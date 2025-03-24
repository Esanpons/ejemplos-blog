//codigo extraido y posteriormente modificado del Git de Erik Houggard. URL: https://github.com/hougaard/Youtube-Video-Sources/tree/master/JsonTools


codeunit 50101 "Advanced Mgt. Json"
{

    //*************************************************************************************************************************************************************************************************
    //RecToJson   ---  IMPORTAR  ----
    //*************************************************************************************************************************************************************************************************
    procedure UploadJson2Rec(RecVariant: Variant): Variant
    var
        RecordRefe: RecordRef;
    begin
        RecordRefe.GetTable(RecVariant);
        exit(UploadJson2Rec(RecordRefe.Number()));
    end;

    procedure UploadJson2Rec(TableNo: Integer): Variant
    var
        JObject: JsonObject;
        FileName: Text;
        DocInStream: InStream;
    begin
        if not UploadIntoStream('', '', '', FileName, DocInStream) then
            exit;

        Clear(JObject);
        JObject.ReadFrom(DocInStream);

        exit(Json2Rec(JObject, TableNo));
    end;

    procedure Json2Rec(JObject: JsonObject; RecVariant: Variant): Variant
    var
        RecordRefe: RecordRef;
    begin
        RecordRefe.GetTable(RecVariant);
        exit(Json2Rec(JObject, RecordRefe.Number()));
    end;

    procedure Json2Rec(JObject: JsonObject; TableNo: Integer): Variant
    var
        RecordRefe: RecordRef;
        FieldRefe: FieldRef;
        FieldHash: Dictionary of [Text, Integer];
        i: Integer;
        JsonKey: Text;
        JToken: JsonToken;
        JsonValueKey: JsonValue;
        RecVariant: Variant;
    begin
        RecordRefe.OPEN(TableNo);
        for i := 1 to RecordRefe.FieldCount() do begin
            FieldRefe := RecordRefe.FieldIndex(i);
            FieldHash.Add(GetJsonFieldName(FieldRefe), FieldRefe.Number);
        end;
        RecordRefe.Init();
        foreach JsonKey in JObject.Keys() do begin
            if JObject.Get(JsonKey, JToken) then begin
                if JToken.IsValue() then begin
                    JsonValueKey := JToken.AsValue();
                    FieldRefe := RecordRefe.Field(FieldHash.Get(JsonKey));
                    AssignValueToFieldRef(FieldRefe, JsonValueKey);
                end;
            end;
        end;
        RecordRefe.Insert();
        RecVariant := RecordRefe;
        exit(RecVariant);
    end;

    local procedure AssignValueToFieldRef(var FieldRefe: FieldRef; JsonKeyValue: JsonValue)
    var
        Text001Lbl: Label '%1 is not a supported field type', comment = 'ESP="%1 no es un tipo de campo admitido"';
    begin
        case FieldRefe.Type() of
            FieldType::Code,
             FieldType::Text:
                FieldRefe.Value := JsonKeyValue.AsText();
            FieldType::Integer:
                FieldRefe.Value := JsonKeyValue.AsInteger();
            FieldType::Date:
                FieldRefe.Value := JsonKeyValue.AsDate();
            FieldType::Time:
                FieldRefe.Value := JsonKeyValue.AsTime();
            FieldType::DateTime:
                FieldRefe.Value := JsonKeyValue.AsDateTime();
            FieldType::Decimal:
                FieldRefe.Value := JsonKeyValue.AsDecimal();
            FieldType::Option:
                FieldRefe.Value := JsonKeyValue.AsOption();
            FieldType::Boolean:
                FieldRefe.Value := JsonKeyValue.AsBoolean();
            else
                error(Text001Lbl, FieldRefe.Type());
        end;
    end;


    //*************************************************************************************************************************************************************************************************
    //RecToJson --- EXPORTAR ---
    //*************************************************************************************************************************************************************************************************
    procedure Rec2Json(Rec: Variant): JsonObject
    var
        RecordRefe: RecordRef;
        FieldRefe: FieldRef;
        JObject: JsonObject;
        JValue: JsonValue;
        i: Integer;
        Tet001Lbl: Label 'Parameter Rec is not a record', comment = 'ESP="El parámetro Rec no es un registro"';
    begin
        if not Rec.IsRecord then
            error(Text001Lbl);
        RecordRefe.GetTable(Rec);
        for i := 1 to RecordRefe.FieldCount() do begin
            FieldRefe := RecordRefe.FieldIndex(i);
            case FieldRefe.Class of
                FieldRefe.Class::Normal:
                    begin
                        Clear(JValue);
                        JValue := FieldRef2JsonValue(FieldRefe);
                        if Not JValue.IsNull then
                            JObject.Add(GetJsonFieldName(FieldRefe), JValue);
                    end;

                FieldRefe.Class::FlowField:
                    begin
                        FieldRefe.CalcField();
                        JValue := FieldRefToJsonValue(FieldRefe);
                        if Not JValue.IsNull then
                            JObject.Add(GetJsonFieldName(FieldRefe), JValue);
                    end;
            end;
        end;
        exit(JObject);
    end;

    local procedure FieldRef2JsonValue(FieldRefe: FieldRef): JsonValue
    var
        JValue: JsonValue;
        ValueDate: Date;
        ValueDateTime: DateTime;
        ValueTime: Time;
        ValueInt: Integer;
        ValueDec: Decimal;
        ValueOption: Option;
        ValueBoo: Boolean;
    begin
        Clear(JValue);

        case FieldRefe.Type() of
            FieldType::Code,
            FieldType::Text:
                JValue.SetValue(Format(FieldRefe.Value, 0, 9));
            FieldType::Integer:
                begin
                    ValueInt := FieldRefe.Value;
                    JValue.SetValue(ValueInt);
                end;
            FieldType::Date:
                begin
                    ValueDate := FieldRefe.Value;
                    JValue.SetValue(ValueDate);
                end;
            FieldType::Time:
                begin
                    ValueTime := FieldRefe.Value;
                    JValue.SetValue(ValueTime);
                end;
            FieldType::DateTime:
                begin
                    ValueDateTime := FieldRefe.Value;
                    JValue.SetValue(ValueDateTime);
                end;
            FieldType::Decimal:
                begin
                    ValueDec := FieldRefe.Value;
                    JValue.SetValue(ValueDec);
                end;
            FieldType::Option:
                begin
                    ValueOption := FieldRefe.Value;
                    JValue.SetValue(ValueOption);
                end;
            FieldType::Boolean:
                begin
                    ValueBoo := FieldRefe.Value;
                    JValue.SetValue(ValueBoo);
                end;
        end;
        exit(JValue);
    end;


    //*************************************************************************************************************************************************************************************************
    //Varios
    //*************************************************************************************************************************************************************************************************
    local procedure GetJsonFieldName(FieldRefe: FieldRef): Text
    var
        Name: Text;
        i: Integer;
    begin
        Name := FieldRefe.Name();
        for i := 1 to Strlen(Name) do begin
            if Name[i] < '0' then
                Name[i] := '_';
        end;
        exit(Name.Replace('__', '_').TrimEnd('_').TrimStart('_'));
    end;
}
