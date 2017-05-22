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

unit FluentQuery.Chars;

interface
uses
  FluentQuery.Core.Types,
  System.SysUtils,
  FluentQuery.Core.EnumerationStrategies,
  FluentQuery.Core.Enumerators,
  System.Generics.Collections;

type
  IUnboundCharQuery = interface;
  IBoundCharQuery = interface(IBaseBoundQuery<Char>)
    function GetEnumerator: IBoundCharQuery;
    // Query Operations
    function Equals(const Value : Char) : IBoundCharQuery;
    function IsControl: IBoundCharQuery;
    function IsDigit: IBoundCharQuery;
    function IsHighSurrogate: IBoundCharQuery;
    function IsInArray(const SomeChars: array of Char): IBoundCharQuery;
    function IsLetter: IBoundCharQuery;
    function IsLetterOrDigit: IBoundCharQuery;
    function IsLower: IBoundCharQuery;
    function IsLowSurrogate: IBoundCharQuery;
    function IsNumber: IBoundCharQuery;
    function IsPunctuation: IBoundCharQuery;
    function IsSeparator: IBoundCharQuery;
    function IsSurrogate: IBoundCharQuery;
    function IsSymbol: IBoundCharQuery;
    function IsUpper: IBoundCharQuery;
    function IsWhiteSpace: IBoundCharQuery;
    function IsNotWhiteSpace: IBoundCharQuery;
    function Map(Transformer : TFunc<Char, Char>) : IBoundCharQuery;
    function Matches(const Value : Char; IgnoreCase : Boolean = True) : IBoundCharQuery;
    function NotEquals(const Value : Char) : IBoundCharQuery;
    function NotMatches(const Value : Char; IgnoreCase : Boolean = True) : IBoundCharQuery;
    function Skip(Count : Integer): IBoundCharQuery;
    function SkipWhile(Predicate : TPredicate<Char>) : IBoundCharQuery; overload;
    function SkipWhile(UnboundQuery : IUnboundCharQuery) : IBoundCharQuery; overload;
    function Take(Count : Integer): IBoundCharQuery;
    function TakeWhile(Predicate : TPredicate<Char>): IBoundCharQuery; overload;
    function TakeWhile(UnboundQuery : IUnboundCharQuery): IBoundCharQuery; overload;
    function Where(Predicate : TPredicate<Char>) : IBoundCharQuery;
    function WhereNot(UnboundQuery : IUnboundCharQuery) : IBoundCharQuery; overload;
    function WhereNot(Predicate : TPredicate<Char>) : IBoundCharQuery; overload;
    // terminating operations
    function AsString : String;
  end;

  IUnboundCharQuery = interface(IBaseUnboundQuery<Char>)
    function GetEnumerator: IUnboundCharQuery;
    function From(StringValue : String) : IBoundCharQuery; overload;
    function From(Container : TEnumerable<Char>) : IBoundCharQuery; overload;
    // Query Operations
    function Equals(const Value : Char) : IUnboundCharQuery;
    function IsControl: IUnboundCharQuery;
    function IsDigit: IUnboundCharQuery;
    function IsHighSurrogate: IUnboundCharQuery;
    function IsInArray(const SomeChars: array of Char): IUnboundCharQuery;
    function IsLetter: IUnboundCharQuery;
    function IsLetterOrDigit: IUnboundCharQuery;
    function IsLower: IUnboundCharQuery;
    function IsLowSurrogate: IUnboundCharQuery;
    function IsNumber: IUnboundCharQuery;
    function IsPunctuation: IUnboundCharQuery;
    function IsSeparator: IUnboundCharQuery;
    function IsSurrogate: IUnboundCharQuery;
    function IsSymbol: IUnboundCharQuery;
    function IsUpper: IUnboundCharQuery;
    function IsWhiteSpace: IUnboundCharQuery;
    function IsNotWhiteSpace: IUnboundCharQuery;
    function Map(Transformer : TFunc<Char, Char>) : IUnboundCharQuery;
    function Matches(const Value : Char; IgnoreCase : Boolean = True) : IUnboundCharQuery;
    function NotEquals(const Value : Char) : IUnboundCharQuery;
    function NotMatches(const Value : Char; IgnoreCase : Boolean = True) : IUnboundCharQuery;
    function Skip(Count : Integer): IUnboundCharQuery;
    function SkipWhile(Predicate : TPredicate<Char>) : IUnboundCharQuery; overload;
    function SkipWhile(UnboundQuery : IUnboundCharQuery) : IUnboundCharQuery; overload;
    function Take(Count : Integer): IUnboundCharQuery;
    function TakeWhile(Predicate : TPredicate<Char>): IUnboundCharQuery; overload;
    function TakeWhile(UnboundQuery : IUnboundCharQuery): IUnboundCharQuery; overload;
    function Where(Predicate : TPredicate<Char>) : IUnboundCharQuery;
    function WhereNot(UnboundQuery : IUnboundCharQuery) : IUnboundCharQuery; overload;
    function WhereNot(Predicate : TPredicate<Char>) : IUnboundCharQuery; overload;
  end;

  function CharQuery : IUnboundCharQuery;




