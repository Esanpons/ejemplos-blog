codeunit 60005 "Mgt Assign Charge Item"
{

    //funcion para Asignar proporcionalmente a todas las líneas
    procedure AssignProportionallyToAllLines(ChargeSalesLine: Record "Sales Line"; var SalesLine: Record "Sales Line"; TotalQty: Decimal; TotalAmount: Decimal)
    var
        Qty: Decimal;
        Amt: Decimal;
        AmountCharge: Decimal;
        NextLineNo: Integer;
    begin
        NextLineNo := -10000;
        AmountCharge := ChargeSalesLine."Line Amount";

        if SalesLine.FindSet() then
            repeat
                NextLineNo += 10000;
                FromOneLineToOneLine(ChargeSalesLine, SalesLine, NextLineNo);

                Qty := SalesLine.Amount / TotalAmount;
                Amt := AmountCharge / Qty;
                ModifyAssignedItemCharge(ChargeSalesLine, SalesLine."Line No.", Qty, Amt);
            until SalesLine.Next() = 0;
    end;

    //funcion para crear y asignar a una linea del documento toda su cantidad
    procedure FromOneLineToOneLine(ChargeSalesLine: Record "Sales Line"; SalesLine: Record "Sales Line"; NextLineNo: Integer)
    var
        ItemChargeAssignmentSales: Record "Item Charge Assignment (Sales)";
        ItemChargeAssgntSales: Codeunit "Item Charge Assgnt. (Sales)";
        SalesAppliestoDocumentType: enum "Sales Applies-to Document Type";
    begin
        ItemChargeAssignmentSales.Reset();
        ItemChargeAssignmentSales.SetRange("Document Type", ChargeSalesLine."Document Type");
        ItemChargeAssignmentSales.SetRange("Document No.", ChargeSalesLine."Document No.");
        ItemChargeAssignmentSales.SetRange("Document Line No.", ChargeSalesLine."Line No.");
        ItemChargeAssignmentSales.SetRange("Item Charge No.", ChargeSalesLine."No.");
        ItemChargeAssignmentSales.SetRange("Applies-to Doc. Line No.", SalesLine."Line No.");
        if ItemChargeAssignmentSales.IsEmpty() then begin
            ItemChargeAssignmentSales.Init();
            ItemChargeAssignmentSales."Document Type" := ChargeSalesLine."Document Type";
            ItemChargeAssignmentSales."Document No." := ChargeSalesLine."Document No.";
            ItemChargeAssignmentSales."Document Line No." := ChargeSalesLine."Line No.";
            ItemChargeAssignmentSales."Item Charge No." := ChargeSalesLine."No.";
            if ChargeSalesLine.Quantity <> 0 then
                ItemChargeAssignmentSales."Unit Cost" :=
                  Round(ChargeSalesLine."Line Amount" / ChargeSalesLine.Quantity, 0.01);

            case SalesLine."Document Type" of
                "Sales Document Type"::Quote:
                    SalesAppliestoDocumentType := SalesAppliestoDocumentType::Quote;
                "Sales Document Type"::Order:
                    SalesAppliestoDocumentType := SalesAppliestoDocumentType::Order;
                "Sales Document Type"::Invoice:
                    SalesAppliestoDocumentType := SalesAppliestoDocumentType::Invoice;
                "Sales Document Type"::"Blanket Order":
                    SalesAppliestoDocumentType := SalesAppliestoDocumentType::"Blanket Order";
                "Sales Document Type"::"Credit Memo":
                    SalesAppliestoDocumentType := SalesAppliestoDocumentType::"Credit Memo";
                "Sales Document Type"::"Return Order":
                    SalesAppliestoDocumentType := SalesAppliestoDocumentType::"Return Order";
            end;


            ItemChargeAssgntSales.InsertItemChargeAssignment(ItemChargeAssignmentSales, SalesAppliestoDocumentType, ChargeSalesLine."Document No.", SalesLine."Line No.", SalesLine."No.", SalesLine.Description, NextLineNo);
        end;

        ModifyAssignedItemCharge(ChargeSalesLine, SalesLine."Line No.", ChargeSalesLine.Quantity, ChargeSalesLine."Line Amount");

    end;

    //funcion para modificar las cantidades ya asignadas
    local procedure ModifyAssignedItemCharge(ChargeSalesLine: Record "Sales Line"; SalesLineLineNo: Integer; Qty: Decimal; Amount: Decimal)
    var
        ItemChargeAssignmentSales: Record "Item Charge Assignment (Sales)";
    begin
        ItemChargeAssignmentSales.Reset();
        ItemChargeAssignmentSales.SetRange("Document Type", ChargeSalesLine."Document Type");
        ItemChargeAssignmentSales.SetRange("Document No.", ChargeSalesLine."Document No.");
        ItemChargeAssignmentSales.SetRange("Document Line No.", ChargeSalesLine."Line No.");
        ItemChargeAssignmentSales.SetRange("Item Charge No.", ChargeSalesLine."No.");
        ItemChargeAssignmentSales.SetRange("Applies-to Doc. Line No.", SalesLineLineNo);

        if ItemChargeAssignmentSales.FindFirst() then begin
            if Qty <> 0 then begin
                ItemChargeAssignmentSales."Qty. to Assign" := Qty;
                ItemChargeAssignmentSales."Qty. to Handle" := Qty;
            end;
            if Amount <> 0 then begin
                ItemChargeAssignmentSales."Amount to Assign" := Amount;
                ItemChargeAssignmentSales."Amount to Handle" := Amount;
            end;
            ItemChargeAssignmentSales.Modify(true);
        end;
    end;
}