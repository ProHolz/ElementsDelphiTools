namespace ProHolz.CodeGen;

interface
uses RemObjects.Elements.RTL;

type
  ElementsConverter = static class
  private
    method BuildElementsFile(const Source: String; const Dest: String): Boolean;

  public
    method BuildSameName(const Source : String) : Boolean;
  end;

implementation
uses
  ProHolz.Ast,
  ProHolz.CodeGen;


  method ElementsConverter.BuildElementsFile(const Source : String; const Dest : String) : boolean;
  begin
    var Data : not nullable String;

    var Error : not nullable String;
    if TProjectIndexer.SafeOpenFileContext(Source, out Data, out Error) then
    begin
    var  Root := TPasSyntaxTreeBuilder.RunWithString(Data, false);
    if Root.Typ = TSyntaxNodeType.ntUnit then
    begin
      result := false;
      var lUnit := new CodeBuilder().BuildCGCodeUnitFomSyntaxNode(Root);
      var cg := new CGOxygeneCodeGenerator();
      var ElementsData := cg.GenerateUnit(lUnit);
      if Environment.OS = OperatingSystem.Windows then
      begin
        var a := Encoding.UTF8.GetBytes(ElementsData) includeBOM(true);
        File.WriteBytes(Dest , a);
       result := true;
      end;
    end;
    end;
  end;


  method ElementsConverter.BuildSameName(const Source: String): Boolean;
  begin
    result := false;
    if File.Exists(Source) then
    result := BuildElementsFile(Source, Source);
  end;


end.