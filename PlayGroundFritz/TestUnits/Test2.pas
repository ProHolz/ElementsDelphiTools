namespace ProHolz.CodeGen;
const TestUnit2 = "
{ -----------------------------------------------------------------------------
  Unit Name: cad.Line
  Author:    Fritz
  Date:      17-Dez-2005
  Purpose:  Linie mit 2 Punkten 2d und 3d
  History:
  ----------------------------------------------------------------------------- }

{$I proholz.inc}
unit cad.Line;

interface

uses
   System.sysutils,
   System.classes,
   System.Types,
   System.Math,
   cad.Objects,
   cad.Base,
   cad.Types.Calculations,
   ci2dc.interfaces,
   cad.Xml,
   cad.Types,
   Gui.Interfaces.CadCanvas,
   cad.Searchpoint,
   cad.VecSearch,
   cad.DistList,
   Display.interfaces,
   cad.interfaces.Base;
//

type
  // Interface
  Itest = Interface
   ['{E277B1D4-88D3-4D1B-8541-39939F683D87}']
   function GetCharProp(index: Integer; index2 : Integer): Char;
   function GetColor: TColor; stdcall;
   function GetIntProp(Index: Integer): Integer;
   procedure SetCharProp(index: Integer; index2: Integer; const Value: Char);
   procedure SetColor(const Value: TColor);
   procedure SetIntProp(Index: Integer; const Value: Integer);
   property CharProp[index: Integer; Index2 : integer]: Char read GetCharProp write SetCharProp;
   property Color: TColor read GetColor write SetColor;
   property IntProp[Index: Integer]: Integer read GetIntProp write SetIntProp; default;

  end;
// Alias
CadColor = System.UiTypes.Tcolor;

type
//  TLine = class;

   TLine = class(TcadBase, IInterface)
   private
      fstyle: eCadPenstyle;
      fdisp: IDispBase;

   strict protected
      procedure AssignFrom(aobject: tcadObject); override;
   protected
      procedure readxml(node: TXmlNode); override;
      procedure Storexml(node: TXmlNode); override;

   public

      k: tVecLine;

    // Konstruktoren Load save
      constructor Create(V: tVecLine; aStyle: Integer = lpsSolid);

      constructor CreateVecs(p1, p2: Tvec3d; aStyle: Integer = lpsSolid; acol: Integer = 15);
      destructor Destroy; override;

       constructor loadFromStream(const s: tstream);
      procedure savetoStream(const s: tstream);


    // Darstellung
      procedure Draw(const aCadCanvas: IcadCanvas); override;
      procedure Setcol(const c: tColorRange); override;
    // Suchen
      procedure Insert_in_Liste(w: word; wo: Tvec3d; P: TDistancelist); override; // Objekt suchen
      procedure Write_in_Searchlist(w: word; TP: Tvec3d; aList: TvecSearchList; Abstand: Double); override;

    // Abfragen
      function canDelete: Boolean; override;
      procedure calcAbstand(mode: Integer; w: Tvec3d); override; // Berechnet den Abstand zu W
      procedure Getmax(var rx, ry, lx, ly: Double); override;
      procedure maximal(var afirst: Boolean; var ulv, orv: Tvec3d); override; // Liefert Die BoundingBox des Objectes als 2 Vectoren

      function getwinkel(w, n: Double): string;

    // Bearbeitungen
      procedure doStretch(T: tVecLine; abst: Double; const stretch: Boolean); override;
      function SplitTwoPoints(p1, p2: Tvec3d): TcadBase; override;

      procedure Rotate_Around_Point(const Drehpunkt: Tvec3d; Winkel: Double); override;

      procedure Rotate_Around_Axis(const aDir: TDirection; Value: TDegrees); override;
      procedure SelectMove(P: Tvec3d); override;

      procedure doMoveDist(P: Tvec3d); override;

      function inerhalb(A: Double): Boolean;

      procedure Schreibe_in_Clipping(Bereich: tVecLine; Drehung: Double; const s: tstream); override;
      procedure Factor(m: Double); override;

      procedure write_to_DxfStream(const s: tstream); override;

      procedure WriteCw2d(const o2dc: i2dcInterface); override;

      function getnormale: Tvec3d;

      function Getname: string; override;

      procedure Write_Points_inList(tl: TSearchPointList; wo: Tvec3d); override;

      function Laenge: Double;
    // Displaylist
      procedure AddToDisplayList(const Display: IDisplayListAdder); override;
      procedure setistVisible(const Value: Boolean); override;

      procedure setZvalues(const Value: Double);

      function sortdrawtype: Integer; override;

      function StartPoint: Tvec3d;
      function EndPoint: Tvec3d;
   end;


   tCadGuiHelperLine = class(Tline)
      public
         constructor Create(V: tVecLine; aStyle: Integer = lpsSolid);
         function HasFirstPoint(var p: Tvec3d): Boolean; override;
      published
         function getMovePlane(var Value : TcadPlane) : boolean; override;

   end;



