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
unit PascalParser;

interface

type

  TStringEvent = public block(var s: String);

  TPasLexer = public class
  private

    FLexer: TmwPasLex;
    FOnHandleString: TStringEvent;
    method GetToken: not nullable String; inline;
    method GetPosXY: TTokenPoint; inline;
    method GetFileName: not nullable String;

  public
    constructor (const ALexer: TmwPasLex; AOnHandleString: TStringEvent);
    property FileName: not nullable String read GetFileName;
    property PosXY: TTokenPoint read GetPosXY;
    property Token: not nullable String read GetToken;

  end;

  TNodeStack = public class
    strict private
    FLexer: TPasLexer;
    FStack: Stack<TSyntaxNode>;

    method GetCount: Integer;
  public
    constructor (Lexer: TPasLexer);


    method AddChild(Typ: TSyntaxNodeType): TSyntaxNode;
    method AddChild(Node: TSyntaxNode): TSyntaxNode;
    method AddValuedChild(Typ: TSyntaxNodeType; const Value: not nullable String): TSyntaxNode;

    method Clear;
    method Peek: TSyntaxNode;
    method Pop: TSyntaxNode;

    method Push(Typ: TSyntaxNodeType): TSyntaxNode;
    method Push(Node: TSyntaxNode): TSyntaxNode;
    method PushCompoundSyntaxNode(Typ: TSyntaxNodeType): TSyntaxNode;
    method PushValuedNode(Typ: TSyntaxNodeType; const Value: not nullable String): TSyntaxNode;

    property Count: Integer read GetCount;
  end;

  TPasSyntaxTreeBuilder = public class(TmwSimplePasPar)
  private

type
    TTreeBuilderMethod = block ();//method of object;
  private
    method BuildExpressionTree(ExpressionMethod: TTreeBuilderMethod);
    method BuildParametersList(ParametersListMethod: TTreeBuilderMethod);
    method ParserMessage(Sender: Object; const Typ: TMessageEventType; const Msg: String; X, Y: Integer);
    method NodeListToString(NamesNode: TSyntaxNode): not nullable String;
    method MoveMembersToVisibilityNodes(TypeNode: TSyntaxNode);
    method CallInheritedConstantExpression;
    method CallInheritedExpression;
    method CallInheritedFormalParameterList;
    method CallInheritedPropertyParameterList;
    method SetCurrentCompoundNodesEndPosition;
    method DoOnComment(Sender: Object; const Text: String);
    method DoHandleString(var s: not nullable String); //inline;
    method GetMainSection(Node: TSyntaxNode): TSyntaxNode;
  protected
    FStack: TNodeStack;
    FComments: List<TCommentNode>;
    FLexer: TPasLexer;
    FOnHandleString: TStringEvent;

    method AccessSpecifier; override;
    method AdditiveOperator; override;
    method AddressOp; override;
    method AlignmentParameter; override;
    method AnonymousMethod; override;
    method AnonymousMethodType; override;
    method AnonymousMethodTypeFunction; override;
    method AnonymousMethodTypeProcedure; override;
    method ArrayBounds; override;
    method ArrayConstant; override;
    method ArrayDimension; override;
    method ArrayOfConst; override;
    method AsmFragment; override;
    method AsmLabelAt; override;
    method AsmStatement; override;
    method AsmStatements; override;
    method AsOp; override;
    method AssignOp; override;
    method AtExpression; override;
    method CaseElseStatement; override;
    method CaseLabel; override;
    method CaseLabelList; override;
    method CaseSelector; override;
    method CaseStatement; override;
    method ClassClass; override;
    method ClassConstraint; override;
    method ClassField; override;
    method ClassForward; override;
    method ClassFunctionHeading; override;
    method ClassHelper; override;
    method ClassMethod; override;
    method ClassMethodResolution; override;
    method ClassMethodHeading; override;
    method ClassProcedureHeading; override;
    method ClassProperty; override;
    method ClassReferenceType; override;
    method ClassType; override;
    method CompilerDirective; override;
    method CompoundStatement; override;
    method ConstParameter; override;
    method ConstantDeclaration; override;
    method ConstantExpression; override;
    method ConstantName; override;
    method ConstraintList; override;
    method ConstSection; override;
    method ConstantValue; override;
    method ConstantValueTyped; override;
    method ConstructorConstraint; override;
    method ConstructorName; override;
    method ContainsClause; override;
    method DestructorName; override;
    method DirectiveAbstract; override;
    method DirectiveBinding; override;
    method DirectiveBindingMessage; override;
    method DirectiveCalling; override;
    method DirectiveDeprecated; override;
    method DirectiveExperimental; override;
    method DirectiveInline; override;
    method DirectiveLibrary; override;
    method DirectivePlatform; override;
    method DirectiveSealed; override;
    method DirectiveVarargs; override;
    method DispInterfaceForward; override;
    method DoubleAddressOp; override;
    method DotOp; override;
    method ElseStatement; override;
    method EmptyStatement; override;
    method EnumeratedType; override;
    method ExceptBlock; override;
    method ExceptionBlockElseBranch; override;
    method ExceptionHandler; override;
    method ExceptionVariable; override;
    method ExplicitType; override;
    method ExportedHeading; override;
    method ExportsClause; override;
    method ExportsElement; override;
    method ExportsName; override;
    method ExportsNameId; override;
    method Expression; override;
    method ExpressionList; override;
    method ExternalDirective; override;
    method ExternalDependency; override;
    method FieldList; override;
    method FieldName; override;
    method FinalizationSection; override;
    method FinallyBlock; override;
    method FormalParameterList; override;
    method ForStatement; override;
    method ForStatementDownTo; override;
    method ForStatementFrom; override;
    method ForStatementIn; override;
    method ForStatementTo; override;
    method ForwardDeclaration; override;
    method FunctionHeading; override;
    method FunctionMethodName; override;
    method FunctionProcedureName; override;
    method GotoStatement; override;
    method IfStatement; override;
    method Identifier; override;
    method ImplementationSection; override;
    method ImplementsSpecifier; override;
    method IndexSpecifier; override;
    method IndexOp; override;
    method InheritedStatement; override;
    method InheritedVariableReference; override;
    method InitializationSection; override;
    method InterfaceForward; override;
    method InterfaceGUID; override;
    method InterfaceSection; override;
    method InterfaceType; override;
    method LabelDeclarationSection; override;
    method LabeledStatement; override;
    method LabelId; override;
    method LibraryFile; override;
    method MainUsesClause; override;
    method MainUsedUnitStatement; override;
    method MethodKind; override;
    method MultiplicativeOperator; override;
    method NameSpecifier; override;
    method NotOp; override;
    method NilToken; override;
    method Number; override;
    method ObjectField; override;
    method ObjectForward; override;
    method ObjectNameOfMethod; override;
    method ObjectType; override;
    method OutParameter; override;
    method PackageFile; override;
    method ParameterFormal; override;
    method ParameterName; override;
    method PointerSymbol; override;
    method PointerType; override;
    method ProceduralDirectiveOf; override;
    method ProceduralType; override;
    method ProcedureHeading; override;
    method ProcedureDeclarationSection; override;
    method ProcedureProcedureName; override;
    method ProgramFile; override;
    method PropertyName; override;
    method PropertyParameterList; override;
    method RaiseStatement; override;
    method RecordConstraint; override;
    method RecordConstant; override;
    method RecordFieldConstant; override;
    method RecordType; override;
    method RecordVariant; override;
    method RecordVariantSection; override;
    method RecordVariantTag; override;
    method RelativeOperator; override;
    method RepeatStatement; override;
    method ResourceDeclaration; override;
    method ResourceValue; override;
    method RequiresClause; override;
    method RequiresIdentifier; override;
    method RequiresIdentifierId; override;
    method Resident; override;
    method ReturnType; override;
    method RoundClose; override;
    method RoundOpen; override;
    method SetConstructor; override;
    method SetElement; override;
    method SimpleStatement; override;
    method SimpleType; override;
    method StatementList; override;
    method StorageDefault; override;
    method StringConst; override;
    method StringConstSimple; override;
    method StringStatement; override;
    method StructuredType; override;
    method SubrangeType; override;
    method TagField; override;
    method TagFieldTypeName; override;
    method ThenStatement; override;
    method TryStatement; override;
    method TypeArgs; override;
    method TypeDeclaration; override;
    method TypeId; override;
    method TypeParamDecl; override;
    method TypeParams; override;
    method TypeSection; override;
    method TypeSimple; override;
    method UnaryMinus; override;
    method UnitFile; override;
    method UnitName; override;
    method UnitId; override;
    method UsesClause; override;
    method UsedUnitName; override;
    method VarAbsolute; override;
    method VarDeclaration; override;
    method VarName; override;
    method VarParameter; override;
    method VarSection; override;
    method VisibilityAutomated; override;
    method VisibilityPrivate; override;
    method VisibilityProtected; override;
    method VisibilityPublic; override;
    method VisibilityPublished; override;
    method VisibilityStrictPrivate; override;
    method VisibilityStrictProtected; override;
    method WhileStatement; override;
    method WithExpressionList; override;
    method WithStatement; override;

    method AttributeSections; override;
    method Attribute; override;
    method AttributeName; override;
    method AttributeArguments; override;
    method PositionalArgument; override;
    method NamedArgument; override;
    method AttributeArgumentName; override;
    method AttributeArgumentExpression; override;
  public
    class constructor();
    constructor (const compiler : DelphiCompiler);
    method RunWithString(const Context: not nullable String;
    const aCompiler : DelphiCompiler = DelphiCompiler.dcDefault): TSyntaxNode; reintroduce; virtual;


    class method RunWithString(const Context: not nullable String; InterfaceOnly: Boolean = False;
    const aCompiler : DelphiCompiler = DelphiCompiler.dcDefault;
    IncludeHandler: IIncludeHandler = nil;
    OnHandleString: TStringEvent = nil): TSyntaxNode; reintroduce;


    property Comments: List<TCommentNode> read FComments;
    property Lexer: TPasLexer read FLexer; reintroduce;
    property OnHandleString: TStringEvent read FOnHandleString write FOnHandleString;


  end;

implementation

