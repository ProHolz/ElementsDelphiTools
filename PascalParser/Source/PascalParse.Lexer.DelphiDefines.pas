namespace PascalParser;

 type

  DelphiCompiler = public enum (dcDefault, dcXe7, dcTokyo, dcRio);

  DelphiDefines =  public static class
  protected
    method &default : Array of  String;
    begin
      result := ['VER280',
                 'MSWINDOWS',
                 'CONDITIONALEXPRESSIONS',
                 'UNICODE',
                 'WIN32',
                 'XE7'];

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
        DelphiCompiler.dcTokyo : result := 32;
        DelphiCompiler.dcRio : result := 33;
        else
          result := 28;
      end;

   end;


  end;


end.