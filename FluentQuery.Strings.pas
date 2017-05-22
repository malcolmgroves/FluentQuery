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

unit FluentQuery.Strings;

interface
uses
  FluentQuery.Core.Types,
  System.SysUtils,
  FluentQuery.Core.EnumerationStrategies,
  FluentQuery.Core.Enumerators,
  System.Generics.Collections,
  System.Classes;

type
  IUnboundStringQuery = interface;

  IBoundStringQuery = interface(IBaseBoundQuery<String>)
    function GetEnumerator: IBoundStringQuery;
    // common operations
    function Map(Transformer : TFunc<String, String>) : IBoundStringQuery;
    function Skip(Count : Integer): IBoundStringQuery;
    function SkipWhile(Predicate : TPredicate<String>) : IBoundStringQuery; overload;
    function SkipWhile(UnboundQuery : IUnboundStringQuery) : IBoundStringQuery; overload;
    function Take(Count : Integer): IBoundStringQuery;
    function TakeWhile(Predicate : TPredicate<String>): IBoundStringQuery; overload;
    function TakeWhile(UnboundQuery : IUnboundStringQuery): IBoundStringQuery; overload;
    function Where(Predicate : TPredicate<String>) : IBoundStringQuery;
    function WhereNot(UnboundQuery : IUnboundStringQuery) : IBoundStringQuery; overload;
    function WhereNot(Predicate : TPredicate<String>) : IBoundStringQuery; overload;
    // type-specific operations
    function Equals(const Value : String) : IBoundStringQuery;
    function NotEquals(const Value : String) : IBoundStringQuery;
    function Matches(const Value : String; IgnoreCase : Boolean = True) : IBoundStringQuery;
    function NotMatches(const Value : String; IgnoreCase : Boolean = True) : IBoundStringQuery;
    function Contains(const Value : String; IgnoreCase : Boolean = True) : IBoundStringQuery;
    function StartsWith(const Value : String; IgnoreCase : Boolean = True) : IBoundStringQuery;
    function EndsWith(const Value : String; IgnoreCase : Boolean = True) : IBoundStringQuery;
    function SubString(const StartIndex : Integer) : IBoundStringQuery; overload;
    function SubString(const StartIndex : Integer; Length : Integer) : IBoundStringQuery; overload;
    function Value(const Name : String; IgnoreCase : Boolean = True) : IBoundStringQuery;
    function Values: IBoundStringQuery;
    // terminating operations
    function AsTStrings : TStrings;
  end;

  IUnboundStringQuery = interface(IBaseUnboundQuery<String>)
    function GetEnumerator: IUnboundStringQuery;
    // common operations
    function From(Container : TEnumerable<String>) : IBoundStringQuery; overload;
    function From(Strings : TStrings) : IBoundStringQuery; overload;
    function Map(Transformer : TFunc<String, String>) : IUnboundStringQuery;
    function Skip(Count : Integer): IUnboundStringQuery;
    function SkipWhile(Predicate : TPredicate<String>) : IUnboundStringQuery; overload;
    function SkipWhile(UnboundQuery : IUnboundStringQuery) : IUnboundStringQuery; overload;
    function Take(Count : Integer): IUnboundStringQuery;
    function TakeWhile(Predicate : TPredicate<String>): IUnboundStringQuery; overload;
    function TakeWhile(UnboundQuery : IUnboundStringQuery): IUnboundStringQuery; overload;
    function Where(Predicate : TPredicate<String>) : IUnboundStringQuery;
    function WhereNot(UnboundQuery : IUnboundStringQuery) : IUnboundStringQuery; overload;
    function WhereNot(Predicate : TPredicate<String>) : IUnboundStringQuery; overload;
    // type-specific operations
    function Matches(const Value : String; IgnoreCase : Boolean = True) : IUnboundStringQuery;
    function NotMatches(const Value : String; IgnoreCase : Boolean = True) : IUnboundStringQuery;
    function Equals(const Value : String) : IUnboundStringQuery;
    function NotEquals(const Value : String) : IUnboundStringQuery;
    function Contains(const Value : String; IgnoreCase : Boolean = True) : IUnboundStringQuery;
    function StartsWith(const Value : String; IgnoreCase : Boolean = True) : IUnboundStringQuery;
    function EndsWith(const Value : String; IgnoreCase : Boolean = True) : IUnboundStringQuery;
    function SubString(const StartIndex : Integer) : IUnboundStringQuery; overload;
    function SubString(const StartIndex : Integer; Length : Integer) : IUnboundStringQuery; overload;
    function Value(const Name : String; IgnoreCase : Boolean = True) : IUnboundStringQuery;
    function Values : IUnboundStringQuery;
  end;

  function StringQuery : IUnboundStringQuery;

