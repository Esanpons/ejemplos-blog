page 90025 "Database LocksMGS"
{
    ApplicationArea = All;
    Caption = 'Database Locks';
    PageType = List;
    SourceTable = "Database Locks";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("AL Method Scope"; Rec."AL Method Scope")
                {
                    ToolTip = 'Specifies the AL method that is executed in the context of the given AL object.';
                    ApplicationArea = All;
                }
                field("AL Object Extension Name"; Rec."AL Object Extension Name")
                {
                    ToolTip = 'Specifies the extension name for an AL object that is executed in the context of the SQL lock.';
                    ApplicationArea = All;
                }
                field("AL Object Id"; Rec."AL Object Id")
                {
                    ToolTip = 'Specifies the AL object ID that is executed in the context of the SQL lock.';
                    ApplicationArea = All;
                }
                field("AL Object Name"; Rec."AL Object Name")
                {
                    ToolTip = 'Specifies the AL object name that is executed in the context of the SQL lock.';
                    ApplicationArea = All;
                }
                field("AL Object Type"; Rec."AL Object Type")
                {
                    ToolTip = 'Specifies the AL object type that is executed in the context of the SQL lock.';
                    ApplicationArea = All;
                }
                field("Object Name"; Rec."Object Name")
                {
                    ToolTip = 'Specifies the name of table on which the lock request was done.';
                    ApplicationArea = All;
                }
                field("Request Mode"; Rec."Request Mode")
                {
                    ToolTip = 'Specifies the SQL lock request mode that determines how concurrent transactions can access the resource. For granted requests, this is the granted mode; for waiting requests, this is the mode being requested.';
                    ApplicationArea = All;
                }
                field("Request Status"; Rec."Request Status")
                {
                    ToolTip = 'Specifies the SQL lock request status.';
                    ApplicationArea = All;
                }
                field("Resource Type"; Rec."Resource Type")
                {
                    ToolTip = 'Specifies the database resource affected by the SQL lock';
                    ApplicationArea = All;
                }
                field("SQL Session ID"; Rec."SQL Session ID")
                {
                    ToolTip = 'Specifies the session ID.';
                    ApplicationArea = All;
                }
                field("Session ID"; Rec."Session ID")
                {
                    ToolTip = 'Specifies the User Session ID.';
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
                field("Transaction ID"; Rec."Transaction ID")
                {
                    ToolTip = 'Specifies the value of the Transaction ID field.';
                    ApplicationArea = All;
                }
                field("User Name"; Rec."User Name")
                {
                    ToolTip = 'Specifies the user that has requested the SQL lock.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
