namespace PlayGroundFritz;
const TestTypes = "
unit TestTypes;

interface

type
 myString = String;
// Pointer Type
  PmyInteger = ^Integer;

 // record
 PMyRecord = ^MyRecord;

 MyRecord = record
 a : integer;
 b : Double;
 end;

 // Enum
 eCadPenStyle = (lpsDash, lpsSolid, lpsDot);

 eStyleset = set of eCadPenStyle;

const
 DefaultStyle : eStyleSet = [lpsDash, lpsSolid];
 SimpleIntArray : Array[0..2] of Integer = (0, 1,2);

   AllInt : array[0..1, 3..4] of integer = ((3,4), (5,6));
 enumArray : array[eCadPenStyle, ecadpenstyle] of integer = ((0,1,2), (0,1,2));

type
  tClassCollection = class of  TPersistent;

  tmyProc = procedure(value : integer);
  tmyfunc = function(value : integer) : integer of object;
  tmyref = reference to procedure(value : integer);


resourceString
r1 = 'Hello';
r2 = 'Hello2';

implementation

 initialization

   a := b;
   finalization
   a := b;
end.

";

end.