program FluentQueryTests;
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
  DUnitTestRunner,
  FluentQuery.Strings.Tests in 'FluentQuery.Strings.Tests.pas',
  FluentQuery in '..\FluentQuery.pas',
  FluentQuery.EnumerationStrategies in '..\FluentQuery.EnumerationStrategies.pas',
  FluentQuery.Enumerators in '..\FluentQuery.Enumerators.pas',
  FluentQuery.Types in '..\FluentQuery.Types.pas',
  FluentQuery.Enumerators.Strings in '..\FluentQuery.Enumerators.Strings.pas',
  FluentQuery.Enumerators.Generic in '..\FluentQuery.Enumerators.Generic.pas',
  FluentQuery.Enumerators.Char in '..\FluentQuery.Enumerators.Char.pas',
  FluentQuery.Enumerators.Pointer in '..\FluentQuery.Enumerators.Pointer.pas',
  FluentQuery.FluentPredicate.Tests in 'FluentQuery.FluentPredicate.Tests.pas',
  FluentQuery.Pointers.Tests in 'FluentQuery.Pointers.Tests.pas',
  FluentQuery.Tests in 'FluentQuery.Tests.pas';

{$R *.RES}

begin
  ReportMemoryLeaksOnShutdown := True;
  DUnitTestRunner.RunRegisteredTests;
end.

