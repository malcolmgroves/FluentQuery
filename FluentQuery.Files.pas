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

unit FluentQuery.Files;

interface
uses
  FluentQuery.Core.Types,
  System.SysUtils,
  System.Generics.Collections,
  FluentQuery.Core.EnumerationStrategies,
  FluentQuery.Core.Enumerators,
  FluentQuery.Strings,
  IOUtils;

type
  { TODO : add a DriveQuery as well, with operators like IsNetworked, etc }
  { TODO : add FileSystemQuery.FromRoot(Drive) }
  { TODO : Implement Hidden on Posix using . convention }

  IUnboundFileSystemQuery = interface;

  IBoundFileSystemQuery = interface(IBaseBoundQuery<String>)
    function GetEnumerator: IBoundFileSystemQuery;
    // query operations
    function Map(Transformer : TFunc<String, String>) : IBoundFileSystemQuery;
    function Skip(Count : Integer): IBoundFileSystemQuery;
    function SkipWhile(Predicate : TPredicate<String>) : IBoundFileSystemQuery; overload;
    function SkipWhile(UnboundQuery : IUnboundFileSystemQuery) : IBoundFileSystemQuery; overload;
    function Take(Count : Integer): IBoundFileSystemQuery;
    function TakeWhile(Predicate : TPredicate<String>): IBoundFileSystemQuery; overload;
    function TakeWhile(UnboundQuery : IUnboundFileSystemQuery): IBoundFileSystemQuery; overload;
    function Where(Predicate : TPredicate<String>) : IBoundFileSystemQuery;
    function WhereNot(UnboundQuery : IUnboundFileSystemQuery) : IBoundFileSystemQuery; overload;
    function WhereNot(Predicate : TPredicate<String>) : IBoundFileSystemQuery; overload;
    // type-specific operations
    function NameMatches(const Mask : String) : IBoundFileSystemQuery; overload;
    function NameMatches(StringQuery : IUnboundStringQuery) : IBoundFileSystemQuery; overload;
    function Files : IBoundFileSystemQuery;
    function Directories : IBoundFileSystemQuery;
{$IFDEF MSWINDOWS}
    function Hidden : IBoundFileSystemQuery;
    function NotHidden : IBoundFileSystemQuery;
    function ReadOnly : IBoundFileSystemQuery;
    function NotReadOnly : IBoundFileSystemQuery;
    function System : IBoundFileSystemQuery;
    function NotSystem : IBoundFileSystemQuery;
{$ENDIF MSWINDOWS}
    function Extension(const AExtension : string) : IBoundFileSystemQuery;
    function LargerThan(Bytes : Int64) : IBoundFileSystemQuery;
    function SmallerThan(Bytes : Int64) : IBoundFileSystemQuery;
    function CreatedBefore(DateTime : TDateTime) : IBoundFileSystemQuery;
    function CreatedAfter(DateTime : TDateTime) : IBoundFileSystemQuery;
    function ModifiedBefore(DateTime : TDateTime) : IBoundFileSystemQuery;
    function ModifiedAfter(DateTime : TDateTime) : IBoundFileSystemQuery;
    function LastAccessedBefore(DateTime : TDateTime) : IBoundFileSystemQuery;
    function LastAccessedAfter(DateTime : TDateTime) : IBoundFileSystemQuery;
  end;

  IUnboundFileSystemQuery = interface(IBaseUnboundQuery<String>)
