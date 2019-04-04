namespace ProHolz.CodeGen;
interface
uses
  ProHolz.Ast;


type
  CodeBuilder =  class
  private
    fUnit : CGCodeUnit;
    fInterfaceMethods : Dictionary<String, TSyntaxNode>;
    fImplementationMethods : Dictionary<String, TSyntaxNode>;

    method FillMethods(const interfaceNode, implementationNode: TSyntaxNode);
    method ResolveInterfaceMethod(const node : TSyntaxNode);
    method ResolveImplemenationMethod(const node : TSyntaxNode);
    method getImplementationMethodNodesFor(const name : String) : Dictionary<String, TSyntaxNode>;

    method BuildUsesInterfaceClause(const node: TSyntaxNode);
    method BuildUsesImplementationClause(const node : TSyntaxNode);
    method BuildClassClause(const node : TSyntaxNode);
    method BuildPointerClause(const node : TSyntaxNode);
    method BuildGlobMethodClause(const node : TSyntaxNode; const ispublic : Boolean);
    method BuildConstantsClause(const node : TSyntaxNode; const ispublic : Boolean);
    method BuildVariablesClause(const node : TSyntaxNode; const ispublic : Boolean);
    method BuildTypesClause(const node : TSyntaxNode);
    method BuildGlobMethodWithStatements(const node : TSyntaxNode; const prefix : String; const name : String);


  public
    method BuildCGCodeUnitFomSyntaxNode(const rootnode : TSyntaxNode) : CGCodeUnit;
    constructor();
  end;

implementation

method CodeBuilder.FillMethods(const interfaceNode, implementationNode: TSyntaxNode);
begin
 // writeLn('**** Interface  **** ' );
  if assigned(interfaceNode) then
  begin
    for each child in interfaceNode.ChildNodes.where(Item->Item.Typ = TSyntaxNodeType.ntMethod) do
      begin
      fInterfaceMethods.add(CodeBuilderMethods.BuildMethodMangledName(child), child);
    end;
  end;
//  writeLn('**** implementationNode  **** ' );
  if assigned(implementationNode) then
    for each child in implementationNode.ChildNodes.where(Item->Item.Typ = TSyntaxNodeType.ntMethod) do
      begin
    //  writeLn(CodeBuilderMethods.BuildMethodMangledName(child));
      fImplementationMethods.add(CodeBuilderMethods.BuildMethodMangledName(child), child);
    end;

end;

method CodeBuilder.ResolveInterfaceMethod(const node: TSyntaxNode);
begin
 // We must have the node in fInterfaceMethods
  if fInterfaceMethods.ContainsValue(node) then
  begin
    var lname := CodeBuilderMethods.BuildMethodMangledName(node);
    if not String.IsNullOrEmpty(lname) then
    begin
      if fImplementationMethods.ContainsKey(lname) then
      begin
        var implNode := fImplementationMethods[lname];
       // Remove from fimplementation
        fImplementationMethods.Remove(lname);
        BuildGlobMethodClause(implNode, true);
      end
      else
        BuildGlobMethodClause(node, true);

    end;
  end;
end;

method CodeBuilder.ResolveImplemenationMethod(const node: TSyntaxNode);
begin
 // We must have the node in fImplementationMethods

  if fImplementationMethods.ContainsValue(node) then
  begin
    var lname := CodeBuilderMethods.BuildMethodMangledName(node);
    if not String.IsNullOrEmpty(lname) then
    begin
      if fImplementationMethods.ContainsKey(lname) then
      begin
        var implNode := fImplementationMethods[lname];
       // Remove from fimplementation
        fImplementationMethods.Remove(lname);
        BuildGlobMethodClause(implNode, false);
      end;
    end;
  end;
end;

method CodeBuilder.BuildUsesInterfaceClause(const node: TSyntaxNode);
begin
  if node = nil  then exit;
  for each child in node.FindChilds(TSyntaxNodeType.ntUnit) do
    fUnit.Imports.Add(new CGImport(child.AttribName));
end;

method CodeBuilder.BuildUsesImplementationClause(const node: TSyntaxNode);
begin
  if node = nil  then exit;
  for each child in node.FindChilds(TSyntaxNodeType.ntUnit) do
    fUnit.ImplementationImports.Add(new CGImport(child.AttribName));
end;

method CodeBuilder.BuildClassClause(const node: TSyntaxNode);
begin
  var lclass := new CGClassTypeDefinition(node.AttribName);
  fUnit.Types.Add(lclass);
end;

