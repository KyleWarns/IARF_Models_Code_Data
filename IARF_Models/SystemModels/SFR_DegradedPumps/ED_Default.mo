within IARF_Models.SystemModels.SFR_DegradedPumps;
model ED_Default
  extends BaseClasses.Partial_EventDriver;
annotation(defaultComponentName="PHS_CS", Icon(graphics={
        Text(
          extent={{-94,82},{94,74}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,237},
          fillPattern=FillPattern.Solid,
          textString="ED: Basic/Default")}));
end ED_Default;
