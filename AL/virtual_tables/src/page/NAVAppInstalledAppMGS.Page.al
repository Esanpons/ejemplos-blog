page 90013 "NAV App Installed AppMGS"
{
    ApplicationArea = All;
    Caption = 'NAV App Installed App';
    PageType = List;
    SourceTable = "NAV App Installed App";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("App ID"; Rec."App ID")
                {
                    ToolTip = 'Specifies the ID of the extension.';
                    ApplicationArea = All;
                }
                field("Compatibility Build"; Rec."Compatibility Build")
                {
                    ToolTip = 'Specifies the value of the Compatibility Build field.';
                    ApplicationArea = All;
                }
                field("Compatibility Major"; Rec."Compatibility Major")
                {
                    ToolTip = 'Specifies the value of the Compatibility Major field.';
                    ApplicationArea = All;
                }
                field("Compatibility Minor"; Rec."Compatibility Minor")
                {
                    ToolTip = 'Specifies the value of the Compatibility Minor field.';
                    ApplicationArea = All;
                }
                field("Compatibility Revision"; Rec."Compatibility Revision")
                {
                    ToolTip = 'Specifies the value of the Compatibility Revision field.';
                    ApplicationArea = All;
                }
                field("Content Hash"; Rec."Content Hash")
                {
                    ToolTip = 'Specifies the value of the Content Hash field.';
                    ApplicationArea = All;
                }
                field("Extension Type"; Rec."Extension Type")
                {
                    ToolTip = 'Specifies the value of the Extension Type field.';
                    ApplicationArea = All;
                }
                field("Hash Algorithm"; Rec."Hash Algorithm")
                {
                    ToolTip = 'Specifies the value of the Hash Algorithm field.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the name of the extension.';
                    ApplicationArea = All;
                }
                field("Package ID"; Rec."Package ID")
                {
                    ToolTip = 'Specifies the ID of the package.';
                    ApplicationArea = All;
                }
                field("Published As"; Rec."Published As")
                {
                    ToolTip = 'Specifies the value of the Published As field.';
                    ApplicationArea = All;
                }
                field(Publisher; Rec.Publisher)
                {
                    ToolTip = 'Specifies the value of the Publisher field.';
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
                field("Version Build"; Rec."Version Build")
                {
                    ToolTip = 'Specifies the value of the Version Build field.';
                    ApplicationArea = All;
                }
                field("Version Major"; Rec."Version Major")
                {
                    ToolTip = 'Specifies the value of the Version Major field.';
                    ApplicationArea = All;
                }
                field("Version Minor"; Rec."Version Minor")
                {
                    ToolTip = 'Specifies the value of the Version Minor field.';
                    ApplicationArea = All;
                }
                field("Version Revision"; Rec."Version Revision")
                {
                    ToolTip = 'Specifies the value of the Version Revision field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
