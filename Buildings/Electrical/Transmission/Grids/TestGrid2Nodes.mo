within Buildings.Electrical.Transmission.Grids;
record TestGrid2Nodes "Simple model of a grid with 2 nodes and 1 link"
  extends Buildings.Electrical.Transmission.Grids.PartialGrid(
    nNodes=2,
    nLinks=1,
    FromTo=[[1,2]],
    L=[200],
    cables={LowVoltageCables.Cu35()});
  annotation (Documentation(info="<html>
<p>
This model represents a simple grid with two nodes and a single link between them.
</p>
<p>
The picture below describes the grid topology.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/Transmission/Grids/testGrid2Nodes.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
June 3, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>"));
end TestGrid2Nodes;
