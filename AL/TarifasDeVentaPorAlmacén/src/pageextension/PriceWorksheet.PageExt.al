pageextension 60032 "Price Worksheet" extends "Price Worksheet"
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