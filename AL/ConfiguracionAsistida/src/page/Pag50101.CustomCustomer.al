page 50101 "Custom Customer "
{
    ApplicationArea = All;
    Caption = 'Custom Customer ';
    PageType = List;
    SourceTable = Customer;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(City; Rec.City)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        GuidedExperience: Codeunit "Guided Experience";
    begin
        if not GuidedExperience.IsAssistedSetupComplete(ObjectType::Page, Page::"Setup Extension") then
            GuidedExperience.OpenAssistedSetup();
    end;
}
