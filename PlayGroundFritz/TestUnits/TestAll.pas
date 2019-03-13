namespace PlayGroundFritz;

const TestAll = "
unit TestAll;

interface



const
  OperatorsInfo: array [0..2] of TOperatorInfo =
    ((Typ: ntAddr;         AssocType: atRight),
     (Typ: ntDeref;        AssocType: atLeft),
     (Typ: ntGeneric;      AssocType: atRight));

 const
   // First without types.....
   cInt  = 42;  // Should be Literal Numeric
   cString = 'Hello Elements'; // Should be Literal String
   cFloat  = 12.42; // Should be Literal Numeric

   cintArray = [1,2,cInt]; // Will be a Array

   cNil : pointer = nil;

   cintArray2 : Array of Integer  = [1,2,3];


  type
   eEnum = (first, second, third);

   eEnumSet = set of eEnum;

  const
   eSimple : eEnumSet = [first, third];

   var
    vInt : Integer =100;
    vInt64 : Int64;
    vDouble : Double;
    vSingle : Single;





// Default String Params

function TestFuncString7(value: string = 'Test'): string;

// Default Integer Params
function TestFuncDefaultInt(const value: integer = 42): string;
function TestFuncDefaultInt2(value: integer = intConst): string;

implementation

end.
";


end.