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
  System.SysUtils;

type
  TDBRecord = class(TObject)
  private
    FDataset : TDataset;
  public
    constructor Create(Dataset : TDataset); virtual;
    function FieldByName(const FieldName: string): TField;
  end;

  IUnboundDBRecordQuery = interface;

  IBoundDBRecordQuery = interface(IBaseQuery<TDBRecord>)
    function GetEnumerator: IBoundDBRecordQuery;
    // common operations
//    function Map(Transformer : TFunc<TDBRecord, TDBRecord>) : IBoundDBRecordQuery;
//    function Skip(Count : Integer): IBoundDBRecordQuery;
//    function SkipWhile(Predicate : TPredicate<TDBRecord>) : IBoundDBRecordQuery; overload;
//    function SkipWhile(UnboundQuery : IUnboundDBRecordQuery) : IBoundDBRecordQuery; overload;
//    function Take(Count : Integer): IBoundDBRecordQuery;
//    function TakeWhile(Predicate : TPredicate<TDBRecord>): IBoundDBRecordQuery; overload;
//    function TakeWhile(UnboundQuery : IUnboundDBRecordQuery): IBoundDBRecordQuery; overload;
    function Where(Predicate : TPredicate<TDBRecord>) : IBoundDBRecordQuery;
//    function WhereNot(UnboundQuery : IUnboundDBRecordQuery) : IBoundDBRecordQuery; overload;
//    function WhereNot(Predicate : TPredicate<TDBRecord>) : IBoundDBRecordQuery; overload;
    // type-specific operations
    // terminating operations
//    function First : TDBRecord;
//    function Count : Integer;
  end;

  IUnboundDBRecordQuery = interface(IBaseQuery<TDBRecord>)
    function GetEnumerator: IUnboundDBRecordQuery;
    // common operations
    function From(Dataset : TDataset) : IBoundDBRecordQuery; overload;
//    function Map(Transformer : TFunc<TDBRecord, TDBRecord>) : IUnboundDBRecordQuery;
//    function Skip(Count : Integer): IUnboundDBRecordQuery;
//    function SkipWhile(Predicate : TPredicate<TDBRecord>) : IUnboundDBRecordQuery; overload;
//    function SkipWhile(UnboundQuery : IUnboundDBRecordQuery) : IUnboundDBRecordQuery; overload;
//    function Take(Count : Integer): IUnboundDBRecordQuery;
//    function TakeWhile(Predicate : TPredicate<TDBRecord>): IUnboundDBRecordQuery; overload;
//    function TakeWhile(UnboundQuery : IUnboundDBRecordQuery): IUnboundDBRecordQuery; overload;
    function Where(Predicate : TPredicate<TDBRecord>) : IUnboundDBRecordQuery;
//    function WhereNot(UnboundQuery : IUnboundDBRecordQuery) : IUnboundDBRecordQuery; overload;
//    function WhereNot(Predicate : TPredicate<TDBRecord>) : IUnboundDBRecordQuery; overload;
    // type-specific operations
  end;

  function DBRecordQuery : IUnboundDBRecordQuery;


implementation
uses
  FluentQuery.Core.EnumerationStrategies, FluentQuery.Core.Enumerators;

type
  TDatasetEnumerator = class(TInterfacedObject, IMinimalEnumerator<TDBRecord>)
  private
    FDataset : TDataset;
    FDBRecord : TDBRecord;
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
//        function Map(Transformer : TFunc<TDBRecord, TDBRecord>) : T;
//        function SkipWhile(Predicate : TPredicate<TDBRecord>) : T; overload;
//        function TakeWhile(Predicate : TPredicate<TDBRecord>): T; overload;
        function Where(Predicate : TPredicate<TDBRecord>) : T;
        // Derivative Operations
//        function Skip(Count : Integer): T;
//        function SkipWhile(UnboundQuery : IUnboundDBRecordQuery) : T; overload;
//        function Take(Count : Integer): T;
//        function TakeWhile(UnboundQuery : IUnboundDBRecordQuery): T; overload;
//        function WhereNot(UnboundQuery : IUnboundDBRecordQuery) : T; overload;
//        function WhereNot(Predicate : TPredicate<TDBRecord>) : T; overload;
//        function Equals(const Value : TDBRecord) : T; reintroduce;
//        function NotEquals(const Value : TDBRecord) : T;
//        function Matches(const Value : TDBRecord; IgnoreCase : Boolean = True) : T;
//        function NotMatches(const Value : TDBRecord; IgnoreCase : Boolean = True) : T;
//        function Contains(const Value : TDBRecord; IgnoreCase : Boolean = True) : T;
//        function StartsWith(const Value : TDBRecord; IgnoreCase : Boolean = True) : T;
//        function EndsWith(const Value : TDBRecord; IgnoreCase : Boolean = True) : T;
//        function SubString(const StartIndex : Integer) : T; overload;
//        function SubString(const StartIndex : Integer; Length : Integer) : T; overload;
//        function Value(const Name : TDBRecord; IgnoreCase : Boolean = True) : T;
        // Terminating Operations
//        function First : TDBRecord;
//        function Count : Integer;
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

constructor TDBRecord.Create(Dataset: TDataset);
begin
  FDataset := Dataset;
end;

function TDBRecord.FieldByName(const FieldName: string): TField;
begin
  if Assigned(FDataset) then
    Result := FDataset.FieldByName(FieldName)
  else
    raise EFluentQueryException.Create('Dataset is nil');
end;


{ TDatasetEnumerator }

constructor TDatasetEnumerator.Create(Dataset: TDataset);
begin
  if Dataset.Active = False then
    raise EFluentQueryException.Create('Dataset not active');
  FDataset := Dataset;
  FDataset.First;
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
  Result := not FDataset.Eof;
  FDataset.Next;
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

constructor TDBRecordQuery.TDBRecordQueryImpl<T>.Create(Query: TDBRecordQuery);
begin
  FQuery := Query;
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

end.
