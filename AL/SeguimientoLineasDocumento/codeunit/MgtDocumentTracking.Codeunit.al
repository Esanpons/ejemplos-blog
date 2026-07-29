codeunit 50100 "Mgt. Document Tracking"
{
    [EventSubscriber(ObjectType::Page, Page::"Document Line Tracking", OnAfterFindRecordsRelatedToSalesOrder, '', false, false)]
    local procedure P6560_OnAfterFindRecordsRelatedToSalesOrder(DocNo: Code[20]; DocLineNo: Integer; var TempDocumentEntry: Record "Document Entry" temporary)
    begin
        FindWarehouseShipmentLineBySalesOrder(DocNo, DocLineNo, TempDocumentEntry, true);
        FindWarehouseActivityLineBySalesOrder(DocNo, DocLineNo, TempDocumentEntry, true);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Line Tracking", OnAfterActionEvent, Show, false, false)]
    local procedure P6560_OnAfterActionEvent_Show(var Rec: Record "Document Entry" temporary)
    begin
        ShowDocument(Rec);

    end;

    #region Funciones de mostrar documento
    local procedure ShowDocument(var Rec: Record "Document Entry" temporary)
    begin
        case Rec."Table ID" of
            Database::"Warehouse Shipment Line":
                begin
                    FindWarehouseShipmentLineBySalesOrder(Rec."Document No.", Rec."Document Line No.", Rec, false);
                    PAGE.RunModal(PAGE::"Whse. Shipment Lines", WarehouseShipmentLine);
                end;
            Database::"Warehouse Activity Line":
                begin
                    FindWarehouseActivityLineBySalesOrder(Rec."Document No.", Rec."Document Line No.", Rec, false);
                    PAGE.RunModal(PAGE::"Warehouse Activity Lines", WarehouseActivityLine);
                end;
        end;


    end;
    #endregion

    #region Funciones de Buscar
    local procedure FindWarehouseShipmentLineBySalesOrder(DocNo: Code[20]; DocLineNo: Integer; var TempDocumentEntry: Record "Document Entry" temporary; IsInsert: Boolean)
    begin
        //se busca las líneas de envio almacen
        if WarehouseShipmentLine.ReadPermission() then begin
            WarehouseShipmentLine.Reset();
            WarehouseShipmentLine.SetRange("Source Type", Database::"Sales Line");
            WarehouseShipmentLine.SetRange("Source Subtype", WarehouseShipmentLine."Source Subtype"::"1");
            WarehouseShipmentLine.SetRange("Source No.", DocNo);
            if DocLineNo <> 0 then
                WarehouseShipmentLine.SetRange("Source Line No.", DocLineNo);

            if IsInsert then
                InsertIntoDocEntry(TempDocumentEntry,
                    DATABASE::"Warehouse Shipment Line", Enum::"Document Entry Document Type"::Order,
                    DocNo, DocLineNo,
                    WarehouseShippingLineLbl, WarehouseShipmentLine.Count);
        end;
    end;

    local procedure FindWarehouseActivityLineBySalesOrder(DocNo: Code[20]; DocLineNo: Integer; var TempDocumentEntry: Record "Document Entry" temporary; IsInsert: Boolean)
    begin
        //se busca las líneas de envio almacen
        if WarehouseShipmentLine.ReadPermission() then begin
            WarehouseActivityLine.Reset();
            WarehouseActivityLine.SetRange("Source Type", Database::"Sales Line");
            WarehouseActivityLine.SetRange("Source Subtype", WarehouseShipmentLine."Source Subtype"::"1");
            WarehouseActivityLine.SetRange("Source No.", DocNo);
            if DocLineNo <> 0 then
                WarehouseActivityLine.SetRange("Source Line No.", DocLineNo);

            if IsInsert then
                InsertIntoDocEntry(TempDocumentEntry,
                    DATABASE::"Warehouse Activity Line", Enum::"Document Entry Document Type"::Order,
                    DocNo, DocLineNo,
                    PickingLineLbl, WarehouseActivityLine.Count);
        end;
    end;

    local procedure InsertIntoDocEntry(var TempDocumentEntry: Record "Document Entry" temporary; DocTableID: Integer; DocType2: Enum "Document Entry Document Type"; DocNo: Code[20]; DocLineNo: Integer; DocTableName: Text; DocNoOfRecords: Integer)
    begin
        if DocNoOfRecords = 0 then
            exit;

        TempDocumentEntry.Init();
        TempDocumentEntry."Entry No." := TempDocumentEntry."Entry No." + 1;
        TempDocumentEntry."Table ID" := DocTableID;
        TempDocumentEntry."Document Type" := DocType2;
        TempDocumentEntry."Table Name" := CopyStr(DocTableName, 1, MaxStrLen(TempDocumentEntry."Table Name"));
        TempDocumentEntry."No. of Records" := DocNoOfRecords;
        TempDocumentEntry."Document No." := DocNo;
        TempDocumentEntry."Document Line No." := DocLineNo;
        TempDocumentEntry.Insert();
    end;
    #endregion

    procedure OpenDocumentLineTracking(SourceType: Integer; SourceNo: Code[20]; SourceLine: Integer)
    var
        SalesLine: Record "Sales Line";
        DocumentLineTrackingPage: Page "Document Line Tracking";
    begin
        if SourceType <> Database::"Sales Line" then
            exit;

        if not SalesLine.Get(SalesLine."Document Type"::Order, SourceNo, SourceLine) then
            exit;

        Clear(DocumentLineTrackingPage);
        DocumentLineTrackingPage.SetSourceDoc(
            "Document Line Source Type"::"Sales Order", SalesLine."Document No.", SalesLine."Line No.", SalesLine."Blanket Order No.", SalesLine."Blanket Order Line No.", '', 0);
        DocumentLineTrackingPage.RunModal();
    end;

    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        WarehouseActivityLine: Record "Warehouse Activity Line";
        WarehouseShippingLineLbl: Label 'Warehouse Shipping Line', Comment = 'ESP="Línea envío almacén"';
        PickingLineLbl: Label 'Picking Line', Comment = 'ESP="Línea picking"';

}