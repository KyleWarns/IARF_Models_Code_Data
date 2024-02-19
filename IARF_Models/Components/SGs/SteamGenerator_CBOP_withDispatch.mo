within IARF_Models.Components.SGs;
model SteamGenerator_CBOP_withDispatch
  "Base SG model, flipped so tubes are on BOP side, with simple BOP model used for steam dispatch"
replaceable package Medium =
      TRANSFORM.Media.Fluids.Sodium.ConstantPropertyLiquidSodium
    "Intermediate heat system medium" annotation(choicesAllMatching=true);
 replaceable package Medium_Ambient =
      Modelica.Media.Air.DryAirNasa
    "Ambient medium" annotation(choicesAllMatching=true);
 Modelica.Units.SI.SpecificHeatCapacity c_sodium = 1280;
 Modelica.Units.SI.SpecificHeatCapacity c_air = 1000;
 Modelica.Units.SI.Power Q_AHX_Shell = (AHX.shell.state_b.T - AHX.shell.state_a.T)*AHX.shell.port_a.m_flow*c_sodium "Power Estimate in AHX Shell Side";
 Modelica.Units.SI.Power Q_AHX_Tube = (AHX.tube.state_b.T - AHX.tube.state_a.T)*AHX.tube.port_a.m_flow*c_air "Power Estimate in AHX Shell Side";
 package Medium_BOP = Modelica.Media.Water.StandardWater "BOP working fluid";

 parameter Modelica.Units.SI.Temperature T_AHX_shell_inlet;
 parameter Modelica.Units.SI.Temperature T_AHX_shell_outlet;
 parameter Modelica.Units.SI.MassFlowRate m_flow_AHX_shell;

  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance_toAHX(
      redeclare package Medium = Medium, R=50)
    annotation (Placement(transformation(extent={{-28,16},{-8,36}})));

  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_a(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-30},{-90,-10}}),
        iconTransformation(extent={{-110,-30},{-90,-10}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_b(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}}),
        iconTransformation(extent={{-110,-70},{-90,-50}})));
  TRANSFORM.HeatExchangers.GenericDistributed_HX AHX(
    redeclare package Material_tubeWall = TRANSFORM.Media.Solids.SS304,
    redeclare package Medium_tube = Medium_BOP,
    use_Ts_start_shell=true,
    T_a_start_shell=T_AHX_shell_inlet,
    T_b_start_shell=T_AHX_shell_outlet,
    p_b_start_tube=BOP.p_turbineInlet,
    use_Ts_start_tube=false,
    h_a_start_tube=BOP.h_FW_PumpOutlet,
    h_b_start_tube=BOP.h_turbineInlet,
    m_flow_a_start_tube=BOP.m_flow,
    m_flow_a_start_shell=m_flow_AHX_shell,
    redeclare package Medium_shell = Medium,
    useLumpedPressure_shell=true,
    useLumpedPressure_tube=true,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        nR=3,
        D_o_shell=2,
        nTubes=1000,
        length_shell=2.5168,
        dimension_tube=data.D_tube_inner_AHX,
        length_tube=9.9,
        th_wall=data.th_tubewall_AHX,
        surfaceArea_shell={data.surfaceArea_finnedTube},
        nV=2,
        angle_shell=1.5707963267949),
    redeclare model HeatTransfer_shell =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Ideal,
    redeclare model HeatTransfer_tube =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Ideal,
    p_a_start_shell=250000,
    p_a_start_tube=BOP.p_turbineInlet)
                           annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={0,-20})));

  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipe_fromAHX(
    T_a_start=T_AHX_shell_outlet,
    redeclare package Medium = Medium,
    m_flow_a_start=m_flow_AHX_shell,
    p_a_start=200000,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=data.D_pipes_IHTStofromHXs, length=0.5*data.length_pipes_IHTStofromHXs))
    annotation (Placement(transformation(extent={{-20,-70},{-40,-50}})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume(
    redeclare package Medium = Medium_BOP,
    p_start=BOP.p_turbineInlet,
    use_T_start=false,
    h_start=BOP.h_turbineInlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.0001),
    nPorts_a=1,
    nPorts_b=1) annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  IARF_Models.SystemModels.SFR_SteamDispatchSystem.Data.SFR_PHS data
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  IARF_Models.Components.BOPs.BOP_withDispatch BOP(
      p_otherProcess=3200000)
    annotation (Placement(transformation(extent={{50,-26},{70,-6}})));
equation
  connect(resistance_toAHX.port_a, port_a) annotation (Line(points={{-25,26},{-62,
          26},{-62,-20},{-100,-20}},
                                   color={0,127,255}));
  connect(pipe_fromAHX.port_b, port_b)
    annotation (Line(points={{-40,-60},{-100,-60}}, color={0,127,255}));
  connect(resistance_toAHX.port_b, AHX.port_a_shell)
    annotation (Line(points={{-11,26},{-4.6,26},{-4.6,-10}}, color={0,127,255}));
  connect(AHX.port_b_shell, pipe_fromAHX.port_a) annotation (Line(points={{-4.6,-30},
          {-4,-30},{-4,-60},{-20,-60}}, color={0,127,255}));
  connect(AHX.port_b_tube, volume.port_a[1])
    annotation (Line(points={{0,-10},{0,0},{14,0}}, color={0,127,255}));
  connect(volume.port_b[1], BOP.steam_Inlet)
    annotation (Line(points={{26,0},{38,0},{38,-12},{50,-12}}, color={0,127,255}));
  connect(BOP.FW_outlet, AHX.port_a_tube) annotation (Line(points={{50,-20},{38,-20},
          {38,-40},{0,-40},{0,-30}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Dash),
        Polygon(
          points={{0,30},{-44,10},{44,10},{0,30}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,10},{40,-80}},
          lineColor={0,0,0},
          fillColor={19,216,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,-44},{60,-52},{70,-52},{70,-68},{60,-68},{40,-74},{40,-44}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{74,-72},{70,-80},{90,-80},{86,-72},{74,-72}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{94,-46},{66,-74}},
          lineColor={0,0,0},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-20},{20,-20},{-18,-40}}, color={238,46,47}),
        Line(points={{-18,-40},{18,-60},{-90,-60}}, color={28,108,200}),
        Text(
          extent={{-149,144},{151,104}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName))}),               Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=10, __Dymola_Algorithm="Esdirk45a"));
end SteamGenerator_CBOP_withDispatch;
