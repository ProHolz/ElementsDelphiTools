namespace ProHolz.SourceChecker;

interface

uses
  RemObjects.Elements.EUnit,
  ProHolz.Ast;


type
  TestSyntaxNodeSolver = public class(Test)
  private

    FSolver : ISyntaxNodeSolver;
  protected
    method PrepareSimpleUnit : TSyntaxNode;
    method PrepareSimpleUnitWithUses: TSyntaxNode;
    method prepareUnitWithType : TSyntaxNode;
  public
   method Setup; override;
    method SimpleUnit;
    method SimpleUnitWithUses;
    method SimpleUnitWithUsesArray;
    method UnitWithGlobalTypes;
    method TestGetPublicClass;

  end;

implementation


method TestSyntaxNodeSolver.Setup;
begin
  FSolver := new TSyntaxNodeResolver();
end;


method TestSyntaxNodeSolver.PrepareSimpleUnit: TSyntaxNode;
begin
  const simple = 'Unit Test; interface implementation end.';
 result := TPasSyntaxTreeBuilder.RunWithString(simple, false);
end;

method TestSyntaxNodeSolver.PrepareSimpleUnitWithUses: TSyntaxNode;
begin
  const simple = 'Unit Test; interface uses Test, System.Sysutils; implementation uses U1, u2, u3; end.';
  result := TPasSyntaxTreeBuilder.RunWithString(simple, false);
end;


method TestSyntaxNodeSolver.prepareUnitWithType: TSyntaxNode;
begin
  result := TPasSyntaxTreeBuilder.RunWithString(cTest1, false);
end;

method TestSyntaxNodeSolver.SimpleUnit;
begin
  Assert.IsNotNil(FSolver);
  var node := PrepareSimpleUnit;
  Assert.IsNotNil(node);
  Assert.AreEqual(node.Typ, TSyntaxNodeType.ntUnit);
  Check.AreEqual(FSolver.getNode(TSyntaxNodeType.ntInterface, node).Typ, TSyntaxNodeType.ntInterface);
  Check.AreEqual(FSolver.getNode(TSyntaxNodeType.ntImplementation, node).Typ, TSyntaxNodeType.ntImplementation);

end;

method TestSyntaxNodeSolver.SimpleUnitWithUses;
begin
  Assert.IsNotNil(FSolver);
  var node := PrepareSimpleUnitWithUses;
  Assert.IsNotNil(node);
  Assert.AreEqual(node.Typ, TSyntaxNodeType.ntUnit);
  var lInterfacenode := FSolver.getNode(TSyntaxNodeType.ntInterface, node);
  var lusesNode := FSolver.getNode(TSyntaxNodeType.ntUses, lInterfacenode);
  Assert.IsNotNil(lusesNode);
  var lnodes := FSolver.getNodeArray(TSyntaxNodeType.ntUnit, lusesNode);
  Assert.IsNotNil(lnodes);
  Check.AreEqual(lnodes.Count, 2);


end;

method TestSyntaxNodeSolver.SimpleUnitWithUsesArray;
begin
  Assert.IsNotNil(FSolver);
  var node := PrepareSimpleUnitWithUses;
  Assert.IsNotNil(node);
  Assert.AreEqual(node.Typ, TSyntaxNodeType.ntUnit);
  var lnodes := FSolver.getNodeArrayAll([SNT.ntInterface, SNT.ntUses, SNT.ntUnit], node);
  Assert.IsNotNil(lnodes);
  Check.AreEqual(lnodes.Count, 2);

   lnodes := FSolver.getNodeArrayAll([SNT.ntImplementation, SNT.ntUses, SNT.ntUnit], node);
  Assert.IsNotNil(lnodes);
  Check.AreEqual(lnodes.Count, 3);
end;


method TestSyntaxNodeSolver.UnitWithGlobalTypes;
begin
  Assert.IsNotNil(FSolver);
  var node := prepareUnitWithType;
  Assert.IsNotNil(node);
  Assert.AreEqual(node.Typ, TSyntaxNodeType.ntUnit);
  var lnodes := FSolver.getNodeArrayAll([SNT.ntInterface, SNT.ntUses, SNT.ntUnit], node);
  Assert.IsNotNil(lnodes);
  Check.AreEqual(lnodes.Count, 3);

  lnodes := FSolver.getNodeArrayAll([SNT.ntImplementation, SNT.ntUses, SNT.ntUnit], node);
  Assert.IsNotNil(lnodes);
  Check.AreEqual(lnodes.Count, 1);

  lnodes := FSolver.getPublicRecord(node);
  Check.AreEqual(lnodes.Count, 2);

  lnodes := FSolver.getPublicClass(node);
  Check.AreEqual(lnodes.Count, 2);

end;

method TestSyntaxNodeSolver.TestGetPublicClass;
begin

// const  lPublicTypesInterface = [SNT.ntInterface, SNT.ntTypeSection ]; //
  var node := prepareUnitWithType;
  var lClasses := FSolver.getPublicClass(node);
  Assert.AreEqual(lClasses.Count,2);

var lnodes := FSolver.getPublicTypes(node, 'class');

Check.AreEqual(lnodes:Count, 2);

end;



end.