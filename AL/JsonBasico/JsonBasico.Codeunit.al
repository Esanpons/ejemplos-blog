codeunit 70101 JsonBasico
{

    procedure ReadJsonFromFile()
    var
        DocInStream: InStream;
        FileName: Text;
        jsonText: Text;
        jsonString: Text;
        jsonObj: JsonObject;
        JToken: JsonToken;
        filePath: Text;
        id: Text;
        name: Text;
        age: Integer;
    begin
        if not UploadIntoStream('', '', '', FileName, DocInStream) then
            exit;

        DocInStream.ReadText(jsonText);

        // Leer el contenido del archivo JSON
        Clear(jsonObj);
        jsonObj.ReadFrom(jsonText);

        // Leer los valores de los campos
        jsonObj.SelectToken('id', JToken);
        id := JToken.AsValue().AsText();

        jsonObj.SelectToken('name', JToken);
        name := JToken.AsValue().AsText();

        jsonObj.SelectToken('age', JToken);
        age := JToken.AsValue().AsInteger();

        // Procesar los datos
        Message('ID: %1, Name: %2, Age: %3', id, name, age);
    end;

    procedure CreateJsonFile()
    var
        TempBlob: Codeunit "Temp Blob";
        DocOutStream: OutStream;
        DocInStream: InStream;
        FileName: Text;
        jsonObj: JsonObject;
        jsonString: Text;
        filePath: Text;
    begin
        // Crear un objeto JSON
        Clear(jsonObj);
        jsonObj.Add('id', '1234');
        jsonObj.Add('name', 'Esteve');
        jsonObj.Add('age', '25');

        //convertimos Json en un texto
        jsonObj.WriteTo(jsonString);

        // Escribir la cadena JSON en un archivo y lo descargamos
        FileName := 'archivo.json';

        TempBlob.CreateOutStream(DocOutStream);
        DocOutStream.WriteText(jsonString);

        TempBlob.CreateInStream(DocInStream);
        DownloadFromStream(DocInStream, '', '', '', FileName);
    end;

}