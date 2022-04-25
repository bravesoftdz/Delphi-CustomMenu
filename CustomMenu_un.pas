unit CustomMenu_un;

interface

uses
  FMX.Layouts,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Forms,
  FMX.Types,
  FMX.Graphics,
  System.UITypes,
  System.Classes,
  System.SysUtils,
  FMX.Dialogs;

type
  TCustomMenu = class
  private
    { Private declarations }
    lytMenu: TLayout;
    rectFundo: TRectangle;
    lytBody: TLayout;
    itemCancelar: TRectangle;
    lblItemCancelar: TLabel;
  public
    { Public declarations }
    constructor Create(frm: TForm);
    procedure ShowMenu;
    procedure HideMenu;
    procedure HideMenuClick(Sender: TObject);
    procedure AddItem(AItemText: string; AItemClick: TNotifyEvent);
  end;

implementation

constructor TCustomMenu.Create(frm: TForm);
begin
  lytMenu := TLayout.Create(frm);
  with lytMenu do
  begin
    Align := TAlignLayout.Contents;
    parent := frm;
    Visible := false;
  end;

  rectFundo := TRectangle.Create(frm);
  with rectFundo do
  begin
    parent := lytMenu;
    Align := TAlignLayout.Contents;

    HitTest := True;
    OnClick := HideMenuClick;

    Fill.Kind := TBrushKind.Solid;
    Fill.Color := TAlphaColorRec.Black;
    Opacity := 0.6;
    Stroke.Kind := TBrushKind.None;
  end;

  lytBody := TLayout.Create(frm);
  with lytBody do
  begin
    parent := lytMenu;
    Align := TAlignLayout.Contents;
    BringToFront;
  end;
end;

procedure TCustomMenu.ShowMenu;
begin
  lytBody.Position.Y := lytMenu.Height + 20;

  rectFundo.Opacity := 0;
  rectFundo.AnimateFloat('Opacity', 0.4, 0.2);

  lytBody.AnimateFloat('Position.Y', lytMenu.Height - lytBody.Height, 0.5,
    TAnimationType.InOut, TInterpolationType.Circular);

  lytMenu.Visible := True;
end;

procedure TCustomMenu.HideMenu;
begin
  lytBody.AnimateFloat('Position.Y', lytMenu.Height + 20, 0.3,
    TAnimationType.InOut, TInterpolationType.Circular);

  rectFundo.AnimateFloat('Opacity', 0, 0.6);

  TThread.CreateAnonymousThread(
    procedure
    begin
      sleep(800);
      lytMenu.Visible := false;
    end).Start;
end;

procedure TCustomMenu.HideMenuClick(Sender: TObject);
begin
  HideMenu;
end;

procedure TCustomMenu.AddItem(AItemText: string; AItemClick: TNotifyEvent);
begin
  itemCancelar := TRectangle.Create(lytBody);
  with itemCancelar do
  begin
    parent := lytBody;
    Align := TAlignLayout.Bottom;
    BringToFront;
    Height := 48;

    Fill.Kind := TBrushKind.Solid;
    Fill.Color := TAlphaColorRec.White;
    Opacity := 1;
    Stroke.Kind := TBrushKind.None;

    HitTest := false;

    XRadius := 6;
    YRadius := 6;

    Margins.Bottom := 16;
    Margins.Left := 16;
    Margins.Right := 16;

// Corners := []
  end;

  lblItemCancelar := TLabel.Create(lytBody);
  with lblItemCancelar do
  begin
    parent := itemCancelar;
    Align := TAlignLayout.Contents;
    BringToFront;

    HitTest := True;
    OnClick := AItemClick;

    Text := AItemText;

    StyledSettings := StyledSettings - [TStyledSetting.Size];
    Font.Size := 16;
    TextAlign := TTextAlign.Center;

    Margins.Left := 8;
  end;
end;

end.
