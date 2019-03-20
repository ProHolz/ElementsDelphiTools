namespace PascalParser;

 type

  DelphiCompiler = public enum (dcDefault, dcXe7, dcXe8, dcSeatle, dcBerlin, dcTokyo, dcRio);

  DelphiDefines =  public static class
  protected
    method &default : Array of  String;
    begin
      result := ['VER280',
                 'MSWINDOWS',
                 'CONDITIONALEXPRESSIONS',
                 'UNICODE',
                 'WIN32',
                 'XE7',
                 'CPUX86',
                 'PUREPASCAL'];
    end;


    method defXE8 : Array of  String;
    begin
      result := ['VER290',
                 'MSWINDOWS',
                 'CONDITIONALEXPRESSIONS',
                 'UNICODE',
                 'WIN32',
                 'XE8'];
    end;

    method defSeatle : Array of  String;
    begin
      result := ['VER300',
                 'MSWINDOWS',
                 'CONDITIONALEXPRESSIONS',
                 'UNICODE',
                 'WIN32',
                 'SEATLE'];
    end;


    method defBerlin : Array of  String;
    begin
      result := ['VER310',
                 'MSWINDOWS',
                 'CONDITIONALEXPRESSIONS',
                 'UNICODE',
                 'WIN32',
                 'BERLIN'];

    end;

     method defTokyo : Array of  String;
     begin
       result := ['VER320',
                  'MSWINDOWS',
                  'CONDITIONALEXPRESSIONS',
                  'UNICODE',
                  'WIN32',
                  'TOKYO'];

     end;


 method defRio : Array of  String;
     begin
       result := ['VER330',
                  'MSWINDOWS',
                  'CONDITIONALEXPRESSIONS',
                  'UNICODE',
                  'WIN32',
                  'RIO'];

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