const
  CaseSensitive = False;
  CaseInsensitive = True;


implementation

uses FluentQuery.Strings.MethodFactories, FluentQuery.Core.Reduce;

type
  TStringQuery = class(TBaseQuery<String>,
                                 IBoundStringQuery,
                                 IUnboundStringQuery)
  protected
    type
      TStringQueryImpl<T : IBaseQuery<String>> = class
      private
        FQuery : TStringQuery;
      public
        constructor Create(Query : TStringQuery); virtual;
        function GetEnumerator: T;
{$IFDEF DEBUG}
        function GetOperationName : String;
        function GetOperationPath : String;
        property OperationName : string read GetOperationName;
        property OperationPath : string read GetOperationPath;
{$ENDIF}
        function From(Container : TEnumerable<String>) : IBoundStringQuery; overload;
        function From(Strings : TStrings) : IBoundStringQuery; overload;
        // Primitive Operations
        function Map(Transformer : TFunc<String, String>) : T;
        function SkipWhile(Predicate : TPredicate<String>) : T; overload;
        function TakeWhile(Predicate : TPredicate<String>): T; overload;
        function Where(Predicate : TPredicate<String>) : T;
        // Derivative Operations
        function Skip(Count : Integer): T;
        function SkipWhile(UnboundQuery : IUnboundStringQuery) : T; overload;
        function Take(Count : Integer): T;
        function TakeWhile(UnboundQuery : IUnboundStringQuery): T; overload;
        function WhereNot(UnboundQuery : IUnboundStringQuery) : T; overload;
        function WhereNot(Predicate : TPredicate<String>) : T; overload;
        function Equals(const Value : String) : T; reintroduce;
        function NotEquals(const Value : String) : T;
        function Matches(const Value : String; IgnoreCase : Boolean = True) : T;
        function NotMatches(const Value : String; IgnoreCase : Boolean = True) : T;
        function Contains(const Value : String; IgnoreCase : Boolean = True) : T;
        function StartsWith(const Value : String; IgnoreCase : Boolean = True) : T;
        function EndsWith(const Value : String; IgnoreCase : Boolean = True) : T;
        function SubString(const StartIndex : Integer) : T; overload;
        function SubString(const StartIndex : Integer; Length : Integer) : T; overload;
        function Value(const Name : String; IgnoreCase : Boolean = True) : T;
        function Values : T;
        // Terminating Operations
        function AsTStrings : TStrings;
        function First : String;
        function Count : Integer;
        function Predicate : TPredicate<string>;
      end;
  protected
    FBoundQuery : TStringQueryImpl<IBoundStringQuery>;
    FUnboundQuery : TStringQueryImpl<IUnboundStringQuery>;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<String>;
                       UpstreamQuery : IBaseQuery<String> = nil;
                       SourceData : IMinimalEnumerator<String> = nil
                       ); override;
    destructor Destroy; override;
    property BoundQuery : TStringQueryImpl<IBoundStringQuery>
                                       read FBoundQuery implements IBoundStringQuery;
    property UnboundQuery : TStringQueryImpl<IUnboundStringQuery>
                                       read FUnboundQuery implements IUnboundStringQuery;
  end;




function StringQuery : IUnboundStringQuery;
begin
  Result := TStringQuery.Create(TEnumerationStrategy<String>.Create);
{$IFDEF DEBUG}
  Result.OperationName := 'StringQuery';
{$ENDIF}
end;


{ TStringQueryEnumerator }

constructor TStringQuery.Create(
  EnumerationStrategy: TEnumerationStrategy<String>;
  UpstreamQuery: IBaseQuery<String>;
  SourceData: IMinimalEnumerator<String>);
begin
  inherited Create(EnumerationStrategy, UpstreamQuery, SourceData);
  FBoundQuery := TStringQueryImpl<IBoundStringQuery>.Create(self);
  FUnboundQuery := TStringQueryImpl<IUnboundStringQuery>.Create(self);
end;


destructor TStringQuery.Destroy;
begin
  FBoundQuery.Free;
  FUnboundQuery.Free;
  inherited;
end;

function TStringQuery.TStringQueryImpl<T>.Contains(
  const Value: String; IgnoreCase: Boolean): T;
begin
  Result := Where(TStringMethodFactory.Contains(Value, IgnoreCase));
{$IFDEF DEBUG}
  Result.OperationName := Format('Contains(''%s'', %s', [Value, IgnoreCase.ToString]);
{$ENDIF}
end;

