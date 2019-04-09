namespace ProHolz.CodeGen;

interface
uses ProHolz.Ast;

type

  prepareNewTypeEnum = (&block, &enum);

  CodeBuilderMethods = static partial class
  private
    method PrepareInitializer(aType: CGTypeReference; node: TSyntaxNode): CGExpression;

    method PrepareDllCallAttribute(const node: TSyntaxNode): CGAttribute;
    method PrepareCallingConventionAttribute(const value: CGCallingConventionKind): CGAttribute;
    method isImplementsMethod(const node: TSyntaxNode): CGMethodLikeMemberDefinition;
    method PrepareClassCreateMethod(const node: TSyntaxNode; const name : not nullable String): CGMethodLikeMemberDefinition;
    method AddMembers(const res : CGClassOrStructTypeDefinition; const node: TSyntaxNode; const visibility :CGMemberVisibilityKind; const name: not nullable String;
    const methodBodys: Dictionary<String,TSyntaxNode>);

    method PrepareGenericParameterDefinition(const node: TSyntaxNode): List<CGGenericParameterDefinition>;

    method AddAncestors(const Value : CGClassOrStructTypeDefinition; const Types : TSyntaxNode);

    method PrepareArrayType(const node: TSyntaxNode): CGTypeReference;
    method PrepareProperty(prop: TSyntaxNode): CGPropertyDefinition;
    method PrepareVarOrConstant(const node: TSyntaxNode; const isConst: Boolean; const ispublic: Boolean; const newtypename : String = nil): CGGlobalVariableDefinition;

    method PrepareDefaultValue(const paramnode: TSyntaxNode; paramkind : String): CGExpression;
    method PrepareParam(const node: TSyntaxNode): CGParameterDefinition;

    method PrepareMethod(const methodnode : TSyntaxNode; implnode: TSyntaxNode) : CGMethodLikeMemberDefinition;

  public
    method BuildInterface(const node : TSyntaxNode; const name : not nullable String): CGInterfaceTypeDefinition;
    method BuildClass(const node: TSyntaxNode; const name: not nullable String; const methodBodys : Dictionary<String,TSyntaxNode>): CGClassTypeDefinition;
    method BuildRecord(const node : TSyntaxNode; const name : not nullable String; const methodBodys : Dictionary<String,TSyntaxNode>): CGClassOrStructTypeDefinition;
    method BuildGlobMethod(const methodnode : TSyntaxNode; const ispublic : Boolean) : CGGlobalFunctionDefinition;

    method BuildSet(const node: TSyntaxNode; const className: not nullable String): CGTypeDefinition;
    method BuildVariable(const node : TSyntaxNode; const ispublic : Boolean; const newtypename : String = nil) : CGGlobalVariableDefinition ;
    method BuildConstant(const node : TSyntaxNode; const ispublic : Boolean) : CGGlobalVariableDefinition;

    method BuildArray(const node: TSyntaxNode; const className: not nullable String): CGTypeDefinition;
    method BuildAlias(const node: TSyntaxNode; const name: not nullable String): CGTypeDefinition;
    method BuildClassOf(const node: TSyntaxNode; const className: not nullable String): CGTypeDefinition;
    method BuildBlockType(const node: TSyntaxNode; const name: not nullable String): CGTypeDefinition;


    method BuildMethodMangledName(const node: TSyntaxNode): String;
    method PrepareGenericParameterName(const node: TSyntaxNode): String;
    method PrepareAttribute(const node: TSyntaxNode): CGAttribute;
    method isVarWithNewType(const node : TSyntaxNode; out preparetyp : prepareNewTypeEnum) : Boolean;
  end;

implementation