implementation

uses System.Character, FluentQuery.Core.MethodFactories, FluentQuery.Core.Reduce;

type
  TCharQuery = class(TBaseQuery<Char>,
                               IBoundCharQuery,
                               IUnboundCharQuery)
  protected
    type
      TCharQueryImpl<T : IBaseQuery<Char>> = class
      private
        FQuery : TCharQuery;
      public
        constructor Create(Query : TCharQuery); virtual;
        function GetEnumerator: T;
{$IFDEF DEBUG}
        function GetOperationName : String;
        function GetOperationPath : String;
        property OperationName : string read GetOperationName;
        property OperationPath : string read GetOperationPath;
{$ENDIF}
        function From(StringValue : String) : IBoundCharQuery; overload;
        function From(Collection : TEnumerable<Char>) : IBoundCharQuery; overload;
        // Primitive Operations
        function Map(Transformer : TFunc<Char, Char>) : T;
        function SkipWhile(Predicate : TPredicate<Char>) : T; overload;
        function TakeWhile(Predicate : TPredicate<Char>): T; overload;
        function Where(Predicate : TPredicate<Char>) : T;
        // Derivative Operations
        function Equals(const Value : Char) : T; reintroduce;
        function NotEquals(const Value : Char) : T;
        function Skip(Count : Integer): T;
        function SkipWhile(UnboundQuery : IUnboundCharQuery) : T; overload;
        function Take(Count : Integer): T;
        function TakeWhile(UnboundQuery : IUnboundCharQuery): T; overload;
        function WhereNot(UnboundQuery : IUnboundCharQuery) : T; overload;
        function WhereNot(Predicate : TPredicate<Char>) : T; overload;
        function Matches(const Value : Char; IgnoreCase : Boolean = True) : T;
        function NotMatches(const Value : Char; IgnoreCase : Boolean = True) : T;
        function IsControl: T;
        function IsDigit: T;
        function IsHighSurrogate: T;
        function IsInArray(const SomeChars: array of Char): T;
        function IsLetter: T;
        function IsLetterOrDigit: T;
        function IsLower: T;
        function IsLowSurrogate: T;
        function IsNumber: T;
        function IsPunctuation: T;
        function IsSeparator: T;
        function IsSurrogate: T;
        function IsSymbol: T;
        function IsUpper: T;
        function IsWhiteSpace: T;
        function IsNotWhiteSpace: T;
        // Terminating Operations
        function Predicate : TPredicate<Char>;
        function AsString : String;
        function First : Char;
        function Count : Integer;
      end;
  protected
    FBoundQuery : TCharQueryImpl<IBoundCharQuery>;
    FUnboundQuery : TCharQueryImpl<IUnboundCharQuery>;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<Char>;
                       UpstreamQuery : IBaseQuery<Char> = nil;
                       SourceData : IMinimalEnumerator<Char> = nil); override;
    destructor Destroy; override;
    property BoundQuery : TCharQueryImpl<IBoundCharQuery>
                                       read FBoundQuery implements IBoundCharQuery;
    property UnboundQuery : TCharQueryImpl<IUnboundCharQuery>
                                       read FUnboundQuery implements IUnboundCharQuery;

  end;

  TCharPredicateFactory = class(TMethodFactory<Char>)
  public
    class function Matches(const AChar : Char; IgnoreCase : Boolean) : TPredicate<Char>;
  end;


