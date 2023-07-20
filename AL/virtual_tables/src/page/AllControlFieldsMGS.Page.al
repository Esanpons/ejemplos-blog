page 90019 "All Control FieldsMGS"
{
    ApplicationArea = All;
    Caption = 'All Control Fields';
    PageType = List;
    SourceTable = "All Control Fields";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Caption; Rec.Caption)
                {
                    ToolTip = 'Specifies the value of the Caption field.';
                    ApplicationArea = All;
                }
                field("Control ID"; Rec."Control ID")
                {
                    ToolTip = 'Specifies the value of the Control ID field.';
                    ApplicationArea = All;
                }
                field("Control Name"; Rec."Control Name")
                {
                    ToolTip = 'Specifies the value of the Control Name field.';
                    ApplicationArea = All;
                }
                field("Data Type"; Rec."Data Type")
                {
                    ToolTip = 'Specifies the value of the Data Type field.';
                    ApplicationArea = All;
                }
                field("Data Type Length"; Rec."Data Type Length")
                {
                    ToolTip = 'Specifies the value of the Data Type Length field.';
                    ApplicationArea = All;
                }
                field("Object ID"; Rec."Object ID")
                {
                    ToolTip = 'Specifies the value of the Object ID field.';
                    ApplicationArea = All;
                }
                field("Object Type"; Rec."Object Type")
                {
                    ToolTip = 'Specifies the value of the Object Type field.';
                    ApplicationArea = All;
                }
                field("Option Caption"; Rec."Option Caption")
                {
                    ToolTip = 'Specifies the value of the Option Caption field.';
                    ApplicationArea = All;
                }
                field("Option String"; Rec."Option String")
                {
                    ToolTip = 'Specifies the value of the Option String field.';
                    ApplicationArea = All;
                }
                field("Related Field ID"; Rec."Related Field ID")
                {
                    ToolTip = 'Specifies the value of the Related Field ID field.';
                    ApplicationArea = All;
                }
                field("Related Table ID"; Rec."Related Table ID")
                {
                    ToolTip = 'Specifies the value of the Related Table ID field.';
                    ApplicationArea = All;
                }
                field("Source Expression"; Rec."Source Expression")
                {
                    ToolTip = 'Specifies the value of the Source Expression field.';
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
