namespace ProHolz.Ast;

type
  {$IF ECHOES}
  TSyntaxNodeTypeSet = set of TSyntaxNodeType;
 {$ELSE}
  TSyntaxNodeTypeSet = &Set<TSyntaxNodeType>;
  {$ENDIF}

//  TSyntaxNodeType
  const
    // Binary Operators

    TSyntaxNodeTypeBinaryOperator : TSyntaxNodeTypeSet =[
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
    TSyntaxNodeTypeUnaryOperator : TSyntaxNodeTypeSet =[
    TSyntaxNodeType.ntAddr,
    TSyntaxNodeType.ntNot,
    TSyntaxNodeType.ntUnaryMinus
    ];


// Statement
    TSyntaxNodeTypeStatement : TSyntaxNodeTypeSet =[
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
    TSyntaxNodeTypeExpression : TSyntaxNodeTypeSet =[
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

    TSyntaxNodeTypeFileFlow : TSyntaxNodeTypeSet =[
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

    TSyntaxNodeTypeAnonymous : TSyntaxNodeTypeSet =[

    TSyntaxNodeType.ntAnonymousMethodType
    ];


// Attributes
    TSyntaxNodeTypeAttribs : TSyntaxNodeTypeSet =[
    TSyntaxNodeType.ntArguments,
    TSyntaxNodeType.ntAttribute,
    TSyntaxNodeType.ntAttributes
    ];


// Asm
    TSyntaxNodeTypeAsm : TSyntaxNodeTypeSet =[
    TSyntaxNodeType.ntAsmFragment,
    TSyntaxNodeType.ntAsmStatement
    ];


// Type decl
    TSyntaxNodeTypeTypeDecl : TSyntaxNodeTypeSet =[
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
    TSyntaxnodeTypeTypeSpec : TSyntaxNodeTypeSet =[
    TSyntaxNodeType.ntDefault,
    TSyntaxNodeType.ntPlatform
    ];


// Comment
    TSyntaxNodeTypeComments : TSyntaxNodeTypeSet =[
    TSyntaxNodeType.ntAnsiComment,
    TSyntaxNodeType.ntBorComment,
    TSyntaxNodeType.ntSlashesComment
    ];

// Not Supported
    TSyntaxNodeTypeNotSupported : TSyntaxNodeTypeSet =[
    TSyntaxNodeType.ntLabel

    ];


type
  TSyntaxNodeTypeHelper = public extension class(TSyntaxNodeType)
  public
    method EnumName() : String;
    begin
      exit Self.ToString.Substring(2);
    end;

    method IsOperator : Boolean;
    begin
      result := isBinaryOperator
                or isUnaryOperator;
    end;

    method IsBinaryOperator : Boolean;
    begin
      exit self in TSyntaxNodeTypeBinaryOperator;
    end;

    method IsUnaryOperator : Boolean;
    begin
      exit self in TSyntaxNodeTypeUnaryOperator;
    end;


    method IsStatement : Boolean;
    begin
      exit self in TSyntaxNodeTypeStatement;
    end;

    method IsExpression : Boolean;
    begin
      exit self in TSyntaxNodeTypeExpression;
    end;

    method NotSupported : Boolean;
    begin
      exit self in TSyntaxNodeTypeNotSupported;
    end;

  end;

end.