page 90033 "Scheduled TaskMGS"
{
    ApplicationArea = All;
    Caption = 'Scheduled Task';
    PageType = List;
    SourceTable = "Scheduled Task";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Company; Rec.Company)
                {
                    ToolTip = 'Specifies the company name for which this task was scheduled.';
                    ApplicationArea = All;
                }
                field("Failure Codeunit"; Rec."Failure Codeunit")
                {
                    ToolTip = 'Specifies the ID of a backup codeunit to run if the codeunit specified for the task fails.';
                    ApplicationArea = All;
                }
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the ID of the scheduled task.';
                    ApplicationArea = All;
                }
                field("Is Ready"; Rec."Is Ready")
                {
                    ToolTip = 'Specifies whether the task has been scheduled.';
                    ApplicationArea = All;
                }
                field("Last Error"; Rec."Last Error")
                {
                    ToolTip = 'Specifies the value of the Last Error field.';
                    ApplicationArea = All;
                }
                field("Not Before"; Rec."Not Before")
                {
                    ToolTip = 'Specifies the value of the Not Before field.';
                    ApplicationArea = All;
                }
                field("Record"; Rec."Record")
                {
                    ToolTip = 'Specifies the value of the Record field.';
                    ApplicationArea = All;
                }
                field("Run Codeunit"; Rec."Run Codeunit")
                {
                    ToolTip = 'Specifies the ID of the codeunit to run.';
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
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ToolTip = 'Specifies the ID of the tenant for which this task was scheduled.';
                    ApplicationArea = All;
                }
                field(Timeout; Rec.Timeout)
                {
                    ToolTip = 'Specifies the value of the Timeout field.';
                    ApplicationArea = All;
                }
                field("User App ID"; Rec."User App ID")
                {
                    ToolTip = 'Specifies the value of the User App ID field.';
                    ApplicationArea = All;
                }
                field("User Format ID"; Rec."User Format ID")
                {
                    ToolTip = 'Specifies the value of the User Format ID field.';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID field.';
                    ApplicationArea = All;
                }
                field("User Language ID"; Rec."User Language ID")
                {
                    ToolTip = 'Specifies the value of the User Language ID field.';
                    ApplicationArea = All;
                }
                field("User Name"; Rec."User Name")
                {
                    ToolTip = 'Specifies the username of the user who scheduled the task.';
                    ApplicationArea = All;
                }
                field("User Time Zone"; Rec."User Time Zone")
                {
                    ToolTip = 'Specifies the value of the User Time Zone field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