type
  TAttributeValue = (atAsm, atTrue, atFunction, atProcedure, atOperator, atClass_Of, atClass,
    atConst, atConstructor, atDestructor, atEnum, atInterface, atNil, atNumeric,
    atOut, atPointer, atName, atString, atSubRange, atVar, atDispInterface, atType{ExplicitType},
    atObject, atSealed, atAbstract, atBegin, atOf_Object{method of object},
    atVarargs, atExternal{Varargs and external are mutually exclusive},
    atStatic, atAbsolute);
    var
      AttributeValues: array[TAttributeValue] of String;

      method InitAttributeValues;
      var
      value: TAttributeValue;
      AttributeStr: String;
      begin
        for value := low(TAttributeValue) to high(TAttributeValue) do begin
          AttributeStr:=  value.ToString.Substring(2);
          AttributeStr:= AttributeStr.Replace('_', ' ');
          AttributeValues[value] := AttributeStr;
        end;
      end;

      method AssignLexerPositionToNode(const Lexer: TPasLexer; const Node: TSyntaxNode);
      begin
        Node.Col := Lexer.PosXY.X;
        Node.Line := Lexer.PosXY.Y;
        Node.FileName := Lexer.FileName;
      end;

{ TPasLexer }

      constructor TPasLexer(const ALexer: TmwPasLex; AOnHandleString: TStringEvent);
      begin
        inherited ();
        FLexer := ALexer;
        FOnHandleString := AOnHandleString;
      end;

      method TPasLexer.GetFileName: not nullable string;
      begin
        result := FLexer.Buffer.FileName;
      end;

      method TPasLexer.GetPosXY: TTokenPoint;
      begin
        result := FLexer.PosXY;
      end;

      method TPasLexer.GetToken: not nullable string;
      begin
        result := FLexer.Buffer.Buf.Substring(FLexer.TokenPos, FLexer.TokenLen);
        FOnHandleString(var result);
      end;

{ TNodeStack }

      method TNodeStack.AddChild(Typ: TSyntaxNodeType): TSyntaxNode;
      begin
        result := FStack.Peek.AddChild(new TSyntaxNode(Typ));
        AssignLexerPositionToNode(FLexer, result);
      end;

      method TNodeStack.AddChild(Node: TSyntaxNode): TSyntaxNode;
      begin
        result := FStack.Peek.AddChild(Node);
      end;

      method TNodeStack.AddValuedChild(Typ: TSyntaxNodeType;
      const Value: not nullable string): TSyntaxNode;
      begin
        result := new TValuedSyntaxNode(Typ);
        FStack.Peek.AddChild(result);
        AssignLexerPositionToNode(FLexer, result);
        TValuedSyntaxNode(result).Value := Value;
      end;

      method TNodeStack.Clear;
      begin
        FStack.Clear;
      end;

      constructor TNodeStack(Lexer: TPasLexer);
      begin
        FLexer := Lexer;
        FStack := new Stack<TSyntaxNode>();
      end;

      method TNodeStack.GetCount: Integer;
      begin
        result := FStack.Count;
      end;

      method TNodeStack.Peek: TSyntaxNode;
      begin
        result := FStack.Peek;
      end;

      method TNodeStack.Pop: TSyntaxNode;
      begin
        result := FStack.Pop;
      end;

      method TNodeStack.Push(Node: TSyntaxNode): TSyntaxNode;
      begin
        FStack.Push(Node);
        result := Node;
        AssignLexerPositionToNode(FLexer, result);
      end;

      method TNodeStack.PushCompoundSyntaxNode(Typ: TSyntaxNodeType): TSyntaxNode;
      begin
        result := Push(Peek.AddChild(new TCompoundSyntaxNode(Typ)));
      end;

      method TNodeStack.PushValuedNode(Typ: TSyntaxNodeType;
      const Value: not nullable string): TSyntaxNode;
      begin
        result := Push(Peek.AddChild(new TValuedSyntaxNode(Typ)));
        TValuedSyntaxNode(result).Value := Value;
      end;

      method TNodeStack.Push(Typ: TSyntaxNodeType): TSyntaxNode;
      begin
        result := FStack.Peek.AddChild(new TSyntaxNode(Typ));
        Push(result);
      end;

