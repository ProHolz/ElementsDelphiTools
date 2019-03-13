﻿namespace PlayGroundFritz;
const TestTypes = "
unit TestTypes;

interface
  uses
  System.Sysutils,
  System.UiTypes,
   System.Classes;
 type
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

type
  tClassCollection = class of  TPersistent;

  tmyProc = procedure(value : integer);
  tmyfunc = function(value : integer) : integer of object;
  tmyref = reference to procedure(value : integer);

implementation


end.

";

end.