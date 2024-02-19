within IARF_Models.Components.HXs;
model Temp_Average_Calculator
  "Calculates the weighted average of two temperature vectors from different numbers of parallel pipe components"
  parameter Integer nV = 1 "Number of volume nodes contributing to each vector";
  parameter Real w1 = 1 "Weight of first input vector";
  parameter Real w2 = 1 "Weight of second input vector";

  TRANSFORM.HeatAndMassTransfer.Interfaces.HeatPort_Flow InputVector1[nV]
    annotation (Placement(transformation(extent={{-70,-110},{-50,-90}})));
  TRANSFORM.HeatAndMassTransfer.Interfaces.HeatPort_Flow OutputVector[nV]
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  TRANSFORM.HeatAndMassTransfer.Interfaces.HeatPort_Flow InputVector2[nV]
    annotation (Placement(transformation(extent={{50,-110},{70,-90}})));

equation
  for i in 1:nV loop
    InputVector1[i].Q_flow/w1 = InputVector2[i].Q_flow/w2;
    OutputVector[i].Q_flow + InputVector1[i].Q_flow + InputVector2[i].Q_flow  = 0;
    OutputVector[i].T = (InputVector1[i].T*w1 + InputVector2[i].T*w2)  / (w1 + w2);
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Line(
          points={{-60,-98},{0,0},{60,-98},{60,-100}},
          color={238,46,47},
          thickness=1), Line(
          points={{0,0},{0,100}},
          color={238,46,47},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Temp_Average_Calculator;
