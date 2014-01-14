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
  IUnboundCharQueryEnumerator = interface;
  IBoundCharQueryEnumerator = interface(IBaseQueryEnumerator<Char>)
    function GetEnumerator: IBoundCharQueryEnumerator;
    // common operations
    function First : IBoundCharQueryEnumerator;
    function Skip(Count : Integer): IBoundCharQueryEnumerator;
    function SkipWhile(Predicate : TPredicate<Char>) : IBoundCharQueryEnumerator; overload;
    function SkipWhile(UnboundQuery : IUnboundCharQueryEnumerator) : IBoundCharQueryEnumerator; overload;
    function Take(Count : Integer): IBoundCharQueryEnumerator;
    function TakeWhile(Predicate : TPredicate<Char>): IBoundCharQueryEnumerator; overload;
    function TakeWhile(UnboundQuery : IUnboundCharQueryEnumerator): IBoundCharQueryEnumerator; overload;
    function Where(Predicate : TPredicate<Char>) : IBoundCharQueryEnumerator;
    function WhereNot(UnboundQuery : IUnboundCharQueryEnumerator) : IBoundCharQueryEnumerator; overload;
    function WhereNot(Predicate : TPredicate<Char>) : IBoundCharQueryEnumerator; overload;
    // type-specific operations
    function Equals(const Value : Char) : IBoundCharQueryEnumerator;
    function NotEquals(const Value : Char) : IBoundCharQueryEnumerator;
    function Matches(const Value : Char; IgnoreCase : Boolean = True) : IBoundCharQueryEnumerator;
    function IsControl: IBoundCharQueryEnumerator;
    function IsDigit: IBoundCharQueryEnumerator;
    function IsHighSurrogate: IBoundCharQueryEnumerator;
    function IsInArray(const SomeChars: array of Char): IBoundCharQueryEnumerator;
    function IsLetter: IBoundCharQueryEnumerator;
    function IsLetterOrDigit: IBoundCharQueryEnumerator;
    function IsLower: IBoundCharQueryEnumerator;
    function IsLowSurrogate: IBoundCharQueryEnumerator;
    function IsNumber: IBoundCharQueryEnumerator;
    function IsPunctuation: IBoundCharQueryEnumerator;
    function IsSeparator: IBoundCharQueryEnumerator;
    function IsSurrogate: IBoundCharQueryEnumerator;
    function IsSymbol: IBoundCharQueryEnumerator;
    function IsUpper: IBoundCharQueryEnumerator;
    function IsWhiteSpace: IBoundCharQueryEnumerator;
    // terminating operations
    function ToAString : String;
  end;

  IUnboundCharQueryEnumerator = interface(IBaseQueryEnumerator<Char>)
    function GetEnumerator: IUnboundCharQueryEnumerator;
    // common operations
    function First : IUnboundCharQueryEnumerator;
    function From(StringValue : String) : IBoundCharQueryEnumerator; overload;
    function From(Container : TEnumerable<Char>) : IBoundCharQueryEnumerator; overload;
    function Skip(Count : Integer): IUnboundCharQueryEnumerator;
    function SkipWhile(Predicate : TPredicate<Char>) : IUnboundCharQueryEnumerator; overload;
    function SkipWhile(UnboundQuery : IUnboundCharQueryEnumerator) : IUnboundCharQueryEnumerator; overload;
    function Take(Count : Integer): IUnboundCharQueryEnumerator;
    function TakeWhile(Predicate : TPredicate<Char>): IUnboundCharQueryEnumerator; overload;
    function TakeWhile(UnboundQuery : IUnboundCharQueryEnumerator): IUnboundCharQueryEnumerator; overload;
    function Where(Predicate : TPredicate<Char>) : IUnboundCharQueryEnumerator;
    function WhereNot(UnboundQuery : IUnboundCharQueryEnumerator) : IUnboundCharQueryEnumerator; overload;
    function WhereNot(Predicate : TPredicate<Char>) : IUnboundCharQueryEnumerator; overload;
    // type-specific operations
    function Equals(const Value : Char) : IUnboundCharQueryEnumerator;
    function NotEquals(const Value : Char) : IUnboundCharQueryEnumerator;
    function Matches(const Value : Char; IgnoreCase : Boolean = True) : IUnboundCharQueryEnumerator;
    function IsControl: IUnboundCharQueryEnumerator;
    function IsDigit: IUnboundCharQueryEnumerator;
    function IsHighSurrogate: IUnboundCharQueryEnumerator;
    function IsInArray(const SomeChars: array of Char): IUnboundCharQueryEnumerator;
    function IsLetter: IUnboundCharQueryEnumerator;
    function IsLetterOrDigit: IUnboundCharQueryEnumerator;
    function IsLower: IUnboundCharQueryEnumerator;
    function IsLowSurrogate: IUnboundCharQueryEnumerator;
    function IsNumber: IUnboundCharQueryEnumerator;
    function IsPunctuation: IUnboundCharQueryEnumerator;
    function IsSeparator: IUnboundCharQueryEnumerator;
    function IsSurrogate: IUnboundCharQueryEnumerator;
    function IsSymbol: IUnboundCharQueryEnumerator;
    function IsUpper: IUnboundCharQueryEnumerator;
    function IsWhiteSpace: IUnboundCharQueryEnumerator;
    // terminating operations
    function Predicate : TPredicate<Char>;
  end;

  function Query : IUnboundCharQueryEnumerator;




