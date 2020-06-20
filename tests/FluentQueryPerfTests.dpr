program FluentQueryPerfTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  TestInsight.Dunit,
  FluentQuery.Core.EnumerationStrategies in '..\FluentQuery.Core.EnumerationStrategies.pas',
  FluentQuery.Core.Enumerators in '..\FluentQuery.Core.Enumerators.pas',
  FluentQuery.Core.Types in '..\FluentQuery.Core.Types.pas',
  FluentQuery.Integers in '..\FluentQuery.Integers.pas',
  FluentQuery.Generics in '..\FluentQuery.Generics.pas',
  FluentQuery.Chars in '..\FluentQuery.Chars.pas',
  FluentQuery.Pointers in '..\FluentQuery.Pointers.pas',
  FluentQuery.Performance.Tests in 'FluentQuery.Performance.Tests.pas',
  FluentQuery.Strings in '..\FluentQuery.Strings.pas',
  FluentQuery.GenericObjects in '..\FluentQuery.GenericObjects.pas',
  FluentQuery.Components in '..\FluentQuery.Components.pas',
  FluentQuery.Core.MethodFactories in '..\FluentQuery.Core.MethodFactories.pas',
  FluentQuery.Strings.MethodFactories in '..\FluentQuery.Strings.MethodFactories.pas',
  FluentQuery.GenericObjects.MethodFactories in '..\FluentQuery.GenericObjects.MethodFactories.pas',
  FluentQuery.Integers.MethodFactories in '..\FluentQuery.Integers.MethodFactories.pas',
  FluentQuery.Components.MethodFactories in '..\FluentQuery.Components.MethodFactories.pas',
  FluentQuery.Files in '..\FluentQuery.Files.pas',
  FluentQuery.Core.Reduce in '..\FluentQuery.Core.Reduce.pas',
  FluentQuery.DB in '..\FluentQuery.DB.pas',
  FluentQuery.Tests.Base in 'FluentQuery.Tests.Base.pas',
  FluentQuery.JSON in '..\FluentQuery.JSON.pas',
  FluentQuery.JSON.MethodFactories in '..\FluentQuery.JSON.MethodFactories.pas';

{$R *.RES}

begin
  ReportMemoryLeaksOnShutdown := True;
  RunRegisteredTests;
end.