implementation

uses
  System.Generics.Collections,
  cad.Xml.helper,
  cad.consts,
  cad.Colors,
  cad.Types.Clipping,
  cad.Types.Base2d,
  cad.Types.Math,
  Gui.Vclwrapper,
  Gui,
  stringresourcen,
  classesHelper;

constructor TLine.Create(V: tVecLine; aStyle: Integer = lpsSolid);
begin
   inherited Create;
   AdMode(ofLoeschmode);
   AdMode(ofVecSearch);
   AdMode(ofVerlaengern);
   AdMode(ofBruch);
   AdMode(ofVerschieb);
   AdMode(ofkopier);
   AdMode(ofDrehen);
   k := V;
   k.pnextLine := nil;
   col := k.col;
   case aStyle of
      lpsSolid: fstyle := eCadPenstyle.Solid;
      lpsDot: fstyle := eCadPenstyle.Dot;
   end;

end;

procedure TLine.Draw(const aCadCanvas: IcadCanvas);
begin
   aCadCanvas.Pen.Style := fstyle;

   if isselected then
      begin
         aCadCanvas.Pen.Color := Global.SelectColor;
         aCadCanvas.Pen.Width := 3;
      end
   else
      begin
         aCadCanvas.Pen.Color := CadColor.colarray[col].Test;
         if aCadCanvas.CanvasType = eCanvasType.screen then
         aCadCanvas.Pen.Width := 1
         else
         begin
          if fstyle = eCadPenstyle.Solid then
            aCadCanvas.Pen.Width := Global.Linienstaerke_druck
            else
            aCadCanvas.Pen.Width := 1;
         end;
      end;
   aCadCanvas.Draw_Line(k.p1, k.p2)
end;

procedure TLine.Setcol(const c: tColorRange);
begin
   if c = 0 then
      inherited Setcol(1)
   else
      inherited Setcol(c);
   k.col := col;
end;

procedure TLine.Write_in_Searchlist(w: word; TP: Tvec3d; aList: TvecSearchList; Abstand: Double);
var
   r: Double;
   k2, k3, woclip: tVecLine;
   tv: Tvec3d;
   lIdent: eAxType;
begin
   if (selectMode and w = w) and (not isInMove) then
      begin
         k2.clear;
         aList.View.calcpoint(k2.p1, k.p1);
         aList.View.calcpoint(k2.p2, k.p2);

         tv.x := Abstand;
         tv.y := Abstand;
         tv.z := 0;
         TP.z := 0;

         vecadd(woclip.p2, tv, TP);
         vecmul(tv, - 1, tv);
         vecadd(woclip.p1, tv, TP);

         k3 := k2;
         if Mach_ClipVec(k3, woclip, 0, k2) then

            if distance(k.p1, k.p2) > 0 then
               if not issamenormgegen(normale_von(k2.p1, k2.p2), Global.sichtnormale) then
                  begin
                     k2.p1.z := 0;
                     k2.p2.z := 0;
                     r := abstand_vec(TP, k2, lIdent);
                     Ident := lIdent;
                     if r <= Abstand then
                        aList.Add(TvecSearch.Create(r, k, self));
                  end;

      end;
