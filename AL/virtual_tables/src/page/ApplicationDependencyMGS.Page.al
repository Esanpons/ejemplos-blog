page 90026 "Application Dependency MGS"
{
    ApplicationArea = All;
    Caption = 'Application Dependency';
    PageType = List;
    SourceTable = "Application Dependency";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Dependency App ID"; Rec."Dependency App ID")
                {
                    ToolTip = 'Specifies the value of the Dependency App ID field.';
                    ApplicationArea = All;
                }
                field("Dependency Name"; Rec."Dependency Name")
                {
                    ToolTip = 'Specifies the value of the Dependency Name field.';
                    ApplicationArea = All;
                }
                field("Dependency Publisher"; Rec."Dependency Publisher")
                {
                    ToolTip = 'Specifies the value of the Dependency Publisher field.';
                    ApplicationArea = All;
                }
                field("Dependency Version Build"; Rec."Dependency Version Build")
                {
                    ToolTip = 'Specifies the value of the Dependency Version Build field.';
                    ApplicationArea = All;
                }
                field("Dependency Version Major"; Rec."Dependency Version Major")
                {
                    ToolTip = 'Specifies the value of the Dependency Version Major field.';
                    ApplicationArea = All;
                }
                field("Dependency Version Minor"; Rec."Dependency Version Minor")
                {
                    ToolTip = 'Specifies the value of the Dependency Version Minor field.';
                    ApplicationArea = All;
                }
                field("Dependency Version Revision"; Rec."Dependency Version Revision")
                {
                    ToolTip = 'Specifies the value of the Dependency Version Revision field.';
                    ApplicationArea = All;
                }
                field("Package ID"; Rec."Package ID")
                {
                    ToolTip = 'Specifies the value of the Package ID field.';
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
            }
        }
    }
}
