unit Rgbu;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Clipbrd, IniFiles, TabNotBk, About,
  ComCtrls;

type
  TfRGB = class(TForm)
    gbAll: TGroupBox;
    lHTML: TLabel;
    bQuit: TButton;
    bAbout: TButton;
    iPictureRGB: TImage;
    tabColour: TTabbedNotebook;
    lRed: TLabel;
    lGreen: TLabel;
    lBlue: TLabel;
    eBlue: TEdit;
    eGreen: TEdit;
    eRed: TEdit;
    sRed: TScrollBar;
    sGreen: TScrollBar;
    sBlue: TScrollBar;
    lValue: TLabel;
    lSaturation: TLabel;
    lHue: TLabel;
    sValue: TScrollBar;
    eValue: TEdit;
    eHue: TEdit;
    eSaturation: TEdit;
    sSaturation: TScrollBar;
    sHue: TScrollBar;
    rBlack: TRadioButton;
    rSilver: TRadioButton;
    rGray: TRadioButton;
    rWhite: TRadioButton;
    rMaroon: TRadioButton;
    rRed: TRadioButton;
    rPurple: TRadioButton;
    rFuchsia: TRadioButton;
    rGreen: TRadioButton;
    rLime: TRadioButton;
    rOlive: TRadioButton;
    rYellow: TRadioButton;
    rNavy: TRadioButton;
    rBlue: TRadioButton;
    rTeal: TRadioButton;
    rAqua: TRadioButton;
    rOther: TRadioButton;
    eHTML: TEdit;
    lCode1: TLabel;
    lCode3: TLabel;
    bCopy: TButton;
    bPaste: TButton;
    dColor: TColorDialog;
    bDecAll: TButton;
    bIncAll4: TButton;
    bDecAll4: TButton;
    bIncAll: TButton;
    cPart: TComboBox;
    lCode2: TLabel;
    paSample: TPanel;
    pBackground: TPaintBox;
    lHTMLLink: TLabel;
    lHTMLALink: TLabel;
    lHTMLVlink: TLabel;
    lHTMLText: TLabel;
    bSelect: TButton;
    bCopyAll: TButton;
    paColor: TPanel;
    pColor: TPaintBox;
    procedure sRedChange(Sender: TObject);
    procedure sGreenChange(Sender: TObject);
    procedure sBlueChange(Sender: TObject);
    procedure eRedChange(Sender: TObject);
    procedure eGreenChange(Sender: TObject);
    procedure eBlueChange(Sender: TObject);
    procedure updateHTML(fromhsv, updatenames: boolean);
    procedure updateHTML2(Sender: TObject);
    procedure bQuitClick(Sender: TObject);
    procedure bAboutClick(Sender: TObject);
    procedure lHTMLClick(Sender: TObject);
    procedure GetHSV(var h, s, v: single);
    procedure RGB_2_HSV(r, g, b: single; var h, s, v: single);
    procedure HSV_2_RGB(var r, g, b: single; h, s, v: single);
    procedure sHueChange(Sender: TObject);
    procedure sSaturationChange(Sender: TObject);
    procedure sValueChange(Sender: TObject);
    procedure eHueChange(Sender: TObject);
    procedure eSaturationChange(Sender: TObject);
    procedure eValueChange(Sender: TObject);
    procedure rNameClick(Sender: TObject);
    procedure bCopyClick(Sender: TObject);
    procedure eHTMLChange(Sender: TObject);
    procedure bPasteClick(Sender: TObject);
    procedure bSelectClick(Sender: TObject);
    procedure eValueKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eHueKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eSaturationKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bDecAll4Click(Sender: TObject);
    procedure bDecAllClick(Sender: TObject);
    procedure bIncAllClick(Sender: TObject);
    procedure bIncAll4Click(Sender: TObject);
    procedure pBackgroundRedraw(Sender: TObject);
    procedure cPartChange(Sender: TObject);
    procedure fRGBActivate(Sender: TObject);
    procedure bCopyAllClick(Sender: TObject);
    procedure lHTMLTextClick(Sender: TObject);
    procedure lHTMLLinkClick(Sender: TObject);
    procedure lHTMLALinkClick(Sender: TObject);
    procedure lHTMLVlinkClick(Sender: TObject);
    procedure pBackgroundClick(Sender: TObject);
  private
    { Private declarations }
    inupdate: boolean;
    function hex(b: byte): string;
    function TColor_2_Hex(c: TColor): string;
  public
    rgbmode: boolean;
    colours: array[0..16] of TRadioButton;
    currcol: array[0..5]  of TColor;
    { Public declarations }
  end;

