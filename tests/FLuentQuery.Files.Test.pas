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

unit FLuentQuery.Files.Test;

interface

uses
  TestFramework,
  System.Generics.Collections,
  FluentQuery.Files,
  IOUtils,
  System.Types,
  SysUtils;

type
  TestFileQuery = class(TTestCase)
  strict private
    FTestDirectory : string;
    FFileCount : Integer;
    FDirCount : Integer;
    FTotalCount : Integer;
    FFirstLetterEven : TPredicate<string>;
    FFirstLetterFourOrLess : TPredicate<string>;
    FTruePredicate : TPredicate<string>;
    FFalsePredicate : TPredicate<string>;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestPassThrough;
    procedure TestPassThroughFiles;
    procedure TestPassThroughDirectories;
    procedure TestTakeLowerThanCount;
    procedure TestTakeEqualCount;
    procedure TestTakeGreaterThanCount;
    procedure TestTakeZero;
    procedure TestTakeOne;
    procedure TestWhereEven;
    procedure TestWhereNotWhereEven;
    procedure TestWhereNotEven;
    procedure TestWhereNone;
    procedure TestWhereAll;
    procedure TestWhereTake;
    procedure TestTakeWhere;
    procedure TestSkipLowerThanCount;
    procedure TestSkipEqualCount;
    procedure TestSkipGreaterThanCount;
    procedure TestSkipZero;
    procedure TestWhereSkip;
    procedure TestSkipWhere;
    procedure TestSkipWhileTrue;
    procedure TestSkipWhileFalse;
    procedure TestSkipWhile;
    procedure TestTakeWhileFalse;
    procedure TestTakeWhileTrue;
    procedure TestTakeWhile;
    procedure TestFirst;
    procedure TestNameMatchesAll;
    procedure TestNameMatchesSome;
    procedure TestNameMatchesNone;
  end;

var
  DummyFile : string; // used to suppress warnings about not using loop variables in tests

implementation

procedure TestFileQuery.SetUp;
begin
  FTestDirectory := TPath.GetTempPath + TPath.GetGUIDFilename; ;
  TDirectory.CreateDirectory(FTestDirectory);

  TFile.WriteAllText(FTestDirectory + PathDelim + '10filename.txt', '');
  TFile.WriteAllText(FTestDirectory + PathDelim + '1filename.txt', '');
  TFile.WriteAllText(FTestDirectory + PathDelim + '2filename.txt', '');
  TFile.WriteAllText(FTestDirectory + PathDelim + '3filename.txt', '');
  TFile.WriteAllText(FTestDirectory + PathDelim + '4filename.txt', '');
  TFile.WriteAllText(FTestDirectory + PathDelim + '5filename.txt', '');
  TFile.WriteAllText(FTestDirectory + PathDelim + '6filename.txt', '');
  TFile.WriteAllText(FTestDirectory + PathDelim + '7filename.txt', '');
  TFile.WriteAllText(FTestDirectory + PathDelim + '8filename.txt', '');
  TFile.WriteAllText(FTestDirectory + PathDelim + '9filename.txt', '');

  // subdirectory
  TDirectory.CreateDirectory(FTestDirectory + PathDelim + 'childdir');

  FFileCount := Length(TDirectory.GetFiles(FTestDirectory));
  FDirCount := Length(TDirectory.GetDirectories(FTestDirectory));
  FTotalCount := FFileCount + FDirCount;

  FFirstLetterEven := function (Value : string) : Boolean
                  var
                    LFilename : string;
                  begin
                    LFilename := TPath.GetFilename(Value);
                    try
                      Result := StrToInt(LFilename.Substring(0, 1)) mod 2 = 0;
                    except
                      on E : EConvertError do
                        Result := False;
                    end;
                  end;
  FFirstLetterFourOrLess := function (Value : string) : Boolean
                  var
                    LFilename : string;
                  begin
                    LFilename := TPath.GetFilename(Value);
                    try
                      Result := StrToInt(LFilename.Substring(0, 1)) <= 4;
                    except
                      on E : EConvertError do
                        Result := False;
                    end;
                 end;
  FTruePredicate := function (Value : string) : Boolean
                    begin
                      Result := True;
                    end;

  FFalsePredicate := function (Value : string) : Boolean
                     begin
                       Result := False;
                     end;
end;

procedure TestFileQuery.TearDown;
begin
  TDirectory.Delete(FTestDirectory, True);
end;


procedure TestFileQuery.TestTakeEqualCount;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;
  for I in FileQuery
            .From(FTestDirectory)
            .Take(FTotalCount) do
  begin
    Inc(LPassCount);
    DummyFile := i;   // just to suppress warning about not using I
  end;

  CheckEquals(FTotalCount, LPassCount);
  CheckNotEquals(0, LPasscount);
end;

