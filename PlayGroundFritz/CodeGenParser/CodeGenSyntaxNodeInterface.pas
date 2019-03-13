namespace PlayGroundFritz;

interface
uses PascalParser;

type
  CodeBuilderMethods = static partial class
  private


    method AddAncestors(const Value : CGClassOrStructTypeDefinition; const Types : TSyntaxNode);
    method AddFields(const Value : CGClassOrStructTypeDefinition; const Types : TSyntaxNode);
    method PrepareArrayType(const Node: TSyntaxNode; const ClassName: not nullable String): CGArrayTypeReference;
    method PrepareProperty(prop: TSyntaxNode): CGPropertyDefinition;
    method PrepareVarOrConstant(const constnode: TSyntaxNode; const isConst: Boolean; const ispublic: Boolean): CGGlobalVariableDefinition;

    method mapVisibility(Value : TSyntaxNodeType) : CGMemberVisibilityKind;
    method mapCallingConvention(const Value : String) : CGCallingConventionKind;
    method mapBinding(const Value : String) : CGMemberVirtualityKind;

    method PrepareDefaultValue(const paramnode: TSyntaxNode; paramkind : String): CGExpression;
    method PrepareParam(const paramnode: TSyntaxNode): CGParameterDefinition;
    method PrepareMethod(const methodnode : TSyntaxNode;  const implnode: TSyntaxNode = nil) : CGMethodLikeMemberDefinition;

  public
    method BuildInterface(const InterfaceTypeNode : TSyntaxNode; const interfaceName : not nullable String): CGInterfaceTypeDefinition;
    method BuildClass(const ClassTypeNode: TSyntaxNode; const ClassName: not nullable String; const methodBodys : Dictionary<String,TSyntaxNode>): CGClassTypeDefinition;
    method BuildRecord(const RecordTypeNode : TSyntaxNode; const recordName : not nullable String; const methodBodys : Dictionary<String,TSyntaxNode>): CGStructTypeDefinition;
    method BuildGlobMethod(const methodnode : TSyntaxNode; const ispublic : Boolean) : CGGlobalFunctionDefinition;

    method BuildSet(const node: TSyntaxNode; const ClassName: not nullable String): CGTypeDefinition;
    method BuildVariable(const node : TSyntaxNode; const ispublic : Boolean) : CGGlobalVariableDefinition ;
    method BuildConstant(const node : TSyntaxNode; const ispublic : Boolean) : CGGlobalVariableDefinition;

    method BuildArray(const ClassTypeNode: TSyntaxNode; const ClassName: not nullable String): CGTypeDefinition;
    method BuildAlias(const ClassTypeNode: TSyntaxNode; const ClassName: not nullable String): CGTypeDefinition;
    method BuildClassOf(const ClassTypeNode: TSyntaxNode; const ClassName: not nullable String): CGTypeDefinition;
    method BuildBlockType(const node: TSyntaxNode; const name: not nullable String): CGTypeDefinition;
    method BuildAnonymousBlockType(const node: TSyntaxNode; const name: not nullable String): CGTypeDefinition;
    method BuildMethodMangledName(const methodnode: TSyntaxNode): String;

  end;

implementation

method CodeBuilderMethods.PrepareArrayType(const Node: TSyntaxNode; const ClassName: not nullable String): CGArrayTypeReference;
begin
  var typeNode := Node.FindNode(TSyntaxNodeType.ntType);
  if assigned(typeNode) then
  begin

    var lBounds := resolveBounds(Node);
    if lBounds <> nil then
    begin
      var lArrayBounds := new List<CGArrayBounds>;
      var lTypeBounds := new List<CGTypeReference>;
      for each lbound in lBounds do
        begin
        if lbound is CGArrayBounds then
          lArrayBounds.Add(lbound as CGArrayBounds)
        else
          if lbound is CGTypeReference then
            lTypeBounds.Add(lbound as CGTypeReference)
      end;

      if (lArrayBounds.Count > 0) and (lTypeBounds.Count > 0) then
        result := new CGArrayTypeReference((typeNode.AttribName).AsTypeReference, '***Combined__TYPES'.AsTypeReference)
      else
       if lArrayBounds.Count > 0 then
         result := new CGArrayTypeReference(typeNode.AttribName.AsTypeReference, lArrayBounds)
       else
         if lTypeBounds.Count > 0 then
           result := new CGArrayTypeReference(typeNode.AttribName.AsTypeReference, lTypeBounds)
         else
           result := new CGArrayTypeReference(typeNode.AttribName.AsTypeReference)

    end
    else
      result := new CGArrayTypeReference(typeNode.AttribName.AsTypeReference);

  end
  else raise new Exception("Array Type Alias not solved");