end;

procedure TLine.doStretch(T: tVecLine; abst: Double; const stretch: Boolean);

var
   k2: tVecLine;
   rad, grad: Double;

begin
   k2 := k;
   if abst <> 0 then
      begin
// with k2 do
         gebe_RadGrad(k2.p1, k2.p2, rad, grad);
         T := k2;
// with T do
         begin
            drehe_Vektor(T.p1, T.p2, - grad);
            if Ident = Ax.onStart then
               begin
                  T.p1.x := T.p1.x - abst;
                  T.p2 := T.p1;
                  T.p2.y := T.p2.y + abst;
               end
            else
               begin
                  T.p2.x := T.p2.x + abst;
                  T.p1 := T.p2;
                  T.p1.y := T.p1.y + abst;
               end;
            drehe_Vektor(T.p1, T.p2, grad);
         end;
      end;

   if not issamenormgegen(getnormale, normale_von(T.p1, T.p2)) then
      begin
         if Ident = Ax.onStart then
            verlaengern_VectorenP1(k, T)
         else
            verlaengern_VectorenP2(k, T);
      end;

end;

function TLine.SplitTwoPoints(p1, p2: Tvec3d): TcadBase;
var
   lp: TcadPlane;
   A: TArray<Double>;
   d: Double;

begin
   Result := nil;
   if not SameValue(Laenge, 0) then
      begin
         lp.clear;
         lp.Norm := getnormale;
         lp.d := - lp.distance(k.p1);
         setlength(A, 0);
         d := lp.distance(p1);
         if (d > 0) and (d < Laenge) then
            A := A + [d];
         d := lp.distance(p2);
         if (d > 0) and (d < Laenge) then
            A := A + [d];
         A := A + [Laenge];
         TArray.Sort<Double, Integer>(A);
         if length(A) > 1 then
            begin
               k.p2 := k.p1 + lp.Norm * A[0,3];
               if length(A) > 2 then
                  begin
                     p1 := k.p1 + lp.Norm * A[1];
                     p2 := k.p1 + lp.Norm * A[2];
                     Result := TLine.CreateVecs(p1, p2);
                  end;
            end;
      end;
end;

function TLine.canDelete: Boolean;
begin
  try
   canDelete := PhGui.Screen.Frage(vecLoesche);
  except
  end;
end;

procedure TLine.Getmax(var rx, ry, lx, ly: Double);

var
   L: tVecLine;

begin
   L := k;

   if  PhGui.MapView.DrehungX <> 0 then
      drehe_Vektor(L.p1, L.p2, PhGui.MapView.DrehungX);
   if PhGui.MapView.DrehungZ <> 0 then
      Drehe_VektorZ(L.p1, L.p2, PhGui.MapView.DrehungZ);

   rx := min(L.p1.x, rx);
   lx := max(L.p2.x, lx);
   ry := min(L.p1.y, ry);
   ly := max(L.p2.y, ly);

end;

procedure TLine.Rotate_Around_Point(const Drehpunkt: Tvec3d; Winkel: Double);

begin
   differenz(Drehpunkt, k.p1);
   differenz(Drehpunkt, k.p2);
   drehe_Vektor(k.p1, k.p2, Winkel);
   addiere(Drehpunkt, k.p1);
   addiere(Drehpunkt, k.p2);
end;

function TLine.inerhalb(A: Double): Boolean;
begin
// with k do
   begin
      inerhalb := ((A >= k.p1.x) and (A < k.p2.x)) or ((A <= k.p1.x) and (A > k.p2.x));
   end;
end;

procedure TLine.doMoveDist(P: Tvec3d);
begin
// with k do
// begin
   addiere(P, k.p1);
   addiere(P, k.p2);
// end;
end;