//    function GetEnumerator: IUnboundFileSystemQuery;
    function From(const Directory : string) : IBoundFileSystemQuery;
    function FromRecursive(const Directory : string) : IBoundFileSystemQuery;
    // query operations
    function Map(Transformer : TFunc<String, String>) : IUnboundFileSystemQuery;
    function Skip(Count : Integer): IUnboundFileSystemQuery;
    function SkipWhile(Predicate : TPredicate<String>) : IUnboundFileSystemQuery; overload;
    function SkipWhile(UnboundQuery : IUnboundFileSystemQuery) : IUnboundFileSystemQuery; overload;
    function Take(Count : Integer): IUnboundFileSystemQuery;
    function TakeWhile(Predicate : TPredicate<String>): IUnboundFileSystemQuery; overload;
    function TakeWhile(UnboundQuery : IUnboundFileSystemQuery): IUnboundFileSystemQuery; overload;
    function Where(Predicate : TPredicate<String>) : IUnboundFileSystemQuery;
    function WhereNot(UnboundQuery : IUnboundFileSystemQuery) : IUnboundFileSystemQuery; overload;
    function WhereNot(Predicate : TPredicate<String>) : IUnboundFileSystemQuery; overload;
    // type-specific operations
    function NameMatches(const Mask : String) : IUnboundFileSystemQuery; overload;
    function NameMatches(StringQuery : IUnboundStringQuery) : IUnboundFileSystemQuery; overload;
    function Files : IUnboundFileSystemQuery;
    function Directories : IUnboundFileSystemQuery;
{$IFDEF MSWINDOWS}
    function Hidden : IUnboundFileSystemQuery;
    function NotHidden : IUnboundFileSystemQuery;
    function ReadOnly : IUnboundFileSystemQuery;
    function NotReadOnly : IUnboundFileSystemQuery;
    function System : IUnboundFileSystemQuery;
    function NotSystem : IUnboundFileSystemQuery;
{$ENDIF MSWINDOWS}
    function Extension(const AExtension : string) : IUnboundFileSystemQuery;
    function LargerThan(Bytes : Int64) : IUnboundFileSystemQuery;
    function SmallerThan(Bytes : Int64) : IUnboundFileSystemQuery;
    function CreatedBefore(DateTime : TDateTime) : IUnboundFileSystemQuery;
    function CreatedAfter(DateTime : TDateTime) : IUnboundFileSystemQuery;
    function ModifiedBefore(DateTime : TDateTime) : IUnboundFileSystemQuery;
    function ModifiedAfter(DateTime : TDateTime) : IUnboundFileSystemQuery;
    function LastAccessedBefore(DateTime : TDateTime) : IUnboundFileSystemQuery;
    function LastAccessedAfter(DateTime : TDateTime) : IUnboundFileSystemQuery;
  end;


function FileSystemQuery : IUnboundFileSystemQuery;

const
  Kilobyte = 1024;
  Megabyte = 1048576;
  Gigabyte = 1073741824;

implementation

uses  FluentQuery.Strings.MethodFactories, FluentQuery.Core.Reduce;

