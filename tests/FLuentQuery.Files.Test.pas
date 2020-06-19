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
  SysUtils,
  FluentQuery.Tests.Base;

type
  TestFileQuery = class(TFluentQueryTestCase<String>)
  strict private
    FTestDirectory : string;
    FFileCount, FRecursiveFileCount : Integer;
    FTopLevelDirCount, FTotalDirCount : Integer;
    FTotalCount, FTotalRecursiveCount : Integer;
    FFirstLetterEven : TPredicate<string>;
    FFirstLetterFourOrLess : TPredicate<string>;
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
    procedure TestStep;
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
    procedure TestCreatedBeforeToday;
    procedure TestCreatedBeforeTomorrow;
    procedure TestCreatedAfterYesterday;
    procedure TestCreatedAfterTomorrow;
    procedure TestModifiedBeforeToday;
    procedure TestModifiedBeforeTomorrow;
    procedure TestModifiedAfterYesterday;
    procedure TestModifiedAfterTomorrow;
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
end;

procedure TestFileQuery.TearDown;
begin
  TDirectory.Delete(FTestDirectory, True);
end;


procedure TestFileQuery.TestTakeEqualCount;
begin
  CheckEquals(FTotalCount, FileSystemQuery.From(FTestDirectory).Take(FTotalCount).Count);
end;

procedure TestFileQuery.TestTakeGreaterThanCount;
begin
  CheckEquals(FTotalCount,  FileSystemQuery.From(FTestDirectory).Take(FTotalCount + 1).Count);
end;

procedure TestFileQuery.TestTakeLowerThanCount;
begin
  CheckEquals(FTotalCount - 1, FileSystemQuery.From(FTestDirectory).Take(FTotalCount - 1).Count);
end;

procedure TestFileQuery.TestTakeOne;
begin
  CheckEquals(1, FileSystemQuery.From(FTestDirectory).Take(1).Count);
end;

procedure TestFileQuery.TestTakeWhere;
begin
  CheckEquals(2, FileSystemQuery.From(FTestDirectory).Take(5).Where(FFirstLetterEven).Count);
end;

procedure TestFileQuery.TestTakeWhile;
begin
  CheckEquals(5, FileSystemQuery.From(FTestDirectory).TakeWhile(FFirstLetterFourOrLess).Count);
end;

procedure TestFileQuery.TestTakeWhileFalse;
begin
  CheckEquals(0, FileSystemQuery.From(FTestDirectory).TakeWhile(FFalsePredicate).Count);
end;

procedure TestFileQuery.TestTakeWhileTrue;
begin
  CheckEquals(FTotalCount, FileSystemQuery.From(FTestDirectory).TakeWhile(FTruePredicate).Count);
end;

procedure TestFileQuery.TestTakeZero;
begin
  CheckEquals(0, FileSystemQuery.From(FTestDirectory).Take(0).Count);
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
begin
  CheckEquals(FTotalCount, FileSystemQuery.From(FTestDirectory).NameMatches('*').Count);
end;

procedure TestFileQuery.TestNameMatchesDir;
begin
  CheckEquals(1, FileSystemQuery.From(FTestDirectory).NameMatches('child*').Count);
end;

procedure TestFileQuery.TestNameMatchesNone;
begin
  CheckEquals(0, FileSystemQuery.From(FTestDirectory).NameMatches('*.blah').Count);
end;

procedure TestFileQuery.TestNameMatchesSome;
begin
  CheckEquals(2, FileSystemQuery.From(FTestDirectory).NameMatches('1*.*').Count);
end;

procedure TestFileQuery.TestWhereNotEven;
begin
  CheckExpectedCountWithInnerCheck(FileSystemQuery
                                     .From(FTestDirectory)
                                     .Files
                                     .WhereNot(FFirstLetterEven),
                                   function (Arg : String) : Boolean
                                   begin
                                     Result := StrToInt(TPath.GetFilename(Arg).Substring(0, 1)) mod 2 <> 0;
                                   end,
                                   6, 'Should enumerate odd numbered items');
end;

procedure TestFileQuery.TestWhereNotWhereEven;
begin
  CheckExpectedCountWithInnerCheck(FileSystemQuery
                                     .From(FTestDirectory)
                                     .Files
                                     .WhereNot(FileSystemQuery.Where(FFirstLetterEven)),
                                   function (Arg : String) : Boolean
                                   begin
                                     Result := StrToInt(TPath.GetFilename(Arg).Substring(0, 1)) mod 2 <> 0;
                                   end,
                                   6, 'Should enumerate odd numbered items');