var
  fRGB: TfRGB;
  StrRed, StrGreen, StrBlue, StrHue, StrSaturation, StrValue: string;

const
  redTable: array[0..15] of byte =
    ( $0, $c0,$80,$ff,$80,$ff,$80,$ff,$0 ,$0, $80,$ff,$0 ,$0, $0, $0 );
  greenTable: array[0..15] of byte =
    ( $0, $c0,$80,$ff,$0, $0, $0, $0, $80,$ff,$80,$ff,$0 ,$0, $80,$ff);
  blueTable: array[0..15] of byte =
    ( $0, $c0,$80,$ff,$0, $0, $80,$ff,$0, $0, $0, $0, $80,$ff,$80,$ff);
  rect2: TRect =
    (Left: 0; Top: 0; Right: 285; Bottom: 45);
 initdone: boolean = false;

implementation

{$R *.DFM}

function TfRGB.hex(b: byte): string;
const
  hexarr: array[0..15] of char = '0123456789abcdef';
begin
  hex := hexarr[b shr 4] + hexarr[b and 15];
end;

function TfRGB.TColor_2_Hex(c: TColor): string;
begin
  TColor_2_Hex := hex( c         and 255) +
                  hex((c shr 8)  and 255) +
                  hex((c shr 16) and 255);
end;

{ *** Rullningslister *** }

procedure TfRGB.sRedChange(Sender: TObject);
Var
  s: string;
begin
  Str(sRed.Position, s);
  eRed.Text := s;
  fRGB.updateHTML(false, true);
end;

procedure TfRGB.sGreenChange(Sender: TObject);
Var
  s: string;
begin
  Str(sGreen.Position, s);
  eGreen.Text := s;
  fRGB.updateHTML(false, true);
end;

procedure TfRGB.sBlueChange(Sender: TObject);
Var
  s: string;
begin
  Str(sBlue.Position, s);
  eBlue.Text := s;
  fRGB.updateHTML(false, true);
end;

procedure TfRGB.sHueChange(Sender: TObject);
Var
  s: string;
begin
  Str(sHue.Position / 10:1:1, s);
  eHue.Text := s;
  fRGB.updateHTML(true, true);
end;

procedure TfRGB.sSaturationChange(Sender: TObject);
Var
  s: string;
begin
  Str(sSaturation.Position / 100:1:2, s);
  eSaturation.Text := s;
  fRGB.updateHTML(true, true);
end;

procedure TfRGB.sValueChange(Sender: TObject);
Var
  s: string;
begin
  Str(sValue.Position / 100:1:2, s);
  eValue.Text := s;
  fRGB.updateHTML(true, true);
end;



{ *** Redigeringsrutor *** }

procedure TfRGB.eRedChange(Sender: TObject);
Var
  v: word;
  t: integer;
begin
  Val(eRed.Text, v, t);
  if t = 0 then
    sRed.Position := v
  else if eRed.Text <> '' then begin
    sRed.Position := 0;
    eRed.Text := '0';
  end;
end;

procedure TfRGB.eGreenChange(Sender: TObject);
Var
  v: word;
  t: integer;
begin
  Val(eGreen.Text, v, t);
  if t = 0 then
    sGreen.Position := v
  else if eGreen.Text <> '' then begin
    sGreen.Position := 0;
    eGreen.Text := '0';
  end;
