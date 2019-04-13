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
  TOperatorKind = (okUnary, okBinary);
  TOperatorAssocType = (atLeft, atRight);

  TOperatorInfo = record
    Typ: TSyntaxNodeType;
    Priority: Byte;
    Kind: TOperatorKind;
    AssocType: TOperatorAssocType;
    class method Create(aTyp: TSyntaxNodeType) : TOperatorInfo;
    begin
      result := new TOperatorInfo();
      result.Typ := aTyp;

    end;
  end;


  TOperators = static class
    private
    method GetItem(Typ: TSyntaxNodeType): TOperatorInfo;
  public
    method IsOpName(Typ: TSyntaxNodeType): Boolean;
    property Items[Typ: TSyntaxNodeType]: TOperatorInfo read GetItem; default;
  end;

implementation

  var
    OperatorsInfo: array of TOperatorInfo :=

    [new TOperatorInfo(Typ := TSyntaxNodeType.ntAddr, Priority:= 1, Kind:= TOperatorKind.okUnary, AssocType:= TOperatorAssocType.atRight),
     new TOperatorInfo(Typ := TSyntaxNodeType.ntDeref,        Priority:= 1, Kind:= TOperatorKind.okUnary,  AssocType:= TOperatorAssocType.atLeft),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntGeneric,      Priority:= 1, Kind:= TOperatorKind.okBinary, AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntIndexed,      Priority:= 1, Kind:= TOperatorKind.okUnary,  AssocType:= TOperatorAssocType.atLeft),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntDot,          Priority:= 2, Kind:= TOperatorKind.okBinary, AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntCall,         Priority:= 3, Kind:= TOperatorKind.okBinary, AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntUnaryMinus,   Priority:= 5, Kind:= TOperatorKind.okUnary,  AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntNot,          Priority:= 6, Kind:= TOperatorKind.okUnary,  AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntMul,          Priority:= 7, Kind:= TOperatorKind.okBinary, AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntFDiv,         Priority:= 7, Kind:= TOperatorKind.okBinary, AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntDiv,          Priority:= 7, Kind:= TOperatorKind.okBinary, AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntMod,          Priority:= 7, Kind:= TOperatorKind.okBinary, AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntAnd,          Priority:= 7, Kind:= TOperatorKind.okBinary, AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntShl,          Priority:= 7, Kind:= TOperatorKind.okBinary, AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntShr,          Priority:= 7, Kind:= TOperatorKind.okBinary, AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntAs,           Priority:= 7, Kind:= TOperatorKind.okBinary, AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntAdd,          Priority:= 8, Kind:= TOperatorKind.okBinary, AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntSub,          Priority:= 8, Kind:= TOperatorKind.okBinary, AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntOr,           Priority:= 8, Kind:= TOperatorKind.okBinary, AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntXor,          Priority:= 8, Kind:= TOperatorKind.okBinary, AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntEqual,        Priority:= 9, Kind:= TOperatorKind.okBinary, AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntNotEqual,     Priority:= 9, Kind:= TOperatorKind.okBinary, AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntLower,        Priority:= 9, Kind:= TOperatorKind.okBinary, AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntGreater,      Priority:= 9, Kind:= TOperatorKind.okBinary, AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntLowerEqual,   Priority:= 9, Kind:= TOperatorKind.okBinary, AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntGreaterEqual, Priority:= 9, Kind:= TOperatorKind.okBinary, AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntIn,           Priority:= 9, Kind:= TOperatorKind.okBinary, AssocType:= TOperatorAssocType.atRight),
       new TOperatorInfo(Typ := TSyntaxNodeType.ntIs,           Priority:= 9, Kind:= TOperatorKind.okBinary, AssocType:= TOperatorAssocType.atRight)
    ]; readonly;



{ TOperators }

   method TOperators.GetItem(Typ: TSyntaxNodeType): TOperatorInfo;
    var
    i: Integer;
    begin
      for i := 0 to high(OperatorsInfo) do
        if OperatorsInfo[i].Typ = Typ then
          Exit(OperatorsInfo[i]);
    end;

   method TOperators.IsOpName(Typ: TSyntaxNodeType): Boolean;
    var
    i: Integer;
    begin
      for i := 0 to high(OperatorsInfo) do
        if OperatorsInfo[i].Typ = Typ then
          Exit(True);
      Result := False;
    end;

end.