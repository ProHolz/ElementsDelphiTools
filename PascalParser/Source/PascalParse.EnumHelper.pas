namespace ProHolz.Ast;

//  TSyntaxNodeType
  const
    // Binary Operators
    TSyntaxnodeTypeBinaryOperator : set of TSyntaxNodeType =[
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
    TSyntaxnodeTypeUnaryOperator : set of TSyntaxNodeType =[
    TSyntaxNodeType.ntAddr,
    TSyntaxNodeType.ntNot,
    TSyntaxNodeType.ntUnaryMinus
    ];


// Statement
    TSyntaxnodeTypeStatement : set of TSyntaxNodeType =[
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
    TSyntaxnodeTypeExpression : set of TSyntaxNodeType =[
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
    TSyntaxNodeType.ntField

    ];

    // FileFlow

    TSyntaxnodeTypeFileFlow : set of TSyntaxNodeType =[
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
    TSyntaxNodeType.ntUses
    ];


// Anonym Methods

    TSyntaxnodeTypeAnonymous : set of TSyntaxNodeType =[

    TSyntaxNodeType.ntAnonymousMethodType
    ];


// Attributes
    TSyntaxnodeTypeAttribs : set of TSyntaxNodeType =[
    TSyntaxNodeType.ntArguments,
    TSyntaxNodeType.ntAttribute,
    TSyntaxNodeType.ntAttributes
    ];


// Asm
    TSyntaxnodeTypeAsm : set of TSyntaxNodeType =[
    TSyntaxNodeType.ntAsmFragment,
    TSyntaxNodeType.ntAsmStatement
    ];


// Type decl
    TSyntaxnodeTypeTypeDecl : set of TSyntaxNodeType =[
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
    TSyntaxnodeTypeTypeSpec : set of TSyntaxNodeType =[
    TSyntaxNodeType.ntDefault,
    TSyntaxNodeType.ntPlatform
    ];


// Comment
    TSyntaxnodeTypeComments : set of TSyntaxNodeType =[
    TSyntaxNodeType.ntAnsiComment,
    TSyntaxNodeType.ntBorComment,
    TSyntaxNodeType.ntSlashesComment
    ];

// Not Supported
    TSyntaxnodeTypeNotSupported : set of TSyntaxNodeType =[
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