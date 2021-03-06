unit CreatorForm;

interface

uses
  Messages, Classes, Graphics, Controls, Forms, Dialogs, Spin, ComCtrls,
  StdCtrls, ExtCtrls, GraphicEx, Types, XMLDoc, XMLIntf,
  InputFilterFunctions;

type
  TfrmCreator = class(TForm)
    pgcMain: TPageControl;
    pgcMain3: TTabSheet;
    pgcMain4: TTabSheet;
    pgcMain1: TTabSheet;
    pgcMain6: TTabSheet;
    pgcMain5: TTabSheet;
    pgcMain2: TTabSheet;
    cobCategory: TComboBox;
    cobSubcategory: TComboBox;
    edtTitle: TEdit;
    lblCategory: TLabel;
    lblDescription: TLabel;
    lblExe: TLabel;
    lblSubcategory: TLabel;
    lblTitle: TLabel;
    memDescription: TMemo;
    pnlExe: TPanel;
    edtExe: TEdit;
    btnExe: TButton;
    edtMail: TEdit;
    edtName: TEdit;
    edtWebsite: TEdit;
    grbAppAuthor: TGroupBox;
    lblAppAuthor: TLabel;
    lblAppWebsite: TLabel;
    lblAppMail: TLabel;
    edtAppAuthor: TEdit;
    edtAppWebsite: TEdit;
    edtAppMail: TEdit;
    lblMail: TLabel;
    lblName: TLabel;
    lblWebsite: TLabel;
    memAuthorHelp: TMemo;
    grbLicense: TGroupBox;
    lblLicense: TLabel;
    lblLicenseURL: TLabel;
    lblSourceURL: TLabel;
    edtLicenseURL: TEdit;
    edtSourceURL: TEdit;
    memLicenseHelp: TMemo;
    cobLicense: TComboBox;
    pnlButtons: TPanel;
    btnNext: TButton;
    btnCancel: TButton;
    cbxPort: TCheckBox;
    memHello: TMemo;
    lblErrors: TLabel;
    redErrors: TRichEdit;
    grbScreenshots: TGroupBox;
    grbIcon: TGroupBox;
    pnlIcon: TPanel;
    lblIcon: TLabel;
    pnlIconPath: TPanel;
    edtIcon: TEdit;
    btnIcon: TButton;
    lblIconInfo: TLabel;
    memScreenshotsHelp: TMemo;
    opdIcon: TOpenDialog;
    scbScreenshots: TScrollBox;
    pnlScreenButtons: TPanel;
    btnScreenAdd: TButton;
    imgIcon: TImage;
    btnPrev: TButton;
    btnRemove: TButton;
    grbExeSettings: TGroupBox;
    cbxExeSettings: TCheckBox;
    lblStartdir: TLabel;
    edtArguments: TEdit;
    lblArguments: TLabel;
    grbVersion: TGroupBox;
    pnlVMajor: TPanel;
    lblVMajor: TLabel;
    spbVMajor: TSpinButton;
    edtVMajor: TEdit;
    pnlVMinor: TPanel;
    lblVMinor: TLabel;
    spbVMinor: TSpinButton;
    edtVMinor: TEdit;
    pnlVRelease: TPanel;
    lblVRelease: TLabel;
    spbVRelease: TSpinButton;
    edtVRelease: TEdit;
    pnlVBuild: TPanel;
    lblVBuild: TLabel;
    spbVBuild: TSpinButton;
    edtVBuild: TEdit;
    pnlVType: TPanel;
    lblVType: TLabel;
    cobVType: TComboBox;
    sadPXML: TSaveDialog;
    memDetailsHelp: TMemo;
    grbInfo: TGroupBox;
    lblInfoFile: TLabel;
    Panel1: TPanel;
    edtInfoFile: TEdit;
    btnInfoFile: TButton;
    lblInfoName: TLabel;
    edtInfoName: TEdit;
    grbAdvanced: TGroupBox;
    lblID: TLabel;
    lblAppdata: TLabel;
    edtID: TEdit;
    memAdvancedHelp: TMemo;
    cbxAdvanced: TCheckBox;
    memIDHelp: TMemo;
    edtAppdata: TEdit;
    memAppdataHelp: TMemo;
    memInfo: TMemo;
    btnStartdir: TButton;
    edtStartdir: TEdit;
    Panel2: TPanel;
    memDescriptionHelp: TMemo;
    procedure btnInfoFileClick(Sender: TObject);
    procedure btnExeClick(Sender: TObject);
    procedure btnStartdirClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure cbxExeSettingsClick(Sender: TObject);
    procedure btnScreenAddClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnIconClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pgcMainChange(Sender: TObject);
    procedure edtIconExit(Sender: TObject);
    procedure cbxAdvancedClick(Sender: TObject);
    procedure cobLicenseChange(Sender: TObject);
    procedure spbVMajorUpClick(Sender: TObject);
    procedure spbVMajorDownClick(Sender: TObject);
    procedure cobCategoryChange(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure cbxPortClick(Sender: TObject);
  private
    FFilename : String;
    procedure ChangeVersionNumber(Target: TCustomEdit; const Delta: Integer);
    procedure AddError(const TextToAdd : String; const Color: TColor = clBlack);
    procedure CheckForErrors;
    function SavePXMLFile(const Filename : String) : Boolean;
    procedure LoadIcon(const Filename : String);
    function GetIconFilename : String;
  public
    function Execute : Boolean;
    property Filename : String read FFilename;     
    property IconFilename : String read GetIconFilename;
    { Public declarations }
  end;

  TScreenshotPanel = class (TCustomPanel)
    imgScreenshot: TImage;
    pnlText: TPanel;
    pnlButtons: TPanel;
    lblPath: TLabel;
    lblSize: TLabel;
    btnRemove: TButton;
    btnMoveUp: TButton;
    btnMoveDown: TButton;
    procedure btnRemoveClick(Sender: TObject);
    procedure btnMoveUpClick(Sender: TObject);
    procedure btnMoveDownClick(Sender: TObject); 
  private
    pFilepath : String; 
    constructor Create(AOwner : TComponent); reintroduce; overload;
  public
    // Double linked list for ordering  
    Prev : TScreenshotPanel;
    Next : TScreenshotPanel;
    constructor Create(const Filepath: String; const ImageFile : String); reintroduce; overload;
    property Filepath : String read pFilepath;
  end;

  TStringPair = class
      S1 : String;
      S2 : String;
  end;

const                   
    CATEGORIES_FILE : String       = 'tools\Categories.txt';
    LICENSES_FILE   : String       = 'tools\Licenses.txt';
    PXML_NAMESPACE : String        = 'http://openpandora.org/namespaces/PXML';

var
  frmCreator: TfrmCreator;
  InputFilter: TInputFilters;
  First : TScreenshotPanel;
  Successful : Boolean;

implementation

uses {$Ifdef Win32}ControlHideFix,{$Endif} MainForm, FileSelectForm, StrUtils,
    SysUtils, VSTUtils, VirtualTrees, GraphicUtils;

{$R *.dfm}

procedure TfrmCreator.ChangeVersionNumber(Target: TCustomEdit; const Delta: Integer);
var temp : Integer;
begin
    // TODO: Extract numbers from Strings with letters also
    try
        temp := StrToInt(Target.Text);
    except
        Exit;
    end;
    if (temp > 0) OR ((Target.Text = '0') AND (Delta > 0)) then
        Target.Text := IntToStr(temp+Delta);
end;

procedure TfrmCreator.AddError(const TextToAdd : String; const Color: TColor = clBlack);
var
    Count : Integer;
begin
    Count := Length(redErrors.Text);
    redErrors.Lines.Add(TextToAdd);
    redErrors.SelStart := count;
    redErrors.SelLength := Length(redErrors.Text) - redErrors.SelStart;
    redErrors.SelAttributes.Color := Color;
    redErrors.SelLength := 0;
end;

procedure TfrmCreator.CheckForErrors;
begin         
    redErrors.Clear;
    // Page 2
    if (Length(edtName.Text) = 0) then
        AddError('Invalid or no author name specified!',frmMain.LOG_ERROR_COLOR);
    if (cbxPort.Checked) AND (Length(edtAppAuthor.Text) = 0) then
        AddError('Invalid or no name for the application author entered!',frmMain.LOG_ERROR_COLOR);
    // Page 3
    if (Length(edtTitle.Text) = 0) then
        AddError('Invalid or no title set!',frmMain.LOG_ERROR_COLOR);
    if Length(edtExe.Text) = 0 then
        AddError('No executable specified!',frmMain.LOG_ERROR_COLOR)
    else if CheckForExistance(frmMain.vstFiles,edtExe.Text) = nil then
        AddError('The selected executable does not exist!',frmMain.LOG_ERROR_COLOR);
    if Length(cobCategory.Text) = 0 then
        AddError('No category specified!',frmMain.LOG_ERROR_COLOR);
    if Length(cobSubcategory.Text) = 0 then
        AddError('No sub-category set!',frmMain.LOG_ERROR_COLOR);
    // Page 4
    if Length(edtIcon.Text) = 0 then
        AddError('No icon specified!',frmMain.LOG_ERROR_COLOR)
    else if CheckForExistance(frmMain.vstFiles,edtIcon.Text) = nil then
        AddError('The specified icon does not exist!',frmMain.LOG_ERROR_COLOR);
    if First = nil then
        AddError('No screenshots added!',frmMain.LOG_ERROR_COLOR);
    // Page 5
    if Length(cobLicense.Text) = 0 then
        AddError('No license set!',frmMain.LOG_ERROR_COLOR);
    if cbxAdvanced.Checked then
    begin
        if Length(edtID.Text) = 0 then
            AddError('Invalid ID entered!',frmMain.LOG_ERROR_COLOR);
        if Length(edtAppdata.Text) = 0 then
            AddError('Invalid appdata directory entered!',frmMain.LOG_ERROR_COLOR);
    end;
    

    if redErrors.Lines.Count = 0 then
    begin
        AddError('All valid, good job! The PXML can now be created by pressing the ''Finish'' button at the bottom.',frmMain.LOG_SUCCESS_COLOR);
        btnNext.Enabled := true;
    end else
    begin  
        AddError('You need to go back and fix these errors before the PXML can be created.',frmMain.LOG_ERROR_COLOR);
        btnNext.Enabled := false;
    end;
end;

function TfrmCreator.SavePXMLFile(const Filename: string) : Boolean;

    function CreateNode(Name : String; Parent : IXMLNode) : IXMLNode;
    begin
        Result := Parent.AddChild(Name,PXML_NAMESPACE);
    end;

    // A few "makros" for data used in both package and application nodes
    procedure SetAuthorInfo(Node : IXMLNode; const Name, Website, Mail : TCustomEdit);
    begin
        Node.Attributes['name'] := Name.Text;
        if Length(Website.Text) > 0 then
            Node.Attributes['website'] := Website.Text;
        if Length(Mail.Text) > 0 then
            Node.Attributes['email'] := Mail.Text;
    end;
    procedure SetVersionInfo(Node : IXMLNode);
    begin
        Node.Attributes['major'] := edtVMajor.Text;
        Node.Attributes['minor'] := edtVMinor.Text;
        Node.Attributes['release'] := edtVRelease.Text;
        Node.Attributes['build'] := edtVBuild.Text;
        if Length(cobVType.Text) > 0 then
            Node.Attributes['type'] := cobVType.Text;
    end;
    procedure SetTitleDescrInfo(Node : IXMLNode);
    var temp : IXMLNode;
    begin
        temp := CreateNode('title',CreateNode('titles',Node));
        temp.Attributes['lang'] := 'en_US';
        temp.NodeValue := edtTitle.Text;
        temp := CreateNode('description',CreateNode('descriptions',Node));
        temp.Attributes['lang'] := 'en_US';
        temp.NodeValue := memDescription.Text;
    end;

var Doc : IXMLDocument;
    temp, packNode, appNode, pxmlNode : IXMLNode;
    tempScreen : TScreenshotPanel;
begin
    Result := false;
    try
        Doc := NewXMLDocument('1.0');
        Doc.Encoding := 'UTF-8';
        Doc.Options := [doNodeAutoCreate,doNodeAutoIndent];
        pxmlNode := Doc.AddChild('PXML',PXML_NAMESPACE);

        // package
        packNode := CreateNode('package',pxmlNode);
        packNode.Attributes['id'] := edtID.Text;

        SetAuthorInfo(CreateNode('author',packNode),edtName,edtWebsite,edtMail);
        SetVersionInfo(CreateNode('version',packNode));
        SetTitleDescrInfo(packNode);
        temp := CreateNode('icon',packNode);
        temp.Attributes['src'] := edtIcon.Text;

        // application
        appNode := CreateNode('application',pxmlNode);
        appNode.Attributes['id'] := edtID.Text;
        if Length(edtAppdata.Text) > 0 then
            appNode.Attributes['appdata'] := edtAppdata.Text;
        temp := CreateNode('exec',appNode);
        temp.Attributes['command'] := edtExe.Text;
        if cbxExeSettings.Checked then
        begin
            if Length(edtArguments.Text) > 0 then
                temp.Attributes['arguments'] := edtArguments.Text;
            if Length(edtStartdir.Text) > 0 then
                temp.Attributes['startdir'] := edtStartdir.Text;
        end;
        temp := CreateNode('author',appNode);
        if cbxPort.Checked then
            SetAuthorInfo(temp,edtAppAuthor,edtAppWebsite,edtAppMail)
        else
            SetAuthorInfo(temp,edtName,edtWebsite,edtMail);
        SetVersionInfo(CreateNode('version',appNode));
        SetTitleDescrInfo(appNode);
        temp := Doc.CreateNode('Extra block for compatibility with OS versions before HF6',ntComment);
        appNode.ChildNodes.Add(temp);
        temp := CreateNode('title',appNode);
        temp.Attributes['lang'] := 'en_US';
        temp.NodeValue := edtTitle.Text;
        temp := CreateNode('description',appNode);
        temp.Attributes['lang'] := 'en_US';
        temp.NodeValue := memDescription.Text;
        temp := Doc.CreateNode('END Extra block',ntComment);
        appNode.ChildNodes.Add(temp);
        temp := CreateNode('icon',appNode);
        temp.Attributes['src'] := edtIcon.Text;
        temp := CreateNode('license',CreateNode('licenses',appNode));
        temp.Attributes['name'] := cobLicense.Text;
        if Length(edtLicenseURL.Text) > 0 then
            temp.Attributes['url'] := edtLicenseURL.Text;
        if Length(edtSourceURL.Text) > 0 then
            temp.Attributes['sourcecodeurl'] := edtSourceURL.Text;
        temp := CreateNode('icon',appNode);
        temp.Attributes['src'] := edtIcon.Text;
        temp := CreateNode('previewpics',appNode);
        tempScreen := First;
        while tempScreen <> nil do
        begin
            CreateNode('pic',temp).Attributes['src'] := tempScreen.Filepath;
            tempScreen := tempScreen.Next;
        end;
        if (Length(edtInfoFile.Text) > 0) AND (Length(edtInfoName.Text) > 0) then
        begin
            temp := CreateNode('info',appNode);
            temp.Attributes['name'] := StringReplace(edtInfoName.Text,'<yourapptitlehere>',edtTitle.Text,[]);
            if (ExtractFileExt(edtInfoFile.Text) = '.htm') OR (ExtractFileExt(edtInfoFile.Text) = '.html') then
                temp.Attributes['type'] := 'text/html'
            else
                temp.Attributes['type'] := 'text/plain';
            temp.Attributes['src'] := edtInfoFile.Text;
        end;
        temp := CreateNode('category',CreateNode('categories',appNode));
        temp.Attributes['name'] := cobCategory.Text;
        temp := CreateNode('subcategory',temp);
        temp.Attributes['name'] := cobSubcategory.Text;

        Doc.SaveToFile(Filename);
        Doc.Active := false;
        Result := true;
    except
        on E : Exception do
        begin
            frmMain.LogLine('Error creating the PXML file: ' + E.ClassName + ' - ' +
                E.Message, frmMain.LOG_ERROR_COLOR);
            Doc.Active := false;
        end;
    end;
end;

procedure TfrmCreator.LoadIcon(const Filename: string);
var temp : TPicture;
begin           
    temp := TPicture.Create;
    try
        temp.LoadFromFile(Filename); 
        imgIcon.Canvas.Brush.Color := clBtnFace;
        imgIcon.Canvas.FillRect(Rect(0,0,imgIcon.Width,imgIcon.Height));
        imgIcon.Canvas.StretchDraw(GetStretchRect(temp.Width,temp.Height,
            imgIcon.Width,imgIcon.Height),temp.Graphic);
        lblIconInfo.Caption := UpperCase(ExtractFileExt(Filename)) + ', ' +
                               IntToStr(temp.Width) + 'x' + IntToStr(temp.Height);
        temp.Free;
    except
        // Draw "missing" image
        imgIcon.Canvas.Brush.Color := clWhite;
        imgIcon.Canvas.Pen.Color := clBlack;
        imgIcon.Canvas.Pen.Width := 2;
        imgIcon.Canvas.Rectangle(0,0,imgIcon.Width,imgIcon.Height);
        imgIcon.Canvas.MoveTo(0,0);
        imgIcon.Canvas.LineTo(imgIcon.Width,imgIcon.Height);
        imgIcon.Canvas.MoveTo(imgIcon.Width,0);
        imgIcon.Canvas.LineTo(0,imgIcon.Height);
        lblIconInfo.Caption := 'No icon loaded';
        temp.Free;
    end;
end;

function TfrmCreator.GetIconFilename : String;
var PData : PFileTreeData;
    Node : PVirtualNode;
begin
    Node := CheckForExistance(frmMain.vstFiles,edtIcon.Text);
    if Node = nil then
        Result := ''
    else
    begin
        PData := frmMain.vstFiles.GetNodeData(Node);
        Result := PData.Name;
    end;
end;

function TfrmCreator.Execute : Boolean;
var F : TextFile;
    S : String;
    P : TStringPair;
    I : Integer;
begin
    Successful := false;
    // Reset controls
    btnRemoveClick(Self);
    for I := 0 to ComponentCount - 1 do
    begin  
        try
            (Components[I] as TEdit).Text := '';
            Continue;
        except
        end;
        try
            (Components[I] as TComboBox).ItemIndex := -1;
            Continue;
        except
        try
            (Components[I] as TCheckBox).Checked := false;
        except
        end;
        end;
    end;
    memDescription.Clear;
    edtVMajor.Text := '1';
    edtVMinor.Text := '0';  
    edtVRelease.Text := '0';
    edtVBuild.Text := '0';

    // Fill Category drop-down
    cobCategory.Clear;
    try
        AssignFile(F,ExtractFilePath(Application.ExeName) + CATEGORIES_FILE);
        Reset(F);
        while not EOF(F) do
        begin
            P := TStringPair.Create;
            ReadLn(F,S);
            P.S1 := S;
            ReadLn(F,S); // Sub-categories
            P.S2 := S;
            cobCategory.Items.AddObject(P.S1,P);
        end;
    finally
        CloseFile(F);
    end;
    // Fill license preset drop-down
    cobLicense.Clear;
    try
        AssignFile(F,ExtractFilePath(Application.ExeName) + LICENSES_FILE);
        Reset(F);
        while not EOF(F) do
        begin
            P := TStringPair.Create;
            ReadLn(F,S);
            P.S1 := S;         
            ReadLn(F,S); // License URL
            P.S2 := S;
            cobLicense.Items.AddObject(P.S1,P);
        end;
    finally
        CloseFile(F);
    end;
    LoadIcon('');
    pgcMain.ActivePageIndex := 0; 
    btnPrev.Enabled := false;    
    btnNext.Caption := 'Next ->';
    ShowModal;
    Result := Successful;
end;

// --- Form --------------------------------------------------------------------

procedure TfrmCreator.FormCreate(Sender: TObject);
var dummy : TButtonEvent;
begin
    edtMail.OnKeyPress := InputFilter.EmailKeyPress;
    edtAppMail.OnKeyPress := InputFilter.EmailKeyPress;
    edtID.OnKeyPress := InputFilter.IDKeyPress;
    edtVMajor.OnKeyPress := InputFilter.VersionKeyPress;
    edtVMinor.OnKeyPress := InputFilter.VersionKeyPress;
    edtVRelease.OnKeyPress := InputFilter.VersionKeyPress;
    edtVBuild.OnKeyPress := InputFilter.VersionKeyPress;
    edtAppdata.OnKeyPress := InputFilter.FolderKeyPress;
    edtStartdir.OnKeyPress := InputFilter.FolderKeyPress;
    First := nil;
    {$Ifdef Win32}
    KeyPreview := true;
    dummy := TButtonEvent.Create;
    OnKeyDown := dummy.KeyDown;
    dummy.Free;
    {$Endif}
end;

// --- Buttons -----------------------------------------------------------------

procedure TfrmCreator.btnCancelClick(Sender: TObject);
begin
    Successful := false;
    Close;
end;

procedure TfrmCreator.btnExeClick(Sender: TObject);
begin
    frmFileSelect.SetFilter('.bin;;.sh','Executable files');
    frmFileSelect.Caption := 'Select executable...';
    frmFileSelect.CopyTreeData(frmMain.vstFiles,frmMain.Settings.ShowIcons);
    frmFileSelect.MultiSelect := false;
    frmFileSelect.Left := Left + (Width - frmFileSelect.Width) div 2;
    frmFileSelect.Top := Top + (Height - frmFileSelect.Height) div 2;
    if frmFileSelect.Execute then
        edtExe.Text := frmFileSelect.Filename;
end;

procedure TfrmCreator.btnIconClick(Sender: TObject);
var PData : PFileTreeData;
begin
    frmFileSelect.SetFilter('.png','PNG Image');
    frmFileSelect.Caption := 'Select icon image...';
    frmFileSelect.CopyTreeData(frmMain.vstFiles,frmMain.Settings.ShowIcons);
    frmFileSelect.MultiSelect := false; 
    frmFileSelect.Left := Left + (Width - frmFileSelect.Width) div 2;
    frmFileSelect.Top := Top + (Height - frmFileSelect.Height) div 2;
    if frmFileSelect.Execute then
    begin
        edtIcon.Text := frmFileSelect.FileName;
        PData := frmMain.vstFiles.GetNodeData(frmFileSelect.FileNode);
        LoadIcon(PData.Name);
    end;
end;

procedure TfrmCreator.btnInfoFileClick(Sender: TObject);
begin
    frmFileSelect.SetFilter('.txt;.htm;.html','Text or HTML files');
    frmFileSelect.Caption := 'Select documentation file...';
    frmFileSelect.CopyTreeData(frmMain.vstFiles,frmMain.Settings.ShowIcons);
    frmFileSelect.MultiSelect := false; 
    frmFileSelect.Left := Left + (Width - frmFileSelect.Width) div 2;
    frmFileSelect.Top := Top + (Height - frmFileSelect.Height) div 2;
    if frmFileSelect.Execute then
        edtInfoFile.Text := frmFileSelect.Filename;
end;

procedure TfrmCreator.btnNextClick(Sender: TObject);
begin
    if pgcMain.ActivePageIndex < pgcMain.PageCount-1 then
    begin
        pgcMain.ActivePageIndex := pgcMain.ActivePageIndex + 1;
        pgcMainChange(Sender);
    end else
    begin
        if sadPXML.Execute then
        begin
            if SavePXMLFile(sadPXML.Filename) then
            begin
                FFilename := sadPXML.Filename;
                Successful := true;
                Close;
            end else
                MessageDlg('An error occurred while attempting to save PXML file.'#13#10 +
                    'Sorry about that...'#13#10 +
                    'Check the log on the main window for details.',mtError,[mbOK],0);
        end;
    end;
end;

procedure TfrmCreator.btnPrevClick(Sender: TObject);
begin
    if pgcMain.ActivePageIndex > 0 then
    begin
        pgcMain.ActivePageIndex := pgcMain.ActivePageIndex - 1;
        pgcMainChange(Sender);
    end;
end;

procedure TfrmCreator.btnRemoveClick(Sender: TObject);
begin
    while scbScreenshots.ControlCount > 0 do
    begin
        (scbScreenshots.Controls[0] as TScreenshotPanel).Free;
    end;
    btnRemove.Enabled := false;
    First := nil;
end;

procedure TfrmCreator.btnScreenAddClick(Sender: TObject);
var newPanel, temp : TScreenshotPanel;
    I : Integer;
    PData : PFileTreeData;
begin
    frmFileSelect.SetFilter('.png;.jpg;.gif','Image files');
    frmFileSelect.Caption := 'Select (multiple) screenshots...';  
    frmFileSelect.CopyTreeData(frmMain.vstFiles,frmMain.Settings.ShowIcons);
    frmFileSelect.MultiSelect := true;  
    frmFileSelect.Left := Left + (Width - frmFileSelect.Width) div 2;
    frmFileSelect.Top := Top + (Height - frmFileSelect.Height) div 2;
    if frmFileSelect.Execute then
    begin
        for I := 0 to frmFileSelect.FileList.Count - 1 do
        begin
            PData := frmMain.vstFiles.GetNodeData(frmFileSelect.NodeList[I]);
            newPanel := TScreenshotPanel.Create(frmFileSelect.FileList[I],PData.Name);
            if First = nil then
                First := newPanel
            else
            begin
                temp := First;
                First := newPanel;
                temp.Prev := First;
                First.Next := temp;
            end;
        end;
        btnRemove.Enabled := true;
    end;
end;

procedure TfrmCreator.btnStartdirClick(Sender: TObject);
begin                
    frmFileSelect.SetFilter(frmFileSelect.FOLDER_WILDCARD,'Folders');
    frmFileSelect.Caption := 'Select starting directory...';  
    frmFileSelect.CopyTreeData(frmMain.vstFiles,frmMain.Settings.ShowIcons);
    frmFileSelect.MultiSelect := false;  
    frmFileSelect.Left := Left + (Width - frmFileSelect.Width) div 2;
    frmFileSelect.Top := Top + (Height - frmFileSelect.Height) div 2;
    if frmFileSelect.Execute then
        edtStartdir.Text := frmFileSelect.Filename;
end;

// --- Checkboxes --------------------------------------------------------------

procedure TfrmCreator.cbxAdvancedClick(Sender: TObject);
var I : Integer;
begin
    for I := 0 to grbAdvanced.ControlCount - 1 do
    begin
        if (not (grbAdvanced.Controls[I] is TMemo)) AND (grbAdvanced.Controls[I] <> Sender) then
            grbAdvanced.Controls[I].Enabled := (Sender as TCheckBox).Checked;
    end;
end;

procedure TfrmCreator.cbxPortClick(Sender: TObject);
var I : Integer;
begin
    for I := 0 to grbAppAuthor.ControlCount - 1 do
    begin
        grbAppAuthor.Controls[I].Enabled := (Sender as TCheckBox).Checked;
    end;
end; 

procedure TfrmCreator.cbxExeSettingsClick(Sender: TObject);
var I : Integer;
begin
    for I := 0 to grbExeSettings.ControlCount - 1 do
    begin
        grbExeSettings.Controls[I].Enabled := (Sender as TCheckBox).Checked;    
    end;
end;

// --- PageControl -------------------------------------------------------------

procedure TfrmCreator.pgcMainChange(Sender: TObject);

    function IDFormatString(const S : String) : String;
    var I : Integer;
    begin
        Result := AnsiLowerCase(S);
        I := 1;
        while I <= Length(Result) do
        begin
            if NOT (Result[I] in ['a'..'z','A'..'Z','0'..'9','.','_','!','-','+']) then
                Result := LeftStr(Result,I-1) + RightStr(Result,Length(Result)-I)
            else
                Inc(I);
        end;
    end;

begin
    if pgcMain.ActivePageIndex = 0 then
        btnPrev.Enabled := false
    else
        btnPrev.Enabled := true;
    if pgcMain.ActivePageIndex = 5 then
    begin
        if (Length(edtTitle.Text) > 0) AND (Length(edtName.Text) > 0) AND NOT cbxAdvanced.Checked then
        begin
            edtID.Text := IDFormatString(edtTitle.Text) + '.' + IDFormatString(edtName.Text);
        end;
    end;
    if pgcMain.ActivePageIndex = pgcMain.PageCount-1 then // Finish tab
       btnNext.Caption := 'Finish...'
    else
        begin
        btnNext.Caption := 'Next ->';
        btnNext.Enabled := true;
        Exit;
        end;
                      
    CheckForErrors;
end;

// --- License -----------------------------------------------------------------

procedure TfrmCreator.cobLicenseChange(Sender: TObject);
var S : String;
begin
    edtLicenseURL.Clear;
    if cobLicense.ItemIndex >= 0 then
        S := (cobLicense.Items.Objects[cobLicense.ItemIndex] as TStringPair).S2
    else
        S := '';
    edtLicenseURL.Text := S;
end;

// --- Icon --------------------------------------------------------------------

procedure TfrmCreator.edtIconExit(Sender: TObject);
var PData : PFileTreeData;
    Node : PVirtualNode;

begin
    if Length(edtIcon.Text) = 0 then
    begin
        LoadIcon('');
    end else
    begin
        Node := CheckForExistance(frmMain.vstFiles,edtIcon.Text);
        if Node = nil then
        begin
            frmMain.LogLine('Error loading icon file: ' + edtIcon.Text,frmMain.LOG_ERROR_COLOR);
            LoadIcon('');
        end else
        begin
            PData := frmMain.vstFiles.GetNodeData(Node);
            LoadIcon(PData.Name);
        end;
    end;
end;

// --- Category ----------------------------------------------------------------

procedure TfrmCreator.cobCategoryChange(Sender: TObject);
var S,temp : String;
    L : TStrings;
begin
    temp := cobSubcategory.Text;
    cobSubcategory.Clear;
    // Fill Sub-category drop-down dependant on what Category shows
    if cobCategory.ItemIndex >= 0 then
        S := (cobCategory.Items.Objects[cobCategory.ItemIndex] as TStringPair).S2
    else
        S := '';
    L := TStringList.Create;
    L.Delimiter := '|';
    L.DelimitedText := S;
    cobSubcategory.Items.AddStrings(L);
    cobSubcategory.Text := temp;
end;

// --- Version -----------------------------------------------------------------

procedure TfrmCreator.spbVMajorDownClick(Sender: TObject);
var I : Integer;
begin
    for I := 0 to (Sender as TControl).Parent.ControlCount - 1 do
    begin
        if (Sender as TControl).Parent.Controls[I] is TCustomEdit then
            ChangeVersionNumber(((Sender as TControl).Parent.Controls[I] as TCustomEdit),-1);
    end;
end;

procedure TfrmCreator.spbVMajorUpClick(Sender: TObject);
var I : Integer;
begin
    for I := 0 to (Sender as TControl).Parent.ControlCount - 1 do
    begin
        if (Sender as TControl).Parent.Controls[I] is TCustomEdit then
            ChangeVersionNumber(((Sender as TControl).Parent.Controls[I] as TCustomEdit),1);
    end;
end;

// --- ScreenshotPanel ---------------------------------------------------------

constructor TScreenshotPanel.Create(AOwner : TComponent);
begin
    inherited;
end;

constructor TScreenshotPanel.Create(const Filepath: String; const ImageFile : String);
var temp : TPicture;
begin
    Create(frmCreator);
    pFilepath := Filepath;
    Prev := nil;
    Next := nil;
    Parent := frmCreator.scbScreenshots;
    Align := alTop;
    Height := 100;
    Caption := '';
    ParentBackground := false;
    imgScreenshot := TImage.Create(Self);
    with imgScreenshot do
    begin
        Align := alLeft;
        AlignWithMargins := true;
        with Margins do
        begin
            Bottom := 4;
            Left := 4;
            Right := 4;
            Top := 4;
        end;
        Width := 150;
        Parent := Self;
    end;
    pnlText := TPanel.Create(Self);
    with pnlText do
    begin
        Align := alClient;
        AlignWithMargins := true; 
        with Margins do
        begin
            Bottom := 0;
            Left := 4;
            Right := 0;
            Top := 0;
        end;
        BevelOuter := bvNone;
        Caption := '';
        ParentColor := true;
        Parent := Self;
    end;
    pnlButtons := TPanel.Create(Self);
    with pnlButtons do
    begin
        Align := alRight;
        BevelOuter := bvNone;
        Caption := '';
        ParentColor := true;
        Parent := Self;
        Width := 33;
    end;
    lblPath := TLabel.Create(Self);
    with lblPath do
    begin
        Parent := pnlText;
        Align := alTop;
        AlignWithMargins := true;
        Caption := Filepath;
        with Margins do
        begin
            Bottom := 0;
            Left := 0;
            Right := 0;
            Top := 34;
        end;
        Font.Style := [];
    end;
    lblSize := TLabel.Create(Self);
    with lblSize do
    begin
        Parent := pnlText;
        Align := alTop;
        AlignWithMargins := true;
        Caption := 'size';
        with Margins do
        begin
            Bottom := 0;
            Left := 0;
            Right := 0;
            Top := 4;
        end;
        Top := 51; 
        Font.Style := [];
    end;
    btnRemove := TButton.Create(Self);
    with btnRemove do
    begin
        Parent := pnlButtons;
        Align := alTop;
        AlignWithMargins := true;
        Caption := 'X';
        Height := 25;
        with Margins do
        begin
            Bottom := 4;
            Left := 4;
            Right := 4;
            Top := 4;
        end;
        TabOrder := 0;
        OnClick := btnRemoveClick;   
        Font.Style := [];
    end;     
    btnMoveDown := TButton.Create(Self);
    with btnMoveDown do
    begin
        Parent := pnlButtons;
        Align := alBottom;
        AlignWithMargins := true;
        Caption := 'v';
        Height := 25;
        with Margins do
        begin
            Bottom := 4;
            Left := 4;
            Right := 4;
            Top := 0;
        end;    
        TabOrder := 2;
        OnClick := btnMoveDownClick;   
        Font.Style := [];
    end;
    btnMoveUp := TButton.Create(Self);
    with btnMoveUp do
    begin
        Parent := pnlButtons;
        Align := alBottom;
        AlignWithMargins := true;
        Caption := '^';
        Height := 25;
        with Margins do
        begin
            Bottom := 0;
            Left := 4;
            Right := 4;
            Top := 4;
        end;     
        TabOrder := 1;
        OnClick := btnMoveUpClick;    
        Font.Style := [];
    end;
      
    temp := TPicture.Create;
    try
        temp.LoadFromFile(ImageFile);   
        imgScreenshot.Canvas.Brush.Color := clBtnFace;
        imgScreenshot.Canvas.FillRect(Rect(0,0,imgScreenshot.Width,imgScreenshot.Height));
        imgScreenshot.Canvas.StretchDraw(GetStretchRect(temp.Width,temp.Height,
            imgScreenshot.Width,imgScreenshot.Height),temp.Graphic);
        lblSize.Caption := UpperCase(ExtractFileExt(Filepath)) + ', ' +
                            IntToStr(temp.Width) + 'x' + IntToStr(temp.Height);
        temp.Free;
    except
        lblSize.Caption := 'No icon loaded';
        temp.Free;
    end;
end;

procedure TScreenshotPanel.btnRemoveClick(Sender: TObject);
begin
    if frmCreator.scbScreenshots.ControlCount = 1 then
        frmCreator.btnRemove.Enabled := false;
    if Self = First then
        First := Self.Next;
    if Self.Prev <> nil then
        Self.Prev.Next := Self.Next;
    if Self.Next <> nil then
        Self.Next.Prev := Self.Prev;
    Self.Free;
end;

procedure TScreenshotPanel.btnMoveUpClick(Sender: TObject);
var temp : TScreenshotPanel;
begin
    if Self.Prev <> nil then
    begin
        temp := Self.Prev;
        if temp.Prev <> nil then
           temp.Prev.Next := Self;
        if Self.Next <> nil then
            Self.Next.Prev := temp;
        Self.Prev := temp.Prev; 
        temp.Next := Self.Next;
        Self.Next := temp;
        temp.Prev := Self;
        if temp = First then
            First := Self;
        Self.Top := Self.Top - Self.Height;
    end;
end;

procedure TScreenshotPanel.btnMoveDownClick(Sender: TObject); 
var temp : TScreenshotPanel;
begin
    if Self.Next <> nil then
    begin
        temp := Self.Next;
        if temp.Next <> nil then
            temp.Next.Prev := Self;
        if Self.Prev <> nil then
            Self.Prev.Next := temp;
        Self.Next := temp.Next; 
        temp.Prev := Self.Prev;
        Self.Prev := temp;
        temp.Next := Self;
        if Self = First then
            First := temp;
        Self.Top := Self.Top + Self.Height + 1;
    end;
end;


end.
