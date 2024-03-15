codeunit 50000 "DividirLinea"
{
    procedure AddNewLine(Rec: Record "Sales Shipment Line"; NewComment: Text[50])
    var
        SalesShipmentLine: Record "Sales Shipment Line";
        NextLineNo: Integer;
        InitialLineNo: Integer;
        NewLineNo: Integer;
    begin
        SalesShipmentLine.Reset();
        SalesShipmentLine.SetRange("Document No.", Rec."Document No.");
        SalesShipmentLine.SetFilter("Line No.", '>=%1', Rec."Line No.");
        SalesShipmentLine.FindSet();

        InitialLineNo := Rec."Line No.";

        IF SalesShipmentLine.NEXT() <> 0 THEN
            NextLineNo := SalesShipmentLine."Line No."
        ELSE
            NextLineNo := Rec."Line No." + 10000;

        NewLineNo := (Rec."Line No." + ((NextLineNo - InitialLineNo) DIV 2));

        IF (NewLineNo = 0) OR (NewLineNo = Rec."Line No.") THEN BEGIN
            SalesShipmentLine.FINDLAST();
            NewLineNo := SalesShipmentLine."Line No." + 10000;
        END;

        SalesShipmentLine.INIT();
        SalesShipmentLine."Line No." := NewLineNo;
        SalesShipmentLine."Document No." := Rec."Document No.";
        SalesShipmentLine.Type := SalesShipmentLine.Type::" ";
        SalesShipmentLine.Description := NewComment;
        SalesShipmentLine.Insert();
    end;



}