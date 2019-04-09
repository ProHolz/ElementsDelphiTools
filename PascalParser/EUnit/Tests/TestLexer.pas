namespace ProHolz.Ast;

interface
uses
  RemObjects.Elements.EUnit;


type
  LexerTest =  class(Test)
  private

   fLexer : TmwBasePasLex;
    method TestElements;
  public
    method Setup; override;
    procedure Teardown; override;

    method Test;

  end;

implementation


method LexerTest.Test;
begin
   fLexer.Origin := 'Unit Test; interface implementation end.';
   Assert.AreEqual('Unit', fLexer.Token);
   fLexer.NextNoSpace;
   Assert.AreEqual(4, fLexer.TokenLen);
   Assert.AreEqual('TEST', fLexer.Token.ToUpper);
   fLexer.NextNoSpace;
   Assert.AreEqual(';', fLexer.Token);
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

method LexerTest.TestElements;
begin

   fLexer.Origin := 'NameSpace Test; interface implementation end.';
  Assert.AreEqual(fLexer.Token, 'NameSpace');
   fLexer.NextNoSpace;
   Assert.AreEqual(4, fLexer.TokenLen);
  Assert.AreEqual('Test', fLexer.Token);
   fLexer.NextNoSpace;
   Assert.AreEqual(';', fLexer.Token);
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


method LexerTest.Setup;
begin
   fLexer := new TmwBasePasLex(DelphiCompiler.dcDefault);
end;

method LexerTest.Teardown;
begin

end;


//procedure LexerTest.TestMhashTable;
//begin
  //Assert.AreEqual(0,  mHashTable[#0]);
  //Assert.AreEqual(0,  mHashTable[#1]);
  //Assert.AreEqual(21,  mHashTable['u']);
  //Assert.AreEqual(22,  mHashTable['v']);

//end;

end.