namespace ProHolz.Ast;

interface
uses
  RemObjects.Elements.EUnit;

type
  ClassesTest =  class(Test)
  public
    Procedure Test;
    Procedure TestClone;
  end;

implementation


Procedure ClassesTest.Test;
Var lNode, lClone : TSyntaxNode;
begin
  lNode := new TSyntaxNode(TSyntaxNodeType.ntUnknown);

  Assert.AreEqual(TSyntaxNodeType.ntUnknown,  lNode.Typ);
  Assert.IsFalse(lNode.HasChildren);
  Assert.IsFalse(lNode.HasAttributes);
  Assert.IsFalse(lNode.HasAttribute(TAttributeName.anType));
  lNode.SetAttribute(TAttributeName.anType, 'integer');
  Assert.IsTrue(lNode.HasAttribute(TAttributeName.anType));
  Assert.IsTrue(lNode.HasAttributes);
  lNode.ClearAttributes;
  Assert.IsFalse(lNode.HasAttributes);
  lNode.SetAttribute(TAttributeName.anType, 'integer');
  lNode.SetAttribute(TAttributeName.anVisibility, 'public');
  Assert.IsTrue(lNode.HasAttributes);

  Assert.AreEqual('integer', lNode.GetAttribute(TAttributeName.anType));
  Assert.AreEqual('public', lNode.GetAttribute(TAttributeName.anVisibility));

  lClone := lNode.Clone;
  Assert.IsFalse(lClone = nil);

  Assert.AreEqual('integer', lClone.GetAttribute(TAttributeName.anType));
  Assert.AreEqual('public', lClone.GetAttribute(TAttributeName.anVisibility));


end;

procedure ClassesTest.TestClone;
Var lNode,
    lClone : TSyntaxNode;
begin
 lClone := nil;

  lNode := new TValuedSyntaxNode(TSyntaxNodeType.ntUnknown);

  TValuedSyntaxNode(lNode).Value := 'Test';
  Assert.AreEqual('Test', TValuedSyntaxNode(lNode).Value);

  lClone := lNode.Clone;

  Assert.AreEqual('Test', TValuedSyntaxNode(lClone).Value);



end;



end.