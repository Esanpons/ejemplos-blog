page 90001 "Extension Execution InfoMGS"
{
    ApplicationArea = All;
    Caption = 'Extension Execution Info';
    PageType = List;
    SourceTable = "Extension Execution Info";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Execution Time"; Rec."Execution Time")
                {
                    ToolTip = 'Specifies the value of the Execution time field.';
                    ApplicationArea = All;
                }
                field("Form ID"; Rec."Form ID")
                {
                    ToolTip = 'Specifies the value of the Form ID field.';
                    ApplicationArea = All;
                }
                field("Runtime Package ID"; Rec."Runtime Package ID")
                {
                    ToolTip = 'Specifies the value of the Runtime Package ID field.';
                    ApplicationArea = All;
                }
                field("Subscriber Execution Count"; Rec."Subscriber Execution Count")
                {
                    ToolTip = 'Specifies the value of the Subscriber execution count field.';
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
