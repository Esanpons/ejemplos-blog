codeunit 50102 "Mgt. Download/Upload"
{
    procedure Download()
    var
        TempBlob: Codeunit "Temp Blob";
        DocOutStream: OutStream;
        DocInStream: InStream;
        FileName: Text;
    begin
        FileName := 'Ejemplo.Txt';

        TempBlob.CreateOutStream(DocOutStream);
        DocOutStream.WriteText('Hola Mundo!!!');

        TempBlob.CreateInStream(DocInStream);
        DownloadFromStream(DocInStream, '', '', '', FileName);
    end;

    procedure Upload()
    var
        DocInStream: InStream;
        FileName: Text;
        ValueText: Text;
    begin
        if not UploadIntoStream('', '', '', FileName, DocInStream) then
            exit;

        DocInStream.ReadText(ValueText);
        Message(ValueText);
    end;

    procedure UploadMultipleFilesManual(files: List of [FileUpload])
    var
        Item: Record Item;
        FileManagement: Codeunit "File Management";
        CurrentFileUpload: FileUpload;
        InStream: InStream;
        FileName: Text;
    begin
        clear(FileName);
        Clear(FileManagement);
        foreach CurrentFileUpload in Files do begin
            CurrentFileUpload.CreateInStream(InStream, TextEncoding::MSDos);
            FileName := FileManagement.GetFileNameWithoutExtension(CurrentFileUpload.FileName);
            if Item.Get(FileName) then begin
                Clear(Item.Picture);
                Item.Picture.ImportStream(InStream, 'Demo picture for item ' + Format(Item."No."));
                Item.Modify(true);
            end;
        end;
    end;
}