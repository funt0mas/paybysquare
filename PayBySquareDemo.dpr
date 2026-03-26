program PayBySquareDemo;

uses
  Forms,
  uMainForm in 'uMainForm.pas' {frmMain},
  uPaymentData in 'uPaymentData.pas',
  uPayBySquareGenerator in 'uPayBySquareGenerator.pas',
  uPayBySquareValidation in 'uPayBySquareValidation.pas',
  uPayBySquareSelfTest in 'uPayBySquareSelfTest.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
