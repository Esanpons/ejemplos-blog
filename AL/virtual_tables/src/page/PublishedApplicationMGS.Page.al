page 90036 "Published ApplicationMGS"
{
    ApplicationArea = All;
    Caption = 'Published Application';
    PageType = List;
    SourceTable = "Published Application";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("App Insights Connection String"; Rec."App Insights Connection String")
                {
                    ToolTip = 'Specifies the value of the Application Insights Connection String field.';
                    ApplicationArea = All;
                }
                field("Application Insights Key"; Rec."Application Insights Key")
                {
                    ToolTip = 'Specifies the value of the Application Insights Key field.';
                    ApplicationArea = All;
                }
                field("Blob"; Rec."Blob")
                {
                    ToolTip = 'Specifies the value of the Blob field.';
                    ApplicationArea = All;
                }
                field(Brief; Rec.Brief)
                {
                    ToolTip = 'Specifies the value of the Brief field.';
                    ApplicationArea = All;
                }
                field("Content Hash"; Rec."Content Hash")
                {
                    ToolTip = 'Specifies the value of the Content Hash field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field(Documentation; Rec.Documentation)
                {
                    ToolTip = 'Specifies the value of the Documentation field.';
                    ApplicationArea = All;
                }
                field(EULA; Rec.EULA)
                {
                    ToolTip = 'Specifies the value of the EULA field.';
                    ApplicationArea = All;
                }
                field(Help; Rec.Help)
                {
                    ToolTip = 'Specifies the value of the Help field.';
                    ApplicationArea = All;
                }
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.';
                    ApplicationArea = All;
                }
                field(Installed; Rec.Installed)
                {
                    ToolTip = 'Specifies the value of the Installed field.';
                    ApplicationArea = All;
                }
                field("Key Vault URLs"; Rec."Key Vault URLs")
                {
                    ToolTip = 'Specifies the value of the Key Vault URLs field.';
                    ApplicationArea = All;
                }
                field(Logo; Rec.Logo)
                {
                    ToolTip = 'Specifies the logo of the extension, such as the logo of the service provider.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the name of the extension.';
                    ApplicationArea = All;
                }
                field("Package Hash"; Rec."Package Hash")
                {
                    ToolTip = 'Specifies the value of the Package Hash field.';
                    ApplicationArea = All;
                }
                field("Package ID"; Rec."Package ID")
                {
                    ToolTip = 'Specifies the value of the Package ID field.';
                    ApplicationArea = All;
                }
                field("Package Type"; Rec."Package Type")
                {
                    ToolTip = 'Specifies the value of the Package Type field.';
                    ApplicationArea = All;
                }
                field("PerTenant Or Installed"; Rec."PerTenant Or Installed")
                {
                    ToolTip = 'Specifies the value of the PerTenant Or Installed field.';
                    ApplicationArea = All;
                }
                field("Privacy Statement"; Rec."Privacy Statement")
                {
                    ToolTip = 'Specifies the value of the Privacy Statement field.';
                    ApplicationArea = All;
                }
                field("Published As"; Rec."Published As")
                {
                    ToolTip = 'Specifies whether the extension is published as a per-tenant, development, or a global extension.';
                    ApplicationArea = All;
                }
                field(Publisher; Rec.Publisher)
                {
                    ToolTip = 'Specifies the publisher of the extension.';
                    ApplicationArea = All;
                }
                field("Publisher AAD Tenant ID"; Rec."Publisher AAD Tenant ID")
                {
                    ToolTip = 'Specifies the value of the Publisher AAD Tenant ID field.';
                    ApplicationArea = All;
                }
                field("Resource Exposure Policy"; Rec."Resource Exposure Policy")
                {
                    ToolTip = 'Specifies the value of the Resource Exposure Policy field.';
                    ApplicationArea = All;
                }
                field("Runtime Package ID"; Rec."Runtime Package ID")
                {
                    ToolTip = 'Specifies the value of the Runtime Package ID field.';
                    ApplicationArea = All;
                }
                field(Screenshots; Rec.Screenshots)
                {
                    ToolTip = 'Specifies the value of the Screenshots field.';
                    ApplicationArea = All;
                }
                field("Show My Code"; Rec."Show My Code")
                {
                    ToolTip = 'Specifies the value of the Show My Code field.';
                    ApplicationArea = All;
                }
                field(Symbols; Rec.Symbols)
                {
                    ToolTip = 'Specifies the value of the Symbols field.';
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
                field("Tenant Visible"; Rec."Tenant Visible")
                {
                    ToolTip = 'Specifies the value of the Tenant Visible field.';
                    ApplicationArea = All;
                }
                field(Url; Rec.Url)
                {
                    ToolTip = 'Specifies the value of the Url field.';
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
