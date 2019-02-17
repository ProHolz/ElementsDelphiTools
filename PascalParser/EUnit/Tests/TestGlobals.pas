namespace PascalParser;

interface
uses
  RemObjects.Elements.EUnit;

type

  GlobalsTest =  class(Test)
    Procedure TestAnsiDequote;
    Procedure TestOneBasedFuncs;
  end;

implementation

Procedure GlobalsTest.TestAnsiDequote;
Var Test : String;
begin
   Test := "'Hallo'";
 Assert.AreEqual('''Hallo''', Test);
 Assert.AreEqual('Hallo', StrHelper.AnsiDequotedStr(Test, ''''));

end;

Procedure GlobalsTest.TestOneBasedFuncs;
// This test was used to find out a special Mistake in
// method TmwBasePasLex.EvaluateConditionalExpression(const AParams: String): Boolean;
// AParams was used for check the length, the Delphi copy igonres length aparams to long
// Elements Fails so i had to fix it
method DeleteOneBased(Var value : String; start : Integer; len : Integer); inline;
begin
  value := value.Remove(start-1, len);
end;

  method PosIndexOneBassed(const check : String; const Value : String) : Integer; inline;
  begin
    result := Value.IndexOf(check)+1;
  end;

  method CopyOneBased(const Value : String; start : Integer; len : Integer) : String;
  begin
    start := start -1;
    if len > (Value.Length-start) then
      len := Value.Length-start;
    result := Value.Substring(start, len);
  end;

  method CopyOneBasedTest(const Value : String; start : Integer; len : Integer) : String;
  begin
    result := Value.Substring(start-1, len);
  end;


  method TrimLeft(const Value : String) : String; inline;
  begin
    result := Value.TrimStart;
  end;


begin
  var LParams := 'DEFINED(TEST)';
  var LDefine := CopyOneBased(LParams, 9, PosIndexOneBassed(')', LParams) - 9);
  Assert.AreEqual(LDefine, 'TEST');
  LParams := TrimLeft(CopyOneBasedTest(LParams, 10 + length(LDefine), length(LParams) - (9 + length(LDefine))));
  Assert.AreEqual(LParams, '');

end;

end.