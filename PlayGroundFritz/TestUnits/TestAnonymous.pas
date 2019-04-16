namespace ProHolz.CodeGen;

const TestAnonymous = "
unit TestBlocks;

interface

type
  tCallFunc = reference to function (var  b: Integer ) : Integer;

  procedure TestCall(var value : Integer; acallfunc : tCallFunc);
  procedure testDirect;

implementation


procedure TestCall(var value : integer; acallfunc : Tcallfunc);
begin
  value := acallfunc(value);
end;

procedure testDirect;
begin
 Testcall(
 function (const a : integer) : integer
 Var c : integer;
 const b : integer = 2;
 d = 5;
 begin
   c := 2;
   result := a*a;
 end
 );

end;
procedure testinDirect;
var ltemp : tCallFunc;
    val : Integer;
begin

  ltemp := function (var a : Integer) : Integer
  begin
    result := a*a;
  end;
  val := 3;
  TestCall(val, ltemp);
end;
end.

";

end.