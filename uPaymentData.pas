unit uPaymentData;

interface

uses
  SysUtils;

type
  TPaymentData = record
    IBAN: string;
    Swift: string;
    Amount: Currency;
    CurrencyCode: string;
    VariableSymbol: string;
    SpecificSymbol: string;
    ConstantSymbol: string;
    PaymentNote: string;
    BeneficiaryName: string;
    DueDate: TDateTime;
    class function CreateDemo: TPaymentData; static;
  end;

implementation

class function TPaymentData.CreateDemo: TPaymentData;
begin
  Result.IBAN := 'SK3112000000198742637541';
  Result.Swift := 'TATRSKBX';
  Result.Amount := 123.45;
  Result.CurrencyCode := 'EUR';
  Result.VariableSymbol := '20260001';
  Result.SpecificSymbol := '1234';
  Result.ConstantSymbol := '0308';
  Result.PaymentNote := 'Demo platba Pay by Square';
  Result.BeneficiaryName := 'Demo Prijemca s.r.o.';
  Result.DueDate := EncodeDate(2026, 4, 15);
end;

end.
