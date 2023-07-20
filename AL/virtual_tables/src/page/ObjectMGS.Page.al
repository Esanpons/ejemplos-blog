page 90005 "ObjectMGS"
{
    ApplicationArea = All;
    Caption = 'Object';
    PageType = List;
    SourceTable = Object;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("BLOB Reference"; Rec."BLOB Reference")
                {
                    ToolTip = 'Specifies the value of the BLOB Reference field.';
                    ApplicationArea = All;
                }
                field("BLOB Size"; Rec."BLOB Size")
                {
                    ToolTip = 'Specifies the value of the BLOB Size field.';
                    ApplicationArea = All;
                }
                field(Caption; Rec.Caption)
                {
                    ToolTip = 'Specifies the value of the Caption field.';
                    ApplicationArea = All;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Specifies the value of the Company Name field.';
                    ApplicationArea = All;
                }
                field(Compiled; Rec.Compiled)
                {
                    ToolTip = 'Specifies the value of the Compiled field.';
                    ApplicationArea = All;
                }
                field("DBM Table No."; Rec."DBM Table No.")
                {
                    ToolTip = 'Specifies the value of the DBM Table No. field.';
                    ApplicationArea = All;
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.';
                    ApplicationArea = All;
                }
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.';
                    ApplicationArea = All;
                }
                field(Locked; Rec.Locked)
                {
                    ToolTip = 'Specifies the value of the Locked field.';
                    ApplicationArea = All;
                }
                field("Locked By"; Rec."Locked By")
                {
                    ToolTip = 'Specifies the value of the Locked By field.';
                    ApplicationArea = All;
                }
                field(Modified; Rec.Modified)
                {
                    ToolTip = 'Specifies the value of the Modified field.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
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
                field("Time"; Rec."Time")
                {
                    ToolTip = 'Specifies the value of the Time field.';
                    ApplicationArea = All;
                }
                field(Type; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Version List"; Rec."Version List")
                {
                    ToolTip = 'Specifies the value of the Version List field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
