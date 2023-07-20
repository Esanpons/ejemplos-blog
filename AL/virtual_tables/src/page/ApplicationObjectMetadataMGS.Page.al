page 90011 "Application Object MetadataMGS"
{
    ApplicationArea = All;
    Caption = 'Application Object Metadata';
    PageType = List;
    SourceTable = "Application Object Metadata";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Metadata; Rec.Metadata)
                {
                    ToolTip = 'Specifies the value of the Metadata field.';
                    ApplicationArea = All;
                }
                field("Metadata Format"; Rec."Metadata Format")
                {
                    ToolTip = 'Specifies the value of the Metadata Format field.';
                    ApplicationArea = All;
                }
                field("Metadata Hash"; Rec."Metadata Hash")
                {
                    ToolTip = 'Specifies the value of the Metadata Hash field.';
                    ApplicationArea = All;
                }
                field("Metadata Version"; Rec."Metadata Version")
                {
                    ToolTip = 'Specifies the value of the Metadata Version field.';
                    ApplicationArea = All;
                }
                field("Object Flags"; Rec."Object Flags")
                {
                    ToolTip = 'Specifies the value of the Object Flags field.';
                    ApplicationArea = All;
                }
                field("Object ID"; Rec."Object ID")
                {
                    ToolTip = 'Specifies the value of the Object ID field.';
                    ApplicationArea = All;
                }
                field("Object Name"; Rec."Object Name")
                {
                    ToolTip = 'Specifies the value of the Object Name field.';
                    ApplicationArea = All;
                }
                field("Object Subtype"; Rec."Object Subtype")
                {
                    ToolTip = 'Specifies the value of the Object Subtype field.';
                    ApplicationArea = All;
                }
                field("Object Type"; Rec."Object Type")
                {
                    ToolTip = 'Specifies the value of the Object Type field.';
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
                field("User AL Code"; Rec."User AL Code")
                {
                    ToolTip = 'Specifies the value of the User AL Code field.';
                    ApplicationArea = All;
                }
                field("User Code"; Rec."User Code")
                {
                    ToolTip = 'Specifies the value of the User Code field.';
                    ApplicationArea = All;
                }
                field("User Code Hash"; Rec."User Code Hash")
                {
                    ToolTip = 'Specifies the value of the User Code Hash field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
