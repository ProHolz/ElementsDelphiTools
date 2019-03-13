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

  end;

end.