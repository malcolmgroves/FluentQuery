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
unit FluentQuery.DB;

interface
uses
  Data.DB,
  FluentQuery.Core.Types,
  System.SysUtils,
  FluentQuery.Strings,
  FluentQuery.Integers;

type
  TDBRecord = class(TObject)
  private
    FDataset : TDataset;
  public
    constructor Create(Dataset : TDataset); virtual;
    function FieldByName(const FieldName: string): TField;
    procedure Edit;
    procedure Post;
    procedure Cancel;
  end;

  IUnboundDBRecordQuery = interface;

  IBoundDBRecordQuery = interface(IBaseBoundQuery<TDBRecord>)
    function GetEnumerator: IBoundDBRecordQuery;
    // common operations
    function Map(Transformer : TFunc<TDBRecord, TDBRecord>) : IBoundDBRecordQuery;
    function Skip(Count : Integer): IBoundDBRecordQuery;
    function SkipWhile(Predicate : TPredicate<TDBRecord>) : IBoundDBRecordQuery; overload;
    function SkipWhile(UnboundQuery : IUnboundDBRecordQuery) : IBoundDBRecordQuery; overload;
    function Take(Count : Integer): IBoundDBRecordQuery;
    function TakeWhile(Predicate : TPredicate<TDBRecord>): IBoundDBRecordQuery; overload;
    function TakeWhile(UnboundQuery : IUnboundDBRecordQuery): IBoundDBRecordQuery; overload;
    function Where(Predicate : TPredicate<TDBRecord>) : IBoundDBRecordQuery;
    function WhereNot(UnboundQuery : IUnboundDBRecordQuery) : IBoundDBRecordQuery; overload;
    function WhereNot(Predicate : TPredicate<TDBRecord>) : IBoundDBRecordQuery; overload;
    // type-specific operations
    function StringField(const Name : string; Query : IUnboundStringQuery) : IBoundDBRecordQuery; overload;
    function StringField(const Name : string; Predicate : TPredicate<String>) : IBoundDBRecordQuery; overload;
    function IntegerField(const Name : string; Query : IUnboundIntegerQuery) : IBoundDBRecordQuery; overload;
    function IntegerField(const Name : string; Predicate : TPredicate<Integer>) : IBoundDBRecordQuery; overload;
    function Null(const Name : string) : IBoundDBRecordQuery;
    function NotNull(const Name : string) : IBoundDBRecordQuery;
  end;

  IUnboundDBRecordQuery = interface(IBaseUnboundQuery<TDBRecord>)
    function GetEnumerator: IUnboundDBRecordQuery;
    // common operations
    function From(Dataset : TDataset) : IBoundDBRecordQuery; overload;
    function Map(Transformer : TFunc<TDBRecord, TDBRecord>) : IUnboundDBRecordQuery;
    function Skip(Count : Integer): IUnboundDBRecordQuery;
    function SkipWhile(Predicate : TPredicate<TDBRecord>) : IUnboundDBRecordQuery; overload;
    function SkipWhile(UnboundQuery : IUnboundDBRecordQuery) : IUnboundDBRecordQuery; overload;
    function Take(Count : Integer): IUnboundDBRecordQuery;
    function TakeWhile(Predicate : TPredicate<TDBRecord>): IUnboundDBRecordQuery; overload;
    function TakeWhile(UnboundQuery : IUnboundDBRecordQuery): IUnboundDBRecordQuery; overload;
    function Where(Predicate : TPredicate<TDBRecord>) : IUnboundDBRecordQuery;
    function WhereNot(UnboundQuery : IUnboundDBRecordQuery) : IUnboundDBRecordQuery; overload;
    function WhereNot(Predicate : TPredicate<TDBRecord>) : IUnboundDBRecordQuery; overload;
    // type-specific operations
    function StringField(const Name : string; Query : IUnboundStringQuery) : IUnboundDBRecordQuery; overload;
    function StringField(const Name : string; Predicate : TPredicate<String>) : IUnboundDBRecordQuery; overload;
    function IntegerField(const Name : string; Query : IUnboundIntegerQuery) : IUnboundDBRecordQuery; overload;
    function IntegerField(const Name : string; Predicate : TPredicate<Integer>) : IUnboundDBRecordQuery; overload;
    function Null(const Name : string) : IUnboundDBRecordQuery;
    function NotNull(const Name : string) : IUnboundDBRecordQuery;
  end;

  function DBRecordQuery : IUnboundDBRecordQuery;


implementation
uses
  FluentQuery.Core.EnumerationStrategies, FluentQuery.Core.Enumerators,
  FluentQuery.Core.Reduce, FluentQuery.Core.MethodFactories;

