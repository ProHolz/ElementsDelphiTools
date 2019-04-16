namespace ProHolz.CodeGen;


// Will only parsed in Interface

const TestMethods = "
unit TestMethods;

interface
 uses sysutils;
type
 eEnum = (first, second);
 intArray = Array of integer;

const
 intConst = 42;


function TestFuncInt: integer;
function TestFuncInt2(): integer;

 // Also test callingConvention  and const, var out
function TestFuncString: string; cdecl;
function TestFuncString2(value: string): string; stdcall;
function TestFuncString3(const value: string): string;  register;  // This is the default in Delphi
function TestFuncString4(var value: string): string;  pascal;
function TestFuncString5(out value: string): string;  safecall;

// Default String Params
function TestFuncString6(const value: string = 'Test'): string;
function TestFuncString7(value: string = 'Test'): string;

// Default Integer Params
function TestFuncDefaultInt(const value: integer = 42): string;
function TestFuncDefaultInt2(value: integer = intConst): string;

//  Arrays

function TestOpenArray(const value : Array of integer): boolean;

//function TestOpenArray(const value : intArray): boolean;
// Enum
function TestEnum(value : eEnum) :  eEnum;
function TestEnum2(const value : eEnum = first) :  eEnum;

procedure TestArray(const cintArray : intArray = []);


implementation

function TestFuncInt: integer;
begin
  result := 1;
end;

function TestFuncInt2(): integer;
begin
    result := 2;
end;

function TestFuncString: string; cdecl;
begin
    result := 'Hello';
end;

function TestFuncString2(value: string): string;
begin
  result := Value;
end;

function TestFuncString3(const value: string): string;
begin
  result := Value+' Test';
end;

function TestFuncString4(var value: string): string;
begin
   Value := Value+' Test';
   result := Value;
end;

function TestFuncString5(out value: string): string;
begin
 result := 'Hello';
 value := result;
end;

function TestFuncString6(const value: string = 'Test'): string;
begin
   result := value;
end;

function TestFuncString7(value: string = 'Test'): string;
begin
  result := value;
end;


function TestOpenArray(const value : Array of integer): boolean;
var i : integer;
begin
  for i := low(value) to High(Value) do
  begin
    Start1();
    Start2();
  end;
end;


function TestEnum(value : eEnum) :  eEnum;
begin
  result := value;
end;

function TestEnum2(const value : eEnum = first) :  eEnum;
begin
  result := value;
end;



function TestFuncDefaultInt(const value: integer = 42): string;
begin
  result := value.toString;
end;

function TestFuncDefaultInt2(value: integer = intConst): string;
begin
  result := value.toString;
end;


procedure TestArray(const cintArray : intArray = []);
var i : integer;
const b : integer = 2;
 cnames : Array[0..1] of String = ('Test', 'Test2');
begin
  for I in cintArray do
   begin
    Start(a,b);
    Start2();
   end;

end;

procedure SimpleIf;
begin
  if true then start(true);
end;

procedure SimpleIfElse;
begin
  if true then start(true) else Start(false);
end;

procedure SimpleIfWithBegin;
begin
  if (true or 2) then
  begin
    start(true);
    a := a / 2;
    if b then begin
    start(false);
    end;
   end;
end;

procedure SimpleIfElseWithBegin;
begin
  if (true or 2) then
  begin
    start(true);
    a := a / 2;
    if b then begin
    start(false);
    end
    else d := false;
   end
   else
    begin
      c := 12;
    end;
end;

procedure SimpleWhile;
begin
  while true do start(true);

end;

procedure SimpleWhileBeginEnd;
begin
  while (getIndex(i) and Test) > 3 do
    begin
      start(true);
      start2(true);
    end;

end;


procedure SimpleRepeat;
begin
  repeat
    start(true);
  until false;

end;


procedure ComplexerRepeat;
begin
  repeat
    start(true);
    start2(true);
  until not getNext(a);

end;

end.

";


end.