method CodeBuilder.BuildPointerClause(const node: TSyntaxNode);
begin
  Var lType := node.FindNode(TSyntaxNodeType.ntType);
  if assigned(lType) then
  begin
    var lRefType := lType.FindNode(TSyntaxNodeType.ntType);
    if assigned(lRefType) then
    begin
    var lRef := CodeBuilderMethods.PrepareTypeRef(lRefType);
    var lclass := new CGTypeAliasDefinition(node.AttribName, new CGPointerTypeReference(lRef));
    fUnit.Types.Add(lclass);
    end
    else
      begin
     // var lt := new CGTypeOfExpression('Pointer'.AsTypeReferenceExpression);
      var lt :=  CodeBuilderDefaultTypes.getType(lType.AttribName);


      var lclass := new CGTypeAliasDefinition(node.AttribName,  lt {'Type of Pointer'.AsTypeReference});
      fUnit.Types.Add(lclass);
      end;
  end;

end;

method CodeBuilder.BuildGlobMethodClause(const node: TSyntaxNode; const ispublic: Boolean);
begin
  var lTemp := CodeBuilderMethods.BuildGlobMethod(node, ispublic);
  if assigned(lTemp) then
    fUnit.Globals.Add(lTemp) else
    assert(false, 'Method not solved');
end;

method CodeBuilder.BuildConstantsClause(const node: TSyntaxNode; const ispublic: Boolean);
begin
    for each Child in node.FindChilds(TSyntaxNodeType.ntConstant) do
      fUnit.Globals.Add(CodeBuilderMethods.BuildConstant(Child, ispublic));

    for each Child in node.FindChilds( TSyntaxNodeType.ntResourceString) do
      fUnit.Globals.Add(CodeBuilderMethods.BuildConstant(Child, ispublic));

end;

method CodeBuilder.BuildVariablesClause(const node: TSyntaxNode; const ispublic: Boolean);
begin
  for each Child in node.ChildNodes.FindAll(Item -> Item.Typ = TSyntaxNodeType.ntVariable) do
   begin
    // Here we check of a new Type declarartion inside the var decl
    var lnewtypeEnum : prepareNewTypeEnum;
    if CodeBuilderMethods.isVarWithnewType(Child, out lnewtypeEnum) then
    begin
      // Pick up the varname and add a '_type'
      var lname := Child.FindNode(TSyntaxNodeType.ntName).AttribName + '_type';
      // Actual it can be a function or procedure

      Var lnewType :=
      case lnewtypeEnum of
         prepareNewTypeEnum.block : CodeBuilderMethods.BuildBlockType(Child, lname);
         prepareNewTypeEnum.enum : CodeBuilderEnum.BuildEnum(Child.FindNode(TSyntaxNodeType.ntType), lname);
       end;

      lnewType.Comment := 'Type automatic created'.AsBuilderComment;
      fUnit.Types.Add(lnewType);
      var lvar := CodeBuilderMethods.BuildVariable(Child, ispublic, lname);
      lvar.Variable.Comment := 'Type automatic added'.AsBuilderComment;
      fUnit.Globals.Add(lvar);
    end
    else
    fUnit.Globals.Add(CodeBuilderMethods.BuildVariable(Child, ispublic));
   end;
end;

