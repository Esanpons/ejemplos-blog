
codeunit 51002 "Mgt. Exp/Imp Table To Json"
{
    //codeunit para importar o exportar tablas enteras

    #region FUNCIONES IMPORTAR
    procedure ReadJsonArray(JArray: JsonArray; var RecordRefe: RecordRef)
    var
        JToken: JsonToken;
        JObject: JsonObject;
    begin
        Clear(JToken);
        foreach Jtoken in JArray do begin
            Clear(JObject);
            JObject := JToken.AsObject();
            JsonToRec(JObject, RecordRefe);
        end;
    end;

    procedure JsonToRec(JObject: JsonObject; var RecordRefe: RecordRef)
    var
        FieldRefe: FieldRef;
        FieldHash: Dictionary of [Text, Integer];
        i: Integer;
        JsonKey: Text;
        JToken: JsonToken;
        JsonKeyValue: JsonValue;
        NumField: Integer;
    begin
        for i := 1 to RecordRefe.FieldCount() do begin
            FieldRefe := RecordRefe.FieldIndex(i);
            FieldHash.Add(GetJsonFieldName(FieldRefe), FieldRefe.Number);
        end;
        RecordRefe.Init();
        if ChangeCompany <> '' then
            RecordRefe.ChangeCompany(ChangeCompany);

        foreach JsonKey in JObject.Keys() do
            if JObject.Get(JsonKey, JToken) then
                if JToken.IsValue() then begin
                    JsonKeyValue := JToken.AsValue();
                    if FieldHash.ContainsKey(JsonKey) then begin
                        NumField := FieldHash.Get(JsonKey);

                        FieldRefe := RecordRefe.Field(NumField);
                        AssignValueToFieldRef(FieldRefe, RecordRefe, JsonKeyValue);
                    end;
                end;

        if OverWrite then begin
            if not RecordRefe.Insert(true) then
                RecordRefe.Modify(true);
        end else
            RecordRefe.Insert(true);
    end;


    local procedure AssignValueToFieldRef(var FieldRefe: FieldRef; var RecordRefe: RecordRef; JsonKeyValue: JsonValue)
    var
        ValueGuid: Guid;
    begin
        if ImportTablesWithSpecialFields(FieldRefe, RecordRefe, JsonKeyValue) then
            exit;

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
            FieldType::Guid:
                begin
                    Evaluate(ValueGuid, JsonKeyValue.AsText());
                    FieldRefe.Value := ValueGuid;
                end;
            FieldType::MediaSet:
                ConvertBase64ToFieldsWithStream(FieldRefe, JsonKeyValue);
            FieldType::Media:
                ConvertBase64ToFieldsWithStream(FieldRefe, JsonKeyValue);
            FieldType::Blob:
                ConvertBase64ToFieldsWithStream(FieldRefe, JsonKeyValue);
        end;
    end;

    //funcion para campos que son especiales de tablas en concreto
    local procedure ImportTablesWithSpecialFields(var FieldRefe: FieldRef; var RecordRefe: RecordRef; JsonKeyValue: JsonValue) ReturnValue: Boolean
    var
        Item: Record Item;
        EntityText: Record "Entity Text";
        l_FieldRef: FieldRef;
        ValueInteger: Integer;
        ValueText: Text;
        ValueGuid: Guid;
    begin
        ReturnValue := false;
        case RecordRefe.Number of
            Database::"Entity Text":
                case FieldRefe.Number of
                    EntityText.FieldNo(Company):
                        begin
                            ValueText := JsonKeyValue.AsText();
                            if Item.Get(ValueText) then begin
                                Clear(l_FieldRef);
                                l_FieldRef := RecordRefe.Field(EntityText.FieldNo("Source System Id"));
                                l_FieldRef.Value := Item.SystemId;
                                ValueItemGuid := Item.SystemId;
                            end;

                            FieldRefe.Value := CompanyName();
                            ReturnValue := true;
                        end;

                    EntityText.FieldNo("Source System Id"):
                        begin
                            Clear(l_FieldRef);
                            l_FieldRef := RecordRefe.Field(EntityText.FieldNo("Source System Id"));

                            if Evaluate(ValueGuid, format(l_FieldRef.Value)) then begin
                                Clear(l_FieldRef);
                                l_FieldRef := RecordRefe.Field(EntityText.FieldNo("Source Table Id"));
                                if Evaluate(ValueInteger, Format(l_FieldRef.Value)) then
                                    if ValueInteger = Database::Item then begin
                                        Item.Reset();
                                        Item.SetRange(SystemId, ValueGuid);
                                        if Item.FindFirst() then begin
                                            FieldRefe.Value := Item.SystemId;
                                            ReturnValue := true;
                                        end;
                                    end;
                            end;

                        end;

                end;
        end;
    end;

    var
        ValueItemGuid: Guid;

    local procedure ConvertBase64ToFieldsWithStream(var FieldRefe: FieldRef; JsonKeyValue: JsonValue)
    var
        TempConfigMediaBuffer: Record "Config. Media Buffer" temporary;
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        InStream: InStream;
        Base64Text: Text;
    begin
        Clear(TempBlob);
        Clear(Base64Convert);
        Clear(OutStream);
        Clear(InStream);
        Clear(TempConfigMediaBuffer);
        Clear(Base64Text);

        //traspasamos el valor en base64 a una variable
        Base64Text := JsonKeyValue.AsText();

        //convertimos el Base64 a InStream
        if FieldRefe.Type() in [FieldType::Media, FieldType::MediaSet] then begin
            TempBlob.CreateOutStream(OutStream);
            Base64Convert.FromBase64(Base64Text, OutStream);
            TempBlob.CreateInStream(InStream);
        end;

        //añadimos el Stream a una temporal  con el campo necesario. Para despues añadirlo como valor al campo de la tabla referenciada
        case FieldRefe.Type() of
            FieldType::MediaSet:
                begin
                    TempConfigMediaBuffer."Media Set".ImportStream(InStream, '');
                    FieldRefe.Value := TempConfigMediaBuffer."Media Set";
                end;
            FieldType::Media:
                begin
                    TempConfigMediaBuffer."Media".ImportStream(InStream, '');
                    FieldRefe.Value := TempConfigMediaBuffer."Media";
                end;
            FieldType::Blob:
                begin
                    TempConfigMediaBuffer."Media Blob".CreateOutStream(OutStream);
                    Base64Convert.FromBase64(Base64Text, OutStream);
                    FieldRefe.Value := TempConfigMediaBuffer."Media Blob";
                end;
        end;

        //hacemos el clear del campo de la tabla temporal para vaciarlo y que no se queden restos del archivo
        Clear(TempConfigMediaBuffer."Media");
        Clear(TempConfigMediaBuffer."Media Set");
        Clear(TempConfigMediaBuffer."Media Blob");
        Clear(TempConfigMediaBuffer);
    end;

    #endregion

    #region FUNCIONES EXPORTAR
    procedure AddJsonArray(var JObject: JsonObject; RecVariant: Variant)
    var
        RecordRefe: RecordRef;
        JArray: JsonArray;
    begin
        Clear(JArray);
        Clear(RecordRefe);
        RecordRefe.GetTable(RecVariant);
        if RecordRefe.FindSet() then begin
            repeat
                JArray.Add(RecToJson(RecordRefe));
            until RecordRefe.Next() = 0;

            JObject.Add(Format(RecordRefe.Number), JArray);
        end;
    end;

    procedure RecToJson(RecordRefe: RecordRef): JsonObject
    var
        FieldRefe: FieldRef;
        JObject: JsonObject;
        JValue: JsonValue;
        i: Integer;
    begin
        for i := 1 to RecordRefe.FieldCount() do begin
            Clear(JValue);
            FieldRefe := RecordRefe.FieldIndex(i);
            case FieldRefe.Class of
                FieldRefe.Class::Normal:
                    begin
                        JValue := FieldRefToJsonValue(FieldRefe, RecordRefe);
                        if not JValue.IsNull then
                            JObject.Add(GetJsonFieldName(FieldRefe), JValue);
                    end;

                FieldRefe.Class::FlowField:
                    begin
                        FieldRefe.CalcField();
                        JValue := FieldRefToJsonValue(FieldRefe, RecordRefe);
                        if not JValue.IsNull then
                            JObject.Add(GetJsonFieldName(FieldRefe), JValue);
                    end;
            end;
        end;
        exit(JObject);
    end;



    local procedure FieldRefToJsonValue(FieldRefe: FieldRef; RecordRefe: RecordRef): JsonValue
    var
        JValue: JsonValue;
        ValueText: Text;
        ValueDate: Date;
        ValueDateTime: DateTime;
        ValueTime: Time;
        ValueInt: Integer;
        ValueDec: Decimal;
        ValueOption: Option;
        ValueBoo: Boolean;
    begin
        if ExportTablesWithSpecialFields(FieldRefe, RecordRefe) then
            exit;

        Clear(JValue);

        case FieldRefe.Type() of
            FieldType::Code,
            FieldType::Text:
                begin
                    ValueText := Format(FieldRefe.Value, 0, 9);
                    JValue.SetValue(ValueText);
                end;
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
            FieldType::Guid:
                begin
                    ValueText := Format(FieldRefe.Value);
                    JValue.SetValue(ValueText);
                end;
            FieldType::Blob:
                begin
                    ValueText := ConvertFieldsWithStreamToBase64(FieldRefe);
                    if ValueText <> '' then
                        JValue.SetValue(ValueText);
                end;
            FieldType::MediaSet:
                begin
                    ValueText := ConvertFieldsWithStreamToBase64(FieldRefe);
                    if ValueText <> '' then
                        JValue.SetValue(ValueText);
                end;
            FieldType::Media:
                begin
                    ValueText := ConvertFieldsWithStreamToBase64(FieldRefe);
                    if ValueText <> '' then
                        JValue.SetValue(ValueText);
                end;
        end;
        exit(JValue);
    end;

    //funcion para campos que son especiales de tablas en concreto
    local procedure ExportTablesWithSpecialFields(var FieldRefe: FieldRef; RecordRefe: RecordRef) ReturnValue: Boolean
    var
        Item: Record Item;
        EntityText: Record "Entity Text";
        l_FieldRef: FieldRef;
        ValueInteger: Integer;
    begin
        ReturnValue := false;
        case RecordRefe.Number of
            Database::"Entity Text":
                case FieldRefe.Number of
                    EntityText.FieldNo(Company):
                        begin
                            Clear(l_FieldRef);
                            l_FieldRef := RecordRefe.Field(EntityText.FieldNo("Source Table Id"));
                            Evaluate(ValueInteger, Format(l_FieldRef.Value));
                            if ValueInteger = Database::Item then begin
                                Clear(l_FieldRef);
                                l_FieldRef := RecordRefe.Field(EntityText.FieldNo("Source System Id"));
                                Item.Reset();
                                Item.SetRange(SystemId, EntityText."Source System Id");
                                if Item.FindFirst() then begin
                                    FieldRefe.Value := Item."No.";
                                    ReturnValue := true;
                                end;
                            end;
                        end;
                end;
        end;
    end;

    local procedure ConvertFieldsWithStreamToBase64(FieldRefe: FieldRef) ReturnValue: Text
    var
        TempConfigMediaBuffer: Record "Config. Media Buffer" temporary;
        TenantMedia: Record "Tenant Media";
        Base64Convert: Codeunit "Base64 Convert";
        InStream: InStream;
        ValueIdMediaSet: Text;
        IsExit: Boolean;
        Count: Integer;
    begin
        Clear(InStream);
        Clear(Base64Convert);
        Clear(ValueIdMediaSet);
        Clear(TempConfigMediaBuffer);
        ReturnValue := '';
        IsExit := false;


        case FieldRefe.Type() of
            FieldType::MediaSet:
                begin
                    TempConfigMediaBuffer."Media Set" := FieldRefe.Value;
                    Count := TempConfigMediaBuffer."Media Set".Count;

                    if Count = 0 then
                        IsExit := true
                    else
                        //añadimos el valor del ID a una variable para buscarlo
                        ValueIdMediaSet := Format(TempConfigMediaBuffer."Media Set".Item(1));
                end;
            FieldType::Media:
                begin
                    TempConfigMediaBuffer.Media := FieldRefe.Value;

                    if not TempConfigMediaBuffer."Media".HasValue then
                        IsExit := true
                    else
                        //añadimos el valor del ID a una variable para buscarlo
                        ValueIdMediaSet := Format(TempConfigMediaBuffer."Media".MediaId);
                end;
            FieldType::Blob:
                begin
                    //calculamos el Blob si no esta sale
                    if not FieldRefe.CalcField() then
                        IsExit := true
                    else
                        //añadimos el blob en la temporal
                        TempConfigMediaBuffer."Media Blob" := FieldRefe.Value;

                    if TempConfigMediaBuffer."Media Blob".Length < 1 then
                        IsExit := true;


                end;
        end;

        //hacemos el clear de los campo de la tabla temporal para vaciarlo y que no se queden restos del archivo
        if IsExit then begin
            Clear(TempConfigMediaBuffer."Media");
            Clear(TempConfigMediaBuffer."Media Set");
            Clear(TempConfigMediaBuffer."Media Blob");
            Clear(TempConfigMediaBuffer);
            exit;
        end;

        //buscamos el valor en el tenant media y creamos el InStream para convertirlo en un Base64
        if FieldRefe.Type() in [FieldType::Media, FieldType::MediaSet] then begin
            TenantMedia.Reset();
            TenantMedia.Get(ValueIdMediaSet);
            TenantMedia.CalcFields(Content);
            TenantMedia.Content.CreateInStream(InStream);
            ReturnValue := Base64Convert.ToBase64(InStream);
        end;

        if FieldRefe.Type() = FieldType::Blob then begin
            //buscamos el valor en el tenant media y creamos el InStream para convertirlo en un Base64
            TempConfigMediaBuffer."Media Blob".CreateInStream(InStream);
            ReturnValue := Base64Convert.ToBase64(InStream);
        end;

        //hacemos el clear del campo de la tabla temporal para vaciarlo y que no se queden restos del archivo
        Clear(TempConfigMediaBuffer."Media");
        Clear(TempConfigMediaBuffer."Media Set");
        Clear(TempConfigMediaBuffer."Media Blob");
        Clear(TempConfigMediaBuffer);
    end;

    #endregion

    #region FUNCIONES COMUNES
    //funcion para sobreescribir los datos
    procedure SetOverWrite(NewOverWrite: Boolean)
    begin
        OverWrite := NewOverWrite;
    end;

    procedure SetChangeCompany(NewChangeCompany: Text)
    begin
        ChangeCompany := NewChangeCompany;
    end;

    local procedure GetJsonFieldName(FieldRefe: FieldRef): Text
    var
        Name: Text;
        i: Integer;
    begin
        Name := FieldRefe.Name();
        for i := 1 to Strlen(Name) do
            if Name[i] < '0' then
                Name[i] := '_';
        exit(Name.Replace('__', '_').TrimEnd('_').TrimStart('_'));
    end;
    #endregion

    var
        OverWrite: Boolean;
        ChangeCompany: Text;
}