end;


method CodeBuilderMethods.PrepareProperty(prop : TSyntaxNode) : CGPropertyDefinition;
begin
  Var Propname := prop.AttribName;
  Var PropKind := prop.FindNode(TSyntaxNodeType.ntType):AttribName;
  if String.IsNullOrEmpty(PropKind) then
    result := new CGPropertyDefinition(Propname)
  else
    result := new CGPropertyDefinition(Propname, PropKind.AsTypeReference);
  result.Visibility :=  mapVisibility(prop.ParentNode.Typ);

  // Check for Parameters

  var lParams := prop.findnode(TSyntaxNodeType.ntParameters);
  if lParams <> nil then
  begin
    for each &param in lParams.FindNodes(TSyntaxNodeType.ntParameter) do
      begin
      result.Parameters.Add(PrepareParam(&param));
    end;

    if prop.findnode(TSyntaxNodeType.ntDefault) <> nil then
      result.Default := true;

  end;



  Var lRead := prop.FindNode(TSyntaxNodeType.ntRead):FindNode(TSyntaxNodeType.ntIdentifier);
  if lRead <> nil then
    result.GetExpression := new CGPropertyAccessExpression(nil, lRead.AttribName);

  Var lWrite := prop.FindNode(TSyntaxNodeType.ntWrite):FindNode(TSyntaxNodeType.ntIdentifier);
  if lWrite <> nil then
    result.SetExpression := new CGPropertyAccessExpression(nil, lWrite.AttribName);

end;

method CodeBuilderMethods.PrepareVarOrConstant(const constnode: TSyntaxnode; const isConst : Boolean; const ispublic : Boolean) : CGGlobalVariableDefinition;
begin
  Var constName := constnode.FindNode(TSyntaxNodeType.ntName).AttribName;
  Var typeNode := constnode.FindNode(TSyntaxNodeType.ntType);

  Var typeName := typeNode:AttribName;
  Var typeType := typeNode:AttribType;
  var lGlobalSet : CGFieldDefinition := nil;

  if typeType <> nil then
    case typeType.ToLower of
    // Special Handling of Array Constants
      'array' :
      exit  new CGGlobalVariableDefinition(PrepareArrayVarOrConstant(constnode, isConst, ispublic));
    end;

  if String.IsNullOrEmpty(typeName) then
    lGlobalSet := new CGFieldDefinition(constName)
  else
    lGlobalSet := new CGFieldDefinition(constName, typeName.AsTypeReference);

  var valuenode := constnode.FindNode(TSyntaxNodeType.ntValue);
  if valuenode <> nil then
    lGlobalSet.Initializer := PrepareExpressionValue(valuenode);

  lGlobalSet.Constant := isConst;

  if ispublic then
    lGlobalSet.Visibility := CGMemberVisibilityKind.Public;
  exit new CGGlobalVariableDefinition(lGlobalSet);

end;





method CodeBuilderMethods.mapVisibility(Value: TSyntaxNodeType): CGMemberVisibilityKind;
begin
  case Value of
    TSyntaxNodeType.ntPrivate : exit CGMemberVisibilityKind.Private;
    TSyntaxNodeType.ntStrictPrivate : exit CGMemberVisibilityKind.Private;
    TSyntaxNodeType.ntProtected : exit CGMemberVisibilityKind.Protected;
    TSyntaxNodeType.ntStrictProtected : exit CGMemberVisibilityKind.Protected;
    TSyntaxNodeType.ntPublic : exit CGMemberVisibilityKind.Public;
    TSyntaxNodeType.ntPublished : exit CGMemberVisibilityKind.Published;
    else
      exit CGMemberVisibilityKind.Unspecified;
  end;
end;

method CodeBuilderMethods.mapCallingConvention(const Value: String): CGCallingConventionKind;
begin
  case Value.ToLower of
    'stdcall' : exit CGCallingConventionKind.StdCall;
    'cdecl' : exit CGCallingConventionKind.CDecl;
    'pascal': exit CGCallingConventionKind.Pascal;
    'safecall': exit CGCallingConventionKind.SafeCall;
    else
      exit CGCallingConventionKind.Register;
  end;
end;