implementation
uses
  System.Character;

type
  TCharQueryEnumerator = class(TBaseQueryEnumerator<Char>,
                               IBoundCharQueryEnumerator,
                               IUnboundCharQueryEnumerator,
                               IBaseQueryEnumerator<Char>,
                               IMinimalEnumerator<Char>)
  protected
    type
      TCharQueryEnumeratorImpl<TReturnType : IBaseQueryEnumerator<Char>> = class
      private
        FQuery : TCharQueryEnumerator;
      public
        constructor Create(Query : TCharQueryEnumerator); virtual;
        function GetEnumerator: TReturnType;
{$IFDEF DEBUG}
        function GetOperationName : String;
        function GetOperationPath : String;
        property OperationName : string read GetOperationName;
        property OperationPath : string read GetOperationPath;
{$ENDIF}
        function Equals(const Value : Char) : TReturnType; reintroduce;
        function NotEquals(const Value : Char) : TReturnType;
        function First : TReturnType;
        function From(StringValue : String) : IBoundCharQueryEnumerator; overload;
        function From(Collection : TEnumerable<Char>) : IBoundCharQueryEnumerator; overload;
        function Skip(Count : Integer): TReturnType;
        function SkipWhile(Predicate : TPredicate<Char>) : TReturnType; overload;
        function SkipWhile(UnboundQuery : IUnboundCharQueryEnumerator) : TReturnType; overload;
        function Take(Count : Integer): TReturnType;
        function TakeWhile(Predicate : TPredicate<Char>): TReturnType; overload;
        function TakeWhile(UnboundQuery : IUnboundCharQueryEnumerator): TReturnType; overload;
        function Where(Predicate : TPredicate<Char>) : TReturnType;
        function WhereNot(UnboundQuery : IUnboundCharQueryEnumerator) : TReturnType; overload;
        function WhereNot(Predicate : TPredicate<Char>) : TReturnType; overload;
        function Matches(const Value : Char; IgnoreCase : Boolean = True) : TReturnType;
        function IsControl: TReturnType;
        function IsDigit: TReturnType;
        function IsHighSurrogate: TReturnType;
        function IsInArray(const SomeChars: array of Char): TReturnType;
        function IsLetter: TReturnType;
        function IsLetterOrDigit: TReturnType;
        function IsLower: TReturnType;
        function IsLowSurrogate: TReturnType;
        function IsNumber: TReturnType;
        function IsPunctuation: TReturnType;
        function IsSeparator: TReturnType;
        function IsSurrogate: TReturnType;
        function IsSymbol: TReturnType;
        function IsUpper: TReturnType;
        function IsWhiteSpace: TReturnType;
        function Predicate : TPredicate<Char>;
        function ToAString : String;
      end;
  protected
    FBoundCharQueryEnumerator : TCharQueryEnumeratorImpl<IBoundCharQueryEnumerator>;
    FUnboundCharQueryEnumerator : TCharQueryEnumeratorImpl<IUnboundCharQueryEnumerator>;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<Char>;
                       UpstreamQuery : IBaseQueryEnumerator<Char> = nil;
                       SourceData : IMinimalEnumerator<Char> = nil); override;
    destructor Destroy; override;
    property BoundCharQueryEnumerator : TCharQueryEnumeratorImpl<IBoundCharQueryEnumerator>
                                       read FBoundCharQueryEnumerator implements IBoundCharQueryEnumerator;
    property UnboundCharQueryEnumerator : TCharQueryEnumeratorImpl<IUnboundCharQueryEnumerator>
                                       read FUnboundCharQueryEnumerator implements IUnboundCharQueryEnumerator;

  end;