method CodeBuilderMethods.PrepareArrayType(const node: TSyntaxNode): CGTypeReference;
begin
  var typeNode := node.FindNode(TSyntaxNodeType.ntType);
  if assigned(typeNode) then
  begin
    var lBounds := resolveBounds(node);
    if lBounds <> nil then
    begin
      var lArrayBounds := new List<CGArrayBounds>;
      for each lbound in lBounds do
        if lbound is CGArrayBounds then
          lArrayBounds.Add(lbound as CGArrayBounds);


        Var lTempType := PrepareTypeRef(typeNode);
        if lArrayBounds.Count > 0 then
        begin
          result := new CGArrayTypeReference(lTempType, lArrayBounds);

          CGArrayTypeReference( result).ArrayKind := CGArrayKind.Static;
        end
        else
          result := new CGArrayTypeReference(lTempType);
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

method CodeBuilderMethods.PrepareInitializer(aType : CGTypeReference; node : TSyntaxNode) : CGExpression;
begin
  var lres := new CGNewInstanceExpression(aType);
  var lFields := new List<CGPropertyInitializer>;

  if node.Typ = TSyntaxNodeType.ntRecordConstant then
  begin
    for each child in node.FindChilds(TSyntaxNodeType.ntField) do
      lFields.Add(PrepareFieldExpression(child));
  end
  else
  begin
  for each rec in node.FindChilds(TSyntaxNodeType.ntRecordConstant) do
  for each child in rec.FindChilds(TSyntaxNodeType.ntField) do
    lFields.Add(PrepareFieldExpression(child));
  end;
if lFields.Count > 0 then
 lres.PropertyInitializers := lFields;

  result := lres;

end;

method CodeBuilderMethods.PrepareVarOrConstant(const node: TSyntaxnode; const isConst : Boolean; const ispublic : Boolean; const newtypename : string = nil) : CGGlobalVariableDefinition;
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
      'set' :
      begin
          var lset := PrepareSetVarOrConstant(node, isConst, ispublic);
        //  exit lset;

          exit  new CGGlobalVariableDefinition(lset);
      end;
    end;
  end;

  var typename : String := '';

  if assigned(newtypename) then
    typename := newtypename
  else
  begin
    typename := typeNode:AttribName;
    if String.IsNullOrEmpty(typename) then
      typename := typeNode:AttribType;
  end;

  var   lGlobalSet := if String.IsNullOrEmpty(typename) then  new CGFieldDefinition(constName)
else if assigned(newtypename) then
  new CGFieldDefinition(constName, newtypename.AsTypeReference)
else
  new CGFieldDefinition(constName, PrepareTypeRef( typeNode));

  lGlobalSet.Constant := isConst;

  var valuenode := node.FindNode(TSyntaxNodeType.ntValue);
  if assigned(valuenode) then
   begin
     // If there ar ntRecordConstants inside we will solve these
     var rec := valuenode.FindAllNodes(TSyntaxNodeType.ntRecordConstant);
     if rec.Length > 0 then
     begin
       lGlobalSet.Initializer := PrepareInitializer(lGlobalSet.Type,  valuenode);
       //lGlobalSet.Constant := false;
       //lGlobalSet.ReadOnly := true;
       //lGlobalSet.l
     end
    else
    lGlobalSet.Initializer := PrepareExpressionValue(valuenode);
   end;



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
      if String.IsNullOrEmpty(paramKind) then
        paramKind := paramTypenode.AttribType;


      case paramKind.ToLower of
        'array' : begin
          var ArrayTyp := paramTypenode.FindNode(TSyntaxNodeType.ntType):AttribName;
          if String.IsNullOrEmpty(ArrayTyp) then
            ArrayTyp := paramTypenode.FindNode(TSyntaxNodeType.ntType):AttribKind;
          var lrefTyp :=
          // if CodeBuilderDefaultTypes.isDefaultType(ArrayTyp) then
          CodeBuilderDefaultTypes.GetType(ArrayTyp);



          var larray := new CGArrayTypeReference(lrefTyp);
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
    //result := new CGParameterDefinition(paramName, ''.AsTypeReference, Modifier := Modifier);
    result := new CGParameterDefinition(paramName, Modifier := Modifier);
  end;

end;