method CodeBuilderMethods.mapBinding(const Value: String): CGMemberVirtualityKind;
begin
  case Value.ToLower of
    'abstract' : exit CGMemberVirtualityKind.Abstract;
    'virtual' : exit CGMemberVirtualityKind.Virtual;
    'override' : exit CGMemberVirtualityKind.Override;
    'reintroduce' : exit CGMemberVirtualityKind.Reintroduce;
    else
      exit CGMemberVirtualityKind.None;
  end;
end;

method CodeBuilderMethods.PrepareDefaultValue(const paramnode: TSyntaxNode; paramkind : string): CGExpression;
begin
  result := nil;
  var literal := paramnode.FindNode(TSyntaxNodeType.ntExpression):FindNode(TSyntaxNodeType.ntLiteral);
  if (literal <> nil) then
    exit PrepareLiteralExpression(literal);

  literal := paramnode.FindNode(TSyntaxNodeType.ntExpression):FindNode(TSyntaxNodeType.ntIdentifier);
  if (literal <> nil) then
    exit new CGNamedIdentifierExpression(literal.AttribName);

  literal := paramnode.FindNode(TSyntaxNodeType.ntExpression);
  if (literal <> nil) and literal.HasChildren then
    exit PrepareSingleExpressionValue(literal.ChildNodes[0]);
end;

method CodeBuilderMethods.PrepareParam(const paramnode: TSyntaxNode): CGParameterDefinition;
begin
  result := nil;
  var paramName := paramnode.FindNode(TSyntaxNodeType.ntName):AttribName;

  var Modifier := CGParameterModifierKind.In;
  case paramnode.AttribKind.ToLower of
    'const' : Modifier := CGParameterModifierKind.Const;
    'var' : Modifier := CGParameterModifierKind.Var;
    'out' : Modifier := CGParameterModifierKind.Out;
  end;

  var paramTypenode := paramnode.FindNode(TSyntaxNodeType.ntType);
  if paramTypenode <> nil then
  begin
    var paramKind   := paramTypenode.AttribName;
    if String.IsNullOrEmpty(paramKind) then
    begin
      paramKind := paramTypenode.GetAttribute(TAttributeName.anType);

      case paramKind.ToLower of
        'array' : begin
          var ArrayTyp := paramTypenode.FindNode(TSyntaxNodeType.ntType):AttribName;
          if String.IsNullOrEmpty(ArrayTyp) then
            ArrayTyp := paramTypenode.FindNode(TSyntaxNodeType.ntType):AttribKind;

          var larray := new CGArrayTypeReference(ArrayTyp.AsTypeReference);
          var DefaultValue :=  PrepareDefaultValue(paramnode, ArrayTyp);
          exit new CGParameterDefinition(paramName, larray, Modifier := Modifier, DefaultValue := DefaultValue);

        end;
      end;
    end;
  // Is there a Defaultvalue
    var DefaultValue :=  PrepareDefaultValue(paramnode, paramKind);
    result := new CGParameterDefinition(paramName, paramKind.AsTypeReference, Modifier := Modifier, DefaultValue := DefaultValue);
  end
  else
  begin
    result := new CGParameterDefinition(paramName, ''.AsTypeReference, Modifier := Modifier);
  end;

end;

method CodeBuilderMethods.PrepareMethod(const methodnode : TSyntaxNode; const implnode: TSyntaxNode = nil): CGMethodLikeMemberDefinition;
begin
  Var MethodType := methodnode.AttribKind;
  var lMethod : CGMethodLikeMemberDefinition;

  case MethodType.ToLower of
    'constructor' : lMethod := new CGConstructorDefinition(methodnode.AttribName);
    'destructor' : lMethod := new CGDestructorDefinition(methodnode.AttribName);
    'operator'   : lMethod := new CGCustomOperatorDefinition(methodnode.FindNode(TSyntaxNodeType.ntName):AttribName);
    else
      begin
        lMethod := new CGMethodDefinition(methodnode.FindNode(TSyntaxNodeType.ntName):AttribName);
      end;
  end;

  Var ReturnType :=  methodnode.FindNode(TSyntaxNodeType.ntReturnType):FindNode(TSyntaxNodeType.ntType).AttribName;
  If not String.IsNullOrEmpty(ReturnType) then
    lMethod.ReturnType := ReturnType.AsTypeReference;

  lMethod.CallingConvention := mapCallingConvention(methodnode.GetAttribute(TAttributeName.anCallingConvention));
  lMethod.Visibility := mapVisibility(methodnode.ParentNode.Typ);
  lMethod.Virtuality := mapBinding(methodnode.GetAttribute(TAttributeName.anMethodBinding));
     // Class Method?
  if methodnode.GetAttribute(TAttributeName.anClass).ToLower = 'true' then
    lMethod.Static := true;

  for each &Param in methodnode.FindNodes(TSyntaxNodeType.ntParameter) do
    lMethod.Parameters.Add(PrepareParam(&Param));

