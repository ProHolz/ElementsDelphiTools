﻿namespace PlayGroundFritz;

interface
uses ProHolz.Ast;

type
  CodeBuilderMethods = static partial class
  private
    method isImplementsMethod(const methodnode: TSyntaxNode): CGMethodLikeMemberDefinition;
    method PrepareClassCreateMethod(const methodnode: TSyntaxNode; const name : not nullable String): CGMethodLikeMemberDefinition;
    method AddMembers(const res : CGClassOrStructTypeDefinition; const node: TSyntaxNode; const visibility :CGMemberVisibilityKind; const name: not nullable String;
    const methodBodys: Dictionary<String,TSyntaxNode>);

    method PrepareGenericParameterDefinition(const node: TSyntaxNode): List<CGGenericParameterDefinition>;

    method AddAncestors(const Value : CGClassOrStructTypeDefinition; const Types : TSyntaxNode);



    method PrepareArrayType(const Node: TSyntaxNode; const ClassName: not nullable String): CGArrayTypeReference;
    method PrepareProperty(prop: TSyntaxNode): CGPropertyDefinition;
    method PrepareVarOrConstant(const node: TSyntaxNode; const isConst: Boolean; const ispublic: Boolean): CGGlobalVariableDefinition;

    method PrepareDefaultValue(const paramnode: TSyntaxNode; paramkind : String): CGExpression;
    method PrepareParam(const node: TSyntaxNode): CGParameterDefinition;

    method PrepareMethod(const methodnode : TSyntaxNode; implnode: TSyntaxNode) : CGMethodLikeMemberDefinition;

  public
    method BuildInterface(const node : TSyntaxNode; const name : not nullable String): CGInterfaceTypeDefinition;
    method BuildClass(const node: TSyntaxNode; const name: not nullable String; const methodBodys : Dictionary<String,TSyntaxNode>): CGClassTypeDefinition;
    method BuildRecord(const node : TSyntaxNode; const name : not nullable String; const methodBodys : Dictionary<String,TSyntaxNode>): CGStructTypeDefinition;
    method BuildGlobMethod(const methodnode : TSyntaxNode; const ispublic : Boolean) : CGGlobalFunctionDefinition;

    method BuildSet(const node: TSyntaxNode; const ClassName: not nullable String): CGTypeDefinition;
    method BuildVariable(const node : TSyntaxNode; const ispublic : Boolean) : CGGlobalVariableDefinition ;
    method BuildConstant(const node : TSyntaxNode; const ispublic : Boolean) : CGGlobalVariableDefinition;

    method BuildArray(const ClassTypeNode: TSyntaxNode; const ClassName: not nullable String): CGTypeDefinition;
    method BuildAlias(const node: TSyntaxNode; const name: not nullable String): CGTypeDefinition;
    method BuildClassOf(const ClassTypeNode: TSyntaxNode; const ClassName: not nullable String): CGTypeDefinition;
    method BuildBlockType(const node: TSyntaxNode; const name: not nullable String): CGTypeDefinition;


    method BuildMethodMangledName(const node: TSyntaxNode): String;
    method PrepareGenericParameterName(const node: TSyntaxNode): String;
    method PrepareAttribute(node: TSyntaxNode): CGAttribute;
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
        begin
          result := new CGArrayTypeReference(typeNode.AttribName.AsTypeReference, lArrayBounds);
          result.ArrayKind := CGArrayKind.Static;
        end
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
  Var PropType := prop.FindNode(TSyntaxNodeType.ntType);
  Var PropKind := PropType:AttribName;
  if String.IsNullOrEmpty(PropKind) then
    result := new CGPropertyDefinition(Propname)
  else
    result := new CGPropertyDefinition(Propname,  PrepareTypeRef(PropType));
  result.Visibility :=  mapVisibility(prop.ParentNode.Typ);

  // Check for Parameters

  var lParams := prop.findnode(TSyntaxNodeType.ntParameters);
  if lParams <> nil then
  begin
    for each &param in lParams.FindChilds(TSyntaxNodeType.ntParameter) do
      begin
      result.Parameters.Add(PrepareParam(&param));
    end;

    if prop.findnode(TSyntaxNodeType.ntDefault) <> nil then
      result.Default := true;

  end;


  var lImpl := prop.FindNode(TSyntaxNodeType.ntImplements);
  if assigned(lImpl) then
  begin
    var lType :=  PrepareTypeRef(lImpl.FindNode(TSyntaxNodeType.ntType));
    if assigned(lType) then
      result.ImplementsInterface := lType;
  end;



  Var lRead := prop.FindNode(TSyntaxNodeType.ntRead):FindNode(TSyntaxNodeType.ntIdentifier);
  if lRead <> nil then
    result.GetExpression := new CGPropertyAccessExpression(nil, lRead.AttribName);

  Var lWrite := prop.FindNode(TSyntaxNodeType.ntWrite):FindNode(TSyntaxNodeType.ntIdentifier);
  if lWrite <> nil then
    result.SetExpression := new CGPropertyAccessExpression(nil, lWrite.AttribName);

