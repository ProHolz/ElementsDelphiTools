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
   // method AssignLexerPositionToNode(const Lexer: TPasLexer; const Node: TSyntaxNode);
type
    TTreeBuilderMethod = block ();//method of object;
  private
    method BuildExpressionTree(ExpressionMethod: TTreeBuilderMethod);
    method BuildParametersList(ParametersListMethod: TTreeBuilderMethod);
    method RearrangeVarSection(const VarSect: TSyntaxNode);
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
    method ArrayBounds; override;
    method ArrayConstant; override;
    method ArrayDimension; override;
    method AsmStatement; override;
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
    method DirectiveBinding; override;
    method DirectiveBindingMessage; override;
    method DirectiveCalling; override;
    method DirectiveInline; override;
    method DispInterfaceForward; override;
    method DotOp; override;
    method ElseStatement; override;
    method EmptyStatement; override;
    method EnumeratedType; override;
    method ExceptBlock; override;
    method ExceptionBlockElseBranch; override;
    method ExceptionHandler; override;
    method ExceptionVariable; override;
    method ExportedHeading; override;
    method ExportsClause; override;
    method ExportsElement; override;
    method ExportsName; override;
    method ExportsNameId; override;
    method Expression; override;
    method ExpressionList; override;
    method ExternalDirective; override;
    method FieldName; override;
    method FinalizationSection; override;
    method FinallyBlock; override;
    method FormalParameterList; override;
    method ForStatement; override;
    method ForStatementDownTo; override;
    method ForStatementFrom; override;
    method ForStatementIn; override;
    method ForStatementTo; override;
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
    method InlineVarDeclaration; override;
    method InlineVarSection; override;
    method InterfaceForward; override;
    method InterfaceGUID; override;
    method InterfaceSection; override;
    method InterfaceType; override;
    method LabelId; override;
    method MainUsesClause; override;
    method MainUsedUnitStatement; override;
    method MethodKind; override;
    method MultiplicativeOperator; override;
    method NotOp; override;
    method NilToken; override;
    method Number; override;
    method ObjectNameOfMethod; override;
    method OutParameter; override;
    method ParameterFormal; override;
    method ParameterName; override;
    method PointerSymbol; override;
    method PointerType; override;
    method ProceduralType; override;
    method ProcedureHeading; override;
    method ProcedureDeclarationSection; override;
    method ProcedureProcedureName; override;
    method PropertyName; override;
    method PropertyParameterList; override;
    method RaiseStatement; override;
    method RecordConstraint; override;
    method RecordFieldConstant; override;
    method RecordType; override;
    method RelativeOperator; override;
    method RepeatStatement; override;
    method ResourceDeclaration; override;
    method ResourceValue; override;
    method RequiresClause; override;
    method RequiresIdentifier; override;
    method RequiresIdentifierId; override;
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
    method VarDeclaration; override;
    method VarName; override;
    method VarParameter; override;
    method VarSection; override;
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
  TAttributeValue = (atAsm, atTrue, atFunction, atProcedure, atClassOf, atClass,
    atConst, atConstructor, atDestructor, atEnum, atInterface, atNil, atNumeric,
    atOut, atPointer, atName, atString, atSubRange, atVar, atDispInterface, atOperator);

    var
      AttributeValues: array[TAttributeValue] of String := [
      'Asm',
      'True',
      'Function',
      'Procedure',
      'ClassOf',
      'Class',
      'Const',
      'Constructor',
      'Destructor',
      'Enum',
      'Interface',
      'Nil',
      'Numeric',
      'Out',
      'Pointer',
      'Name',
      'String',
      'SubRange',
      'Var',
      'DispInterface',
      'Operator'

      ]; readonly;

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
        Result := FLexer.Buffer.FileName;
      end;

      method TPasLexer.GetPosXY: TTokenPoint;
      begin
        Result := FLexer.PosXY;
      end;

      method TPasLexer.GetToken: not nullable string;
      begin
        Result := FLexer.Buffer.Buf.Substring(FLexer.TokenPos, FLexer.TokenLen);
        FOnHandleString(var Result);
      end;

