codeunit 50100 "EnTextoDejarSoloNumeros"
{
    procedure DejarSoloNumeros(InputText: Text) OutputText: Text
    var
        i: Integer;
        ValueInt: Integer;
        ValueText: Text;
    begin
        OutputText := '';
        for i := 1 to StrLen(InputText) do begin
            ValueText := InputText[i];
            if Evaluate(ValueInt, ValueText) then
                OutputText += ValueText;
        end;
    end;
}