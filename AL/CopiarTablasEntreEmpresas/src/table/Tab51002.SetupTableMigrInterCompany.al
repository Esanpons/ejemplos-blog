table 51002 "Setup Table Migr. InterCompany"
{
    Caption = 'Setup Of Tables To Be Migrated Between Companies', Comment = 'ESP="Configuración tablas a migrar entre empresas"';
    DataClassification = CustomerContent;
    DataPerCompany = false;
    LookupPageId = "Setup Table Migr. InterCompany";
    DrillDownPageId = "Setup Table Migr. InterCompany";

    fields
    {
        field(1; "Id Table"; Integer)
        {
            Caption = 'Id Table', Comment = 'ESP="Id tabla"';
            DataClassification = CustomerContent;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(table));
        }
        field(2; "Name Table"; Text[250])
        {
            Caption = 'Name Table', Comment = 'ESP="Nombre tabla"';
            FieldClass = FlowField;
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object ID" = field("Id Table")));
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Id Table")
        {
            Clustered = true;
        }
    }

    procedure ExportJsonTables(var SetupTableMigrInterCompany: Record "Setup Table Migr. InterCompany")
    var
        MgtExpImpTableToJson: Codeunit "Mgt. Exp/Imp Table To Json";
        RecordRef: RecordRef;
        JsonObject: JsonObject;
    begin
        Clear(JsonObject);

        SetupTableMigrInterCompany.Reset();
        if SetupTableMigrInterCompany.FindSet() then
            repeat
                Clear(MgtExpImpTableToJson);
                Clear(RecordRef);
                RecordRef.Open(SetupTableMigrInterCompany."Id Table");

                MgtExpImpTableToJson.AddJsonArray(JsonObject, RecordRef);

            until SetupTableMigrInterCompany.Next() = 0;

        DownloadObject(JsonObject);
    end;

    local procedure DownloadObject(JObject: JsonObject)
    var
        TempBlob: Codeunit "Temp Blob";
        DocOutStream: OutStream;
        DocInStream: InStream;
        FileName: Text;
    begin

        FileName := 'Exp/Imp ' + '.json';
        TempBlob.CreateOutStream(DocOutStream);
        JObject.WriteTo(DocOutStream);
        TempBlob.CreateInStream(DocInStream);
        DownloadFromStream(DocInStream, '', '', '', FileName);
    end;

    procedure ImportJsonTables()
    var
        MgtExpImpTableToJson: Codeunit "Mgt. Exp/Imp Table To Json";
        RecordRefe: RecordRef;
        PrincipalJObject: JsonObject;
        JToken: JsonToken;
        DocInStream: InStream;
        FileName: Text;
    begin
        if not UploadIntoStream('', '', '', FileName, DocInStream) then
            exit;

        Clear(MgtExpImpTableToJson);
        Clear(PrincipalJObject);
        PrincipalJObject.ReadFrom(DocInStream);

        MgtExpImpTableToJson.SetOverWrite(true);

        Rec.Reset();
        if Rec.FindSet() then
            repeat
                // Leer el Json y escribir en la tabla T27
                Clear(RecordRefe);
                Clear(JToken);
                RecordRefe.Open(Rec."Id Table");
                if PrincipalJObject.Get(format(RecordRefe.Number), JToken) then
                    MgtExpImpTableToJson.ReadJsonArray(JToken.AsArray(), RecordRefe);

            until Rec.Next() = 0;


    end;
}
