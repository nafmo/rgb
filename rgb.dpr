program Rgb;

uses
  Forms,
  Rgbu in 'RGBU.PAS' {fRGB},
  IniFiles;

{$R *.RES}
var
  rgbini: TIniFile;
  lang: string;
  ch: char;
begin
  { Startvärden för programmet }
  Application.Title := 'RödGrönBlå';
  Application.CreateForm(TfRGB, fRGB);
  { Lägg in färgknapparna i en vektor }
  fRGB.colours[0] := fRGB.rBlack;
  fRGB.colours[1] := fRGB.rSilver;
  fRGB.colours[2] := fRGB.rGray;
  fRGB.colours[3] := fRGB.rWhite;
  fRGB.colours[4] := fRGB.rMaroon;
  fRGB.colours[5] := fRGB.rRed;
  fRGB.colours[6] := fRGB.rPurple;
  fRGB.colours[7] := fRGB.rFuchsia;
  fRGB.colours[8] := fRGB.rGreen;
  fRGB.colours[9] := fRGB.rLime;
  fRGB.colours[10]:= fRGB.rOlive;
  fRGB.colours[11]:= fRGB.rYellow;
  fRGB.colours[12]:= fRGB.rNavy;
  fRGB.colours[13]:= fRGB.rBlue;
  fRGB.colours[14]:= fRGB.rTeal;
  fRGB.colours[15]:= fRGB.rAqua;
  fRGB.colours[16]:= fRGB.rOther;
  { Hämta inställningar }
  rgbini := TIniFile.Create('win.ini');
  fRGB.sRed.Position   := rgbini.ReadInteger('HTMLRGB', 'R', 0);
  fRGB.sGreen.Position := rgbini.ReadInteger('HTMLRGB', 'G', 0);
  fRGB.sBlue.Position  := rgbini.ReadInteger('HTMLRGB', 'B', 0);
  If (ParamStr(1) <> '-') and (ParamStr(2) <> '-') then begin
    fRGB.Left := rgbini.ReadInteger('HTMLRGB', 'X',
                                    (Screen.Width -  fRGB.Width)  shr 1);
    fRGB.Top  := rgbini.ReadInteger('HTMLRGB', 'Y',
                                    (Screen.Height - fRGB.Height) shr 1);
  end else begin
    fRGB.Left := (Screen.Width -  fRGB.Width)  shr 1;
    fRGB.Top  := (Screen.Height - fRGB.Height) shr 1;
  end;
  fRGB.tabColour.PageIndex := rgbini.ReadInteger('HTMLRGB', 'Mode', 0);
  fRGB.rgbmode := true;
  { Språkval }
  if (Paramcount >= 1) and (ParamStr(1) <> '-') then begin
    lang := Paramstr(1);
    ch := lang[1];
    case UpCase(ch) of
      'S':  lang := 'sve';
      'D':  lang := 'deu';
      'F':  lang := 'fra';
      'P':  lang := 'esp';
      else  lang := 'eng';
    end;
  end else begin
    lang := rgbini.ReadString('intl', 'sLanguage', 'eng');
    if lang = 'enu' then lang := 'eng';
    if lang = 'frc' then lang := 'fra';
    if lang = 'esn' then lang := 'esp';
    if (lang <> 'eng') and (lang <> 'sve') and (lang <> 'deu') and
       (lang <> 'fra') and (lang <> 'esp') then
      lang := 'eng';
  end;
  if lang = 'sve' then begin
    fRGB.rBlack.Hint := 'Svart';
    fRGB.rSilver.Hint := 'Silver';
    fRGB.rGray.Hint := 'Grå';
    fRGB.rWhite.Hint := 'Vit';
    fRGB.rMaroon.Hint := 'Rödbrun';
    fRGB.rRed.Hint := 'Röd';
    fRGB.rPurple.Hint := 'Purpur';
    fRGB.rFuchsia.Hint := 'Lila';
    fRGB.rGreen.Hint := 'Grön';
    fRGB.rLime.Hint := 'Limefärgad';
    fRGB.rOlive.Hint := 'Olivfärgad';
    fRGB.rYellow.Hint := 'Gul';
    fRGB.rNavy.Hint := 'Marinblå';
    fRGB.rBlue.Hint := 'Blå';
    fRGB.rTeal.Hint := 'Cyan';
    fRGB.rAqua.Hint := 'Ljus cyan';
  end else if lang = 'eng' then begin
    Application.Title := 'RedGreenBlue';
    fRGB.Caption := 'RedGreenBlue 1.1';
    fRGB.gbSkrollar.Caption := 'Colour settings';
    fRGB.lRed.Caption := '&Red:';
    fRGB.lGreen.Caption := '&Green:';
    fRGB.lBlue.Caption := '&Blue:';
    fRGB.lHue.Caption := '&Hue:';
    fRGB.lSaturation.Caption := '&Saturation';
    fRGB.lValue.Caption := '&Value:';

    fRGB.bQuit.Caption := 'E&xit';
    fRGB.bAbout.Caption := '&About';

    fRGB.eRed.Hint := 'Red colour value (0-255)';
    fRGB.eGreen.Hint := 'Green colour value (0-255)';
    fRGB.eBlue.Hint := 'Blue colour value (0-255)';
    fRGB.sRed.Hint := 'Red colour control';
    fRGB.sGreen.Hint := 'Green colour control';
    fRGB.sBlue.Hint := 'Blue colour control';

    fRGB.eHue.Hint := 'Hue (0-360°)';
    fRGB.eSaturation.Hint := 'Colour saturation (0-1)';
    fRGB.eValue.Hint := 'Colour value (0-1)';
    fRGB.sHue.Hint := 'Hue control';
    fRGB.sSaturation.Hint := 'Saturation control';
    fRGB.sValue.Hint := 'Colour value control';

    fRGB.pColor.Hint := 'Colour sample';
    fRGB.bAbout.Hint := 'Information about the program';
    fRGB.bQuit.Hint := 'Exit the program';
    fRGB.lHTML.Hint := 'HTML colour code. Click to copy to the clipboard';

    fRGB.tabColour.Pages[2] := 'HTML &names';

    fRGB.rOther.Caption := 'Other';
  end else if lang ='deu' then begin
    Application.Title := 'RotGrünBlau';
    fRGB.Caption := 'RotGrünBlau 1.1';
    fRGB.gbSkrollar.Caption := 'Farbeinstellungen';
    fRGB.lRed.Caption := '&Rot:';
    fRGB.lGreen.Caption := '&Grün:';
    fRGB.lBlue.Caption := '&Blau:';
    fRGB.lHue.Caption := '&Farbe:';
    fRGB.lSaturation.Caption := '&Sättigung:';
    fRGB.lValue.Caption := '&Wert:';

    fRGB.bQuit.Caption := '&Verlassen';
    fRGB.bAbout.Caption := '&Über';

    fRGB.eRed.Hint := 'Farbwert rot (0-255)';
    fRGB.eGreen.Hint := 'Farbwert grün (0-255)';
    fRGB.eBlue.Hint := 'Farbwert blau (0-255)';
    fRGB.sRed.Hint := 'Farbsteuerung rot';
    fRGB.sGreen.Hint := 'Farbsteuerung blau';
    fRGB.sBlue.Hint := 'Farbsteuerung grün';

    fRGB.eHue.Hint := 'Farbe (0-360°)';
    fRGB.eSaturation.Hint := 'Farbensättigung (0-1)';
    fRGB.eValue.Hint := 'Farbwert (0-1)';
    fRGB.sHue.Hint := 'Farbsteurung';
    fRGB.sSaturation.Hint := 'Farbensättigungsteurung';
    fRGB.sValue.Hint := 'Farbwertsteurung';

    fRGB.pColor.Hint := 'Farbbeispiel';
    fRGB.bAbout.Hint := 'Programminformation';
    fRGB.bQuit.Hint := 'Programm verlassen';
    fRGB.lHTML.Hint := 'HTML-farbcode. Anklicken um im Clipboard hinzufügen';

    fRGB.tabColour.Pages[2] := 'HTML-&Namem';

    fRGB.rOther.Caption := 'Andere';

    fRGB.rBlack.Hint := 'Schwarz';
    fRGB.rSilver.Hint := 'Silber';
    fRGB.rGray.Hint := 'Grau';
    fRGB.rWhite.Hint := 'Weiß';
    fRGB.rMaroon.Hint := 'Kastanienbraun';
    fRGB.rRed.Hint := 'Rot';
    fRGB.rPurple.Hint := 'Purpurrot';
    fRGB.rFuchsia.Hint := 'Lila';
    fRGB.rGreen.Hint := 'Grün';
    fRGB.rLime.Hint := 'Limefarbe';
    fRGB.rOlive.Hint := 'Olivgrün';
    fRGB.rYellow.Hint := 'Gelb';
    fRGB.rNavy.Hint := 'Marineblau';
    fRGB.rBlue.Hint := 'Blau';
    fRGB.rTeal.Hint := 'Zyan';
    fRGB.rAqua.Hint := 'Hellzyan';
  end else if lang = 'fra' then begin
    Application.Title := 'RougeVertBleu';
    fRGB.Caption := 'RougeVertBleu 1.1';
    fRGB.gbSkrollar.Caption := 'Couleur';
    fRGB.lRed.Caption := '&Rouge:';
    fRGB.lGreen.Caption := '&Vert:';
    fRGB.lBlue.Caption := '&Bleu:';
    fRGB.lHue.Caption := '&Tonalité:';
    fRGB.lSaturation.Caption := '&Saturation';
    fRGB.lValue.Caption := '&Valeur:';

    fRGB.bQuit.Caption := '&Quitter';
    fRGB.bAbout.Caption := '&Information';

    fRGB.eRed.Hint := 'Valeur du rouge (0-255)';
    fRGB.eGreen.Hint := 'Valeur du vert (0-255)';
    fRGB.eBlue.Hint := 'Valeur du bleu (0-255)';
    fRGB.sRed.Hint := 'Contrôle du rouge';
    fRGB.sGreen.Hint := 'Contrôle du vert';
    fRGB.sBlue.Hint := 'Contrôle du bleu';

    fRGB.eHue.Hint := 'Tonalité (0-360°)';
    fRGB.eSaturation.Hint := 'Saturation de couleur (0-1)';
    fRGB.eValue.Hint := 'Valeur de couleur (0-1)';
    fRGB.sHue.Hint := 'Contrôle de tonalité';
    fRGB.sSaturation.Hint := 'Contrôle de saturation';
    fRGB.sValue.Hint := 'Contrôle de valeur de couleur';

    fRGB.pColor.Hint := 'Échantillon de la couleur';
    fRGB.bAbout.Hint := 'Information sur le programma';
    fRGB.bQuit.Hint := 'Quitter le programme';
    fRGB.lHTML.Hint := 'Code HTML de la couleur. Cliquez pour copier vers le presse-papiers';

    fRGB.tabColour.Pages[2] := 'HTML &Noms';

    fRGB.rOther.Caption := 'Autre';

    fRGB.rBlack.Hint := 'Noire';
    fRGB.rSilver.Hint := 'Argent';
    fRGB.rGray.Hint := 'Grise';
    fRGB.rWhite.Hint := 'Blanche';
    fRGB.rMaroon.Hint := 'Marron';
    fRGB.rRed.Hint := 'Rouge';
    fRGB.rPurple.Hint := 'Pourpre';
    fRGB.rFuchsia.Hint := '[Lila]';
    fRGB.rGreen.Hint := 'Verte';
    fRGB.rLime.Hint := '[Limefarbe]';
    fRGB.rOlive.Hint := 'Olive';
    fRGB.rYellow.Hint := 'Jaune';
    fRGB.rNavy.Hint := '[Marine]';
    fRGB.rBlue.Hint := 'Bleue';
    fRGB.rTeal.Hint := '[Zyan]';
    fRGB.rAqua.Hint := '[Hellzyan]';
  end else if lang = 'esp' then begin
    Application.Title := 'RödGrönBlå';
    fRGB.Caption := 'RojoVerdeAzul 1.1';
    fRGB.gbSkrollar.Caption := 'Color';
    fRGB.lRed.Caption := '&Rojo:';
    fRGB.lGreen.Caption := '&Verde:';
    fRGB.lBlue.Caption := '&Azul:';
    fRGB.lHue.Caption := '&Tonalidad';
    fRGB.lSaturation.Caption := '&Saturación';
    fRGB.lValue.Caption := '&Valor:';

    fRGB.bQuit.Caption := '&Fin';
    fRGB.bAbout.Caption := '&Información';

    fRGB.eRed.Hint := 'Valor del color rojo (0-255)';
    fRGB.eGreen.Hint := 'Valor del color verde (0-255)';
    fRGB.eBlue.Hint := 'Valor del color azul (0-255)';
    fRGB.sRed.Hint := 'Control del color rojo';
    fRGB.sGreen.Hint := 'Control del color verde';
    fRGB.sBlue.Hint := 'Control del color azul';

    fRGB.eHue.Hint := '[Tonalidad] (0-360°)';
    fRGB.eSaturation.Hint := '[Saturación] (0-1)';
    fRGB.eValue.Hint := '[Valor] (0-1)';
    fRGB.sHue.Hint := 'Control de la tonalidad';
    fRGB.sSaturation.Hint := 'Control de la saturación del color';
    fRGB.sValue.Hint := 'Control del valor del color';

    fRGB.pColor.Hint := 'Muestra del color';
    fRGB.bAbout.Hint := 'Información sobre el programa';
    fRGB.bQuit.Hint := 'Cerrar el programa';
    fRGB.lHTML.Hint := 'Código HTML del color. Pinche para copiar en el pisapeles';

    fRGB.tabColour.Pages[2] := 'HTML &Nombres';

    fRGB.rOther.Caption := 'Otro';

    fRGB.rBlack.Hint := 'Negro';
    fRGB.rSilver.Hint := 'Plata';
    fRGB.rGray.Hint := 'Gris';
    fRGB.rWhite.Hint := 'Blanco';
    fRGB.rMaroon.Hint := 'Marrón';
    fRGB.rRed.Hint := 'Rojo';
    fRGB.rPurple.Hint := 'Púrpura';
    fRGB.rFuchsia.Hint := '[Lila]';
    fRGB.rGreen.Hint := 'Verde';
    fRGB.rLime.Hint := '[Limefarbe]';
    fRGB.rOlive.Hint := 'Oliva';
    fRGB.rYellow.Hint := 'Amarillo';
    fRGB.rNavy.Hint := '[Marina]';
    fRGB.rBlue.Hint := 'Azul';
    fRGB.rTeal.Hint := '[Zyan]';
    fRGB.rAqua.Hint := '[Hellzyan]';
  end;
  { Vi behöver inte INI-filen mer nu }
  rgbini.Free;
  { Kör }
  Application.Run;
end.
