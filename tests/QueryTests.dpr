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
  Generics.Collections.Query.Tests in 'Generics.Collections.Query.Tests.pas',
  Generics.Collections.Query in '..\Generics.Collections.Query.pas',
  Generics.Collections.EnumerationDelegates in '..\Generics.Collections.EnumerationDelegates.pas',
  Generics.Collections.Enumerators in '..\Generics.Collections.Enumerators.pas',
  Generics.Collections.Query.Interfaces in '..\Generics.Collections.Query.Interfaces.pas';

{$R *.RES}

begin
  ReportMemoryLeaksOnShutdown := True;
  DUnitTestRunner.RunRegisteredTests;
end.