type
  TDatasetEnumerator = class(TInterfacedObject, IMinimalEnumerator<TDBRecord>)
  private
    FDataset : TDataset;
    FDBRecord : TDBRecord;
    FFirstTime : Boolean;
  protected
    function MoveNext: Boolean;
    function GetCurrent: TDBRecord;
  public
    constructor Create(Dataset : TDataset);
    destructor Destroy; override;
  end;

  TDBRecordQuery = class(TBaseQuery<TDBRecord>,
                                 IBoundDBRecordQuery,
                                 IUnboundDBRecordQuery)
  protected
    type
      TDBRecordQueryImpl<T : IBaseQuery<TDBRecord>> = class
      private
        FQuery : TDBRecordQuery;
      public
        constructor Create(Query : TDBRecordQuery); virtual;
        function GetEnumerator: T;
{$IFDEF DEBUG}
        function GetOperationName : String;
        function GetOperationPath : String;
        property OperationName : String read GetOperationName;
        property OperationPath : String read GetOperationPath;
{$ENDIF}
        function From(Dataset : TDataset) : IBoundDBRecordQuery; overload;
        // Primitive Operations
        function Map(Transformer : TFunc<TDBRecord, TDBRecord>) : T;
        function SkipWhile(Predicate : TPredicate<TDBRecord>) : T; overload;
        function TakeWhile(Predicate : TPredicate<TDBRecord>): T; overload;
        function Where(Predicate : TPredicate<TDBRecord>) : T;
        // Derivative Operations
        function Skip(Count : Integer): T;
        function SkipWhile(UnboundQuery : IUnboundDBRecordQuery) : T; overload;
        function Take(Count : Integer): T;
        function TakeWhile(UnboundQuery : IUnboundDBRecordQuery): T; overload;
        function WhereNot(UnboundQuery : IUnboundDBRecordQuery) : T; overload;
        function WhereNot(Predicate : TPredicate<TDBRecord>) : T; overload;
        // type-specific operations
        function StringField(const Name : string; Query : IUnboundStringQuery) : T; overload;
        function StringField(const Name : string; Predicate : TPredicate<string>) : T; overload;
        function IntegerField(const Name : string; Query : IUnboundIntegerQuery) : T; overload;
        function IntegerField(const Name : string; Predicate : TPredicate<Integer>) : T; overload;
        function Null(const Name : string) : T;
        function NotNull(const Name : string) : T;
        // Terminating Operations
        function First : TDBRecord;
        function Count : Integer;
        function Predicate : TPredicate<TDBRecord>;
      end;
  protected
    FBoundQuery : TDBRecordQueryImpl<IBoundDBRecordQuery>;
    FUnboundQuery : TDBRecordQueryImpl<IUnboundDBRecordQuery>;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<TDBRecord>;
                       UpstreamQuery : IBaseQuery<TDBRecord> = nil;
                       SourceData : IMinimalEnumerator<TDBRecord> = nil
                       ); override;
    destructor Destroy; override;
    property BoundQuery : TDBRecordQueryImpl<IBoundDBRecordQuery>
                                       read FBoundQuery implements IBoundDBRecordQuery;
    property UnboundQuery : TDBRecordQueryImpl<IUnboundDBRecordQuery>
                                       read FUnboundQuery implements IUnboundDBRecordQuery;
  end;


function DBRecordQuery : IUnboundDBRecordQuery;
begin
  Result := TDBRecordQuery.Create(TEnumerationStrategy<TDBRecord>.Create);
{$IFDEF DEBUG}
  Result.OperationName := 'DBRecordQuery';
{$ENDIF}
end;



{ TDatasetRecord }

procedure TDBRecord.Cancel;
begin
  FDataset.Cancel;
end;

constructor TDBRecord.Create(Dataset: TDataset);
begin
  FDataset := Dataset;
end;

procedure TDBRecord.Edit;
begin
  FDataset.Edit;
end;

function TDBRecord.FieldByName(const FieldName: string): TField;
begin
  if Assigned(FDataset) then
    Result := FDataset.FieldByName(FieldName)
  else
    raise EFluentQueryException.Create('Dataset is nil');
end;


procedure TDBRecord.Post;
begin
  FDataset.Post;
end;

{ TDatasetEnumerator }

constructor TDatasetEnumerator.Create(Dataset: TDataset);
begin
  if Dataset.Active = False then
    raise EFluentQueryException.Create('Dataset not active');
  FDataset := Dataset;
  FDataset.First;
  FFirstTime := True;
  FDBRecord := TDBRecord.Create(FDataset);
end;

destructor TDatasetEnumerator.Destroy;
begin
  FDBRecord.Free;
  inherited;
end;

