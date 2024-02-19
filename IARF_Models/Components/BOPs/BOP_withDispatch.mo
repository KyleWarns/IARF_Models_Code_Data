within IARF_Models.Components.BOPs;
model BOP_withDispatch
  "Simplified version of the BOP model with dispatch capabilities"

  package Medium_BOP = Modelica.Media.Water.StandardWater "Working fluid";

  parameter Real PressureValvePosition = 1.0 "Opening position of pressure control valve";
  parameter Real TurbineValvePosition = 1.0 "Opening position of turbine control valve";
  parameter Real DispatchValvePosition = 0 "Opening position of steam dispatch valve";

  parameter Modelica.Units.SI.Pressure p_turbineInlet = 3.4e6 "Turbine Inlet Pressure";
  parameter Modelica.Units.SI.Pressure p_condensor = 0.0081e6 "Condensor Pressure";
  parameter Modelica.Units.SI.Pressure p_LPFW = 0.25e6 "Condensate Pressure pre-FW Pump";
  parameter Modelica.Units.SI.Pressure p_FW_pump = 3.4e6 "FW Pump Outlet Pressure";
  parameter Modelica.Units.SI.Pressure p_otherProcess = 3.38e6 "Other Process Pressure";
  parameter Modelica.Units.SI.Pressure dp_uponDispatch = 0.001e6 "Increase in condenser pressure upon performing steam dispatch";

  parameter Modelica.Units.SI.PressureDifference dp_FW_pump = 1e5 "Nominal FW Pump Pressure Drop";

  parameter Modelica.Units.SI.Temperature T_LPFW = 100+273.15 "Condensate Temperature pre-FW Pump";
  parameter Modelica.Units.SI.Temperature T_FW = 150+273.15 "FW Temperature";

  parameter Modelica.Units.SI.SpecificEnthalpy h_turbineInlet = 2900e3 "Turbine Inlet Specific Enthalpy";
  parameter Modelica.Units.SI.SpecificEnthalpy h_turbineOutlet = 2200e3 "Turbine Outlet Specific Enthalpy";
  parameter Modelica.Units.SI.SpecificEnthalpy h_FW_PumpOutlet = 1000e3 "FW Pump Outlet Specific Enthalpy";

  parameter Modelica.Units.SI.MassFlowRate m_flow = 67.1 "System Mass Flow Rate";

  parameter Real Condensor_Decrease = 0 "Real valve decrease of condensor pressure ramp function";

  TRANSFORM.Fluid.Machines.SteamTurbine steamTurbine(redeclare package Medium =
        Medium_BOP,
    redeclare model Eta_wetSteam =
        TRANSFORM.Fluid.Machines.BaseClasses.WetSteamEfficiency.eta_Constant (
          eta_nominal=1),
    p_a_start=p_turbineInlet,
    p_b_start=p_condensor,
    use_T_start=false,
    h_a_start=h_turbineInlet,
    h_b_start=h_turbineOutlet,
    m_flow_start=m_flow,
    use_Stodola=true,
    use_T_nominal=false,
    d_nominal=Medium_BOP.density_ph(p_turbineInlet, h_turbineInlet))
                                                     annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={6,46})));
  TRANSFORM.Electrical.PowerConverters.Generator generator
    annotation (Placement(transformation(extent={{-8,-8},{8,8}},
        rotation=0,
        origin={50,68})));
  TRANSFORM.Electrical.Sources.FrequencySource boundary annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={68,68})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT fromCondensor(redeclare package
      Medium = Medium_BOP,
    p=p_LPFW,
    T=T_LPFW,
    nPorts=1)
    annotation (Placement(transformation(extent={{-42,-50},{-62,-30}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_ph toCondensor(redeclare package
      Medium = Medium_BOP,
    use_p_in=true,
    p=p_condensor,
    h=h_turbineOutlet,                                       nPorts=1)
    annotation (Placement(transformation(extent={{60,30},{40,50}})));
  TRANSFORM.Fluid.Volumes.MixingVolume FW_Heating(
    redeclare package Medium = Medium_BOP,
    p_start=p_FW_pump,
    T_start=T_FW,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    use_HeatPort=true,
    nPorts_b=1,
    nPorts_a=1) annotation (Placement(transformation(extent={{-108,-50},{-128,-30}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance(redeclare
      package Medium = Medium_BOP, R=1)
    annotation (Placement(transformation(extent={{-154,-50},{-134,-30}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow FW_outlet(redeclare package Medium =
        Medium_BOP)
    annotation (Placement(transformation(extent={{-190,-50},{-170,-30}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow steam_Inlet(redeclare package Medium =
        Medium_BOP)
    annotation (Placement(transformation(extent={{-190,30},{-170,50}})));
  TRANSFORM.Fluid.Valves.ValveLinear PressureControlValve(redeclare package Medium =
        Medium_BOP,
    dp_nominal(displayUnit="bar") = 10000,
    m_flow_nominal=m_flow)
    annotation (Placement(transformation(extent={{-122,30},{-102,50}})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbineInlet,
    use_T_start=false,
    h_start=h_turbineInlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    use_HeatPort=true,
    nPorts_b=1,
    nPorts_a=1)
    annotation (Placement(transformation(extent={{-152,30},{-132,50}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature FW_Heater(T=T_FW)
    annotation (Placement(transformation(extent={{-86,-70},{-106,-50}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature Superheater(use_port=
        false, T=523.15)
    annotation (Placement(transformation(extent={{-170,12},{-150,32}})));
  TRANSFORM.Fluid.Valves.ValveLinear SteamDispatchValve(
    redeclare package Medium = Medium_BOP,
    dp_nominal(displayUnit="Pa") = 10,
    m_flow_nominal=m_flow*0.15)
                           annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={0,4})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_ph toOtherProcess(
    redeclare package Medium = Medium_BOP,
    use_p_in=true,
    p=p_otherProcess,
    h=h_turbineInlet,
    nPorts=1) annotation (Placement(transformation(extent={{54,-6},{34,14}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=DispatchValvePosition,
    duration=10,
    offset=0,
    startTime=500) annotation (Placement(transformation(extent={{-38,-22},{-18,-2}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=p_otherProcess)
    annotation (Placement(transformation(extent={{88,2},{68,22}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    height=PressureValvePosition - 1,
    duration=10,
    offset=1,
    startTime=500) annotation (Placement(transformation(extent={{-76,60},{-96,80}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    height=Condensor_Decrease,
    duration=10,
    offset=p_condensor,
    startTime=500) annotation (Placement(transformation(extent={{98,38},{78,58}})));
  TRANSFORM.Fluid.Valves.ValveLinear TurbineControlValve(
    redeclare package Medium = Medium_BOP,
    dp_nominal(displayUnit="bar") = 100000,
    m_flow_nominal=m_flow) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-46,40})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume2(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbineInlet,
    use_T_start=false,
    h_start=h_turbineInlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    use_HeatPort=false,
    nPorts_b=1,
    nPorts_a=1)
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Modelica.Blocks.Sources.Ramp ramp3(
    height=TurbineValvePosition - 1,
    duration=10,
    offset=1,
    startTime=500) annotation (Placement(transformation(extent={{-14,58},{-34,78}})));
  TRANSFORM.Fluid.FittingsAndResistances.TeeJunctionVolume tee(
    redeclare package Medium = Medium_BOP,
    V=0.1,
    p_start=p_turbineInlet,
    use_T_start=false,
    h_start=h_turbineInlet) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-78,40})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump(redeclare package Medium =
        Medium_BOP, m_flow_nominal=m_flow)
    annotation (Placement(transformation(extent={{-72,-50},{-92,-30}})));
equation
  connect(steamTurbine.shaft_b, generator.shaft)
    annotation (Line(points={{16,46},{30,46},{30,68},{42,68}}, color={0,0,0}));
  connect(generator.port, boundary.port)
    annotation (Line(points={{58,68},{62,68}}, color={255,0,0}));
  connect(steamTurbine.portLP, toCondensor.ports[1])
    annotation (Line(points={{16,40},{40,40}}, color={0,127,255}));
  connect(resistance.port_b, FW_Heating.port_b[1])
    annotation (Line(points={{-137,-40},{-124,-40}},
                                                   color={0,127,255}));
  connect(FW_outlet, resistance.port_a)
    annotation (Line(points={{-180,-40},{-151,-40}},color={0,127,255}));
  connect(FW_Heater.port, FW_Heating.heatPort)
    annotation (Line(points={{-106,-60},{-118,-60},{-118,-46}},
                                                             color={191,0,0}));
  connect(volume.port_b[1], PressureControlValve.port_a)
    annotation (Line(points={{-136,40},{-122,40}},
                                                 color={0,127,255}));
  connect(volume.port_a[1], steam_Inlet)
    annotation (Line(points={{-148,40},{-180,40}},color={0,127,255}));
  connect(SteamDispatchValve.port_b, toOtherProcess.ports[1])
    annotation (Line(points={{10,4},{34,4}},   color={0,127,255}));
  connect(ramp.y, SteamDispatchValve.opening)
    annotation (Line(points={{-17,-12},{0,-12},{0,-4}},  color={0,0,127}));
  connect(realExpression1.y, toOtherProcess.p_in)
    annotation (Line(points={{67,12},{56,12}}, color={0,0,127}));
  connect(ramp2.y, toCondensor.p_in)
    annotation (Line(points={{77,48},{62,48}}, color={0,0,127}));
  connect(steam_Inlet, steam_Inlet)
    annotation (Line(points={{-180,40},{-180,40}}, color={0,127,255}));
  connect(ramp1.y, PressureControlValve.opening) annotation (Line(points={{-97,70},{
          -112,70},{-112,48}},             color={0,0,127}));
  connect(Superheater.port, volume.heatPort)
    annotation (Line(points={{-150,22},{-142,22},{-142,34}},
                                                          color={191,0,0}));
  connect(volume2.port_b[1], steamTurbine.portHP)
    annotation (Line(points={{-14,40},{-4,40}}, color={0,127,255}));
  connect(tee.port_3, SteamDispatchValve.port_a)
    annotation (Line(points={{-78,30},{-78,4},{-10,4}}, color={0,127,255}));
  connect(pump.port_a, fromCondensor.ports[1])
    annotation (Line(points={{-72,-40},{-62,-40}}, color={0,127,255}));
  connect(pump.port_b, FW_Heating.port_a[1])
    annotation (Line(points={{-92,-40},{-112,-40}}, color={0,127,255}));
  connect(tee.port_2, TurbineControlValve.port_a)
    annotation (Line(points={{-68,40},{-56,40}}, color={0,127,255}));
  connect(TurbineControlValve.port_b, volume2.port_a[1])
    annotation (Line(points={{-36,40},{-26,40}}, color={0,127,255}));
  connect(ramp3.y, TurbineControlValve.opening)
    annotation (Line(points={{-35,68},{-46,68},{-46,48}}, color={0,0,127}));
  connect(PressureControlValve.port_b, tee.port_1)
    annotation (Line(points={{-102,40},{-88,40}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,-100},{
            100,100}})),                                         Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-100},{100,100}})));
end BOP_withDispatch;
