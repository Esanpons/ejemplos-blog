namespace SendMail.Base;
using Microsoft.Foundation.Reporting;
using System.EMail;
using System.Globalization;

tableextension 60046 "Report Selections" extends "Report Selections"
{
    // #Creado por Esteve Sanpons Carballares.
    // #https://github.com/Esanpons
    // #Se da acceso libre a modificar y utilizar este objeto libremente. Siempre y cuando se haga referencia al autor.

    fields
    {
        modify("Email Body Layout Description")
        {
            Caption = 'Email Body Design', Comment = 'ESP="Diseño del cuerpo del correo electronico"';
        }

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
                LookupLayout_Attachment();
            end;
        }
        field(60002; "Email Subject Layout Code"; Code[20])
        {
            Caption = 'Email Subject Layout Code', Comment = 'ESP="Código de diseño de informe personalizado del asunto"';
            DataClassification = CustomerContent;
            TableRelation = "Custom Report Layout".Code where(Code = field("Email Subject Layout Code"), "Report ID" = field("Report ID"));

            trigger OnValidate()
            begin
                CalcFields(Rec."Email Subject Layout Descr.");
            end;
        }
        field(60004; "Language Code"; Code[10])
        {
            Caption = 'Language Code', Comment = 'ESP="Cód. idioma"';
            DataClassification = CustomerContent;
            TableRelation = Language;
        }
        field(60006; "Mail Only Option"; Boolean)
        {
            Caption = 'Mail Only Option', Comment = 'ESP="Opción solo para correos"';
            DataClassification = CustomerContent;
        }

        field(60007; "Email Attach. Layout Descr."; Text[250])
        {
            CalcFormula = lookup("Custom Report Layout".Description where(Code = field("Email Subject Layout Code")));
            Caption = 'Email Attachments Design', Comment = 'ESP="Diseño del adjunto del correo electronico"';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                LookupLayout_Attachment();
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
        if CustomReportLayout.LookupLayoutOK(Rec."Report ID") then
            Rec.Validate("Email Subject Layout Code", CustomReportLayout.Code);
    end;

    procedure LookupLayout_Attachment()
    var
        CustomReportLayout: Record "Custom Report Layout";
    begin
        if CustomReportLayout.LookupLayoutOK("Report ID") then
            Rec.Validate("Custom Report Layout Code", CustomReportLayout.Code);
    end;
}