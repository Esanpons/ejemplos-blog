page 90029 "NAV App Tenant OperationMGS"
{
    ApplicationArea = All;
    Caption = 'NAV App Tenant Operation';
    PageType = List;
    SourceTable = "NAV App Tenant Operation";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field(Details; Rec.Details)
                {
                    ToolTip = 'Specifies the value of the Details field.';
                    ApplicationArea = All;
                }
                field(Metadata; Rec.Metadata)
                {
                    ToolTip = 'Specifies the value of the Metadata field.';
                    ApplicationArea = All;
                }
                field("Metadata Key"; Rec."Metadata Key")
                {
                    ToolTip = 'Specifies the value of the Metadata Key field.';
                    ApplicationArea = All;
                }
                field("Metadata Version"; Rec."Metadata Version")
                {
                    ToolTip = 'Specifies the value of the Metadata Version field.';
                    ApplicationArea = All;
                }
                field("Operation ID"; Rec."Operation ID")
                {
                    ToolTip = 'Specifies the value of the Operation ID field.';
                    ApplicationArea = All;
                }
                field("Operation Type"; Rec."Operation Type")
                {
                    ToolTip = 'Specifies the value of the Operation Type field.';
                    ApplicationArea = All;
                }
                field("Started On"; Rec."Started On")
                {
                    ToolTip = 'Specifies the deployment start date.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the deployment status.';
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
