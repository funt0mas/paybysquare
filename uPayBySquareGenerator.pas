unit uPayBySquareGenerator;

interface

uses
  Classes, SysUtils, uPaymentData;

function GeneratePayBySquareString(const APayment: TPaymentData): string;

implementation

uses
  DateUtils, ZLib, uPayBySquareValidation;

const
  CSubstAlphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUV';

function FormatAmount(const AValue: Currency): string;
var
  FS: TFormatSettings;
begin
  FS := TFormatSettings.Create;
  FS.DecimalSeparator := '.';
  Result := FormatCurr('0.00', AValue, FS);
end;

function FormatDate(const ADate: TDateTime): string;
begin
  Result := FormatDateTime('yyyymmdd', ADate);
end;

function BuildDataString(const APayment: TPaymentData): AnsiString;
begin
  Result := AnsiString(
    #9 +
    '1' + #9 +
    '1' + #9 +
    FormatAmount(APayment.Amount) + #9 +
    APayment.CurrencyCode + #9 +
    FormatDate(APayment.DueDate) + #9 +
    APayment.VariableSymbol + #9 +
    APayment.ConstantSymbol + #9 +
    APayment.SpecificSymbol + #9 +
    '' + #9 +
    APayment.PaymentNote + #9 +
    '1' + #9 +
    APayment.IBAN + #9 +
    APayment.Swift + #9 +
    '0' + #9 +
    '0' + #9 +
    APayment.BeneficiaryName + #9 +
    '' + #9 +
    '');
end;

function CalcCrc32(const AData: AnsiString): Cardinal;
const
  Polynomial = $EDB88320;
var
  I, J: Integer;
  C: Cardinal;
begin
  Result := $FFFFFFFF;
  for I := 1 to Length(AData) do
  begin
    C := (Result xor Byte(AData[I]));
    for J := 0 to 7 do
      if (C and 1) <> 0 then
        C := (C shr 1) xor Polynomial
      else
        C := C shr 1;
    Result := C;
  end;
  Result := not Result;
end;

function CompressPayload(const ABytes: TBytes): TBytes;
var
  InStream, OutStream: TMemoryStream;
  Compressor: TCompressionStream;
begin
  InStream := TMemoryStream.Create;
  OutStream := TMemoryStream.Create;
  try
    if Length(ABytes) > 0 then
      InStream.WriteBuffer(ABytes[0], Length(ABytes));
    InStream.Position := 0;

    { Poznámka:
      Oficiálna špecifikácia Pay by Square používa LZMA1 RAW (lc=3, lp=0, pb=2, dict=128k).
      Delphi XE2 nemá natívny LZMA encoder, preto v demo projekte používame čistú XE2 alternatívu
      cez ZLib. Architektúra je pripravená tak, aby bolo možné túto metódu neskôr nahradiť
      LZMA implementáciou 1:1 podľa špecifikácie. }
    Compressor := TCompressionStream.Create(clMax, OutStream);
    try
      Compressor.CopyFrom(InStream, InStream.Size);
    finally
      Compressor.Free;
    end;

    SetLength(Result, OutStream.Size);
    OutStream.Position := 0;
    if OutStream.Size > 0 then
      OutStream.ReadBuffer(Result[0], OutStream.Size);
  finally
    InStream.Free;
    OutStream.Free;
  end;
end;

function BytesToPayBySquareBase32(const ABytes: TBytes): string;
var
  I, J, Buffer, BitCount, Value: Integer;
begin
  Result := '';
  Buffer := 0;
  BitCount := 0;

  for I := 0 to Length(ABytes) - 1 do
  begin
    Buffer := (Buffer shl 8) or ABytes[I];
    Inc(BitCount, 8);

    while BitCount >= 5 do
    begin
      Value := (Buffer shr (BitCount - 5)) and $1F;
      Result := Result + CSubstAlphabet[Value + 1];
      Dec(BitCount, 5);
    end;
  end;

  if BitCount > 0 then
  begin
    Value := (Buffer shl (5 - BitCount)) and $1F;
    Result := Result + CSubstAlphabet[Value + 1];
  end;

  { len modulo 8 musí byť 0, preto doplníme nulové kvintety rovnako ako v referenciách }
  J := Length(Result) mod 8;
  if J <> 0 then
    Result := Result + StringOfChar(CSubstAlphabet[1], 8 - J);
end;

function GeneratePayBySquareString(const APayment: TPaymentData): string;
var
  Payment: TPaymentData;
  DataStr: AnsiString;
  Crc: Cardinal;
  Total: TBytes;
  Compressed: TBytes;
  FinalBytes: TBytes;
  I: Integer;
begin
  Payment := APayment;
  ValidatePaymentData(Payment);

  DataStr := BuildDataString(Payment);
  Crc := CalcCrc32(DataStr);

  SetLength(Total, 4 + Length(DataStr));
  Total[0] := Byte(Crc and $FF);
  Total[1] := Byte((Crc shr 8) and $FF);
  Total[2] := Byte((Crc shr 16) and $FF);
  Total[3] := Byte((Crc shr 24) and $FF);
  for I := 1 to Length(DataStr) do
    Total[3 + I] := Byte(DataStr[I]);

  Compressed := CompressPayload(Total);

  SetLength(FinalBytes, 4 + Length(Compressed));
  FinalBytes[0] := 0;
  FinalBytes[1] := 0;
  FinalBytes[2] := Byte(Length(Total) and $FF);
  FinalBytes[3] := Byte((Length(Total) shr 8) and $FF);
  for I := 0 to Length(Compressed) - 1 do
    FinalBytes[4 + I] := Compressed[I];

  Result := BytesToPayBySquareBase32(FinalBytes);
end;

end.