function TDatasetEnumerator.GetCurrent: TDBRecord;
begin
  Result := FDBRecord;
end;

function TDatasetEnumerator.MoveNext: Boolean;
begin
  if not FFirstTime then
    FDataset.Next
  else
    FFirstTime := False;
  Result := not FDataset.Eof;
end;


{ TDBRecordQuery }

constructor TDBRecordQuery.Create(
  EnumerationStrategy: TEnumerationStrategy<TDBRecord>;
  UpstreamQuery: IBaseQuery<TDBRecord>;
  SourceData: IMinimalEnumerator<TDBRecord>);
begin
  inherited Create(EnumerationStrategy, UpstreamQuery, SourceData);
  FBoundQuery := TDBRecordQueryImpl<IBoundDBRecordQuery>.Create(self);
  FUnboundQuery := TDBRecordQueryImpl<IUnboundDBRecordQuery>.Create(self);
end;

destructor TDBRecordQuery.Destroy;
begin
  FBoundQuery.Free;
  FUnboundQuery.Free;
  inherited;
end;

{ TDBRecordQuery.TDBRecordQueryImpl<T> }

function TDBRecordQuery.TDBRecordQueryImpl<T>.Count: Integer;
begin
  Result := TReducer<TDBRecord,Integer>.Reduce( FQuery,
                                                0,
                                                function(Accumulator : Integer; NextValue : TDBRecord): Integer
                                                begin
                                                  Result := Accumulator + 1;
                                                end);
end;

constructor TDBRecordQuery.TDBRecordQueryImpl<T>.Create(Query: TDBRecordQuery);
begin
  FQuery := Query;
end;

function TDBRecordQuery.TDBRecordQueryImpl<T>.First: TDBRecord;
begin
  if FQuery.MoveNext then
    Result := FQuery.GetCurrent
  else
    raise EEmptyResultSetException.Create('Can''t call First on an empty Result Set');
end;

function TDBRecordQuery.TDBRecordQueryImpl<T>.From(
  Dataset: TDataset): IBoundDBRecordQuery;
var
  EnumeratorAdapter : IMinimalEnumerator<TDBRecord>;
begin
  EnumeratorAdapter := TDatasetEnumerator.Create(Dataset) as IMinimalEnumerator<TDBRecord>;
  Result := TDBRecordQuery.Create(TEnumerationStrategy<TDBRecord>.Create,
                                  IBaseQuery<TDBRecord>(FQuery),
                                  EnumeratorAdapter);
{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [Dataset.Name]);
{$ENDIF}
end;

function TDBRecordQuery.TDBRecordQueryImpl<T>.GetEnumerator: T;
begin
  Result := FQuery;
end;


{$IFDEF DEBUG}
function TDBRecordQuery.TDBRecordQueryImpl<T>.GetOperationName: String;
begin
  Result := FQuery.OperationName;
end;

function TDBRecordQuery.TDBRecordQueryImpl<T>.GetOperationPath: String;
begin
  Result := FQuery.OperationPath;
end;

function TDBRecordQuery.TDBRecordQueryImpl<T>.IntegerField(const Name: string;
  Query: IUnboundIntegerQuery): T;
