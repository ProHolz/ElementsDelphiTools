namespace PlayGroundFritz;

const TestAnonymous = "
unit TestAnonTypes;

interface

type
 tCallFunc = reference to function (const a: integer ) : integer;
 tCallFuncTArray = reference to function (const a: Tarray<integer>) : integer;

 procedure TestCall(acallfunc : Tcallfunc);
 procedure testDirect;

implementation


procedure TestCall(acallfunc : Tcallfunc);
Var a : integer;
begin
 a := acallfunc(1);
end;

procedure testDirect;
begin
 Testcall(
 function (const a : integer) : integer
 begin
   result := a*a;
 end
 );

end;

procedure testinDirect;
var ltemp : tCallFunc;
begin

 ltemp := function (const a : integer) : integer
 begin
   result := a*a;
 end;

 TestCall(ltemp);


end;



end.


";

end.