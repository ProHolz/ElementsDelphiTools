namespace PlayGroundFritz;

const TestGeneric = "
unit TestGeneric;
interface
type
TGenericClass<T> = class
 private
 fData : Array of T;
 public
 constructor Create;
 procedure Test;
end;

implementation
{ TGenericClass<T> }
constructor TGenericClass<T>.Create;
begin
 fdata := [];
end;
procedure TGenericClass<T>.Test;
begin
  fdata[0] := '';
end;
end.

";

end.