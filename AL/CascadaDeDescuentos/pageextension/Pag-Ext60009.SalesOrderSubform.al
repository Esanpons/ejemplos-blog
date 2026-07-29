pageextension 60009 "Sales Order Subform" extends "Sales Order Subform"

{
    layout
    {
        addlast(Control1)
        {
            field("Dto1"; Rec."Dto1")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
            field("Dto2"; Rec."Dto2")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
            field("Dto3"; Rec."Dto3")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
        }
    }
}