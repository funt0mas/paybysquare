unit uPayBySquareSelfTest;

interface

function RunDeterminismSelfTest: Boolean;

implementation

uses
  uPaymentData, uPayBySquareGenerator;

function RunDeterminismSelfTest: Boolean;
var
  P: TPaymentData;
  S1, S2: string;
begin
  P := TPaymentData.CreateDemo;
  S1 := GeneratePayBySquareString(P);
  S2 := GeneratePayBySquareString(P);
  Result := S1 = S2;
end;

end.
