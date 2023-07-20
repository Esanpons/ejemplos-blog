page 90024 "Table Relations MetadataMGS"
{
    ApplicationArea = All;
    Caption = 'Table Relations Metadata';
    PageType = List;
    SourceTable = "Table Relations Metadata";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Condition Field No."; Rec."Condition Field No.")
                {
                    ToolTip = 'Specifies the value of the Condition Field No. field.';
                    ApplicationArea = All;
                }
                field("Condition No."; Rec."Condition No.")
                {
                    ToolTip = 'Specifies the value of the Condition No. field.';
                    ApplicationArea = All;
                }
                field("Condition Type"; Rec."Condition Type")
                {
                    ToolTip = 'Specifies the value of the Condition Type field.';
                    ApplicationArea = All;
                }
                field("Condition Value"; Rec."Condition Value")
                {
                    ToolTip = 'Specifies the value of the Condition Value field.';
                    ApplicationArea = All;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ToolTip = 'Specifies the value of the Field Name field.';
                    ApplicationArea = All;
                }
                field("Field No."; Rec."Field No.")
                {
                    ToolTip = 'Specifies the value of the Field No. field.';
                    ApplicationArea = All;
                }
                field("Related Field Name"; Rec."Related Field Name")
                {
                    ToolTip = 'Specifies the value of the Related Field Name field.';
                    ApplicationArea = All;
                }
                field("Related Field No."; Rec."Related Field No.")
                {
                    ToolTip = 'Specifies the value of the Related Field No. field.';
                    ApplicationArea = All;
                }
                field("Related Table ID"; Rec."Related Table ID")
                {
                    ToolTip = 'Specifies the value of the Related Table ID field.';
                    ApplicationArea = All;
                }
                field("Related Table Name"; Rec."Related Table Name")
                {
                    ToolTip = 'Specifies the value of the Related Table Name field.';
                    ApplicationArea = All;
                }
                field("Relation No."; Rec."Relation No.")
                {
                    ToolTip = 'Specifies the value of the Relation No. field.';
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
                field("Table ID"; Rec."Table ID")
                {
                    ToolTip = 'Specifies the value of the Table ID field.';
                    ApplicationArea = All;
                }
                field("Table Name"; Rec."Table Name")
                {
                    ToolTip = 'Specifies the value of the Table Name field.';
                    ApplicationArea = All;
                }
                field("Test Table Relation"; Rec."Test Table Relation")
                {
                    ToolTip = 'Specifies the value of the Test Table Relation field.';
                    ApplicationArea = All;
                }
                field("Validate Table Relation"; Rec."Validate Table Relation")
                {
                    ToolTip = 'Specifies the value of the Validate Table Relation field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
