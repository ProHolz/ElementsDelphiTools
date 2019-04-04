public extension RemObjects.Elements.RTL.String {
	public func AsComment() -> CGCommentStatement {
		return CGCommentStatement(self)
	}
	public func AsBuilderComment() -> CGCommentStatement {
		return CGCommentStatement("Proholz.CodeBuilder:  \(self)")
	}
}

public extension RemObjects.Elements.System.String {
	public func AsComment() -> CGCommentStatement {
		return CGCommentStatement(self)
	}
	 public func AsBuilderComment() -> CGCommentStatement {
		return CGCommentStatement("Proholz.CodeBuilder:  \(self)")
	}
}