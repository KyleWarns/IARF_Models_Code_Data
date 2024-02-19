within IARF_Models.Components.BOPs;
model BOP_Full "BOP model for connection to AHX"
  package Medium_BOP = Modelica.Media.Water.StandardWater "Working fluid";
  parameter Modelica.Units.SI.Pressure p_turbine_inlet_s1=3.5e6 "Turbine Stage 1 Inlet Pressure";
  parameter Modelica.Units.SI.Pressure p_turbine_outlet_s1=0.5126e6 "Turbine Stage 1 Outlet Pressure";
  parameter Modelica.Units.SI.Pressure p_turbine_outlet_s2=0.2482e6 "Turbine Stage 2 Outlet Pressure";
  parameter Modelica.Units.SI.Pressure p_turbine_outlet_s3=0.062e6 "Turbine Stage 3 Outlet Pressure";
  parameter Modelica.Units.SI.Pressure p_turbine_outlet_s4=0.0081e6 "Turbine Stage 4 Outlet Pressure";
  parameter Modelica.Units.SI.Temperature T_turbine_inlet_s1=303.7+273.15 "HP Turbine Stage 1 Inlet Temperature";
  parameter Modelica.Units.SI.Temperature T_turbine_outlet_s1=152.8+273.15 "HP Turbine Stage 1 Outlet Temperature";
  parameter Modelica.Units.SI.Temperature T_turbine_outlet_s2=127.2+273.15 "HP Turbine Stage 2 Outlet Temperature";
  parameter Modelica.Units.SI.Temperature T_turbine_outlet_s3=86.8+273.15 "LP Turbine Stage 2 Outlet Temperature";
  parameter Modelica.Units.SI.Temperature T_turbine_outlet_s4=41.7+273.15 "LP Turbine Stage 3 Outlet Temperature";
  parameter Modelica.Units.SI.Temperature T_LP_FWH2_outlet=82.3+273.15 "LP FWH 2 Outlet Temperature";
  parameter Modelica.Units.SI.Temperature T_LP_FWH1_outlet=123.7+273.15 "LP FWH 1 Outlet Temperature";
  parameter Modelica.Units.SI.Temperature T_HP_FWH_outlet=148.9+273.15 "HP FWH Outlet Temperature";
  parameter Modelica.Units.SI.MassFlowRate m_flow_turbine_s1=67.1 "HP Turbine Stage 1 Mass Flow";
  parameter Modelica.Units.SI.MassFlowRate m_flow_turbine_s2=63.5 "HP Turbine Stage 2 Mass Flow";
  parameter Modelica.Units.SI.MassFlowRate m_flow_turbine_s3=58.45 "LP Turbine Stage 2 Mass Flow";
  parameter Modelica.Units.SI.MassFlowRate m_flow_turbine_s4=53.46 "LP Turbine Stage 3 Mass Flow";
  parameter Modelica.Units.SI.MassFlowRate m_flow_condensate_pump=67.1 "Condensate Pump Mass Flow";
  parameter Modelica.Units.SI.MassFlowRate m_flow_FW_pump=67.1 "Feedwater Pump Mass Flow";
  parameter Modelica.Units.SI.MassFlowRate m_flow_HP_FWH=3.6 "Mass Flow to HP FWH from HP Turbine";
  parameter Modelica.Units.SI.MassFlowRate m_flow_LP_FWH1=8.65 "Mass Flow to LP FWH 1 from LP Turbine Stage 1";
  parameter Modelica.Units.SI.MassFlowRate m_flow_LP_FWH2=13.64 "Mass Flow to LP FWH 2 from LP Turbine Stage 2";
  parameter Modelica.Units.SI.SpecificEnthalpy h_turbine_inlet_s1=2999.39e3 "HP Turbine Stage 1 Inlet Enthalpy";
  parameter Modelica.Units.SI.SpecificEnthalpy h_turbine_outlet_s1=2673.75e3 "HP Turbine Stage 1 Outlet Enthalpy";
  parameter Modelica.Units.SI.SpecificEnthalpy h_turbine_outlet_s2=2563.03e3 "HP Turbine Stage 2 Outlet Enthalpy";
  parameter Modelica.Units.SI.SpecificEnthalpy h_turbine_outlet_s3=2401.84e3 "LP Turbine Stage 2 Outlet Enthalpy";
  parameter Modelica.Units.SI.SpecificEnthalpy h_turbine_outlet_s4=2260.18e3 "LP Turbine Stage 3 Outlet Enthalpy";
  parameter Modelica.Units.SI.SpecificEnthalpy h_condenser_outlet=138.1e3 "Condenser Outlet Enthalpy";
  parameter Modelica.Units.SI.SpecificEnthalpy h_LP_FWH2_shell_outlet=302.38e3 "LP FWH2 Shell Outlet Enthalpy";
  parameter Modelica.Units.SI.SpecificEnthalpy h_LP_FWH1_shell_outlet=368.21e3 "LP FWH1 Shell Outlet Enthalpy";
  parameter Modelica.Units.SI.SpecificEnthalpy h_HP_FWH_shell_outlet=544.52e3 "HP FWH Shell Outlet Enthalpy";
  TRANSFORM.Fluid.Machines.SteamTurbine Turbine_s1(
    redeclare package Medium = Medium_BOP,
    p_a_start=p_turbine_inlet_s1,
    p_b_start=p_turbine_outlet_s1,
    use_T_start=false,
    h_a_start=h_turbine_inlet_s1,
    h_b_start=h_turbine_outlet_s1,
    m_flow_start=m_flow_turbine_s1,
    use_Stodola=true,
    use_T_nominal=false,
    d_nominal=Medium_BOP.density_ph(p_turbine_inlet_s1, h_turbine_inlet_s1))
                      annotation (Placement(transformation(extent={{-118,64},{-98,44}})));
  TRANSFORM.Electrical.PowerConverters.Generator generator
    annotation (Placement(transformation(extent={{-8,-8},{8,8}},
        rotation=90,
        origin={208,64})));
  TRANSFORM.Electrical.Sources.FrequencySource boundary annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={208,88})));
  TRANSFORM.Fluid.Volumes.IdealCondenser condenser(redeclare package Medium =
        Medium_BOP,
    p=p_turbine_outlet_s4,
    V_total=20,
    V_liquid_start=5)
    annotation (Placement(transformation(extent={{184,20},{204,40}})));
  inner TRANSFORM.Fluid.System system
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  TRANSFORM.HeatExchangers.GenericDistributed_HX HP_FWH1(
    nParallel=1,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        D_o_shell=1.04,
        nV=2,
        nTubes=66,
        nR=3,
        length_shell=2.5168,
        surfaceArea_shell={80.5409},
        angle_shell=0,
        dimension_tube=0.014122,
        length_tube=9.9,
        th_wall=0.889e-3),
    redeclare package Medium_shell = Medium_BOP,
    redeclare package Medium_tube = Medium_BOP,
    redeclare package Material_tubeWall = TRANSFORM.Media.Solids.SS304,
    p_a_start_shell=p_turbine_outlet_s1,
    p_b_start_shell=p_turbine_outlet_s1,
    use_Ts_start_shell=false,
    h_a_start_shell=h_turbine_outlet_s1,
    h_b_start_shell=h_HP_FWH_shell_outlet,
    m_flow_a_start_shell=m_flow_HP_FWH,
    p_a_start_tube=p_turbine_inlet_s1,
    p_b_start_tube=p_turbine_inlet_s1,
    use_Ts_start_tube=true,
    T_a_start_tube=T_LP_FWH1_outlet,
    T_b_start_tube=T_HP_FWH_outlet,
    m_flow_a_start_tube=m_flow_FW_pump,
    adiabaticDims={false,false})
                                annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-76,-40})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance(
      redeclare package Medium = Medium_BOP,
    showName=false,
    R=1)
    annotation (Placement(transformation(extent={{-7,-7},{7,7}},
        rotation=270,
        origin={-3,13})));
  TRANSFORM.Fluid.Volumes.MixingVolume v1(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_inlet_s1,
    use_T_start=false,
    h_start=h_turbine_inlet_s1,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    use_HeatPort=false,
    showName=false,
    nPorts_b=1,
    nPorts_a=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-132,48})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance2(redeclare
      package Medium = Medium_BOP,
    showName=false,
    R=1)
    annotation (Placement(transformation(extent={{-7,-7},{7,7}},
        rotation=270,
        origin={-81,-1})));
  TRANSFORM.Fluid.Volumes.MixingVolume v2(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_outlet_s3,
    use_T_start=false,
    h_start=h_turbine_outlet_s3,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    use_HeatPort=false,
    showName=false,
    nPorts_a=2,
    nPorts_b=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={118,-14})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance3(
      redeclare package Medium = Medium_BOP,
    showName=false,
    R=1)
    annotation (Placement(transformation(extent={{-7,-7},{7,7}},
        rotation=0,
        origin={133,-19})));
  TRANSFORM.Fluid.Machines.SteamTurbine Turbine_s2(
    redeclare package Medium = Medium_BOP,
    p_a_start=p_turbine_outlet_s1,
    p_b_start=p_turbine_outlet_s2,
    use_T_start=false,
    h_a_start=h_turbine_outlet_s1,
    h_b_start=h_turbine_outlet_s2,
    m_flow_start=m_flow_turbine_s2,
    use_Stodola=true,
    use_T_nominal=false,
    d_nominal=Medium_BOP.density_ph(p_turbine_outlet_s1, h_turbine_outlet_s1))
                      annotation (Placement(transformation(extent={{-48,64},{-28,44}})));
  TRANSFORM.Fluid.Volumes.MixingVolume v6(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_outlet_s1,
    use_T_start=false,
    h_start=h_turbine_outlet_s1,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    use_HeatPort=false,
    showName=false,
    nPorts_a=1,
    nPorts_b=2) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-84,48})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume8(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_outlet_s1,
    use_T_start=false,
    h_start=h_HP_FWH_shell_outlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.1),
    use_HeatPort=false,
    showName=false,
    nPorts_b=1,
    nPorts_a=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-46,-26})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance8(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=5e4)
    annotation (Placement(transformation(extent={{-7,-7},{7,7}},
        rotation=0,
        origin={-29,-25})));
  TRANSFORM.Fluid.Machines.SteamTurbine Turbine_s3(
    redeclare package Medium = Medium_BOP,
    p_a_start=p_turbine_outlet_s2,
    p_b_start=p_turbine_outlet_s3,
    use_T_start=false,
    h_a_start=h_turbine_outlet_s2,
    h_b_start=h_turbine_outlet_s3,
    m_flow_start=m_flow_turbine_s3,
    use_Stodola=true,
    use_T_nominal=false,
    d_nominal=Medium_BOP.density_ph(p_turbine_outlet_s2, h_turbine_outlet_s2))
                      annotation (Placement(transformation(extent={{18,64},{38,44}})));
  TRANSFORM.Fluid.Machines.SteamTurbine Turbine_s4(
    redeclare package Medium = Medium_BOP,
    p_a_start=p_turbine_outlet_s3,
    p_b_start=p_turbine_outlet_s4,
    use_T_start=false,
    h_a_start=h_turbine_outlet_s3,
    h_b_start=h_turbine_outlet_s4,
    m_flow_start=m_flow_turbine_s4,
    use_Stodola=true,
    use_T_nominal=false,
    d_nominal=Medium_BOP.density_ph(p_turbine_outlet_s3, h_turbine_outlet_s3))
                      annotation (Placement(transformation(extent={{86,64},{106,44}})));
  TRANSFORM.Fluid.Volumes.MixingVolume v4(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_outlet_s2,
    use_T_start=false,
    h_start=h_turbine_outlet_s2,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    use_HeatPort=false,
    showName=false,
    nPorts_b=2,
    nPorts_a=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-8,48})));
  TRANSFORM.Fluid.Volumes.MixingVolume v7(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_outlet_s3,
    use_T_start=false,
    h_start=h_turbine_outlet_s3,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    use_HeatPort=false,
    showName=false,
    nPorts_b=2,
    nPorts_a=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={64,48})));
  TRANSFORM.HeatExchangers.GenericDistributed_HX LP_FWH1(
    nParallel=1,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        D_o_shell=1.04,
        nV=2,
        nTubes=66,
        nR=3,
        length_shell=2.5168,
        surfaceArea_shell={80.5409},
        angle_shell=0,
        dimension_tube=0.014122,
        length_tube=9.9,
        th_wall=0.889e-3),
    redeclare package Medium_shell = Medium_BOP,
    redeclare package Medium_tube = Medium_BOP,
    redeclare package Material_tubeWall = TRANSFORM.Media.Solids.SS304,
    p_a_start_shell=p_turbine_outlet_s2,
    p_b_start_shell=p_turbine_outlet_s2,
    use_Ts_start_shell=false,
    h_a_start_shell=h_turbine_outlet_s2,
    h_b_start_shell=h_LP_FWH1_shell_outlet,
    m_flow_a_start_shell=m_flow_LP_FWH1,
    p_a_start_tube=p_turbine_inlet_s1,
    p_b_start_tube=p_turbine_inlet_s1,
    use_Ts_start_tube=true,
    T_a_start_tube=T_LP_FWH2_outlet,
    T_b_start_tube=T_LP_FWH1_outlet,
    m_flow_a_start_tube=m_flow_condensate_pump)
                                annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={56,-32})));
  TRANSFORM.HeatExchangers.GenericDistributed_HX LP_FWH2(
    nParallel=1,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        D_o_shell=1.04,
        nV=2,
        nTubes=66,
        nR=3,
        length_shell=2.5168,
        surfaceArea_shell={80.5409},
        angle_shell=0,
        dimension_tube=0.014122,
        length_tube=9.9,
        th_wall=0.889e-3),
    redeclare package Medium_shell = Medium_BOP,
    redeclare package Medium_tube = Medium_BOP,
    redeclare package Material_tubeWall = TRANSFORM.Media.Solids.SS304,
    p_a_start_shell=p_turbine_outlet_s3,
    p_b_start_shell=p_turbine_outlet_s3,
    use_Ts_start_shell=false,
    h_a_start_shell=h_turbine_outlet_s3,
    h_b_start_shell=h_LP_FWH2_shell_outlet,
    m_flow_a_start_shell=m_flow_LP_FWH2,
    p_a_start_tube=p_turbine_inlet_s1,
    p_b_start_tube=p_turbine_inlet_s1,
    use_Ts_start_tube=true,
    T_a_start_tube=T_turbine_outlet_s4,
    T_b_start_tube=T_LP_FWH2_outlet,
    m_flow_a_start_tube=m_flow_condensate_pump)
                                annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={160,-32})));
  TRANSFORM.Fluid.Volumes.MixingVolume v8(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_outlet_s4,
    use_T_start=false,
    h_start=h_LP_FWH2_shell_outlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=1),
    use_HeatPort=false,
    showName=false,
    nPorts_a=1,
    nPorts_b=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={176,-12})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance4(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=2e3)
    annotation (Placement(transformation(extent={{-7,-7},{7,7}},
        rotation=90,
        origin={177,3})));
  TRANSFORM.Fluid.Volumes.MixingVolume v9(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_inlet_s1,
    use_T_start=true,
    T_start=T_LP_FWH1_outlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=1),
    use_HeatPort=false,
    showName=false,
    nPorts_a=1,
    nPorts_b=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={34,-68})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance7(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1)
    annotation (Placement(transformation(extent={{-7,-7},{7,7}},
        rotation=270,
        origin={93,21})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume1(
    redeclare package Medium = Medium_BOP,
    p_start(displayUnit="Pa") = p_turbine_inlet_s1 + 0.3e6,
    use_T_start=true,
    T_start=T_LP_FWH1_outlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=5),
    use_HeatPort=false,
    showName=false,
    nPorts_a=1,
    nPorts_b=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={-22,-68})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance10(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1)
    annotation (Placement(transformation(extent={{-7,-7},{7,7}},
        rotation=180,
        origin={-39,-69})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance11(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1)
    annotation (Placement(transformation(extent={{-7,-7},{7,7}},
        rotation=180,
        origin={183,-33})));
  TRANSFORM.Fluid.Volumes.MixingVolume v3(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_outlet_s4,
    use_T_start=false,
    h_start=h_turbine_outlet_s4,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    use_HeatPort=false,
    showName=false,
    nPorts_a=1,
    nPorts_b=2) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={138,48})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance12(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1)
    annotation (Placement(transformation(extent={{-7,-7},{7,7}},
        rotation=0,
        origin={169,47})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance14(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1)
    annotation (Placement(transformation(extent={{-7,-7},{7,7}},
        rotation=0,
        origin={-157,47})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume2(
    redeclare package Medium = Medium_BOP,
    p_start(displayUnit="Pa") = p_turbine_inlet_s1,
    use_T_start=true,
    T_start=T_HP_FWH_outlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    use_HeatPort=false,
    showName=false,
    nPorts_b=1,
    nPorts_a=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={-108,-40})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance15(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1)
    annotation (Placement(transformation(extent={{-7,-7},{7,7}},
        rotation=180,
        origin={-129,-39})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance17(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1)
    annotation (Placement(transformation(extent={{-7,-7},{7,7}},
        rotation=270,
        origin={201,7})));
  TRANSFORM.Fluid.Volumes.MixingVolume v11(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_outlet_s4,
    use_T_start=true,
    T_start=T_turbine_outlet_s4,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    use_HeatPort=false,
    showName=false,
    nPorts_b=1,
    nPorts_a=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={202,-14})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow FW_pump(redeclare package Medium = Medium_BOP,
    use_input=false,                                                                          m_flow_nominal=m_flow_FW_pump)
    annotation (Placement(transformation(extent={{10,-78},{-10,-58}})));

  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow Condensate_pump(redeclare package
      Medium =                                                                            Medium_BOP, m_flow_nominal=
        m_flow_condensate_pump) annotation (Placement(transformation(extent={{216,-68},{196,-48}})));
  TRANSFORM.Fluid.Volumes.MixingVolume v12(
    redeclare package Medium = Medium_BOP,
    p_start(displayUnit="Pa") = p_turbine_inlet_s1,
    use_T_start=true,
    T_start=T_turbine_outlet_s4,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=5),
    use_HeatPort=false,
    showName=false,
    nPorts_a=1,
    nPorts_b=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={194,-44})));
  TRANSFORM.Fluid.Volumes.MixingVolume v13(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_outlet_s2,
    use_T_start=false,
    h_start=h_LP_FWH1_shell_outlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=1),
    use_HeatPort=false,
    showName=false,
    nPorts_a=1,
    nPorts_b=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={80,-18})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance16(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1e4)
    annotation (Placement(transformation(extent={{-7,-7},{7,7}},
        rotation=0,
        origin={99,-11})));
  TRANSFORM.Fluid.Volumes.MixingVolume v17(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_outlet_s2,
    use_T_start=false,
    h_start=h_turbine_outlet_s2,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    use_HeatPort=false,
    showName=false,
    nPorts_a=2,
    nPorts_b=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={0,-16})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance18(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1)
    annotation (Placement(transformation(extent={{-7,-7},{7,7}},
        rotation=0,
        origin={21,-21})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow from_SG(redeclare package Medium =
        Medium_BOP)
    annotation (Placement(transformation(extent={{-190,38},{-170,58}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow to_SG(redeclare package Medium =
        Medium_BOP)
    annotation (Placement(transformation(extent={{-190,-50},{-170,-30}})));
equation
  connect(Turbine_s3.shaft_b, Turbine_s4.shaft_a) annotation (Line(points={{38,54},{86,54}}, color={0,0,0}));
  connect(Turbine_s1.shaft_b, Turbine_s2.shaft_a) annotation (Line(points={{-98,54},{-48,54}}, color={0,0,0}));
  connect(v1.port_b[1], Turbine_s1.portHP) annotation (Line(points={{-128.4,48},{-118,48}}, color={0,127,255}));
  connect(v6.port_a[1], Turbine_s1.portLP) annotation (Line(points={{-87.6,48},{-98,48}}, color={0,127,255}));
  connect(v6.port_b[1], Turbine_s2.portHP) annotation (Line(points={{-80.4,47.85},{
          -74,47.85},{-74,48},{-48,48}},                                                                        color={0,127,255}));
  connect(resistance8.port_a, volume8.port_b[1])
    annotation (Line(points={{-33.9,-25},{-36,-25},{-36,-26},{-42.4,-26}}, color={0,127,255}));
  connect(HP_FWH1.port_b_shell, volume8.port_a[1])
    annotation (Line(points={{-66,-35.4},{-58,-35.4},{-58,-26},{-49.6,-26}}, color={0,127,255}));
  connect(Turbine_s3.portHP, v4.port_b[1]) annotation (Line(points={{18,48},{6,48},{
          6,47.85},{-4.4,47.85}},                                                                         color={0,127,255}));
  connect(generator.port, boundary.port) annotation (Line(points={{208,72},{208,82}}, color={255,0,0}));
  connect(Turbine_s4.shaft_b, generator.shaft) annotation (Line(points={{106,54},{202,54},{202,56},{208,56}}, color={0,0,0}));
  connect(Turbine_s4.portHP, v7.port_b[1]) annotation (Line(points={{86,48},{86,
          47.85},{67.6,47.85}},                                                                     color={0,127,255}));
  connect(Turbine_s3.portLP, v7.port_a[1]) annotation (Line(points={{38,48},{60.4,48}}, color={0,127,255}));
  connect(LP_FWH1.port_a_tube, LP_FWH2.port_b_tube) annotation (Line(points={{66,-32},{150,-32}},  color={0,127,255}));
  connect(LP_FWH2.port_b_shell, v8.port_a[1]) annotation (Line(points={{170,-27.4},{176,-27.4},{176,-15.6}}, color={0,127,255}));
  connect(v8.port_b[1], resistance4.port_a) annotation (Line(points={{176,-8.4},{176,-1.9},{177,-1.9}}, color={0,127,255}));
  connect(LP_FWH2.port_a_tube, resistance11.port_b)
    annotation (Line(points={{170,-32},{176,-32},{176,-33},{178.1,-33}}, color={0,127,255}));
  connect(volume2.port_b[1], resistance15.port_a) annotation (Line(points={{-111.6,
          -40},{-114,-40},{-114,-39},{-124.1,-39}},        color={0,127,255}));
  connect(v11.port_b[1], Condensate_pump.port_a) annotation (Line(points={{202,-17.6},{216,-17.6},{216,-58}}, color={0,127,255}));
  connect(Condensate_pump.port_b, v12.port_a[1]) annotation (Line(points={{196,-58},{196,-47.6},{194,-47.6}}, color={0,127,255}));
  connect(v12.port_b[1], resistance11.port_a)
    annotation (Line(points={{194,-40.4},{192,-40.4},{192,-33},{187.9,-33}}, color={0,127,255}));
  connect(resistance2.port_a, v6.port_b[2]) annotation (Line(points={{-81,3.9},{-81,
          40},{-76,40},{-76,48.15},{-80.4,48.15}},
                                                 color={0,127,255}));
  connect(resistance2.port_b, HP_FWH1.port_a_shell) annotation (Line(points={{-81,-5.9},
          {-81,-16},{-100,-16},{-100,-35.4},{-86,-35.4}}, color={0,127,255}));
  connect(volume2.port_a[1], HP_FWH1.port_b_tube)
    annotation (Line(points={{-104.4,-40},{-86,-40}}, color={0,127,255}));
  connect(Turbine_s2.portLP, v4.port_a[1]) annotation (Line(points={{-28,48},{-11.6,48}}, color={0,127,255}));
  connect(Turbine_s2.shaft_b, Turbine_s3.shaft_a) annotation (Line(points={{-28,54},{18,54}}, color={0,0,0}));
  connect(v9.port_a[1], LP_FWH1.port_b_tube) annotation (Line(points={{37.6,-68},{46,-68},{46,-32}}, color={0,127,255}));
  connect(FW_pump.port_a, v9.port_b[1]) annotation (Line(points={{10,-68},{30.4,-68}}, color={0,127,255}));
  connect(FW_pump.port_b, volume1.port_a[1]) annotation (Line(points={{-10,-68},{-18.4,-68}}, color={0,127,255}));
  connect(resistance10.port_a, volume1.port_b[1])
    annotation (Line(points={{-34.1,-69},{-28.05,-69},{-28.05,-68},{-25.6,-68}}, color={0,127,255}));
  connect(resistance10.port_b, HP_FWH1.port_a_tube)
    annotation (Line(points={{-43.9,-69},{-50,-69},{-50,-40},{-66,-40}}, color={0,127,255}));
  connect(v4.port_b[2], resistance.port_a) annotation (Line(points={{-4.4,48.15},{-4,
          48.15},{-4,17.9},{-3,17.9}},                                                                          color={0,127,255}));
  connect(resistance.port_b, v17.port_a[1])
    annotation (Line(points={{-3,8.1},{-3,-2},{-8,-2},{-8,-12.4},{-0.15,-12.4}},color={0,127,255}));
  connect(resistance8.port_b, v17.port_a[2])
    annotation (Line(points={{-24.1,-25},{-12,-25},{-12,-12.4},{0.15,-12.4}},color={0,127,255}));
  connect(v17.port_b[1], resistance18.port_a)
    annotation (Line(points={{0,-19.6},{10,-19.6},{10,-21},{16.1,-21}}, color={0,127,255}));
  connect(resistance18.port_b, LP_FWH1.port_a_shell)
    annotation (Line(points={{25.9,-21},{34,-21},{34,-27.4},{46,-27.4}}, color={0,127,255}));
  connect(LP_FWH1.port_b_shell, v13.port_a[1])
    annotation (Line(points={{66,-27.4},{68,-27.4},{68,-28},{70,-28},{70,-18},{76.4,-18}}, color={0,127,255}));
  connect(v13.port_b[1], resistance16.port_a)
    annotation (Line(points={{83.6,-18},{88,-18},{88,-11},{94.1,-11}}, color={0,127,255}));
  connect(resistance16.port_b, v2.port_a[1])
    annotation (Line(points={{103.9,-11},{110.95,-11},{110.95,-10.4},{117.85,-10.4}},color={0,127,255}));
  connect(v7.port_b[2], resistance7.port_a)
    annotation (Line(points={{67.6,48.15},{68,48.15},{68,34},{93,34},{93,25.9}},
                                                                               color={0,127,255}));
  connect(resistance7.port_b, v2.port_a[2]) annotation (Line(points={{93,16.1},{93,8},
          {118.15,8},{118.15,-10.4}},                                                                           color={0,127,255}));
  connect(resistance3.port_b, LP_FWH2.port_a_shell)
    annotation (Line(points={{137.9,-19},{142,-19},{142,-27.4},{150,-27.4}}, color={0,127,255}));
  connect(resistance3.port_a, v2.port_b[1])
    annotation (Line(points={{128.1,-19},{123.05,-19},{123.05,-17.6},{118,-17.6}}, color={0,127,255}));
  connect(Turbine_s4.portLP, v3.port_a[1]) annotation (Line(points={{106,48},{134.4,48}}, color={0,127,255}));
  connect(v3.port_b[1], resistance4.port_b)
    annotation (Line(points={{141.6,47.85},{142,47.85},{142,14},{177,14},{177,7.9}},
                                                                                   color={0,127,255}));
  connect(v3.port_b[2], resistance12.port_a)
    annotation (Line(points={{141.6,48.15},{154,48.15},{154,47},{164.1,47}},
                                                                           color={0,127,255}));
  connect(resistance12.port_b, condenser.port_a) annotation (Line(points={{173.9,47},{187,47},{187,37}}, color={0,127,255}));
  connect(condenser.port_b, resistance17.port_a) annotation (Line(points={{194,22},{194,11.9},{201,11.9}}, color={0,127,255}));
  connect(resistance17.port_b, v11.port_a[1])
    annotation (Line(points={{201,2.1},{201,-3.95},{202,-3.95},{202,-10.4}}, color={0,127,255}));
  connect(resistance14.port_b, v1.port_a[1])
    annotation (Line(points={{-152.1,47},{-135.6,48}}, color={0,127,255}));
  connect(resistance14.port_a, from_SG)
    annotation (Line(points={{-161.9,47},{-180,47},{-180,48}}, color={0,127,255}));
  connect(resistance15.port_b, to_SG) annotation (Line(points={{-133.9,-39},{-180,
          -39},{-180,-40}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(extent={{-180,-100},{220,100}})),
    Icon(coordinateSystem(extent={{-180,-100},{220,100}})),
    experiment(
      StopTime=1000,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Sdirk34hw"));
end BOP_Full;
