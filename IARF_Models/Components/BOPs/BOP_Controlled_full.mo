within IARF_Models.Components.BOPs;
model BOP_Controlled_full
  package Medium_BOP = Modelica.Media.Water.StandardWater "Working fluid";
  // Pressures
  parameter Modelica.Units.SI.Pressure p_FW_pump_outlet = 3.501e6;
  parameter Modelica.Units.SI.Pressure p_HP_FWH_tube_outlet = 3.5001e6;
  parameter Modelica.Units.SI.Pressure p_LP_FWH2_tube_outlet = 0.139e6;
  parameter Modelica.Units.SI.Pressure p_LP_FWH1_tube_outlet = 0.496e6;
  parameter Modelica.Units.SI.Pressure p_LP_FWH1_tube_inlet = 0.853e6;

  parameter Modelica.Units.SI.Pressure p_Boiler = 3.50007e6;
  parameter Modelica.Units.SI.Pressure p_turbine_s1_inlet = 3.5e6;
  parameter Modelica.Units.SI.Pressure p_turbine_s1_outlet = 0.512e6;
  parameter Modelica.Units.SI.Pressure p_turbine_s2_outlet = 0.2484e6;
  parameter Modelica.Units.SI.Pressure p_turbine_s3_outlet = 0.062e6;
  parameter Modelica.Units.SI.Pressure p_turbine_s4_outlet = 0.0081e6;

  parameter Modelica.Units.SI.Pressure p_condenser = 0.0081e6;
  parameter Modelica.Units.SI.Pressure p_condensate_pump_outlet = 1e6;

  // Temperatures
  parameter Modelica.Units.SI.Temperature T_LP_FWH2_tube_outlet = 109.1 + 273.15;
  parameter Modelica.Units.SI.Temperature T_HP_FWH_tube_outlet = 148.9 + 273.15;
  parameter Modelica.Units.SI.Temperature T_LP_FWH2_tube_inlet = 70 + 273.15;
  parameter Modelica.Units.SI.Temperature T_condenser = 41.7 + 273.15;

  // Mass Flow Rates
  parameter Modelica.Units.SI.MassFlowRate m_flow_FW_pump = 67.1;
  parameter Modelica.Units.SI.MassFlowRate m_flow_condensate_pump = 67.1;

  parameter Modelica.Units.SI.MassFlowRate m_flow_turbine_s2 = m_flow_FW_pump - m_flow_extraction_s1;
  parameter Modelica.Units.SI.MassFlowRate m_flow_turbine_s3 = m_flow_turbine_s2 - m_flow_extraction_s2;
  parameter Modelica.Units.SI.MassFlowRate m_flow_turbine_s4 = m_flow_turbine_s3 - m_flow_extraction_s3;

  parameter Modelica.Units.SI.MassFlowRate m_flow_extraction_s1 = 6.49078;
  parameter Modelica.Units.SI.MassFlowRate m_flow_extraction_s2 = m_flow_LP_FWH2_shell - m_flow_extraction_s1;
  parameter Modelica.Units.SI.MassFlowRate m_flow_extraction_s3 = m_flow_LP_FWH1_shell - m_flow_LP_FWH2_shell;

  parameter Modelica.Units.SI.MassFlowRate m_flow_LP_FWH2_shell = 15;
  parameter Modelica.Units.SI.MassFlowRate m_flow_LP_FWH1_shell = 20.1267;

  // Enthalpy
  parameter Modelica.Units.SI.SpecificEnthalpy h_boiler = 2500e3;
  parameter Modelica.Units.SI.SpecificEnthalpy h_drum_liquid = 650e3;

  parameter Modelica.Units.SI.SpecificEnthalpy h_turbine_s1_inlet = 2864.86e3;
  parameter Modelica.Units.SI.SpecificEnthalpy h_turbine_s1_outlet = 2560.31e3;
  parameter Modelica.Units.SI.SpecificEnthalpy h_turbine_s2_outlet = 2459.61e3;
  parameter Modelica.Units.SI.SpecificEnthalpy h_turbine_s3_outlet = 2286.67e3;
  parameter Modelica.Units.SI.SpecificEnthalpy h_turbine_s4_outlet = 2072.24e3;

  parameter Modelica.Units.SI.SpecificEnthalpy h_HP_FWH_shell_outlet = 1000e3;
  parameter Modelica.Units.SI.SpecificEnthalpy h_LP_FWH2_shell_inlet = 2045.09e3;
  parameter Modelica.Units.SI.SpecificEnthalpy h_LP_FWH2_shell_outlet = 931.98e3;
  parameter Modelica.Units.SI.SpecificEnthalpy h_LP_FWH1_shell_inlet = 1277.04e3;
  parameter Modelica.Units.SI.SpecificEnthalpy h_LP_FWH1_shell_outlet = 868.408e3;
  parameter Modelica.Units.SI.SpecificEnthalpy h_condenser_mixing = 1702.1e3;

  parameter Modelica.Units.SI.SpecificEnthalpy h_HP_FWH_tube_outlet = 571e3;

  TRANSFORM.Fluid.Machines.SteamTurbine Turbine_s1(
    redeclare package Medium = Medium_BOP,
    p_a_start=p_turbine_s1_inlet,
    p_b_start=p_turbine_s1_outlet,
    use_T_start=false,
    h_a_start=h_turbine_s1_inlet,
    h_b_start=h_turbine_s1_outlet,
    m_flow_start=m_flow_FW_pump,
    use_T_nominal=false,
    d_nominal=Medium_BOP.density_ph(p_turbine_s1_inlet, h_turbine_s1_inlet))
    annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={-199,81})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_s1_inlet,
    use_T_start=false,
    h_start=h_turbine_s1_inlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    nPorts_b=1,
    nPorts_a=1) annotation (Placement(transformation(extent={{-220,72},{-208,84}})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume1(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_s1_outlet,
    use_T_start=false,
    h_start=h_turbine_s1_outlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    nPorts_a=1,
    nPorts_b=2) annotation (Placement(transformation(extent={{-190,72},{-178,84}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance3(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-170,78})));
  TRANSFORM.Fluid.Machines.SteamTurbine Turbine_s2(
    redeclare package Medium = Medium_BOP,
    p_a_start=p_turbine_s1_outlet,
    p_b_start=p_turbine_s2_outlet,
    use_T_start=false,
    h_a_start=h_turbine_s1_outlet,
    h_b_start=h_turbine_s2_outlet,
    m_flow_start=m_flow_turbine_s2,
    use_T_nominal=false,
    d_nominal=Medium_BOP.density_ph(p_turbine_s1_outlet, h_turbine_s1_outlet))
    annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={-85,81})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume2(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_s1_outlet,
    use_T_start=false,
    h_start=h_turbine_s1_outlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    nPorts_b=1,
    nPorts_a=1) annotation (Placement(transformation(extent={{-106,72},{-94,84}})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume3(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_s2_outlet,
    use_T_start=false,
    h_start=h_turbine_s2_outlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    nPorts_a=1,
    nPorts_b=2) annotation (Placement(transformation(extent={{-76,72},{-64,84}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance5(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-56,78})));
  TRANSFORM.Fluid.Machines.SteamTurbine Turbine_s3(
    redeclare package Medium = Medium_BOP,
    p_a_start=p_turbine_s2_outlet,
    p_b_start=p_turbine_s3_outlet,
    use_T_start=false,
    h_a_start=h_turbine_s2_outlet,
    h_b_start=h_turbine_s3_outlet,
    m_flow_start=m_flow_turbine_s3,
    use_T_nominal=false,
    d_nominal=Medium_BOP.density_ph(p_turbine_s2_outlet, h_turbine_s2_outlet))
    annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={27,81})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume4(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_s2_outlet,
    use_T_start=false,
    h_start=h_turbine_s2_outlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    nPorts_b=1,
    nPorts_a=1) annotation (Placement(transformation(extent={{6,72},{18,84}})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume5(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_s3_outlet,
    use_T_start=false,
    h_start=h_turbine_s3_outlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    nPorts_a=1,
    nPorts_b=2) annotation (Placement(transformation(extent={{36,72},{48,84}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance7(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={56,78})));
  TRANSFORM.Fluid.Machines.SteamTurbine Turbine_s4(
    redeclare package Medium = Medium_BOP,
    p_a_start=p_turbine_s3_outlet,
    p_b_start=p_turbine_s4_outlet,
    use_T_start=false,
    h_a_start=h_turbine_s3_outlet,
    h_b_start=h_turbine_s4_outlet,
    m_flow_start=m_flow_turbine_s4,
    use_T_nominal=false,
    d_nominal=Medium_BOP.density_ph(p_turbine_s3_outlet, h_turbine_s3_outlet))
    annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={143,81})));
  TRANSFORM.Electrical.Sources.FrequencySource boundary4
    annotation (Placement(transformation(extent={{180,88},{172,96}})));
  TRANSFORM.Electrical.PowerConverters.Generator generator3
    annotation (Placement(transformation(extent={{158,88},{166,96}})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume6(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_s3_outlet,
    use_T_start=false,
    h_start=h_turbine_s3_outlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.1),
    nPorts_b=1,
    nPorts_a=1) annotation (Placement(transformation(extent={{122,72},{134,84}})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume7(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_s4_outlet,
    use_T_start=false,
    h_start=h_turbine_s4_outlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    nPorts_a=1,
    nPorts_b=1) annotation (Placement(transformation(extent={{152,72},{164,84}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance9(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={172,78})));
  TRANSFORM.HeatExchangers.Simple_HX_A HP_FWH(
    redeclare package Medium_1 = Medium_BOP,
    redeclare package Medium_2 = Medium_BOP,
    V_1=1,
    V_2=1,
    surfaceArea=20,
    alpha_1=11.16e3,
    alpha_2=165e3,
    p_a_start_1=p_turbine_s1_outlet,
    use_Ts_start_1=false,
    h_a_start_1=h_turbine_s1_outlet,
    h_b_start_1=h_HP_FWH_shell_outlet,
    m_flow_start_1=m_flow_extraction_s1,
    p_a_start_2=p_FW_pump_outlet,
    p_b_start_2=p_HP_FWH_tube_outlet,
    T_a_start_2=T_LP_FWH2_tube_outlet,
    T_b_start_2=T_HP_FWH_tube_outlet,
    m_flow_start_2=m_flow_FW_pump)
    annotation (Placement(transformation(extent={{-140,-36},{-120,-16}})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume8(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_s1_outlet,
    use_T_start=false,
    h_start=h_HP_FWH_shell_outlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    nPorts_a=1,
    nPorts_b=1) annotation (Placement(transformation(extent={{-112,-22},{-100,-10}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance11(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-154,-16})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance13(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-106,-38})));
  TRANSFORM.Fluid.Valves.ValveIncompressible Valve_extraction_s1(
    redeclare package Medium = Medium_BOP,
    dp_nominal=p_turbine_s1_outlet - p_turbine_s2_outlet,
    m_flow_nominal=m_flow_extraction_s1,
    rho_nominal=Medium_BOP.density_ph(p_turbine_s1_outlet, h_HP_FWH_shell_outlet),
    opening_nominal=0.5)
    annotation (Placement(transformation(extent={{-94,-20},{-86,-12}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=0.5)
    annotation (Placement(transformation(extent={{-102,-10},{-94,-2}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance10(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-50,-38})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance14(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-52,-18})));
  TRANSFORM.Fluid.Volumes.MixingVolume LP_FWH2_mixing(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_s2_outlet,
    use_T_start=false,
    h_start=h_LP_FWH2_shell_inlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    nPorts_a=2,
    nPorts_b=1) annotation (Placement(transformation(extent={{-38,-34},{-26,-22}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance15(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-18,-28})));
  TRANSFORM.HeatExchangers.Simple_HX_A LP_FWH2(
    redeclare package Medium_1 = Medium_BOP,
    redeclare package Medium_2 = Medium_BOP,
    V_1=1,
    V_2=1,
    surfaceArea=80,
    alpha_1=30e3,
    alpha_2=200e3,
    p_a_start_1=p_turbine_s2_outlet,
    use_Ts_start_1=false,
    h_a_start_1=h_LP_FWH2_shell_inlet,
    h_b_start_1=h_LP_FWH2_shell_outlet,
    m_flow_start_1=m_flow_LP_FWH2_shell,
    p_a_start_2=p_LP_FWH1_tube_outlet,
    p_b_start_2=p_LP_FWH2_tube_outlet,
    T_a_start_2=T_LP_FWH2_tube_inlet,
    T_b_start_2=T_LP_FWH2_tube_outlet,
    m_flow_start_2=m_flow_condensate_pump)
    annotation (Placement(transformation(extent={{-6,-50},{14,-30}})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume10(
    redeclare package Medium = Medium_BOP,
    p_start=p_LP_FWH2_tube_outlet,
    use_T_start=true,
    T_start=T_LP_FWH2_tube_outlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.1),
    nPorts_a=1,
    nPorts_b=1) annotation (Placement(transformation(extent={{-18,-60},{-30,-48}})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume11(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_s2_outlet,
    use_T_start=false,
    h_start=h_LP_FWH2_shell_outlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    nPorts_a=1,
    nPorts_b=1) annotation (Placement(transformation(extent={{20,-36},{32,-24}})));
  TRANSFORM.Fluid.Valves.ValveIncompressible Valve_extraction_s2(
    redeclare package Medium = Medium_BOP,
    dp_nominal=p_turbine_s2_outlet - p_turbine_s3_outlet,
    m_flow_nominal=m_flow_LP_FWH2_shell,
    rho_nominal=Medium_BOP.density_ph(p_turbine_s2_outlet, h_LP_FWH2_shell_outlet),
    opening_nominal=0.5)
    annotation (Placement(transformation(extent={{38,-34},{46,-26}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=0.5)
    annotation (Placement(transformation(extent={{28,-24},{36,-16}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance17(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={30,-50})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume12(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_s2_outlet,
    use_T_start=false,
    h_start=h_HP_FWH_shell_outlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (                                                                                                   V=0.001),
    nPorts_a=1,
    nPorts_b=1) annotation (Placement(transformation(extent={{-70,-44},{-58,-32}})));
  TRANSFORM.Fluid.Volumes.MixingVolume LP_FWH1_mixing(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_s3_outlet,
    use_T_start=false,
    h_start=h_LP_FWH1_shell_inlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (                                                                                                   V=0.001),
    nPorts_a=2,
    nPorts_b=1) annotation (Placement(transformation(extent={{108,-28},{120,-16}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance4(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={128,-22})));
  TRANSFORM.HeatExchangers.Simple_HX_A LP_FWH1(
    redeclare package Medium_1 = Medium_BOP,
    redeclare package Medium_2 = Medium_BOP,
    V_1=1,
    V_2=1,
    surfaceArea=20,
    alpha_1=30e3,
    alpha_2=200e3,
    p_a_start_1=p_turbine_s3_outlet,
    use_Ts_start_1=false,
    h_a_start_1=h_LP_FWH1_shell_inlet,
    h_b_start_1=h_LP_FWH1_shell_outlet,
    m_flow_start_1=m_flow_LP_FWH1_shell,
    p_a_start_2=p_LP_FWH1_tube_inlet,
    p_b_start_2=p_LP_FWH1_tube_outlet,
    T_a_start_2=T_condenser,
    T_b_start_2=T_LP_FWH2_tube_inlet,
    m_flow_start_2=m_flow_condensate_pump)
    annotation (Placement(transformation(extent={{140,-44},{160,-24}})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume13(
    redeclare package Medium = Medium_BOP,
    p_start=p_LP_FWH1_tube_outlet,
    use_T_start=true,
    T_start=T_LP_FWH2_tube_inlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (                                                                                                   V=0.001),
    nPorts_a=1,
    nPorts_b=1) annotation (Placement(transformation(extent={{128,-54},{116,-42}})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume14(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_s3_outlet,
    use_T_start=false,
    h_start=h_LP_FWH1_shell_outlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (                                                                                                   V=0.001),
    nPorts_a=1,
    nPorts_b=1) annotation (Placement(transformation(extent={{166,-30},{178,-18}})));
  TRANSFORM.Fluid.Valves.ValveIncompressible Valve_extraction_s3(
    redeclare package Medium = Medium_BOP,
    dp_nominal=p_turbine_s3_outlet - p_turbine_s4_outlet,
    m_flow_nominal=m_flow_LP_FWH1_shell,
    rho_nominal=Medium_BOP.density_ph(p_turbine_s3_outlet, h_LP_FWH1_shell_outlet),
    opening_nominal=0.5)
    annotation (Placement(transformation(extent={{184,-28},{192,-20}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=0.5)
    annotation (Placement(transformation(extent={{174,-18},{182,-10}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance18(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={176,-44})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance20(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={98,-12})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance21(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={98,-28})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume15(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_s3_outlet,
    use_T_start=false,
    h_start=h_LP_FWH2_shell_outlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.1),
    nPorts_a=1,
    nPorts_b=1) annotation (Placement(transformation(extent={{74,-34},{86,-22}})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume16(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_s4_outlet,
    use_T_start=false,
    h_start=h_LP_FWH1_shell_outlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (                                                                                                   V=0.001),
    nPorts_a=1,
    nPorts_b=1) annotation (Placement(transformation(extent={{158,24},{170,36}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance6(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={178,30})));
  TRANSFORM.Fluid.Volumes.MixingVolume condenser_mixing(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_s4_outlet,
    use_T_start=false,
    h_start=h_condenser_mixing,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (                                                                                                   V=0.001),
    nPorts_a=2,
    nPorts_b=1) annotation (Placement(transformation(extent={{186,44},{198,56}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance22(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={206,50})));
  TRANSFORM.Fluid.Machines.Pump_Controlled condensate_pump(
    redeclare package Medium = Medium_BOP,
    p_a_start=p_condenser,
    p_b_start=p_LP_FWH1_tube_inlet,
    use_T_start=true,
    T_a_start=T_condenser,
    m_flow_start=m_flow_condensate_pump,
    redeclare model FlowChar =
        TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Flow.PerformanceCurve
        (head_curve={0,115,230}, V_flow_curve={0.1015,0.0671,0}),
    dp_nominal=1010000,
    controlType="RPM",
    use_port=false)
    annotation (Placement(transformation(extent={{196,-76},{186,-64}})));
  TRANSFORM.Fluid.Valves.ValveLinear valveLinear(
    redeclare package Medium = Medium_BOP,
    dp_nominal(displayUnit="bar") = 800,
    m_flow_nominal=m_flow_condensate_pump) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={170,-70})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y=1)
    annotation (Placement(transformation(extent={{140,-96},{160,-76}})));
  TRANSFORM.Fluid.Valves.ValveLinear valveLinear1(
    redeclare package Medium = Medium_BOP,
    dp_nominal(displayUnit="Pa") = 1,
    m_flow_nominal=m_flow_condensate_pump) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={210,-70})));
  Modelica.Blocks.Sources.RealExpression realExpression4(y=1)
    annotation (Placement(transformation(extent={{184,-96},{204,-76}})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume17(
    redeclare package Medium = Medium_BOP,
    p_start=p_LP_FWH1_tube_inlet,
    use_T_start=true,
    T_start=T_LP_FWH2_tube_inlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.1),
    nPorts_a=1,
    nPorts_b=1) annotation (Placement(transformation(extent={{158,-76},{146,-64}})));
  TRANSFORM.Fluid.Machines.Pump_Controlled FW_pump(
    redeclare package Medium = Medium_BOP,
    p_a_start=p_LP_FWH2_tube_outlet - valveLinear3.dp_nominal,
    p_b_start=p_FW_pump_outlet + valveLinear2.dp_nominal,
    use_T_start=true,
    T_a_start=T_LP_FWH2_tube_outlet,
    m_flow_start=m_flow_FW_pump,
    redeclare model FlowChar =
        TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Flow.PerformanceCurve
        (head_curve={0,500,1000}, V_flow_curve={0.1015,0.0671,0}),
    redeclare model EfficiencyChar =
        TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Efficiency.Constant,
    dp_nominal(displayUnit="bar") = 10,
    controlType="RPM",
    use_port=false)
    annotation (Placement(transformation(extent={{-96,-74},{-106,-62}})));

  TRANSFORM.Fluid.Valves.ValveLinear valveLinear2(
    redeclare package Medium = Medium_BOP,
    dp_nominal(displayUnit="Pa") = 100,
    m_flow_nominal=m_flow_FW_pump) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={-120,-68})));
  Modelica.Blocks.Sources.RealExpression realExpression5(y=1)
    annotation (Placement(transformation(extent={{-150,-94},{-130,-74}})));
  TRANSFORM.Fluid.Valves.ValveLinear valveLinear3(
    redeclare package Medium = Medium_BOP,
    dp_nominal(displayUnit="Pa") = 10,
    m_flow_nominal=m_flow_condensate_pump) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={-82,-68})));
  Modelica.Blocks.Sources.RealExpression realExpression6(y=1)
    annotation (Placement(transformation(extent={{-108,-94},{-88,-74}})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume18(
    redeclare package Medium = Medium_BOP,
    p_start=p_FW_pump_outlet,
    use_T_start=true,
    T_start=T_LP_FWH2_tube_outlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=1),
    nPorts_a=1,
    nPorts_b=1) annotation (Placement(transformation(extent={{-132,-74},{-144,-62}})));
  TRANSFORM.Fluid.Volumes.IdealCondenser condenser(
    redeclare package Medium = Medium_BOP,
    p=p_condenser,
    V_total=100,
    V_liquid_start=1) annotation (Placement(transformation(extent={{214,-12},{226,0}})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume19(
    redeclare package Medium = Medium_BOP,
    p_start=p_condenser,
    use_T_start=true,
    T_start=T_condenser,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (                                                                                                   V=0.001),
    nPorts_a=1,
    nPorts_b=1) annotation (Placement(transformation(extent={{222,-32},{210,-20}})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume9(
    redeclare package Medium = Medium_BOP,
    p_start=p_HP_FWH_tube_outlet,
    use_T_start=true,
    T_start=T_HP_FWH_tube_outlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (                                                                                                   V=0.001),
    nPorts_a=1,
    nPorts_b=1) annotation (Placement(transformation(extent={{-148,-38},{-160,-26}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance1(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-246,54})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance2(
    redeclare package Medium = Medium_BOP,
    showName=false,
    R=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={-172,-32})));
  Modelica.Blocks.Sources.RealExpression realExpression8(y=PID.y)
    annotation (Placement(transformation(extent={{-248,80},{-240,92}})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume21(
    redeclare package Medium = Medium_BOP,
    p_start=p_turbine_s1_inlet,
    use_T_start=false,
    h_start=h_turbine_s1_inlet,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=0.001),
    nPorts_b=1,
    nPorts_a=1) annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-246,72})));
  TRANSFORM.Fluid.Valves.ValveLinear SteamControlValve(
    redeclare package Medium = Medium_BOP,
    dp_nominal(displayUnit="bar") = 52000,
    m_flow_nominal=m_flow_FW_pump) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-228,78})));
  Modelica.Blocks.Sources.RealExpression realExpression9(y=volume21.medium.p)
    annotation (Placement(transformation(extent={{-88,8},{-100,24}})));
  Modelica.Blocks.Sources.RealExpression realExpression10(y=p_turbine_s1_inlet)
    annotation (Placement(transformation(extent={{-76,28},{-88,44}})));
  TRANSFORM.Controls.LimPID PID(
    k=-1e-6,
    yb=0.5,
    yMax=1,
    yMin=0.05) annotation (Placement(transformation(extent={{-110,26},{-130,46}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow Feedwater_out(redeclare package Medium
      = Medium_BOP)
    annotation (Placement(transformation(extent={{-270,-42},{-250,-22}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow Steam_in(redeclare package Medium =
        Medium_BOP)
    annotation (Placement(transformation(extent={{-270,44},{-250,64}})));
equation
  connect(volume.port_b[1], Turbine_s1.portHP)
    annotation (Line(points={{-210.4,78},{-204,78}}, color={0,127,255}));
  connect(Turbine_s1.portLP, volume1.port_a[1])
    annotation (Line(points={{-194,78},{-187.6,78}}, color={0,127,255}));
  connect(volume1.port_b[1], resistance3.port_a)
    annotation (Line(points={{-180.4,77.85},{-178,77.85},{-178,78},{-174.2,78}},
                                                       color={0,127,255}));
  connect(volume2.port_b[1], Turbine_s2.portHP)
    annotation (Line(points={{-96.4,78},{-90,78}}, color={0,127,255}));
  connect(Turbine_s2.portLP,volume3. port_a[1])
    annotation (Line(points={{-80,78},{-73.6,78}},   color={0,127,255}));
  connect(volume3.port_b[1],resistance5. port_a)
    annotation (Line(points={{-66.4,77.85},{-64,77.85},{-64,78},{-60.2,78}},
                                                       color={0,127,255}));
  connect(volume4.port_b[1],Turbine_s3. portHP)
    annotation (Line(points={{15.6,78},{22,78}},   color={0,127,255}));
  connect(Turbine_s3.portLP,volume5. port_a[1])
    annotation (Line(points={{32,78},{38.4,78}},     color={0,127,255}));
  connect(volume5.port_b[1],resistance7. port_a)
    annotation (Line(points={{45.6,77.85},{48,77.85},{48,78},{51.8,78}},
                                                       color={0,127,255}));
  connect(Turbine_s4.shaft_b,generator3. shaft)
    annotation (Line(points={{148,81},{152,81},{152,92},{158,92}}, color={0,0,0}));
  connect(generator3.port,boundary4. port)
    annotation (Line(points={{166,92},{172,92}}, color={255,0,0}));
  connect(volume6.port_b[1],Turbine_s4. portHP)
    annotation (Line(points={{131.6,78},{138,78}}, color={0,127,255}));
  connect(Turbine_s4.portLP,volume7. port_a[1])
    annotation (Line(points={{148,78},{154.4,78}},   color={0,127,255}));
  connect(volume7.port_b[1],resistance9. port_a)
    annotation (Line(points={{161.6,78},{167.8,78}},   color={0,127,255}));
  connect(HP_FWH.port_b1, volume8.port_a[1]) annotation (Line(points={{-120,-22},{-114,
          -22},{-114,-16},{-109.6,-16}}, color={0,127,255}));
  connect(HP_FWH.port_a1, resistance11.port_b) annotation (Line(points={{-140,-22},{-144,
          -22},{-144,-16},{-149.8,-16}}, color={0,127,255}));
  connect(HP_FWH.port_a2, resistance13.port_a) annotation (Line(points={{-120,-30},{-114,
          -30},{-114,-38},{-110.2,-38}}, color={0,127,255}));
  connect(volume8.port_b[1],Valve_extraction_s1. port_a)
    annotation (Line(points={{-102.4,-16},{-94,-16}}, color={0,127,255}));
  connect(realExpression.y,Valve_extraction_s1. opening)
    annotation (Line(points={{-93.6,-6},{-90,-6},{-90,-12.8}}, color={0,0,127}));
  connect(resistance11.port_a, volume1.port_b[2]) annotation (Line(points={{-158.2,
          -16},{-178,-16},{-178,78.15},{-180.4,78.15}},
                                                 color={0,127,255}));
  connect(resistance14.port_b, LP_FWH2_mixing.port_a[1]) annotation (Line(points={{-47.8,
          -18},{-42,-18},{-42,-28.15},{-35.6,-28.15}},
                                                 color={0,127,255}));
  connect(resistance10.port_b, LP_FWH2_mixing.port_a[2]) annotation (Line(points={{-45.8,
          -38},{-42,-38},{-42,-27.85},{-35.6,-27.85}},
                                                 color={0,127,255}));
  connect(volume10.port_a[1], LP_FWH2.port_b2) annotation (Line(points={{-20.4,-54},{-12,-54},{-12,-44},{-6,-44}},
                                  color={0,127,255}));
  connect(volume11.port_b[1], Valve_extraction_s2.port_a)
    annotation (Line(points={{29.6,-30},{38,-30}}, color={0,127,255}));
  connect(realExpression1.y, Valve_extraction_s2.opening)
    annotation (Line(points={{36.4,-20},{42,-20},{42,-26.8}}, color={0,0,127}));
  connect(LP_FWH2.port_b1, volume11.port_a[1]) annotation (Line(points={{14,-36},{18,-36},{18,-30},{22.4,-30}},
                                    color={0,127,255}));
  connect(LP_FWH2.port_a2, resistance17.port_a) annotation (Line(points={{14,-44},{20,-44},{20,-50},{25.8,-50}},
                                    color={0,127,255}));
  connect(LP_FWH2_mixing.port_b[1], resistance15.port_b)
    annotation (Line(points={{-28.4,-28},{-22.2,-28}},color={0,127,255}));
  connect(resistance15.port_a, LP_FWH2.port_a1)
    annotation (Line(points={{-13.8,-28},{-10,-28},{-10,-36},{-6,-36}},
                                                                     color={0,127,255}));
  connect(volume12.port_b[1], resistance10.port_a) annotation (Line(points={{-60.4,-38},{-54.2,-38}}, color={0,127,255}));
  connect(volume12.port_a[1], Valve_extraction_s1.port_b)
    annotation (Line(points={{-67.6,-38},{-74,-38},{-74,-16},{-86,-16}}, color={0,127,255}));
  connect(resistance14.port_a, volume3.port_b[2])
    annotation (Line(points={{-56.2,-18},{-66.4,-18},{-66.4,78.15}},color={0,127,255}));
  connect(resistance3.port_b, volume2.port_a[1]) annotation (Line(points={{-165.8,78},{-103.6,78}}, color={0,127,255}));
  connect(Turbine_s1.shaft_b, Turbine_s2.shaft_a)
    annotation (Line(points={{-194,81},{-192,81},{-192,82},{-188,82},{-188,88},{-92,88},{-92,81},{-90,81}}, color={0,0,0}));
  connect(volume13.port_a[1],LP_FWH1. port_b2) annotation (Line(points={{125.6,-48},{134,-48},{134,-38},{140,-38}},
                                  color={0,127,255}));
  connect(volume14.port_b[1],Valve_extraction_s3. port_a)
    annotation (Line(points={{175.6,-24},{184,-24}},
                                                   color={0,127,255}));
  connect(realExpression2.y,Valve_extraction_s3. opening)
    annotation (Line(points={{182.4,-14},{188,-14},{188,-20.8}},
                                                              color={0,0,127}));
  connect(LP_FWH1.port_b1,volume14. port_a[1]) annotation (Line(points={{160,-30},{164,-30},{164,-24},{168.4,-24}},
                                    color={0,127,255}));
  connect(LP_FWH1.port_a2,resistance18. port_a) annotation (Line(points={{160,-38},{166,-38},{166,-44},{171.8,-44}},
                                    color={0,127,255}));
  connect(LP_FWH1_mixing.port_b[1], resistance4.port_b) annotation (Line(points={{117.6,-22},{123.8,-22}},
                                                                                                       color={0,127,255}));
  connect(resistance4.port_a, LP_FWH1.port_a1) annotation (Line(points={{132.2,-22},{136,-22},{136,-30},{140,-30}},
                                                                                                            color={0,127,255}));
  connect(resistance21.port_a, LP_FWH1_mixing.port_a[1])
    annotation (Line(points={{102.2,-28},{106,-28},{106,-22.15},{110.4,-22.15}},
                                                                    color={0,127,255}));
  connect(resistance20.port_a, LP_FWH1_mixing.port_a[2])
    annotation (Line(points={{102.2,-12},{106,-12},{106,-21.85},{110.4,-21.85}},
                                                                    color={0,127,255}));
  connect(resistance20.port_b, volume5.port_b[2])
    annotation (Line(points={{93.8,-12},{50,-12},{50,78.15},{45.6,78.15}},
                                                                         color={0,127,255}));
  connect(volume15.port_b[1], resistance21.port_b) annotation (Line(points={{83.6,-28},{93.8,-28}}, color={0,127,255}));
  connect(volume15.port_a[1], Valve_extraction_s2.port_b)
    annotation (Line(points={{76.4,-28},{60,-28},{60,-30},{46,-30}}, color={0,127,255}));
  connect(resistance5.port_b, volume4.port_a[1]) annotation (Line(points={{-51.8,78},{8.4,78}}, color={0,127,255}));
  connect(Turbine_s2.shaft_b, Turbine_s3.shaft_a)
    annotation (Line(points={{-80,81},{-78,81},{-78,80},{-76,80},{-76,86},{18,86},{18,81},{22,81}}, color={0,0,0}));
  connect(Valve_extraction_s3.port_b, volume16.port_a[1])
    annotation (Line(points={{192,-24},{196,-24},{196,-4},{154,-4},{154,30},{160.4,30}}, color={0,127,255}));
  connect(volume16.port_b[1], resistance6.port_a) annotation (Line(points={{167.6,30},{173.8,30}}, color={0,127,255}));
  connect(resistance6.port_b, condenser_mixing.port_a[1])
    annotation (Line(points={{182.2,30},{186,30},{186,49.85},{188.4,49.85}},
                                                                           color={0,127,255}));
  connect(resistance9.port_b, condenser_mixing.port_a[2])
    annotation (Line(points={{176.2,78},{184,78},{184,50.15},{188.4,50.15}},
                                                                           color={0,127,255}));
  connect(resistance22.port_a, condenser_mixing.port_b[1]) annotation (Line(points={{201.8,50},{195.6,50}}, color={0,127,255}));
  connect(resistance7.port_b, volume6.port_a[1]) annotation (Line(points={{60.2,78},{124.4,78}}, color={0,127,255}));
  connect(Turbine_s3.shaft_b, Turbine_s4.shaft_a)
    annotation (Line(points={{32,81},{34,81},{34,86},{134,86},{134,81},{138,81}}, color={0,0,0}));
  connect(realExpression3.y, valveLinear.opening)
    annotation (Line(points={{161,-86},{170,-86},{170,-74.8}}, color={0,0,127}));
  connect(valveLinear.port_a, condensate_pump.port_b)
    annotation (Line(points={{176,-70},{186,-70}}, color={0,127,255}));
  connect(condensate_pump.port_a, valveLinear1.port_b)
    annotation (Line(points={{196,-70},{204,-70}}, color={0,127,255}));
  connect(realExpression4.y, valveLinear1.opening)
    annotation (Line(points={{205,-86},{210,-86},{210,-74.8}}, color={0,0,127}));
  connect(volume17.port_a[1], valveLinear.port_b)
    annotation (Line(points={{155.6,-70},{164,-70}}, color={0,127,255}));
  connect(volume17.port_b[1], resistance18.port_b) annotation (Line(points={{148.4,
          -70},{144,-70},{144,-58},{188,-58},{188,-44},{180.2,-44}}, color={0,127,
          255}));
  connect(realExpression5.y, valveLinear2.opening)
    annotation (Line(points={{-129,-84},{-120,-84},{-120,-72.8}}, color={0,0,127}));
  connect(realExpression6.y, valveLinear3.opening)
    annotation (Line(points={{-87,-84},{-82,-84},{-82,-72.8}}, color={0,0,127}));
  connect(volume13.port_b[1], resistance17.port_b) annotation (Line(points={{118.4,
          -48},{42,-48},{42,-50},{34.2,-50}}, color={0,127,255}));
  connect(FW_pump.port_a, valveLinear3.port_b) annotation (Line(points={{-96,-68},{-88,-68}}, color={0,127,255}));
  connect(FW_pump.port_b, valveLinear2.port_a) annotation (Line(points={{-106,-68},{-114,-68}}, color={0,127,255}));
  connect(valveLinear3.port_a, volume10.port_b[1])
    annotation (Line(points={{-76,-68},{-60,-68},{-60,-54},{-27.6,-54}}, color={0,127,255}));
  connect(volume18.port_a[1], valveLinear2.port_b) annotation (Line(points={{-134.4,-68},{-126,-68}}, color={0,127,255}));
  connect(volume18.port_b[1], resistance13.port_b)
    annotation (Line(points={{-141.6,-68},{-146,-68},{-146,-50},{-94,-50},{-94,-38},{-101.8,-38}}, color={0,127,255}));
  connect(condenser.port_b, volume19.port_a[1])
    annotation (Line(points={{220,-10.8},{220,-18},{220,-26},{219.6,-26}}, color={0,127,255}));
  connect(volume19.port_b[1], valveLinear1.port_a)
    annotation (Line(points={{212.4,-26},{208,-26},{208,-54},{226,-54},{226,-70},{216,-70}}, color={0,127,255}));
  connect(resistance22.port_b, condenser.port_a) annotation (Line(points={{210.2,50},{215.8,50},{215.8,-1.8}}, color={0,127,255}));
  connect(volume9.port_a[1], HP_FWH.port_b2)
    annotation (Line(points={{-150.4,-32},{-148,-32},{-148,-30},{-140,-30}}, color={0,127,255}));
  connect(resistance2.port_a, volume9.port_b[1])
    annotation (Line(points={{-167.8,-32},{-157.6,-32}}, color={0,127,255}));
  connect(SteamControlValve.port_a,volume21. port_b[1])
    annotation (Line(points={{-234,78},{-242.4,78},{-242.4,72}},
                                                               color={0,127,255}));
  connect(realExpression8.y,SteamControlValve. opening)
    annotation (Line(points={{-239.6,86},{-228,86},{-228,82.8}}, color={0,0,127}));
  connect(PID.u_s, realExpression10.y)
    annotation (Line(points={{-108,36},{-88.6,36}}, color={0,0,127}));
  connect(realExpression9.y, PID.u_m)
    annotation (Line(points={{-100.6,16},{-120,16},{-120,24}}, color={0,0,127}));
  connect(volume21.port_a[1], resistance1.port_b) annotation (Line(points={{-249.6,72},
          {-252,72},{-252,62},{-240,62},{-240,54},{-241.8,54}}, color={0,127,255}));
  connect(resistance2.port_b, Feedwater_out)
    annotation (Line(points={{-176.2,-32},{-260,-32}}, color={0,127,255}));
  connect(resistance1.port_a, Steam_in)
    annotation (Line(points={{-250.2,54},{-260,54}}, color={0,127,255}));
  connect(SteamControlValve.port_b, volume.port_a[1])
    annotation (Line(points={{-222,78},{-217.6,78}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-260,-100},{240,
            100}})),                                             Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-260,-100},{240,100}})),
    experiment(StopTime=10000, __Dymola_Algorithm="Esdirk45a"));
end BOP_Controlled_full;
