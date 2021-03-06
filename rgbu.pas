unit Rgbu;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Clipbrd, IniFiles, TabNotBk, About,
  ComCtrls, Menus, SampleU;

type
  TfRGB = class(TForm)
    gbAll: TGroupBox;
    lHTML: TLabel;
    iPictureRGB: TImage;
    dColor: TColorDialog;
    paColor: TPanel;
    pColor: TPaintBox;
    mRGBMenu: TMainMenu;
    mFile: TMenuItem;
    mFileExit: TMenuItem;
    mView: TMenuItem;
    mViewSampleWindow: TMenuItem;
    mHelp: TMenuItem;
    mHelpAbout: TMenuItem;
    mViewRGB: TMenuItem;
    N1: TMenuItem;
    mViewHSV: TMenuItem;
    mColor: TMenuItem;
    mColorBlack: TMenuItem;
    mColorSilver: TMenuItem;
    mColorGray: TMenuItem;
    mColorWhite: TMenuItem;
    mColorMaroon: TMenuItem;
    mColorRed: TMenuItem;
    mColorPurple: TMenuItem;
    mColorFuchsia: TMenuItem;
    mColorGreen: TMenuItem;
    mColorLime: TMenuItem;
    mColorOlive: TMenuItem;
    mColorYellow: TMenuItem;
    mColorNavy: TMenuItem;
    mColorBlue: TMenuItem;
    mColorTeal: TMenuItem;
    mColorAqua: TMenuItem;
    N2: TMenuItem;
    mColorSelect: TMenuItem;
    lInput1: TLabel;
    lInput2: TLabel;
    lInput3: TLabel;
    eInput3: TEdit;
    eInput2: TEdit;
    eInput1: TEdit;
    sInput1: TScrollBar;
    sInput2: TScrollBar;
    sInput3: TScrollBar;
    bDecAll: TButton;
    bIncAll4: TButton;
    bDecAll4: TButton;
    bIncAll: TButton;
    procedure sInput1Change(Sender: TObject);
    procedure sInput2Change(Sender: TObject);
    procedure sInput3Change(Sender: TObject);
    procedure eInput1Change(Sender: TObject);
    procedure eInput2Change(Sender: TObject);
    procedure eInput3Change(Sender: TObject);
    procedure updateDisplay;
    procedure updateHTML(fromhsv, updatenames: boolean);
    procedure updateHTML2(Sender: TObject);
    procedure bQuitClick(Sender: TObject);
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
    procedure gbAllClick(Sender: TObject);
    procedure mColorClick(Sender: TObject);
    procedure mColorSelectClick(Sender: TObject);
    procedure mHelpAboutClick(Sender: TObject);
    procedure mFileExitClick(Sender: TObject);
    procedure mViewRGBClick(Sender: TObject);
    procedure mViewHSVClick(Sender: TObject);
    procedure mViewSampleWindowClick(Sender: TObject);
  private
    { Private declarations }
    inupdate: boolean;
    { Aktuell f�rg }
    r, g, b: single;
    function hex(b: byte): string;
    function TColor_2_Hex(c: TColor): string;
  public
    { Public declarations }
    rgbmode: boolean;
    currcol: array[0..5]  of TColor;
    redCaption, greenCaption, blueCaption: string;
    hueCaption, saturationCaption, valueCaption: string;
  end;

var
  fRGB: TfRGB;
  rect2: TRect;
  StrRed, StrGreen, StrBlue, StrHue, StrSaturation, StrValue: string;

const
  redTable: array[0..15] of byte =
    ( $0, $c0,$80,$ff,$80,$ff,$80,$ff,$0 ,$0, $80,$ff,$0 ,$0, $0, $0 );
  greenTable: array[0..15] of byte =
    ( $0, $c0,$80,$ff,$0, $0, $0, $0, $80,$ff,$80,$ff,$0 ,$0, $80,$ff);
  blueTable: array[0..15] of byte =
    ( $0, $c0,$80,$ff,$0, $0, $80,$ff,$0, $0, $0, $0, $80,$ff,$80,$ff);
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

{ *** Uppdatera visning *** }

