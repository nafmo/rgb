unit SampleU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfSample = class(TForm)
    gbSample: TGroupBox;
    lCode1: TLabel;
    cPart: TComboBox;
    lCode2: TLabel;
    eHTML: TEdit;
    lCode3: TLabel;
    paSample: TPanel;
    pBackground: TPaintBox;
    lHTMLText: TLabel;
    lHTMLLink: TLabel;
    lHTMLALink: TLabel;
    lHTMLVlink: TLabel;
    bCopy: TButton;
    bCopyAll: TButton;
    bPaste: TButton;
    procedure bCopyClick(Sender: TObject);
    procedure bPasteClick(Sender: TObject);
    procedure bCopyAllClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fSample: TfSample;

implementation

{$R *.DFM}

procedure TfSample.bCopyClick(Sender: TObject);
begin
  ClipBoard.AsText := fRGB.eHTML.Text;
end;

procedure TfSample.bPasteClick(Sender: TObject);
var
  s: string;
begin
  s := ClipBoard.AsText;
  if length(s) = 6 then
    fRGB.eHTML.Text := s
  else if (s[1] = '#') and (length(s) = 7) then
    fRGB.eHTML.Text := Copy(s, 2, 6);
end;

procedure TfSample.bCopyAllClick(Sender: TObject);
begin
  ClipBoard.AsText := '<body bgcolor="#' + TColor_2_Hex(currcol[0]) +
                      '" text="#'        + TColor_2_Hex(currcol[1]) +
                      '" link="#'        + TColor_2_Hex(currcol[2]) +
                      '" alink="#'       + TColor_2_Hex(currcol[3]) +
                      '" vlink="#'       + TColor_2_Hex(currcol[4]) + '">';
end;

end.
