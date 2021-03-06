﻿namespace ProHolz.Ast;

interface

uses
  RemObjects.Elements.EUnit;

type
  TestTreeBuilder = public class(Test)
  private

    // Only used internal for FW
    method TestSynEditUnitFromFile;

  public
    method TestNames;
    method TestAsm;
    method TestNameSpace;

    method TestCompilerVersions;
    method TestCompilerDirectives;
    method TestSynEditUnit;
    method TestVariantRecord;
    method TestConstArrays;
    method TestCommentPositions;
    method TestCommentPositions2;

  end;

implementation

method TestTreeBuilder.TestCompilerVersions;
begin
  var Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.Xe7);
 //

  Check.DoesNotThrows(->Builder.RunwithString(cCompilerVersions28));
  // Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.dcXe7);
  Check.DoesNotThrows(->Builder.RunWithString(cCompilerVersionsGreater28));

  Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.Rio);
  Check.Throws(->Builder.RunWithString(cCompilerVersions28));
  Check.Throws(->Builder.RunWithString(cCompilerVersionsGreater28));

end;

method TestTreeBuilder.TestCompilerDirectives;
begin
  var Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.Xe7);

  try
    Builder.RunWithString(cTestCompilerDirectives );
  except
    on E : Exception do
      Assert.Fail(E.Message);
  end;
end;

method TestTreeBuilder.TestSynEditUnit;
begin
  var Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.Xe7);
  try
    Builder.RunWithString(ctestSyn );
  except
    on E : Exception do
      Assert.Fail(E.Message);
  end;
end;

method TestTreeBuilder.TestSynEditUnitFromFile;
begin
  var Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.Xe7);
  var Source : String;
  if Environment.OS = OperatingSystem.macOS then
    Source := File.ReadText("/Volumes/HD2/Projekte/SynEdit/Source/SynUsp10.pas")
  else
    Source := File.ReadText("X:\Projekte\SynEdit\Source\SynUsp10.pas");

  try
    Builder.RunWithString(Source );
  except
    on E : Exception do
      Assert.Fail(E.Message);
  end;
end;

method TestTreeBuilder.TestVariantRecord;
begin
  const
ctestVariantRecord ="
unit Test;
interface
type
  TSQLVar = record
    case VType: STQLDBFieldType of
    ftInt64: (
      VInt64: Int64);
    ftDouble: (
      VDouble: double);
    ftDate: (
      VDateTime: TDateTime);
    ftCurrency: (
      VCurrency: Currency);
    ftUTF8: (
      VText: PUTF8Char);
    ftBlob: (
      VBlob: pointer;
      VBlobLen: Integer)
  end;

 TSQLVarVType = record
  VSingle : TSQLDBFieldType;
   case TSQLDBFieldType of
    ftInt64: (
      VInt64: Int64);
    ftDouble: (
      VDouble: double);
    ftDate: (
      VDateTime: TDateTime);
    ftCurrency: (
      VCurrency: Currency);
    ftUTF8: (
      VText: PUTF8Char);
    ftBlob: (
      VBlob: pointer;
      VBlobLen: Integer)
  end;

 implementation
end.
";

  var Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.Xe7);

  try
    Builder.RunWithString(ctestVariantRecord );
  except
    on E : Exception do
      Assert.Fail(E.Message);
  end;
end;

method TestTreeBuilder.TestConstArrays;
begin
  var Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.Xe7);
  Var Root := Builder.RunWithString(cTestArray );

  Var lConsts := Root.FindNode(TSyntaxNodeType.ntInterface):FindChilds(TSyntaxNodeType.ntConstants);
  Assert.AreEqual(length(lConsts), 1);
  Assert.AreEqual(lConsts[0].ChildCount, 2);
  Var const1 := lConsts[0].ChildNodes[0];
  Var const2 := lConsts[0].ChildNodes[1];
  Check.IsNotNil(const1.FindNode(TSyntaxNodeType.ntValue).FindNode(TSyntaxNodeType.ntExpressions));
  Check.IsNotNil(const2.FindNode(TSyntaxNodeType.ntValue).FindNode(TSyntaxNodeType.ntExpression));
end;

method TestTreeBuilder.TestNames;
begin
  var Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.Xe7);
  Var Root := Builder.RunWithString(cTestClassMethodNames );
  var node := Root.FindNode(TSyntaxNodeType.ntInterface):FindNode(TSyntaxNodeType.ntTypeSection);
  Assert.IsnotNil(node);
  for each ltypedecl in node.FindChilds(TSyntaxNodeType.ntTypeDecl) do
    for each ltype in ltypedecl.ChildNodes.Where(Item->Item.Typ = TSyntaxNodeType.ntType)  do
      begin
      if ltype.AttribType.ToLower = 'class' then
      begin
        for each proc in ltype.FindNode(TSyntaxNodeType.ntPublic):FindChilds(TSyntaxNodeType.ntMethod) index i do
          begin
          var s := proc.FindNode(TSyntaxNodeType.ntName):AttribName.ToLower;
          case i of
            0 : Check.AreEqual(s, 'test<t>');
            1 : Check.AreEqual(s, 'create');
            2 : Check.AreEqual(s, 'destroy');
          end;
        end;
      end;
    end;