end;

procedure TestFileQuery.TestPassThrough;
begin
  CheckEquals(FTotalCount, FileSystemQuery.From(FTestDirectory).Count);
end;

procedure TestFileQuery.TestPassThroughRecursive;
begin
  CheckEquals(FTotalRecursiveCount, FileSystemQuery.FromRecursive(FTestDirectory).Count);
end;

procedure TestFileQuery.TestCreatedAfterTomorrow;
begin
  CheckEquals(0, FileSystemQuery.FromRecursive(FTestDirectory).CreatedAfter(Date + 1).Count);
end;

procedure TestFileQuery.TestCreatedAfterYesterday;
begin
  CheckEquals(FTotalRecursiveCount, FileSystemQuery.FromRecursive(FTestDirectory).CreatedAfter(Date - 1).Count);
end;

procedure TestFileQuery.TestCreatedBeforeToday;
begin
  CheckEquals(0, FileSystemQuery
                  .FromRecursive(FTestDirectory)
                  .Files
                  .CreatedBefore(Date)
                  .Count);
end;

procedure TestFileQuery.TestCreatedBeforeTomorrow;
begin
  CheckEquals(FTotalRecursiveCount, FileSystemQuery
                                    .FromRecursive(FTestDirectory)
                                    .CreatedBefore(Date + 1)
                                    .Count);
end;

procedure TestFileQuery.TestDirectories;
begin
  CheckEquals(FTopLevelDirCount, FileSystemQuery
                                  .From(FTestDirectory)
                                  .Directories
                                  .Count);
end;

procedure TestFileQuery.TestDirectoriesRecursive;
begin
  CheckEquals(FTotalDirCount, FileSystemQuery
                              .FromRecursive(FTestDirectory)
                              .Directories
                              .Count);
end;

procedure TestFileQuery.TestDirNameMatchesStringQuery;
begin
  CheckEquals(1, FileSystemQuery
                   .From(FTestDirectory)
                   .Directories
                   .NameMatches(StringQuery.StartsWith('chi')).Count);
end;

procedure TestFileQuery.TestExtension;
begin
  CheckEquals(2, FileSystemQuery
                   .From(FTestDirectory)
                   .Extension('.doc').Count);
end;

procedure TestFileQuery.TestExtensionRecursive;
begin
  CheckEquals(3, FileSystemQuery
                   .FromRecursive(FTestDirectory)
                   .Extension('.doc').Count);
end;

procedure TestFileQuery.TestFiles;
begin
  CheckEquals(FFileCount, FileSystemQuery
                            .From(FTestDirectory)
                            .Files.Count);
end;

procedure TestFileQuery.TestFilesNameMatchesStringQuery;
begin
  CheckEquals(1, FileSystemQuery
                   .From(FTestDirectory)
                   .Files
                   .NameMatches(StringQuery.StartsWith('10')).Count);
end;

procedure TestFileQuery.TestFilesRecursive;
begin
  CheckEquals(FRecursiveFileCount, FileSystemQuery
                                     .FromRecursive(FTestDirectory)
                                     .Files.Count);
end;

procedure TestFileQuery.TestHiddenFiles;
begin
  CheckEquals(1, FileSystemQuery
                   .From(FTestDirectory)
                   .Files
                   .Hidden
                   .Count);
end;

procedure TestFileQuery.TestLargerThanLarge;
begin
  CheckEquals(0, FileSystemQuery
                    .From(FTestDirectory)
                    .Files
                    .LargerThan(MaxLongint)
                    .Count);
end;

procedure TestFileQuery.TestLargerThanLargeRecursive;
begin
  CheckEquals(0, FileSystemQuery
                  .FromRecursive(FTestDirectory)
                  .Files
                  .LargerThan(MaxLongint)
                  .Count);
end;

procedure TestFileQuery.TestLargerThanNegative;
begin
  CheckEquals(FFileCount, FileSystemQuery
                            .From(FTestDirectory)
                            .Files
                            .LargerThan(-1)
                            .Count);
end;

procedure TestFileQuery.TestLargerThanNegativeRecursive;
begin
  CheckEquals(FRecursiveFileCount, FileSystemQuery
                                    .FromRecursive(FTestDirectory)
                                    .Files
                                    .LargerThan(-1)
                                    .Count);
