unit FluentQuery.Pointers.Tests;

interface

uses
  TestFramework,
  System.Generics.Collections,
  FluentQuery,
  System.Classes;

type
  TestTQueryPointer = class(TTestCase)
  strict private
    FList: TList<Pointer>;
    FObject1, FObject2, FObject3 : TObject;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestPassThrough;
    procedure TestIsAssigned;
  end;


implementation
uses
  System.SysUtils;

{ TestTQueryPointer }

procedure TestTQueryPointer.SetUp;
begin
  inherited;
  FList := TList<Pointer>.Create;
  FObject1 := TObject.Create;
  FObject2 := TObject.Create;
  FObject3 := TObject.Create;

  FList.Add(FObject1);
  FList.Add(nil);
  FList.Add(FObject2);
  FList.Add(Pointer(1234));
  FList.Add(FObject3);
end;

procedure TestTQueryPointer.TearDown;
begin
  FObject1.Free;
  FObject2.Free;
  FObject3.Free;
  FList.Free;
  inherited;
end;

procedure TestTQueryPointer.TestIsAssigned;
var
  LPassCount : Integer;
  LPointer : Pointer;
begin
  LPassCount := 0;
  for LPointer in Query<Pointer>
                    .From(FList)
                    .IsAssigned do
    Inc(LPassCount);
  Check(LPassCount = 4, 'IsAssigned Query should enumerate four items');
end;

procedure TestTQueryPointer.TestPassThrough;
var
  LPassCount : Integer;
  LPointer : Pointer;
begin
  LPassCount := 0;
  for LPointer in Query<Pointer>.From(FList) do
    Inc(LPassCount);
  Check(LPassCount = FList.Count, 'Passthrough Query should enumerate all items');
end;

initialization
  // Register any test cases with the test runner
  RegisterTest('Pointer/TList<Pointer>', TestTQueryPointer.Suite);
end.

