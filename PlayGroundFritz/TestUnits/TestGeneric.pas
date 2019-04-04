namespace ProHolz.CodeGen;

const TestGeneric = "
unit TestGeneric;

interface

type
TGenericClass = class
 procedure Test;
end;

TGenericClass<T> = class
 private
 fData : Array of T;
  b : integer;
 public
 constructor Create;
 procedure Test<A>;  overload;
 procedure Test;  overload;

end;

implementation

constructor TGenericClass<T>.Create;
begin

end;

procedure TGenericClass<T>.Test<A>;
begin
  b := 1;
end;

procedure TGenericClass.Test;
begin
  b := 3;
end;


procedure TGenericClass<T>.Test;
begin
  b := 2;
end;

end.
";

end.