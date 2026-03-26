unit uPayBySquareValidation;

interface

uses
  SysUtils, uPaymentData;

type
  EPaymentValidationError = class(Exception);

function NormalizeIBAN(const AValue: string): string;
procedure ValidatePaymentData(var APayment: TPaymentData);

implementation

function DigitsOnly(const AValue: string): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 1 to Length(AValue) do
    if not CharInSet(AValue[I], ['0'..'9']) then
      Exit(False);
end;

function NormalizeIBAN(const AValue: string): string;
begin
  Result := UpperCase(StringReplace(Trim(AValue), ' ', '', [rfReplaceAll]));
end;

procedure ValidateNumericField(const AValue, AName: string; AMaxLen: Integer);
begin
  if AValue = '' then
    Exit;
  if Length(AValue) > AMaxLen then
    raise EPaymentValidationError.CreateFmt('%s môže mať maximálne %d znakov.', [AName, AMaxLen]);
  if not DigitsOnly(AValue) then
    raise EPaymentValidationError.CreateFmt('%s musí obsahovať iba číslice.', [AName]);
end;

procedure ValidatePaymentData(var APayment: TPaymentData);
begin
  APayment.IBAN := NormalizeIBAN(APayment.IBAN);
  APayment.Swift := UpperCase(Trim(APayment.Swift));
  APayment.CurrencyCode := UpperCase(Trim(APayment.CurrencyCode));
  APayment.VariableSymbol := Trim(APayment.VariableSymbol);
  APayment.SpecificSymbol := Trim(APayment.SpecificSymbol);
  APayment.ConstantSymbol := Trim(APayment.ConstantSymbol);
  APayment.PaymentNote := Trim(APayment.PaymentNote);
  APayment.BeneficiaryName := Trim(APayment.BeneficiaryName);

  if APayment.IBAN = '' then
    raise EPaymentValidationError.Create('IBAN je povinný.');

  if Length(APayment.IBAN) < 15 then
    raise EPaymentValidationError.Create('IBAN je príliš krátky.');

  if APayment.Swift = '' then
    raise EPaymentValidationError.Create('SWIFT/BIC je v tejto implementácii povinný (pre kompatibilitu s referenciami).');

  if (Length(APayment.Swift) <> 8) and (Length(APayment.Swift) <> 11) then
    raise EPaymentValidationError.Create('SWIFT/BIC musí mať 8 alebo 11 znakov.');

  if APayment.Amount <= 0 then
    raise EPaymentValidationError.Create('Suma musí byť väčšia než 0.');

  if APayment.CurrencyCode = '' then
    APayment.CurrencyCode := 'EUR';

  if APayment.CurrencyCode <> 'EUR' then
    raise EPaymentValidationError.Create('Demo implementácia podporuje iba menu EUR.');

  ValidateNumericField(APayment.VariableSymbol, 'Variabilný symbol', 10);
  ValidateNumericField(APayment.SpecificSymbol, 'Špecifický symbol', 10);
  ValidateNumericField(APayment.ConstantSymbol, 'Konštantný symbol', 4);

  if Length(APayment.PaymentNote) > 140 then
    raise EPaymentValidationError.Create('Poznámka môže mať maximálne 140 znakov.');

  if APayment.DueDate <= 0 then
    raise EPaymentValidationError.Create('Dátum splatnosti je povinný.');
end;

end.
