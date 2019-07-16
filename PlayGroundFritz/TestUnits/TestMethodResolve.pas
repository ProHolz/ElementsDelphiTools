namespace ProHolz.CodeGen;
const TestMethodimplementation=
"
unit Methodimplementation;

interface
type
 Range = 0..20;
 RangeSet = set of Range;
 RangeArray = Array[Range] of Integer;
 TPtrUIntArray = array[0..MaxInt div SizeOf(PtrUInt)-1] of PtrUInt;
 TMixedArray = array[0..Maxtest-20, enumtype] of byte;
Procedure LocalTest;
implementation

 Procedure LocalTest;

 Procedure Local1;
 Procedure Local2;
 begin
 end;

 begin
 end;

 begin
 end;



end.
";


end.