end;

method CodeBuilderMethods.PrepareVarOrConstant(const node: TSyntaxnode; const isConst : Boolean; const ispublic : Boolean) : CGGlobalVariableDefinition;
begin
  Var constName := node.FindNode(TSyntaxNodeType.ntName).AttribName;
  Var typeNode := node.FindNode(TSyntaxNodeType.ntType);

  if assigned(typeNode) then
  begin
    case typeNode.AttribName.ToLower of
    // Special Handling of Array Constants
      'array' :
      exit  new CGGlobalVariableDefinition(PrepareArrayVarOrConstant(node, isConst, ispublic));
    end;

    case typeNode.AttribType.ToLower of
   // Special Handling of Array Constants
      'array' :
      exit  new CGGlobalVariableDefinition(PrepareArrayVarOrConstant(node, isConst, ispublic));
    end;


  end;

  Var typeName := typeNode:AttribName;
  var lGlobalSet := if String.IsNullOrEmpty(typeName) then  new CGFieldDefinition(constName)
else
  new CGFieldDefinition(constName, PrepareTypeRef( typeNode));

  var valuenode := node.FindNode(TSyntaxNodeType.ntValue);
  if assigned(valuenode) then
    lGlobalSet.Initializer := PrepareExpressionValue(valuenode);

  lGlobalSet.Constant := isConst;

  if ispublic then
    lGlobalSet.Visibility := CGMemberVisibilityKind.Public;
  exit new CGGlobalVariableDefinition(lGlobalSet);

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

method CodeBuilderMethods.PrepareParam(const node: TSyntaxNode): CGParameterDefinition;
begin
  result := nil;
  var paramName := node.FindNode(TSyntaxNodeType.ntName):AttribName;

  var Modifier := CGParameterModifierKind.In;
  case node.AttribKind.ToLower of
    'const' : Modifier := CGParameterModifierKind.Const;
    'var' : Modifier := CGParameterModifierKind.Var;
    'out' : Modifier := CGParameterModifierKind.Out;
  end;

  var paramTypenode := node.FindNode(TSyntaxNodeType.ntType);
  if assigned(paramTypenode) then
  begin
    var paramKind   := paramTypenode.AttribName;
    if String.IsNullOrEmpty(paramKind) then
    begin
      paramKind := paramTypenode.AttribKind;

      case paramKind.ToLower of
        'array' : begin
          var ArrayTyp := paramTypenode.FindNode(TSyntaxNodeType.ntType):AttribName;
          if String.IsNullOrEmpty(ArrayTyp) then
            ArrayTyp := paramTypenode.FindNode(TSyntaxNodeType.ntType):AttribKind;

          var larray := new CGArrayTypeReference(ArrayTyp.AsTypeReference);
          var DefaultValue :=  PrepareDefaultValue(node, ArrayTyp);
          exit new CGParameterDefinition(paramName, larray, Modifier := Modifier, DefaultValue := DefaultValue);

        end;
      end;
    end;
  // Is there a Defaultvalue
    var DefaultValue :=  PrepareDefaultValue(node, paramKind);
    result := new CGParameterDefinition(paramName, PrepareTypeRef(paramTypenode), Modifier := Modifier, DefaultValue := DefaultValue);
  end
  else
  begin
    result := new CGParameterDefinition(paramName, ''.AsTypeReference, Modifier := Modifier);
  end;

