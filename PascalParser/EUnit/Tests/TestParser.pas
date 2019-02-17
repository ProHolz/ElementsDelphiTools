unit TestParser;

interface
uses
{$IF ELEMENTS}
  RemObjects.Elements.EUnit,
{$ELSE}
  Sysutils,
  Dunitx.ElementsHelper,
{$ENDIF}
  DUnitX.TestFramework,
  SimpleParser.Lexer.Types,
  SimpleParser,
  DelphiAst.Classes;

type
 [TestFixture]
  ParserTest =  class(TTest)
  private
   fParser : TmwSimplePasPar;

  public
    [Setup]
    procedure Setup; override;
    [TearDown]
    procedure TearDown; override;

  [Test]
    Procedure Test;
  end;

implementation



procedure ParserTest.Setup;
begin
   {$IFNDEF ELEMENTS}
   fParser:= TmwSimplePasPar.Create;
   Assert.IsNotNull(fParser);
  {$ELSE}
   fParser := new TmwSimplePasPar();
  {$ENDIF}
end;

procedure ParserTest.TearDown;
begin
  {$IFNDEF ELEMENTS}
   fParser.Free;
  {$ENDIF}
end;


Procedure ParserTest.Test;
begin

end;



 {$IFNDEF ELEMENTS}
initialization
  TDUnitX.RegisterTestFixture(ParserTest);
{$ENDIF}
end.
