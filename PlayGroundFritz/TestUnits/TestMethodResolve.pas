namespace ProHolz.CodeGen;
const TestMethodimplementation=
"
unit Methodimplementation;

interface
const
  /// used e.g. by inlined function GetLineContains()
  ANSICHARNOT01310: set of AnsiChar = [#1..#9,#11,#12,#14..#255];

implementation
var StrLen: function(S: pointer): PtrInt = StrLenPas;


procedure DestType(var Dest);

begin
  exit;
end;

procedure AddArrayOfConst(var Dest: TTVarRecDynArray; const Values: array of const);
var i,n: Integer;
begin
  n := length(Dest);
  SetLength(Dest,n+length(Values));
  for i := 0 to high(Values) do
    Dest[i+n] := Values[i];
end;

Procedure DotTest;
begin
  // Res.Text := @V.VString^[1];
   dsp.result^ := 0;
   //LeftCall.RightCall;
   //LeftCall.MidCall1.MidCall2.Midcall3.RightCall;
   //MethodCall(value).ArrayCall[col];//.NamedCall(value).Tests;
   //MethodCall(value.RightValue).ArrayCall[col];
   //MethodCall(value.RightValue(value)).MidMethod(Value1, Value2).ArrayCall[col];
  MethodCall.value.RightValue[value]^.MidMethod(Value1, Value2).ArrayCall[col];
 // LeftCall.RightCall^.Test := a;

 with a, b.temp, c do begin
   with z do exit (false);

  end;


end;

end.
";


end.