namespace ProjectBuilder;

interface
// a Class to create a Shared Project
// at Moment it will always create a new one.......
// This fits my needs
  type
    PBuilder = class
      private
       fElementsFile : XmlDocument;
       fSharedFile : XmlDocument;
       fBasePath : String;

       method PrepareProjectFile;
       method PrepareSharedFile;
       method SetDefaults;
       method LoadData;

       method getRelativPath(const value : String) : String;


      public
        constructor (const aFilename : String);

        method AddShared(const values : Array of String);

        method Save;

        property ProjectGuid : Guid;
        property Name : String;
        property Filename : String;
    end;

implementation

constructor PBuilder(const aFilename: String);
begin
 inherited constructor ();
  ProjectGuid := Guid.NewGuid;
  Name := Path.GetFileNameWithoutExtension(aFilename);
  fBasePath := Path.GetWindowsParentDirectory(aFilename);
// We assume always a *.elements File
 Filename :=  Path.ChangeExtension(aFilename, '.elements');
 LoadData;
end;



method PBuilder.LoadData;
begin
  if File.Exists(Filename) then
  begin
    fElementsFile :=  XmlDocument.FromFile(Filename);
    fSharedFile :=  XmlDocument.FromFile(Path.ChangeExtension(Filename, '.projitems'));

  end
  else
    SetDefaults;
end;

method PBuilder.SetDefaults;
begin
 PrepareProjectFile;
 PrepareSharedFile;
end;

method PBuilder.PrepareProjectFile;
begin
  fElementsFile := XmlDocument.WithRootElement("Project");
  fElementsFile.Root.AddNamespace(nil, Url.UrlWithString("http://schemas.microsoft.com/developer/msbuild/2003"));
  fElementsFile.Version := "1.0";
  fElementsFile.Encoding := "utf-8";
  fElementsFile.Standalone := "yes";

  var lPropGroup := fElementsFile.Root.AddElement("PropertyGroup");
  lPropGroup.AddElement("ProjectGuid").Value := ProjectGuid.ToString(GuidFormat.Braces);
  lPropGroup.AddElement("RootNamespace").Value := Name;
  lPropGroup.AddElement("DefaultUses").Value := "RemObjects.Elements.RTL";


  var lImp:= fElementsFile.Root.AddElement("Import");
  lImp.SetAttribute('Project', $"{Name}.projitems");
  lImp.SetAttribute('Label', "Shared");

  lImp:= fElementsFile.Root.AddElement("Import");
  lImp.SetAttribute('Project', "$(MSBuildExtensionsPath)\RemObjects Software\Elements\RemObjects.Elements.SharedProject.targets");


end;

method PBuilder.Save;
begin
 if assigned(fElementsFile) then
  begin
   var lXmlFormatOptions := new XmlFormattingOptions;
   lXmlFormatOptions.WhitespaceStyle := XmlWhitespaceStyle.PreserveWhitespaceAroundText;
   lXmlFormatOptions.NewLineForElements := true;
   lXmlFormatOptions.NewLineForAttributes := false;
   lXmlFormatOptions.NewLineSymbol := XmlNewLineSymbol.LF;
   lXmlFormatOptions.SpaceBeforeSlashInEmptyTags := true;


    fElementsFile.SaveToFile(Filename, lXmlFormatOptions);

    if assigned(fSharedFile) then
      fSharedFile.SaveToFile(Path.ChangeExtension(Filename, '.projitems'), lXmlFormatOptions);

  end;
end;

method PBuilder.PrepareSharedFile;
begin
  fSharedFile := XmlDocument.WithRootElement("Project");
  fSharedFile.Root.AddNamespace(nil, Url.UrlWithString("http://schemas.microsoft.com/developer/msbuild/2003"));
  fSharedFile.Version := "1.0";
  fSharedFile.Encoding := "utf-8";
  fSharedFile.Standalone := "yes";

  var lPropGroup := fSharedFile.Root.AddElement("PropertyGroup");
  lPropGroup.AddElement("MSBuildAllProjects").Value := '$(MSBuildAllProjects);$(MSBuildThisFileFullPath)';
  lPropGroup.AddElement("SharedGUID").Value := ProjectGuid.ToString(GuidFormat.Braces);
  lPropGroup.AddElement("HasSharedItems").Value := 'true';

  lPropGroup := fSharedFile.Root.AddElement("PropertyGroup");
  lPropGroup.SetAttribute('Label','Configuration');
  lPropGroup.AddElement("Import_RootNamespace").Value := Name;

end;

method PBuilder.AddShared(const values: array of String);
begin
  var relpath : String;
  fSharedFile.Root.RemoveElementsWithName("ItemGroup");
  var lImp:= fSharedFile.Root.AddElement("ItemGroup");
  for each value in values do
   begin
   relpath := getRelativPath(value);


    if not String.IsNullOrEmpty(relpath) then
      lImp.AddElement('None').SetAttribute('Include', $"$(MSBuildThisFileDirectory){relpath}");
   end;

end;

method PBuilder.getRelativPath(const value: String): String;
begin
  if value.IsAbsolutePath then
   begin
  //  relpath := Path.GetPath(value) RelativeToPath(fBasePath)
    var lurlf := Url.UrlWithWindowsPath(value) isDirectory(false);
    var lurlp := Url.UrlWithWindowsPath(fBasePath) isDirectory(true);

    result := lurlf.WindowsPathRelativeToUrl(lurlp) Always(true);

   end
   else
    result := value;
end;

end.