end;



method CodeBuilderMethods.PrepareClassCreateMethod(const methodnode : TSyntaxNode; const name : not nullable String): CGMethodLikeMemberDefinition;
begin
//  Var MethodType := methodnode.AttribKind;
  var lMethod : CGMethodLikeMemberDefinition;
  var lMethodNameNode := methodnode.FindNode(TSyntaxNodeType.ntName);
  var lMethodName := lMethodNameNode:AttribName;


     // Check for TypeParams
  // This done with a check for TypeParams in NameNode
  //var lTypeParams := lMethodNameNode.FindNode(TSyntaxNodeType.ntTypeParams);
  //if assigned(lTypeParams) then
  //begin
    //lMethodName := lMethodNameNode.FindNode(TSyntaxNodeType.ntName):AttribName;
    //lGenerics := PrepareGenericParameterDefinition(lMethodNameNode);
  //end;

  lMethod := new CGMethodDefinition(lMethodName);
  lMethod.Static := true;
  lMethod.Visibility := CGMemberVisibilityKind.Public;
  lMethod.ReturnType := name.AsTypeReference() isClassType(true);

  var lParams := new List<CGParameterDefinition>;

  for each &Param in methodnode.FindNode(TSyntaxNodeType.ntParameters):FindChilds(TSyntaxNodeType.ntParameter) do
    begin
    var lparam := PrepareParam(&Param);
    lMethod.Parameters.Add(lparam);
    lParams.Add(lparam);
  end;

  lMethod.Statements.add(new CGRawStatement('{$HINT "Check call to constructor"}'));

  var lCall := new CGNewInstanceExpression(name.AsNamedIdentifierExpression);

  for each lparam in lParams do
    lCall.Parameters.add(new CGCallParameter(lparam.Name.AsNamedIdentifierExpression));

  var lCreate := new CGReturnStatement(lCall);
  lMethod.Statements.add(lCreate);
  exit lMethod;

end;


method CodeBuilderMethods.PrepareMethod(const methodnode : TSyntaxNode; implnode: TSyntaxNode): CGMethodLikeMemberDefinition;
begin
  Var MethodType := methodnode.AttribKind;
  var lMethod : CGMethodLikeMemberDefinition;
  var lMethodNameNode := methodnode.FindNode(TSyntaxNodeType.ntName);
  var lMethodName := lMethodNameNode:AttribName;
  var lGenerics : List<CGGenericParameterDefinition> := nil;
  var lImplementationName : String;
  var lChangedDestructor : Boolean := false;


  if not assigned(lMethodNameNode) then
  begin
    var lResClause := methodnode.FindNode(TSyntaxNodeType.ntResolutionClause);
    if assigned(lResClause) then
    begin
      var lNames := lResClause.ChildNodes.Where(Item->Item.Typ = TSyntaxNodeType.ntName).toArray;
      if lNames.Count = 2 then
      begin
        lMethodNameNode := lNames[0];
        lMethodName := lMethodNameNode:AttribName;
        lImplementationName := lNames[1].AttribName;
      end
      else raise new Exception("Could not resolve ntResolutionClause");
    end
    else raise new Exception("Could not resolve Methodname");
  end;

   // Check for TypeParams
  // This done with a check for TypeParams in NameNode
  var lTypeParams := lMethodNameNode.FindNode(TSyntaxNodeType.ntTypeParams);
  if assigned(lTypeParams) then
  begin
    lMethodName := lMethodNameNode.FindNode(TSyntaxNodeType.ntName):AttribName;
    lGenerics := PrepareGenericParameterDefinition(lMethodNameNode);
  end;

  case MethodType.ToLower of
    'destructor' : begin
      lMethodName := 'destruct_'+lMethodName;
      lChangedDestructor := true;
    end;
  end;



  case MethodType.ToLower of
    'constructor' : begin
      lMethod := new CGConstructorDefinition('');
    end;
   // 'destructor' : lMethod := new CGDestructorDefinition(lMethodName);
    'operator'   : lMethod := new CGCustomOperatorDefinition(lMethodName);
    else
      begin
        lMethod := new CGMethodDefinition(lMethodName);
        CGMethodDefinition(lMethod).GenericParameters := lGenerics;
        if not String.IsNullOrEmpty(lImplementationName) then
        begin

          exit nil;
        end;
      end;
  end;



  Var ReturnType :=  GetReturnType( methodnode.FindNode(TSyntaxNodeType.ntReturnType));
  If assigned(ReturnType) then
    lMethod.ReturnType := ReturnType;

  lMethod.CallingConvention := mapCallingConvention(methodnode.GetAttribute(TAttributeName.anCallingConvention));
  lMethod.Visibility := mapVisibility(methodnode.ParentNode.Typ);
  if methodnode.getAttribute(TAttributeName.anAbstract).ToLower = 'true' then
    lMethod.Virtuality := CGMemberVirtualityKind.Abstract
  else
    lMethod.Virtuality := mapBinding(methodnode.GetAttribute(TAttributeName.anMethodBinding));
     // Class Method?
  if methodnode.GetAttribute(TAttributeName.anClass).ToLower = 'true' then
    lMethod.Static := true;

