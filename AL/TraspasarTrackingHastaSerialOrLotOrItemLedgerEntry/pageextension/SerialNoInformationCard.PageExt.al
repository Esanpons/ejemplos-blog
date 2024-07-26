pageextension 60000 "Serial No. Information Card" extends "Serial No. Information Card"
{
    layout
    {
        addafter("Serial No.")
        {
            field("Serial No. 2"; Rec."Serial No. 2")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
                ShowMandatory = true;
            }
            field("Serial No. 3"; Rec."Serial No. 3")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
            field("Serial No. 4"; Rec."Serial No. 4")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
        }
    }


}