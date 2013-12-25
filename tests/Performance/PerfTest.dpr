program PerfTest;

uses
  FMX.Forms,
  Unit8 in 'Unit8.pas' {Form8},
  FluentQuery in '..\..\FluentQuery.pas',
  FluentQuery.Enumerators in '..\..\FluentQuery.Enumerators.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm8, Form8);
  Application.Run;
end.
