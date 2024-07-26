codeunit 60004 "Mgt. Pass Data From Tracking"
{
    //codeunit para traspasar datos des de el traking hasta los movimientos de producto, la información del lote o de la serie
    //#T337 #T336 #Tracking

    #region CODEUNITS  

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnCodeOnBeforeCheckItemTracking, '', false, false)]
    local procedure C22_OnCodeOnBeforeCheckItemTracking(var ItemJnlLine: Record "Item Journal Line"; DisableItemTracking: Boolean; var IsHandled: Boolean; var TempTrackingSpecification: Record "Tracking Specification"; var ItemTrackingSetup: Record "Item Tracking Setup")
    begin
        //funcion para traspasar los campos a item journal line para despues traspasarlos a item ledger entry
        ItemJnlLine."Serial No. 2" := TempTrackingSpecification."Serial No. 2";
        ItemJnlLine."Serial No. 3" := TempTrackingSpecification."Serial No. 3";
        ItemJnlLine."Serial No. 4" := TempTrackingSpecification."Serial No. 4";
        ItemJnlLine."Lot No. 2" := TempTrackingSpecification."Lot No. 2";
        ItemJnlLine."Lot No. 3" := TempTrackingSpecification."Lot No. 3";
        ItemJnlLine."Lot No. 4" := TempTrackingSpecification."Lot No. 4";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnBeforeInsertItemLedgEntry, '', false, false)]
    local procedure C22_OnBeforeInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; TransferItem: Boolean; OldItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLineOrigin: Record "Item Journal Line")
    begin
        //funcion para traspasar los campos a la item ledger entry
        ItemLedgerEntry."Serial No. 2" := ItemJournalLine."Serial No. 2";
        ItemLedgerEntry."Serial No. 3" := ItemJournalLine."Serial No. 3";
        ItemLedgerEntry."Serial No. 4" := ItemJournalLine."Serial No. 4";
        ItemLedgerEntry."Lot No. 2" := ItemJournalLine."Lot No. 2";
        ItemLedgerEntry."Lot No. 3" := ItemJournalLine."Lot No. 3";
        ItemLedgerEntry."Lot No. 4" := ItemJournalLine."Lot No. 4";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", OnAfterCreateSNInformation, '', false, false)]
    local procedure C6500_OnAfterCreateSNInformation(var SerialNoInfo: Record "Serial No. Information"; TrackingSpecification: Record "Tracking Specification")
    begin
        //funcion para traspasar des de el traking hacia la informacion de la serie
        SerialNoInfo."Serial No. 2" := TrackingSpecification."Serial No. 2";
        SerialNoInfo."Serial No. 3" := TrackingSpecification."Serial No. 3";
        SerialNoInfo."Serial No. 4" := TrackingSpecification."Serial No. 4";
        SerialNoInfo.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", OnAfterCreateLotInformation, '', false, false)]
    local procedure C6500_OnAfterCreateLotInformation(var LotNoInfo: Record "Lot No. Information"; var TrackingSpecification: Record "Tracking Specification")
    begin
        //funcion para traspasar des de el traking hacia la informacion del lote
        LotNoInfo."Lot No. 2" := TrackingSpecification."Lot No. 2";
        LotNoInfo."Lot No. 3" := TrackingSpecification."Lot No. 3";
        LotNoInfo."Lot No. 4" := TrackingSpecification."Lot No. 4";
        LotNoInfo.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", OnAfterCreateReservEntryFor, '', false, false)]
    local procedure C99000830_OnAfterCreateReservEntryFor(var ReservationEntry: Record "Reservation Entry"; Sign: Integer; ForType: Option; ForSubtype: Integer; ForID: Code[20]; ForBatchName: Code[10]; ForProdOrderLine: Integer; ForRefNo: Integer; ForQtyPerUOM: Decimal; Quantity: Decimal; QuantityBase: Decimal; ForReservEntry: Record "Reservation Entry")
    begin
        //se le asigna a la variable de reserva de insercion los datos de los campos
        ReservationEntry."Serial No. 2" := ForReservEntry."Serial No. 2";
        ReservationEntry."Serial No. 3" := ForReservEntry."Serial No. 3";
        ReservationEntry."Serial No. 4" := ForReservEntry."Serial No. 4";
        ReservationEntry."Lot No. 2" := ForReservEntry."Lot No. 2";
        ReservationEntry."Lot No. 3" := ForReservEntry."Lot No. 3";
        ReservationEntry."Lot No. 4" := ForReservEntry."Lot No. 4";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", OnCreateEntryOnBeforeSurplusCondition, '', false, false)]
    local procedure C99000830_OnCreateEntryOnBeforeSurplusCondition(var ReservEntry: Record "Reservation Entry"; QtyToHandleAndInvoiceIsSet: Boolean; var InsertReservEntry: Record "Reservation Entry")
    begin
        //se añade los campos a la reserva des de la variable de inserción
        ReservEntry."Serial No. 2" := InsertReservEntry."Serial No. 2";
        ReservEntry."Serial No. 3" := InsertReservEntry."Serial No. 3";
        ReservEntry."Serial No. 4" := InsertReservEntry."Serial No. 4";
        ReservEntry."Lot No. 2" := InsertReservEntry."Lot No. 2";
        ReservEntry."Lot No. 3" := InsertReservEntry."Lot No. 3";
        ReservEntry."Lot No. 4" := InsertReservEntry."Lot No. 4";
    end;

    #endregion

    #region PAGE

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", OnAfterEntriesAreIdentical, '', false, false)]
    local procedure P6510_OnAfterEntriesAreIdentical(ReservEntry1: Record "Reservation Entry"; ReservEntry2: Record "Reservation Entry"; var IdenticalArray: array[2] of Boolean)
    begin
        //se verifica si son iguales y a mas se deja de nuevo la descripcion igual que deberia de estar
        if IdenticalArray[1] then begin
            IdenticalArray[1] :=
                       (ReservEntry1."Serial No. 2" = ReservEntry2."Serial No. 2") and
                       (ReservEntry1."Serial No. 3" = ReservEntry2."Serial No. 3") and
                       (ReservEntry1."Serial No. 3" = ReservEntry2."Serial No. 3") and
                       (ReservEntry1."Lot No. 2" = ReservEntry2."Lot No. 2") and
                       (ReservEntry1."Lot No. 3" = ReservEntry2."Lot No. 3") and
                       (ReservEntry1."Lot No. 3" = ReservEntry2."Lot No. 3");

            ReservEntry2.Description := ReservEntry1.Description;

        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", OnAfterMoveFields, '', false, false)]
    local procedure P6510_OnAfterMoveFields(var TrkgSpec: Record "Tracking Specification"; var ReservEntry: Record "Reservation Entry")
    begin
        //traspasamos los campos a la reserva cuando se elimina la linea parcialmente
        ReservEntry."Serial No. 2" := TrkgSpec."Serial No. 2";
        ReservEntry."Serial No. 3" := TrkgSpec."Serial No. 3";
        ReservEntry."Serial No. 4" := TrkgSpec."Serial No. 4";
        ReservEntry."Lot No. 2" := TrkgSpec."Lot No. 2";
        ReservEntry."Lot No. 3" := TrkgSpec."Lot No. 3";
        ReservEntry."Lot No. 4" := TrkgSpec."Lot No. 4";
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", OnRegisterChangeOnChangeTypeModifyOnBeforeCheckEntriesAreIdentical, '', false, false)]
    local procedure P6510_OnRegisterChangeOnChangeTypeModifyOnBeforeCheckEntriesAreIdentical(var ReservEntry1: Record "Reservation Entry"; var ReservEntry2: Record "Reservation Entry"; var OldTrackingSpecification: Record "Tracking Specification"; var NewTrackingSpecification: Record "Tracking Specification"; var IdenticalArray: array[2] of Boolean)
    var
        Identical: Boolean;
    begin
        //identificamos que los campos sean diferentes y si es asi lo que realizamos es un cambio de la desccripcion para que inserte los cambios.
        Identical :=
              (OldTrackingSpecification."Serial No. 2" <> NewTrackingSpecification."Serial No. 2") or
              (OldTrackingSpecification."Serial No. 3" <> NewTrackingSpecification."Serial No. 3") or
              (OldTrackingSpecification."Serial No. 3" <> NewTrackingSpecification."Serial No. 3") or
              (OldTrackingSpecification."Lot No. 2" <> NewTrackingSpecification."Lot No. 2") or
              (OldTrackingSpecification."Lot No. 3" <> NewTrackingSpecification."Lot No. 3") or
              (OldTrackingSpecification."Lot No. 3" <> NewTrackingSpecification."Lot No. 3");

        if Identical then
            ReservEntry2.Description := Format(CurrentDateTime);
    end;

    #endregion

    #region TABLE

    [EventSubscriber(ObjectType::Table, Database::"Tracking Specification", OnBeforeTestApplyToItemLedgEntry, '', false, false)]
    local procedure t336_OnBeforeTestApplyToItemLedgEntry(var TrackingSpecification: Record "Tracking Specification"; ItemLedgerEntry: Record "Item Ledger Entry"; var IsHandled: Boolean)
    begin
        //Traspasamos la información del movimiento hacia el seguimiento.
        TrackingSpecification."Serial No. 2" := ItemLedgerEntry."Serial No. 2";
        TrackingSpecification."Serial No. 3" := ItemLedgerEntry."Serial No. 3";
        TrackingSpecification."Serial No. 4" := ItemLedgerEntry."Serial No. 4";
        TrackingSpecification."Lot No. 2" := ItemLedgerEntry."Lot No. 2";
        TrackingSpecification."Lot No. 3" := ItemLedgerEntry."Lot No. 3";
        TrackingSpecification."Lot No. 4" := ItemLedgerEntry."Lot No. 4";
    end;


    [EventSubscriber(ObjectType::Table, Database::"Reservation Entry", OnAfterCopyTrackingFromTrackingSpec, '', false, false)]
    local procedure T337_OnAfterCopyTrackingFromTrackingSpec(TrackingSpecification: Record "Tracking Specification"; var ReservationEntry: Record "Reservation Entry")
    begin
        //copiamos los campos al hacer la copia des del tracking hacia la reserva
        ReservationEntry."Serial No. 2" := TrackingSpecification."Serial No. 2";
        ReservationEntry."Serial No. 3" := TrackingSpecification."Serial No. 3";
        ReservationEntry."Serial No. 4" := TrackingSpecification."Serial No. 4";
        ReservationEntry."Lot No. 2" := TrackingSpecification."Lot No. 2";
        ReservationEntry."Lot No. 3" := TrackingSpecification."Lot No. 3";
        ReservationEntry."Lot No. 4" := TrackingSpecification."Lot No. 4";
    end;

    #endregion
}