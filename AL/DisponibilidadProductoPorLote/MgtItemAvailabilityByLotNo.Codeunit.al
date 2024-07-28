codeunit 51010 "MgtItemAvailabilityByLotNo"
{
    procedure EjecuteProcess(var NewItem: Record Item)
    begin
        FindPeriod(NewItem);

        Item.Copy(NewItem);
        BuildLotNoList(TempAvailabilityInfoBuffer, Item."No.");

        if Item.GetFilter("Location Filter") <> '' then
            TempAvailabilityInfoBuffer.SetRange("Location Code Filter", Item.GetFilter("Location Filter"));

        if Item.GetFilter("Variant Filter") <> '' then
            TempAvailabilityInfoBuffer.SetRange("Variant Code Filter", Item.GetFilter("Variant Filter"));

        TempAvailabilityInfoBuffer.SetRange("Date Filter", 0D, Item.GetRangeMax("Date Filter"));
    end;

    local procedure FindPeriod(var FindPeriodItem: Record Item)
    var
        CalendarDate: Record Date;
        PeriodPageMgt: Codeunit PeriodPageManagement;
        PeriodType: Enum "Analysis Period Type";
    begin
        PeriodType := PeriodType::Day;

        if FindPeriodItem.GetFilter("Date Filter") <> '' then begin
            CalendarDate.SetFilter("Period Start", FindPeriodItem.GetFilter("Date Filter"));
            if not PeriodPageMgt.FindDate('+', CalendarDate, PeriodType) then
                PeriodPageMgt.FindDate('+', CalendarDate, PeriodType::Day);
            CalendarDate.SetRange("Period Start");
        end;

        PeriodPageMgt.FindDate('', CalendarDate, PeriodType);

        FindPeriodItem.SetRange("Date Filter", 0D, CalendarDate."Period End");
    end;

    local procedure BuildLotNoList(var AvailabilityInfoBuffer: Record "Availability Info. Buffer"; ItemNo: Code[20])
    var
        ItemByLotNoRes: Query "Item By Lot No. Res.";
        ItemByLotNoItemLedg: Query "Item By Lot No. Item Ledg.";
        LotDictionary: Dictionary of [Code[50], Text];
    begin
        Clear(AvailabilityInfoBuffer);
        AvailabilityInfoBuffer.DeleteAll();

        ItemByLotNoItemLedg.SetRange(Item_No, ItemNo);
        ItemByLotNoItemLedg.SetFilter(Variant_Code, Item.GetFilter("Variant Filter"));
        ItemByLotNoItemLedg.SetFilter(Location_Code, Item.GetFilter("Location Filter"));
        ItemByLotNoItemLedg.Open();
        while ItemByLotNoItemLedg.Read() do
            if ItemByLotNoItemLedg.Lot_No <> '' then
                if not LotDictionary.ContainsKey(ItemByLotNoItemLedg.Lot_No) then begin
                    LotDictionary.Add(ItemByLotNoItemLedg.Lot_No, '');
                    AvailabilityInfoBuffer.Init();
                    AvailabilityInfoBuffer."Item No." := Item."No.";
                    AvailabilityInfoBuffer."Lot No." := ItemByLotNoItemLedg.Lot_No;
                    AvailabilityInfoBuffer."Expiration Date" := ItemByLotNoItemLedg.Expiration_Date;
                    AvailabilityInfoBuffer.Insert();
                end;

        // Expected Receipt Date for positive reservation entries.
        ItemByLotNoRes.SetRange(Item_No, ItemNo);
        ItemByLotNoRes.SetFilter(Quantity__Base_, '>0');
        ItemByLotNoRes.SetFilter(Expected_Receipt_Date, Item.GetFilter("Date Filter"));
        ItemByLotNoRes.SetFilter(Variant_Code, Item.GetFilter("Variant Filter"));
        ItemByLotNoRes.SetFilter(Location_Code, Item.GetFilter("Location Filter"));
        ItemByLotNoRes.Open();
        AddReservationEntryLotNos(AvailabilityInfoBuffer, ItemByLotNoRes, LotDictionary);

        // Shipment date for negative reservation entries.
        ItemByLotNoRes.SetRange(Item_No, ItemNo);
        ItemByLotNoRes.SetFilter(Quantity__Base_, '<0');
        ItemByLotNoRes.SetFilter(Expected_Receipt_Date, '');
        ItemByLotNoRes.SetFilter(Shipment_Date, Item.GetFilter("Date Filter"));
        ItemByLotNoRes.SetFilter(Variant_Code, Item.GetFilter("Variant Filter"));
        ItemByLotNoRes.SetFilter(Location_Code, Item.GetFilter("Location Filter"));
        AddReservationEntryLotNos(AvailabilityInfoBuffer, ItemByLotNoRes, LotDictionary);
    end;

    local procedure AddReservationEntryLotNos(
        var AvailabilityInfoBuffer: Record "Availability Info. Buffer";
        var ItemByLotNoRes: Query "Item By Lot No. Res.";
        var LotDictionary: Dictionary of [Code[50], Text]
    )
    begin
        ItemByLotNoRes.Open();
        while ItemByLotNoRes.Read() do
            if ItemByLotNoRes.Lot_No <> '' then
                if not LotDictionary.ContainsKey(ItemByLotNoRes.Lot_No) then begin
                    LotDictionary.Add(ItemByLotNoRes.Lot_No, '');
                    AvailabilityInfoBuffer.Init();
                    AvailabilityInfoBuffer."Item No." := Item."No.";
                    AvailabilityInfoBuffer."Lot No." := ItemByLotNoRes.Lot_No;
                    AvailabilityInfoBuffer."Expiration Date" := ItemByLotNoRes.Expiration_Date;
                    AvailabilityInfoBuffer.Insert();
                end;
    end;

    local procedure Calculate()
    var
        IsHandled: Boolean;
    begin
        TempAvailabilityInfoBuffer.SetRange("Lot No. Filter", TempAvailabilityInfoBuffer."Lot No.");

        if not IsHandled then
            TempAvailabilityInfoBuffer.CalcFields(
                Inventory,
                "Qty. on Sales Order",
                "Qty. on Service Order",
                "Qty. on Job Order",
                "Qty. on Component Lines",
                "Qty. on Trans. Order Shipment",
                "Qty. on Asm. Component",
                "Qty. on Purch. Return",
                "Planned Order Receipt (Qty.)",
                "Purch. Req. Receipt (Qty.)",
                "Qty. on Purch. Order",
                "Qty. on Prod. Receipt",
                "Qty. on Trans. Order Receipt",
                "Qty. on Assembly Order",
                "Qty. on Sales Return"
            );

        GrossRequirement :=
            TempAvailabilityInfoBuffer."Qty. on Sales Order" +
            TempAvailabilityInfoBuffer."Qty. on Service Order" +
            TempAvailabilityInfoBuffer."Qty. on Job Order" +
            TempAvailabilityInfoBuffer."Qty. on Component Lines" +
            TempAvailabilityInfoBuffer."Qty. on Trans. Order Shipment" +
            TempAvailabilityInfoBuffer."Qty. on Asm. Component" +
            TempAvailabilityInfoBuffer."Qty. on Purch. Return";

        PlannedOrderRcpt :=
            TempAvailabilityInfoBuffer."Planned Order Receipt (Qty.)" +
            TempAvailabilityInfoBuffer."Purch. Req. Receipt (Qty.)";

        ScheduledRcpt :=
            TempAvailabilityInfoBuffer."Qty. on Prod. Receipt" +
            TempAvailabilityInfoBuffer."Qty. on Purch. Order" +
            TempAvailabilityInfoBuffer."Qty. on Trans. Order Receipt" +
            TempAvailabilityInfoBuffer."Qty. on Assembly Order" +
            TempAvailabilityInfoBuffer."Qty. on Sales Return";

        TempAvailabilityInfoBuffer."Qty. In Hand" := TempAvailabilityInfoBuffer.Inventory;
        TempAvailabilityInfoBuffer."Gross Requirement" := GrossRequirement;
        TempAvailabilityInfoBuffer."Planned Order Receipt" := PlannedOrderRcpt;
        TempAvailabilityInfoBuffer."Scheduled Receipt" := ScheduledRcpt;
        TempAvailabilityInfoBuffer."Available Inventory" := TempAvailabilityInfoBuffer.Inventory + PlannedOrderRcpt + ScheduledRcpt - GrossRequirement;

    end;

    procedure GetJson() ReturnValue: Text
    var
        JsonObject: JsonObject;
        JsonArray: JsonArray;
    begin
        Clear(ReturnValue);
        Clear(JsonArray);

        if TempAvailabilityInfoBuffer.FindSet() then
            repeat

                Calculate();

                Clear(JsonObject);
                JsonObject.Add('itemNo', Item."No.");
                JsonObject.Add('lotNo', TempAvailabilityInfoBuffer."Lot No.");
                JsonObject.Add('qtyAvailable', TempAvailabilityInfoBuffer."Available Inventory");

                JsonArray.Add(JsonObject);

            until TempAvailabilityInfoBuffer.Next() = 0;

        JsonArray.WriteTo(ReturnValue);
    end;

    procedure GetRecord(var TempGETAvailabilityInfoBuffer: Record "Availability Info. Buffer" temporary)
    begin
        TempGETAvailabilityInfoBuffer.Reset();
        TempGETAvailabilityInfoBuffer.DeleteAll();

        if TempAvailabilityInfoBuffer.FindSet() then
            repeat
                TempGETAvailabilityInfoBuffer.transferfield(TempAvailabilityInfoBuffer);
                TempGETAvailabilityInfoBuffer.Insert();
            until TempAvailabilityInfoBuffer.Next() = 0;

    end;

    var
        TempAvailabilityInfoBuffer: Record "Availability Info. Buffer" temporary;
        Item: Record Item;
        GrossRequirement: Decimal;
        PlannedOrderRcpt: Decimal;
        ScheduledRcpt: Decimal;





    //ejemplo de como se deberia de llamar a esta codeunit
    procedure Ejemplo()
    var
        OnRunItem: Record Item;
        MgtItemAvailabilityByLotNo: Codeunit "MgtItemAvailabilityByLotNo";
    begin
        OnRunItem.SetRange("No.", '1896-S');
        OnRunItem.SetFilter("Location Filter", 'PRINCIPAL');
        OnRunItem.SetFilter("Date Filter", '''..%2', Today());

        Clear(MgtItemAvailabilityByLotNo);
        MgtItemAvailabilityByLotNo.EjecuteProcess(OnRunItem);
        Message(MgtItemAvailabilityByLotNo.GetJson());
    end;
}