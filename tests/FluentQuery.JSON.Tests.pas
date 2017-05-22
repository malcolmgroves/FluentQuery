unit FluentQuery.JSON.Tests;

interface

uses
  TestFramework, FluentQuery.Core.Types, FluentQuery.JSON, SYstem.JSON,
  FireDAC.Comp.Client, FLuentQuery.Tests.Base,  System.SysUtils;

type
  TestTJSONObjectQuery = class(TFluentQueryTestCase<TJSONPair>)
  strict private
    FJSONObject : TJSONObject;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestPassthrough;
    procedure TestWherePredicate;
    procedure TestNumberValue;
    procedure TestValueByName;
    procedure TestStringValue;
//    procedure TestObjectValue;
//    procedure TestArrayValue;
    procedure TestBooleanValue;
    procedure TestNullValue;
  end;

implementation


procedure TestTJSONObjectQuery.SetUp;
var
  LJSON : string;
begin
  LJSON := '{ "name":"John", "age":31, "city":"New York", "alien":false, "priors":null }';
  FJSONObject := TJSONObject.ParseJSONValue(LJSON, True) as TJSONObject;
end;

procedure TestTJSONObjectQuery.TearDown;
begin
  FJSONObject.Free;
end;


procedure TestTJSONObjectQuery.TestBooleanValue;
begin
  CheckEquals(1, JSONPairQuery.From(FJSONObject).BooleanValue.Count);
end;

procedure TestTJSONObjectQuery.TestNullValue;
begin
  CheckEquals(1, JSONPairQuery.From(FJSONObject).NullValue.Count);
end;

procedure TestTJSONObjectQuery.TestNumberValue;
begin
  CheckEquals(1, JSONPairQuery.From(FJSONObject).NumberValue.Count);
end;

procedure TestTJSONObjectQuery.TestPassthrough;
begin
  CheckEquals(5, JSONPairQuery.From(FJSONObject).Count);
end;

procedure TestTJSONObjectQuery.TestStringValue;
begin
  CheckEquals(2, JSONPairQuery.From(FJSONObject).StringValue.Count);
end;

procedure TestTJSONObjectQuery.TestValueByName;
begin
  CheckEquals('age', JSONPairQuery.From(FJSONObject).Value('age').First.JsonString.Value);
end;

procedure TestTJSONObjectQuery.TestWherePredicate;
var
  LIsAgePair : TPredicate<TJSonPair>;
begin
  LIsAgePair := function (Pair : TJsonPair) : Boolean
                begin
                  Result := LowerCase(Pair.JsonString.Value) = 'age';
                end;
  CheckEquals(1, JSONPairQuery.From(FJSONObject).Where(LIsAgePair).Count);
end;

initialization
  // Register any test cases with the test runner
  RegisterTest('JSON', TestTJSONObjectQuery.Suite);
end.

