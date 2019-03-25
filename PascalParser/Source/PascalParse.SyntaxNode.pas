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
  TSyntaxNode =  public class(Object)
  private
    method GetHasChildren: Boolean;
    method GetHasAttributes: Boolean;
  protected
    FAttributes: Dictionary<TAttributeName, String>;
    FChildNodes: List<TSyntaxNode>;
    method NewNode: TSyntaxNode; virtual;
    method InitFields;

  public
    constructor();
    constructor(aTyp: TSyntaxNodeType); virtual;

    class method create(aTyp: TSyntaxNodeType) : TSyntaxNode;

    method Clone: TSyntaxNode; virtual;
    method AssignPositionFrom(const Node: TSyntaxNode);
 // Attributes
    method GetAttribute(const Key: TAttributeName): not nullable String;
    method HasAttribute(const Key: TAttributeName): Boolean;
    method SetAttribute(const Key: TAttributeName; const  Value: not nullable String);
    method ClearAttributes;

// ShortCuts for Attributes
    method AttribName : not nullable String; inline;
    method AttribKind : not nullable String; inline;
    method AttribType : not nullable String; inline;


// Childs
    method AddChild(Node: TSyntaxNode): TSyntaxNode;
    method AddChild(aTyp: TSyntaxNodeType): TSyntaxNode;
    method DeleteChild(Node: TSyntaxNode);
    method ExtractChild(Node: TSyntaxNode) : TSyntaxNode;
    method ChildCount : Integer;

    method FindNode(aTyp: TSyntaxNodeType): TSyntaxNode;
    method FindAllNodes(aTyp: TSyntaxNodeType): Array of TSyntaxNode;
    method FindChilds(aTyp: TSyntaxNodeType): Array of TSyntaxNode;

    property Typ: TSyntaxNodeType read  protected write;

    property Attributes: Dictionary<TAttributeName, String> read FAttributes;
    property ChildNodes: List<TSyntaxNode> read FChildNodes;
    property HasAttributes: Boolean read GetHasAttributes;
    property HasChildren: Boolean read GetHasChildren;

    property ParentNode: TSyntaxNode read ;

    property Col: Integer read  write ;
    property Line: Integer read  write ;
    property FileName: String read  write ;
  end;



implementation

{ TSyntaxNode }

constructor TSyntaxNode();
begin
  inherited constructor();
  InitFields;
end;


constructor TSyntaxNode(aTyp: TSyntaxNodeType);
begin
  constructor();
  Typ := aTyp;
end;


class method TSyntaxNode.create(aTyp: TSyntaxNodeType) : TSyntaxNode;
begin
  result := new TSyntaxNode(aTyp)
end;

method TSyntaxNode.NewNode: TSyntaxNode; {virtual;}
begin
  result := new TSyntaxNode(Typ);
end;


// Instance Methods
method TSyntaxNode.SetAttribute(const Key: TAttributeName; const Value: not nullable string);
begin
  if not FAttributes.ContainsKey(Key)  then
    FAttributes.Add(Key, Value)
  else
    FAttributes[Key] := Value;
end;


method TSyntaxNode.AddChild(Node: TSyntaxNode): TSyntaxNode;
require
  Node <> nil;
  begin
    FChildNodes.Add(Node);
    Node.ParentNode := Self;
    Result := Node;
  end;

  method TSyntaxNode.AddChild(aTyp: TSyntaxNodeType): TSyntaxNode;
  begin
    Result := AddChild(new TSyntaxNode(aTyp));
  end;

  method TSyntaxNode.InitFields;
  begin
    FAttributes := new Dictionary<TAttributeName, String>();
    FChildNodes:= new List<TSyntaxNode>();
  end;

  method TSyntaxNode.Clone: TSyntaxNode;

  begin
    result := NewNode;
    for item in FChildNodes  do
      result.AddChild(item.Clone);
    result.FAttributes.Add(FAttributes);
    result.AssignPositionFrom(Self);

  end;


  method TSyntaxNode.ExtractChild(Node: TSyntaxNode) : TSyntaxNode;
  begin
    if FChildNodes.Contains(Node) then
      FChildNodes.Remove(Node);
      result := Node;
  end;

  method TSyntaxNode.DeleteChild(Node: TSyntaxNode);
  begin
    ExtractChild(Node);
  end;


  method TSyntaxNode.FindNode(aTyp: TSyntaxNodeType): TSyntaxNode;
  begin
    exit  FChildNodes.FirstOrDefault((Item)->(Item.Typ = aTyp));
  end;

  method TSyntaxNode.FindAllNodes(aTyp: TSyntaxNodeType): Array of TSyntaxNode;
  begin
    var ltemp := new List<TSyntaxNode>();
    for lNode in ChildNodes do
      begin
      if lNode.Typ = aTyp then
        ltemp.Add(lNode);
      ltemp.Add(lNode.FindAllNodes(aTyp));
    end;
    result := ltemp.ToArray;
  end;

  method TSyntaxNode.FindChilds(aTyp: TSyntaxNodeType): Array of TSyntaxNode;
  begin
    var ltemp := new List<TSyntaxNode>();
    for each lNode in ChildNodes.Where(Item->Item.Typ = aTyp) do
     ltemp.Add(lNode);
    result := ltemp.ToArray;
  end;


  method TSyntaxNode.GetAttribute(const Key: TAttributeName): not nullable string;
  begin
    if FAttributes.ContainsKey(Key) then
      exit FAttributes.Item[Key] as not nullable
    else
      exit '';
  end;

  method TSyntaxNode.GetHasAttributes: Boolean;
  begin
    Result := FAttributes.Count > 0;
  end;

  method TSyntaxNode.GetHasChildren: Boolean;
  begin
    Result := FChildNodes.Count > 0;
  end;

  method TSyntaxNode.HasAttribute(const Key: TAttributeName): Boolean;
  begin
    exit FAttributes.ContainsKey(Key)
  end;

  method TSyntaxNode.ClearAttributes;
  begin
    FAttributes.RemoveAll;
  end;

  method TSyntaxNode.AssignPositionFrom(const Node: TSyntaxNode);
  begin
    Col := Node.Col;
    Line := Node.Line;
    FileName := Node.FileName;
  end;

  method TSyntaxNode.AttribName: not nullable String;
  begin
    result := GetAttribute(TAttributeName.anName);
  end;

  method TSyntaxNode.AttribKind: not nullable String;
  begin
    result := GetAttribute(TAttributeName.anKind);
  end;

  method TSyntaxNode.AttribType: not nullable String;
  begin
    result := GetAttribute(TAttributeName.anType);
  end;

method TSyntaxNode.ChildCount: Integer;
begin
 result := ChildNodes.Count;
end;


end.