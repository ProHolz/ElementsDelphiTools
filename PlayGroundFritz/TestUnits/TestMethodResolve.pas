namespace PlayGroundFritz;
const TestMethodimplementation=
"
unit Methodimplementation;

interface



implementation

type
  /// option set for RawUnicodeToUtf8() conversion
  TCharConversionFlags = set of (
    ccfNoTrailingZero, ccfReplacementCharacterForUnmatchedSurrogate);

TSimpleSet = set of byte;


//function Testfunc(const i : integer) : integer;
////Type Test = record a : integer; end;
//Var local : integer;
////const c : integer = 5;
////const b = 12;

   ////function LocalFunc : Integer;
   ////begin
     ////result := 5;
   ////end;

 ////procedure Test2;
 ////procedure Test3;
 ////begin
 ////end;

 ////begin
 ////end;


//begin
  //local := i*local-5;

  //result := i+(local-5);
//end;



procedure AddToDisplayList(const Display: IDisplayListAdder);
begin
   Display.addLine(k.p1, k.p2, CadColor.colarray[k.col], eDisp.lineType.Normal);
  Pointer(tmp)^ := c^;
   PWordArray(Dest)[0] := fAnsiToWide[Ord(Source[0])];
end;


function IsAnsiCompatible(PC: PAnsiChar): boolean;
label unmatch;
begin
  result := false;
  if PC<>nil then
  while true do
    if PC^=#0 then
      break else
    if PC^<=#127 then
      inc(PC) else // 7 bits chars are always OK, whatever codepage/charset is used
      exit;
  result := true;


  while false do
    begin
      test := 1;
      Test2 := 3;

    end;


   if (PtrInt(Source)>=SourceLen) or
           (cardinal(Source^)-UTF16_HISURROGATE_MIN>UTF16_HISURROGATE_MAX-UTF16_HISURROGATE_MIN) then
            begin
          goto unmatch;
          end else begin
          c := ((cardinal(Source^)-$D7C0)shl 10)+(c xor UTF16_LOSURROGATE_MIN);
          inc(Source);
        end;

 unmatch:


end;


end.
";






end.