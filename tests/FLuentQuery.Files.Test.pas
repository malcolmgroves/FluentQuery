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
    FFileCount, FRecursiveFileCount : Integer;
    FTopLevelDirCount, FTotalDirCount : Integer;
    FTotalCount, FTotalRecursiveCount : Integer;
    FFirstLetterEven : TPredicate<string>;
    FFirstLetterFourOrLess : TPredicate<string>;
    FTruePredicate : TPredicate<string>;
    FFalsePredicate : TPredicate<string>;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestPassThrough;
    procedure TestPassThroughRecursive;
    procedure TestFiles;
    procedure TestFilesRecursive;
    procedure TestDirectories;
    procedure TestDirectoriesRecursive;
    procedure TestHiddenFiles;
    procedure TestNotHiddenFiles;
    procedure TestNotHiddenNotReadOnlyFiles;
    procedure TestReadOnlyFiles;
    procedure TestNotReadOnlyFiles;
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
    procedure TestFilesNameMatchesStringQuery;
    procedure TestDirNameMatchesStringQuery;
    procedure TestNameMatchesDir;
    procedure TestNameMatchesNone;
    procedure TestExtension;
    procedure TestExtensionRecursive;
    procedure TestLargerThanZero;
    procedure TestLargerThanNegative;
    procedure TestLargerThanLarge;
    procedure TestLargerThanSmall;
    procedure TestLargerThanZeroRecursive;
    procedure TestLargerThanNegativeRecursive;
    procedure TestLargerThanLargeRecursive;
    procedure TestLargerThanSmallRecursive;
    procedure TestSmallerThanZero;
    procedure TestSmallerThanNegative;
    procedure TestSmallerThanLarge;
    procedure TestSmallerThanSmall;
    procedure TestLargerThanSmallerThan;
    procedure TestSmallerThanZeroRecursive;
    procedure TestSmallerThanNegativeRecursive;
    procedure TestSmallerThanLargeRecursive;
    procedure TestSmallerThanSmallRecursive;
    procedure TestLargerThanSmallerThanRecursive;
  end;

var
  DummyFile : string; // used to suppress warnings about not using loop variables in tests

implementation
uses
  FluentQuery.Strings;

procedure TestFileQuery.SetUp;
var
  LChildTestDirectory : string;
  LSomeContent : string;
begin
  FTestDirectory := TPath.GetTempPath + TPath.GetGUIDFilename; ;
  TDirectory.CreateDirectory(FTestDirectory);
  LSomeCOntent := '{4C405B5B-600F-4E3C-995F-CCFF61F4E736}{951B2E71-57A4-48F6-85F3-7584679AAD78}' +
                  '{457EAA37-8A77-4D76-B448-2FF6E338781C}{209D029E-985C-4A5E-82EF-E992D0D68079}';

  TFile.WriteAllText(FTestDirectory + PathDelim + '10filename.txt', LSomeContent);
  TFile.WriteAllText(FTestDirectory + PathDelim + '1filename.txt', '');
  TFile.WriteAllText(FTestDirectory + PathDelim + '2filename.doc', LSomeContent);
  TFile.WriteAllText(FTestDirectory + PathDelim + '3filename.txt', '');
  TFile.WriteAllText(FTestDirectory + PathDelim + '4filename.doc', '');
  TFile.WriteAllText(FTestDirectory + PathDelim + '5filename.txt', '');
  TFile.WriteAllText(FTestDirectory + PathDelim + '6filename.txt', '');
  TFile.SetAttributes(FTestDirectory + PathDelim + '6filename.txt', [TFileAttribute.faHidden]);
  TFile.WriteAllText(FTestDirectory + PathDelim + '7filename.txt', '');
  TFile.SetAttributes(FTestDirectory + PathDelim + '7filename.txt', [TFileAttribute.faReadOnly]);
  TFile.WriteAllText(FTestDirectory + PathDelim + '8filename.txt', '');
  TFile.WriteAllText(FTestDirectory + PathDelim + '9filename.txt', '');

  // subdirectory
  LChildTestDirectory := FTestDirectory + PathDelim + 'childdir';
  TDirectory.CreateDirectory(LChildTestDirectory);
  TFile.WriteAllText(LChildTestDirectory + PathDelim + '1filename.txt', LSomeContent);
  TFile.WriteAllText(LChildTestDirectory + PathDelim + '2filename.doc', LSomeContent);
  TFile.WriteAllText(LChildTestDirectory + PathDelim + '3filename.txt', '');

  //sub-subdirectory
  TDirectory.CreateDirectory(LChildTestDirectory + PathDelim + 'grandchilddir');


  FFileCount := Length(TDirectory.GetFiles(FTestDirectory));
  FRecursiveFileCount := FFileCOunt + Length(TDirectory.GetFiles(LChildTestDirectory));
  FTopLevelDirCount := Length(TDirectory.GetDirectories(FTestDirectory));

  FTotalDirCount := FTopLevelDirCount +  + Length(TDirectory.GetDirectories(LChildTestDirectory));
  FTotalCount := FFileCount + FTopLevelDirCount;
  FTotalRecursiveCount := FRecursiveFileCount + FTotalDirCount;

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
  for I in FileSystemQuery
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
  for I in FileSystemQuery
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

  for I in FileSystemQuery
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

  for I in FileSystemQuery
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

  for I in FileSystemQuery
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

  for I in FileSystemQuery
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

  for I in FileSystemQuery
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

  for I in FileSystemQuery
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
  for I in FileSystemQuery
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
  I := FileSystemQuery
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

  for I in FileSystemQuery
             .From(FTestDirectory)
             .NameMatches('*') do
    Inc(LPassCount);

  CheckEquals(FTotalCount, LPassCount);
  CheckNotEquals(0, LPassCount);