method CodeBuilderMethods.PrepareClassCreateMethod(const node : TSyntaxNode; const name : not nullable String): CGMethodLikeMemberDefinition;
begin
  var lMethod : CGMethodLikeMemberDefinition;
  var lMethodNameNode := node.FindNode(TSyntaxNodeType.ntName);
  var lMethodName := lMethodNameNode:AttribName;


  lMethod := new CGMethodDefinition(lMethodName);
  lMethod.Static := true;
  lMethod.Visibility := CGMemberVisibilityKind.Public;
  lMethod.ReturnType := name.AsTypeReference() isClassType(true);

  var lParams := new List<CGParameterDefinition>;

  for each &Param in node.FindNode(TSyntaxNodeType.ntParameters):FindChilds(TSyntaxNodeType.ntParameter) do
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


method CodeBuilderMethods.PrepareCallingConventionAttribute(const value : CGCallingConventionKind) : CGAttribute;
begin
  result :=
  case value of
    CGCallingConventionKind.CDecl : new CGAttribute('CallingConvention'.AsTypeReference, 'CallingConvention.Cdecl'.AsNamedIdentifierExpression.AsCallParameter);
    CGCallingConventionKind.StdCall : new CGAttribute('CallingConvention'.AsTypeReference, 'CallingConvention.StdCall'.AsNamedIdentifierExpression.AsCallParameter);
    CGCallingConventionKind.SafeCall : new CGAttribute('CallingConvention'.AsTypeReference, 'CallingConvention.SafeCall'.AsNamedIdentifierExpression.AsCallParameter);
  end;
end;


method CodeBuilderMethods.PrepareDllCallAttribute(const node : TSyntaxNode) : CGAttribute;
begin
  var lident := node.FindNode(TSyntaxNodeType.ntIdentifier);
  if not assigned(lident) then
    lident := node.FindNode(TSyntaxNodeType.ntLiteral);


  var ltype := PrepareSingleExpressionValue(lident);
//  [DllImport('', EntryPoint := '__island_get_intvalue')]
//  [DllImport('', EntryPoint := '__island_get_intvalue')]
  var lextnode := node.FindNode(TSyntaxNodeType.ntExternalName);
  if assigned(lextnode) then
  begin
      //var Lexpressions := PrepareCallExpressions(lextnode);
      //if Lexpressions.count > 0 then
      //begin
        //var lData := new CGCallParameter(Lexpressions.ToList);
      //end;

    var lexttype := PrepareSingleExpressionValue(lextnode);
    var lentry := new CGCallParameter(lexttype, 'EntryPoint') as not nullable;
    exit new CGAttribute('DllImport'.AsTypeReference, ltype.AsCallParameter, lentry);
  end;

  exit new CGAttribute('DllImport'.AsTypeReference, ltype.AsCallParameter);
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


  lMethod.Visibility := mapVisibility(methodnode.ParentNode.Typ);
  if methodnode.getAttribute(TAttributeName.anAbstract).ToLower = 'true' then
    lMethod.Virtuality := CGMemberVirtualityKind.Abstract
  else
    if not (lMethod is CGConstructorDefinition) then
      lMethod.Virtuality := mapBinding(methodnode.GetAttribute(TAttributeName.anMethodBinding));
     // Class Method?
  if methodnode.GetAttribute(TAttributeName.anClass).ToLower = 'true' then
    lMethod.Static := true;

// Reintroduce?
  if not (lMethod is CGConstructorDefinition) then
    if methodnode.getAttribute(TAttributeName.anReintroduce).ToLower = 'true' then
      lMethod.Reintroduced := true;




