namespace ProHolz.SourceChecker;
uses ProHolz.Ast;

const
  // Use for Interface Types
  cPublicTypesInterface = [SNT.ntInterface, SNT.ntTypeSection, SNT.ntTypeDecl, SNT.ntType ]; //
  // Use for IMplementaion Types
  cPublicTypesImplementation = [SNT.ntImplementation,SNT.ntTypeSection, SNT.ntTypeDecl, SNT.ntType]; //

  cPublicClassMethods: array of SNT = [SNT.ntInterface, SNT.ntTypeSection, SNT.ntTypeDecl, SNT.ntType, SNT.ntPublic, SNT.ntMethod]; //

  cStatementInMethods : array of SNT = [SNT.ntImplementation, SNT.ntMethod, SNT.ntStatements];

// Actual Tests, there are more to comming
type
  eEleCheck = public enum ( //
    eDummy,
    eDfm, // There is a *.dfm
    eWith, // with clause in source
    eInitializations, // initialization found
    eFinalizations, // finalization found
    ePublicVars, // There are public Global Vars in initialization
    eGlobalMethods, // Global Methods
    eDestructors, // There is a Destructor in classes
    eMultiConstructors, // There is more then on public Constructor for a class
    eMoreThenOneClass, // There is more then on class in the file
    eInterfaceandImplement,   // declaration of a Interface and Implementatiion of a class that use it
    eVariantRecord,       // Record with Variant parts
    ePublicEnums,        // Enum Types shuld be check ScopedEnums, not done yet
    eClassDeclImpl,      // Class defined in implementation
    eConstRecord,     // Const Records with initialisation, Should be extendet with checke of not Single consts aka const array of integer
    eHasResources,    // Res in File
    eHasResourceStrings, //Resourcestrings in File
    eVarsWithTypes,   //Variables with defined Types like Var l : (e1, e2, e3);
    eTypesInMethods,   // Type declaration in Methods
    eAsm,               // Assembler is used somewhere
    eTypeinType        // Like eVarsWithTypes but for records
    );

  const
  cEleProbsnames: array [eEleCheck] of String = ( //
    'Is DUMMY Check',
    '*.dfm File',
    'With Clauses ',
    'Initialization',
    'Finalizations',
    'Public Vars in Interface needs {GLOBALS ON}',
    'Public Methods in Interface needs {GLOBALS ON}',
    'Destructors',
    'Multible Constructors',
    'Multible Classes defined in Interface',
    'IInterface and Class that uses it in the same File ',
    'Variant record Type',
    'Enums without Scope',
    'Class Declaration in Implementation',
    'Const Records ',
    'Resources inside',
    'Resource Strings in File',
    'Variables with defined Types',
    'Type declaration in Method',
    'Assembler is used',
    'Record or Class with new types Inside');

end.