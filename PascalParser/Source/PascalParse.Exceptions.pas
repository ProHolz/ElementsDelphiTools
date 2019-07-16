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


const
  rsExpected = '"{0}" expected found "{1}"';
  rsEndOfFile = 'end of file';


type
  EParserException = public class(RTLException)
  public
    constructor (aLine, aCol: Integer; const aFileName, Msg: String);
    begin
      inherited constructor(Msg);
      self.FileName := aFileName;
      self.Line := aLine;
      self.Col := aCol;
    end;

    property FileName: String read;
    property Line: Integer read;
    property Col: Integer read;
  end;


  ESyntaxTreeException = public  class(EParserException)
  public
    constructor (Line, Col: Integer; const FileName, Msg: String; aSyntaxTree: TSyntaxNode); reintroduce;
    begin
      inherited (Line, Col, FileName, Msg);
      SyntaxTree := aSyntaxTree;
    end;

    property SyntaxTree: TSyntaxNode read;
  end;

  EIncludeError = public class(Exception);


  ESyntaxError = public class(RTLException)
  private
    fPosXY: TTokenPoint;
  public
    constructor (const Msg: String);
    begin
      fPosXY.X := -1;
      fPosXY.Y := -1;
      inherited constructor(Msg);//, Args);
    end;


    constructor (const Msg: String; const Args: array of Object);
    begin
      fPosXY.X := -1;
      fPosXY.Y := -1;
      inherited constructor(Msg);//, Args);
    end;

    constructor (const Msg: String; aPosXY: TTokenPoint);
    begin
      fPosXY := aPosXY;
      inherited Constructor(String.Format('{0} {1} {2}',  [Msg, fPosXY.X, fPosXY.Y ]));
    end;

    property PosXY: TTokenPoint read fPosXY write fPosXY;
  end;


end.