procedure TLine.Insert_in_Liste(w: word; wo: Tvec3d; P: TDistancelist);
var
   r: Double;
   lIdent: eAxType;
begin
   if (selectMode and w = w) and not isInMove then // Können wir und werden wir auch nicht verschoben ?
      begin
         r := abstand_vec(wo, k, lIdent);
         Ident := lIdent;
         if Ident = Ax.onStart then

            fLastSelPoint := k.p1
         else
            fLastSelPoint := k.p2;

         if Assigned(P) then
            if r < PhGui.ViewSearch.searchViewRange then
               P.insert(r, self);
      end;
end;

procedure TLine.Schreibe_in_Clipping(Bereich: tVecLine; Drehung: Double; const s: tstream);
var
   k2: tVecLine;
   P: TLine;
begin
   if Mach_ClipVec(k, Bereich, Drehung, k2) then
      begin
         P := TLine.Create(k2);
         P.Setcol(col);
         P.savetoStream(s);
         P.Free;
      end;
end;

procedure TLine.Factor(m: Double);
begin
// with k do
// begin
   vecmul(k.p1, m, k.p1);
   vecmul(k.p2, m, k.p2);
// end;
end;

function TLine.getnormale: Tvec3d;
begin
   vecsub(Result, k.p2, k.p1);
   Norm(Result, Result);
end;

procedure TLine.WriteCw2d(const o2dc: i2dcInterface);
var
   p1, p2: Tvec3d;
begin
   if Global.d3 then
      begin
         p1 := k.p1;
         p2 := k.p2;
         PhGui.ViewSearch.drehePunkt(p1);
         PhGui.ViewSearch.drehePunkt(p2);
         o2dc.add_line(0, col, 1, 0, p1, p2);
      end
   else
      begin
         case fstyle of
            eCadPenstyle.Solid: o2dc.add_line(0, col, 1, 0, k.p1, k.p2);
            eCadPenstyle.Dot: o2dc.add_line(0, col, 1, 1, k.p1, k.p2);
            eCadPenstyle.DashDotDot: o2dc.add_line(0, col, 1, 2, k.p1, k.p2);
         else
            o2dc.add_line(0, col, 1, 0, k.p1, k.p2);
         end;

      end;
end;

function TLine.Getname: string;
begin
   Result := 'Linie';
end;

procedure TLine.AssignFrom(aobject: tcadObject);
begin
   inherited;
   if Assigned(aobject) and (aobject is TLine) then
      begin
         k := TLine(aobject).k;
         fstyle := TLine(aobject).fstyle;
      end;
end;

procedure TLine.maximal(var afirst: Boolean; var ulv, orv: Tvec3d);
var
   ap: tpoint;
begin
   if isVisible then
      begin

         PhGui.ViewSearch.Fuelle_Point(ap, k.p1);
         PHGui.MapView.Map_InsertPoint(ap);
         PhGui.ViewSearch.Fuelle_Point(ap, k.p2);
         PHGui.MapView.Map_InsertPoint(ap);

         if afirst then
            begin
               afirst := False;
               ulv := Tvec3d.getMinValues(k.p1, k.p2);
               orv := Tvec3d.getMaxValues(k.p1, k.p2);

            end
         else
            begin
               ulv := Tvec3d.getMinValues(k.p1, ulv);
               ulv := Tvec3d.getMinValues(k.p2, ulv);
               orv := Tvec3d.getMaxValues(k.p1, orv);
               orv := Tvec3d.getMaxValues(k.p2, orv);
            end;
      end;
end;

procedure TLine.Write_Points_inList(tl: TSearchPointList; wo: Tvec3d);
var
   p3, p4: Tvec3d;
   a1, a2: TSearchDistance;
begin
   if isVisible and (not isInMove) then
      begin
         tl.View.calcpoint(p3, k.p1);
         tl.View.calcpoint(p4, k.p2);
         p3.z := 0;
         p4.z := 0;
         wo.z := 0;
         a1 := distance(p3, wo);
         a2 := distance(p4, wo);
         tl.AddSearch(p3, k.p1, self, a1);
         tl.AddSearch(p4, k.p2, self, a2);
      end;
