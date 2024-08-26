namespace SendMail.Base;
using Microsoft.Foundation.Reporting;
using Microsoft.Sales.Setup;

pageextension 60025 "ReportSelectionSales" extends "Report Selection - Sales"
{
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

        addafter("Use for Email Attachment")
        {
            field("Language Code"; Rec."Language Code")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
        }
        addbefore("Use for Email Body")
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
        }
        addbefore("Email Body Layout Description")
        {
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
        }
    }
}