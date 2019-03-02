namespace PascalParser;

interface

uses
  RemObjects.Elements.EUnit;

type
  TestTreeBuilder = public class(Test)
  private


    method FirstTest;
    method TestCompilerVersions;
  public
    method TestCompilerDirectives;
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
 Check.DoesNotThrows(->Builder.RunWithString(cCompilerVersions28));
 Check.DoesNotThrows(->Builder.RunWithString(cCompilerVersionsGreater28));

 Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.dcRio);
 Check.Throws(->Builder.RunWithString(cCompilerVersions28));
 Check.Throws(->Builder.RunWithString(cCompilerVersionsGreater28));

end;

method TestTreeBuilder.TestCompilerDirectives;
begin
  var Builder := new TPasSyntaxTreeBuilder(DelphiCompiler.dcXe7);
 //try
  //var node :=  Builder.RunWithString(cTestEmptyUnit);
 //except
   //on E : Exception do
   //Assert.Fail(E.Message);
 //end;
 try
  Builder.RunWithString(cTestCompilerDirectives);
 except
   on E : Exception do
     Assert.Fail(E.Message);
 end;
end;

end.