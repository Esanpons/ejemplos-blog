page 90035 "Token CacheMGS"
{
    ApplicationArea = All;
    Caption = 'Token Cache';
    PageType = List;
    SourceTable = "Token Cache";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Cache Data"; Rec."Cache Data")
                {
                    ToolTip = 'Specifies the value of the Cache Data field.';
                    ApplicationArea = All;
                }
                field("Cache Write Time"; Rec."Cache Write Time")
                {
                    ToolTip = 'Specifies the value of the Cache Write Time field.';
                    ApplicationArea = All;
                }
                field("Home Account ID"; Rec."Home Account ID")
                {
                    ToolTip = 'Specifies the value of the Home Account ID field.';
                    ApplicationArea = All;
                }
                field("Login Hint"; Rec."Login Hint")
                {
                    ToolTip = 'Specifies the value of the Login Hint field.';
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
                    ToolTip = 'Specifies the value of the Tenant ID field.';
                    ApplicationArea = All;
                }
                field("Tenant String Unique ID"; Rec."Tenant String Unique ID")
                {
                    ToolTip = 'Specifies the value of the Tenant String Unique ID field.';
                    ApplicationArea = All;
                }
                field("User Security ID"; Rec."User Security ID")
                {
                    ToolTip = 'Specifies the value of the User Security ID field.';
                    ApplicationArea = All;
                }
                field("User String Unique ID"; Rec."User String Unique ID")
                {
                    ToolTip = 'Specifies the value of the User String Unique ID field.';
                    ApplicationArea = All;
                }
                field("User Unique ID"; Rec."User Unique ID")
                {
                    ToolTip = 'Specifies the value of the User Unique ID field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
