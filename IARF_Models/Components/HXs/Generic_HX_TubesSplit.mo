within IARF_Models.Components.HXs;
model Generic_HX_TubesSplit
  "A (i.e., no inlet/outlet plenum considerations, etc.) generic heat exchanger with discritized fluid and wall volumes where concurrent/counter flow is specified mass flow direction."
  import TRANSFORM.Math.linspace_1D;
  import TRANSFORM.Math.fillArray_1D;
  import TRANSFORM.Math.linspaceRepeat_1D;
  import TRANSFORM.Fluid.Types.LumpedLocation;
  import Modelica.Fluid.Types.Dynamics;
  outer TRANSFORM.Fluid.SystemTF systemTF;
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_a_tube(redeclare package Medium =
               Medium_tube) annotation (Placement(transformation(extent={{-110,-10},
            {-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_b_tube(redeclare package Medium =
               Medium_tube) annotation (Placement(transformation(extent={{90,-10},
            {110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_a_shell(redeclare package Medium =
               Medium_shell) annotation (Placement(transformation(extent={{90,36},
            {110,56}}), iconTransformation(extent={{90,36},{110,56}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_b_shell(redeclare package Medium =
               Medium_shell) annotation (Placement(transformation(extent={{-110,
            36},{-90,56}}), iconTransformation(extent={{-110,36},{-90,56}})));
  parameter Real nParallel=1 "# of identical parallel HXs";
  replaceable model Geometry =
      IARF_Models.Components.HXs.Geometries.ShellAndTubeHX_Creep
    constrainedby
    IARF_Models.Components.HXs.Geometries.GenericHX_Creep
    "Geometry" annotation (choicesAllMatching=true);
  Geometry geometry
    annotation (Placement(transformation(extent={{-98,82},{-82,98}})));
  replaceable package Medium_shell =
      Modelica.Media.Interfaces.PartialMedium
    "Shell side medium" annotation (choicesAllMatching=true);
  replaceable package Medium_tube = Modelica.Media.Interfaces.PartialMedium
    "Tube side medium" annotation (choicesAllMatching=true);
  replaceable package Material_tubeWall =
      TRANSFORM.Media.Interfaces.Solids.PartialAlloy
                                              "Tube wall material" annotation (
      choicesAllMatching=true);
  parameter Boolean counterCurrent=true
    "Swap shell side temperature and flux vector order";
  replaceable model FlowModel_shell =
      TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D.SinglePhase_Developed_2Region_NumStable
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D.PartialDistributedStaggeredFlow
    "Shell side flow models (i.e., momentum, pressure loss, wall friction)"
    annotation (choicesAllMatching=true, Dialog(group="Pressure Loss"));
  replaceable model HeatTransfer_shell =
      TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Ideal
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.PartialHeatTransfer_setT
    "Shell side coefficient of heat transfer" annotation (choicesAllMatching=true,
      Dialog(group="Heat Transfer"));
  replaceable model FlowModel_tube =
      TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D.SinglePhase_Developed_2Region_NumStable
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D.PartialDistributedStaggeredFlow
    "Tube side flow models (i.e., momentum, pressure loss, wall friction)"
    annotation (choicesAllMatching=true, Dialog(group="Pressure Loss"));
  replaceable model HeatTransfer_tube =
      TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Ideal
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.PartialHeatTransfer_setT
    "Tube side coefficient of heat transfer" annotation (choicesAllMatching=true,
      Dialog(group="Heat Transfer"));

  // Shell Initialization - General part 1
    parameter Boolean use_Ts_start_shell=true
    "Use T_start if true, otherwise h_start" annotation (Evaluate=true, Dialog(
        tab="Shell Initialization", group="Start Value: Temperature"));

  // Shell Segment 1 Initialization
  parameter Modelica.Units.SI.AbsolutePressure[geometry.nV] ps_start_shell_s1=
      linspace_1D(
      p_a_start_shell_s1,
      p_b_start_shell_s1,
      geometry.nV) "Pressure" annotation (Dialog(tab="Shell Initialization", group="Segment 1 Start Value: Absolute Pressure"));
  parameter Modelica.Units.SI.AbsolutePressure p_a_start_shell_s1=Medium_shell.p_default
    "Pressure at port a" annotation (Dialog(tab="Shell Initialization", group="Segment 1 Start Value: Absolute Pressure"));
  parameter Modelica.Units.SI.AbsolutePressure p_b_start_shell_s1=p_a_start_shell_s1 + (
      if m_flow_a_start_shell > 0 then -0.3e3 elseif m_flow_a_start_shell < 0 then -0.3e3
       else 0) "Pressure at port b" annotation (Dialog(tab="Shell Initialization",
        group="Segment 1 Start Value: Absolute Pressure"));
  parameter Modelica.Units.SI.Temperature Ts_start_shell_s1[geometry.nV]=linspace_1D(
      T_a_start_shell_s1,
      T_b_start_shell_s1,
      geometry.nV) "Temperature" annotation (Evaluate=true, Dialog(
      tab="Shell Initialization",
      group="Segment 1 Start Value: Temperature",
      enable=use_Ts_start_shell));
  parameter Modelica.Units.SI.Temperature T_a_start_shell_s1=Medium_shell.T_default
    "Temperature at port a" annotation (Dialog(
      tab="Shell Initialization",
      group="Segment 1 Start Value: Temperature",
      enable=use_Ts_start_shell));
  parameter Modelica.Units.SI.Temperature T_b_start_shell_s1=T_a_start_shell_s1
    "Temperature at port b" annotation (Dialog(
      tab="Shell Initialization",
      group="Segment 1 Start Value: Temperature",
      enable=use_Ts_start_shell));
  parameter Modelica.Units.SI.SpecificEnthalpy[geometry.nV] hs_start_shell_s1=if not
      use_Ts_start_shell then linspace_1D(
      h_a_start_shell_s1,
      h_b_start_shell_s1,
      geometry.nV) else {Medium_shell.specificEnthalpy_pTX(
      ps_start_shell_s1[i],
      Ts_start_shell_s1[i],
      Xs_start_shell[i, 1:Medium_shell.nX]) for i in 1:geometry.nV}
    "Specific enthalpy" annotation (Dialog(
      tab="Shell Initialization",
      group="Segment 1 Start Value: Specific Enthalpy",
      enable=not use_Ts_start_shell));
  parameter Modelica.Units.SI.SpecificEnthalpy h_a_start_shell_s1=
      Medium_shell.specificEnthalpy_pTX(
      p_a_start_shell_s1,
      T_a_start_shell_s1,
      X_a_start_shell) "Specific enthalpy at port a" annotation (Dialog(
      tab="Shell Initialization",
      group="Segment 1 Start Value: Specific Enthalpy",
      enable=not use_Ts_start_shell));
  parameter Modelica.Units.SI.SpecificEnthalpy h_b_start_shell_s1=
      Medium_shell.specificEnthalpy_pTX(
      p_b_start_shell_s1,
      T_b_start_shell_s1,
      X_b_start_shell) "Specific enthalpy at port b" annotation (Dialog(
      tab="Shell Initialization",
      group="Segment 1 Start Value: Specific Enthalpy",
      enable=not use_Ts_start_shell));

  // Shell Segment 2 Initialization
  parameter Modelica.Units.SI.AbsolutePressure[geometry.nV] ps_start_shell_s2=
      linspace_1D(
      p_b_start_shell_s1,
      p_a_start_shell_s3,
      geometry.nV) "Pressure" annotation (Dialog(tab="Shell Initialization", group="Segment 2 Start Value: Absolute Pressure"));
  parameter Modelica.Units.SI.Temperature Ts_start_shell_s2[geometry.nV]=linspace_1D(
      T_b_start_shell_s1,
      T_a_start_shell_s3,
      geometry.nV) "Temperature" annotation (Evaluate=true, Dialog(
      tab="Shell Initialization",
      group="Segment 2 Start Value: Temperature",
      enable=use_Ts_start_shell));
  parameter Modelica.Units.SI.SpecificEnthalpy[geometry.nV] hs_start_shell_s2=if not
      use_Ts_start_shell then linspace_1D(
      h_b_start_shell_s1,
      h_a_start_shell_s3,
      geometry.nV) else {Medium_shell.specificEnthalpy_pTX(
      ps_start_shell_s2[i],
      Ts_start_shell_s2[i],
      Xs_start_shell[i, 1:Medium_shell.nX]) for i in 1:geometry.nV}
    "Specific enthalpy" annotation (Dialog(
      tab="Shell Initialization",
      group="Segment 2 Start Value: Specific Enthalpy",
      enable=not use_Ts_start_shell));

  // Shell Segment 3 Initialization
  parameter Modelica.Units.SI.AbsolutePressure[geometry.nV] ps_start_shell_s3=
      linspace_1D(
      p_a_start_shell_s3,
      p_b_start_shell_s3,
      geometry.nV) "Pressure" annotation (Dialog(tab="Shell Initialization", group="Segment 3 Start Value: Absolute Pressure"));
  parameter Modelica.Units.SI.AbsolutePressure p_a_start_shell_s3=p_b_start_shell_s1 + (
      if m_flow_a_start_shell > 0 then -0.3e3 elseif m_flow_a_start_shell < 0 then -0.3e3
       else 0) "Pressure at port a" annotation (Dialog(tab="Shell Initialization", group="Segment 3 Start Value: Absolute Pressure"));
  parameter Modelica.Units.SI.AbsolutePressure p_b_start_shell_s3=p_a_start_shell_s3 + (
      if m_flow_a_start_shell > 0 then -0.3e3 elseif m_flow_a_start_shell < 0 then -0.3e3
       else 0) "Pressure at port b" annotation (Dialog(tab="Shell Initialization",
        group="Segment 3 Start Value: Absolute Pressure"));
  parameter Modelica.Units.SI.Temperature Ts_start_shell_s3[geometry.nV]=linspace_1D(
      T_a_start_shell_s3,
      T_b_start_shell_s3,
      geometry.nV) "Temperature" annotation (Evaluate=true, Dialog(
      tab="Shell Initialization",
      group="Segment 3 Start Value: Temperature",
      enable=use_Ts_start_shell));
  parameter Modelica.Units.SI.Temperature T_a_start_shell_s3=T_b_start_shell_s1
    "Temperature at port a" annotation (Dialog(
      tab="Shell Initialization",
      group="Segment 3 Start Value: Temperature",
      enable=use_Ts_start_shell));
  parameter Modelica.Units.SI.Temperature T_b_start_shell_s3=T_a_start_shell_s3
    "Temperature at port b" annotation (Dialog(
      tab="Shell Initialization",
      group="Segment 3 Start Value: Temperature",
      enable=use_Ts_start_shell));
  parameter Modelica.Units.SI.SpecificEnthalpy[geometry.nV] hs_start_shell_s3=if not
      use_Ts_start_shell then linspace_1D(
      h_a_start_shell_s3,
      h_b_start_shell_s3,
      geometry.nV) else {Medium_shell.specificEnthalpy_pTX(
      ps_start_shell_s3[i],
      Ts_start_shell_s3[i],
      Xs_start_shell[i, 1:Medium_shell.nX]) for i in 1:geometry.nV}
    "Specific enthalpy" annotation (Dialog(
      tab="Shell Initialization",
      group="Segment 3 Start Value: Specific Enthalpy",
      enable=not use_Ts_start_shell));
  parameter Modelica.Units.SI.SpecificEnthalpy h_a_start_shell_s3=
      Medium_shell.specificEnthalpy_pTX(
      p_a_start_shell_s3,
      T_a_start_shell_s3,
      X_a_start_shell) "Specific enthalpy at port a" annotation (Dialog(
      tab="Shell Initialization",
      group="Segment 3 Start Value: Specific Enthalpy",
      enable=not use_Ts_start_shell));
  parameter Modelica.Units.SI.SpecificEnthalpy h_b_start_shell_s3=
      Medium_shell.specificEnthalpy_pTX(
      p_b_start_shell_s3,
      T_b_start_shell_s3,
      X_b_start_shell) "Specific enthalpy at port b" annotation (Dialog(
      tab="Shell Initialization",
      group="Segment 3 Start Value: Specific Enthalpy",
      enable=not use_Ts_start_shell));

   // Shell Initialization - General part 2
 parameter Modelica.Units.SI.MassFraction Xs_start_shell[geometry.nV,Medium_shell.nX]=
     linspaceRepeat_1D(
      X_a_start_shell,
      X_b_start_shell,
      geometry.nV) "Mass fraction" annotation (Dialog(
      tab="Shell Initialization",
      group="Start Value: Species Mass Fraction",
      enable=Medium_shell.nXi > 0));
  parameter Modelica.Units.SI.MassFraction X_a_start_shell[Medium_shell.nX]=
      Medium_shell.X_default "Mass fraction at port a" annotation (Dialog(tab="Shell Initialization",
        group="Start Value: Species Mass Fraction"));
  parameter Modelica.Units.SI.MassFraction X_b_start_shell[Medium_shell.nX]=
      X_a_start_shell "Mass fraction at port b" annotation (Dialog(tab="Shell Initialization",
        group="Start Value: Species Mass Fraction"));
  parameter TRANSFORM.Units.ExtraProperty Cs_start_shell[geometry.nV,Medium_shell.nC]=
     linspaceRepeat_1D(
      C_a_start_shell,
      C_b_start_shell,
      geometry.nV) "Mass-Specific value" annotation (Dialog(
      tab="Shell Initialization",
      group="Start Value: Trace Substances",
      enable=Medium_shell.nC > 0));
  parameter TRANSFORM.Units.ExtraProperty C_a_start_shell[Medium_shell.nC]=fill(0,
      Medium_shell.nC) "Mass-Specific value at port a" annotation (Dialog(tab="Shell Initialization",
        group="Start Value: Trace Substances"));
  parameter TRANSFORM.Units.ExtraProperty C_b_start_shell[Medium_shell.nC]=
      C_a_start_shell "Mass-Specific value at port b" annotation (Dialog(tab="Shell Initialization",
        group="Start Value: Trace Substances"));
  parameter Modelica.Units.SI.MassFlowRate[geometry.nV + 1] m_flows_start_shell=linspace(
      m_flow_a_start_shell,
      -m_flow_b_start_shell,
      geometry.nV + 1) "Mass flow rates" annotation (Evaluate=true, Dialog(tab="Shell Initialization",
        group="Start Value: Mass Flow Rate"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_a_start_shell=0
    "Mass flow rate at port_a" annotation (Dialog(tab="Shell Initialization", group="Start Value: Mass Flow Rate"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_b_start_shell=-
      m_flow_a_start_shell "Mass flow rate at port_b" annotation (Dialog(tab="Shell Initialization",
        group="Start Value: Mass Flow Rate"));

  // Tube 1 Initialization - General part 1
  parameter Boolean use_Ts_start_tube=true
    "Use T_start if true, otherwise h_start" annotation (Evaluate=true, Dialog(
        tab="Tube Initialization", group="Start Value: Temperature"));

  // Tube Segment 1 Initialization
  parameter Modelica.Units.SI.AbsolutePressure[geometry.nV] ps_start_tube_s1=
      linspace_1D(
      p_a_start_tube_s1,
      p_b_start_tube_s1,
      geometry.nV) "Pressure" annotation (Dialog(tab="Tube Initialization", group="Segment 1 Start Value: Absolute Pressure"));
  parameter Modelica.Units.SI.AbsolutePressure p_a_start_tube_s1=Medium_tube.p_default
    "Pressure at port a" annotation (Dialog(tab="Tube Initialization", group="Segment 1 Start Value: Absolute Pressure"));
  parameter Modelica.Units.SI.AbsolutePressure p_b_start_tube_s1=p_a_start_tube_s1 + (if
      m_flow_a_start_tube > 0 then -0.3e3 elseif m_flow_a_start_tube < 0 then -0.3e3
       else 0) "Pressure at port b" annotation (Dialog(tab="Tube Initialization",
        group="Segment 1 Start Value: Absolute Pressure"));
  parameter Modelica.Units.SI.Temperature Ts_start_tube_s1[geometry.nV]=linspace_1D(
      T_a_start_tube_s1,
      T_b_start_tube_s1,
      geometry.nV) "Temperature" annotation (Evaluate=true, Dialog(
      tab="Tube Initialization",
      group="Segment 1 Start Value: Temperature",
      enable=use_Ts_start_tube));
  parameter Modelica.Units.SI.Temperature T_a_start_tube_s1=Medium_tube.T_default
    "Temperature at port a" annotation (Dialog(
      tab="Tube Initialization",
      group="Segment 1 Start Value: Temperature",
      enable=use_Ts_start_tube));
  parameter Modelica.Units.SI.Temperature T_b_start_tube_s1=T_a_start_tube_s1
    "Temperature at port b" annotation (Dialog(
      tab="Tube Initialization",
      group="Segment 1 Start Value: Temperature",
      enable=use_Ts_start_tube));
  parameter Modelica.Units.SI.SpecificEnthalpy[geometry.nV] hs_start_tube_s1=if not
      use_Ts_start_tube then linspace_1D(
      h_a_start_tube_s1,
      h_b_start_tube_s1,
      geometry.nV) else {Medium_tube.specificEnthalpy_pTX(
      ps_start_tube_s1[i],
      Ts_start_tube_s1[i],
      Xs_start_tube[i, 1:Medium_tube.nX]) for i in 1:geometry.nV}
    "Specific enthalpy" annotation (Dialog(
      tab="Tube Initialization",
      group="Segment 1 Start Value: Specific Enthalpy",
      enable=not use_Ts_start_tube));
  parameter Modelica.Units.SI.SpecificEnthalpy h_a_start_tube_s1=
      Medium_tube.specificEnthalpy_pTX(
      p_a_start_tube_s1,
      T_a_start_tube_s1,
      X_a_start_tube) "Specific enthalpy at port a" annotation (Dialog(
      tab="Tube Initialization",
      group="Segment 1 Start Value: Specific Enthalpy",
      enable=not use_Ts_start_tube));
  parameter Modelica.Units.SI.SpecificEnthalpy h_b_start_tube_s1=
      Medium_tube.specificEnthalpy_pTX(
      p_b_start_tube_s1,
      T_b_start_tube_s1,
      X_b_start_tube) "Specific enthalpy at port b" annotation (Dialog(
      tab="Tube Initialization",
      group="Segment 1 Start Value: Specific Enthalpy",
      enable=not use_Ts_start_tube));

  // Tube Segment 2 Initialization
  parameter Modelica.Units.SI.AbsolutePressure[geometry.nV] ps_start_tube_s2=
      linspace_1D(
      p_b_start_tube_s1,
      p_a_start_tube_s3,
      geometry.nV) "Pressure" annotation (Dialog(tab="Tube Initialization", group="Segment 2 Start Value: Absolute Pressure"));
  parameter Modelica.Units.SI.Temperature Ts_start_tube_s2[geometry.nV]=linspace_1D(
      T_b_start_tube_s1,
      T_a_start_tube_s3,
      geometry.nV) "Temperature" annotation (Evaluate=true, Dialog(
      tab="Tube Initialization",
      group="Segment 2 Start Value: Temperature",
      enable=use_Ts_start_tube));
  parameter Modelica.Units.SI.SpecificEnthalpy[geometry.nV] hs_start_tube_s2=if not
      use_Ts_start_tube then linspace_1D(
      h_b_start_tube_s1,
      h_a_start_tube_s3,
      geometry.nV) else {Medium_tube.specificEnthalpy_pTX(
      ps_start_tube_s2[i],
      Ts_start_tube_s2[i],
      Xs_start_tube[i, 1:Medium_tube.nX]) for i in 1:geometry.nV}
    "Specific enthalpy" annotation (Dialog(
      tab="Tube Initialization",
      group="Segment 2 Start Value: Specific Enthalpy",
      enable=not use_Ts_start_tube));

  // Tube Creep Segment Initialization
  parameter Modelica.Units.SI.AbsolutePressure[geometry.nV] ps_start_tube_creep=
      linspace_1D(
      p_b_start_tube_s1,
      p_a_start_tube_s3,
      geometry.nV) "Pressure" annotation (Dialog(tab="Tube Initialization", group="Creep Segment Start Value: Absolute Pressure"));
  parameter Modelica.Units.SI.Temperature Ts_start_tube_creep[geometry.nV]=linspace_1D(
      T_b_start_tube_s1,
      T_a_start_tube_s3,
      geometry.nV) "Temperature" annotation (Evaluate=true, Dialog(
      tab="Tube Initialization",
      group="Creep Segment Start Value: Temperature",
      enable=use_Ts_start_tube));
  parameter Modelica.Units.SI.SpecificEnthalpy[geometry.nV] hs_start_tube_creep=if not
      use_Ts_start_tube then linspace_1D(
      h_b_start_tube_s1,
      h_a_start_tube_s3,
      geometry.nV) else {Medium_tube.specificEnthalpy_pTX(
      ps_start_tube_s2[i],
      Ts_start_tube_s2[i],
      Xs_start_tube[i, 1:Medium_tube.nX]) for i in 1:geometry.nV}
    "Specific enthalpy" annotation (Dialog(
      tab="Tube Initialization",
      group="Creep Segment Start Value: Specific Enthalpy",
      enable=not use_Ts_start_tube));

  // Tube Segment 3 Initialization
  parameter Modelica.Units.SI.AbsolutePressure[geometry.nV] ps_start_tube_s3=
      linspace_1D(
      p_a_start_tube_s3,
      p_b_start_tube_s3,
      geometry.nV) "Pressure" annotation (Dialog(tab="Tube Initialization", group="Segment 3 Start Value: Absolute Pressure"));
  parameter Modelica.Units.SI.AbsolutePressure p_a_start_tube_s3=p_b_start_tube_s1 + (if
      m_flow_a_start_tube > 0 then -0.3e3 elseif m_flow_a_start_tube < 0 then -0.3e3
       else 0) "Pressure at port a" annotation (Dialog(tab="Tube Initialization", group="Segment 3 Start Value: Absolute Pressure"));
  parameter Modelica.Units.SI.AbsolutePressure p_b_start_tube_s3=p_a_start_tube_s3 + (if
      m_flow_a_start_tube > 0 then -0.3e3 elseif m_flow_a_start_tube < 0 then -0.3e3
       else 0) "Pressure at port b" annotation (Dialog(tab="Tube Initialization",
        group="Segment 3 Start Value: Absolute Pressure"));
  parameter Modelica.Units.SI.Temperature Ts_start_tube_s3[geometry.nV]=linspace_1D(
      T_a_start_tube_s3,
      T_b_start_tube_s3,
      geometry.nV) "Temperature" annotation (Evaluate=true, Dialog(
      tab="Tube Initialization",
      group="Segment 3 Start Value: Temperature",
      enable=use_Ts_start_tube));
  parameter Modelica.Units.SI.Temperature T_a_start_tube_s3=T_b_start_tube_s1
    "Temperature at port a" annotation (Dialog(
      tab="Tube Initialization",
      group="Segment 3 Start Value: Temperature",
      enable=use_Ts_start_tube));
  parameter Modelica.Units.SI.Temperature T_b_start_tube_s3=T_a_start_tube_s3
    "Temperature at port b" annotation (Dialog(
      tab="Tube Initialization",
      group="Segment 3 Start Value: Temperature",
      enable=use_Ts_start_tube));
  parameter Modelica.Units.SI.SpecificEnthalpy[geometry.nV] hs_start_tube_s3=if not
      use_Ts_start_tube then linspace_1D(
      h_a_start_tube_s3,
      h_b_start_tube_s3,
      geometry.nV) else {Medium_tube.specificEnthalpy_pTX(
      ps_start_tube_s3[i],
      Ts_start_tube_s3[i],
      Xs_start_tube[i, 1:Medium_tube.nX]) for i in 1:geometry.nV}
    "Specific enthalpy" annotation (Dialog(
      tab="Tube Initialization",
      group="Segment 3 Start Value: Specific Enthalpy",
      enable=not use_Ts_start_tube));
  parameter Modelica.Units.SI.SpecificEnthalpy h_a_start_tube_s3=
      Medium_tube.specificEnthalpy_pTX(
      p_a_start_tube_s3,
      T_a_start_tube_s3,
      X_a_start_tube) "Specific enthalpy at port a" annotation (Dialog(
      tab="Tube Initialization",
      group="Segment 3 Start Value: Specific Enthalpy",
      enable=not use_Ts_start_tube));
  parameter Modelica.Units.SI.SpecificEnthalpy h_b_start_tube_s3=
      Medium_tube.specificEnthalpy_pTX(
      p_b_start_tube_s3,
      T_b_start_tube_s3,
      X_b_start_tube) "Specific enthalpy at port b" annotation (Dialog(
      tab="Tube Initialization",
      group="Segment 3 Start Value: Specific Enthalpy",
      enable=not use_Ts_start_tube));

  // Tube Initialization - General Part 2
  parameter Modelica.Units.SI.MassFraction Xs_start_tube[geometry.nV,Medium_tube.nX]=
     linspaceRepeat_1D(
      X_a_start_tube,
      X_b_start_tube,
      geometry.nV) "Mass fraction" annotation (Dialog(
      tab="Tube Initialization",
      group="Start Value: Species Mass Fraction",
      enable=Medium_tube.nXi > 0));
  parameter Modelica.Units.SI.MassFraction X_a_start_tube[Medium_tube.nX]=
      Medium_tube.X_default "Mass fraction at port a" annotation (Dialog(tab="Tube Initialization",
        group="Start Value: Species Mass Fraction"));
  parameter Modelica.Units.SI.MassFraction X_b_start_tube[Medium_tube.nX]=
      X_a_start_tube "Mass fraction at port b" annotation (Dialog(tab="Tube Initialization",
        group="Start Value: Species Mass Fraction"));
  parameter TRANSFORM.Units.ExtraProperty Cs_start_tube[geometry.nV,Medium_tube.nC]=
      linspaceRepeat_1D(
      C_a_start_tube,
      C_b_start_tube,
      geometry.nV) "Mass-Specific value" annotation (Dialog(
      tab="Tube Initialization",
      group="Start Value: Trace Substances",
      enable=Medium_tube.nC > 0));
  parameter TRANSFORM.Units.ExtraProperty C_a_start_tube[Medium_tube.nC]=fill(0,
      Medium_tube.nC) "Mass-Specific value at port a" annotation (Dialog(tab="Tube Initialization",
        group="Start Value: Trace Substances"));
  parameter TRANSFORM.Units.ExtraProperty C_b_start_tube[Medium_tube.nC]=
      C_a_start_tube "Mass-Specific value at port b" annotation (Dialog(tab="Tube Initialization",
        group="Start Value: Trace Substances"));
  parameter Modelica.Units.SI.MassFlowRate[geometry.nV + 1] m_flows_start_tube=linspace(
      m_flow_a_start_tube,
      -m_flow_b_start_tube,
      geometry.nV + 1) "Mass flow rates" annotation (Evaluate=true, Dialog(tab="Tube Initialization",
        group="Start Value: Mass Flow Rate"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_a_start_tube=0
    "Mass flow rate at port_a" annotation (Dialog(tab="Tube Initialization", group="Start Value: Mass Flow Rate"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_b_start_tube=-m_flow_a_start_tube
    "Mass flow rate at port_b" annotation (Dialog(tab="Tube Initialization", group="Start Value: Mass Flow Rate"));

  // Wall Initialization
  parameter Modelica.Units.SI.Temperature Ts_wall_start_s1[geometry.nR,geometry.nV]=
      linspaceRepeat_1D(
      Ts_wall_start_tubeSide_s1,
      if counterCurrent then Modelica.Math.Vectors.reverse(Ts_wall_start_shellSide_s3)
         else Ts_wall_start_shellSide_s3,
      geometry.nR) "Tube wall temperature"
    annotation (Dialog(tab="Wall Initialization", group="Segment 1 Start Value: Temperature"));
  parameter Modelica.Units.SI.Temperature Ts_wall_start_tubeSide_s1[geometry.nV]=
      Medium_tube.temperature_phX(
      ps_start_tube_s1,
      hs_start_tube_s1,
      Xs_start_tube) "Tube side wall temperature"
    annotation (Dialog(tab="Wall Initialization", group="Segment 1 Start Value: Temperature"));
  parameter Modelica.Units.SI.Temperature Ts_wall_start_shellSide_s3[geometry.nV]=
      Medium_shell.temperature_phX(
      ps_start_shell_s3,
      hs_start_shell_s3,
      Xs_start_shell) "Shell side wall temperature"
    annotation (Dialog(tab="Wall Initialization", group="Segment 1 Start Value: Temperature"));
  parameter Modelica.Units.SI.Temperature Ts_wall_start_s2[geometry.nR,geometry.nV]=
      linspaceRepeat_1D(
      Ts_wall_start_tubeSide_s2,
      if counterCurrent then Modelica.Math.Vectors.reverse(Ts_wall_start_shellSide_s2)
         else Ts_wall_start_shellSide_s2,
      geometry.nR) "Tube wall temperature"
    annotation (Dialog(tab="Wall Initialization", group="Segment 2 Start Value: Temperature"));
  parameter Modelica.Units.SI.Temperature Ts_wall_start_tubeSide_s2[geometry.nV]=
      Medium_tube.temperature_phX(
      ps_start_tube_s2,
      hs_start_tube_s2,
      Xs_start_tube) "Tube side wall temperature"
    annotation (Dialog(tab="Wall Initialization", group="Segment 2 Start Value: Temperature"));
  parameter Modelica.Units.SI.Temperature Ts_wall_start_shellSide_s2[geometry.nV]=
      Medium_shell.temperature_phX(
      ps_start_shell_s2,
      hs_start_shell_s2,
      Xs_start_shell) "Shell side wall temperature"
    annotation (Dialog(tab="Wall Initialization", group="Segment 2 Start Value: Temperature"));
  parameter Modelica.Units.SI.Temperature Ts_wall_start_s3[geometry.nR,geometry.nV]=
      linspaceRepeat_1D(
      Ts_wall_start_tubeSide_s3,
      if counterCurrent then Modelica.Math.Vectors.reverse(Ts_wall_start_shellSide_s1)
         else Ts_wall_start_shellSide_s1,
      geometry.nR) "Tube wall temperature"
    annotation (Dialog(tab="Wall Initialization", group="Segment 3 Start Value: Temperature"));
  parameter Modelica.Units.SI.Temperature Ts_wall_start_tubeSide_s3[geometry.nV]=
      Medium_tube.temperature_phX(
      ps_start_tube_s3,
      hs_start_tube_s3,
      Xs_start_tube) "Tube side wall temperature"
    annotation (Dialog(tab="Wall Initialization", group="Segment 3 Start Value: Temperature"));
  parameter Modelica.Units.SI.Temperature Ts_wall_start_shellSide_s1[geometry.nV]=
      Medium_shell.temperature_phX(
      ps_start_shell_s1,
      hs_start_shell_s1,
      Xs_start_shell) "Shell side wall temperature"
    annotation (Dialog(tab="Wall Initialization", group="Segment 3 Start Value: Temperature"));
   parameter Modelica.Units.SI.Temperature Ts_wall_start_creep[geometry.nR,geometry.nV]=
      linspaceRepeat_1D(
      Ts_wall_start_tubeSide_creep,
      if counterCurrent then Modelica.Math.Vectors.reverse(Ts_wall_start_shellSide_s2)
         else Ts_wall_start_shellSide_s2,
      geometry.nR) "Tube wall temperature"
    annotation (Dialog(tab="Wall Initialization", group="Creep Segment Start Value: Temperature"));
  parameter Modelica.Units.SI.Temperature Ts_wall_start_tubeSide_creep[geometry.nV]=
      Medium_tube.temperature_phX(
      ps_start_tube_creep,
      hs_start_tube_creep,
      Xs_start_tube) "Tube side wall temperature"
    annotation (Dialog(tab="Wall Initialization", group="Creep Segment Start Value: Temperature"));

  // Advanced
  parameter Modelica.Fluid.Types.Dynamics energyDynamics[3]={Dynamics.DynamicFreeInitial,
      Dynamics.DynamicFreeInitial,Dynamics.DynamicFreeInitial}
    "Formulation of energy balances {shell,tube,tubeWall}"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics[2]=energyDynamics[1:2]
    "Formulation of mass balances {shell,tube}"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics traceDynamics[2]=massDynamics
    "Formulation of trace substance balances {shell,tube}"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  parameter Modelica.Fluid.Types.Dynamics momentumDynamics[2]={Dynamics.SteadyState,
      Dynamics.SteadyState} "Formulation of momentum balances {shell,tube}"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  parameter Boolean allowFlowReversal_shell=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Advanced", group="Shell Side"));
  parameter Boolean exposeState_a_shell=true
    "=true, p is calculated at port_a else m_flow"
    annotation (Dialog(tab="Advanced", group="Shell Side"));
  parameter Boolean exposeState_b_shell=false
    "=true, p is calculated at port_b else m_flow"
    annotation (Dialog(tab="Advanced", group="Shell Side"));
  parameter Boolean useLumpedPressure_shell=false
    "=true to lump pressure states together"
    annotation (Dialog(tab="Advanced", group="Shell Side"), Evaluate=true);
  parameter LumpedLocation lumpPressureAt_shell=LumpedLocation.port_a
    "Location of pressure for flow calculations" annotation (Dialog(
      tab="Advanced",
      group="Shell Side",
      enable=if useLumpedPressure_shell and not exposeState_a_shell and not exposeState_b_shell then true else false), Evaluate=true);
  parameter Boolean useInnerPortProperties_shell=false
    "=true to take port properties for flow models from internal control volumes"
    annotation (Dialog(tab="Advanced", group="Shell Side"), Evaluate=true);
  parameter Boolean allowFlowReversal_tube=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Advanced", group="Tube Side"));
  parameter Boolean exposeState_a_tube=true
    "=true, p is calculated at port_a else m_flow"
    annotation (Dialog(tab="Advanced", group="Tube Side"));
  parameter Boolean exposeState_b_tube=false
    "=true, p is calculated at port_b else m_flow"
    annotation (Dialog(tab="Advanced", group="Tube Side"));
  parameter Boolean useLumpedPressure_tube=false
    "=true to lump pressure states together"
    annotation (Dialog(tab="Advanced", group="Tube Side"), Evaluate=true);
  parameter LumpedLocation lumpPressureAt_tube=LumpedLocation.port_a
    "Location of pressure for flow calculations" annotation (Dialog(
      tab="Advanced",
      group="Tube Side",
      enable=if useLumpedPressure_tube and not exposeState_a_tube and not exposeState_b_tube then true else false), Evaluate=true);
  parameter Boolean useInnerPortProperties_tube=false
    "=true to take port properties for flow models from internal control volumes"
    annotation (Dialog(tab="Advanced", group="Tube Side"), Evaluate=true);
  parameter Boolean adiabaticDims[2]={false,false}
    "=true, toggle off conduction heat transfer in dimension {1,2}"
    annotation (Dialog(tab="Advanced", group="Tube Wall"));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.CounterFlow counterFlow_s2(
      counterCurrent=counterCurrent, n=geometry.nV) annotation (Placement(
        transformation(
        extent={{-5,-6},{5,6}},
        rotation=90,
        origin={0,27})));
  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.Conduction_2D tubeWall_s2(
    nParallel=tube_s2.nParallel,
    energyDynamics=energyDynamics[3],
    adiabaticDims=adiabaticDims,
    redeclare package Material = Material_tubeWall,
    T_a1_start=sum(Ts_wall_start_tubeSide_s2)/size(Ts_wall_start_tubeSide_s2, 1),
    T_b1_start=sum(Ts_wall_start_shellSide_s2)/size(Ts_wall_start_shellSide_s2, 1),
    T_a2_start=(Ts_wall_start_tubeSide_s2[1] + (if counterCurrent then
        Ts_wall_start_shellSide_s2[end] else Ts_wall_start_shellSide_s2[1]))/2,
    T_b2_start=(Ts_wall_start_tubeSide_s2[end] + (if counterCurrent then
        Ts_wall_start_shellSide_s2[1] else Ts_wall_start_shellSide_s2[end]))/2,
    Ts_start=Ts_wall_start_s2,
    exposeState_a1=if tube_s2.heatTransfer.flagIdeal == 1 then false else true,
    exposeState_b1=if shell_s2.heatTransfer.flagIdeal == 1 then false else true,
    exposeState_a2=exposeState_a_tube,
    exposeState_b2=exposeState_b_tube,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_2D_r_z
        (
        r_inner=0.5*sum(geometry.dimensions_tube)/geometry.nV,
        r_outer=0.5*sum(geometry.dimensions_tube_outer)/geometry.nV,
        length_z=sum(geometry.dlengths_tube_s2),
        drs=geometry.drs,
        nR=geometry.nR,
        nZ=geometry.nV,
        dzs=transpose({fill(geometry.dlengths_tube_s2[i], geometry.nR) for i in 1:
            geometry.nV}))) annotation (Placement(transformation(
        extent={{-7,6},{7,-6}},
        rotation=90,
        origin={0,-31})));
  TRANSFORM.HeatExchangers.BaseClasses.Summary summary(
    R_tubeWall=log(tubeWall_s2.geometry.r_outer/tubeWall_s2.geometry.r_inner)/(2*
        Modelica.Constants.pi*geometry.length_tube_s2*tubeWall_s2.summary.lambda_effective),
    R_shell=if shell_s2.heatTransfer.flagIdeal == 1 then 0 else 1/(sum({shell_s2.heatTransfer.alphas[
        i, 1]*shell_s2.geometry.surfaceAreas[i, 1] for i in 1:shell_s2.nV})*shell_s2.nParallel
        /shell_s2.nV),
    R_tube=if tube_s2.heatTransfer.flagIdeal == 1 then 0 else 1/(sum({tube_s2.heatTransfer.alphas[
        i, 1]*tube_s2.geometry.surfaceAreas[i, 1] for i in 1:tube_s2.nV})*tube_s2.nParallel
        /tube_s2.nV))
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));

  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi adiabaticWall_a2_s2(nPorts=
        geometry.nR)
    annotation (Placement(transformation(extent={{-28,-38},{-12,-24}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi adiabaticWall_b2_s2(nPorts=
        geometry.nR)
    annotation (Placement(transformation(extent={{28,-38},{12,-24}})));
  replaceable model InternalTraceGen_tube =
      TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
    annotation (Dialog(group="Trace Mass Transfer"),choicesAllMatching=true);
  replaceable model InternalTraceGen_shell =
      TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
    annotation (Dialog(group="Trace Mass Transfer"),choicesAllMatching=true);
  replaceable model InternalHeatGen_tube =
      TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration
      annotation (Dialog(group="Heat Transfer"),choicesAllMatching=true);
  replaceable model InternalHeatGen_shell =
      TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration
      annotation (Dialog(group="Heat Transfer"),choicesAllMatching=true);
  extends TRANSFORM.Utilities.Visualizers.IconColorMap(
    showColors=systemTF.showColors,
    val_min=systemTF.val_min,
    val_max=systemTF.val_max,
    val=shell_s2.summary.T_effective);
  Real dynColor_tube[3]=
      Modelica.Mechanics.MultiBody.Visualizers.Colors.scalarToColor(
      tube_s2.summary.T_effective,
      val_min,
      val_max,
      colorMap(n_colors));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface shell_s1(
    redeclare package Medium = Medium_shell,
    use_HeatTransfer=true,
    redeclare model HeatTransfer = HeatTransfer_shell,
    use_Ts_start=use_Ts_start_shell,
    p_a_start=p_a_start_shell_s1,
    p_b_start=p_b_start_shell_s1,
    T_a_start=T_a_start_shell_s1,
    T_b_start=T_b_start_shell_s1,
    h_a_start=h_a_start_shell_s1,
    h_b_start=h_b_start_shell_s1,
    ps_start=ps_start_shell_s1,
    hs_start=hs_start_shell_s1,
    Ts_start=Ts_start_shell_s1,
    nParallel=nParallel,
    Ts_wall(start=transpose(TRANSFORM.Math.fillArray_1D(Ts_wall_start_shellSide_s1,
          geometry.nSurfaces_shell))),
    redeclare model FlowModel = FlowModel_shell,
    energyDynamics=energyDynamics[1],
    massDynamics=massDynamics[1],
    traceDynamics=traceDynamics[1],
    exposeState_a=exposeState_a_shell,
    exposeState_b=exposeState_b_shell,
    momentumDynamics=momentumDynamics[1],
    useInnerPortProperties=useInnerPortProperties_shell,
    useLumpedPressure=useLumpedPressure_shell,
    lumpPressureAt=lumpPressureAt_shell,
    m_flow_a_start=m_flow_a_start_shell,
    m_flow_b_start=m_flow_b_start_shell,
    m_flows_start=m_flows_start_shell,
    Xs_start=Xs_start_shell,
    Cs_start=Cs_start_shell,
    X_a_start=X_a_start_shell,
    X_b_start=X_b_start_shell,
    C_a_start=C_a_start_shell,
    C_b_start=C_b_start_shell,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.GenericPipe
        (
        nV=geometry.nV,
        crossAreas=geometry.crossAreas_shell,
        perimeters=geometry.perimeters_shell,
        dlengths=geometry.dlengths_shell_s1,
        roughnesses=geometry.roughnesses_shell,
        surfaceAreas=geometry.surfaceAreas_shell_s1,
        dheights=geometry.dheights_shell_s1,
        height_a=geometry.height_a_shell,
        dimensions=geometry.dimensions_shell,
        nSurfaces=geometry.nSurfaces_shell,
        angles=geometry.angles_shell),
    redeclare model InternalHeatGen = InternalHeatGen_shell,
    redeclare model InternalTraceGen = InternalTraceGen_shell) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,46})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface tube_s1(
    redeclare package Medium = Medium_tube,
    use_HeatTransfer=true,
    redeclare model HeatTransfer = HeatTransfer_tube,
    use_Ts_start=use_Ts_start_tube,
    p_a_start=p_a_start_tube_s1,
    p_b_start=p_b_start_tube_s1,
    T_a_start=T_a_start_tube_s1,
    T_b_start=T_b_start_tube_s1,
    h_a_start=h_a_start_tube_s1,
    h_b_start=h_b_start_tube_s1,
    ps_start=ps_start_tube_s1,
    hs_start=hs_start_tube_s1,
    Ts_start=Ts_start_tube_s1,
    Ts_wall(start=transpose(TRANSFORM.Math.fillArray_1D(Ts_wall_start_tubeSide_s1,
          geometry.nSurfaces_tube))),
    redeclare model FlowModel = FlowModel_tube,
    nParallel=geometry.nTubes_Total*nParallel,
    energyDynamics=energyDynamics[2],
    massDynamics=massDynamics[2],
    traceDynamics=traceDynamics[2],
    exposeState_a=exposeState_a_tube,
    exposeState_b=exposeState_b_tube,
    momentumDynamics=momentumDynamics[2],
    useInnerPortProperties=useInnerPortProperties_tube,
    useLumpedPressure=useLumpedPressure_tube,
    lumpPressureAt=lumpPressureAt_tube,
    m_flow_a_start=m_flow_a_start_tube,
    m_flow_b_start=m_flow_b_start_tube,
    m_flows_start=m_flows_start_tube,
    Xs_start=Xs_start_tube,
    Cs_start=Cs_start_tube,
    X_a_start=X_a_start_tube,
    X_b_start=X_b_start_tube,
    C_a_start=C_a_start_tube,
    C_b_start=C_b_start_tube,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.GenericPipe
        (
        nV=geometry.nV,
        dimensions=geometry.dimensions_tube,
        dlengths=geometry.dlengths_tube_s1,
        roughnesses=geometry.roughnesses_tube,
        surfaceAreas=geometry.surfaceAreas_tube_s1,
        dheights=geometry.dheights_tube_s1,
        height_a=geometry.height_a_tube,
        crossAreas=geometry.crossAreas_tube,
        perimeters=geometry.perimeters_tube,
        nSurfaces=geometry.nSurfaces_tube,
        angles=geometry.angles_tube),
    redeclare model InternalTraceGen = InternalTraceGen_tube,
    redeclare model InternalHeatGen = InternalHeatGen_tube) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-80})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface shell_s2(
    redeclare package Medium = Medium_shell,
    use_HeatTransfer=true,
    redeclare model HeatTransfer = HeatTransfer_shell,
    use_Ts_start=use_Ts_start_shell,
    p_a_start=p_b_start_shell_s1,
    p_b_start=p_a_start_shell_s3,
    T_a_start=T_b_start_shell_s1,
    T_b_start=T_a_start_shell_s3,
    h_a_start=h_b_start_shell_s1,
    h_b_start=h_a_start_shell_s3,
    ps_start=ps_start_shell_s2,
    hs_start=hs_start_shell_s2,
    Ts_start=Ts_start_shell_s2,
    nParallel=nParallel,
    Ts_wall(start=transpose(TRANSFORM.Math.fillArray_1D(Ts_wall_start_shellSide_s2,
          geometry.nSurfaces_shell))),
    redeclare model FlowModel = FlowModel_shell,
    energyDynamics=energyDynamics[1],
    massDynamics=massDynamics[1],
    traceDynamics=traceDynamics[1],
    exposeState_a=exposeState_a_shell,
    exposeState_b=exposeState_b_shell,
    momentumDynamics=momentumDynamics[1],
    useInnerPortProperties=useInnerPortProperties_shell,
    useLumpedPressure=useLumpedPressure_shell,
    lumpPressureAt=lumpPressureAt_shell,
    m_flow_a_start=m_flow_a_start_shell,
    m_flow_b_start=m_flow_b_start_shell,
    m_flows_start=m_flows_start_shell,
    Xs_start=Xs_start_shell,
    Cs_start=Cs_start_shell,
    X_a_start=X_a_start_shell,
    X_b_start=X_b_start_shell,
    C_a_start=C_a_start_shell,
    C_b_start=C_b_start_shell,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.GenericPipe
        (
        nV=geometry.nV,
        crossAreas=geometry.crossAreas_shell,
        perimeters=geometry.perimeters_shell,
        dlengths=geometry.dlengths_shell_s2,
        roughnesses=geometry.roughnesses_shell,
        surfaceAreas=geometry.surfaceAreas_shell_s2,
        dheights=geometry.dheights_shell_s2,
        height_a=geometry.height_a_shell,
        dimensions=geometry.dimensions_shell,
        nSurfaces=geometry.nSurfaces_shell,
        angles=geometry.angles_shell),
    redeclare model InternalHeatGen = InternalHeatGen_shell,
    redeclare model InternalTraceGen = InternalTraceGen_shell) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={0,46})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface shell_s3(
    redeclare package Medium = Medium_shell,
    use_HeatTransfer=true,
    redeclare model HeatTransfer = HeatTransfer_shell,
    use_Ts_start=use_Ts_start_shell,
    p_a_start=p_a_start_shell_s3,
    p_b_start=p_b_start_shell_s3,
    T_a_start=T_a_start_shell_s3,
    T_b_start=T_b_start_shell_s3,
    h_a_start=h_a_start_shell_s3,
    h_b_start=h_b_start_shell_s3,
    ps_start=ps_start_shell_s3,
    hs_start=hs_start_shell_s3,
    Ts_start=Ts_start_shell_s3,
    nParallel=nParallel,
    Ts_wall(start=transpose(TRANSFORM.Math.fillArray_1D(Ts_wall_start_shellSide_s3,
          geometry.nSurfaces_shell))),
    redeclare model FlowModel = FlowModel_shell,
    energyDynamics=energyDynamics[1],
    massDynamics=massDynamics[1],
    traceDynamics=traceDynamics[1],
    exposeState_a=exposeState_a_shell,
    exposeState_b=exposeState_b_shell,
    momentumDynamics=momentumDynamics[1],
    useInnerPortProperties=useInnerPortProperties_shell,
    useLumpedPressure=useLumpedPressure_shell,
    lumpPressureAt=lumpPressureAt_shell,
    m_flow_a_start=m_flow_a_start_shell,
    m_flow_b_start=m_flow_b_start_shell,
    m_flows_start=m_flows_start_shell,
    Xs_start=Xs_start_shell,
    Cs_start=Cs_start_shell,
    X_a_start=X_a_start_shell,
    X_b_start=X_b_start_shell,
    C_a_start=C_a_start_shell,
    C_b_start=C_b_start_shell,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.GenericPipe
        (
        nV=geometry.nV,
        crossAreas=geometry.crossAreas_shell,
        perimeters=geometry.perimeters_shell,
        dlengths=geometry.dlengths_shell_s3,
        roughnesses=geometry.roughnesses_shell,
        surfaceAreas=geometry.surfaceAreas_shell_s3,
        dheights=geometry.dheights_shell_s3,
        height_a=geometry.height_a_shell,
        dimensions=geometry.dimensions_shell,
        nSurfaces=geometry.nSurfaces_shell,
        angles=geometry.angles_shell),
    redeclare model InternalHeatGen = InternalHeatGen_shell,
    redeclare model InternalTraceGen = InternalTraceGen_shell) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-50,46})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface tube_s2(
    redeclare package Medium = Medium_tube,
    use_HeatTransfer=true,
    redeclare model HeatTransfer = HeatTransfer_tube,
    use_Ts_start=use_Ts_start_tube,
    p_a_start=p_b_start_tube_s1,
    p_b_start=p_a_start_tube_s3,
    T_a_start=T_b_start_tube_s1,
    T_b_start=T_a_start_tube_s3,
    h_a_start=h_b_start_tube_s1,
    h_b_start=h_a_start_tube_s3,
    ps_start=ps_start_tube_s2,
    hs_start=hs_start_tube_s2,
    Ts_start=Ts_start_tube_s2,
    Ts_wall(start=transpose(TRANSFORM.Math.fillArray_1D(Ts_wall_start_tubeSide_s2,
          geometry.nSurfaces_tube))),
    redeclare model FlowModel = FlowModel_tube,
    nParallel=(geometry.nTubes_Total - geometry.nTubes_creep)*nParallel,
    energyDynamics=energyDynamics[2],
    massDynamics=massDynamics[2],
    traceDynamics=traceDynamics[2],
    exposeState_a=exposeState_a_tube,
    exposeState_b=exposeState_b_tube,
    momentumDynamics=momentumDynamics[2],
    useInnerPortProperties=useInnerPortProperties_tube,
    useLumpedPressure=useLumpedPressure_tube,
    lumpPressureAt=lumpPressureAt_tube,
    m_flow_a_start=m_flow_a_start_tube,
    m_flow_b_start=m_flow_b_start_tube,
    m_flows_start=m_flows_start_tube,
    Xs_start=Xs_start_tube,
    Cs_start=Cs_start_tube,
    X_a_start=X_a_start_tube,
    X_b_start=X_b_start_tube,
    C_a_start=C_a_start_tube,
    C_b_start=C_b_start_tube,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.GenericPipe
        (
        nV=geometry.nV,
        dimensions=geometry.dimensions_tube,
        dlengths=geometry.dlengths_tube_s2,
        roughnesses=geometry.roughnesses_tube,
        surfaceAreas=geometry.surfaceAreas_tube_s2,
        dheights=geometry.dheights_tube_s2,
        height_a=geometry.height_a_tube,
        crossAreas=geometry.crossAreas_tube,
        perimeters=geometry.perimeters_tube,
        nSurfaces=geometry.nSurfaces_tube,
        angles=geometry.angles_tube),
    redeclare model InternalTraceGen = InternalTraceGen_tube,
    redeclare model InternalHeatGen = InternalHeatGen_tube) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,-66})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface tube_s3(
    redeclare package Medium = Medium_tube,
    use_HeatTransfer=true,
    redeclare model HeatTransfer = HeatTransfer_tube,
    use_Ts_start=use_Ts_start_tube,
    p_a_start=p_a_start_tube_s3,
    p_b_start=p_b_start_tube_s3,
    T_a_start=T_a_start_tube_s3,
    T_b_start=T_b_start_tube_s3,
    h_a_start=h_a_start_tube_s3,
    h_b_start=h_b_start_tube_s3,
    ps_start=ps_start_tube_s3,
    hs_start=hs_start_tube_s3,
    Ts_start=Ts_start_tube_s3,
    Ts_wall(start=transpose(TRANSFORM.Math.fillArray_1D(Ts_wall_start_tubeSide_s3,
          geometry.nSurfaces_tube))),
    redeclare model FlowModel = FlowModel_tube,
    nParallel=geometry.nTubes_Total*nParallel,
    energyDynamics=energyDynamics[2],
    massDynamics=massDynamics[2],
    traceDynamics=traceDynamics[2],
    exposeState_a=exposeState_a_tube,
    exposeState_b=exposeState_b_tube,
    momentumDynamics=momentumDynamics[2],
    useInnerPortProperties=useInnerPortProperties_tube,
    useLumpedPressure=useLumpedPressure_tube,
    lumpPressureAt=lumpPressureAt_tube,
    m_flow_a_start=m_flow_a_start_tube,
    m_flow_b_start=m_flow_b_start_tube,
    m_flows_start=m_flows_start_tube,
    Xs_start=Xs_start_tube,
    Cs_start=Cs_start_tube,
    X_a_start=X_a_start_tube,
    X_b_start=X_b_start_tube,
    C_a_start=C_a_start_tube,
    C_b_start=C_b_start_tube,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.GenericPipe
        (
        nV=geometry.nV,
        dimensions=geometry.dimensions_tube,
        dlengths=geometry.dlengths_tube_s3,
        roughnesses=geometry.roughnesses_tube,
        surfaceAreas=geometry.surfaceAreas_tube_s3,
        dheights=geometry.dheights_tube_s3,
        height_a=geometry.height_a_tube,
        crossAreas=geometry.crossAreas_tube,
        perimeters=geometry.perimeters_tube,
        nSurfaces=geometry.nSurfaces_tube,
        angles=geometry.angles_tube),
    redeclare model InternalTraceGen = InternalTraceGen_tube,
    redeclare model InternalHeatGen = InternalHeatGen_tube) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,-80})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.CounterFlow counterFlow_s3(
      counterCurrent=counterCurrent, n=geometry.nV) annotation (Placement(
        transformation(
        extent={{-5,-6},{5,6}},
        rotation=90,
        origin={50,27})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.CounterFlow counterFlow_s1(
      counterCurrent=counterCurrent, n=geometry.nV) annotation (Placement(
        transformation(
        extent={{-5,-6},{5,6}},
        rotation=90,
        origin={-50,27})));
  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.Conduction_2D tubeWall_s3(
    nParallel=tube_s2.nParallel,
    energyDynamics=energyDynamics[3],
    adiabaticDims=adiabaticDims,
    redeclare package Material = Material_tubeWall,
    T_a1_start=sum(Ts_wall_start_tubeSide_s3)/size(Ts_wall_start_tubeSide_s3, 1),
    T_b1_start=sum(Ts_wall_start_shellSide_s1)/size(Ts_wall_start_shellSide_s1, 1),
    T_a2_start=(Ts_wall_start_tubeSide_s3[1] + (if counterCurrent then
        Ts_wall_start_shellSide_s1[end] else Ts_wall_start_shellSide_s1[1]))/2,
    T_b2_start=(Ts_wall_start_tubeSide_s3[end] + (if counterCurrent then
        Ts_wall_start_shellSide_s1[1] else Ts_wall_start_shellSide_s1[end]))/2,
    Ts_start=Ts_wall_start_s3,
    exposeState_a1=if tube_s2.heatTransfer.flagIdeal == 1 then false else true,
    exposeState_b1=if shell_s2.heatTransfer.flagIdeal == 1 then false else true,
    exposeState_a2=exposeState_a_tube,
    exposeState_b2=exposeState_b_tube,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_2D_r_z
        (
        r_inner=0.5*sum(geometry.dimensions_tube)/geometry.nV,
        r_outer=0.5*sum(geometry.dimensions_tube_outer)/geometry.nV,
        length_z=sum(geometry.dlengths_tube_s3),
        drs=geometry.drs,
        nR=geometry.nR,
        nZ=geometry.nV,
        dzs=transpose({fill(geometry.dlengths_tube_s3[i], geometry.nR) for i in 1:
            geometry.nV}))) annotation (Placement(transformation(
        extent={{-7,6},{7,-6}},
        rotation=90,
        origin={50,-31})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi adiabaticWall_a2_s3(nPorts=
        geometry.nR)
    annotation (Placement(transformation(extent={{22,-38},{38,-24}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi adiabaticWall_b2_s3(nPorts=
        geometry.nR)
    annotation (Placement(transformation(extent={{78,-38},{62,-24}})));
  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.Conduction_2D tubeWall_s1(
    nParallel=tube_s2.nParallel,
    energyDynamics=energyDynamics[3],
    adiabaticDims=adiabaticDims,
    redeclare package Material = Material_tubeWall,
    T_a1_start=sum(Ts_wall_start_tubeSide_s1)/size(Ts_wall_start_tubeSide_s1, 1),
    T_b1_start=sum(Ts_wall_start_shellSide_s3)/size(Ts_wall_start_shellSide_s3, 1),
    T_a2_start=(Ts_wall_start_tubeSide_s1[1] + (if counterCurrent then
        Ts_wall_start_shellSide_s3[end] else Ts_wall_start_shellSide_s3[1]))/2,
    T_b2_start=(Ts_wall_start_tubeSide_s1[end] + (if counterCurrent then
        Ts_wall_start_shellSide_s3[1] else Ts_wall_start_shellSide_s3[end]))/2,
    Ts_start=Ts_wall_start_s1,
    exposeState_a1=if tube_s2.heatTransfer.flagIdeal == 1 then false else true,
    exposeState_b1=if shell_s2.heatTransfer.flagIdeal == 1 then false else true,
    exposeState_a2=exposeState_a_tube,
    exposeState_b2=exposeState_b_tube,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_2D_r_z
        (
        r_inner=0.5*sum(geometry.dimensions_tube)/geometry.nV,
        r_outer=0.5*sum(geometry.dimensions_tube_outer)/geometry.nV,
        length_z=sum(geometry.dlengths_tube_s1),
        drs=geometry.drs,
        nR=geometry.nR,
        nZ=geometry.nV,
        dzs=transpose({fill(geometry.dlengths_tube_s1[i], geometry.nR) for i in 1:
            geometry.nV}))) annotation (Placement(transformation(
        extent={{-7,6},{7,-6}},
        rotation=90,
        origin={-50,-31})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi adiabaticWall_a2_s1(nPorts=
        geometry.nR)
    annotation (Placement(transformation(extent={{-78,-38},{-62,-24}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi adiabaticWall_b2_s1(nPorts=
        geometry.nR)
    annotation (Placement(transformation(extent={{-22,-38},{-38,-24}})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface tube_creep(
    redeclare package Medium = Medium_tube,
    use_HeatTransfer=true,
    redeclare model HeatTransfer = HeatTransfer_tube,
    use_Ts_start=use_Ts_start_tube,
    p_a_start=p_b_start_tube_s1,
    p_b_start=p_a_start_tube_s3,
    T_a_start=T_b_start_tube_s1,
    T_b_start=T_a_start_tube_s3,
    h_a_start=h_b_start_tube_s1,
    h_b_start=h_a_start_tube_s3,
    ps_start=ps_start_tube_creep,
    hs_start=hs_start_tube_creep,
    Ts_start=Ts_start_tube_creep,
    Ts_wall(start=transpose(TRANSFORM.Math.fillArray_1D(Ts_wall_start_tubeSide_creep,
          geometry.nSurfaces_tube))),
    redeclare model FlowModel = FlowModel_tube,
    nParallel=geometry.nTubes_creep*nParallel,
    energyDynamics=energyDynamics[2],
    massDynamics=massDynamics[2],
    traceDynamics=traceDynamics[2],
    exposeState_a=exposeState_a_tube,
    exposeState_b=exposeState_b_tube,
    momentumDynamics=momentumDynamics[2],
    useInnerPortProperties=useInnerPortProperties_tube,
    useLumpedPressure=useLumpedPressure_tube,
    lumpPressureAt=lumpPressureAt_tube,
    m_flow_a_start=m_flow_a_start_tube,
    m_flow_b_start=m_flow_b_start_tube,
    m_flows_start=m_flows_start_tube,
    Xs_start=Xs_start_tube,
    Cs_start=Cs_start_tube,
    X_a_start=X_a_start_tube,
    X_b_start=X_b_start_tube,
    C_a_start=C_a_start_tube,
    C_b_start=C_b_start_tube,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.GenericPipe
        (
        nV=geometry.nV,
        dimensions=geometry.dimensions_tube_creep,
        dlengths=geometry.dlengths_tube_s2,
        roughnesses=geometry.roughnesses_tube,
        surfaceAreas=geometry.surfaceAreas_tube_creep,
        dheights=geometry.dheights_tube_s2,
        height_a=geometry.height_a_tube,
        crossAreas=geometry.crossAreas_tube_creep,
        perimeters=geometry.perimeters_tube_creep,
        nSurfaces=geometry.nSurfaces_tube,
        angles=geometry.angles_tube),
    redeclare model InternalTraceGen = InternalTraceGen_tube,
    redeclare model InternalHeatGen = InternalHeatGen_tube) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,-88})));
  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.Conduction_2D tubeWall_creep(
    nParallel=tube_creep.nParallel,
    energyDynamics=energyDynamics[3],
    adiabaticDims=adiabaticDims,
    redeclare package Material = Material_tubeWall,
    T_a1_start=sum(Ts_wall_start_tubeSide_creep)/size(Ts_wall_start_tubeSide_creep,
        1),
    T_b1_start=sum(Ts_wall_start_shellSide_s2)/size(Ts_wall_start_shellSide_s2, 1),
    T_a2_start=(Ts_wall_start_tubeSide_creep[1] + (if counterCurrent then
        Ts_wall_start_shellSide_s2[end] else Ts_wall_start_shellSide_s2[1]))/2,
    T_b2_start=(Ts_wall_start_tubeSide_creep[end] + (if counterCurrent then
        Ts_wall_start_shellSide_s2[1] else Ts_wall_start_shellSide_s2[end]))/2,
    Ts_start=Ts_wall_start_s2,
    exposeState_a1=if tube_creep.heatTransfer.flagIdeal == 1 then false else true,
    exposeState_b1=if shell_s2.heatTransfer.flagIdeal == 1 then false else true,
    exposeState_a2=exposeState_a_tube,
    exposeState_b2=exposeState_b_tube,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_2D_r_z
        (
        r_inner=0.5*sum(geometry.dimensions_tube_creep)/geometry.nV,
        r_outer=0.5*sum(geometry.dimensions_tube_outer_creep)/geometry.nV,
        length_z=sum(geometry.dlengths_tube_s2),
        drs=geometry.drs,
        nR=geometry.nR,
        nZ=geometry.nV,
        dzs=transpose({fill(geometry.dlengths_tube_s2[i], geometry.nR) for i in 1:
            geometry.nV}))) annotation (Placement(transformation(
        extent={{-7,6},{7,-6}},
        rotation=90,
        origin={24,-13})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi adiabaticWall_a2_creep(nPorts=
        geometry.nR)
    annotation (Placement(transformation(extent={{-4,-20},{12,-6}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi adiabaticWall_b2_creep(nPorts=
        geometry.nR)
    annotation (Placement(transformation(extent={{52,-20},{36,-6}})));
  IARF_Models.Components.HXs.Temp_Average_Calculator Tavg(
    nV=geometry.nV,
    w1=tube_s2.nParallel,
    w2=tube_creep.nParallel)
    annotation (Placement(transformation(extent={{-6,2},{6,14}})));
equation
  //    SI.TemperatureDifference DT_lm "Log mean temperature difference";
  //    SI.ThermalConductance UA "Overall heat transfer conductance";
  //
  //    SI.CoefficientOfHeatTransfer U_shell "Overall heat transfer coefficient - shell side";
  //    SI.CoefficientOfHeatTransfer U_tube "Overall heat transfer coefficient - tube side";
  //
  //    SI.CoefficientOfHeatTransfer alphaAvg_shell "Average shell side heat transfer coefficient";
  //    SI.ThermalResistance R_shell;
  //
  //    SI.CoefficientOfHeatTransfer alphaAvg_tube;
  //    SI.ThermalResistance R_tube;
  //   alphaAvg_shell = sum(shell.heatTransfer.alphas)/geometry.nV;
  //   R_shell = 1/(alphaAvg_shell*sum(shell.surfaceAreas));
  //
  //   alphaAvg_tube = sum(tube.heatTransfer.alphas)/geometry.nV;
  //   R_tube = 1/(alphaAvg_tube*sum(tube.surfaceAreas));
  //
  //   DT_lm = SMR160.Models.Fluid.HeatExchangers.Utilities.Functions.LMTD(
  //             T_hi=shell.mediums[1].T,
  //             T_ho=shell.mediums[geometry.nV].T,
  //             T_ci=tube.mediums[1].T,
  //             T_co=tube.mediums[geometry.nV].T,
  //             counterCurrent=counterCurrent);
  //
  //   UA = SMR160.Models.Fluid.HeatExchangers.Utilities.Functions.UA(
  //             n=3,
  //             isSeries={true,true,true},
  //             R=[R_tube; 1e-6; R_shell]);
  //
  //   U_shell = UA/sum(shell.surfaceAreas);
  //   U_tube = UA/sum(tube.surfaceAreas);
  connect(shell_s1.port_a, port_a_shell)
    annotation (Line(points={{60,46},{100,46}}, color={0,127,255}));
  connect(tube_s1.port_a, port_a_tube) annotation (Line(points={{-60,-80},{-70,-80},{
          -70,0},{-100,0}}, color={0,127,255}));
  connect(shell_s2.port_a, shell_s1.port_b)
    annotation (Line(points={{10,46},{40,46}}, color={0,127,255}));
  connect(shell_s3.port_a, shell_s2.port_b)
    annotation (Line(points={{-40,46},{-10,46}}, color={0,127,255}));
  connect(shell_s3.port_b, port_b_shell)
    annotation (Line(points={{-60,46},{-100,46}}, color={0,127,255}));
  connect(tube_s1.port_b, tube_s2.port_a)
    annotation (Line(points={{-40,-80},{-26,-80},{-26,-66},{-10,-66}},
                                                   color={0,127,255}));
  connect(tube_s2.port_b, tube_s3.port_a)
    annotation (Line(points={{10,-66},{26,-66},{26,-80},{40,-80}},
                                                 color={0,127,255}));
  connect(adiabaticWall_a2_s2.port, tubeWall_s2.port_a2)
    annotation (Line(points={{-12,-31},{-6,-31}}, color={191,0,0}));
  connect(adiabaticWall_b2_s2.port, tubeWall_s2.port_b2)
    annotation (Line(points={{12,-31},{6,-31}}, color={191,0,0}));
  connect(counterFlow_s2.port_b, shell_s2.heatPorts[:, 1])
    annotation (Line(points={{4.44089e-16,32},{4.44089e-16,36},{0,36},{0,41}},
                                             color={191,0,0}));
  connect(counterFlow_s3.port_b, shell_s1.heatPorts[:, 1])
    annotation (Line(points={{50,32},{50,41}}, color={191,0,0}));
  connect(counterFlow_s1.port_b, shell_s3.heatPorts[:, 1])
    annotation (Line(points={{-50,32},{-50,41}}, color={191,0,0}));
  connect(adiabaticWall_a2_s3.port, tubeWall_s3.port_a2)
    annotation (Line(points={{38,-31},{44,-31}}, color={191,0,0}));
  connect(adiabaticWall_b2_s3.port, tubeWall_s3.port_b2)
    annotation (Line(points={{62,-31},{56,-31}}, color={191,0,0}));
  connect(adiabaticWall_a2_s1.port,tubeWall_s1. port_a2)
    annotation (Line(points={{-62,-31},{-56,-31}}, color={191,0,0}));
  connect(adiabaticWall_b2_s1.port,tubeWall_s1. port_b2)
    annotation (Line(points={{-38,-31},{-44,-31}}, color={191,0,0}));
  connect(tube_s3.port_b, port_b_tube)
    annotation (Line(points={{60,-80},{70,-80},{70,0},{100,0}}, color={0,127,255}));
  connect(tubeWall_s3.port_b1, counterFlow_s3.port_a)
    annotation (Line(points={{50,-24},{50,22}}, color={191,0,0}));
  connect(tubeWall_s1.port_b1,counterFlow_s1. port_a)
    annotation (Line(points={{-50,-24},{-50,22}}, color={191,0,0}));
  connect(tubeWall_s3.port_a1, tube_s3.heatPorts[:, 1])
    annotation (Line(points={{50,-38},{50,-75}}, color={191,0,0}));
  connect(tubeWall_s1.port_a1, tube_s1.heatPorts[:, 1])
    annotation (Line(points={{-50,-38},{-50,-75}}, color={191,0,0}));
  connect(tube_s1.port_b, tube_creep.port_a) annotation (Line(points={{-40,-80},{-26,
          -80},{-26,-88},{-10,-88}}, color={0,127,255}));
  connect(tube_creep.port_b, tube_s3.port_a) annotation (Line(points={{10,-88},{26,-88},
          {26,-80},{40,-80}}, color={0,127,255}));
  connect(tube_s2.heatPorts[:, 1], tubeWall_s2.port_a1)
    annotation (Line(points={{0,-61},{0,-38}}, color={191,0,0}));
  connect(adiabaticWall_a2_creep.port, tubeWall_creep.port_a2)
    annotation (Line(points={{12,-13},{18,-13}}, color={191,0,0}));
  connect(adiabaticWall_b2_creep.port, tubeWall_creep.port_b2)
    annotation (Line(points={{36,-13},{30,-13}}, color={191,0,0}));
  connect(tube_creep.heatPorts[:, 1], tubeWall_creep.port_a1)
    annotation (Line(points={{0,-83},{0,-74},{24,-74},{24,-20}}, color={191,0,0}));
  connect(Tavg.OutputVector, counterFlow_s2.port_a)
    annotation (Line(points={{0,14},{-2.77556e-16,22}}, color={191,0,0}));
  connect(tubeWall_s2.port_b1, Tavg.InputVector1) annotation (Line(points={{0,-24},{
          0,-18},{-3.6,-18},{-3.6,2}}, color={191,0,0}));
  connect(tubeWall_creep.port_b1, Tavg.InputVector2)
    annotation (Line(points={{24,-6},{24,-2},{3.6,-2},{3.6,2}}, color={191,0,0}));
  annotation (
    defaultComponentName="heatExchanger",
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Ellipse(
          extent={{10,28.5},{-10,-28.5}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_b_shell,
          origin={-100,45.5},
          rotation=360),
        Ellipse(
          extent={{10,28.5},{-10,-28.5}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_a_shell,
          origin={100,45.5},
          rotation=0),
        Rectangle(
          extent={{-90,2},{90,-2}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Forward,
          origin={0,-28},
          rotation=360),
        Rectangle(
          extent={{-90,16},{90,-16}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor=DynamicSelect({0,63,125}, if showColors then dynColor else {
              0,63,125}),
          origin={0,46},
          rotation=360),
        Rectangle(
          extent={{-90,26},{90,-26}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor=DynamicSelect({0,128,255}, if showColors then dynColor_tube
               else {0,128,255}),
          origin={0,0},
          rotation=360),
        Rectangle(
          extent={{-90,16},{90,-16}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor=DynamicSelect({0,63,125}, if showColors then dynColor else {
              0,63,125}),
          origin={0,-46},
          rotation=360),
        Rectangle(
          extent={{-90,2},{90,-2}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Forward,
          origin={0,28},
          rotation=360),
        Polygon(
          points={{-6,12},{20,0},{-6,-10},{-6,12}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,63,255},
          fillPattern=FillPattern.Solid,
          origin={38,0},
          rotation=360),
        Line(
          points={{45,0},{-45,0}},
          color={0,63,255},
          smooth=Smooth.None,
          origin={-13,0},
          rotation=360),
        Polygon(
          points={{6,11},{-20,-1},{6,-11},{6,11}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          origin={-40,46},
          rotation=360),
        Line(
          points={{45,0},{-45,0}},
          color={0,128,255},
          smooth=Smooth.None,
          origin={11,45},
          rotation=360),
        Line(
          points={{45,0},{-45,0}},
          color={0,128,255},
          smooth=Smooth.None,
          origin={11,-47},
          rotation=360),
        Ellipse(
          extent={{10,28.5},{-10,-28.5}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_a_tube,
          origin={-100,-0.5},
          rotation=0),
        Polygon(
          points={{6,11},{-20,-1},{6,-11},{6,11}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          origin={-40,-46},
          rotation=360),
        Ellipse(
          extent={{10,28.5},{-10,-28.5}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_b_tube,
          origin={100,-0.5},
          rotation=360),
        Text(
          extent={{-149,-68},{151,-108}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName))}),
    Documentation(info="<html>
<p>A generic heat exchanger for any relatively simple general purpose heat transfer process.</p>
<p><br>- Currently the nodes on the shell and tube side must be equal. The lengths do not however there are no geometry checks to ensure reasonable user input.</p>
<p>- The wall is currently fixed as a 2D cylinder but may be generalized in the future to allow user to select wall geometry. The 2D cyclinder though does not require the tubes/shell to be cylinders but will potentially impact the results depending on what thermal resistance dominates.</p>
</html>"));
end Generic_HX_TubesSplit;