function TStringQuery.TStringQueryImpl<T>.Count: Integer;
begin
  Result := TReducer<String,Integer>.Reduce(FQuery,
                                            0,
                                            function(Accumulator : Integer; NextValue : String): Integer
                                            begin
                                              Result := Accumulator + 1;
                                            end);
end;

constructor TStringQuery.TStringQueryImpl<T>.Create(Query: TStringQuery);
begin
  FQuery := Query;
end;


function TStringQuery.TStringQueryImpl<T>.EndsWith(const Value: String; IgnoreCase: Boolean): T;
begin
  Result := Where(TStringMethodFactory.EndsWith(Value, IgnoreCase));
{$IFDEF DEBUG}
  Result.OperationName := Format('EndsWith(''%s'', %s', [Value, IgnoreCase.ToString]);
{$ENDIF}
end;

function TStringQuery.TStringQueryImpl<T>.Equals(
  const Value: String): T;
begin
  Result := Matches(Value, False);
{$IFDEF DEBUG}
  Result.OperationName := 'Equals';
{$ENDIF}
end;

function TStringQuery.TStringQueryImpl<T>.First: String;
begin
  if FQuery.MoveNext then
    Result := FQuery.GetCurrent
  else
    raise EEmptyResultSetException.Create('Can''t call First on an empty Result Set');
end;

function TStringQuery.TStringQueryImpl<T>.From(Container: TEnumerable<String>): IBoundStringQuery;
var
  EnumeratorAdapter : IMinimalEnumerator<String>;
begin
  EnumeratorAdapter := TGenericEnumeratorAdapter<String>.Create(Container.GetEnumerator) as IMinimalEnumerator<String>;
  Result := TStringQuery.Create(TEnumerationStrategy<String>.Create,
                                          IBaseQuery<String>(FQuery),
                                          EnumeratorAdapter);
{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [Container.ToString]);
{$ENDIF}
end;

function TStringQuery.TStringQueryImpl<T>.From(Strings: TStrings): IBoundStringQuery;
begin
  Result := TStringQuery.Create(TEnumerationStrategy<String>.Create,
                                          IBaseQuery<String>(FQuery),
                                          TStringsEnumeratorAdapter.Create(Strings.GetEnumerator));
{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [Strings.ToString]);
{$ENDIF}
end;

function TStringQuery.TStringQueryImpl<T>.GetEnumerator: T;
begin
  Result := FQuery;
end;

{$IFDEF DEBUG}
function TStringQuery.TStringQueryImpl<T>.GetOperationName: String;
begin
  Result := FQuery.OperationName;
end;

function TStringQuery.TStringQueryImpl<T>.GetOperationPath: String;
begin
  Result := FQuery.OperationPath;
end;
{$ENDIF}

function TStringQuery.TStringQueryImpl<T>.Map(
  Transformer: TFunc<String, String>): T;
