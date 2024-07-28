codeunit 51100 "ConvertRecToJsonSimple"
{
    procedure Ejecute(VarianRec: Variant) JsonText: Text;
    var
        RecRef: RecordRef;
        FieldRefe: FieldRef;
        RecField: Record Field;
        Json: JsonObject;
    begin
        RecRef.GetTable(VarianRec);
        RecField.SetRange(RecField.TableNo, RecRef.Number);
        RecField.SetFilter(Type, '<>%1&<>%2&<>%3&<>%4&<>%5', RecField.Type::BLOB, RecField.Type::DateFormula, RecField.Type::GUID, RecField.Type::Media, RecField.Type::MediaSet);
        RecField.SetFilter(ObsoleteState, '<>%1&<>%2', RecField.ObsoleteState::Removed, RecField.ObsoleteState::Pending);
        if RecField.FindSet() then
            repeat
                FieldRefe := RecRef.Field(RecField."No.");

                if RecField.Class = RecField.Class::FlowField then
                    FieldRefe.CalcField();

                Json.Add(RecField.FieldName, format(FieldRefe.Value));
            until RecField.Next() = 0;
        Json.WriteTo(JsonText);
    end;
}