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
            field("Mail Only Option"; Rec."Mail Only Option")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
            field("Use for Email Subject"; Rec."Use for Email Subject")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
            field("Use for Email Body"; Rec."Use for Email Body")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
            field("Use for Email Attachment"; Rec."Use for Email Attachment")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
            field("Language Code"; Rec."Language Code")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
            field("ReportLayoutCaption"; Rec."Report Layout Caption")
            {
                ToolTip = 'Specifies the Name of the report layout that is used.', comment = 'ESP="Especifica el nombre del diseño del informe que se utiliza."';
                ApplicationArea = All;

                trigger OnDrillDown()
                begin
                    Rec.DrillDownToSelectLayout(Rec."Report Layout Name", Rec."Report Layout AppID");
                    CurrPage.Update(true);
                end;
            }
            field("Subject Layout Descr."; Rec."Subject Layout Descr.")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;

                trigger OnDrillDown()
                var
                    CustomReportLayout: Record "Custom Report Layout";
                begin
                    if CustomReportLayout.LookupLayoutOK(Rec."Report ID") then
                        Rec.Validate("Subject Layout Code", CustomReportLayout.Code);
                end;
            }
            field("Email Body Layout Description"; Rec."EmailBodyLayoutDescription")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;

                trigger OnDrillDown()
                var
                    CustomReportLayout: Record "Custom Report Layout";
                begin
                    if CustomReportLayout.LookupLayoutOK(Rec."Report ID") then
                        Rec.Validate("Email Body Layout Code", CustomReportLayout.Code);
                end;
            }

        }
    }
}