namespace ProHolz.CodeGen;

const TestDll = "
Unit TestDll;
interface
const
   {$IF Defined(WIN32)}
// LIB_CAIRO_32 = 'libCairo-2.dll';
   {$IFDEF DEBUGCAIRO}
   LIB_CAIRO_32 = 'CairoD.dll';
   {$ELSE}
   LIB_CAIRO_32 = 'Cairo.dll';
   {$ENDIF}
   _PU = '';
   {$ELSE}
   {$MESSAGE Error 'Unsupported platform'}
   {$ENDIF}
 function cairo_version(): Integer; cdecl; external LIB_CAIRO_32 name  PU+ 'cairo_version';

function cairo_interfaceimplementation(): Integer; cdecl;

implementation

// Will only show up in the interface in Oxygene
function cairo_interfaceimplementation(): Integer; cdecl; external LIB_CAIRO_32 name 'cairo_interfaceimplementation';

function cairo_implementation(): Integer; cdecl; external LIB_CAIRO_32 name 'cairo_implementation';
end.

";

end.