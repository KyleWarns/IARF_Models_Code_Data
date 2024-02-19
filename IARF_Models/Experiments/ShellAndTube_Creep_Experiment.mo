within IARF_Models.Experiments;
model ShellAndTube_Creep_Experiment
  "Example of an water and water shell and tube exchanger, used to demonstrate no change in pressure drop during typical instances of creep"
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T tube_inlet(
    m_flow=1,
    T(displayUnit="degC") = 293.15,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1)
    annotation (Placement(transformation(extent={{-51,-6},{-39,6}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT tube_outlet(
    p(displayUnit="bar") = 100000,
    T(displayUnit="degC") = 333.15,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1)
    annotation (Placement(transformation(extent={{51,-5},{41,5}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T shell_inlet(
    T(displayUnit="degC") = 363.15,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    m_flow=1,
    nPorts=1)
    annotation (Placement(transformation(extent={{51,14},{39,26}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT shell_outlet(
    p(displayUnit="bar") = 100000,
    T(displayUnit="degC") = 343.15,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1)
    annotation (Placement(transformation(extent={{-51,15},{-41,25}})));
  IARF_Models.Components.HXs.Generic_HX_TubesSplit heatExchanger(
    redeclare model Geometry =
        IARF_Models.Components.HXs.Geometries.ShellAndTubeHX_Creep (
        nV=10,
        nTubes_Total=50,
        nR=3,
        nTubes_creep=10,
        D_o_shell=0.3,
        dimension_tube=0.01,
        length_tube_s1=0.667,
        length_tube_s2=0.666,
        length_tube_s3=0.667,
        dimension_tube_creep=0.02),
    redeclare package Medium_shell = Modelica.Media.Water.StandardWater,
    redeclare package Medium_tube = Modelica.Media.Water.StandardWater,
    redeclare package Material_tubeWall = TRANSFORM.Media.Solids.SS316_TRACE,
    redeclare model HeatTransfer_shell =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Alphas
        (alpha0=1000),
    redeclare model HeatTransfer_tube =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Alphas
        (alpha0=1000),
    p_a_start_shell_s1=shell_outlet.p + 100,
    T_a_start_shell_s1=shell_inlet.T,
    p_b_start_shell_s3=shell_outlet.p,
    T_b_start_shell_s3=shell_outlet.T,
    m_flow_a_start_shell=shell_inlet.m_flow,
    use_Ts_start_tube=false,
    p_a_start_tube_s1=tube_outlet.p + 100,
    p_b_start_tube_s3=tube_outlet.p,
    m_flow_a_start_tube=tube_inlet.m_flow)
    annotation (Placement(transformation(extent={{-16,-18},{20,18}})));
equation
  connect(tube_inlet.ports[1], heatExchanger.port_a_tube)
    annotation (Line(points={{-39,0},{-16,0}}, color={0,127,255}));
  connect(heatExchanger.port_b_tube, tube_outlet.ports[1])
    annotation (Line(points={{20,0},{41,0}}, color={0,127,255}));
  connect(heatExchanger.port_a_shell, shell_inlet.ports[1]) annotation (Line(points=
          {{20,8.28},{26,8.28},{26,8},{30,8},{30,20},{39,20}}, color={0,127,255}));
  connect(heatExchanger.port_b_shell, shell_outlet.ports[1]) annotation (Line(points=
         {{-16,8.28},{-22,8.28},{-22,8},{-28,8},{-28,20},{-41,20}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(
      StopTime=1000,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Esdirk45a"),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>A counterflow shell and tube heat exchanger with the purpose of verifying the simplest application of the model, especially the effect of the value nTubes.</p>
</html>"));
end ShellAndTube_Creep_Experiment;
