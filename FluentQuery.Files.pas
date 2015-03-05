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
  { TODO : HasAttribute, whihc is used by IsHidden, IsDirectory etc }
  { TODO : FromRoot(Drive) }
  { TODO : Make this a FileSystemQuery, and add a DriveQuery as well }

  IUnboundFileQuery = interface;

  IBoundFileQuery = interface(IBaseQuery<String>)
    function GetEnumerator: IBoundFileQuery;
    // query operations
    function Map(Transformer : TFunc<String, String>) : IBoundFileQuery;
    function Skip(Count : Integer): IBoundFileQuery;
    function SkipWhile(Predicate : TPredicate<String>) : IBoundFileQuery; overload;
    function SkipWhile(UnboundQuery : IUnboundFileQuery) : IBoundFileQuery; overload;
    function Take(Count : Integer): IBoundFileQuery;
    function TakeWhile(Predicate : TPredicate<String>): IBoundFileQuery; overload;
    function TakeWhile(UnboundQuery : IUnboundFileQuery): IBoundFileQuery; overload;
    function Where(Predicate : TPredicate<String>) : IBoundFileQuery;
    function WhereNot(UnboundQuery : IUnboundFileQuery) : IBoundFileQuery; overload;
    function WhereNot(Predicate : TPredicate<String>) : IBoundFileQuery; overload;
    // type-specific operations
    function NameMatches(const Mask : String) : IBoundFileQuery;
    // terminating operations
    function First : String;
  end;

  IUnboundFileQuery = interface(IBaseQuery<String>)
    function GetEnumerator: IUnboundFileQuery;
    function From(const Directory : string) : IBoundFileQuery;
    // query operations
    function Map(Transformer : TFunc<String, String>) : IUnboundFileQuery;
    function Skip(Count : Integer): IUnboundFileQuery;
    function SkipWhile(Predicate : TPredicate<String>) : IUnboundFileQuery; overload;
    function SkipWhile(UnboundQuery : IUnboundFileQuery) : IUnboundFileQuery; overload;
    function Take(Count : Integer): IUnboundFileQuery;
    function TakeWhile(Predicate : TPredicate<String>): IUnboundFileQuery; overload;
    function TakeWhile(UnboundQuery : IUnboundFileQuery): IUnboundFileQuery; overload;
    function Where(Predicate : TPredicate<String>) : IUnboundFileQuery;
    function WhereNot(UnboundQuery : IUnboundFileQuery) : IUnboundFileQuery; overload;
    function WhereNot(Predicate : TPredicate<String>) : IUnboundFileQuery; overload;
    // type-specific operations
    function NameMatches(const Mask : String) : IUnboundFileQuery;
    // terminating operations
    function Predicate : TPredicate<String>;
  end;


function FileQuery : IUnboundFileQuery;


implementation

uses  FluentQuery.Strings.MethodFactories;

type
  TFileQuery = class(TBaseQuery<String>, IBoundFileQuery, IUnboundFileQuery)
  protected
    type
      TQueryImpl<TReturnType : IBaseQuery<String>> = class
      private
        FQuery : TFileQuery;
      public
        constructor Create(Query : TFileQuery); virtual;
        function GetEnumerator: TReturnType;
{$IFDEF DEBUG}
        function GetOperationName : String;
        function GetOperationPath : String;
        property OperationName : string read GetOperationName;
        property OperationPath : string read GetOperationPath;
{$ENDIF}
        function From(const Directory : string) : IBoundFileQuery;
        // Primitive Operations
        function Map(Transformer : TFunc<String, String>) : TReturnType;
        function SkipWhile(Predicate : TPredicate<String>) : TReturnType; overload;
        function TakeWhile(Predicate : TPredicate<String>): TReturnType; overload;
        function Where(Predicate : TPredicate<String>) : TReturnType;
        // Derivative Operations
        function Skip(Count : Integer): TReturnType;
        function SkipWhile(UnboundQuery : IUnboundFileQuery) : TReturnType; overload;
        function Take(Count : Integer): TReturnType;
        function TakeWhile(UnboundQuery : IUnboundFileQuery): TReturnType; overload;
        function WhereNot(UnboundQuery : IUnboundFileQuery) : TReturnType; overload;
        function WhereNot(Predicate : TPredicate<String>) : TReturnType; overload;
        function NameMatches(const Mask : String) : TReturnType;
        // Terminating Operations
        function Predicate : TPredicate<String>;
        function First : String;
      end;
  protected
    FBoundQuery : TQueryImpl<IBoundFileQuery>;
    FUnboundQuery : TQueryImpl<IUnboundFileQuery>;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<String>;
                       UpstreamQuery : IBaseQuery<String> = nil;
                       SourceData : IMinimalEnumerator<String> = nil); override;
    destructor Destroy; override;
    property BoundQuery : TQueryImpl<IBoundFileQuery>
                                       read FBoundQuery implements IBoundFileQuery;
    property UnboundQuery : TQueryImpl<IUnboundFileQuery>
                                       read FUnboundQuery implements IUnboundFileQuery;
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

  TFileMethodFactory = class(TStringMethodFactory)
  public
    class function NameMatches(const Mask : string) : TPredicate<String>;
  end;




function FileQuery : IUnboundFileQuery;
begin
  Result := TFileQuery.Create(TEnumerationStrategy<String>.Create);
{$IFDEF DEBUG}
  Result.OperationName := 'FileQuery';
{$ENDIF}
end;

{ TQueryEnumerator<String> }

constructor TFileQuery.TQueryImpl<TReturnType>.Create(
  Query: TFileQuery);
begin
  FQuery := Query;
