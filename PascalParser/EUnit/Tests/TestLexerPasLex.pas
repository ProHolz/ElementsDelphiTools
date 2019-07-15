namespace ProHolz.Ast;

interface
uses
  RemObjects.Elements.EUnit;

type
  LexerPasTest =  class(Test)
  private
   fLexer : TmwPasLex;

  public

    procedure Setup; override;

    procedure Teardown; override;


    Procedure Test;

    Procedure Test2;

  end;

implementation


Procedure LexerPasTest.Test;
begin
   fLexer.Origin := 'Unit Test; interface implementation end.';
   Assert.AreEqual('Unit', fLexer.Token);

   fLexer.NextNoSpace;
   Assert.AreEqual(4, fLexer.TokenLen);
   Assert.AreEqual('TEST', fLexer.Token.ToUpper);
   fLexer.NextNoSpace;
   Assert.AreEqual(';', fLexer.Token);

   fLexer.InitAhead;
   Assert.AreEqual('interface'.ToUpper, fLexer.AheadLex.Token.ToUpper);


   fLexer.NextNoSpace;
   Assert.AreEqual('Interface'.ToUpper, fLexer.Token.ToUpper);
   fLexer.NextNoSpace;
   Assert.AreEqual('Implementation'.ToUpper, fLexer.Token.ToUpper);
   fLexer.NextNoSpace;

   Assert.AreEqual('END', fLexer.Token.ToUpper);
   fLexer.NextNoSpace;
   Assert.AreEqual('.', fLexer.Token);
   fLexer.NextNoSpace;
   Assert.AreEqual(TptTokenKind.ptNull ,  fLexer.TokenID);

end;


Procedure LexerPasTest.Test2;
begin
   fLexer.Origin := 'Unit Test; interface  procedure Test; begin end;  implementation end.';
   Assert.AreEqual('Unit', fLexer.Token);

   fLexer.NextNoSpace;
   Assert.AreEqual(4, fLexer.TokenLen);
   Assert.AreEqual('TEST', fLexer.Token.ToUpper);
   fLexer.NextNoSpace;
   Assert.AreEqual(';', fLexer.Token);

   fLexer.InitAhead;
   Assert.AreEqual('interface'.ToUpper, fLexer.AheadLex.Token.ToUpper);


   fLexer.NextNoSpace;
   Assert.AreEqual('Interface'.ToUpper, fLexer.Token.ToUpper);
   fLexer.NextNoSpace;

   Assert.AreEqual('Procedure'.ToUpper, fLexer.Token.ToUpper);
   fLexer.NextNoSpace;


   Assert.AreEqual('test'.ToUpper, fLexer.Token.ToUpper);
   fLexer.NextNoSpace;

   Assert.AreEqual(';', fLexer.Token);
   fLexer.NextNoSpace;


   Assert.AreEqual('begin'.ToUpper, fLexer.Token.ToUpper);
   fLexer.NextNoSpace;


   Assert.AreEqual('end'.ToUpper, fLexer.Token.ToUpper);
   fLexer.NextNoSpace;

    Assert.AreEqual(';', fLexer.Token);
   fLexer.NextNoSpace;

   Assert.AreEqual('Implementation'.ToUpper, fLexer.Token.ToUpper);
   fLexer.NextNoSpace;

   Assert.AreEqual('END', fLexer.Token.ToUpper);
   fLexer.NextNoSpace;
   Assert.AreEqual('.', fLexer.Token);
   fLexer.NextNoSpace;
   Assert.AreEqual(TptTokenKind.ptNull ,  fLexer.TokenID);

end;


procedure LexerPasTest.Setup;
begin
   fLexer := new TmwPasLex(DelphiCompiler.Default);
end;

procedure LexerPasTest.Teardown;
begin

end;

end.