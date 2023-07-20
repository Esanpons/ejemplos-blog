codeunit 50101 "Simple Mgt. Json"
{
    procedure CreateJsonToRec(RecVariant: Variant) JsonText: Text;
    var
        RecField: Record Field;
        RecordRefe: RecordRef;
        FieldRefe: FieldRef;
        Json: JsonObject;
    begin
        RecordRefe.GetTable(RecVariant);
        RecField.SetRange(RecField.TableNo, RecordRefe.Number);
        RecField.SetFilter(Type, '<>%1&<>%2&<>%3&<>%4&<>%5', RecField.Type::BLOB, RecField.Type::DateFormula, RecField.Type::GUID, RecField.Type::Media, RecField.Type::MediaSet);
        RecField.SetFilter(ObsoleteState, '<>%1&<>%2', RecField.ObsoleteState::Removed, RecField.ObsoleteState::Pending);
        if RecField.FindSet() then
            repeat
                FieldRefe := RecordRefe.Field(RecField."No.");
                Json.Add(RecField.FieldName, format(FieldRefe.Value));
            until RecField.Next() = 0;
        Json.WriteTo(JsonText);
    end;
}