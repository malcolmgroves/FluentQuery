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
    procedure TestJSONNumber;
    procedure TestJSONNumberByName;
    procedure TestNamed;
    procedure TestJSONString;
    procedure TestJSONStringByName;
    procedure TestJSONObject;
    procedure TestDescendIntoNamedJSONObject;
    procedure TestJSONStringByNameInChildObject;
//    procedure TestArrayValue;
    procedure TestJSONBool;
    procedure TestJSONBoolByName;
    procedure TestJSONNull;
    procedure TestJSONNullByName;
  end;

implementation


procedure TestTJSONObjectQuery.SetUp;
var
  LJSON : string;
begin
  LJSON := '{ "name":"John",' +
              '"age":31,' +
              '"city":"New York",' +
              '"alien":false,' +
              '"priors":null,' +
              '"address": {' +
                '"address1" : "1313 Mockingbird Lane"' +
                '"city" : "Sydney"' +
                '"phone" : "0416264200"}}';
  FJSONObject := TJSONObject.ParseJSONValue(LJSON, True) as TJSONObject;
end;

procedure TestTJSONObjectQuery.TearDown;
begin
  FJSONObject.Free;
end;


procedure TestTJSONObjectQuery.TestJSONBool;
begin
  CheckEquals(1, JSONPairQuery.From(FJSONObject).JSONBool.Count);
end;

procedure TestTJSONObjectQuery.TestJSONBoolByName;
begin
  CheckEquals(1, JSONPairQuery.From(FJSONObject).JSONBool('alien').Count);
  CheckEquals(0, JSONPairQuery.From(FJSONObject).JSONBool('city').Count);
end;

procedure TestTJSONObjectQuery.TestDescendIntoNamedJSONObject;
begin
  CheckEquals(3, JSONPairQuery.From(FJSONObject).JSONObject('Address').JSONString.Count);
end;

procedure TestTJSONObjectQuery.TestJSONNull;
begin
  CheckEquals(1, JSONPairQuery.From(FJSONObject).JSONNull.Count);
end;

procedure TestTJSONObjectQuery.TestJSONNullByName;
begin
  CheckEquals(1, JSONPairQuery.From(FJSONObject).JSONNull('Priors').Count);
  CheckEquals(0, JSONPairQuery.From(FJSONObject).JSONNull('alien').Count);
end;

procedure TestTJSONObjectQuery.TestJSONNumber;
begin
  CheckEquals(1, JSONPairQuery.From(FJSONObject).JSONNumber.Count);
end;

procedure TestTJSONObjectQuery.TestJSONNumberByName;
begin
  CheckEquals(1, JSONPairQuery.From(FJSONObject).JSONNumber('age').Count);
end;

procedure TestTJSONObjectQuery.TestJSONObject;
begin
  CheckEquals(1, JSONPairQuery.From(FJSONObject).JSONObject.Count);
end;

procedure TestTJSONObjectQuery.TestPassthrough;
begin
  CheckEquals(6, JSONPairQuery.From(FJSONObject).Count);
end;

procedure TestTJSONObjectQuery.TestJSONString;
begin
  CheckEquals(2, JSONPairQuery.From(FJSONObject).JSONString.Count);
end;

procedure TestTJSONObjectQuery.TestJSONStringByName;
begin
  CheckEquals(1, JSONPairQuery.From(FJSONObject).JSONString('city').Count);
end;

procedure TestTJSONObjectQuery.TestJSONStringByNameInChildObject;
begin
  CheckEquals('Sydney', JSONPairQuery.From(FJSONObject).JSONObject('Address').JSONString('City').First.JsonValue.Value);
end;

procedure TestTJSONObjectQuery.TestNamed;
begin
  CheckEquals('age', JSONPairQuery.From(FJSONObject).Named('age').First.JsonString.Value);
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