type
  TFileSystemQuery = class(TBaseQuery<String>, IBoundFileSystemQuery, IUnboundFileSystemQuery)
  protected
    type
      TQueryImpl<TReturnType : IBaseQuery<String>> = class
      private
        FQuery : TFileSystemQuery;
        function HasAttributePredicate(Attributes : TFileAttributes): TPredicate<String>;
        function NameOnlyBeforePredicate(APredicate : TPredicate<string>) : TPredicate<string>;
        function DoFrom(const Directory : string; Recursive : boolean) : IBoundFileSystemQuery;
        function GetSize(const Path : string) : Int64;
        function GetCreationTime(const Path : string) : TDateTime;
        function GetModifiedTime(const Path : string) : TDateTime;
        function GetLastAccessedTime(const Path : string) : TDateTime;
      public
        constructor Create(Query : TFileSystemQuery); virtual;
        function GetEnumerator: TReturnType;
{$IFDEF DEBUG}
        function GetOperationName : String;
        function GetOperationPath : String;
        property OperationName : string read GetOperationName;
        property OperationPath : string read GetOperationPath;
{$ENDIF}
        function From(const Directory : string) : IBoundFileSystemQuery;
        function FromRecursive(const Directory : string) : IBoundFileSystemQuery;
        // Primitive Operations
        function Map(Transformer : TFunc<String, String>) : TReturnType;
        function SkipWhile(Predicate : TPredicate<String>) : TReturnType; overload;
        function TakeWhile(Predicate : TPredicate<String>): TReturnType; overload;
        function Where(Predicate : TPredicate<String>) : TReturnType;
        // Derivative Operations
        function Skip(Count : Integer): TReturnType;
        function SkipWhile(UnboundQuery : IUnboundFileSystemQuery) : TReturnType; overload;
        function Take(Count : Integer): TReturnType;
        function TakeWhile(UnboundQuery : IUnboundFileSystemQuery): TReturnType; overload;
        function WhereNot(UnboundQuery : IUnboundFileSystemQuery) : TReturnType; overload;
        function WhereNot(Predicate : TPredicate<String>) : TReturnType; overload;
        function NameMatches(const Mask : String) : TReturnType; overload;
        function NameMatches(StringQuery : IUnboundStringQuery) : TReturnType; overload;
        function Files : TReturnType;
        function Directories : TReturnType;
{$IFDEF MSWINDOWS}
        function Hidden : TReturnType;
        function NotHidden : TReturnType;
        function ReadOnly : TReturnType;
        function NotReadOnly : TReturnType;
        function System : TReturnType;
        function NotSystem : TReturnType;
{$ENDIF MSWINDOWS}
        function Extension(const AExtension : string) : TReturnType;
        function LargerThan(Bytes : Int64) : TReturnType;
        function SmallerThan(Bytes : Int64) : TReturnType;
        function CreatedBefore(DateTime : TDateTime) : TReturnType;
        function CreatedAfter(DateTime : TDateTime) : TReturnType;
        function ModifiedBefore(DateTime : TDateTime) : TReturnType;
        function ModifiedAfter(DateTime : TDateTime) : TReturnType;
        function LastAccessedBefore(DateTime : TDateTime) : TReturnType;
        function LastAccessedAfter(DateTime : TDateTime) : TReturnType;
        // Terminating Operations
        function Predicate : TPredicate<String>;
        function First : String;
        function Count : Integer;
      end;
  protected
    FBoundQuery : TQueryImpl<IBoundFileSystemQuery>;
    FUnboundQuery : TQueryImpl<IUnboundFileSystemQuery>;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<String>;
                       UpstreamQuery : IBaseQuery<String> = nil;
                       SourceData : IMinimalEnumerator<String> = nil); override;
    destructor Destroy; override;
    property BoundQuery : TQueryImpl<IBoundFileSystemQuery>
                                       read FBoundQuery implements IBoundFileSystemQuery;
    property UnboundQuery : TQueryImpl<IUnboundFileSystemQuery>
                                       read FUnboundQuery implements IUnboundFileSystemQuery;
  end;

  TFileSystemEnumerator = class(TInterfacedObject, IMinimalEnumerator<String>)
  protected
    FPath : string;
    FStarted : boolean;
    FFileAttrs : Integer;
    FSearchRec : TSearchRec;
    function GetCurrent: String; virtual;
    function MoveNext: Boolean; virtual;
    procedure Setup(const Path : string); virtual;
    procedure Teardown; virtual;
  public
    constructor Create(const Path : string; FileAttrs : Integer); virtual;
    destructor Destroy; override;
    property Current: String read GetCurrent;
  end;

  TRecursiveFileSystemEnumerator = class(TFileSystemEnumerator, IMinimalEnumerator<string>)
  private
    FChildDirs : TStack<string>;
    FDirHistory : TList<string>;
    function GetCurrent: String; override;
    function MoveNext: Boolean; override;
  public
    constructor Create(const Path : string; FileAttrs : Integer); override;
    destructor Destroy; override;
  end;


function IsDir(const Path : string) : boolean;
var
  LFileAttributes : TFileAttributes;
begin
  LFileAttributes := TPath.GetAttributes(Path);
  Result := LFileAttributes * [TFileAttribute.faDirectory] <> [];
end;

function IsDots(const Path : string) : boolean;
var
  LFilename : string;
begin
  LFilename := TPath.GetFilename(Path);
  Result := (LFilename = '.') OR (LFilename = '..');
end;


const
  DirValue = 'Directory';
{$IFDEF MSWINDOWS}
  FileAttrs = faReadOnly + faHIdden + faSysFile + faNormal + faTemporary + faCompressed + faEncrypted + faDirectory;
{$ENDIF MSWINDOWS}
{$IFDEF POSIX}
  FileAttrs = faReadOnly + faNormal + faDirectory + faSymLink;
{$ENDIF POSIX}




function FileSystemQuery : IUnboundFileSystemQuery;
begin
  Result := TFileSystemQuery.Create(TEnumerationStrategy<String>.Create);
{$IFDEF DEBUG}
  Result.OperationName := 'FileQuery';
{$ENDIF}
end;

{ TQueryEnumerator<String> }

function TFileSystemQuery.TQueryImpl<TReturnType>.Count: Integer;
begin
  Result := TReducer<String,Integer>.Reduce(FQuery,
                                            0,
                                            function(Accumulator : Integer; NextValue : String): Integer
                                            begin
                                              Result := Accumulator + 1;
                                            end);
end;

constructor TFileSystemQuery.TQueryImpl<TReturnType>.Create(
  Query: TFileSystemQuery);
