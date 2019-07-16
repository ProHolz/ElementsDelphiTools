namespace ProHolz.Ast;

type
  DelphiCompiler = public enum (&Default, Xe7, Xe8, Seatle, Berlin, Tokyo, Rio);

  DelphiDefines =  public static class
  private
    const base : array of  String = ['MSWINDOWS',
    'CONDITIONALEXPRESSIONS',
    'UNICODE',
    'WIN32'];


    method Prepare(const values : Array of String ): Array of String;
    begin
      var ltemp := new List<String>(base);
      ltemp.add(values);
      result := ltemp.ToArray;
    end;

  protected
    method &Default : array of  String;
    begin
      exit Prepare(['VER280','XE7']);
    end;


    method DefXE8 : Array of  String;
    begin
      exit  Prepare(['VER290','XE8']);
    end;

    method defSeatle : Array of  String;
    begin
      exit Prepare(['VER300','SEATLE']);
    end;


    method DefBerlin : Array of  String;
    begin
      exit Prepare(['VER310','BERLIN']);
    end;

    method DefTokyo : Array of  String;
    begin
      exit Prepare(['VER320','TOKYO']);
    end;


    method DefRio : Array of  String;
    begin
      exit Prepare(['VER330','RIO']);
    end;

  public

     method GetDefinesFor(const compiler : DelphiCompiler) : sequence of String;
     begin
       case compiler of
         DelphiCompiler.Default : result := &Default;
         DelphiCompiler.Xe7 : result := &Default;
         DelphiCompiler.Xe8 : result := DefXE8;
         DelphiCompiler.Seatle : result := defSeatle;
         DelphiCompiler.Berlin : result := DefBerlin;
         DelphiCompiler.Tokyo : result := DefTokyo;
         DelphiCompiler.Rio : result := DefRio;
         else
           result := &Default;
       end;

     end;


     method GetCompilerVersion(const compiler : DelphiCompiler) : Integer;
     begin
       case compiler of
         DelphiCompiler.Default : result := 28;
         DelphiCompiler.Xe7 : result := 28;
         DelphiCompiler.Xe8 : result := 29;
         DelphiCompiler.Seatle : result := 30;
         DelphiCompiler.Berlin : result := 31;
         DelphiCompiler.Tokyo : result := 32;
         DelphiCompiler.Rio : result := 33;
         else
           result := 28;
       end;
     end;

     method GetRtlVersion(const compiler : DelphiCompiler) : Integer;
     begin
       case compiler of
         DelphiCompiler.Default : result := 28;
         DelphiCompiler.Xe7 : result := 28;
         DelphiCompiler.Xe8 : result := 29;
         DelphiCompiler.Seatle : result := 30;
         DelphiCompiler.Berlin : result := 31;
         DelphiCompiler.Tokyo : result := 32;
         DelphiCompiler.Rio : result := 33;
         else
           result := 28;
       end;
     end;
   end;
end.