codeunit 50100 OpenCardPage
{

    procedure OpenRun()
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.FindFirst();

        Clear(PageManagement);
        PageManagement.PageRun(SalesHeader);
    end;

    procedure OpenRunModal()
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.FindFirst();

        Clear(PageManagement);
        PageManagement.PageRunModal(SalesHeader);
    end;

    procedure GetPageID()
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.FindFirst();

        Clear(PageManagement);
        Message(format(PageManagement.GetPageID(SalesHeader)));
    end;

    var
        SalesHeader: Record "Sales Header";
        PageManagement: Codeunit "Page Management";
}