procedure TfRGB.updateDisplay;
Var
  h, s, v: single;
  ir, ig, ib: word;
  text: string;
  rgbcolor: TColor;
  rect: TRect;
begin
  { Undvik o�ndlig rekursion }
  if inupdate or not initdone then exit;
  inupdate := true;

  ir := trunc(r * 255);
  ig := trunc(g * 255);
  ib := trunc(b * 255);

  if rgbmode then
  begin
    { S�tt in RGB-v�rden  }

    { Uppdatera rullningslister }
    sInput1.Position := ir;
    sInput2.Position := ig;
    sInput3.Position := ib;

    { Uppdatera inmatningsf�lt }
    Str(ir, text);
    eInput1.Text := text;
    Str(ig, text);
    eInput2.Text := text;
    Str(ib, text);
    eInput3.Text := text;
  end else begin
    { S�tt in HSV-v�rden  }
    RGB_2_HSV(r, g, b, h, s, v);

    { Uppdatera rullningslister }
    sInput1.Position := trunc(h * 10);
    sInput2.Position := trunc(s * 100);
    sInput3.Position := trunc(v * 100);

    { Uppdatera inmatningsf�lt }
    Str(sInput1.Position / 10:1:1, text);
    eInput1.Text := text;
    Str(sInput2.Position / 100:1:2, text);
    eInput2.Text := text;
    Str(sInput3.Position / 100:1:2, text);
    eInput3.Text := text;
  end;

  { Rita om kvadraten }
  rect.Left  := 0;
  rect.Top   := 0;
  rect.Right := pColor.Width;
  rect.Bottom:= pColor.Height;
  rgbcolor := ir or longint(ig) shl 8 or longint(ib) shl 16;
  pColor.Canvas.Brush.Color := rgbcolor;
  pColor.Color := rgbcolor;
  pColor.Canvas.FillRect(rect);

  { COMCTL-f�rgdialogen }
  dColor.Color := rgbcolor;

  { Uppdatera f�rgnummeretiketten }
  lHTML.Caption := '#' + Hex(ir) + Hex(ig) + Hex(ib);

  { Uppdatera f�rgexempel }
  if fSample.Visible then
    fSample.doUpdate(ir, ig, ib);

  inupdate := false;
end;

{ *** Rullningslister *** }

procedure TfRGB.sInput1Change(Sender: TObject);
begin
  if not inupdate then begin
    if rgbmode then begin
      r := sInput3.Position / 255;
    end else begin
      HSV_2_RGB(r, g, b,
                sInput1.Position / 10,
                sInput2.Position / 100,
                sinput3.Position / 100);
    end;
    updateDisplay;
  end;
end;

procedure TfRGB.sInput2Change(Sender: TObject);
begin
  if not inupdate then begin
    if rgbmode then begin
      g := sInput2.Position / 255;
    end else begin
      HSV_2_RGB(r, g, b,
                sInput1.Position / 10,
                sInput2.Position / 100,
                sinput3.Position / 100);
    end;
    updateDisplay;
  end;
end;

procedure TfRGB.sInput3Change(Sender: TObject);
begin
  if not inupdate then begin
    if rgbmode then begin
      b := sInput3.Position / 255;
    end else begin
      HSV_2_RGB(r, g, b,
                sInput1.Position / 10,
                sInput2.Position / 100,
                sinput3.Position / 100);
    end;
    updateDisplay;
  end;
end;

{ *** Redigeringsrutor *** }

procedure TfRGB.eInput1Change(Sender: TObject);
Var
  v: single;
  t: integer;
begin
  if (eInput1.Text <> '') and (not inupdate) then begin
    Val(eInput1.Text, v, t);
    if t = 0 then begin
      if rgbmode then begin
        r := v / 255;
      end else begin
      HSV_2_RGB(r, g, b,
                v,
                sInput2.Position / 100,
                sinput3.Position / 100);
      end;
      updateDisplay;
    end;
  end;
end;

procedure TfRGB.eInput2Change(Sender: TObject);
Var
  v: single;
  t: integer;
