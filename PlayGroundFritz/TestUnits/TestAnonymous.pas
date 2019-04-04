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
var val : Integer;
begin
  val := 2;
  TestCall(val,
  function (var a : Integer) : Integer
  begin
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