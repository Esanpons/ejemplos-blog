pageextension 60031 "Price List Lines" extends "Price List Lines"
{
    layout
    {
        addafter("Variant Code")
        {
            field("Location Code"; Rec."Location Code")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
        }
    }
}