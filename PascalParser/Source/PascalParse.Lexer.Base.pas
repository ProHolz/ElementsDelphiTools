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
namespace PascalParser;
interface

type
  // Blocks
  TDirectiveEvent =  public block(Sender: TmwBasePasLex);// of object;
  TCommentEvent = public block(Sender: Object; const Text: not nullable String);// of object;



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


  TmwBasePasLex = public class(Object)
  unit or protected
    FCommentState: TCommentState;
    method CloneDefinesFrom(ALexer: TmwBasePasLex);
    method SetSharedBuffer(SharedBuffer: TBufferRec);


  private // Class

    class var Identifiers: array[#0..#127] of Boolean;
    class var mHashTable: array[#0..#127] of Integer;
    class method MakeIdentTable;
  private
    type proc = block();
    type tokenfunc = block() : TptTokenKind;
    type Lee =  enum  (None, &And, &Or);



    FProcTable: array[#0..#127] of proc;
    FBuffer: TBufferRec;

    FTempRun: Integer;

    FIdentFuncTable: array[0..191] of tokenfunc;
    FTokenPos: Integer;
    FTokenID: TptTokenKind;
    FExID: TptTokenKind;

    FDirectiveParamOrigin: Integer;
    FAsmCode: Boolean;
    FDefines: List<String>;
    FDefineStack: Integer;
    FTopDefineRec: Stack<TDefineRec>;
    FUseDefines: Boolean;
    FScopedEnums: Boolean;
    FIncludeHandler: IIncludeHandler;
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
    class Constructor ();

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

    property Buffer: TBufferRec read FBuffer;
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
    property TokenPos: Integer read FTokenPos;
    property TokenID: TptTokenKind read FTokenID;
    property ExID: TptTokenKind read FExID;
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

    property AsmCode: Boolean read FAsmCode write FAsmCode;
    property DirectiveParamOrigin: Integer read FDirectiveParamOrigin;
    property UseDefines: Boolean read FUseDefines write FUseDefines;
    property ScopedEnums: Boolean read FScopedEnums;
    property IncludeHandler: IIncludeHandler read FIncludeHandler write FIncludeHandler;
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


  end;

  TmwPasLex = public class(TmwBasePasLex)
  private
    FAheadLex: TmwBasePasLex;
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
    property AheadLex: TmwBasePasLex read FAheadLex;
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
      var RunAhead := FBuffer.Run;
      while (FBuffer.Buf[RunAhead] > #0) and (FBuffer.Buf[RunAhead] < #33) do
        inc(RunAhead);
      Result := FBuffer.Buf[RunAhead];
    end;

    method TmwBasePasLex.ClearDefines;
    begin
      FDefineStack := 0;
      FDefines := new List<String>();
      FTopDefineRec:= new Stack<TDefineRec>();
    end;

    method TmwBasePasLex.CloneDefinesFrom(ALexer: TmwBasePasLex);
    begin
      ClearDefines;
      if (ALexer.FDefines <> nil) and (ALexer.FDefines.Count > 0) then
        FDefines :=  new List<String>(ALexer.FDefines:ToArray)
      else
        FDefines :=  new List<String>();
      FDefineStack := ALexer.FDefineStack;
 // {$HINT RETHINK AND TEST}
 {$if not TOFFEE }
      FTopDefineRec := ALexer.FTopDefineRec:UniqueCopy;
      {$ENDIF}
    end;

    method TmwBasePasLex.GetPosXY: TTokenPoint;
    begin
      Result.Y := FBuffer.LineNumber + 1;
      Result.X := FTokenPos - FBuffer.LinePos + 1;
    end;

    method TmwBasePasLex.GetRunPos: Integer;
    begin
      Result := FBuffer.Run;
    end;

    method TmwBasePasLex.InitIdent;
    var
    I: Integer;
    begin
      for I := 0 to 191 do
        case I of
          9: FIdentFuncTable[I] := @Func9;
          15: FIdentFuncTable[I] := @Func15;
          19: FIdentFuncTable[I] := @Func19;
          20: FIdentFuncTable[I] := @Func20;
          21: FIdentFuncTable[I] := @Func21;
          23: FIdentFuncTable[I] := @Func23;
          25: FIdentFuncTable[I] := @Func25;
          27: FIdentFuncTable[I] := @Func27;
          28: FIdentFuncTable[I] := @Func28;
          29: FIdentFuncTable[I] := @Func29;
          30: FIdentFuncTable[I] := @Func30;
          32: FIdentFuncTable[I] := @Func32;
          33: FIdentFuncTable[I] := @Func33;
          35: FIdentFuncTable[I] := @Func35;
          36: FIdentFuncTable[I] := @Func36;
          37: FIdentFuncTable[I] := @Func37;
          38: FIdentFuncTable[I] := @Func38;
          39: FIdentFuncTable[I] := @Func39;
          40: FIdentFuncTable[I] := @Func40;
          41: FIdentFuncTable[I] := @Func41;
          42: FIdentFuncTable[I] := @Func42;
          43: FIdentFuncTable[I] := @Func43;
          44: FIdentFuncTable[I] := @Func44;
          45: FIdentFuncTable[I] := @Func45;
          46: FIdentFuncTable[I] := @Func46;
          47: FIdentFuncTable[I] := @Func47;
          49: FIdentFuncTable[I] := @Func49;
          52: FIdentFuncTable[I] := @Func52;
          54: FIdentFuncTable[I] := @Func54;
          55: FIdentFuncTable[I] := @Func55;
          56: FIdentFuncTable[I] := @Func56;
          57: FIdentFuncTable[I] := @Func57;
          58: FIdentFuncTable[I] := @Func58;
          59: FIdentFuncTable[I] := @Func59;
          60: FIdentFuncTable[I] := @Func60;
          61: FIdentFuncTable[I] := @Func61;
          62: FIdentFuncTable[I] := @Func62;
          63: FIdentFuncTable[I] := @Func63;
          64: FIdentFuncTable[I] := @Func64;
          65: FIdentFuncTable[I] := @Func65;
          66: FIdentFuncTable[I] := @Func66;
          69: FIdentFuncTable[I] := @Func69;
          71: FIdentFuncTable[I] := @Func71;
          72: FIdentFuncTable[I] := @Func72;
          73: FIdentFuncTable[I] := @Func73;
          75: FIdentFuncTable[I] := @Func75;
          76: FIdentFuncTable[I] := @Func76;
          78: FIdentFuncTable[I] := @Func78;
          79: FIdentFuncTable[I] := @Func79;
          81: FIdentFuncTable[I] := @Func81;
          84: FIdentFuncTable[I] := @Func84;
          85: FIdentFuncTable[I] := @Func85;
          86: FIdentFuncTable[I] := @Func86;
          87: FIdentFuncTable[I] := @Func87;
          88: FIdentFuncTable[I] := @Func88;
          89: FIdentFuncTable[I] := @Func89;
          91: FIdentFuncTable[I] := @Func91;
          92: FIdentFuncTable[I] := @Func92;
          94: FIdentFuncTable[I] := @Func94;
          95: FIdentFuncTable[I] := @Func95;
          96: FIdentFuncTable[I] := @Func96;
          97: FIdentFuncTable[I] := @Func97;
          98: FIdentFuncTable[I] := @Func98;
          99: FIdentFuncTable[I] := @Func99;
          100: FIdentFuncTable[I] := @Func100;
          101: FIdentFuncTable[I] := @Func101;
          102: FIdentFuncTable[I] := @Func102;
          103: FIdentFuncTable[I] := @Func103;
          104: FIdentFuncTable[I] := @Func104;
          105: FIdentFuncTable[I] := @Func105;
          106: FIdentFuncTable[I] := @Func106;
          107: FIdentFuncTable[I] := @Func107;
          108: FIdentFuncTable[I] := @Func108;
          112: FIdentFuncTable[I] := @Func112;
          117: FIdentFuncTable[I] := @Func117;
          123: FIdentFuncTable[I] := @Func123;
          126: FIdentFuncTable[I] := @Func126;
          127: FIdentFuncTable[I] := @Func127;
          128: FIdentFuncTable[I] := @Func128;
          129: FIdentFuncTable[I] := @Func129;
          130: FIdentFuncTable[I] := @Func130;
          132: FIdentFuncTable[I] := @Func132;
          133: FIdentFuncTable[I] := @Func133;
          136: FIdentFuncTable[I] := @Func136;
          141: FIdentFuncTable[I] := @Func141;
          142: FIdentFuncTable[I] := @Func142;
          143: FIdentFuncTable[I] := @Func143;
          166: FIdentFuncTable[I] := @Func166;
          167: FIdentFuncTable[I] := @Func167;
          168: FIdentFuncTable[I] := @Func168;
          191: FIdentFuncTable[I] := @Func191;
          else
            FIdentFuncTable[I] := @AltFunc;
        end;
    end;

    method TmwBasePasLex.KeyHash: Integer;
    begin
      Result := 0;
      while IsIdentifiers(FBuffer.Buf[FBuffer.Run]) do
      begin
        inc(Result, HashValue(FBuffer.Buf[FBuffer.Run]));
        inc(FBuffer.Run);
      end;
    end;

    method TmwBasePasLex.KeyComp(const aKey: not nullable string): Boolean;
    var
    I: Integer;
    Temp: Integer;
    begin
      if length(aKey) = TokenLen then
      begin
        Temp := FTokenPos;
        Result := True;
        for I := 0 to TokenLen-1 do
          begin
          if mHashTable[FBuffer.Buf[Temp]] <> mHashTable[aKey[I]] then
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
        FExID := TptTokenKind.ptAdd;
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
        if KeyComp('At') then FExID := TptTokenKind.ptAt;
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
      if KeyComp('Far') then FExID := TptTokenKind.ptFar;
    end;

    method TmwBasePasLex.Func27: TptTokenKind;
    begin
      Result :=TptTokenKind.ptIdentifier;
      if KeyComp('Cdecl') then FExID := TptTokenKind.ptCdecl;
    end;

    method TmwBasePasLex.Func28: TptTokenKind;
    begin
      Result :=TptTokenKind.ptIdentifier;
      if KeyComp('Read') then FExID := TptTokenKind.ptRead else
        if KeyComp('Case') then Result := TptTokenKind.ptCase else
          if KeyComp('Is') then Result := TptTokenKind.ptIs;
    end;

    method TmwBasePasLex.Func29: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('On') then FExID := TptTokenKind.ptOn;
    end;

    method TmwBasePasLex.Func30: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Char') then FExID := TptTokenKind.ptChar;
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
  else if KeyComp('Name') then FExID := TptTokenKind.ptName
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
      if KeyComp('Real') then FExID := TptTokenKind.ptReal else
        if KeyComp('Real48') then FExID := TptTokenKind.ptReal48;
    end;

    method TmwBasePasLex.Func37: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Begin') then Result := TptTokenKind.ptBegin else
        if KeyComp('Break') then FExID := TptTokenKind.ptBreak;
    end;

    method TmwBasePasLex.Func38: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Near') then FExID := TptTokenKind.ptNear;
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
          if KeyComp('Halt') then FExID := TptTokenKind.ptHalt;
    end;

    method TmwBasePasLex.Func42: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Final') then
        FExID := TptTokenKind.ptFinal; //TODO: Is this supposed to be an ExID?
    end;

    method TmwBasePasLex.Func43: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Int64') then FExID := TptTokenKind.ptInt64
      else if KeyComp('local') then FExID := TptTokenKind.ptLocal;
    end;

    method TmwBasePasLex.Func44: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Set') then Result := TptTokenKind.ptSet else
        if KeyComp('Package') then FExID := TptTokenKind.ptPackage;
    end;

    method TmwBasePasLex.Func45: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Shr') then Result := TptTokenKind.ptShr;
    end;

    method TmwBasePasLex.Func46: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('PChar') then FExID := TptTokenKind.ptPChar else
        if KeyComp('Sealed') then Result := TptTokenKind.ptSealed;
    end;

    method TmwBasePasLex.Func47: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Then') then Result := TptTokenKind.ptThen else
        if KeyComp('Comp') then FExID := TptTokenKind.ptComp;
    end;

    method TmwBasePasLex.Func49: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Not') then Result := TptTokenKind.ptNot;
    end;

    method TmwBasePasLex.Func52: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Byte') then FExID := TptTokenKind.ptByte else
        if KeyComp('Raise') then Result := TptTokenKind.ptRaise else
          if KeyComp('Pascal') then FExID := TptTokenKind.ptPascal;
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
      if KeyComp('Index') then FExID := TptTokenKind.ptIndex else
        if KeyComp('Out') then FExID := TptTokenKind.ptOut else // bug in Delphi's documentation: OUT is a directive
          if KeyComp('Abort') then FExID := TptTokenKind.ptAbort else
            if KeyComp('Delayed') then FExID := TptTokenKind.ptDelayed;
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
      if KeyComp('Exit') then FExID := TptTokenKind.ptExit;
    end;

    method TmwBasePasLex.Func59: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Safecall') then FExID := TptTokenKind.ptSafeCall else
        if KeyComp('Double') then FExID := TptTokenKind.ptDouble;
    end;

    method TmwBasePasLex.Func60: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('With') then Result := TptTokenKind.ptWith else
        if KeyComp('Word') then FExID := TptTokenKind.ptWord;
    end;

    method TmwBasePasLex.Func61: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Dispid') then FExID := TptTokenKind.ptDispid;
    end;

    method TmwBasePasLex.Func62: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Cardinal') then FExID := TptTokenKind.ptCardinal;
    end;

    method TmwBasePasLex.Func63: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      case FBuffer.Buf[FTokenPos] of
        'P', 'p': if KeyComp('Public') then FExID := TptTokenKind.ptPublic;
        'A', 'a': if KeyComp('Array') then Result := TptTokenKind.ptArray;
        'T', 't': if KeyComp('Try') then Result := TptTokenKind.ptTry;
        'R', 'r': if KeyComp('Record') then Result := TptTokenKind.ptRecord;
        'I', 'i': if KeyComp('Inline') then
        begin
          Result := TptTokenKind.ptInline;
          FExID := TptTokenKind.ptInline;
        end;
      end;
    end;

    method TmwBasePasLex.Func64: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      case FBuffer.Buf[FTokenPos] of
        'B', 'b': if KeyComp('Boolean') then FExID := TptTokenKind.ptBoolean;
        'D', 'd': if KeyComp('DWORD') then FExID := TptTokenKind.ptDWORD;
        'U', 'u': if KeyComp('Uses') then Result := TptTokenKind.ptUses else
          if KeyComp('Unit') then Result := TptTokenKind.ptUnit;
        'H', 'h': if KeyComp('Helper') then FExID := TptTokenKind.ptHelper;
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
      if KeyComp('Single') then FExID := TptTokenKind.ptSingle else
        if KeyComp('Type') then Result := TptTokenKind.ptType else
          if KeyComp('Unsafe') then Result := TptTokenKind.ptUnsafe;
    end;

    method TmwBasePasLex.Func69: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Default') then FExID := TptTokenKind.ptDefault else
        if KeyComp('Dynamic') then FExID := TptTokenKind.ptDynamic else
          if KeyComp('Message') then FExID := TptTokenKind.ptMessage;
    end;

    method TmwBasePasLex.Func71: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('WideChar') then FExID := TptTokenKind.ptWideChar else
        if KeyComp('Stdcall') then FExID := TptTokenKind.ptStdcall else
          if KeyComp('Const') then Result := TptTokenKind.ptConst;
    end;

    method TmwBasePasLex.Func72: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Static') then FExID := TptTokenKind.ptStatic;
    end;

    method TmwBasePasLex.Func73: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
  if KeyComp('Except') then Result := TptTokenKind.ptExcept else
  if KeyComp('AnsiChar') then FExID := TptTokenKind.ptAnsiChar;
    end;

    method TmwBasePasLex.Func75: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Write') then FExID := TptTokenKind.ptWrite;
    end;

    method TmwBasePasLex.Func76: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Until') then Result := TptTokenKind.ptUntil;
    end;

    method TmwBasePasLex.Func78: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Integer') then FExID := TptTokenKind.ptInteger else
        if KeyComp('Remove') then FExID := TptTokenKind.ptRemove;
    end;

    method TmwBasePasLex.Func79: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Finally') then Result := TptTokenKind.ptFinally else
        if KeyComp('Reference') then FExID := TptTokenKind.ptReference;
    end;

    method TmwBasePasLex.Func81: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Extended') then FExID := TptTokenKind.ptExtended else
        if KeyComp('Stored') then FExID := TptTokenKind.ptStored else
          if KeyComp('Interface') then Result := TptTokenKind.ptInterface else
            if KeyComp('Deprecated') then FExID := TptTokenKind.ptDeprecated;
    end;

    method TmwBasePasLex.Func84: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Abstract') then FExID := TptTokenKind.ptAbstract;
    end;

    method TmwBasePasLex.Func85: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Library') then Result := TptTokenKind.ptLibrary else
        if KeyComp('Forward') then FExID := TptTokenKind.ptForward else
          if KeyComp('Variant') then FExID := TptTokenKind.ptVariant;
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
      if KeyComp('Strict') then FExID := TptTokenKind.ptStrict;
    end;

    method TmwBasePasLex.Func91: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Downto') then Result := TptTokenKind.ptDownto else
        if KeyComp('Private') then FExID := TptTokenKind.ptPrivate else
          if KeyComp('Longint') then FExID := TptTokenKind.ptLongint;
    end;

    method TmwBasePasLex.Func92: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Inherited') then Result := TptTokenKind.ptInherited else
        if KeyComp('LongBool') then FExID := TptTokenKind.ptLongBool else
          if KeyComp('Overload') then FExID := TptTokenKind.ptOverload;
    end;

    method TmwBasePasLex.Func94: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Resident') then FExID := TptTokenKind.ptResident else
        if KeyComp('Readonly') then FExID := TptTokenKind.ptReadonly else
          if KeyComp('Assembler') then FExID := TptTokenKind.ptAssembler;
    end;

    method TmwBasePasLex.Func95: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Contains') then FExID := TptTokenKind.ptContains
      else if KeyComp('Absolute') then FExID := TptTokenKind.ptAbsolute
      else if KeyComp('Dependency') then FExID := TptTokenKind.ptDependency; //#240

    end;


    method TmwBasePasLex.Func96: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;

      if KeyComp('ByteBool') then FExID := TptTokenKind.ptByteBool else
        if KeyComp('Override') then FExID := TptTokenKind.ptOverride else
          if KeyComp('Published') then FExID := TptTokenKind.ptPublished;
    end;

    method TmwBasePasLex.Func97: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Threadvar') then Result := TptTokenKind.ptThreadvar;
    end;

    method TmwBasePasLex.Func98: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Export') then FExID := TptTokenKind.ptExport else
        if KeyComp('Nodefault') then FExID := TptTokenKind.ptNodefault;
    end;

    method TmwBasePasLex.Func99: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('External') then FExID := TptTokenKind.ptExternal;
    end;

    method TmwBasePasLex.Func100: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Automated') then FExID := TptTokenKind.ptAutomated else
        if KeyComp('Smallint') then FExID := TptTokenKind.ptSmallint;
    end;

    method TmwBasePasLex.Func101: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
  if KeyComp('Register') then FExID:= TptTokenKind.ptRegister
  else if KeyComp('Platform') then FExID:= TptTokenKind.ptPlatform
  else if KeyComp('Continue') then FExID:= TptTokenKind.ptContinue;
    end;

    method TmwBasePasLex.Func102: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Function') then Result := TptTokenKind.ptFunction;
    end;

    method TmwBasePasLex.Func103: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Virtual') then FExID := TptTokenKind.ptVirtual;
    end;

    method TmwBasePasLex.Func104: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('WordBool') then FExID := TptTokenKind.ptWordBool;
    end;

    method TmwBasePasLex.Func105: TptTokenKind;
    begin
      Result := TptTokenKind.ptIdentifier;
      if KeyComp('Procedure') then Result := TptTokenKind.ptProcedure;
    end;

    method TmwBasePasLex.Func106: TptTokenKind;
    begin
      Result :=TptTokenKind.ptIdentifier;
      if KeyComp('Protected') then FExID := TptTokenKind.ptProtected;
    end;

    method TmwBasePasLex.Func107: TptTokenKind;
    begin
      Result :=TptTokenKind.ptIdentifier;
      if KeyComp('Currency') then FExID := TptTokenKind.ptCurrency;
    end;

    method TmwBasePasLex.Func108: TptTokenKind;
    begin
      Result :=TptTokenKind.ptIdentifier;
      if KeyComp('Longword') then FExID := TptTokenKind.ptLongword else
        if KeyComp('Operator') then FExID := TptTokenKind.ptOperator;
    end;

    method TmwBasePasLex.Func112: TptTokenKind;
    begin
      Result :=TptTokenKind.ptIdentifier;
      if KeyComp('Requires') then FExID := TptTokenKind.ptRequires;
    end;

    method TmwBasePasLex.Func117: TptTokenKind;
    begin
      Result :=TptTokenKind.ptIdentifier;
  if KeyComp('Exports') then Result:= TptTokenKind.ptExports
  else if KeyComp('OleVariant') then FExID:= TptTokenKind.ptOleVariant;
    end;

    method TmwBasePasLex.Func123: TptTokenKind;
    begin
      Result :=TptTokenKind.ptIdentifier;
      if KeyComp('Shortint') then FExID := TptTokenKind.ptShortint;
    end;

    method TmwBasePasLex.Func126: TptTokenKind;
    begin
      Result :=TptTokenKind.ptIdentifier;
      if KeyComp('Implements') then FExID := TptTokenKind.ptImplements;
    end;

    method TmwBasePasLex.Func127: TptTokenKind;
    begin
      Result :=TptTokenKind.ptIdentifier;
      if KeyComp('Runerror') then FExID := TptTokenKind.ptRunError;
    end;

    method TmwBasePasLex.Func128: TptTokenKind;
    begin
      Result :=TptTokenKind.ptIdentifier;
      if KeyComp('WideString') then FExID := TptTokenKind.ptWideString;
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
      FExID := TptTokenKind.ptAnsiString;
      end;
    end;

      method TmwBasePasLex.Func132: TptTokenKind;
      begin
        result := TptTokenKind.ptIdentifier;
        if KeyComp('Reintroduce') then FExID := TptTokenKind.ptReintroduce;
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
      if KeyComp('Writeonly') then FExID := TptTokenKind.ptWriteonly;
    end;

    method TmwBasePasLex.Func142: TptTokenKind;
    begin
      Result :=TptTokenKind.ptIdentifier;
      if KeyComp('experimental') then FExID := TptTokenKind.ptExperimental;
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
      if KeyComp('ShortString') then FExID := TptTokenKind.ptShortString;
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
  else if KeyComp('Stringresource') then FExID:= TptTokenKind.ptStringresource;
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
        Result := FIdentFuncTable[HashKey]()
      else
        Result :=TptTokenKind.ptIdentifier;
    end;

    method TmwBasePasLex.MakeMethodTables;
    var
    I: Char;
    begin
      for I := #0 to #127 do
        case I of
          #0: FProcTable[I] := @NullProc;
          #10: FProcTable[I] := @LFProc;
          #13: FProcTable[I] := @CRProc;
          #1..#9, #11, #12, #14..#32: FProcTable[I] := @SpaceProc;
          '#': FProcTable[I] := @AsciiCharProc;
          '$': FProcTable[I] := @IntegerProc;
          #39: FProcTable[I] := @StringProc;
          '0'..'9': FProcTable[I] := @NumberProc;
          'A'..'Z', 'a'..'z', '_': FProcTable[I] := @IdentProc;
          '{': FProcTable[I] := @BraceOpenProc;
          '}': FProcTable[I] := @BraceCloseProc;
          '!', '"', '%', '&', '('..'/', ':'..'@', '['..'^', '`', '~':
          begin
            case I of
              '(': FProcTable[I] := @RoundOpenProc;
              ')': FProcTable[I] := @RoundCloseProc;
              '*': FProcTable[I] := @StarProc;
              '+': FProcTable[I] := @PlusProc;
              ',': FProcTable[I] := @CommaProc;
              '-': FProcTable[I] := @MinusProc;
              '.': FProcTable[I] := @PointProc;
              '/': FProcTable[I] := @SlashProc;
              ':': FProcTable[I] := @ColonProc;
              ';': FProcTable[I] := @SemiColonProc;
              '<': FProcTable[I] := @LowerProc;
              '=': FProcTable[I] := @EqualProc;
              '>': FProcTable[I] := @GreaterProc;
              '@': FProcTable[I] := @AddressOpProc;
              '[': FProcTable[I] := @SquareOpenProc;
              ']': FProcTable[I] := @SquareCloseProc;
              '^': FProcTable[I] := @PointerSymbolProc;
              '"': FProcTable[I] := @StringDQProc;
              '&': FProcTable[I] := @AmpersandOpProc;
              else
                FProcTable[I] := @SymbolProc;
            end;
          end;
          else
            FProcTable[I] := @UnknownProc;
        end;
    end;

    constructor TmwBasePasLex.Create(const aCompiler : DelphiCompiler);

    begin
      inherited constructor() ;
      fCompiler := aCompiler;
      InitIdent;
      MakeMethodTables;
      FExID := TptTokenKind.ptUnknown;

      FUseDefines := true;
      FScopedEnums := False;
//  FTopDefineRec:= new Stack<TDefineRec>();
      ClearDefines;
      FBuffer := new TBufferRec();
       InitDefinesDefinedByCompiler;
    end;



    method TmwBasePasLex.DoOnComment(const CommentText: not nullable string);
    require
      assigned(OnComment);

      begin
        if not FUseDefines or (FDefineStack = 0) then
          OnComment(Self, CommentText);
      end;

      method TmwBasePasLex.DoProcTable(AChar: Char);
      begin
  {$IF DEBUG}
  var lShort := ord(AChar);
  if lShort < 127 then;

   {$ENDIF}

    if ord(AChar) <= 127 then
      FProcTable[AChar]()
    else
    begin
      IdentProc;
    end;
  end;

  method TmwBasePasLex.SetOrigin(const NewValue: not nullable string);
  begin
    FBuffer.Buf := NewValue+#0;
    InitLexer;
    Next;
  end;

  method TmwBasePasLex.SetRunPos(const Value: Integer);
  begin
    FBuffer.Run := Value;
    Next;
  end;

  method TmwBasePasLex.SetSharedBuffer(SharedBuffer: TBufferRec);
  begin
    while assigned(FBuffer.Next) do
      FBuffer := FBuffer.Next;

    if not FBuffer.SharedBuffer and assigned(FBuffer.Buf) then
      FBuffer.Buf := '';

    FBuffer.Buf := SharedBuffer.Buf;
    FBuffer.Run := SharedBuffer.Run;
    FBuffer.LineNumber := SharedBuffer.LineNumber;
    FBuffer.LinePos := SharedBuffer.LinePos;
    FBuffer.SharedBuffer := True;

    Next;
  end;

  method TmwBasePasLex.AddDefine(const ADefine: not nullable string);

  begin
    FDefines.Add(ADefine);
  end;

  method TmwBasePasLex.AddressOpProc;
  begin
    case FBuffer.Buf[FBuffer.Run + 1] of
      '@':
      begin
        FTokenID := TptTokenKind.ptDoubleAddressOp;
        inc(FBuffer.Run, 2);
    end;
      else
        begin
          FTokenID := TptTokenKind.ptAddressOp;
          inc(FBuffer.Run);
        end;
    end;
  end;

  method TmwBasePasLex.AsciiCharProc;
  begin
    FTokenID := TptTokenKind.ptAsciiChar;
    inc(FBuffer.Run);
    if FBuffer.Buf[FBuffer.Run] = '$' then
    begin
      inc(FBuffer.Run);
    // ['0'..'9', 'A'..'F', 'a'..'f']
      while (FBuffer.Buf[FBuffer.Run] in ['0'..'9', 'A'..'F', 'a'..'f']) do inc(FBuffer.Run);
    end else
    begin

  {$IF TOFFEE}
  while String.CharacterisNumber(FBuffer.Buf[FBuffer.Run]) do
    inc(FBuffer.Run);
{$ELSE}
      while Char.IsNumber(FBuffer.Buf[FBuffer.Run]) do
        inc(FBuffer.Run);
{$ENDIF}

    end;
  end;

  method TmwBasePasLex.BraceCloseProc;
  begin
    inc(FBuffer.Run);
    FTokenID := TptTokenKind.ptError;
    if assigned(OnMessage) then
      OnMessage(Self, TMessageEventType.meError, 'Illegal character', PosXY.X, PosXY.Y);
  end;

  method TmwBasePasLex.BorProc;
  var
  BeginRun: Integer;
  CommentText: String;
  begin
    FTokenID := TptTokenKind.ptBorComment;
    case FBuffer.Buf[FBuffer.Run] of
      #0:
      begin
        NullProc;
        if assigned(OnMessage) then
          OnMessage(Self, TMessageEventType.meError, 'Unexpected file end', PosXY.X, PosXY.Y);
        Exit;
      end;
    end;

    BeginRun := FBuffer.Run;

    while FBuffer.Buf[FBuffer.Run] <> #0 do
      case FBuffer.Buf[FBuffer.Run] of
        '}':
        begin
          FCommentState := TCommentState.csNo;
          inc(FBuffer.Run);
          Break;
        end;
        #10:
        begin
          inc(FBuffer.Run);
          inc(FBuffer.LineNumber);
          FBuffer.LinePos := FBuffer.Run;
        end;
        #13:
        begin
          inc(FBuffer.Run);
          if FBuffer.Buf[FBuffer.Run] = #10 then inc(FBuffer.Run);
          inc(FBuffer.LineNumber);
          FBuffer.LinePos := FBuffer.Run;
        end;
        else
          inc(FBuffer.Run);
      end;

    if assigned(OnComment) then
    begin
      CommentText := FBuffer.Buf.Substring( BeginRun, FBuffer.Run - BeginRun - 1);
      DoOnComment(CommentText);
    end;
  end;

  method TmwBasePasLex.BraceOpenProc;
  var
  BeginRun: Integer;
  CommentText: String;
  begin
    case FBuffer.Buf[FBuffer.Run + 1] of
      '$': FTokenID := GetDirectiveKind;
      else
        begin
          FTokenID := TptTokenKind.ptBorComment;
          FCommentState := TCommentState.csBor;
        end;
    end;

    inc(FBuffer.Run);
    BeginRun := FBuffer.Run;
    while FBuffer.Buf[FBuffer.Run] <> #0 do
      case FBuffer.Buf[FBuffer.Run] of
        '}':
        begin
          FCommentState := TCommentState.csNo;
          inc(FBuffer.Run);
          Break;
      end;
      #10:
      begin
          inc(FBuffer.Run);
          inc(FBuffer.LineNumber);
          FBuffer.LinePos := FBuffer.Run;
      end;
      #13:
      begin
          inc(FBuffer.Run);
          if FBuffer.Buf[FBuffer.Run] = #10 then inc(FBuffer.Run);
          inc(FBuffer.LineNumber);
          FBuffer.LinePos := FBuffer.Run;
      end;
      else
        inc(FBuffer.Run);
    end;
    case FTokenID of
      TptTokenKind.ptBorComment:
      begin
        if assigned(OnComment) then
        begin
          CommentText := FBuffer.Buf.Substring( BeginRun, FBuffer.Run - BeginRun - 1);
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
        if FUseDefines and (FDefineStack = 0) then
          AddDefine(DirectiveParam);
        if assigned(OnDefineDirect) then
          OnDefineDirect(Self);
    end;
    TptTokenKind.ptElseDirect:
    begin
        if FUseDefines then
        begin
          if FTopDefineRec.Count > 0 then
          begin
            if FTopDefineRec.Peek.Defined then
              inc(FDefineStack)
            else
              if FDefineStack > 0 then
                dec(FDefineStack);
          end;
        end;
        if assigned(OnElseDirect) then
          OnElseDirect(Self);
    end;
    TptTokenKind.ptEndIfDirect:
    begin
        if FUseDefines then
          ExitDefineBlock;
        if assigned(OnEndIfDirect) then
          OnEndIfDirect(Self);
    end;
    TptTokenKind.ptIfDefDirect:
    begin
        if FUseDefines then
          EnterDefineBlock(IsDefined(DirectiveParam));
        if assigned(OnIfDefDirect) then
          OnIfDefDirect(Self);
    end;
    TptTokenKind.ptIfNDefDirect:
    begin
        if FUseDefines then
          EnterDefineBlock(not IsDefined(DirectiveParam));
        if assigned(OnIfNDefDirect) then
          OnIfNDefDirect(Self);
    end;
    TptTokenKind.ptIfOptDirect:
    begin
        if FUseDefines then
          EnterDefineBlock(False);
        if assigned(OnIfOptDirect) then
          OnIfOptDirect(Self);
    end;
    TptTokenKind.ptIfDirect:
    begin
        if FUseDefines then
          EnterDefineBlock(EvaluateConditionalExpression(DirectiveParam));
        if assigned(OnIfDirect) then
          OnIfDirect(Self);
    end;
    TptTokenKind.ptIfEndDirect:
    begin
        if FUseDefines then
          ExitDefineBlock;
        if assigned(OnIfEndDirect) then
          OnIfEndDirect(Self);
    end;
  TptTokenKind.ptElseIfDirect:
  begin
    if FUseDefines then
    begin
      if FTopDefineRec.Count > 0 then
      begin
        if FTopDefineRec.Peek.Defined then
          FDefineStack := FTopDefineRec.Peek.StartCount + 1
        else
        begin
          FDefineStack := FTopDefineRec.Peek.StartCount;
          if EvaluateConditionalExpression(DirectiveParam) then
            FTopDefineRec.Peek.Defined := True
          else
            FDefineStack := FTopDefineRec.Peek.StartCount + 1
        end;
      end;
    end;
    if assigned(OnElseIfDirect) then
      OnElseIfDirect(Self);
  end;
  TptTokenKind.ptIncludeDirect:
  begin

    if assigned(FIncludeHandler) and (FDefineStack = 0) then
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
        if FUseDefines and (FDefineStack = 0) then
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
  end else
    Result := False;
end;

method TmwBasePasLex.ColonProc;
begin
  case FBuffer.Buf[FBuffer.Run + 1] of
    '=':
    begin
        inc(FBuffer.Run, 2);
        FTokenID := TptTokenKind.ptAssign;
    end;
    else
      begin
        inc(FBuffer.Run);
        FTokenID := TptTokenKind.ptColon;
      end;
end;
end;

method TmwBasePasLex.CommaProc;
begin
  inc(FBuffer.Run);
  FTokenID := TptTokenKind.ptComma;
end;

method TmwBasePasLex.CRProc;
begin
  case FCommentState of
    TCommentState.csBor: FTokenID := TptTokenKind.ptCRLFCo;
    TCommentState.csAnsi: FTokenID := TptTokenKind.ptCRLFCo;
    else
      FTokenID := TptTokenKind.ptCRLF;
  end;

  case FBuffer.Buf[FBuffer.Run + 1] of
    #10: inc(FBuffer.Run, 2);
    else
      inc(FBuffer.Run);
  end;
  inc(FBuffer.LineNumber);
  FBuffer.LinePos := FBuffer.Run;
end;

method TmwBasePasLex.EnterDefineBlock(ADefined: Boolean);
var
StackFrame: TDefineRec;
begin
  StackFrame := New TDefineRec();
    StackFrame.Defined := ADefined;
    StackFrame.StartCount := FDefineStack;
    FTopDefineRec.Push(StackFrame);// := StackFrame;
    if not ADefined then
      inc(FDefineStack);
  end;

  method TmwBasePasLex.EqualProc;
  begin
    inc(FBuffer.Run);
    FTokenID := TptTokenKind.ptEqual;
  end;

  method TmwBasePasLex.ExitDefineBlock;

  begin
    if FTopDefineRec.Count > 0 then
    begin
      var StackFrame := FTopDefineRec.Pop;
      FDefineStack := StackFrame.StartCount;
    end;

  end;

  method TmwBasePasLex.GreaterProc;
  begin
    case FBuffer.Buf[FBuffer.Run + 1] of
      '=':
      begin
        inc(FBuffer.Run, 2);
        FTokenID := TptTokenKind.ptGreaterEqual;
    end;
      else
        begin
          inc(FBuffer.Run);
          FTokenID := TptTokenKind.ptGreater;
        end;
    end;
  end;

  method TmwBasePasLex.HashValue(AChar: Char): Integer;
  begin
    if AChar <= #127 then
      Result := mHashTable[FBuffer.Buf[FBuffer.Run]]
    else
      Result := ord(AChar);
  end;

  method TmwBasePasLex.IdentProc;
  begin
    FTokenID := IdentKind;
  end;

  method TmwBasePasLex.IntegerProc;
  begin
    inc(FBuffer.Run);
    FTokenID := TptTokenKind.ptIntegerConst;
  //  ['0'..'9', 'A'..'F', 'a'..'f']
    while (FBuffer.Buf[FBuffer.Run] in ['0'..'9', 'A'..'F', 'a'..'f']  ) do
      inc(FBuffer.Run);
  end;

  method TmwBasePasLex.IsDefined(const ADefine: not nullable string): Boolean;
  begin
    for Define in  FDefines do
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
  case FCommentState of
    TCommentState.csBor: FTokenID := TptTokenKind.ptCRLFCo;
    TCommentState.csAnsi: FTokenID := TptTokenKind.ptCRLFCo;
    else
      FTokenID := TptTokenKind.ptCRLF;
  end;
  inc(FBuffer.Run);
  inc(FBuffer.LineNumber);
  FBuffer.LinePos := FBuffer.Run;
end;

method TmwBasePasLex.LowerProc;
begin
  case FBuffer.Buf[FBuffer.Run + 1] of
    '=':
    begin
        inc(FBuffer.Run, 2);
        FTokenID := TptTokenKind.ptLowerEqual;
      end;
      '>':
      begin
        inc(FBuffer.Run, 2);
        FTokenID := TptTokenKind.ptNotEqual;
    end
    else
      begin
        inc(FBuffer.Run);
        FTokenID := TptTokenKind.ptLower;
      end;
    end;
  end;

  method TmwBasePasLex.MinusProc;
  begin
    inc(FBuffer.Run);
    FTokenID := TptTokenKind.ptMinus;
  end;

  method TmwBasePasLex.NullProc;
  begin
    if assigned(FBuffer.Next) then
    begin
      FBuffer := FBuffer.Next;
      Next;
    end else
      FTokenID := TptTokenKind.ptNull;
  end;

  method TmwBasePasLex.NumberProc;
  begin
    inc(FBuffer.Run);
    FTokenID := TptTokenKind.ptIntegerConst;
  //  ['0'..'9', '.', 'e', 'E']
    while (FBuffer.Buf[FBuffer.Run] in ['0'..'9', '.', 'e', 'E']) do
    begin
      case FBuffer.Buf[FBuffer.Run] of
        '.':
        if FBuffer.Buf[FBuffer.Run + 1] = '.' then
          Break
        else
          FTokenID := TptTokenKind.ptFloat
        end;
      inc(FBuffer.Run);
    end;
  end;

  method TmwBasePasLex.PlusProc;
  begin
    inc(FBuffer.Run);
    FTokenID := TptTokenKind.ptPlus;
  end;

  method TmwBasePasLex.PointerSymbolProc;
//const
//  PointerChars = ['a'..'z', 'A'..'Z', '\', '!', '"', '#', '$', '%', '&', '''',
  //                '?', '@', '_', '`', '|', '}', '~'];
                  // TODO: support ']', '), ''*', '+', ',', '-', '.', '/', ':', ';', '<', '=', '>', '{', '^', '(', '['
begin
  inc(FBuffer.Run);
  FTokenID := TptTokenKind.ptPointerSymbol;

  //This is a wierd Pascal construct that rarely appears, but needs to be
  //supported. ^M is a valid char reference (#13, in this case)
  if (FBuffer.Buf[FBuffer.Run] in ['a'..'z', 'A'..'Z', '\', '!', '"', '#', '$', '%', '&', '''','?', '@', '_', '`', '|', '}', '~'])
  and not IsIdentifiers(FBuffer.Buf[FBuffer.Run+1]) then
  begin
    inc(FBuffer.Run);
    FTokenID := TptTokenKind.ptAsciiChar;
  end;
end;

method TmwBasePasLex.PointProc;
begin
  case FBuffer.Buf[FBuffer.Run + 1] of
    '.':
    begin
        inc(FBuffer.Run, 2);
        FTokenID := TptTokenKind.ptDotDot;
    end;
    ')':
    begin
        inc(FBuffer.Run, 2);
        FTokenID := TptTokenKind.ptSquareClose;
    end;
    else
      begin
        inc(FBuffer.Run);
        FTokenID := TptTokenKind.ptPoint;
      end;
  end;
end;



method TmwBasePasLex.RemoveDefine(const ADefine: not nullable string);
begin
  for i : Integer := FDefines.Count-1 downto 0 do
    begin

    if (FDefines[i] = nil)  or
     FDefines[i].EqualsIgnoringCase(ADefine) then
      FDefines.RemoveAt(i);
    end;
end;

method TmwBasePasLex.RoundCloseProc;
begin
  inc(FBuffer.Run);
  FTokenID := TptTokenKind.ptRoundClose;
end;

method TmwBasePasLex.AnsiProc;
var
BeginRun: Integer;
CommentText: String;
begin
  FTokenID := TptTokenKind.ptAnsiComment;
  case FBuffer.Buf[FBuffer.Run] of
    #0:
    begin
      NullProc;
      if assigned(OnMessage) then
        OnMessage(Self, TMessageEventType.meError, 'Unexpected file end', PosXY.X, PosXY.Y);
      Exit;
    end;
  end;

  BeginRun := FBuffer.Run + 1;

  while FBuffer.Run < FBuffer.Buf.Length  do
    case FBuffer.Buf[FBuffer.Run] of
      '*':
      if FBuffer.Buf[FBuffer.Run + 1] = ')' then
      begin
        FCommentState := TCommentState.csNo;
        inc(FBuffer.Run, 2);
        Break;
      end
      else inc(FBuffer.Run);
      #10:
      begin
        inc(FBuffer.Run);
        inc(FBuffer.LineNumber);
        FBuffer.LinePos := FBuffer.Run;
      end;
      #13:
      begin
        inc(FBuffer.Run);
        if FBuffer.Buf[FBuffer.Run] = #10 then inc(FBuffer.Run);
        inc(FBuffer.LineNumber);
        FBuffer.LinePos := FBuffer.Run;
      end;
      else
        inc(FBuffer.Run);
    end;

  if assigned(OnComment) then
  begin
    CommentText := FBuffer.Buf.Substring( BeginRun, FBuffer.Run - BeginRun - 2);
    DoOnComment(CommentText);
  end;
  end;

  method TmwBasePasLex.RoundOpenProc;
  var
  BeginRun: Integer;
  CommentText: String;
  begin
    BeginRun := FBuffer.Run + 2;
    inc(FBuffer.Run);
    case FBuffer.Buf[FBuffer.Run] of
      '*':
      begin
        FTokenID := TptTokenKind.ptAnsiComment;
        if FBuffer.Buf[FBuffer.Run + 1] = '$' then
          FTokenID := GetDirectiveKind
        else
          FCommentState := TCommentState.csAnsi;
        inc(FBuffer.Run);
        while FBuffer.Buf[FBuffer.Run] <> #0 do
          case FBuffer.Buf[FBuffer.Run] of
            '*':
            if FBuffer.Buf[FBuffer.Run + 1] = ')' then
            begin
              FCommentState := TCommentState.csNo;
              inc(FBuffer.Run, 2);
              Break;
            end
            else
              inc(FBuffer.Run);
            #10:
            begin
              inc(FBuffer.Run);
              inc(FBuffer.LineNumber);
              FBuffer.LinePos := FBuffer.Run;
            end;
            #13:
            begin
              inc(FBuffer.Run);
              if FBuffer.Buf[FBuffer.Run] = #10 then inc(FBuffer.Run);
              inc(FBuffer.LineNumber);
              FBuffer.LinePos := FBuffer.Run;
            end;
            else
              inc(FBuffer.Run);
          end;
      end;
      '.':
      begin
        inc(FBuffer.Run);
        FTokenID := TptTokenKind.ptSquareOpen;
      end;
      else
        FTokenID := TptTokenKind.ptRoundOpen;
    end;
    case FTokenID of
      TptTokenKind.ptAnsiComment:
      begin
        if assigned(OnComment) then
        begin
          CommentText := FBuffer.Buf.Substring(BeginRun,  FBuffer.Run - BeginRun - 2);
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
      if assigned(FIncludeHandler) then
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
      inc(FBuffer.Run);
      FTokenID := TptTokenKind.ptSemiColon;
    end;

    method TmwBasePasLex.SlashProc;
    var
    BeginRun: Integer;
    CommentText: String;
    begin
      case FBuffer.Buf[FBuffer.Run + 1] of
        '/':
        begin
          inc(FBuffer.Run, 2);

          BeginRun := FBuffer.Run;

          FTokenID := TptTokenKind.ptSlashesComment;
          while FBuffer.Buf[FBuffer.Run] <> #0 do
          begin
            case FBuffer.Buf[FBuffer.Run] of
              #10, #13: Break;
            end;
            inc(FBuffer.Run);
          end;

          if assigned(OnComment) then
          begin
            CommentText := FBuffer.Buf.Substring(BeginRun,  FBuffer.Run - BeginRun);
            DoOnComment(CommentText);
          end;
        end;
        else
          begin
            inc(FBuffer.Run);
            FTokenID := TptTokenKind.ptSlash;
          end;
      end;
    end;

    method TmwBasePasLex.SpaceProc;
    begin
      inc(FBuffer.Run);
      FTokenID := TptTokenKind.ptSpace;
  // [#1..#9, #11, #12, #14..#32]

      while FBuffer.Buf[FBuffer.Run] in [#1..#9, #11, #12, #14..#32] do
        inc(FBuffer.Run);
    end;

    method TmwBasePasLex.SquareCloseProc;
    begin
      inc(FBuffer.Run);
      FTokenID := TptTokenKind.ptSquareClose;
    end;

    method TmwBasePasLex.SquareOpenProc;
    begin
      inc(FBuffer.Run);
      FTokenID := TptTokenKind.ptSquareOpen;
    end;

    method TmwBasePasLex.StarProc;
    begin
      inc(FBuffer.Run);
      FTokenID := TptTokenKind.ptStar;
    end;

    method TmwBasePasLex.StringProc;
    begin
      FTokenID := TptTokenKind.ptStringConst;
      repeat
        inc(FBuffer.Run);
        case FBuffer.Buf[FBuffer.Run] of
          #0, #10, #13:
          begin
            if assigned(OnMessage) then
              OnMessage(Self, TMessageEventType.meError, 'Unterminated string', PosXY.X, PosXY.Y);
            Break;
          end;
          #39:
          begin
            while (FBuffer.Buf[FBuffer.Run] = #39) and (FBuffer.Buf[FBuffer.Run + 1] = #39) do
            begin
              inc(FBuffer.Run, 2);
            end;
          end;
        end;
        until FBuffer.Buf[FBuffer.Run] = #39;
      if FBuffer.Buf[FBuffer.Run] = #39 then
      begin
        inc(FBuffer.Run);
        if TokenLen = 3 then
        begin
          FTokenID := TptTokenKind.ptAsciiChar;
        end;
      end;
    end;

    method TmwBasePasLex.SymbolProc;
    begin
      inc(FBuffer.Run);
      FTokenID := TptTokenKind.ptSymbol;
    end;

    method TmwBasePasLex.UnknownProc;
    begin
      inc(FBuffer.Run);
      FTokenID := TptTokenKind.ptUnknown;
      if assigned(OnMessage) then
        OnMessage(Self, TMessageEventType.meError, 'Unknown Character', PosXY.X, PosXY.Y);
    end;

    method TmwBasePasLex.Next;
    begin
      FExID := TptTokenKind.ptUnknown;
      FTokenPos := FBuffer.Run;
      case FCommentState of
        TCommentState.csNo: DoProcTable(FBuffer.Buf[FBuffer.Run]);
        TCommentState.csBor: BorProc;
        TCommentState.csAnsi: AnsiProc;
      end;
    end;

    method TmwBasePasLex.GetIsJunk: Boolean;
    begin
      Result := TptTokenKind.IsTokenIDJunk(FTokenID) or (FUseDefines and (FDefineStack > 0) and (TokenID <> TptTokenKind.ptNull));
    end;

method TmwBasePasLex.GetIsJunkAssembly: Boolean;
begin
  Result := not(FTokenID in [ TptTokenKind.ptCRLF]) and (
    IsTokenIDJunk(FTokenID) or (FUseDefines and (FDefineStack > 0) and (TokenID <> TptTokenKind.ptNull))
    );
end;
    method TmwBasePasLex.GetIsSpace: Boolean;
    begin
      Result := FTokenID in [TptTokenKind.ptCRLF, TptTokenKind.ptSpace];
    end;

    method TmwBasePasLex.GetToken: not nullable string;
    begin
      Result := FBuffer.Buf.Substring(FTokenPos, TokenLen);
    end;

    method TmwBasePasLex.GetTokenLen: Integer;
    begin
      Result := FBuffer.Run - FTokenPos;
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
      if FTokenPos = 0 then Exit;
      RunBack := FTokenPos;
      dec(RunBack);
  //  [#1..#9, #11, #12, #14..#32]

      while FBuffer.Buf[RunBack] in [#1..#9, #11, #12, #14..#32] do
        dec(RunBack);
      if RunBack = 0 then Exit;
      case FBuffer.Buf[RunBack] of
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
        case FBuffer.Buf[FTokenPos] of
          '(':
          begin
            DirectLen := FBuffer.Run - FTokenPos - 4;
            Result := FBuffer.Buf.Substring(FTokenPos + 2, DirectLen).ToUpper;
          end;
          '{':
          begin
            DirectLen := FBuffer.Run - FTokenPos - 2;
            Result := FBuffer.Buf.Substring(FTokenPos + 1, DirectLen).ToUpper;
          end;
        end;
    end;

    method TmwBasePasLex.GetDirectiveKind: TptTokenKind;
    var
    TempPos: Integer;
    begin
      case FBuffer.Buf[FTokenPos] of
        '(': FBuffer.Run := FTokenPos + 3;
        '{': FBuffer.Run := FTokenPos + 2;
      end;
      FDirectiveParamOrigin := FTokenPos;
      TempPos := FTokenPos;
      FTokenPos := FBuffer.Run;
  FExID:= TptTokenKind.ptCompDirect; //Always register the fact that we are in a directive.
      case KeyHash of
        9:
        if KeyComp('I') and (not (FBuffer.Buf[FBuffer.Run] in ['+', '-'])) then
          Result := TptTokenKind.ptIncludeDirect else
          Result := TptTokenKind.ptCompDirect;
        15:
        if KeyComp('IF') then
          Result := TptTokenKind.ptIfDirect else
          Result := TptTokenKind.ptCompDirect;
        18:
        if KeyComp('R') then
        begin
          if not (FBuffer.Buf[FBuffer.Run] in ['+', '-']) then
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
      FTokenPos := TempPos;
      dec(FBuffer.Run);
    end;

    method TmwBasePasLex.GetDirectiveParam: not nullable string;
    var
    EndPos: Integer;
    ParamLen: Integer;
    begin
      case FBuffer.Buf[FTokenPos] of
        '(':
        begin
          FTempRun := FTokenPos + 3;
          EndPos := FBuffer.Run - 2;
        end;
        '{':
        begin
          FTempRun := FTokenPos + 2;
          EndPos := FBuffer.Run - 1;
        end;
        else
          EndPos := 0;
      end;
      while IsIdentifiers(FBuffer.Buf[FTempRun]) do
        inc(FTempRun);
      while (FBuffer.Buf[FTempRun] in ['+', ',', '-']) do
      begin
        inc(FTempRun);
        while IsIdentifiers(FBuffer.Buf[FTempRun]) do
          inc(FTempRun);
        if (FBuffer.Buf[FTempRun - 1] in ['+', ',', '-']) and (FBuffer.Buf[FTempRun] = ' ')
          then inc(FTempRun);
      end;
      if FBuffer.Buf[FTempRun] = ' ' then inc(FTempRun);
      ParamLen := EndPos - FTempRun;
      Result:= FBuffer.Buf.Substring(FTempRun, ParamLen).ToUpper;
    end;

    method TmwBasePasLex.GetFileName: not nullable string;
    begin
      Result := FBuffer.FileName;
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
      Content := FIncludeHandler.GetIncludeFileContent(IncludeFileName) + #13#10#0;

      NewBuffer := New TBufferRec();
      NewBuffer.SharedBuffer := False;
      NewBuffer.Next := FBuffer;
      NewBuffer.LineNumber := 0;
      NewBuffer.LinePos := 0;
      NewBuffer.Run := 0;
      NewBuffer.FileName := IncludeFileName;

      NewBuffer.Buf := Content;


      FBuffer := NewBuffer;

      Next;
    end;

    method TmwBasePasLex.InitLexer;
    begin
      FCommentState :=  TCommentState.csNo;
      FBuffer.LineNumber := 0;
      FBuffer.LinePos := 0;
    end;

    method TmwBasePasLex.InitFrom(ALexer: TmwBasePasLex);
    begin
      SetSharedBuffer(ALexer.FBuffer);
      FCommentState := ALexer.FCommentState;
      FScopedEnums := ALexer.ScopedEnums;
      FBuffer.Run := ALexer.RunPos;
      FTokenID := ALexer.TokenID;
      FExID := ALexer.ExID;
      CloneDefinesFrom(ALexer);
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
  if FTokenID =TptTokenKind.ptIdentifier then
    Result := FExID in [TptTokenKind.ptBoolean, TptTokenKind.ptByte, TptTokenKind.ptChar, TptTokenKind.ptDWORD, TptTokenKind.ptInt64, TptTokenKind.ptInteger,
      TptTokenKind.ptLongint, TptTokenKind.ptLongword, TptTokenKind.ptPChar, TptTokenKind.ptShortint, TptTokenKind.ptSmallint, TptTokenKind.ptWideChar, TptTokenKind.ptWord]
  else
    Result := False;
end;

method TmwBasePasLex.GetIsOrdinalType: Boolean;
begin
  Result := GetIsOrdIdent or (FTokenID in [TptTokenKind.ptAsciiChar, TptTokenKind.ptIntegerConst]);
end;

method TmwBasePasLex.GetIsRealType: Boolean;
begin
  if FTokenID =TptTokenKind.ptIdentifier then
    Result := FExID in [TptTokenKind.ptComp, TptTokenKind.ptCurrency, TptTokenKind.ptDouble, TptTokenKind.ptExtended, TptTokenKind.ptReal, TptTokenKind.ptReal48, TptTokenKind.ptSingle]
  else
    Result := False;
end;

method TmwBasePasLex.GetIsStringType: Boolean;
begin
  if FTokenID =TptTokenKind.ptIdentifier then
    Result := FExID in [TptTokenKind.ptAnsiString, TptTokenKind.ptWideString]
  else
    Result := FTokenID in [TptTokenKind.ptString, TptTokenKind.ptStringConst];
end;

method TmwBasePasLex.GetIsVariantType: Boolean;
begin
  if FTokenID =TptTokenKind.ptIdentifier then
    Result := FExID in [TptTokenKind.ptOleVariant, TptTokenKind.ptVariant]
  else
    Result := False;
end;

method TmwBasePasLex.GetOrigin: not nullable string;
begin
  Result := FBuffer.Buf;
end;

method TmwBasePasLex.GetIsAddOperator: Boolean;
begin
  Result := FTokenID in [TptTokenKind.ptMinus, TptTokenKind.ptOr, TptTokenKind.ptPlus, TptTokenKind.ptXor];
end;

method TmwBasePasLex.GetIsMulOperator: Boolean;
begin
  Result := FTokenID in [TptTokenKind.ptAnd, TptTokenKind.ptAs, TptTokenKind.ptDiv, TptTokenKind.ptMod, TptTokenKind.ptShl, TptTokenKind.ptShr, TptTokenKind.ptSlash, TptTokenKind.ptStar];
end;

method TmwBasePasLex.GetIsRelativeOperator: Boolean;
begin
  Result := FTokenID in [TptTokenKind.ptAs, TptTokenKind.ptEqual, TptTokenKind.ptGreater, TptTokenKind.ptGreaterEqual, TptTokenKind.ptLower, TptTokenKind.ptLowerEqual,
    TptTokenKind.ptIn, TptTokenKind.ptIs, TptTokenKind.ptNotEqual];
end;

method TmwBasePasLex.GetIsCompilerDirective: Boolean;
begin
  Result := FTokenID in [TptTokenKind.ptCompDirect, TptTokenKind.ptDefineDirect, TptTokenKind.ptElseDirect,
    TptTokenKind.ptEndIfDirect, TptTokenKind.ptIfDefDirect, TptTokenKind.ptIfNDefDirect, TptTokenKind.ptIfOptDirect,
    TptTokenKind.ptIncludeDirect, TptTokenKind.ptResourceDirect, TptTokenKind.ptScopedEnumsDirect, TptTokenKind.ptUndefDirect];
end;

method TmwBasePasLex.GetGenID: TptTokenKind;
begin
  Result := FTokenID;
  if FTokenID =TptTokenKind.ptIdentifier then
    if FExID <> TptTokenKind.ptUnknown then Result := FExID;
end;

{ TmwPasLex }

constructor TmwPasLex(const aCompiler : DelphiCompiler);
begin
  inherited constructor(aCompiler);
  FAheadLex := new TmwBasePasLex(aCompiler);
end;

method TmwPasLex.AheadNext;
begin
  FAheadLex.NextNoJunk;
end;

method TmwPasLex.GetAheadExID: TptTokenKind;
begin
  Result := FAheadLex.ExID;
end;

method TmwPasLex.GetAheadGenID: TptTokenKind;
begin
  Result := FAheadLex.GenID;
end;

method TmwPasLex.GetAheadToken: not nullable string;
begin
  Result := FAheadLex.Token;
end;

method TmwPasLex.GetAheadTokenID: TptTokenKind;
begin
  Result := FAheadLex.TokenID;
end;

method TmwPasLex.InitAhead;
begin
  FAheadLex.FCommentState := FCommentState;
  FAheadLex.CloneDefinesFrom(Self);
  FAheadLex.SetSharedBuffer(Buffer);
  while FAheadLex.IsJunk do
    FAheadLex.Next;
end;

method TmwPasLex.SetOrigin(const NewValue: not nullable string);
begin
  inherited SetOrigin(NewValue);
  FAheadLex.SetSharedBuffer(Buffer);
end;

method TmwBasePasLex.Func86: TptTokenKind;
begin
  Result :=TptTokenKind.ptIdentifier;
  if KeyComp('Varargs') then FExID := TptTokenKind.ptVarargs;
end;

method TmwBasePasLex.StringDQProc;
begin
  if not FAsmCode then
  begin
    SymbolProc;
    Exit;
  end;
  FTokenID := TptTokenKind.ptStringDQConst;
  repeat
    inc(FBuffer.Run);
    case FBuffer.Buf[FBuffer.Run] of
      #0, #10, #13:
      begin
          if assigned(OnMessage) then
            OnMessage(Self, TMessageEventType.meError, 'Unterminated string', PosXY.X, PosXY.Y);
          Break;
      end;
      '\':
      begin
          inc(FBuffer.Run);
          //[#32..#127]
          if (FBuffer.Buf[FBuffer.Run] in [#32..#127]) then inc(FBuffer.Run);
      end;
    end;
    until FBuffer.Buf[FBuffer.Run] = '"';
  if FBuffer.Buf[FBuffer.Run] = '"' then
    inc(FBuffer.Run);
end;

method TmwBasePasLex.AmpersandOpProc;
begin
  FTokenID := TptTokenKind.ptAmpersand;
  inc(FBuffer.Run);
  //   ['a'..'z', 'A'..'Z','0'..'9', '_', '&']
  while (FBuffer.Buf[FBuffer.Run] in ['a'..'z', 'A'..'Z','0'..'9', '_', '&']) do
    inc(FBuffer.Run);
  FTokenID :=TptTokenKind.ptIdentifier;
end;

method TmwBasePasLex.UpdateScopedEnums;
begin
  FScopedEnums := DirectiveParam.EqualsIgnoringCase('ON');
end;

class constructor TmwBasePasLex();
begin
  MakeIdentTable;
end;


//initialization
 // MakeIdentTable;
end.