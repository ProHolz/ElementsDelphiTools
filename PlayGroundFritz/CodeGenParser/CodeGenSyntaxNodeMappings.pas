namespace PlayGroundFritz;
uses
  PascalParser;

type
  CodeBuilderMethods = static partial class
  private
    method mapSyntaxnodeToOperatorKind(const NodeTyp : TSyntaxNodeType) : CGBinaryOperatorKind;
    begin
      result :=
      case NodeTyp   of
      //case Concat // string concat, can be different than +

        TSyntaxNodeType.ntAdd : CGBinaryOperatorKind.Addition;
        TSyntaxNodeType.ntSub : CGBinaryOperatorKind.Subtraction;
        TSyntaxNodeType.ntMul : CGBinaryOperatorKind.Multiplication;
        TSyntaxNodeType.ntFDiv : CGBinaryOperatorKind.Division;
        TSyntaxNodeType.ntDiv : CGBinaryOperatorKind.LegacyPascalDivision;
        TSyntaxNodeType.ntMod : CGBinaryOperatorKind.Modulus;
        TSyntaxNodeType.ntEqual : CGBinaryOperatorKind.Equals;
        TSyntaxNodeType.ntNotEqual : CGBinaryOperatorKind.NotEquals;
        TSyntaxNodeType.ntLower : CGBinaryOperatorKind.LessThan;
        TSyntaxNodeType.ntLowerEqual : CGBinaryOperatorKind.LessThanOrEquals;
        TSyntaxNodeType.ntGreater : CGBinaryOperatorKind.GreaterThan;
        TSyntaxNodeType.ntGreaterEqual : CGBinaryOperatorKind.GreatThanOrEqual;
        TSyntaxNodeType.ntAnd : CGBinaryOperatorKind.LogicalAnd;
        TSyntaxNodeType.ntOr : CGBinaryOperatorKind.LogicalOr;
        TSyntaxNodeType.ntXor : CGBinaryOperatorKind.LogicalXor;

        TSyntaxNodeType.ntShl : CGBinaryOperatorKind.Shl;
        TSyntaxNodeType.ntShr : CGBinaryOperatorKind.Shr;
        //case BitwiseAnd
        //case BitwiseOr
        //case BitwiseXor
        //case Implies /* Oxygene only */
        TSyntaxNodeType.ntIs : CGBinaryOperatorKind.Is;
        // case IsNot
        TSyntaxNodeType.ntIn : CGBinaryOperatorKind.In;
       // case NotIn /* Oxygene only */

        //case Assign
        //case AssignAddition
        //case AssignSubtraction
        //case AssignMultiplication
        //case AssignDivision

        //case AssignBitwiseAnd
        //case AssignBitwiseOr
        //case AssignBitwiseXor
        //case AssignShl
        //case AssignShr*/
        //case AddEvent
        //case RemoveEvent


        else
          CGBinaryOperatorKind.Multiplication;
        end;
    end;

method mapCallingConvention(const Value: String): CGCallingConventionKind;
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

method mapBinding(const Value: String): CGMemberVirtualityKind;
begin
  case Value.ToLower of
    'abstract' : exit CGMemberVirtualityKind.Abstract;
    'virtual' : exit CGMemberVirtualityKind.Virtual;
    'override' : exit CGMemberVirtualityKind.Override;
    else
      exit CGMemberVirtualityKind.None;
  end;
end;


method mapVisibility(Value: TSyntaxNodeType): CGMemberVisibilityKind;
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
end;


end.