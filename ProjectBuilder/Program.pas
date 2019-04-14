namespace ProjectBuilder;

type
  Program = class
  public

    class method Main(args: array of String): Int32;
    begin
      // add your own code here
      writeLn('Delphi to Elements........');
      if args.Count > 0 then
      begin
        var lConvert := new DelphiProject(args[0]);
        if lConvert.createElementsProject then
         writeLn($"Project {args[0]} converted") else
         writeLn($"Project {args[0]} not converted");

      end;
    end;

  end;

end.