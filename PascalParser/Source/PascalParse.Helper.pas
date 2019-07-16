namespace ProHolz.Ast;

type
  StrHelper =  static public class
  private
    method DeQuotedString(const S : not nullable String; const QuoteChar: Char): not  nullable String;
    begin
      if (S.Length >= 2) and (S.Chars[0] = QuoteChar) and (S.Chars[S.Length - 1] = QuoteChar) then
      begin
        var lSb := new Char[S.Length - 2];
        var lTotal := 0;
        var lInQuote: Boolean := false;
        for i: Integer := 1 to S.Length - 2 do
          begin
          var lChar := S.Chars[i];
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
        result := S;
    end;
  public

    method AnsiDequotedStr(const S: not nullable String; aQuote: Char): not nullable String;
    begin
      result := DeQuotedString(S, aQuote);
    end;

  end;

end.