// Is there an implementation?
  var lImplnode := if  assigned(implnode) then implnode else methodnode;

  for each ltypesec in lImplnode.ChildNodes do
    begin
    if ltypesec.Typ.notSupported  then
      lMethod.Statements.Add(BuildCommentFromNode('Unsupported', ltypesec, true))
    else
      case ltypesec.Typ of
     // TSyntaxNodeType.ntTypeSection : BuildTypesMethodClause(ltypesec, lMethod);
        TSyntaxNodeType.ntConstants : BuildConstantsMethodClause(ltypesec, lMethod);
        TSyntaxNodeType.ntVariables : BuildVariablesMethod(ltypesec, lMethod);
    //  TSyntaxNodeType.ntMethod : BuildGlobMethodClause(ltypesec, false);
        TSyntaxNodeType.ntStatements : BuildStatements(ltypesec, lMethod);
      end;
  end;
  result := lMethod;
end;


method CodeBuilderMethods.AddAncestors(const Value: CGClassOrStructTypeDefinition;  const Types : TSyntaxNode);
begin
  for each Node in Types.ChildNodes.FindAll(Item -> Item.Typ =  TSyntaxNodeType.ntType) do
    Value.Ancestors.Add(Node.GetAttribute(TAttributeName.anName).AsTypeReference);
end;

method CodeBuilderMethods.AddFields(const Value: CGClassOrStructTypeDefinition; const Types: TSyntaxNode);
begin
  const visibiltyFilter : set of TSyntaxNodeType = [TSyntaxNodeType.ntPrivate,
                                                    TSyntaxNodeType.ntStrictPrivate,
                                                    TSyntaxNodeType.ntStrictProtected,
                                                    TSyntaxNodeType.ntProtected,
                                                    TSyntaxNodeType.ntPublic];

  for each Visibility in Types.ChildNodes.FindAll(Item -> Item.Typ in visibiltyFilter )  do
    for each Node in Visibility.ChildNodes.FindAll(Item -> Item.Typ =  TSyntaxNodeType.ntField) do
      begin
      Var FieldName := Node.FindNode(TSyntaxNodeType.ntName).AttribName;
      Var FieldType := Node.FindNode(TSyntaxNodeType.ntType).AttribName;
      var lField := new CGFieldDefinition(FieldName, FieldType.AsTypeReference);
      lField.Visibility :=  mapVisibility(Visibility.Typ);
      Value.Members.Add(lField);
    end;

end;

method CodeBuilderMethods.BuildInterface(const InterfaceTypeNode: TSyntaxNode; const interfaceName: not nullable String): CGInterfaceTypeDefinition;
begin
  result := new CGInterfaceTypeDefinition(interfaceName);
  Var NodeGuid := InterfaceTypeNode.FindNode(TSyntaxNodeType.ntGuid);
  Var NodeValue := NodeGuid:FindNode(TSyntaxNodeType.ntLiteral);
  If assigned(NodeValue) then
  begin
    Var StringGuid := (NodeValue as TValuedSyntaxNode).Value;
    If StringGuid <> '' then
      result.InterfaceGuid := new Guid(StringGuid);
  end;

  AddAncestors(result, InterfaceTypeNode);

  for each &method in InterfaceTypeNode.FindNodes(TSyntaxNodeType.ntMethod) do
    begin
    result.Members.Add(PrepareMethod(&method));
  end;

  for each prop in InterfaceTypeNode.FindNodes(TSyntaxNodeType.ntProperty) do
    result.Members.Add(PrepareProperty(prop));

end;

method CodeBuilderMethods.BuildClass(const ClassTypeNode: TSyntaxNode; const ClassName: not nullable String; const methodBodys : Dictionary<String,TSyntaxNode>): CGClassTypeDefinition;
begin
  result := new CGClassTypeDefinition(ClassName);
    // Descenting from
  AddAncestors(result, ClassTypeNode);
  AddFields(result,  ClassTypeNode);

  for each &method in ClassTypeNode.FindNodes(TSyntaxNodeType.ntMethod) do
    begin
    var Search := ClassName.ToLower+'.'+BuildMethodMangledName(&method);

    if methodBodys.ContainsKey(Search) then
    begin
      result.Members.Add(PrepareMethod(&method, methodBodys[Search]));
    end
    else

      result.Members.Add(PrepareMethod(&method));
  end;




  for each prop in ClassTypeNode.FindNodes(TSyntaxNodeType.ntProperty) do
    result.Members.Add(PrepareProperty(prop));


