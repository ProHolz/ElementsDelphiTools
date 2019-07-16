namespace ProHolz.CodeGen;

interface
uses ProHolz.Ast;

type
  // This part is used for Methods

  CodeBuilder =  partial class
  private
    method isImplementsMethod(const node: TSyntaxNode): CGMethodLikeMemberDefinition;
    method GetReturnType(const node: TSyntaxNode) : CGTypeReference;
    method PrepareDefaultValue(const node: TSyntaxNode; paramkind : String): CGExpression;
    method PrepareParam(const node: TSyntaxNode): CGParameterDefinition;
    method PrepareClassCreateMethod(const node: TSyntaxNode; const name : not nullable String): CGMethodLikeMemberDefinition;

    method PrepareMethod(const node : TSyntaxNode; implnode: TSyntaxNode) : CGMethodLikeMemberDefinition;
    method BuildLocalMethod(const node: TSyntaxNode; const lMethod: CGMethodLikeMemberDefinition);
    method PrepareLocalVarOrConstant(const node: TSyntaxNode; const isConst: Boolean): CGVariableDeclarationStatement;
    method BuildVariablesMethod(const node: TSyntaxNode; const lMethod: CGMethodLikeMemberDefinition);
    method BuildConstantsMethodClause(const node: TSyntaxNode; const lMethod: CGMethodLikeMemberDefinition);
    method BuildTypesMethodClause(const node : TSyntaxNode; const lMethod : CGMethodLikeMemberDefinition);

  end;
implementation

method CodeBuilder.PrepareLocalVarOrConstant(const node: TSyntaxnode; const isConst : Boolean) : CGVariableDeclarationStatement;
begin
  Var constName := node.FindNode(TSyntaxNodeType.ntName).AttribName;
  Var typeNode := node.FindNode(TSyntaxNodeType.ntType);

  Var typeName := typeNode:AttribName;
  Var typeType := typeNode:AttribType;

  if not String.IsNullOrEmpty(typeType) then
    case typeType.ToLower of
    // Special Handling of Array Constants
      'array' : begin
        var larray := PrepareArrayVarOrConstant(node, isConst, false);


        exit  new CGVariableDeclarationStatement(constName, larray.Type );
      end;

      'pointer' : begin
        typeName := typeNode.FindNode(TSyntaxNodeType.ntType):AttribName;

        exit new CGVariableDeclarationStatement(constName, new CGPointerTypeReference(typeName:AsTypeReference));
      end;

    end;

  var valuenode := node.FindNode(TSyntaxNodeType.ntValue);


  if assigned(typeNode) then
    result :=  new CGVariableDeclarationStatement(constName, PrepareTypeRef(typeNode), PrepareExpressionValue(valuenode))
  else
    result :=  new CGVariableDeclarationStatement(constName, nil , PrepareExpressionValue(valuenode));
  result.Constant := isConst;

end;


method CodeBuilder.BuildLocalMethod(const node : TSyntaxNode; const lMethod : CGMethodLikeMemberDefinition);
begin
  var lTemp := PrepareMethod(node, nil);
  if assigned(lTemp) and (lTemp is CGMethodDefinition) then
  begin
    if not assigned(lMethod.LocalMethods) then
      lMethod.LocalMethods := new List<CGMethodDefinition>;

    lMethod.LocalMethods.Add(CGMethodDefinition(lTemp));
  end;

end;


method CodeBuilder.BuildVariablesMethod(const node : TSyntaxNode; const lMethod : CGMethodLikeMemberDefinition);
begin
  for each Child in node.ChildNodes.FindAll(Item -> Item.Typ = TSyntaxNodeType.ntVariable) do
    begin

    var temp := PrepareLocalVarOrConstant(Child, false);
    if temp <> nil then
    begin
      if lMethod.LocalVariables = nil then
        lMethod.LocalVariables := new List<CGVariableDeclarationStatement>;

      lMethod.LocalVariables.Add(temp);
    end;
  end;
