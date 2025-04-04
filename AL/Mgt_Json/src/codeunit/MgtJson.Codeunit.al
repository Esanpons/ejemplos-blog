codeunit 71002 "Mgt. Json"
{
    // #Creado por Esteve Sanpons Carballares.
    // #https://github.com/Esanpons
    // #Se da acceso libre a modificar y utilizar este objeto libremente. Siempre y cuando se haga referencia al autor.

    #region GetValue Text
    procedure GetValueText(Json: JsonObject; Tag: Text) ReturnValue: Text;
    var
        ValueText: Text;
    begin
        Json.WriteTo(ValueText);
        ReturnValue := this.GetValueText(ValueText, Tag);
    end;

    procedure GetValueText(Json: Text; Tag: Text) ReturnValue: Text;
    var
        JSONManagement: Codeunit "JSON Management";
    begin
        Clear(JSONManagement);
        JSONManagement.InitializeObject(Json);
        ReturnValue := JSONManagement.GetValue(Tag);
    end;

    procedure GetValueInteger(Json: JsonObject; Tag: Text) ReturnValue: Integer;
    var
        ValueText: Text;
    begin
        Json.WriteTo(ValueText);
        ReturnValue := this.GetValueInteger(ValueText, Tag);
    end;

    procedure GetValueInteger(Json: Text; Tag: Text) ReturnValue: Integer;
    var
        ValueText: Text;
    begin
        ValueText := this.GetValueText(Json, Tag);
        if ValueText = '' then
            exit;

        if not Evaluate(ReturnValue, ValueText) then
            Error(this.Text001Err, ValueText, Tag);
    end;

    procedure GetValueDecimal(Json: JsonObject; Tag: Text) ReturnValue: Decimal;
    var
        ValueText: Text;
    begin
        Json.WriteTo(ValueText);
        ReturnValue := this.GetValueDecimal(ValueText, Tag);
    end;

    procedure GetValueDecimal(Json: Text; Tag: Text) ReturnValue: Decimal;
    var
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        JsonValue: JsonValue;
    begin
        Clear(ReturnValue);
        if not JsonObject.ReadFrom(Json) then
            exit;

        if not JsonObject.Get(tag, JsonToken) then
            exit;

        if not JsonToken.IsValue() then
            exit;

        JsonValue := JsonToken.AsValue();
        ReturnValue := JsonValue.AsDecimal();
    end;

    procedure GetValueDateTime(Json: JsonObject; Tag: Text) ReturnValue: DateTime;
    var
        ValueText: Text;
    begin
        Json.WriteTo(ValueText);
        ReturnValue := this.GetValueDateTime(ValueText, Tag);
    end;

    procedure GetValueDateTime(Json: Text; Tag: Text) ReturnValue: DateTime;
    var
        ValueText: Text;
    begin
        ValueText := this.GetValueText(Json, Tag);
        if ValueText = '' then
            exit;

        if not Evaluate(ReturnValue, ValueText) then
            Error(this.Text001Err, ValueText, Tag);
    end;

    procedure GetValueDate(Json: JsonObject; Tag: Text) ReturnValue: Date;
    var
        ValueText: Text;
    begin
        Json.WriteTo(ValueText);
        ReturnValue := this.GetValueDate(ValueText, Tag);
    end;

    procedure GetValueDate(Json: Text; Tag: Text) ReturnValue: Date;
    var
        ValueText: Text;
    begin
        ValueText := this.GetValueText(Json, Tag);
        if ValueText = '' then
            exit;

        if not Evaluate(ReturnValue, ValueText) then
            Error(this.Text001Err, ValueText, Tag);
    end;

    procedure GetValueTime(Json: JsonObject; Tag: Text) ReturnValue: Time;
    var
        ValueText: Text;
    begin
        Json.WriteTo(ValueText);
        ReturnValue := this.GetValueTime(ValueText, Tag);
    end;

    procedure GetValueTime(Json: Text; Tag: Text) ReturnValue: Time;
    var
        ValueText: Text;
    begin
        ValueText := this.GetValueText(Json, Tag);
        if ValueText = '' then
            exit;

        if not Evaluate(ReturnValue, ValueText) then
            Error(this.Text001Err, ValueText, Tag);
    end;

    procedure GetValueBoolean(Json: JsonObject; Tag: Text) ReturnValue: Boolean;
    var
        ValueText: Text;
    begin
        Json.WriteTo(ValueText);
        ReturnValue := this.GetValueBoolean(ValueText, Tag);
    end;

    procedure GetValueBoolean(Json: Text; Tag: Text) ReturnValue: Boolean;
    var
        ValueText: Text;
    begin
        ValueText := this.GetValueText(Json, Tag);
        if ValueText = '' then
            exit;

        if not Evaluate(ReturnValue, ValueText) then
            Error(this.Text001Err, ValueText, Tag);
    end;

    procedure GetValueJsonObject(Json: JsonObject; Tag: Text) ReturnValue: JsonObject;
    var
        ValueText: Text;
    begin
        Json.WriteTo(ValueText);
        ReturnValue := this.GetValueJsonObject(ValueText, Tag);
    end;

    procedure GetValueJsonObject(Json: Text; Tag: Text) ReturnValue: JsonObject;
    var
        ValueText: Text;
    begin
        ValueText := this.GetValueText(Json, Tag);
        ReturnValue.ReadFrom(ValueText);
    end;

    procedure GetValueJsonArray(Json: JsonObject; Tag: Text) ReturnValue: JsonArray;
    var
        ValueText: Text;
    begin
        ValueText := this.GetValueText(Json, Tag);
        ReturnValue.ReadFrom(ValueText);
    end;

    procedure GetValueJsonArray(Json: Text; Tag: Text) ReturnValue: JsonArray;
    var
        ValueText: Text;
    begin
        ValueText := this.GetValueText(Json, Tag);
        ReturnValue.ReadFrom(ValueText);
    end;

    procedure GetValueFromJsonArray(Json: JsonArray; Index: Integer) ReturnValue: Text;
    var
        ValueText: Text;
    begin
        Json.WriteTo(ValueText);
        ReturnValue := this.GetValueFromJsonArray(ValueText, Index);
    end;

    procedure GetValueFromJsonArray(Json: Text; Index: Integer) ReturnValue: Text;
    var
        JSONManagement: Codeunit "JSON Management";
    begin
        Clear(JSONManagement);
        JSONManagement.InitializeCollection(Json);
        JSONManagement.GetObjectFromCollectionByIndex(ReturnValue, Index);
    end;

    procedure GetJsonObjectFromJsonArray(Json: JsonArray; Index: Integer) ReturnValue: JsonObject;
    var
        ValueText: Text;
    begin
        Json.WriteTo(ValueText);
        ReturnValue := this.GetJsonObjectFromJsonArray(ValueText, Index);
    end;

    procedure GetJsonObjectFromJsonArray(Json: Text; Index: Integer) ReturnValue: JsonObject;
    var
        ValueText: Text;
    begin
        ValueText := this.GetValueFromJsonArray(Json, Index);
        ReturnValue.ReadFrom(ValueText);
    end;

    #endregion

    #region SetValue
    procedure SetValue(Json: JsonObject; Tag: Text; NewValueVariant: Variant) ReturnValue: JsonObject;
    var
        ValueText: Text;
    begin
        Json.WriteTo(ValueText);
        ValueText := this.SetValue(ValueText, Tag, NewValueVariant);
        Clear(ReturnValue);
        ReturnValue.WriteTo(ValueText);
    end;

    procedure SetValue(JsonText: Text; Tag: Text; NewValueVariant: Variant) ReturnValue: Text
    var
        JsonObject: JsonObject;
        JValue: JsonValue;
    begin
        JsonObject.ReadFrom(JsonText);
        JValue := this.FieldRefToJsonValue(NewValueVariant);
        JsonObject.Replace(tag, JValue);
        JsonObject.WriteTo(ReturnValue);
    end;


    local procedure FieldRefToJsonValue(ValueVariant: Variant) JsonValue: JsonValue;
    var
        ValueDate: Date;
        ValueDateTime: DateTime;
        ValueTime: Time;
        ValueInt: Integer;
        ValueDec: Decimal;
        ValueOption: Option;
        ValueBoo: Boolean;
    begin
        Clear(JsonValue);

        case true of
            ValueVariant.IsCode(),
            ValueVariant.IsText:
                JsonValue.SetValue(Format(ValueVariant));
            ValueVariant.IsInteger:
                begin
                    ValueInt := ValueVariant;
                    JsonValue.SetValue(ValueInt);
                end;
            ValueVariant.IsDate:
                begin
                    ValueDate := ValueVariant;
                    JsonValue.SetValue(ValueDate);
                end;
            ValueVariant.IsTime:
                begin
                    ValueTime := ValueVariant;
                    JsonValue.SetValue(ValueTime);
                end;
            ValueVariant.IsDateTime:
                begin
                    ValueDateTime := ValueVariant;
                    JsonValue.SetValue(ValueDateTime);
                end;
            ValueVariant.IsDecimal:
                begin
                    ValueDec := ValueVariant;
                    JsonValue.SetValue(ValueDec);
                end;
            ValueVariant.IsOption:
                begin
                    ValueOption := ValueVariant;
                    JsonValue.SetValue(ValueOption);
                end;
            ValueVariant.IsBoolean:
                begin
                    ValueBoo := ValueVariant;
                    JsonValue.SetValue(ValueBoo);
                end;
            else
                JsonValue.SetValue(Format(ValueVariant));
        end;
    end;


    #endregion
    #region Others
    procedure HasValue(Json: JsonObject; Tag: Text) ReturnValue: Boolean;
    var
        ValueText: Text;
    begin
        Json.WriteTo(ValueText);
        ReturnValue := this.HasValue(ValueText, Tag);
    end;

    procedure HasValue(Json: Text; Tag: Text) ReturnValue: Boolean
    var
        ValueText: Text;
    begin
        Clear(ReturnValue);
        ValueText := this.GetValueText(Json, Tag);
        if ValueText <> '' then
            ReturnValue := true;
    end;

    // Procedimiento que da formato a un texto JSON.
    // Se lee el texto JSON, se recorre su estructura y se genera un nuevo texto formateado.
    procedure FormatJsonText(JsonText: Text): Text
    var
        TempJsonBuffer: Record "JSON Buffer" temporary;
        JsonTextReaderWriter: Codeunit "Json Text Reader/Writer";
        LastPropertyName: Text;
        FormattedJson: Text;
    begin
        // Se lee el texto JSON y se carga en el buffer temporal.
        JsonTextReaderWriter.ReadJSonToJSonBuffer(JsonText, TempJsonBuffer);

        // Se recorre el buffer si tiene registros.
        if TempJsonBuffer.FindSet() then
            repeat
                // Se evalúa el tipo de token para determinar la acción correspondiente.
                case TempJsonBuffer."Token type" of
                    // Se almacena el nombre de la propiedad para su uso posterior.
                    TempJsonBuffer."Token type"::"Property Name":
                        LastPropertyName := TempJsonBuffer.Value;

                    // Se inicia un nuevo objeto JSON.
                    TempJsonBuffer."Token type"::"Start Object":
                        if LastPropertyName <> '' then begin
                            JsonTextReaderWriter.WriteStartObject(LastPropertyName);
                            LastPropertyName := '';
                        end else
                            JsonTextReaderWriter.WriteStartObject('');

                    // Se cierra un objeto JSON.
                    TempJsonBuffer."Token type"::"End Object":
                        JsonTextReaderWriter.WriteEndObject();

                    // Se inicia un nuevo array JSON.
                    TempJsonBuffer."Token type"::"Start Array":
                        if LastPropertyName <> '' then begin
                            JsonTextReaderWriter.WriteStartArray(LastPropertyName);
                            LastPropertyName := '';
                        end else
                            JsonTextReaderWriter.WriteStartArray('');

                    // Se cierra un array JSON.
                    TempJsonBuffer."Token type"::"End Array":
                        JsonTextReaderWriter.WriteEndArray();

                    // Se escribe una propiedad de tipo cadena.
                    TempJsonBuffer."Token type"::String:
                        if LastPropertyName <> '' then begin
                            JsonTextReaderWriter.WriteStringProperty(LastPropertyName, TempJsonBuffer.Value);
                            LastPropertyName := '';
                        end else
                            JsonTextReaderWriter.WriteValue(TempJsonBuffer.Value);

                    // Se escribe una propiedad de tipo numérico (entero o decimal).
                    TempJsonBuffer."Token type"::Integer,
                    TempJsonBuffer."Token type"::Decimal:
                        if LastPropertyName <> '' then begin
                            JsonTextReaderWriter.WriteNumberProperty(LastPropertyName, TempJsonBuffer.Value);
                            LastPropertyName := '';
                        end else
                            JsonTextReaderWriter.WriteValue(TempJsonBuffer.Value);

                    // Se escribe una propiedad de tipo booleano.
                    TempJsonBuffer."Token type"::Boolean:
                        if LastPropertyName <> '' then begin
                            JsonTextReaderWriter.WriteBooleanProperty(LastPropertyName, TempJsonBuffer.Value);
                            LastPropertyName := '';
                        end else
                            JsonTextReaderWriter.WriteValue(TempJsonBuffer.Value);

                    // Se escribe una propiedad con valor nulo.
                    TempJsonBuffer."Token type"::Null:
                        if LastPropertyName <> '' then begin
                            JsonTextReaderWriter.WriteNullProperty(LastPropertyName);
                            LastPropertyName := '';
                        end else
                            JsonTextReaderWriter.WriteNullValue();
                end;
            until TempJsonBuffer.Next() = 0;

        // Se obtiene el texto JSON formateado.
        FormattedJson := JsonTextReaderWriter.GetJSonAsText();
        exit(FormattedJson);
    end;


    procedure FomatDecimal(Value: Decimal) ReturnValue: Decimal
    var
        ValueText1: Text;
        ValueText2: Text;
        ValueText3: Text;
        ValueDec: Decimal;
        Lenght: Integer;
    begin
        ReturnValue := Value;

        ValueText1 := Format(Value);
        if ValueText1 = '' then
            exit;

        ValueText1 := DelChr(ValueText1, '=', ',');
        ValueText1 := DelChr(ValueText1, '=', '.');
        Lenght := StrLen(ValueText1);

        case Lenght of
            0:
                exit;
            1:
                begin
                    ValueText2 := '0';
                    ValueText3 := '0' + ValueText1;
                end;
            2:
                begin
                    ValueText2 := '0';
                    ValueText3 := ValueText1;
                end;
            else begin
                ValueText2 := CopyStr(ValueText1, 1, Lenght - 2);
                ValueText3 := CopyStr(ValueText1, Lenght - 1, Lenght);
            end;

        end;

        ValueText1 := ValueText2 + ',' + ValueText3;
        if not Evaluate(ValueDec, ValueText1) then
            exit;

        ReturnValue := ValueDec;
    end;



    #endregion

    var
        Text001Err: Label 'The value "%1" cannot be evaluated in the tag "%2"', Comment = 'ESP="El valor "%1", no puede ser evaluado en el Tag "%2""';


}