end;

procedure TestFileQuery.TestNameMatchesDir;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileSystemQuery
             .From(FTestDirectory)
             .NameMatches('child*') do
    Inc(LPassCount);

  CheckEquals(1, LPassCount);
end;

procedure TestFileQuery.TestNameMatchesNone;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileSystemQuery
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

  for I in FileSystemQuery
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

  for I in FileSystemQuery
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

  for I in FileSystemQuery
             .From(FTestDirectory)
             .WhereNot(FileSystemQuery.Where(FFirstLetterEven)) do
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
  for LFile in FileSystemQuery
                .From(FTestDirectory) do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(FTotalCount, LPassCount);
  CheckNotEquals(0, LPasscount);
end;

procedure TestFileQuery.TestPassThroughRecursive;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .FromRecursive(FTestDirectory) do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(FTotalRecursiveCount, LPassCount);
  CheckNotEquals(0, LPasscount);
end;

procedure TestFileQuery.TestDirectories;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .From(FTestDirectory)
                .Directories do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(FTopLevelDirCount, LPassCount);
end;

procedure TestFileQuery.TestDirectoriesRecursive;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .FromRecursive(FTestDirectory)
                .Directories do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(FTotalDirCount, LPassCount);
end;

procedure TestFileQuery.TestDirNameMatchesStringQuery;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileSystemQuery
             .From(FTestDirectory)
             .Directories
             .NameMatches(StringQuery.StartsWith('chi')) do
    Inc(LPassCount);

  CheckEquals(1, LPassCount);
end;

procedure TestFileQuery.TestExtension;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .From(FTestDirectory)
                .Extension('.doc') do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(2, LPassCount);
  CheckNotEquals(0, LPasscount);
end;

procedure TestFileQuery.TestExtensionRecursive;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .FromRecursive(FTestDirectory)
                .Extension('.doc') do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(3, LPassCount);
  CheckNotEquals(0, LPasscount);
end;

procedure TestFileQuery.TestFiles;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .From(FTestDirectory)
                .Files do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(FFileCount, LPassCount);
  CheckNotEquals(0, LPasscount);
end;

procedure TestFileQuery.TestFilesNameMatchesStringQuery;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileSystemQuery
             .From(FTestDirectory)
             .Files
             .NameMatches(StringQuery.StartsWith('10')) do
    Inc(LPassCount);

  CheckEquals(1, LPassCount);
end;

procedure TestFileQuery.TestFilesRecursive;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .FromRecursive(FTestDirectory)
                .Files do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(FRecursiveFileCount, LPassCount);
  CheckNotEquals(0, LPasscount);
end;

procedure TestFileQuery.TestHiddenFiles;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .From(FTestDirectory)
                .Files
                .Hidden do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(1, LPassCount);
end;

procedure TestFileQuery.TestLargerThanLarge;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .From(FTestDirectory)
                .Files
                .LargerThan(MaxLongint) do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(0, LPassCount);
end;

procedure TestFileQuery.TestLargerThanLargeRecursive;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .FromRecursive(FTestDirectory)
                .Files
                .LargerThan(MaxLongint) do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(0, LPassCount);
end;

procedure TestFileQuery.TestLargerThanNegative;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .From(FTestDirectory)
                .Files
                .LargerThan(-1) do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(FFileCount, LPassCount);
  CheckNotEquals(0, LPasscount);
end;

procedure TestFileQuery.TestLargerThanNegativeRecursive;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .FromRecursive(FTestDirectory)
                .Files
                .LargerThan(-1) do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(FRecursiveFileCount, LPassCount);
  CheckNotEquals(0, LPasscount);
end;

