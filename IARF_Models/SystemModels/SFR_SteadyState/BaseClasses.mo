within IARF_Models.SystemModels.SFR_SteadyState;
package BaseClasses
  extends TRANSFORM.Icons.BasesPackage;
  partial model Partial_SubSystem
    extends TRANSFORM.Examples.BaseClasses.Partial_SubSystem;
    extends Record_SubSystem;
    replaceable Partial_ControlSystem CS annotation (choicesAllMatching=true,
        Placement(transformation(extent={{-18,122},{-2,138}})));
    replaceable Partial_EventDriver ED annotation (choicesAllMatching=true,
        Placement(transformation(extent={{2,122},{18,138}})));
    replaceable Record_Data data
      annotation (Placement(transformation(extent={{42,122},{58,138}})));
    SignalSubBus_ActuatorInput actuatorBus
      annotation (Placement(transformation(extent={{10,80},{50,120}}),
          iconTransformation(extent={{10,80},{50,120}})));
    SignalSubBus_SensorOutput sensorBus
      annotation (Placement(transformation(extent={{-50,80},{-10,120}}),
          iconTransformation(extent={{-50,80},{-10,120}})));
  equation
    connect(sensorBus, ED.sensorBus) annotation (Line(
        points={{-30,100},{-16,100},{7.6,100},{7.6,122}},
        color={239,82,82},
        pattern=LinePattern.Dash,
        thickness=0.5));
    connect(sensorBus, CS.sensorBus) annotation (Line(
        points={{-30,100},{-12.4,100},{-12.4,122}},
        color={239,82,82},
        pattern=LinePattern.Dash,
        thickness=0.5));
    connect(actuatorBus, CS.actuatorBus) annotation (Line(
        points={{30,100},{12,100},{-7.6,100},{-7.6,122}},
        color={111,216,99},
        pattern=LinePattern.Dash,
        thickness=0.5));
    connect(actuatorBus, ED.actuatorBus) annotation (Line(
        points={{30,100},{20,100},{12.4,100},{12.4,122}},
        color={111,216,99},
        pattern=LinePattern.Dash,
        thickness=0.5));
    annotation (
      defaultComponentName="PHS",
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
              100,140}})));
  end Partial_SubSystem;

  partial model Partial_SubSystem_A
    extends Partial_SubSystem;
    extends Record_SubSystem_A;
    import Modelica.Constants;
     TRANSFORM.Fluid.Interfaces.FluidPort_State port_a(redeclare package Medium =
          Medium, m_flow(min=if allowFlowReversal then -Constants.inf else 0))
      "Fluid connector a (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{90,-50},{110,-30}}),
          iconTransformation(extent={{90,-50},{110,-30}})));
     TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_b(redeclare package Medium =
          Medium, m_flow(max=if allowFlowReversal then +Constants.inf else 0))
      "Fluid connector b (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{90,30},{110,50}}),
          iconTransformation(extent={{90,30},{110,50}})));
    annotation (
      defaultComponentName="PHS",
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              140}})));
  end Partial_SubSystem_A;

  partial record Record_Data
    extends TRANSFORM.Icons.Record;
    annotation (defaultComponentName="data",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Record_Data;

  partial record Record_SubSystem
    annotation (defaultComponentName="data",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Record_SubSystem;

  partial record Record_SubSystem_A
    extends Record_SubSystem;
    replaceable package Medium =
        TRANSFORM.Media.Fluids.Sodium.ConstantPropertyLiquidSodium
      constrainedby Modelica.Media.Interfaces.PartialMedium
      "Medium at fluid ports" annotation (choicesAllMatching=true);
    /* Nominal Conditions */
    parameter TRANSFORM.Examples.Utilities.Record_fluidPorts port_a_nominal(
        redeclare package Medium = Medium, h=Medium.specificEnthalpy(
          Medium.setState_pT(port_a_nominal.p, port_a_nominal.T))) "port_a"
      annotation (Dialog(tab="Nominal Conditions"));
    parameter TRANSFORM.Examples.Utilities.Record_fluidPorts port_b_nominal(
      redeclare package Medium = Medium,
      h=Medium.specificEnthalpy(Medium.setState_pT(port_b_nominal.p,
          port_b_nominal.T)),
      m_flow=-port_a_nominal.m_flow) "port_b"
      annotation (Dialog(tab="Nominal Conditions"));
    /* Initialization */
    parameter TRANSFORM.Examples.Utilities.Record_fluidPorts port_a_start(
      redeclare package Medium = Medium,
      p=port_a_nominal.p,
      T=port_a_nominal.T,
      h=Medium.specificEnthalpy(Medium.setState_pT(port_a_start.p, port_a_start.T)),
      m_flow=port_a_nominal.m_flow) "port_a"
      annotation (Dialog(tab="Initialization"));
    parameter TRANSFORM.Examples.Utilities.Record_fluidPorts port_b_start(
      redeclare package Medium = Medium,
      p=port_b_nominal.p,
      T=port_b_nominal.T,
      h=Medium.specificEnthalpy(Medium.setState_pT(port_b_start.p, port_b_start.T)),
      m_flow=-port_a_start.m_flow) "port_b"
      annotation (Dialog(tab="Initialization"));
    /* Assumptions */
    parameter Boolean allowFlowReversal=true
      "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
      annotation (Dialog(tab="Assumptions"), Evaluate=true);
    annotation (defaultComponentName="data",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Record_SubSystem_A;

  partial model Partial_ControlSystem
    extends TRANSFORM.Examples.BaseClasses.Partial_ControlSystem;
    SignalSubBus_ActuatorInput actuatorBus
      annotation (Placement(transformation(extent={{10,-120},{50,-80}}),
          iconTransformation(extent={{10,-120},{50,-80}})));
    SignalSubBus_SensorOutput sensorBus
      annotation (Placement(transformation(extent={{-50,-120},{-10,-80}}),
          iconTransformation(extent={{-50,-120},{-10,-80}})));
    annotation (
      defaultComponentName="CS",
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
              100,100}})));
  end Partial_ControlSystem;

  partial model Partial_EventDriver
    extends TRANSFORM.Examples.BaseClasses.Partial_EventDriver;
    SignalSubBus_ActuatorInput actuatorBus
      annotation (Placement(transformation(extent={{10,-120},{50,-80}}),
          iconTransformation(extent={{10,-120},{50,-80}})));
    SignalSubBus_SensorOutput sensorBus
      annotation (Placement(transformation(extent={{-50,-120},{-10,-80}}),
          iconTransformation(extent={{-50,-120},{-10,-80}})));
    annotation (
      defaultComponentName="ED",
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}})));
  end Partial_EventDriver;

  expandable connector SignalSubBus_ActuatorInput
    extends TRANSFORM.Examples.Interfaces.SignalSubBus_ActuatorInput;
    annotation (defaultComponentName="actuatorBus",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end SignalSubBus_ActuatorInput;

  expandable connector SignalSubBus_SensorOutput
    extends TRANSFORM.Examples.Interfaces.SignalSubBus_SensorOutput;
    annotation (defaultComponentName="sensorBus",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end SignalSubBus_SensorOutput;
end BaseClasses;
