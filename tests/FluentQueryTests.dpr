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
  FluentQuery.Core.EnumerationStrategies in '..\FluentQuery.Core.EnumerationStrategies.pas',
  FluentQuery.Core.Enumerators in '..\FluentQuery.Core.Enumerators.pas',
  FluentQuery.Core.Types in '..\FluentQuery.Core.Types.pas',
  FluentQuery.Integers in '..\FluentQuery.Integers.pas',
  FluentQuery.Generics in '..\FluentQuery.Generics.pas',
  FluentQuery.Chars in '..\FluentQuery.Chars.pas',
  FluentQuery.Pointers in '..\FluentQuery.Pointers.pas',
  FluentQuery.Pointers.Tests in 'FluentQuery.Pointers.Tests.pas',
  FluentQuery.Integers.Tests in 'FluentQuery.Integers.Tests.pas',
  FluentQuery.Chars.Tests in 'FluentQuery.Chars.Tests.pas',
  FluentQuery.GenericObjects.Tests in 'FluentQuery.GenericObjects.Tests.pas',
  FluentQuery.Strings.Tests in 'FluentQuery.Strings.Tests.pas',
  FluentQuery.Strings in '..\FluentQuery.Strings.pas',
  FluentQuery.GenericObjects in '..\FluentQuery.GenericObjects.pas',
  FluentQuery.Generics.Tests in 'FluentQuery.Generics.Tests.pas',
  FluentQuery.Components in '..\FluentQuery.Components.pas',
  FluentQuery.Components.Test in 'FluentQuery.Components.Test.pas',
  FluentQuery.Core.MethodFactories in '..\FluentQuery.Core.MethodFactories.pas',
  FluentQuery.Chars.MethodFactories in '..\FluentQuery.Chars.MethodFactories.pas',
  FluentQuery.Strings.MethodFactories in '..\FluentQuery.Strings.MethodFactories.pas',
  FluentQuery.GenericObjects.MethodFactories in '..\FluentQuery.GenericObjects.MethodFactories.pas',
  FluentQuery.Pointers.MethodFactories in '..\FluentQuery.Pointers.MethodFactories.pas',
  FluentQuery.Integers.MethodFactories in '..\FluentQuery.Integers.MethodFactories.pas';

{$R *.RES}

begin
  ReportMemoryLeaksOnShutdown := True;
  DUnitTestRunner.RunRegisteredTests;
end.