method CodeBuilder.BuildTypesClause(const node: TSyntaxNode);
begin
  if node = nil  then exit;
  var lAttributes := new List<CGAttribute>;
  for each child in node.ChildNodes do
    begin
    case child.Typ of

      TSyntaxNodeType.ntAttributes : begin
          for each lNodeAttr in child.ChildNodes.Where(Item->Item.Typ = TSyntaxNodeType.ntAttribute) do
            begin
            var lattr := CodeBuilderMethods.PrepareAttribute(lNodeAttr);
            if assigned(lattr) then
              lAttributes.Add(lattr);
          end;
      end;


      TSyntaxNodeType.ntTypeDecl:
      begin

        if child.HasChildren then
        begin
          Var lTypNode := child.FindNode(TSyntaxNodeType.ntType);
          if assigned(lTypNode) then
          begin
            Var lTyp := lTypNode.AttribType.ToLower;
            if lTyp = '' then
              lTyp := lTypNode.AttribName.ToLower;

            case lTyp  of
              'class' : begin
                var lTypeParams := child.FindNode(TSyntaxNodeType.ntTypeParams);
                var lname : String := '';
                if assigned(lTypeParams) then
                  lname := CodeBuilderMethods.PrepareGenericParameterName(lTypeParams);

                var lList := getImplementationMethodNodesFor((child.AttribName+lname).ToLower);
                var lClass := CodeBuilderMethods.BuildClass(lTypNode, child.AttribName, lList);
                if lAttributes.Count > 0  then
                begin
                  lClass.Attributes.add(lAttributes);
                  lAttributes.RemoveAll;
                end;
                fUnit.Types.Add(lClass);
              end;

              'class of' : begin
                fUnit.Types.Add(CodeBuilderMethods.BuildClassOf(child, child.AttribName));
              end;

              'function' : begin
                fUnit.Types.Add(CodeBuilderMethods.BuildBlockType(child, child.AttribName));
              end;

              'procedure' : begin
                fUnit.Types.Add(CodeBuilderMethods.BuildBlockType(child, child.AttribName));
              end;

              'interface' : begin
                fUnit.Types.Add(CodeBuilderMethods.BuildInterface(lTypNode, child.AttribName));
              end;
              'record' :  begin
                var lTypeParams := child.FindNode(TSyntaxNodeType.ntTypeParams);
                var lname : String := '';
                if assigned(lTypeParams) then
                  lname := CodeBuilderMethods.PrepareGenericParameterName(lTypeParams);

                var lList := getImplementationMethodNodesFor((child.AttribName+lname).ToLower);

                fUnit.Types.Add(CodeBuilderMethods.BuildRecord(lTypNode, child.AttribName, lList));
              end;
              'object' :  begin
                var lTypeParams := child.FindNode(TSyntaxNodeType.ntTypeParams);
                var lname : String := '';
                if assigned(lTypeParams) then
                  lname := CodeBuilderMethods.PrepareGenericParameterName(lTypeParams);

                var lList := getImplementationMethodNodesFor((child.AttribName+lname).ToLower);
                var lrec := CodeBuilderMethods.BuildRecord(lTypNode, child.AttribName, lList);
                lrec.Comment := '***Object Type written as Record ***'.AsBuilderComment;
                fUnit.Types.Add(lrec);
              end;


              'pointer' : BuildPointerClause(child);
              'enum' : fUnit.Types.Add(CodeBuilderEnum.BuildEnum(lTypNode, child.AttribName));
              'set' : fUnit.Types.Add(CodeBuilderMethods.BuildSet(lTypNode, child.AttribName));
              'array': fUnit.Types.Add(CodeBuilderMethods.BuildArray(lTypNode, child.AttribName));
              else
                fUnit.Types.Add(CodeBuilderMethods.BuildAlias(lTypNode, child.AttribName));
            // raise new Exception("Unknown type "+lTyp);

            end;
          end;
          lTypNode := child.FindNode(TSyntaxNodeType.ntAnonymousMethodType);
          if lTypNode <> nil then
          begin
            Var lTyp := lTypNode.AttribKind.ToLower;
            case lTyp  of
              'procedure' : fUnit.Types.Add(CodeBuilderMethods.BuildAnonymousBlockType(child, child.AttribName));
              'function' : fUnit.Types.Add(CodeBuilderMethods.BuildAnonymousBlockType(child, child.AttribName));
            end;
          end;
        end;
      end;
    end;
  end;
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

   constructor CodeBuilder();
   begin
     fInterfaceMethods := new Dictionary<String, TSyntaxNode>;
     fImplementationMethods := new Dictionary<String, TSyntaxNode>;
   end;

   method CodeBuilder.getImplementationMethodNodesFor(const name: String): Dictionary<String,TSyntaxNode>;
   begin
     result := new Dictionary<String, TSyntaxNode>;
     Var lname := name.ToLower.trim+'.';
     for each lkey in fImplementationMethods.Keys do
       if lkey.StartsWith(lname) then
       begin
         result.Add(lkey, fImplementationMethods[lkey]);
       end;

  // Remove from fImplementation all nodes for the class
     for each lkey in result.Keys do
       fImplementationMethods.Remove(lkey);

   end;

method CodeBuilder.BuildGlobMethodWithStatements(const node: TSyntaxNode; const prefix: String; const name: String);
begin
  var methodname := prefix+name.Replace('.', '_');

  var lmethod := new CGMethodDefinition(methodname);
  lmethod.Visibility := CGMemberVisibilityKind.Public;
  lmethod.Statements.add(new CGRawStatement('{$HINT "Replaces Initialization/Finalization"}'));
  CodeBuilderMethods.BuildStatements(node, lmethod);
  lmethod.Comment := (methodname + ' added as method').AsBuilderComment;
  fUnit.Globals.Add(lmethod.AsGlobal);

end;

end.