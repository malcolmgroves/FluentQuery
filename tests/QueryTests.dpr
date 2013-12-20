program QueryTests;
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
  FluidQuery.Tests in 'FluidQuery.Tests.pas',
  FluidQuery in '..\FluidQuery.pas',
  FluidQuery.EnumerationDelegates in '..\FluidQuery.EnumerationDelegates.pas',
  FluidQuery.Enumerators in '..\FluidQuery.Enumerators.pas',
  FluidQuery.Types in '..\FluidQuery.Types.pas',
  FluidQuery.Enumerators.Strings in '..\FluidQuery.Enumerators.Strings.pas',
  FluidQuery.Enumerators.Generic in '..\FluidQuery.Enumerators.Generic.pas';

{$R *.RES}

begin
  ReportMemoryLeaksOnShutdown := True;
  DUnitTestRunner.RunRegisteredTests;
end.

