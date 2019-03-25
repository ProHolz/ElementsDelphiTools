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
type
  TSyntaxNodeType = public enum (
    ntAddr, //unary
    ntDoubleAddr,
    ntDeref, // Expression
    ntGeneric,
    ntIndexed, //Expression
    ntDot, // Expression
    ntCall, // Expression Statement
    ntUnaryMinus, //unary
    ntNot, //unary
    ntMul, //Operator
    ntFDiv, //Operator
    ntDiv, //Operator
    ntMod, //Operator
    ntAnd, //Operator
    ntShl, //Operator
    ntShr, //Operator
    ntAs, // Expression

    ntAdd, //Operator
    ntSub, //Operator
    ntOr, //Operator
    ntXor, //Operator
    ntEqual, //Operator
    ntNotEqual, //Operator
    ntLower, //Operator
    ntGreater, //Operator
    ntLowerEqual, //Operator
    ntGreaterEqual, //Operator
    ntIn, //Operator
    ntIs, //Operator

  //Allow the use of [ntStrictPrivate..ntAutomated].
    ntStrictPrivate, // Visibility
    ntPrivate, // Visibility
    ntStrictProtected, // Visibility
    ntProtected, // Visibility
    ntPublic, // Visibility
    ntPublished, // Visibility
    ntAutomated, // Visibility

    ntUnknown, // unknown Operator
    ntAlignmentParam, // Dont now check.....
    ntAnonymousMethod, // Anonymous
    ntAnonymousMethodType, // Anonymous
    ntArguments, // Attribute
    ntAsmFragment, // Asm
    ntAsmStatement, // Asm
    ntAssign, // Statement
    ntAt, // Expression
    ntAttribute, // Attribute
    ntAttributes, // Attribute
    ntBounds, // Expression
    ntCase,  // Statement
    ntCaseElse, // Statement
    ntCaseLabel, // Statement
    ntCaseLabels, // Statement
    ntCaseSelector, // Statement
    ntClassConstraint,
    ntCompilerDirective, // Fileflow
    ntConstant,  // Typedecl
    ntConstants, // Typedecl
    ntConstraints,
    ntConstructorConstraint,
    ntContains, // Fileflow
    ntDefault, // Type Specifier
    ntDependency, // File Flow
    ntDeprecated,
    ntDimension, // Expression
    ntDownTo,  // Statement
    ntElement, // Expression
    ntElse,  // Statement
    ntEmptyStatement, // Statement
    ntEnum, // Not used
    ntExcept, // Statement
    ntExceptElse, // Statement
    ntExceptionHandler,
    ntExperimental,
    ntExports,
    ntExpression, // Expression
    ntExpressions, // Expressions
    ntExternal,
    ntExternalName,
    ntField, // Typedecl
    ntFields, // Typedecl
    ntFinalization, // FileFlow
    ntFinally,
    ntFor, // Statement
    ntFrom, // Statement
    ntGoto, // Expression
    ntGuid, // Typedecl
    ntHelper,
    ntIdentifier, // Expression
    ntIf, // Statement
    ntImplementation, //FileFlow
    ntImplements,
    ntIndex,
    ntInherited, // Statement
    ntInitialization, // FileFlow
    ntInterface, // FileFlow
    ntLabel,
    ntLabeledStatement,
    ntLHS, //Expression
    ntLibrary, //Filflow
    ntLiteral, //Expression
    ntMessage,
    ntMethod, // Type decl
    ntName, // Expression
    ntNamedArgument,
    ntPackage, // Fileflow
    ntParameter, // Expression
    ntParameters, // Expression
  {ntPath,}
    ntPlatform, //Type specifier
    ntPositionalArgument,
    ntProgram, // FileFlow
    ntProperty, // Type decl
    ntRaise,
    ntRead, // Expression
    ntRecordConstant, // Expression
    ntRecordConstraint,
    ntRecordVariant,
    ntRepeat, // Statement
    ntRequires,
    ntResident,
    ntResolutionClause,
    ntResourceString, // Type decl
    ntReturnType, // Expression
    ntRHS, // Expression
    ntRoundClose, // Expression
    ntRoundOpen, // Expression
    ntSet, // Expression
    ntStatement, // not used
    ntStatements, // Statement
    ntSubrange, // not used
    ntThen, // Statement
    ntTo, // Statement
    ntTry, // Statement
    ntType, // Expression
    ntTypeArgs,
    ntTypeDecl, // Type decl
    ntTypeParam,
    ntTypeParams,
    ntTypeSection,// Type decl
    ntValue, // Expression
    ntVariable, // Type decl
    ntVariables, // Type decl
    ntVariantSection,
    ntVariantTag,
    ntUnit, // FileFlow
    ntUses, // FileFlow
    ntWhile, // Statement
    ntWith,  // Statement
    ntWrite, // Expression

    ntAnsiComment, // Comment
    ntBorComment, // Comment
    ntSlashesComment // Comment

  );

  TAttributeName = public enum (
    anType,
    anClass,
    anForwarded,
    anKind,
    anName,
    anVisibility,
    anCallingConvention,
    anPath,
    anMethodBinding,
    anReintroduce,
    anOverload,
    anAbstract,
    anInline
  );


  TmwParseError = public enum(
    InvalidAdditiveOperator,
    InvalidAccessSpecifier,
    InvalidCharString,
    InvalidClassMethodHeading,
    InvalidConstantDeclaration,
    InvalidConstSection,
    InvalidDeclarationSection,
    InvalidDirective16Bit,
    InvalidDirectiveBinding,
    InvalidDirectiveCalling,
    InvalidExportedHeading,
    InvalidForStatement,
    InvalidInitializationSection,
    InvalidInterfaceDeclaration,
    InvalidInterfaceType,
    InvalidLabelId,
    InvalidLabeledStatement,
    InvalidMethodHeading,
    InvalidMultiplicativeOperator,
    InvalidNumber,
    InvalidOrdinalIdentifier,
    InvalidParameter,
    InvalidParseFile,
    InvalidProceduralDirective,
    InvalidProceduralType,
    InvalidProcedureDeclarationSection,
    InvalidProcedureMethodDeclaration,
    InvalidRealIdentifier,
    InvalidRelativeOperator,
    InvalidStorageSpecifier,
    InvalidStringIdentifier,
    InvalidStructuredType,
    InvalidTryStatement,
    InvalidTypeKind,
    InvalidVariantIdentifier,
    InvalidVarSection,
    vchInvalidClass,
    vchInvalidMethod,
    vchInvalidProcedure,
    vchInvalidCircuit,
    vchInvalidIncludeFile
  );



end.