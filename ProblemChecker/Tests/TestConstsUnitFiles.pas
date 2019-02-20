namespace ProblemChecker;

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

end.