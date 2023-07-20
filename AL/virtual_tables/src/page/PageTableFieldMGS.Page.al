page 90031 "Page Table FieldMGS"
{
    ApplicationArea = All;
    Caption = 'Page Table Field';
    PageType = List;
    SourceTable = "Page Table Field";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Caption; Rec.Caption)
                {
                    ToolTip = 'Specifies the caption of the field.';
                    ApplicationArea = All;
                }
                field("Field ID"; Rec."Field ID")
                {
                    ToolTip = 'Specifies the ID of the field.';
                    ApplicationArea = All;
                }
                field(IsTableField; Rec.IsTableField)
                {
                    ToolTip = 'Specifies the value of the IsTableField field.';
                    ApplicationArea = All;
                }
                field(Length; Rec.Length)
                {
                    ToolTip = 'Specifies the length of the field.';
                    ApplicationArea = All;
                }
                field("Page ID"; Rec."Page ID")
                {
                    ToolTip = 'Specifies the number of the page that is used to show the journal or worksheet that uses the template.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the field''s status, such as if the field is already placed on the page.';
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
                field(Type; Rec."Type")
                {
                    ToolTip = 'Specifies the type of the field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
