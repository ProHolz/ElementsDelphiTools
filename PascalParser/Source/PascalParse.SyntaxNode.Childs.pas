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
namespace PascalParser;
type
  TCompoundSyntaxNode = public class(TSyntaxNode)
  public
    method NewNode: TSyntaxNode; override;
    begin
      result := new TCompoundSyntaxNode(Typ);
    end;

   method Clone: TSyntaxNode; override;
   begin
     Result := inherited;
     TCompoundSyntaxNode(Result).EndLine := Self.EndLine;
     TCompoundSyntaxNode(Result).EndCol := Self.EndCol;
   end;

   property EndCol: Integer read  write ;
   property EndLine: Integer read  write ;
 end;

  TValuedSyntaxNode = public class(TSyntaxNode)

  public
    method NewNode: TSyntaxNode; override;
    begin
      result := new TValuedSyntaxNode(Typ);
    end;

    method Clone: TSyntaxNode; override;
    begin
      Result := inherited;
      TValuedSyntaxNode(Result).Value := Self.Value;
    end;
    property Value: not nullable String  := '';
  end;


  TCommentNode = public class(TSyntaxNode)
  public

    method NewNode: TSyntaxNode; override;
    begin
     result := new TCommentNode(Typ);
    end;

    method Clone: TSyntaxNode; override;
    begin
      Result := inherited;
      TCommentNode(Result).Text := Self.Text;
    end;

    property Text: String read  write ;
  end;


end.