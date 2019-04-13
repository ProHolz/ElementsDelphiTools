{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License Version
1.1 (the "License"); you may not use this file except in compliance with the
License. You may obtain a copy of the License at
http://www.mozilla.org/NPL/NPL-1_1Final.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: mwPasLex.PAS, released August 17, 1999.

The Initial Developer of the Original Code is Martin Waldenburg
(Martin.Waldenburg@T-Online.de).
Portions created by Martin Waldenburg are Copyright (C) 1998, 1999 Martin
Waldenburg.
All Rights Reserved.

Contributor(s):  James Jacobson, LaKraven Studios Ltd, Roman Yankovsky
(This list is ALPHABETICAL)

Last Modified: mm/dd/yyyy
Current Version: 2.25

Notes: This program is a very fast Pascal tokenizer. I'd like to invite the
Delphi community to develop it further and to create a fully featured Object
Pascal parser.

Modification history:

LaKraven Studios Ltd, January 2015:

- Cleaned up version-specifics up to XE8
- Fixed all warnings & hints

Daniel Rolf between 20010723 and 20020116

Made ready for Delphi 6

platform
deprecated
varargs
local

Known Issues:
-----------------------------------------------------------------------------}
namespace ProHolz.Ast;

interface
type
  TExpressionTools = static class
  private
    method CreateNodeWithParentsPosition(NodeType: TSyntaxNodeType; ParentNode: TSyntaxNode): TSyntaxNode;
  public
    method ExprToReverseNotation(Expr: List<TSyntaxNode>): List<TSyntaxNode>;
    method NodeListToTree(Expr: List<TSyntaxNode>; Root: TSyntaxNode);
    method PrepareExpr(ExprNodes: List<TSyntaxNode>): List<TSyntaxNode>;
    method RawNodeListToTree(RawParentNode: TSyntaxNode; RawNodeList: List<TSyntaxNode>; NewRoot: TSyntaxNode);
  end;

implementation


method IsRoundClose(Typ: TSyntaxNodeType): Boolean; inline;
begin
  Result := Typ = TSyntaxNodeType.ntRoundClose;
end;

method IsRoundOpen(Typ: TSyntaxNodeType): Boolean; inline;
begin
  Result := Typ = TSyntaxNodeType.ntRoundOpen;
end;



method TExpressionTools.ExprToReverseNotation(Expr: List<TSyntaxNode>): List<TSyntaxNode>;
var
Stack: Stack<TSyntaxNode>;
  //Node: TSyntaxNode;
begin
  Result := new List<TSyntaxNode>();
  try
    Stack := new Stack<TSyntaxNode>();
    try
      for Node in Expr do
        if TOperators.IsOpName(Node.Typ) then
        begin
          while (Stack.Count > 0) and TOperators.IsOpName(Stack.Peek.Typ) and
            (((TOperators.Items[Node.Typ].AssocType = TOperatorAssocType.atLeft) and
            (TOperators.Items[Node.Typ].Priority >= TOperators.Items[Stack.Peek.Typ].Priority))
            or
            ((TOperators.Items[Node.Typ].AssocType = TOperatorAssocType.atRight) and
            (TOperators.Items[Node.Typ].Priority > TOperators.Items[Stack.Peek.Typ].Priority)))
            do
            Result.Add(Stack.Pop);

          Stack.Push(Node);
        end
        else if IsRoundOpen(Node.Typ) then
          Stack.Push(Node)
        else if IsRoundClose(Node.Typ) then
        begin
          while not IsRoundOpen(Stack.Peek.Typ) do
            Result.Add(Stack.Pop);

          // RoundOpen and RoundClose nodes are not needed anymore
          Stack.Pop;
          Node := nil;

          if (Stack.Count > 0) and TOperators.IsOpName(Stack.Peek.Typ) then
            Result.Add(Stack.Pop);
        end else
          Result.Add(Node);

      while Stack.Count > 0 do
        Result.Add(Stack.Pop);
    finally
      Stack := nil;
    end;
  except
    Result := nil;
      raise;
  end;
end;