end;

method CodeBuilderMethods.BuildSet(const node: TSyntaxNode; const ClassName: not nullable String): CGTypeDefinition;
begin
  var typenode := node.Findnode(TSyntaxNodeType.ntType);
  var typename := typenode:AttribName;
  if not String.IsNullOrEmpty(typename) then
  begin
    {$HINT "We need a Type in CGCodegen"}
    typename := "set of "+typename;
    var lTemp := new CGTypeAliasDefinition(ClassName, typename.AsTypeReference);
    lTemp.Comment := 'HardCoded Set of'.AsComment;
    exit lTemp;
  end;

  typename := typenode:AttribType;

 case typename:ToLower of
   'enum' : exit CodeBuilderEnum.BuildSet(node,ClassName);

  end; // Case

  exit new CGTypeAliasDefinition(ClassName, ('****UnknownSET').AsTypeReference)

  //raise new Exception("Could not create set or enum");
end;

method CodeBuilderMethods.BuildGlobMethod(const methodnode: TSyntaxNode; const ispublic : Boolean): CGGlobalFunctionDefinition;
begin
  Var res := PrepareMethod(methodnode);
  if res is CGMethodDefinition then
  begin
    result := (res as CGMethodDefinition).AsGlobal;
    result.Function.Visibility := if ispublic then CGMemberVisibilityKind.Public else CGMemberVisibilityKind.Private;
  end
  else exit nil;
end;

method CodeBuilderMethods.BuildRecord(const RecordTypeNode: TSyntaxNode; const recordName: not nullable String;const methodBodys : Dictionary<String,TSyntaxNode>) : CGStructTypeDefinition;
begin
  result :=  new CGStructTypeDefinition(recordName);
  for each FieldNode in RecordTypeNode.FindNodes(TSyntaxNodeType.ntField) do
    begin
    var Fieldname := FieldNode.FindNode(TSyntaxNodeType.ntName).AttribName;
    var FieldType := FieldNode.FindNode(TSyntaxNodeType.ntType).AttribName;

    Var cgType := CodeBuilderDefaultTypes.GetType(FieldType);

    Var lField := new CGFieldDefinition(Fieldname, cgType);
    lField.Visibility :=  mapVisibility(FieldNode.ParentNode.Typ);

    result.Members.Add(lField);
  end;

  for each &method in RecordTypeNode.FindNodes(TSyntaxNodeType.ntMethod) do
    begin

    var Search := recordName.ToLower+'.'+BuildMethodMangledName(&method);

    if methodBodys.ContainsKey(Search) then
    begin
      result.Members.Add(PrepareMethod(&method, methodBodys[Search]));
    end
    else

      result.Members.Add(PrepareMethod(&method));
  end;

  for each prop in RecordTypeNode.FindNodes(TSyntaxNodeType.ntProperty) do
    result.Members.Add(PrepareProperty(prop));

end;

method CodeBuilderMethods.BuildVariable(const node: TSyntaxnode; const ispublic : Boolean) : CGGlobalVariableDefinition;
begin
  exit PrepareVarOrConstant(node, false, ispublic);
end;

method CodeBuilderMethods.BuildConstant(const node: TSyntaxnode; const ispublic : Boolean) : CGGlobalVariableDefinition;
begin
  exit PrepareVarOrConstant(node, true, ispublic);
end;


method CodeBuilderMethods.BuildMethodMangledName(const methodnode: TSyntaxNode): String;
begin
  Var MethodName := methodnode.Findnode(TSyntaxNodeType.ntName):AttribName;
  Var MethodType := methodnode.AttribKind;

  if String.IsNullOrEmpty(MethodName) then
    case MethodType.ToLower of
      'constructor' : MethodName := methodnode.AttribName;
      'destructor' :  MethodName:=  methodnode.AttribName;
      'operator'   : MethodName := methodnode.FindNode(TSyntaxNodeType.ntName):AttribName;
    end;

  Var ReturnType :=  methodnode.FindNode(TSyntaxNodeType.ntReturnType):FindNode(TSyntaxNodeType.ntType).AttribName;
  var lParam : String;

  for each &Param in methodnode.FindNodes(TSyntaxNodeType.ntParameter) do
    lParam := lParam + &Param.Findnode(TSyntaxNodeType.ntName):AttribName+'_'+&Param.Findnode(TSyntaxNodeType.ntType):AttribName;
  result := (MethodName+'_'+lParam+'_'+ReturnType).ToLower;
