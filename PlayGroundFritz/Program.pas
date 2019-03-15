namespace PlayGroundFritz;

type
  Program = class
  public
    class method Main(args: array of String): Int32;
    begin
      var full : Boolean := false;
      var s := BuildPasfromNode(full);
      writeLn(s);
    end;
  end;
end.