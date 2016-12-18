unit FluentQuery.Tests.Base;

interface

uses
  TestFramework,
  FluentQuery.Core.Types,
  System.SysUtils;

type
  TFluentQueryTestCase<T> = class(TTestCase)
  protected
    FTruePredicate : TPredicate<T>;
    FFalsePredicate : TPredicate<T>;
    procedure CheckExpectedCountWithInnerCheck(Query : IMinimalEnumerator<T>; InnerCheck : TPredicate<T>; ExpectedCount : Integer; InnerMsg : String; FormatMsg : string = '');
  public
    constructor Create(MethodName: string; RunCount: Int64); override;
  end;

  TFluentQueryIntegerTestCase = class(TFluentQueryTestCase<Integer>)
  protected
    FEvenNumbers : TPredicate<Integer>;
    FFourOrLess : TPredicate<Integer>;
    FGreaterThanTen : TPredicate<Integer>;
    FInc : TFunc<Integer, Integer>;
  public
    constructor Create(MethodName: string; RunCount: Int64); override;
  end;


implementation

{ TFluentQueryTestCase<T> }

procedure TFluentQueryTestCase<T>.CheckExpectedCountWithInnerCheck(
  Query: IMinimalEnumerator<T>; InnerCheck: TPredicate<T>;
  ExpectedCount: Integer; InnerMsg: string; FormatMsg: string);
var
  LPassCount : Integer;
  LItem : T;
begin
  LPassCount := 0;

  while Query.MoveNext do
  begin
    Inc(LPassCount);
    if assigned(InnerCheck) then
      Check(InnerCheck(Query.Current), 'InnerCheck : ' + InnerMsg);
  end;

  if FormatMsg = '' then
    FormatMsg := 'Query returned %d items, expected %d';

  Check(LPassCount = ExpectedCount, Format(FormatMsg, [LPassCount, ExpectedCount]));
end;


constructor TFluentQueryTestCase<T>.Create(MethodName: string; RunCount: Int64);
begin
  inherited Create(MethodName, RunCount);
  FTruePredicate := function (Arg : T) : Boolean
                    begin
                      Result := True;
                    end;
  FFalsePredicate := function (Arg : T) : Boolean
                     begin
                       Result := False;
                     end;

end;

{ TFluentQueryIntegerTestCase }

constructor TFluentQueryIntegerTestCase.Create(MethodName: string;
  RunCount: Int64);
begin
  inherited;
  FEvenNumbers := function (Value : Integer) : Boolean
                  begin
                    Result := Value mod 2 = 0;
                  end;
  FFourOrLess := function (Value : Integer) : Boolean
                 begin
                   Result := Value <= 4;
                 end;
  FGreaterThanTen := function (Value : Integer) : Boolean
                     begin
                       Result := Value > 10;
                     end;
  FInc := function (Value : Integer) : Integer
          begin
            Result := Value + 1;
          end;
end;

end.
