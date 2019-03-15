namespace PlayGroundFritz;
interface
uses
  PascalParser;
   //RemObjects.CodeGen4;

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

  public
    method BuildCGCodeUnitFomSyntaxNode(const rootnode : TSyntaxNode) : CGCodeUnit;
    constructor();
  end;

implementation

method CodeBuilder.FillMethods(const interfaceNode, implementationNode: TSyntaxNode);
begin
  if assigned(interfaceNode) then
    for each child in interfaceNode.ChildNodes.where(Item->Item.Typ = TSyntaxNodeType.ntMethod) do
    begin
    //  var ltemp := CodeBuilderMethods.BuildMethodMangledName(child);
    //  writeLn(ltemp);
      fInterfaceMethods.add(CodeBuilderMethods.BuildMethodMangledName(child, true), child);
    end;

  if assigned(implementationNode) then
    for each child in implementationNode.ChildNodes.where(Item->Item.Typ = TSyntaxNodeType.ntMethod) do
    begin
     // var ltemp := CodeBuilderMethods.BuildMethodMangledName(child);
    //  writeLn(ltemp);
      fImplementationMethods.add(CodeBuilderMethods.BuildMethodMangledName(child, false), child);
    end;

end;

method CodeBuilder.ResolveInterfaceMethod(const node: TSyntaxNode);
begin
 // We must have the node in fInterfaceMethods
  if fInterfaceMethods.ContainsValue(node) then
  begin
    var lname := CodeBuilderMethods.BuildMethodMangledName(node, true);
    if not String.IsNullOrEmpty(lname) then
    begin
      if fImplementationMethods.ContainsKey(lname) then
      begin
        var implNode := fImplementationMethods[lname];
       // Remove from fimplementation
        fImplementationMethods.Remove(lname);
        BuildGlobMethodClause(implNode, true);
      end;
    end;
  end;
end;

method CodeBuilder.ResolveImplemenationMethod(const node: TSyntaxNode);
begin
 // We must have the node in fInterfaceMethods

   if fImplementationMethods.ContainsValue(node) then
   begin
     var lname := CodeBuilderMethods.BuildMethodMangledName(node, true);
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
   for each child in node.FindNodes(TSyntaxNodeType.ntUnit) do
     fUnit.Imports.Add(new CGImport(child.GetAttribute(TAttributeName.anName)));
 end;

 method CodeBuilder.BuildUsesImplementationClause(const node: TSyntaxNode);
 begin
   if node = nil  then exit;
   for each child in node.FindNodes(TSyntaxNodeType.ntUnit) do
     fUnit.ImplementationImports.Add(new CGImport(child.GetAttribute(TAttributeName.anName)));
 end;

 method CodeBuilder.BuildClassClause(const node: TSyntaxNode);
 begin
   var lclass := new CGClassTypeDefinition(node.GetAttribute(TAttributeName.anName));
   fUnit.Types.Add(lclass);
 end;

 method CodeBuilder.BuildPointerClause(const node: TSyntaxNode);
 begin
   Var lType := node.FindNode(TSyntaxNodeType.ntType);
   if assigned(lType) then
   begin
     var lRef := CodeBuilderMethods.PrepareTypeRef(lType.FindNode(TSyntaxNodeType.ntType));
     var lclass := new CGTypeAliasDefinition(node.AttribName, new CGPointerTypeReference(lRef));
     fUnit.Types.Add(lclass);
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
   if ispublic then
   begin
     for each Child in node.ChildNodes.FindAll(Item -> Item.Typ = TSyntaxNodeType.ntConstant) do
       fUnit.Globals.Add(CodeBuilderMethods.BuildConstant(Child, ispublic));
   end
   else
     for each Child in node.ChildNodes.FindAll(Item -> Item.Typ = TSyntaxNodeType.ntConstant) do
       fUnit.Globals.Add(CodeBuilderMethods.BuildConstant(Child, ispublic))
 end;

 method CodeBuilder.BuildVariablesClause(const node: TSyntaxNode; const ispublic: Boolean);
 begin
   for each Child in node.ChildNodes.FindAll(Item -> Item.Typ = TSyntaxNodeType.ntVariable) do
     fUnit.Globals.Add(CodeBuilderMethods.BuildVariable(Child, ispublic));
 end;

 method CodeBuilder.BuildTypesClause(const node: TSyntaxNode);
 begin
   if node = nil  then exit;
   for each child in node.ChildNodes.FindAll(Item -> Item.Typ = TSyntaxNodeType.ntTypeDecl) do
     if child.HasChildren then
     begin
       Var lTypNode := child.FindNode(TSyntaxNodeType.ntType);
       if lTypNode <> nil then
       begin
         Var lTyp := lTypNode.AttribType.ToLower;
         if lTyp = '' then
           lTyp := lTypNode.AttribName.ToLower;

         case lTyp  of
           'class' : begin
             var lList := getImplementationMethodNodesFor(child.AttribName);
               fUnit.Types.Add(CodeBuilderMethods.BuildClass(lTypNode, child.AttribName, lList));
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

           'interface' : fUnit.Types.Add(CodeBuilderMethods.BuildInterface(lTypNode, child.AttribName));
           'record' :  begin
             var lList := getImplementationMethodNodesFor(child.AttribName);

             fUnit.Types.Add(CodeBuilderMethods.BuildRecord(lTypNode, child.AttribName, lList));
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

 method CodeBuilder.BuildCGCodeUnitFomSyntaxNode(const rootnode : TSyntaxNode): CGCodeUnit;
 require
   (rootnode <> nil) and (rootnode.Typ = TSyntaxNodeType.ntUnit);
 begin
   fUnit := new CGCodeUnit();
   fUnit.Namespace :=  new CGNamespaceReference(rootnode.GetAttribute(TAttributeName.anName));