end;

procedure TfRGB.eBlueChange(Sender: TObject);
Var
  v: word;
  t: integer;
begin
  Val(eBlue.Text, v, t);
  if t = 0 then
    sBlue.Position := v
  else if eBlue.Text <> '' then begin
    sBlue.Position := 0;
    eBlue.Text := '0';
  end;
end;


procedure TfRGB.eHueChange(Sender: TObject);
Var
  f: single;
  t: integer;
begin
  Val(eHue.Text, f, t);
  if t = 0 then
    sHue.Position := trunc(f * 10)
  else if eHue.Text <> '' then begin
    sHue.Position := 0;
    eHue.Text := '0';
  end;
end;

procedure TfRGB.eSaturationChange(Sender: TObject);
Var
  f: single;
  t: integer;
begin
  Val(eSaturation.Text, f, t);
  if t = 0 then
    sSaturation.Position := trunc(f * 100)
  else if eSaturation.Text <> '' then begin
    sSaturation.Position := 0;
    eSaturation.Text := '0';
  end;
end;

procedure TfRGB.eValueChange(Sender: TObject);
Var
  f: single;
  t: integer;
begin
  Val(eValue.Text, f, t);
  if t = 0 then
    sValue.Position := trunc(f * 100)
  else if eBlue.Text <> '' then begin
    sValue.Position := 0;
    eValue.Text := '0';
  end;
end;

procedure TfRGB.eHTMLChange(Sender: TObject);
var
  r, g, b: byte;
  t: integer;
begin
  If (not inupdate) and (length(eHTML.Text) = 6) then begin
    Val('$' + Copy(eHTML.Text, 1, 2), r, t);
    if t = 0 then begin
      Val('$' + Copy(eHTML.Text, 3, 2), g, t);
      if t = 0 then begin
        Val('$' + Copy(eHTML.Text, 5, 2), b, t);
        if t = 0 then begin
          fRGB.sRed.Position   := r;
          fRGB.sGreen.Position := g;
          fRGB.sBlue.Position  := b;
        end;
      end;
    end;
  end;
end;

{ ***  *** }


procedure TfRGB.bQuitClick(Sender: TObject);
var
  rgbini: TIniFile;
  i: byte;
begin
  rgbini := TIniFile.Create('win.ini');
  rgbini.WriteInteger('HTMLRGB', 'R', fRGB.sRed.Position);
  rgbini.WriteInteger('HTMLRGB', 'G', fRGB.sGreen.Position);
  rgbini.WriteInteger('HTMLRGB', 'B', fRGB.sBlue.Position);
  rgbini.WriteInteger('HTMLRGB', 'X', fRGB.Left);
  rgbini.WriteInteger('HTMLRGB', 'Y', fRGB.Top);
  rgbini.WriteInteger('HTMLRGB', 'Mode', fRGB.tabColour.PageIndex);
  rgbini.WriteInteger('HTMLRGB', 'Index', fRGB.cPart.ItemIndex);
  for i := 0 to 4 do
    rgbini.WriteString('HTMLRGB', 'Color' + Char(i + 48),
                       TColor_2_Hex(currcol[i]));
  rgbini.Free;
  Halt;
end;

procedure TfRGB.bAboutClick(Sender: TObject);
begin
{
  MessageDlg(fRGB.Caption + #13#10'© 1997-1999 Peter Karlsson'#13#10'A Softwolves Software release in 1999'#13#10 +
             'softwolves@softwolves.pp.se'#13#10'http://www.softwolves.pp.se/',
             mtInformation, [mbOk], 0);
}
  fAbout.ShowModal;
end;

procedure TfRGB.lHTMLClick(Sender: TObject);
begin
  ClipBoard.AsText := fRGB.lHTML.Caption;
end;

