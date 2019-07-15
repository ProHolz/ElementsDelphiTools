namespace ProHolz.Ast;

interface
uses
  RemObjects.Elements.EUnit;
type
  NodeStackTest =  class(Test)
  private
   procedure onStringEvent(var s: String);
  public
    Procedure Test;
  end;

implementation


Procedure NodeStackTest.Test;
Var lNodeStack : TNodeStack;
    lLexer : TPasLexer;
begin
    lLexer := new TPasLexer(new TmwPasLex(DelphiCompiler.Default), @onStringEvent);
   lNodeStack := new TNodeStack(lLexer);

   Assert.AreEqual(0, lNodeStack.Count);
   lNodeStack.Push(TSyntaxNode.Create(TSyntaxNodeType.ntUnknown));
   Assert.AreEqual(1, lNodeStack.Count, 'Count should be 1');

   lNodeStack.AddChild(TSyntaxNode.Create(TSyntaxNodeType.ntUnit));
   Assert.AreEqual(1, lNodeStack.Count, 'Count should be 1');

   lNodeStack.Push(TSyntaxNodeType.ntAnd);
   Assert.AreEqual(2, lNodeStack.Count, 'Count should be 2');

   lNodeStack.AddChild(TSyntaxNodeType.ntAnd);
   Assert.AreEqual(true, lNodeStack.Peek.HasChildren, 'should have Childrean');

   lNodeStack.Pop;
   Assert.AreEqual(1, lNodeStack.Count, 'Count should be 1');

   lNodeStack.Pop;
   Assert.AreEqual(0, lNodeStack.Count, 'Count should be 0');


end;


procedure NodeStackTest.onStringEvent(var s: string);
begin
  ;
end;


end.