// Reintroduce?
  if methodnode.getAttribute(TAttributeName.anReintroduce).ToLower = 'true' then
    lMethod.Reintroduced := true;


//  var lParams :=
  for each &Param in
    methodnode.FindNode(TSyntaxNodeType.ntParameters):ChildNodes.where(Item-> Item.Typ = TSyntaxNodeType.ntParameter)
    do
    lMethod.Parameters.Add(PrepareParam(&Param));

// Is there an implementation?
  var lImplnode := if  assigned(implnode) then implnode else methodnode;

  for each ltypesec in lImplnode.ChildNodes do
    begin
    if ltypesec.Typ.notSupported  then
      lMethod.Statements.Add(BuildCommentFromNode('Unsupported', ltypesec, true))
    else
      case ltypesec.Typ of
        TSyntaxNodeType.ntTypeSection : BuildTypesMethodClause(ltypesec, lMethod);
        TSyntaxNodeType.ntConstants : BuildConstantsMethodClause(ltypesec, lMethod);
        TSyntaxNodeType.ntVariables : BuildVariablesMethod(ltypesec, lMethod);
        TSyntaxNodeType.ntMethod : BuildLocalMethod(ltypesec, lMethod);
        TSyntaxNodeType.ntStatements : BuildStatements(ltypesec, lMethod);
      end;
  end;

 // if we have changed the destructor to a method we
 // Adding a hint do the statements in the method
  if lChangedDestructor then
  begin
    lMethod.Statements.Insert(0, new CGRawStatement('{$HINT "destructor changed to method"}'));
   // lMethod.Comment.Lines.Add('destructor changed');
  end;


  result := lMethod;
end;


method CodeBuilderMethods.isImplementsMethod(const methodnode : TSyntaxNode): CGMethodLikeMemberDefinition;
begin
  var lMethod : CGMethodLikeMemberDefinition;
  var lMethodNameNode := methodnode.FindNode(TSyntaxNodeType.ntName);
  var lMethodName := lMethodNameNode:AttribName;
  var lImplementationName : String;

  if not assigned(lMethodNameNode) then
  begin
    var lResClause := methodnode.FindNode(TSyntaxNodeType.ntResolutionClause);
    if assigned(lResClause) then
    begin
      var lNames := lResClause.ChildNodes.Where(Item->Item.Typ = TSyntaxNodeType.ntName).toArray;
      if lNames.Count = 2 then
      begin
        lMethodNameNode := lNames[0];
        lMethodName := lMethodNameNode:AttribName;
        lImplementationName := lNames[1].AttribName;
      end
      else raise new Exception("Could not resolve ntResolutionClause");
    end
    else raise new Exception("Could not resolve Methodname");

    lMethod := new CGMethodDefinition(lMethodName);

    if not String.IsNullOrEmpty(lImplementationName) then
    begin
      lMethod.ImplementsInterface := lMethodName.AsTypeReference;
      lMethod.ImplementsInterfaceMember := lImplementationName;
      exit lMethod;
    end;
  end;
  result := nil;
end;




