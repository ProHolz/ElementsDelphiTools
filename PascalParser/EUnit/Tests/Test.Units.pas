namespace ProHolz.Ast;

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


cTestArray = "
unit Test;
interface
const
SimpleIntArray : Array[0..2] of Integer = (0, 1,2);

SimpleIntArray2 : Array[0..2] of Integer = (1 shl 2 -1, 1, 2);

 implementation
end.
";

cTestNamespace =
"namespace Test;
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

cTestAsm =
"unit Test;
interface

implementation

 procedure Handler(Params: Pointer);
asm
        .NOFRAME
        SUB     RSP, 28H
        CALL    InternalHandler
        MOV     [RSP], RAX
        MOVSD   XMM0, [RSP]
        ADD     RSP, 28H
end;
end.
";



end.