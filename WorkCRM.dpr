program WorkCRM;

uses
  Vcl.Forms,
  SysUtils,
  Work.Main in 'Work.Main.pas' {FormMain},
  SQLite3 in '..\..\SQLite\SQLite3.pas',
  SQLiteTable3 in '..\..\SQLite\SQLiteTable3.pas',
  SQLLang in '..\..\SQLite\SQLLang.pas',
  Work.DB in 'Work.DB.pas',
  Work.Table.Customers in 'Work.Table.Customers.pas',
  Work.Table.Tasks in 'Work.Table.Tasks.pas',
  Work.Table.History in 'Work.Table.History.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Work CRM';
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
