codeunit 60004 "CrearLineasFacturaDesdeAlbaranes"
{

    procedure Ejecute(SalesShipment: Text; CustomerNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        SalesPost: Codeunit "Sales-Post";
    begin
        CreateHeaderInvoice(CustomerNo, SalesHeader);

        SalesShipmentLine.Reset();
        SalesShipmentLine.SetFilter("Document No.", SalesShipment);
        SalesShipmentLine.SetFilter("Qty. Shipped Not Invoiced", '<>0');
        if SalesShipmentLine.FindSet() then
            repeat
                CreateInvoiceLineFromShipment(SalesShipmentLine, SalesHeader);
            until SalesShipmentLine.Next() < 1;

        Clear(SalesPost);
        SalesPost.Run(SalesHeader);
    end;

    procedure CreateHeaderInvoice(CustomerNo: Code[20]; var SalesHeader: Record "Sales Header")
    begin
        SalesHeader.Init();
        SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Invoice);
        SalesHeader."No." := '';
        SalesHeader.Insert(true);

        SalesHeader.Invoice := true;
        SalesHeader.Validate("Sell-to Customer No.", CustomerNo);
        SalesHeader.Modify();
    end;

    procedure CreateInvoiceLineFromShipment(var SalesShipmentLine: Record "Sales Shipment Line"; SalesHeader: Record "Sales Header")
    var
        SalesGetShipment: Codeunit "Sales-Get Shipment";
    begin
        Clear(SalesGetShipment);
        SalesGetShipment.SetSalesHeader(SalesHeader);
        SalesGetShipment.CreateInvLines(SalesShipmentLine);
    end;
}
