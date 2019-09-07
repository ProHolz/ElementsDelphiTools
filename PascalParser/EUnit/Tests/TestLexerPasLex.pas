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

    Procedure TestNumbers;

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


Procedure LexerPasTest.TestNumbers;
begin
   fLexer.Origin :=
    "  100
      -100
      10.00
      -10.00
      1.123E4
      END
     ";


  fLexer.NextNoSpace;
  Assert.AreEqual(fLexer.Token.ToUpper, '100');
  Assert.AreEqual(TptTokenKind.ptIntegerConst ,  fLexer.TokenID);

  fLexer.NextNoSpace;
  Assert.AreEqual(fLexer.Token.ToUpper, '-');
  Assert.AreEqual(TptTokenKind.ptMinus ,  fLexer.TokenID);


  fLexer.NextNoSpace;
  Assert.AreEqual(fLexer.Token.ToUpper, '100');
  Assert.AreEqual(TptTokenKind.ptIntegerConst ,  fLexer.TokenID);

  fLexer.NextNoSpace;
  Assert.AreEqual(fLexer.Token.ToUpper, '10.00');
  Assert.AreEqual(TptTokenKind.ptFloat ,  fLexer.TokenID);

  fLexer.NextNoSpace;
  Assert.AreEqual(fLexer.Token.ToUpper, '-');
  Assert.AreEqual(TptTokenKind.ptMinus ,  fLexer.TokenID);

  fLexer.NextNoSpace;
  Assert.AreEqual(fLexer.Token.ToUpper, '10.00');
  Assert.AreEqual(TptTokenKind.ptFloat ,  fLexer.TokenID);

  fLexer.NextNoSpace;
  Assert.AreEqual(fLexer.Token.ToUpper, '1.123E4');
  Assert.AreEqual(TptTokenKind.ptFloat ,  fLexer.TokenID);

  fLexer.NextNoSpace;
  Assert.AreEqual(fLexer.Token.ToUpper, 'END');


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