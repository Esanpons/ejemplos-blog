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
}