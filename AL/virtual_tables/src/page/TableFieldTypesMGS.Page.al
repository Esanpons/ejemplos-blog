page 90015 "Table Field TypesMGS"
{
    ApplicationArea = All;
    Caption = 'Table Field Types';
    PageType = List;
    SourceTable = "Table Field Types";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Blank; Rec.Blank)
                {
                    ToolTip = 'Specifies the value of the Blank field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies description.';
                    ApplicationArea = All;
                }
                field("Display Name"; Rec."Display Name")
                {
                    ToolTip = 'Specifies Name displayed to users.';
                    ApplicationArea = All;
                }
                field(FieldTypeGroup; Rec.FieldTypeGroup)
                {
                    ToolTip = 'Specifies the value of the FieldTypeGroup field.';
                    ApplicationArea = All;
                }
                field(Icon; Rec.Icon)
                {
                    ToolTip = 'Specifies the value of the Icon field.';
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
                field("Type ID"; Rec."Type ID")
                {
                    ToolTip = 'Specifies the value of the Type ID field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
