within IARF_Models.Components.HXs;
package Geometries
  model GenericHX_Divided
    import TRANSFORM.Math.fillArray_1D;
    parameter Integer nV(min=1) = 1 "Number of volume nodes";
    parameter Integer nSurfaces_shell=1 "Number of transfer (heat/mass) surfaces"
    annotation (Dialog(tab="Shell Side",enable=false));

  // Shell Inputs - Shared
    input Modelica.Units.SI.Length dimensions_shell[nV]=4*crossAreas_shell ./
        perimeters_shell "Characteristic dimension (e.g., hydraulic diameter)"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Area crossAreas_shell[nV]=0.25*Modelica.Constants.pi*
        dimensions_shell .* dimensions_shell "Cross sectional area of unit volumes"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Length perimeters_shell[nV]=4*crossAreas_shell ./
        dimensions_shell "Wetted perimeter of unit volumes"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Height[nV] roughnesses_shell=fill(2.5e-5, nV)
      "Average heights of surface asperities"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));

  // Shell Segment 1 Inputs
   input Modelica.Units.SI.Length dlengths_shell_s1[nV]=ones(nV) "Unit cell length"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 1"));
    input Modelica.Units.SI.Area surfaceAreas_shell_s1[nV,nSurfaces_shell]={{if j == 1
         then Modelica.Constants.pi*dimensions_tube_outer[i]*dlengths_tube_s1[i]*nTubes_Total
         else 0 for j in 1:nSurfaces_shell} for i in 1:nV}
      "Discretized area per transfer surface"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 1"));
    input Modelica.Units.SI.Length[nV] dheights_shell_s1=dlengths_shell_s1 .* sin(
        angles_shell) "Height(port_b) - Height(port_a)"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 1"));

  // Shell Segment 2 Inputs
   input Modelica.Units.SI.Length dlengths_shell_s2[nV]=ones(nV) "Unit cell length"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 2"));
    input Modelica.Units.SI.Area surfaceAreas_shell_s2[nV,nSurfaces_shell]={{if j == 1
         then Modelica.Constants.pi*dimensions_tube_outer[i]*dlengths_tube_s2[i]*nTubes_Total
         else 0 for j in 1:nSurfaces_shell} for i in 1:nV}
      "Discretized area per transfer surface"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 2"));
    input Modelica.Units.SI.Length[nV] dheights_shell_s2=dlengths_shell_s2 .* sin(
        angles_shell) "Height(port_b) - Height(port_a)"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 2"));

  // Shell Segment 3 Inputs
   input Modelica.Units.SI.Length dlengths_shell_s3[nV]=ones(nV) "Unit cell length"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 3"));
    input Modelica.Units.SI.Area surfaceAreas_shell_s3[nV,nSurfaces_shell]={{if j == 1
         then Modelica.Constants.pi*dimensions_tube_outer[i]*dlengths_tube_s3[i]*nTubes_Total
         else 0 for j in 1:nSurfaces_shell} for i in 1:nV}
      "Discretized area per transfer surface"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 3"));
    input Modelica.Units.SI.Length[nV] dheights_shell_s3=dlengths_shell_s3 .* sin(
        angles_shell) "Height(port_b) - Height(port_a)"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 3"));

    // Elevation
    input Modelica.Units.SI.Angle[nV] angles_shell=fill(0, nV)
      "Vertical angle from the horizontal  (-pi/2 < x <= pi/2)"
      annotation (Dialog(tab="Shell Side", group="Inputs Elevation"));
    input Modelica.Units.SI.Length height_a_shell=0
      "Elevation at port_a: Reference value only. No impact on calculations."
      annotation (Dialog(tab="Shell Side", group="Inputs Elevation"));
    output Modelica.Units.SI.Length height_b_shell=height_a_shell + sum(dheights_shell_s1)
    + sum(dheights_shell_s2) + sum(dheights_shell_s3)
      "Elevation at port_b: Reference value only. No impact on calculations."
      annotation (Dialog(
        tab="Shell Side",
        group="Inputs Elevation",
        enable=false));

    // Tube Inputs - Shared
    parameter Real nTubes_Total=1 "Total # of tubes per heat exchanger" annotation (Dialog(tab="Tube Side"));
    parameter Integer nR(min=1) = 1 "Number of radial nodes in wall (r-direction)" annotation(Dialog(tab="Tube Side"));
    parameter Integer nSurfaces_tube=1 "Number of transfer (heat/mass) surfaces"
    annotation (Dialog(tab="Tube Side",enable=false));
    input Modelica.Units.SI.Length dimensions_tube[nV]=4*crossAreas_tube ./
        perimeters_tube "Characteristic dimension (e.g., hydraulic diameter)"
      annotation (Dialog(tab="Tube Side", group="Inputs - Majority"));
    input Modelica.Units.SI.Area crossAreas_tube[nV]=0.25*Modelica.Constants.pi*
        dimensions_tube .* dimensions_tube "Cross sectional area of unit volumes"
      annotation (Dialog(tab="Tube Side", group="Inputs - Majority"));
    input Modelica.Units.SI.Length perimeters_tube[nV]=4*crossAreas_tube ./
        dimensions_tube "Wetted perimeter of unit volumes"
      annotation (Dialog(tab="Tube Side", group="Inputs - Majority"));
    input Modelica.Units.SI.Height[nV] roughnesses_tube=fill(2.5e-5, nV)
      "Average heights of surface asperities"
      annotation (Dialog(tab="Tube Side", group="Inputs - Majority"));

   // Tube Segment 1 Inputs
    input Modelica.Units.SI.Length dlengths_tube_s1[nV]=ones(nV) "Unit cell length"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 1"));
    input Modelica.Units.SI.Area surfaceAreas_tube_s1[nV,nSurfaces_tube]={{if j == 1
         then perimeters_tube[i]*dlengths_tube_s1[i] else 0 for j in 1:nSurfaces_tube}
        for i in 1:nV} "Discretized area per transfer surface"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 1"));
    input Modelica.Units.SI.Length[nV] dheights_tube_s1=dlengths_tube_s1 .* sin(angles_tube)
      "Height(port_b) - Height(port_a)"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 1"));

   // Tube Segment 2 Inputs
    input Modelica.Units.SI.Length dlengths_tube_s2[nV]=ones(nV) "Unit cell length"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 2"));
    input Modelica.Units.SI.Area surfaceAreas_tube_s2[nV,nSurfaces_tube]={{if j == 1
         then perimeters_tube[i]*dlengths_tube_s2[i] else 0 for j in 1:nSurfaces_tube}
        for i in 1:nV} "Discretized area per transfer surface"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 2"));
    input Modelica.Units.SI.Length[nV] dheights_tube_s2=dlengths_tube_s2 .* sin(angles_tube)
      "Height(port_b) - Height(port_a)"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 2"));

   // Tube Segment 3 Inputs
    input Modelica.Units.SI.Length dlengths_tube_s3[nV]=ones(nV) "Unit cell length"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 3"));
    input Modelica.Units.SI.Area surfaceAreas_tube_s3[nV,nSurfaces_tube]={{if j == 1
         then perimeters_tube[i]*dlengths_tube_s3[i] else 0 for j in 1:nSurfaces_tube}
        for i in 1:nV} "Discretized area per transfer surface"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 3"));
    input Modelica.Units.SI.Length[nV] dheights_tube_s3=dlengths_tube_s3 .* sin(angles_tube)
      "Height(port_b) - Height(port_a)"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 3"));

    // Elevation
    input Modelica.Units.SI.Angle[nV] angles_tube=fill(0, nV)
      "Vertical angle from the horizontal  (-pi/2 < x <= pi/2)"
      annotation (Dialog(tab="Tube Side", group="Inputs Elevation"));
    input Modelica.Units.SI.Length height_a_tube=0
      "Elevation at port_a: Reference value only. No impact on calculations."
      annotation (Dialog(tab="Tube Side", group="Inputs Elevation"));
    output Modelica.Units.SI.Length height_b_tube=height_a_tube + sum(dheights_tube_s1)
    + sum(dheights_tube_s2) + sum(dheights_tube_s3)
      "Elevation at port_b: Reference value only. No impact on calculations."
      annotation (Dialog(
        tab="Tube Side",
        group="Inputs Elevation",
        enable=false));

    // Tube Wall - Shared between all segments
    input Modelica.Units.SI.Length ths_wall[nV]=fill(0.001, nV) "Tube wall thickness"
      annotation (Dialog(tab="Tube Side", group="Inputs: Tube Wall"));
    input Modelica.Units.SI.Length drs[nR,nV](min=0)=fillArray_1D(ths_wall/nR, nR)
      "Tube unit volume lengths of r-dimension"
      annotation (Dialog(tab="Tube Side", group="Inputs: Tube Wall"));
    Modelica.Units.SI.Length dimensions_tube_outer[nV]={dimensions_tube[i] + 2*sum(drs[
        :, i]) for i in 1:nV} "Tube outer diameter";
    Modelica.Units.SI.Length D_o_tube=sum(dimensions_tube_outer)/nV
      "Tube outer average diameter";
  equation
    for i in 1:nV loop
      assert(dimensions_shell[i] > 0, "Characteristic dimension must be > 0");
      assert(dlengths_shell_s1[i] >= abs(dheights_shell_s1[i]), "Geometry dlengths_shell_s1 must be greater or equal to abs(dheights_shell_s1)");
      assert(dlengths_shell_s2[i] >= abs(dheights_shell_s2[i]), "Geometry dlengths_shell_s2 must be greater or equal to abs(dheights_shell_s2)");
      assert(dlengths_shell_s3[i] >= abs(dheights_shell_s3[i]), "Geometry dlengths_shell_s3 must be greater or equal to abs(dheights_shell_s3)");
      assert(dimensions_shell[i] > 0, "Characteristic dimension must be > 0");
      assert(dlengths_shell_s1[i] >= abs(dheights_shell_s1[i]), "Geometry dlengths_shell_s1 must be greater or equal to abs(dheights_shell_s1)");
      assert(dlengths_shell_s2[i] >= abs(dheights_shell_s2[i]), "Geometry dlengths_shell_s2 must be greater or equal to abs(dheights_shell_s2)");
      assert(dlengths_shell_s3[i] >= abs(dheights_shell_s3[i]), "Geometry dlengths_shell_s3 must be greater or equal to abs(dheights_shell_s3)");
      assert(dimensions_tube[i] > 0, "Characteristic dimension must be > 0");
      assert(dlengths_tube_s1[i] >= abs(dheights_tube_s1[i]), "Geometry dlengths_tube_s1 must be greater or equal to abs(dheights_tube_s1)");
      assert(dlengths_tube_s2[i] >= abs(dheights_tube_s2[i]), "Geometry dlengths_tube_s2 must be greater or equal to abs(dheights_tube_s2)");
      assert(dlengths_tube_s3[i] >= abs(dheights_tube_s3[i]), "Geometry dlengths_tube_s3 must be greater or equal to abs(dheights_tube_s3)");
      assert(dimensions_tube[i] > 0, "Characteristic dimension must be > 0");
      assert(dlengths_tube_s1[i] >= abs(dheights_tube_s1[i]), "Geometry dlengths_tube_s1 must be greater or equal to abs(dheights_tube_s1)");
      assert(dlengths_tube_s2[i] >= abs(dheights_tube_s2[i]), "Geometry dlengths_tube_s2 must be greater or equal to abs(dheights_tube_s2)");
      assert(dlengths_tube_s3[i] >= abs(dheights_tube_s3[i]), "Geometry dlengths_tube_s3 must be greater or equal to abs(dheights_tube_s3)");
    end for;
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                                                  Bitmap(extent={{
                -100,-100},{100,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/Geometry_genericVolume.jpg")}),
                                                                   Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end GenericHX_Divided;

  model ShellAndTubeHX_Divided
    extends GenericHX_Divided(
      final dimensions_shell=fill(dimension_shell, nV),
      final crossAreas_shell=fill(crossArea_shell, nV),
      final perimeters_shell=fill(perimeter_shell, nV),
      final dlengths_shell_s1=fill(length_shell_s1/nV, nV),
      final dlengths_shell_s2=fill(length_shell_s2/nV, nV),
      final dlengths_shell_s3=fill(length_shell_s3/nV, nV),
      final roughnesses_shell=fill(roughness_shell, nV),
      final angles_shell=fill(angle_shell,nV),
      final dheights_shell_s1=fill(dheight_shell_s1/nV, nV),
      final dheights_shell_s2=fill(dheight_shell_s2/nV, nV),
      final dheights_shell_s3=fill(dheight_shell_s3/nV, nV),
      final surfaceAreas_shell_s1=transpose({fill(surfaceArea_shell_s1[i]/nV, nV) for i in
              1:nSurfaces_shell}),
      final surfaceAreas_shell_s2=transpose({fill(surfaceArea_shell_s2[i]/nV, nV) for i in
              1:nSurfaces_shell}),
      final surfaceAreas_shell_s3=transpose({fill(surfaceArea_shell_s3[i]/nV, nV) for i in
              1:nSurfaces_shell}),
      final dimensions_tube=fill(dimension_tube, nV),
      final crossAreas_tube=fill(crossArea_tube, nV),
      final perimeters_tube=fill(perimeter_tube, nV),
      final dlengths_tube_s1=fill(length_tube_s1/nV, nV),
      final dlengths_tube_s2=fill(length_tube_s2/nV, nV),
      final dlengths_tube_s3=fill(length_tube_s3/nV, nV),
      final roughnesses_tube=fill(roughness_tube, nV),
      final angles_tube=fill(angle_tube,nV),
      final dheights_tube_s1=fill(dheight_tube_s1/nV, nV),
      final dheights_tube_s2=fill(dheight_tube_s2/nV, nV),
      final dheights_tube_s3=fill(dheight_tube_s3/nV, nV),
      final surfaceAreas_tube_s1=transpose({fill(surfaceArea_tube_s1[i]/nV, nV) for i in
              1:nSurfaces_tube}),
      final surfaceAreas_tube_s2=transpose({fill(surfaceArea_tube_s2[i]/nV, nV) for i in
              1:nSurfaces_tube}),
      final surfaceAreas_tube_s3=transpose({fill(surfaceArea_tube_s3[i]/nV, nV) for i in
              1:nSurfaces_tube}),
      final ths_wall = fill(th_wall,nV),
      drs=fill(th_wall/nR,nR,nV));

  // Shell Shared Inputs
    input Modelica.Units.SI.Length dimension_shell=4*crossAreaNew_shell/perimeterNew_shell
      "Characteristic dimension (e.g., hydraulic diameter)"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Area crossArea_shell=crossAreaNew_shell
      "Cross-sectional flow areas"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Length perimeter_shell=perimeterNew_shell
      "Wetted perimeters"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Height roughness_shell=2.5e-5
      "Average heights of surface asperities"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Angle angle_shell=0.0 "Vertical angle from the horizontal  (-pi/2 < x <= pi/2)"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Diameter D_i_shell=0 "Inner diameter of shell (if shell is an annulus)"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Diameter D_o_shell = 4*crossAreaEmpty_shell/perimeterEmpty_shell "Outer diameter of shell"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Area crossAreaEmpty_shell = 0.25*Modelica.Constants.pi*(D_o_shell^2 - D_i_shell^2) "Cross-sectional area of empty shell (i.e., no tubes)"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Length perimeterEmpty_shell = Modelica.Constants.pi*(D_o_shell + D_i_shell) "Wetted parameter of an empty shell (i.e., no tubes);"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));

    // Shell Segment 1
    input Modelica.Units.SI.Length length_shell_s1=0.333 "Pipe length"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 1"));
    input Modelica.Units.SI.Area surfaceArea_shell_s1[nSurfaces_shell]={if i == 1 then Modelica.Constants.pi*D_o_tube*length_tube_s1*nTubes_Total else 0 for i in 1:nSurfaces_shell} "Outer surface area"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 1"));
    input Modelica.Units.SI.Length dheight_shell_s1= length_shell_s1*sin(angle_shell)
      "Height(port_b) - Height(port_a) distributed by flow segment"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 1"));

    // Shell Segment 2
    input Modelica.Units.SI.Length length_shell_s2=0.334 "Pipe length"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 2"));
    input Modelica.Units.SI.Area surfaceArea_shell_s2[nSurfaces_shell]={if i == 1 then Modelica.Constants.pi*D_o_tube*length_tube_s2*nTubes_Total else 0 for i in 1:nSurfaces_shell} "Outer surface area"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 2"));
    input Modelica.Units.SI.Length dheight_shell_s2= length_shell_s2*sin(angle_shell)
      "Height(port_b) - Height(port_a) distributed by flow segment"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 2"));

    // Shell Segment 3
    input Modelica.Units.SI.Length length_shell_s3=0.333 "Pipe length"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 3"));
    input Modelica.Units.SI.Area surfaceArea_shell_s3[nSurfaces_shell]={if i == 1 then Modelica.Constants.pi*D_o_tube*length_tube_s3*nTubes_Total else 0 for i in 1:nSurfaces_shell} "Outer surface area"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 3"));
    input Modelica.Units.SI.Length dheight_shell_s3= length_shell_s3*sin(angle_shell)
      "Height(port_b) - Height(port_a) distributed by flow segment"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 3"));

    // Tube Shared Inputs
    input Modelica.Units.SI.Length dimension_tube=4*crossArea_tube/perimeter_tube
      "Characteristic dimension (e.g., hydraulic diameter)"
      annotation (Dialog(tab="Tube Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Area crossArea_tube=0.25*Modelica.Constants.pi*dimension_tube*dimension_tube
      "Cross-sectional flow areas"
      annotation (Dialog(tab="Tube Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Length perimeter_tube=4*crossArea_tube/dimension_tube
      "Wetted perimeters"
      annotation (Dialog(tab="Tube Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Height roughness_tube=2.5e-5 "Average heights of surface asperities"
      annotation (Dialog(tab="Tube Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Angle angle_tube=0.0 "Vertical angle from the horizontal  (-pi/2 < x <= pi/2)"
      annotation (Dialog(tab="Tube Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Length th_wall=0.001 "Tube wall thickness"
      annotation (Dialog(tab="Tube Side",group="Inputs: Tube Wall"));
    Modelica.Units.SI.Length dimension_tube_outer = sum(dimensions_tube_outer)/nV "Tube outer diameter";

    // Tube Segment 1
    input Modelica.Units.SI.Length length_tube_s1=0.333 "Pipe length"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 1"));
    input Modelica.Units.SI.Area surfaceArea_tube_s1[nSurfaces_tube]={if i ==1 then perimeter_tube*length_tube_s1 else 0 for i in 1:nSurfaces_tube} "Inner surface area"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 1"));
    input Modelica.Units.SI.Length dheight_tube_s1= length_tube_s1*sin(angle_tube)
      "Height(port_b) - Height(port_a) distributed by flow segment"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 1"));

    // Tube Segment 2
    input Modelica.Units.SI.Length length_tube_s2=0.334 "Pipe length"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 2"));
    input Modelica.Units.SI.Area surfaceArea_tube_s2[nSurfaces_tube]={if i ==1 then perimeter_tube*length_tube_s2 else 0 for i in 1:nSurfaces_tube} "Inner surface area"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 2"));
    input Modelica.Units.SI.Length dheight_tube_s2= length_tube_s2*sin(angle_tube)
      "Height(port_b) - Height(port_a) distributed by flow segment"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 2"));

    // Tube Segment 3
    input Modelica.Units.SI.Length length_tube_s3=0.333 "Pipe length"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 3"));
    input Modelica.Units.SI.Area surfaceArea_tube_s3[nSurfaces_tube]={if i ==1 then perimeter_tube*length_tube_s3 else 0 for i in 1:nSurfaces_tube} "Inner surface area"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 3"));
    input Modelica.Units.SI.Length dheight_tube_s3= length_tube_s3*sin(angle_tube)
      "Height(port_b) - Height(port_a) distributed by flow segment"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 3"));

  protected
    TRANSFORM.Units.NonDim lengthRatio = (length_tube_s1 + length_tube_s2 + length_tube_s3) / (length_shell_s1 + length_shell_s2 + length_shell_s3)
    "Ratio of tube length to shell length";
    Modelica.Units.SI.Area crossAreaModded_tube = 0.25*Modelica.Constants.pi*D_o_tube^2*nTubes_Total*lengthRatio "Estimate of cross sectional area of tubes (exact if tubes are circular) with an unequal shell-tube length factor correction";
    Modelica.Units.SI.Length perimeterModded_tube = Modelica.Constants.pi*D_o_tube*nTubes_Total*lengthRatio "Wetted perimeter of tubes in shell with an unequal shell-tube length factor correction";
    Modelica.Units.SI.Area crossAreaNew_shell = crossAreaEmpty_shell-crossAreaModded_tube "Cross-sectional flow area of shell";
    Modelica.Units.SI.Length perimeterNew_shell = perimeterEmpty_shell + perimeterModded_tube "Wetted perimeter of shell";
  equation
    assert(crossAreaNew_shell > 0, "Cross flow area of tubes is greater than the area of the empty shell");

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end ShellAndTubeHX_Divided;

  model GenericHX_Creep
    import TRANSFORM.Math.fillArray_1D;
    parameter Integer nV(min=1) = 1 "Number of volume nodes";
    parameter Integer nSurfaces_shell=1 "Number of transfer (heat/mass) surfaces"
    annotation (Dialog(tab="Shell Side",enable=false));

  // Shell Inputs - Shared
    input Modelica.Units.SI.Length dimensions_shell[nV]=4*crossAreas_shell ./
        perimeters_shell "Characteristic dimension (e.g., hydraulic diameter)"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Area crossAreas_shell[nV]=0.25*Modelica.Constants.pi*
        dimensions_shell .* dimensions_shell "Cross sectional area of unit volumes"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Length perimeters_shell[nV]=4*crossAreas_shell ./
        dimensions_shell "Wetted perimeter of unit volumes"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Height[nV] roughnesses_shell=fill(2.5e-5, nV)
      "Average heights of surface asperities"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));

  // Shell Segment 1 Inputs
   input Modelica.Units.SI.Length dlengths_shell_s1[nV]=ones(nV) "Unit cell length"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 1"));
    input Modelica.Units.SI.Area surfaceAreas_shell_s1[nV,nSurfaces_shell]={{if j == 1
         then Modelica.Constants.pi*dimensions_tube_outer[i]*dlengths_tube_s1[i]*nTubes_Total
         else 0 for j in 1:nSurfaces_shell} for i in 1:nV}
      "Discretized area per transfer surface"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 1"));
    input Modelica.Units.SI.Length[nV] dheights_shell_s1=dlengths_shell_s1 .* sin(
        angles_shell) "Height(port_b) - Height(port_a)"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 1"));

  // Shell Segment 2 Inputs
   input Modelica.Units.SI.Length dlengths_shell_s2[nV]=ones(nV) "Unit cell length"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 2"));
    input Modelica.Units.SI.Area surfaceAreas_shell_s2[nV,nSurfaces_shell]={{if j == 1
         then Modelica.Constants.pi*dimensions_tube_outer[i]*dlengths_tube_s2[i]*nTubes_Total
         else 0 for j in 1:nSurfaces_shell} for i in 1:nV}
      "Discretized area per transfer surface"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 2"));
    input Modelica.Units.SI.Length[nV] dheights_shell_s2=dlengths_shell_s2 .* sin(
        angles_shell) "Height(port_b) - Height(port_a)"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 2"));

  // Shell Segment 3 Inputs
   input Modelica.Units.SI.Length dlengths_shell_s3[nV]=ones(nV) "Unit cell length"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 3"));
    input Modelica.Units.SI.Area surfaceAreas_shell_s3[nV,nSurfaces_shell]={{if j == 1
         then Modelica.Constants.pi*dimensions_tube_outer[i]*dlengths_tube_s3[i]*nTubes_Total
         else 0 for j in 1:nSurfaces_shell} for i in 1:nV}
      "Discretized area per transfer surface"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 3"));
    input Modelica.Units.SI.Length[nV] dheights_shell_s3=dlengths_shell_s3 .* sin(
        angles_shell) "Height(port_b) - Height(port_a)"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 3"));

    // Elevation
    input Modelica.Units.SI.Angle[nV] angles_shell=fill(0, nV)
      "Vertical angle from the horizontal  (-pi/2 < x <= pi/2)"
      annotation (Dialog(tab="Shell Side", group="Inputs Elevation"));
    input Modelica.Units.SI.Length height_a_shell=0
      "Elevation at port_a: Reference value only. No impact on calculations."
      annotation (Dialog(tab="Shell Side", group="Inputs Elevation"));
    output Modelica.Units.SI.Length height_b_shell=height_a_shell + sum(dheights_shell_s1)
    + sum(dheights_shell_s2) + sum(dheights_shell_s3)
      "Elevation at port_b: Reference value only. No impact on calculations."
      annotation (Dialog(
        tab="Shell Side",
        group="Inputs Elevation",
        enable=false));

    // Tube Inputs - Majority
    parameter Real nTubes_Total=2 "Total # of tubes per heat exchanger" annotation (Dialog(tab="Tube Side"));
    parameter Integer nR(min=1) = 1 "Number of radial nodes in wall (r-direction)" annotation(Dialog(tab="Tube Side"));
    parameter Integer nSurfaces_tube=1 "Number of transfer (heat/mass) surfaces"
    annotation (Dialog(tab="Tube Side",enable=false));
    input Modelica.Units.SI.Length dimensions_tube[nV]=4*crossAreas_tube ./
        perimeters_tube "Characteristic dimension (e.g., hydraulic diameter)"
      annotation (Dialog(tab="Tube Side", group="Inputs - Majority"));
    input Modelica.Units.SI.Area crossAreas_tube[nV]=0.25*Modelica.Constants.pi*
        dimensions_tube .* dimensions_tube "Cross sectional area of unit volumes"
      annotation (Dialog(tab="Tube Side", group="Inputs - Majority"));
    input Modelica.Units.SI.Length perimeters_tube[nV]=4*crossAreas_tube ./
        dimensions_tube "Wetted perimeter of unit volumes"
      annotation (Dialog(tab="Tube Side", group="Inputs - Majority"));
    input Modelica.Units.SI.Height[nV] roughnesses_tube=fill(2.5e-5, nV)
      "Average heights of surface asperities"
      annotation (Dialog(tab="Tube Side", group="Inputs - Majority"));

   // Tube Inputs - Minority
   parameter Real nTubes_creep=1 "# of tubes undergoing creep" annotation (Dialog(tab="Tube Side"));

   // Tube Segment 1 Inputs
    input Modelica.Units.SI.Length dlengths_tube_s1[nV]=ones(nV) "Unit cell length"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 1"));
    input Modelica.Units.SI.Area surfaceAreas_tube_s1[nV,nSurfaces_tube]={{if j == 1
         then perimeters_tube[i]*dlengths_tube_s1[i] else 0 for j in 1:nSurfaces_tube}
        for i in 1:nV} "Discretized area per transfer surface"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 1"));
    input Modelica.Units.SI.Length[nV] dheights_tube_s1=dlengths_tube_s1 .* sin(angles_tube)
      "Height(port_b) - Height(port_a)"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 1"));

   // Tube Segment 2 Inputs
    input Modelica.Units.SI.Length dlengths_tube_s2[nV]=ones(nV) "Unit cell length"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 2"));
    input Modelica.Units.SI.Area surfaceAreas_tube_s2[nV,nSurfaces_tube]={{if j == 1
         then perimeters_tube[i]*dlengths_tube_s2[i] else 0 for j in 1:nSurfaces_tube}
        for i in 1:nV} "Discretized area per transfer surface"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 2"));
    input Modelica.Units.SI.Length[nV] dheights_tube_s2=dlengths_tube_s2 .* sin(angles_tube)
      "Height(port_b) - Height(port_a)"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 2"));

   // Tube Segment 3 Inputs
    input Modelica.Units.SI.Length dlengths_tube_s3[nV]=ones(nV) "Unit cell length"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 3"));
    input Modelica.Units.SI.Area surfaceAreas_tube_s3[nV,nSurfaces_tube]={{if j == 1
         then perimeters_tube[i]*dlengths_tube_s3[i] else 0 for j in 1:nSurfaces_tube}
        for i in 1:nV} "Discretized area per transfer surface"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 3"));
    input Modelica.Units.SI.Length[nV] dheights_tube_s3=dlengths_tube_s3 .* sin(angles_tube)
      "Height(port_b) - Height(port_a)"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 3"));

    // Tube Creep Segment Inputs
    input Modelica.Units.SI.Area surfaceAreas_tube_creep[nV,nSurfaces_tube]={{if j == 1
         then perimeters_tube_creep[i]*dlengths_tube_s2[i] else 0 for j in 1:nSurfaces_tube}
        for i in 1:nV} "Discretized area per transfer surface"
      annotation (Dialog(tab="Tube Side", group="Creep parameters"));
    input Modelica.Units.SI.Length dimensions_tube_creep[nV]=4*crossAreas_tube_creep ./
        perimeters_tube_creep "Characteristic dimension (e.g., hydraulic diameter)"
      annotation (Dialog(tab="Tube Side", group="Creep parameters"));
    input Modelica.Units.SI.Area crossAreas_tube_creep[nV]=0.25*Modelica.Constants.pi*
        dimensions_tube_creep .* dimensions_tube_creep "Cross sectional area of unit volumes"
      annotation (Dialog(tab="Tube Side", group="Creep parameters"));
    input Modelica.Units.SI.Length perimeters_tube_creep[nV]=4*crossAreas_tube_creep ./
        dimensions_tube_creep "Wetted perimeter of unit volumes"
      annotation (Dialog(tab="Tube Side", group="Creep parameters"));
    Modelica.Units.SI.Length dimensions_tube_outer_creep[nV]={dimensions_tube_creep[i] + 2*sum(drs[
        :, i]) for i in 1:nV} "Tube outer diameter";
    Modelica.Units.SI.Length D_o_tube_creep=sum(dimensions_tube_outer_creep)/nV
      "Tube outer average diameter";

    // Elevation
    input Modelica.Units.SI.Angle[nV] angles_tube=fill(0, nV)
      "Vertical angle from the horizontal  (-pi/2 < x <= pi/2)"
      annotation (Dialog(tab="Tube Side", group="Inputs Elevation"));
    input Modelica.Units.SI.Length height_a_tube=0
      "Elevation at port_a: Reference value only. No impact on calculations."
      annotation (Dialog(tab="Tube Side", group="Inputs Elevation"));
    output Modelica.Units.SI.Length height_b_tube=height_a_tube + sum(dheights_tube_s1)
    + sum(dheights_tube_s2) + sum(dheights_tube_s3)
      "Elevation at port_b: Reference value only. No impact on calculations."
      annotation (Dialog(
        tab="Tube Side",
        group="Inputs Elevation",
        enable=false));

    // Tube Wall - Shared between all segments
    input Modelica.Units.SI.Length ths_wall[nV]=fill(0.001, nV) "Tube wall thickness"
      annotation (Dialog(tab="Tube Side", group="Inputs: Tube Wall"));
    input Modelica.Units.SI.Length drs[nR,nV](min=0)=fillArray_1D(ths_wall/nR, nR)
      "Tube unit volume lengths of r-dimension"
      annotation (Dialog(tab="Tube Side", group="Inputs: Tube Wall"));
    Modelica.Units.SI.Length dimensions_tube_outer[nV]={dimensions_tube[i] + 2*sum(drs[
        :, i]) for i in 1:nV} "Tube outer diameter";
    Modelica.Units.SI.Length D_o_tube=sum(dimensions_tube_outer)/nV
      "Tube outer average diameter";
  equation
    for i in 1:nV loop
      assert(dimensions_shell[i] > 0, "Characteristic dimension must be > 0");
      assert(dlengths_shell_s1[i] >= abs(dheights_shell_s1[i]), "Geometry dlengths_shell_s1 must be greater or equal to abs(dheights_shell_s1)");
      assert(dlengths_shell_s2[i] >= abs(dheights_shell_s2[i]), "Geometry dlengths_shell_s2 must be greater or equal to abs(dheights_shell_s2)");
      assert(dlengths_shell_s3[i] >= abs(dheights_shell_s3[i]), "Geometry dlengths_shell_s3 must be greater or equal to abs(dheights_shell_s3)");
      assert(dimensions_shell[i] > 0, "Characteristic dimension must be > 0");
      assert(dlengths_shell_s1[i] >= abs(dheights_shell_s1[i]), "Geometry dlengths_shell_s1 must be greater or equal to abs(dheights_shell_s1)");
      assert(dlengths_shell_s2[i] >= abs(dheights_shell_s2[i]), "Geometry dlengths_shell_s2 must be greater or equal to abs(dheights_shell_s2)");
      assert(dlengths_shell_s3[i] >= abs(dheights_shell_s3[i]), "Geometry dlengths_shell_s3 must be greater or equal to abs(dheights_shell_s3)");
      assert(dimensions_tube[i] > 0, "Characteristic dimension must be > 0");
      assert(dimensions_tube_creep[i] > 0, "Characteristic dimension must be > 0");
      assert(dlengths_tube_s1[i] >= abs(dheights_tube_s1[i]), "Geometry dlengths_tube_s1 must be greater or equal to abs(dheights_tube_s1)");
      assert(dlengths_tube_s2[i] >= abs(dheights_tube_s2[i]), "Geometry dlengths_tube_s2 must be greater or equal to abs(dheights_tube_s2)");
      assert(dlengths_tube_s3[i] >= abs(dheights_tube_s3[i]), "Geometry dlengths_tube_s3 must be greater or equal to abs(dheights_tube_s3)");
      assert(dimensions_tube[i] > 0, "Characteristic dimension must be > 0");
      assert(dimensions_tube_creep[i] > 0, "Characteristic dimension must be > 0");
      assert(dlengths_tube_s1[i] >= abs(dheights_tube_s1[i]), "Geometry dlengths_tube_s1 must be greater or equal to abs(dheights_tube_s1)");
      assert(dlengths_tube_s2[i] >= abs(dheights_tube_s2[i]), "Geometry dlengths_tube_s2 must be greater or equal to abs(dheights_tube_s2)");
      assert(dlengths_tube_s3[i] >= abs(dheights_tube_s3[i]), "Geometry dlengths_tube_s3 must be greater or equal to abs(dheights_tube_s3)");
    end for;
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                                                  Bitmap(extent={{
                -100,-100},{100,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/Geometry_genericVolume.jpg")}),
                                                                   Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end GenericHX_Creep;

  model ShellAndTubeHX_Creep
    extends GenericHX_Creep(
      final dimensions_shell=fill(dimension_shell, nV),
      final crossAreas_shell=fill(crossArea_shell, nV),
      final perimeters_shell=fill(perimeter_shell, nV),
      final dlengths_shell_s1=fill(length_shell_s1/nV, nV),
      final dlengths_shell_s2=fill(length_shell_s2/nV, nV),
      final dlengths_shell_s3=fill(length_shell_s3/nV, nV),
      final roughnesses_shell=fill(roughness_shell, nV),
      final angles_shell=fill(angle_shell,nV),
      final dheights_shell_s1=fill(dheight_shell_s1/nV, nV),
      final dheights_shell_s2=fill(dheight_shell_s2/nV, nV),
      final dheights_shell_s3=fill(dheight_shell_s3/nV, nV),
      final surfaceAreas_shell_s1=transpose({fill(surfaceArea_shell_s1[i]/nV, nV) for i in
              1:nSurfaces_shell}),
      final surfaceAreas_shell_s2=transpose({fill(surfaceArea_shell_s2[i]/nV, nV) for i in
              1:nSurfaces_shell}),
      final surfaceAreas_shell_s3=transpose({fill(surfaceArea_shell_s3[i]/nV, nV) for i in
              1:nSurfaces_shell}),
      final dimensions_tube=fill(dimension_tube, nV),
      final crossAreas_tube=fill(crossArea_tube, nV),
      final perimeters_tube=fill(perimeter_tube, nV),
      final dimensions_tube_creep=fill(dimension_tube_creep, nV),
      final crossAreas_tube_creep=fill(crossArea_tube_creep, nV),
      final perimeters_tube_creep=fill(perimeter_tube_creep, nV),
      final dlengths_tube_s1=fill(length_tube_s1/nV, nV),
      final dlengths_tube_s2=fill(length_tube_s2/nV, nV),
      final dlengths_tube_s3=fill(length_tube_s3/nV, nV),
      final roughnesses_tube=fill(roughness_tube, nV),
      final angles_tube=fill(angle_tube,nV),
      final dheights_tube_s1=fill(dheight_tube_s1/nV, nV),
      final dheights_tube_s2=fill(dheight_tube_s2/nV, nV),
      final dheights_tube_s3=fill(dheight_tube_s3/nV, nV),
      final surfaceAreas_tube_s1=transpose({fill(surfaceArea_tube_s1[i]/nV, nV) for i in
              1:nSurfaces_tube}),
      final surfaceAreas_tube_s2=transpose({fill(surfaceArea_tube_s2[i]/nV, nV) for i in
              1:nSurfaces_tube}),
      final surfaceAreas_tube_s3=transpose({fill(surfaceArea_tube_s3[i]/nV, nV) for i in
              1:nSurfaces_tube}),
      final surfaceAreas_tube_creep=transpose({fill(surfaceArea_tube_creep[i]/nV, nV) for i in
              1:nSurfaces_tube}),
      final ths_wall = fill(th_wall,nV),
      drs=fill(th_wall/nR,nR,nV));

  // Shell Shared Inputs
    input Modelica.Units.SI.Length dimension_shell=4*crossAreaNew_shell/perimeterNew_shell
      "Characteristic dimension (e.g., hydraulic diameter)"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Area crossArea_shell=crossAreaNew_shell
      "Cross-sectional flow areas"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Length perimeter_shell=perimeterNew_shell
      "Wetted perimeters"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Height roughness_shell=2.5e-5
      "Average heights of surface asperities"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Angle angle_shell=0.0 "Vertical angle from the horizontal  (-pi/2 < x <= pi/2)"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Diameter D_i_shell=0 "Inner diameter of shell (if shell is an annulus)"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Diameter D_o_shell = 4*crossAreaEmpty_shell/perimeterEmpty_shell "Outer diameter of shell"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Area crossAreaEmpty_shell = 0.25*Modelica.Constants.pi*(D_o_shell^2 - D_i_shell^2) "Cross-sectional area of empty shell (i.e., no tubes)"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Length perimeterEmpty_shell = Modelica.Constants.pi*(D_o_shell + D_i_shell) "Wetted parameter of an empty shell (i.e., no tubes);"
      annotation (Dialog(tab="Shell Side", group="Inputs - Shared"));

    // Shell Segment 1
    input Modelica.Units.SI.Length length_shell_s1=0.333 "Pipe length"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 1"));
    input Modelica.Units.SI.Area surfaceArea_shell_s1[nSurfaces_shell]={if i == 1 then Modelica.Constants.pi*D_o_tube*length_tube_s1*nTubes_Total else 0 for i in 1:nSurfaces_shell} "Outer surface area"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 1"));
    input Modelica.Units.SI.Length dheight_shell_s1= length_shell_s1*sin(angle_shell)
      "Height(port_b) - Height(port_a) distributed by flow segment"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 1"));

    // Shell Segment 2
    input Modelica.Units.SI.Length length_shell_s2=0.334 "Pipe length"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 2"));
    input Modelica.Units.SI.Area surfaceArea_shell_s2[nSurfaces_shell]={if i == 1 then Modelica.Constants.pi*D_o_tube*length_tube_s2*nTubes_Total else 0 for i in 1:nSurfaces_shell} "Outer surface area"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 2"));
    input Modelica.Units.SI.Length dheight_shell_s2= length_shell_s2*sin(angle_shell)
      "Height(port_b) - Height(port_a) distributed by flow segment"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 2"));

    // Shell Segment 3
    input Modelica.Units.SI.Length length_shell_s3=0.333 "Pipe length"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 3"));
    input Modelica.Units.SI.Area surfaceArea_shell_s3[nSurfaces_shell]={if i == 1 then Modelica.Constants.pi*D_o_tube*length_tube_s3*nTubes_Total else 0 for i in 1:nSurfaces_shell} "Outer surface area"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 3"));
    input Modelica.Units.SI.Length dheight_shell_s3= length_shell_s3*sin(angle_shell)
      "Height(port_b) - Height(port_a) distributed by flow segment"
      annotation (Dialog(tab="Shell Side", group="Inputs - Segment 3"));

    // Tube Shared Inputs
    input Modelica.Units.SI.Length dimension_tube=4*crossArea_tube/perimeter_tube
      "Characteristic dimension (e.g., hydraulic diameter)"
      annotation (Dialog(tab="Tube Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Area crossArea_tube=0.25*Modelica.Constants.pi*dimension_tube*dimension_tube
      "Cross-sectional flow areas"
      annotation (Dialog(tab="Tube Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Length perimeter_tube=4*crossArea_tube/dimension_tube
      "Wetted perimeters"
      annotation (Dialog(tab="Tube Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Height roughness_tube=2.5e-5 "Average heights of surface asperities"
      annotation (Dialog(tab="Tube Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Angle angle_tube=0.0 "Vertical angle from the horizontal  (-pi/2 < x <= pi/2)"
      annotation (Dialog(tab="Tube Side", group="Inputs - Shared"));
    input Modelica.Units.SI.Length th_wall=0.001 "Tube wall thickness"
      annotation (Dialog(tab="Tube Side",group="Inputs: Tube Wall"));
    Modelica.Units.SI.Length dimension_tube_outer = sum(dimensions_tube_outer)/nV "Tube outer diameter";

    // Tube Segment 1
    input Modelica.Units.SI.Length length_tube_s1=0.333 "Pipe length"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 1"));
    input Modelica.Units.SI.Area surfaceArea_tube_s1[nSurfaces_tube]={if i ==1 then perimeter_tube*length_tube_s1 else 0 for i in 1:nSurfaces_tube} "Inner surface area"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 1"));
    input Modelica.Units.SI.Length dheight_tube_s1= length_tube_s1*sin(angle_tube)
      "Height(port_b) - Height(port_a) distributed by flow segment"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 1"));

    // Tube Segment 2
    input Modelica.Units.SI.Length length_tube_s2=0.334 "Pipe length"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 2"));
    input Modelica.Units.SI.Area surfaceArea_tube_s2[nSurfaces_tube]={if i ==1 then perimeter_tube*length_tube_s2 else 0 for i in 1:nSurfaces_tube} "Inner surface area"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 2"));
    input Modelica.Units.SI.Length dheight_tube_s2= length_tube_s2*sin(angle_tube)
      "Height(port_b) - Height(port_a) distributed by flow segment"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 2"));

    // Tube Segment 3
    input Modelica.Units.SI.Length length_tube_s3=0.333 "Pipe length"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 3"));
    input Modelica.Units.SI.Area surfaceArea_tube_s3[nSurfaces_tube]={if i ==1 then perimeter_tube*length_tube_s3 else 0 for i in 1:nSurfaces_tube} "Inner surface area"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 3"));
    input Modelica.Units.SI.Length dheight_tube_s3= length_tube_s3*sin(angle_tube)
      "Height(port_b) - Height(port_a) distributed by flow segment"
      annotation (Dialog(tab="Tube Side", group="Inputs - Segment 3"));

    // Tube Segment Creep
    input Modelica.Units.SI.Length dimension_tube_creep=4*crossArea_tube_creep/perimeter_tube_creep
      "Characteristic dimension (e.g., hydraulic diameter)"
      annotation (Dialog(tab="Tube Side", group="Creep parameters"));
    input Modelica.Units.SI.Area crossArea_tube_creep=0.25*Modelica.Constants.pi*dimension_tube_creep*dimension_tube_creep
      "Cross-sectional flow areas"
      annotation (Dialog(tab="Tube Side", group="Creep parameters"));
    input Modelica.Units.SI.Length perimeter_tube_creep=4*crossArea_tube_creep/dimension_tube_creep
      "Wetted perimeters"
      annotation (Dialog(tab="Tube Side", group="Creep parameters"));
    Modelica.Units.SI.Length dimension_tube_outer_creep = sum(dimensions_tube_outer_creep)/nV "Tube outer diameter";
    input Modelica.Units.SI.Area surfaceArea_tube_creep[nSurfaces_tube]={if i ==1 then perimeter_tube_creep*length_tube_s2 else 0 for i in 1:nSurfaces_tube} "Inner surface area"
      annotation (Dialog(tab="Tube Side", group="Creep parameters"));

  protected
    TRANSFORM.Units.NonDim lengthRatio = (length_tube_s1 + length_tube_s2 + length_tube_s3) / (length_shell_s1 + length_shell_s2 + length_shell_s3)
    "Ratio of tube length to shell length";
    Modelica.Units.SI.Area crossAreaModded_tube = 0.25*Modelica.Constants.pi*(D_o_tube^2*(nTubes_Total-nTubes_creep)*lengthRatio + D_o_tube_creep^2*nTubes_creep*length_tube_s2/length_shell_s2)
    "Estimate of cross sectional area of tubes (exact if tubes are circular) with an unequal shell-tube length factor correction";
    Modelica.Units.SI.Length perimeterModded_tube = Modelica.Constants.pi*(D_o_tube*(nTubes_Total-nTubes_creep)*lengthRatio + D_o_tube_creep*nTubes_creep*length_tube_s2/length_shell_s2)
    "Wetted perimeter of tubes in shell with an unequal shell-tube length factor correction";
    Modelica.Units.SI.Area crossAreaNew_shell = crossAreaEmpty_shell-crossAreaModded_tube "Cross-sectional flow area of shell";
    Modelica.Units.SI.Length perimeterNew_shell = perimeterEmpty_shell + perimeterModded_tube "Wetted perimeter of shell";
  equation
    assert(crossAreaNew_shell > 0, "Cross flow area of tubes is greater than the area of the empty shell");

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end ShellAndTubeHX_Creep;
end Geometries;
