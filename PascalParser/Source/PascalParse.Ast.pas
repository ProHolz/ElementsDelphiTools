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
namespace ProHolz.Ast;

interface

type

  TStringEvent = public block(var s: String);

  TPasLexer = public class
  private
    fLexer: TmwPasLex;
    fOnHandleString: TStringEvent;
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
  private
    fLexer: TPasLexer;
    fStack: Stack<TSyntaxNode>;

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
    fStack: TNodeStack;
    fComments: List<TCommentNode>;
    fLexer: TPasLexer;
    fOnHandleString: TStringEvent;

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
    method ElementsFile; override;
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
    const aCompiler : DelphiCompiler = DelphiCompiler.Default): TSyntaxNode; reintroduce; virtual;


    class method RunWithString(const Context: not nullable String; InterfaceOnly: Boolean = False;
    const aCompiler : DelphiCompiler = DelphiCompiler.Default;
    IncludeHandler: IIncludeHandler = nil;
    OnHandleString: TStringEvent = nil): TSyntaxNode; reintroduce;


    property Comments: List<TCommentNode> read fComments;
    property Lexer: TPasLexer read fLexer; reintroduce;
    property OnHandleString: TStringEvent read fOnHandleString write fOnHandleString;


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
        fLexer := ALexer;
        fOnHandleString := AOnHandleString;
      end;

      method TPasLexer.GetFileName: not nullable string;
      begin
        result := fLexer.Buffer.FileName;
      end;

      method TPasLexer.GetPosXY: TTokenPoint;
      begin
        result := fLexer.PosXY;
      end;

      method TPasLexer.GetToken: not nullable string;
      begin
        result := fLexer.Buffer.Buf.Substring(fLexer.TokenPos, fLexer.TokenLen);
        fOnHandleString(var result);
      end;

{ TNodeStack }

      method TNodeStack.AddChild(Typ: TSyntaxNodeType): TSyntaxNode;
      begin
        result := fStack.Peek.AddChild(new TSyntaxNode(Typ));
        AssignLexerPositionToNode(fLexer, result);
      end;

      method TNodeStack.AddChild(Node: TSyntaxNode): TSyntaxNode;
      begin
        result := fStack.Peek.AddChild(Node);
      end;

      method TNodeStack.AddValuedChild(Typ: TSyntaxNodeType;
      const Value: not nullable string): TSyntaxNode;
      begin
        result := new TValuedSyntaxNode(Typ);
        fStack.Peek.AddChild(result);
        AssignLexerPositionToNode(fLexer, result);
        TValuedSyntaxNode(result).Value := Value;
      end;

      method TNodeStack.Clear;
      begin
        fStack.Clear;
      end;

      constructor TNodeStack(Lexer: TPasLexer);
      begin
        fLexer := Lexer;
        fStack := new Stack<TSyntaxNode>();
      end;

      method TNodeStack.GetCount: Integer;
      begin
        result := fStack.Count;
      end;

      method TNodeStack.Peek: TSyntaxNode;
      begin
        result := fStack.Peek;
      end;

      method TNodeStack.Pop: TSyntaxNode;
      begin
        result := fStack.Pop;
      end;

      method TNodeStack.Push(Node: TSyntaxNode): TSyntaxNode;
      begin
        fStack.Push(Node);
        result := Node;
        AssignLexerPositionToNode(fLexer, result);
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
        result := fStack.Peek.AddChild(new TSyntaxNode(Typ));
        Push(result);
      end;