procedure TfRGB.GetHSV(var h, s, v: single);
begin
  h := fRGB.sHue.Position / 10;
  s := fRGB.sSaturation.Position / 100;
  v := fRGB.sValue.Position / 100;
end;

{ *** Tilläggsfunktioner *** }

procedure TfRGB.updateHTML2(Sender: TObject);
begin
  updateHTML(false, true);
end;

procedure TfRGB.updateHTML(fromhsv, updatenames: boolean);
var
  rgbcolor: TColor;
  r, g, b, h, s, v: single;
  ir, ig, ib: word;
  st: string;
  i, found: byte;
const
  rect: TRect = (Left: 0; Top: 0; Right: 57;  Bottom: 57);
begin
  if inupdate or not initdone then exit;
  inupdate := true;

  if fromhsv then begin
    GetHSV(h, s, v);
    HSV_2_RGB(r, g, b, h, s, v);
    ir := trunc(r * 255);
    ig := trunc(g * 255);
    ib := trunc(b * 255);
    fRGB.lHTML.Caption := '#' + hex(ir) + hex(ig) + hex(ib);
    fRGB.eHTML.Text := hex(ir) + hex(ig) + hex(ib);
    rgbcolor := ir or longint(ig) shl 8 or longint(ib) shl 16;

    fRGB.sRed.Position := ir;
    fRGB.sGreen.Position := ig;
    fRGB.sBlue.Position := ib;

    Str(ir, st);
    eRed.Text := st;
    Str(ig, st);
    eGreen.Text := st;
    Str(ib, st);
    eBlue.Text := st;
  end else begin
    fRGB.lHTML.Caption := '#' + hex(fRGB.sRed.Position) +
      hex(fRGB.sGreen.Position) + hex(fRGB.sBlue.Position);
    fRGB.eHTML.Text := hex(fRGB.sRed.Position) +
      hex(fRGB.sGreen.Position) + hex(fRGB.sBlue.Position);
    rgbcolor := fRGB.sRed.Position or longint(fRGB.sGreen.Position) shl 8 or
      longint(fRGB.sBlue.Position) shl 16;

    ir := fRGB.sRed.Position;
    ig := fRGB.sGreen.Position;
    ib := fRGB.sBlue.Position;

    r := fRGB.sRed.Position / 255;
    g := fRGB.sGreen.Position / 255;
    b := fRGB.sBlue.Position / 255;
    RGB_2_HSV(r, g, b, h, s, v);

    fRGB.sHue.Position := trunc(h * 10);
    fRGB.sSaturation.Position := trunc(s * 100);
    fRGB.sValue.Position := trunc(v * 100);
    Str(sHue.Position / 10:1:1, st);
    eHue.Text := st;
    Str(sSaturation.Position / 100:1:2, st);
    eSaturation.Text := st;
    Str(sValue.Position / 100:1:2, st);
    eValue.Text := st;
  end;

  fRGB.pColor.Canvas.Brush.Color := rgbcolor;
  fRGB.dColor.Color := rgbcolor;
  fRGB.pColor.Canvas.FillRect(rect);

  currcol[fRGB.cPart.ItemIndex] := rgbcolor;
  case fRGB.cPart.ItemIndex of
    0: begin
         pBackground.Canvas.Brush.Color := rgbcolor;
         pBackground.Canvas.FillRect(rect2);
         lHTMLText.Color  := rgbcolor;
         lHTMLLink.Color  := rgbcolor;
         lHTMLALink.Color := rgbcolor;
         lHTMLVLink.Color := rgbcolor;
       end;
    1: lHTMLText.Font.Color  := rgbcolor;
    2: lHTMLLink.Font.Color  := rgbcolor;
    3: lHTMLALink.Font.Color := rgbcolor;
    4: lHTMLVLink.Font.Color := rgbcolor;
  end;
  lHTMLText.Refresh;
  lHTMLLink.Refresh;
  lHTMLALink.Refresh;
  lHTMLVLink.Refresh;

  If updatenames then begin
    found := 16;
    for i := 0 to 15 do begin
      if (redTable[i] = ir) and (greenTable[i] = ig) and (blueTable[i] = ib) then
        found := i;
    end;

    colours[found].Checked := true;
  end;

  inupdate := false;