// Is there an implementation?
  var lImplnode := if  assigned(implnode) then implnode else methodnode;

  for each ltypesec in lImplnode.ChildNodes do
    begin
    if ltypesec.Typ.notSupported  then
      lMethod.Statements.Add(BuildCommentFromNode('Unsupported', ltypesec, true))
    else
      case ltypesec.Typ of
        TSyntaxNodeType.ntParameters : begin
          for each &Param in
            ltypesec.ChildNodes.where(Item-> Item.Typ = TSyntaxNodeType.ntParameter)
            do
            lMethod.Parameters.Add(PrepareParam(&Param));
        end;
        TSyntaxNodeType.ntReturnType : lMethod.ReturnType := GetReturnType(ltypesec);
        TSyntaxNodeType.ntTypeSection : BuildTypesMethodClause(ltypesec, lMethod);
        TSyntaxNodeType.ntConstants : BuildConstantsMethodClause(ltypesec, lMethod);
        TSyntaxNodeType.ntVariables : BuildVariablesMethod(ltypesec, lMethod);
        TSyntaxNodeType.ntMethod : BuildLocalMethod(ltypesec, lMethod);
        TSyntaxNodeType.ntStatements : BuildStatements(ltypesec, lMethod);
        TSyntaxNodeType.ntExternal : begin
          lMethod.External := true;

          lMethod.Attributes.Add(PrepareDllCallAttribute(ltypesec));


        end;
      end;
  end;

  lMethod.CallingConvention := mapCallingConvention(methodnode.GetAttribute(TAttributeName.anCallingConvention));

  if lMethod.External then
  begin
    if (lMethod.CallingConvention <> CGCallingConventionKind.Register) then
      lMethod.Attributes.Add(PrepareCallingConventionAttribute(lMethod.CallingConvention));

  end;

 // if we have changed the destructor to a method we
 // Adding a hint do the statements in the method
  if lChangedDestructor then
  begin
    lMethod.Comment := "destructor changed to method".AsBuilderComment;
    lMethod.Statements.Insert(0, new CGRawStatement('{$HINT "destructor changed to method"}'));
    lMethod.Virtuality := CGMemberVirtualityKind.None;
   // lMethod.Comment.Lines.Add('destructor changed');
  end;


  result := lMethod;
end;


method CodeBuilderMethods.isImplementsMethod(const node : TSyntaxNode): CGMethodLikeMemberDefinition;
begin
  var lMethod : CGMethodLikeMemberDefinition;
  var lMethodNameNode := node.FindNode(TSyntaxNodeType.ntName);
  var lMethodName := lMethodNameNode:AttribName;
  var lImplementationName : String;

  if not assigned(lMethodNameNode) then
  begin
    var lResClause := node.FindNode(TSyntaxNodeType.ntResolutionClause);
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
  // Interface
  if Value is CGInterfaceTypeDefinition then
  begin
    for each child in Types.ChildNodes.FindAll(Item -> Item.Typ =  TSyntaxNodeType.ntType)  do
      Value.ImplementedInterfaces.Add(PrepareTypeRef(child));

  end
  else
  // Class
    for each child in Types.ChildNodes.FindAll(Item -> Item.Typ =  TSyntaxNodeType.ntType) index i do
      begin
    // In Delphi for a class the first is the anestor all others are interfaces
      if i= 0 then
        Value.Ancestors.Add(PrepareTypeRef(child))
      else
        Value.ImplementedInterfaces.Add(PrepareTypeRef(child));
    end;
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
  if settings.PublicInterfaces then
    result.Visibility := CGTypeVisibilityKind.Public;


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
              lCgType := PrepareArrayType(lFieldType);
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
              lMethod.Comment := 'Nameless Constructor added'.AsBuilderComment;
              var lClassMethod := PrepareClassCreateMethod(child, name);
              lClassMethod.ReturnType := name.AsTypeReference;
              lClassMethod.Comment := 'Static Factory method added'.AsBuilderComment;
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

  if settings.PublicClasses then
    result.Visibility := CGTypeVisibilityKind.Public;

end;

