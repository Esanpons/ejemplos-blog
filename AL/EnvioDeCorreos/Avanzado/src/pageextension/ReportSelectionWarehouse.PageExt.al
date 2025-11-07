namespace SendMail.Base;
using Microsoft.Foundation.Reporting;
using Microsoft.Warehouse.Setup;

pageextension 60026 "ReportSelectionWarehouse" extends "Report Selection - Warehouse"
{
    // #Creado por Esteve Sanpons Carballares.
    // #https://github.com/Esanpons
    // #Se da acceso libre a modificar y utilizar este objeto libremente. Siempre y cuando se haga referencia al autor.

    layout
    {
        addlast("Control1")
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
            field("jbcUT Use for Email Body"; Rec."Use for Email Body")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
            field("jbcUT Use for Email Attachment"; Rec."Use for Email Attachment")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
            field("jbcUT Language Code"; Rec."Language Code")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }

            field("jbcUT Subject Layout Descr."; Rec."Email Subject Layout Descr.")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;

                trigger OnDrillDown()
                begin
                    Rec.LookupLayout_Subject();
                end;
            }
            field("jbcUT Email Body Layout Description"; Rec."Email Body Layout Descr.")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;

                trigger OnDrillDown()
                begin
                    Rec.LookupLayout_Body();
                end;
            }
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