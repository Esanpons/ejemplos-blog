codeunit 60004 "Events"
{
    #region CODEUNITS
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Price List Management", OnAfterSetAssetFilters, '', false, false)]
    local procedure C7017_OnAfterSetAssetFilters(PriceListLine: Record "Price List Line"; var DuplicatePriceListLine: Record "Price List Line")
    begin
        //Precios de venta: es para que no de problemas al comprobar lineas en la lista de precios de venta
        DuplicatePriceListLine.SetRange("Location Code", PriceListLine."Location Code");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Price Calculation Buffer Mgt.", OnAfterSetFilters, '', false, false)]
    local procedure C7800_OnAfterSetFilters(var PriceListLine: Record "Price List Line"; AmountType: Enum "Price Amount Type"; var PriceCalculationBuffer: Record "Price Calculation Buffer"; ShowAll: Boolean)
    begin
        //Precios de venta: es para que filtre por el campo nuevo del almacén
        if PriceCalculationBuffer."Location Code" = '' then
            PriceListLine.SetFilter("Location Code", '%1', '')
        else
            PriceListLine.SetFilter("Location Code", '%1|%2', PriceCalculationBuffer."Location Code", '');

    end;

    #endregion

    #region TABLES
    [EventSubscriber(ObjectType::Table, database::"Sales Line", OnAfterValidateEvent, "Location Code", false, false)]
    local procedure T37_OnAfterValidateEvent_LocationCode(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        //Precios de venta: es para que vuelva a comprobar los precios y los descuentos al validar el almacén
        Rec.UpdateUnitPriceByField(0);

    end;
    #endregion



}
