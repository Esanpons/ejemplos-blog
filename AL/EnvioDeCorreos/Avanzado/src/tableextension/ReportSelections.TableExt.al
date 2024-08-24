namespace SendMail.Base;
using Microsoft.Foundation.Reporting;
using System.EMail;
using System.Globalization;

tableextension 60046 "Report Selections" extends "Report Selections"
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
    }

    keys
    {
        key(FK01; "Use for Email Body") { }
        key(FK02; "Use for Email Subject") { }
    }
}