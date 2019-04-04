namespace ProHolz.CodeGen;

type
  Program = class
  public
    class method Main(args: array of String): Int32;
    begin
      var full : Boolean := true;
      var s := BuildPasfromNode(full);
      writeLn(s);
    end;
  end;
end.