method CodeBuilderMethods.AddAncestors(const Value: CGClassOrStructTypeDefinition;  const Types : TSyntaxNode);
begin
  for each Node in Types.ChildNodes.FindAll(Item -> Item.Typ =  TSyntaxNodeType.ntType) do
    Value.Ancestors.Add(PrepareTypeRef(Node));
end;


method CodeBuilderMethods.BuildInterface(const node: TSyntaxNode; const name: not nullable String): CGInterfaceTypeDefinition;
begin
  result := new CGInterfaceTypeDefinition(name);
  result.GenericParameters.Add(PrepareGenericParameterDefinition(node.ParentNode).ToArray);
  Var NodeGuid := node.FindNode(TSyntaxNodeType.ntGuid);
  Var NodeValue := NodeGuid:FindNode(TSyntaxNodeType.ntLiteral);
  If assigned(NodeValue) then
  begin
    Var StringGuid := (NodeValue as TValuedSyntaxNode).Value;
    If StringGuid <> '' then begin
      result.InterfaceGuid := new Guid(StringGuid);
      if settings.InterfaceGuids then
      begin
        if settings.ComInterfaces then
          result.Attributes.Add(new CGAttribute('COM'.AsTypeReference));

        result.Attributes.Add(new CGAttribute('Guid'.AsTypeReference, new CGCallParameter(StringGuid.AsLiteralExpression)));
      end;
    end;
  end;

  AddAncestors(result, node);
  AddMembers(result, node, CGMemberVisibilityKind.Unspecified,   name, nil);

end;


method CodeBuilderMethods.PrepareGenericParameterDefinition(const node: TSyntaxNode) : List<CGGenericParameterDefinition>;
begin
  result := new List<CGGenericParameterDefinition>;
  var TypParams := node.FindNode(TSyntaxNodeType.ntTypeParams);
  if assigned(TypParams) then
  begin
    for each child in TypParams.FindChilds(TSyntaxNodeType.ntTypeParam) do
      begin
      result.Add(new CGGenericParameterDefinition(child.FindNode(TSyntaxNodeType.ntType).AttribName));
    end;
  end;

end;

method CodeBuilderMethods.PrepareGenericParameterName(const node: TSyntaxNode): String;
begin
  result := nil;
  if assigned(node) then
  begin
    var largs := new List<String>;
    for each child in node.ChildNodes.where(Item->Item.Typ = TSyntaxNodeType.ntTypeParam) do
      largs.Add(child.FindNode(TSyntaxNodeType.ntType).AttribName);

    if largs.Count > 0 then
    begin
      var dot := '';
      result := '<';
      for each s in largs  do
        begin
        result := result+dot+s;
        dot := ',';
      end;
      result := result+'>';
    end;
  end;

end;