procedure TestFileQuery.TestTakeGreaterThanCount;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;
  for I in FileQuery
            .From(FTestDirectory)
            .Take(FTotalCount + 1) do
  begin
    Inc(LPassCount);
    DummyFile := i;   // just to suppress warning about not using I
  end;

  CheckEquals(FTotalCount,  LPassCount);
  CheckNotEquals(0, LPasscount);
end;

procedure TestFileQuery.TestTakeLowerThanCount;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileQuery
            .From(FTestDirectory)
            .Take(FTotalCount - 1) do
  begin
    Inc(LPassCount);
    DummyFile := i;   // just to suppress warning about not using I
  end;

  CheckEquals(FTotalCount - 1, LPassCount);
  CheckNotEquals(0, LPasscount);
end;

procedure TestFileQuery.TestTakeOne;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileQuery
            .From(FTestDirectory)
            .Take(1) do
  begin
    Inc(LPassCount);
    DummyFile := i;   // just to suppress warning about not using I
  end;

  CheckEquals(1, LPassCount);
  CheckNotEquals(0, LPasscount);
end;

procedure TestFileQuery.TestTakeWhere;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileQuery
             .From(FTestDirectory)
             .Take(5)
             .Where(FFirstLetterEven) do
  begin
    Inc(LPassCount);
    DummyFile := i;   // just to suppress warning about not using I
  end;

  CheckEquals(2, LPassCount);
  CheckNotEquals(0, LPasscount);
end;

procedure TestFileQuery.TestTakeWhile;
var
  LPasscount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileQuery
             .From(FTestDirectory)
             .TakeWhile(FFirstLetterFourOrLess) do
  begin
    Inc(LPassCount);
    DummyFile := i;   // just to suppress warning about not using I
  end;

  CheckEquals(5, LPassCount);
  CheckNotEquals(0, LPasscount);
end;

procedure TestFileQuery.TestTakeWhileFalse;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileQuery
            .From(FTestDirectory)
            .TakeWhile(FFalsePredicate) do
  begin
    Inc(LPassCount);
    DummyFile := i;   // just to suppress warning about not using I
  end;

  CheckEquals(0, LPassCount);
end;

procedure TestFileQuery.TestTakeWhileTrue;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileQuery
            .From(FTestDirectory)
            .TakeWhile(FTruePredicate) do
  begin
    Inc(LPassCount);
    DummyFile := i;   // just to suppress warning about not using I
  end;

  CheckEquals(FTotalCount, LPassCount);
  CheckNotEquals(0, LPasscount);
end;

procedure TestFileQuery.TestTakeZero;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;
  for I in FileQuery
            .From(FTestDirectory)
            .Take(0) do
  begin
    Inc(LPassCount);
    DummyFile := i;   // just to suppress warning about not using I
  end;

  CheckEquals(0, LPassCount);
end;

procedure TestFileQuery.TestFirst;
var
  I : String;
  LFilename : string;
begin
  I := FileQuery
        .From(FTestDirectory)
        .Skip(2)
        .First;

  LFilename := TPath.GetFilename(I);

  CheckEquals(2, StrToInt(LFilename.Substring(0, 1)));
end;

procedure TestFileQuery.TestNameMatchesAll;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileQuery
             .From(FTestDirectory)
             .NameMatches('*') do
    Inc(LPassCount);

  CheckEquals(FTotalCount, LPassCount);
  CheckNotEquals(0, LPassCount);
end;

procedure TestFileQuery.TestNameMatchesNone;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileQuery
             .From(FTestDirectory)
             .NameMatches('*.blah') do
    Inc(LPassCount);

  CheckEquals(0, LPassCount);
end;

procedure TestFileQuery.TestNameMatchesSome;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileQuery
             .From(FTestDirectory)
             .NameMatches('1*.*') do
    Inc(LPassCount);

  CheckEquals(2, LPassCount);
end;

procedure TestFileQuery.TestWhereNotEven;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileQuery
             .From(FTestDirectory)
             .WhereNot(FFirstLetterEven) do
  begin
    try
      Check(StrToInt(TPath.GetFilename(I).Substring(0, 1)) mod 2 <> 0,
            'Should enumerate odd numbered items, but enumerated ' + I);
      Inc(LPassCount);
    except
      on E : EConvertError do
        DummyFile := '';
    end;        
  end;
  CheckEquals(6, LPassCount);
end;

procedure TestFileQuery.TestWhereNotWhereEven;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileQuery
             .From(FTestDirectory)
             .WhereNot(FileQuery.Where(FFirstLetterEven)) do
  begin
    try
      Check(StrToInt(TPath.GetFilename(I).Substring(0, 1)) mod 2 <> 0,
          'Should enumerate odd numbered items, but enumerated ' + I);
      Inc(LPassCount);
    except 
      on E : EConvertError do
        DummyFile := '';
    end;      
  end;
  CheckEquals(6, LPassCount);
end;

procedure TestFileQuery.TestPassThrough;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileQuery
                .From(FTestDirectory) do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(FTotalCount, LPassCount);
  CheckNotEquals(0, LPasscount);
