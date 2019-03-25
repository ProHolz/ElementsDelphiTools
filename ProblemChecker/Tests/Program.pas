﻿namespace ProblemChecker.Tests;

interface

uses
  ProHolz.SourceChecker,
  RemObjects.Elements.EUnit;

implementation

begin
// WriteoutConstxml;

  var lTests := Discovery.DiscoverTests();
  Runner.RunTests(lTests) withListener(Runner.DefaultListener);
end.