method CodeBuilderMethods.BuildSet(const node: TSyntaxNode; const className: not nullable String): CGTypeDefinition;
begin
  var typenode := node.Findnode(TSyntaxNodeType.ntType);
  var typename := typenode:AttribName;
  if not String.IsNullOrEmpty(typename) then
    exit new CGTypeAliasDefinition(className,  new CGSetTypeReference( typename.AsTypeReference));

  typename := typenode:AttribType;

  case typename:ToLower of
    'enum' : exit CodeBuilderEnum.BuildSet(node,className);

  end; // Case

  {..$HINT "ADD SUPPORT FOR OTHER SET TYPES"}

  if node.ChildNodes.Count = 2 then
  begin
    var lstart := PrepareSingleExpressionValue(node.ChildNodes[0]);
   var lEnd := PrepareSingleExpressionValue(node.ChildNodes[1]);

    exit new CGTypeAliasDefinition(className, new CGRangeTypeReference(lstart, lEnd));
  end;


  var lres := new CGTypeAliasDefinition(className, ('****UnknownSET').AsTypeReference);
  lres.Comment :=  $" UnknownSet on Line {node.ParentNode.Line}".AsComment;

  if settings.PublicEnums then
    lres.Visibility := CGTypeVisibilityKind.Public;


  exit lres;

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

method CodeBuilderMethods.BuildRecord(const node: TSyntaxNode; const name: not nullable String;const methodBodys : Dictionary<String,TSyntaxNode>) : CGClassOrStructTypeDefinition;
begin
{$IF LOG}
  writeLn(TSyntaxTreeWriter.ToXML(node, true ) );
{$ENDIF}
  var Helper := node.FindNode(TSyntaxNodeType.ntHelper);

  if assigned(Helper) then
   begin
    result :=  new CGExtensionTypeDefinition(name);
     AddAncestors( result, Helper);

   end
   else
  result :=  new CGStructTypeDefinition(name);
  var lGenerics := PrepareGenericParameterDefinition(node.ParentNode).ToArray;
  result.GenericParameters.Add(lGenerics);

  var lTypeParams := node.ParentNode.FindNode(TSyntaxNodeType.ntTypeParams);
  var lname : String := '';
  if assigned(lTypeParams) then
    lname := CodeBuilderMethods.PrepareGenericParameterName(lTypeParams);

  AddMembers(result, node, CGMemberVisibilityKind.Unspecified,   name+lname, methodBodys);

  if settings.PublicRecords then
    result.Visibility := CGTypeVisibilityKind.Public;


end;

method CodeBuilderMethods.BuildVariable(const node: TSyntaxnode; const ispublic : Boolean; const newtypename : string = nil) : CGGlobalVariableDefinition;
begin
  exit PrepareVarOrConstant(node, false, ispublic, newtypename);
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


method CodeBuilderMethods.BuildArray(const node: TSyntaxNode; const className: not nullable String): CGTypeDefinition;
begin
  var lArray := PrepareArrayType(node);
  if assigned(lArray) then
    exit new CGTypeAliasDefinition(className, lArray)
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

method CodeBuilderMethods.BuildClassOf(const node: TSyntaxNode; const className: not nullable String): CGTypeDefinition;
begin
  Var typeName := node.AttribName;
  if not String.IsNullOrEmpty(typeName)  then
    exit new CGTypeAliasDefinition(className, ('Class of '+typeName).AsTypeReference)
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
   if settings.PublicBlocks then
     ltemp.Visibility := CGTypeVisibilityKind.Public;

    exit ltemp;
  end
  else raise new Exception("BuildBlockType not solved");
end;

method CodeBuilderMethods.PrepareAttribute(const node: TSyntaxNode): CGAttribute;
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

method CodeBuilderMethods.isVarWithNewType(const node: TSyntaxnode; out preparetyp : prepareNewTypeEnum): Boolean;
begin
  case node.FindNode(TSyntaxNodeType.ntType):AttribType.ToLower of
    'function','procedure' : begin
        preparetyp := prepareNewTypeEnum.block;
        exit true;
    end;
    'enum' : begin
      preparetyp := prepareNewTypeEnum.enum;
      exit true;
    end;
  end;
  exit false;
end;

end.