begin
  FQuery := Query;
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.CreatedAfter(
  DateTime: TDateTime): TReturnType;
var
  LCreatedAfter : TPredicate<string>;
begin
  LCreatedAfter := function (CurrentValue : String) : Boolean
                    begin
                      Result := GetCreationTime(CurrentValue) > DateTime;
                    end;

  Result := Where(LCreatedAfter);
{$IFDEF DEBUG}
  Result.OperationName := Format('CreatedAfter(''%s'')', [DateTimeToStr(DateTime)]);
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.CreatedBefore(
  DateTime: TDateTime): TReturnType;
var
  LCreatedBefore : TPredicate<string>;
begin
  LCreatedBefore := function (CurrentValue : String) : Boolean
                    begin
                      Result := GetCreationTime(CurrentValue) < DateTime;
                    end;

  Result := Where(LCreatedBefore);
{$IFDEF DEBUG}
  Result.OperationName := Format('CreatedBefore(''%s'')', [DateTimeToStr(DateTime)]);
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.Directories: TReturnType;
begin
  Result := Where(HasAttributePredicate([TFileAttribute.faDirectory]));
{$IFDEF DEBUG}
  Result.OperationName := 'Directories';
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.DoFrom(
  const Directory: string; Recursive: boolean): IBoundFileSystemQuery;
var
  EnumeratorWrapper : IMinimalEnumerator<String>;
  LSearchRec : TSearchRec;
  LSkipDotEntries : TPredicate<string>;
begin
  LSkipDotEntries := function(Value : string): boolean
                     begin
                        Result := not IsDots(Value);
                     end;

  if Recursive then
    EnumeratorWrapper := TRecursiveFileSystemEnumerator.Create(Directory, FileAttrs) as IMinimalEnumerator<string>
  else
    EnumeratorWrapper := TFileSystemEnumerator.Create(Directory, FileAttrs) as IMinimalEnumerator<String>;


  Result := TFileSystemQuery.Create(TWhereEnumerationStrategy<String>.Create(LSkipDotEntries),
                                       IBaseQuery<String>(FQuery),
                                       EnumeratorWrapper);
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.Extension(
  const AExtension: string): TReturnType;
var
  LExtensionMatches : TPredicate<string>;
begin
  LExtensionMatches := function (CurrentValue : String) : Boolean
                       var
                         LExtension : string;
                       begin
                         LExtension := TPath.GetExtension(CurrentValue);
                         Result := LExtension.Compare(LExtension, AExtension, True) = 0;
                       end;

  Result := Where(LExtensionMatches);
{$IFDEF DEBUG}
  Result.OperationName := Format('Extension(''%s'')', [AExtension]);
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.Files: TReturnType;
begin
  Result := Where(TStringMethodFactory.Not(HasAttributePredicate([TFileAttribute.faDirectory])));
{$IFDEF DEBUG}
  Result.OperationName := 'Files';
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.First: String;
begin
  if FQuery.MoveNext then
    Result := FQuery.GetCurrent
  else
    raise EEmptyResultSetException.Create('Can''t call First on an empty Result Set');
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.From(const Directory : String): IBoundFileSystemQuery;
begin
  Result := DoFrom(Directory, false);
{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [Directory]);
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.FromRecursive(
  const Directory: string): IBoundFileSystemQuery;
begin
  Result := DoFrom(Directory, true);
{$IFDEF DEBUG}
  Result.OperationName := Format('FromRecursive(%s)', [Directory]);
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.GetCreationTime(
  const Path: string): TDateTime;
begin
  if IsDir(Path) then
    Result := TDirectory.GetCreationTime(Path)
  else
    Result := TFile.GetCreationTime(Path);
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.GetEnumerator: TReturnType;
begin
  Result := FQuery;
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.GetLastAccessedTime(
  const Path: string): TDateTime;
begin
  if IsDir(Path) then
    Result := TDirectory.GetLastAccessTime(Path)
  else
    Result := TFile.GetLastAccessTime(Path);
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.GetModifiedTime(
  const Path: string): TDateTime;
begin
  if IsDir(Path) then
    Result := TDirectory.GetLastWriteTime(Path)
  else
    Result := TFile.GetLastWriteTime(Path);
end;

{$IFDEF DEBUG}
function TFileSystemQuery.TQueryImpl<TReturnType>.GetOperationName: String;
begin
  Result := FQuery.OperationName;
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.GetOperationPath: String;
begin
  Result := FQuery.OperationPath;
