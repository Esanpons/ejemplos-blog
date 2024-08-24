namespace SendMail.Base;
using Microsoft.Foundation.Reporting;
using System.Reflection;
using Microsoft.Warehouse.Setup;
using System.EMail;
using System.Globalization;

tableextension 60047 "Report Selection Warehouse" extends "Report Selection Warehouse"
{
    fields
    {
        field(60000; "Use for Email Subject"; Boolean)
        {
            Caption = 'Use for Email Subject', Comment = 'ESP="Uso para el asunto del correo electrónico"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not Rec."Use for Email Subject" then
                    Rec.Validate("Subject Layout Code", '');
            end;
        }
        field(60001; "Subject Layout Descr."; Text[250])
        {
            CalcFormula = lookup("Custom Report Layout".Description where(Code = field("Subject Layout Code")));
            Caption = 'Email Subject Layout Description', Comment = 'ESP="Descripción del diseño del asunto del correo electronico"';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            var
                CustomReportLayout: Record "Custom Report Layout";
            begin
                if Rec."Subject Layout Type" = Rec."Subject Layout Type"::"Custom Report Layout" then
                    if CustomReportLayout.LookupLayoutOK("Report ID") then
                        Rec.Validate("Subject Layout Code", CustomReportLayout.Code);
            end;
        }
        field(60002; "Subject Layout Code"; Code[20])
        {
            Caption = 'Email Subject Layout Code', Comment = 'ESP="Código de diseño de informe personalizado del asunto"';
            DataClassification = CustomerContent;
            TableRelation = if ("Subject Layout Type" = const("Custom Report Layout")) "Custom Report Layout".Code where(Code = field("Subject Layout Code"),
                                                                                                                           "Report ID" = field("Report ID"))
            else
            if ("Subject Layout Type" = const("HTML Layout")) "O365 HTML Template".Code;

            trigger OnValidate()
            begin
                CalcFields(Rec."Subject Layout Descr.");
            end;
        }
        field(60003; "Subject Layout Type"; Enum "Email Body Layout Type")
        {
            Caption = 'Email Body Layout Type', Comment = 'ESP="Tipo de diseño del asunto del correo"';
            DataClassification = CustomerContent;
            InitValue = "Custom Report Layout";
        }
        field(60004; "Language Code"; Code[10])
        {
            Caption = 'Language Code', Comment = 'ESP="Cód. idioma"';
            TableRelation = Language;
        }


        field(60010; "Use for Email Attachment"; Boolean)
        {
            Caption = 'Use for Email Attachment', Comment = 'ESP="Usar para los datos adjuntos de correo electrónico"';
            DataClassification = CustomerContent;
            InitValue = true;

            trigger OnValidate()
            begin
                if not "Use for Email Body" then begin
                    "Email Body Layout Code" := '';
                    "Email Body Layout Name" := '';
                end;
            end;
        }

        field(60011; "Use for Email Body"; Boolean)
        {
            Caption = 'Use for Email Body', Comment = 'ESP="Usar para el cuerpo del correo electrónico"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not "Use for Email Body" then begin
                    "Email Body Layout Code" := '';
                    "Email Body Layout Name" := '';
                end;
            end;
        }

        #region Body Layout
        field(60020; "Email Body Layout Code"; Code[20])
        {
            Caption = 'Email Body Custom Layout Code', Comment = 'ESP="Código del diseño personalizado del correo electrónico"';
            DataClassification = CustomerContent;
            TableRelation = if ("Email Body Layout Type" = const("Custom Report Layout")) "Custom Report Layout".Code where(Code = field("Email Body Layout Code"), "Report ID" = field("Report ID"), "Built-In" = const(false))
            else
            if ("Email Body Layout Type" = const("HTML Layout")) "O365 HTML Template".Code;

            trigger OnValidate()
            begin
                if "Email Body Layout Code" <> '' then begin
                    Testfield("Use for Email Body", true);
                    "Email Body Layout Name" := '';
                end;
                Calcfields("EmailBodyLayoutDescription");
            end;
        }
        field(60021; "EmailBodyLayoutDescription"; Text[250])
        {
            CalcFormula = lookup("Custom Report Layout".Description where(Code = field("Email Body Layout Code")));
            Caption = 'Email Body Custom Layout Description', Comment = 'ESP="Descripción del diseño del cuerpo del correo electrónico"';
            Editable = false;
            FieldClass = Flowfield;

            trigger OnLookup()
            var
                CustomReportLayout: Record "Custom Report Layout";
            begin
                if "Email Body Layout Type" = "Email Body Layout Type"::"Custom Report Layout" then
                    if CustomReportLayout.LookupLayoutOK("Report ID") then
                        Validate("Email Body Layout Code", CustomReportLayout.Code);
            end;
        }
        field(60022; "Email Body Layout Type"; Enum "Email Body Layout Type")
        {
            Caption = 'Email Body Layout Type', Comment = 'ESP="Tipo de diseño del cuerpo del correo"';
            DataClassification = CustomerContent;
        }

        field(60023; "Email Body Layout Name"; Text[250])
        {
            Caption = 'Email Body Layout Name', Comment = 'ESP="Nombre de diseño del cuerpo del correo electrónico"';
            DataClassification = CustomerContent;
            TableRelation = "Report Layout List".Name where("Report ID" = field("Report ID"));

            trigger OnLookup()
            var
                ReportLayoutList: Record "Report Layout List";
                ReportManagement: Codeunit ReportManagement;
                Handled: Boolean;
            begin
                ReportLayoutList.SetRange("Report ID", Rec."Report ID");
                ReportManagement.OnSelectReportLayout(ReportLayoutList, Handled);
                if not Handled then
                    exit;
                "Email Body Layout Name" := ReportLayoutList.Name;
                "Email Body Layout AppID" := ReportLayoutList."Application ID";
            end;

            trigger OnValidate()
            var
                ReportLayoutList: Record "Report Layout List";
            begin
                if "Email Body Layout Name" <> '' then begin
                    "Use for Email Body" := true;
                    "Email Body Layout Code" := '';
                    "EmailBodyLayoutDescription" := '';
                    ReportLayoutList.SetRange(Name, "Email Body Layout Name");
                    ReportLayoutList.SetRange("Report ID", Rec."Report ID");
                    if not IsNullGuid("Email Body Layout AppID") then
                        ReportLayoutList.SetRange("Application ID", "Email Body Layout AppID");
                    if not ReportLayoutList.FindFirst() then begin
                        ReportLayoutList.SetRange("Application ID");
                        ReportLayoutList.FindFirst();
                    end;
                    if IsNullGuid("Email Body Layout AppID") then
                        Rec."Email Body Layout AppID" := ReportLayoutList."Application ID";
                end;
            end;
        }

        field(60024; "Email Body Layout AppID"; Guid)
        {
            Caption = 'Email Body Layout AppID', Comment = 'ESP="Id. de aplicación de diseño del cuerpo del correo electrónico"';
            DataClassification = CustomerContent;
            TableRelation = "Report Layout List"."Application ID" where("Report ID" = field("Report ID"));
        }

        field(60025; "Email Body Layout Caption"; Text[250])
        {
            Caption = 'Email Body Layout', Comment = 'ESP="Diseño del cuerpo del correo electrónico"';
            FieldClass = FlowField;
            CalcFormula = lookup("Report Layout List".Caption where("Report ID" = field("Report ID"), Name = field("Email Body Layout Name")));

            trigger OnLookup()
            var
                ReportLayoutList: Record "Report Layout List";
                ReportManagement: Codeunit ReportManagement;
                Handled: Boolean;
            begin
                ReportLayoutList.SetRange("Report ID", Rec."Report ID");
                ReportManagement.OnSelectReportLayout(ReportLayoutList, Handled);
                if not Handled then
                    exit;
                "Email Body Layout Name" := ReportLayoutList.Name;
                "Email Body Layout AppID" := ReportLayoutList."Application ID";
            end;
        }
        #endregion

        #region Report Layout
        field(60030; "Report Layout Name"; Text[250])
        {
            Caption = 'Report Layout name', Comment = 'ESP="Tipo de diseño de informe"';
            DataClassification = CustomerContent;
            TableRelation = "Report Layout List".Name where("Report ID" = field("Report ID"));

            trigger OnLookup()
            var
                ReportLayoutList: Record "Report Layout List";
                ReportManagement: Codeunit ReportManagement;
                Handled: Boolean;
            begin
                ReportLayoutList.SetRange("Report ID", Rec."Report ID");
                ReportManagement.OnSelectReportLayout(ReportLayoutList, Handled);
                if not Handled then
                    exit;
                "Report Layout Name" := ReportLayoutList.Name;
                "Report Layout AppID" := ReportLayoutList."Application ID";
            end;

            trigger OnValidate()
            var
                ReportLayoutList: Record "Report Layout List";
            begin
                if "Report Layout Name" <> '' then begin
                    "Use for Email Attachment" := true;
                    ReportLayoutList.SetRange(Name, "Report Layout Name");
                    ReportLayoutList.SetRange("Report ID", Rec."Report ID");
                    if not IsNullGuid("Report Layout AppID") then
                        ReportLayoutList.SetRange("Application ID", "Report Layout AppID");
                    if not ReportLayoutList.FindFirst() then begin
                        ReportLayoutList.SetRange("Application ID");
                        ReportLayoutList.FindFirst();
                    end;
                    if IsNullGuid("Report Layout AppID") then
                        Rec."Report Layout AppID" := ReportLayoutList."Application ID";
                end;
            end;
        }

        field(60031; "Report Layout AppID"; Guid)
        {
            Caption = 'Report Layout App ID', Comment = 'ESP="Id. de aplicación de diseño de informe"';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(60032; "Report Layout Caption"; Text[250])
        {
            Caption = 'Report Layout', Comment = 'ESP="Diseño de informe"';
            FieldClass = FlowField;
            CalcFormula = lookup("Report Layout List".Caption where("Report ID" = field("Report ID"), Name = field("Report Layout Name")));

            trigger OnLookup()
            var
                ReportLayoutList: Record "Report Layout List";
                ReportManagement: Codeunit ReportManagement;
                Handled: Boolean;
            begin
                ReportLayoutList.SetRange("Report ID", Rec."Report ID");
                ReportManagement.OnSelectReportLayout(ReportLayoutList, Handled);
                if not Handled then
                    exit;
                "Report Layout Name" := ReportLayoutList.Name;
                "Report Layout AppID" := ReportLayoutList."Application ID";
                if "Report Layout Name" <> '' then
                    "Use for Email Attachment" := true;
            end;
        }

        #endregion
    }

    keys
    {
        key(FK01; "Use for Email Body") { }
        key(FK02; "Use for Email Subject") { }
    }

    procedure DrillDownToSelectLayout(var SelectedLayoutName: Text[250]; var SelectedLayoutAppID: Guid)
    var
        ReportLayoutListSelection: Record "Report Layout List";
        ReportManagementCodeunit: Codeunit ReportManagement;
        IsReportLayoutSelected: Boolean;
    begin
        ReportLayoutListSelection.SetRange("Report ID", Rec."Report ID");
        ReportManagementCodeunit.OnSelectReportLayout(ReportLayoutListSelection, IsReportLayoutSelected);
        if IsReportLayoutSelected then begin
            SelectedLayoutName := ReportLayoutListSelection."Name";
            SelectedLayoutAppID := ReportLayoutListSelection."Application ID";
        end;
    end;
}