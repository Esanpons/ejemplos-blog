page 90010 "Object MetadataMGS"
{
    ApplicationArea = All;
    Caption = 'Object Metadata';
    PageType = List;
    SourceTable = "Object Metadata";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Has Subscribers"; Rec."Has Subscribers")
                {
                    ToolTip = 'Specifies the value of the Has Subscribers field.';
                    ApplicationArea = All;
                }
                field(Hash; Rec.Hash)
                {
                    ToolTip = 'Specifies the value of the Hash field.';
                    ApplicationArea = All;
                }
                field(Metadata; Rec.Metadata)
                {
                    ToolTip = 'Specifies the value of the Metadata field.';
                    ApplicationArea = All;
                }
                field("Metadata Version"; Rec."Metadata Version")
                {
                    ToolTip = 'Specifies the value of the Metadata Version field.';
                    ApplicationArea = All;
                }
                field("Object ID"; Rec."Object ID")
                {
                    ToolTip = 'Specifies the value of the Object ID field.';
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
                field("Schema Hash"; Rec."Schema Hash")
                {
                    ToolTip = 'Specifies the value of the Schema Hash field.';
                    ApplicationArea = All;
                }
                field("Symbol Reference"; Rec."Symbol Reference")
                {
                    ToolTip = 'Specifies the value of the Symbol Reference field.';
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
            }
        }
    }
}