function Query : IUnboundCharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TEnumerationStrategy<Char>.Create);
{$IFDEF DEBUG}
  Result.OperationName := 'Query';
{$ENDIF}
end;


{ TCharQueryEnumerator }

constructor TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.Create(
  Query: TCharQueryEnumerator);
begin
  FQuery := Query;
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.Equals(
  const Value: Char): TReturnType;
begin
  Result := Matches(Value, False);
{$IFDEF DEBUG}
  Result.OperationName := 'Equals';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.First: TReturnType;
begin
  Result := TCharQueryEnumerator.Create(TTakeWhileEnumerationStrategy<Char>.Create(TPredicateFactory<Char>.LessThanOrEqualTo(1)),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'First';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.From(
  Collection: TEnumerable<Char>): IBoundCharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TEnumerationStrategy<Char>.Create,
                                        IBaseQueryEnumerator<Char>(FQuery),
                                        TGenericEnumeratorAdapter<Char>.Create(Collection.GetEnumerator) as IMinimalEnumerator<Char>);
{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [Collection.ToString]);
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.From(
  StringValue: String): IBoundCharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TEnumerationStrategy<Char>.Create,
                                        IBaseQueryEnumerator<Char>(FQuery),
                                        TStringEnumeratorAdapter.Create(StringValue));
{$IFDEF DEBUG}
  Result.OperationName := Format('From(''%s'')', [StringValue]);
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.GetEnumerator: TReturnType;
begin
  Result := FQuery;
end;

{$IFDEF DEBUG}
function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.GetOperationName: String;
begin
  Result := FQuery.OperationName;
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.GetOperationPath: String;
begin
  Result := FQuery.OperationPath;
end;
{$ENDIF}

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.IsControl: TReturnType;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsControl;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'IsControl';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.IsDigit: TReturnType;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsDigit;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'IsDigit';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.IsHighSurrogate: TReturnType;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsHighSurrogate;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'IsHighSurrogate';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.IsInArray(const SomeChars: array of Char): TReturnType;
var
  LMatchesPredicate : TPredicate<Char>;
  LSomeChars : array of Char;
  I : Integer;
begin
  // was getting an "unable to capture symbol" error when capturing SomeChars directly.
  SetLength(LSomeChars, Length(SomeChars));
  for I := Low(SomeChars) to High(SomeChars) do
    LSomeChars[i] := SomeChars[i];

  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsInArray(LSomeChars);
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'IsInArray(SomeChars)';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.IsLetter: TReturnType;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsLetter;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'IsLetter';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.IsLetterOrDigit: TReturnType;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsLetterOrDigit;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'IsLetterOrDigit';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.IsLower: TReturnType;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsLower;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'IsLower';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.IsLowSurrogate: TReturnType;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsLowSurrogate;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'IsLowSurrogate';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.IsNumber: TReturnType;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsNumber;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'IsNumber';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.IsPunctuation: TReturnType;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsPunctuation;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'IsPunctuation';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.IsSeparator: TReturnType;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsSeparator;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'IsSeperator';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.IsSurrogate: TReturnType;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsSurrogate;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'IsSurrogate';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.IsSymbol: TReturnType;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsSymbol;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'IsSymbol';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.IsUpper: TReturnType;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsUpper;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'IsUpper';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.IsWhiteSpace: TReturnType;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsWhiteSpace;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'IsWhitespace';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.Matches(const Value: Char;
  IgnoreCase: Boolean): TReturnType;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                         if IgnoreCase then
                           Result := CurrentValue.ToUpper = Value.ToUpper
                         else
                           Result := CurrentValue = Value;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := Format('Matches(''%s'', %s', [Value, IgnoreCase.ToString]);
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.NotEquals(
  const Value: Char): TReturnType;
