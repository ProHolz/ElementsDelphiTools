﻿namespace ProHolz.Ast;

interface

uses

  RemObjects.Elements.EUnit;

type
  TestBinaryReadeWriter = public class(Test)
  private
  protected
  public
    method FirstTest;

    method testBinaryXML;


  end;

implementation

method TestBinaryReadeWriter.FirstTest;

begin
 var Stream := new MemoryStream();
 Var node := new TSyntaxNode(TSyntaxNodeType.ntUnknown);
 var child := new TValuedSyntaxNode(TSyntaxNodeType.ntBounds);
 child.Value := 'Das ist ein Test';
 node.ChildNodes.Add(child);

  node.AddChild(TSyntaxNodeType.ntCaseElse);


 Var B := new TBinarySerializer();
 Check.IsTrue( B.Write(Stream, node));
 Stream.Position := 0;

 var Root : TSyntaxNode;
  Check.IsTrue(B.Read(Stream, var Root));
Check.IsNotNil(Root);
Assert.AreEqual(2, Root.ChildNodes.Count);
 child := Root.ChildNodes[0] as TValuedSyntaxNode;
  Check.AreEqual(child.Typ, TSyntaxNodeType.ntBounds);
  Check.AreEqual(child.Value , 'Das ist ein Test');

end;

method TestBinaryReadeWriter.testBinaryXML;
begin
  const
  cBinaryXml =
  " unit TestPublic;

interface
 uses
   Windows,
   Sysutils,
   Classes;

  type
    testRecord = record
       x,y : integer;
    end;

{$IFDEF UNICODE}

{$ELSE}
  bla
{$ENDIF}

{$IFDEF TOKYO}
bla
{$ELSE}

{$ENDIF}


   testRecord2 = record
       x,y : integer;
    end;

   const T : testrecord = (X:1; y:2);

  type
   testclass = class
   public
     destructor Done;
   end;

   Itest = interface
   end;

    testclass2 = class(ITest)
    public
    constructor one;
    constructor two;

   end;

implementation
 uses
  System.Math;
type
  implclass = class
  end;


procedure TestWidth;
begin
 with a do
   begin
    end;
end;

end.
";

  var  Root := TPasSyntaxTreeBuilder.RunWithString(cBinaryXml, false);
  var Xml := TSyntaxTreeWriter.ToXML(Root, true);
  var Stream := new MemoryStream();
  Var B := new TBinarySerializer();
  Check.IsTrue( B.Write(Stream, Root));
  Stream.Position := 0;
  Stream.Position := 0;
  Root := nil;
  Check.IsTrue(B.Read(Stream, var Root));
  var Xml2 := TSyntaxTreeWriter.ToXML(Root, true);
  Check.AreEqual(Xml, Xml2);

end;

end.