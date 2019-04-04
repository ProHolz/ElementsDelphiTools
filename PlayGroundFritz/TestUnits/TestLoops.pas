namespace ProHolz.CodeGen;
const TestLoops = "
unit TestLoops;

interface


implementation

procedure ForLoopUpDown;
var i : integer;
    lvalue : integer;
begin
 lValue := 0;
  for I := 1 to 10 do
   lvalue := lValue + i;


   for I := 10 downto 1 do
   lvalue := lValue - i;

  if lvalue <> 0 then
  begin

  end;
end;

procedure ForEachLoop;
var i : integer;
    larray : Array of integer;
    lvalue : integer;
begin
 larray := [0,1,2,3];
 lValue := 0;
 for I in larray do
   lvalue := lValue + i;

end;

 procedure WhileLoop;
  var
  lvalue : integer;
 begin
   lValue := 0;
   while lvalue = 0 do inc(lvalue);

    while lvalue = 0 do
    begin
      lValue := 3;
      inc(lvalue);
    end;

 end;

 procedure RepeatLoop;
  var
  lvalue : integer;
 begin
   lValue := 0;

   repeat
    lvalue := lvalue+2;

   until lvalue > 1000;

 end;

end.

";

end.