namespace PlayGroundFritz;

type
  Program = class
  public
    class method Main(args: array of String): Int32;
    begin
      var s := BuildPasfromNode;
      writeLn(s);
    end;
  end;
end.