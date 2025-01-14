pageextension 50100 "Sales Order" extends "Sales Order"
{
    layout
    {
        modify("Posting Date")
        {
            trigger OnAfterValidate()
            begin
                Message(Msg, Rec."Posting Date".Year, Rec."Posting Date".Month, Rec."Posting Date".Day, Rec."Posting Date".WeekNo, Rec."Posting Date".DayOfWeek);
            end;
        }
    }
    var
        Msg: Label 'Year: %1\Month: %2\Day: %3\Day Of Week: %4\Week No.: %5', Comment = 'ESP="Año: %1\Mes: %2\Día: %3\Día de la Semana: %4\N.º de Semana: %5"';

}