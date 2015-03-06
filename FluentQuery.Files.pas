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
  IOUtils;

type
  { TODO : FromRoot(Drive) }
  { TODO : add a DriveQuery as well }

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
    function NameMatches(const Mask : String) : IBoundFileSystemQuery;
    function Files : IBoundFileSystemQuery;
    function Directories : IBoundFileSystemQuery;
    function Hidden : IBoundFileSystemQuery;
    function NotHidden : IBoundFileSystemQuery;
    function ReadOnly : IBoundFileSystemQuery;
    function NotReadOnly : IBoundFileSystemQuery;
    // terminating operations
    function First : String;
  end;

  IUnboundFileSystemQuery = interface(IBaseQuery<String>)
    function GetEnumerator: IUnboundFileSystemQuery;
    function From(const Directory : string) : IBoundFileSystemQuery;
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
    function NameMatches(const Mask : String) : IUnboundFileSystemQuery;
    function Files : IUnboundFileSystemQuery;
    function Hidden : IUnboundFileSystemQuery;
    function NotHidden : IUnboundFileSystemQuery;
    function ReadOnly : IUnboundFileSystemQuery;
    function NotReadOnly : IUnboundFileSystemQuery;
    function Directories : IUnboundFileSystemQuery;
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
        function HasAttribute(const Path : string; Attributes : TFileAttributes): boolean;
      protected
        function GetDirectory : string;
        procedure SetDirectory(const Path : string);
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
        function NameMatches(const Mask : String) : TReturnType;
        function Files : TReturnType;
        function Hidden : TReturnType;
        function NotHidden : TReturnType;
        function ReadOnly : TReturnType;
        function NotReadOnly : TReturnType;
        function Directories : TReturnType;
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

  TFilesEnumeratorAdapter = class(TInterfacedObject, IMinimalEnumerator<String>)
  protected
    FPath : string;
    FStarted : boolean;
    FFileAttrs : Integer;
    FSearchRec : TSearchRec;
    function GetCurrent: String;
    function MoveNext: Boolean;
  public
    constructor Create(const Path : string; FileAttrs : Integer); virtual;
    destructor Destroy; override;
    property Current: String read GetCurrent;
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
var
  LIsDir : TPredicate<string>;
begin
  LIsDir := function(Value : string) : Boolean
             begin
               Result := HasAttribute(Value, [TFileAttribute.faDirectory]);
             end;
  Result := Where(LIsDir);
{$IFDEF DEBUG}
  Result.OperationName := 'Directories';
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.Files: TReturnType;
var
  LIsFile : TPredicate<string>;
begin
  LIsFile := function(Value : string) : Boolean
             begin
               Result := not HasAttribute(Value, [TFileAttribute.faDirectory]);
             end;
  Result := Where(LIsFile);
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
var
  EnumeratorWrapper : IMinimalEnumerator<String>;
  LSearchRec : TSearchRec;
  LFileAttrs : Integer;
  LSkipDotEntries : TPredicate<string>;
begin
  SetDirectory(Directory);

  LSkipDotEntries := function(Value : string): boolean
                     begin
                        Result := (Value = '.') OR (Value = '..');
                     end;

  LFileAttrs := faReadOnly + faHIdden + faSysFile + faNormal + faTemporary + faCompressed + faEncrypted + faDirectory;
  EnumeratorWrapper := TFilesEnumeratorAdapter.Create(Directory + PathDelim + '*', LFileAttrs) as IMinimalEnumerator<String>;
  Result := TFileSystemQuery.Create(TWhereNotEnumerationStrategy<String>.Create(LSkipDotEntries),
                                       IBaseQuery<String>(FQuery),
                                       EnumeratorWrapper);

{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [Directory]);
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.GetDirectory: string;
begin
  Result := FQuery.GetValue(DirValue);
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
function TFileSystemQuery.TQueryImpl<TReturnType>.HasAttribute(const Path: string;
  Attributes: TFileAttributes): boolean;
var
  LFileAttributes : TFileAttributes;
begin
  LFileAttributes := TPath.GetAttributes(GetDirectory + PathDelim + Path);
  Result := LFileAttributes * Attributes <> [];
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.Hidden: TReturnType;
var
  LIsHIdden : TPredicate<string>;
begin
  LIsHIdden := function(Value : string) : Boolean
               begin
                 Result := HasAttribute(Value, [TFileAttribute.faHidden]);
               end;
  Result := Where(LIsHIdden);
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

  Result := Where(LMatches);
{$IFDEF DEBUG}
  Result.OperationName := Format('NameMatches(''%s'')', [Mask]);
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.NotHidden: TReturnType;
var
  LNotHIdden : TPredicate<string>;
begin
  LNotHIdden := function(Value : string) : Boolean
                 begin
                   Result := not HasAttribute(Value, [TFileAttribute.faHidden]);
                 end;
  Result := Where(LNotHIdden);
{$IFDEF DEBUG}
  Result.OperationName := 'NotHidden';
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.NotReadOnly: TReturnType;
var
  LIsHIdden : TPredicate<string>;
begin
  LIsHIdden := function(Value : string) : Boolean
               begin
                 Result := not HasAttribute(Value, [TFileAttribute.faReadOnly]);
               end;
  Result := Where(LIsHIdden);
{$IFDEF DEBUG}
  Result.OperationName := 'ReadOnly';
{$ENDIF}
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.Predicate: TPredicate<String>;
begin
  Result := TStringMethodFactory.QuerySingleValue(FQuery);
end;

function TFileSystemQuery.TQueryImpl<TReturnType>.ReadOnly: TReturnType;
var
  LIsHIdden : TPredicate<string>;
begin
  LIsHIdden := function(Value : string) : Boolean
               begin
                 Result := HasAttribute(Value, [TFileAttribute.faReadOnly]);
               end;
  Result := Where(LIsHIdden);
{$IFDEF DEBUG}
  Result.OperationName := 'ReadOnly';
{$ENDIF}
end;

procedure TFileSystemQuery.TQueryImpl<TReturnType>.SetDirectory(const Path: string);
begin
  FQuery.SetValue(DirValue, Path);
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

constructor TFilesEnumeratorAdapter.Create(const Path: string; FileAttrs : Integer);
begin
  FStarted := False;
  FPath := Path;
  FFileAttrs := FileAttrs;
end;


destructor TFilesEnumeratorAdapter.Destroy;
begin
  FIndCLose(FSearchRec);
  inherited;
end;

function TFilesEnumeratorAdapter.GetCurrent: String;
begin
  Result := FSearchRec.Name;
end;

function TFilesEnumeratorAdapter.MoveNext: Boolean;
begin
  if not FStarted then
  begin
    FStarted := True;
    Result := FindFirst(FPath, FFileAttrs, FSearchRec) = 0;
  end
  else
    Result := FindNext(FSearchRec) = 0;
end;


{ TFileMethodFactory }

end.