begin
  Result := TStringQuery.Create(TIsomorphicTransformEnumerationStrategy<String>.Create(Transformer),
                                          IBaseQuery<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Map(Transformer)';
{$ENDIF}
end;


function TStringQuery.TStringQueryImpl<T>.Matches(
  const Value: String; IgnoreCase: Boolean): T;
begin
  Result := Where(TStringMethodFactory.Matches(Value, IgnoreCase));
{$IFDEF DEBUG}
  Result.OperationName := Format('Matches(''%s'', %s)', [Value, IgnoreCase.ToString]);
{$ENDIF}
end;

function TStringQuery.TStringQueryImpl<T>.Value(
  const Name: String; IgnoreCase: Boolean): T;
begin
  Result := TStringQuery.Create(
              TIsomorphicTransformEnumerationStrategy<String>.Create(TStringMethodFactory.SubStringAfter('=', -1)),
              TStringQuery.Create(
                TWhereEnumerationStrategy<String>.Create(TStringMethodFactory.StartsWith(Name, IgnoreCase)),
                IBaseQuery<String>(FQuery)));

{$IFDEF DEBUG}
  Result.OperationName := Format('Value(%s, %s)', [Name, IgnoreCase.ToString]);
{$ENDIF}
end;

function TStringQuery.TStringQueryImpl<T>.Values: T;
begin
  Result := TStringQuery.Create(
              TIsomorphicTransformEnumerationStrategy<String>.Create(TStringMethodFactory.SubStringAfter('=', -1)),
              TStringQuery.Create(
                TWhereEnumerationStrategy<String>.Create(TStringMethodFactory.Contains('=', False)),
                IBaseQuery<String>(FQuery)));

{$IFDEF DEBUG}
  Result.OperationName := 'Values';
{$ENDIF}
end;

function TStringQuery.TStringQueryImpl<T>.NotEquals(
  const Value: String): T;
begin
  Result := NotMatches(Value, False);
{$IFDEF DEBUG}
  Result.OperationName := Format('NotEquals(''%s'')', [Value]);
{$ENDIF}
end;

function TStringQuery.TStringQueryImpl<T>.NotMatches(
  const Value: String; IgnoreCase: Boolean): T;
begin
  Result := WhereNot(TStringMethodFactory.Matches(Value, IgnoreCase));
{$IFDEF DEBUG}
  Result.OperationName := Format('NotMatches(''%s'', %s)', [Value, IgnoreCase.ToString]);
{$ENDIF}
end;

function TStringQuery.TStringQueryImpl<T>.Predicate: TPredicate<string>;
begin
  Result := TStringMethodFactory.QuerySingleValue(FQuery);
end;

function TStringQuery.TStringQueryImpl<T>.Skip(Count: Integer): T;
begin
  Result := SkipWhile(TStringMethodFactory.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Skip(%d)', [Count]);
{$ENDIF}
end;

function TStringQuery.TStringQueryImpl<T>.SkipWhile(
  UnboundQuery: IUnboundStringQuery): T;
begin
  Result := SkipWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('SkipWhile(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TStringQuery.TStringQueryImpl<T>.SkipWhile(
  Predicate: TPredicate<String>): T;
begin
  Result := TStringQuery.Create(TSkipWhileEnumerationStrategy<String>.Create(Predicate),
                                          IBaseQuery<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'SkipWhile(Predicate)';
{$ENDIF}
end;

function TStringQuery.TStringQueryImpl<T>.StartsWith(
  const Value: String; IgnoreCase: Boolean): T;
begin
  Result := Where(TStringMethodFactory.StartsWith(Value, IgnoreCase));
{$IFDEF DEBUG}
  Result.OperationName := Format('StartsWith(''%s'', %s)', [Value, IgnoreCase.ToString]);
{$ENDIF}
end;

function TStringQuery.TStringQueryImpl<T>.SubString(
  const StartIndex: Integer): T;
begin
  Result := Map(TStringMethodFactory.SubString(StartIndex, -1));

{$IFDEF DEBUG}
  Result.OperationName := Format('Substring(''%d'')', [StartIndex]);
{$ENDIF}
end;

function TStringQuery.TStringQueryImpl<T>.SubString(
  const StartIndex: Integer; Length: Integer): T;
begin
  Result := Map(TStringMethodFactory.SubString(StartIndex, Length));
{$IFDEF DEBUG}
  Result.OperationName := Format('Substring(''%d'', ''%d'')', [StartIndex, Length]);
{$ENDIF}
end;

function TStringQuery.TStringQueryImpl<T>.Take(Count: Integer): T;
begin
  Result := TakeWhile(TStringMethodFactory.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Take(%d)', [Count]);
{$ENDIF}
end;

function TStringQuery.TStringQueryImpl<T>.TakeWhile(
  UnboundQuery: IUnboundStringQuery): T;
begin
  Result := TakeWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('TakeWhile(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TStringQuery.TStringQueryImpl<T>.TakeWhile(Predicate: TPredicate<String>): T;
begin
  Result := TStringQuery.Create(TTakeWhileEnumerationStrategy<String>.Create(Predicate),
                                          IBaseQuery<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'TakeWhile(Predicate)';
{$ENDIF}
end;

function TStringQuery.TStringQueryImpl<T>.AsTStrings: TStrings;
begin
  Result := TReducer<String,TStrings>.Reduce(FQuery,
                                        TStringList.Create,
                                        function(Accumulator : TStrings; NextValue : String): TStrings
                                        begin
                                          Accumulator.Add(NextValue);
                                          Result := Accumulator;
                                        end);
end;

function TStringQuery.TStringQueryImpl<T>.Where(
  Predicate: TPredicate<String>): T;
begin
  Result := TStringQuery.Create(TWhereEnumerationStrategy<String>.Create(Predicate),
                                          IBaseQuery<String>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Where(Predicate)';
{$ENDIF}
end;

function TStringQuery.TStringQueryImpl<T>.WhereNot(
  UnboundQuery: IUnboundStringQuery): T;
begin
  Result := WhereNot(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('WhereNot(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TStringQuery.TStringQueryImpl<T>.WhereNot(
  Predicate: TPredicate<String>): T;
begin
  Result := Where(TStringMethodFactory.Not(Predicate));

{$IFDEF DEBUG}
  Result.OperationName := 'WhereNot(Predicate)';
{$ENDIF}
end;


end.