{ TNodeStack }

      method TNodeStack.AddChild(Typ: TSyntaxNodeType): TSyntaxNode;
      begin
        Result := FStack.Peek.AddChild(new TSyntaxNode(Typ));
        AssignLexerPositionToNode(FLexer, Result);
      end;

      method TNodeStack.AddChild(Node: TSyntaxNode): TSyntaxNode;
      begin
        Result := FStack.Peek.AddChild(Node);
      end;

      method TNodeStack.AddValuedChild(Typ: TSyntaxNodeType;
      const Value: not nullable string): TSyntaxNode;
      begin
        Result := new TValuedSyntaxNode(Typ);
        FStack.Peek.AddChild(Result);
        AssignLexerPositionToNode(FLexer, Result);
        TValuedSyntaxNode(Result).Value := Value;
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
        Result := FStack.Count;
      end;

      method TNodeStack.Peek: TSyntaxNode;
      begin
        Result := FStack.Peek;
      end;

      method TNodeStack.Pop: TSyntaxNode;
      begin
        Result := FStack.Pop;
      end;

      method TNodeStack.Push(Node: TSyntaxNode): TSyntaxNode;
      begin
        FStack.Push(Node);
        Result := Node;
        AssignLexerPositionToNode(FLexer, Result);
      end;

      method TNodeStack.PushCompoundSyntaxNode(Typ: TSyntaxNodeType): TSyntaxNode;
      begin
        Result := Push(Peek.AddChild(new TCompoundSyntaxNode(Typ)));
      end;

      method TNodeStack.PushValuedNode(Typ: TSyntaxNodeType;
      const Value: not nullable string): TSyntaxNode;
      begin
        Result := Push(Peek.AddChild(new TValuedSyntaxNode(Typ)));
        TValuedSyntaxNode(Result).Value := Value;
      end;

      method TNodeStack.Push(Typ: TSyntaxNodeType): TSyntaxNode;
      begin
        Result := FStack.Peek.AddChild(new TSyntaxNode(Typ));
        Push(Result);
      end;

