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
  { TODO : FromRoot(Drive) }
  { TODO : LargerThan, SmallerThan }
  { TODO : CreatedBefore, CreatedAfter, ModifiedBefore, ModifiedAfter }

  IUnboundFileSystemQuery = interface;

  IBoundFileSystemQuery = interface(IBaseQuery<String>)
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
    function Hidden : IBoundFileSystemQuery;
    function NotHidden : IBoundFileSystemQuery;
    function ReadOnly : IBoundFileSystemQuery;
    function NotReadOnly : IBoundFileSystemQuery;
    function System : IBoundFileSystemQuery;
    function NotSystem : IBoundFileSystemQuery;
    // terminating operations
    function First : String;
  end;

  IUnboundFileSystemQuery = interface(IBaseQuery<String>)
    function GetEnumerator: IUnboundFileSystemQuery;
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
    function Hidden : IUnboundFileSystemQuery;
    function NotHidden : IUnboundFileSystemQuery;
    function ReadOnly : IUnboundFileSystemQuery;
    function NotReadOnly : IUnboundFileSystemQuery;
    function Directories : IUnboundFileSystemQuery;
    function System : IUnboundFileSystemQuery;
    function NotSystem : IUnboundFileSystemQuery;
    // terminating operations
    function Predicate : TPredicate<String>;
  end;


function FileSystemQuery : IUnboundFileSystemQuery;


implementation

uses  FluentQuery.Strings.MethodFactories;

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
        function Hidden : TReturnType;
        function NotHidden : TReturnType;
        function ReadOnly : TReturnType;
        function NotReadOnly : TReturnType;
        function Directories : TReturnType;
        function System : TReturnType;
        function NotSystem : TReturnType;
        // Terminating Operations
        function Predicate : TPredicate<String>;
        function First : String;
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


function FileSystemQuery : IUnboundFileSystemQuery;
begin
  Result := TFileSystemQuery.Create(TEnumerationStrategy<String>.Create);
{$IFDEF DEBUG}
  Result.OperationName := 'FileQuery';
{$ENDIF}
end;

{ TQueryEnumerator<String> }

constructor TFileSystemQuery.TQueryImpl<TReturnType>.Create(
  Query: TFileSystemQuery);
begin
  FQuery := Query;
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
  LFileAttrs : Integer;
  LSkipDotEntries : TPredicate<string>;
begin
  LSkipDotEntries := function(Value : string): boolean
                     begin
                        Result := IsDots(Value);
                     end;

  LFileAttrs := faReadOnly + faHIdden + faSysFile + faNormal + faTemporary + faCompressed + faEncrypted + faDirectory;

  if Recursive then
    EnumeratorWrapper := TRecursiveFileSystemEnumerator.Create(Directory, LFileAttrs) as IMinimalEnumerator<string>
  else
    EnumeratorWrapper := TFileSystemEnumerator.Create(Directory, LFileAttrs) as IMinimalEnumerator<String>;


  Result := TFileSystemQuery.Create(TWhereNotEnumerationStrategy<String>.Create(LSkipDotEntries),
                                       IBaseQuery<String>(FQuery),
                                       EnumeratorWrapper);
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.Files: TReturnType;
begin
  Result := Where(TStringMethodFactory.InvertPredicate(HasAttributePredicate([TFileAttribute.faDirectory])));
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

function TFileSystemQuery.TQueryImpl<TReturnType>.GetEnumerator: TReturnType;
begin
  Result := FQuery;
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

function TFileSystemQuery.TQueryImpl<TReturnType>.Hidden: TReturnType;
begin
  Result := Where(HasAttributePredicate([TFileAttribute.faHidden]));
{$IFDEF DEBUG}
  Result.OperationName := 'Hidden';
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

function TFileSystemQuery.TQueryImpl<TReturnType>.NotHidden: TReturnType;
begin
  Result := Where(TStringMethodFactory.InvertPredicate(HasAttributePredicate([TFileAttribute.faHidden])));
{$IFDEF DEBUG}
  Result.OperationName := 'NotHidden';
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.NotReadOnly: TReturnType;
begin
  Result := Where(TStringMethodFactory.InvertPredicate(HasAttributePredicate([TFileAttribute.faReadOnly])));
{$IFDEF DEBUG}
  Result.OperationName := 'ReadOnly';
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.NotSystem: TReturnType;
begin
  Result := Where(TStringMethodFactory.InvertPredicate(HasAttributePredicate([TFileAttribute.faSystem])));
{$IFDEF DEBUG}
  Result.OperationName := 'NotSystem';
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.Predicate: TPredicate<String>;
begin
  Result := TStringMethodFactory.QuerySingleValue(FQuery);
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.ReadOnly: TReturnType;
begin
  Result := Where(HasAttributePredicate([TFileAttribute.faReadOnly]));
{$IFDEF DEBUG}
  Result.OperationName := 'ReadOnly';
{$ENDIF}
end;

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

function TFileSystemQuery.TQueryImpl<TReturnType>.System: TReturnType;
begin
  Result := Where(HasAttributePredicate([TFileAttribute.faSystem]));
{$IFDEF DEBUG}
  Result.OperationName := 'NotSystem';
{$ENDIF}
end;

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
  Result := Where(TStringMethodFactory.InvertPredicate(Predicate));
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