end;

function TFileQuery.TQueryImpl<TReturnType>.First: String;
begin
  if FQuery.MoveNext then
    Result := FQuery.GetCurrent
  else
    raise EEmptyResultSetException.Create('Can''t call First on an empty Result Set');
end;

function TFileQuery.TQueryImpl<TReturnType>.From(const Directory : String): IBoundFileQuery;
var
  EnumeratorWrapper : IMinimalEnumerator<String>;
  LSearchRec : TSearchRec;
  LFileAttrs : Integer;
begin
  LFileAttrs := faReadOnly + faHIdden + faSysFile + faNormal + faTemporary + faCompressed + faEncrypted;
  EnumeratorWrapper := TFilesEnumeratorAdapter.Create(Directory + PathDelim + '*', LFileAttrs) as IMinimalEnumerator<String>;
  Result := TFileQuery.Create(TEnumerationStrategy<String>.Create,
                                       IBaseQuery<String>(FQuery),
                                       EnumeratorWrapper);
{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [Directory]);
{$ENDIF}
end;

function TFileQuery.TQueryImpl<TReturnType>.GetEnumerator: TReturnType;
begin
  Result := FQuery;
end;

{$IFDEF DEBUG}
function TFileQuery.TQueryImpl<TReturnType>.GetOperationName: String;
begin
  Result := FQuery.OperationName;
end;

function TFileQuery.TQueryImpl<TReturnType>.GetOperationPath: String;
begin
  Result := FQuery.OperationPath;
end;
{$ENDIF}

function TFileQuery.TQueryImpl<TReturnType>.Map(
  Transformer: TFunc<String, String>): TReturnType;
begin
  Result := TFileQuery.Create(TIsomorphicTransformEnumerationStrategy<String>.Create(Transformer),
                                          IBaseQuery<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Map(Transformer)';
{$ENDIF}
end;


function TFileQuery.TQueryImpl<TReturnType>.NameMatches(const Mask: String): TReturnType;
begin
  Result := Where(TFileMEthodFactory.NameMatches(Mask));
{$IFDEF DEBUG}
  Result.OperationName := Format('NameMatches(''%s'')', [Mask]);
{$ENDIF}
end;

function TFileQuery.TQueryImpl<TReturnType>.Predicate: TPredicate<String>;
begin
  Result := TFileMethodFactory.QuerySingleValue(FQuery);
end;

function TFileQuery.TQueryImpl<TReturnType>.Skip(Count: Integer): TReturnType;
begin
  Result := SkipWhile(TFileMethodFactory.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Skip(%d)', [Count]);
{$ENDIF}
end;

function TFileQuery.TQueryImpl<TReturnType>.SkipWhile(
  UnboundQuery: IUnboundFileQuery): TReturnType;
begin
  Result := SkipWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('SkipWhile', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TFileQuery.TQueryImpl<TReturnType>.SkipWhile(
  Predicate: TPredicate<String>): TReturnType;
begin
  Result := TFileQuery.Create(TSkipWhileEnumerationStrategy<String>.Create(Predicate),
                                       IBaseQuery<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'SkipWhile(Predicate)';
{$ENDIF}
end;

function TFileQuery.TQueryImpl<TReturnType>.Take(Count: Integer): TReturnType;
begin
  Result := TakeWhile(TFileMethodFactory.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Take(%d)', [Count]);
{$ENDIF}
end;

function TFileQuery.TQueryImpl<TReturnType>.TakeWhile(
  UnboundQuery: IUnboundFileQuery): TReturnType;
begin
  Result := TakeWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('TakeWhile', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TFileQuery.TQueryImpl<TReturnType>.TakeWhile(
  Predicate: TPredicate<String>): TReturnType;
begin
  Result := TFileQuery.Create(TTakeWhileEnumerationStrategy<String>.Create(Predicate),
                                       IBaseQuery<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'TakeWhile(Predicate)';
{$ENDIF}
end;


function TFileQuery.TQueryImpl<TReturnType>.Where(
  Predicate: TPredicate<String>): TReturnType;
begin
  Result := TFileQuery.Create(TWhereEnumerationStrategy<String>.Create(Predicate),
                                       IBaseQuery<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Where(Predicate)';
{$ENDIF}
end;


function TFileQuery.TQueryImpl<TReturnType>.WhereNot(
  UnboundQuery: IUnboundFileQuery): TReturnType;
begin
  Result := WhereNot(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('WhereNot(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TFileQuery.TQueryImpl<TReturnType>.WhereNot(
  Predicate: TPredicate<String>): TReturnType;
begin
  Result := Where(TFileMethodFactory.InvertPredicate(Predicate));
{$IFDEF DEBUG}
  Result.OperationName := 'WhereNot(Predicate)';
{$ENDIF}
end;

{ TQueryEnumerator<String> }

constructor TFileQuery.Create(
  EnumerationStrategy: TEnumerationStrategy<String>;
  UpstreamQuery: IBaseQuery<String>; SourceData: IMinimalEnumerator<String>);
begin
  inherited Create(EnumerationStrategy, UpstreamQuery, SourceData);
  FBoundQuery := TQueryImpl<IBoundFileQuery>.Create(self);
  FUnboundQuery := TQueryImpl<IUnboundFileQuery>.Create(self);
end;

destructor TFileQuery.Destroy;
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

class function TFileMethodFactory.NameMatches(const Mask: string): TPredicate<String>;
begin
  Result := function (CurrentValue : String) : Boolean
            begin
              Result := TPath.MatchesPattern(TPath.GetFilename(CurrentValue), Mask, False);
            end;
end;

end.