function CharQuery : IUnboundCharQuery;
begin
  Result := TCharQuery.Create(TEnumerationStrategy<Char>.Create);
{$IFDEF DEBUG}
  Result.OperationName := 'CharQuery';
{$ENDIF}
end;

{ TCharQueryEnumerator }

function TCharQuery.TCharQueryImpl<T>.Count: Integer;
begin
  Result := TReducer<Char,Integer>.Reduce(FQuery,
                                          0,
                                          function(Accumulator : Integer; NextValue : Char): Integer
                                          begin
                                            Result := Accumulator + 1;
                                          end);
end;

constructor TCharQuery.TCharQueryImpl<T>.Create(
  Query: TCharQuery);
begin
  FQuery := Query;
end;

function TCharQuery.TCharQueryImpl<T>.Equals(
  const Value: Char): T;
begin
  Result := Matches(Value, False);
{$IFDEF DEBUG}
  Result.OperationName := 'Equals';
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.First: Char;
begin
  if FQuery.MoveNext then
    Result := FQuery.GetCurrent
  else
    raise EEmptyResultSetException.Create('Can''t call First on an empty Result Set');
end;

function TCharQuery.TCharQueryImpl<T>.From(
  Collection: TEnumerable<Char>): IBoundCharQuery;
begin
  Result := TCharQuery.Create(TEnumerationStrategy<Char>.Create,
                                        IBaseQuery<Char>(FQuery),
                                        TGenericEnumeratorAdapter<Char>.Create(Collection.GetEnumerator) as IMinimalEnumerator<Char>);
{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [Collection.ToString]);
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.From(
  StringValue: String): IBoundCharQuery;
begin
  Result := TCharQuery.Create(TEnumerationStrategy<Char>.Create,
                                        IBaseQuery<Char>(FQuery),
                                        TStringEnumeratorAdapter.Create(StringValue));
{$IFDEF DEBUG}
  Result.OperationName := Format('From(''%s'')', [StringValue]);
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.GetEnumerator: T;
begin
  Result := FQuery;
end;

{$IFDEF DEBUG}
function TCharQuery.TCharQueryImpl<T>.GetOperationName: String;
begin
  Result := FQuery.OperationName;
end;

function TCharQuery.TCharQueryImpl<T>.GetOperationPath: String;
begin
  Result := FQuery.OperationPath;
end;
{$ENDIF}

function TCharQuery.TCharQueryImpl<T>.IsControl: T;
var
  LIsControl : TPredicate<char>;
begin
  LIsControl := function (CurrentValue : Char) : Boolean
                 begin
                   Result := CurrentValue.IsControl;
                 end;

  Result := Where(LIsControl);
{$IFDEF DEBUG}
  Result.OperationName := 'IsControl';
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.IsDigit: T;
var
  LPredicate : TPredicate<char>;