end;

procedure TestFileQuery.TestPassThroughDirectories;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileQuery
                .From(FTestDirectory)
                .Directories do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(FDirCount, LPassCount);
end;

procedure TestFileQuery.TestPassThroughFiles;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileQuery
                .From(FTestDirectory)
                .Files do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(FFileCount, LPassCount);
  CheckNotEquals(0, LPasscount);
end;

procedure TestFileQuery.TestSkipEqualCount;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileQuery
            .From(FTestDirectory)
            .Skip(FTotalCount) do
  begin
    Inc(LPassCount);
    DummyFile := i;   // just to suppress warning about not using I
  end;

  CheckEquals(0, LPassCount);
end;

procedure TestFileQuery.TestSkipGreaterThanCount;
var
  LPassCount, LSkipCount : Integer;
  I : string;
begin
  LPassCount := 0;
  LSkipCount := FTotalCount + 2;

  for I in FileQuery
            .From(FTestDirectory)
            .Skip(LSkipCount) do
  begin
    Inc(LPassCount);
    DummyFile := i;   // just to suppress warning about not using I
  end;

  CheckEquals(0, LPassCount);
end;

procedure TestFileQuery.TestSkipLowerThanCount;
var
  LPassCount, LSkipCount : Integer;
  I : string;
begin
  LPassCount := 0;
  LSkipCount := FTotalCount - 2;

  for I in FileQuery
            .From(FTestDirectory)
            .Skip(LSkipCount) do
  begin
    Inc(LPassCount);
    DummyFile := i;   // just to suppress warning about not using I
  end;

  CheckEquals(2, LPassCount);
end;

procedure TestFileQuery.TestSkipWhere;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileQuery
             .From(FTestDirectory)
             .Skip(5)
             .Where(FFirstLetterEven) do
  begin
    Inc(LPassCount);
    DummyFile := i;   // just to suppress warning about not using I
  end;

  CheckEquals(2, LPassCount);
end;

procedure TestFileQuery.TestSkipWhile;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileQuery
            .From(FTestDirectory)
            .SkipWhile(FFirstLetterFourOrLess) do
  begin
    Inc(LPassCount);
    DummyFile := i;   // just to suppress warning about not using I
  end;

  CheckEquals(6, LPassCount);
end;

procedure TestFileQuery.TestSkipWhileFalse;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileQuery
            .From(FTestDirectory)
            .SkipWhile(FFalsePredicate) do
  begin
    Inc(LPassCount);
    DummyFile := i;   // just to suppress warning about not using I
  end;

  CheckEquals(FTotalCount, LPassCount);
  CheckNotEquals(0, LPassCount);
end;

procedure TestFileQuery.TestSkipWhileTrue;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileQuery
            .From(FTestDirectory)
            .SkipWhile(FTruePredicate) do
  begin
    Inc(LPassCount);
    DummyFile := i;   // just to suppress warning about not using I
  end;

  CheckEquals(0, LPassCount);
end;

procedure TestFileQuery.TestSkipZero;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileQuery
            .From(FTestDirectory)
            .Skip(0) do
  begin
    Inc(LPassCount);
    DummyFile := i;   // just to suppress warning about not using I
  end;

  CheckEquals(FTotalCount, LPassCount);
end;

procedure TestFileQuery.TestWhereEven;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileQuery
            .From(FTestDirectory)
            .Where(FFirstLetterEven) do
  begin
    Inc(LPassCount);
    DummyFile := i;   // just to suppress warning about not using I
  end;

  CheckEquals(4, LPassCount);
end;

procedure TestFileQuery.TestWhereAll;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileQuery
            .From(FTestDirectory)
            .Where(FTruePredicate) do
  begin
    Inc(LPassCount);
    DummyFile := i;   // just to suppress warning about not using I
  end;

  CheckEquals(FTotalCount, LPassCount);
end;

procedure TestFileQuery.TestWhereTake;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileQuery
             .From(FTestDirectory)
             .Where(FFirstLetterEven)
             .Take(3) do
  begin
    Inc(LPassCount);
    DummyFile := i;   // just to suppress warning about not using I
  end;

  CheckEquals(3, LPassCount);
end;

procedure TestFileQuery.TestWhereNone;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileQuery
            .From(FTestDirectory)
            .Where(FFalsePredicate) do
  begin
    Inc(LPassCount);
    DummyFile := i;   // just to suppress warning about not using I
  end;

  CheckEquals(0, LPassCount);
end;

procedure TestFileQuery.TestWhereSkip;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileQuery
             .From(FTestDirectory)
             .Where(FFirstLetterEven)
             .Skip(3) do
  begin
    Inc(LPassCount);
    DummyFile := i;  // just to suppress warning about not using I
  end;

  CheckEquals(1, LPassCount);
end;




initialization
  // Register any test cases with the test runner
  RegisterTest('Files', TestFileQuery.Suite);
end.

