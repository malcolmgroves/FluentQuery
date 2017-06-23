unit FluentQuery.JSON.Tests;

interface

uses
  TestFramework, FluentQuery.Core.Types, FluentQuery.JSON, SYstem.JSON,
  FireDAC.Comp.Client, FLuentQuery.Tests.Base,  System.SysUtils;

type
  TestTJSONObjectQuery = class(TFluentQueryTestCase<TJSONPair>)
  strict private
    FJSONObject : TJSONObject;
    FJSONString : string;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestInvalidJSON;
    procedure TestPassthrough;
    procedure TestWherePredicate;
    procedure TestWhereUnboundPredicate;
    procedure TestIsJSONNumber;
    procedure TestIsJSONNumberByName;
    procedure TestNamed;
    procedure TestIsJSONString;
    procedure TestIsJSONStringByName;
    procedure TestIsJSONStringNameMatchesStringQuery;
    procedure TestIsJSONStringNameMatchesPredicate;
    procedure TestIsJSONObject;
    procedure TestIsJSONObjectByName;
    procedure TestDescendIntoNamedJSONObject;
    procedure TestJSONStringByNameInChildObject;
    procedure TestIsJSONArray;
    procedure TestIsJSONArrayByName;
    procedure TestIsJSONArrayWithFromAtEnd;
    procedure TestDescendIntoNamedJSONArray;
    procedure TestDescendIntoNamedJSONArrayByIndex;
    procedure TestIsJSONBool;
    procedure TestIsJSONBoolByName;
    procedure TestIsJSONNull;
    procedure TestIsJSONNullByName;
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
    procedure TestJSONStrings;
    procedure TestJSONNumbers;
    procedure TestIsJSONObject;
    procedure TestIsJSONBool;
    procedure TestJSONNulls;
    procedure TestIndex;
    procedure TestDescendIntoJSONArray;
    procedure TestDescendIntoJSONArrayIndex;
    procedure TestDescendIntoJSONObject;
    procedure TestJSONStringByNameInChildObject;
  end;

implementation
uses
  FLuentQuery.Strings;


procedure TestTJSONObjectQuery.SetUp;
begin
  FJSONString := '{ "name":"John",' +
                    '"age":31,' +
                    '"city":"New York",' +
                    '"alien":false,' +
                    '"priors":null,' +
                    '"numbers" : [0,1,2,3,4],' +
                    '"address": {' +
                      '"address1" : "1313 Mockingbird Lane"' +
                      '"city" : "Sydney"' +
                      '"phone" : "0416264200"}}';
  FJSONObject := TJSONObject.ParseJSONValue(FJSONString, True) as TJSONObject;
end;

procedure TestTJSONObjectQuery.TearDown;
begin
  FJSONObject.Free;
end;


procedure TestTJSONObjectQuery.TestInvalidJSON;
var
    LJSONString : string;
begin
  LJSONString := '{ "name":"John",' +
                    '"age":31,' +
                    '"city":"New York",' +
                    '"alien":false,' +
                    '"priors":null,' +
                    '"numbers : [0,1,2,3,4],' +  // missing closing quote on name
                    '"address": {' +
                      '"address1" : "1313 Mockingbird Lane"' +
                      '"city" : "Sydney"' +
                      '"phone" : "0416264200"}}';

  ExpectedException := EJSONParseFailure;
  CheckEquals(7, JSONQuery.From(LJSONString).Count);
  StopExpectingException;
end;

procedure TestTJSONObjectQuery.TestIsJSONArray;
begin
  CheckEquals(1, JSONQuery.From(FJSONString).IsJSONArray.Count);
end;

procedure TestTJSONObjectQuery.TestIsJSONArrayByName;
begin
  CheckEquals(1, JSONQuery.From(FJSONObject).IsJSONArray('NumbeRs').Count);
end;

procedure TestTJSONObjectQuery.TestIsJSONArrayWithFromAtEnd;
begin
  CheckEquals(1, JSONQuery.IsJSONArray.From(FJSONObject).Count);
end;

procedure TestTJSONObjectQuery.TestIsJSONBool;
begin
  CheckEquals(1, JSONQuery.From(FJSONObject).IsJSONBool.Count);
end;

procedure TestTJSONObjectQuery.TestIsJSONBoolByName;
begin
  CheckEquals(1, JSONQuery.From(FJSONObject).IsJSONBool('alien').Count);
  CheckEquals(0, JSONQuery.From(FJSONObject).IsJSONBool('city').Count);
end;

procedure TestTJSONObjectQuery.TestDescendIntoNamedJSONArray;
begin
  CheckEquals(5, JSONQuery.From(FJSONObject).JSONArray('Numbers').IsJSONNumber.Count);
end;

procedure TestTJSONObjectQuery.TestDescendIntoNamedJSONArrayByIndex;
begin
  CheckEquals('3', JSONQuery.From(FJSONObject).JSONArray('Numbers')[3].Value);
end;

