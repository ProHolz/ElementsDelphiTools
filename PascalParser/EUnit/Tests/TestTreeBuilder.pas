namespace ProHolz.Ast;

interface

uses
  RemObjects.Elements.EUnit;

type
  TestTreeBuilder = public class(Test)
  private
    // Only used internal for FW
    method TestSynEditUnitFromFile;

    method FirstTest;
    method TestCompilerVersions;
    method TestCompilerDirectives;
    method TestSynEditUnit;
    method TestVariantRecord;
    method TestConstArrays;
   public
     method TestNames;
     method TestAsm;

  end;

implementation

method TestTreeBuilder.FirstTest;
begin
 var Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.dcXe7);
 try
  Builder.RunWithString(cBinaryXml);
 except
   on E : Exception do
     Assert.Fail(E.Message);
 end;
// var  Root := TPasSyntaxTreeBuilder.RunWithString(cBinaryXml, false);
end;


method TestTreeBuilder.TestCompilerVersions;
begin
 var Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.dcXe7);
//

 Check.DoesNotThrows(->Builder.RunwithString(cCompilerVersions28));
 // Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.dcXe7);
 Check.DoesNotThrows(->Builder.RunWithString(cCompilerVersionsGreater28));

 Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.dcRio);
 Check.Throws(->Builder.RunWithString(cCompilerVersions28));
 Check.Throws(->Builder.RunWithString(cCompilerVersionsGreater28));

end;

method TestTreeBuilder.TestCompilerDirectives;
begin
  var Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.dcXe7);

 try
  Builder.RunWithString(cTestCompilerDirectives );
 except
   on E : Exception do
     Assert.Fail(E.Message);
 end;
end;

method TestTreeBuilder.TestSynEditUnit;
begin
  var Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.dcXe7);

  try
    Builder.RunWithString(ctestSyn );
  except
    on E : Exception do
      Assert.Fail(E.Message);
  end;
end;

method TestTreeBuilder.TestSynEditUnitFromFile;
begin
  var Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.dcXe7);
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
  var Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.dcXe7);

  try
    Builder.RunWithString(ctestVariantRecord );
  except
    on E : Exception do
      Assert.Fail(E.Message);
  end;
end;

method TestTreeBuilder.TestConstArrays;
begin
  var Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.dcXe7);
  Var Root := Builder.RunWithString(cTestArray );

  Var lConsts := Root.FindNode(TSyntaxNodeType.ntInterface):FindChilds(TSyntaxNodeType.ntConstants);
  Assert.AreEqual(length(lConsts), 1);
  Assert.AreEqual(lConsts[0].ChildCount, 2);
  Var const1 := lConsts[0].ChildNodes[0];
  Var const2 := lConsts[0].ChildNodes[1];
  Check.IsNotNil(const1.FindNode(TSyntaxNodeType.ntValue).FindNode(TSyntaxNodeType.ntExpression));
  Check.IsNotNil(const2.FindNode(TSyntaxNodeType.ntValue).FindNode(TSyntaxNodeType.ntExpression));
end;

method TestTreeBuilder.TestNames;
begin
  var Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.dcXe7);
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
  var Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.dcXe7);
  Var Root := Builder.RunWithString(cTestAsm );
  //var Xml2 := TSyntaxTreeWriter.ToXML(Root, true);
  //File.WriteText('D:\Test\Testasm.xml', Xml2);

end;



end.