end;
function TFileSystemQuery.TQueryImpl<TReturnType>.GetSize(
  const Path: string): Int64;
var
  LSearchRec : TSearchRec;
begin
  try
    if FindFirst(Path, FileAttrs, LSearchRec) = 0 then
      Result := LSearchRec.Size
    else
      Result := -1;
  finally
    FindClose(LSearchRec);
  end;
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.HasAttributePredicate(Attributes: TFileAttributes): TPredicate<String>;
begin
  Result := function (Value : string) : boolean
            var
              LFileAttributes : TFileAttributes;
            begin
              LFileAttributes := TPath.GetAttributes(Value);
              Result := LFileAttributes * Attributes <> [];
            end;
end;

{$IFDEF MSWINDOWS}
function TFileSystemQuery.TQueryImpl<TReturnType>.Hidden: TReturnType;
begin
  Result := Where(HasAttributePredicate([TFileAttribute.faHidden]));
{$IFDEF DEBUG}
  Result.OperationName := 'Hidden';
{$ENDIF}
end;
{$ENDIF MSWINDOWS}

function TFileSystemQuery.TQueryImpl<TReturnType>.LargerThan(
  Bytes: Int64): TReturnType;
var
  LLargerThan : TPredicate<string>;
begin
  LLargerThan := function (CurrentValue : String) : Boolean
                 var
                   LSize : Int64;
                 begin
                   LSize := GetSize(CurrentValue);
                   if LSize >= 0 then
                     Result := LSize > Bytes
                   else
                     Result := false;
                 end;

  Result := Where(LLargerThan);
{$IFDEF DEBUG}
  Result.OperationName := Format('LargerThan(''%d'')', [Bytes]);
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.LastAccessedAfter(
  DateTime: TDateTime): TReturnType;
var
  LLastAccessedAfter : TPredicate<string>;
begin
  LLastAccessedAfter := function (CurrentValue : String) : Boolean
                    begin
                      Result := GetLastAccessedTime(CurrentValue) > DateTime;
                    end;

  Result := Where(LLastAccessedAfter);
{$IFDEF DEBUG}
  Result.OperationName := Format('LastAccessedAfter(''%s'')', [DateTimeToStr(DateTime)]);
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.LastAccessedBefore(
  DateTime: TDateTime): TReturnType;
var
  LLastAccessedBefore : TPredicate<string>;
begin
  LLastAccessedBefore := function (CurrentValue : String) : Boolean
                    begin
                      Result := GetLastAccessedTime(CurrentValue) < DateTime;
                    end;

  Result := Where(LLastAccessedBefore);
{$IFDEF DEBUG}
  Result.OperationName := Format('LastAccessedBefore(''%s'')', [DateTimeToStr(DateTime)]);
{$ENDIF}
end;

{$ENDIF}

function TFileSystemQuery.TQueryImpl<TReturnType>.Map(
  Transformer: TFunc<String, String>): TReturnType;
