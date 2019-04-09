namespace ProHolz.CodeGen;

interface
uses
  ProHolz.Ast;

type
  BuildSettings  nested in CodeBuilder = static class
  public
   property InterfaceGuids : Boolean  := true;
   property ComInterfaces : Boolean  := true;
   property PublicEnums : Boolean := true;
   property PublicClasses : Boolean := true;
   property PublicInterfaces : Boolean := true;
   property PublicRecords : Boolean := true;
   property PublicBlocks : Boolean := true;

 end;

  CodeBuilder =  partial class
  private
    fUnit : CGCodeUnit;
    fInterfaceMethods : Dictionary<String, TSyntaxNode>;
    fImplementationMethods : Dictionary<String, TSyntaxNode>;

  public
    constructor();
    method BuildCGCodeUnitFomSyntaxNode(const rootnode : TSyntaxNode) : CGCodeUnit;
    property settings : BuildSettings read;
  end;

implementation

constructor CodeBuilder();
begin
  fInterfaceMethods := new Dictionary<String, TSyntaxNode>;
  fImplementationMethods := new Dictionary<String, TSyntaxNode>;
end;

method CodeBuilder.BuildCGCodeUnitFomSyntaxNode(const rootnode : TSyntaxNode): CGCodeUnit;
require
  (rootnode <> nil) and (rootnode.Typ = TSyntaxNodeType.ntUnit);
 begin
   fUnit := new CGCodeUnit();
   fUnit.Namespace :=  new CGNamespaceReference(rootnode.AttribName);
// Uses Interface
   for each ltypesec in rootnode.FindNode(TSyntaxNodeType.ntInterface).FindChilds(TSyntaxNodeType.ntUses) do
     BuildUsesInterfaceClause(ltypesec);

   FillMethods(rootnode.FindNode(TSyntaxNodeType.ntInterface), rootnode.FindNode(TSyntaxNodeType.ntImplementation));

// Interface
//  var lInterface := rootnode.FindNode(TSyntaxNodeType.ntInterface);

  for each ltypesec in rootnode.FindNode(TSyntaxNodeType.ntInterface).ChildNodes do
    begin
    case ltypesec.Typ of
      TSyntaxNodeType.ntTypeSection : BuildTypesClause(ltypesec);
      TSyntaxNodeType.ntConstants : BuildConstantsClause(ltypesec, true);
      TSyntaxNodeType.ntVariables : BuildVariablesClause(ltypesec, true);
      TSyntaxNodeType.ntMethod : ResolveInterfaceMethod(ltypesec);
    end;
  end;

      // Implementation
  for each ltypesec in rootnode.FindNode(TSyntaxNodeType.ntImplementation).FindChilds(TSyntaxNodeType.ntUses) do
    BuildUsesImplementationClause(ltypesec);



  for each ltypesec in rootnode.FindNode(TSyntaxNodeType.ntImplementation).ChildNodes do
    begin
    case ltypesec.Typ of
      TSyntaxNodeType.ntTypeSection : BuildTypesClause(ltypesec);
      TSyntaxNodeType.ntConstants : BuildConstantsClause(ltypesec, false);
      TSyntaxNodeType.ntVariables : BuildVariablesClause(ltypesec, false);
      TSyntaxNodeType.ntMethod : ResolveImplemenationMethod(ltypesec);
    end;
  end;

  var lInitalizationStatement := rootnode.FindNode(TSyntaxNodeType.ntInitialization):FindNode(TSyntaxNodeType.ntStatements);
  if lInitalizationStatement:HasChildren then
    BuildGlobMethodWithStatements(lInitalizationStatement, 'Initialize_', fUnit.Namespace.Name);


  lInitalizationStatement := rootnode.FindNode(TSyntaxNodeType.ntFinalization):FindNode(TSyntaxNodeType.ntStatements);
  if lInitalizationStatement:HasChildren then
    BuildGlobMethodWithStatements(lInitalizationStatement, 'Finalize_', fUnit.Namespace.Name);

  result := fUnit;
end;

end.