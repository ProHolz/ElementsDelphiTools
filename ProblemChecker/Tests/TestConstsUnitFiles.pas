namespace ProHolz.SourceChecker;
uses ProHolz.Ast;
const
  cUnitWithResDFM =
"unit TestPublic;
interface
{$R *.dfm}

implementation

{$R test.res}


end.
";


  ////////

  cUnitInitFinal ="
unit TestPublic;

interface

Var Test : Integer;
{.$SCOPEDENUMS ON}
type
  TEnum = (first, second);


procedure Globall;

implementation

procedure Globall;
begin
end;

initialization


finalization
end.
  ";

 /////////////////////

  cTest1 =
  " unit TestPublic;

interface
 uses
   Windows,
   Sysutils,
   Classes;

  type
    {$SCOPEDENUMS ON}

  TEnum = (first, second);

    testRecord = record
       x,y : integer;
    end;

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

    testclass2 = class(testclass, ITest)
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


////////////////////////////////

cConstVarRec = "
unit TestPublic;
interface
type
  varRecord = record
      case boolean of
       false : (b : Boolean);
       true : (c : Integer);

    end;


const
  cint = 5;
  TInit : testrecord = (X:1; y:2);
implementation
end.
";


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

SimpleIntArray2 : Array[0..2] of Integer = (1 shl 2 -1, 1,2);

 implementation
end.
";


cTestVarTypes = "
unit Test;
interface
var
 ArrayCheck2Level : Array[0..2] of Array[1..2] of TestRecord; // NO Problem
 ArrayCheck3Level : Array[0..2] of Array[1..2] of Array[1..2] of TestRecord; // NO Problem
 ArrayProblemCheck : Array[0..2] of record x,y,z:  double; end; //Problem
 ArrayCheck : Array[0..2] of TestRecord; // NO Problem
 Simple : Integer; // No Problem
 SimpleSet :  (e1, e2, e3);  // Problem
 ByteArray : Array[0..0] of byte; // No Problem

 pprocVar  : Procedure(a : Integer); // Problem
 pprocFunc  : function(a : Integer) : boolean; // Problem



 implementation
end.
";

cTestTypeMethods = "
unit Test;
interface

 implementation

 procedure TestMethod;
 var a : Integer;

 type
   TestRec = record a : integer; end; // Problem1
   const c = 5;
   type
   TestRec2 = record a : integer; end; // Problem2
    begin
   end;

 procedure TestOuter;

 Procedure TestOuter1;
   procedure TestLocal;
    type
      TestRecLocal = record a : integer; end; // Problem3
     begin
     end;

 begin
 end;

 begin
 end;
end.
";

cTestASMMethods = "
unit Test;
interface

 implementation

 function ReturnAddress: Pointer;
asm
  mov eax,[ebp+4]
end;

end.
";




method WriteoutConstxml;
begin
 if Environment.OS = OperatingSystem.Windows then
  begin
  var temp := TPasSyntaxTreeBuilder.RunWithString(cUnitWithResDFM, false);
  File.WriteText('X:\Elements\ElementsDelphiTools\ProblemChecker\Tests\XML\cUnitWithResDFM.xml' , TSyntaxTreeWriter.ToXML(temp, true));

  temp := TPasSyntaxTreeBuilder.RunWithString(cUnitInitFinal, false);
  File.WriteText('X:\Elements\ElementsDelphiTools\ProblemChecker\Tests\XML\cUnitInitFinal.xml' , TSyntaxTreeWriter.ToXML(temp, true));


  temp := TPasSyntaxTreeBuilder.RunWithString(cTest1, false);
  File.WriteText('X:\Elements\ElementsDelphiTools\ProblemChecker\Tests\XML\cTest1.xml' , TSyntaxTreeWriter.ToXML(temp, true));

  temp := TPasSyntaxTreeBuilder.RunWithString(cConstVarRec, false);
  File.WriteText('X:\Elements\ElementsDelphiTools\ProblemChecker\Tests\XML\cConstVarRec.xml' , TSyntaxTreeWriter.ToXML(temp, true));


  temp := TPasSyntaxTreeBuilder.RunWithString(ctestVariantRecord, true);
  File.WriteText('X:\Elements\ElementsDelphiTools\ProblemChecker\Tests\XML\ctestVariantRecord.xml' , TSyntaxTreeWriter.ToXML(temp, true));

  temp := TPasSyntaxTreeBuilder.RunWithString(cTestArray, true);
  File.WriteText('X:\Elements\ElementsDelphiTools\ProblemChecker\Tests\XML\cTestArray.xml' , TSyntaxTreeWriter.ToXML(temp, true));
end;


end;



end.