namespace ProHolz.CodeGen;
const TestConstArray = "

unit ConstArray;

interface
(*
type
 // Pointer Type
  PmyInteger = ^Integer;
  pmyVec = ^TVec3d;

 // record

 MyRecord = record
 a1 : shortint;
 a2 : int8;
 b1 : int16;
 b2 : smallint;

 a : integer;
 b : Double;
 c : byte;
 d : Tvec2d;
 end;

 eCadPenStyle = (lpsDash, lpsSolid, lpsDot);



const
 JSON_BASE64_MAGIC_QUOTE = Ord('""')+cardinal(JSON_BASE64_MAGIC) shl 8;
 testmul = (15 * 22);
 testDiv = (14 div 3) * 2;
 test = (2 shl 3 + 5 div 6 shr 2 * sizeof(integer));
 TestOrXor = (2 or (5 xor 7) and not 2);

pAddrTest = @TEST;

SimpleIntArray : Array[0..2] of Integer = (0, 1,2);

AllInt : Array[0..1, 3..4] of integer = ((3,4), (5,6));


  /// constant array used by GetAllBits() function (when inlined)
  ALLBITS_CARDINAL: Array[1..32] of Cardinal = (
    1 shl 1-1, 1 shl 2-1, 1 shl 3-1, 1 shl 4-1, 1 shl 5-1, 1 shl 6-1,
    1 shl 7-1, 1 shl 8-1, 1 shl 9-1, 1 shl 10-1, 1 shl 11-1, 1 shl 12-1,
    1 shl 13-1, 1 shl 14-1, 1 shl 15-1, 1 shl 16-1, 1 shl 17-1, 1 shl 18-1,
    1 shl 19-1, 1 shl 20-1, 1 shl 21-1, 1 shl 22-1, 1 shl 23-1, 1 shl 24-1,
    1 shl 25-1, 1 shl 26-1, 1 shl 27-1, 1 shl 28-1, 1 shl 29-1, 1 shl 30-1,
    $7fffffff, $ffffffff);


type
CadColor = System.UiTypes.Tcolor;

Var intVar : Array[0..4] of Integer;

 GetTickCount64: function(a : integer; b : Integer): Int64; stdcall;

const
  NOTRAILING: array[boolean] of TCharConversionFlags =
    ([],[ccfNoTrailingZero]);



type
  tUtf8Rec = record
  offset, minimum: cardinal;
end;

const
  UTF8_EXTRA: array[0..6] of tUtf8Rec
 = ( // http://floodyberry.wordpress.com/2007/04/14/utf-8-conversion-tricks
(offset: $00000000;  minimum: $00010000),
(offset: $00003080;  minimum: $00000080),
(offset: $000e2080;  minimum: $00000800),
(offset: $03c82080;  minimum: $00010000),
(offset: $fa082080;  minimum: $00200000),
(offset: $82082080;  minimum: $04000000),
(offset: $00000000;  minimum: $04000000));

*)
type
  TCoeff = array[0..3] of Double;
  TCoeffArray = array [0 .. 1, 0 .. 3] of TCoeff;


  const
  coeffsHigh: TCoeffArray = (((0.0899116, - 19.2349, - 4.11711, 0.183362), (0.138148, - 1.45804, 1.32044, 1.38474), (0.230903, - 0.450262, 0.219963, 0.414038),
    (0.0590565, - 0.101062, 0.0430592, 0.0204699)), ((0.0164649, 9.89394, 0.0919496, 0.00760802), (0.0191603, - 0.0322058, 0.0134667, - 0.0825018),
    (0.0156192, - 0.017535, 0.00326508, - 0.228157), ( - 0.0236752, 0.0405821, - 0.0173086, 0.176187)));





implementation
(* const
SimpleIntArray2 : Array[0..2] of Integer = (1 shl 2 -1, 1,2);

var f : Double = 0.0;
*)





end.

";

end.