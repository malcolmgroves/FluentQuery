{****************************************************}
{                                                    }
{  FluentQuery                                       }
{                                                    }
{  Copyright (C) 2013 Malcolm Groves                 }
{                                                    }
{  http://www.malcolmgroves.com                      }
{                                                    }
{****************************************************}
{                                                    }
{  This Source Code Form is subject to the terms of  }
{  the Mozilla Public License, v. 2.0. If a copy of  }
{  the MPL was not distributed with this file, You   }
{  can obtain one at                                 }
{                                                    }
{  http://mozilla.org/MPL/2.0/                       }
{                                                    }
{****************************************************}

unit FluentQuery.Performance.Tests;

interface

uses
  TestFramework,
  System.Generics.Collections,
  FluentQuery.Integers,
  FLuentQuery.Tests.Base,
  System.SysUtils;

// this is just an experiment to catch any big speed blowouts as I evolve FluentQuery
// FluentQuery will ABSOLUTELY be slower than traditional methods.
// Its aim is not speed but READABILITY.
// However, if I do something that changes the performance profile dramatically, these smoketests should alert me.


type
  TestFluentQueryPerformance = class(TTestCase)
  published
    procedure TestIntegerQueryPerf;
  end;


implementation
uses
  Math, FluentQuery.Core.Types, System.Diagnostics;

var
  DummyInt : Integer; // used to suppress warnings about unused Loop variable




procedure TestFluentQueryPerformance.TestIntegerQueryPerf;
var
  LPassCount, LOldStylePassCount, I : Integer;
  LStopWatch, LOldStyleStopWatch : TStopWatch;
  LSpeedPercentage : double;
begin
  LPassCount := 0;
  LOldStylePassCount := 0;

  // time fluentquery
  LStopWatch := TStopwatch.StartNew;
  try
    for I in IntegerRange(-1000000, 1000000).Positive.Even.GreaterThan(3000) do
    begin
      Inc(LPassCount);
      DummyInt := i;   // just to suppress warning about not using I
    end;
  finally
    LStopWatch.Stop;
  end;

  // time equivalent old style
  LOldStyleStopWatch := TStopwatch.StartNew;
  try
    for I := -1000000 to 1000000 do
      if I >= 0 then   // Positive
        if I mod 2 = 0 then  // Even
          if I > 3000 then
          begin
            Inc(LOldStylePassCount);
            DummyInt := i;   // just to suppress warning about not using I
          end;
  finally
    LOldStyleStopWatch.Stop;
  end;

  LSpeedPercentage := LStopWatch.ElapsedMilliseconds / LOldStyleStopWatch.ElapsedMilliseconds;
  Check(LSpeedPercentage < 270, Format('%f percent. If this fails consistently, you''ve done something to slow everything down Malcolm', [LSpeedPercentage]));
  Check(LSpeedPercentage > 170, Format('%f percent. If this fails consistently, you''ve done something to speed everything up Malcolm.', [LSpeedPercentage]));
  CheckEquals(LPassCount, LOldStylePassCount);
end;



initialization
  // Register any test cases with the test runner
  RegisterTest('Performance', TestFluentQueryPerformance.Suite);
end.

