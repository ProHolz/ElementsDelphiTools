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
cTestCompilerDirectives = "
unit Test;
interface
 {$DESCRIPTION 'TEST Description '}

(*$DESCRIPTION 'TEST Description '*)

implementation
end.

";

cTestEmptyUnit = "
unit Test;
interface

implementation
end.

";


end.