end;

procedure TfRGB.RGB_2_HSV(r, g, b: single; var h, s, v: single);
var
  max, min, delta: single;
begin
  max := r;
  if g > max then max := g;
  if b > max then max := b;
  min := r;
  if g < min then min := g;
  if b < min then min := b;
  v := max;

  if max <> 0.0 then
    s := (max - min) / max
  else
    s := 0;

  if s = 0.0 then
    h := 0 { undefined }
  else begin
    delta := max - min;
    if r = max then
      h := (g - b) / delta
    else if g = max then
      h := 2.0 + (b - r) / delta
    else if b = max then
      h := 4.0 + (r - g) / delta;
    h := h * 60.0;
    if (h < 0.0) then h := h + 360.0;
  end;
end;

procedure TfRGB.HSV_2_RGB(var r, g, b: single; h, s, v: single);
var
  f, p, q, t: single;
  i: integer;
begin
  if s = 0 then begin
    r := v;
    g := v;
    b := v;
  end else begin
    if h = 360.0 then h := 0.0;
    h := h / 60.0;
    i := trunc(h);
    f := h - i;
    p := v * (1 - s);
    q := v * (1 - s * f);
    t := v * (1 - s * (1 - f));

    case i of
      0: begin
        r := v;
        g := t;
        b := p;
      end;
      1: begin
        r := q;
        g := v;
        b := p;
      end;
      2: begin
        r := p;
        g := v;
        b := t;
      end;
      3: begin
        r := p;
        g := q;
        b := v;
      end;
      4: begin
        r := t;
        g := p;
        b := v;
      end;
      5: begin
        r := v;
        g := p;
        b := q;
      end;
    end;
  end;
end;

procedure TfRGB.rNameClick(Sender: TObject);
var
  r, g, b: byte;
begin
  { Röd }
  r := redTable[TRadioButton(Sender).Tag];
  g := greenTable[TRadioButton(Sender).Tag];
  b := blueTable[TRadioButton(Sender).Tag];

  sRed.Position := r;
  sGreen.Position := g;
  sBlue.Position := b;
end;

procedure TfRGB.bCopyClick(Sender: TObject);
begin
  ClipBoard.AsText := fRGB.eHTML.Text;
end;


procedure TfRGB.bPasteClick(Sender: TObject);
var
  s: string;
begin
  s := ClipBoard.AsText;
  if length(s) = 6 then
    fRGB.eHTML.Text := s
  else if (s[1] = '#') and (length(s) = 7) then
    fRGB.eHTML.Text := Copy(s, 2, 6);
end;

procedure TfRGB.bSelectClick(Sender: TObject);
var
  r, g, b: byte;
begin
  If dColor.Execute then begin
    r := (dColor.Color and $000000ff);
    g := (dColor.Color and $0000ff00) shr 8;
    b := (dColor.Color and $00ff0000) shr 16;
    sRed.Position   := r;
    sGreen.Position := g;
    sBlue.Position  := b;
  end;
end;

procedure TfRGB.eValueKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If Key = VK_RETURN then eValueChange(Sender);
end;

procedure TfRGB.eHueKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If Key = VK_RETURN then eHueChange(Sender);
end;

procedure TfRGB.eSaturationKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If Key = VK_RETURN then eSaturationChange(Sender);
end;

procedure TfRGB.bDecAll4Click(Sender: TObject);
begin
  sRed.Position   := sRed.Position   - 4;
  sGreen.Position := sGreen.Position - 4;
  sBlue.Position  := sBlue.Position  - 4;
end;

procedure TfRGB.bDecAllClick(Sender: TObject);
begin
  sRed.Position   := sRed.Position   - 1;
  sGreen.Position := sGreen.Position - 1;
  sBlue.Position  := sBlue.Position  - 1;