end;

procedure TestFileQuery.TestLargerThanSmall;
begin
  CheckEquals(2, FileSystemQuery
                  .From(FTestDirectory)
                  .Files
                  .LargerThan(4)
                  .Count);
end;

procedure TestFileQuery.TestLargerThanSmallerThan;
begin
  CheckEquals(2, FileSystemQuery
                  .From(FTestDirectory)
                  .Files
                  .LargerThan(100)
                  .SmallerThan(400)
                  .Count);
end;

procedure TestFileQuery.TestLargerThanSmallerThanRecursive;
begin
  CheckEquals(4, FileSystemQuery
                  .FromRecursive(FTestDirectory)
                  .Files
                  .LargerThan(100)
                  .SmallerThan(400)
                  .Count);
end;

procedure TestFileQuery.TestLargerThanSmallRecursive;
begin
  CheckEquals(4, FileSystemQuery
                  .FromRecursive(FTestDirectory)
                  .Files
                  .LargerThan(4)
                  .Count);
end;

procedure TestFileQuery.TestLargerThanZero;
begin
  CheckEquals(2, FileSystemQuery
                  .From(FTestDirectory)
                  .Files
                  .LargerThan(0)
                  .Count);
end;

procedure TestFileQuery.TestLargerThanZeroRecursive;
begin
  CheckEquals(4, FileSystemQuery
                  .FromRecursive(FTestDirectory)
                  .Files
                  .LargerThan(0)
                  .Count);
end;

procedure TestFileQuery.TestModifiedAfterTomorrow;
begin
  CheckEquals(0, FileSystemQuery
                  .FromRecursive(FTestDirectory)
                  .ModifiedAfter(Date + 1)
                  .Count);
end;

procedure TestFileQuery.TestModifiedAfterYesterday;
begin
  CheckEquals(FTotalRecursiveCount, FileSystemQuery
                                      .FromRecursive(FTestDirectory)
                                      .ModifiedAfter(Date - 1)
                                      .Count);
end;

procedure TestFileQuery.TestModifiedBeforeToday;
begin
  CheckEquals(0, FileSystemQuery
                  .FromRecursive(FTestDirectory)
                  .Files
                  .ModifiedBefore(Date)
                  .Count);
end;

procedure TestFileQuery.TestModifiedBeforeTomorrow;
begin
  CheckEquals(FTotalRecursiveCount, FileSystemQuery
                                      .FromRecursive(FTestDirectory)
                                      .ModifiedBefore(Date + 1)
                                      .Count);
end;

procedure TestFileQuery.TestNotHiddenFiles;
begin
  CheckEquals(FFileCount - 1, FileSystemQuery
                                .From(FTestDirectory)
                                .Files
                                .NotHidden
                                .Count);
end;

procedure TestFileQuery.TestNotHiddenNotReadOnlyFiles;
begin
  CheckEquals(FFileCount - 2, FileSystemQuery
                                .From(FTestDirectory)
                                .Files
                                .NotHidden
                                .NotReadOnly
                                .Count);
end;

procedure TestFileQuery.TestNotReadOnlyFiles;
begin
  CheckEquals(FFileCount - 1, FileSystemQuery
                                .From(FTestDirectory)
                                .Files
                                .NotReadOnly
                                .Count);
end;

procedure TestFileQuery.TestReadOnlyFiles;
begin
  CheckEquals(1, FileSystemQuery
                  .From(FTestDirectory)
                  .Files
                  .ReadOnly
                  .Count);
end;

procedure TestFileQuery.TestSkipEqualCount;
begin
  CheckEquals(0, FileSystemQuery
                  .From(FTestDirectory)
                  .Skip(FTotalCount)
                  .Count);
end;

procedure TestFileQuery.TestSkipGreaterThanCount;
begin
  CheckEquals(0, FileSystemQuery
                  .From(FTestDirectory)
                  .Skip(FTotalCount + 2)
                  .Count);
end;

procedure TestFileQuery.TestSkipLowerThanCount;
begin
  CheckEquals(2, FileSystemQuery
                  .From(FTestDirectory)
                  .Skip(FTotalCount - 2)
                  .Count);
end;

procedure TestFileQuery.TestSkipWhere;
begin
  CheckEquals(2, FileSystemQuery
                   .From(FTestDirectory)
                   .Skip(5)
                   .Where(FFirstLetterEven)
                   .Count);
