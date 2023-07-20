page 50100 "CarPart Picture"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = "Config. Media Buffer";
    SourceTableTemporary = true;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            field(Picture; Rec."Media Set")
            {
                ApplicationArea = All;
                ShowCaption = false;
                ToolTip = 'Specifies the picture that has been inserted for the item.';
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(ActionTakePhoto)
            {
                ApplicationArea = All;
                Caption = 'Take Photo', Comment = 'ESP="Hacer foto"';
                Image = Camera;
                ToolTip = 'Activate the camera on the device.', Comment = 'ESP="Activa la cámara en el dispositivo."';

                trigger OnAction()
                begin
                    TakePhoto();
                end;
            }
            action(ActionImportPicture)
            {
                ApplicationArea = All;
                Caption = 'Import', Comment = 'ESP="Importar"';
                Image = Import;
                ToolTip = 'Import a picture file.', Comment = 'ESP="Importar un archivo de imagen."';

                trigger OnAction()
                begin
                    ImportPicture();
                end;
            }
            action(ActionExportPicture)
            {
                ApplicationArea = All;
                Caption = 'Export', Comment = 'ESP="Exportar"';
                Image = Export;
                ToolTip = 'Export the picture to a file.', Comment = 'ESP="Exporte la imagen a un archivo."';

                trigger OnAction()
                var
                begin
                    ExportPicture()
                end;
            }
            action(ActionDeletePicture)
            {
                ApplicationArea = All;
                Caption = 'Delete', Comment = 'ESP="Eliminar"';
                Image = Delete;
                ToolTip = 'Delete the record.', Comment = 'ESP="Eliminar el registro."';

                trigger OnAction()
                begin
                    DeletePicture();
                end;
            }
        }
    }

    procedure SetParams(RecVariant: Variant; FieldNo: Integer)
    begin
        Clear(RecordRefe);
        Clear(FieldRefe);

        RecordRefe.GetTable(RecVariant);
        FieldRefe := RecordRefe.Field(FieldNo);

        Rec.Reset();
        Rec.DeleteAll();
        Rec.Init();
        Rec."Media Set" := FieldRefe.Value();
        Rec.Insert();
    end;

    local procedure TakePhoto()
    var
        Camera: Codeunit Camera;
        PictureInstream: InStream;
        PictureDescription: Text;
        MimeTypeTok: Label 'image/jpeg', Locked = true;
    begin
        if Rec."Media Set".Count() > 0 then
            ClearPicture();

        if Camera.GetPicture(PictureInstream, PictureDescription) then begin
            Clear(Rec."Media Set");
            Rec."Media Set".ImportStream(PictureInstream, PictureDescription, MimeTypeTok);
            FieldRefe.Value := Rec."Media Set";
            RecordRefe.Modify();
        end;
    end;

    local procedure ImportPicture()
    begin
        if not UploadIntoStream('', '', '', FileName, DocInStream) then
            exit;

        if Rec."Media Set".Count() > 0 then
            ClearPicture();

        Rec."Media Set".ImportStream(DocInStream, FileName);
        FieldRefe.Value := Rec."Media Set";
        RecordRefe.Modify();
    end;

    local procedure ExportPicture()
    begin
        Clear(DocInStream);

        TenantMedia.Get(Rec."Media Set".Item(Rec."Media Set".Count));
        TenantMedia.CalcFields(Content);
        TenantMedia.Content.CreateInStream(DocInStream);
        FileName := TenantMedia.Description;

        DownloadFromStream(DocInStream, '', '', '', FileName);
    end;

    local procedure DeletePicture()
    var
        DeleteImageQst: Label 'Do you want to delete the image?', Comment = 'ESP="¿Quieres eliminar la imagen?"';
    begin
        if not Confirm(DeleteImageQst) then
            exit;

        ClearPicture();
    end;

    local procedure ClearPicture()
    begin
        Clear(Rec."Media Set");
        FieldRefe.Value := Rec."Media Set";
        RecordRefe.Modify();
    end;

    var
        TenantMedia: Record "Tenant Media";
        RecordRefe: RecordRef;
        FieldRefe: FieldRef;
        FileName: Text;
        DocInStream: InStream;

}