var
  LPredicate : TPredicate<Char>;
begin
  LPredicate := function (CurrentValue : Char) : Boolean
                begin
                  Result := CurrentValue <> Value;
                end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := Format('NotEquals(''%s'')', [Value]);
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.Predicate: TPredicate<Char>;
begin
  Result := TPredicateFactory<Char>.QuerySingleValue(FQuery);
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.Skip(Count: Integer): TReturnType;
begin
  Result := TCharQueryEnumerator.Create(TSkipWhileEnumerationStrategy<Char>.Create(TPredicateFactory<Char>.LessThanOrEqualTo(Count)),
                                       IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := Format('Skip(%d)', [Count]);
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.SkipWhile(
  UnboundQuery: IUnboundCharQueryEnumerator): TReturnType;
begin
  Result := SkipWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('SkipWhile', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.SkipWhile(
  Predicate: TPredicate<Char>): TReturnType;
begin
  Result := TCharQueryEnumerator.Create(TSkipWhileEnumerationStrategy<Char>.Create(Predicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'SkipWhile(Predicate)';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.Take(Count: Integer): TReturnType;
begin
  Result := TCharQueryEnumerator.Create(TTakeWhileEnumerationStrategy<Char>.Create(TPredicateFactory<Char>.LessThanOrEqualTo(Count)),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := Format('Take(%d)', [Count]);
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.TakeWhile(
  UnboundQuery: IUnboundCharQueryEnumerator): TReturnType;
begin
  Result := TakeWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('TakeWhile', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.TakeWhile(
  Predicate: TPredicate<Char>): TReturnType;
begin
  Result := TCharQueryEnumerator.Create(TTakeWhileEnumerationStrategy<Char>.Create(Predicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'TakeWhile(Predicate)';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.ToAString: String;
var
  LString : String;
begin
  LString := '';

  while FQuery.MoveNext do
    LString := LString + FQuery.GetCurrent;

  Result := LString;
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.Where(
  Predicate: TPredicate<Char>): TReturnType;
begin
  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(Predicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Where(Predicate)';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.WhereNot(
  Predicate: TPredicate<Char>): TReturnType;
begin
  Result := TCharQueryEnumerator.Create(TWhereNotEnumerationStrategy<Char>.Create(Predicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'WhereNot(Predicate)';
{$ENDIF}
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<TReturnType>.WhereNot(
  UnboundQuery: IUnboundCharQueryEnumerator): TReturnType;
begin
  Result := WhereNot(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('WhereNot(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;



{ TCharQueryEnumerator }

constructor TCharQueryEnumerator.Create(
  EnumerationStrategy: TEnumerationStrategy<Char>;
  UpstreamQuery: IBaseQueryEnumerator<Char>;
  SourceData: IMinimalEnumerator<Char>);
begin
  inherited Create(EnumerationStrategy, UpstreamQuery, SourceData);
  FBoundCharQueryEnumerator := TCharQueryEnumeratorImpl<IBoundCharQueryEnumerator>.Create(self);
  FUnboundCharQueryEnumerator := TCharQueryEnumeratorImpl<IUnboundCharQueryEnumerator>.Create(self);
end;

destructor TCharQueryEnumerator.Destroy;
begin
  FBoundCharQueryEnumerator.Free;
  FUnboundCharQueryEnumerator.Free;
  inherited;
end;

end.