end;

procedure TfRGB.bIncAllClick(Sender: TObject);
begin
  sRed.Position   := sRed.Position   + 1;
  sGreen.Position := sGreen.Position + 1;
  sBlue.Position  := sBlue.Position  + 1;
end;

procedure TfRGB.bIncAll4Click(Sender: TObject);
begin
  sRed.Position   := sRed.Position   + 4;
  sGreen.Position := sGreen.Position + 4;
  sBlue.Position  := sBlue.Position  + 4;
end;

procedure TfRGB.pBackgroundRedraw(Sender: TObject);
begin
  pBackground.Canvas.Brush.Color := currcol[0];
  pBackground.Canvas.FillRect(rect2);
  lHTMLText.Color  := currcol[0];
  lHTMLLink.Color  := currcol[0];
  lHTMLALink.Color := currcol[0];
  lHTMLVLink.Color := currcol[0];
  lHTMLText.Font.Color  := currcol[1];
  lHTMLLink.Font.Color  := currcol[2];
  lHTMLALink.Font.Color := currcol[3];
  lHTMLVLink.Font.Color := currcol[4];
  lHTMLText.Refresh;
  lHTMLLink.Refresh;
  lHTMLALink.Refresh;
  lHTMLVLink.Refresh;
end;

procedure TfRGB.cPartChange(Sender: TObject);
var
  c: TColor;
begin
  c := currcol[cPart.ItemIndex];
  sRed.Position   :=  c         and 255;
  sGreen.Position := (c shr 8)  and 255;
  sBlue.Position  := (c shr 16) and 255;
  lHTMLText.Update;
  lHTMLLink.Update;
  lHTMLALink.Update;
  lHTMLVLink.Update;
end;

procedure TfRGB.fRGBActivate(Sender: TObject);
begin
  pBackground.Canvas.Brush.Color := currcol[0];
  pBackground.Canvas.FillRect(rect2);
  lHTMLText.Color  := currcol[0];
  lHTMLLink.Color  := currcol[0];
  lHTMLALink.Color := currcol[0];
  lHTMLVLink.Color := currcol[0];
  lHTMLText.Font.Color  := currcol[1];
  lHTMLLink.Font.Color  := currcol[2];
  lHTMLALink.Font.Color := currcol[3];
  lHTMLVLink.Font.Color := currcol[4];
  lHTMLText.Invalidate;
  lHTMLLink.Invalidate;
  lHTMLALink.Invalidate;
  lHTMLVLink.Invalidate;
  initdone := true;
end;

procedure TfRGB.bCopyAllClick(Sender: TObject);
begin
  ClipBoard.AsText := '<body bgcolor="#' + TColor_2_Hex(currcol[0]) +
                      '" text="#'        + TColor_2_Hex(currcol[1]) +
                      '" link="#'        + TColor_2_Hex(currcol[2]) +
                      '" alink="#'       + TColor_2_Hex(currcol[3]) +
                      '" vlink="#'       + TColor_2_Hex(currcol[4]) + '">';
end;

procedure TfRGB.lHTMLTextClick(Sender: TObject);
begin
  cPart.ItemIndex := 1;
  cPartChange(Sender);
end;

procedure TfRGB.lHTMLLinkClick(Sender: TObject);
begin
  cPart.ItemIndex := 2;
  cPartChange(Sender);
end;

procedure TfRGB.lHTMLALinkClick(Sender: TObject);
begin
  cPart.ItemIndex := 3;
  cPartChange(Sender);
end;

procedure TfRGB.lHTMLVlinkClick(Sender: TObject);
begin
  cPart.ItemIndex := 4;
  cPartChange(Sender);
end;

procedure TfRGB.pBackgroundClick(Sender: TObject);
begin
  cPart.ItemIndex := 0;
  cPartChange(Sender);
end;

end.