end;

procedure TLine.write_to_DxfStream(const s: tstream);
var
   ch: AnsiChar;
   k2: tdxfVecLine;
begin
   ch := 'L';
   s.write(ch, SizeOf(ch));
   if not Global.d3 then
      begin
         k2 := tdxfVecLine(k);
         k2.p1.z := 0;
         k2.p2.z := 0;
         s.write(k2, SizeOf(k2));
      end
   else
      begin
         k2 := tdxfVecLine(k);
         PhGui.ViewSearch.drehePunkt(k2.p1);
         PhGui.ViewSearch.drehePunkt(k2.p2);
         k2.p1.z := 0;
         k2.p2.z := 0;
         s.write(k2, SizeOf(k2));
      end;
end;

procedure TLine.calcAbstand(mode: Integer; w: Tvec3d);
var
   r: Double;
   i: eAxType;
   k2, k3, woclip: tVecLine;
   tv: Tvec3d;
begin
   inherited;
   PhGui.ViewSearch.calcpoint(k2.p1, k.p1);
   PhGui.ViewSearch.calcpoint(k2.p2, k.p2);

   tv.x := PhGui.ViewSearch.ViewPixel;
   tv.y := PhGui.ViewSearch.ViewPixel;
   tv.z := 0;
   w.z := 0;

   vecadd(woclip.p2, tv, w);
   vecmul(tv, - 1, tv);
   vecadd(woclip.p1, tv, w);

   k3 := k2;
   if Mach_ClipVec(k3, woclip, 0, k2) then
      if distance(k.p1, k.p2) > 0 then
         if not issamenormgegen(normale_von(k2.p1, k2.p2), Global.sichtnormale) then
            begin
               k2.p1.z := 0;
               k2.p2.z := 0;
               r := abstand_vec(w, k2, i);
               if r <= PhGui.ViewSearch.ViewPixel then
                  theAbstand := r;
            end;
end;

function TLine.Laenge: Double;
begin
   Result := distance(k.p1, k.p2);
end;

constructor TLine.CreateVecs(p1, p2: Tvec3d; aStyle: Integer = lpsSolid; acol: Integer = 15);
var
   test: tVecLine;
begin
   test.clear;
   test.p1 := p1;
   test.p2 := p2;
   test.col := 15;
   Create(test, aStyle);
   Setcol(acol);
end;

function TLine.getwinkel(w, n: Double): string;
var
   s, T: string;
   L: tVecLine;
   rad, grad, help: Double;

begin
   Result := '';
   s := '';
   L := k;
   drehe_Vektor(L.p1, L.p2, - w);
// with L do
   gebe_RadGrad(L.p1, L.p2, rad, grad);
   grad := grad * 10;
   grad := round(grad);
   grad := grad / 10;
   if grad <> 0 then
      if grad <> 90 then
         if grad <> 180 then
            if grad <> 270 then
               if grad <> 360 then
                  begin
                     if grad > 270 then
                        begin
                           grad := grad - 270;
                           grad := 90 - grad;
                        end;
                     if grad > 180 then
                        grad := grad - 180;
                     if grad > 90 then
                        begin
                           grad := grad - 90;
                           grad := 90 - grad;
                        end;
                     help := TDeg.Tan(grad) / TDeg.Cos(n);
                     help := TDeg.ArcTan(help);
                     s := Format('%4.1f', [grad]);
              // str(grad, 4, 1, s);
                     s := dvGW + s;
              // str(help, 4, 1, T);
                     T := Format('%4.1f', [help]);
                     T := dvRW + T;
                     s := s + '  ' + T;
                  end;
   Result := s;
end;

procedure TLine.savetoStream(const s: tstream);
begin
   s.WriteInteger(col);
   s.WriteInteger(Ord(fstyle));
   s.write(k.p1, SizeOf(k.p1));
   s.write(k.p2, SizeOf(k.p2));
