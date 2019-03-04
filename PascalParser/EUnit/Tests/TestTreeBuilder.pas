namespace PascalParser;

interface

uses
  RemObjects.Elements.EUnit;

type
  TestTreeBuilder = public class(Test)
  private

    method FirstTest;
    method TestCompilerVersions;

    method TestCompilerDirectives;
  public

    method TestSynEditUnit;
    method TestSynEditUnitFromFile;
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
    Source := File.ReadText("/Volumes/HD2/Projekte/SynEdit/Source/SynEditMiscClasses.pas")
    else
    Source := File.ReadText("X:\Projekte\SynEdit\Source\SynEditMiscClasses.pas");

  try
    Builder.RunWithString(Source );
  except
    on E : Exception do
      Assert.Fail(E.Message);
  end;
end;

end.