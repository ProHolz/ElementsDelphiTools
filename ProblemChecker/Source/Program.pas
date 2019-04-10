namespace ProHolz.SourceChecker;
uses ProHolz.Ast;

type
  Program = class
  public
    class method Main(args: array of String): Int32;
    begin
       Var Sourcecheck := new SourceChecker;
       Sourcecheck.RunMain(args);
    end;

  end;

end.