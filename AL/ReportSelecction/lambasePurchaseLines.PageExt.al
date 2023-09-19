pageextension 54007 "Customer Card" extends "Customer Card"
{
    actions
    {
        addlast(Processing)
        {
            action("Send Claim")
            {
                ToolTip = 'Send Claim', Comment = 'ESP="Enviar reclamación"';
                Caption = 'Send Claim', Comment = 'ESP="Enviar reclamación"';
                Image = OrderList;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ReportSelections: Record "Report Selections";
                    ReportDistributionManagement: Codeunit "Report Distribution Management";
                    ReportUsage: Integer;
                    DocTxt: Text[150];
                begin
                    ReportUsage := ReportSelections.Usage::"lam_base Claim".AsInteger();

                    Clear(ReportDistributionManagement);
                    DocTxt := ReportDistributionManagement.GetFullDocumentTypeText(Rec);

                    Clear(ReportSelections);
                    ReportSelections.SendEmailToCust(ReportUsage, Rec, Rec."No.", DocTxt, true, Rec."Customer No.")

                end;
            }
        }
    }



}