// TPasSyntaxTreeBuilder

      method TPasSyntaxTreeBuilder.AccessSpecifier;
      begin
        case ExID of
          TptTokenKind.ptRead:
          FStack.Push(TSyntaxNodeType.ntRead);
          TptTokenKind.ptWrite:
          FStack.Push(TSyntaxNodeType.ntWrite);
          else
            FStack.Push(TSyntaxNodeType.ntUnknown);
        end;
        try
          inherited AccessSpecifier;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.AdditiveOperator;
      begin
        case TokenID of
          TptTokenKind.ptMinus: FStack.AddChild(TSyntaxNodeType.ntSub);
          TptTokenKind.ptOr: FStack.AddChild(TSyntaxNodeType.ntOr);
          TptTokenKind.ptPlus: FStack.AddChild(TSyntaxNodeType.ntAdd);
          TptTokenKind.ptXor: FStack.AddChild(TSyntaxNodeType.ntXor);
        end;

        inherited;
      end;

      method TPasSyntaxTreeBuilder.AddressOp;
      begin
        FStack.Push(TSyntaxNodeType.ntAddr);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.AlignmentParameter;
      begin
        FStack.Push(TSyntaxNodeType.ntAlignmentParam);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.AnonymousMethod;
      begin
        FStack.Push(TSyntaxNodeType.ntAnonymousMethod).Attributes[TAttributeName.anKind]:= Lexer.Token;  //method or method
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.AnonymousMethodType;
      begin
        FStack.Push(TSyntaxNodeType.ntAnonymousMethodType);
        try
          inherited;
        finally
          FStack.Pop
        end;
      end;

      method TPasSyntaxTreeBuilder.AnonymousMethodTypeProcedure;
      begin
        FStack.Peek.Attributes[TAttributeName.anKind]:= Lexer.Token; //method
      end;
      method TPasSyntaxTreeBuilder.AnonymousMethodTypeFunction;
      begin
        FStack.Peek.Attributes[TAttributeName.anKind]:= Lexer.Token; //method
      end;

      method TPasSyntaxTreeBuilder.ArrayBounds;
      begin
        FStack.Push(TSyntaxNodeType.ntBounds);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ArrayConstant;
      begin
        FStack.Push(TSyntaxNodeType.ntExpressions);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ArrayDimension;
      begin
        FStack.Push(TSyntaxNodeType.ntDimension);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ArrayOfConst;
      begin
        FStack.Push(TSyntaxNodeType.ntType).Attributes[TAttributeName.anKind]:= AttributeValues[TAttributeValue.atConst];
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.AsmFragment;
      begin
        FStack.AddValuedChild(TSyntaxNodeType.ntAsmFragment, Lexer.Token);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.AsmLabelAt;
      begin
        FStack.AddValuedChild(TSyntaxNodeType.ntAsmFragment, Lexer.Token);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.AsmStatement;

      begin
        FStack.PushValuedNode(TSyntaxNodeType.ntAsmStatement,'');
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.AsmStatements;
      begin
        FStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntStatements).
        Attributes[TAttributeName.anKind]:= AttributeValues[TAttributeValue.atAsm];
        try
          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.AsOp;
      begin
        FStack.AddChild(TSyntaxNodeType.ntAs);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.AssignOp;
      begin
        FStack.AddChild(TSyntaxNodeType.ntAssign);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.AtExpression;
      begin
        FStack.Push(TSyntaxNodeType.ntAt);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.Attribute;
      begin
        FStack.Push(TSyntaxNodeType.ntAttribute);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.AttributeArgumentExpression;
      begin
        FStack.Push(TSyntaxNodeType.ntValue);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.AttributeArgumentName;
      begin
  //FStack.AddValuedChild(ntName, Lexer.Token);
        FStack.AddChild(TSyntaxNodeType.ntName).Attributes[TAttributeName.anName]:= Lexer.Token;
        inherited;
      end;

      method TPasSyntaxTreeBuilder.AttributeArguments;
      begin
        FStack.Push(TSyntaxNodeType.ntArguments);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.AttributeName;
      begin
  //FStack.AddValuedChild(ntName, Lexer.Token);
        FStack.AddChild(TSyntaxNodeType.ntName).Attributes[TAttributeName.anName]:= Lexer.Token;
        inherited;
      end;

      method TPasSyntaxTreeBuilder.AttributeSections;
      begin
        FStack.Push(TSyntaxNodeType.ntAttributes);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.BuildExpressionTree(ExpressionMethod: TTreeBuilderMethod);
      var
      RawExprNode: TSyntaxNode;
      ExprNode: TSyntaxNode;

      NodeList: List<TSyntaxNode>;

      Col, Line: Integer;
      FileName: String;
      begin
        Line := Lexer.PosXY.Y;
        Col := Lexer.PosXY.X;
        FileName := Lexer.FileName;

        RawExprNode := new TSyntaxNode(TSyntaxNodeType.ntExpression);
        try
          FStack.Push(RawExprNode);
          try
            ExpressionMethod;
          finally
            FStack.Pop;
          end;

          if RawExprNode.HasChildren then
          begin
            ExprNode := FStack.Push(TSyntaxNodeType.ntExpression);
            try
              ExprNode.Line := Line;
              ExprNode.Col := Col;
              ExprNode.FileName := FileName;

              NodeList := new List<TSyntaxNode>();
              try
                for Node in RawExprNode.ChildNodes do
                  NodeList.Add(Node);
                TExpressionTools.RawNodeListToTree(RawExprNode, NodeList, ExprNode);
              finally
                NodeList := nil;
              end;
            finally
              FStack.Pop;
            end;
          end;
        finally
          RawExprNode := nil;
        end;
      end;

      method TPasSyntaxTreeBuilder.BuildParametersList(
      ParametersListMethod: TTreeBuilderMethod);
      var
      &Params, Temp: TSyntaxNode;
      TypeInfo, ParamExpr: TSyntaxNode;
      ParamKind: String;
      begin
        &Params := new TSyntaxNode(TSyntaxNodeType.ntUnknown);
        try
          FStack.Push(TSyntaxNodeType.ntParameters);

          FStack.Push(&Params);
          try
            ParametersListMethod;
          finally
            FStack.Pop;
          end;

          for ParamList in &Params.ChildNodes do
            begin
            TypeInfo := ParamList.FindNode(TSyntaxNodeType.ntType);
            ParamKind := ParamList.GetAttribute(TAttributeName.anKind);
            ParamExpr := ParamList.FindNode(TSyntaxNodeType.ntExpression);
            var Attributes:= ParamList.FindNode(TSyntaxNodeType.ntAttributes);

            for &Param in ParamList.ChildNodes do
              begin
              if &Param.Typ <> TSyntaxNodeType.ntName then
                Continue;

              Temp := FStack.Push(TSyntaxNodeType.ntParameter);
              if ParamKind <> '' then
                Temp.SetAttribute(TAttributeName.anKind, ParamKind);

              Temp.Col := &Param.Col;
              Temp.Line := &Param.Line;

              if assigned(Attributes) then
                FStack.AddChild(Attributes.Clone);
              FStack.AddChild(&Param.Clone);
              if assigned(TypeInfo) then
                FStack.AddChild(TypeInfo.Clone);

              if assigned(ParamExpr) then
                FStack.AddChild(ParamExpr.Clone);

              FStack.Pop;
            end;
          end;
          FStack.Pop;
        finally
          &Params := nil;
        end;
      end;

      method TPasSyntaxTreeBuilder.CaseElseStatement;
      begin
        FStack.Push(TSyntaxNodeType.ntCaseElse);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.CaseLabel;
      begin
        FStack.Push(TSyntaxNodeType.ntCaseLabel);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.CaseLabelList;
      begin
        FStack.Push(TSyntaxNodeType.ntCaseLabels);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.CaseSelector;
      begin
        FStack.Push(TSyntaxNodeType.ntCaseSelector);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.CaseStatement;
      begin
        FStack.Push(TSyntaxNodeType.ntCase);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.RecordVariant;
      begin
        FStack.Push(TSyntaxNodeType.ntRecordVariant);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;
      method TPasSyntaxTreeBuilder.ClassClass;
      begin
        FStack.Peek.SetAttribute(TAttributeName.anClass, AttributeValues[TAttributeValue.atTrue]);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.ClassField;
      var
      Fields, Temp: TSyntaxNode;
      TypeInfo, lTypeArgs: TSyntaxNode;
      IsClassVarSection: Boolean;
      begin
        IsClassVarSection:= FStack.Peek.HasAttribute(TAttributeName.anClass);
        Fields := new TSyntaxNode(TSyntaxNodeType.ntFields);
        try
          FStack.Push(Fields);
          try
            inherited;
          finally
            FStack.Pop;
          end;

          TypeInfo := Fields.FindNode(TSyntaxNodeType.ntType);
          lTypeArgs := Fields.FindNode(TSyntaxNodeType.ntTypeArgs);
          for Field in Fields.ChildNodes do
            begin
            if Field.Typ <> TSyntaxNodeType.ntName then
              Continue;

            Temp := FStack.Push(TSyntaxNodeType.ntField);
            if (IsClassVarSection) then Temp.Attributes[TAttributeName.anClass]:= AttributeValues[TAttributeValue.atTrue];
            try
              Temp.AssignPositionFrom(Field);

              FStack.AddChild(Field.Clone);
              TypeInfo := TypeInfo.Clone;
              if assigned(lTypeArgs) then
                TypeInfo.AddChild(lTypeArgs.Clone);
              FStack.AddChild(TypeInfo);
            finally
              FStack.Pop;
            end;
          end;
        finally
          Fields := nil;
        end;
      end;

      method TPasSyntaxTreeBuilder.ObjectField;
      var
      Fields, Temp: TSyntaxNode;
      TypeInfo, lTypeArgs: TSyntaxNode;
      IsClassVarSection: Boolean;
      begin
        IsClassVarSection:= FStack.Peek.HasAttribute(TAttributeName.anClass);
        Fields := TSyntaxNode.Create(TSyntaxNodeType.ntFields);
        try
          FStack.Push(Fields);
          try
            inherited;
          finally
            FStack.Pop;
          end;

          TypeInfo := Fields.FindNode(TSyntaxNodeType.ntType);
          lTypeArgs := Fields.FindNode(TSyntaxNodeType.ntTypeArgs);
          for each Field in Fields.ChildNodes do
            begin
            if Field.Typ <> TSyntaxNodeType.ntName then
              Continue;

            Temp := FStack.Push(TSyntaxNodeType.ntField);
            if (IsClassVarSection) then Temp.Attributes[TAttributeName.anClass]:= AttributeValues[TAttributeValue.atTrue];
            try
              Temp.AssignPositionFrom(Field);

              FStack.AddChild(Field.Clone);
              TypeInfo := TypeInfo.Clone;
              if assigned(lTypeArgs) then
                TypeInfo.AddChild(lTypeArgs.Clone);
              FStack.AddChild(TypeInfo);
            finally
              FStack.Pop;
            end;
          end;
        finally
          Fields := nil;
        end;
      end;

      method TPasSyntaxTreeBuilder.ClassForward;
      begin
        FStack.Peek.SetAttribute(TAttributeName.anForwarded, AttributeValues[TAttributeValue.atTrue]);
        FStack.Peek.Attributes[TAttributeName.anType]:= AttributeValues[TAttributeValue.atClass];
        inherited ClassForward;
      end;

      method TPasSyntaxTreeBuilder.ClassFunctionHeading;
      begin
        if (FLexer.Token = 'operator') then FStack.Peek.Attributes[TAttributeName.anKind]:= AttributeValues[TAttributeValue.atOperator]
        else
          FStack.Peek.SetAttribute(TAttributeName.anKind, AttributeValues[TAttributeValue.atFunction]);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.ClassHelper;
      begin
        FStack.Push(TSyntaxNodeType.ntHelper);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ClassMethod;
      begin
        FStack.Peek.SetAttribute(TAttributeName.anClass, AttributeValues[TAttributeValue.atTrue]);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.ClassMethodResolution;
      var
      PrevNode: TSyntaxNode;
      begin
        PrevNode:= FStack.Peek; //Get the ntMethod node above
        PrevNode.Attributes[TAttributeName.anKind]:= FLexer.Token;
        FStack.Push(TSyntaxNodeType.ntResolutionClause);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ClassMethodHeading;
      begin
        FStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntMethod);
        try
          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ClassProcedureHeading;
      begin
        FStack.Peek.SetAttribute(TAttributeName.anKind, AttributeValues[TAttributeValue.atProcedure]);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.ClassProperty;
      begin
        FStack.Push(TSyntaxNodeType.ntProperty);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ClassReferenceType;
      begin
        FStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anType, AttributeValues[TAttributeValue.atClass_Of]);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ClassType;
      begin
        FStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anType, AttributeValues[TAttributeValue.atClass]);
        try
          inherited;
        finally
          MoveMembersToVisibilityNodes(FStack.Pop);
        end;
      end;

      method TPasSyntaxTreeBuilder.MoveMembersToVisibilityNodes(TypeNode: TSyntaxNode);
      var
      child, vis: TSyntaxNode;
      i: Integer;
      extracted: Boolean;
      begin
        vis := nil;
        i := 0;
        while i < length(TypeNode.ChildNodes) do
        begin
          child := TypeNode.ChildNodes[i];
          extracted := false;
          if child.HasAttribute(TAttributeName.anVisibility) then
            vis := child
          else if assigned(vis) then
          begin
            TypeNode.ExtractChild(child);
            vis.AddChild(child);
            extracted := true;
          end;
          if not extracted then
            inc(i);
        end;
      end;

      method TPasSyntaxTreeBuilder.ConstParameter;
      begin
        FStack.Push(TSyntaxNodeType.ntParameters).SetAttribute(TAttributeName.anKind, AttributeValues[TAttributeValue.atConst]);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ConstructorName;
      var
      Temp: TSyntaxNode;
      NameNode : TSyntaxNode;
      FullName, Dot, Comma: String;
      begin
        Temp := FStack.Peek;
        Temp.SetAttribute(TAttributeName.anKind, AttributeValues[TAttributeValue.atConstructor]);
        Temp.SetAttribute(TAttributeName.anName, Lexer.Token);
        NameNode:= FStack.Push(TSyntaxNodeType.ntName);
        try
          inherited;
        finally
          FStack.Pop;
        end;
        assert(NameNode.HasChildren);
        Dot:= '';
        for each ChildNode in NameNode.ChildNodes do begin
          case ChildNode.Typ of
            TSyntaxNodeType.ntName: begin
              FullName:= FullName + Dot + ChildNode.Attributes[TAttributeName.anName];
              Dot:= '.';
            end; {ntName}
            TSyntaxNodeType.ntTypeParams: begin
              Comma:= '';
              FullName:= FullName + '<';
              for TypeParam in ChildNode.ChildNodes do begin
                FullName:= FullName + Comma + TypeParam.FindNode(TSyntaxNodeType.ntType).Attributes[TAttributeName.anName];
                Comma:= ',';
              end;

              FullName:= FullName + '>';
            end; {ntTypeParams:}

          end;
        end;
        NameNode.Attributes[TAttributeName.anName]:= FullName;

      end;

      method TPasSyntaxTreeBuilder.GetMainSection(Node: TSyntaxNode): TSyntaxNode;
      var
      Temp: TSyntaxNode;
      begin
        If Node.Typ = TSyntaxNodeType.ntUnknown then begin
          Temp:= FStack.Pop;
          Node:= FStack.Peek;
          FStack.Push(Temp);
        end;
        if not(assigned(Node.ParentNode)) then Exit(Node); //return the root node.
        while assigned(Node.ParentNode.ParentNode) do Node:= Node.ParentNode;
        if (Node.ParentNode.Typ in [TSyntaxNodeType.ntProgram, TSyntaxNodeType.ntLibrary, TSyntaxNodeType.ntPackage]) then Exit(Node.ParentNode);
        result:= Node;
      end;

      method TPasSyntaxTreeBuilder.CompilerDirective;
      begin
        var Root : TSyntaxNode;
        var Directive:= Lexer.Token.ToUpper;
        if FStack.Count > 0 then
          Root:= GetMainSection(FStack.Peek);
        // Maybe the directive is before the UnitNode
        // Will be ignored at Moment....
        if assigned(Root) then
        begin
          var Node:= new TValuedSyntaxNode(TSyntaxNodeType.ntCompilerDirective);
          AssignLexerPositionToNode(Lexer, Node);
          Node.Value:= Directive;

          Root.AddChild(Node);
          if (Directive.StartsWith('(*$')) then
          begin
            Directive := Directive.Substring(3);
            Directive := Directive.Replace('*)','}');

          end else
            Directive := Directive.Substring(2);

          var Part2:= 0;
          while not (Directive[Part2] in [' ', '+', '-', '}']) do
            inc(Part2);

          var lType := Directive.Substring(0, Part2);
          Node.Attributes[TAttributeName.anType]:= lType;
          Directive := Directive.Substring(Part2+1).TrimEnd;

          Node.Attributes[TAttributeName.anKind]:= Directive.Replace('}','');
        end;
        inherited;

      end;

      method TPasSyntaxTreeBuilder.CompoundStatement;
      begin
        FStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntStatements).Attributes[TAttributeName.anKind]:= AttributeValues[TAttributeValue.atBegin];
        try
          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ConstantDeclaration;
      begin
        FStack.Push(TSyntaxNodeType.ntConstant);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ConstantExpression;
      var
      ExpressionMethod: TTreeBuilderMethod;
      begin
        ExpressionMethod := @CallInheritedConstantExpression;
        BuildExpressionTree(ExpressionMethod);
      end;

      method TPasSyntaxTreeBuilder.CallInheritedFormalParameterList;
      begin
        inherited FormalParameterList;
      end;

      method TPasSyntaxTreeBuilder.CallInheritedConstantExpression;
      begin
        inherited ConstantExpression;
      end;

      method TPasSyntaxTreeBuilder.ConstantName;
      begin
  //FStack.AddValuedChild(ntName, Lexer.Token);
        FStack.AddChild(TSyntaxNodeType.ntName).Attributes[TAttributeName.anName]:= Lexer.Token;
        inherited;
      end;

      method TPasSyntaxTreeBuilder.ConstantValue;
      begin
        FStack.Push(TSyntaxNodeType.ntValue);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ConstantValueTyped;
      begin
        FStack.Push(TSyntaxNodeType.ntValue);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ConstraintList;
      begin
        FStack.Push(TSyntaxNodeType.ntConstraints);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ClassConstraint;
      begin
        FStack.Push(TSyntaxNodeType.ntClassConstraint);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ConstructorConstraint;
      begin
        FStack.Push(TSyntaxNodeType.ntConstructorConstraint);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.RecordConstant;
      begin
        FStack.Push(TSyntaxNodeType.ntRecordConstant);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;
      method TPasSyntaxTreeBuilder.RecordConstraint;
      begin
        FStack.Push(TSyntaxNodeType.ntRecordConstraint);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ConstSection;
      var
      ConstSect, Temp: TSyntaxNode;
      TypeInfo, Value: TSyntaxNode;
      begin
        ConstSect := new TSyntaxNode(TSyntaxNodeType.ntConstants);
        try
          FStack.Push(TSyntaxNodeType.ntConstants).Attributes[TAttributeName.anKind]:= Lexer.Token; //resourcestring or const

          FStack.Push(ConstSect);
          try
            inherited ConstSection;
          finally
            FStack.Pop;
          end;

          for ConstList in ConstSect.ChildNodes do
            begin
            TypeInfo := ConstList.FindNode(TSyntaxNodeType.ntType);
            Value := ConstList.FindNode(TSyntaxNodeType.ntValue);
            for Constant in ConstList.ChildNodes do
              begin
              if Constant.Typ <> TSyntaxNodeType.ntName then
                Continue;

              Temp := FStack.Push(ConstList.Typ);
              try
                Temp.AssignPositionFrom(Constant);

                FStack.AddChild(Constant.Clone);
                if assigned(TypeInfo) then
                  FStack.AddChild(TypeInfo.Clone);
                FStack.AddChild(Value.Clone);
              finally
                FStack.Pop;
              end;
            end;
          end;
          FStack.Pop;
        finally
          ConstSect := nil;
        end;
      end;

      method TPasSyntaxTreeBuilder.ContainsClause;
      begin
        FStack.Push(TSyntaxNodeType.ntContains);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      constructor TPasSyntaxTreeBuilder(const compiler : DelphiCompiler);
      begin
        inherited(compiler);
        FLexer := new TPasLexer(inherited Lexer, @DoHandleString);
        FStack := new TNodeStack(FLexer);
        FComments := new List<TCommentNode>();

        OnComment := @DoOnComment;
      end;

      method TPasSyntaxTreeBuilder.DoHandleString(var s: not nullable string);
      begin
        if assigned(FOnHandleString) then
          FOnHandleString(var s);
      end;



      method TPasSyntaxTreeBuilder.DestructorName;
      var
      Temp: TSyntaxNode;
      NameNode : TSyntaxNode;
      FullName, Dot, Comma: String;
      begin
        Temp := FStack.Peek;
        Temp.SetAttribute(TAttributeName.anKind, AttributeValues[TAttributeValue.atDestructor]);
        Temp.SetAttribute(TAttributeName.anName, Lexer.Token);
        NameNode:= FStack.Push(TSyntaxNodeType.ntName);
        try
          inherited;
        finally
          FStack.Pop;
        end;
        assert(NameNode.HasChildren);
        Dot:= '';
        for each ChildNode in NameNode.ChildNodes do begin
          case ChildNode.Typ of
            TSyntaxNodeType.ntName: begin
              FullName:= FullName + Dot + ChildNode.Attributes[TAttributeName.anName];
              Dot:= '.';
            end; {ntName}
            TSyntaxNodeType.ntTypeParams: begin
              Comma:= '';
              FullName:= FullName + '<';
              for TypeParam in ChildNode.ChildNodes do begin
                FullName:= FullName + Comma + TypeParam.FindNode(TSyntaxNodeType.ntType).Attributes[TAttributeName.anName];
                Comma:= ',';
              end;

              FullName:= FullName + '>';
            end; {ntTypeParams:}

          end;
        end;
        NameNode.Attributes[TAttributeName.anName]:= FullName;

      end;

      method TPasSyntaxTreeBuilder.DirectiveAbstract;
      begin
        FStack.Peek.Attributes[TAttributeName.anAbstract]:= Lexer.Token;
        inherited;
      end;
      method TPasSyntaxTreeBuilder.DirectiveBinding;
      var
      token: String;
      begin
        token := Lexer.Token;
  // Method bindings:
        if token.EqualsIgnoringCase('override') or token.EqualsIgnoringCase('virtual')
        or token.EqualsIgnoringCase('dynamic')
          then
          FStack.Peek.SetAttribute(TAttributeName.anMethodBinding, token)
  // Other directives
        else if token.EqualsIgnoringCase('reintroduce') then
          FStack.Peek.SetAttribute(TAttributeName.anReintroduce, AttributeValues[TAttributeValue.atTrue])
        else if token.EqualsIgnoringCase('overload') then
          FStack.Peek.SetAttribute(TAttributeName.anOverload, AttributeValues[TAttributeValue.atTrue])
        else if token.EqualsIgnoringCase('abstract') then
          FStack.Peek.SetAttribute(TAttributeName.anAbstract, AttributeValues[TAttributeValue.atTrue]);

        inherited;
      end;

      method TPasSyntaxTreeBuilder.DirectiveBindingMessage;
      begin
        FStack.Peek.Attributes[TAttributeName.anMethodBinding]:= 'message';
        FStack.Push(TSyntaxNodeType.ntMessage);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.DirectiveCalling;
      begin
        FStack.Peek.SetAttribute(TAttributeName.anCallingConvention, Lexer.Token);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.DirectiveDeprecated;
      begin
        FStack.Push(TSyntaxNodeType.ntDeprecated);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;
      method TPasSyntaxTreeBuilder.DirectiveExperimental;
      begin
        FStack.Push(TSyntaxNodeType.ntExperimental);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;
      method TPasSyntaxTreeBuilder.DirectiveInline;
      begin
        FStack.Peek.Attributes[TAttributeName.anInline]:= Lexer.Token;
        inherited;
      end;
      method TPasSyntaxTreeBuilder.DirectiveLibrary;
      begin
        FStack.Push(TSyntaxNodeType.ntLibrary);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;
      method TPasSyntaxTreeBuilder.DirectivePlatForm;
      begin
        FStack.Push(TSyntaxNodeType.ntPlatform);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;
      method TPasSyntaxTreeBuilder.DirectiveSealed;
      begin
        FStack.Peek.Attributes[TAttributeName.anAbstract]:= Lexer.Token;
        inherited;
      end;
      method TPasSyntaxTreeBuilder.DirectiveVarargs;
      begin
        FStack.Push(TSyntaxNodeType.ntExternal).Attributes[TAttributeName.anKind]:= AttributeValues[TAttributeValue.atVarargs];
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.DispInterfaceForward;
      begin
        FStack.Peek.SetAttribute(TAttributeName.anForwarded, AttributeValues[TAttributeValue.atTrue]);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.DotOp;
      begin
        FStack.AddChild(TSyntaxNodeType.ntDot);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.DoubleAddressOp;
      begin
        FStack.Push(TSyntaxNodeType.ntDoubleAddr);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ElseStatement;
      begin
        FStack.Push(TSyntaxNodeType.ntElse);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.EmptyStatement;
      begin
        FStack.Push(TSyntaxNodeType.ntEmptyStatement);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.EnumeratedType;
      var
      TypeNode: TSyntaxNode;
      begin
        TypeNode := FStack.Push(TSyntaxNodeType.ntType);
        try
          TypeNode.Attributes[TAttributeName.anType]:= AttributeValues[TAttributeValue.atEnum];
          if ScopedEnums then
            TypeNode.SetAttribute(TAttributeName.anVisibility, 'scoped');
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ExceptBlock;
      begin
        FStack.Push(TSyntaxNodeType.ntExcept);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ExceptionBlockElseBranch;
      begin
        FStack.Push(TSyntaxNodeType.ntExceptElse); //#223
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ExceptionHandler;
      begin
        FStack.Push(TSyntaxNodeType.ntExceptionHandler);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ExceptionVariable;
      begin
        FStack.Push(TSyntaxNodeType.ntVariable);
  //FStack.AddValuedChild(ntName, Lexer.Token);
        FStack.AddChild(TSyntaxNodeType.ntName).Attributes[TAttributeName.anName]:= Lexer.Token;
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ExplicitType;  //#220+#181
      begin
        FStack.Peek.Attributes[TAttributeName.anKind]:= AttributeValues[TAttributeValue.atType];
        inherited;
      end;
      method TPasSyntaxTreeBuilder.ExportedHeading;
      begin
        FStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntMethod);
        try
          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ExportsClause;
      begin
        FStack.Push(TSyntaxNodeType.ntExports);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ExportsElement;
      begin
        FStack.Push(TSyntaxNodeType.ntElement);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ExportsName;
      var
      NamesNode: TSyntaxNode;
      begin
        NamesNode := new TSyntaxNode(TSyntaxNodeType.ntUnknown);
        try
          FStack.Push(NamesNode);
          try
            inherited;
          finally
            FStack.Pop;
          end;

          FStack.Peek.SetAttribute(TAttributeName.anName, NodeListToString(NamesNode));
        finally
          NamesNode := nil;
        end;
      end;

      method TPasSyntaxTreeBuilder.ExportsNameId;
      begin
        FStack.AddChild(TSyntaxNodeType.ntUnknown).SetAttribute(TAttributeName.anName, Lexer.Token);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.Expression;
      var
      ExpressionMethod: TTreeBuilderMethod;
      begin
        ExpressionMethod := @CallInheritedExpression;
        BuildExpressionTree(ExpressionMethod);
      end;

      method TPasSyntaxTreeBuilder.SetCurrentCompoundNodesEndPosition;
      var
      Temp: TCompoundSyntaxNode;
      begin
        Temp := TCompoundSyntaxNode(FStack.Peek);
        Temp.EndCol := Lexer.PosXY.X;
        Temp.EndLine := Lexer.PosXY.Y;
        Temp.FileName := Lexer.FileName;
      end;

      method TPasSyntaxTreeBuilder.CallInheritedExpression;
      begin
        inherited Expression;
      end;

      method TPasSyntaxTreeBuilder.CallInheritedPropertyParameterList;
      begin
        inherited PropertyParameterList;
      end;

      method TPasSyntaxTreeBuilder.ExpressionList;
      begin
        FStack.Push(TSyntaxNodeType.ntExpressions);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ExternalDependency;
      begin
        FStack.Push(TSyntaxNodeType.ntDependency);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;
      method TPasSyntaxTreeBuilder.ExternalDirective;
      begin
        FStack.Push(TSyntaxNodeType.ntExternal).Attributes[TAttributeName.anKind]:= AttributeValues[TAttributeValue.atExternal];
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.FieldList;
      var
      Fields, Temp: TSyntaxNode;
      TypeInfo, lTypeArgs: TSyntaxNode;
      IsClassVarSection: Boolean;
      begin
        IsClassVarSection:= FStack.Peek.HasAttribute(TAttributeName.anClass);
        Fields := TSyntaxNode.Create(TSyntaxNodeType.ntFields);
        try
          FStack.Push(Fields);
          try
            inherited;
          finally
            FStack.Pop;
          end;

          TypeInfo := Fields.FindNode(TSyntaxNodeType.ntType);
          lTypeArgs := Fields.FindNode(TSyntaxNodeType.ntTypeArgs);
          for each Field in Fields.ChildNodes do
            begin
            if Field.Typ <> TSyntaxNodeType.ntName then
              Continue;

            Temp := FStack.Push(TSyntaxNodeType.ntField);
            if (IsClassVarSection) then Temp.Attributes[TAttributeName.anClass]:= AttributeValues[TAttributeValue.atTrue];
            try
              Temp.AssignPositionFrom(Field);

              FStack.AddChild(Field.Clone);
              TypeInfo := TypeInfo.Clone;
              if assigned(lTypeArgs) then
                TypeInfo.AddChild(lTypeArgs.Clone);
              FStack.AddChild(TypeInfo);
            finally
              FStack.Pop;
            end;
          end;
        finally
          Fields := nil;
        end;
      end;

      method TPasSyntaxTreeBuilder.FieldName;
      begin
  //FStack.AddValuedChild(ntName, Lexer.Token);
        FStack.AddChild(TSyntaxNodeType.ntName).Attributes[TAttributeName.anName]:= Lexer.Token;
        inherited;
      end;

      method TPasSyntaxTreeBuilder.FinalizationSection;
      begin
        FStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntFinalization);
        try
          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.FinallyBlock;
      begin
        FStack.Push(TSyntaxNodeType.ntFinally);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.FormalParameterList;
      var
      TreeBuilderMethod: TTreeBuilderMethod;
      begin
        TreeBuilderMethod := @CallInheritedFormalParameterList;
        BuildParametersList(TreeBuilderMethod);
      end;

      method TPasSyntaxTreeBuilder.ForStatement;
      begin
        FStack.Push(TSyntaxNodeType.ntFor);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ForStatementDownTo;
      begin
        FStack.Push(TSyntaxNodeType.ntDownTo);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ForStatementFrom;
      begin
        FStack.Push(TSyntaxNodeType.ntFrom);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ForStatementIn;
      begin
        FStack.Push(TSyntaxNodeType.ntIn);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ForStatementTo;
      begin
        FStack.Push(TSyntaxNodeType.ntTo);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ForwardDeclaration;
      begin
        if FStack.Peek.ParentNode.Typ = TSyntaxNodeType.ntImplementation then begin  //#166
          FStack.Peek.Attributes[TAttributeName.anForwarded]:= AttributeValues[TAttributeValue.atTrue];
        end;
        inherited;
      end;
      method TPasSyntaxTreeBuilder.FunctionHeading;
      begin
        FStack.Peek.SetAttribute(TAttributeName.anKind, AttributeValues[TAttributeValue.atFunction]);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.FunctionMethodName;
      begin
  //FStack.AddValuedChild(ntName, Lexer.Token);
        FStack.AddChild(TSyntaxNodeType.ntName).Attributes[TAttributeName.anName]:= Lexer.Token;
        inherited;
      end;

      method TPasSyntaxTreeBuilder.FunctionProcedureName;
      var
      NameNode: TSyntaxNode;
      FullName, Dot, Comma: String;
      begin
  //Temp:= FStack.Peek;
        NameNode:= FStack.Push(TSyntaxNodeType.ntName);
        try
          inherited;
        finally
          FStack.Pop;
        end;
  //Traverse the name node and reconstruct the full name
        assert(NameNode.HasChildren);
        Dot:= '';
        for each ChildNode in NameNode.ChildNodes do begin
          case ChildNode.Typ of
            TSyntaxNodeType.ntName: begin
              FullName:= FullName + Dot + ChildNode.Attributes[TAttributeName.anName];
              Dot:= '.';
            end; {ntName}
            TSyntaxNodeType.ntTypeParams: begin
              Comma:= '';
              FullName:= FullName + '<';
              for TypeParam in ChildNode.ChildNodes do begin
                FullName:= FullName + Comma + TypeParam.FindNode(TSyntaxNodeType.ntType).Attributes[TAttributeName.anName];
                Comma:= ',';
              end;

              FullName:= FullName + '>';
            end; {ntTypeParams:}

          end;
        end;
        NameNode.Attributes[TAttributeName.anName]:= FullName;
      end;

      method TPasSyntaxTreeBuilder.GotoStatement;
      begin
        FStack.Push(TSyntaxNodeType.ntGoto);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.Identifier;
      begin
        FStack.AddChild(TSyntaxNodeType.ntIdentifier).SetAttribute(TAttributeName.anName, Lexer.Token);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.IfStatement;
      begin
        FStack.Push(TSyntaxNodeType.ntIf);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ImplementationSection;
      begin
        FStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntImplementation);
        try
          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ImplementsSpecifier;
      begin
        FStack.Push(TSyntaxNodeType.ntImplements);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.IndexOp;
      begin
        FStack.Push(TSyntaxNodeType.ntIndexed);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.IndexSpecifier;
      begin
        FStack.Push(TSyntaxNodeType.ntIndex);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.InheritedStatement;
      begin
        FStack.Push(TSyntaxNodeType.ntInherited);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.InheritedVariableReference;
      begin
        FStack.Push(TSyntaxNodeType.ntInherited);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.InitializationSection;
      begin
        FStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntInitialization);
        try
          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.InterfaceForward;
      begin
        FStack.Peek.Attributes[TAttributeName.anForwarded]:= AttributeValues[TAttributeValue.atTrue];
        inherited InterfaceForward;
      end;

      method TPasSyntaxTreeBuilder.InterfaceGUID;
      begin
        FStack.Push(TSyntaxNodeType.ntGuid);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.InterfaceSection;
      begin
        FStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntInterface);
        try

          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          FStack.Pop;
        end;

      end;

      method TPasSyntaxTreeBuilder.InterfaceType;
      begin
        case TokenID of
          TptTokenKind.ptInterface: FStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anType, AttributeValues[TAttributeValue.atInterface]);
          TptTokenKind.ptDispinterface: FStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anType, AttributeValues[TAttributeValue.atDispInterface]);
        end; {case}
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.LabeledStatement;
      var
      Node, Name: TSyntaxNode;
      begin
        Node:= FStack.Push(TSyntaxNodeType.ntLabeledStatement);
        Name:= Node.AddChild(TSyntaxNodeType.ntName);
        Name.Attributes[TAttributeName.anName]:= Lexer.Token;
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.LabelDeclarationSection;
      begin
        FStack.Push(TSyntaxNodeType.ntLabel);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.LabelId;

      begin
        FStack.Push(TSyntaxNodeType.ntName).Attributes[TAttributeName.anName]:= Lexer.Token;
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.LibraryFile;
      begin
        FStack.Push(TSyntaxNode.Create(TSyntaxNodeType.ntLibrary));
        AssignLexerPositionToNode(Lexer, FStack.Peek);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.MainUsedUnitStatement;
      var
      NameNode, PathNode, PathLiteralNode, Temp: TSyntaxNode;
      begin
        FStack.Push(TSyntaxNodeType.ntUnit);
        try
          inherited;

          NameNode := FStack.Peek.FindNode(TSyntaxNodeType.ntUnit);

          if assigned(NameNode) then
          begin
            Temp := FStack.Peek;
            Temp.Attributes[TAttributeName.anName]:= NameNode.Attributes[TAttributeName.anName];
            Temp.DeleteChild(NameNode);
          end;

          PathNode := FStack.Peek.FindNode(TSyntaxNodeType.ntExpression);
          if assigned(PathNode) then
          begin
            FStack.Peek.ExtractChild(PathNode);
            try
              PathLiteralNode := PathNode.FindNode(TSyntaxNodeType.ntLiteral);

              if PathLiteralNode is TValuedSyntaxNode then
                FStack.Peek.SetAttribute(TAttributeName.anPath, TValuedSyntaxNode(PathLiteralNode).Value);
            finally
              PathNode := nil;
            end;
          end;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.MainUsesClause;
      begin
        FStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntUses);
        try
          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.MethodKind;
      var
      value: String;
      begin
        value := Lexer.Token.ToLower;
        DoHandleString(var value);
        FStack.Peek.SetAttribute(TAttributeName.anKind, value);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.MultiplicativeOperator;
      begin
        case TokenID of
          TptTokenKind.ptAnd:
          FStack.AddChild(TSyntaxNodeType.ntAnd);
          TptTokenKind.ptDiv:
          FStack.AddChild(TSyntaxNodeType.ntDiv);
          TptTokenKind.ptMod:
          FStack.AddChild(TSyntaxNodeType.ntMod);
          TptTokenKind.ptShl:
          FStack.AddChild(TSyntaxNodeType.ntShl);
          TptTokenKind.ptShr:
          FStack.AddChild(TSyntaxNodeType.ntShr);
          TptTokenKind.ptSlash:
          FStack.AddChild(TSyntaxNodeType.ntFDiv);
          TptTokenKind.ptStar:
          FStack.AddChild(TSyntaxNodeType.ntMul);
          else
            FStack.AddChild(TSyntaxNodeType.ntUnknown);
        end;

        inherited;
      end;

      method TPasSyntaxTreeBuilder.NamedArgument;
      begin
        FStack.Push(TSyntaxNodeType.ntNamedArgument);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.NameSpecifier;
      begin
        FStack.Push(TSyntaxNodeType.ntExternalName);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;
      method TPasSyntaxTreeBuilder.NilToken;
      var
      Node: TSyntaxNode;
      begin
        Node:= FStack.AddValuedChild(TSyntaxNodeType.ntLiteral, AttributeValues[TAttributeValue.atNil]);
        Node.Attributes[TAttributeName.anType]:= AttributeValues[TAttributeValue.atNil];
        inherited;
      end;

      method TPasSyntaxTreeBuilder.NotOp;
      begin
        FStack.AddChild(TSyntaxNodeType.ntNot);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.Number;
      var
      Node: TSyntaxNode;
      begin
        Node := FStack.AddValuedChild(TSyntaxNodeType.ntLiteral, Lexer.Token);
        Node.SetAttribute(TAttributeName.anType, AttributeValues[TAttributeValue.atNumeric]);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.ObjectForward;
      begin
        FStack.Peek.Attributes[TAttributeName.anForwarded]:= AttributeValues[TAttributeValue.atTrue];
        FStack.Peek.Attributes[TAttributeName.anType]:= AttributeValues[TAttributeValue.atObject];
        inherited;
      end;

      method TPasSyntaxTreeBuilder.ObjectNameOfMethod;
      begin
  //FStack.AddValuedChild(ntName, Lexer.Token);
        FStack.AddChild(TSyntaxNodeType.ntName).Attributes[TAttributeName.anName]:= Lexer.Token;
        inherited;
      end;

      method TPasSyntaxTreeBuilder.ObjectType;
      begin
        FStack.Push(TSyntaxNodeType.ntType).Attributes[TAttributeName.anType]:= AttributeValues[TAttributeValue.atObject];
        try
          inherited;
        finally
          MoveMembersToVisibilityNodes(FStack.Pop);
        end;
      end;

      method TPasSyntaxTreeBuilder.DoOnComment(Sender: Object; const Text: string);
      var
      Node: TCommentNode;
      begin
        case TokenID of
          TptTokenKind.ptAnsiComment: Node := new TCommentNode(TSyntaxNodeType.ntAnsiComment);
          TptTokenKind.ptBorComment: Node := new TCommentNode(TSyntaxNodeType.ntAnsiComment);
          TptTokenKind.ptSlashesComment: Node := new TCommentNode(TSyntaxNodeType.ntSlashesComment);
          else
            raise new EParserException(Lexer.PosXY.Y, Lexer.PosXY.X, Lexer.FileName, 'Invalid comment type');
        end;

        AssignLexerPositionToNode(Lexer, Node);
        Node.Text := Text;

        FComments.Add(Node);
      end;

      method TPasSyntaxTreeBuilder.ParserMessage(Sender: Object;
      const Typ: TMessageEventType; const Msg: string; X, Y: Integer);
      begin
        if Typ = TMessageEventType.meError then
          raise new EParserException(Y, X, Lexer.FileName, Msg);
      end;

      method TPasSyntaxTreeBuilder.OutParameter;
      begin
        FStack.Push(TSyntaxNodeType.ntParameters).SetAttribute(TAttributeName.anKind, AttributeValues[TAttributeValue.atOut]);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.PackageFile;
      begin
        FStack.Push(TSyntaxNode.Create(TSyntaxNodeType.ntPackage));
        AssignLexerPositionToNode(Lexer, FStack.Peek);
        inherited;
      end;
      method TPasSyntaxTreeBuilder.ParameterFormal;
      begin
        FStack.Push(TSyntaxNodeType.ntParameters);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ParameterName;
      begin
  //FStack.AddValuedChild(ntName, Lexer.Token);
        FStack.AddChild(TSyntaxNodeType.ntName).Attributes[TAttributeName.anName]:= Lexer.Token;
        inherited;
      end;

      method TPasSyntaxTreeBuilder.PointerSymbol;
      begin
        FStack.AddChild(TSyntaxNodeType.ntDeref);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.PointerType;
      begin
        FStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anType, AttributeValues[TAttributeValue.atPointer]);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.PositionalArgument;
      begin
        FStack.Push(TSyntaxNodeType.ntPositionalArgument);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ProceduralDirectiveOf;
      begin
        FStack.Peek.Attributes[TAttributeName.anKind]:= AttributeValues[TAttributeValue.atOf_Object];
        inherited;
      end;
      method TPasSyntaxTreeBuilder.ProceduralType;
      begin
        FStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anType, Lexer.Token);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ProcedureDeclarationSection;
      begin
        FStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntMethod);
        try
          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ProcedureHeading;
      begin
        FStack.Peek.SetAttribute(TAttributeName.anKind, AttributeValues[TAttributeValue.atProcedure]);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.ProcedureProcedureName;
      begin
  //FStack.Peek.Attribute[TAttributeName.anName, Lexer.Token);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.ProgramFile;
      begin
        FStack.Push(new TSyntaxNode(TSyntaxNodeType.ntProgram));
        AssignLexerPositionToNode(Lexer, FStack.Peek);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.PropertyName;
      begin
        FStack.Peek.SetAttribute(TAttributeName.anName, Lexer.Token);
        inherited PropertyName;
      end;

      method TPasSyntaxTreeBuilder.PropertyParameterList;
      var
      TreeBuilderMethod: TTreeBuilderMethod;
      begin
        TreeBuilderMethod := @CallInheritedPropertyParameterList;
        BuildParametersList(TreeBuilderMethod);
      end;

      method TPasSyntaxTreeBuilder.RaiseStatement;
      begin
        FStack.Push(TSyntaxNodeType.ntRaise);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.RecordFieldConstant;
      begin
        FStack.Push(TSyntaxNodeType.ntField).AddChild(TSyntaxNodeType.ntName).Attributes[TAttributeName.anName]:= Lexer.Token;
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.RecordType;
      begin
        inherited RecordType;
        MoveMembersToVisibilityNodes(FStack.Peek);
      end;

      method TPasSyntaxTreeBuilder.RelativeOperator;
      begin
        case TokenID of
          TptTokenKind.ptAs:
          FStack.AddChild(TSyntaxNodeType.ntAs);
          TptTokenKind.ptEqual:
          FStack.AddChild(TSyntaxNodeType.ntEqual);
          TptTokenKind.ptGreater:
          FStack.AddChild(TSyntaxNodeType.ntGreater);
          TptTokenKind.ptGreaterEqual:
          FStack.AddChild(TSyntaxNodeType.ntGreaterEqual);
          TptTokenKind.ptIn:
          FStack.AddChild(TSyntaxNodeType.ntIn);
          TptTokenKind.ptIs:
          FStack.AddChild(TSyntaxNodeType.ntIs);
          TptTokenKind.ptLower:
          FStack.AddChild(TSyntaxNodeType.ntLower);
          TptTokenKind.ptLowerEqual:
          FStack.AddChild(TSyntaxNodeType.ntLowerEqual);
          TptTokenKind.ptNotEqual:
          FStack.AddChild(TSyntaxNodeType.ntNotEqual);
          else
            FStack.AddChild(TSyntaxNodeType.ntUnknown);
        end;

        inherited;
      end;

      method TPasSyntaxTreeBuilder.RepeatStatement;
      begin
        FStack.Push(TSyntaxNodeType.ntRepeat);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.RequiresClause;
      begin
        FStack.Push(TSyntaxNodeType.ntRequires);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.RequiresIdentifier;
      var
      NamesNode: TSyntaxNode;
      begin
        NamesNode := new TSyntaxNode(TSyntaxNodeType.ntUnknown);
        try
          FStack.Push(NamesNode);
          try
            inherited;
          finally
            FStack.Pop;
          end;

          FStack.AddChild(TSyntaxNodeType.ntPackage).SetAttribute(TAttributeName.anName, NodeListToString(NamesNode));
        finally
          NamesNode := nil;
        end;
      end;

      method TPasSyntaxTreeBuilder.RequiresIdentifierId;
      begin
        FStack.AddChild(TSyntaxNodeType.ntUnknown).SetAttribute(TAttributeName.anName, Lexer.Token);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.Resident;
      begin
        FStack.Push(TSyntaxNodeType.ntResident);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;
      method TPasSyntaxTreeBuilder.ResourceDeclaration;
      begin
        FStack.Push(TSyntaxNodeType.ntResourceString);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ResourceValue;
      begin
        FStack.Push(TSyntaxNodeType.ntValue);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ReturnType;
      begin
        FStack.Push(TSyntaxNodeType.ntReturnType);
        try
          inherited;
        finally
          FStack.Pop
        end;
      end;

      method TPasSyntaxTreeBuilder.RoundClose;
      begin
        FStack.AddChild(TSyntaxNodeType.ntRoundClose);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.RoundOpen;
      begin
        FStack.AddChild(TSyntaxNodeType.ntRoundOpen);
        inherited;
      end;


      method TPasSyntaxTreeBuilder.NodeListToString(NamesNode: TSyntaxNode): not nullable string;
      begin
        result := '';
        for NamePartNode in NamesNode.ChildNodes do
          begin
          if (result <> '') then
            result := result + '.';
          result := result + NamePartNode.GetAttribute(TAttributeName.anName);
        end;
        DoHandleString(var result);
      end;

      method TPasSyntaxTreeBuilder.SetConstructor;
      begin
        FStack.Push(TSyntaxNodeType.ntSet);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.SetElement;
      begin
        FStack.Push(TSyntaxNodeType.ntElement);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.SimpleStatement;
      var
      RawStatement, Temp: TSyntaxNode;
      LHS, RHS: TSyntaxNode;
      NodeList: List<TSyntaxNode>;
      I, AssignIdx: Integer;
      Position: TTokenPoint;
      FileName: String;
      begin
        Position := Lexer.PosXY;
        FileName := Lexer.FileName;

        RawStatement := new TSyntaxNode(TSyntaxNodeType.ntStatement);
        try
          FStack.Push(RawStatement);
          try
            inherited;
          finally
            FStack.Pop;
          end;

          if not RawStatement.HasChildren then
            Exit;

          if RawStatement.FindNode(TSyntaxNodeType.ntAssign) <> nil then
          begin
            Temp := FStack.Push(TSyntaxNodeType.ntAssign);
            try
              Temp.Col := Position.X;
              Temp.Line := Position.Y;
              Temp.FileName := FileName;

              NodeList := new List<TSyntaxNode>;
              try
                AssignIdx := -1;
                for I := 0 to length(RawStatement.ChildNodes) - 1 do
                  begin
                  if RawStatement.ChildNodes[I].Typ = TSyntaxNodeType.ntAssign then
                  begin
                    AssignIdx := I;
                    Break;
                  end;
                  NodeList.Add(RawStatement.ChildNodes[I]);
                end;

                if NodeList.Count = 0 then
                  raise new EParserException(Position.Y, Position.X, Lexer.FileName, 'Illegal expression');

                LHS := FStack.AddChild(TSyntaxNodeType.ntLHS);
                LHS.AssignPositionFrom(NodeList[0]);

                TExpressionTools.RawNodeListToTree(RawStatement, NodeList, LHS);

                NodeList.RemoveAll;

                for I := AssignIdx + 1 to length(RawStatement.ChildNodes) - 1 do
                  NodeList.Add(RawStatement.ChildNodes[I]);

                if NodeList.Count = 0 then
                  raise new EParserException(Position.Y, Position.X, Lexer.FileName, 'Illegal expression');

                RHS := FStack.AddChild(TSyntaxNodeType.ntRHS);
                RHS.AssignPositionFrom(NodeList[0]);

                TExpressionTools.RawNodeListToTree(RawStatement, NodeList, RHS);
              finally
                NodeList := nil;
              end;
            finally
              FStack.Pop;
            end;
          end else
          begin
            Temp := FStack.Push(TSyntaxNodeType.ntCall);
            try
              Temp.Col := Position.X;
              Temp.Line := Position.Y;

              NodeList := new List<TSyntaxNode>;
              try
                for Node in RawStatement.ChildNodes do
                  NodeList.Add(Node);
                TExpressionTools.RawNodeListToTree(RawStatement, NodeList, FStack.Peek);
              finally
                NodeList := nil;
              end;
            finally
              FStack.Pop;
            end;
          end;
        finally
          RawStatement := nil;
        end;
      end;

      method TPasSyntaxTreeBuilder.SimpleType;
      begin
        FStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anName, Lexer.Token);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.StatementList;
      begin
        FStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntStatements);
        try
          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.StorageDefault;
      begin
        FStack.Push(TSyntaxNodeType.ntDefault);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.StringConst;
      var
      StrConst: TSyntaxNode;
      Node: TSyntaxNode;
      Str: String;
      begin
        StrConst := new TSyntaxNode(TSyntaxNodeType.ntUnknown);
        try
          FStack.Push(StrConst);
          try
            inherited;
          finally
            FStack.Pop;
          end;

          Str := '';
          for Literal in StrConst.ChildNodes do
            Str := Str + TValuedSyntaxNode(Literal).Value;
        finally
          StrConst := nil;
        end;

        DoHandleString(var Str);
        Node := FStack.AddValuedChild(TSyntaxNodeType.ntLiteral, Str);
        Node.SetAttribute(TAttributeName.anType, AttributeValues[TAttributeValue.atString]);
      end;

      method TPasSyntaxTreeBuilder.StringConstSimple;
      begin
  //TODO support ptAsciiChar
              FStack.AddValuedChild(TSyntaxNodeType.ntLiteral, StrHelper.AnsiDequotedStr(Lexer.Token, ''''));
  //FStack.AddValuedChild(TSyntaxNodeType.ntLiteral, Lexer.Token);
              inherited;
            end;

            method TPasSyntaxTreeBuilder.StringStatement;
            begin
              FStack.AddChild(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anName, Lexer.Token);
              inherited;
            end;

            method TPasSyntaxTreeBuilder.StructuredType;
            begin
              FStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anType, Lexer.Token);
              try
                inherited;
              finally
                FStack.Pop;
              end;
            end;

            method TPasSyntaxTreeBuilder.SubrangeType;
            begin
              FStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anName, AttributeValues[TAttributeValue.atSubRange]);
              try
                inherited;
              finally
                FStack.Pop;
              end;
            end;

            method TPasSyntaxTreeBuilder.TagField;
            var
            TagNode: TSyntaxNode;
            TypeNode: TSyntaxNode;
            begin
              TagNode:= FStack.Push(TSyntaxNodeType.ntCaseSelector);
              TagNode.Attributes[TAttributeName.anKind]:= Lexer.Token;
              try
                inherited;
                TypeNode:= FStack.Peek.FindNode(TSyntaxNodeType.ntIdentifier);
                if (assigned(TypeNode)) then begin
                  TagNode.Attributes[TAttributeName.anName]:= TagNode.Attributes[TAttributeName.anKind];
                  TagNode.Attributes[TAttributeName.anKind]:= TypeNode.Attributes[TAttributeName.anKind];
                  TagNode.DeleteChild(TypeNode);
                end;
              finally
                FStack.Pop;
              end;
            end;
            method TPasSyntaxTreeBuilder.TagFieldTypeName;
            begin
              FStack.Push(TSyntaxNodeType.ntIdentifier).Attributes[TAttributeName.anKind]:= Lexer.Token;
              try
                inherited;
              finally
                FStack.Pop;
              end;
            end;
            method TPasSyntaxTreeBuilder.ThenStatement;
            begin
              FStack.Push(TSyntaxNodeType.ntThen);
              try
                inherited;
              finally
                FStack.Pop;
              end;
            end;

            method TPasSyntaxTreeBuilder.TryStatement;
            begin
              FStack.Push(TSyntaxNodeType.ntTry);
              try
                inherited;
              finally
                FStack.Pop;
              end;
            end;

            method TPasSyntaxTreeBuilder.TypeArgs;
            begin
              FStack.Push(TSyntaxNodeType.ntTypeArgs);
              try
                inherited;
              finally
                FStack.Pop;
              end;
            end;

            method TPasSyntaxTreeBuilder.TypeDeclaration;
            begin
              FStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntTypeDecl).SetAttribute(TAttributeName.anName, Lexer.Token);
              try
                inherited;
                SetCurrentCompoundNodesEndPosition;
              finally
                FStack.Pop;
              end;
            end;

            method TPasSyntaxTreeBuilder.TypeId;
            var
            TypeNode, InnerTypeNode, SubNode: TSyntaxNode;
            TypeName, InnerTypeName: String;
            i: Integer;
            begin
              TypeNode := FStack.Push(TSyntaxNodeType.ntType);
              try
                inherited;

                InnerTypeName := '';
                InnerTypeNode := TypeNode.FindNode(TSyntaxNodeType.ntType);
                if assigned(InnerTypeNode) then
                begin
                  InnerTypeName := InnerTypeNode.GetAttribute(TAttributeName.anName);
                  for SubNode in InnerTypeNode.ChildNodes do
                    TypeNode.AddChild(SubNode.Clone);

                  TypeNode.DeleteChild(InnerTypeNode);
                end;

                TypeName := '';
                for i := length(TypeNode.ChildNodes) - 1 downto 0 do
                  begin
                  SubNode := TypeNode.ChildNodes[i];
                  if SubNode.Typ = TSyntaxNodeType.ntType then
                  begin
                    if TypeName <> '' then
                      TypeName := '.' + TypeName;

                    TypeName := SubNode.GetAttribute(TAttributeName.anName) + TypeName;
                    TypeNode.DeleteChild(SubNode);
                  end;
                end;

                if TypeName <> '' then
                  TypeName := '.' + TypeName;
                TypeName := InnerTypeName + TypeName;

                DoHandleString(var TypeName);
                TypeNode.SetAttribute(TAttributeName.anName, TypeName);
              finally
                FStack.Pop;
              end;
            end;

            method TPasSyntaxTreeBuilder.TypeParamDecl;
            var
            OriginTypeParamNode, NewTypeParamNode, Constraints: TSyntaxNode;
            TypeNodeCount: Integer;
            TypeNodesToDelete: List<TSyntaxNode>;
            begin
              OriginTypeParamNode := FStack.Push(TSyntaxNodeType.ntTypeParam);
              try
                inherited;
              finally
                FStack.Pop;
              end;

              Constraints := OriginTypeParamNode.FindNode(TSyntaxNodeType.ntConstraints);
              TypeNodeCount := 0;
              TypeNodesToDelete := new List<TSyntaxNode>;
              try
                for TypeNode in OriginTypeParamNode.ChildNodes do
                  begin
                  if TypeNode.Typ = TSyntaxNodeType.ntType then
                  begin
                    inc(TypeNodeCount);
                    if TypeNodeCount > 1 then
                    begin
                      NewTypeParamNode := FStack.Push(TSyntaxNodeType.ntTypeParam);
                      try
                        NewTypeParamNode.AddChild(TypeNode.Clone);
                        if assigned(Constraints) then
                          NewTypeParamNode.AddChild(Constraints.Clone);
                        TypeNodesToDelete.Add(TypeNode);
                      finally
                        FStack.Pop;
                      end;
                    end;
                  end;
                end;

                for TypeNode in TypeNodesToDelete do
                  OriginTypeParamNode.DeleteChild(TypeNode);
              finally
                TypeNodesToDelete := nil;
              end;
            end;

            method TPasSyntaxTreeBuilder.TypeParams;
            begin
              FStack.Push(TSyntaxNodeType.ntTypeParams);
              try
                inherited;
              finally
                FStack.Pop;
              end;
            end;

            method TPasSyntaxTreeBuilder.TypeSection;
            begin
              FStack.Push(TSyntaxNodeType.ntTypeSection);
              try
                inherited;
              finally
                FStack.Pop;
              end;
            end;

            method TPasSyntaxTreeBuilder.TypeSimple;
            begin
              FStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anName, Lexer.Token);
              try
                inherited;
              finally
                FStack.Pop;
              end;
            end;

            method TPasSyntaxTreeBuilder.UnaryMinus;
            begin
              FStack.AddChild(TSyntaxNodeType.ntUnaryMinus);
              inherited;
            end;

            method TPasSyntaxTreeBuilder.UnitFile;
            begin
         //Assert(FStack.Peek.ParentNode = nil);
        FStack.Push(TSyntaxNode.Create(TSyntaxNodeType.ntUnit));
        AssignLexerPositionToNode(Lexer, FStack.Peek);
        inherited;
         //Stack.pop is done in `Run`
      end;

      method TPasSyntaxTreeBuilder.UnitId;
      begin
        FStack.AddChild(TSyntaxNodeType.ntUnknown).SetAttribute(TAttributeName.anName, Lexer.Token);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.UnitName;
      var
      NamesNode: TSyntaxNode;
      begin
        NamesNode := new TSyntaxNode(TSyntaxNodeType.ntUnknown);
        try
          FStack.Push(NamesNode);
          try
            inherited;
          finally
            FStack.Pop;
          end;

          FStack.Peek.SetAttribute(TAttributeName.anName, NodeListToString(NamesNode));
        finally
          NamesNode := nil;
        end;
      end;

      method TPasSyntaxTreeBuilder.UsedUnitName;
      var
      NamesNode, UnitNode: TSyntaxNode;
      Position: TTokenPoint;
      FileName: String;
      begin
        Position := Lexer.PosXY;
        FileName := Lexer.FileName;

        NamesNode := new TSyntaxNode(TSyntaxNodeType.ntUnit);
        try
          FStack.Push(NamesNode);
          try
            inherited;
          finally
            FStack.Pop;
          end;

          UnitNode := FStack.AddChild(TSyntaxNodeType.ntUnit);
          UnitNode.SetAttribute(TAttributeName.anName, NodeListToString(NamesNode));
          UnitNode.Col  := Position.X;
          UnitNode.Line := Position.Y;
          UnitNode.FileName := FileName;
        finally
          NamesNode := nil;
        end;
      end;

      method TPasSyntaxTreeBuilder.UsesClause;
      begin
        FStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntUses);
        try
          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.VarAbsolute;
      var
      AbsoluteNode: TSyntaxNode;
      ValueNode: TSyntaxNode;
      begin
        AbsoluteNode:= new TSyntaxNode(TSyntaxNodeType.ntUnknown);
        FStack.Push(AbsoluteNode);
        try
          inherited;
        finally
          FStack.Pop;
          ValueNode:=   AbsoluteNode.ExtractChild(AbsoluteNode.ChildNodes[0] );
          ValueNode.Attributes[TAttributeName.anKind]:= AttributeValues[TAttributeValue.atAbsolute];
          AbsoluteNode := nil;
          FStack.Peek.AddChild(ValueNode);
        end;
      end;

      method TPasSyntaxTreeBuilder.VarDeclaration;
      begin
        FStack.Push(TSyntaxNodeType.ntVariables);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.RecordVariantSection;
      begin
        FStack.Push(TSyntaxNodeType.ntVariantSection);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.RecordVariantTag;
      var
      Temp: TSyntaxNode;
      begin
        Temp:= FStack.Push(TSyntaxNodeType.ntVariantTag);

        try
          inherited;
          if Temp.ChildCount = 2 then begin
            Temp.Attributes[TAttributeName.anName]:= Temp.ChildNodes[0].Attributes[TAttributeName.anName];
            Temp.Attributes[TAttributeName.anType]:= Temp.ChildNodes[1].Attributes[TAttributeName.anName];
            Temp.DeleteChild(Temp.ChildNodes[1]);
          end else begin
            Temp.Attributes[TAttributeName.anType]:= Temp.ChildNodes[0].Attributes[TAttributeName.anName];
          end;
          Temp.DeleteChild(Temp.ChildNodes[0]);
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.VarName;
      begin
        FStack.AddChild(TSyntaxNodeType.ntName).Attributes[TAttributeName.anName]:= Lexer.Token; //#222
        inherited;
      end;

      method TPasSyntaxTreeBuilder.VarParameter;
      begin
        FStack.Push(TSyntaxNodeType.ntParameters).Attributes[TAttributeName.anKind]:= AttributeValues[TAttributeValue.atVar];
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.VarSection;
      var
      VarSect, Temp: TSyntaxNode;
      TypeInfo, ValueInfo: TSyntaxNode;
      begin
        VarSect := new TSyntaxNode(TSyntaxNodeType.ntUnknown);
        try
          FStack.Push(TSyntaxNodeType.ntVariables);
          FStack.Push(VarSect);
          try
            inherited VarSection;
          finally
            FStack.Pop;
          end;
          for each VarList in VarSect.ChildNodes do
            begin
            TypeInfo := VarList.FindNode(TSyntaxNodeType.ntType);
            ValueInfo := VarList.FindNode(TSyntaxNodeType.ntValue);
            for each Variable in VarList.ChildNodes do
              begin
              if Variable.Typ <> TSyntaxNodeType.ntName then
                Continue;

              Temp := FStack.Push(TSyntaxNodeType.ntVariable);
              try
                Temp.AssignPositionFrom(Variable);

                FStack.AddChild(Variable.Clone);
                if assigned(TypeInfo) then
                  FStack.AddChild(TypeInfo.Clone);

                if assigned(ValueInfo) then
                  FStack.AddChild(ValueInfo.Clone);
              finally
                FStack.Pop;
              end;
            end;
          end;
          FStack.Pop;
        finally
          VarSect := nil;
        end;
      end;

      method TPasSyntaxTreeBuilder.VisibilityStrictPrivate;
      var
      Temp: TSyntaxNode;
      begin
        Temp := FStack.Push(TSyntaxNodeType.ntStrictPrivate);
        try
          Temp.SetAttribute(TAttributeName.anVisibility, AttributeValues[TAttributeValue.atTrue]);
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.VisibilityPrivate;
      var
      Temp: TSyntaxNode;
      begin
        Temp := FStack.Push(TSyntaxNodeType.ntPrivate);
        try
          Temp.SetAttribute(TAttributeName.anVisibility, AttributeValues[TAttributeValue.atTrue]);
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.VisibilityStrictProtected;
      var
      Temp: TSyntaxNode;
      begin
        Temp := FStack.Push(TSyntaxNodeType.ntStrictProtected);
        try
          Temp.SetAttribute(TAttributeName.anVisibility, AttributeValues[TAttributeValue.atTrue]);
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.VisibilityProtected;
      var
      Temp: TSyntaxNode;
      begin
        Temp := FStack.Push(TSyntaxNodeType.ntProtected);
        try
          Temp.SetAttribute(TAttributeName.anVisibility, AttributeValues[TAttributeValue.atTrue]);
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.VisibilityPublic;
      var
      Temp: TSyntaxNode;
      begin
        Temp := FStack.Push(TSyntaxNodeType.ntPublic);
        try
          Temp.SetAttribute(TAttributeName.anVisibility, AttributeValues[TAttributeValue.atTrue]);
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.VisibilityPublished;
      var
      Temp: TSyntaxNode;
      begin
        Temp := FStack.Push(TSyntaxNodeType.ntPublished);
        try
          Temp.SetAttribute(TAttributeName.anVisibility, AttributeValues[TAttributeValue.atTrue]);
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.VisibilityAutomated;
      var
      Temp: TSyntaxNode;
      begin
        Temp := FStack.Push(TSyntaxNodeType.ntAutomated);
        try
          Temp.Attributes[TAttributeName.anVisibility]:= AttributeValues[TAttributeValue.atTrue];
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.WhileStatement;
      begin
        FStack.Push(TSyntaxNodeType.ntWhile);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.WithExpressionList;
      begin
        FStack.Push(TSyntaxNodeType.ntExpressions);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.WithStatement;
      begin
        FStack.Push(TSyntaxNodeType.ntWith);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.RunWithString(const Context: not nullable String; const aCompiler : DelphiCompiler = DelphiCompiler.dcDefault): TSyntaxNode;
      begin

        try
          FStack.Clear;
          try
            self.OnMessage := @ParserMessage;
            inherited RunWithString(Context);
          finally
            if FStack.Count > 0 then
              Result := FStack.Pop;
          end;
        except
          on E: EParserException do
            raise new ESyntaxTreeException(E.Line, E.Col, Lexer.FileName, E.Message, Result);
            on E: ESyntaxError do

              raise new ESyntaxTreeException(E.PosXY.X, E.PosXY.Y, Lexer.FileName, E.Message, Result);

              on E : Exception do
              begin
                Result := nil;
                raise;
              end;
        end;

        assert(FStack.Count = 0);
      end;

      class method TPasSyntaxTreeBuilder.RunWithString(const Context: not nullable String; InterfaceOnly: Boolean := false; const aCompiler : DelphiCompiler = DelphiCompiler.dcDefault; IncludeHandler: IIncludeHandler := nil; OnHandleString: TStringEvent := nil): TSyntaxNode;
      begin
        var Builder := new TPasSyntaxTreeBuilder(aCompiler);
        Builder.InterfaceOnly := InterfaceOnly;
        Builder.OnHandleString := OnHandleString;

        Builder.IncludeHandler := IncludeHandler;
        result := Builder.RunWithString(Context, aCompiler);

      end;

      class constructor TPasSyntaxTreeBuilder();
      begin
        InitAttributeValues;
      end;

end.