namespace ProblemChecker;
uses PascalParser;

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
    eHasResourceStrings
    );

  const
  cEleProbsnames: array [eEleCheck] of String = ( //
    'Is DUMMY Check',
    'has *.dfm File',
    'has With Clauses ',
    'has Initialization',
    'has Finalizations',
    'has Public Vars in Interface needs {GLOBALS ON}',
    'has Public Methods in Interface needs {GLOBALS ON}',
    'has Destructors',
    'has more then 1 Constructors for one ore more classes',
    'has more then One Class defined in Interface',
    'has IInterface and Class that uses it in the same File ',
    'has Variant record Type',
    'has Enums in Interface (Check for Scoped Enums)',
    'has Class Declaration in Implementation',
    'has Const Records ',
    'has Resources inside',
    'Resource Strings in File');

end.