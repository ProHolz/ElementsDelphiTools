namespace ProHolz.Ast;

 type

  DelphiCompiler = public enum (dcDefault, dcXe7, dcXe8, dcSeatle, dcBerlin, dcTokyo, dcRio);

  DelphiDefines =  public static class
  private
    const base : array of  String = ['MSWINDOWS',
                                     'CONDITIONALEXPRESSIONS',
                                     'UNICODE',
                                     'WIN32'];


    method prepare(const values : Array of String ): Array of String;
    begin
      var ltemp := new List<String>(base);
      ltemp.add(values);
      result := ltemp.ToArray;
    end;

  protected
   method &default : array of  String;
    begin
      exit prepare(['VER280','XE7']);
    end;


    method defXE8 : Array of  String;
    begin
      exit  prepare(['VER290','XE8']);
    end;

    method defSeatle : Array of  String;
    begin
      exit prepare(['VER300','SEATLE']);
    end;


    method defBerlin : Array of  String;
    begin
      exit prepare(['VER310','BERLIN']);
    end;

     method defTokyo : Array of  String;
     begin
       exit prepare(['VER320','TOKYO']);
     end;


 method defRio : Array of  String;
     begin
       exit prepare(['VER330','RIO']);
     end;

  public

  method getDefinesFor(const compiler : DelphiCompiler) : sequence of String;
    begin
      case compiler of
        DelphiCompiler.dcDefault : result := &default;
        DelphiCompiler.dcXe7 : result := &default;
        DelphiCompiler.dcXe8 : result := defXE8;
        DelphiCompiler.dcSeatle : result := defSeatle;
        DelphiCompiler.dcBerlin : result := defBerlin;
        DelphiCompiler.dcTokyo : result := defTokyo;
        DelphiCompiler.dcRio : result := defRio;
        else
          result := &default;
      end;

    end;


   method getCompilerVersion(const compiler : DelphiCompiler) : Integer;
   begin
      case compiler of
        DelphiCompiler.dcDefault : result := 28;
        DelphiCompiler.dcXe7 : result := 28;
        DelphiCompiler.dcXe8 : result := 29;
        DelphiCompiler.dcSeatle : result := 30;
        DelphiCompiler.dcBerlin : result := 31;
        DelphiCompiler.dcTokyo : result := 32;
        DelphiCompiler.dcRio : result := 33;
        else
          result := 28;
      end;
   end;

  method getRtlVersion(const compiler : DelphiCompiler) : Integer;
   begin
      case compiler of
        DelphiCompiler.dcDefault : result := 28;
        DelphiCompiler.dcXe7 : result := 28;
        DelphiCompiler.dcXe8 : result := 29;
        DelphiCompiler.dcSeatle : result := 30;
        DelphiCompiler.dcBerlin : result := 31;
        DelphiCompiler.dcTokyo : result := 32;
        DelphiCompiler.dcRio : result := 33;
        else
          result := 28;
      end;

   end;

  end;

end.