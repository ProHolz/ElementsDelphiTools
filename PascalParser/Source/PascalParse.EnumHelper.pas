namespace ProHolz.Ast;

type
  {$IF ECHOES}
   TsyntaxNodeTypeSet = set of TSyntaxNodeType;
  {$ELSE}
  TsyntaxNodeTypeSet = &Set<TSyntaxNodeType>;
  {$ENDIF}

//  TSyntaxNodeType
  const
    // Binary Operators

    TSyntaxnodeTypeBinaryOperator : TsyntaxNodeTypeSet =[
    TSyntaxNodeType.ntAdd,
    TSyntaxNodeType.ntSub,
    TSyntaxNodeType.ntMul,
    TSyntaxNodeType.ntFDiv,
    TSyntaxNodeType.ntDiv,
    TSyntaxNodeType.ntMod,
    TSyntaxNodeType.ntEqual,
    TSyntaxNodeType.ntNotEqual,
    TSyntaxNodeType.ntLower,
    TSyntaxNodeType.ntLowerEqual,
    TSyntaxNodeType.ntGreater,
    TSyntaxNodeType.ntGreaterEqual,
    TSyntaxNodeType.ntAnd,
    TSyntaxNodeType.ntOr,
    TSyntaxNodeType.ntXor,
    TSyntaxNodeType.ntShl,
    TSyntaxNodeType.ntShr,
    TSyntaxNodeType.ntIs,
    TSyntaxNodeType.ntIn
    ];

  // UNary Operators
    TSyntaxnodeTypeUnaryOperator : TsyntaxNodeTypeSet =[
    TSyntaxNodeType.ntAddr,
    TSyntaxNodeType.ntNot,
    TSyntaxNodeType.ntUnaryMinus
    ];


// Statement
    TSyntaxnodeTypeStatement : TsyntaxNodeTypeSet =[
    TSyntaxNodeType.ntCall,
    TSyntaxNodeType.ntAssign,
    TSyntaxNodeType.ntIf,
    TSyntaxNodeType.ntInherited,
    TSyntaxNodeType.ntStatements,
    TSyntaxNodeType.ntFor,
    TSyntaxNodeType.ntWhile,
    TSyntaxNodeType.ntRepeat,
    TSyntaxNodeType.ntCase,
    TSyntaxNodeType.ntCaseElse,
    TSyntaxNodeType.ntEmptyStatement,
    TSyntaxNodeType.ntTry,
    TSyntaxNodeType.ntWith,
    TSyntaxNodeType.ntAsmStatement,
    TSyntaxNodeType.ntAsmFragment,
    TSyntaxNodeType.ntExpression,
    TSyntaxNodeType.ntRaise,
    TSyntaxNodeType.ntLabeledStatement
  ];


// Expressions
    TSyntaxnodeTypeExpression : TsyntaxNodeTypeSet =[
    TSyntaxNodeType.ntIndexed,
    TSyntaxNodeType.ntExpression,
    TSyntaxNodeType.ntExpressions,
    TSyntaxNodeType.ntCall,
    TSyntaxNodeType.ntAs,
    TSyntaxNodeType.ntDeref,
    TSyntaxNodeType.ntDot,
    TSyntaxNodeType.ntAt,
    TSyntaxNodeType.ntBounds,
    TSyntaxNodeType.ntElement,
    TSyntaxNodeType.ntIdentifier,
    TSyntaxNodeType.ntInherited,
    TSyntaxNodeType.ntAnonymousMethod,

    TSyntaxNodeType.ntLHS,
     TSyntaxNodeType.ntLiteral,
    TSyntaxNodeType.ntName,
    TSyntaxNodeType.ntParameter,
    TSyntaxNodeType.ntParameters,
    TSyntaxNodeType.ntRead,
    TSyntaxNodeType.ntRecordConstant,
    TSyntaxNodeType.ntReturnType,
    TSyntaxNodeType.ntRHS,
    TSyntaxNodeType.ntRoundClose,
    TSyntaxNodeType.ntRoundOpen,
    TSyntaxNodeType.ntSet,
    TSyntaxNodeType.ntType,
    TSyntaxNodeType.ntValue,
    TSyntaxNodeType.ntWrite,
    TSyntaxNodeType.ntGoto,
    TSyntaxNodeType.ntGeneric,
    TSyntaxNodeType.ntField,
    TSyntaxNodeType.ntExternalName

    ];

    // FileFlow

    TSyntaxnodeTypeFileFlow : TsyntaxNodeTypeSet =[
    TSyntaxNodeType.ntCompilerDirective,
    TSyntaxNodeType.ntContains,
    TSyntaxNodeType.ntDependency,
    TSyntaxNodeType.ntFinalization,
    TSyntaxNodeType.ntImplementation,
    TSyntaxNodeType.ntInitialization,
    TSyntaxNodeType.ntInterface,
    TSyntaxNodeType.ntLibrary,
    TSyntaxNodeType.ntPackage,
    TSyntaxNodeType.ntProgram,
    TSyntaxNodeType.ntUnit,
    TSyntaxNodeType.ntUses,
    TSyntaxNodeType.ntNamespace
    ];


