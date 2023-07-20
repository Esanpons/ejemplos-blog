page 50100 "Setup Extension"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Setup Extension';
    PageType = Card;
    SourceTable = "Setup Extension";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Maximum Date"; Rec."Maximum Date")
                {
                    ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                }
                field("Quantity of Days"; Rec."Quantity of Days")
                {
                    ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                }
                field("Destination Warehouse"; Rec."Destination Warehouse")
                {
                    ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                }
            }
        }
    }

    trigger OnInit()
    begin
        if Rec.IsEmpty() then
            Rec.Insert();
        Commit();
    end;

    trigger OnClosePage()
    var
        GuidedExperience: Codeunit "Guided Experience";
    begin
        if (Rec."Maximum Date" <> 0D) And (Rec."Quantity of Days" <> 0) And (Rec."Destination Warehouse" <> '') then
            GuidedExperience.CompleteAssistedSetup(ObjectType::Page, Page::"Setup Extension")
        else
            GuidedExperience.ResetAssistedSetup(ObjectType::Page, Page::"Setup Extension");


    end;
}
