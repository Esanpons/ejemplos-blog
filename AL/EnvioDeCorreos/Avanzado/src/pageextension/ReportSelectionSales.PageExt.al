namespace SendMail.Base;
using Microsoft.Foundation.Reporting;
using Microsoft.Sales.Setup;

pageextension 60025 "ReportSelectionSales" extends "Report Selection - Sales"
{
    // #Creado por Esteve Sanpons Carballares.
    // #https://github.com/Esanpons
    // #Se da acceso libre a modificar y utilizar este objeto libremente. Siempre y cuando se haga referencia al autor.

    layout
    {
        modify("EmailLayoutCaption")
        {
            Visible = false;
        }
        modify("Email Body Layout Description")
        {
            Visible = true;
        }
        modify("ReportLayoutCaption")
        {
            Visible = false;
        }

        addafter("Use for Email Attachment")
        {
            field("jbcUT Language Code"; Rec."Language Code")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
        }
        addbefore("Use for Email Body")
        {
            field("jbcUT Mail Only Option"; Rec."Mail Only Option")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
            field("jbcUT Use for Email Subject"; Rec."Use for Email Subject")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
        }
        addbefore("Email Body Layout Description")
        {
            field("jbcUT Subject Layout Descr."; Rec."Email Subject Layout Descr.")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;

                trigger OnDrillDown()
                begin
                    Rec.LookupLayout_Subject();
                end;
            }
        }
        addafter("Email Body Layout Description")
        {
            field("jbcUT Email Attach. Layout Descr."; Rec."Email Attach. Layout Descr.")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;

                trigger OnDrillDown()
                begin
                    Rec.LookupLayout_Attachment();
                end;
            }
        }
    }
}