end;

procedure TestFileQuery.TestSkipWhile;
begin
  CheckEquals(6, FileSystemQuery
                  .From(FTestDirectory)
                  .SkipWhile(FFirstLetterFourOrLess)
                  .Count);
end;

procedure TestFileQuery.TestSkipWhileFalse;
begin
  CheckEquals(FTotalCount, FileSystemQuery
                            .From(FTestDirectory)
                            .SkipWhile(FFalsePredicate)
                            .Count);
end;

procedure TestFileQuery.TestSkipWhileTrue;
begin
  CheckEquals(0, FileSystemQuery
                  .From(FTestDirectory)
                  .SkipWhile(FTruePredicate)
                  .Count);
end;

procedure TestFileQuery.TestSkipZero;
begin
  CheckEquals(FTotalCount, FileSystemQuery
                            .From(FTestDirectory)
                            .Skip(0)
                            .Count);
end;

procedure TestFileQuery.TestSmallerThanLarge;
begin
  CheckEquals(FFileCount, FileSystemQuery
                            .From(FTestDirectory)
                            .Files
                            .SmallerThan(MaxLongint)
                            .Count);
end;

procedure TestFileQuery.TestSmallerThanLargeRecursive;
begin
  CheckEquals(FRecursiveFileCount, FileSystemQuery
                                    .FromRecursive(FTestDirectory)
                                    .Files
                                    .SmallerThan(MaxLongint)
                                    .Count);
end;

procedure TestFileQuery.TestSmallerThanNegative;
begin
  CheckEquals(0, FileSystemQuery
                  .From(FTestDirectory)
                  .Files
                  .SmallerThan(-1)
                  .Count);
end;

procedure TestFileQuery.TestSmallerThanNegativeRecursive;
begin
  CheckEquals(0, FileSystemQuery
                  .FromRecursive(FTestDirectory)
                  .Files
                  .SmallerThan(-1)
                  .Count);
end;

procedure TestFileQuery.TestSmallerThanSmall;
begin
  CheckEquals(FFileCount - 2, FileSystemQuery
                                .From(FTestDirectory)
                                .Files
                                .SmallerThan(4)
                                .Count);
end;

procedure TestFileQuery.TestSmallerThanSmallRecursive;
begin
  CheckEquals(FRecursiveFileCount - 4, FileSystemQuery
                                        .FromRecursive(FTestDirectory)
                                        .Files
                                        .SmallerThan(4)
                                        .Count);
end;

procedure TestFileQuery.TestSmallerThanZero;
begin
  CheckEquals(0, FileSystemQuery
                  .From(FTestDirectory)
                  .Files
                  .SmallerThan(0)
                  .Count);
end;

procedure TestFileQuery.TestSmallerThanZeroRecursive;
begin
  CheckEquals(0, FileSystemQuery
                .FromRecursive(FTestDirectory)
                .Files
                .SmallerThan(0)
                .Count);
end;

procedure TestFileQuery.TestStep;
begin
  CheckEquals(4, FileSystemQuery.From(FTestDirectory).Step(3).Count);
end;

procedure TestFileQuery.TestWhereEven;
begin
  CheckEquals(4, FileSystemQuery
                  .From(FTestDirectory)
                  .Where(FFirstLetterEven)
                  .Count);
end;

procedure TestFileQuery.TestWhereAll;
begin
  CheckEquals(FTotalCount, FileSystemQuery
                            .From(FTestDirectory)
                            .Where(FTruePredicate)
                            .Count);
end;

procedure TestFileQuery.TestWhereTake;
begin
  CheckEquals(3, FileSystemQuery
                   .From(FTestDirectory)
                   .Where(FFirstLetterEven)
                   .Take(3)
                   .Count);
end;

procedure TestFileQuery.TestWhereNone;
begin
  CheckEquals(0, FileSystemQuery
                  .From(FTestDirectory)
                  .Where(FFalsePredicate)
                  .Count);
end;

procedure TestFileQuery.TestWhereSkip;
begin
  CheckEquals(1, FileSystemQuery
                   .From(FTestDirectory)
                   .Where(FFirstLetterEven)
                   .Skip(3)
                   .Count);
end;




initialization
  // Register any test cases with the test runner
  RegisterTest('Files', TestFileQuery.Suite);
end.

