namespace SendMail.Base;
using Microsoft.Foundation.Reporting;
using System.Reflection;
using Microsoft.Warehouse.Setup;
using System.EMail;
using System.Globalization;

tableextension 60047 "Report Selection Warehouse" extends "Report Selection Warehouse"
{
    // #Creado por Esteve Sanpons Carballares.
    // #https://github.com/Esanpons
    // #Se da acceso libre a modificar y utilizar este objeto libremente. Siempre y cuando se haga referencia al autor.

    fields
    {
        //crs-al disable
        // le quito las funciones de la extension de CRS de Waldo para que no modifique el nombre y funcione todo correctamente, ya que depende del nombre que todo valla bien.
        field(60000; "Use for Email Subject"; Boolean)
        {
            Caption = 'Use for Email Subject', Comment = 'ESP="Uso para el asunto del correo electrónico"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not Rec."Use for Email Subject" then
                    Rec.Validate("Email Subject Layout Code", '');
            end;
        }

        field(60001; "Email Subject Layout Descr."; Text[250])
        {
            CalcFormula = lookup("Custom Report Layout".Description where(Code = field("Email Subject Layout Code")));
            Caption = 'Email Subject Design', Comment = 'ESP="Diseño del asunto del correo electronico"';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                LookupLayout_Subject();
            end;
        }
        field(60002; "Email Subject Layout Code"; Code[20])
        {
            Caption = 'Email Subject Layout Code', Comment = 'ESP="Código de diseño de informe personalizado del asunto"';
            DataClassification = CustomerContent;
            TableRelation = "Custom Report Layout".Code where(Code = field("Email Subject Layout Code"), "Report ID" = field("Report ID"));
            trigger OnValidate()
            begin
                Rec.CalcFields(Rec."Email Subject Layout Descr.");
            end;
        }

        field(60004; "Language Code"; Code[10])
        {
            Caption = 'Language Code', Comment = 'ESP="Cód. idioma"';
            TableRelation = Language;
        }
        field(60006; "Mail Only Option"; Boolean)
        {
            Caption = 'Mail Only Option', Comment = 'ESP="Opción solo para correos"';
            DataClassification = CustomerContent;
        }
        field(60007; "Email Attach. Layout Descr."; Text[250])
        {
            CalcFormula = lookup("Custom Report Layout".Description where(Code = field("Custom Report Layout Code")));
            Caption = 'Email Attachments Design', Comment = 'ESP="Diseño del adjunto del correo electronico"';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                LookupLayout_Attachment();
            end;
        }
        field(60008; "Custom Report Layout Code"; Code[20])
        {
            Caption = 'Email Attachments Design Code', Comment = 'ESP="Código del adjunto del correo electronico"';
            Editable = false;
            TableRelation = "Custom Report Layout".Code where(Code = field("Custom Report Layout Code"), "Built-In" = const(false));

            trigger OnValidate()
            begin
                rec.CalcFields(Rec."Email Attach. Layout Descr.");
            end;
        }

        field(60020; "Use for Email Attachment"; Boolean)
        {
            Caption = 'Use for Email Attachment', Comment = 'ESP="Usar para los datos adjuntos de correo electrónico"';
            DataClassification = CustomerContent;
            InitValue = true;

            trigger OnValidate()
            begin
                if not "Use for Email Attachment" then
                    Rec.Validate("Custom Report Layout Code", '');
            end;
        }
        field(60021; "Use for Email Body"; Boolean)
        {
            Caption = 'Use for Email Body', Comment = 'ESP="Usar para el cuerpo del correo electrónico"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not "Use for Email Body" then
                    Rec.Validate("Email Body Layout Code", '');
            end;
        }

        field(60030; "Email Body Layout Code"; Code[20])
        {
            Caption = 'Email Body Custom Layout Code', Comment = 'ESP="Código del diseño personalizado del correo electrónico"';
            DataClassification = CustomerContent;
            TableRelation = "Custom Report Layout".Code where(Code = field("Email Body Layout Code"), "Report ID" = field("Report ID"), "Built-In" = const(false));
            trigger OnValidate()
            begin
                if "Email Body Layout Code" <> '' then
                    Rec.Testfield("Use for Email Body", true);

                Rec.Calcfields("Email Body Layout Descr.");
            end;
        }
        field(60031; "Email Body Layout Descr."; Text[250])
        {
            CalcFormula = lookup("Custom Report Layout".Description where(Code = field("Email Body Layout Code")));
            Caption = 'Email Body Design', Comment = 'ESP="Diseño del cuerpo del correo electronico"';
            Editable = false;
            FieldClass = Flowfield;

            trigger OnLookup()
            begin
                LookupLayout_Body();
            end;
        }

        //crs-al enable
    }

    keys
    {
        key(FK01; "Use for Email Body") { }
        key(FK02; "Use for Email Subject") { }
    }

    procedure LookupLayout_Subject()
    var
        CustomReportLayout: Record "Custom Report Layout";
    begin
        if not CustomReportLayout.LookupLayoutOK(Rec."Report ID") then
            exit;

        Rec.Validate("Email Subject Layout Code", CustomReportLayout.Code);
    end;

    procedure LookupLayout_Attachment()
    var
        CustomReportLayout: Record "Custom Report Layout";
    begin
        if not CustomReportLayout.LookupLayoutOK("Report ID") then
            exit;

        Rec.Validate("Custom Report Layout Code", CustomReportLayout.Code);
    end;

    procedure LookupLayout_Body()
    var
        CustomReportLayout: Record "Custom Report Layout";
    begin
        if not CustomReportLayout.LookupLayoutOK("Report ID") then
            exit;

        Rec.Validate("Email Body Layout Code", CustomReportLayout.Code);
    end;

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