// Uses Interface
   for each ltypesec in rootnode.FindInterfaceNodes(TSyntaxNodeType.ntUses) do
     BuildUsesInterfaceClause(ltypesec);


   FillMethods(rootnode.FindNode(TSyntaxNodeType.ntInterface), rootnode.FindNode(TSyntaxNodeType.ntImplementation));


        // Interface
   var lInterface := rootnode.FindNode(TSyntaxNodeType.ntInterface);



   for each ltypesec in lInterface.ChildNodes do
     begin
     case ltypesec.Typ of
       TSyntaxNodeType.ntTypeSection : BuildTypesClause(ltypesec);
       TSyntaxNodeType.ntConstants : BuildConstantsClause(ltypesec, true);
       TSyntaxNodeType.ntVariables : BuildVariablesClause(ltypesec, true);
       TSyntaxNodeType.ntMethod : ResolveInterfaceMethod(ltypesec);
     end;
   end;

   for each ltypesec in rootnode.FindImplemenationNodes(TSyntaxNodeType.ntUses) do
     BuildUsesImplementationClause(ltypesec);

         // Implementation
   lInterface := rootnode.FindNode(TSyntaxNodeType.ntImplementation);
   for each ltypesec in lInterface.ChildNodes do
     begin
     case ltypesec.Typ of
       TSyntaxNodeType.ntTypeSection : BuildTypesClause(ltypesec);
       TSyntaxNodeType.ntConstants : BuildConstantsClause(ltypesec, false);
       TSyntaxNodeType.ntVariables : BuildVariablesClause(ltypesec, false);
       TSyntaxNodeType.ntMethod : ResolveImplemenationMethod(ltypesec);
     end;
   end;

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
     //  var check := lkey.SubString(length(lname));
       result.Add(lkey, fImplementationMethods[lkey]);
     end;

  // Remove from fImplementation all nodes for the class
   for each lkey in result.Keys do
     fImplementationMethods.Remove(lkey);

 end;

end.