procedure TestTJSONObjectQuery.TestDescendIntoNamedJSONObject;
begin
  CheckEquals(3, JSONQuery.From(FJSONObject).JSONObject('Address').IsJSONString.Count);
end;

procedure TestTJSONObjectQuery.TestIsJSONNull;
begin
  CheckEquals(1, JSONQuery.From(FJSONObject).IsJSONNull.Count);
end;

procedure TestTJSONObjectQuery.TestIsJSONNullByName;
begin
  CheckEquals(1, JSONQuery.From(FJSONObject).IsJSONNull('Priors').Count);
  CheckEquals(0, JSONQuery.From(FJSONObject).IsJSONNull('alien').Count);
end;

procedure TestTJSONObjectQuery.TestIsJSONNumber;
begin
  CheckEquals(1, JSONQuery.From(FJSONObject).IsJSONNumber.Count);
end;

procedure TestTJSONObjectQuery.TestIsJSONNumberByName;
begin
  CheckEquals(1, JSONQuery.From(FJSONObject).IsJSONNumber('age').Count);
end;

procedure TestTJSONObjectQuery.TestIsJSONObject;
begin
  CheckEquals(1, JSONQuery.From(FJSONObject).IsJSONObject.Count);
end;

procedure TestTJSONObjectQuery.TestIsJSONObjectByName;
begin
  CheckEquals(1, JSONQuery.From(FJSONObject).IsJSONObject('Address').Count);
end;

procedure TestTJSONObjectQuery.TestPassthrough;
begin
  CheckEquals(7, JSONQuery.From(FJSONObject).Count);
end;

procedure TestTJSONObjectQuery.TestIsJSONString;
begin
  CheckEquals(2, JSONQuery.From(FJSONObject).IsJSONString.Count);
end;

procedure TestTJSONObjectQuery.TestIsJSONStringByName;
begin
  CheckEquals(1, JSONQuery.From(FJSONObject).IsJSONString('city').Count);
  CheckEquals('New York', JSONQuery.From(FJSONObject).IsJSONString('city').ValueAsString);
end;

procedure TestTJSONObjectQuery.TestIsJSONStringNameMatchesPredicate;
var
  LengthAtLeast4 : TPredicate<String>;
begin
  LengthAtLeast4 := function (Value : string) : boolean
                     begin
                       Result := Length(Value) >= 4;
                     end;
  CheckEquals(2, JSONQuery.From(FJSONObject).IsJSONString(LengthAtLeast4).Count);
end;

procedure TestTJSONObjectQuery.TestIsJSONStringNameMatchesStringQuery;
begin
  CheckEquals(1, JSONQuery.From(FJSONObject).IsJSONString(StringQuery.StartsWith('C')).Count);
end;

procedure TestTJSONObjectQuery.TestJSONStringByNameInChildObject;
begin
  CheckEquals('Sydney', JSONQuery.From(FJSONObject).JSONObject('Address').IsJSONString('City').ValueAsString);
end;

procedure TestTJSONObjectQuery.TestNamed;
begin
  CheckEquals('age', JSONQuery.From(FJSONObject).Named('age').Name);
end;

procedure TestTJSONObjectQuery.TestWhereUnboundPredicate;
begin
  CheckEquals(1, JSONQuery.From(FJSONObject).Where(JSONQuery.Named('age').Predicate).Count);
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

procedure TTestJSONArrayQuery.TestDescendIntoJSONArray;
begin
  CheckEquals(4, FQuery.From(FJSONArray).JSONArray.Count);
end;

procedure TTestJSONArrayQuery.TestDescendIntoJSONArrayIndex;
begin
  CheckEquals('2', FQuery.From(FJSONArray).JSONArray[2].Value);
end;

procedure TTestJSONArrayQuery.TestDescendIntoJSONObject;
begin
  CheckEquals(3, FQuery.From(FJSONArray).JSONObject.Count);
end;

procedure TTestJSONArrayQuery.TestIsJSONBool;
begin
  CheckEquals(1, FQuery.From(FJSONArray).IsJSONBool.Count);
end;

procedure TTestJSONArrayQuery.TestJSONNulls;
begin
  CheckEquals(1, FQuery.From(FJSONArray).IsJSONNull.Count);
end;

procedure TTestJSONArrayQuery.TestJSONNumbers;
begin
  CheckEquals(1, FQuery.From(FJSONArray).IsJSONNumber.Count);
end;

procedure TTestJSONArrayQuery.TestIsJSONObject;
begin
  CheckEquals(1, FQuery.From(FJSONArray).IsJSONObject.Count);
end;

procedure TTestJSONArrayQuery.TestJSONStringByNameInChildObject;
begin
  CheckEquals('Sydney', FQuery.From(FJSONArray).JSONObject.IsJSONString('City').ValueAsString);
end;

procedure TTestJSONArrayQuery.TestJSONStrings;
begin
  CheckEquals(2, FQuery.From(FJSONArray).IsJSONString.Count);
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

