namespace ProHolz.Ast;

type
  StrHelper =  static public class
  private
    method DeQuotedString(const s : not nullable String; const QuoteChar: Char): not  nullable String;
    begin
      if (s.Length >= 2) and (s.Chars[0] = QuoteChar) and (s.Chars[s.Length - 1] = QuoteChar) then
      begin
        var lSb := new Char[s.Length - 2];
        var lTotal := 0;
        var lInQuote: Boolean := false;
        for i: Integer := 1 to s.Length - 2 do
        begin
          var lChar := s.Chars[i];
          if lChar = QuoteChar then
          begin
            if lInQuote then
            begin
              lInQuote := false;
              lSb[lTotal] := lChar;
              inc(lTotal);
            end
            else
              lInQuote := true;
          end
          else
          begin
            if lInQuote then
              lInQuote := false;
            lSb[lTotal] := lChar;
            inc(lTotal);
          end;
        end;
        result :=  new String(lSb, 0, lTotal);
      end
      else
        result := s;
    end;
  public

    method AnsiDequotedStr(const S: not nullable String; aQuote: Char): not nullable String;
    begin
      result := DeQuotedString(S, aQuote);
    end;

  end;

end.