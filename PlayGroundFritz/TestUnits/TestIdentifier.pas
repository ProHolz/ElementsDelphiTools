namespace ProHolz.CodeGen;
const TestIndentifier = "
 unit TestLoops;

interface


implementation

function  TestResult : integer;
var i : integer;
    lvalue : integer;
    p : Pointer;

begin
  lvalue := 10;
  result := 0;
   for i := 0 to 10 do
     begin
       result := result + lValue;
       inc(result);
       dec(result);
       p := nil;

     end;
end;
end.
";

end.