method CodeBuilderMethods.AddMembers(const res : CGClassOrStructTypeDefinition; const node: TSyntaxNode;
const visibility :CGMemberVisibilityKind; const name: not nullable String; const methodBodys : Dictionary<String,TSyntaxNode>);
begin
  if assigned(node) then
  begin
    var lAttributes := new List<CGAttribute>;
    for each child in node.ChildNodes do
      begin
      case child.Typ of
        TSyntaxNodeType.ntField : begin
          Var lFieldName := child.FindNode(TSyntaxNodeType.ntName).AttribName;
          Var lFieldType := child.FindNode(TSyntaxNodeType.ntType);
          var lCgType : CGTypeReference;
          case lFieldType.AttribType.ToLower of
            'array' : begin
              lCgType := PrepareArrayType(lFieldType, lFieldName);
            end;
            else
              lCgType := PrepareTypeRef(lFieldType);
          end;


          var lField := new CGFieldDefinition(lFieldName, lCgType);
          lField.Visibility :=  visibility;
          res.Members.Add(lField);
          if lAttributes.Count > 0  then
          begin
            lField.Attributes.add(lAttributes);
            lAttributes.RemoveAll;
          end;


        end;

        TSyntaxNodeType.ntMethod :
        begin
          var Search := (name+'.'+BuildMethodMangledName(child)).ToLower;
          var lMethod :=
          if (assigned(methodBodys) and methodBodys.ContainsKey(Search)) then
            PrepareMethod(child, methodBodys[Search])
        else
          PrepareMethod(child, nil);

          if assigned(lMethod)  then
          begin
            if lAttributes.Count > 0  then
            begin
              lMethod.Attributes.add(lAttributes);
              lAttributes.RemoveAll;
            end;

            res.Members.Add(lMethod);

            if (lMethod is CGConstructorDefinition) and (not lMethod.Static) then
            begin
              var lClassMethod := PrepareClassCreateMethod(child, name);
              lClassMethod.ReturnType := name.AsTypeReference;
              res.Members.Add(lClassMethod);
            end;
          end
          // If we receaive nil it could be a
          // Implements Method so we check it
          else
          begin
            lMethod := isImplementsMethod(child);
            if assigned(lMethod) and (not String.IsNullOrEmpty(lMethod.ImplementsInterfaceMember)) and assigned(lMethod.ImplementsInterface) then
            begin
                // Search for the Method in Owner
             var lActual := res.Members.Find(Item->Item.Name.ToLower = lMethod.ImplementsInterfaceMember.ToLower);
             if assigned(lActual) and (lActual is CGMethodLikeMemberDefinition ) then
             begin
               var lData :=  CGNamedTypeReference(lMethod.ImplementsInterface).Name.Split('.', true);
               if lData.Count = 2 then
               begin
                 CGMethodLikeMemberDefinition(lActual).ImplementsInterface := lData[0].AsTypeReference;
                 CGMethodLikeMemberDefinition(lActual).ImplementsInterfaceMember := lData[1];
               end;
               lMethod := nil;
             end;
           end;
          end;
        end;

        TSyntaxNodeType.ntProperty : begin
          var lProp := PrepareProperty(child);
          if lAttributes.Count > 0  then
          begin
            lProp.Attributes.add(lAttributes);
            lAttributes.RemoveAll;
          end;

          res.Members.Add(lProp);
        end;

        TSyntaxNodeType.ntAttributes : begin
          for each lNodeAttr in child.ChildNodes.Where(Item->Item.Typ = TSyntaxNodeType.ntAttribute) do
            begin
            var lattr := PrepareAttribute(lNodeAttr);
            if assigned(lattr) then
              lAttributes.Add(lattr);
          end;
        end;


        // Visibilitys
        TSyntaxNodeType.ntPrivate : AddMembers(res, child, CGMemberVisibilityKind.Private, name, methodBodys);
        TSyntaxNodeType.ntStrictPrivate :  AddMembers(res, child, CGMemberVisibilityKind.Private, name, methodBodys);
        TSyntaxNodeType.ntStrictProtected : AddMembers(res, child, CGMemberVisibilityKind.Protected, name, methodBodys);
        TSyntaxNodeType.ntProtected : AddMembers(res, child, CGMemberVisibilityKind.Protected, name, methodBodys);
        TSyntaxNodeType.ntPublic : AddMembers(res, child, CGMemberVisibilityKind.Public, name, methodBodys);
        TSyntaxNodeType.ntPublished : AddMembers(res, child, CGMemberVisibilityKind.Published, name, methodBodys);

      end;
    end;
  end;
end;


method CodeBuilderMethods.BuildClass(const node: TSyntaxNode; const name: not nullable String; const methodBodys : Dictionary<String,TSyntaxNode>): CGClassTypeDefinition;
begin
  //public var GenericParameters = List<CGGenericParameterDefinition>()
  result := new CGClassTypeDefinition(name);
  var lGenerics := PrepareGenericParameterDefinition(node.ParentNode).ToArray;
  result.GenericParameters.Add(lGenerics);

  var lTypeParams := node.ParentNode.FindNode(TSyntaxNodeType.ntTypeParams);
  var lname : String := '';
  if assigned(lTypeParams) then
    lname := CodeBuilderMethods.PrepareGenericParameterName(lTypeParams);

    // Descenting from
  AddAncestors(result, node);
  AddMembers(result, node, CGMemberVisibilityKind.Unspecified,   name+lname, methodBodys);

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
  Var res := PrepareMethod(methodnode, nil);
  if res is CGMethodDefinition then
  begin
    result := (res as CGMethodDefinition).AsGlobal;
    result.Function.Visibility := if ispublic then CGMemberVisibilityKind.Public else CGMemberVisibilityKind.Private;
  end
  else exit nil;