begin
  Result := TFileSystemQuery.Create(TIsomorphicTransformEnumerationStrategy<String>.Create(Transformer),
                                          IBaseQuery<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Map(Transformer)';
{$ENDIF}
end;


function TFileSystemQuery.TQueryImpl<TReturnType>.ModifiedAfter(
  DateTime: TDateTime): TReturnType;
var
  LModifiedAfter : TPredicate<string>;
begin
  LModifiedAfter := function (CurrentValue : String) : Boolean
                    begin
                      Result := GetModifiedTime(CurrentValue) > DateTime;
                    end;

  Result := Where(LModifiedAfter);
{$IFDEF DEBUG}
  Result.OperationName := Format('ModifiedAfter(''%s'')', [DateTimeToStr(DateTime)]);
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.ModifiedBefore(
  DateTime: TDateTime): TReturnType;
var
  LModifiedBefore : TPredicate<string>;
begin
  LModifiedBefore := function (CurrentValue : String) : Boolean
                    begin
                      Result := GetModifiedTime(CurrentValue) < DateTime;
                    end;

  Result := Where(LModifiedBefore);
{$IFDEF DEBUG}
  Result.OperationName := Format('ModifiedBefore(''%s'')', [DateTimeToStr(DateTime)]);
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.NameMatches(const Mask: String): TReturnType;
var
  LMatches : TPredicate<string>;
begin
  LMatches := function (CurrentValue : String) : Boolean
              begin
                Result := TPath.MatchesPattern(CurrentValue, Mask, False);
              end;

  Result := Where(NameOnlyBeforePredicate(LMatches));
{$IFDEF DEBUG}
  Result.OperationName := Format('NameMatches(''%s'')', [Mask]);
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.NameMatches(
  StringQuery: IUnboundStringQuery): TReturnType;
begin
  Result := Where(NameOnlyBeforePredicate(StringQuery.Predicate));
{$IFDEF DEBUG}
  Result.OperationName := Format('NameMatches(''%s'')', [StringQuery.OperationPath]);
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.NameOnlyBeforePredicate(
  APredicate: TPredicate<string>): TPredicate<string>;
begin
  Result := function (CurrentValue : String) : Boolean
            begin
              Result := APredicate(TPath.GetFilename(CurrentValue));
            end;
end;

{$IFDEF MSWINDOWS}
function TFileSystemQuery.TQueryImpl<TReturnType>.NotHidden: TReturnType;
begin
  Result := Where(TStringMethodFactory.Not(HasAttributePredicate([TFileAttribute.faHidden])));
{$IFDEF DEBUG}
  Result.OperationName := 'NotHidden';
{$ENDIF}
end;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}
function TFileSystemQuery.TQueryImpl<TReturnType>.NotReadOnly: TReturnType;
begin
  Result := Where(TStringMethodFactory.Not(HasAttributePredicate([TFileAttribute.faReadOnly])));
{$IFDEF DEBUG}
  Result.OperationName := 'ReadOnly';
{$ENDIF}
end;
{$ENDIF MSWINDOWS}

{$IFDEF MSWINDOWS}
function TFileSystemQuery.TQueryImpl<TReturnType>.NotSystem: TReturnType;
begin
  Result := Where(TStringMethodFactory.Not(HasAttributePredicate([TFileAttribute.faSystem])));
{$IFDEF DEBUG}
  Result.OperationName := 'NotSystem';
{$ENDIF}
end;
{$ENDIF MSWINDOWS}

function TFileSystemQuery.TQueryImpl<TReturnType>.Predicate: TPredicate<String>;
begin
  Result := TStringMethodFactory.QuerySingleValue(FQuery);
end;

{$IFDEF MSWINDOWS}
function TFileSystemQuery.TQueryImpl<TReturnType>.ReadOnly: TReturnType;
begin
  Result := Where(HasAttributePredicate([TFileAttribute.faReadOnly]));
{$IFDEF DEBUG}
  Result.OperationName := 'ReadOnly';
{$ENDIF}
end;
{$ENDIF MSWINDOWS}