end;


method CodeBuilder.BuildConstantsMethodClause(const node : TSyntaxNode; const lMethod : CGMethodLikeMemberDefinition);
begin
  for each Child in node.ChildNodes.FindAll(Item -> Item.Typ = TSyntaxNodeType.ntConstant) do
    begin
    var temp := PrepareLocalVarOrConstant(Child, true);
    if temp <> nil then
    begin
      if lMethod.LocalVariables = nil then
        lMethod.LocalVariables := new List<CGVariableDeclarationStatement>;

      lMethod.LocalVariables.Add(temp);
    end;
  end;
end;

method CodeBuilder.BuildTypesMethodClause(const node : TSyntaxNode; const lMethod : CGMethodLikeMemberDefinition);
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

        if not assigned(lMethod.LocalTypes) then
          lMethod.LocalTypes := new List<CGTypeDefinition>;

        case lTyp  of
          'record' :  lMethod.LocalTypes.Add(BuildRecord(lTypNode, child.AttribName, nil));
        end;
      end;

    end;

end;

method CodeBuilder.GetReturnType(const node: TSyntaxNode): CGTypeReference;
begin
  if not assigned(node) then exit nil;
  assert(node.Typ = TSyntaxNodeType.ntReturnType);
  var lReturn := node.FindNode(TSyntaxNodeType.ntType);
  if assigned(lReturn) then
    exit PrepareTypeRef(lReturn)
  else
    exit nil;
end;

method CodeBuilder.isImplementsMethod(const node : TSyntaxNode): CGMethodLikeMemberDefinition;
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

method CodeBuilder.PrepareMethod(const node : TSyntaxNode; implnode: TSyntaxNode): CGMethodLikeMemberDefinition;
begin
  Var MethodType := node.AttribKind;
  var lMethod : CGMethodLikeMemberDefinition;
  var lMethodNameNode := node.FindNode(TSyntaxNodeType.ntName);
  var lMethodName := lMethodNameNode:AttribName;
  var lGenerics : List<CGGenericParameterDefinition> := nil;
  var lImplementationName : String;
  var lChangedDestructor : Boolean := false;


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


  lMethod.Visibility := mapVisibility(node.ParentNode.Typ);
  if node.getAttribute(TAttributeName.anAbstract).ToLower = 'true' then
    lMethod.Virtuality := CGMemberVirtualityKind.Abstract
  else
    if not (lMethod is CGConstructorDefinition) then
      lMethod.Virtuality := mapBinding(node.GetAttribute(TAttributeName.anMethodBinding));
     // Class Method?
  if node.GetAttribute(TAttributeName.anClass).ToLower = 'true' then
    lMethod.Static := true;

// Reintroduce?
  if not (lMethod is CGConstructorDefinition) then
    if node.getAttribute(TAttributeName.anReintroduce).ToLower = 'true' then
      lMethod.Reintroduced := true;




// Is there an implementation?
  var lImplnode := if  assigned(implnode) then implnode else node;

  for each ltypesec in lImplnode.ChildNodes do
    begin
    if ltypesec.Typ.NotSupported  then
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

  lMethod.CallingConvention := mapCallingConvention(node.GetAttribute(TAttributeName.anCallingConvention));

//  if lMethod.External then
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

method CodeBuilder.PrepareParam(const node: TSyntaxNode): CGParameterDefinition;
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
          var lrefTyp := GetType(ArrayTyp);

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

method CodeBuilder.PrepareClassCreateMethod(const node : TSyntaxNode; const name : not nullable String): CGMethodLikeMemberDefinition;
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




method CodeBuilder.PrepareDefaultValue(const node: TSyntaxNode; paramkind : string): CGExpression;
begin
  result := nil;
  var literal := node.FindNode(TSyntaxNodeType.ntExpression);
  if  assigned(literal)  then
    exit PrepareSingleExpressionValue(literal);

end;


end.