procedure TestFileQuery.TestLargerThanSmall;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .From(FTestDirectory)
                .Files
                .LargerThan(4) do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(2, LPassCount);
end;

procedure TestFileQuery.TestLargerThanSmallerThan;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .From(FTestDirectory)
                .Files
                .LargerThan(100)
                .SmallerThan(400) do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(2, LPassCount);
end;

procedure TestFileQuery.TestLargerThanSmallerThanRecursive;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .FromRecursive(FTestDirectory)
                .Files
                .LargerThan(100)
                .SmallerThan(400) do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(4, LPassCount);
end;

procedure TestFileQuery.TestLargerThanSmallRecursive;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .FromRecursive(FTestDirectory)
                .Files
                .LargerThan(4) do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(4, LPassCount);
end;

procedure TestFileQuery.TestLargerThanZero;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .From(FTestDirectory)
                .Files
                .LargerThan(0) do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(2, LPassCount);
  CheckNotEquals(0, LPasscount);
end;

procedure TestFileQuery.TestLargerThanZeroRecursive;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .FromRecursive(FTestDirectory)
                .Files
                .LargerThan(0) do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(4, LPassCount);
  CheckNotEquals(0, LPasscount);
end;

procedure TestFileQuery.TestNotHiddenFiles;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .From(FTestDirectory)
                .Files
                .NotHidden do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(FFileCount - 1, LPassCount);
  CheckNotEquals(0, LPasscount);
end;

procedure TestFileQuery.TestNotHiddenNotReadOnlyFiles;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .From(FTestDirectory)
                .Files
                .NotHidden
                .NotReadOnly do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(FFileCount - 2, LPassCount);
  CheckNotEquals(0, LPasscount);
end;

procedure TestFileQuery.TestNotReadOnlyFiles;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .From(FTestDirectory)
                .Files
                .NotReadOnly do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(FFileCount - 1, LPassCount);
  CheckNotEquals(0, LPasscount);
end;

procedure TestFileQuery.TestReadOnlyFiles;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .From(FTestDirectory)
                .Files
                .ReadOnly do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(1, LPassCount);
end;

procedure TestFileQuery.TestSkipEqualCount;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileSystemQuery
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

  for I in FileSystemQuery
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

  for I in FileSystemQuery
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

  for I in FileSystemQuery
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

  for I in FileSystemQuery
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

  for I in FileSystemQuery
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

  for I in FileSystemQuery
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

  for I in FileSystemQuery
            .From(FTestDirectory)
            .Skip(0) do
  begin
    Inc(LPassCount);
    DummyFile := i;   // just to suppress warning about not using I
  end;

  CheckEquals(FTotalCount, LPassCount);
end;

procedure TestFileQuery.TestSmallerThanLarge;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .From(FTestDirectory)
                .Files
                .SmallerThan(MaxLongint) do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(FFileCount, LPassCount);
end;

procedure TestFileQuery.TestSmallerThanLargeRecursive;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .FromRecursive(FTestDirectory)
                .Files
                .SmallerThan(MaxLongint) do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(FRecursiveFileCount, LPassCount);
end;

procedure TestFileQuery.TestSmallerThanNegative;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .From(FTestDirectory)
                .Files
                .SmallerThan(-1) do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(0, LPassCount);
end;

procedure TestFileQuery.TestSmallerThanNegativeRecursive;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .FromRecursive(FTestDirectory)
                .Files
                .SmallerThan(-1) do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(0, LPassCount);
end;

procedure TestFileQuery.TestSmallerThanSmall;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .From(FTestDirectory)
                .Files
                .SmallerThan(4) do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(FFileCount - 2, LPassCount);
end;

procedure TestFileQuery.TestSmallerThanSmallRecursive;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .FromRecursive(FTestDirectory)
                .Files
                .SmallerThan(4) do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(FRecursiveFileCount - 4, LPassCount);
end;

procedure TestFileQuery.TestSmallerThanZero;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .From(FTestDirectory)
                .Files
                .SmallerThan(0) do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(0, LPassCount);
end;

procedure TestFileQuery.TestSmallerThanZeroRecursive;
var
  LPassCount : Integer;
  LFile : string;
begin
  LPassCount := 0;
  for LFile in FileSystemQuery
                .FromRecursive(FTestDirectory)
                .Files
                .SmallerThan(0) do
  begin
    Inc(LPassCount);
    DummyFile := LFile;   // just to suppress warning about not using File
  end;
  CheckEquals(0, LPassCount);
end;

procedure TestFileQuery.TestWhereEven;
var
  LPassCount : Integer;
  I : string;
begin
  LPassCount := 0;

  for I in FileSystemQuery
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

  for I in FileSystemQuery
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

  for I in FileSystemQuery
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

  for I in FileSystemQuery
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

  for I in FileSystemQuery
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

