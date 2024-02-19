within IARF_Models.SystemModels.SFR_DegradedPumps;
model ConstantPoweSource_DegradedPumps "Constant power source with nominal power of original SFR model and Controlled BOP"
  replaceable package Medium =
      TRANSFORM.Media.Fluids.Sodium.ConstantPropertyLiquidSodium
    "Primary heat system medium" annotation(choicesAllMatching=true);
  Data.SFR_PHS data annotation (Placement(transformation(extent={{40,82},{60,102}})));
  Components.IHTS_CBOP_DegradedPumps
                        IHTS
    annotation (Placement(transformation(extent={{14,-20},{66,20}})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipe(
    redeclare package Medium = Medium,
    p_a_start=400000,
    p_b_start=300000,
    T_a_start=data.T_IHX_inletIHTS,
    T_b_start=data.T_IHX_outletIHTS,
    m_flow_b_start=data.m_flow_IHX_IHTS,
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
    height=-0.08*300e6,
    duration=5000,
    offset=300e6,
    startTime=25000)
    annotation (Placement(transformation(extent={{-96,-10},{-76,10}})));
equation
  connect(pipe.port_b, IHTS.port_b) annotation (Line(points={{-30,10},{-30,18},{-8,18},
          {-8,8},{14,8}}, color={0,127,255}));
  connect(IHTS.port_a, pipe.port_a) annotation (Line(points={{14,-12},{-8,-12},{-8,-18},
          {-30,-18},{-30,-10}}, color={0,127,255}));
  connect(FixedPowerInput.port, pipe.heatPorts[1, 1])
    annotation (Line(points={{-48,0},{-35,0}}, color={191,0,0}));
  connect(ramp.y, FixedPowerInput.Q_flow_ext)
    annotation (Line(points={{-75,0},{-62,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=50000,
      __Dymola_NumberOfIntervals=8,
      __Dymola_Algorithm="Esdirk45a"));
end ConstantPoweSource_DegradedPumps;
