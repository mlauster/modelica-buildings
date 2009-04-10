within Buildings.Fluids.Storage;
model Stratified "Model of a stratified tank for thermal energy storage"
  extends Buildings.Fluids.Interfaces.PartialStaticTwoPortInterface(final
      p_a_start =                                                                     p_start,
                                                                    final
      p_b_start =                                                                     p_start);
  extends Buildings.BaseClasses.BaseIcon;
  replaceable package Medium = 
      Modelica.Media.Interfaces.PartialSimpleMedium;
  import Modelica_Fluid.Types;
  import Modelica_Fluid.Types.Dynamics;
  annotation (Documentation(info="<html>
<p>
This is a model of a stratified storage tank.
The tank uses several volumes to model the stratification.
Heat conduction is modeled between the volumes through the fluid,
and between the volumes and the ambient.
The port <tt>heaPorVol</tt> may be used to connect a temperature sensor
that measures the fluid temperature of an individual volume. It may also
be used to add heat to individual volumes.
</p>
<p>
The heat ports outside the tank insulation can be 
used to specify an ambient temperature.
Leave these ports unconnected to force adiabatic boundary conditions.
Note, however, that all heat conduction elements through the tank wall (but not the top and bottom) are connected to the 
heat port <tt>heaPorSid</tt>. Thus, not connecting
<tt>heaPorSid</tt> means an adiabatic boundary condition in the sense 
that <tt>heaPorSid.Q_flow = 0</tt>. This, however, still allows heat to flow
through the tank walls, modelled by <tt>conWal</tt>, from one fluid volume
to another one.
</p>
<p>
For a model with enhanced stratification, use
<a href=\"Modelica:Buildings.Fluids.Storage.StratifiedEnhanced\">
Buildings.Fluids.Storage.StratifiedEnhanced</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 19, 2009 by Michael Wetter:<br>
Changed declaration that constrains the medium. The earlier
declaration caused the medium model to be not shown in the parameter
window.
</li>
<li>
October 31, 2008 by Michael Wetter:<br>
Added heat conduction.
</li>
<li>
October 23, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={
        Rectangle(
          extent={{-40,60},{40,20}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,-20},{40,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-76,2},{-90,-2}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,84},{-80,80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-76,84},{-80,-2}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{82,0},{78,-86}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,84},{-4,60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{82,-84},{2,-88}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{6,-60},{2,-84}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{92,2},{78,-2}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,20},{40,-20}},
          lineColor={255,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.CrossDiag),
        Text(
          extent={{100,106},{134,74}},
          lineColor={0,0,127},
          textString="QLoss"),
        Rectangle(
          extent={{-10,10},{10,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,255}),
        Rectangle(
          extent={{50,68},{40,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,66},{-50,-68}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,68},{50,60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,-60},{50,-68}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{26,72},{102,72},{100,72}},
          color={127,0,0},
          pattern=LinePattern.Dot),
        Line(
          points={{56,6},{56,72},{58,72}},
          color={127,0,0},
          pattern=LinePattern.Dot),
        Line(
          points={{22,-74},{70,-74},{70,72}},
          color={127,0,0},
          pattern=LinePattern.Dot)}),
                            Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                    graphics));
  parameter Modelica.SIunits.Volume VTan "Tank volume";
  parameter Modelica.SIunits.Length hTan "Height of tank (without insulation)";
  parameter Modelica.SIunits.Length dIns "Thickness of insulation";
  parameter Modelica.SIunits.ThermalConductivity kIns = 0.04
    "Specific heat conductivity of insulation";
  parameter Integer nSeg(min=2) = 2 "Number of volume segments";

  ////////////////////////////////////////////////////////////////////
  // Assumptions
  parameter Types.Dynamics energyDynamics=system.energyDynamics
    "Formulation of energy balance" 
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
  parameter Types.Dynamics massDynamics=system.massDynamics
    "Formulation of mass balance" 
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));

  // Initialization
  parameter Medium.AbsolutePressure p_start = system.p_start
    "Start value of pressure" 
    annotation(Dialog(tab = "Initialization"));
  parameter Boolean use_T_start = true "= true, use T_start, otherwise h_start"
    annotation(Dialog(tab = "Initialization"), Evaluate=true);
  parameter Medium.Temperature T_start=
    if use_T_start then system.T_start else Medium.temperature_phX(p_start,h_start,X_start)
    "Start value of temperature" 
    annotation(Dialog(tab = "Initialization", enable = use_T_start));
  parameter Medium.SpecificEnthalpy h_start=
    if use_T_start then Medium.specificEnthalpy_pTX(p_start, T_start, X_start) else Medium.h_default
    "Start value of specific enthalpy" 
    annotation(Dialog(tab = "Initialization", enable = not use_T_start));
  parameter Medium.MassFraction X_start[Medium.nX] = Medium.X_default
    "Start value of mass fractions m_i/m" 
    annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](
       quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Start value of trace substances" 
    annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));

  ////////////////////////////////////////////////////////////////////

  MixingVolumes.MixingVolume[nSeg] vol(
    redeclare each package Medium = Medium,
    each energyDynamics=energyDynamics,
    each massDynamics=massDynamics,
    each p_start=p_start,
    each use_T_start=use_T_start,
    each T_start=T_start,
    each h_start=h_start,
    each X_start=X_start,
    each C_start=C_start,
    each V=VTan/nSeg,
    each nPorts=nPorts,
    each m_flow_small = m_flow_small,
    each use_HeatTransfer=true,
    redeclare each model HeatTransfer = 
        Modelica_Fluid.Vessels.BaseClasses.HeatTransfer.IdealHeatTransfer)
    "Tank segment"            annotation (Placement(transformation(extent={{-26,-10},
            {-6,10}},      rotation=0)));
  Sensors.EnthalpyFlowRate hA(redeclare package Medium = Medium) 
    annotation (Placement(transformation(extent={{-72,-30},{-52,-10}},rotation=
            0)));
  Sensors.EnthalpyFlowRate[nSeg-1] hVol_flow(redeclare package Medium = Medium) 
    annotation (Placement(transformation(extent={{-22,-50},{-2,-30}}, rotation=
            0)));
  Sensors.EnthalpyFlowRate hB(redeclare package Medium = Medium) 
    annotation (Placement(transformation(extent={{46,-42},{66,-22}}, rotation=0)));
  BaseClasses.Buoyancy buo(
    redeclare package Medium = Medium,
    V=VTan,
    nSeg=nSeg,
    tau=tau) "Model to prevent unstable tank stratification" 
    annotation (Placement(transformation(extent={{-60,50},{-40,70}}, rotation=0)));
  parameter Modelica.SIunits.Time tau=1
    "Time constant for mixing due to temperature inversion";
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor[
                                                 nSeg - 1] conFlu(
                                                                each G=conFluSeg)
    "Thermal conductance in fluid between the segments" 
    annotation (Placement(transformation(extent={{-52,30},{-38,44}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor[
                                                 nSeg] conWal(
     each G=2*Modelica.Constants.pi*kIns*hSeg/ln((rTan+dIns)/rTan))
    "Thermal conductance through tank wall" 
    annotation (Placement(transformation(extent={{10,34},{20,46}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conTop(
     G=conTopSeg) "Thermal conductance through tank top" 
    annotation (Placement(transformation(extent={{10,54},{20,66}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conBot(
     G=conTopSeg) "Thermal conductance through tank bottom" 
    annotation (Placement(transformation(extent={{10,14},{20,26}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nSeg] heaPorVol
    "Heat port of fluid volumes" 
    annotation (Placement(transformation(extent={{-6,-6},{6,6}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorSid
    "Heat port tank side (outside insulation)" 
                    annotation (Placement(transformation(extent={{50,-6},{62,6}},
          rotation=0)));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSid[
                                                         nSeg]
    "Heat flow at wall of tank (outside insulation)" 
    annotation (Placement(transformation(extent={{30,34},{42,46}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorTop
    "Heat port tank top (outside insulation)" 
                    annotation (Placement(transformation(extent={{14,68},{26,80}},
          rotation=0)));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloTop
    "Heat flow at top of tank (outside insulation)" 
    annotation (Placement(transformation(extent={{30,54},{42,66}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorBot
    "Heat port tank bottom (outside insulation). Leave unconnected for adiabatic condition"
                    annotation (Placement(transformation(extent={{14,-80},{26,
            -68}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloBot
    "Heat flow at bottom of tank (outside insulation)" 
    annotation (Placement(transformation(extent={{30,14},{42,26}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput Ql_flow
    "Heat loss of tank (positve if heat flows from to ambient)" 
    annotation (Placement(transformation(extent={{100,62},{120,82}}, rotation=0)));

protected
  constant Integer nPorts = 2 "Number of ports of volume";
  parameter Modelica.SIunits.Length hSeg = hTan / nSeg
    "Height of a tank segment";
  parameter Modelica.SIunits.Area ATan = VTan/hTan
    "Tank cross-sectional area (without insulation)";
  parameter Modelica.SIunits.Length rTan = sqrt(ATan/Modelica.Constants.pi)
    "Tank diameter (without insulation)";
  parameter Modelica.SIunits.ThermalConductance conFluSeg = ATan*Medium.lambda_const/hSeg
    "Thermal conductance between fluid volumes";
  parameter Modelica.SIunits.ThermalConductance conTopSeg = 1/(1/conFluSeg+1/(ATan*kIns/dIns))
    "Thermal conductance from center of top (or bottom) volume through tank insulation at top (or bottom)";

protected
  Modelica.Blocks.Routing.Multiplex3 mul(
    n1=1,
    n2=nSeg,
    n3=1) annotation (Placement(transformation(extent={{62,44},{70,54}},
          rotation=0)));
  Modelica.Blocks.Math.Sum sum1(nin=nSeg + 2) 
                                          annotation (Placement(transformation(
          extent={{78,42},{90,56}}, rotation=0)));
equation
  connect(hA.port_b, vol[1].ports[1]) 
                                     annotation (Line(points={{-52,-20},{-52,
          -10},{-16,-10}},                        color={0,127,255}));
  connect(vol[nSeg].ports[2], hB.port_a) 
                                        annotation (Line(points={{-16,-10},{-16,
          -20},{30,-20},{30,-32},{46,-32}},                 color={0,127,255}));
  connect(hB.port_b, port_b) annotation (Line(points={{66,-32},{82,-32},{82,0},
          {100,0}},                          color={0,127,255}));
  for i in 1:(nSeg-1) loop

  connect(vol[i].ports[2], hVol_flow[i].port_a) 
                                               annotation (Line(points={{-16,-10},
            {-16,-20},{-28,-20},{-28,-40},{-22,-40}},               color={0,
            127,255}));
  connect(hVol_flow[i].port_b, vol[i+1].ports[1]) 
                                                 annotation (Line(points={{-2,-40},
            {4,-40},{4,-10},{-16,-10}},                        color={0,127,255}));
  end for;
  connect(port_a, hA.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,-20},
          {-72,-20}},                                           color={0,127,
          255}));
  connect(buo.heatPort, vol.heatPort)    annotation (Line(
      points={{-40,60},{-26,60},{-26,0}},
      color={191,0,0},
      pattern=LinePattern.None));
  for i in 1:nSeg-1 loop
  // heat conduction between fluid nodes
     connect(vol[i].heatPort, conFlu[i].port_a)    annotation (Line(points={{-26,0},
            {-26,20},{-60,20},{-60,40},{-52,40},{-52,37}}, color={191,0,0}));
    connect(vol[i+1].heatPort, conFlu[i].port_b)    annotation (Line(points={{-26,0},
            {-26,16},{-26,37},{-38,37}}, color={191,0,0}));
  end for;
  connect(vol[1].heatPort, conTop.port_a)    annotation (Line(points={{-26,0},{
          -26,60},{-4,60},{10,60}},          color={191,0,0}));
  connect(vol.heatPort, conWal.port_a)    annotation (Line(points={{-26,0},{-26,
          40},{0,40},{10,40}},           color={191,0,0}));
  connect(conBot.port_a, vol[nSeg].heatPort)    annotation (Line(points={{10,20},
          {-26,20},{-26,0}},   color={191,0,0}));
  connect(vol.heatPort, heaPorVol)    annotation (Line(points={{-26,0},{-26,-2},
          {-26,12},{0,12},{0,0}},
        color={191,0,0}));
  connect(conWal.port_b, heaFloSid.port_a) 
    annotation (Line(points={{20,40},{30,40}}, color={191,0,0}));
  for i in 1:nSeg loop

    connect(heaFloSid[i].port_b, heaPorSid) annotation (Line(points={{42,40},{
          56,40},{56,0}},               color={191,0,0}));
  end for;

  connect(conTop.port_b, heaFloTop.port_a) 
    annotation (Line(points={{20,60},{30,60}}, color={191,0,0}));
  connect(conBot.port_b, heaFloBot.port_a) 
    annotation (Line(points={{20,20},{30,20}}, color={191,0,0}));
  connect(heaFloTop.port_b, heaPorTop) annotation (Line(points={{42,60},{52,60},
          {52,74},{20,74}}, color={191,0,0}));
  connect(heaFloBot.port_b, heaPorBot) annotation (Line(points={{42,20},{44,20},
          {44,-74},{20,-74}}, color={191,0,0}));
  connect(heaFloTop.Q_flow, mul.u1[1]) annotation (Line(points={{36,54},{50,54},
          {50,52.5},{61.2,52.5}}, color={0,0,127}));
  connect(heaFloSid.Q_flow, mul.u2) annotation (Line(points={{36,34},{50,34},{
          50,49},{61.2,49}}, color={0,0,127}));
  connect(heaFloBot.Q_flow, mul.u3[1]) annotation (Line(points={{36,14},{36,10},
          {58,10},{58,45.5},{61.2,45.5}}, color={0,0,127}));
  connect(mul.y, sum1.u) annotation (Line(points={{70.4,49},{76.8,49}}, color={
          0,0,127}));
  connect(sum1.y, Ql_flow) annotation (Line(points={{90.6,49},{98,49},{98,72},{
          110,72}}, color={0,0,127}));
end Stratified;
