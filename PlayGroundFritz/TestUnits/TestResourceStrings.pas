namespace ProHolz.CodeGen;
const cResStrings = "
 unit Test;
 interface
 const
   cTest1 = 'without SpecialChars';
   cTest2 = 'with German Umlauts äöüÄÖÜß';
 resourceString
   crTest1 = 'without SpecialChars';
   crTest2 = 'with German Umlauts äöüÄÖÜß';

 implementation
 end.

";

end.