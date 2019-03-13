namespace PlayGroundFritz;

type
  Test = public class
  private
  protected
  public

    method CreateUnit: CGCodeUnit;
    begin
      result := new CGCodeUnit();

      result.Imports.Add(new CGImport("System.Sysutils"));
      result.Imports.Add(new CGImport("System.UiTypoes"));
      result.Imports.Add(new CGImport("System.Classes"));

      var lRecord := new CGStructTypeDefinition("MyRecord");
      lRecord.Members.Add(new CGFieldDefinition("a", CGPredefinedTypeReference.Int32));
      lRecord.Members.Add(new CGFieldDefinition("b", CGPredefinedTypeReference.Double));
      result.Types.Add(lRecord);

      var lEnum := new CGEnumTypeDefinition("eCadPenStyle");
      lRecord.Members.Add(new CGEnumValueDefinition("lpsDash"));
      lRecord.Members.Add(new CGEnumValueDefinition("lpsSolid"));
      lRecord.Members.Add(new CGEnumValueDefinition("lpsDot"));
      result.Types.Add(lEnum);

      //var lSet := new CGSetTypeDefinition("eStyleset", "eCadPenStyle".AsTypeReference)

      var lGlobalSet := new CGFieldDefinition("DefaultStyle", "eStyleset".AsTypeReference);
      lGlobalSet.Constant := true;
      lGlobalSet.Initializer := new CGSetLiteralExpression(new CGEnumValueAccessExpression("eCadPenStyle".AsTypeReference, "lpsDash"),
                                                           new CGEnumValueAccessExpression("eCadPenStyle".AsTypeReference, "lpsSolid"));
      result.Globals.Add(new CGGlobalVariableDefinition(lGlobalSet));


      //Forwards are not needed/supported


      var lInterface := new CGInterfaceTypeDefinition("Itest");
      lInterface.InterfaceGuid := new Guid("{E277B1D4-88D3-4D1B-8541-39939F683D87}");
      result.Types.Add(lInterface);

      var lMethod := new CGMethodDefinition("GetColor");
      lMethod.ReturnType := "TColor".AsTypeReference;
      lMethod.CallingConvention := CGCallingConventionKind.StdCall;
      lInterface.Members.Add(lMethod);

      lMethod := new CGMethodDefinition("SetColor");
      lMethod.Parameters.Add(new CGParameterDefinition("Value", "TColor".AsTypeReference, Modifier := CGParameterModifierKind.Const));
      lInterface.Members.Add(lMethod);

      var lProperty := new CGPropertyDefinition("Color", "TColor".AsTypeReference);
      // this one needs some improveemnts tio reflect Delphi syntax, i think:
      lProperty.GetExpression := new CGMethodCallExpression(CGSelfExpression.Self, "GetColor");
      lProperty.SetExpression := new CGMethodCallExpression(CGSelfExpression.Self, "SetColor");
      lInterface.Members.Add(lProperty);


      var lAlias := new CGTypeAliasDefinition("CadColor", "System.UiTypes.Tcolor".AsTypeReference);
      result.Types.Add(lAlias);


      var lClass := new CGClassTypeDefinition("TLine", "TInterfacedObject".AsTypeReference);
      lClass.ImplementedInterfaces.Add("Itest".AsTypeReference);
      result.Types.Add(lClass);

      lMethod := new CGMethodDefinition("GetColor");
      lMethod.ReturnType := "TColor".AsTypeReference;
      lMethod.CallingConvention := CGCallingConventionKind.StdCall;
      lMethod.Visibility := CGMemberVisibilityKind.Private;
      lMethod.Statements.Add(new CGReturnStatement(new CGFieldAccessExpression(CGSelfExpression.Self, "fColor")));
      lClass.Members.Add(lMethod);

      lMethod := new CGMethodDefinition("SetColor");
      lMethod.Parameters.Add(new CGParameterDefinition("Value", "TColor".AsTypeReference, Modifier := CGParameterModifierKind.Const));
      lMethod.Visibility := CGMemberVisibilityKind.Private;
      lMethod.Statements.Add(new CGAssignmentStatement(new CGFieldAccessExpression(CGSelfExpression.Self, "fColor"), "Value".AsNamedIdentifierExpression));
      lClass.Members.Add(lMethod);

      lMethod := new CGMethodDefinition("savetoStream");
      lMethod.Parameters.Add(new CGParameterDefinition("s", "tstream".AsTypeReference, Modifier := CGParameterModifierKind.Const));
      lMethod.Visibility := CGMemberVisibilityKind.Public;
      lMethod.LocalVariables.Add(new CGVariableDeclarationStatement("temp", CGPredefinedTypeReference.Int32));
      lMethod.LocalVariables.Add(new CGVariableDeclarationStatement("a", new CGArrayTypeReference(CGPredefinedTypeReference.Int32)));
      lMethod.Statements.Add(new CGAssignmentStatement("temp".AsNamedIdentifierExpression,
                             new CGBinaryOperatorExpression(new CGFieldAccessExpression(CGSelfExpression.Self, "Fcolor"),
                                                            new CGMethodCallExpression(nil, "ord", new CGFieldAccessExpression(CGSelfExpression.Self, "Fstyle").AsCallParameter),
                                                            CGBinaryOperatorKind.Addition)));
      lMethod.Statements.Add(new CGMethodCallExpression("s".AsNamedIdentifierExpression, "write",
                                                        "temp".AsNamedIdentifierExpression.AsCallParameter,
                                                        new CGSizeOfExpression("temp".AsNamedIdentifierExpression).AsCallParameter));
      lMethod.Statements.Add(new CGAssignmentStatement("a".AsNamedIdentifierExpression, CGNilExpression.Nil));
      lMethod.Statements.Add(new CGAssignmentStatement("a".AsNamedIdentifierExpression, new CGBinaryOperatorExpression("a".AsNamedIdentifierExpression,
                                                                                                                       new CGArrayLiteralExpression(10.AsLiteralExpression, 20.AsLiteralExpression),
                                                                                                                       CGBinaryOperatorKind.Addition)));
      lMethod.Statements.Add(new CGMethodCallExpression(CGSelfExpression.Self, "setLength", "a".AsNamedIdentifierExpression.AsCallParameter, 10.AsLiteralExpression.AsCallParameter));
      lMethod.Statements.Add(new CGAssignmentStatement(new CGArrayElementAccessExpression("a".AsNamedIdentifierExpression, 2.AsLiteralExpression),
                                                       30.AsLiteralExpression));
      lClass.Members.Add(lMethod);

      var lCtor := new CGConstructorDefinition("Create");
      lCtor.Parameters.Add(new CGParameterDefinition("V", "tLine".AsTypeReference));
      lCtor.Parameters.Add(new CGParameterDefinition("aStyle", "eCadPenstyle".AsTypeReference, DefaultValue := new CGEnumValueAccessExpression("eCadPenStyle".AsTypeReference, "lpsSolid")));
      lCtor.Visibility := CGMemberVisibilityKind.Public;
      lCtor.Statements.Add(new CGConstructorCallStatement(CGInheritedExpression.Inherited));
      lCtor.Statements.Add(new CGAssignmentStatement(new CGFieldAccessExpression(CGSelfExpression.Self, "fColor"), new CGMethodCallExpression("V".AsNamedIdentifierExpression, "getColor")));
      lCtor.Statements.Add(new CGAssignmentStatement(new CGFieldAccessExpression(CGSelfExpression.Self, "fstyle"), "aStyle".AsNamedIdentifierExpression));
      lClass.Members.Add(lCtor);

      var lDtor := new CGDestructorDefinition("Destroy");
      lDtor.Virtuality := CGMemberVirtualityKind.Override;;
      //lDtor.Statements.Add(new CGDestuctorCallExpression(CGInheritedExpression.Inherited)); // not supported, need to add
      lClass.Members.Add(lDtor);

      var lField := new CGFieldDefinition("fstyle", "eCadPenstyle".AsTypeReference);
      lClass.Members.Add(lField);

      lField := new CGFieldDefinition("fColor", "TColor".AsTypeReference);
      lClass.Members.Add(lField);

      // we dontr support emitting these empty, but if there were statements, you could add them here:
      //result.Initialization.Add(...);
      //result.Finalization.Add(...);

    end;

    method GenerateCode(aGenerator: CGCodeGenerator): String;
    begin
      result := aGenerator.GenerateUnit(CreateUnit);
    end;

  end;

end.