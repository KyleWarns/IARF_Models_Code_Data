within IARF_Models.SystemModels.SFR_SteadyState;
package Data
  model SFR_PHS
    extends BaseClasses.Record_Data;
    //Source 1: Fast Spectrum Reactors by Alan Waltar, Donald Todd, and Pavel Tsvetkov
    replaceable package Medium_primary =
        TRANSFORM.Media.Fluids.Sodium.ConstantPropertyLiquidSodium constrainedby
      Modelica.Media.Interfaces.PartialMedium
      "Primary system medium: Sodium change/add temp dependent sodium!"
      annotation (choicesAllMatching=true);
  // PHTS medium: Sodium
  // Fuel-Cladding Bond material: Sodium change/add liquid sodium!
  // Duct material: SS316 or HT9
  // Cladding material: SS316 or HT9
    parameter Integer nShield = 126;
    parameter Integer nReflector = 180;
    parameter Integer nOuterCore = 42;
    parameter Integer nInnerCore = 30;
    parameter Integer nPrimarCR = 6;
    parameter Integer nSecondaryCR = 3;
    parameter Integer nTestLoop = 4;
    parameter Modelica.Units.SI.Length pitch_subassembly=0.12 "Subassembly pitch";
    parameter Modelica.Units.SI.Length th_duct=0.003 "Subassembly duct thickness";
    parameter Modelica.Units.SI.Length gap_subassembly=0.003
      "Gap between subassemblies";
    parameter Modelica.Units.SI.Length width_duct_inside=pitch_subassembly - 2*
        th_duct - gap_subassembly
      "Subassembly duct inside flat-to-flat. Default 0.111";
    parameter Integer nPins_perSub=271 "# pins per subassembly";
    parameter Modelica.Units.SI.Length D_pin=0.0053 "Pin diameter";
    parameter Modelica.Units.SI.Length th_clad=0.00037 "Cladding thickness";
    parameter Modelica.Units.SI.Length D_wireWrap=0.00126 "Wire wrap diameter";
    parameter TRANSFORM.Units.NonDim PD_ratio=1.248
      "Pin pitch to diameter ratio p/d";
    parameter Modelica.Units.SI.Length length_subassembly_out=0.60
      "Length of subassembly above gas plenum region";
    parameter Modelica.Units.SI.Length length_subassembly_gasplenum=1.50
      "Length of subassembly gas plenum length after active region";
    parameter Modelica.Units.SI.Length length_subassembly_active=0.80
      "Length of subassembly active core";
    parameter Modelica.Units.SI.Length length_subassembly_shielding=0.95
      "Length of subassembly shielding before active region";
    parameter Modelica.Units.SI.Length length_subassembly_in=0.32
      "Length of subassembly before shielding";
    parameter Modelica.Units.SI.Length length_in=length_subassembly_shielding +
        length_subassembly_in;
    parameter Modelica.Units.SI.Length length_out=length_subassembly_out +
        length_subassembly_gasplenum;
    parameter Modelica.Units.SI.Length length_total=length_in +
        length_subassembly_active + length_out;
    // Initialization
    parameter Modelica.Units.SI.Pressure p_start=1e5;
    parameter Modelica.Units.SI.Temperature T_start_hot=T_IHX_inletPHTS;
    parameter Modelica.Units.SI.Temperature T_start_cold=T_IHX_oultetPHTS;
    parameter Modelica.Units.SI.MassFlowRate m_flow_start=m_flow_PHTS;
    parameter Modelica.Units.SI.SpecificEnthalpy h_start_hot=
        Medium_primary.specificEnthalpy_pT(p_start, T_start_hot);
    parameter Modelica.Units.SI.SpecificEnthalpy h_start_IHTS_cold=
        Medium_primary.specificEnthalpy_pT(p_start, T_IHX_inletIHTS);
    parameter Real R_m_flows[4] = {0.5,0.3,0.1,0.1} "Fraction of total flow per assembly type";
    parameter Modelica.Units.SI.MassFlowRate m_flow_outer=R_m_flows[1]*m_flow_PHTS;
    parameter Modelica.Units.SI.MassFlowRate m_flow_inner=R_m_flows[2]*m_flow_PHTS;
    parameter Modelica.Units.SI.MassFlowRate m_flow_reflector=R_m_flows[3]*
        m_flow_PHTS;
    parameter Modelica.Units.SI.MassFlowRate m_flow_shield=R_m_flows[4]*
        m_flow_PHTS;
    // Kinetics - source 1 pg. 125 Table 6.2
    parameter TRANSFORM.Units.TempFeedbackCoeff alpha_outer=0.5*(0.0011 + 0.0013);
    parameter TRANSFORM.Units.TempFeedbackCoeff alpha_inner=0.5*(0.0034 + 0.0037);
    // Nominal Conditions
    parameter Modelica.Units.SI.Power Qth_nominal=300e6 "Nominal thermal power";
    parameter TRANSFORM.Units.NonDim Q_outer_nominal=0.6*Qth_nominal
      "Nominal power in region";
    parameter TRANSFORM.Units.NonDim Q_inner_nominal=0.4*Qth_nominal
      "Nominal power in region";
    parameter Modelica.Units.SI.MassFlowRate m_flow_PHTS=1570
      "Sodium flow rate in PHTS";
    parameter Modelica.Units.SI.MassFlowRate m_flow_IHX_PHTS=m_flow_PHTS/nIHXs
      "Sodium flow rate per IHX on PHTS side";
    parameter Modelica.Units.SI.MassFlowRate m_flow_IHX_IHTS=m_flow_PHTS/nIHXs
      "Sodium flow rate per IHX on IHTS side";
    parameter Modelica.Units.SI.Temperature T_IHX_inletPHTS=
        TRANSFORM.Units.Conversions.Functions.Temperature_K.from_degC(510)
      "PHTS side inlet temperature to IHX";
    parameter Modelica.Units.SI.Temperature T_IHX_oultetPHTS=
        TRANSFORM.Units.Conversions.Functions.Temperature_K.from_degC(360)
      "PHTS side outlet temperature to IHX";
    parameter Modelica.Units.SI.Temperature T_IHX_inletIHTS=
        TRANSFORM.Units.Conversions.Functions.Temperature_K.from_degC(334)
      "IHTS side inlet temperature to IHX";
    parameter Modelica.Units.SI.Temperature T_IHX_outletIHTS=
        TRANSFORM.Units.Conversions.Functions.Temperature_K.from_degC(483)
      "IHTS side outlet temperature to IHX";
    parameter Modelica.Units.SI.PressureDifference dp_IHX_shell=16805
      "Shell (primary) side pressure drop";
    parameter Modelica.Units.SI.PressureDifference dp_IHX_tube=39250
      "Tube (secondary) side pressure drop";
    /// Geometry Calculations
    final parameter Modelica.Units.SI.Length a_inner=width_duct_inside/sqrt(3)
      "Inner length of hexagonol subassembly duct";
    final parameter Modelica.Units.SI.Area crossArea_duct_empty=0.5*3*sqrt(3)*
        a_inner^2 "Empty duct cross sectional flow area";
    final parameter Modelica.Units.SI.Area crossArea_pin=0.25*Modelica.Constants.pi
        *D_pin^2 "Cross sectional area of pin";
    final parameter Modelica.Units.SI.Area crossArea_pins=crossArea_pin*
        nPins_perSub "Total cross sectional area of pins";
    final parameter Modelica.Units.SI.Area crossArea_duct=crossArea_duct_empty -
        crossArea_pins "Cross sectional flow area of duct";
    final parameter Modelica.Units.SI.Area crossArea_pinflow=crossArea_duct/
        nPins_perSub "Cross sectional flow area per pin";
    // Pumps
    parameter Integer nPumps = 3 "# of pumps in PHTS";
    parameter Integer nPumpDowncomers = 2 "# of downcomer pipes per pump";
    parameter Modelica.Units.SI.Length D_pumpDowncomer=12*0.0254
      "Pump downcomer pipes";
    parameter Modelica.Units.SI.Length length_pumpDowncomer=6
      "Downcomer length rough estimate from drawings";
    // Vessel
    parameter Modelica.Units.SI.Length height_primaryVessel=14.67;
    parameter Modelica.Units.SI.Length D_inner_primaryVessel=9.91;
    parameter Modelica.Units.SI.Length D_inner_guardVessel=10.42;
    parameter Modelica.Units.SI.Length D_outer_guardVessel=10.93;
    parameter Modelica.Units.SI.Temperature T_ambientGround=293.15
      "Ambient ground temperature around primary guard vessel";
    parameter Real frac_emptytopprimaryVessel = 0.5 "Fraction of primary vessel cross sectional area empty above core region";
    final parameter Modelica.Units.SI.Length th_primaryVessel=0.5*(
        D_inner_guardVessel - D_inner_primaryVessel);
    final parameter Modelica.Units.SI.Length th_guardVessel=th_primaryVessel;
    final parameter Modelica.Units.SI.Length level_coldNa=11.23 - th_primaryVessel;
    final parameter Modelica.Units.SI.Length level_hotNa=13.46 - th_primaryVessel;
    final parameter Modelica.Units.SI.Area crossArea_topprimaryVessel=
        frac_emptytopprimaryVessel*0.25*Modelica.Constants.pi*
        D_inner_primaryVessel^2;
    final parameter Modelica.Units.SI.Length height_topprimaryVessel=
        height_primaryVessel - 5;
    final parameter Modelica.Units.SI.Length level_start_topcold=level_coldNa - 5;
    final parameter Modelica.Units.SI.Length level_start_tophot=level_hotNa - 5;
    final parameter Modelica.Units.SI.Length dlevel_start=level_start_tophot -
        level_start_topcold;
    final parameter Modelica.Units.SI.Area crossArea_upperplenum=5^2*Modelica.Constants.pi
        /4 + Modelica.Constants.pi/8*(crossArea_topprimaryVessel^2 - 5^2)
      "rough estimate based on drawing";
    final parameter Modelica.Units.SI.Length height_upperplenum=3.5
      "distance from core exit to midpoint of IHX inlet";
    final parameter Modelica.Units.SI.Area crossArea_expansionVolume=
        crossArea_topprimaryVessel;
    final parameter Modelica.Units.SI.Length level_start_cold_expanstionTank=
        level_start_topcold - height_upperplenum;
    final parameter Modelica.Units.SI.Length level_start_hot_expanstionTank=
        level_hotNa - height_upperplenum;
    final parameter Modelica.Units.SI.Area crossArea_bottomprimaryVessel=0.25*
        Modelica.Constants.pi*D_inner_primaryVessel^2 - 0.25*Modelica.Constants.pi
        *5^2;
    final parameter Modelica.Units.SI.Length height_bottomprimaryVessel=5;
    final parameter Modelica.Units.SI.Length length_Vessel=level_hotNa
      "Rough estimate of transfer area to primary and guard vessel";
    // Lower Plenum
    parameter Modelica.Units.SI.Length D_lower=4.5
      "Approximate diameter of lower entry plenum for fuel";
    parameter Real Vfrac = 0.75;
    // REDAN
    parameter Modelica.Units.SI.Length th_redan=0.05 "Thickness of REDAN - guess";
    // IHX
    //Shell side is primary and tube side is secondary
    // material of tubes is SS304H
    parameter Integer nIHXs = 3 "Number of IHXs";
    parameter Modelica.Units.SI.Length D_tube_outer=0.0159 "Tube outer diameter";
    parameter Modelica.Units.SI.Length th_tubewall=0.889e-3 "Tube wall thickness";
    final parameter Modelica.Units.SI.Length D_tube_inner=D_tube_outer - 2*
        th_tubewall;
    parameter Modelica.Units.SI.Length pitch_tube=0.025 "Tube pitch";
    parameter Modelica.Units.SI.Length length_tube=4.03 "tube length";
    parameter Integer nTubes = 2248 "Number of tubes";
    parameter Modelica.Units.SI.Length th_tubesheet=0.137 "Tube sheet thickness";
    parameter Modelica.Units.SI.Length height_shell=5.32 "Shell height";
    parameter Modelica.Units.SI.Length D_shell_outer=1.41
      "Shell outer diameter 1.41/1.50";
    parameter Modelica.Units.SI.Length th_shellwall=0.01905 "Shell wall thickness";
    final parameter Modelica.Units.SI.Area surfaceArea=Modelica.Constants.pi*
        D_tube_outer*length_tube*nTubes "Heat transfer area. Should = 466.5";
    parameter Modelica.Units.SI.Power Qth_nominal_IHXs=Qth_nominal/nIHXs
      "Nominal design capacity per IHX";
    parameter Modelica.Units.SI.Length D_downcomerIHX=0.36 "downcomer diameter";
    parameter Modelica.Units.SI.Length D_riserIHX=0.5 "ihx riser diameter";
    // IHTS - Dimensions not specified in paper (unless noted). Assumed to be same as IHX but with increased air side surface area due to fins
    parameter Modelica.Units.SI.Length D_pipes_IHTStofromHXs=12*0.0254
      "Pipe diameters to and from HXs in IHTS";
    parameter Modelica.Units.SI.Length length_pipes_IHTStofromHXs=30
      "Pipe diameters to and from HXs in IHTS";
    parameter Integer nAirHXs = 3 "Number of air HXs per bank";
    parameter Modelica.Units.SI.Length D_tube_outer_AHX=D_tube_inner_AHX + 2*
        th_tubewall_AHX;
    parameter Modelica.Units.SI.Length th_tubewall_AHX=0.889e-3
      "Tube wall thickness";
    final parameter Modelica.Units.SI.Length D_tube_inner_AHX=sqrt(nTubes*
        D_tube_inner^2/(nTubes_AHX*nAirHXs))/2 "Velocity is 4x IHX pipe velocity";
    parameter Modelica.Units.SI.Length pitch_tube_AHX=0.0572
      "Tube pitch - in paper";
    parameter Modelica.Units.SI.Length length_tube_AHX=9.9
      "tube length - in paper";
    parameter Integer nTubes_AHX = 66 "Number of tubes - in paper";
    // assume 6 rows of tubes 11 rows deep in the vertical direction
    parameter Integer nPasses_AHX = 4 "Number of tube passes - in paper";
    parameter Modelica.Units.SI.Length height_active_shell_AHX=pitch_tube_AHX*11*
        nPasses_AHX "Shell height";
    parameter Modelica.Units.SI.Length D_shell_outer_AHX=sqrt(4/Modelica.Constants.pi
        *(pitch_tube_AHX*6)*(length_tube_AHX/nPasses_AHX))
      "Shell outer diameter 1.41/1.50";
    parameter Modelica.Units.SI.Power Qth_nominal_IHXs_AHX=Qth_nominal/nIHXs/
        nAirHXs "Nominal design capacity per IHX";
    // Air side fins - assume spacing and thickness
    parameter Modelica.Units.SI.Length th_fins=0.001;
    parameter Modelica.Units.SI.Length pitch_fins=0.004;
    parameter Modelica.Units.SI.Length D_fins=pitch_tube_AHX*0.5 "Fin diameter";
    parameter Modelica.Units.SI.Area surfaceArea_perfin_perTube=0.25*(D_fins -
        D_tube_outer_AHX)^2*Modelica.Constants.pi*2 + Modelica.Constants.pi*D_fins
        *th_fins "two sides of each fin and edge";
    parameter Real nFins_perTube = floor(length_tube_AHX/pitch_fins) "two sides of each fin";
    parameter Modelica.Units.SI.Area surfaceArea_tube_perTube=Modelica.Constants.pi
        *D_tube_outer_AHX*length_tube_AHX - Modelica.Constants.pi*D_tube_outer_AHX
        *th_fins*nFins_perTube;
    parameter Modelica.Units.SI.Area surfaceArea_fins_perTube=
        surfaceArea_perfin_perTube*nFins_perTube;
    parameter Modelica.Units.SI.Area surfaceArea_finnedTube=(
        surfaceArea_fins_perTube + surfaceArea_tube_perTube)*nTubes_AHX;
    // DRACS
  // DRACS medium: NaK
    parameter Modelica.Units.SI.Power Qth_nominal_DRACS=750e3
      "Nominal capacity per hx";
    parameter Modelica.Units.SI.Area surfaceArea_DRACS=12.5;
    parameter Modelica.Units.SI.MassFlowRate m_flow_DRACS=3.921;
    parameter Modelica.Units.SI.MassFlowRate m_flow_DRACSsec=5.47;
    parameter Modelica.Units.SI.Temperature T_inlet_DRACS=T_IHX_inletPHTS;
    parameter Modelica.Units.SI.Temperature T_outlet_DRACS=T_IHX_oultetPHTS;
    parameter Modelica.Units.SI.Temperature T_inlet_DRACSsec=327 + 273.15;
    parameter Modelica.Units.SI.Temperature T_outlet_DRACSsec=483 + 273.15;
    parameter Modelica.Units.SI.Length D_tube_outerDRACS=0.0222;
    parameter Modelica.Units.SI.Length th_tubewallDRACS=0.0009;
    parameter Modelica.Units.SI.Length D_tube_innerDRACS=D_tube_outerDRACS - 2*
        th_tubewallDRACS;
    parameter Modelica.Units.SI.Length pitch_tubeDRACS=0.0379;
    parameter Modelica.Units.SI.Length length_tubeDRACS=2.489;
    parameter Modelica.Units.SI.Length length_shellDRACS=length_tubeDRACS;
    parameter Real nTubes_DRACS = 72;
    parameter Modelica.Units.SI.Length D_shell_outerDRACS=0.4;
    parameter Modelica.Units.SI.Length th_shellDRACS=0.009525;
    parameter Modelica.Units.SI.Length D_shell_innerDRACS=D_shell_outerDRACS - 2*
        th_shellDRACS;
    // material of tubes is SS304H
    // Air side DRACS - assume spacing and thickness
   parameter Modelica.Units.SI.Length D_pipes_tofromHXs_DRACS=sqrt(4/Modelica.Constants.pi
        *m_flow_DRACSsec/2/863) "Pipe diameters to and from HXs in IHTS";
    parameter Modelica.Units.SI.Length length_pipes_tofromHXs_DRACS=30
      "Pipe lengths to and from HXs in IHTS";
    parameter Modelica.Units.SI.Length D_tube_outer_ADHX=D_tube_outerDRACS;
    parameter Modelica.Units.SI.Length th_tubewall_ADHX=th_tubewallDRACS
      "Tube wall thickness";
    parameter Modelica.Units.SI.Length D_tube_inner_ADHX=D_tube_innerDRACS;
    parameter Modelica.Units.SI.Length pitch_tube_ADHX=4*pitch_tubeDRACS
      "Tube pitch";
    parameter Modelica.Units.SI.Length length_tube_ADHX=10 "tube length";
    parameter Real nTubes_ADHX = nTubes_DRACS "Number of tubes";
    // assume 6 rows of tubes 12 rows deep in the horizontal direction
    parameter Integer nPasses_ADHX = 2 "Number of tube passes - up then down";
    parameter Modelica.Units.SI.Length height_active_shell_ADHX=0.5*
        length_tube_ADHX "Shell height";
    parameter Modelica.Units.SI.Length D_shell_outer_ADHX=sqrt(4/Modelica.Constants.pi
        *(pitch_tube_ADHX*6)*(length_tube_ADHX/nPasses_ADHX))
      "Shell outer diameter 1.41/1.50";
    parameter Modelica.Units.SI.Length th_fins_ADHX=0.001;
    parameter Modelica.Units.SI.Length pitch_fins_ADHX=0.004;
    parameter Modelica.Units.SI.Length D_fins_ADHX=pitch_tube_ADHX*0.5
      "Fin diameter";
    parameter Modelica.Units.SI.Area surfaceArea_perfin_perTube_ADHX=0.25*(
        D_fins_ADHX - D_tube_outer_ADHX)^2*Modelica.Constants.pi*2 + Modelica.Constants.pi
        *D_fins_ADHX*th_fins_ADHX "two sides of each fin and edge";
    parameter Real nFins_perTube_ADHX = floor(length_tube_ADHX/pitch_fins_ADHX) "two sides of each fin";
    parameter Modelica.Units.SI.Area surfaceArea_tube_perTube_ADHX=Modelica.Constants.pi
        *D_tube_outer_ADHX*length_tube_ADHX - Modelica.Constants.pi*
        D_tube_outer_ADHX*th_fins_ADHX*nFins_perTube_ADHX;
    parameter Modelica.Units.SI.Area surfaceArea_fins_perTube_ADHX=
        surfaceArea_perfin_perTube_ADHX*nFins_perTube_ADHX;
    parameter Modelica.Units.SI.Area surfaceArea_finnedTube_ADHX=(
        surfaceArea_fins_perTube_ADHX + surfaceArea_tube_perTube_ADHX)*nTubes_ADHX;
    annotation (
      defaultComponentName="data",
      Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
            lineColor={0,0,0},
            extent={{-100,-90},{100,-70}},
            textString="PHS")}),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
      Documentation(info="<html>
</html>"));
  end SFR_PHS;
end Data;