end;

method CodeBuilderMethods.BuildRecord(const node: TSyntaxNode; const name: not nullable String;const methodBodys : Dictionary<String,TSyntaxNode>) : CGStructTypeDefinition;
begin
  result :=  new CGStructTypeDefinition(name);
  var lGenerics := PrepareGenericParameterDefinition(node.ParentNode).ToArray;
  result.GenericParameters.Add(lGenerics);

  var lTypeParams := node.ParentNode.FindNode(TSyntaxNodeType.ntTypeParams);
  var lname : String := '';
  if assigned(lTypeParams) then
    lname := CodeBuilderMethods.PrepareGenericParameterName(lTypeParams);

    // Descenting from
  AddAncestors(result, node);
  AddMembers(result, node, CGMemberVisibilityKind.Unspecified,   name+lname, methodBodys);
end;

method CodeBuilderMethods.BuildVariable(const node: TSyntaxnode; const ispublic : Boolean) : CGGlobalVariableDefinition;
begin
  exit PrepareVarOrConstant(node, false, ispublic);
end;

method CodeBuilderMethods.BuildConstant(const node: TSyntaxnode; const ispublic : Boolean) : CGGlobalVariableDefinition;
begin
  exit PrepareVarOrConstant(node, true, ispublic);
end;


method CodeBuilderMethods.BuildMethodMangledName(const node: TSyntaxNode ): String;
begin
  var lName := node.Findnode(TSyntaxNodeType.ntName);
  var MethodName := lName:AttribName;
  Var ReturnType :=  node.FindNode(TSyntaxNodeType.ntReturnType):FindNode(TSyntaxNodeType.ntType).AttribName;
  var lParam : String;

  for each &Param in node.FindNode(TSyntaxNodeType.ntParameters):FindChilds(TSyntaxNodeType.ntParameter) do
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

method CodeBuilderMethods.BuildAlias(const node: TSyntaxNode; const name: not nullable String): CGTypeDefinition;
require
  (node <> nil) implies (node.Typ = TSyntaxNodeType.ntType);
begin
  Var typeName := node.AttribName;
  if not String.IsNullOrEmpty(typeName)  then
  begin
    var lref := PrepareTypeRef(node);
    exit new CGTypeAliasDefinition(name, lref);
  end
  else raise new Exception("BuildAlias not solved");
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

    var ltemp := new CGBlockTypeDefinition(name);
    Var ReturnType :=   GetReturnType(typenode.FindNode(TSyntaxNodeType.ntReturnType));
    If assigned(ReturnType) then
      ltemp.ReturnType := ReturnType;

    for each &Param in typenode.FindNode(TSyntaxNodeType.ntParameters):FindChilds(TSyntaxNodeType.ntParameter) do
      ltemp.Parameters.Add(PrepareParam(&Param));

    if String.IsNullOrEmpty(typenode.AttribKind) then
      ltemp.IsPlainFunctionPointer := true;


    exit ltemp;
  end
  else raise new Exception("BuildBlockType not solved");
end;

method CodeBuilderMethods.PrepareAttribute(node: TSyntaxNode): CGAttribute;
begin
  Var lName := node.FindNode(TSyntaxNodeType.ntName):AttribName;
  if not String.IsNullOrEmpty(lName) then
  begin
    var lparameter := new List<CGCallParameter>;
    var lArguments := node.FindNode(TSyntaxNodeType.ntArguments);

    for each posarg in lArguments:ChildNodes.Where(Item->Item.Typ = TSyntaxNodeType.ntPositionalArgument) do
      begin
      var lattr := PrepareExpressionValue(posarg.FindNode(TSyntaxNodeType.ntValue));
      if assigned(lattr) then
        lparameter.Add(new CGCallParameter(lattr));
    end;
    if lparameter.Count > 0 then
      result := new CGAttribute(lName.AsTypeReference, lparameter)
    else
      result := new CGAttribute(lName.AsTypeReference);
  end;
end;

end.