end;

method TestTreeBuilder.TestAsm;
begin
  var Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.Xe7);
  Var Root := Builder.RunWithString(cTestAsm );
  Check.AreEqual(Root.Typ, TSyntaxNodeType.ntUnit);
  //var Xml2 := TSyntaxTreeWriter.ToXML(Root, true);
  //File.WriteText('D:\Test\Testasm.xml', Xml2);
end;

method TestTreeBuilder.TestNameSpace;
begin
  var Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.Default);
  Var Root := Builder.RunWithString(cTestNamespace );
  Check.AreEqual(Root.Typ, TSyntaxNodeType.ntNamespace);
end;

method TestTreeBuilder.TestCommentPositions;
begin
  const  cTestComments =
"unit Test;
// First Test
  interface

  implementation

  // Test before Handler
  procedure Handler(Params: Pointer);
  begin
    if Params <> nil then // test for assigned
    begin
    end;
  end;

  {$DEFINE USEDEFINE}

  {$IFDEF USEDEFINE}

  // Comment before TestCommentInDefine
   procedure TestCommentInDefine;
   begin
  (*
        Test
   *)

  {
      Test
   }
   end;

  {$ENDIF}

  end.
";

  var Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.Default);
  Var Root := Builder.RunWithString(cTestComments );
  Check.AreEqual(Root.Typ, TSyntaxNodeType.ntUnit);
  Assert.AreEqual(Builder.Comments.Count, 6);
  for each matching node : TCommentNode in Builder.Comments index i do
    begin
    case i of
      0 : begin
          Check.AreEqual(node.Line,  2);
          Check.AreEqual(node.Col,  1);
          Check.AreEqual(node.Typ, TSyntaxNodeType.ntSlashesComment);

      end;
      1 : begin
        Check.AreEqual(node.Line,  7);
       // Check.AreEqual(node.Col,  2);
        Check.AreEqual(node.Typ, TSyntaxNodeType.ntSlashesComment);

      end;

      2 : begin
          Check.AreEqual(node.Line,  10);
        //  Check.AreEqual(node.Col,  25);
          Check.AreEqual(node.Typ, TSyntaxNodeType.ntSlashesComment);
        end;

      3 : begin
          Check.AreEqual(node.Line,  19);
          Check.AreEqual(node.Col,  3);
          Check.AreEqual(node.Typ, TSyntaxNodeType.ntSlashesComment);
        end;

  4 : begin
    Check.AreEqual(node.Line,  24);
    Check.AreEqual(node.Col,  3);
    Check.AreEqual(node.Typ, TSyntaxNodeType.ntAnsiComment);
  end;

  5 : begin
    Check.AreEqual(node.Line,  28);
    Check.AreEqual(node.Col,  3);
    Check.AreEqual(node.Typ, TSyntaxNodeType.ntBorComment);
  end;
end;
end;
end;

method TestTreeBuilder.TestCommentPositions2;
begin
  const  cTestComments =
  "unit Test;
   (*
     Test *)

    interface

    implementation
    // Comment before TestCommentInDefine
     procedure TestCommentInDefine;
     begin
    (*
          Test
      *)

    {
        Test
    }
     end;
   end.
  ";

  var Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.Default);
  Var Root := Builder.RunWithString(cTestComments );
  Check.AreEqual(Root.Typ, TSyntaxNodeType.ntUnit);
  Assert.AreEqual(Builder.Comments.Count, 4);
  for each matching node : TCommentNode in Builder.Comments index i do
    begin
    case i of
      0 : begin
          Check.AreEqual(node.Line,  3);
          Check.AreEqual(node.Col,  10);
          Check.AreEqual(node.Typ, TSyntaxNodeType.ntAnsiComment);

        end;

        1 : begin
          Check.AreEqual(node.Line,  8);
          Check.AreEqual(node.Col,  5);
          Check.AreEqual(node.Typ, TSyntaxNodeType.ntSlashesComment);

        end;
        2 : begin
          Check.AreEqual(node.Line,  13);
          Check.AreEqual(node.Col,  6);
          Check.AreEqual(node.Typ, TSyntaxNodeType.ntAnsiComment);

        end;

        3 : begin
          Check.AreEqual(node.Line,  17);
          Check.AreEqual(node.Col,  4);
          Check.AreEqual(node.Typ, TSyntaxNodeType.ntBorComment);
        end;
      end;
    end;
end;

end.