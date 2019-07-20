{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License Version
1.1 (the "License"); you may not use this file except in compliance with the
License. You may obtain a copy of the License at
http://www.mozilla.org/NPL/NPL-1_1Final.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: mwPasLex.PAS, released August 17, 1999.

The Initial Developer of the Original Code is Martin Waldenburg
(Martin.Waldenburg@T-Online.de).
Portions created by Martin Waldenburg are Copyright (C) 1998, 1999 Martin
Waldenburg.
All Rights Reserved.

Contributor(s):  James Jacobson, LaKraven Studios Ltd, Roman Yankovsky
(This list is ALPHABETICAL)

Last Modified: mm/dd/yyyy
Current Version: 2.25

Notes: This program is a very fast Pascal tokenizer. I'd like to invite the
Delphi community to develop it further and to create a fully featured Object
Pascal parser.

Modification history:

LaKraven Studios Ltd, January 2015:

- Cleaned up version-specifics up to XE8
- Fixed all warnings & hints

Daniel Rolf between 20010723 and 20020116

Made ready for Delphi 6

platform
deprecated
varargs
local

Known Issues:
-----------------------------------------------------------------------------}
{$HIDE H7}
namespace ProHolz.Ast;
interface

type
  // Blocks
  TDirectiveEvent =  public block(Sender: TmwBasePasLex);// of object;
  TCommentEvent = public block(Sender: Object; const Text: not nullable String);// of object;
  TParseCompilerDirectiveEvent = public block (Sender: Object; const directive: String; out res : Boolean) : Boolean;


  TDefineRec =  class
    Defined: Boolean;
    StartCount: Integer;
  end;


  TBufferRec = public class
    Buf: not nullable String := '';//PCHAR;
    Run: Integer;
    SharedBuffer: Boolean;
    LineNumber: Integer;
    LinePos: Integer;
    FileName: not nullable String := '';
    Next: TBufferRec;
  end;


  Proc nested in TmwBasePasLex  = block();
  Tokenfunc nested in TmwBasePasLex = block() : TptTokenKind;
  Lee nested in TmwBasePasLex =  enum  (None, &And, &Or);

  TmwBasePasLex = public class(Object)
  unit or protected
    fCommentState: TCommentState;
    method CloneDefinesFrom(ALexer: TmwBasePasLex);
    method SetSharedBuffer(SharedBuffer: TBufferRec);


  private // Class

    class var Identifiers: array[#0..#127] of Boolean;
    class var mHashTable: array[#0..#127] of Integer;
    class method MakeIdentTable;
  private

    fProcTable: array[#0..#127] of Proc;
    fBuffer: TBufferRec;
    fTempRun: Integer;
    fIdentFuncTable: array[0..191] of Tokenfunc;
    fTokenPos: Integer;
    fTokenID: TptTokenKind;
    fExID: TptTokenKind;

    fDirectiveParamOrigin: Integer;
    fAsmCode: Boolean;
    fDefines: List<String>;
    fDefineStack: Integer;
    fTopDefineRec: Stack<TDefineRec>;
    fUseDefines: Boolean;
    fScopedEnums: Boolean;
    fIncludeHandler: IIncludeHandler;
    fCompiler : DelphiCompiler;


    method KeyHash: Integer;
    method KeyComp(const aKey: not nullable String): Boolean;
    method Func9: TptTokenKind;
    method Func15: TptTokenKind;
    method Func19: TptTokenKind;
    method Func20: TptTokenKind;
    method Func21: TptTokenKind;
    method Func23: TptTokenKind;
    method Func25: TptTokenKind;
    method Func27: TptTokenKind;
    method Func28: TptTokenKind;
    method Func29: TptTokenKind;
    method Func30: TptTokenKind;
    method Func32: TptTokenKind;
    method Func33: TptTokenKind;
    method Func35: TptTokenKind;
    method Func36: TptTokenKind;
    method Func37: TptTokenKind;
    method Func38: TptTokenKind;
    method Func39: TptTokenKind;
    method Func40: TptTokenKind;
    method Func41: TptTokenKind;
    method Func42: TptTokenKind;
    method Func43: TptTokenKind;
    method Func44: TptTokenKind;
    method Func45: TptTokenKind;
    method Func46: TptTokenKind;
    method Func47: TptTokenKind;
    method Func49: TptTokenKind;
    method Func52: TptTokenKind;
    method Func54: TptTokenKind;
    method Func55: TptTokenKind;
    method Func56: TptTokenKind;
    method Func57: TptTokenKind;
    method Func58: TptTokenKind;
    method Func59: TptTokenKind;
    method Func60: TptTokenKind;
    method Func61: TptTokenKind;
    method Func62: TptTokenKind;
    method Func63: TptTokenKind;
    method Func64: TptTokenKind;
    method Func65: TptTokenKind;
    method Func66: TptTokenKind;
    method Func69: TptTokenKind;
    method Func71: TptTokenKind;
    method Func72: TptTokenKind;
    method Func73: TptTokenKind;
    method Func75: TptTokenKind;
    method Func76: TptTokenKind;
    method Func77: TptTokenKind;
    method Func78: TptTokenKind;
    method Func79: TptTokenKind;
    method Func81: TptTokenKind;
    method Func84: TptTokenKind;
    method Func85: TptTokenKind;
    method Func86: TptTokenKind;
    method Func87: TptTokenKind;
    method Func88: TptTokenKind;
    method Func89: TptTokenKind;
    method Func91: TptTokenKind;
    method Func92: TptTokenKind;
    method Func94: TptTokenKind;
    method Func95: TptTokenKind;
    method Func96: TptTokenKind;
    method Func97: TptTokenKind;
    method Func98: TptTokenKind;
    method Func99: TptTokenKind;
    method Func100: TptTokenKind;
    method Func101: TptTokenKind;
    method Func102: TptTokenKind;
    method Func103: TptTokenKind;
    method Func104: TptTokenKind;
    method Func105: TptTokenKind;
    method Func106: TptTokenKind;
    method Func107: TptTokenKind;
    method Func108: TptTokenKind;
    method Func112: TptTokenKind;
    method Func117: TptTokenKind;
    method Func123: TptTokenKind;
    method Func126: TptTokenKind;
    method Func127: TptTokenKind;
    method Func128: TptTokenKind;
    method Func129: TptTokenKind;
    method Func130: TptTokenKind;
    method Func132: TptTokenKind;
    method Func133: TptTokenKind;
    method Func136: TptTokenKind;
    method Func141: TptTokenKind;
    method Func142: TptTokenKind;
    method Func143: TptTokenKind;
    method Func166: TptTokenKind;
    method Func167: TptTokenKind;
    method Func168: TptTokenKind;
    method Func191: TptTokenKind;
    method AltFunc: TptTokenKind;
    method InitIdent;
    method GetPosXY: TTokenPoint;
    method IdentKind: TptTokenKind;
    method MakeMethodTables;
    method AddressOpProc;
    method AmpersandOpProc;
    method AsciiCharProc;
    method AnsiProc;
    method BorProc;
    method BraceCloseProc;
    method BraceOpenProc;
    method ColonProc;
    method CommaProc;
    method CRProc;
    method EqualProc;
    method GreaterProc;
    method IdentProc;
    method IntegerProc;
    method LFProc;
    method LowerProc;
    method MinusProc;
    method NullProc;
    method NumberProc;
    method PlusProc;
    method PointerSymbolProc;
    method PointProc;
    method RoundCloseProc;
    method RoundOpenProc;
    method SemiColonProc;
    method SlashProc;
    method SpaceProc;
    method SquareCloseProc;
    method SquareOpenProc;
    method StarProc;
    method StringProc;
    method StringDQProc;
    method SymbolProc;
    method UnknownProc;
    method GetToken: not nullable String;
    method GetTokenLen: Integer;
    method GetCompilerDirective: not nullable String;
    method GetDirectiveKind: TptTokenKind;
    method GetDirectiveParam: not nullable String;
    method GetStringContent: not nullable String;
    method GetIsJunk: Boolean;
    method GetIsSpace: Boolean;
    method GetIsOrdIdent: Boolean;
    method GetIsRealType: Boolean;
    method GetIsStringType: Boolean;
    method GetIsVariantType: Boolean;
    method GetIsAddOperator: Boolean;
    method GetIsMulOperator: Boolean;
    method GetIsRelativeOperator: Boolean;
    method GetIsCompilerDirective: Boolean;
    method GetIsOrdinalType: Boolean;
    method GetGenID: TptTokenKind;

    method EnterDefineBlock(ADefined: Boolean);
    method ExitDefineBlock;

    method DoProcTable(AChar: Char);
    method IsIdentifiers(AChar: Char): Boolean; inline;
    method HashValue(AChar: Char): Integer;
    method EvaluateComparison(AValue1: Double; const AOper: not nullable String; AValue2: Double): Boolean;
    method EvaluateConditionalExpression(const AParams: not nullable String): Boolean;
    method EvaluateSpeciaConditionalExpression(const AParams: not nullable String): Boolean;
    method IncludeFile;
    method GetIncludeFileNameFromToken(const IncludeToken: not nullable String): not nullable String;
    method GetOrigin: not nullable String;
    method GetRunPos: Integer;
    method SetRunPos(const Value: Integer);


    method GetFileName: not nullable String;
    method UpdateScopedEnums;
    method GetIsJunkAssembly: Boolean;
    method DoOnComment(const CommentText: not nullable String);
  protected
    method SetOrigin(const NewValue: not nullable String); virtual;
  public
    constructor(const aCompiler : DelphiCompiler);
    class constructor ();

    method CharAhead: Char;
    method Next;
    method NextNoJunk;
    method NextNoJunkAssembly;
    method NextNoSpace;
    method InitLexer;
    method InitFrom(ALexer: TmwBasePasLex);
    method FirstInLine: Boolean;

    method AddDefine(const ADefine: not nullable String);
    method RemoveDefine(const ADefine: not nullable String);
    method IsDefined(const ADefine: not nullable String): Boolean;
    method ClearDefines;
    method InitDefinesDefinedByCompiler;

    property Buffer: TBufferRec read fBuffer;
    property CompilerDirective: not nullable String read GetCompilerDirective;
    property DirectiveParam: not nullable String read GetDirectiveParam;
    property IsJunk: Boolean read GetIsJunk;
    property IsJunkAssembly: Boolean read GetIsJunkAssembly;
    property IsSpace: Boolean read GetIsSpace;
    property Origin: not nullable String read GetOrigin write SetOrigin;
    property PosXY: TTokenPoint read GetPosXY;
    property RunPos: Integer read GetRunPos write SetRunPos;
    property Token: not nullable String read GetToken;
    property TokenLen: Integer read GetTokenLen;
    property TokenPos: Integer read fTokenPos;
    property TokenID: TptTokenKind read fTokenID;
    property ExID: TptTokenKind read fExID;
    property GenID: TptTokenKind read GetGenID;
    property StringContent: not nullable String read GetStringContent;
    property IsOrdIdent: Boolean read GetIsOrdIdent;
    property IsOrdinalType: Boolean read GetIsOrdinalType;
    property IsRealType: Boolean read GetIsRealType;
    property IsStringType: Boolean read GetIsStringType;
    property IsVariantType: Boolean read GetIsVariantType;
    property IsRelativeOperator: Boolean read GetIsRelativeOperator;
    property IsAddOperator: Boolean read GetIsAddOperator;
    property IsMulOperator: Boolean read GetIsMulOperator;
    property IsCompilerDirective: Boolean read GetIsCompilerDirective;

    property AsmCode: Boolean read fAsmCode write fAsmCode;
    property DirectiveParamOrigin: Integer read fDirectiveParamOrigin;
    property UseDefines: Boolean read fUseDefines write fUseDefines;
    property ScopedEnums: Boolean read fScopedEnums;
    property IncludeHandler: IIncludeHandler read fIncludeHandler write fIncludeHandler;
    property FileName: not nullable String read GetFileName;


   // Events
    property OnComment: TCommentEvent read  write ;
    property OnMessage: TMessageEvent read  write ;
    property OnCompDirect: TDirectiveEvent read  write ;
    property OnDefineDirect: TDirectiveEvent read  write ;
    property OnElseDirect: TDirectiveEvent read  write;
    property OnEndIfDirect: TDirectiveEvent read  write ;
    property OnIfDefDirect: TDirectiveEvent read  write;
    property OnIfNDefDirect: TDirectiveEvent read  write ;
    property OnIfOptDirect: TDirectiveEvent read  write ;

    property OnIfDirect: TDirectiveEvent read  write ;
    property OnIfEndDirect: TDirectiveEvent read  write ;
    property OnElseIfDirect: TDirectiveEvent read  write ;
    property OnResourceDirect: TDirectiveEvent read  write ;
    property OnUnDefDirect: TDirectiveEvent read  write ;
    property OnParseCompilerDirectiveEvent : TParseCompilerDirectiveEvent read write;

  end;

  TmwPasLex = public class(TmwBasePasLex)
  private
    fAheadLex: TmwBasePasLex;
    method GetAheadExID: TptTokenKind;
    method GetAheadGenID: TptTokenKind;
    method GetAheadToken: not nullable String;
    method GetAheadTokenID: TptTokenKind;
  protected
    method SetOrigin(const NewValue: not nullable String); override;
  public
    constructor(const aCompiler : DelphiCompiler);

    method InitAhead;
    method AheadNext;
    property AheadLex: TmwBasePasLex read fAheadLex;
    property AheadToken: not nullable String read GetAheadToken;
    property AheadTokenID: TptTokenKind read GetAheadTokenID;
    property AheadExID: TptTokenKind read GetAheadExID;
    property AheadGenID: TptTokenKind read GetAheadGenID;
  end;

implementation

class method TmwBasePasLex.MakeIdentTable;
var
I, J: Char;
begin
  for I := #0 to #127 do
    begin
    case I of
      '_', '0'..'9', 'a'..'z', 'A'..'Z': Identifiers[I] := True;
      else
        Identifiers[I] := False;
    end;
  {$IF ECHOES}
  J := Char.ToUpper(I);
   {$ELSEIF TOFFEE}
   J := chr(toupper(ord(I)));

     {$ELSE}

     J := I.ToUpper;
     {$ENDIF}
    case I of
      'a'..'z', 'A'..'Z', '_': mHashTable[I] := ord(J) - 64;
      else
        mHashTable[Char(I)] := 0;
    end;
  end;
end;

method TmwBasePasLex.CharAhead: Char;
begin
  var RunAhead := fBuffer.Run;
  while (fBuffer.Buf[RunAhead] > #0) and (fBuffer.Buf[RunAhead] < #33) do
    inc(RunAhead);
  Result := fBuffer.Buf[RunAhead];
end;

method TmwBasePasLex.ClearDefines;
begin
  fDefineStack := 0;
  fDefines := new List<String>();
  fTopDefineRec:= new Stack<TDefineRec>();
end;

method TmwBasePasLex.CloneDefinesFrom(ALexer: TmwBasePasLex);
begin
  ClearDefines;
  if (ALexer.fDefines <> nil) and (ALexer.fDefines.Count > 0) then
    fDefines :=  new List<String>(ALexer.fDefines:ToArray)
  else
    fDefines :=  new List<String>();
  fDefineStack := ALexer.fDefineStack;
// {$HINT RETHINK AND TEST}
{$if not TOFFEE }
fTopDefineRec := ALexer.fTopDefineRec:UniqueCopy;
{$ENDIF}
end;

method TmwBasePasLex.GetPosXY: TTokenPoint;
begin
  Result.Y := fBuffer.LineNumber + 1;
  Result.X := fTokenPos - fBuffer.LinePos + 1;
end;

method TmwBasePasLex.GetRunPos: Integer;
begin
  Result := fBuffer.Run;
end;

method TmwBasePasLex.InitIdent;
var
I: Integer;
begin
  for I := 0 to 191 do
    case I of
      9: fIdentFuncTable[I] := @Func9;
      15: fIdentFuncTable[I] := @Func15;
      19: fIdentFuncTable[I] := @Func19;
      20: fIdentFuncTable[I] := @Func20;
      21: fIdentFuncTable[I] := @Func21;
      23: fIdentFuncTable[I] := @Func23;
      25: fIdentFuncTable[I] := @Func25;
      27: fIdentFuncTable[I] := @Func27;
      28: fIdentFuncTable[I] := @Func28;
      29: fIdentFuncTable[I] := @Func29;
      30: fIdentFuncTable[I] := @Func30;
      32: fIdentFuncTable[I] := @Func32;
      33: fIdentFuncTable[I] := @Func33;
      35: fIdentFuncTable[I] := @Func35;
      36: fIdentFuncTable[I] := @Func36;
      37: fIdentFuncTable[I] := @Func37;
      38: fIdentFuncTable[I] := @Func38;
      39: fIdentFuncTable[I] := @Func39;
      40: fIdentFuncTable[I] := @Func40;
      41: fIdentFuncTable[I] := @Func41;
      42: fIdentFuncTable[I] := @Func42;
      43: fIdentFuncTable[I] := @Func43;
      44: fIdentFuncTable[I] := @Func44;
      45: fIdentFuncTable[I] := @Func45;
      46: fIdentFuncTable[I] := @Func46;
      47: fIdentFuncTable[I] := @Func47;
      49: fIdentFuncTable[I] := @Func49;
      52: fIdentFuncTable[I] := @Func52;
      54: fIdentFuncTable[I] := @Func54;
      55: fIdentFuncTable[I] := @Func55;
      56: fIdentFuncTable[I] := @Func56;
      57: fIdentFuncTable[I] := @Func57;
      58: fIdentFuncTable[I] := @Func58;
      59: fIdentFuncTable[I] := @Func59;
      60: fIdentFuncTable[I] := @Func60;
      61: fIdentFuncTable[I] := @Func61;
      62: fIdentFuncTable[I] := @Func62;
      63: fIdentFuncTable[I] := @Func63;
      64: fIdentFuncTable[I] := @Func64;
      65: fIdentFuncTable[I] := @Func65;
      66: fIdentFuncTable[I] := @Func66;
      69: fIdentFuncTable[I] := @Func69;
      71: fIdentFuncTable[I] := @Func71;
      72: fIdentFuncTable[I] := @Func72;
      73: fIdentFuncTable[I] := @Func73;
      75: fIdentFuncTable[I] := @Func75;
      76: fIdentFuncTable[I] := @Func76;
      77: fIdentFuncTable[I] := @Func77;
      78: fIdentFuncTable[I] := @Func78;
      79: fIdentFuncTable[I] := @Func79;
      81: fIdentFuncTable[I] := @Func81;
      84: fIdentFuncTable[I] := @Func84;
      85: fIdentFuncTable[I] := @Func85;
      86: fIdentFuncTable[I] := @Func86;
      87: fIdentFuncTable[I] := @Func87;
      88: fIdentFuncTable[I] := @Func88;
      89: fIdentFuncTable[I] := @Func89;
      91: fIdentFuncTable[I] := @Func91;
      92: fIdentFuncTable[I] := @Func92;
      94: fIdentFuncTable[I] := @Func94;
      95: fIdentFuncTable[I] := @Func95;
      96: fIdentFuncTable[I] := @Func96;
      97: fIdentFuncTable[I] := @Func97;
      98: fIdentFuncTable[I] := @Func98;
      99: fIdentFuncTable[I] := @Func99;
      100: fIdentFuncTable[I] := @Func100;
      101: fIdentFuncTable[I] := @Func101;
      102: fIdentFuncTable[I] := @Func102;
      103: fIdentFuncTable[I] := @Func103;
      104: fIdentFuncTable[I] := @Func104;
      105: fIdentFuncTable[I] := @Func105;
      106: fIdentFuncTable[I] := @Func106;
      107: fIdentFuncTable[I] := @Func107;
      108: fIdentFuncTable[I] := @Func108;
      112: fIdentFuncTable[I] := @Func112;
      117: fIdentFuncTable[I] := @Func117;
      123: fIdentFuncTable[I] := @Func123;
      126: fIdentFuncTable[I] := @Func126;
      127: fIdentFuncTable[I] := @Func127;
      128: fIdentFuncTable[I] := @Func128;
      129: fIdentFuncTable[I] := @Func129;
      130: fIdentFuncTable[I] := @Func130;
      132: fIdentFuncTable[I] := @Func132;
      133: fIdentFuncTable[I] := @Func133;
      136: fIdentFuncTable[I] := @Func136;
      141: fIdentFuncTable[I] := @Func141;
      142: fIdentFuncTable[I] := @Func142;
      143: fIdentFuncTable[I] := @Func143;
      166: fIdentFuncTable[I] := @Func166;
      167: fIdentFuncTable[I] := @Func167;
      168: fIdentFuncTable[I] := @Func168;
      191: fIdentFuncTable[I] := @Func191;
      else
        fIdentFuncTable[I] := @AltFunc;
    end;
end;

method TmwBasePasLex.KeyHash: Integer;
begin
  Result := 0;
  while IsIdentifiers(fBuffer.Buf[fBuffer.Run]) do
  begin
    inc(Result, HashValue(fBuffer.Buf[fBuffer.Run]));
    inc(fBuffer.Run);
  end;
end;

method TmwBasePasLex.KeyComp(const aKey: not nullable string): Boolean;
var
I: Integer;
Temp: Integer;
begin
  if length(aKey) = TokenLen then
  begin
    Temp := fTokenPos;
    Result := True;
    for I := 0 to TokenLen-1 do
      begin
      if mHashTable[fBuffer.Buf[Temp]] <> mHashTable[aKey[I]] then
      begin
        Result := False;
        Break;
      end;
      inc(Temp);
    end;
  end
  else
    Result := False;
end;

method TmwBasePasLex.Func9: tptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Add') then
    fExID := TptTokenKind.ptAdd;
end;

method TmwBasePasLex.Func15: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('If') then Result := TptTokenKind.ptIf;
end;

method TmwBasePasLex.Func19: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Do') then Result := TptTokenKind.ptDo
  else if KeyComp('And') then Result := TptTokenKind.ptAnd;
end;

method TmwBasePasLex.Func20: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('As') then Result := TptTokenKind.ptAs;
end;

method TmwBasePasLex.Func21: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('Of') then Result := TptTokenKind.ptOf else
    if KeyComp('At') then fExID := TptTokenKind.ptAt;
end;

method TmwBasePasLex.Func23: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('End') then Result := TptTokenKind.ptEnd else
    if KeyComp('In') then Result :=TptTokenKind.ptIn;
end;

method TmwBasePasLex.Func25: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('Far') then fExID := TptTokenKind.ptFar;
end;

method TmwBasePasLex.Func27: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('Cdecl') then fExID := TptTokenKind.ptCdecl;
end;

method TmwBasePasLex.Func28: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('Read') then fExID := TptTokenKind.ptRead else
    if KeyComp('Case') then Result := TptTokenKind.ptCase else
      if KeyComp('Is') then Result := TptTokenKind.ptIs;
end;

method TmwBasePasLex.Func29: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('On') then fExID := TptTokenKind.ptOn;
end;

method TmwBasePasLex.Func30: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Char') then fExID := TptTokenKind.ptChar;
end;

method TmwBasePasLex.Func32: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('File') then Result := TptTokenKind.ptFile else
    if KeyComp('Label') then Result := TptTokenKind.ptLabel else
      if KeyComp('Mod') then Result := TptTokenKind.ptMod;
end;

method TmwBasePasLex.Func33: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Or') then Result := TptTokenKind.ptOr
  else if KeyComp('Name') then fExID := TptTokenKind.ptName
  else if KeyComp('Asm') then Result := TptTokenKind.ptAsm;
end;

method TmwBasePasLex.Func35: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Nil') then Result := TptTokenKind.ptNil else
    if KeyComp('To') then Result := TptTokenKind.ptTo else
      if KeyComp('Div') then Result := TptTokenKind.ptDiv;
end;

method TmwBasePasLex.Func36: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Real') then fExID := TptTokenKind.ptReal else
    if KeyComp('Real48') then fExID := TptTokenKind.ptReal48;
end;

method TmwBasePasLex.Func37: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Begin') then Result := TptTokenKind.ptBegin else
    if KeyComp('Break') then fExID := TptTokenKind.ptBreak;
end;

method TmwBasePasLex.Func38: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Near') then fExID := TptTokenKind.ptNear;
end;

method TmwBasePasLex.Func39: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('For') then Result := TptTokenKind.ptFor
  else if KeyComp('Shl') then Result := TptTokenKind.ptShl;
end;

method TmwBasePasLex.Func40: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Packed') then Result := TptTokenKind.ptPacked;
end;

method TmwBasePasLex.Func41: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Var') then Result := TptTokenKind.ptVar else
    if KeyComp('Else') then Result := TptTokenKind.ptElse else
      if KeyComp('Halt') then fExID := TptTokenKind.ptHalt;
end;

method TmwBasePasLex.Func42: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Final') then
    fExID := TptTokenKind.ptFinal; //TODO: Is this supposed to be an ExID?
end;

method TmwBasePasLex.Func43: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Int64') then fExID := TptTokenKind.ptInt64
  else if KeyComp('local') then fExID := TptTokenKind.ptLocal;
end;

method TmwBasePasLex.Func44: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Set') then Result := TptTokenKind.ptSet else
    if KeyComp('Package') then fExID := TptTokenKind.ptPackage;
end;

method TmwBasePasLex.Func45: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Shr') then Result := TptTokenKind.ptShr;
end;

method TmwBasePasLex.Func46: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('PChar') then fExID := TptTokenKind.ptPChar else
    if KeyComp('Sealed') then Result := TptTokenKind.ptSealed;
end;

method TmwBasePasLex.Func47: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Then') then Result := TptTokenKind.ptThen else
    if KeyComp('Comp') then fExID := TptTokenKind.ptComp;
end;

method TmwBasePasLex.Func49: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Not') then Result := TptTokenKind.ptNot;
end;

method TmwBasePasLex.Func52: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Byte') then fExID := TptTokenKind.ptByte else
    if KeyComp('Raise') then Result := TptTokenKind.ptRaise else
      if KeyComp('Pascal') then fExID := TptTokenKind.ptPascal;
end;

method TmwBasePasLex.Func54: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Class') then Result := TptTokenKind.ptClass;
end;

method TmwBasePasLex.Func55: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Object') then Result := TptTokenKind.ptObject;
end;

method TmwBasePasLex.Func56: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Index') then fExID := TptTokenKind.ptIndex else
    if KeyComp('Out') then fExID := TptTokenKind.ptOut else // bug in Delphi's documentation: OUT is a directive
      if KeyComp('Abort') then fExID := TptTokenKind.ptAbort else
        if KeyComp('Delayed') then fExID := TptTokenKind.ptDelayed;
end;

method TmwBasePasLex.Func57: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('While') then Result := TptTokenKind.ptWhile
  else if KeyComp('Xor') then Result := TptTokenKind.ptXor
  else if KeyComp('Goto') then Result := TptTokenKind.ptGoto;
end;

method TmwBasePasLex.Func58: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Exit') then fExID := TptTokenKind.ptExit;
end;

method TmwBasePasLex.Func59: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Safecall') then fExID := TptTokenKind.ptSafeCall else
    if KeyComp('Double') then fExID := TptTokenKind.ptDouble;
end;

method TmwBasePasLex.Func60: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('With') then Result := TptTokenKind.ptWith else
    if KeyComp('Word') then fExID := TptTokenKind.ptWord;
end;

method TmwBasePasLex.Func61: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Dispid') then fExID := TptTokenKind.ptDispid;
end;

method TmwBasePasLex.Func62: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Cardinal') then fExID := TptTokenKind.ptCardinal;
end;

method TmwBasePasLex.Func63: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  case fBuffer.Buf[fTokenPos] of
    'P', 'p': if KeyComp('Public') then fExID := TptTokenKind.ptPublic;
    'A', 'a': if KeyComp('Array') then Result := TptTokenKind.ptArray;
    'T', 't': if KeyComp('Try') then Result := TptTokenKind.ptTry;
    'R', 'r': if KeyComp('Record') then Result := TptTokenKind.ptRecord;
    'I', 'i': if KeyComp('Inline') then
    begin
      Result := TptTokenKind.ptInline;
      fExID := TptTokenKind.ptInline;
    end;
  end;
end;

method TmwBasePasLex.Func64: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  case fBuffer.Buf[fTokenPos] of
    'B', 'b': if KeyComp('Boolean') then fExID := TptTokenKind.ptBoolean;
    'D', 'd': if KeyComp('DWORD') then fExID := TptTokenKind.ptDWORD;
    'U', 'u': if KeyComp('Uses') then Result := TptTokenKind.ptUses else
      if KeyComp('Unit') then Result := TptTokenKind.ptUnit;
    'H', 'h': if KeyComp('Helper') then fExID := TptTokenKind.ptHelper;
  end;
end;

method TmwBasePasLex.Func65: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Repeat') then Result := TptTokenKind.ptRepeat;
end;

method TmwBasePasLex.Func66: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Single') then fExID := TptTokenKind.ptSingle else
    if KeyComp('Type') then Result := TptTokenKind.ptType else
      if KeyComp('Unsafe') then Result := TptTokenKind.ptUnsafe;
end;

method TmwBasePasLex.Func69: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Default') then fExID := TptTokenKind.ptDefault else
    if KeyComp('Dynamic') then fExID := TptTokenKind.ptDynamic else
      if KeyComp('Message') then fExID := TptTokenKind.ptMessage;
end;

method TmwBasePasLex.Func71: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('WideChar') then fExID := TptTokenKind.ptWideChar else
    if KeyComp('Stdcall') then fExID := TptTokenKind.ptStdcall else
      if KeyComp('Const') then Result := TptTokenKind.ptConst;
end;

method TmwBasePasLex.Func72: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Static') then fExID := TptTokenKind.ptStatic;
end;

method TmwBasePasLex.Func73: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Except') then Result := TptTokenKind.ptExcept else
    if KeyComp('AnsiChar') then fExID := TptTokenKind.ptAnsiChar;
end;

method TmwBasePasLex.Func75: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Write') then fExID := TptTokenKind.ptWrite;
end;

method TmwBasePasLex.Func76: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Until') then Result := TptTokenKind.ptUntil;
end;

method TmwBasePasLex.Func77: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Namespace') then Result := TptTokenKind.ptNamespace;
end;

method TmwBasePasLex.Func78: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Integer') then fExID := TptTokenKind.ptInteger else
    if KeyComp('Remove') then fExID := TptTokenKind.ptRemove;
end;

method TmwBasePasLex.Func79: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Finally') then Result := TptTokenKind.ptFinally else
    if KeyComp('Reference') then fExID := TptTokenKind.ptReference;
end;

method TmwBasePasLex.Func81: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Extended') then fExID := TptTokenKind.ptExtended else
    if KeyComp('Stored') then fExID := TptTokenKind.ptStored else
      if KeyComp('Interface') then Result := TptTokenKind.ptInterface else
        if KeyComp('Deprecated') then fExID := TptTokenKind.ptDeprecated;
end;

method TmwBasePasLex.Func84: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Abstract') then fExID := TptTokenKind.ptAbstract;
end;

method TmwBasePasLex.Func85: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Library') then Result := TptTokenKind.ptLibrary else
    if KeyComp('Forward') then fExID := TptTokenKind.ptForward else
      if KeyComp('Variant') then fExID := TptTokenKind.ptVariant;
end;

method TmwBasePasLex.Func87: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('String') then Result := TptTokenKind.ptString;
end;

method TmwBasePasLex.Func88: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Program') then Result := TptTokenKind.ptProgram;
end;

method TmwBasePasLex.Func89: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Strict') then fExID := TptTokenKind.ptStrict;
end;

method TmwBasePasLex.Func91: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Downto') then Result := TptTokenKind.ptDownto else
    if KeyComp('Private') then fExID := TptTokenKind.ptPrivate else
      if KeyComp('Longint') then fExID := TptTokenKind.ptLongint;
end;

method TmwBasePasLex.Func92: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Inherited') then Result := TptTokenKind.ptInherited else
    if KeyComp('LongBool') then fExID := TptTokenKind.ptLongBool else
      if KeyComp('Overload') then fExID := TptTokenKind.ptOverload;
end;

method TmwBasePasLex.Func94: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Resident') then fExID := TptTokenKind.ptResident else
    if KeyComp('Readonly') then fExID := TptTokenKind.ptReadonly else
      if KeyComp('Assembler') then fExID := TptTokenKind.ptAssembler;
end;

method TmwBasePasLex.Func95: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Contains') then fExID := TptTokenKind.ptContains
  else if KeyComp('Absolute') then fExID := TptTokenKind.ptAbsolute
  else if KeyComp('Dependency') then fExID := TptTokenKind.ptDependency; //#240

end;


method TmwBasePasLex.Func96: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;

  if KeyComp('ByteBool') then fExID := TptTokenKind.ptByteBool else
    if KeyComp('Override') then fExID := TptTokenKind.ptOverride else
      if KeyComp('Published') then fExID := TptTokenKind.ptPublished;
end;

method TmwBasePasLex.Func97: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Threadvar') then Result := TptTokenKind.ptThreadvar;
end;

method TmwBasePasLex.Func98: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Export') then fExID := TptTokenKind.ptExport else
    if KeyComp('Nodefault') then fExID := TptTokenKind.ptNodefault;
end;

method TmwBasePasLex.Func99: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('External') then fExID := TptTokenKind.ptExternal;
end;

method TmwBasePasLex.Func100: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Automated') then fExID := TptTokenKind.ptAutomated else
    if KeyComp('Smallint') then fExID := TptTokenKind.ptSmallint;
end;

method TmwBasePasLex.Func101: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Register') then fExID:= TptTokenKind.ptRegister
  else if KeyComp('Platform') then fExID:= TptTokenKind.ptPlatform
  else if KeyComp('Continue') then fExID:= TptTokenKind.ptContinue;
end;

method TmwBasePasLex.Func102: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Function') then Result := TptTokenKind.ptFunction;
end;

method TmwBasePasLex.Func103: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Virtual') then fExID := TptTokenKind.ptVirtual;
end;

method TmwBasePasLex.Func104: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('WordBool') then fExID := TptTokenKind.ptWordBool;
end;

method TmwBasePasLex.Func105: TptTokenKind;
begin
  Result := TptTokenKind.ptIdentifier;
  if KeyComp('Procedure') then Result := TptTokenKind.ptProcedure;
end;

method TmwBasePasLex.Func106: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('Protected') then fExID := TptTokenKind.ptProtected;
end;

method TmwBasePasLex.Func107: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('Currency') then fExID := TptTokenKind.ptCurrency;
end;

method TmwBasePasLex.Func108: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('Longword') then fExID := TptTokenKind.ptLongword else
    if KeyComp('Operator') then fExID := TptTokenKind.ptOperator;
end;

method TmwBasePasLex.Func112: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('Requires') then fExID := TptTokenKind.ptRequires;
end;

method TmwBasePasLex.Func117: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('Exports') then Result:= TptTokenKind.ptExports
  else if KeyComp('OleVariant') then fExID:= TptTokenKind.ptOleVariant;
end;

method TmwBasePasLex.Func123: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('Shortint') then fExID := TptTokenKind.ptShortint;
end;

method TmwBasePasLex.Func126: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('Implements') then fExID := TptTokenKind.ptImplements;
end;

method TmwBasePasLex.Func127: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('Runerror') then fExID := TptTokenKind.ptRunError;
end;

method TmwBasePasLex.Func128: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('WideString') then fExID := TptTokenKind.ptWideString;
end;

method TmwBasePasLex.Func129: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('Dispinterface') then Result := TptTokenKind.ptDispinterface
end;

method TmwBasePasLex.Func130: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('AnsiString') then begin
    Result:= TptTokenKind.ptString;
    fExID := TptTokenKind.ptAnsiString;
  end;
end;

method TmwBasePasLex.Func132: TptTokenKind;
begin
  result := TptTokenKind.ptIdentifier;
  if KeyComp('Reintroduce') then fExID := TptTokenKind.ptReintroduce;
end;

method TmwBasePasLex.Func133: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;

  if KeyComp('Property') then Result := TptTokenKind.ptProperty;
end;

method TmwBasePasLex.Func136: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('Finalization') then Result := TptTokenKind.ptFinalization;
end;

method TmwBasePasLex.Func141: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('Writeonly') then fExID := TptTokenKind.ptWriteonly;
end;

method TmwBasePasLex.Func142: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('experimental') then fExID := TptTokenKind.ptExperimental;
end;

method TmwBasePasLex.Func143: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('Destructor') then Result := TptTokenKind.ptDestructor;
end;

method TmwBasePasLex.Func166: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('Constructor') then Result:= TptTokenKind.ptConstructor
  else if KeyComp('Implementation') then Result:= TptTokenKind.ptImplementation;
end;

method TmwBasePasLex.Func167: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('ShortString') then fExID := TptTokenKind.ptShortString;
end;

method TmwBasePasLex.Func168: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('Initialization') then Result := TptTokenKind.ptInitialization;
end;

method TmwBasePasLex.Func191: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('Resourcestring') then Result:= TptTokenKind.ptResourcestring
  else if KeyComp('Stringresource') then fExID:= TptTokenKind.ptStringresource;
end;

method TmwBasePasLex.AltFunc: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
end;

method TmwBasePasLex.IdentKind: TptTokenKind;
var
HashKey: Integer;
begin
  HashKey := KeyHash;
  if HashKey < 192 then
    Result := fIdentFuncTable[HashKey]()
  else
    Result :=TptTokenKind.ptIdentifier;
end;

method TmwBasePasLex.MakeMethodTables;
var
I: Char;
begin
  for I := #0 to #127 do
    case I of
      #0: fProcTable[I] := @NullProc;
      #10: fProcTable[I] := @LFProc;
      #13: fProcTable[I] := @CRProc;
      #1..#9, #11, #12, #14..#32: fProcTable[I] := @SpaceProc;
      '#': fProcTable[I] := @AsciiCharProc;
      '$': fProcTable[I] := @IntegerProc;
      #39: fProcTable[I] := @StringProc;
      '0'..'9': fProcTable[I] := @NumberProc;
      'A'..'Z', 'a'..'z', '_': fProcTable[I] := @IdentProc;
      '{': fProcTable[I] := @BraceOpenProc;
      '}': fProcTable[I] := @BraceCloseProc;
      '!', '"', '%', '&', '('..'/', ':'..'@', '['..'^', '`', '~':
      begin
        case I of
          '(': fProcTable[I] := @RoundOpenProc;
          ')': fProcTable[I] := @RoundCloseProc;
          '*': fProcTable[I] := @StarProc;
          '+': fProcTable[I] := @PlusProc;
          ',': fProcTable[I] := @CommaProc;
          '-': fProcTable[I] := @MinusProc;
          '.': fProcTable[I] := @PointProc;
          '/': fProcTable[I] := @SlashProc;
          ':': fProcTable[I] := @ColonProc;
          ';': fProcTable[I] := @SemiColonProc;
          '<': fProcTable[I] := @LowerProc;
          '=': fProcTable[I] := @EqualProc;
          '>': fProcTable[I] := @GreaterProc;
          '@': fProcTable[I] := @AddressOpProc;
          '[': fProcTable[I] := @SquareOpenProc;
          ']': fProcTable[I] := @SquareCloseProc;
          '^': fProcTable[I] := @PointerSymbolProc;
          '"': fProcTable[I] := @StringDQProc;
          '&': fProcTable[I] := @AmpersandOpProc;
          else
            fProcTable[I] := @SymbolProc;
        end;
      end;
      else
        fProcTable[I] := @UnknownProc;
    end;
end;

constructor TmwBasePasLex.Create(const aCompiler : DelphiCompiler);

begin
  inherited constructor() ;
  fCompiler := aCompiler;
  InitIdent;
  MakeMethodTables;
  fExID := TptTokenKind.ptUnknown;

  fUseDefines := true;
  fScopedEnums := False;
//  FTopDefineRec:= new Stack<TDefineRec>();
  ClearDefines;
  fBuffer := new TBufferRec();
  InitDefinesDefinedByCompiler;
end;



method TmwBasePasLex.DoOnComment(const CommentText: not nullable string);
require
  assigned(OnComment);

begin
  if not fUseDefines or (fDefineStack = 0) then
    OnComment(Self, CommentText);
end;

method TmwBasePasLex.DoProcTable(AChar: Char);
begin
{$IF DEBUG}
var lShort := ord(AChar);
if lShort < 127 then;

 {$ENDIF}

  if ord(AChar) <= 127 then
    fProcTable[AChar]()
  else
  begin
    IdentProc;
  end;
end;

method TmwBasePasLex.SetOrigin(const NewValue: not nullable string);
begin
  fBuffer.Buf := NewValue+#0;
  InitLexer;
  Next;
end;

method TmwBasePasLex.SetRunPos(const Value: Integer);
begin
  fBuffer.Run := Value;
  Next;
end;

method TmwBasePasLex.SetSharedBuffer(SharedBuffer: TBufferRec);
begin
  while assigned(fBuffer.Next) do
    fBuffer := fBuffer.Next;

  if not fBuffer.SharedBuffer and assigned(fBuffer.Buf) then
    fBuffer.Buf := '';

  fBuffer.Buf := SharedBuffer.Buf;
  fBuffer.Run := SharedBuffer.Run;
  fBuffer.LineNumber := SharedBuffer.LineNumber;
  fBuffer.LinePos := SharedBuffer.LinePos;
  fBuffer.SharedBuffer := True;

  Next;
end;

method TmwBasePasLex.AddDefine(const ADefine: not nullable string);

begin
  fDefines.Add(ADefine);
end;

method TmwBasePasLex.AddressOpProc;
begin
  case fBuffer.Buf[fBuffer.Run + 1] of
    '@':
    begin
      fTokenID := TptTokenKind.ptDoubleAddressOp;
      inc(fBuffer.Run, 2);
    end;
    else
      begin
        fTokenID := TptTokenKind.ptAddressOp;
        inc(fBuffer.Run);
      end;
  end;
end;

method TmwBasePasLex.AsciiCharProc;
begin
  fTokenID := TptTokenKind.ptAsciiChar;
  inc(fBuffer.Run);
  if fBuffer.Buf[fBuffer.Run] = '$' then
  begin
    inc(fBuffer.Run);
  // ['0'..'9', 'A'..'F', 'a'..'f']
    while (fBuffer.Buf[fBuffer.Run] in ['0'..'9', 'A'..'F', 'a'..'f']) do inc(fBuffer.Run);
  end else
  begin

{$IF TOFFEE}
while String.CharacterisNumber(FBuffer.Buf[FBuffer.Run]) do
  inc(FBuffer.Run);
{$ELSE}
while Char.IsNumber(fBuffer.Buf[fBuffer.Run]) do
  inc(fBuffer.Run);
{$ENDIF}

  end;
end;

method TmwBasePasLex.BraceCloseProc;
begin
  inc(fBuffer.Run);
  fTokenID := TptTokenKind.ptError;
  if assigned(OnMessage) then
    OnMessage(Self, TMessageEventType.meError, 'Illegal character', PosXY.X, PosXY.Y);
end;

method TmwBasePasLex.BorProc;
var
BeginRun: Integer;
CommentText: String;
begin
  fTokenID := TptTokenKind.ptBorComment;
  case fBuffer.Buf[fBuffer.Run] of
    #0:
    begin
      NullProc;
      if assigned(OnMessage) then
        OnMessage(Self, TMessageEventType.meError, 'Unexpected file end', PosXY.X, PosXY.Y);
      Exit;
    end;
  end;

  BeginRun := fBuffer.Run;

  while fBuffer.Buf[fBuffer.Run] <> #0 do
    case fBuffer.Buf[fBuffer.Run] of
      '}':
      begin
        fCommentState := TCommentState.csNo;
        inc(fBuffer.Run);
        Break;
      end;
      #10:
      begin
        inc(fBuffer.Run);
        inc(fBuffer.LineNumber);
        fBuffer.LinePos := fBuffer.Run;
      end;
      #13:
      begin
        inc(fBuffer.Run);
        if fBuffer.Buf[fBuffer.Run] = #10 then inc(fBuffer.Run);
        inc(fBuffer.LineNumber);
        fBuffer.LinePos := fBuffer.Run;
      end;
      else
        inc(fBuffer.Run);
    end;

  if assigned(OnComment) then
  begin
    CommentText := fBuffer.Buf.Substring( BeginRun, fBuffer.Run - BeginRun - 1);
    DoOnComment(CommentText);
  end;
end;

method TmwBasePasLex.BraceOpenProc;
var
BeginRun: Integer;
CommentText: String;
begin
  case fBuffer.Buf[fBuffer.Run + 1] of
    '$': fTokenID := GetDirectiveKind;
    else
      begin
        fTokenID := TptTokenKind.ptBorComment;
        fCommentState := TCommentState.csBor;
      end;
  end;

  inc(fBuffer.Run);
  BeginRun := fBuffer.Run;
  while fBuffer.Buf[fBuffer.Run] <> #0 do
    case fBuffer.Buf[fBuffer.Run] of
      '}':
      begin
        fCommentState := TCommentState.csNo;
       // Position of Comment is on the end before {
        if fTokenID = TptTokenKind.ptBorComment then
          fTokenPos := fBuffer.Run-1;
        inc(fBuffer.Run);
        Break;
      end;
      #10:
      begin
        inc(fBuffer.Run);
        inc(fBuffer.LineNumber);
        fBuffer.LinePos := fBuffer.Run;
      end;
      #13:
      begin
        inc(fBuffer.Run);
        if fBuffer.Buf[fBuffer.Run] = #10 then inc(fBuffer.Run);
        inc(fBuffer.LineNumber);
        fBuffer.LinePos := fBuffer.Run;
      end;
      else
        inc(fBuffer.Run);
    end;
  case fTokenID of
    TptTokenKind.ptBorComment:
    begin
      if assigned(OnComment) then
      begin
        CommentText := fBuffer.Buf.Substring( BeginRun, fBuffer.Run - BeginRun - 1);
        DoOnComment(CommentText);
      end;
    end;
    TptTokenKind.ptCompDirect:
    begin
      if assigned(OnCompDirect) then
        OnCompDirect(Self);
    end;
    TptTokenKind.ptDefineDirect:
    begin
      if fUseDefines and (fDefineStack = 0) then
        AddDefine(DirectiveParam);
      if assigned(OnDefineDirect) then
        OnDefineDirect(Self);
    end;
    TptTokenKind.ptElseDirect:
    begin
      if fUseDefines then
      begin
        if fTopDefineRec.Count > 0 then
        begin
          if fTopDefineRec.Peek.Defined then
            inc(fDefineStack)
          else
            if fDefineStack > 0 then
              dec(fDefineStack);
        end;
      end;
      if assigned(OnElseDirect) then
        OnElseDirect(Self);
    end;
    TptTokenKind.ptEndIfDirect:
    begin
      if fUseDefines then
        ExitDefineBlock;
      if assigned(OnEndIfDirect) then
        OnEndIfDirect(Self);
    end;
    TptTokenKind.ptIfDefDirect:
    begin
      if fUseDefines then
        EnterDefineBlock(IsDefined(DirectiveParam));
      if assigned(OnIfDefDirect) then
        OnIfDefDirect(Self);
    end;
    TptTokenKind.ptIfNDefDirect:
    begin
      if fUseDefines then
        EnterDefineBlock(not IsDefined(DirectiveParam));
      if assigned(OnIfNDefDirect) then
        OnIfNDefDirect(Self);
    end;
    TptTokenKind.ptIfOptDirect:
    begin
      if fUseDefines then
        EnterDefineBlock(False);
      if assigned(OnIfOptDirect) then
        OnIfOptDirect(Self);
    end;
    TptTokenKind.ptIfDirect:
    begin
      if fUseDefines then
        EnterDefineBlock(EvaluateConditionalExpression(DirectiveParam));
      if assigned(OnIfDirect) then
        OnIfDirect(Self);
    end;
    TptTokenKind.ptIfEndDirect:
    begin
      if fUseDefines then
        ExitDefineBlock;
      if assigned(OnIfEndDirect) then
        OnIfEndDirect(Self);
    end;
    TptTokenKind.ptElseIfDirect:
    begin
      if fUseDefines then
      begin
        if fTopDefineRec.Count > 0 then
        begin
          if fTopDefineRec.Peek.Defined then
            fDefineStack := fTopDefineRec.Peek.StartCount + 1
          else
          begin
            fDefineStack := fTopDefineRec.Peek.StartCount;
            if EvaluateConditionalExpression(DirectiveParam) then
              fTopDefineRec.Peek.Defined := True
            else
              fDefineStack := fTopDefineRec.Peek.StartCount + 1
          end;
        end;
      end;
      if assigned(OnElseIfDirect) then
        OnElseIfDirect(Self);
    end;
    TptTokenKind.ptIncludeDirect:
    begin

      if assigned(fIncludeHandler) and (fDefineStack = 0) then
        IncludeFile
      else
        Next;
    end;
    TptTokenKind.ptResourceDirect:
    begin
      if assigned(OnResourceDirect) then
        OnResourceDirect(Self);
    end;
    TptTokenKind.ptScopedEnumsDirect:
    begin
      UpdateScopedEnums;
    end;
    TptTokenKind.ptUndefDirect:
    begin
      if fUseDefines and (fDefineStack = 0) then
        RemoveDefine(DirectiveParam);
      if assigned(OnUnDefDirect) then
        OnUnDefDirect(Self);
    end;
  end;
end;

method TmwBasePasLex.EvaluateComparison(AValue1: Double; const AOper: not nullable String; AValue2: Double): Boolean;
begin
  if AOper = '=' then
    Result := AValue1 = AValue2
  else if AOper = '<>' then
    Result := AValue1 <> AValue2
  else if AOper = '<' then
    Result := AValue1 < AValue2
  else if AOper = '<=' then
    Result := AValue1 <= AValue2
  else if AOper = '>' then
    Result := AValue1 > AValue2
  else if AOper = '>=' then
    Result := AValue1 >= AValue2
  else
    Result := False;
end;

method TmwBasePasLex.EvaluateSpeciaConditionalExpression(const AParams: not nullable String): Boolean;
begin
  result := false;
  if assigned(OnParseCompilerDirectiveEvent) then
  begin
    var res : Boolean := false;
    if OnParseCompilerDirectiveEvent(self, AParams, out res) then
      exit res;
  end;

 // We should raise a Exception...........
  if not result then
    raise new EParserException(PosXY.Y, PosXY.X,'',$"can not solve Compiler directive [{AParams}]");

end;

method TmwBasePasLex.EvaluateConditionalExpression(const AParams: not nullable String): Boolean;
var
LParams: not nullable String;
LDefine: not nullable String;
LEvaluation: Lee;
LIsComVer: Boolean;
LIsRtlVer: Boolean;
LOper: not nullable String;
LValue: Integer;
p: Integer;

  method DeleteOneBased(Var value : not nullable String; start : Integer; len : Integer); inline;
  begin
    value := value.Remove(start-1, len);
  end;

  method PosIndexOneBassed(const check : not nullable String; const Value : not nullable String) : Integer; inline;
  begin
    result := Value.IndexOf(check)+1;
  end;

  method CopyOneBased(const Value : not nullable String; start : Integer; len : Integer) : not nullable String;
  begin
    result := Value.Substring(start-1, len);
  end;

  method TrimLeft(const Value : not nullable String) : not nullable String; inline;
  begin
    result := Value.TrimStart;
  end;

begin
  //{$HINT check against original Sources the consts}
  { TODO : Expand support for <=> evaluations (complicated to do). Expand support for NESTED expressions }
  LEvaluation := Lee.None;
  LParams := AParams.TrimStart;
  LIsComVer := PosIndexOneBassed('COMPILERVERSION', LParams) = 1;
  LIsRtlVer := PosIndexOneBassed('RTLVERSION', LParams) = 1;
  if LIsComVer or LIsRtlVer then //simple parser which covers most frequent use cases
  begin
    Result := False;
    if LIsComVer then
      DeleteOneBased(var LParams, 1, length('COMPILERVERSION'));
    if LIsRtlVer then
      DeleteOneBased(var LParams, 1, length('RTLVERSION'));
    while (LParams <> '') and (LParams[0] = ' ') do
      DeleteOneBased(var LParams, 1, 1);
    p := PosIndexOneBassed(' ', LParams);
    if p > 0 then
    begin
      LOper := CopyOneBased(LParams, 1, p-1);
      DeleteOneBased(var LParams, 1, p);
      while (LParams <> '') and (LParams[0] = ' ') do
        DeleteOneBased(var LParams, 1, 1);
      p := PosIndexOneBassed(' ', LParams);
      if p = 0 then
        p := length(LParams);
      if p=4 then
        LParams := CopyOneBased(LParams,1,2);

      if Integer.TryParse(LParams, out  LValue) then
      begin
        if LIsComVer then
          Result := EvaluateComparison(DelphiDefines.getCompilerversion(fCompiler), LOper, LValue)
        else if LIsRtlVer then
          Result := EvaluateComparison(DelphiDefines.getRTLVersion(fCompiler), LOper, LValue);
      end;
    end;
  end else
    if (PosIndexOneBassed('DEFINED(', LParams) = 1) or (PosIndexOneBassed('NOT DEFINED(', LParams) = 1) then
    begin
      Result := True; // Optimistic
      while (PosIndexOneBassed('DEFINED(', LParams) = 1) or (PosIndexOneBassed('NOT DEFINED(', LParams) = 1) do
      begin
        if PosIndexOneBassed('DEFINED(', LParams) = 1 then
        begin
          LDefine := CopyOneBased(LParams, 9, PosIndexOneBassed(')', LParams) - 9);
          LParams := TrimLeft(CopyOneBased(LParams, 10 + length(LDefine), length(LParams) - (9 + length(LDefine))));
          case LEvaluation of
            Lee.None: Result := IsDefined(LDefine);
            Lee.And: Result := Result and IsDefined(LDefine);
            Lee.Or: Result := Result or IsDefined(LDefine);
          end;
        end
        else if PosIndexOneBassed('NOT DEFINED(', LParams) = 1 then
        begin
          LDefine := CopyOneBased(LParams, 13, PosIndexOneBassed(')', LParams) - 13);
          LParams := TrimLeft(CopyOneBased(LParams, 14 + length(LDefine), length(LParams) - (13 + length(LDefine))));
          case LEvaluation of
            Lee.None: Result := (not IsDefined(LDefine));
            Lee.And: Result := Result and (not IsDefined(LDefine));
            Lee.Or: Result := Result or (not IsDefined(LDefine));
          end;
        end;
      // Determine next Evaluation
        if PosIndexOneBassed('AND ', LParams) = 1 then
        begin
          LEvaluation := Lee.And;
          LParams := TrimLeft(CopyOneBased(LParams, 4, length(LParams) - 3));
        end
        else if PosIndexOneBassed('OR ', LParams) = 1 then
        begin
          LEvaluation := Lee.Or;
          LParams := TrimLeft(CopyOneBased(LParams, 3, length(LParams) - 2));
        end;
      end;
    end
    else
      result := EvaluateSpeciaConditionalExpression(LParams);
end;

method TmwBasePasLex.ColonProc;
begin
  case fBuffer.Buf[fBuffer.Run + 1] of
    '=':
    begin
      inc(fBuffer.Run, 2);
      fTokenID := TptTokenKind.ptAssign;
    end;
    else
      begin
        inc(fBuffer.Run);
        fTokenID := TptTokenKind.ptColon;
      end;
  end;
end;

method TmwBasePasLex.CommaProc;
begin
  inc(fBuffer.Run);
  fTokenID := TptTokenKind.ptComma;
end;

method TmwBasePasLex.CRProc;
begin
  case fCommentState of
    TCommentState.csBor: fTokenID := TptTokenKind.ptCRLFCo;
    TCommentState.csAnsi: fTokenID := TptTokenKind.ptCRLFCo;
    else
      fTokenID := TptTokenKind.ptCRLF;
  end;

  case fBuffer.Buf[fBuffer.Run + 1] of
    #10: inc(fBuffer.Run, 2);
    else
      inc(fBuffer.Run);
  end;
  inc(fBuffer.LineNumber);
  fBuffer.LinePos := fBuffer.Run;
end;

method TmwBasePasLex.EnterDefineBlock(ADefined: Boolean);
var
StackFrame: TDefineRec;
begin
  StackFrame := New TDefineRec();
  StackFrame.Defined := ADefined;
  StackFrame.StartCount := fDefineStack;
  fTopDefineRec.Push(StackFrame);// := StackFrame;
  if not ADefined then
    inc(fDefineStack);
end;

method TmwBasePasLex.EqualProc;
begin
  inc(fBuffer.Run);
  fTokenID := TptTokenKind.ptEqual;
end;

method TmwBasePasLex.ExitDefineBlock;

begin
  if fTopDefineRec.Count > 0 then
  begin
    var StackFrame := fTopDefineRec.Pop;
    fDefineStack := StackFrame.StartCount;
  end;

end;

method TmwBasePasLex.GreaterProc;
begin
  case fBuffer.Buf[fBuffer.Run + 1] of
    '=':
    begin
      inc(fBuffer.Run, 2);
      fTokenID := TptTokenKind.ptGreaterEqual;
    end;
    else
      begin
        inc(fBuffer.Run);
        fTokenID := TptTokenKind.ptGreater;
      end;
  end;
end;

method TmwBasePasLex.HashValue(AChar: Char): Integer;
begin
  if AChar <= #127 then
    Result := mHashTable[fBuffer.Buf[fBuffer.Run]]
  else
    Result := ord(AChar);
end;

method TmwBasePasLex.IdentProc;
begin
  fTokenID := IdentKind;
end;

method TmwBasePasLex.IntegerProc;
begin
  inc(fBuffer.Run);
  fTokenID := TptTokenKind.ptIntegerConst;
//  ['0'..'9', 'A'..'F', 'a'..'f']
  while (fBuffer.Buf[fBuffer.Run] in ['0'..'9', 'A'..'F', 'a'..'f']  ) do
    inc(fBuffer.Run);
end;

method TmwBasePasLex.IsDefined(const ADefine: not nullable string): Boolean;
begin
  for Define in  fDefines do
    if Define:EqualsIgnoringCase(ADefine) then
      Exit(True);
  Result := False;
end;

method TmwBasePasLex.IsIdentifiers(AChar: Char): Boolean;
begin
{$IF ECHOES}

exit Char.IsLetterOrDigit(AChar) or (AChar = '_');
{$ELSEIF TOFFEE}
exit  String.CharacterIsLetterOrNumber(AChar) or (AChar = '_');
{$ELSE}
 {$HINT 'Needs Checks'}

 if AChar = '_' then exit true;
 if Char.IsNumber(AChar) then exit(true);
 if Char.IsWhiteSpace(AChar) then exit false;
 if AChar in [#0,'.',';',',','!','<','>','(',')'] then exit false;
 exit true;
{$ENDIF}
end;

method TmwBasePasLex.LFProc;
begin
  case fCommentState of
    TCommentState.csBor: fTokenID := TptTokenKind.ptCRLFCo;
    TCommentState.csAnsi: fTokenID := TptTokenKind.ptCRLFCo;
    else
      fTokenID := TptTokenKind.ptCRLF;
  end;
  inc(fBuffer.Run);
  inc(fBuffer.LineNumber);
  fBuffer.LinePos := fBuffer.Run;
end;

method TmwBasePasLex.LowerProc;
begin
  case fBuffer.Buf[fBuffer.Run + 1] of
    '=':
    begin
      inc(fBuffer.Run, 2);
      fTokenID := TptTokenKind.ptLowerEqual;
    end;
    '>':
    begin
      inc(fBuffer.Run, 2);
      fTokenID := TptTokenKind.ptNotEqual;
    end
    else
      begin
        inc(fBuffer.Run);
        fTokenID := TptTokenKind.ptLower;
      end;
  end;
end;

method TmwBasePasLex.MinusProc;
begin
  inc(fBuffer.Run);
  fTokenID := TptTokenKind.ptMinus;
end;

method TmwBasePasLex.NullProc;
begin
  if assigned(fBuffer.Next) then
  begin
    fBuffer := fBuffer.Next;
    Next;
  end else
    fTokenID := TptTokenKind.ptNull;
end;

method TmwBasePasLex.NumberProc;
begin
  inc(fBuffer.Run);
  fTokenID := TptTokenKind.ptIntegerConst;
//  ['0'..'9', '.', 'e', 'E']
  while (fBuffer.Buf[fBuffer.Run] in ['0'..'9', '.', 'e', 'E']) do
  begin
    case fBuffer.Buf[fBuffer.Run] of
      '.':
      if fBuffer.Buf[fBuffer.Run + 1] = '.' then
        Break
      else
        fTokenID := TptTokenKind.ptFloat
      end;
    inc(fBuffer.Run);
  end;
end;

method TmwBasePasLex.PlusProc;
begin
  inc(fBuffer.Run);
  fTokenID := TptTokenKind.ptPlus;
end;

method TmwBasePasLex.PointerSymbolProc;
//const
//  PointerChars = ['a'..'z', 'A'..'Z', '\', '!', '"', '#', '$', '%', '&', '''',
  //                '?', '@', '_', '`', '|', '}', '~'];
                  // TODO: support ']', '), ''*', '+', ',', '-', '.', '/', ':', ';', '<', '=', '>', '{', '^', '(', '['
begin
  inc(fBuffer.Run);
  fTokenID := TptTokenKind.ptPointerSymbol;

  //This is a wierd Pascal construct that rarely appears, but needs to be
  //supported. ^M is a valid char reference (#13, in this case)
  if (fBuffer.Buf[fBuffer.Run] in ['a'..'z', 'A'..'Z', '\', '!', '"', '#', '$', '%', '&', '''','?', '@', '_', '`', '|', '}', '~'])
  and not IsIdentifiers(fBuffer.Buf[fBuffer.Run+1]) then
  begin
    inc(fBuffer.Run);
    fTokenID := TptTokenKind.ptAsciiChar;
  end;
end;

method TmwBasePasLex.PointProc;
begin
  case fBuffer.Buf[fBuffer.Run + 1] of
    '.':
    begin
      inc(fBuffer.Run, 2);
      fTokenID := TptTokenKind.ptDotDot;
    end;
    ')':
    begin
      inc(fBuffer.Run, 2);
      fTokenID := TptTokenKind.ptSquareClose;
    end;
    else
      begin
        inc(fBuffer.Run);
        fTokenID := TptTokenKind.ptPoint;
      end;
  end;
end;



method TmwBasePasLex.RemoveDefine(const ADefine: not nullable string);
begin
  for i : Integer := fDefines.Count-1 downto 0 do
    begin

    if (fDefines[i] = nil)  or
     fDefines[i].EqualsIgnoringCase(ADefine) then
      fDefines.RemoveAt(i);
  end;
end;

method TmwBasePasLex.RoundCloseProc;
begin
  inc(fBuffer.Run);
  fTokenID := TptTokenKind.ptRoundClose;
end;

method TmwBasePasLex.AnsiProc;
var
BeginRun: Integer;
CommentText: String;
begin
  fTokenID := TptTokenKind.ptAnsiComment;
  case fBuffer.Buf[fBuffer.Run] of
    #0:
    begin
      NullProc;
      if assigned(OnMessage) then
        OnMessage(Self, TMessageEventType.meError, 'Unexpected file end', PosXY.X, PosXY.Y);
      Exit;
    end;
  end;

  BeginRun := fBuffer.Run + 1;

  while fBuffer.Run < fBuffer.Buf.Length  do
    case fBuffer.Buf[fBuffer.Run] of
      '*':
      if fBuffer.Buf[fBuffer.Run + 1] = ')' then
      begin
        fCommentState := TCommentState.csNo;
        inc(fBuffer.Run, 2);
        Break;
      end
      else inc(fBuffer.Run);
      #10:
      begin
        inc(fBuffer.Run);
        inc(fBuffer.LineNumber);
        fBuffer.LinePos := fBuffer.Run;
      end;
      #13:
      begin
        inc(fBuffer.Run);
        if fBuffer.Buf[fBuffer.Run] = #10 then inc(fBuffer.Run);
        inc(fBuffer.LineNumber);
        fBuffer.LinePos := fBuffer.Run;
      end;
      else
        inc(fBuffer.Run);
    end;

  if assigned(OnComment) then
  begin
    CommentText := fBuffer.Buf.Substring( BeginRun, fBuffer.Run - BeginRun - 2);
    DoOnComment(CommentText);
  end;
end;

method TmwBasePasLex.RoundOpenProc;
begin
  var BeginRun := fBuffer.Run + 2; // The Comment or Directive start here
  inc(fBuffer.Run);
  case fBuffer.Buf[fBuffer.Run] of
    '*':
    begin
      fTokenID := TptTokenKind.ptAnsiComment;
      if fBuffer.Buf[fBuffer.Run + 1] = '$' then
        fTokenID := GetDirectiveKind
      else
        fCommentState := TCommentState.csAnsi;
      inc(fBuffer.Run);
      while fBuffer.Buf[fBuffer.Run] <> #0 do
        case fBuffer.Buf[fBuffer.Run] of
          '*':
          if fBuffer.Buf[fBuffer.Run + 1] = ')' then
          begin
            fCommentState := TCommentState.csNo;
            // The Position in the CommentNode is at the end before "*)"
            // Only for Comments
            if fTokenID = TptTokenKind.ptAnsiComment then
              fTokenPos := fBuffer.Run-1;
            inc(fBuffer.Run, 2);
            Break;
          end
          else
            inc(fBuffer.Run);
          #10:
          begin
            inc(fBuffer.Run);
            inc(fBuffer.LineNumber);
            fBuffer.LinePos := fBuffer.Run;
          end;
          #13:
          begin
            inc(fBuffer.Run);
            if fBuffer.Buf[fBuffer.Run] = #10 then inc(fBuffer.Run);
            inc(fBuffer.LineNumber);
            fBuffer.LinePos := fBuffer.Run;
          end;
          else
            inc(fBuffer.Run);
        end;
    end;
    '.':
    begin
      inc(fBuffer.Run);
      fTokenID := TptTokenKind.ptSquareOpen;
    end;
    else
      fTokenID := TptTokenKind.ptRoundOpen;
  end;
  case fTokenID of
    TptTokenKind.ptAnsiComment:
    begin
      if assigned(OnComment) then
      begin
        var CommentText := fBuffer.Buf.Substring(BeginRun,  fBuffer.Run - BeginRun - 2);
        DoOnComment(CommentText);
      end;
    end;
    TptTokenKind.ptCompDirect:
    begin
      if assigned(OnCompDirect) then
        OnCompDirect(Self);
    end;
    TptTokenKind.ptDefineDirect:
    begin
      if assigned(OnDefineDirect) then
        OnDefineDirect(Self);
    end;
    TptTokenKind.ptElseDirect:
    begin
      if assigned(OnElseDirect) then
        OnElseDirect(Self);
    end;
    TptTokenKind.ptEndIfDirect:
    begin
      if assigned(OnEndIfDirect) then
        OnEndIfDirect(Self);
    end;
    TptTokenKind.ptIfDefDirect:
    begin
      if assigned(OnIfDefDirect) then
        OnIfDefDirect(Self);
    end;
    TptTokenKind.ptIfNDefDirect:
    begin
      if assigned(OnIfNDefDirect) then
        OnIfNDefDirect(Self);
    end;
    TptTokenKind.ptIfOptDirect:
    begin
      if assigned(OnIfOptDirect) then
        OnIfOptDirect(Self);
    end;
    TptTokenKind.ptIncludeDirect:
    begin
      if assigned(fIncludeHandler) then
        IncludeFile;
    end;
    TptTokenKind.ptResourceDirect:
    begin
      if assigned(OnResourceDirect) then
        OnResourceDirect(Self);
    end;
    TptTokenKind.ptScopedEnumsDirect:
    begin
      UpdateScopedEnums;
    end;
    TptTokenKind.ptUndefDirect:
    begin
      if assigned(OnUnDefDirect) then
        OnUnDefDirect(Self);
    end;
  end;
end;

method TmwBasePasLex.SemiColonProc;
begin
  inc(fBuffer.Run);
  fTokenID := TptTokenKind.ptSemiColon;
end;

method TmwBasePasLex.SlashProc;
var
BeginRun: Integer;
CommentText: String;
begin
  case fBuffer.Buf[fBuffer.Run + 1] of
    '/':
    begin
      inc(fBuffer.Run, 2);

      BeginRun := fBuffer.Run;

      fTokenID := TptTokenKind.ptSlashesComment;
      while fBuffer.Buf[fBuffer.Run] <> #0 do
      begin
        case fBuffer.Buf[fBuffer.Run] of
          #10, #13: Break;
        end;
        inc(fBuffer.Run);
      end;

      if assigned(OnComment) then
      begin
        CommentText := fBuffer.Buf.Substring(BeginRun,  fBuffer.Run - BeginRun);
        DoOnComment(CommentText);
      end;
    end;
    else
      begin
        inc(fBuffer.Run);
        fTokenID := TptTokenKind.ptSlash;
      end;
  end;
end;

method TmwBasePasLex.SpaceProc;
begin
  inc(fBuffer.Run);
  fTokenID := TptTokenKind.ptSpace;
// [#1..#9, #11, #12, #14..#32]

  while fBuffer.Buf[fBuffer.Run] in [#1..#9, #11, #12, #14..#32] do
    inc(fBuffer.Run);
end;

method TmwBasePasLex.SquareCloseProc;
begin
  inc(fBuffer.Run);
  fTokenID := TptTokenKind.ptSquareClose;
end;

method TmwBasePasLex.SquareOpenProc;
begin
  inc(fBuffer.Run);
  fTokenID := TptTokenKind.ptSquareOpen;
end;

method TmwBasePasLex.StarProc;
begin
  inc(fBuffer.Run);
  fTokenID := TptTokenKind.ptStar;
end;

method TmwBasePasLex.StringProc;
begin
  fTokenID := TptTokenKind.ptStringConst;
  repeat
    inc(fBuffer.Run);
    case fBuffer.Buf[fBuffer.Run] of
      #0, #10, #13:
      begin
        if assigned(OnMessage) then
          OnMessage(Self, TMessageEventType.meError, 'Unterminated string', PosXY.X, PosXY.Y);
        Break;
      end;
      #39:
      begin
        while (fBuffer.Buf[fBuffer.Run] = #39) and (fBuffer.Buf[fBuffer.Run + 1] = #39) do
        begin
          inc(fBuffer.Run, 2);
        end;
      end;
    end;
    until fBuffer.Buf[fBuffer.Run] = #39;
  if fBuffer.Buf[fBuffer.Run] = #39 then
  begin
    inc(fBuffer.Run);
    if TokenLen = 3 then
    begin
      fTokenID := TptTokenKind.ptAsciiChar;
    end;
  end;
end;

method TmwBasePasLex.SymbolProc;
begin
  inc(fBuffer.Run);
  fTokenID := TptTokenKind.ptSymbol;
end;

method TmwBasePasLex.UnknownProc;
begin
  inc(fBuffer.Run);
  fTokenID := TptTokenKind.ptUnknown;
  if assigned(OnMessage) then
    OnMessage(Self, TMessageEventType.meError, 'Unknown Character', PosXY.X, PosXY.Y);
end;

method TmwBasePasLex.Next;
begin
  fExID := TptTokenKind.ptUnknown;
  fTokenPos := fBuffer.Run;
  case fCommentState of
    TCommentState.csNo: DoProcTable(fBuffer.Buf[fBuffer.Run]);
    TCommentState.csBor: BorProc;
    TCommentState.csAnsi: AnsiProc;
  end;
end;

method TmwBasePasLex.GetIsJunk: Boolean;
begin
  Result := fTokenID.IsJunk or (fUseDefines and (fDefineStack > 0) and (TokenID <> TptTokenKind.ptNull));
end;

method TmwBasePasLex.GetIsJunkAssembly: Boolean;
begin
  Result := not(fTokenID in [ TptTokenKind.ptCRLF]) and (
    fTokenID.IsJunk or (fUseDefines and (fDefineStack > 0) and (TokenID <> TptTokenKind.ptNull))
    );
end;

method TmwBasePasLex.GetIsSpace: Boolean;
begin
  Result := fTokenID in [TptTokenKind.ptCRLF, TptTokenKind.ptSpace];
end;

method TmwBasePasLex.GetToken: not nullable string;
begin
  Result := fBuffer.Buf.Substring(fTokenPos, TokenLen);
end;

method TmwBasePasLex.GetTokenLen: Integer;
begin
  Result := fBuffer.Run - fTokenPos;
end;

method TmwBasePasLex.NextNoJunk;
begin
  repeat
    Next;
    until not IsJunk;
end;

method TmwBasePasLex.NextNoJunkAssembly;
begin
  repeat
    Next
    until not IsJunkAssembly;
end;
method TmwBasePasLex.NextNoSpace;
begin
  repeat
    Next;
    until not IsSpace;
end;

method TmwBasePasLex.FirstInLine: Boolean;
var
RunBack: Integer;
begin
  Result := True;
  if fTokenPos = 0 then Exit;
  RunBack := fTokenPos;
  dec(RunBack);
//  [#1..#9, #11, #12, #14..#32]

  while fBuffer.Buf[RunBack] in [#1..#9, #11, #12, #14..#32] do
    dec(RunBack);
  if RunBack = 0 then Exit;
  case fBuffer.Buf[RunBack] of
    #10, #13: Exit;
    else
      begin
        Result := False;
        Exit;
      end;
  end;
end;

method TmwBasePasLex.GetCompilerDirective: not nullable string;
var
DirectLen: Integer;
begin
  result := '';
  if TokenID <> TptTokenKind.ptCompDirect then
    Result := ''
  else
    case fBuffer.Buf[fTokenPos] of
      '(':
      begin
        DirectLen := fBuffer.Run - fTokenPos - 4;
        Result := fBuffer.Buf.Substring(fTokenPos + 2, DirectLen).ToUpper;
      end;
      '{':
      begin
        DirectLen := fBuffer.Run - fTokenPos - 2;
        Result := fBuffer.Buf.Substring(fTokenPos + 1, DirectLen).ToUpper;
      end;
    end;
end;

method TmwBasePasLex.GetDirectiveKind: TptTokenKind;
var
TempPos: Integer;
begin
  case fBuffer.Buf[fTokenPos] of
    '(': fBuffer.Run := fTokenPos + 3;
    '{': fBuffer.Run := fTokenPos + 2;
  end;
  fDirectiveParamOrigin := fTokenPos;
  TempPos := fTokenPos;
  fTokenPos := fBuffer.Run;
  fExID:= TptTokenKind.ptCompDirect; //Always register the fact that we are in a directive.
  case KeyHash of
    9:
    if KeyComp('I') and (not (fBuffer.Buf[fBuffer.Run] in ['+', '-'])) then
      Result := TptTokenKind.ptIncludeDirect else
      Result := TptTokenKind.ptCompDirect;
    15:
    if KeyComp('IF') then
      Result := TptTokenKind.ptIfDirect else
      Result := TptTokenKind.ptCompDirect;
    18:
    if KeyComp('R') then
    begin
      if not (fBuffer.Buf[fBuffer.Run] in ['+', '-']) then
        Result := TptTokenKind.ptResourceDirect else Result := TptTokenKind.ptCompDirect;
    end else Result := TptTokenKind.ptCompDirect;
    30:
    if KeyComp('IFDEF') then
      Result := TptTokenKind.ptIfDefDirect else
      Result := TptTokenKind.ptCompDirect;
    38:
    if KeyComp('ENDIF') then
      Result := TptTokenKind.ptEndIfDirect else
      if KeyComp('IFEND') then
        Result := TptTokenKind.ptIfEndDirect else
        Result := TptTokenKind.ptCompDirect;
    41:
    if KeyComp('ELSE') then
      Result := TptTokenKind.ptElseDirect else
      Result := TptTokenKind.ptCompDirect;
    43:
    if KeyComp('DEFINE') then
      Result := TptTokenKind.ptDefineDirect else
      Result := TptTokenKind.ptCompDirect;
    44:
    if KeyComp('IFNDEF') then
      Result := TptTokenKind.ptIfNDefDirect else
      Result := TptTokenKind.ptCompDirect;
    50:
    if KeyComp('UNDEF') then
      Result := TptTokenKind.ptUndefDirect else
      Result := TptTokenKind.ptCompDirect;
    56:
    if KeyComp('ELSEIF') then
      Result := TptTokenKind.ptElseIfDirect else
      Result := TptTokenKind.ptCompDirect;
    66:
    if KeyComp('IFOPT') then
      Result := TptTokenKind.ptIfOptDirect else
      Result := TptTokenKind.ptCompDirect;
    68:
    if KeyComp('INCLUDE') then
      Result := TptTokenKind.ptIncludeDirect else
      Result := TptTokenKind.ptCompDirect;
    104:
    if KeyComp('Resource') then
      Result := TptTokenKind.ptResourceDirect else
      Result := TptTokenKind.ptCompDirect;
    134:
    if KeyComp('SCOPEDENUMS') then
      Result := TptTokenKind.ptScopedEnumsDirect else
      Result := TptTokenKind.ptCompDirect;
    else Result := TptTokenKind.ptCompDirect;
  end;
  fTokenPos := TempPos;
  dec(fBuffer.Run);
end;

method TmwBasePasLex.GetDirectiveParam: not nullable string;
var
EndPos: Integer;
ParamLen: Integer;
begin
  case fBuffer.Buf[fTokenPos] of
    '(':
    begin
      fTempRun := fTokenPos + 3;
      EndPos := fBuffer.Run - 2;
    end;
    '{':
    begin
      fTempRun := fTokenPos + 2;
      EndPos := fBuffer.Run - 1;
    end;
    else
      EndPos := 0;
  end;
  while IsIdentifiers(fBuffer.Buf[fTempRun]) do
    inc(fTempRun);
  while (fBuffer.Buf[fTempRun] in ['+', ',', '-']) do
  begin
    inc(fTempRun);
    while IsIdentifiers(fBuffer.Buf[fTempRun]) do
      inc(fTempRun);
    if (fBuffer.Buf[fTempRun - 1] in ['+', ',', '-']) and (fBuffer.Buf[fTempRun] = ' ')
      then inc(fTempRun);
  end;
  if fBuffer.Buf[fTempRun] = ' ' then inc(fTempRun);
  ParamLen := EndPos - fTempRun;
  Result:= fBuffer.Buf.Substring(fTempRun, ParamLen).ToUpper;
end;

method TmwBasePasLex.GetFileName: not nullable string;
begin
  Result := fBuffer.FileName;
end;

method TmwBasePasLex.GetIncludeFileNameFromToken(const IncludeToken: not nullable string): not nullable string;
var
FileNameStartPos, CurrentPos: Integer;
TrimmedToken: String;
begin
  TrimmedToken := IncludeToken.Trim;
  CurrentPos := 1;
  while TrimmedToken[CurrentPos] > #32 do
    inc(CurrentPos);
  while TrimmedToken[CurrentPos] <= #32 do
    inc(CurrentPos);
  FileNameStartPos := CurrentPos;
  while (TrimmedToken[CurrentPos] > #32) and (TrimmedToken[CurrentPos] <> '}')  do
    inc(CurrentPos);

  Result := TrimmedToken.Substring( FileNameStartPos, CurrentPos - FileNameStartPos);
end;

method TmwBasePasLex.IncludeFile;
var
IncludeFileName, IncludeDirective, Content: not nullable String;
NewBuffer: TBufferRec;
begin
  IncludeDirective := Token;
  IncludeFileName := GetIncludeFileNameFromToken(IncludeDirective);
  Content := fIncludeHandler.GetIncludeFileContent(IncludeFileName) + #13#10#0;

  NewBuffer := New TBufferRec();
  NewBuffer.SharedBuffer := False;
  NewBuffer.Next := fBuffer;
  NewBuffer.LineNumber := 0;
  NewBuffer.LinePos := 0;
  NewBuffer.Run := 0;
  NewBuffer.FileName := IncludeFileName;

  NewBuffer.Buf := Content;


  fBuffer := NewBuffer;

  Next;
end;

method TmwBasePasLex.InitLexer;
begin
  fCommentState :=  TCommentState.csNo;
  fBuffer.LineNumber := 0;
  fBuffer.LinePos := 0;
end;

method TmwBasePasLex.InitFrom(ALexer: TmwBasePasLex);
begin
  SetSharedBuffer(ALexer.fBuffer);
  fCommentState := ALexer.fCommentState;
  fScopedEnums := ALexer.ScopedEnums;
  fBuffer.Run := ALexer.RunPos;
  fTokenID := ALexer.TokenID;
  fExID := ALexer.ExID;
  CloneDefinesFrom(ALexer);
  OnParseCompilerDirectiveEvent := ALexer.OnParseCompilerDirectiveEvent;
end;

method TmwBasePasLex.InitDefinesDefinedByCompiler;
begin
  for each s in DelphiDefines.getDefinesFor(fCompiler) do
    AddDefine(s)
end;

method TmwBasePasLex.GetStringContent: not nullable string;
begin
  if TokenID <> TptTokenKind.ptStringConst then
    Result := ''
  else
  begin
    var TempString := Token;
    var sEnd := length(TempString);
    if TempString[sEnd] <> #39 then inc(sEnd);
    Result :=  TempString.Substring( 2, sEnd - 2);

  end;
end;

method TmwBasePasLex.GetIsOrdIdent: Boolean;
begin
  if fTokenID =TptTokenKind.ptIdentifier then
    Result := fExID in [TptTokenKind.ptBoolean, TptTokenKind.ptByte, TptTokenKind.ptChar, TptTokenKind.ptDWORD, TptTokenKind.ptInt64, TptTokenKind.ptInteger,
      TptTokenKind.ptLongint, TptTokenKind.ptLongword, TptTokenKind.ptPChar, TptTokenKind.ptShortint, TptTokenKind.ptSmallint, TptTokenKind.ptWideChar, TptTokenKind.ptWord]
  else
    Result := False;
end;

method TmwBasePasLex.GetIsOrdinalType: Boolean;
begin
  Result := GetIsOrdIdent or (fTokenID in [TptTokenKind.ptAsciiChar, TptTokenKind.ptIntegerConst]);
end;

method TmwBasePasLex.GetIsRealType: Boolean;
begin
  if fTokenID =TptTokenKind.ptIdentifier then
    Result := fExID in [TptTokenKind.ptComp, TptTokenKind.ptCurrency, TptTokenKind.ptDouble, TptTokenKind.ptExtended, TptTokenKind.ptReal, TptTokenKind.ptReal48, TptTokenKind.ptSingle]
  else
    Result := False;
end;

method TmwBasePasLex.GetIsStringType: Boolean;
begin
  if fTokenID =TptTokenKind.ptIdentifier then
    Result := fExID in [TptTokenKind.ptAnsiString, TptTokenKind.ptWideString]
  else
    Result := fTokenID in [TptTokenKind.ptString, TptTokenKind.ptStringConst];
end;

method TmwBasePasLex.GetIsVariantType: Boolean;
begin
  if fTokenID =TptTokenKind.ptIdentifier then
    Result := fExID in [TptTokenKind.ptOleVariant, TptTokenKind.ptVariant]
  else
    Result := False;
end;

method TmwBasePasLex.GetOrigin: not nullable string;
begin
  Result := fBuffer.Buf;
end;

method TmwBasePasLex.GetIsAddOperator: Boolean;
begin
  Result := fTokenID in [TptTokenKind.ptMinus, TptTokenKind.ptOr, TptTokenKind.ptPlus, TptTokenKind.ptXor];
end;

method TmwBasePasLex.GetIsMulOperator: Boolean;
begin
  Result := fTokenID in [TptTokenKind.ptAnd, TptTokenKind.ptAs, TptTokenKind.ptDiv, TptTokenKind.ptMod, TptTokenKind.ptShl, TptTokenKind.ptShr, TptTokenKind.ptSlash, TptTokenKind.ptStar];
end;

method TmwBasePasLex.GetIsRelativeOperator: Boolean;
begin
  Result := fTokenID in [TptTokenKind.ptAs, TptTokenKind.ptEqual, TptTokenKind.ptGreater, TptTokenKind.ptGreaterEqual, TptTokenKind.ptLower, TptTokenKind.ptLowerEqual,
    TptTokenKind.ptIn, TptTokenKind.ptIs, TptTokenKind.ptNotEqual];
end;

method TmwBasePasLex.GetIsCompilerDirective: Boolean;
begin
  Result := fTokenID in [TptTokenKind.ptCompDirect, TptTokenKind.ptDefineDirect, TptTokenKind.ptElseDirect,
    TptTokenKind.ptEndIfDirect, TptTokenKind.ptIfDefDirect, TptTokenKind.ptIfNDefDirect, TptTokenKind.ptIfOptDirect,
    TptTokenKind.ptIncludeDirect, TptTokenKind.ptResourceDirect, TptTokenKind.ptScopedEnumsDirect, TptTokenKind.ptUndefDirect];
end;

method TmwBasePasLex.GetGenID: TptTokenKind;
begin
  Result := fTokenID;
  if fTokenID =TptTokenKind.ptIdentifier then
    if fExID <> TptTokenKind.ptUnknown then Result := fExID;
end;

{ TmwPasLex }

constructor TmwPasLex(const aCompiler : DelphiCompiler);
begin
  inherited constructor(aCompiler);
  fAheadLex := new TmwBasePasLex(aCompiler);
end;

method TmwPasLex.AheadNext;
begin
  fAheadLex.NextNoJunk;
end;

method TmwPasLex.GetAheadExID: TptTokenKind;
begin
  Result := fAheadLex.ExID;
end;

method TmwPasLex.GetAheadGenID: TptTokenKind;
begin
  Result := fAheadLex.GenID;
end;

method TmwPasLex.GetAheadToken: not nullable string;
begin
  Result := fAheadLex.Token;
end;

method TmwPasLex.GetAheadTokenID: TptTokenKind;
begin
  Result := fAheadLex.TokenID;
end;

method TmwPasLex.InitAhead;
begin
  fAheadLex.fCommentState := fCommentState;
  fAheadLex.CloneDefinesFrom(Self);
  fAheadLex.SetSharedBuffer(Buffer);
  fAheadLex.OnParseCompilerDirectiveEvent := OnParseCompilerDirectiveEvent;
  while fAheadLex.IsJunk do
    fAheadLex.Next;
end;

method TmwPasLex.SetOrigin(const NewValue: not nullable string);
begin
  inherited SetOrigin(NewValue);
  fAheadLex.SetSharedBuffer(Buffer);
end;

method TmwBasePasLex.Func86: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('Varargs') then fExID := TptTokenKind.ptVarargs;
end;

method TmwBasePasLex.StringDQProc;
begin
  if not fAsmCode then
  begin
    SymbolProc;
    Exit;
  end;
  fTokenID := TptTokenKind.ptStringDQConst;
  repeat
    inc(fBuffer.Run);
    case fBuffer.Buf[fBuffer.Run] of
      #0, #10, #13:
      begin
        if assigned(OnMessage) then
          OnMessage(Self, TMessageEventType.meError, 'Unterminated string', PosXY.X, PosXY.Y);
        Break;
      end;
      '\':
      begin
        inc(fBuffer.Run);
        //[#32..#127]
        if (fBuffer.Buf[fBuffer.Run] in [#32..#127]) then inc(fBuffer.Run);
      end;
    end;
    until fBuffer.Buf[fBuffer.Run] = '"';
  if fBuffer.Buf[fBuffer.Run] = '"' then
    inc(fBuffer.Run);
end;

method TmwBasePasLex.AmpersandOpProc;
begin
  fTokenID := TptTokenKind.ptAmpersand;
  inc(fBuffer.Run);
  //   ['a'..'z', 'A'..'Z','0'..'9', '_', '&']
  while (fBuffer.Buf[fBuffer.Run] in ['a'..'z', 'A'..'Z','0'..'9', '_', '&']) do
    inc(fBuffer.Run);
  fTokenID :=TptTokenKind.ptIdentifier;
end;

method TmwBasePasLex.UpdateScopedEnums;
begin
  fScopedEnums := DirectiveParam.EqualsIgnoringCase('ON');
end;

class constructor TmwBasePasLex();
begin
  MakeIdentTable;
end;


end.