method TExpressionTools.NodeListToTree(Expr: List<TSyntaxNode>; Root: TSyntaxNode);
var
Stack: Stack<TSyntaxNode>;
SecondNode: TSyntaxNode;
begin
  Stack := new Stack<TSyntaxNode>();
  try
    for Node in Expr do
      begin
      if TOperators.IsOpName(Node.Typ) then
        case TOperators.Items[Node.Typ].Kind of
          TOperatorKind.okUnary: Node.AddChild(Stack.Pop);
          TOperatorKind.okBinary:
          begin
            SecondNode := Stack.Pop;
            Node.AddChild(Stack.Pop);
            Node.AddChild(SecondNode);
          end;
        end;
      Stack.Push(Node);
    end;

    Root.AddChild(Stack.Pop);

  //  assert(Stack.Count = 0);
  finally
    Stack := nil;
  end;
end;

method TExpressionTools.PrepareExpr(ExprNodes: List<TSyntaxNode>): List<TSyntaxNode>;
var
PrevNode: TSyntaxNode;
begin
  Result := new List<TSyntaxNode>;
  try
    //Result.Capacity := ExprNodes.Count * 2;

        PrevNode := nil;
        for Node in ExprNodes do
          begin
          if Node.Typ = TSyntaxNodeType.ntCall then
            Continue;

          if assigned(PrevNode) and IsRoundOpen(Node.Typ) then
          begin
            if not TOperators.IsOpName(PrevNode.Typ) and not IsRoundOpen(PrevNode.Typ) then
              Result.Add(CreateNodeWithParentsPosition(TSyntaxNodeType.ntCall, Node.ParentNode));

            if TOperators.IsOpName(PrevNode.Typ)
            and (TOperators.Items[PrevNode.Typ].Kind = TOperatorKind.okUnary)
            and (TOperators.Items[PrevNode.Typ].AssocType = TOperatorAssocType.atLeft)
              then
              Result.Add(CreateNodeWithParentsPosition(TSyntaxNodeType.ntCall, Node.ParentNode));
          end;

          if assigned(PrevNode) and (Node.Typ = TSyntaxNodeType.ntTypeArgs) then
          begin
            if not TOperators.IsOpName(PrevNode.Typ) and (PrevNode.Typ <> TSyntaxNodeType.ntTypeArgs) then
              Result.Add(CreateNodeWithParentsPosition(TSyntaxNodeType.ntGeneric, Node.ParentNode));

            if TOperators.IsOpName(PrevNode.Typ)
            and (TOperators.Items[PrevNode.Typ].Kind = TOperatorKind.okUnary)
            and (TOperators.Items[PrevNode.Typ].AssocType = TOperatorAssocType.atLeft)
              then
              Result.Add(CreateNodeWithParentsPosition(TSyntaxNodeType.ntGeneric, Node.ParentNode));
          end;

          if Node.Typ <> TSyntaxNodeType.ntAlignmentParam then
            Result.Add(Node.Clone);
          PrevNode := Node;
        end;
      except
        Result := nil;
          raise;
      end;
end;

method TExpressionTools.CreateNodeWithParentsPosition(NodeType: TSyntaxNodeType; ParentNode: TSyntaxNode): TSyntaxNode;
begin
  Result := new TSyntaxNode(NodeType);
  Result.AssignPositionFrom(ParentNode);
end;

method TExpressionTools.RawNodeListToTree(RawParentNode: TSyntaxNode; RawNodeList: List<TSyntaxNode>;
NewRoot: TSyntaxNode);
var
PreparedNodeList, ReverseNodeList: List<TSyntaxNode>;
begin
  try
    PreparedNodeList := PrepareExpr(RawNodeList);
    try
      ReverseNodeList := ExprToReverseNotation(PreparedNodeList);
      try
        NodeListToTree(ReverseNodeList, NewRoot);
      finally
        ReverseNodeList := nil;
      end;
    finally
      PreparedNodeList := nil;
    end;
  except
    on E: Exception do
      raise new EParserException(NewRoot.Line, NewRoot.Col, NewRoot.FileName, E.Message);
  end;
end;

end.