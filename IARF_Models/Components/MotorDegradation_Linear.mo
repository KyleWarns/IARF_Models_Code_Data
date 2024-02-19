within IARF_Models.Components;
model MotorDegradation_Linear
  "Linear function governing degradation of feedwater pumps"
  parameter Modelica.Units.SI.Time start_time "Time degradation begins";
  Modelica.Units.SI.Time linear_end_time "Time degradation would end with no feedback";
  Real tau "Mass flow rate feedback to degradation rate";

  parameter Real r "Randomness parameter";
  parameter Modelica.Units.SI.MassFlowRate a "Mass flow rate weighting parameter";

  parameter Modelica.Units.SI.AngularVelocity s_nom "Nominal shaft rotational speed";
  parameter Modelica.Units.SI.AngularVelocity s_min "Minimum permissible shaft rotational speed";
  Modelica.Units.SI.AngularAcceleration sdot_linear "Nominal rate of linear speed decrease. Must be negative!";
  Modelica.Units.SI.AngularAcceleration sdot "Rate of change of shaft speed";

  Modelica.Blocks.Interfaces.RealOutput s_out annotation (Placement(transformation(
          extent={{94,-18},{130,18}}), iconTransformation(extent={{80,-18},{116,18}})));

  Modelica.Blocks.Interfaces.RealInput m_flow
    annotation (Placement(transformation(extent={{-126,-20},{-86,20}})));
equation
  linear_end_time = 9.4607e7 + (start_time - 3.1535e7);
  sdot_linear = (s_min - s_nom) / (linear_end_time - start_time);
  tau = m_flow*r / a;
  sdot = sdot_linear*tau;

  if time < start_time then
    s_out = s_nom;
  elseif time >= start_time and s_out >= s_min then
    s_out = sdot*(time-start_time) + s_nom;
  else
    s_out = s_min;
  end if
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end MotorDegradation_Linear;
