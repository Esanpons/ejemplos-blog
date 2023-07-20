page 90014 "NAV App ExtraMGS"
{
    ApplicationArea = All;
    Caption = 'NAV App Extra';
    PageType = List;
    SourceTable = "NAV App Extra";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Package ID"; Rec."Package ID")
                {
                    ToolTip = 'Specifies the value of the Package ID field.';
                    ApplicationArea = All;
                }
                field("PerTenant Or Installed"; Rec."PerTenant Or Installed")
                {
                    ToolTip = 'Specifies the value of the PerTenant Or Installed field.';
                    ApplicationArea = All;
                }
                field("Runtime Package ID"; Rec."Runtime Package ID")
                {
                    ToolTip = 'Specifies the value of the Runtime Package ID field.';
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.';
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                    ApplicationArea = All;
                }
                field("Tenant Visible"; Rec."Tenant Visible")
                {
                    ToolTip = 'Specifies the value of the Tenant Visible field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
