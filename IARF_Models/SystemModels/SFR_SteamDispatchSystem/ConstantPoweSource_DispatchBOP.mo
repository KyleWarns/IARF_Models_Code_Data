within IARF_Models.SystemModels.SFR_SteamDispatchSystem;
model ConstantPoweSource_DispatchBOP
  "Constant power source with nominal power of original SFR model and heavily simplified version of BOP model"
  replaceable package Medium =
      TRANSFORM.Media.Fluids.Sodium.ConstantPropertyLiquidSodium
    "Primary heat system medium" annotation(choicesAllMatching=true);
  Data.SFR_PHS data annotation (Placement(transformation(extent={{40,82},{60,102}})));
  Components.IHTS5_AHX3_Dispatch
                             IHTS(
    T_AHX_shell_inlet=873.15,
    T_AHX_shell_outlet=473.15,
    m_flow_AHX_shell=225,
    m_flow_IHTS=450)
    annotation (Placement(transformation(extent={{54,-20},{106,20}})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipe(
    redeclare package Medium = Medium,
    p_a_start=400000,
    p_b_start=300000,
    T_a_start=873.15,
    T_b_start=473.15,
    m_flow_b_start=450,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=data.D_pipes_IHTStofromHXs, length=0.5*data.length_pipes_IHTStofromHXs),
    use_HeatTransfer=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,0})));

  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow FixedPowerInput(
      use_port=true)
    annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=0,
    duration=4000,
    offset=300e6,
    startTime=5000)
    annotation (Placement(transformation(extent={{-96,-10},{-76,10}})));
equation
  connect(FixedPowerInput.port, pipe.heatPorts[1, 1])
    annotation (Line(points={{-48,0},{-35,0}}, color={191,0,0}));
  connect(ramp.y, FixedPowerInput.Q_flow_ext)
    annotation (Line(points={{-75,0},{-62,0}}, color={0,0,127}));
  connect(pipe.port_b, IHTS.port_b) annotation (Line(points={{-30,10},{-30,18},{40,
          18},{40,8},{54,8}}, color={0,127,255}));
  connect(IHTS.port_a, pipe.port_a) annotation (Line(points={{54,-12},{40,-12},{40,
          -24},{-30,-24},{-30,-10}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1000, __Dymola_Algorithm="Esdirk45a"));
end ConstantPoweSource_DispatchBOP;