begin
  LPredicate := function (CurrentValue : Char) : Boolean
                begin
                  Result := CurrentValue.IsDigit;
                end;

  Result := Where(LPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsDigit';
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.IsHighSurrogate: T;
var
  LPredicate : TPredicate<char>;
begin
  LPredicate := function (CurrentValue : Char) : Boolean
                begin
                  Result := CurrentValue.IsHighSurrogate;
                end;

  Result := Where(LPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsHighSurrogate';
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.IsInArray(const SomeChars: array of Char): T;
var
  LPredicate : TPredicate<char>;
  LSomeChars : array of Char;
  LIndex : Integer;
begin
  SetLength(LSomeChars, Length(SomeChars));
  for LIndex := Low(SomeChars) to High(SomeChars) do
    LSomeChars[LIndex] := SomeChars[LIndex];
  LPredicate := function (CurrentValue : Char) : Boolean
                begin
                  Result := CurrentValue.IsInArray(LSomeChars);
                end;

  Result := Where(LPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsInArray(SomeChars)';
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.IsLetter: T;
var
  LPredicate : TPredicate<char>;
begin
  LPredicate := function (CurrentValue : Char) : Boolean
                begin
                  Result := CurrentValue.IsLetter;
                end;

  Result := Where(LPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsLetter';
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.IsLetterOrDigit: T;
var
  LPredicate : TPredicate<char>;
begin
  LPredicate := function (CurrentValue : Char) : Boolean
                begin
                  Result := CurrentValue.IsLetterOrDigit;
                end;

  Result := Where(LPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsLetterOrDigit';
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.IsLower: T;
var
  LPredicate : TPredicate<char>;
begin
  LPredicate := function (CurrentValue : Char) : Boolean
                begin
                  Result := CurrentValue.IsLower;
                end;

  Result := Where(LPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsLower';
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.IsLowSurrogate: T;
var
  LPredicate : TPredicate<char>;
begin
  LPredicate := function (CurrentValue : Char) : Boolean
                begin
                  Result := CurrentValue.IsLowSurrogate;
                end;

  Result := Where(LPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsLowSurrogate';
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.IsNotWhiteSpace: T;
var
  LPredicate : TPredicate<char>;
begin
  LPredicate := function (CurrentValue : Char) : Boolean
                begin
                  Result := not CurrentValue.IsWhiteSpace;
                end;

  Result := Where(LPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsNotWhitespace';
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.IsNumber: T;
var
  LPredicate : TPredicate<char>;
begin
  LPredicate := function (CurrentValue : Char) : Boolean
                begin
                  Result := CurrentValue.IsNumber;
                end;

  Result := Where(LPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsNumber';
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.IsPunctuation: T;
var
  LPredicate : TPredicate<char>;
begin
  LPredicate := function (CurrentValue : Char) : Boolean
                begin
                  Result := CurrentValue.IsPunctuation;
                end;

  Result := Where(LPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsPunctuation';
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.IsSeparator: T;
var
  LPredicate : TPredicate<char>;
begin
  LPredicate := function (CurrentValue : Char) : Boolean
                begin
                  Result := CurrentValue.IsSeparator;
                end;

  Result := Where(LPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsSeparator';
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.IsSurrogate: T;
var
  LPredicate : TPredicate<char>;
begin
  LPredicate := function (CurrentValue : Char) : Boolean
                begin
                  Result := CurrentValue.IsSurrogate;
                end;

  Result := Where(LPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsSurrogate';
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.IsSymbol: T;
var
  LPredicate : TPredicate<char>;
begin
  LPredicate := function (CurrentValue : Char) : Boolean
                begin
                  Result := CurrentValue.IsSymbol;
                end;

  Result := Where(LPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsSymbol';
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.IsUpper: T;
var
  LPredicate : TPredicate<char>;
begin
  LPredicate := function (CurrentValue : Char) : Boolean
                begin
                  Result := CurrentValue.IsUpper;
                end;

  Result := Where(LPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsUpper';
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.IsWhiteSpace: T;
var
  LPredicate : TPredicate<char>;
begin
  LPredicate := function (CurrentValue : Char) : Boolean
                begin
                  Result := CurrentValue.IsWhiteSpace;
                end;

  Result := Where(LPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsWhitespace';
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.Map(
  Transformer: TFunc<Char, Char>): T;
begin
  Result := TCharQuery.Create(TIsomorphicTransformEnumerationStrategy<Char>.Create(Transformer),
                                        IBaseQuery<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Map(Transformer)';
{$ENDIF}
end;


function TCharQuery.TCharQueryImpl<T>.Matches(const Value: Char;
  IgnoreCase: Boolean): T;
begin
  Result := Where(TCharPredicateFactory.Matches(Value, IgnoreCase));
{$IFDEF DEBUG}
  Result.OperationName := Format('Matches(''%s'', %s', [Value, IgnoreCase.ToString]);
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.NotEquals(
  const Value: Char): T;
begin
  Result := NotMatches(Value, False);
{$IFDEF DEBUG}
  Result.OperationName := Format('NotEquals(''%s'')', [Value]);
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.NotMatches(
  const Value: Char; IgnoreCase: Boolean): T;
begin
  Result := WhereNot(TCharPredicateFactory.Matches(Value, IgnoreCase));
{$IFDEF DEBUG}
  Result.OperationName := Format('NotMatches(''%s'', %s', [Value, IgnoreCase.ToString]);
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.Predicate: TPredicate<Char>;
begin
  Result := TCharPredicateFactory.QuerySingleValue(FQuery);
end;

function TCharQuery.TCharQueryImpl<T>.Skip(Count: Integer): T;
begin
  Result := SkipWhile(TCharPredicateFactory.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Skip(%d)', [Count]);
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.SkipWhile(
  UnboundQuery: IUnboundCharQuery): T;
begin
  Result := SkipWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('SkipWhile', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.SkipWhile(
  Predicate: TPredicate<Char>): T;
begin
  Result := TCharQuery.Create(TSkipWhileEnumerationStrategy<Char>.Create(Predicate),
                                        IBaseQuery<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'SkipWhile(Predicate)';
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.Take(Count: Integer): T;
begin
  Result := TakeWhile(TCharPredicateFactory.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Take(%d)', [Count]);
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.TakeWhile(
  UnboundQuery: IUnboundCharQuery): T;
begin
  Result := TakeWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('TakeWhile', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.TakeWhile(
  Predicate: TPredicate<Char>): T;
begin
  Result := TCharQuery.Create(TTakeWhileEnumerationStrategy<Char>.Create(Predicate),
                                        IBaseQuery<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'TakeWhile(Predicate)';
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.AsString: String;
begin
  Result := TReducer<Char,String>.Reduce(FQuery,
                                         '',
                                         function(Accumulator : String; NextValue : Char): String
                                         begin
                                           Result := Accumulator + NextValue;
                                         end);
end;

function TCharQuery.TCharQueryImpl<T>.Where(
  Predicate: TPredicate<Char>): T;
begin
  Result := TCharQuery.Create(TWhereEnumerationStrategy<Char>.Create(Predicate),
                                        IBaseQuery<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Where(Predicate)';
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.WhereNot(
  Predicate: TPredicate<Char>): T;
begin
  Result := Where(TCharPredicateFactory.Not(Predicate));
{$IFDEF DEBUG}
  Result.OperationName := 'WhereNot(Predicate)';
{$ENDIF}
end;

function TCharQuery.TCharQueryImpl<T>.WhereNot(
  UnboundQuery: IUnboundCharQuery): T;
begin
  Result := WhereNot(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('WhereNot(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;



{ TCharQueryEnumerator }

constructor TCharQuery.Create(
  EnumerationStrategy: TEnumerationStrategy<Char>;
  UpstreamQuery: IBaseQuery<Char>;
  SourceData: IMinimalEnumerator<Char>);
begin
  inherited Create(EnumerationStrategy, UpstreamQuery, SourceData);
  FBoundQuery := TCharQueryImpl<IBoundCharQuery>.Create(self);
  FUnboundQuery := TCharQueryImpl<IUnboundCharQuery>.Create(self);
end;

destructor TCharQuery.Destroy;
begin
  FBoundQuery.Free;
  FUnboundQuery.Free;
  inherited;
end;

{ TCharPredicateFactory }

class function TCharPredicateFactory.Matches(const AChar: Char;
  IgnoreCase: Boolean): TPredicate<Char>;
begin
  Result := function (Value : Char) : Boolean
            begin
            if IgnoreCase then
              Result := Value.ToUpper = AChar.ToUpper
            else
              Result := Value = AChar;
            end;
end;

end.
