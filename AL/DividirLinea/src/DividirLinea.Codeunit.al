codeunit 50000 "DividirLinea"
{
    procedure AddNewLine(Rec: Record "Sales Shipment Line"; NewComment: Text[50])
    var
        SalesShipmentLine: Record "Sales Shipment Line";
        NextLineNo: Integer;
        InitialLineNo: Integer;
    begin
        SalesShipmentLine.Reset();
        SalesShipmentLine.SetRange("Document No.", Rec."Document No.");
        SalesShipmentLine.SetFilter("Line No.", '>=%1', Rec."Line No.");
        SalesShipmentLine.FindSet();

        InitialLineNo := Rec."Line No.";

        IF SalesShipmentLine.NEXT() <> 0 THEN
            NextLineNo := SalesShipmentLine."Line No."
        ELSE
            NextLineNo := SalesShipmentLine."Line No." + 10000;

        SalesShipmentLine.INIT();
        SalesShipmentLine."Line No." := (Rec."Line No." + ((NextLineNo - InitialLineNo) DIV 2));
        SalesShipmentLine."Document No." := Rec."Document No.";
        SalesShipmentLine.Type := SalesShipmentLine.Type::" ";
        SalesShipmentLine.Description := NewComment;
        SalesShipmentLine.Insert();
    end;


}