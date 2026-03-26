unit uMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Clipbrd, uPaymentData;

type
  TfrmMain = class(TForm)
    lblIBAN: TLabel;
    edtIBAN: TEdit;
    lblSwift: TLabel;
    edtSwift: TEdit;
    lblAmount: TLabel;
    edtAmount: TEdit;
    lblCurrency: TLabel;
    edtCurrency: TEdit;
    lblVS: TLabel;
    edtVS: TEdit;
    lblSS: TLabel;
    edtSS: TEdit;
    lblKS: TLabel;
    edtKS: TEdit;
    lblNote: TLabel;
    edtNote: TEdit;
    lblName: TLabel;
    edtName: TEdit;
    lblDueDate: TLabel;
    dtpDueDate: TDateTimePicker;
    btnGenerate: TButton;
    btnCopy: TButton;
    btnLoadDemo: TButton;
    memoOutput: TMemo;
    lblOutput: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnLoadDemoClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
  private
    function ReadPaymentData: TPaymentData;
    procedure LoadPaymentData(const APayment: TPaymentData);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  uPayBySquareGenerator, uPayBySquareValidation, uPayBySquareSelfTest;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  edtCurrency.Text := 'EUR';
  btnLoadDemoClick(nil);
end;

function TfrmMain.ReadPaymentData: TPaymentData;
var
  FS: TFormatSettings;
begin
  Result.IBAN := edtIBAN.Text;
  Result.Swift := edtSwift.Text;

  FS := TFormatSettings.Create;
  FS.DecimalSeparator := ',';
  if Pos('.', edtAmount.Text) > 0 then
    FS.DecimalSeparator := '.';

  Result.Amount := StrToCurr(Trim(edtAmount.Text), FS);
  Result.CurrencyCode := edtCurrency.Text;
  Result.VariableSymbol := edtVS.Text;
  Result.SpecificSymbol := edtSS.Text;
  Result.ConstantSymbol := edtKS.Text;
  Result.PaymentNote := edtNote.Text;
  Result.BeneficiaryName := edtName.Text;
  Result.DueDate := dtpDueDate.Date;
end;

procedure TfrmMain.LoadPaymentData(const APayment: TPaymentData);
begin
  edtIBAN.Text := APayment.IBAN;
  edtSwift.Text := APayment.Swift;
  edtAmount.Text := FormatFloat('0.00', APayment.Amount);
  edtCurrency.Text := APayment.CurrencyCode;
  edtVS.Text := APayment.VariableSymbol;
  edtSS.Text := APayment.SpecificSymbol;
  edtKS.Text := APayment.ConstantSymbol;
  edtNote.Text := APayment.PaymentNote;
  edtName.Text := APayment.BeneficiaryName;
  dtpDueDate.Date := APayment.DueDate;
end;

procedure TfrmMain.btnLoadDemoClick(Sender: TObject);
var
  P: TPaymentData;
begin
  P := TPaymentData.CreateDemo;
  LoadPaymentData(P);
  memoOutput.Clear;
end;

procedure TfrmMain.btnGenerateClick(Sender: TObject);
var
  P: TPaymentData;
  S: string;
begin
  try
    P := ReadPaymentData;
    S := GeneratePayBySquareString(P);
    memoOutput.Lines.Text := S;

    if not RunDeterminismSelfTest then
      MessageDlg('Upozornenie: interný deterministický self-test neprešiel.', mtWarning, [mbOK], 0);
  except
    on E: EPaymentValidationError do
      MessageDlg('Neplatné vstupy: ' + E.Message, mtError, [mbOK], 0);
    on E: Exception do
      MessageDlg('Generovanie zlyhalo: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmMain.btnCopyClick(Sender: TObject);
begin
  if Trim(memoOutput.Lines.Text) = '' then
  begin
    MessageDlg('Najprv vygenerujte Pay by Square text.', mtInformation, [mbOK], 0);
    Exit;
  end;
  Clipboard.AsText := memoOutput.Lines.Text;
  MessageDlg('Text bol skopírovaný do schránky.', mtInformation, [mbOK], 0);
end;

end.