function TFileSystemQuery.TQueryImpl<TReturnType>.Skip(Count: Integer): TReturnType;
begin
  Result := SkipWhile(TStringMethodFactory.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Skip(%d)', [Count]);
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.SkipWhile(
  UnboundQuery: IUnboundFileSystemQuery): TReturnType;
begin
  Result := SkipWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('SkipWhile', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.SmallerThan(
  Bytes: Int64): TReturnType;
var
  LSmallerThan : TPredicate<string>;
begin
  LSmallerThan := function (CurrentValue : String) : Boolean
                  var
                    LSize : Int64;
                  begin
                    LSize := GetSize(CurrentValue);
                    if LSize >= 0 then
                      Result := LSize < Bytes
                    else
                      Result := false;
                  end;

  Result := Where(LSmallerThan);
{$IFDEF DEBUG}
  Result.OperationName := Format('SmallerThan(''%d'')', [Bytes]);
{$ENDIF}
end;

{$IFDEF MSWINDOWS}
function TFileSystemQuery.TQueryImpl<TReturnType>.System: TReturnType;
begin
  Result := Where(HasAttributePredicate([TFileAttribute.faSystem]));
{$IFDEF DEBUG}
  Result.OperationName := 'NotSystem';
{$ENDIF}
end;
{$ENDIF MSWINDOWS}

function TFileSystemQuery.TQueryImpl<TReturnType>.SkipWhile(
  Predicate: TPredicate<String>): TReturnType;
begin
  Result := TFileSystemQuery.Create(TSkipWhileEnumerationStrategy<String>.Create(Predicate),
                                       IBaseQuery<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'SkipWhile(Predicate)';
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.Take(Count: Integer): TReturnType;
begin
  Result := TakeWhile(TStringMethodFactory.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Take(%d)', [Count]);
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.TakeWhile(
  UnboundQuery: IUnboundFileSystemQuery): TReturnType;
begin
  Result := TakeWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('TakeWhile', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.TakeWhile(
  Predicate: TPredicate<String>): TReturnType;
begin
  Result := TFileSystemQuery.Create(TTakeWhileEnumerationStrategy<String>.Create(Predicate),
                                       IBaseQuery<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'TakeWhile(Predicate)';
{$ENDIF}
end;


function TFileSystemQuery.TQueryImpl<TReturnType>.Where(
  Predicate: TPredicate<String>): TReturnType;
begin
  Result := TFileSystemQuery.Create(TWhereEnumerationStrategy<String>.Create(Predicate),
                                       IBaseQuery<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Where(Predicate)';
{$ENDIF}
end;


function TFileSystemQuery.TQueryImpl<TReturnType>.WhereNot(
  UnboundQuery: IUnboundFileSystemQuery): TReturnType;
begin
  Result := WhereNot(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('WhereNot(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.WhereNot(
  Predicate: TPredicate<String>): TReturnType;
begin
  Result := Where(TStringMethodFactory.Not(Predicate));
{$IFDEF DEBUG}
  Result.OperationName := 'WhereNot(Predicate)';
{$ENDIF}
end;

{ TQueryEnumerator<String> }

constructor TFileSystemQuery.Create(
  EnumerationStrategy: TEnumerationStrategy<String>;
  UpstreamQuery: IBaseQuery<String>; SourceData: IMinimalEnumerator<String>);
begin
  inherited Create(EnumerationStrategy, UpstreamQuery, SourceData);
  FBoundQuery := TQueryImpl<IBoundFileSystemQuery>.Create(self);
  FUnboundQuery := TQueryImpl<IUnboundFileSystemQuery>.Create(self);
end;

destructor TFileSystemQuery.Destroy;
begin
  FBoundQuery.Free;
  FUnboundQuery.Free;
  inherited;
end;


{ TFilesEnumeratorAdapter }

constructor TFileSystemEnumerator.Create(const Path: string; FileAttrs : Integer);
begin
  Setup(Path);
  FFileAttrs := FileAttrs;
end;


destructor TFileSystemEnumerator.Destroy;
begin
  Teardown;
  inherited;
end;

function TFileSystemEnumerator.GetCurrent: String;
begin
  Result := FPath + FSearchRec.Name;
end;

function TFileSystemEnumerator.MoveNext: Boolean;
begin
  if not FStarted then
  begin
    FStarted := True;
    Result := FindFirst(FPath + '*', FFileAttrs, FSearchRec) = 0;
  end
  else
    Result := FindNext(FSearchRec) = 0;
end;


procedure TFileSystemEnumerator.Setup(const Path: string);
begin
  FStarted := False;
  FPath := Path + PathDelim;
end;

procedure TFileSystemEnumerator.Teardown;
begin
  FIndCLose(FSearchRec);
end;

{ TRecursiveFileSystemEnumerator }

constructor TRecursiveFileSystemEnumerator.Create(const Path: string;
  FileAttrs: Integer);
begin
  inherited;
  FChildDirs := TStack<string>.Create;
  FDirHistory := TList<string>.Create;
end;

destructor TRecursiveFileSystemEnumerator.Destroy;
begin
  FDirHistory.Free;
  FChildDirs.Free;
  inherited;
end;

function TRecursiveFileSystemEnumerator.GetCurrent: String;
  function NotDots(const Path : string) : boolean;
  var
    LFilename : string;
  begin
    LFilename := TPath.GetFilename(Path);
    Result := not ((LFilename = '.') OR (LFilename = '..'));
  end;
begin
  Result := inherited GetCurrent;
  if IsDir(Result) and not IsDots(Result) then
    if not FDirHistory.Contains(Result) then
    begin
      FDirHistory.Add(Result);
      FChildDirs.Push(Result);
    end;
end;

function TRecursiveFileSystemEnumerator.MoveNext: Boolean;
var
  LNextPath : string;
begin
  Result := inherited MoveNext;
  if not Result then   begin
    if FChildDirs.Count > 0 then
    begin
      LNextPath := FChildDirs.Pop;
      Teardown;
      Setup(LNextPath);
      Result := inherited MoveNext;
    end;
  end;
end;

end.