end;

method CodeBuilderMethods.BuildArray(const ClassTypeNode: TSyntaxNode; const ClassName: not nullable String): CGTypeDefinition;
begin
  var lArray := PrepareArrayType(ClassTypeNode, ClassName);
  if assigned(lArray) then
    exit new CGTypeAliasDefinition(ClassName, lArray)

  else raise new Exception("Array Type Alias not solved");

end;

method CodeBuilderMethods.BuildAlias(const ClassTypeNode: TSyntaxNode; const ClassName: not nullable String): CGTypeDefinition;
begin
  Var typeName := ClassTypeNode.AttribName;
  if not String.IsNullOrEmpty(typeName)  then
    exit new CGTypeAliasDefinition(ClassName, typeName.AsTypeReference)
  else exit new CGTypeAliasDefinition(ClassName, '*****ALIAS not Solved'.AsTypeReference)
 // else raise new Exception("Type Alias not solved");
end;

method CodeBuilderMethods.BuildClassOf(const ClassTypeNode: TSyntaxNode; const ClassName: not nullable String): CGTypeDefinition;
begin
  Var typeName := ClassTypeNode.AttribName;
  if not String.IsNullOrEmpty(typeName)  then
    exit new CGTypeAliasDefinition(ClassName, ('Class of '+typeName).AsTypeReference)
  else raise new Exception("Type ClassOf not solved");
end;

method CodeBuilderMethods.BuildBlockType(const node: TSyntaxNode; const name: not nullable String): CGTypeDefinition;
begin
  Var typenode := node.FindNode(TSyntaxNodeType.ntType);
  if assigned(typenode) then
  begin
    (*
    public class CGBlockTypeDefinition : CGTypeDefinition {
    public var Parameters = List<CGParameterDefinition>()
    public var ReturnType: CGTypeReference?
    public var IsPlainFunctionPointer = false
    *)
    var ltemp := new CGBlockTypeDefinition(name);
    Var ReturnType :=  typenode.FindNode(TSyntaxNodeType.ntReturnType):FindNode(TSyntaxNodeType.ntType):AttribName;
    If not String.IsNullOrEmpty(ReturnType) then
      ltemp.ReturnType := ReturnType.AsTypeReference;
    for each &Param in typenode.FindNodes(TSyntaxNodeType.ntParameter) do
      ltemp.Parameters.Add(PrepareParam(&Param));

      if String.IsNullOrEmpty(typenode.AttribKind) then
        ltemp.IsPlainFunctionPointer := true;


      exit ltemp;//new CGTypeAliasDefinition(name, ltemp.AsTypeReference)
  end
  else raise new Exception("BuildBlockType not solved");
end;

method CodeBuilderMethods.BuildAnonymousBlockType(const node: TSyntaxNode; const name: not nullable String): CGTypeDefinition;
begin
  Var typenode := node.FindNode(TSyntaxNodeType.ntAnonymousMethodType);
  if assigned(typenode) then
  begin
    (*
    public class CGBlockTypeDefinition : CGTypeDefinition {
    public var Parameters = List<CGParameterDefinition>()
    public var ReturnType: CGTypeReference?
    public var IsPlainFunctionPointer = false
    *)
    var ltemp := new CGBlockTypeDefinition(name);
    Var ReturnType :=  typenode.FindNode(TSyntaxNodeType.ntReturnType):FindNode(TSyntaxNodeType.ntType):AttribName;
    If not String.IsNullOrEmpty(ReturnType) then
      ltemp.ReturnType := ReturnType.AsTypeReference;
    for each &Param in typenode.FindNodes(TSyntaxNodeType.ntParameter) do
      ltemp.Parameters.Add(PrepareParam(&Param));

    if String.IsNullOrEmpty(typenode.AttribKind) then
      ltemp.IsPlainFunctionPointer := true;


    exit ltemp;//new CGTypeAliasDefinition(name, ltemp.AsTypeReference)
  end
  else raise new Exception("BuildBlockType not solved");
end;



end.