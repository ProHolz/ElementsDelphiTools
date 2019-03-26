namespace PlayGroundFritz;

interface
uses ProHolz.Ast;

type

 BuildSettings  nested in CodeBuilderMethods = static class
  public
    property InterfaceGuids : Boolean  := true;
    property ComInterfaces : Boolean  := true;

 end;

  CodeBuilderMethods = static partial class
  private

  public
    property settings : BuildSettings read;

  end;
implementation

end.