{ TPasSyntaxTreeBuilder }

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
        FStack.Push(TSyntaxNodeType.ntAnonymousMethod);
        try
          inherited;
        finally
          FStack.Pop;
        end;
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

      method TPasSyntaxTreeBuilder.AsmStatement;
      begin
        FStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntStatements).SetAttribute(TAttributeName.anType, AttributeValues[TAttributeValue.atAsm]);
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
        FStack.AddValuedChild(TSyntaxNodeType.ntName, Lexer.Token);
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
        FStack.AddValuedChild(TSyntaxNodeType.ntName, Lexer.Token);
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

            for &Param in ParamList.ChildNodes do
              begin
              if &Param.Typ <> TSyntaxNodeType.ntName then
                Continue;

              Temp := FStack.Push(TSyntaxNodeType.ntParameter);
              if ParamKind <> '' then
                Temp.SetAttribute(TAttributeName.anKind, ParamKind);

              Temp.Col := &Param.Col;
              Temp.Line := &Param.Line;

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

      method TPasSyntaxTreeBuilder.ClassClass;
      begin
        FStack.Peek.SetAttribute(TAttributeName.anClass, AttributeValues[TAttributeValue.atTrue]);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.ClassField;
      var
      Fields, Temp: TSyntaxNode;
      TypeInfo, lTypeArgs: TSyntaxNode;
      begin
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
        inherited ClassForward;
      end;

      method TPasSyntaxTreeBuilder.ClassFunctionHeading;
      begin
        if FLexer.Token.EqualsIgnoringCase('operator') then FStack.Peek.SetAttribute(TAttributeName.anKind, AttributeValues[TAttributeValue.atOperator])
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
      begin
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
        FStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anType, AttributeValues[TAttributeValue.atClassOf]);
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
      begin
        Temp := FStack.Peek;
        Temp.SetAttribute(TAttributeName.anKind, AttributeValues[TAttributeValue.atConstructor]);
        Temp.SetAttribute(TAttributeName.anName, Lexer.Token);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.CompoundStatement;
      begin
        FStack.PushCompoundSyntaxNode(TSyntaxNodeType.ntStatements);
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
        FStack.AddValuedChild(TSyntaxNodeType.ntName, Lexer.Token);
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
          FStack.Push(TSyntaxNodeType.ntConstants);

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
      begin
        Temp := FStack.Peek;
        Temp.SetAttribute(TAttributeName.anKind, AttributeValues[TAttributeValue.atDestructor]);
        Temp.SetAttribute(TAttributeName.anName, Lexer.Token);
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

      method TPasSyntaxTreeBuilder.DirectiveInline;
      begin
        FStack.Peek.SetAttribute(TAttributeName.anInline, AttributeValues[TAttributeValue.atTrue]);
        inherited;
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
          TypeNode.SetAttribute(TAttributeName.anName, AttributeValues[TAttributeValue.atEnum]);
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
        FStack.Push(TSyntaxNodeType.ntElse);
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
        FStack.AddValuedChild(TSyntaxNodeType.ntName, Lexer.Token);
        try
          inherited;
        finally
          FStack.Pop;
        end;
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

      method TPasSyntaxTreeBuilder.ExternalDirective;
      begin
        FStack.Push(TSyntaxNodeType.ntExternal);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.FieldName;
      begin
        FStack.AddValuedChild(TSyntaxNodeType.ntName, Lexer.Token);
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

      method TPasSyntaxTreeBuilder.FunctionHeading;
      begin
        FStack.Peek.SetAttribute(TAttributeName.anKind, AttributeValues[TAttributeValue.atFunction]);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.FunctionMethodName;
      begin
        FStack.AddValuedChild(TSyntaxNodeType.ntName, Lexer.Token);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.FunctionProcedureName;
      var
      NameNode, TypeNode, Temp: TSyntaxNode;
      FullName, lTypeParams: String;
      begin
        FullName := nil;
        FStack.Push(TSyntaxNodeType.ntName);
        NameNode := FStack.Peek;
        try
          inherited;
          for ChildNode in NameNode.ChildNodes do
            begin
            if ChildNode.Typ = TSyntaxNodeType.ntTypeParams then
            begin
              lTypeParams := nil;

              for TypeParam in ChildNode.ChildNodes do
                begin
                TypeNode := TypeParam.FindNode(TSyntaxNodeType.ntType);
                if assigned(TypeNode) then
                begin
                  if lTypeParams <> nil then
                    lTypeParams := lTypeParams + ',';
                  lTypeParams := lTypeParams + TypeNode.GetAttribute(TAttributeName.anName);
                end;
              end;

              FullName := FullName + '<' + lTypeParams + '>';
              Continue;
            end;

            if not String.isNullOrEmpty( FullName) then
              FullName := FullName + '.';
            FullName := FullName + TValuedSyntaxNode(ChildNode).Value;
          end;
        finally
          FStack.Pop;
          Temp := FStack.Peek;
          DoHandleString(var FullName);
          Temp.SetAttribute(TAttributeName.anName, FullName);
          Temp.DeleteChild(NameNode);
        end;
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

      method TPasSyntaxTreeBuilder.InlineVarDeclaration;
      begin
        FStack.Push(TSyntaxNodeType.ntVariables);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.InlineVarSection;
      var
      VarSect, Variables, lExpression: TSyntaxNode;
      begin
        VarSect := new TSyntaxNode(TSyntaxNodeType.ntUnknown);
        try
          Variables := FStack.Push(TSyntaxNodeType.ntVariables);

          FStack.Push(VarSect);
          try
            inherited InlineVarSection;
          finally
            FStack.Pop;
          end;
          RearrangeVarSection(VarSect);
          lExpression := VarSect.FindNode(TSyntaxNodeType.ntExpression);
          if assigned(lExpression) then
            Variables.AddChild(TSyntaxNodeType.ntAssign).AddChild(lExpression.Clone);

          FStack.Pop;
        finally
          VarSect := nil;
        end;
      end;

      method TPasSyntaxTreeBuilder.InterfaceForward;
      begin
        FStack.Peek.SetAttribute(TAttributeName.anForwarded, AttributeValues[TAttributeValue.atTrue]);
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
          TptTokenKind.ptInterface:
          FStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anType, AttributeValues[TAttributeValue.atInterface]);
          TptTokenKind.ptDispinterface:
          FStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anType, AttributeValues[TAttributeValue.atDispInterface]);
        end;
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.LabelId;
      begin
        FStack.AddValuedChild(TSyntaxNodeType.ntLabel, Lexer.Token);
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
            Temp.SetAttribute(TAttributeName.anName, NameNode.GetAttribute(TAttributeName.anName));
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

      method TPasSyntaxTreeBuilder.NilToken;
      begin
        FStack.AddChild(TSyntaxNodeType.ntLiteral).SetAttribute(TAttributeName.anType, AttributeValues[TAttributeValue.atNil]);
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

      method TPasSyntaxTreeBuilder.ObjectNameOfMethod;
      begin
        FStack.AddValuedChild(TSyntaxNodeType.ntName, Lexer.Token);
        inherited;
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
        FStack.AddValuedChild(TSyntaxNodeType.ntName, Lexer.Token);
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

      method TPasSyntaxTreeBuilder.ProceduralType;
      begin
        FStack.Push(TSyntaxNodeType.ntType).SetAttribute(TAttributeName.anName, Lexer.Token);
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
        FStack.Peek.SetAttribute(TAttributeName.anName, Lexer.Token);
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
      var
      Node: TSyntaxNode;
      begin
        Node := FStack.PushValuedNode(TSyntaxNodeType.ntField, Lexer.Token);
        if Node is TValuedSyntaxNode then
        begin
          var s:= (Node as TValuedSyntaxNode).Value;
          if s='' then;
        end;
        try
          Node.SetAttribute(TAttributeName.anType, AttributeValues[TAttributeValue.atName]);
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
        Result := '';
        for NamePartNode in NamesNode.ChildNodes do
          begin
          if Result <> '' then
            Result := Result + '.';
          Result := Result + NamePartNode.GetAttribute(TAttributeName.anName);
        end;
        DoHandleString(var Result);
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
      var
      Temp: TSyntaxNode;
      begin
        Temp := FStack.Peek;
        AssignLexerPositionToNode(Lexer, Temp);
        inherited;
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

      method TPasSyntaxTreeBuilder.VarDeclaration;
      begin
        FStack.Push(TSyntaxNodeType.ntVariables);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.VarName;
      begin
        FStack.AddValuedChild(TSyntaxNodeType.ntName, Lexer.Token);
        inherited;
      end;

      method TPasSyntaxTreeBuilder.VarParameter;
      begin
        FStack.Push(TSyntaxNodeType.ntParameters).SetAttribute(TAttributeName.anKind, AttributeValues[TAttributeValue.atVar]);
        try
          inherited;
        finally
          FStack.Pop;
        end;
      end;

      method TPasSyntaxTreeBuilder.VarSection;
      var
      VarSect: TSyntaxNode;
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

          RearrangeVarSection(VarSect);
          FStack.Pop;
        finally
          VarSect := nil;
        end;
      end;

      method TPasSyntaxTreeBuilder.RearrangeVarSection(const VarSect: TSyntaxNode);
      var
      Temp: TSyntaxNode;
      TypeInfo, ValueInfo: TSyntaxNode;
      begin
        for VarList in VarSect.ChildNodes do
          begin
          TypeInfo := VarList.FindNode(TSyntaxNodeType.ntType);
          ValueInfo := VarList.FindNode(TSyntaxNodeType.ntValue);
          for Variable in VarList.ChildNodes do
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
        Result := new TSyntaxNode(TSyntaxNodeType.ntUnit);
        try
          FStack.Clear;
          FStack.Push(Result);
          try
            self.OnMessage := @ParserMessage;
            inherited RunWithString(Context);


          finally
            FStack.Pop;
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
        Result := Builder.RunWithString(Context, aCompiler);


        //var withComments : Boolean := false;
        //if withComments then
        //begin
          //var lComments := Result.AddChild(TSyntaxNodeType.ntComments);
          //for each Comment in Builder.Comments do
            //lComments.AddChild(Comment.Clone);
        //end;


      end;

end.