// TPasSyntaxTreeBuilder

      method TPasSyntaxTreeBuilder.AccessSpecifier;
      begin
        case ExID of
          TptTokenKind.ptRead:
          fStack.Push(TSyntaxNodeType.ntRead);
          TptTokenKind.ptWrite:
          fStack.Push(TSyntaxNodeType.ntWrite);
          else
            fStack.Push(TSyntaxNodeType.ntUnknown);
        end;
        try
          inherited AccessSpecifier;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.AdditiveOperator;
      begin
        case TokenID of
          TptTokenKind.ptMinus: fStack.AddChild(TSyntaxNodeType.ntSub);
          TptTokenKind.ptOr: fStack.AddChild(TSyntaxNodeType.ntOr);
          TptTokenKind.ptPlus: fStack.AddChild(TSyntaxNodeType.ntAdd);
          TptTokenKind.ptXor: fStack.AddChild(TSyntaxNodeType.ntXor);
        end;

        inherited;
      end;

      method TPasSyntaxTreeBuilder.AddressOp;
      begin
        fStack.Push(TSyntaxNodeType.ntAddr);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.AlignmentParameter;
      begin
        fStack.Push(TSyntaxNodeType.ntAlignmentParam);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.AnonymousMethod;
      begin
        fStack.Push(TSyntaxNodeType.ntAnonymousMethod).Attributes[TAttributeName.anKind]:= Lexer.Token;  //method or method
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.AnonymousMethodType;
      begin
        fStack.Push(TSyntaxNodeType.ntAnonymousMethodType);
        try
          inherited;
        finally
          fStack.Pop
        end;
      end;

      method TPasSyntaxTreeBuilder.AnonymousMethodTypeProcedure;
      begin
        fStack.Peek.Attributes[TAttributeName.anKind]:= Lexer.Token; //method
      end;
      method TPasSyntaxTreeBuilder.AnonymousMethodTypeFunction;
      begin
        fStack.Peek.Attributes[TAttributeName.anKind]:= Lexer.Token; //method
      end;

      method TPasSyntaxTreeBuilder.ArrayBounds;
      begin
        fStack.Push(TSyntaxNodeType.ntBounds);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ArrayConstant;
      begin
        fStack.Push(TSyntaxNodeType.ntExpressions);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ArrayDimension;
      begin
        fStack.Push(TSyntaxNodeType.ntDimension);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ArrayOfConst;
      begin
        fStack.Push(TSyntaxNodeType.ntType).Attributes[TAttributeName.anKind]:= AttributeValues[TAttributeValue.atConst];
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.AsmFragment;
      begin
        fStack.AddValuedChild(TSyntaxNodeType.ntAsmFragment, Lexer.Token);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.AsmLabelAt;
      begin
        fStack.AddValuedChild(TSyntaxNodeType.ntAsmFragment, Lexer.Token);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.AsmStatement;

      begin
        fStack.PushValuedNode(TSyntaxNodeType.ntAsmStatement,'');
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.AsmStatements;
      begin
        fStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntStatements).
        Attributes[TAttributeName.anKind]:= AttributeValues[TAttributeValue.atAsm];
        try
          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.AsOp;
      begin
        fStack.AddChild(TSyntaxNodeType.ntAs);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.AssignOp;
      begin
        fStack.AddChild(TSyntaxNodeType.ntAssign);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.AtExpression;
      begin
        fStack.Push(TSyntaxNodeType.ntAt);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.Attribute;
      begin
        fStack.Push(TSyntaxNodeType.ntAttribute);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.AttributeArgumentExpression;
      begin
        fStack.Push(TSyntaxNodeType.ntValue);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.AttributeArgumentName;
      begin
  //FStack.AddValuedChild(ntName, Lexer.Token);
        fStack.AddChild(TSyntaxNodeType.ntName).Attributes[TAttributeName.anName]:= Lexer.Token;
        inherited;
      end;

      method TPasSyntaxTreeBuilder.AttributeArguments;
      begin
        fStack.Push(TSyntaxNodeType.ntArguments);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.AttributeName;
      begin
  //FStack.AddValuedChild(ntName, Lexer.Token);
        fStack.AddChild(TSyntaxNodeType.ntName).Attributes[TAttributeName.anName]:= Lexer.Token;
        inherited;
      end;

      method TPasSyntaxTreeBuilder.AttributeSections;
      begin
        fStack.Push(TSyntaxNodeType.ntAttributes);
        try
          inherited;
        finally
          fStack.Pop;
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
          fStack.Push(RawExprNode);
          try
            ExpressionMethod;
          finally
            fStack.Pop;
          end;

          if RawExprNode.HasChildren then
          begin
            ExprNode := fStack.Push(TSyntaxNodeType.ntExpression);
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
              fStack.Pop;
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
          fStack.Push(TSyntaxNodeType.ntParameters);

          fStack.Push(&Params);
          try
            ParametersListMethod;
          finally
            fStack.Pop;
          end;

          for ParamList in &Params.ChildNodes do
            begin
            TypeInfo := ParamList.FindNode(TSyntaxNodeType.ntType);
            ParamKind := ParamList.AttribKind;
            ParamExpr := ParamList.FindNode(TSyntaxNodeType.ntExpression);
            var Attributes:= ParamList.FindNode(TSyntaxNodeType.ntAttributes);

            for &Param in ParamList.ChildNodes do
              begin
              if &Param.Typ <> TSyntaxNodeType.ntName then
                Continue;

              Temp := fStack.Push(TSyntaxNodeType.ntParameter);
              if ParamKind <> '' then
                Temp.SetAttribute(TAttributeName.anKind, ParamKind);

              Temp.Col := &Param.Col;
              Temp.Line := &Param.Line;

              if assigned(Attributes) then
                fStack.AddChild(Attributes.Clone);
              fStack.AddChild(&Param.Clone);
              if assigned(TypeInfo) then
                fStack.AddChild(TypeInfo.Clone);

              if assigned(ParamExpr) then
                fStack.AddChild(ParamExpr.Clone);

              fStack.Pop;
            end;
          end;
          fStack.Pop;
        finally
          &Params := nil;
        end;
      end;

      method TPasSyntaxTreeBuilder.CaseElseStatement;
      begin
        fStack.Push(TSyntaxNodeType.ntCaseElse);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.CaseLabel;
      begin
        fStack.Push(TSyntaxNodeType.ntCaseLabel);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.CaseLabelList;
      begin
        fStack.Push(TSyntaxNodeType.ntCaseLabels);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.CaseSelector;
      begin
        fStack.Push(TSyntaxNodeType.ntCaseSelector);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.CaseStatement;
      begin
        fStack.Push(TSyntaxNodeType.ntCase);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.RecordVariant;
      begin
        fStack.Push(TSyntaxNodeType.ntRecordVariant);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;
      method TPasSyntaxTreeBuilder.ClassClass;
      begin
        fStack.Peek.SetAttribute(TAttributeName.anClass, AttributeValues[TAttributeValue.atTrue]);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.ClassField;
      var
      Fields, Temp: TSyntaxNode;
      TypeInfo, lTypeArgs: TSyntaxNode;
      IsClassVarSection: Boolean;
      begin
        IsClassVarSection:= fStack.Peek.HasAttribute(TAttributeName.anClass);
        Fields := new TSyntaxNode(TSyntaxNodeType.ntFields);
        try
          fStack.Push(Fields);
          try
            inherited;
          finally
            fStack.Pop;
          end;

          TypeInfo := Fields.FindNode(TSyntaxNodeType.ntType);
          lTypeArgs := Fields.FindNode(TSyntaxNodeType.ntTypeArgs);
          for Field in Fields.ChildNodes do
            begin
            if Field.Typ <> TSyntaxNodeType.ntName then
              Continue;

            Temp := fStack.Push(TSyntaxNodeType.ntField);
            if (IsClassVarSection) then Temp.Attributes[TAttributeName.anClass]:= AttributeValues[TAttributeValue.atTrue];
            try
              Temp.AssignPositionFrom(Field);

              fStack.AddChild(Field.Clone);
              TypeInfo := TypeInfo.Clone;
              if assigned(lTypeArgs) then
                TypeInfo.AddChild(lTypeArgs.Clone);
              fStack.AddChild(TypeInfo);
            finally
              fStack.Pop;
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
        IsClassVarSection:= fStack.Peek.HasAttribute(TAttributeName.anClass);
        Fields := TSyntaxNode.Create(TSyntaxNodeType.ntFields);
        try
          fStack.Push(Fields);
          try
            inherited;
          finally
            fStack.Pop;
          end;

          TypeInfo := Fields.FindNode(TSyntaxNodeType.ntType);
          lTypeArgs := Fields.FindNode(TSyntaxNodeType.ntTypeArgs);
          for each Field in Fields.ChildNodes do
            begin
            if Field.Typ <> TSyntaxNodeType.ntName then
              Continue;

            Temp := fStack.Push(TSyntaxNodeType.ntField);
            if (IsClassVarSection) then Temp.Attributes[TAttributeName.anClass]:= AttributeValues[TAttributeValue.atTrue];
            try
              Temp.AssignPositionFrom(Field);

              fStack.AddChild(Field.Clone);
              TypeInfo := TypeInfo.Clone;
              if assigned(lTypeArgs) then
                TypeInfo.AddChild(lTypeArgs.Clone);
              fStack.AddChild(TypeInfo);
            finally
              fStack.Pop;
            end;
          end;
        finally
          Fields := nil;
        end;
      end;

      method TPasSyntaxTreeBuilder.ClassForward;
      begin
        fStack.Peek.SetAttribute(TAttributeName.anForwarded, AttributeValues[TAttributeValue.atTrue]);
        fStack.Peek.Attributes[TAttributeName.anType]:= AttributeValues[TAttributeValue.atClass];
        inherited ClassForward;
      end;

      method TPasSyntaxTreeBuilder.ClassFunctionHeading;
      begin
        if (fLexer.Token = 'operator') then fStack.Peek.Attributes[TAttributeName.anKind]:= AttributeValues[TAttributeValue.atOperator]
        else
          fStack.Peek.SetAttribute(TAttributeName.anKind, AttributeValues[TAttributeValue.atFunction]);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.ClassHelper;
      begin
        fStack.Push(TSyntaxNodeType.ntHelper);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ClassMethod;
      begin
        fStack.Peek.SetAttribute(TAttributeName.anClass, AttributeValues[TAttributeValue.atTrue]);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.ClassMethodResolution;
      var
      PrevNode: TSyntaxNode;
      begin
        PrevNode:= fStack.Peek; //Get the ntMethod node above
        PrevNode.Attributes[TAttributeName.anKind]:= fLexer.Token;
        fStack.Push(TSyntaxNodeType.ntResolutionClause);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ClassMethodHeading;
      begin
        fStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntMethod);
        try
          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ClassProcedureHeading;
      begin
        fStack.Peek.SetAttribute(TAttributeName.anKind, AttributeValues[TAttributeValue.atProcedure]);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.ClassProperty;
      begin
        fStack.Push(TSyntaxNodeType.ntProperty);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ClassReferenceType;
      begin
        fStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anType, AttributeValues[TAttributeValue.atClass_Of]);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ClassType;
      begin
        fStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anType, AttributeValues[TAttributeValue.atClass]);
        try
          inherited;
        finally
          MoveMembersToVisibilityNodes(fStack.Pop);
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
        fStack.Push(TSyntaxNodeType.ntParameters).SetAttribute(TAttributeName.anKind, AttributeValues[TAttributeValue.atConst]);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ConstructorName;
      var
      Temp: TSyntaxNode;
      NameNode : TSyntaxNode;
      FullName, Dot, Comma: String;
      begin
        Temp := fStack.Peek;
        Temp.SetAttribute(TAttributeName.anKind, AttributeValues[TAttributeValue.atConstructor]);
        Temp.SetAttribute(TAttributeName.anName, Lexer.Token);
        NameNode:= fStack.Push(TSyntaxNodeType.ntName);
        try
          inherited;
        finally
          fStack.Pop;
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
          Temp:= fStack.Pop;
          Node:= fStack.Peek;
          fStack.Push(Temp);
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
        if fStack.Count > 0 then
          Root:= GetMainSection(fStack.Peek);
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
        fStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntStatements).Attributes[TAttributeName.anKind]:= AttributeValues[TAttributeValue.atBegin];
        try
          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ConstantDeclaration;
      begin
        fStack.Push(TSyntaxNodeType.ntConstant);
        try
          inherited;
        finally
          fStack.Pop;
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
        fStack.AddChild(TSyntaxNodeType.ntName).Attributes[TAttributeName.anName]:= Lexer.Token;
        inherited;
      end;

      method TPasSyntaxTreeBuilder.ConstantValue;
      begin
        fStack.Push(TSyntaxNodeType.ntValue);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ConstantValueTyped;
      begin
        fStack.Push(TSyntaxNodeType.ntValue);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ConstraintList;
      begin
        fStack.Push(TSyntaxNodeType.ntConstraints);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ClassConstraint;
      begin
        fStack.Push(TSyntaxNodeType.ntClassConstraint);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ConstructorConstraint;
      begin
        fStack.Push(TSyntaxNodeType.ntConstructorConstraint);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.RecordConstant;
      begin
        fStack.Push(TSyntaxNodeType.ntRecordConstant);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;
      method TPasSyntaxTreeBuilder.RecordConstraint;
      begin
        fStack.Push(TSyntaxNodeType.ntRecordConstraint);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ConstSection;
      var
      ConstSect, Temp: TSyntaxNode;
      TypeInfo, Value: TSyntaxNode;
      begin
        ConstSect := new TSyntaxNode(TSyntaxNodeType.ntConstants);
        try
          fStack.Push(TSyntaxNodeType.ntConstants).Attributes[TAttributeName.anKind]:= Lexer.Token; //resourcestring or const

          fStack.Push(ConstSect);
          try
            inherited ConstSection;
          finally
            fStack.Pop;
          end;

          for ConstList in ConstSect.ChildNodes do
            begin
            TypeInfo := ConstList.FindNode(TSyntaxNodeType.ntType);
            Value := ConstList.FindNode(TSyntaxNodeType.ntValue);
            for Constant in ConstList.ChildNodes do
              begin
              if Constant.Typ <> TSyntaxNodeType.ntName then
                Continue;

              Temp := fStack.Push(ConstList.Typ);
              try
                Temp.AssignPositionFrom(Constant);

                fStack.AddChild(Constant.Clone);
                if assigned(TypeInfo) then
                  fStack.AddChild(TypeInfo.Clone);
                fStack.AddChild(Value.Clone);
              finally
                fStack.Pop;
              end;
            end;
          end;
          fStack.Pop;
        finally
          ConstSect := nil;
        end;
      end;

      method TPasSyntaxTreeBuilder.ContainsClause;
      begin
        fStack.Push(TSyntaxNodeType.ntContains);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      constructor TPasSyntaxTreeBuilder(const compiler : DelphiCompiler);
      begin
        inherited(compiler);
        fLexer := new TPasLexer(inherited Lexer, @DoHandleString);
        fStack := new TNodeStack(fLexer);
        fComments := new List<TCommentNode>();

        OnComment := @DoOnComment;
      end;

      method TPasSyntaxTreeBuilder.DoHandleString(var s: not nullable string);
      begin
        if assigned(fOnHandleString) then
          fOnHandleString(var s);
      end;



      method TPasSyntaxTreeBuilder.DestructorName;
      var
      Temp: TSyntaxNode;
      NameNode : TSyntaxNode;
      FullName, Dot, Comma: String;
      begin
        Temp := fStack.Peek;
        Temp.SetAttribute(TAttributeName.anKind, AttributeValues[TAttributeValue.atDestructor]);
        Temp.SetAttribute(TAttributeName.anName, Lexer.Token);
        NameNode:= fStack.Push(TSyntaxNodeType.ntName);
        try
          inherited;
        finally
          fStack.Pop;
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
        fStack.Peek.Attributes[TAttributeName.anAbstract]:= Lexer.Token;
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
          fStack.Peek.SetAttribute(TAttributeName.anMethodBinding, token)
  // Other directives
        else if token.EqualsIgnoringCase('reintroduce') then
          fStack.Peek.SetAttribute(TAttributeName.anReintroduce, AttributeValues[TAttributeValue.atTrue])
        else if token.EqualsIgnoringCase('overload') then
          fStack.Peek.SetAttribute(TAttributeName.anOverload, AttributeValues[TAttributeValue.atTrue])
        else if token.EqualsIgnoringCase('abstract') then
          fStack.Peek.SetAttribute(TAttributeName.anAbstract, AttributeValues[TAttributeValue.atTrue]);

        inherited;
      end;

      method TPasSyntaxTreeBuilder.DirectiveBindingMessage;
      begin
        fStack.Peek.Attributes[TAttributeName.anMethodBinding]:= 'message';
        fStack.Push(TSyntaxNodeType.ntMessage);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.DirectiveCalling;
      begin
        fStack.Peek.SetAttribute(TAttributeName.anCallingConvention, Lexer.Token);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.DirectiveDeprecated;
      begin
        fStack.Push(TSyntaxNodeType.ntDeprecated);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;
      method TPasSyntaxTreeBuilder.DirectiveExperimental;
      begin
        fStack.Push(TSyntaxNodeType.ntExperimental);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;
      method TPasSyntaxTreeBuilder.DirectiveInline;
      begin
        fStack.Peek.Attributes[TAttributeName.anInline]:= Lexer.Token;
        inherited;
      end;
      method TPasSyntaxTreeBuilder.DirectiveLibrary;
      begin
        fStack.Push(TSyntaxNodeType.ntLibrary);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.DirectivePlatform;
      begin
        fStack.Push(TSyntaxNodeType.ntPlatform);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;
      method TPasSyntaxTreeBuilder.DirectiveSealed;
      begin
        fStack.Peek.Attributes[TAttributeName.anAbstract]:= Lexer.Token;
        inherited;
      end;
      method TPasSyntaxTreeBuilder.DirectiveVarargs;
      begin
        fStack.Push(TSyntaxNodeType.ntExternal).Attributes[TAttributeName.anKind]:= AttributeValues[TAttributeValue.atVarargs];
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.DispInterfaceForward;
      begin
        fStack.Peek.SetAttribute(TAttributeName.anForwarded, AttributeValues[TAttributeValue.atTrue]);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.DotOp;
      begin
        fStack.AddChild(TSyntaxNodeType.ntDot);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.DoubleAddressOp;
      begin
        fStack.Push(TSyntaxNodeType.ntDoubleAddr);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ElseStatement;
      begin
        fStack.Push(TSyntaxNodeType.ntElse);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.EmptyStatement;
      begin
        fStack.Push(TSyntaxNodeType.ntEmptyStatement);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.EnumeratedType;
      var
      TypeNode: TSyntaxNode;
      begin
        TypeNode := fStack.Push(TSyntaxNodeType.ntType);
        try
          TypeNode.Attributes[TAttributeName.anType]:= AttributeValues[TAttributeValue.atEnum];
          if ScopedEnums then
            TypeNode.SetAttribute(TAttributeName.anVisibility, 'scoped');
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ExceptBlock;
      begin
        fStack.Push(TSyntaxNodeType.ntExcept);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ExceptionBlockElseBranch;
      begin
        fStack.Push(TSyntaxNodeType.ntExceptElse); //#223
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ExceptionHandler;
      begin
        fStack.Push(TSyntaxNodeType.ntExceptionHandler);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ExceptionVariable;
      begin
        fStack.Push(TSyntaxNodeType.ntVariable);
  //FStack.AddValuedChild(ntName, Lexer.Token);
        fStack.AddChild(TSyntaxNodeType.ntName).Attributes[TAttributeName.anName]:= Lexer.Token;
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ExplicitType;  //#220+#181
      begin
        fStack.Peek.Attributes[TAttributeName.anKind]:= AttributeValues[TAttributeValue.atType];
        inherited;
      end;
      method TPasSyntaxTreeBuilder.ExportedHeading;
      begin
        fStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntMethod);
        try
          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ExportsClause;
      begin
        fStack.Push(TSyntaxNodeType.ntExports);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ExportsElement;
      begin
        fStack.Push(TSyntaxNodeType.ntElement);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ExportsName;
      var
      NamesNode: TSyntaxNode;
      begin
        NamesNode := new TSyntaxNode(TSyntaxNodeType.ntUnknown);
        try
          fStack.Push(NamesNode);
          try
            inherited;
          finally
            fStack.Pop;
          end;

          fStack.Peek.SetAttribute(TAttributeName.anName, NodeListToString(NamesNode));
        finally
          NamesNode := nil;
        end;
      end;

      method TPasSyntaxTreeBuilder.ExportsNameId;
      begin
        fStack.AddChild(TSyntaxNodeType.ntUnknown).SetAttribute(TAttributeName.anName, Lexer.Token);
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
        Temp := TCompoundSyntaxNode(fStack.Peek);
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
        fStack.Push(TSyntaxNodeType.ntExpressions);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ExternalDependency;
      begin
        fStack.Push(TSyntaxNodeType.ntDependency);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;
      method TPasSyntaxTreeBuilder.ExternalDirective;
      begin
        fStack.Push(TSyntaxNodeType.ntExternal).Attributes[TAttributeName.anKind]:= AttributeValues[TAttributeValue.atExternal];
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.FieldList;
      var
      Fields, Temp: TSyntaxNode;
      TypeInfo, lTypeArgs: TSyntaxNode;
      IsClassVarSection: Boolean;
      begin
        IsClassVarSection:= fStack.Peek.HasAttribute(TAttributeName.anClass);
        Fields := TSyntaxNode.Create(TSyntaxNodeType.ntFields);
        try
          fStack.Push(Fields);
          try
            inherited;
          finally
            fStack.Pop;
          end;

          TypeInfo := Fields.FindNode(TSyntaxNodeType.ntType);
          lTypeArgs := Fields.FindNode(TSyntaxNodeType.ntTypeArgs);
          for each Field in Fields.ChildNodes do
            begin
            if Field.Typ <> TSyntaxNodeType.ntName then
              Continue;

            Temp := fStack.Push(TSyntaxNodeType.ntField);
            if (IsClassVarSection) then Temp.Attributes[TAttributeName.anClass]:= AttributeValues[TAttributeValue.atTrue];
            try
              Temp.AssignPositionFrom(Field);

              fStack.AddChild(Field.Clone);
              TypeInfo := TypeInfo.Clone;
              if assigned(lTypeArgs) then
                TypeInfo.AddChild(lTypeArgs.Clone);
              fStack.AddChild(TypeInfo);
            finally
              fStack.Pop;
            end;
          end;
        finally
          Fields := nil;
        end;
      end;

      method TPasSyntaxTreeBuilder.FieldName;
      begin
  //FStack.AddValuedChild(ntName, Lexer.Token);
        fStack.AddChild(TSyntaxNodeType.ntName).Attributes[TAttributeName.anName]:= Lexer.Token;
        inherited;
      end;

      method TPasSyntaxTreeBuilder.FinalizationSection;
      begin
        fStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntFinalization);
        try
          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.FinallyBlock;
      begin
        fStack.Push(TSyntaxNodeType.ntFinally);
        try
          inherited;
        finally
          fStack.Pop;
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
        fStack.Push(TSyntaxNodeType.ntFor);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ForStatementDownTo;
      begin
        fStack.Push(TSyntaxNodeType.ntDownTo);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ForStatementFrom;
      begin
        fStack.Push(TSyntaxNodeType.ntFrom);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ForStatementIn;
      begin
        fStack.Push(TSyntaxNodeType.ntIn);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ForStatementTo;
      begin
        fStack.Push(TSyntaxNodeType.ntTo);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ForwardDeclaration;
      begin
        if fStack.Peek.ParentNode.Typ = TSyntaxNodeType.ntImplementation then begin  //#166
          fStack.Peek.Attributes[TAttributeName.anForwarded]:= AttributeValues[TAttributeValue.atTrue];
        end;
        inherited;
      end;
      method TPasSyntaxTreeBuilder.FunctionHeading;
      begin
        fStack.Peek.SetAttribute(TAttributeName.anKind, AttributeValues[TAttributeValue.atFunction]);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.FunctionMethodName;
      begin
  //FStack.AddValuedChild(ntName, Lexer.Token);
        fStack.AddChild(TSyntaxNodeType.ntName).Attributes[TAttributeName.anName]:= Lexer.Token;
        inherited;
      end;

      method TPasSyntaxTreeBuilder.FunctionProcedureName;
      var
      NameNode: TSyntaxNode;
      FullName, Dot, Comma: String;
      begin
  //Temp:= FStack.Peek;
        NameNode:= fStack.Push(TSyntaxNodeType.ntName);
        try
          inherited;
        finally
          fStack.Pop;
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
        fStack.Push(TSyntaxNodeType.ntGoto);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.Identifier;
      begin
        fStack.AddChild(TSyntaxNodeType.ntIdentifier).SetAttribute(TAttributeName.anName, Lexer.Token);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.IfStatement;
      begin
        fStack.Push(TSyntaxNodeType.ntIf);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ImplementationSection;
      begin
        fStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntImplementation);
        try
          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ImplementsSpecifier;
      begin
        fStack.Push(TSyntaxNodeType.ntImplements);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.IndexOp;
      begin
        fStack.Push(TSyntaxNodeType.ntIndexed);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.IndexSpecifier;
      begin
        fStack.Push(TSyntaxNodeType.ntIndex);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.InheritedStatement;
      begin
        fStack.Push(TSyntaxNodeType.ntInherited);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.InheritedVariableReference;
      begin
        fStack.Push(TSyntaxNodeType.ntInherited);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.InitializationSection;
      begin
        fStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntInitialization);
        try
          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.InterfaceForward;
      begin
        fStack.Peek.Attributes[TAttributeName.anForwarded]:= AttributeValues[TAttributeValue.atTrue];
        inherited InterfaceForward;
      end;

      method TPasSyntaxTreeBuilder.InterfaceGUID;
      begin
        fStack.Push(TSyntaxNodeType.ntGuid);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.InterfaceSection;
      begin
        fStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntInterface);
        try

          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          fStack.Pop;
        end;

      end;

      method TPasSyntaxTreeBuilder.InterfaceType;
      begin
        case TokenID of
          TptTokenKind.ptInterface: fStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anType, AttributeValues[TAttributeValue.atInterface]);
          TptTokenKind.ptDispinterface: fStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anType, AttributeValues[TAttributeValue.atDispInterface]);
        end; {case}
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.LabeledStatement;
      var
      Node, Name: TSyntaxNode;
      begin
        Node:= fStack.Push(TSyntaxNodeType.ntLabeledStatement);
        Name:= Node.AddChild(TSyntaxNodeType.ntName);
        Name.Attributes[TAttributeName.anName]:= Lexer.Token;
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.LabelDeclarationSection;
      begin
        fStack.Push(TSyntaxNodeType.ntLabel);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.LabelId;

      begin
        fStack.Push(TSyntaxNodeType.ntName).Attributes[TAttributeName.anName]:= Lexer.Token;
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.LibraryFile;
      begin
        fStack.Push(TSyntaxNode.Create(TSyntaxNodeType.ntLibrary));
        AssignLexerPositionToNode(Lexer, fStack.Peek);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.MainUsedUnitStatement;
      var
      NameNode, PathNode, PathLiteralNode, Temp: TSyntaxNode;
      begin
        fStack.Push(TSyntaxNodeType.ntUnit);
        try
          inherited;

          NameNode := fStack.Peek.FindNode(TSyntaxNodeType.ntUnit);

          if assigned(NameNode) then
          begin
            Temp := fStack.Peek;
            Temp.Attributes[TAttributeName.anName]:= NameNode.Attributes[TAttributeName.anName];
            Temp.DeleteChild(NameNode);
          end;

          PathNode := fStack.Peek.FindNode(TSyntaxNodeType.ntExpression);
          if assigned(PathNode) then
          begin
            fStack.Peek.ExtractChild(PathNode);
            try
              PathLiteralNode := PathNode.FindNode(TSyntaxNodeType.ntLiteral);

              if PathLiteralNode is TValuedSyntaxNode then
                fStack.Peek.SetAttribute(TAttributeName.anPath, TValuedSyntaxNode(PathLiteralNode).Value);
            finally
              PathNode := nil;
            end;
          end;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.MainUsesClause;
      begin
        fStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntUses);
        try
          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.MethodKind;
      var
      value: String;
      begin
        value := Lexer.Token.ToLower;
        DoHandleString(var value);
        fStack.Peek.SetAttribute(TAttributeName.anKind, value);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.MultiplicativeOperator;
      begin
        case TokenID of
          TptTokenKind.ptAnd:
          fStack.AddChild(TSyntaxNodeType.ntAnd);
          TptTokenKind.ptDiv:
          fStack.AddChild(TSyntaxNodeType.ntDiv);
          TptTokenKind.ptMod:
          fStack.AddChild(TSyntaxNodeType.ntMod);
          TptTokenKind.ptShl:
          fStack.AddChild(TSyntaxNodeType.ntShl);
          TptTokenKind.ptShr:
          fStack.AddChild(TSyntaxNodeType.ntShr);
          TptTokenKind.ptSlash:
          fStack.AddChild(TSyntaxNodeType.ntFDiv);
          TptTokenKind.ptStar:
          fStack.AddChild(TSyntaxNodeType.ntMul);
          else
            fStack.AddChild(TSyntaxNodeType.ntUnknown);
        end;

        inherited;
      end;

      method TPasSyntaxTreeBuilder.NamedArgument;
      begin
        fStack.Push(TSyntaxNodeType.ntNamedArgument);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.NameSpecifier;
      begin
        fStack.Push(TSyntaxNodeType.ntExternalName);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;
      method TPasSyntaxTreeBuilder.NilToken;
      var
      Node: TSyntaxNode;
      begin
        Node:= fStack.AddValuedChild(TSyntaxNodeType.ntLiteral, AttributeValues[TAttributeValue.atNil]);
        Node.Attributes[TAttributeName.anType]:= AttributeValues[TAttributeValue.atNil];
        inherited;
      end;

      method TPasSyntaxTreeBuilder.NotOp;
      begin
        fStack.AddChild(TSyntaxNodeType.ntNot);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.Number;
      var
      Node: TSyntaxNode;
      begin
        Node := fStack.AddValuedChild(TSyntaxNodeType.ntLiteral, Lexer.Token);
        Node.SetAttribute(TAttributeName.anType, AttributeValues[TAttributeValue.atNumeric]);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.ObjectForward;
      begin
        fStack.Peek.Attributes[TAttributeName.anForwarded]:= AttributeValues[TAttributeValue.atTrue];
        fStack.Peek.Attributes[TAttributeName.anType]:= AttributeValues[TAttributeValue.atObject];
        inherited;
      end;

      method TPasSyntaxTreeBuilder.ObjectNameOfMethod;
      begin
  //FStack.AddValuedChild(ntName, Lexer.Token);
        fStack.AddChild(TSyntaxNodeType.ntName).Attributes[TAttributeName.anName]:= Lexer.Token;
        inherited;
      end;

      method TPasSyntaxTreeBuilder.ObjectType;
      begin
        fStack.Push(TSyntaxNodeType.ntType).Attributes[TAttributeName.anType]:= AttributeValues[TAttributeValue.atObject];
        try
          inherited;
        finally
          MoveMembersToVisibilityNodes(fStack.Pop);
        end;
      end;

      method TPasSyntaxTreeBuilder.DoOnComment(Sender: Object; const Text: string);
      var
      Node: TCommentNode;
      begin
        case TokenID of
          TptTokenKind.ptAnsiComment: Node := new TCommentNode(TSyntaxNodeType.ntAnsiComment);
          TptTokenKind.ptBorComment: Node := new TCommentNode(TSyntaxNodeType.ntBorComment);
          TptTokenKind.ptSlashesComment: Node := new TCommentNode(TSyntaxNodeType.ntSlashesComment);
          else
            raise new EParserException(Lexer.PosXY.Y, Lexer.PosXY.X, Lexer.FileName, 'Invalid comment type');
        end;

        AssignLexerPositionToNode(Lexer, Node);
        Node.Text := Text;

        fComments.Add(Node);
      end;

      method TPasSyntaxTreeBuilder.ParserMessage(Sender: Object;
      const Typ: TMessageEventType; const Msg: string; X, Y: Integer);
      begin
        if Typ = TMessageEventType.meError then
          raise new EParserException(Y, X, Lexer.FileName, Msg);
      end;

      method TPasSyntaxTreeBuilder.OutParameter;
      begin
        fStack.Push(TSyntaxNodeType.ntParameters).SetAttribute(TAttributeName.anKind, AttributeValues[TAttributeValue.atOut]);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.PackageFile;
      begin
        fStack.Push(TSyntaxNode.Create(TSyntaxNodeType.ntPackage));
        AssignLexerPositionToNode(Lexer, fStack.Peek);
        inherited;
      end;
      method TPasSyntaxTreeBuilder.ParameterFormal;
      begin
        fStack.Push(TSyntaxNodeType.ntParameters);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ParameterName;
      begin
  //FStack.AddValuedChild(ntName, Lexer.Token);
        fStack.AddChild(TSyntaxNodeType.ntName).Attributes[TAttributeName.anName]:= Lexer.Token;
        inherited;
      end;

      method TPasSyntaxTreeBuilder.PointerSymbol;
      begin
        fStack.AddChild(TSyntaxNodeType.ntDeref);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.PointerType;
      begin
        fStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anType, AttributeValues[TAttributeValue.atPointer]);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.PositionalArgument;
      begin
        fStack.Push(TSyntaxNodeType.ntPositionalArgument);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ProceduralDirectiveOf;
      begin
        fStack.Peek.Attributes[TAttributeName.anKind]:= AttributeValues[TAttributeValue.atOf_Object];
        inherited;
      end;
      method TPasSyntaxTreeBuilder.ProceduralType;
      begin
        fStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anType, Lexer.Token);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ProcedureDeclarationSection;
      begin
        fStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntMethod);
        try
          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ProcedureHeading;
      begin
        fStack.Peek.SetAttribute(TAttributeName.anKind, AttributeValues[TAttributeValue.atProcedure]);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.ProcedureProcedureName;
      begin
  //FStack.Peek.Attribute[TAttributeName.anName, Lexer.Token);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.ProgramFile;
      begin
        fStack.Push(new TSyntaxNode(TSyntaxNodeType.ntProgram));
        AssignLexerPositionToNode(Lexer, fStack.Peek);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.PropertyName;
      begin
        fStack.Peek.SetAttribute(TAttributeName.anName, Lexer.Token);
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
        fStack.Push(TSyntaxNodeType.ntRaise);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.RecordFieldConstant;
      begin
        fStack.Push(TSyntaxNodeType.ntField).AddChild(TSyntaxNodeType.ntName).Attributes[TAttributeName.anName]:= Lexer.Token;
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.RecordType;
      begin
        inherited RecordType;
        MoveMembersToVisibilityNodes(fStack.Peek);
      end;

      method TPasSyntaxTreeBuilder.RelativeOperator;
      begin
        case TokenID of
          TptTokenKind.ptAs:
          fStack.AddChild(TSyntaxNodeType.ntAs);
          TptTokenKind.ptEqual:
          fStack.AddChild(TSyntaxNodeType.ntEqual);
          TptTokenKind.ptGreater:
          fStack.AddChild(TSyntaxNodeType.ntGreater);
          TptTokenKind.ptGreaterEqual:
          fStack.AddChild(TSyntaxNodeType.ntGreaterEqual);
          TptTokenKind.ptIn:
          fStack.AddChild(TSyntaxNodeType.ntIn);
          TptTokenKind.ptIs:
          fStack.AddChild(TSyntaxNodeType.ntIs);
          TptTokenKind.ptLower:
          fStack.AddChild(TSyntaxNodeType.ntLower);
          TptTokenKind.ptLowerEqual:
          fStack.AddChild(TSyntaxNodeType.ntLowerEqual);
          TptTokenKind.ptNotEqual:
          fStack.AddChild(TSyntaxNodeType.ntNotEqual);
          else
            fStack.AddChild(TSyntaxNodeType.ntUnknown);
        end;

        inherited;
      end;

      method TPasSyntaxTreeBuilder.RepeatStatement;
      begin
        fStack.Push(TSyntaxNodeType.ntRepeat);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.RequiresClause;
      begin
        fStack.Push(TSyntaxNodeType.ntRequires);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.RequiresIdentifier;
      var
      NamesNode: TSyntaxNode;
      begin
        NamesNode := new TSyntaxNode(TSyntaxNodeType.ntUnknown);
        try
          fStack.Push(NamesNode);
          try
            inherited;
          finally
            fStack.Pop;
          end;

          fStack.AddChild(TSyntaxNodeType.ntPackage).SetAttribute(TAttributeName.anName, NodeListToString(NamesNode));
        finally
          NamesNode := nil;
        end;
      end;

      method TPasSyntaxTreeBuilder.RequiresIdentifierId;
      begin
        fStack.AddChild(TSyntaxNodeType.ntUnknown).SetAttribute(TAttributeName.anName, Lexer.Token);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.Resident;
      begin
        fStack.Push(TSyntaxNodeType.ntResident);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;
      method TPasSyntaxTreeBuilder.ResourceDeclaration;
      begin
        fStack.Push(TSyntaxNodeType.ntResourceString);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ResourceValue;
      begin
        fStack.Push(TSyntaxNodeType.ntValue);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.ReturnType;
      begin
        fStack.Push(TSyntaxNodeType.ntReturnType);
        try
          inherited;
        finally
          fStack.Pop
        end;
      end;

      method TPasSyntaxTreeBuilder.RoundClose;
      begin
        fStack.AddChild(TSyntaxNodeType.ntRoundClose);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.RoundOpen;
      begin
        fStack.AddChild(TSyntaxNodeType.ntRoundOpen);
        inherited;
      end;


      method TPasSyntaxTreeBuilder.NodeListToString(NamesNode: TSyntaxNode): not nullable string;
      begin
        result := '';
        for NamePartNode in NamesNode.ChildNodes do
          begin
          if (result <> '') then
            result := result + '.';
          result := result + NamePartNode.AttribName;
        end;
        DoHandleString(var result);
      end;

      method TPasSyntaxTreeBuilder.SetConstructor;
      begin
        fStack.Push(TSyntaxNodeType.ntSet);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.SetElement;
      begin
        fStack.Push(TSyntaxNodeType.ntElement);
        try
          inherited;
        finally
          fStack.Pop;
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
          fStack.Push(RawStatement);
          try
            inherited;
          finally
            fStack.Pop;
          end;

          if not RawStatement.HasChildren then
            Exit;

          if RawStatement.FindNode(TSyntaxNodeType.ntAssign) <> nil then
          begin
            Temp := fStack.Push(TSyntaxNodeType.ntAssign);
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

                LHS := fStack.AddChild(TSyntaxNodeType.ntLHS);
                LHS.AssignPositionFrom(NodeList[0]);

                TExpressionTools.RawNodeListToTree(RawStatement, NodeList, LHS);

                NodeList.RemoveAll;

                for I := AssignIdx + 1 to length(RawStatement.ChildNodes) - 1 do
                  NodeList.Add(RawStatement.ChildNodes[I]);

                if NodeList.Count = 0 then
                  raise new EParserException(Position.Y, Position.X, Lexer.FileName, 'Illegal expression');

                RHS := fStack.AddChild(TSyntaxNodeType.ntRHS);
                RHS.AssignPositionFrom(NodeList[0]);

                TExpressionTools.RawNodeListToTree(RawStatement, NodeList, RHS);
              finally
                NodeList := nil;
              end;
            finally
              fStack.Pop;
            end;
          end else
          begin
            Temp := fStack.Push(TSyntaxNodeType.ntCall);
            try
              Temp.Col := Position.X;
              Temp.Line := Position.Y;

              NodeList := new List<TSyntaxNode>;
              try
                for Node in RawStatement.ChildNodes do
                  NodeList.Add(Node);
                TExpressionTools.RawNodeListToTree(RawStatement, NodeList, fStack.Peek);
              finally
                NodeList := nil;
              end;
            finally
              fStack.Pop;
            end;
          end;
        finally
          RawStatement := nil;
        end;
      end;

      method TPasSyntaxTreeBuilder.SimpleType;
      begin
        fStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anName, Lexer.Token);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.StatementList;
      begin
        fStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntStatements);
        try
          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.StorageDefault;
      begin
        fStack.Push(TSyntaxNodeType.ntDefault);
        try
          inherited;
        finally
          fStack.Pop;
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
          fStack.Push(StrConst);
          try
            inherited;
          finally
            fStack.Pop;
          end;

          Str := '';
          for Literal in StrConst.ChildNodes do
            Str := Str + TValuedSyntaxNode(Literal).Value;
        finally
          StrConst := nil;
        end;

        DoHandleString(var Str);
        Node := fStack.AddValuedChild(TSyntaxNodeType.ntLiteral, Str);
        Node.SetAttribute(TAttributeName.anType, AttributeValues[TAttributeValue.atString]);
      end;

      method TPasSyntaxTreeBuilder.StringConstSimple;
      begin
  //TODO support ptAsciiChar
        fStack.AddValuedChild(TSyntaxNodeType.ntLiteral, StrHelper.AnsiDequotedStr(Lexer.Token, ''''));
  //FStack.AddValuedChild(TSyntaxNodeType.ntLiteral, Lexer.Token);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.StringStatement;
      begin
        fStack.AddChild(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anName, Lexer.Token);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.StructuredType;
      begin
        fStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anType, Lexer.Token);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.SubrangeType;
      begin
        fStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anName, AttributeValues[TAttributeValue.atSubRange]);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.TagField;
      var
      TagNode: TSyntaxNode;
      TypeNode: TSyntaxNode;
      begin
        TagNode:= fStack.Push(TSyntaxNodeType.ntCaseSelector);
        TagNode.Attributes[TAttributeName.anKind]:= Lexer.Token;
        try
          inherited;
          TypeNode:= fStack.Peek.FindNode(TSyntaxNodeType.ntIdentifier);
          if (assigned(TypeNode)) then begin
            TagNode.Attributes[TAttributeName.anName]:= TagNode.Attributes[TAttributeName.anKind];
            TagNode.Attributes[TAttributeName.anKind]:= TypeNode.Attributes[TAttributeName.anKind];
            TagNode.DeleteChild(TypeNode);
          end;
        finally
          fStack.Pop;
        end;
      end;
      method TPasSyntaxTreeBuilder.TagFieldTypeName;
      begin
        fStack.Push(TSyntaxNodeType.ntIdentifier).Attributes[TAttributeName.anKind]:= Lexer.Token;
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;
      method TPasSyntaxTreeBuilder.ThenStatement;
      begin
        fStack.Push(TSyntaxNodeType.ntThen);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.TryStatement;
      begin
        fStack.Push(TSyntaxNodeType.ntTry);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.TypeArgs;
      begin
        fStack.Push(TSyntaxNodeType.ntTypeArgs);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.TypeDeclaration;
      begin
        fStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntTypeDecl).SetAttribute(TAttributeName.anName, Lexer.Token);
        try
          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.TypeId;
      var
      TypeNode, InnerTypeNode, SubNode: TSyntaxNode;
      TypeName, InnerTypeName: String;
      i: Integer;
      begin
        TypeNode := fStack.Push(TSyntaxNodeType.ntType);
        try
          inherited;

          InnerTypeName := '';
          InnerTypeNode := TypeNode.FindNode(TSyntaxNodeType.ntType);
          if assigned(InnerTypeNode) then
          begin
            InnerTypeName := InnerTypeNode.AttribName;
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

              TypeName := SubNode.AttribName + TypeName;
              TypeNode.DeleteChild(SubNode);
            end;
          end;

          if TypeName <> '' then
            TypeName := '.' + TypeName;
          TypeName := InnerTypeName + TypeName;

          DoHandleString(var TypeName);
          TypeNode.SetAttribute(TAttributeName.anName, TypeName);
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.TypeParamDecl;
      var
      OriginTypeParamNode, NewTypeParamNode, Constraints: TSyntaxNode;
      TypeNodeCount: Integer;
      TypeNodesToDelete: List<TSyntaxNode>;
      begin
        OriginTypeParamNode := fStack.Push(TSyntaxNodeType.ntTypeParam);
        try
          inherited;
        finally
          fStack.Pop;
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
                NewTypeParamNode := fStack.Push(TSyntaxNodeType.ntTypeParam);
                try
                  NewTypeParamNode.AddChild(TypeNode.Clone);
                  if assigned(Constraints) then
                    NewTypeParamNode.AddChild(Constraints.Clone);
                  TypeNodesToDelete.Add(TypeNode);
                finally
                  fStack.Pop;
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
        fStack.Push(TSyntaxNodeType.ntTypeParams);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.TypeSection;
      begin
        fStack.Push(TSyntaxNodeType.ntTypeSection);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.TypeSimple;
      begin
        fStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anName, Lexer.Token);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.UnaryMinus;
      begin
        fStack.AddChild(TSyntaxNodeType.ntUnaryMinus);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.UnitFile;
      begin
         //Assert(FStack.Peek.ParentNode = nil);
        fStack.Push(TSyntaxNode.Create(TSyntaxNodeType.ntUnit));
        AssignLexerPositionToNode(Lexer, fStack.Peek);
        inherited;
         //Stack.pop is done in `Run`
      end;

      method TPasSyntaxTreeBuilder.UnitId;
      begin
        fStack.AddChild(TSyntaxNodeType.ntUnknown).SetAttribute(TAttributeName.anName, Lexer.Token);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.UnitName;
      var
      NamesNode: TSyntaxNode;
      begin
        NamesNode := new TSyntaxNode(TSyntaxNodeType.ntUnknown);
        try
          fStack.Push(NamesNode);
          try
            inherited;
          finally
            fStack.Pop;
          end;

          fStack.Peek.SetAttribute(TAttributeName.anName, NodeListToString(NamesNode));
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
          fStack.Push(NamesNode);
          try
            inherited;
          finally
            fStack.Pop;
          end;

          UnitNode := fStack.AddChild(TSyntaxNodeType.ntUnit);
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
        fStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntUses);
        try
          inherited;
          SetCurrentCompoundNodesEndPosition;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.VarAbsolute;
      var
      AbsoluteNode: TSyntaxNode;
      ValueNode: TSyntaxNode;
      begin
        AbsoluteNode:= new TSyntaxNode(TSyntaxNodeType.ntUnknown);
        fStack.Push(AbsoluteNode);
        try
          inherited;
        finally
          fStack.Pop;
          ValueNode:=   AbsoluteNode.ExtractChild(AbsoluteNode.ChildNodes[0] );
          ValueNode.Attributes[TAttributeName.anKind]:= AttributeValues[TAttributeValue.atAbsolute];
          AbsoluteNode := nil;
          fStack.Peek.AddChild(ValueNode);
        end;
      end;

      method TPasSyntaxTreeBuilder.VarDeclaration;
      begin
        fStack.Push(TSyntaxNodeType.ntVariables);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.RecordVariantSection;
      begin
        fStack.Push(TSyntaxNodeType.ntVariantSection);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.RecordVariantTag;
      var
      Temp: TSyntaxNode;
      begin
        Temp:= fStack.Push(TSyntaxNodeType.ntVariantTag);

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
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.VarName;
      begin
        fStack.AddChild(TSyntaxNodeType.ntName).Attributes[TAttributeName.anName]:= Lexer.Token; //#222
        inherited;
      end;

      method TPasSyntaxTreeBuilder.VarParameter;
      begin
        fStack.Push(TSyntaxNodeType.ntParameters).Attributes[TAttributeName.anKind]:= AttributeValues[TAttributeValue.atVar];
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.VarSection;
      var
      VarSect, Temp: TSyntaxNode;
      TypeInfo, ValueInfo: TSyntaxNode;
      begin
        VarSect := new TSyntaxNode(TSyntaxNodeType.ntUnknown);
        try
          fStack.Push(TSyntaxNodeType.ntVariables);
          fStack.Push(VarSect);
          try
            inherited VarSection;
          finally
            fStack.Pop;
          end;
          for each VarList in VarSect.ChildNodes do
            begin
            TypeInfo := VarList.FindNode(TSyntaxNodeType.ntType);
            ValueInfo := VarList.FindNode(TSyntaxNodeType.ntValue);
            for each Variable in VarList.ChildNodes do
              begin
              if Variable.Typ <> TSyntaxNodeType.ntName then
                Continue;

              Temp := fStack.Push(TSyntaxNodeType.ntVariable);
              try
                Temp.AssignPositionFrom(Variable);

                fStack.AddChild(Variable.Clone);
                if assigned(TypeInfo) then
                  fStack.AddChild(TypeInfo.Clone);

                if assigned(ValueInfo) then
                  fStack.AddChild(ValueInfo.Clone);
              finally
                fStack.Pop;
              end;
            end;
          end;
          fStack.Pop;
        finally
          VarSect := nil;
        end;
      end;

      method TPasSyntaxTreeBuilder.VisibilityStrictPrivate;
      var
      Temp: TSyntaxNode;
      begin
        Temp := fStack.Push(TSyntaxNodeType.ntStrictPrivate);
        try
          Temp.SetAttribute(TAttributeName.anVisibility, AttributeValues[TAttributeValue.atTrue]);
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.VisibilityPrivate;
      var
      Temp: TSyntaxNode;
      begin
        Temp := fStack.Push(TSyntaxNodeType.ntPrivate);
        try
          Temp.SetAttribute(TAttributeName.anVisibility, AttributeValues[TAttributeValue.atTrue]);
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.VisibilityStrictProtected;
      var
      Temp: TSyntaxNode;
      begin
        Temp := fStack.Push(TSyntaxNodeType.ntStrictProtected);
        try
          Temp.SetAttribute(TAttributeName.anVisibility, AttributeValues[TAttributeValue.atTrue]);
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.VisibilityProtected;
      var
      Temp: TSyntaxNode;
      begin
        Temp := fStack.Push(TSyntaxNodeType.ntProtected);
        try
          Temp.SetAttribute(TAttributeName.anVisibility, AttributeValues[TAttributeValue.atTrue]);
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.VisibilityPublic;
      var
      Temp: TSyntaxNode;
      begin
        Temp := fStack.Push(TSyntaxNodeType.ntPublic);
        try
          Temp.SetAttribute(TAttributeName.anVisibility, AttributeValues[TAttributeValue.atTrue]);
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.VisibilityPublished;
      var
      Temp: TSyntaxNode;
      begin
        Temp := fStack.Push(TSyntaxNodeType.ntPublished);
        try
          Temp.SetAttribute(TAttributeName.anVisibility, AttributeValues[TAttributeValue.atTrue]);
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.VisibilityAutomated;
      var
      Temp: TSyntaxNode;
      begin
        Temp := fStack.Push(TSyntaxNodeType.ntAutomated);
        try
          Temp.Attributes[TAttributeName.anVisibility]:= AttributeValues[TAttributeValue.atTrue];
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.WhileStatement;
      begin
        fStack.Push(TSyntaxNodeType.ntWhile);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.WithExpressionList;
      begin
        fStack.Push(TSyntaxNodeType.ntExpressions);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.WithStatement;
      begin
        fStack.Push(TSyntaxNodeType.ntWith);
        try
          inherited;
        finally
          fStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.RunWithString(const Context: not nullable String; const aCompiler : DelphiCompiler = DelphiCompiler.Default): TSyntaxNode;
      begin

        try
          fStack.Clear;
          try
            self.OnMessage := @ParserMessage;
            inherited RunWithString(Context);
          finally
            if fStack.Count > 0 then
              Result := fStack.Pop;
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

        assert(fStack.Count = 0);
      end;

      class method TPasSyntaxTreeBuilder.RunWithString(const Context: not nullable String; InterfaceOnly: Boolean := false; const aCompiler : DelphiCompiler = DelphiCompiler.Default; IncludeHandler: IIncludeHandler := nil; OnHandleString: TStringEvent := nil): TSyntaxNode;
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

      method TPasSyntaxTreeBuilder.ElementsFile;
      begin
        fStack.Push(TSyntaxNode.Create(TSyntaxNodeType.ntNamespace));
        AssignLexerPositionToNode(Lexer, fStack.Peek);
        inherited;
      end;

end.