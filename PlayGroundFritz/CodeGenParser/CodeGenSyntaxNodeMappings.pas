namespace ProHolz.CodeGen;
uses
  ProHolz.Ast;

type
  CodeBuilderMethods = static partial class
  private
    method mapSyntaxnodeToOperatorKind(const node : TSyntaxNodeType) : CGBinaryOperatorKind;
    begin
      result :=
      case node   of
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

method mapCallingConvention(const value: String): CGCallingConventionKind;
begin
  case value.ToLower of
    'stdcall' : exit CGCallingConventionKind.StdCall;
    'cdecl' : exit CGCallingConventionKind.CDecl;
    'pascal': exit CGCallingConventionKind.Pascal;
    'safecall': exit CGCallingConventionKind.SafeCall;
    else
      exit CGCallingConventionKind.Register;
  end;
end;

method mapBinding(const value: String): CGMemberVirtualityKind;
begin
  case value.ToLower of
    'abstract' : exit CGMemberVirtualityKind.Abstract;
    'virtual' : exit CGMemberVirtualityKind.Virtual;
    'override' : exit CGMemberVirtualityKind.Override;
    else
      exit CGMemberVirtualityKind.None;
  end;
end;


method mapVisibility(value: TSyntaxNodeType): CGMemberVisibilityKind;
begin
  case value of
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