begin
  Result := IntegerField(Name, Query.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('IntegerField(%s, %s)', [Name, Query.OperationPath]);
{$ENDIF}
end;

function TDBRecordQuery.TDBRecordQueryImpl<T>.IntegerField(const Name: string;
  Predicate: TPredicate<Integer>): T;
var
  LPredicate : TPredicate<TDBRecord>;
begin
  LPredicate := function (Value : TDBRecord) : boolean
                var
                  LField : TField;
                  LQueryPredicate : TPredicate<string>;
                begin
                  Result := False;
                  LField := Value.FieldByName(Name);
                  if Assigned(LField) then
                    if LField.DataType = ftInteger then
                      Result := Predicate(LField.AsInteger);
                end;

  Result := Where(LPredicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('IntegerField(%s, Predicate)', [Name]);
{$ENDIF}
end;

function TDBRecordQuery.TDBRecordQueryImpl<T>.Map(
  Transformer: TFunc<TDBRecord, TDBRecord>): T;
begin
  Result := TDBRecordQuery.Create(TIsomorphicTransformEnumerationStrategy<TDBRecord>.Create(Transformer),
                                          IBaseQuery<TDBRecord>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Map(Transformer)';
{$ENDIF}
end;

function TDBRecordQuery.TDBRecordQueryImpl<T>.NotNull(const Name: string): T;
var
  LPredicate : TPredicate<TDBRecord>;
begin
  LPredicate := function (Value : TDBRecord) : boolean
                var
                  LField : TField;
                  LQueryPredicate : TPredicate<string>;
                begin
                  Result := False;
                  LField := Value.FieldByName(Name);
                  if Assigned(LField) then
                    Result := not LField.IsNull;
                end;

  Result := Where(LPredicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('NotNull(%s)', [Name]);
{$ENDIF}
end;

function TDBRecordQuery.TDBRecordQueryImpl<T>.Null(const Name: string): T;
var
  LPredicate : TPredicate<TDBRecord>;
begin
  LPredicate := function (Value : TDBRecord) : boolean
                var
                  LField : TField;
                  LQueryPredicate : TPredicate<string>;
                begin
                  Result := False;
                  LField := Value.FieldByName(Name);
                  if Assigned(LField) then
                    Result := LField.IsNull;
                end;

  Result := Where(LPredicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('Null(%s)', [Name]);
{$ENDIF}
end;

function TDBRecordQuery.TDBRecordQueryImpl<T>.Predicate: TPredicate<TDBRecord>;
begin
  Result := TMethodFactory<TDBRecord>.QuerySingleValue(FQuery);
end;

function TDBRecordQuery.TDBRecordQueryImpl<T>.Skip(Count: Integer): T;
begin
  Result := SkipWhile(TMethodFactory<TDBRecord>.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Skip(%d)', [Count]);
{$ENDIF}
end;

function TDBRecordQuery.TDBRecordQueryImpl<T>.SkipWhile(
  Predicate: TPredicate<TDBRecord>): T;
begin
  Result := TDBRecordQuery.Create(TSkipWhileEnumerationStrategy<TDBRecord>.Create(Predicate),
                                          IBaseQuery<TDBRecord>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'SkipWhile(Predicate)';
{$ENDIF}
end;

function TDBRecordQuery.TDBRecordQueryImpl<T>.SkipWhile(
  UnboundQuery: IUnboundDBRecordQuery): T;
begin
  Result := SkipWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('SkipWhile(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TDBRecordQuery.TDBRecordQueryImpl<T>.StringField(const Name: string;
  Predicate: TPredicate<string>): T;
var
  LPredicate : TPredicate<TDBRecord>;
begin
  LPredicate := function (Value : TDBRecord) : boolean
                var
                  LField : TField;
                  LQueryPredicate : TPredicate<string>;
                begin
                  Result := False;
                  LField := Value.FieldByName(Name);
                  if Assigned(LField) then
                    if LField.DataType = ftString then
                      Result := Predicate(LField.AsString);
                end;

  Result := Where(LPredicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('StringField(%s, Predicate)', [Name]);
{$ENDIF}
end;

function TDBRecordQuery.TDBRecordQueryImpl<T>.Take(Count: Integer): T;
begin
  Result := TakeWhile(TMethodFactory<TDBRecord>.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Take(%d)', [Count]);
{$ENDIF}
end;

function TDBRecordQuery.TDBRecordQueryImpl<T>.TakeWhile(
  Predicate: TPredicate<TDBRecord>): T;
begin
  Result := TDBRecordQuery.Create(TTakeWhileEnumerationStrategy<TDBRecord>.Create(Predicate),
                                          IBaseQuery<TDBRecord>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'TakeWhile(Predicate)';
{$ENDIF}
end;

function TDBRecordQuery.TDBRecordQueryImpl<T>.TakeWhile(
  UnboundQuery: IUnboundDBRecordQuery): T;
begin
  Result := TakeWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('TakeWhile(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TDBRecordQuery.TDBRecordQueryImpl<T>.StringField(const Name: string;
  Query: IUnboundStringQuery): T;
begin
  Result := StringField(Name, Query.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('StringField(%s, %s)', [Name, Query.OperationPath]);
{$ENDIF}
end;

{$ENDIF}

function TDBRecordQuery.TDBRecordQueryImpl<T>.Where(
  Predicate: TPredicate<TDBRecord>): T;
begin
  Result := TDBRecordQuery.Create(TWhereEnumerationStrategy<TDBRecord>.Create(Predicate),
                                          IBaseQuery<TDBRecord>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Where(Predicate)';
{$ENDIF}
end;

function TDBRecordQuery.TDBRecordQueryImpl<T>.WhereNot(
  UnboundQuery: IUnboundDBRecordQuery): T;
begin
  Result := WhereNot(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('WhereNot(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TDBRecordQuery.TDBRecordQueryImpl<T>.WhereNot(
  Predicate: TPredicate<TDBRecord>): T;
begin
  Result := Where(TMethodFactory<TDBRecord>.Not(Predicate));

{$IFDEF DEBUG}
  Result.OperationName := 'WhereNot(Predicate)';
{$ENDIF}
end;

end.
