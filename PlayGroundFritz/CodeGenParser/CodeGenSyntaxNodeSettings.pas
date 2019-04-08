namespace ProHolz.CodeGen;

interface
uses ProHolz.Ast;

type

 BuildSettings  nested in CodeBuilderMethods = static class
  public
    property InterfaceGuids : Boolean  := true;
    property ComInterfaces : Boolean  := true;
    property PublicEnums : Boolean := true;
    property PublicClasses : Boolean := true;
    property PublicInterfaces : Boolean := true;
    property PublicRecords : Boolean := true;
    property PublicBlocks : Boolean := true;

 end;

  CodeBuilderMethods = static partial class
  private

  public
    property settings : BuildSettings read;

  end;
implementation

end.