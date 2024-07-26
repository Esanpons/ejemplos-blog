pageextension 60002 "Lot No. Information Card" extends "Lot No. Information Card"
{
    layout
    {
        addafter("Lot No.")
        {
            field("Lot No. 2"; Rec."Lot No. 2")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
            field("Lot No. 3"; Rec."Lot No. 3")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
            field("Lot No. 4"; Rec."Lot No. 4")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
        }
    }
}