end;

procedure TLine.Rotate_Around_Axis(const aDir: TDirection; Value: TDegrees);
begin
   k.p1 := Rotate_um_Achse(k.p1, Tvec3d(aDir), Value);
   k.p2 := Rotate_um_Achse(k.p2, Tvec3d(aDir), Value);
end;

procedure TLine.SelectMove(P: Tvec3d);
begin
   doMoveDist(P);
end;

procedure TLine.readxml(node: TXmlNode);
var
   lstyle: Integer;
begin
   inherited;
   fstyle := eCadPenstyle.Solid;
   lstyle := node.ReadAttributeInteger('psSTYLE');

   case lstyle of
      lpsSolid: fstyle := eCadPenstyle.Solid;
      lpsDot: fstyle := eCadPenstyle.Dot;
   end;

  // Fix for old Data
   if node.HasAttribute('STYLE') then
      if node.ReadAttributeInteger('STYLE') > 1 then
         fstyle := eCadPenstyle.Dot;

   readcwTVec(node, 'P1', k.p1);
   readcwTVec(node, 'P2', k.p2);
   k.col := col;
end;

procedure TLine.Storexml(node: TXmlNode);
begin
   inherited;
   node.attributeadd('psSTYLE', Ord(fstyle));

   writecwTVec(node, 'P1', k.p1);
   writecwTVec(node, 'P2', k.p2);
end;

constructor TLine.loadFromStream(const s: tstream);
begin
   inherited Create;
   AdMode(ofLoeschmode);
   AdMode(ofVecSearch);
   AdMode(ofVerlaengern);
   AdMode(ofBruch);
   AdMode(ofVerschieb);
   AdMode(ofkopier);
   AdMode(ofDrehen);
   k.clear;
   col := s.readInteger;
   fstyle := eCadPenstyle.Solid;
   if s.readInteger > 0 then
      fstyle := eCadPenstyle.Dot;
   k.col := col;
   s.read(k.p1, SizeOf(k.p1));
   s.read(k.p2, SizeOf(k.p2));

end;

procedure TLine.AddToDisplayList(const Display: IDisplayListAdder);
begin
   if fdisp <> nil then
      fdisp.NotifyOwner(fdisp, eDispNotify.Removed);

   fdisp := Display.addLine(k.p1, k.p2, CadColor.colarray[k.col], eDisplineType.Normal);
end;

destructor TLine.Destroy;
begin
   if fdisp <> nil then
      begin
         fdisp.NotifyOwner(fdisp, eDispNotify.Removed);
         fdisp := nil;
      end;
   inherited;
end;

procedure TLine.setistVisible(const Value: Boolean);
begin
   inherited;
   if Assigned(fdisp) then
      fdisp.visible := Value;
end;

function TLine.sortdrawtype: Integer;
begin
   Result := 1;
end;

procedure TLine.setZvalues(const Value: Double);
begin
   k.p1.z := Value;
   k.p2.z := Value;
end;

function TLine.StartPoint: Tvec3d;
begin
   Result := k.p1;
end;

function TLine.EndPoint: Tvec3d;
begin
   Result := k.p2;
end;

{ tCadGuiHelperLine }

constructor tCadGuiHelperLine.Create(V: tVecLine; aStyle: Integer);
begin
   inherited create(V, aStyle);
end;

function tCadGuiHelperLine.HasFirstPoint(var p: Tvec3d): Boolean;
begin
   p := k.p2;
   result := true;
end;

function tCadGuiHelperLine.getMovePlane(var Value: TcadPlane): boolean;
var lp1, lp2, lp3 : Tvec3d;
begin
  result := k.getLength > 0;
  if result  then
  begin
   lp1 := k.p1;
   lp2 := k.p2;
   lp1.z := 0;
   lp2.z := 0;
   lp3 := lp2+Znorm;
   Value := PlaneFromPoints(lp1, lp2, lp3);
  end;
end;

end.

";

end.