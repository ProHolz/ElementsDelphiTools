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
namespace PascalParser;

interface


type

  TmwSimplePasPar = public class(Object)
  private
    FLexer: TmwPasLex;
    FInterfaceOnly: Boolean;
    FLastNoJunkPos: Integer;
    FLastNoJunkLen: Integer;
    AheadParse: TmwSimplePasPar;
    FInRound: Integer;
    method InitAhead;
    method VariableTail;
    method GetInRound: Boolean;
    method GetUseDefines: Boolean;
    method GetScopedEnums: Boolean;
    method SetUseDefines(const Value: Boolean);
    method SetIncludeHandler(aIncludeHandler: IIncludeHandler);
    method GetOnComment: TCommentEvent;
    method SetOnComment(const Value: TCommentEvent);
  protected
    method Expected(Sym: TptTokenKind); virtual;
    method ExpectedEx(Sym: TptTokenKind); virtual;
    method ExpectedFatal(Sym: TptTokenKind); virtual;
    method HandlePtCompDirect(Sender: TmwBasePasLex); virtual;
    method HandlePtDefineDirect(Sender: TmwBasePasLex); virtual;
    method HandlePtElseDirect(Sender: TmwBasePasLex); virtual;
    method HandlePtEndIfDirect(Sender: TmwBasePasLex); virtual;
    method HandlePtIfDefDirect(Sender: TmwBasePasLex); virtual;
    method HandlePtIfNDefDirect(Sender: TmwBasePasLex); virtual;
    method HandlePtIfOptDirect(Sender: TmwBasePasLex); virtual;
    method HandlePtResourceDirect(Sender: TmwBasePasLex); virtual;
    method HandlePtUndefDirect(Sender: TmwBasePasLex); virtual;
    method HandlePtIfDirect(Sender: TmwBasePasLex); virtual;
    method HandlePtIfEndDirect(Sender: TmwBasePasLex); virtual;
    method HandlePtElseIfDirect(Sender: TmwBasePasLex); virtual;
    method NextToken; virtual;
    method SkipJunk; virtual;
    method Semicolon; virtual;
    method GetExID: TptTokenKind; virtual;
    method GetTokenID: TptTokenKind; virtual;
    method GetGenID: TptTokenKind; virtual;
    method AccessSpecifier; virtual;
    method AdditiveOperator; virtual;
    method AddressOp; virtual;
    method AlignmentParameter; virtual;
    method AsOp; virtual;
    method AncestorIdList; virtual;
    method AncestorId; virtual;
    method AnonymousMethod; virtual;
    method AnonymousMethodType; virtual;
    method ArrayConstant; virtual;
    method ArrayBounds; virtual;
    method ArrayDimension; virtual;
    method ArrayType; virtual;
    method AsmStatement; virtual;
    method AssignOp; virtual;
    method AtExpression; virtual;
    method Block; virtual;
    method CaseElseStatement; virtual;
    method CaseLabel; virtual;
    method CaseLabelList; virtual;
    method CaseSelector; virtual;
    method CaseStatement; virtual;
    method CharString; virtual;
    method ClassField; virtual;
    method ClassForward; virtual;
    method ClassFunctionHeading; virtual;
    method ClassHelper; virtual;
    method ClassHeritage; virtual;
    method ClassMemberList; virtual;
    method ClassMethodDirective; virtual;
    method ClassMethodHeading; virtual;
    method ClassMethodOrProperty; virtual;
    method ClassMethodResolution; virtual;
    method ClassProcedureHeading; virtual;
    method ClassClass; virtual;
    method ClassConstraint; virtual;
    method ClassMethod; virtual;
    method ClassProperty; virtual;
    method ClassReferenceType; virtual;
    method ClassType; virtual;
    method ClassTypeEnd; virtual;
    method ClassVisibility; virtual;
    method CompoundStatement; virtual;
    method ConstantColon; virtual;
    method ConstantDeclaration; virtual;
    method ConstantEqual; virtual;
    method ConstantExpression; virtual;
    method ConstantName; virtual;
    method ConstantType; virtual;
    method ConstantValue; virtual;
    method ConstantValueTyped; virtual;
    method ConstParameter; virtual;
    method ConstructorConstraint; virtual;
    method ConstructorHeading; virtual;
    method ConstructorName; virtual;
    method ConstSection; virtual;
    method ContainsClause; virtual;
    method CustomAttribute; virtual;
    method DeclarationSection; virtual;
    method DeclarationSections; virtual;
    method Designator; virtual;
    method DestructorHeading; virtual;
    method DestructorName; virtual;
    method Directive16Bit; virtual;
    method DirectiveBinding; virtual;
    method DirectiveBindingMessage; virtual;
    method DirectiveCalling; virtual;
    method DirectiveDeprecated; virtual;
    method DirectiveInline; virtual;
    method DirectiveLibrary; virtual;
    method DirectiveLocal; virtual;
    method DirectivePlatform; virtual;
    method DirectiveVarargs; virtual;
    method DispInterfaceForward; virtual;
    method DispIDSpecifier; virtual;
    method DotOp; virtual;
    method ElseStatement; virtual;
    method EmptyStatement; virtual;
    method EnumeratedType; virtual;
    method EnumeratedTypeItem; virtual;
    method ExceptBlock; virtual;
    method ExceptionBlockElseBranch; virtual;
    method ExceptionClassTypeIdentifier; virtual;
    method ExceptionHandler; virtual;
    method ExceptionHandlerList; virtual;
    method ExceptionIdentifier; virtual;
    method ExceptionVariable; virtual;
    method ExplicitType; virtual;
    method ExportedHeading; virtual;
    method ExportsClause; virtual;
    method ExportsElement; virtual;
    method ExportsName; virtual;
    method ExportsNameId; virtual;
    method Expression; virtual;
    method ExpressionList; virtual;
    method ExternalDirective; virtual;
    method ExternalDirectiveThree; virtual;
    method ExternalDirectiveTwo; virtual;
    method Factor; virtual;
    method FieldDeclaration; virtual;
    method FieldList; virtual;
    method FieldNameList; virtual;
    method FieldName; virtual;
    method FileType; virtual;
    method FinalizationSection; virtual;
    method FinallyBlock; virtual;
    method FormalParameterList; virtual;
    method FormalParameterSection; virtual;
    method ForStatement; virtual;
    method ForStatementDownTo; virtual;
    method ForStatementFrom; virtual;
    method ForStatementIn; virtual;
    method ForStatementTo; virtual;
    method ForwardDeclaration; virtual;
    method FunctionHeading; virtual;
    method FunctionMethodDeclaration; virtual;
    method FunctionMethodName; virtual;
    method FunctionProcedureBlock; virtual;
    method FunctionProcedureName; virtual;
    method GotoStatement; virtual;
    method Identifier; virtual;
    method IdentifierList; virtual;
    method IfStatement; virtual;
    method ImplementationSection; virtual;
    method ImplementsSpecifier; virtual;
    method IncludeFile; virtual;
    method IndexSpecifier; virtual;
    method IndexOp; virtual;
    method InheritedStatement; virtual;
    method InheritedVariableReference; virtual;
    method InitializationSection; virtual;
    method InlineConstSection; virtual;
    method InlineStatement; virtual;
    method InlineVarDeclaration; virtual;
    method InlineVarSection; virtual;
    method InParameter; virtual;
    method InterfaceDeclaration; virtual;
    method InterfaceForward; virtual;
    method InterfaceGUID; virtual;
    method InterfaceHeritage; virtual;
    method InterfaceMemberList; virtual;
    method InterfaceSection; virtual;
    method InterfaceType; virtual;
    method LabelDeclarationSection; virtual;
    method LabeledStatement; virtual;
    method LabelId; virtual;
    method LibraryFile; virtual;
    method LibraryBlock; virtual;
    method MainUsedUnitExpression; virtual;
    method MainUsedUnitName; virtual;
    method MainUsedUnitStatement; virtual;
    method MainUsesClause; virtual;
    method MethodKind; virtual;
    method MultiplicativeOperator; virtual;
    method FormalParameterType; virtual;
    method NotOp; virtual;
    method NilToken; virtual;
    method Number; virtual;
    method ObjectConstructorHeading; virtual;
    method ObjectDestructorHeading; virtual;
    method ObjectField; virtual;
    method ObjectForward; virtual;
    method ObjectFunctionHeading; virtual;
    method ObjectHeritage; virtual;
    method ObjectMemberList; virtual;
    method ObjectMethodDirective; virtual;
    method ObjectMethodHeading; virtual;
    method ObjectNameOfMethod; virtual;
    method ObjectProperty; virtual;
    method ObjectPropertySpecifiers; virtual;
    method ObjectProcedureHeading; virtual;
    method ObjectType; virtual;
    method ObjectTypeEnd; virtual;
    method ObjectVisibility; virtual;
    method OrdinalIdentifier; virtual;
    method OrdinalType; virtual;
    method OutParameter; virtual;
    method PackageFile; virtual;
    method ParameterFormal; virtual;
    method ParameterName; virtual;
    method ParameterNameList; virtual;
    method ParseFile; virtual;
    method PointerSymbol; virtual;
    method PointerType; virtual;
    method ProceduralDirective; virtual;
    method ProceduralDirectiveOf; virtual;
    method ProceduralType; virtual;
    method ProcedureDeclarationSection; virtual;
    method ProcedureHeading; virtual;
    method ProcedureProcedureName; virtual;
    method ProcedureMethodName; virtual;
    method ProgramBlock; virtual;
    method ProgramFile; virtual;
    method PropertyDefault; virtual;
    method PropertyInterface; virtual;
    method PropertyName; virtual;
    method PropertyParameterList; virtual;
    method PropertySpecifiers; virtual;
    method QualifiedIdentifier; virtual;
    method RaiseStatement; virtual;
    method ReadAccessIdentifier; virtual;
    method RealIdentifier; virtual;
    method RealType; virtual;
    method RecordConstant; virtual;
    method RecordConstraint; virtual;
    method RecordFieldConstant; virtual;
    method RecordType; virtual;
    method RecordVariant; virtual;
    method RelativeOperator; virtual;
    method RepeatStatement; virtual;
    method RequiresClause; virtual;
    method RequiresIdentifier; virtual;
    method RequiresIdentifierId; virtual;
    method ResolutionInterfaceName; virtual;
    method ResourceDeclaration; virtual;
    method ResourceValue; virtual;
    method ReturnType; virtual;
    method RoundClose; virtual;
    method RoundOpen; virtual;
    method SetConstructor; virtual;
    method SetElement; virtual;
    method SetType; virtual;
    method SimpleExpression; virtual;
    method SimpleStatement; virtual;
    method SimpleType; virtual;
    method SkipAnsiComment; virtual;
    method SkipBorComment; virtual;
    method SkipSlashesComment; virtual;
    method SkipSpace; virtual;
    method SkipCRLFco; virtual;
    method SkipCRLF; virtual;
    method Statement; virtual;
    method StatementOrExpression; virtual;
    method Statements; virtual;
    method StatementList; virtual;
    method StorageExpression; virtual;
    method StorageIdentifier; virtual;
    method StorageDefault; virtual;
    method StorageNoDefault; virtual;
    method StorageSpecifier; virtual;
    method StorageStored; virtual;
    method StringConst; virtual;
    method StringConstSimple; virtual;
    method StringIdentifier; virtual;
    method StringStatement; virtual;
    method StringType; virtual;
    method StructuredType; virtual;
    method SubrangeType; virtual;
    method TagField; virtual;
    method TagFieldName; virtual;
    method TagFieldTypeName; virtual;
    method Term; virtual;
    method ThenStatement; virtual;
    method TryStatement; virtual;
    method TypedConstant; virtual;
    method TypeDeclaration; virtual;
    method TypeId; virtual;
    method TypeKind; virtual;
    method TypeName; virtual;
    method TypeReferenceType; virtual;
    method TypeSimple; virtual;
    //generics
    method TypeArgs; virtual;
    method TypeDirective; virtual;
    method TypeParams; virtual;
    method TypeParamDecl; virtual;
    method TypeParamDeclList; virtual;
    method TypeParamList; virtual;
    method ConstraintList; virtual;
    method Constraint; virtual;
    //end generics
    method TypeSection; virtual;
    method UnaryMinus; virtual;
    method UnitFile; virtual;
    method UnitId; virtual;
    method UnitName; virtual;
    method UsedUnitName; virtual;
    method UsedUnitsList; virtual;
    method UsesClause; virtual;
    method VarAbsolute; virtual;
    method VarEqual; virtual;
    method VarDeclaration; virtual;
    method Variable; virtual;
    method VariableReference; virtual;
    method VariantIdentifier; virtual;
    method VariantSection; virtual;
    method VarParameter; virtual;
    method VarName; virtual;
    method VarNameList; virtual;
    method VarSection; virtual;
    method VisibilityAutomated; virtual;
    method VisibilityPrivate; virtual;
    method VisibilityProtected; virtual;
    method VisibilityPublic; virtual;
    method VisibilityPublished; virtual;
    method VisibilityStrictPrivate; virtual;
    method VisibilityStrictProtected; virtual;
    method VisibilityUnknown; virtual;
    method WhileStatement; virtual;
    method WithExpressionList; virtual;
    method WithStatement; virtual;
    method WriteAccessIdentifier; virtual;
    //JThurman 2004-03-21
    {This is the syntax for custom attributes, based quite strictly on the
    ECMA syntax specifications for C#, but with a Delphi expression being
    used at the bottom as opposed to a C# expression}
    method GlobalAttributes;
    method GlobalAttributeSections;
    method GlobalAttributeSection;
    method GlobalAttributeTargetSpecifier;
    method GlobalAttributeTarget;
    method Attributes;
    method AttributeSections; virtual;
    method AttributeSection;
    method AttributeTargetSpecifier;
    method AttributeTarget;
    method AttributeList;
    method Attribute; virtual;
    method AttributeName; virtual;
    method AttributeArguments; virtual;
    method PositionalArgumentList;
    method PositionalArgument; virtual;
    method NamedArgumentList;
    method NamedArgument; virtual;
    method AttributeArgumentName; virtual;
    method AttributeArgumentExpression; virtual;

    property ExID: TptTokenKind read GetExID;
    property GenID: TptTokenKind read GetGenID;
    property TokenID: TptTokenKind read GetTokenID;
    property InRound: Boolean read GetInRound;
  public
    constructor(const acompiler : DelphiCompiler) ;

    method SynError(Error: TmwParseError); virtual;

    method RunWithString(const aContext: String); virtual;


    method ClearDefines;
    method InitDefinesDefinedByCompiler;
    method AddDefine(const ADefine: String);
    method RemoveDefine(const ADefine: String);
    method IsDefined(const ADefine: String): Boolean;

    property Compiler : DelphiCompiler read protected write;

    property InterfaceOnly: Boolean read FInterfaceOnly write FInterfaceOnly;
    property Lexer: TmwPasLex read FLexer;
    property OnComment: TCommentEvent read GetOnComment write SetOnComment;
    property OnMessage: TMessageEvent read write ;
    property LastNoJunkPos: Integer read FLastNoJunkPos;
    property LastNoJunkLen: Integer read FLastNoJunkLen;

    property UseDefines: Boolean read GetUseDefines write SetUseDefines;
    property ScopedEnums: Boolean read GetScopedEnums;
    property IncludeHandler: IIncludeHandler write SetIncludeHandler;
  end;

implementation



{ TmwSimplePasPar }

method TmwSimplePasPar.ForwardDeclaration;
begin
  NextToken;
  Semicolon;
end;

method TmwSimplePasPar.ObjectProperty;
begin
  Expected(TptTokenKind.ptProperty);
  PropertyName;
  case TokenID of
    TptTokenKind.ptColon, TptTokenKind.ptSquareOpen:
    begin
        PropertyInterface;
    end;
  end;
  ObjectPropertySpecifiers;
  case ExID of
    TptTokenKind.ptDefault:
    begin
        PropertyDefault;
        Semicolon;
    end;
  end;
end;

method TmwSimplePasPar.ObjectPropertySpecifiers;
begin
  if ExID = TptTokenKind.ptIndex then
  begin
    IndexSpecifier;
  end;
  while ExID in [TptTokenKind.ptRead, TptTokenKind.ptReadonly, TptTokenKind.ptWrite, TptTokenKind.ptWriteonly] do
  begin
    AccessSpecifier;
  end;
  while ExID in [TptTokenKind.ptDefault, TptTokenKind.ptNodefault, TptTokenKind.ptStored] do
  begin
    StorageSpecifier;
  end;
  Semicolon;
  // var Encoding: Encoding;
end;




method TmwSimplePasPar.RunWithString(const aContext: String);
begin
  FLexer.Origin := aContext;//StringStream.GetDataString;

  ParseFile;
end;

constructor TmwSimplePasPar(const acompiler : DelphiCompiler);
begin
  inherited constructor();
  self.Compiler := acompiler;

  FLexer := new TmwPasLex(Compiler);

  FLexer.OnCompDirect := @HandlePtCompDirect;
  FLexer.OnDefineDirect := @HandlePtDefineDirect;
  FLexer.OnElseDirect := @HandlePtElseDirect;
  FLexer.OnEndIfDirect := @HandlePtEndIfDirect;
  FLexer.OnIfDefDirect := @HandlePtIfDefDirect;
  FLexer.OnIfNDefDirect := @HandlePtIfNDefDirect;
  FLexer.OnIfOptDirect := @HandlePtIfOptDirect;
  FLexer.OnResourceDirect := @HandlePtResourceDirect;
  FLexer.OnUnDefDirect := @HandlePtUndefDirect;
  FLexer.OnIfDirect := @HandlePtIfDirect;
  FLexer.OnIfEndDirect := @HandlePtIfEndDirect;
  FLexer.OnElseIfDirect := @HandlePtElseIfDirect;
end;

//destructor TmwSimplePasPar.Destroy;
//begin
  //AheadParse.Free;

  //FLexer.Free;
  //inherited Destroy;
//end;

{next two check for TptTokenKind.ptNull and ExpectedFatal for an EOF Error}

method TmwSimplePasPar.Expected(Sym: TptTokenKind);
begin
  if Sym <> Lexer.TokenID then
  begin
    if TokenID = TptTokenKind.ptNull then
      ExpectedFatal(Sym)
    else
    begin
      if assigned(OnMessage) then
        OnMessage(Self,  TMessageEventType.meError, String.Format(rsExpected, [Sym.EnumName, FLexer.Token]),
        FLexer.PosXY.X, FLexer.PosXY.Y);
    end;
  end
  else
    NextToken;
end;

method TmwSimplePasPar.ExpectedEx(Sym: TptTokenKind);
begin
  if Sym <> Lexer.ExID then
  begin
    if Lexer.TokenID = TptTokenKind.ptNull then
      ExpectedFatal(Sym) {jdj 7/22/1999}
    else if assigned(OnMessage) then
      OnMessage(Self, TMessageEventType.meError, String.Format(rsExpected, ['EX:' + Sym.EnumName, FLexer.Token]),
      FLexer.PosXY.X, FLexer.PosXY.Y);
  end
  else
    NextToken;
end;

{Replace Token with cnEndOfFile if TokenId = TptTokenKind.ptnull}

method TmwSimplePasPar.ExpectedFatal(Sym: TptTokenKind);
var
tS: String;
begin
  if Sym <> Lexer.TokenID then
  begin
    {--jdj 7/22/1999--}
    if Lexer.TokenID = TptTokenKind.ptNull then
      tS := rsEndOfFile
    else
      tS := FLexer.Token;
    {--jdj 7/22/1999--}
    raise new ESyntaxError(String.Format(rsExpected, [Sym.EnumName, tS]), FLexer.PosXY);
end
else
  NextToken;
  end;

  method TmwSimplePasPar.HandlePtCompDirect(Sender: TmwBasePasLex);
  begin
    if assigned(OnMessage) then
      OnMessage(Self, TMessageEventType.meNotSupported, 'Currently not supported ' + FLexer.Token, FLexer.PosXY.X, FLexer.PosXY.Y);
    Sender.Next;
  end;

  method TmwSimplePasPar.HandlePtDefineDirect(Sender: TmwBasePasLex);
  begin
    Sender.Next;
  end;

  method TmwSimplePasPar.HandlePtElseDirect(Sender: TmwBasePasLex);
  begin
    if Sender = Lexer then
      NextToken
    else
      Sender.Next;
  end;

  method TmwSimplePasPar.HandlePtElseIfDirect(Sender: TmwBasePasLex);
  begin
    if Sender = Lexer then
      NextToken
    else
      Sender.Next;
  end;

  method TmwSimplePasPar.HandlePtEndIfDirect(Sender: TmwBasePasLex);
  begin
    if Sender = Lexer then
      NextToken
    else
      Sender.Next;
  end;

  method TmwSimplePasPar.HandlePtIfDefDirect(Sender: TmwBasePasLex);
  begin
    if Sender = Lexer then
      NextToken
    else
      Sender.Next;
  end;

  method TmwSimplePasPar.HandlePtIfDirect(Sender: TmwBasePasLex);
  begin
    if Sender = Lexer then
      NextToken
    else
      Sender.Next;
  end;

  method TmwSimplePasPar.HandlePtIfEndDirect(Sender: TmwBasePasLex);
  begin
    if Sender = Lexer then
      NextToken
    else
      Sender.Next;
  end;

  method TmwSimplePasPar.HandlePtIfNDefDirect(Sender: TmwBasePasLex);
  begin
    if Sender = Lexer then
      NextToken
    else
      Sender.Next;
  end;

  method TmwSimplePasPar.HandlePtIfOptDirect(Sender: TmwBasePasLex);
  begin
    if assigned(OnMessage) then
      OnMessage(Self, TMessageEventType.meNotSupported, 'Currently not supported ' + FLexer.Token, FLexer.PosXY.X, FLexer.PosXY.Y);
    Sender.Next;
  end;

  method TmwSimplePasPar.HandlePtResourceDirect(Sender: TmwBasePasLex);
  begin
    if assigned(OnMessage) then
      OnMessage(Self, TMessageEventType.meNotSupported, 'Currently not supported ' + FLexer.Token, FLexer.PosXY.X, FLexer.PosXY.Y);
    Sender.Next;
  end;

  method TmwSimplePasPar.HandlePtUndefDirect(Sender: TmwBasePasLex);
  begin
    Sender.Next;
  end;

  method TmwSimplePasPar.NextToken;
  begin
    FLexer.NextNoJunk;
  end;

  method TmwSimplePasPar.NilToken;
  begin
    Expected(TptTokenKind.ptNil);
  end;

  method TmwSimplePasPar.NotOp;
  begin
    Expected(TptTokenKind.ptNot);
  end;

  method TmwSimplePasPar.SkipJunk;
  begin
    if Lexer.IsJunk then
    begin
      case TokenID of
        TptTokenKind.ptAnsiComment:
        begin
          SkipAnsiComment;
      end;
        TptTokenKind.ptBorComment:
        begin
          SkipBorComment;
        end;
        TptTokenKind.ptSlashesComment:
        begin
          SkipSlashesComment;
        end;
        TptTokenKind.ptSpace:
        begin
          SkipSpace;
        end;
        TptTokenKind.ptCRLFCo:
        begin
          SkipCRLFco;
        end;
        TptTokenKind.ptCRLF:
        begin
          SkipCRLF;
        end;
        TptTokenKind.ptSquareOpen:
        begin
          CustomAttribute;
        end;
        else
          begin
            Lexer.Next;
          end;
      end;
    end;
    FLastNoJunkPos := Lexer.TokenPos;
    FLastNoJunkLen := Lexer.TokenLen;
  end;

  method TmwSimplePasPar.SkipAnsiComment;
  begin
    Expected(TptTokenKind.ptAnsiComment);
    while TokenID in [TptTokenKind.ptAnsiComment] do
      Lexer.Next;
  end;

  method TmwSimplePasPar.SkipBorComment;
  begin
    Expected(TptTokenKind.ptBorComment);
    while TokenID in [TptTokenKind.ptBorComment] do
      Lexer.Next;
  end;

  method TmwSimplePasPar.SkipSlashesComment;
  begin
    Expected(TptTokenKind.ptSlashesComment);
  end;

  method TmwSimplePasPar.ThenStatement;
  begin
    Expected(TptTokenKind.ptThen);
    Statement;
  end;

  method TmwSimplePasPar.Semicolon;
  begin
    case Lexer.TokenID of
      TptTokenKind.ptElse, TptTokenKind.ptEnd, TptTokenKind.ptExcept, TptTokenKind.ptFinally, TptTokenKind.ptFinalization, TptTokenKind.ptRoundClose, TptTokenKind.ptUntil: ;
      else
        Expected(TptTokenKind.ptSemiColon);
    end;
  end;

  method TmwSimplePasPar.GetExID: TptTokenKind;
  begin
    Result := FLexer.ExID;
  end;

  method TmwSimplePasPar.GetTokenID: TptTokenKind;
  begin
    Result := FLexer.TokenID;
  end;

  method TmwSimplePasPar.GetUseDefines: Boolean;
  begin
    Result := FLexer.UseDefines;
  end;

  method TmwSimplePasPar.GetScopedEnums: Boolean;
  begin
    Result := FLexer.ScopedEnums;
  end;

  method TmwSimplePasPar.GotoStatement;
  begin
    Expected(TptTokenKind.ptGoto);
    LabelId;
  end;

  method TmwSimplePasPar.GetGenID: TptTokenKind;
  begin
    Result := FLexer.GenID;
  end;

  method TmwSimplePasPar.GetInRound: Boolean;
  begin
    Result := FInRound > 0;
  end;

  method TmwSimplePasPar.GetOnComment: TCommentEvent;
  begin
    Result := FLexer.OnComment;
  end;

  method TmwSimplePasPar.SynError(Error: TmwParseError);
  begin
    if assigned(OnMessage) then
      OnMessage(Self, TMessageEventType.meError, Error.ToString + ' found ' + FLexer.Token, FLexer.PosXY.X,
      FLexer.PosXY.Y);

  end;

(******************************************************************************
 This part is oriented at the official grammar of Delphi 4
 and parialy based on Robert Zierers Delphi grammar.
 For more information about Delphi grammars take a look at:
 http://www.stud.mw.tu-muenchen.de/~rz1/Grammar.html
******************************************************************************)

method TmwSimplePasPar.ParseFile;
begin
  SkipJunk;
  case GenID of
    TptTokenKind.ptLibrary:
    begin
        LibraryFile;
    end;
    TptTokenKind.ptPackage:
    begin
      PackageFile;
    end;
    TptTokenKind.ptProgram:
    begin
      ProgramFile;
    end;
    TptTokenKind.ptUnit:
    begin
      UnitFile;
    end;
    else
      begin
        IncludeFile;
      end;
  end;
end;

method TmwSimplePasPar.LibraryFile;
begin
  Expected(TptTokenKind.ptLibrary);
  UnitName;
  Semicolon;

  LibraryBlock;
  Expected(TptTokenKind.ptPoint);
end;

method TmwSimplePasPar.LibraryBlock;
begin
  if TokenID = TptTokenKind.ptUses then
    MainUsesClause;

  DeclarationSections;

  if TokenID = TptTokenKind.ptBegin then
    CompoundStatement
  else
    Expected(TptTokenKind.ptEnd);
end;

method TmwSimplePasPar.PackageFile;
begin
  ExpectedEx(TptTokenKind.ptPackage);
  UnitName;
  Semicolon;
  case ExID of
    TptTokenKind.ptRequires:
    begin
        RequiresClause;
    end;
  end;
  case ExID of
    TptTokenKind.ptContains:
    begin
        ContainsClause;
    end;
  end;

  while Lexer.TokenID = TptTokenKind.ptSquareOpen do
  begin
    CustomAttribute;
  end;

  Expected(TptTokenKind.ptEnd);
  Expected(TptTokenKind.ptPoint);
end;

method TmwSimplePasPar.ProgramFile;
begin
  Expected(TptTokenKind.ptProgram);
  UnitName;
  if TokenID = TptTokenKind.ptRoundOpen then
  begin
    NextToken;
    IdentifierList;
    Expected(TptTokenKind.ptRoundClose);
  end;
  if not InterfaceOnly then
  begin
    Semicolon;
    ProgramBlock;
    Expected(TptTokenKind.ptPoint);
  end;
end;

method TmwSimplePasPar.UnaryMinus;
begin
  Expected(TptTokenKind.ptMinus);
end;

method TmwSimplePasPar.UnitFile;
begin
  Expected(TptTokenKind.ptUnit);
  UnitName;
  TypeDirective;

  Semicolon;
  InterfaceSection;
  if not InterfaceOnly then
  begin
    ImplementationSection;
    case TokenID of
      TptTokenKind.ptInitialization:
      begin
          InitializationSection;
          if TokenID = TptTokenKind.ptFinalization then
            FinalizationSection;
          Expected(TptTokenKind.ptEnd);
      end;
      TptTokenKind.ptBegin:
      begin
          CompoundStatement;
      end;
      TptTokenKind.ptEnd:
      begin
          NextToken;
      end;
    end;

    Expected(TptTokenKind.ptPoint);
  end;
end;

method TmwSimplePasPar.ProgramBlock;
begin
  if TokenID = TptTokenKind.ptUses then
  begin
    MainUsesClause;
  end;
  Block;
end;

method TmwSimplePasPar.MainUsesClause;
begin
  Expected(TptTokenKind.ptUses);
  MainUsedUnitStatement;
  while TokenID = TptTokenKind.ptComma do
  begin
    NextToken;
    MainUsedUnitStatement;
  end;
  Semicolon;
end;

method TmwSimplePasPar.MethodKind;
begin
  case TokenID of
    TptTokenKind.ptConstructor:
    begin
        NextToken;
    end;
    TptTokenKind.ptDestructor:
    begin
      NextToken;
    end;
    TptTokenKind.ptProcedure:
    begin
      NextToken;
    end;
    TptTokenKind.ptFunction:
    begin
      NextToken;
    end;
    else
      begin
        SynError(TmwParseError.InvalidProcedureMethodDeclaration);
      end;
  end;
end;

method TmwSimplePasPar.MainUsedUnitStatement;
begin
  MainUsedUnitName;
  if Lexer.TokenID = TptTokenKind.ptIn then
  begin
    NextToken;
    MainUsedUnitExpression;
  end;
end;

method TmwSimplePasPar.MainUsedUnitName;
begin
  UsedUnitName;
end;

method TmwSimplePasPar.MainUsedUnitExpression;
begin
  ConstantExpression;
end;

method TmwSimplePasPar.UsesClause;
begin
  Expected(TptTokenKind.ptUses);
  UsedUnitsList;
  Semicolon;
end;

method TmwSimplePasPar.UsedUnitsList;
begin
  UsedUnitName;
  while TokenID = TptTokenKind.ptComma do
  begin
    NextToken;
    UsedUnitName;
  end;
end;

method TmwSimplePasPar.UsedUnitName;
begin
  UnitId;
  while Lexer.TokenID = TptTokenKind.ptPoint do
  begin
    NextToken;
    UnitId;
  end;
end;

method TmwSimplePasPar.Block;
begin
  DeclarationSections;
  case TokenID of
    TptTokenKind.ptAsm:
    begin
        AsmStatement;
    end;
    else
      begin
        CompoundStatement;
      end;
  end;
end;

method TmwSimplePasPar.DeclarationSection;
begin
  case TokenID of
    TptTokenKind.ptClass:
    begin
        ProcedureDeclarationSection;
    end;
    TptTokenKind.ptConst:
    begin
      ConstSection;
    end;
    TptTokenKind.ptConstructor:
    begin
      ProcedureDeclarationSection;
    end;
    TptTokenKind.ptDestructor:
    begin
      ProcedureDeclarationSection;
    end;
    TptTokenKind.ptExports:
    begin
      ExportsClause;
    end;
    TptTokenKind.ptFunction:
    begin
      ProcedureDeclarationSection;
    end;
    TptTokenKind.ptLabel:
    begin
      LabelDeclarationSection;
    end;
    TptTokenKind.ptProcedure:
    begin
      ProcedureDeclarationSection;
    end;
    TptTokenKind.ptResourcestring:
    begin
      ConstSection;
    end;
    TptTokenKind.ptType:
    begin
      TypeSection;
    end;
    TptTokenKind.ptThreadvar:
    begin
      VarSection;
    end;
    TptTokenKind.ptVar:
    begin
      VarSection;
    end;
    TptTokenKind.ptSquareOpen:
    begin
      CustomAttribute;
    end;
    else
      begin
        SynError(TmwParseError.InvalidDeclarationSection);
      end;
  end;
end;

method TmwSimplePasPar.UnitId;
begin
  Expected(TptTokenKind.ptIdentifier);
end;

method TmwSimplePasPar.UnitName;
begin
  UnitId;
  while Lexer.TokenID = TptTokenKind.ptPoint do
  begin
    NextToken;
    UnitId;
  end;
end;

method TmwSimplePasPar.InterfaceHeritage;
begin
  Expected(TptTokenKind.ptRoundOpen);
  AncestorIdList;
  Expected(TptTokenKind.ptRoundClose);
end;

method TmwSimplePasPar.InterfaceGUID;
begin
  Expected(TptTokenKind.ptSquareOpen);
  CharString;
  Expected(TptTokenKind.ptSquareClose);
end;

method TmwSimplePasPar.AccessSpecifier;
begin
  case ExID of
    TptTokenKind.ptRead:
    begin
        NextToken;
        ReadAccessIdentifier;
    end;
    TptTokenKind.ptWrite:
    begin
        NextToken;
        WriteAccessIdentifier;
    end;
    TptTokenKind.ptReadonly:
    begin
        NextToken;
    end;
    TptTokenKind.ptWriteonly:
    begin
        NextToken;
    end;
    TptTokenKind.ptAdd:
    begin
        NextToken;
        QualifiedIdentifier; //TODO: AddAccessIdentifier
    end;
  TptTokenKind.ptRemove:
  begin
    NextToken;
    QualifiedIdentifier; //TODO: RemoveAccessIdentifier
  end;
  else
    begin
      SynError(TmwParseError.InvalidAccessSpecifier);
    end;
end;
end;

method TmwSimplePasPar.ReadAccessIdentifier;
begin
  Variable;
end;

method TmwSimplePasPar.WriteAccessIdentifier;
begin
  Variable;
end;

method TmwSimplePasPar.StorageSpecifier;
begin
  case ExID of
    TptTokenKind.ptStored:
    begin
        StorageStored;
    end;
    TptTokenKind.ptDefault:
    begin
      StorageDefault;
    end;
    TptTokenKind.ptNodefault:
    begin
      StorageNoDefault;
    end
    else
      begin
        SynError(TmwParseError.InvalidStorageSpecifier);
      end;
  end;
end;

method TmwSimplePasPar.StorageDefault;
begin
  ExpectedEx(TptTokenKind.ptDefault);
  StorageExpression;
end;

method TmwSimplePasPar.StorageNoDefault;
begin
  ExpectedEx(TptTokenKind.ptNodefault);
end;

method TmwSimplePasPar.StorageStored;
begin
  ExpectedEx(TptTokenKind.ptStored);
  case TokenID of
    TptTokenKind.ptIdentifier:
    begin
        StorageIdentifier;
    end;
    else
      if TokenID <> TptTokenKind.ptSemiColon then
      begin
        StorageExpression;
      end;
  end;
end;

method TmwSimplePasPar.StorageExpression;
begin
  ConstantExpression;
end;

method TmwSimplePasPar.StorageIdentifier;
begin
  Expected(TptTokenKind.ptIdentifier);
end;

method TmwSimplePasPar.PropertyParameterList;
begin
  Expected(TptTokenKind.ptSquareOpen);
  FormalParameterSection;
  while TokenID = TptTokenKind.ptSemiColon do
  begin
    Semicolon;
    FormalParameterSection;
  end;
  Expected(TptTokenKind.ptSquareClose);
end;

method TmwSimplePasPar.PropertySpecifiers;
begin
  if ExID = TptTokenKind.ptIndex then
  begin
    IndexSpecifier;
  end;
  while ExID in [TptTokenKind.ptRead, TptTokenKind.ptReadonly, TptTokenKind.ptWrite, TptTokenKind.ptWriteonly, TptTokenKind.ptAdd, TptTokenKind.ptRemove] do
  begin
    AccessSpecifier;
    if TokenID = TptTokenKind.ptSemiColon then
      NextToken;
  end;
  if ExID = TptTokenKind.ptDispid then
  begin
    DispIDSpecifier;
  end;
  while ExID in [TptTokenKind.ptDefault, TptTokenKind.ptNodefault, TptTokenKind.ptStored] do
  begin
    StorageSpecifier;
    if TokenID = TptTokenKind.ptSemiColon then
      NextToken;
  end;
  if ExID = TptTokenKind.ptImplements then
  begin
    ImplementsSpecifier;
  end;
  if TokenID = TptTokenKind.ptSemiColon then
    NextToken;
end;

method TmwSimplePasPar.PropertyInterface;
begin
  if TokenID = TptTokenKind.ptSquareOpen then
  begin
    PropertyParameterList;
  end;
  Expected(TptTokenKind.ptColon);
  TypeId;
end;

method TmwSimplePasPar.ClassMethodHeading;
begin
  if TokenID = TptTokenKind.ptClass then
    ClassClass;

  InitAhead;
  AheadParse.NextToken;
  AheadParse.FunctionProcedureName;

  if AheadParse.TokenID = TptTokenKind.ptEqual then
    ClassMethodResolution
  else
  begin
    case TokenID of
      TptTokenKind.ptConstructor:
      begin
          ConstructorHeading;
      end;
      TptTokenKind.ptDestructor:
      begin
        DestructorHeading;
      end;
      TptTokenKind.ptFunction, TptTokenKind.ptIdentifier:
      begin
        if (TokenID = TptTokenKind.ptIdentifier) and (Lexer.ExID <> TptTokenKind.ptOperator) then
          Expected(TptTokenKind.ptOperator);
        ClassFunctionHeading;
      end;
      TptTokenKind.ptProcedure:
      begin
        ClassProcedureHeading;
      end;
      else
        SynError(TmwParseError.InvalidClassMethodHeading);
    end;
  end;
end;

method TmwSimplePasPar.ClassFunctionHeading;
begin
  if (TokenID = TptTokenKind.ptIdentifier) and (Lexer.ExID = TptTokenKind.ptOperator) then
    Expected(TptTokenKind.ptIdentifier) else
    Expected(TptTokenKind.ptFunction);
  FunctionProcedureName;
  if TokenID = TptTokenKind.ptRoundOpen then
  begin
    FormalParameterList;
  end;
  Expected(TptTokenKind.ptColon);
  ReturnType;
  if TokenID = TptTokenKind.ptSemiColon then
    Semicolon;
  if ExID in [TptTokenKind.ptAbstract,
    TptTokenKind.ptCdecl,
    TptTokenKind.ptDynamic,
    TptTokenKind.ptMessage,
    TptTokenKind.ptOverride,
    TptTokenKind.ptOverload,
    TptTokenKind.ptPascal,
    TptTokenKind.ptRegister,
    TptTokenKind.ptReintroduce,
    TptTokenKind.ptSafeCall,
    TptTokenKind.ptStdcall,
    TptTokenKind.ptVirtual,
    TptTokenKind.ptDeprecated,
    TptTokenKind.ptLibrary,
    TptTokenKind.ptPlatform,
    TptTokenKind.ptStatic,
    TptTokenKind.ptInline,
    TptTokenKind.ptFinal,
    TptTokenKind.ptExperimental,
    TptTokenKind.ptDispid] then
    ClassMethodDirective;
end;

method TmwSimplePasPar.FunctionMethodName;
begin
  Expected(TptTokenKind.ptIdentifier);
end;

method TmwSimplePasPar.ClassProcedureHeading;
begin
  Expected(TptTokenKind.ptProcedure);
  FunctionProcedureName;
  if TokenID = TptTokenKind.ptRoundOpen then
  begin
    FormalParameterList;
  end;
  if TokenID = TptTokenKind.ptSemiColon then
    Semicolon;

  if ExID = TptTokenKind.ptDispid then
  begin
    DispIDSpecifier;
    if TokenID = TptTokenKind.ptSemiColon then
      Semicolon;
  end;
  if ExID in [TptTokenKind.ptAbstract,
    TptTokenKind.ptCdecl,
    TptTokenKind.ptDynamic,
    TptTokenKind.ptMessage,
    TptTokenKind.ptOverride,
    TptTokenKind.ptOverload,
    TptTokenKind.ptPascal,
    TptTokenKind.ptRegister,
    TptTokenKind.ptReintroduce,
    TptTokenKind.ptSafeCall,
    TptTokenKind.ptStdcall,
    TptTokenKind.ptVirtual,
    TptTokenKind.ptDeprecated,
    TptTokenKind.ptLibrary,
    TptTokenKind.ptPlatform,
    TptTokenKind.ptStatic,
    TptTokenKind.ptInline,
    TptTokenKind.ptFinal,
    TptTokenKind.ptExperimental,
    TptTokenKind.ptDispid] then
    ClassMethodDirective;
end;

method TmwSimplePasPar.ProcedureMethodName;
begin
  Expected(TptTokenKind.ptIdentifier);
end;

method TmwSimplePasPar.ClassMethodResolution;
begin
  case TokenID of
    TptTokenKind.ptFunction:
    begin
        NextToken;
    end;
    TptTokenKind.ptProcedure:
    begin
      NextToken;
    end;
    TptTokenKind.ptIdentifier:
    begin
      if Lexer.ExID = TptTokenKind.ptOperator then
        NextToken;
    end;
  end;
  FunctionProcedureName;
  Expected(TptTokenKind.ptEqual);
  FunctionMethodName;
  Semicolon;
end;

method TmwSimplePasPar.ResolutionInterfaceName;
begin
  Expected(TptTokenKind.ptIdentifier);
end;

method TmwSimplePasPar.Constraint;
begin
  while TokenID in [TptTokenKind.ptConstructor, TptTokenKind.ptRecord, TptTokenKind.ptClass, TptTokenKind.ptIdentifier] do
  begin
    case TokenID of
      TptTokenKind.ptConstructor: ConstructorConstraint;
      TptTokenKind.ptRecord: RecordConstraint;
      TptTokenKind.ptClass: ClassConstraint;
      TptTokenKind.ptIdentifier: TypeId;
    end;
    if TokenID = TptTokenKind.ptComma then
      NextToken;
  end;
end;

method TmwSimplePasPar.ConstraintList;
begin
  Constraint;
  while TokenID = TptTokenKind.ptComma do
  begin
    Constraint;
  end;
end;

method TmwSimplePasPar.ConstructorConstraint;
begin
  Expected(TptTokenKind.ptConstructor);
end;

method TmwSimplePasPar.ConstructorHeading;
begin
  Expected(TptTokenKind.ptConstructor);
  ConstructorName;
  if TokenID = TptTokenKind.ptRoundOpen then
  begin
    FormalParameterList;
  end;
  if TokenID = TptTokenKind.ptSemiColon then Semicolon;
  ClassMethodDirective;
end;

method TmwSimplePasPar.ConstructorName;
begin
  Expected(TptTokenKind.ptIdentifier);
end;

method TmwSimplePasPar.DestructorHeading;
begin
  Expected(TptTokenKind.ptDestructor);
  DestructorName;
  if TokenID = TptTokenKind.ptRoundOpen then
  begin
    FormalParameterList;
  end;
  if TokenID = TptTokenKind.ptSemiColon then Semicolon;
  ClassMethodDirective;
end;

method TmwSimplePasPar.DestructorName;
begin
  Expected(TptTokenKind.ptIdentifier);
end;

method TmwSimplePasPar.ClassMethod;
begin
  Expected(TptTokenKind.ptClass);
end;

method TmwSimplePasPar.ClassMethodDirective;
begin
  while ExID in [TptTokenKind.ptAbstract,
    TptTokenKind.ptCdecl,
    TptTokenKind.ptDynamic,
    TptTokenKind.ptMessage,
    TptTokenKind.ptOverride,
    TptTokenKind.ptOverload,
    TptTokenKind.ptPascal,
    TptTokenKind.ptRegister,
    TptTokenKind.ptReintroduce,
    TptTokenKind.ptSafeCall,
    TptTokenKind.ptStdcall,
    TptTokenKind.ptVirtual,
    TptTokenKind.ptDeprecated,
    TptTokenKind.ptLibrary,
    TptTokenKind.ptPlatform,
    TptTokenKind.ptStatic,
    TptTokenKind.ptInline,
    TptTokenKind.ptFinal,
    TptTokenKind.ptExperimental,
    TptTokenKind.ptDispid] do
  begin
    if ExID = TptTokenKind.ptDispid then
      DispIDSpecifier
    else
      ProceduralDirective;
    if TokenID = TptTokenKind.ptSemiColon then
      Semicolon;
  end;
end;

method TmwSimplePasPar.ObjectMethodHeading;
begin
  case TokenID of
    TptTokenKind.ptConstructor:
    begin
        ObjectConstructorHeading;
    end;
    TptTokenKind.ptDestructor:
    begin
      ObjectDestructorHeading;
    end;
    TptTokenKind.ptFunction:
    begin
      ObjectFunctionHeading;
    end;
    TptTokenKind.ptProcedure:
    begin
      ObjectProcedureHeading;
    end;
    else
      begin
        SynError(TmwParseError.InvalidMethodHeading);
      end;
  end;
end;

method TmwSimplePasPar.ObjectFunctionHeading;
begin
  Expected(TptTokenKind.ptFunction);
  FunctionMethodName;
  if TokenID = TptTokenKind.ptRoundOpen then
  begin
    FormalParameterList;
  end;
  Expected(TptTokenKind.ptColon);
  ReturnType;
  if TokenID = TptTokenKind.ptSemiColon then  Semicolon;
  ObjectMethodDirective;
end;

method TmwSimplePasPar.ObjectProcedureHeading;
begin
  Expected(TptTokenKind.ptProcedure);
  ProcedureMethodName;
  if TokenID = TptTokenKind.ptRoundOpen then
  begin
    FormalParameterList;
  end;
  if TokenID = TptTokenKind.ptSemiColon then Semicolon;
  ObjectMethodDirective;
end;

method TmwSimplePasPar.ObjectConstructorHeading;
begin
  Expected(TptTokenKind.ptConstructor);
  ConstructorName;
  if TokenID = TptTokenKind.ptRoundOpen then
  begin
    FormalParameterList;
  end;
  if TokenID = TptTokenKind.ptSemiColon then Semicolon;
  ObjectMethodDirective;
end;

method TmwSimplePasPar.ObjectDestructorHeading;
begin
  Expected(TptTokenKind.ptDestructor);
  DestructorName;
  if TokenID = TptTokenKind.ptRoundOpen then
  begin
    FormalParameterList;
  end;
  if TokenID = TptTokenKind.ptSemiColon then Semicolon;
  ObjectMethodDirective;
end;

method TmwSimplePasPar.ObjectMethodDirective;
begin
  while ExID in [TptTokenKind.ptAbstract, TptTokenKind.ptCdecl, TptTokenKind.ptDynamic, TptTokenKind.ptExport, TptTokenKind.ptExternal, TptTokenKind.ptFar,
    TptTokenKind.ptMessage, TptTokenKind.ptNear, TptTokenKind.ptOverload, TptTokenKind.ptPascal, TptTokenKind.ptRegister, TptTokenKind.ptSafeCall, TptTokenKind.ptStdcall,
    TptTokenKind.ptVirtual, TptTokenKind.ptDeprecated, TptTokenKind.ptLibrary, TptTokenKind.ptPlatform, TptTokenKind.ptStatic, TptTokenKind.ptInline] do
  begin
    ProceduralDirective;
    if TokenID = TptTokenKind.ptSemiColon then Semicolon;
  end;
end;

method TmwSimplePasPar.Directive16Bit;
begin
  case ExID of
    TptTokenKind.ptNear:
    begin
        NextToken;
    end;
    TptTokenKind.ptFar:
    begin
      NextToken;
    end;
    TptTokenKind.ptExport:
    begin
      NextToken;
    end;
    else
      begin
        SynError(TmwParseError.InvalidDirective16Bit);
      end;
  end;
end;

method TmwSimplePasPar.DirectiveBinding;
begin
  case ExID of
    TptTokenKind.ptAbstract:
    begin
        NextToken;
    end;
    TptTokenKind.ptVirtual:
    begin
      NextToken;
    end;
    TptTokenKind.ptDynamic:
    begin
      NextToken;
    end;
    TptTokenKind.ptMessage:
    begin
      DirectiveBindingMessage;
    end;
    TptTokenKind.ptOverride:
    begin
      NextToken;
    end;
    TptTokenKind.ptOverload:
    begin
      NextToken;
    end;
    TptTokenKind.ptReintroduce:
    begin
      NextToken;
    end;
    else
      begin
        SynError(TmwParseError.InvalidDirectiveBinding);
      end;
  end;
end;

method TmwSimplePasPar.DirectiveBindingMessage;
begin
  NextToken;
  ConstantExpression;
end;

method TmwSimplePasPar.ReturnType;
begin
  while TokenID = TptTokenKind.ptSquareOpen do
    CustomAttribute;

  TypeId;
end;

method TmwSimplePasPar.RoundClose;
begin
  Expected(TptTokenKind.ptRoundClose);
  dec(FInRound);
end;

method TmwSimplePasPar.RoundOpen;
begin
  Expected(TptTokenKind.ptRoundOpen);
  inc(FInRound);
end;

method TmwSimplePasPar.FormalParameterList;
begin
  Expected(TptTokenKind.ptRoundOpen);
  FormalParameterSection;
  while TokenID = TptTokenKind.ptSemiColon do
  begin
    Semicolon;
    FormalParameterSection;
  end;
  Expected(TptTokenKind.ptRoundClose);
end;

method TmwSimplePasPar.FormalParameterSection;
begin
  while TokenID = TptTokenKind.ptSquareOpen do
    CustomAttribute;
  case TokenID of
    TptTokenKind.ptConst:
    begin
        ConstParameter;
    end;
    TptTokenKind.ptIdentifier:
    case ExID of
      TptTokenKind.ptOut: OutParameter;
      else
        ParameterFormal;
    end;
    TptTokenKind.ptIn:
    begin
      InParameter;
    end;
    TptTokenKind.ptVar:
    begin
      VarParameter;
    end;
  end;
end;

method TmwSimplePasPar.ConstParameter;
begin
  Expected(TptTokenKind.ptConst);
  ParameterNameList;
  case TokenID of
    TptTokenKind.ptColon:
    begin
        NextToken;
        FormalParameterType;
        if TokenID = TptTokenKind.ptEqual then
        begin
          NextToken;
          TypedConstant;
        end;
    end
  end;
end;

method TmwSimplePasPar.VarParameter;
begin
  Expected(TptTokenKind.ptVar);
  ParameterNameList;
  case TokenID of
    TptTokenKind.ptColon:
    begin
        NextToken;
        FormalParameterType;
    end
  end;
end;

method TmwSimplePasPar.OutParameter;
begin
  ExpectedEx(TptTokenKind.ptOut);
  ParameterNameList;
  case TokenID of
    TptTokenKind.ptColon:
    begin
        NextToken;
        FormalParameterType;
    end
  end;
end;

method TmwSimplePasPar.ParameterFormal;
begin
  case TokenID of
    TptTokenKind.ptIdentifier:
    begin
        ParameterNameList;
        Expected(TptTokenKind.ptColon);
        FormalParameterType;
        if TokenID = TptTokenKind.ptEqual then
        begin
          NextToken;
          TypedConstant;
        end;
    end;
    else
      begin
        SynError(TmwParseError.InvalidParameter);
      end;
  end;
end;

method TmwSimplePasPar.ParameterNameList;
begin
  while TokenID = TptTokenKind.ptSquareOpen do
    CustomAttribute;
  ParameterName;

  while TokenID = TptTokenKind.ptComma do
  begin
    NextToken;

    while TokenID = TptTokenKind.ptSquareOpen do
      CustomAttribute;
    ParameterName;
  end;
end;

method TmwSimplePasPar.ParameterName;
begin
  Expected(TptTokenKind.ptIdentifier);
end;

method TmwSimplePasPar.FormalParameterType;
begin
  if TokenID = TptTokenKind.ptArray then
    StructuredType
  else
    TypeId;
end;

method TmwSimplePasPar.FunctionMethodDeclaration;
begin
  if (TokenID = TptTokenKind.ptIdentifier) and (Lexer.ExID = TptTokenKind.ptOperator) then
    NextToken else
    MethodKind;
  FunctionProcedureName;
  if TokenID = TptTokenKind.ptRoundOpen then
  begin
    FormalParameterList;
  end;
  case TokenID of
    TptTokenKind.ptSemiColon:
    begin
        FunctionProcedureBlock;
    end;
    else
      begin
        Expected(TptTokenKind.ptColon);
        ReturnType;
        FunctionProcedureBlock;
      end;
  end;
end;

method TmwSimplePasPar.ProcedureProcedureName;
begin
  MethodKind;
  FunctionProcedureName;
  if TokenID = TptTokenKind.ptRoundOpen then
  begin
    FormalParameterList;
  end;
  FunctionProcedureBlock;
end;

method TmwSimplePasPar.FunctionProcedureName;
begin
  ObjectNameOfMethod;
end;

method TmwSimplePasPar.ObjectNameOfMethod;
begin
  if TokenID = TptTokenKind.ptIn then
    Expected(TptTokenKind.ptIn)
  else
    Expected(TptTokenKind.ptIdentifier);

  if TokenID = TptTokenKind.ptLower then
    TypeParams;
  if TokenID = TptTokenKind.ptPoint then
  begin
    Expected(TptTokenKind.ptPoint);
    ObjectNameOfMethod;
  end;
end;

method TmwSimplePasPar.FunctionProcedureBlock;
var
HasBlock: Boolean;
begin
  HasBlock := True;
  if TokenID = TptTokenKind.ptSemiColon then Semicolon;

  while ExID in [TptTokenKind.ptAbstract, TptTokenKind.ptCdecl, TptTokenKind.ptDynamic, TptTokenKind.ptExport, TptTokenKind.ptExternal, TptTokenKind.ptDelayed, TptTokenKind.ptFar,
    TptTokenKind.ptMessage, TptTokenKind.ptNear, TptTokenKind.ptOverload, TptTokenKind.ptOverride, TptTokenKind.ptPascal, TptTokenKind.ptRegister,
    TptTokenKind.ptReintroduce, TptTokenKind.ptSafeCall, TptTokenKind.ptStdcall, TptTokenKind.ptVirtual, TptTokenKind.ptLibrary,
    TptTokenKind.ptPlatform, TptTokenKind.ptLocal, TptTokenKind.ptVarargs, TptTokenKind.ptAssembler, TptTokenKind.ptStatic, TptTokenKind.ptInline, TptTokenKind.ptForward,
    TptTokenKind.ptExperimental, TptTokenKind.ptDeprecated] do
  begin
    case ExID of
      TptTokenKind.ptExternal:
      begin
        ProceduralDirective;
        HasBlock := False;
      end;
      TptTokenKind.ptForward:
      begin
        ForwardDeclaration;
        HasBlock := False;
      end
      else
        begin
          ProceduralDirective;
        end;
    end;
    if TokenID = TptTokenKind.ptSemiColon then Semicolon;
  end;

  if HasBlock then
  begin
    case TokenID of
      TptTokenKind.ptAsm:
      begin
        AsmStatement;
      end;
      else
        begin
          Block;
        end;
    end;
    Semicolon;
  end;
end;

method TmwSimplePasPar.ExternalDirective;
begin
  ExpectedEx(TptTokenKind.ptExternal);
  case TokenID of
    TptTokenKind.ptSemiColon:
    begin
        Semicolon;
    end;
    else
      begin
        if FLexer.ExID <> TptTokenKind.ptName then
          SimpleExpression;

        if FLexer.ExID = TptTokenKind.ptDelayed then
          NextToken;

        ExternalDirectiveTwo;
      end;
  end;
end;

method TmwSimplePasPar.ExternalDirectiveTwo;
begin
  case FLexer.ExID of
    TptTokenKind.ptIndex:
    begin
        IndexSpecifier;
    end;
    TptTokenKind.ptName:
    begin
      NextToken;
      SimpleExpression;
    end;
    TptTokenKind.ptSemiColon:
    begin
      Semicolon;
      ExternalDirectiveThree;
    end;
  end
end;

method TmwSimplePasPar.ExternalDirectiveThree;
begin
  case TokenID of
    TptTokenKind.ptMinus:
    begin
        NextToken;
    end;
  end;
  case TokenID of
    TptTokenKind.ptIdentifier, TptTokenKind.ptIntegerConst:
    begin
        NextToken;
    end;
  end;
end;

method TmwSimplePasPar.ForStatement;
begin
  Expected(TptTokenKind.ptFor);
  if TokenID = TptTokenKind.ptVar then
  begin
    NextToken;
    InlineVarDeclaration;
  end
  else
    QualifiedIdentifier;

  if Lexer.TokenID = TptTokenKind.ptAssign then
  begin
    Expected(TptTokenKind.ptAssign);
    ForStatementFrom;
    case TokenID of
      TptTokenKind.ptTo:
      begin
          ForStatementTo;
      end;
      TptTokenKind.ptDownto:
      begin
        ForStatementDownTo;
      end;
      else
        begin
          SynError(TmwParseError.InvalidForStatement);
        end;
    end;
  end else
    if Lexer.TokenID = TptTokenKind.ptIn then
      ForStatementIn;
  Expected(TptTokenKind.ptDo);
  Statement;
end;

method TmwSimplePasPar.ForStatementDownTo;
begin
  Expected(TptTokenKind.ptDownto);
  Expression;
end;

method TmwSimplePasPar.ForStatementFrom;
begin
  Expression;
end;

method TmwSimplePasPar.ForStatementIn;
begin
  Expected(TptTokenKind.ptIn);
  Expression;
end;

method TmwSimplePasPar.ForStatementTo;
begin
  Expected(TptTokenKind.ptTo);
  Expression;
end;

method TmwSimplePasPar.WhileStatement;
begin
  Expected(TptTokenKind.ptWhile);
  Expression;
  Expected(TptTokenKind.ptDo);
  Statement;
end;

method TmwSimplePasPar.RepeatStatement;
begin
  Expected(TptTokenKind.ptRepeat);
  StatementList;
  Expected(TptTokenKind.ptUntil);
  Expression;
end;

method TmwSimplePasPar.CaseStatement;
begin
  Expected(TptTokenKind.ptCase);
  Expression;
  Expected(TptTokenKind.ptOf);
  CaseSelector;
  while TokenID = TptTokenKind.ptSemiColon do
  begin
    Semicolon;
    case TokenID of
      TptTokenKind.ptElse, TptTokenKind.ptEnd: ;
      else
        CaseSelector;
    end;
  end;
  if TokenID = TptTokenKind.ptElse then
    CaseElseStatement;
  Expected(TptTokenKind.ptEnd);
end;

method TmwSimplePasPar.CaseSelector;
begin
  CaseLabelList;
  Expected(TptTokenKind.ptColon);
  case TokenID of
    TptTokenKind.ptSemiColon: EmptyStatement;
    else
      Statement;
  end;
end;

method TmwSimplePasPar.CaseElseStatement;
begin
  Expected(TptTokenKind.ptElse);
  StatementList;
  Semicolon;
end;

method TmwSimplePasPar.CaseLabel;
begin
  ConstantExpression;
  if TokenID = TptTokenKind.ptDotDot then
  begin
    NextToken;
    ConstantExpression;
  end;
end;

method TmwSimplePasPar.IfStatement;
begin
  Expected(TptTokenKind.ptIf);
  Expression;
  ThenStatement;
  if TokenID = TptTokenKind.ptElse then
    ElseStatement;
end;

method TmwSimplePasPar.ExceptBlock;
begin
  if ExID = TptTokenKind.ptOn then
  begin
    ExceptionHandlerList;
    if TokenID = TptTokenKind.ptElse then
      ExceptionBlockElseBranch;
  end else
    if TokenID = TptTokenKind.ptElse then
      ExceptionBlockElseBranch
    else
      StatementList;
end;

method TmwSimplePasPar.ExceptionHandlerList;
begin
  while FLexer.ExID = TptTokenKind.ptOn do
  begin
    ExceptionHandler;
    Semicolon;
  end;
end;

method TmwSimplePasPar.ExceptionHandler;
begin
  ExpectedEx(TptTokenKind.ptOn);
  ExceptionIdentifier;
  Expected(TptTokenKind.ptDo);
  Statement;
end;

method TmwSimplePasPar.ExceptionBlockElseBranch;
begin
  NextToken;
  StatementList;
end;

method TmwSimplePasPar.ExceptionIdentifier;
begin
  Lexer.InitAhead;
  case Lexer.AheadTokenID of
    TptTokenKind.ptPoint:
    begin
        ExceptionClassTypeIdentifier;
    end;
    TptTokenKind.ptColon:
    begin
      ExceptionVariable;
    end
    else
      begin
        ExceptionClassTypeIdentifier;
      end;
  end;
end;

method TmwSimplePasPar.ExceptionClassTypeIdentifier;
begin
  TypeKind;
end;

method TmwSimplePasPar.ExceptionVariable;
begin
  Expected(TptTokenKind.ptIdentifier);
  Expected(TptTokenKind.ptColon);
  ExceptionClassTypeIdentifier;
end;

method TmwSimplePasPar.InlineConstSection;
begin
  case TokenID of
    TptTokenKind.ptConst:
    begin
        NextToken;
        ConstantDeclaration;
    end;
    else
      begin
        SynError(TmwParseError.InvalidConstSection);
      end;
  end;
end;

method TmwSimplePasPar.InlineStatement;
begin
  Expected(TptTokenKind.ptInline);
  Expected(TptTokenKind.ptRoundOpen);
  Expected(TptTokenKind.ptIntegerConst);
  while (TokenID = TptTokenKind.ptSlash) do
  begin
    NextToken;
    Expected(TptTokenKind.ptIntegerConst);
  end;
  Expected(TptTokenKind.ptRoundClose);
end;

method TmwSimplePasPar.InlineVarSection;
begin
  Expected(TptTokenKind.ptVar);
  while TokenID = TptTokenKind.ptIdentifier do
    InlineVarDeclaration;

  if TokenID = TptTokenKind.ptAssign then
  begin
    NextToken;
    Expression;
  end;
end;

method TmwSimplePasPar.InlineVarDeclaration;
begin
  VarNameList;
  if TokenID = TptTokenKind.ptColon then
  begin
    NextToken;
    TypeKind;
  end;
end;

method TmwSimplePasPar.InParameter;
begin
  Expected(TptTokenKind.ptIn);
  ParameterNameList;
  case TokenID of
    TptTokenKind.ptColon:
    begin
        NextToken;
        FormalParameterType;
        if TokenID = TptTokenKind.ptEqual then
        begin
          NextToken;
          TypedConstant;
        end;
    end
  end;
end;

method TmwSimplePasPar.AsmStatement;
begin
  Lexer.AsmCode := True;
  Expected(TptTokenKind.ptAsm);
  { should be replaced with a Assembler lexer }
  while TokenID <> TptTokenKind.ptEnd do
    case FLexer.TokenID of
      TptTokenKind.ptBegin, TptTokenKind.ptCase, TptTokenKind.ptEnd, TptTokenKind.ptIf, TptTokenKind.ptFunction, TptTokenKind.ptProcedure, TptTokenKind.ptRepeat, TptTokenKind.ptWhile: Break;
      TptTokenKind.ptAddressOp:
      begin
          NextToken;
          NextToken;
      end;
      TptTokenKind.ptDoubleAddressOp:
      begin
        NextToken;
        NextToken;
      end;
      TptTokenKind.ptNull:
      begin
        Expected(TptTokenKind.ptEnd);
        Exit;
      end;
      else
        NextToken;
    end;
  Lexer.AsmCode := False;
  Expected(TptTokenKind.ptEnd);
end;

method TmwSimplePasPar.AsOp;
begin
  Expected(TptTokenKind.ptAs);
end;

method TmwSimplePasPar.AssignOp;
begin
  Expected(TptTokenKind.ptAssign);
end;

method TmwSimplePasPar.AtExpression;
begin
  ExpectedEx(TptTokenKind.ptAt);
  Expression;
end;

method TmwSimplePasPar.RaiseStatement;
begin
  Expected(TptTokenKind.ptRaise);
  case TokenID of
    TptTokenKind.ptAddressOp, TptTokenKind.ptDoubleAddressOp, TptTokenKind.ptIdentifier, TptTokenKind.ptRoundOpen:
    begin
        Expression;
    end;
  end;
  if ExID = TptTokenKind.ptAt then
    AtExpression;
end;

method TmwSimplePasPar.TryStatement;
begin
  Expected(TptTokenKind.ptTry);
  StatementList;
  case TokenID of
    TptTokenKind.ptExcept:
    begin
        NextToken;
        ExceptBlock;
        Expected(TptTokenKind.ptEnd);
    end;
    TptTokenKind.ptFinally:
    begin
        NextToken;
        FinallyBlock;
        Expected(TptTokenKind.ptEnd);
    end;
    else
      begin
        SynError(TmwParseError.InvalidTryStatement);
      end;
  end;
end;

method TmwSimplePasPar.WithStatement;
begin
  Expected(TptTokenKind.ptWith);
  WithExpressionList;
  Expected(TptTokenKind.ptDo);
  Statement;
end;

method TmwSimplePasPar.WithExpressionList;
begin
  Expression;
  while FLexer.TokenID = TptTokenKind.ptComma do
  begin
    NextToken;
    Expression;
  end;
end;

method TmwSimplePasPar.StatementList;
begin
  Statements;
end;

method TmwSimplePasPar.StatementOrExpression;
begin
  if TokenID = TptTokenKind.ptGoto then
    SimpleStatement
  else
  begin
    InitAhead;
    AheadParse.Designator;

    if AheadParse.TokenID in [TptTokenKind.ptAssign, TptTokenKind.ptSemiColon, TptTokenKind.ptElse] then
      SimpleStatement
    else
      Expression;
  end;
end;

method TmwSimplePasPar.Statements;
begin {removed TptTokenKind.ptIntegerConst jdj-Put back in for labels}
  while TokenID in [TptTokenKind.ptAddressOp, TptTokenKind.ptAsm, TptTokenKind.ptBegin, TptTokenKind.ptCase, TptTokenKind.ptConst, TptTokenKind.ptDoubleAddressOp,
    TptTokenKind.ptFor, TptTokenKind.ptGoto, TptTokenKind.ptIdentifier, TptTokenKind.ptIf, TptTokenKind.ptInherited, TptTokenKind.ptInline, TptTokenKind.ptIntegerConst,
    TptTokenKind.ptPointerSymbol, TptTokenKind.ptRaise, TptTokenKind.ptRoundOpen, TptTokenKind.ptRepeat, TptTokenKind.ptSemiColon, TptTokenKind.ptString,
    TptTokenKind.ptTry, TptTokenKind.ptVar, TptTokenKind.ptWhile, TptTokenKind.ptWith] do
  begin
    Statement;
    Semicolon;
  end;
end;

method TmwSimplePasPar.SimpleStatement;
begin
  case TokenID of
    TptTokenKind.ptAddressOp, TptTokenKind.ptDoubleAddressOp, TptTokenKind.ptIdentifier, TptTokenKind.ptRoundOpen, TptTokenKind.ptString:
    begin
        Designator;
        if TokenID = TptTokenKind.ptAssign then
        begin
          AssignOp;
          Expression;
        end;
    end;
    TptTokenKind.ptGoto:
    begin
        GotoStatement;
    end;
  end;
end;

method TmwSimplePasPar.Statement;
begin
  case TokenID of
    TptTokenKind.ptAsm:
    begin
        AsmStatement;
    end;
    TptTokenKind.ptBegin:
    begin
      CompoundStatement;
    end;
    TptTokenKind.ptCase:
    begin
      CaseStatement;
    end;
    TptTokenKind.ptConst:
    begin
      InlineConstSection;
    end;
    TptTokenKind.ptFor:
    begin
      ForStatement;
    end;
    TptTokenKind.ptIf:
    begin
      IfStatement;
    end;
    TptTokenKind.ptIdentifier:
    begin
      FLexer.InitAhead;
      case Lexer.AheadTokenID of
        TptTokenKind.ptColon:
        begin
          LabeledStatement;
        end;
        else
          begin
            StatementOrExpression;
          end;
      end;
    end;
    TptTokenKind.ptInherited:
    begin
      InheritedStatement;
    end;
    TptTokenKind.ptInline:
    begin
      InlineStatement;
    end;
    TptTokenKind.ptIntegerConst:
    begin
      FLexer.InitAhead;
      case Lexer.AheadTokenID of
        TptTokenKind.ptColon:
        begin
          LabeledStatement;
        end;
        else
          begin
            SynError(TmwParseError.InvalidLabeledStatement);
            NextToken;
          end;
      end;
    end;
    TptTokenKind.ptRepeat:
    begin
      RepeatStatement;
    end;
    TptTokenKind.ptRaise:
    begin
      RaiseStatement;
    end;
    TptTokenKind.ptSemiColon:
    begin
      EmptyStatement;
    end;
    TptTokenKind.ptTry:
    begin
      TryStatement;
    end;
    TptTokenKind.ptVar:
    begin
      InlineVarSection;
    end;
    TptTokenKind.ptWhile:
    begin
      WhileStatement;
    end;
    TptTokenKind.ptWith:
    begin
      WithStatement;
    end;
    else
      begin
        StatementOrExpression;
      end;
  end;
end;

method TmwSimplePasPar.ElseStatement;
begin
  Expected(TptTokenKind.ptElse);
  Statement;
end;

method TmwSimplePasPar.EmptyStatement;
begin
  { Nothing to do here.
    The semicolon will be removed in StatementList }
end;

method TmwSimplePasPar.InheritedStatement;
begin
  Expected(TptTokenKind.ptInherited);
  if TokenID = TptTokenKind.ptIdentifier then
    Statement;
end;

method TmwSimplePasPar.LabeledStatement;
begin
  case TokenID of
    TptTokenKind.ptIdentifier:
    begin
        NextToken;
        Expected(TptTokenKind.ptColon);
        Statement;
    end;
    TptTokenKind.ptIntegerConst:
    begin
        NextToken;
        Expected(TptTokenKind.ptColon);
        Statement;
    end;
    else
      begin
        SynError(TmwParseError.InvalidLabeledStatement);
      end;
  end;
end;

method TmwSimplePasPar.StringStatement;
begin
  Expected(TptTokenKind.ptString);
end;

method TmwSimplePasPar.SetElement;
begin
  Expression;
  if TokenID = TptTokenKind.ptDotDot then
  begin
    NextToken;
    Expression;
  end;
end;

method TmwSimplePasPar.SetIncludeHandler(aIncludeHandler: IIncludeHandler);
begin
  FLexer.IncludeHandler := aIncludeHandler;
end;

method TmwSimplePasPar.SetOnComment(const Value: TCommentEvent);
begin
  FLexer.OnComment := Value;
end;

method TmwSimplePasPar.QualifiedIdentifier;
begin
  Identifier;

  while TokenID = TptTokenKind.ptPoint do
  begin
    DotOp;
    Identifier;
  end;
end;

method TmwSimplePasPar.SetConstructor;
begin
  Expected(TptTokenKind.ptSquareOpen);
  if TokenID <> TptTokenKind.ptSquareClose then
  begin
    SetElement;
    while TokenID = TptTokenKind.ptComma do
    begin
      NextToken;
      SetElement;
    end;
  end;
  Expected(TptTokenKind.ptSquareClose);
end;

method TmwSimplePasPar.Number;
begin
  case TokenID of
    TptTokenKind.ptFloat:
    begin
        NextToken;
    end;
    TptTokenKind.ptIntegerConst:
    begin
      NextToken;
    end;
    TptTokenKind.ptIdentifier:
    begin
      NextToken;
    end;
    else
      begin
        SynError(TmwParseError.InvalidNumber);
      end;
  end;
end;

method TmwSimplePasPar.ExpressionList;
begin
  Expression;
  if TokenID = TptTokenKind.ptAssign then
  begin
    Expected(TptTokenKind.ptAssign);
    Expression;
  end;
  while TokenID = TptTokenKind.ptComma do
  begin
    NextToken;
    Expression;
    if TokenID = TptTokenKind.ptAssign then
    begin
      Expected(TptTokenKind.ptAssign);
      Expression;
    end;
  end;
end;

method TmwSimplePasPar.Designator;
begin
  VariableReference;
end;

method TmwSimplePasPar.MultiplicativeOperator;
begin
  case TokenID of
    TptTokenKind.ptAnd:
    begin
        NextToken;
    end;
    TptTokenKind.ptDiv:
    begin
      NextToken;
    end;
    TptTokenKind.ptMod:
    begin
      NextToken;
    end;
    TptTokenKind.ptShl:
    begin
      NextToken;
    end;
    TptTokenKind.ptShr:
    begin
      NextToken;
    end;
    TptTokenKind.ptSlash:
    begin
      NextToken;
    end;
    TptTokenKind.ptStar:
    begin
      NextToken;
    end;
    else
      begin SynError(TmwParseError.InvalidMultiplicativeOperator);
      end;
  end;
end;

method TmwSimplePasPar.Factor;
begin
  case TokenID of
    TptTokenKind.ptAsciiChar, TptTokenKind.ptStringConst:
    begin
        CharString;
    end;
    TptTokenKind.ptAddressOp, TptTokenKind.ptDoubleAddressOp, TptTokenKind.ptIdentifier, TptTokenKind.ptInherited, TptTokenKind.ptPointerSymbol:
    begin
      Designator;
    end;
    TptTokenKind.ptRoundOpen:
    begin
      RoundOpen;
      ExpressionList;
      RoundClose;
    end;
    TptTokenKind.ptIntegerConst, TptTokenKind.ptFloat:
    begin
      Number;
    end;
    TptTokenKind.ptNil:
    begin
      NilToken;
    end;
    TptTokenKind.ptMinus:
    begin
      UnaryMinus;
      Factor;
    end;
    TptTokenKind.ptNot:
    begin
      NotOp;
      Factor;
    end;
    TptTokenKind.ptPlus:
    begin
      NextToken;
      Factor;
    end;
    TptTokenKind.ptSquareOpen:
    begin
      SetConstructor;
    end;
    TptTokenKind.ptString:
    begin
      StringStatement;
    end;
    TptTokenKind.ptFunction, TptTokenKind.ptProcedure:
    AnonymousMethod;
  end;

  while TokenID = TptTokenKind.ptSquareOpen do
    IndexOp;

  while TokenID = TptTokenKind.ptPointerSymbol do
    PointerSymbol;

  if TokenID = TptTokenKind.ptRoundOpen then
    Factor;

    while TokenID = TptTokenKind.ptPoint do
    begin
      DotOp;
      Factor;
    end;
  end;

  method TmwSimplePasPar.AdditiveOperator;
  begin
    if TokenID in [TptTokenKind.ptMinus, TptTokenKind.ptOr, TptTokenKind.ptPlus, TptTokenKind.ptXor] then
    begin
      NextToken;
    end
    else
    begin
      SynError(TmwParseError.InvalidAdditiveOperator);
    end;
  end;

  method TmwSimplePasPar.AddressOp;
  begin
    Expected(TptTokenKind.ptAddressOp);
  end;

  method TmwSimplePasPar.AlignmentParameter;
  begin
    SimpleExpression;
  end;

  method TmwSimplePasPar.Term;
  begin
    Factor;
    while TokenID in [TptTokenKind.ptAnd, TptTokenKind.ptDiv, TptTokenKind.ptMod, TptTokenKind.ptShl, TptTokenKind.ptShr, TptTokenKind.ptSlash, TptTokenKind.ptStar] do
    begin
      MultiplicativeOperator;
      Factor;
    end;
  end;

  method TmwSimplePasPar.RelativeOperator;
  begin
    case TokenID of
      TptTokenKind.ptAs:
      begin
        NextToken;
    end;
      TptTokenKind.ptEqual:
      begin
        NextToken;
      end;
      TptTokenKind.ptGreater:
      begin
        NextToken;
      end;
      TptTokenKind.ptGreaterEqual:
      begin
        NextToken;
      end;
      TptTokenKind.ptIn:
      begin
        NextToken;
      end;
      TptTokenKind.ptIs:
      begin
        NextToken;
      end;
      TptTokenKind.ptLower:
      begin
        NextToken;
      end;
      TptTokenKind.ptLowerEqual:
      begin
        NextToken;
      end;
      TptTokenKind.ptNotEqual:
      begin
        NextToken;
      end;
      else
        begin
          SynError(TmwParseError.InvalidRelativeOperator);
        end;
    end;
  end;

  method TmwSimplePasPar.SimpleExpression;
  begin
    Term;
    while TokenID in [TptTokenKind.ptMinus, TptTokenKind.ptOr, TptTokenKind.ptPlus, TptTokenKind.ptXor] do
    begin
      AdditiveOperator;
      Term;
    end;

    case TokenID of
      TptTokenKind.ptAs:
      begin
        AsOp;
        TypeId;
    end;
    end;
  end;

  method TmwSimplePasPar.Expression;
  begin
    SimpleExpression;

  //JT 2006-07-17 The Delphi language guide has this as
  //Expression -> SimpleExpression [RelOp SimpleExpression]...
  //So this needs to be able to repeat itself.
  case TokenID of
    TptTokenKind.ptEqual, TptTokenKind.ptGreater, TptTokenKind.ptGreaterEqual, TptTokenKind.ptLower, TptTokenKind.ptLowerEqual, TptTokenKind.ptIn, TptTokenKind.ptIs,
    TptTokenKind.ptNotEqual:
    begin
      while TokenID in [TptTokenKind.ptEqual, TptTokenKind.ptGreater, TptTokenKind.ptGreaterEqual, TptTokenKind.ptLower, TptTokenKind.ptLowerEqual,
        TptTokenKind.ptIn, TptTokenKind.ptIs, TptTokenKind.ptNotEqual{, TptTokenKind.ptColon}] do
      begin
        RelativeOperator;
        SimpleExpression;
      end;
    end;
    TptTokenKind.ptColon:
    begin
      case InRound of
        False: ;
        True:
        while TokenID = TptTokenKind.ptColon do
        begin
          NextToken;
          AlignmentParameter;
        end;
      end;
    end;
  end;
end;

method TmwSimplePasPar.VarDeclaration;
begin
  VarNameList;
  Expected(TptTokenKind.ptColon);
  TypeKind;
  TypeDirective;

  case GenID of
    TptTokenKind.ptAbsolute:
    begin
        VarAbsolute;
    end;
    TptTokenKind.ptEqual:
    begin
      VarEqual;
    end;
  end;
  TypeDirective;
end;

method TmwSimplePasPar.VarAbsolute;
begin
  ExpectedEx(TptTokenKind.ptAbsolute);
  ConstantValue;
end;

method TmwSimplePasPar.VarEqual;
begin
  Expected(TptTokenKind.ptEqual);
  ConstantValueTyped;
end;

method TmwSimplePasPar.VarNameList;
begin
  VarName;
  while TokenID = TptTokenKind.ptComma do
  begin
    NextToken;
    VarName;
  end;
end;

method TmwSimplePasPar.VarName;
begin
  Expected(TptTokenKind.ptIdentifier);
end;

method TmwSimplePasPar.DirectiveCalling;
begin
  case ExID of
    TptTokenKind.ptCdecl:
    begin
        NextToken;
    end;
    TptTokenKind.ptPascal:
    begin
      NextToken;
    end;
    TptTokenKind.ptRegister:
    begin
      NextToken;
    end;
    TptTokenKind.ptSafeCall:
    begin
      NextToken;
    end;
    TptTokenKind.ptStdcall:
    begin
      NextToken;
    end;
    else
      begin
        SynError(TmwParseError.InvalidDirectiveCalling);
      end;
  end;
end;

method TmwSimplePasPar.RecordVariant;
begin
  ConstantExpression;
  while (TokenID = TptTokenKind.ptComma) do
  begin
    NextToken;
    ConstantExpression;
  end;
  Expected(TptTokenKind.ptColon);
  Expected(TptTokenKind.ptRoundOpen);
  if TokenID <> TptTokenKind.ptRoundClose then
  begin
    FieldList;
  end;
  Expected(TptTokenKind.ptRoundClose);
end;

method TmwSimplePasPar.VariantSection;
begin
  Expected(TptTokenKind.ptCase);
  TagField;
  Expected(TptTokenKind.ptOf);
  RecordVariant;
  while TokenID = TptTokenKind.ptSemiColon do
  begin
    Semicolon;
    case TokenID of
      TptTokenKind.ptEnd, TptTokenKind.ptRoundClose: Break;
      else
        RecordVariant;
    end;
  end;
end;

method TmwSimplePasPar.TagField;
begin
  TagFieldName;
  case FLexer.TokenID of
    TptTokenKind.ptColon:
    begin
        NextToken;
        TagFieldTypeName;
    end;
  end;
end;

method TmwSimplePasPar.TagFieldName;
begin
  Expected(TptTokenKind.ptIdentifier);
end;

method TmwSimplePasPar.TagFieldTypeName;
begin
  OrdinalType;
end;

method TmwSimplePasPar.FieldDeclaration;
begin
  FieldNameList;
  Expected(TptTokenKind.ptColon);
  TypeKind;
  TypeDirective;
end;

method TmwSimplePasPar.FieldList;
begin
  while TokenID = TptTokenKind.ptIdentifier do
  begin
    FieldDeclaration;
    Semicolon;
  end;
  if TokenID = TptTokenKind.ptCase then
  begin
    VariantSection;
  end;
end;

method TmwSimplePasPar.FieldName;
begin
  Expected(TptTokenKind.ptIdentifier);
end;

method TmwSimplePasPar.FieldNameList;
begin
  FieldName;
  while TokenID = TptTokenKind.ptComma do
  begin
    NextToken;
    FieldName;
  end;
end;

method TmwSimplePasPar.RecordType;
begin
  Expected(TptTokenKind.ptRecord);
  if TokenID = TptTokenKind.ptSemiColon then
    Exit;

  if ExID = TptTokenKind.ptHelper then
    ClassHelper;

  if TokenID = TptTokenKind.ptRoundOpen then
  begin
    ClassHeritage;
    if TokenID = TptTokenKind.ptSemiColon then
      Exit;
  end;
  ClassMemberList;
  Expected(TptTokenKind.ptEnd);

  ClassTypeEnd;
end;

method TmwSimplePasPar.FileType;
begin
  Expected(TptTokenKind.ptFile);
  if TokenID = TptTokenKind.ptOf then
  begin
    NextToken;
    TypeId;
  end;
end;

method TmwSimplePasPar.FinalizationSection;
begin
  Expected(TptTokenKind.ptFinalization);
  StatementList;
end;

method TmwSimplePasPar.FinallyBlock;
begin
  StatementList;
end;

method TmwSimplePasPar.SetType;
begin
  Expected(TptTokenKind.ptSet);
  Expected(TptTokenKind.ptOf);
  OrdinalType;
end;

method TmwSimplePasPar.SetUseDefines(const Value: Boolean);
begin
  FLexer.UseDefines := Value;
end;

method TmwSimplePasPar.ArrayType;
begin
  Expected(TptTokenKind.ptArray);
  ArrayBounds;
  Expected(TptTokenKind.ptOf);
  TypeKind;
end;

method TmwSimplePasPar.EnumeratedType;
begin
  Expected(TptTokenKind.ptRoundOpen);
  EnumeratedTypeItem;
  while TokenID = TptTokenKind.ptComma do
  begin
    NextToken;
    EnumeratedTypeItem;
  end;
  Expected(TptTokenKind.ptRoundClose);
end;

method TmwSimplePasPar.SubrangeType;
begin
  ConstantExpression;
  if TokenID = TptTokenKind.ptDotDot then
  begin
    NextToken;
    ConstantExpression;
  end;
end;

method TmwSimplePasPar.RealIdentifier;
begin
  case ExID of
    TptTokenKind.ptReal48:
    begin
        NextToken;
    end;
    TptTokenKind.ptReal:
    begin
      NextToken;
    end;
    TptTokenKind.ptSingle:
    begin
      NextToken;
    end;
    TptTokenKind.ptDouble:
    begin
      NextToken;
    end;
    TptTokenKind.ptExtended:
    begin
      NextToken;
    end;
    TptTokenKind.ptCurrency:
    begin
      NextToken;
    end;
    TptTokenKind.ptComp:
    begin
      NextToken;
    end;
    else
      begin
        SynError(TmwParseError.InvalidRealIdentifier);
      end;
  end;
end;

method TmwSimplePasPar.RealType;
begin
  case TokenID of
    TptTokenKind.ptMinus:
    begin
        NextToken;
    end;
    TptTokenKind.ptPlus:
    begin
      NextToken;
    end;
  end;
  case TokenID of
    TptTokenKind.ptFloat:
    begin
        NextToken;
    end;
    else
      begin
        VariableReference;
      end;
  end;
end;

method TmwSimplePasPar.OrdinalIdentifier;
begin
  case ExID of
    TptTokenKind.ptBoolean:
    begin
        NextToken;
    end;
    TptTokenKind.ptByte:
    begin
      NextToken;
    end;
    TptTokenKind.ptByteBool:
    begin
      NextToken;
    end;
    TptTokenKind.ptCardinal:
    begin
      NextToken;
    end;
    TptTokenKind.ptChar:
    begin
      NextToken;
    end;
    TptTokenKind.ptDWORD:
    begin
      NextToken;
    end;
    TptTokenKind.ptInt64:
    begin
      NextToken;
    end;
    TptTokenKind.ptInteger:
    begin
      NextToken;
    end;
    TptTokenKind.ptLongBool:
    begin
      NextToken;
    end;
    TptTokenKind.ptLongint:
    begin
      NextToken;
    end;
    TptTokenKind.ptLongword:
    begin
      NextToken;
    end;
    TptTokenKind.ptPChar:
    begin
      NextToken;
    end;
    TptTokenKind.ptShortint:
    begin
      NextToken;
    end;
    TptTokenKind.ptSmallint:
    begin
      NextToken;
    end;
    TptTokenKind.ptWideChar:
    begin
      NextToken;
    end;
    TptTokenKind.ptWord:
    begin
      NextToken;
    end;
    TptTokenKind.ptWordBool:
    begin
      NextToken;
    end;
    else
      begin
        SynError(TmwParseError.InvalidOrdinalIdentifier);
      end;
  end;
end;

method TmwSimplePasPar.OrdinalType;
begin
  case TokenID of
    TptTokenKind.ptIdentifier:
    begin
        Lexer.InitAhead;
        case Lexer.AheadTokenID of
          TptTokenKind.ptPoint:
          begin
              Expression;
          end;
          TptTokenKind.ptRoundOpen, TptTokenKind.ptDotDot:
          begin
            ConstantExpression;
          end;
          else
            begin
              TypeId;
            end;
        end;
    end;
    TptTokenKind.ptRoundOpen:
    begin
        EnumeratedType;
    end;
    TptTokenKind.ptSquareOpen:
    begin
      NextToken;
      SubrangeType;
      Expected(TptTokenKind.ptSquareClose);
    end;
    else
      begin
        ConstantExpression;
      end;
  end;
  if TokenID = TptTokenKind.ptDotDot then
  begin
    NextToken;
    ConstantExpression;
  end;
  end;

  method TmwSimplePasPar.VariableReference;
  begin
    case TokenID of
      TptTokenKind.ptRoundOpen:
      begin
        RoundOpen;
        Expression;
        RoundClose;
        VariableTail;
      end;
      TptTokenKind.ptSquareOpen:
      begin
        SetConstructor;
      end;
      TptTokenKind.ptAddressOp:
      begin
        AddressOp;
        VariableReference;
    end;
      TptTokenKind.ptDoubleAddressOp:
      begin
        NextToken;
        VariableReference;
    end;
      TptTokenKind.ptInherited:
      begin
        InheritedVariableReference;
    end;
      else
        Variable;
    end;
  end;

  method TmwSimplePasPar.Variable; (* Attention: could also came from proc_call ! ! *)
  begin
    QualifiedIdentifier;
    VariableTail;
  end;

  method TmwSimplePasPar.VariableTail;
  begin
    case TokenID of
      TptTokenKind.ptRoundOpen:
      begin
        RoundOpen;
        ExpressionList;
        RoundClose;
    end;
    TptTokenKind.ptSquareOpen:
    begin
        IndexOp;
    end;
    TptTokenKind.ptPointerSymbol:
    begin
        PointerSymbol;
    end;
  TptTokenKind.ptLower:
  begin
    InitAhead;
    AheadParse.NextToken;
    AheadParse.TypeArgs;

    if AheadParse.TokenID = TptTokenKind.ptGreater then
    begin
      NextToken;
      TypeArgs;
      Expected(TptTokenKind.ptGreater);
      case TokenID of
        TptTokenKind.ptAddressOp, TptTokenKind.ptDoubleAddressOp, TptTokenKind.ptIdentifier:
        begin
          VariableReference;
        end;
        TptTokenKind.ptPoint, TptTokenKind.ptPointerSymbol, TptTokenKind.ptRoundOpen, TptTokenKind.ptSquareOpen:
        begin
            VariableTail;
          end;
      end;
    end;
end;
  end;

  case TokenID of
    TptTokenKind.ptRoundOpen, TptTokenKind.ptSquareOpen, TptTokenKind.ptPointerSymbol:
    begin
      VariableTail;
    end;
    TptTokenKind.ptPoint:
    begin
      DotOp;
      Variable;
    end;
    TptTokenKind.ptAs:
    begin
      AsOp;
      SimpleExpression;
    end;
  end;
end;

method TmwSimplePasPar.InterfaceType;
begin
  case TokenID of
    TptTokenKind.ptInterface:
    begin
        NextToken;
    end;
    TptTokenKind.ptDispinterface:
    begin
      NextToken;
    end
    else
      begin
        SynError(TmwParseError.InvalidInterfaceType);
      end;
  end;
  case TokenID of
    TptTokenKind.ptEnd:
    begin
        NextToken; { Direct descendant without new members }
    end;
    TptTokenKind.ptRoundOpen:
    begin
      InterfaceHeritage;
      case TokenID of
        TptTokenKind.ptEnd:
        begin
          NextToken; { No new members }
        end;
        TptTokenKind.ptSemiColon: ; { No new members }
        else
          begin
            if TokenID = TptTokenKind.ptSquareOpen then
            begin
              InterfaceGUID;
            end;
            InterfaceMemberList;
            Expected(TptTokenKind.ptEnd);
          end;
      end;
    end;
    else
      begin
        if TokenID = TptTokenKind.ptSquareOpen then
        begin
          InterfaceGUID;
        end;
        InterfaceMemberList; { Direct descendant }
        Expected(TptTokenKind.ptEnd);
      end;
  end;
end;

method TmwSimplePasPar.InterfaceMemberList;
begin
  while TokenID in [TptTokenKind.ptSquareOpen, TptTokenKind.ptFunction, TptTokenKind.ptProcedure, TptTokenKind.ptProperty] do
  begin
    while TokenID = TptTokenKind.ptSquareOpen do
      CustomAttribute;

    ClassMethodOrProperty;
  end;
end;

method TmwSimplePasPar.ClassType;
begin
  Expected(TptTokenKind.ptClass);
  case TokenID of
    TptTokenKind.ptIdentifier: //NASTY hack because Abstract is generally an ExID, except in this case when it should be a keyword.
    begin
        if Lexer.ExID = TptTokenKind.ptAbstract then
          Expected(TptTokenKind.ptIdentifier);

        if Lexer.ExID = TptTokenKind.ptHelper then
          ClassHelper;
    end;
    TptTokenKind.ptSealed:
    Expected(TptTokenKind.ptSealed);
  end;
  case TokenID of
    TptTokenKind.ptEnd:
    begin
        ClassTypeEnd;
        NextToken; { Direct descendant of TObject without new members }
    end;
    TptTokenKind.ptRoundOpen:
    begin
        ClassHeritage;
        case TokenID of
          TptTokenKind.ptEnd:
          begin
              Expected(TptTokenKind.ptEnd);
              ClassTypeEnd;
          end;
          TptTokenKind.ptSemiColon: ClassTypeEnd;
          else
            begin
              ClassMemberList; { Direct descendant of TObject }
              Expected(TptTokenKind.ptEnd);
              ClassTypeEnd;
            end;
        end;
    end;
    TptTokenKind.ptSemiColon: ClassTypeEnd;
    else
      begin
        ClassMemberList; { Direct descendant of TObject }
        Expected(TptTokenKind.ptEnd);
        ClassTypeEnd;
      end;
  end;
end;

method TmwSimplePasPar.ClassHelper;
begin
  ExpectedEx(TptTokenKind.ptHelper);
  if TokenID = TptTokenKind.ptRoundOpen then
    ClassHeritage;
  Expected(TptTokenKind.ptFor);
  TypeId;
end;

method TmwSimplePasPar.ClassHeritage;
begin
  Expected(TptTokenKind.ptRoundOpen);
  AncestorIdList;
  Expected(TptTokenKind.ptRoundClose);
end;

method TmwSimplePasPar.ClassVisibility;
var
IsStrict: Boolean;
begin
  IsStrict := ExID = TptTokenKind.ptStrict;
  if IsStrict then
    ExpectedEx(TptTokenKind.ptStrict);

  while ExID in [TptTokenKind.ptAutomated, TptTokenKind.ptPrivate, TptTokenKind.ptProtected, TptTokenKind.ptPublic, TptTokenKind.ptPublished] do
  begin
    Lexer.InitAhead;
    case Lexer.AheadExID of
      TptTokenKind.ptColon, TptTokenKind.ptComma: ;
      else
        case ExID of
          TptTokenKind.ptAutomated:
          begin
            VisibilityAutomated;
        end;
          TptTokenKind.ptPrivate:
          begin
            if IsStrict then
              VisibilityStrictPrivate
            else
              VisibilityPrivate;
          end;
          TptTokenKind.ptProtected:
          begin
            if IsStrict then
              VisibilityStrictProtected
            else
              VisibilityProtected;
          end;
          TptTokenKind.ptPublic:
          begin
            VisibilityPublic;
          end;
          TptTokenKind.ptPublished:
          begin
            VisibilityPublished;
          end;
        end;
    end;
  end;
  end;

  method TmwSimplePasPar.VisibilityAutomated;
  begin
    ExpectedEx(TptTokenKind.ptAutomated);
  end;

  method TmwSimplePasPar.VisibilityStrictPrivate;
  begin
    ExpectedEx(TptTokenKind.ptPrivate);
  end;

  method TmwSimplePasPar.VisibilityPrivate;
  begin
    ExpectedEx(TptTokenKind.ptPrivate);
  end;

  method TmwSimplePasPar.VisibilityStrictProtected;
  begin
    ExpectedEx(TptTokenKind.ptProtected);
  end;

  method TmwSimplePasPar.VisibilityProtected;
  begin
    ExpectedEx(TptTokenKind.ptProtected);
  end;

  method TmwSimplePasPar.VisibilityPublic;
  begin
    ExpectedEx(TptTokenKind.ptPublic);
  end;

  method TmwSimplePasPar.VisibilityPublished;
  begin
    ExpectedEx(TptTokenKind.ptPublished);
  end;

  method TmwSimplePasPar.VisibilityUnknown;
  begin
  end;

  method TmwSimplePasPar.ClassMemberList;
  begin
    while (TokenID in [TptTokenKind.ptClass, TptTokenKind.ptConstructor, TptTokenKind.ptDestructor, TptTokenKind.ptFunction,
      TptTokenKind.ptIdentifier, TptTokenKind.ptProcedure, TptTokenKind.ptProperty, TptTokenKind.ptType, TptTokenKind.ptSquareOpen, TptTokenKind.ptVar, TptTokenKind.ptConst, TptTokenKind.ptCase]) or (ExID = TptTokenKind.ptStrict) do
    begin
      ClassVisibility;

      if TokenID = TptTokenKind.ptSquareOpen then
        CustomAttribute;

      if (TokenID = TptTokenKind.ptIdentifier) and
        not (ExID in [TptTokenKind.ptPrivate, TptTokenKind.ptProtected, TptTokenKind.ptPublished, TptTokenKind.ptPublic, TptTokenKind.ptStrict]) then
      begin
        InitAhead;
        AheadParse.NextToken;

        if AheadParse.TokenID = TptTokenKind.ptEqual then
          ConstantDeclaration
        else
        begin
          ClassField;
          if TokenID = TptTokenKind.ptEqual then
          begin
            NextToken;
            TypedConstant;
          end;
        end;

        Semicolon;
      end
      else if TokenID in [TptTokenKind.ptClass, TptTokenKind.ptConstructor, TptTokenKind.ptDestructor, TptTokenKind.ptFunction,
        TptTokenKind.ptProcedure, TptTokenKind.ptProperty, TptTokenKind.ptVar, TptTokenKind.ptConst] then
      begin
        ClassMethodOrProperty;
      end;
      if TokenID = TptTokenKind.ptType then
        TypeSection;
      if TokenID = TptTokenKind.ptCase then
      begin
        VariantSection;
      end;
    end;
  end;

  method TmwSimplePasPar.ClassMethodOrProperty;
  var
  CurToken: TptTokenKind;
  begin
    if TokenID = TptTokenKind.ptClass then
    begin
      InitAhead;
      AheadParse.NextToken;
      CurToken := AheadParse.TokenID;
    end else
      CurToken := TokenID;

    case CurToken of
      TptTokenKind.ptProperty:
      begin
        ClassProperty;
      end;
      TptTokenKind.ptVar, TptTokenKind.ptThreadvar:
      begin
        if TokenID = TptTokenKind.ptClass then
          ClassClass;

        NextToken;
        while (TokenID = TptTokenKind.ptIdentifier) and (ExID = TptTokenKind.ptUnknown) do
        begin
          ClassField;
          Semicolon;
        end;
      end;
      TptTokenKind.ptConst:
      begin
        if TokenID = TptTokenKind.ptClass then
          ClassClass;

        NextToken;
        while (TokenID = TptTokenKind.ptIdentifier) and (ExID = TptTokenKind.ptUnknown) do
        begin
          ConstantDeclaration;
          Semicolon;
        end;
      end;
      else
        begin
          ClassMethodHeading;
        end;
    end;
  end;

  method TmwSimplePasPar.ClassProperty;
  begin
    if TokenID = TptTokenKind.ptClass then
      ClassClass;

    Expected(TptTokenKind.ptProperty);
    PropertyName;
    case TokenID of
      TptTokenKind.ptColon, TptTokenKind.ptSquareOpen:
      begin
        PropertyInterface;
    end;
    end;
    PropertySpecifiers;
    case ExID of
      TptTokenKind.ptDefault:
      begin
        PropertyDefault;
        Semicolon;
    end;
    end;
end;

method TmwSimplePasPar.PropertyName;
begin
  Expected(TptTokenKind.ptIdentifier);
end;

method TmwSimplePasPar.ClassField;
begin
  if TokenID = TptTokenKind.ptSquareOpen then
    CustomAttribute;
  FieldNameList;
  Expected(TptTokenKind.ptColon);
  TypeKind;
  TypeDirective;
end;

method TmwSimplePasPar.ObjectType;
begin
  Expected(TptTokenKind.ptObject);
  case TokenID of
    TptTokenKind.ptEnd:
    begin
        ObjectTypeEnd;
        NextToken; { Direct descendant without new members }
    end;
    TptTokenKind.ptRoundOpen:
    begin
        ObjectHeritage;
        case TokenID of
          TptTokenKind.ptEnd:
          begin
              Expected(TptTokenKind.ptEnd);
              ObjectTypeEnd;
          end;
          TptTokenKind.ptSemiColon: ObjectTypeEnd;
          else
            begin
              ObjectMemberList; { Direct descendant }
              Expected(TptTokenKind.ptEnd);
              ObjectTypeEnd;
            end;
        end;
    end;
    else
      begin
        ObjectMemberList; { Direct descendant }
        Expected(TptTokenKind.ptEnd);
        ObjectTypeEnd;
      end;
end;
end;

method TmwSimplePasPar.ObjectHeritage;
begin
  Expected(TptTokenKind.ptRoundOpen);
  AncestorIdList;
  Expected(TptTokenKind.ptRoundClose);
end;

method TmwSimplePasPar.ObjectMemberList;
begin {jdj added TptTokenKind.ptProperty-call to ObjectProperty 02/07/2001}
  ObjectVisibility;
  while TokenID in [TptTokenKind.ptConstructor, TptTokenKind.ptDestructor, TptTokenKind.ptFunction, TptTokenKind.ptIdentifier,
    TptTokenKind.ptProcedure, TptTokenKind.ptProperty] do
  begin
    while TokenID = TptTokenKind.ptIdentifier do
    begin
      ObjectField;
      Semicolon;
      ObjectVisibility;
    end;
    while TokenID in [TptTokenKind.ptConstructor, TptTokenKind.ptDestructor, TptTokenKind.ptFunction, TptTokenKind.ptProcedure, TptTokenKind.ptProperty] do
    begin
      case TokenID of
        TptTokenKind.ptConstructor, TptTokenKind.ptDestructor, TptTokenKind.ptFunction, TptTokenKind.ptProcedure:
        ObjectMethodHeading;
        TptTokenKind.ptProperty:
        ObjectProperty;
      end;
    end;
    ObjectVisibility;
  end;
end;

method TmwSimplePasPar.ObjectVisibility;
begin
  while ExID in [TptTokenKind.ptPrivate, TptTokenKind.ptProtected, TptTokenKind.ptPublic] do
  begin
    Lexer.InitAhead;
    case Lexer.AheadExID of
      TptTokenKind.ptColon, TptTokenKind.ptComma: ;
      else
        case ExID of
          TptTokenKind.ptPrivate:
          begin
            VisibilityPrivate;
          end;
          TptTokenKind.ptProtected:
          begin
            VisibilityProtected;
        end;
          TptTokenKind.ptPublic:
          begin
            VisibilityPublic;
        end;
        end;
    end;
  end;
end;

method TmwSimplePasPar.ObjectField;
begin
  IdentifierList;
  Expected(TptTokenKind.ptColon);
  TypeKind;
  TypeDirective;
end;

method TmwSimplePasPar.ClassReferenceType;
begin
  Expected(TptTokenKind.ptClass);
  Expected(TptTokenKind.ptOf);
  TypeId;
end;

method TmwSimplePasPar.VariantIdentifier;
begin
  case ExID of
    TptTokenKind.ptOleVariant:
    begin
        NextToken;
    end;
    TptTokenKind.ptVariant:
    begin
      NextToken;
    end;
    else
      begin
        SynError(TmwParseError.InvalidVariantIdentifier);
      end;
  end;
end;

method TmwSimplePasPar.ProceduralType;
var
TheTokenID: TptTokenKind;
begin
  case TokenID of
    TptTokenKind.ptFunction:
    begin
      NextToken;
      if TokenID = TptTokenKind.ptRoundOpen then
      begin
        FormalParameterList;
      end;
      Expected(TptTokenKind.ptColon);
      ReturnType;
    end;
    TptTokenKind.ptProcedure:
    begin
      NextToken;
      if TokenID = TptTokenKind.ptRoundOpen then
      begin
        FormalParameterList;
      end;
    end;
    else
      begin
        SynError(TmwParseError.InvalidProceduralType);
      end;
  end;
  if TokenID = TptTokenKind.ptOf then
    ProceduralDirectiveOf;

  Lexer.InitAhead;
  case TokenID of
    TptTokenKind.ptSemiColon: TheTokenID := Lexer.AheadExID;
    else
      TheTokenID := ExID;
  end;
  while TheTokenID in [TptTokenKind.ptAbstract, TptTokenKind.ptCdecl, TptTokenKind.ptDynamic, TptTokenKind.ptExport, TptTokenKind.ptExternal, TptTokenKind.ptFar,
    TptTokenKind.ptMessage, TptTokenKind.ptNear, TptTokenKind.ptOverload, TptTokenKind.ptOverride, TptTokenKind.ptPascal, TptTokenKind.ptRegister,
    TptTokenKind.ptReintroduce, TptTokenKind.ptSafeCall, TptTokenKind.ptStdcall, TptTokenKind.ptVirtual, TptTokenKind.ptStatic, TptTokenKind.ptInline] do
  // DR 2001-11-14 no checking for deprecated etc. since it's captured by the typedecl
  begin
    if TokenID = TptTokenKind.ptSemiColon then Semicolon;
    ProceduralDirective;
    Lexer.InitAhead;
    case TokenID of
      TptTokenKind.ptSemiColon: TheTokenID := Lexer.AheadExID;
      else
        TheTokenID := ExID;
    end;
  end;

    if TokenID = TptTokenKind.ptOf then
      ProceduralDirectiveOf;
  end;

  method TmwSimplePasPar.StringConst;
  begin
    StringConstSimple;
    while TokenID in [TptTokenKind.ptStringConst, TptTokenKind.ptAsciiChar] do
      StringConstSimple;
  end;

  method TmwSimplePasPar.StringConstSimple;
  begin
    NextToken;
  end;

  method TmwSimplePasPar.StringIdentifier;
  begin
    case ExID of
      TptTokenKind.ptAnsiString:
      begin
        NextToken;
    end;
      TptTokenKind.ptShortString:
      begin
        NextToken;
      end;
      TptTokenKind.ptWideString:
      begin
        NextToken;
      end;
      else
        begin
          SynError(TmwParseError.InvalidStringIdentifier);
        end;
    end;
  end;

  method TmwSimplePasPar.StringType;
  begin
    case TokenID of
      TptTokenKind.ptString:
      begin
        NextToken;
        if TokenID = TptTokenKind.ptSquareOpen then
        begin
          NextToken;
          ConstantExpression;
          Expected(TptTokenKind.ptSquareClose);
        end;
    end;
    else
      begin
        VariableReference;
      end;
  end;
end;

method TmwSimplePasPar.PointerSymbol;
begin
  Expected(TptTokenKind.ptPointerSymbol);
end;

method TmwSimplePasPar.PointerType;
begin
  Expected(TptTokenKind.ptPointerSymbol);
  TypeId;
end;

method TmwSimplePasPar.StructuredType;
begin
  case TokenID of
    TptTokenKind.ptArray:
    begin
        ArrayType;
    end;
    TptTokenKind.ptFile:
    begin
      FileType;
    end;
    TptTokenKind.ptRecord:
    begin
      RecordType;
    end;
    TptTokenKind.ptSet:
    begin
      SetType;
    end;
    TptTokenKind.ptObject:
    begin
      ObjectType;
    end
    else
      begin
        SynError(TmwParseError.InvalidStructuredType);
      end;
  end;
end;

method TmwSimplePasPar.SimpleType;
begin
  case TokenID of
    TptTokenKind.ptMinus:
    begin
        NextToken;
    end;
    TptTokenKind.ptPlus:
    begin
      NextToken;
    end;
  end;
  case FLexer.TokenID of
    TptTokenKind.ptAsciiChar, TptTokenKind.ptIntegerConst:
    begin
        OrdinalType;
    end;
    TptTokenKind.ptFloat:
    begin
      RealType;
    end;
    TptTokenKind.ptIdentifier:
    begin
      InitAhead;
      AheadParse.NextToken;
      AheadParse.SimpleExpression;
      if AheadParse.TokenID = TptTokenKind.ptDotDot then
        SubrangeType
      else
        TypeId;
    end;
    else
      begin
        VariableReference;
      end;
  end;
end;

method TmwSimplePasPar.RecordFieldConstant;
begin
  Expected(TptTokenKind.ptIdentifier);
  Expected(TptTokenKind.ptColon);
  TypedConstant;
end;

method TmwSimplePasPar.RecordConstant;
begin
  Expected(TptTokenKind.ptRoundOpen);
  RecordFieldConstant;
  while (TokenID = TptTokenKind.ptSemiColon) do
  begin
    Semicolon;
    if TokenID <> TptTokenKind.ptRoundClose then
      RecordFieldConstant;
  end;
  Expected(TptTokenKind.ptRoundClose);
end;

method TmwSimplePasPar.RecordConstraint;
begin
  Expected(TptTokenKind.ptRecord);
end;

method TmwSimplePasPar.ArrayConstant;
begin
  Expected(TptTokenKind.ptRoundOpen);

  TypedConstant;
  if TokenID = TptTokenKind.ptDotDot then
  begin
    NextToken;
    TypedConstant;
  end;

  while (TokenID = TptTokenKind.ptComma) do
  begin
    NextToken;
    TypedConstant;
    if TokenID = TptTokenKind.ptDotDot then
    begin
      NextToken;
      TypedConstant;
    end;
  end;
  Expected(TptTokenKind.ptRoundClose);
end;

method TmwSimplePasPar.ArrayDimension;
begin
  OrdinalType;
end;

method TmwSimplePasPar.ClassForward;
begin
  Expected(TptTokenKind.ptClass);
end;

method TmwSimplePasPar.DispInterfaceForward;
begin
  Expected(TptTokenKind.ptDispinterface);
end;

method TmwSimplePasPar.DotOp;
begin
  Expected(TptTokenKind.ptPoint);
end;

method TmwSimplePasPar.InterfaceForward;
begin
  Expected(TptTokenKind.ptInterface);
end;

method TmwSimplePasPar.ObjectForward;
begin
  Expected(TptTokenKind.ptObject);
end;

method TmwSimplePasPar.TypeDeclaration;
begin
  TypeName;
  Expected(TptTokenKind.ptEqual);

  Lexer.InitAhead;

  if TokenID = TptTokenKind.ptType then
  begin
    if Lexer.AheadTokenID = TptTokenKind.ptOf then
    begin
      TypeReferenceType;
      TypeDirective;
      Exit;
    end else
      ExplicitType;
  end;

  if (TokenID = TptTokenKind.ptPacked) and (Lexer.AheadTokenID in [TptTokenKind.ptClass, TptTokenKind.ptObject]) then
    NextToken;

  case TokenID of
    TptTokenKind.ptPointerSymbol:
    begin
        PointerType;
    end;
    TptTokenKind.ptClass:
    begin
      case Lexer.AheadTokenID of
        TptTokenKind.ptOf:
        begin
          ClassReferenceType;
        end;
        TptTokenKind.ptSemiColon:
        begin
          ClassForward;
        end;
        else
          begin
            ClassType;
          end;
      end;
    end;
    TptTokenKind.ptInterface:
    begin
      case Lexer.AheadTokenID of
        TptTokenKind.ptSemiColon:
        begin
          InterfaceForward;
        end;
        else
          begin
            InterfaceType;
          end;
      end;
    end;
    TptTokenKind.ptDispinterface:
    begin
      case Lexer.AheadTokenID of
        TptTokenKind.ptSemiColon:
        begin
          DispInterfaceForward;
        end;
        else
          begin
            InterfaceType;
          end;
      end;
    end;
    TptTokenKind.ptObject:
    begin
      case Lexer.AheadTokenID of
        TptTokenKind.ptSemiColon:
        begin
          ObjectForward;
        end;
        else
          begin
            ObjectType;
          end;
      end;
    end;
    else
      begin
        if ExID = TptTokenKind.ptReference then
          AnonymousMethodType
        else
          TypeKind;
      end;
  end;
  TypeDirective;
end;

method TmwSimplePasPar.TypeName;
begin
  Expected(TptTokenKind.ptIdentifier);
  if TokenID = TptTokenKind.ptLower then
    TypeParams;
end;

method TmwSimplePasPar.ExplicitType;
begin
  Expected(TptTokenKind.ptType);
end;

method TmwSimplePasPar.TypeKind;
begin
  case TokenID of
    TptTokenKind.ptAsciiChar, TptTokenKind.ptFloat, TptTokenKind.ptIntegerConst, TptTokenKind.ptMinus, TptTokenKind.ptNil, TptTokenKind.ptPlus, TptTokenKind.ptStringConst, TptTokenKind.ptConst:
    begin
        SimpleType;
    end;
    TptTokenKind.ptRoundOpen:
    begin
      EnumeratedType;
    end;
    TptTokenKind.ptSquareOpen:
    begin
      SubrangeType;
    end;
    TptTokenKind.ptArray, TptTokenKind.ptFile, TptTokenKind.ptPacked, TptTokenKind.ptRecord, TptTokenKind.ptSet:
    begin
      if TokenID = TptTokenKind.ptPacked then
        NextToken;
      StructuredType;
    end;
    TptTokenKind.ptFunction, TptTokenKind.ptProcedure:
    begin
      ProceduralType;
    end;
    TptTokenKind.ptIdentifier:
    begin
      InitAhead;
      AheadParse.NextToken;
      AheadParse.SimpleExpression;
      if AheadParse.TokenID = TptTokenKind.ptDotDot then
        SubrangeType
      else
        TypeId;
    end;
    TptTokenKind.ptPointerSymbol:
    begin
      PointerType;
    end;
    TptTokenKind.ptString:
    begin
      TypeId;
    end;
    else
      begin
        SynError(TmwParseError.InvalidTypeKind);
      end;
  end;
end;

method TmwSimplePasPar.TypeArgs;
begin
  TypeKind;
  while TokenID = TptTokenKind.ptComma do
  begin
    NextToken;
    TypeKind;
  end;
end;

method TmwSimplePasPar.TypedConstant;
var
RoundBrackets: Integer;
begin
  case TokenID of
    TptTokenKind.ptRoundOpen:
    begin
      Lexer.InitAhead;
      while Lexer.AheadTokenID <> TptTokenKind.ptSemiColon do
        case Lexer.AheadTokenID of
          TptTokenKind.ptAnd, TptTokenKind.ptBegin, TptTokenKind.ptCase, TptTokenKind.ptColon, TptTokenKind.ptEnd, TptTokenKind.ptElse, TptTokenKind.ptIf, TptTokenKind.ptMinus, TptTokenKind.ptNull,
          TptTokenKind.ptOr, TptTokenKind.ptPlus, TptTokenKind.ptShl, TptTokenKind.ptShr, TptTokenKind.ptSlash, TptTokenKind.ptStar, TptTokenKind.ptWhile, TptTokenKind.ptWith,
          TptTokenKind.ptXor: Break;
          TptTokenKind.ptRoundOpen:
          begin
            RoundBrackets := 0;
            repeat
              case Lexer.AheadTokenID of
                TptTokenKind.ptBegin, TptTokenKind.ptCase, TptTokenKind.ptEnd, TptTokenKind.ptElse, TptTokenKind.ptIf, TptTokenKind.ptNull, TptTokenKind.ptWhile, TptTokenKind.ptWith: Break;
                else
                  if Lexer.AheadTokenID = TptTokenKind.ptRoundOpen then
                    inc(RoundBrackets);
                  if Lexer.AheadTokenID = TptTokenKind.ptRoundClose then
                    dec(RoundBrackets);

                  Lexer.AheadNext;
              end;
              until RoundBrackets = 0;
          end;
          else
            Lexer.AheadNext;
        end;
      case Lexer.AheadTokenID of
        TptTokenKind.ptColon:
        begin
          RecordConstant;
        end;
        TptTokenKind.ptNull: ;
        TptTokenKind.ptAnd, TptTokenKind.ptMinus, TptTokenKind.ptOr, TptTokenKind.ptPlus, TptTokenKind.ptShl, TptTokenKind.ptShr, TptTokenKind.ptSlash, TptTokenKind.ptStar, TptTokenKind.ptXor:
        begin
          ConstantExpression;
        end;
        else
          begin
            ArrayConstant;
          end;
      end;
    end;
    TptTokenKind.ptSquareOpen:
    ConstantExpression;
    else
      begin
        ConstantExpression;
      end;
  end;
end;

method TmwSimplePasPar.TypeId;
begin
  TypeSimple;

  while TokenID = TptTokenKind.ptPoint do
  begin
    Expected(TptTokenKind.ptPoint);
    TypeSimple;
  end;

  if TokenID = TptTokenKind.ptRoundOpen then
  begin
    Expected(TptTokenKind.ptRoundOpen);
    SimpleExpression;
    Expected(TptTokenKind.ptRoundClose);
  end;
end;

method TmwSimplePasPar.ConstantExpression;
begin
  SimpleExpression;
end;

method TmwSimplePasPar.ResourceDeclaration;
begin
  ConstantName;
  Expected(TptTokenKind.ptEqual);

  ResourceValue;

  TypeDirective;
end;

method TmwSimplePasPar.ResourceValue;
begin
  CharString;
  while TokenID = TptTokenKind.ptPlus do
  begin
    NextToken;
    CharString;
  end;
end;

method TmwSimplePasPar.ConstantDeclaration;
begin
  ConstantName;
  case TokenID of
    TptTokenKind.ptEqual:
    begin
        ConstantEqual;
    end;
    TptTokenKind.ptColon:
    begin
      ConstantColon;
    end;
    else
      begin
        SynError(TmwParseError.InvalidConstantDeclaration);
      end;
  end;
  TypeDirective;
end;

method TmwSimplePasPar.ConstantColon;
begin
  Expected(TptTokenKind.ptColon);
  ConstantType;
  Expected(TptTokenKind.ptEqual);
  ConstantValueTyped;
end;

method TmwSimplePasPar.ConstantEqual;
begin
  Expected(TptTokenKind.ptEqual);
  ConstantValue;
end;

method TmwSimplePasPar.ConstantValue;
begin
  Expression;
end;

method TmwSimplePasPar.ConstantValueTyped;
begin
  TypedConstant;
end;

method TmwSimplePasPar.ConstantName;
begin
  Expected(TptTokenKind.ptIdentifier);
end;

method TmwSimplePasPar.ConstantType;
begin
  TypeKind;
end;

method TmwSimplePasPar.LabelId;
begin
  case TokenID of
    TptTokenKind.ptIntegerConst:
    begin
        NextToken;
    end;
    TptTokenKind.ptIdentifier:
    begin
      NextToken;
    end;
    else
      begin
        SynError(TmwParseError.InvalidLabelId);
      end;
  end;
end;

method TmwSimplePasPar.ProcedureDeclarationSection;
begin
  if TokenID = TptTokenKind.ptClass then
  begin
    ClassMethod;
  end;
  case TokenID of
    TptTokenKind.ptConstructor:
    begin
        ProcedureProcedureName;
    end;
    TptTokenKind.ptDestructor:
    begin
      ProcedureProcedureName;
    end;
    TptTokenKind.ptProcedure:
    begin
      ProcedureProcedureName;
    end;
    TptTokenKind.ptFunction:
    begin
      FunctionMethodDeclaration;
    end;
    TptTokenKind.ptIdentifier:
    begin
      if Lexer.ExID = TptTokenKind.ptOperator then
      begin
        FunctionMethodDeclaration;
      end
      else
        SynError(TmwParseError.InvalidProcedureDeclarationSection);
    end;
    else
      begin
        SynError(TmwParseError.InvalidProcedureDeclarationSection);
      end;
  end;
end;

method TmwSimplePasPar.LabelDeclarationSection;
begin
  Expected(TptTokenKind.ptLabel);
  LabelId;
  while (TokenID = TptTokenKind.ptComma) do
  begin
    NextToken;
    LabelId;
  end;
  Semicolon;
end;

method TmwSimplePasPar.ProceduralDirective;
begin
  case GenID of
    TptTokenKind.ptAbstract:
    begin
        DirectiveBinding;
    end;
    TptTokenKind.ptCdecl, TptTokenKind.ptPascal, TptTokenKind.ptRegister, TptTokenKind.ptSafeCall, TptTokenKind.ptStdcall:
    begin
      DirectiveCalling;
    end;
    TptTokenKind.ptExport, TptTokenKind.ptFar, TptTokenKind.ptNear:
    begin
      Directive16Bit;
    end;
    TptTokenKind.ptExternal:
    begin
      ExternalDirective;
    end;
    TptTokenKind.ptDynamic, TptTokenKind.ptMessage, TptTokenKind.ptOverload, TptTokenKind.ptOverride, TptTokenKind.ptReintroduce, TptTokenKind.ptVirtual:
    begin
      DirectiveBinding;
    end;
    TptTokenKind.ptAssembler:
    begin
      NextToken;
    end;
    TptTokenKind.ptStatic:
    begin
      NextToken;
    end;
    TptTokenKind.ptInline:
    begin
      DirectiveInline;
    end;
    TptTokenKind.ptDeprecated:
    DirectiveDeprecated;
    TptTokenKind.ptLibrary:
    DirectiveLibrary;
    TptTokenKind.ptPlatform:
    DirectivePlatform;
    TptTokenKind.ptLocal:
    DirectiveLocal;
    TptTokenKind.ptVarargs:
    DirectiveVarargs;
    TptTokenKind.ptFinal, TptTokenKind.ptExperimental, TptTokenKind.ptDelayed:
    NextToken;
    else
      begin
        SynError(TmwParseError.InvalidProceduralDirective);
      end;
  end;
end;

method TmwSimplePasPar.ExportedHeading;
begin
  case TokenID of
    TptTokenKind.ptFunction:
    begin
        FunctionHeading;
    end;
    TptTokenKind.ptProcedure:
    begin
      ProcedureHeading;
    end;
    else
      begin
        SynError(TmwParseError.InvalidExportedHeading);
      end;
  end;
  if TokenID = TptTokenKind.ptSemiColon then Semicolon;

  //TODO: Add FINAL
  while ExID in [TptTokenKind.ptAbstract, TptTokenKind.ptCdecl, TptTokenKind.ptDynamic, TptTokenKind.ptExport, TptTokenKind.ptExternal, TptTokenKind.ptFar,
    TptTokenKind.ptMessage, TptTokenKind.ptNear, TptTokenKind.ptOverload, TptTokenKind.ptOverride, TptTokenKind.ptPascal, TptTokenKind.ptRegister,
    TptTokenKind.ptReintroduce, TptTokenKind.ptSafeCall, TptTokenKind.ptStdcall, TptTokenKind.ptVirtual,
    TptTokenKind.ptDeprecated, TptTokenKind.ptLibrary, TptTokenKind.ptPlatform, TptTokenKind.ptLocal, TptTokenKind.ptVarargs,
    TptTokenKind.ptStatic, TptTokenKind.ptInline, TptTokenKind.ptAssembler, TptTokenKind.ptForward, TptTokenKind.ptDelayed] do
  begin
    case ExID of
      TptTokenKind.ptAssembler: NextToken;
      TptTokenKind.ptForward: ForwardDeclaration;
      else
        ProceduralDirective;
    end;
    if TokenID = TptTokenKind.ptSemiColon then Semicolon;
  end;
end;

method TmwSimplePasPar.FunctionHeading;
begin
  Expected(TptTokenKind.ptFunction);
  FunctionProcedureName;
  if TokenID = TptTokenKind.ptRoundOpen then
  begin
    FormalParameterList;
  end;
  if TokenID = TptTokenKind.ptColon then
  begin
    Expected(TptTokenKind.ptColon);
    ReturnType;
  end;
end;

method TmwSimplePasPar.ProcedureHeading;
begin
  Expected(TptTokenKind.ptProcedure);
  FunctionProcedureName;
  if TokenID = TptTokenKind.ptRoundOpen then
  begin
    FormalParameterList;
  end;
end;

method TmwSimplePasPar.VarSection;
begin
  case TokenID of
    TptTokenKind.ptThreadvar:
    begin
        NextToken;
    end;
    TptTokenKind.ptVar:
    begin
      NextToken;
    end;
    else
      begin
        SynError(TmwParseError.InvalidVarSection);
      end;
  end;
  while TokenID in [TptTokenKind.ptIdentifier, TptTokenKind.ptSquareOpen] do
  begin
    if TokenID = TptTokenKind.ptSquareOpen then
      CustomAttribute
    else
    begin
      VarDeclaration;
      Semicolon;
    end;
  end;
  end;

  method TmwSimplePasPar.TypeSection;
  begin
    Expected(TptTokenKind.ptType);

    while (TokenID = TptTokenKind.ptIdentifier) or (Lexer.TokenID = TptTokenKind.ptSquareOpen) do
    begin
      if TokenID = TptTokenKind.ptSquareOpen then
        CustomAttribute
      else
      begin
        InitAhead;
        AheadParse.NextToken;
        if AheadParse.TokenID = TptTokenKind.ptLower then
          AheadParse.TypeParams;

        if AheadParse.TokenID <> TptTokenKind.ptEqual then
          Break;

        TypeDeclaration;
        if TokenID = TptTokenKind.ptEqual then
          TypedConstant;
        Semicolon;
      end;
    end;
  end;

  method TmwSimplePasPar.TypeSimple;
  begin
    case GenID of
      TptTokenKind.ptBoolean, TptTokenKind.ptByte, TptTokenKind.ptChar, TptTokenKind.ptDWORD, TptTokenKind.ptInt64, TptTokenKind.ptInteger, TptTokenKind.ptLongint,
      TptTokenKind.ptLongword, TptTokenKind.ptPChar, TptTokenKind.ptShortint, TptTokenKind.ptSmallint, TptTokenKind.ptWideChar, TptTokenKind.ptWord:
      begin
        OrdinalIdentifier;
    end;
      TptTokenKind.ptComp, TptTokenKind.ptCurrency, TptTokenKind.ptDouble, TptTokenKind.ptExtended, TptTokenKind.ptReal, TptTokenKind.ptReal48, TptTokenKind.ptSingle:
      begin
        RealIdentifier;
      end;
      TptTokenKind.ptAnsiString, TptTokenKind.ptShortString, TptTokenKind.ptWideString:
      begin
        StringIdentifier;
      end;
      TptTokenKind.ptOleVariant, TptTokenKind.ptVariant:
      begin
        VariantIdentifier;
      end;
      TptTokenKind.ptString:
      begin
        StringType;
      end;
      TptTokenKind.ptFile:
      begin
        FileType;
      end;
      TptTokenKind.ptArray:
      begin
        NextToken;
        Expected(TptTokenKind.ptOf);
        case TokenID of
          TptTokenKind.ptConst: (*new in ObjectPascal80*)
          begin
            NextToken;
          end;
          else
            begin
              TypeId;
            end;
        end;
      end;
      else
        Expected(TptTokenKind.ptIdentifier);
    end;

    if TokenID = TptTokenKind.ptLower then
    begin
      Expected(TptTokenKind.ptLower);
      TypeArgs;
      Expected(TptTokenKind.ptGreater);
    end;
  end;

  method TmwSimplePasPar.TypeParamDecl;
  begin
    TypeParamList;
    if TokenID = TptTokenKind.ptColon then
    begin
      NextToken;
      ConstraintList;
    end;
  end;

  method TmwSimplePasPar.TypeParamDeclList;
  begin
    TypeParamDecl;
    while TokenID = TptTokenKind.ptSemiColon do
    begin
      NextToken;
      TypeParamDecl;
    end;
  end;

  method TmwSimplePasPar.TypeParamList;
  begin
    if TokenID = TptTokenKind.ptSquareOpen then
      AttributeSection;
    TypeSimple;
    while TokenID = TptTokenKind.ptComma do
    begin
      NextToken;
      if TokenID = TptTokenKind.ptSquareOpen then
        AttributeSection;
      TypeSimple;
    end;
  end;

  method TmwSimplePasPar.TypeParams;
  begin
    Expected(TptTokenKind.ptLower);
    TypeParamDeclList;
  // workaround for TSomeClass< T >= class(TObject)
    if TokenID = TptTokenKind.ptGreaterEqual then
      Lexer.RunPos := Lexer.RunPos - 1
    else
      Expected(TptTokenKind.ptGreater);
  end;

  method TmwSimplePasPar.TypeReferenceType;
  begin
    Expected(TptTokenKind.ptType);
    Expected(TptTokenKind.ptOf);
    TypeId;
  end;

  method TmwSimplePasPar.ConstSection;
  begin
    case TokenID of
      TptTokenKind.ptConst:
      begin
        NextToken;
        while TokenID in [TptTokenKind.ptIdentifier, TptTokenKind.ptSquareOpen] do
        begin
          if TokenID = TptTokenKind.ptSquareOpen then
            CustomAttribute
          else
          begin
            ConstantDeclaration;
            Semicolon;
          end;
        end;
    end;
    TptTokenKind.ptResourcestring:
    begin
        NextToken;
        while (TokenID = TptTokenKind.ptIdentifier) do
        begin
          ResourceDeclaration;
          Semicolon;
        end;
    end
    else
      begin
        SynError(TmwParseError.InvalidConstSection);
      end;
  end;
end;

method TmwSimplePasPar.InterfaceDeclaration;
begin
  case TokenID of
    TptTokenKind.ptConst:
    begin
        ConstSection;
    end;
    TptTokenKind.ptFunction:
    begin
      ExportedHeading;
    end;
    TptTokenKind.ptProcedure:
    begin
      ExportedHeading;
    end;
    TptTokenKind.ptResourcestring:
    begin
      ConstSection;
    end;
    TptTokenKind.ptType:
    begin
      TypeSection;
    end;
    TptTokenKind.ptThreadvar:
    begin
      VarSection;
    end;
    TptTokenKind.ptVar:
    begin
      VarSection;
    end;
    TptTokenKind.ptExports:
    begin
      ExportsClause;
    end;
    TptTokenKind.ptSquareOpen:
    begin
      CustomAttribute;
    end;
    else
      begin
        SynError(TmwParseError.InvalidInterfaceDeclaration);
      end;
  end;
end;

method TmwSimplePasPar.ExportsElement;
begin
  ExportsName;
  if TokenID = TptTokenKind.ptRoundOpen then
  begin
    FormalParameterList;
  end;

  if FLexer.ExID = TptTokenKind.ptIndex then
  begin
    NextToken;
    Expected(TptTokenKind.ptIntegerConst);
  end;
  if FLexer.ExID = TptTokenKind.ptName then
  begin
    NextToken;
    SimpleExpression;
  end;
  if FLexer.ExID = TptTokenKind.ptResident then
  begin
    NextToken;
  end;
end;

method TmwSimplePasPar.CompoundStatement;
begin
  Expected(TptTokenKind.ptBegin);
  Statements;
  Expected(TptTokenKind.ptEnd);
end;

method TmwSimplePasPar.ExportsClause;
begin
  Expected(TptTokenKind.ptExports);
  ExportsElement;
  while TokenID = TptTokenKind.ptComma do
  begin
    NextToken;
    ExportsElement;
  end;
  Semicolon;
end;

method TmwSimplePasPar.ContainsClause;
begin
  ExpectedEx(TptTokenKind.ptContains);
  MainUsedUnitStatement;
  while TokenID = TptTokenKind.ptComma do
  begin
    NextToken;
    MainUsedUnitStatement;
  end;
  Semicolon;
end;

method TmwSimplePasPar.RequiresClause;
begin
  ExpectedEx(TptTokenKind.ptRequires);
  RequiresIdentifier;
  while TokenID = TptTokenKind.ptComma do
  begin
    NextToken;
    RequiresIdentifier;
  end;
  Semicolon;
end;

method TmwSimplePasPar.RequiresIdentifier;
begin
  RequiresIdentifierId;
  while Lexer.TokenID = TptTokenKind.ptPoint do
  begin
    NextToken;
    RequiresIdentifierId;
  end;
end;

method TmwSimplePasPar.RequiresIdentifierId;
begin
  Expected(TptTokenKind.ptIdentifier);
end;

method TmwSimplePasPar.InitializationSection;
begin
  Expected(TptTokenKind.ptInitialization);
  StatementList;
end;

method TmwSimplePasPar.ImplementationSection;
begin
  Expected(TptTokenKind.ptImplementation);
  if TokenID = TptTokenKind.ptUses then
  begin
    UsesClause;
  end;
  while TokenID in [TptTokenKind.ptClass, TptTokenKind.ptConst, TptTokenKind.ptConstructor, TptTokenKind.ptDestructor, TptTokenKind.ptFunction,
    TptTokenKind.ptLabel, TptTokenKind.ptProcedure, TptTokenKind.ptResourcestring, TptTokenKind.ptThreadvar, TptTokenKind.ptType, TptTokenKind.ptVar,
    TptTokenKind.ptExports, TptTokenKind.ptSquareOpen] do
  begin
    DeclarationSection;
  end;
end;

method TmwSimplePasPar.InterfaceSection;
begin
  Expected(TptTokenKind.ptInterface);
  if TokenID = TptTokenKind.ptUses then
  begin
    UsesClause;
  end;
  while TokenID in [TptTokenKind.ptConst, TptTokenKind.ptFunction, TptTokenKind.ptResourcestring, TptTokenKind.ptProcedure,
    TptTokenKind.ptThreadvar, TptTokenKind.ptType, TptTokenKind.ptVar, TptTokenKind.ptExports, TptTokenKind.ptSquareOpen] do
  begin
    InterfaceDeclaration;
  end;
end;

method TmwSimplePasPar.IdentifierList;
begin
  Identifier;
  while TokenID = TptTokenKind.ptComma do
  begin
    NextToken;
    Identifier;
  end;
end;

method TmwSimplePasPar.CharString;
begin
  case GenID of
    TptTokenKind.ptAsciiChar, TptTokenKind.ptIdentifier, TptTokenKind.ptRoundOpen, TptTokenKind.ptStringConst:
    while GenID in
    [TptTokenKind.ptAsciiChar, TptTokenKind.ptIdentifier, TptTokenKind.ptRoundOpen, TptTokenKind.ptStringConst, TptTokenKind.ptString] do
    begin
      case TokenID of
        TptTokenKind.ptIdentifier, TptTokenKind.ptRoundOpen:
        begin
          if ExID in [TptTokenKind.ptIndex] then
            Break;
          VariableReference;
        end;
        TptTokenKind.ptString:
        begin
          StringStatement;
          Statement;
        end;
        else
          StringConst;
      end;
//        if Lexer.TokenID = TptTokenKind.ptPoint then
//        begin
//          NextToken;
//          VariableReference;
//        end;
    end;
    else
      begin
        SynError(TmwParseError.InvalidCharString);
      end;
  end;
end;

method TmwSimplePasPar.IncludeFile;
begin
  while TokenID <> TptTokenKind.ptNull do
    case TokenID of
      TptTokenKind.ptClass:
      begin
          ProcedureDeclarationSection;
      end;
      TptTokenKind.ptConst:
      begin
        ConstSection;
      end;
      TptTokenKind.ptConstructor:
      begin
        ProcedureDeclarationSection;
      end;
      TptTokenKind.ptDestructor:
      begin
        ProcedureDeclarationSection;
      end;
      TptTokenKind.ptExports:
      begin
        ExportsClause;
      end;
      TptTokenKind.ptFunction:
      begin
        ProcedureDeclarationSection;
      end;
      TptTokenKind.ptIdentifier:
      begin
        Statements;
      end;
      TptTokenKind.ptLabel:
      begin
        LabelDeclarationSection;
      end;
      TptTokenKind.ptProcedure:
      begin
        ProcedureDeclarationSection;
      end;
      TptTokenKind.ptResourcestring:
      begin
        ConstSection;
      end;
      TptTokenKind.ptType:
      begin
        TypeSection;
      end;
      TptTokenKind.ptThreadvar:
      begin
        VarSection;
      end;
      TptTokenKind.ptVar:
      begin
        VarSection;
      end;
      else
        begin
          NextToken;
        end;
    end;
end;

method TmwSimplePasPar.SkipSpace;
begin
  Expected(TptTokenKind.ptSpace);
  while TokenID in [TptTokenKind.ptSpace] do
    Lexer.Next;
end;

method TmwSimplePasPar.SkipCRLFco;
begin
  Expected(TptTokenKind.ptCRLFCo);
  while TokenID in [TptTokenKind.ptCRLFCo] do
    Lexer.Next;
end;

method TmwSimplePasPar.SkipCRLF;
begin
  Expected(TptTokenKind.ptCRLF);
  while TokenID in [TptTokenKind.ptCRLF] do
    Lexer.Next;
end;

method TmwSimplePasPar.ClassClass;
begin
  Expected(TptTokenKind.ptClass);
end;

method TmwSimplePasPar.ClassConstraint;
begin
  Expected(TptTokenKind.ptClass);
end;

method TmwSimplePasPar.PropertyDefault;
begin
  ExpectedEx(TptTokenKind.ptDefault);
end;

method TmwSimplePasPar.DispIDSpecifier;
begin
  ExpectedEx(TptTokenKind.ptDispid);
  ConstantExpression;
end;

method TmwSimplePasPar.IndexOp;
begin
  Expected(TptTokenKind.ptSquareOpen);
  Expression;
  while TokenID = TptTokenKind.ptComma do
  begin
    NextToken;
    Expression;
  end;
  Expected(TptTokenKind.ptSquareClose);
end;

method TmwSimplePasPar.IndexSpecifier;
begin
  ExpectedEx(TptTokenKind.ptIndex);
  ConstantExpression;
end;

method TmwSimplePasPar.ClassTypeEnd;
begin
  case ExID of
    TptTokenKind.ptExperimental: NextToken;
    TptTokenKind.ptDeprecated: DirectiveDeprecated;
  end;
end;

method TmwSimplePasPar.ObjectTypeEnd;
begin
end;

method TmwSimplePasPar.DirectiveDeprecated;
begin
  ExpectedEx(TptTokenKind.ptDeprecated);
  if TokenID = TptTokenKind.ptStringConst then
    NextToken;
end;

method TmwSimplePasPar.DirectiveInline;
begin
  Expected(TptTokenKind.ptInline);
end;

method TmwSimplePasPar.DirectiveLibrary;
begin
  Expected(TptTokenKind.ptLibrary);
end;

method TmwSimplePasPar.DirectivePlatform;
begin
  ExpectedEx(TptTokenKind.ptPlatform);
end;

method TmwSimplePasPar.EnumeratedTypeItem;
begin
  QualifiedIdentifier;
  if TokenID = TptTokenKind.ptEqual then
  begin
    Expected(TptTokenKind.ptEqual);
    ConstantExpression;
  end;
end;

method TmwSimplePasPar.Identifier;
begin
  NextToken;
end;

method TmwSimplePasPar.DirectiveLocal;
begin
  ExpectedEx(TptTokenKind.ptLocal);
end;

method TmwSimplePasPar.DirectiveVarargs;
begin
  ExpectedEx(TptTokenKind.ptVarargs);
end;

method TmwSimplePasPar.AncestorId;
begin
  TypeId;
end;

method TmwSimplePasPar.AncestorIdList;
begin
  AncestorId;
  while(TokenID = TptTokenKind.ptComma) do
  begin
    NextToken;
    AncestorId;
  end;
end;

method TmwSimplePasPar.AnonymousMethod;
begin
  case TokenID of
    TptTokenKind.ptFunction:
    begin
        NextToken;
        if TokenID = TptTokenKind.ptRoundOpen then
          FormalParameterList;
        Expected(TptTokenKind.ptColon);
        ReturnType;
    end;
    TptTokenKind.ptProcedure:
    begin
        NextToken;
        if TokenID = TptTokenKind.ptRoundOpen then
          FormalParameterList;
    end;
  end;
  Block;
end;

method TmwSimplePasPar.AnonymousMethodType;
begin
  ExpectedEx(TptTokenKind.ptReference);
  Expected(TptTokenKind.ptTo);
  case TokenID of
    TptTokenKind.ptProcedure:
    begin
        NextToken;
        if TokenID = TptTokenKind.ptRoundOpen then
          FormalParameterList;
    end;
    TptTokenKind.ptFunction:
    begin
        NextToken;
        if TokenID = TptTokenKind.ptRoundOpen then
          FormalParameterList;
        Expected(TptTokenKind.ptColon);
        ReturnType;
    end;
  end;
end;

method TmwSimplePasPar.AddDefine(const ADefine: string);
begin
  FLexer.AddDefine(ADefine);
end;

method TmwSimplePasPar.RemoveDefine(const ADefine: string);
begin
  FLexer.RemoveDefine(ADefine);
end;

method TmwSimplePasPar.IsDefined(const ADefine: string): Boolean;
begin
  Result := FLexer.IsDefined(ADefine);
end;

method TmwSimplePasPar.ExportsNameId;
begin
  Expected(TptTokenKind.ptIdentifier);
end;

method TmwSimplePasPar.ExportsName;
begin
  ExportsNameId;
  while FLexer.TokenID = TptTokenKind.ptPoint do
  begin
    NextToken;
    ExportsNameId;
  end;
end;

method TmwSimplePasPar.ImplementsSpecifier;
begin
  ExpectedEx(TptTokenKind.ptImplements);

  TypeId;
  while (TokenID = TptTokenKind.ptComma) do
  begin
    NextToken;
    TypeId;
  end;
end;

method TmwSimplePasPar.AttributeArgumentName;
begin
  Expected(TptTokenKind.ptIdentifier);
end;

method TmwSimplePasPar.CaseLabelList;
begin
  CaseLabel;
  while TokenID = TptTokenKind.ptComma do
  begin
    NextToken;
    CaseLabel;
  end;
end;

method TmwSimplePasPar.ArrayBounds;
begin
  if TokenID = TptTokenKind.ptSquareOpen then
  begin
    NextToken;
    ArrayDimension;
    while TokenID = TptTokenKind.ptComma do
    begin
      NextToken;
      ArrayDimension;
    end;
    Expected(TptTokenKind.ptSquareClose);
  end;
end;

method TmwSimplePasPar.DeclarationSections;
begin
  while TokenID in [TptTokenKind.ptClass, TptTokenKind.ptConst, TptTokenKind.ptConstructor, TptTokenKind.ptDestructor, TptTokenKind.ptExports, TptTokenKind.ptFunction, TptTokenKind.ptLabel, TptTokenKind.ptProcedure, TptTokenKind.ptResourcestring, TptTokenKind.ptThreadvar, TptTokenKind.ptType, TptTokenKind.ptVar, TptTokenKind.ptSquareOpen] do
  begin
    DeclarationSection;
  end;
end;

method TmwSimplePasPar.ProceduralDirectiveOf;
begin
  NextToken;
  Expected(TptTokenKind.ptObject);
end;

method TmwSimplePasPar.TypeDirective;
begin
  while GenID in [TptTokenKind.ptDeprecated, TptTokenKind.ptLibrary, TptTokenKind.ptPlatform, TptTokenKind.ptExperimental] do
    case GenID of
      TptTokenKind.ptDeprecated:   DirectiveDeprecated;
      TptTokenKind.ptLibrary:      DirectiveLibrary;
      TptTokenKind.ptPlatform:     DirectivePlatform;
      TptTokenKind.ptExperimental: NextToken;
    end;
end;

method TmwSimplePasPar.InheritedVariableReference;
begin
  Expected(TptTokenKind.ptInherited);
  if TokenID = TptTokenKind.ptIdentifier then
    VariableReference;
end;

method TmwSimplePasPar.ClearDefines;
begin
  FLexer.ClearDefines;
end;

method TmwSimplePasPar.InitAhead;
begin
  if AheadParse = nil then
    AheadParse := new TmwSimplePasPar(Compiler);
  AheadParse.Lexer.InitFrom(Lexer);
end;

method TmwSimplePasPar.InitDefinesDefinedByCompiler;
begin
  FLexer.InitDefinesDefinedByCompiler;
end;

method TmwSimplePasPar.GlobalAttributes;
begin
  GlobalAttributeSections;
end;

method TmwSimplePasPar.GlobalAttributeSections;
begin
  while TokenID = TptTokenKind.ptSquareOpen do
    GlobalAttributeSection;
end;

method TmwSimplePasPar.GlobalAttributeSection;
begin
  Expected(TptTokenKind.ptSquareOpen);
  GlobalAttributeTargetSpecifier;
  AttributeList;
  while TokenID = TptTokenKind.ptComma do
  begin
    Expected(TptTokenKind.ptComma);
    GlobalAttributeTargetSpecifier;
    AttributeList;
  end;
  Expected(TptTokenKind.ptSquareClose);
end;

method TmwSimplePasPar.GlobalAttributeTargetSpecifier;
begin
  GlobalAttributeTarget;
  Expected(TptTokenKind.ptColon);
end;

method TmwSimplePasPar.GlobalAttributeTarget;
begin
  Expected(TptTokenKind.ptIdentifier);
end;

method TmwSimplePasPar.Attributes;
begin
  AttributeSections;
end;

method TmwSimplePasPar.AttributeSections;
begin
  while TokenID = TptTokenKind.ptSquareOpen do
    AttributeSection;
end;

method TmwSimplePasPar.AttributeSection;
begin
  Expected(TptTokenKind.ptSquareOpen);
  Lexer.InitAhead;
  if Lexer.AheadTokenID = TptTokenKind.ptColon then
    AttributeTargetSpecifier;
  AttributeList;
  while TokenID = TptTokenKind.ptComma do
  begin
    Lexer.InitAhead;
    if Lexer.AheadTokenID = TptTokenKind.ptColon then
      AttributeTargetSpecifier;
    AttributeList;
  end;
  Expected(TptTokenKind.ptSquareClose);
end;

method TmwSimplePasPar.AttributeTargetSpecifier;
begin
  AttributeTarget;
  Expected(TptTokenKind.ptColon);
end;

method TmwSimplePasPar.AttributeTarget;
begin
  case TokenID of
    TptTokenKind.ptProperty:
    Expected(TptTokenKind.ptProperty);
    TptTokenKind.ptType:
    Expected(TptTokenKind.ptType);
    else
      Expected(TptTokenKind.ptIdentifier);
  end;
end;

method TmwSimplePasPar.AttributeList;
begin
  Attribute;
  while TokenID = TptTokenKind.ptComma do
  begin
    Expected(TptTokenKind.ptComma);
    AttributeList;
  end;
end;

method TmwSimplePasPar.Attribute;
begin
  AttributeName;
  if TokenID = TptTokenKind.ptRoundOpen then
    AttributeArguments;
end;

method TmwSimplePasPar.AttributeName;
begin
  case TokenID of
    TptTokenKind.ptIn, TptTokenKind.ptOut, TptTokenKind.ptConst, TptTokenKind.ptVar, TptTokenKind.ptUnsafe, TptTokenKind.ptStringConst:
    NextToken;
    else
      begin
        Expected(TptTokenKind.ptIdentifier);
        while TokenID = TptTokenKind.ptPoint do
        begin
          NextToken;
          Expected(TptTokenKind.ptIdentifier);
        end;
      end;
  end;
end;

method TmwSimplePasPar.AttributeArguments;
begin
  Expected(TptTokenKind.ptRoundOpen);
  if TokenID <> TptTokenKind.ptRoundClose then
  begin
    Lexer.InitAhead;
    if Lexer.AheadTokenID = TptTokenKind.ptEqual then
      NamedArgumentList
    else
      PositionalArgumentList;
    if Lexer.TokenID = TptTokenKind.ptEqual then
      NamedArgumentList;
  end;
  Expected(TptTokenKind.ptRoundClose);
end;

method TmwSimplePasPar.PositionalArgumentList;
begin
  PositionalArgument;
  while TokenID = TptTokenKind.ptComma do
  begin
    Expected(TptTokenKind.ptComma);
    PositionalArgument;
  end;
end;

method TmwSimplePasPar.PositionalArgument;
begin
  AttributeArgumentExpression;
end;

method TmwSimplePasPar.NamedArgumentList;
begin
  NamedArgument;
  while TokenID = TptTokenKind.ptComma do
  begin
    Expected(TptTokenKind.ptComma);
    NamedArgument;
  end;
end;

method TmwSimplePasPar.NamedArgument;
begin
  AttributeArgumentName;
  Expected(TptTokenKind.ptEqual);
  AttributeArgumentExpression;
end;

method TmwSimplePasPar.AttributeArgumentExpression;
begin
  Expression;
end;

method TmwSimplePasPar.CustomAttribute;
begin
  //TODO: Global vs. Local attributes
  AttributeSections;
end;



end.