namespace PascalParser;

const
  cBinaryXml =
  " unit TestPublic;

interface
 uses
   Windows,
   Sysutils,
   Classes;

  type
    testRecord = record
       x,y : integer;
    end;

{$IFDEF UNICODE}

{$ELSE}
  bla
{$ENDIF}

{$IFDEF TOKYO}
bla
{$ELSE}

{$ENDIF}


   testRecord2 = record
       x,y : integer;
    end;

   const T : testrecord = (X:1; y:2);

  type
   testclass = class
   public
     destructor Done;
   end;

   Itest = interface
   end;

    testclass2 = class(ITest)
    public
    constructor one;
    constructor two;

   end;

implementation
 uses
  System.Math;
type
  implclass = class
  end;


procedure TestWidth;
begin
 with a do
   begin
    end;
end;

end.
";



const
  cCompilerVersions28 =
  " unit TestPublic;

interface

  {$IF Compilerversion = 28}
    // No Error in XE7
  {$ELSE}
    more_bla
  {$ENDIF}

implementation

end.
";


const
  cCompilerVersionsGreater28 =
  " unit TestPublic;

interface


  {$IF Compilerversion > 28}
    // Should raise a error in XE8 and above
    more_bla
  {$ELSE}

  {$ENDIF}



implementation

end.
";

// ( *$DESCRIPTION 'TEST Description '*)

(*

 {$DESCRIPTION 'TEST Description '}
 const c = 1;
*)
const
cTestCompilerDirectives = "
unit Test;
interface
 {$DESCRIPTION 'TEST Description '}

(*$DESCRIPTION 'TEST Description '*)

implementation
end.

";

const
cTestEmptyUnit =
"unit Test;
interface
implementation
end.";


const
ctestSyn = "

unit Test;
interface
type
  TSynSelectedColor = class(TPersistent)
  public
   procedure WMGetDlgCode(var Message: TMessage); message WM_GETDLGCODE;
  end;

 implementation
end.

"
;

ctestVariantRecord ="
unit Test;
interface
type
  TSQLVar = record
    case VType: STQLDBFieldType of
    ftInt64: (
      VInt64: Int64);
    ftDouble: (
      VDouble: double);
    ftDate: (
      VDateTime: TDateTime);
    ftCurrency: (
      VCurrency: Currency);
    ftUTF8: (
      VText: PUTF8Char);
    ftBlob: (
      VBlob: pointer;
      VBlobLen: Integer)
  end;

 TSQLVarVType = record
  VSingle : TSQLDBFieldType;
   case TSQLDBFieldType of
    ftInt64: (
      VInt64: Int64);
    ftDouble: (
      VDouble: double);
    ftDate: (
      VDateTime: TDateTime);
    ftCurrency: (
      VCurrency: Currency);
    ftUTF8: (
      VText: PUTF8Char);
    ftBlob: (
      VBlob: pointer;
      VBlobLen: Integer)
  end;

 implementation
end.
";

cTestArray = "
unit Test;
interface
const
SimpleIntArray : Array[0..2] of Integer = (0, 1,2);

SimpleIntArray2 : Array[0..2] of Integer = (1 shl 2 -1, 1, 2);

 implementation
end.
";

cTestClassMethodNames = "
unit Test;
interface
  type
    testclass<T> = class
    public
      procedure Test<T>;
      constructor Create;
      destructor Destroy;
    end;

 implementation

 procedure testclass<T>.Test<T>;
 begin
 end;

 constructor testclass<T>.Create;
 begin
 end;

 destructor testclass<T>.Destroy;
 begin
 end;

end.
";

end.