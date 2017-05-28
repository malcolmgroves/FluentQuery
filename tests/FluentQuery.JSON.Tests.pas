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

  TTestJSONArrayQuery = class(TFluentQueryTestCase<TJSONValue>)
  strict private
    FJSONArray : TJSONArray;
    FJSONObject : TJSONObject;
    FQuery : IUnboundJSONValueQuery;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestPassthrough;
    procedure TestFirst;
    procedure TestSkip;
    procedure TestJSONString;
    procedure TestJSONNumber;
    procedure TestJSONObject;
    procedure TestJSONBool;
    procedure TestJSONNull;
    procedure TestIndex;
    procedure TestJSONArray;
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
  CheckEquals(1, JSONQuery.From(FJSONObject).JSONBool.Count);
end;

procedure TestTJSONObjectQuery.TestJSONBoolByName;
begin
  CheckEquals(1, JSONQuery.From(FJSONObject).JSONBool('alien').Count);
  CheckEquals(0, JSONQuery.From(FJSONObject).JSONBool('city').Count);
end;

procedure TestTJSONObjectQuery.TestDescendIntoNamedJSONObject;
begin
  CheckEquals(3, JSONQuery.From(FJSONObject).JSONObject('Address').JSONString.Count);
end;

procedure TestTJSONObjectQuery.TestJSONNull;
begin
  CheckEquals(1, JSONQuery.From(FJSONObject).JSONNull.Count);
end;

procedure TestTJSONObjectQuery.TestJSONNullByName;
begin
  CheckEquals(1, JSONQuery.From(FJSONObject).JSONNull('Priors').Count);
  CheckEquals(0, JSONQuery.From(FJSONObject).JSONNull('alien').Count);
end;

procedure TestTJSONObjectQuery.TestJSONNumber;
begin
  CheckEquals(1, JSONQuery.From(FJSONObject).JSONNumber.Count);
end;

procedure TestTJSONObjectQuery.TestJSONNumberByName;
begin
  CheckEquals(1, JSONQuery.From(FJSONObject).JSONNumber('age').Count);
end;

procedure TestTJSONObjectQuery.TestJSONObject;
begin
  CheckEquals(1, JSONQuery.From(FJSONObject).JSONObject.Count);
end;

procedure TestTJSONObjectQuery.TestPassthrough;
begin
  CheckEquals(6, JSONQuery.From(FJSONObject).Count);
end;

procedure TestTJSONObjectQuery.TestJSONString;
begin
  CheckEquals(2, JSONQuery.From(FJSONObject).JSONString.Count);
end;

procedure TestTJSONObjectQuery.TestJSONStringByName;
begin
  CheckEquals(1, JSONQuery.From(FJSONObject).JSONString('city').Count);
end;

procedure TestTJSONObjectQuery.TestJSONStringByNameInChildObject;
begin
  CheckEquals('Sydney', JSONQuery.From(FJSONObject).JSONObject('Address').JSONString('City').First.JsonValue.Value);
end;

procedure TestTJSONObjectQuery.TestNamed;
begin
  CheckEquals('age', JSONQuery.From(FJSONObject).Named('age').First.JsonString.Value);
end;

procedure TestTJSONObjectQuery.TestWherePredicate;
var
  LIsAgePair : TPredicate<TJSonPair>;
begin
  LIsAgePair := function (Pair : TJsonPair) : Boolean
                begin
                  Result := LowerCase(Pair.JsonString.Value) = 'age';
                end;
  CheckEquals(1, JSONQuery.From(FJSONObject).Where(LIsAgePair).Count);
end;

{ TTestJSONArrayQuery }

procedure TTestJSONArrayQuery.SetUp;
var
  LJSON : string;
begin
  LJSON :=  '{"array": [' +
                        '"Belinda",' +
                        '"Kevin",' +
                        '1991,' +
                        'false,' +
                        'null,' +
                        '{' +
                          '"address1": "1313 Mockingbird Lane",' +
                          '"city": "Sydney",' +
                          '"phone": "0416264200"' +
                        '},' +
                        '[0,1,2,3]' +
                      ']' +
            '}';

  FJSONObject := TJSONObject.ParseJSONValue(LJSON, True) as TJSONObject;
  FJSONArray := FJSONObject.GetValue('array') as TJSONArray;
  FQuery := JSONArrayQuery;
end;

procedure TTestJSONArrayQuery.TearDown;
begin
  inherited;
  FQuery := nil;
  FJSONObject.Free;
end;

procedure TTestJSONArrayQuery.TestFirst;
begin
  CheckEquals('Belinda', FQuery.From(FJSONArray).First.Value);
end;

procedure TTestJSONArrayQuery.TestIndex;
begin
  CheckEquals('false', FQuery.From(FJSONArray).Item[3].Value);
  CheckEquals('1991', FQuery.From(FJSONArray)[2].Value);
end;

procedure TTestJSONArrayQuery.TestJSONArray;
begin
  CheckEquals(4, FQuery.From(FJSONArray).JSONArray.Count);
end;

procedure TTestJSONArrayQuery.TestJSONBool;
begin
  CheckEquals(1, FQuery.From(FJSONArray).JSONBool.Count);
end;

procedure TTestJSONArrayQuery.TestJSONNull;
begin
  CheckEquals(1, FQuery.From(FJSONArray).JSONNull.Count);
end;

procedure TTestJSONArrayQuery.TestJSONNumber;
begin
  CheckEquals(1, FQuery.From(FJSONArray).JSONNumber.Count);
end;

procedure TTestJSONArrayQuery.TestJSONObject;
begin
  CheckEquals(1, FQuery.From(FJSONArray).JSONObject.Count);
end;

procedure TTestJSONArrayQuery.TestJSONString;
begin
  CheckEquals(2, FQuery.From(FJSONArray).JSONString.Count);
end;

procedure TTestJSONArrayQuery.TestPassthrough;
begin
  CheckEquals(7, FQuery.From(FJSONArray).Count);
end;

procedure TTestJSONArrayQuery.TestSkip;
begin
  CheckEquals('Kevin', FQuery.From(FJSONArray).Skip(1).First.Value);
end;

initialization
  // Register any test cases with the test runner
  RegisterTest('JSON', TestTJSONObjectQuery.Suite);
  RegisterTest('JSON', TTestJSONArrayQuery.Suite);
end.

