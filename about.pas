unit About;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, ShellAPI;

type
  TfAbout = class(TForm)
    iPictureRGB: TImage;
    mGPL: TMemo;
    lTitle: TLabel;
    lCopyright: TLabel;
    lRelease: TLabel;
    lWeb: TLabel;
    bOk: TButton;
    procedure bOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure lWebClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fAbout: TfAbout;

implementation

{$R *.DFM}

procedure TfAbout.bOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfAbout.FormActivate(Sender: TObject);
begin
  fAbout.Left := (Screen.Width -  fAbout.Width)  shr 1;
  fAbout.Top  := (Screen.Height - fAbout.Height) shr 1;
end;

procedure TfAbout.lWebClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar('http://www.softwolves.pp.se/wolves/'),
               '', 'C:\', SW_SHOWNORMAL);
end;

end.