begin
  if (eInput2.Text <> '') and (not inupdate) then begin
    Val(eInput2.Text, v, t);
    if t = 0 then begin
      if rgbmode then begin
        g := v / 255;
      end else begin
      HSV_2_RGB(r, g, b,
                sInput1.Position / 10,
                v,
                sinput3.Position / 100);
      end;
      updateDisplay;
    end;
  end;
end;

procedure TfRGB.eInput3Change(Sender: TObject);
Var
  v: single;
  t: integer;
begin
  if (eInput2.Text <> '') and (not inupdate) then begin
    Val(eInput2.Text, v, t);
    if t = 0 then begin
      if rgbmode then begin
        b := v / 255;
      end else begin
      HSV_2_RGB(r, g, b,
                sInput1.Position / 10,
                sInput2.Position / 100,
                v);
      end;
      updateDisplay;
    end;
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

{ *** Till�ggsfunktioner *** }

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
  rect: TRect;
begin
  if inupdate or not initdone then exit;
  inupdate := true;
  rect.Left := 0;
  rect.Top := 0;
  rect.Right := pColor.Width;
  rect.Bottom := pColor.Height;

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
  { R�d }
  r := redTable[TRadioButton(Sender).Tag];
  g := greenTable[TRadioButton(Sender).Tag];
  b := blueTable[TRadioButton(Sender).Tag];

  sRed.Position := r;
  sGreen.Position := g;
  sBlue.Position := b;
end;


procedure TfRGB.mColorSelectClick(Sender: TObject);
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
  rect2.Left := 0;
  rect2.Top := 0;
  rect2.Right := pBackground.Width;
  rect2.Bottom := pBackground.Height;
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
  lInput1.Caption := redCaption;
  lInput2.Caption := greenCaption;
  lInput3.Caption := blueCaption;
  { Hj�lpetiketter TODO }
  initdone := true;
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

procedure TfRGB.mColorClick(Sender: TObject);
var
  r, g, b: byte;
begin
  { Get colors associated with menu entry }
  r := redTable[TMenuItem(Sender).Tag];
  g := greenTable[TMenuItem(Sender).Tag];
  b := blueTable[TMenuItem(Sender).Tag];

  sRed.Position := r;
  sGreen.Position := g;
  sBlue.Position := b;
end;

procedure TfRGB.mHelpAboutClick(Sender: TObject);
begin
{
  MessageDlg(fRGB.Caption + #13#10'� 1997-1999 Peter Karlsson'#13#10'A Softwolves Software release in 1999'#13#10 +
             'softwolves@softwolves.pp.se'#13#10'http://www.softwolves.pp.se/',
             mtInformation, [mbOk], 0);
}
  fAbout.ShowModal;
end;

procedure TfRGB.mFileExitClick(Sender: TObject);
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

procedure TfRGB.mViewRGBClick(Sender: TObject);
begin
  inupdate := true;
  rgbmode := true;
  { S�tt etiketter till RGB }
  lInput1.Caption := redCaption;
  lInput2.Caption := greenCaption;
  lInput3.Caption := blueCaption;
  { Hj�lpetiketter TODO }

  { L�s in RGB-v�rden TODO }
  { St�ll in redigeringsrutor och rullningslister TODO }
  sInput1.max := 255;
  sInput2.max := 255;
  sInput3.max := 255;

  inupdate := false;
end;

procedure TfRGB.mViewHSVClick(Sender: TObject);
begin
  inupdate := true;
  rgbmode := false;
  { S�tt etiketter till HSV }
  lInput1.Caption := hueCaption;
  lInput2.Caption := saturationCaption;
  lInput3.Caption := valueCaption;
  { Hj�lpetiketter TODO }

  { L�s in RGB-v�rden TODO }
  { Konvertera till HSV TODO }
  { St�ll in redigeringsrutor och rullningslister TODO }
  sInput1.max := 3600;
  sInput2.max := 100;
  sInput3.max := 100;

  inupdate := false;
end;

procedure TfRGB.mViewSampleWindowClick(Sender: TObject);
begin
  if (fSample.Visible) then
    fSample.Hide
  else begin
    fSample.Top := Top + Height;
    fSample.Left := Left;
    fSample.Show;
  end;
end;

end.
