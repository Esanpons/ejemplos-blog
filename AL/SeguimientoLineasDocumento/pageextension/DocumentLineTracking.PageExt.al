pageextension 50100 "Document Line Tracking" extends "Document Line Tracking"
{
    layout
    {
        modify("No. of Records")
        {
            Visible = false;
        }
        addafter("No. of Records")
        {
            field("No. of Records2"; Rec."No. of Records")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
        }
    }
}