// Anonym Methods

    TSyntaxnodeTypeAnonymous : TsyntaxNodeTypeSet =[

    TSyntaxNodeType.ntAnonymousMethodType
    ];


// Attributes
    TSyntaxnodeTypeAttribs : TsyntaxNodeTypeSet =[
    TSyntaxNodeType.ntArguments,
    TSyntaxNodeType.ntAttribute,
    TSyntaxNodeType.ntAttributes
    ];


// Asm
    TSyntaxnodeTypeAsm : TsyntaxNodeTypeSet =[
    TSyntaxNodeType.ntAsmFragment,
    TSyntaxNodeType.ntAsmStatement
    ];


// Type decl
    TSyntaxnodeTypeTypeDecl : TsyntaxNodeTypeSet =[
    TSyntaxNodeType.ntConstant,
    TSyntaxNodeType.ntConstants,
    TSyntaxNodeType.ntField,
    TSyntaxNodeType.ntFields,
    TSyntaxNodeType.ntGuid,
    TSyntaxNodeType.ntMethod,
    TSyntaxNodeType.ntProperty,
    TSyntaxNodeType.ntResourceString,
    TSyntaxNodeType.ntTypeDecl,
    TSyntaxNodeType.ntTypeSection,
    TSyntaxNodeType.ntVariable,
    TSyntaxNodeType.ntVariables

    ];

// Type specifier
    TSyntaxnodeTypeTypeSpec : TsyntaxNodeTypeSet =[
    TSyntaxNodeType.ntDefault,
    TSyntaxNodeType.ntPlatform
    ];


// Comment
    TSyntaxnodeTypeComments : TsyntaxNodeTypeSet =[
    TSyntaxNodeType.ntAnsiComment,
    TSyntaxNodeType.ntBorComment,
    TSyntaxNodeType.ntSlashesComment
    ];

// Not Supported
    TSyntaxnodeTypeNotSupported : TsyntaxNodeTypeSet =[
    TSyntaxNodeType.ntLabel

    ];


type
  TSyntaxNodeTypeHelper = public extension class(TSyntaxNodeType)
  public
    method EnumName() : String;
    begin
      exit Self.ToString.Substring(2);
    end;

    method isOperator : Boolean;
    begin
      result := isBinaryOperator
                or isUnaryOperator;
    end;

    method isBinaryOperator : Boolean;
    begin
      exit self in TSyntaxnodeTypeBinaryOperator;
    end;

    method isUnaryOperator : Boolean;
    begin
      exit self in TSyntaxnodeTypeUnaryOperator;
    end;


    method isStatement : Boolean;
    begin
      exit self in TSyntaxnodeTypeStatement;
    end;

    method isExpression : Boolean;
    begin
      exit self in TSyntaxnodeTypeExpression;
    end;

    method notSupported : Boolean;
    begin
      exit self in TSyntaxnodeTypeNotSupported;
    end;

  end;

end.