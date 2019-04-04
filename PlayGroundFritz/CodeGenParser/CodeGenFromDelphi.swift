//public class CGSetTypeDefinition : CGTypeDefinition {
	//public var BaseType: CGTypeReference?
//}



public class CGWithStatement: CGStatement {
	public var WithVars: List<CGExpression>

	public init(_ withvars: List<CGExpression>) {
		WithVars = withvars
	}
}


public class CGDotNameExpression: CGExpression {
	public var LeftValue: CGExpression
	public var RightValue: CGExpression
	public var NilSafe: Boolean = false // true to use colon or elvis operator

	public init(_ leftValue: CGExpression, _ rightValue: CGExpression) {
		LeftValue = leftValue
		RightValue = rightValue
	}
}



public class CGOxygeneHelperCodeGenerator : CGOxygeneCodeGenerator {

	public init() {
		super.init()
		}

 internal func generateWithStatement(_ statement: CGWithStatement) {
		Append("with ")

		for i in 0 ..< statement.WithVars.Count {
			if let withvar = statement.WithVars[i] {

				generateExpression(withvar)
				if i < statement.WithVars.Count-1{
					Append(", ")
				}
			}
		}

		Append(" do // ")
	}


 internal func generateDotNameExpression(_ expression: CGDotNameExpression) {
		generateExpression(expression.LeftValue)
		Append(".")
		generateExpression(expression.RightValue)
	}


 public final func WithStatementToString(_ statement: CGWithStatement) -> String {
		 // So we have a currentCode in Base
	// TODO: Remove the Warning
	let s = StatementToString( CGEmptyStatement());
	 Append(s).Clear();
		generateWithStatement(statement);
		return Append("").ToString()
	}

public final func DotExpressionToString(_ expression: CGDotNameExpression) -> String {
		// So we have a currentCode in Base
		let s = StatementToString( CGEmptyStatement());

		Append(s).Clear();
		generateDotNameExpression(expression);
		return Append("").ToString()
	}


}