codeunit 60004 "Events"
{



    #region TABLE
    [EventSubscriber(ObjectType::Table, Database::"Sales line", OnAfterValidateEvent, Quantity, false, false)]
    local procedure T37_OnAfterValidateEvent_Quantity(var Rec: Record "Sales Line")
    var
        ibacenMgtCascadingDiscounts: Codeunit "MgtCascadingDiscounts";
    begin
        Clear(ibacenMgtCascadingDiscounts);
        ibacenMgtCascadingDiscounts.RecalculateAllLine(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales line", OnAfterValidateEvent, "Unit Price", false, false)]
    local procedure T37_OnAfterValidateEvent_UnitPrice(var Rec: Record "Sales Line")
    var
        ibacenMgtCascadingDiscounts: Codeunit "MgtCascadingDiscounts";
    begin
        Clear(ibacenMgtCascadingDiscounts);
        ibacenMgtCascadingDiscounts.RecalculateAllLine(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales line", OnAfterValidateEvent, "Line Discount %", false, false)]
    local procedure T37_OnAfterValidateEvent_LineDiscount(var Rec: Record "Sales Line")
    begin
        if Rec."Line Discount %" = 0 then begin
            Rec."Dto1" := 0;
            Rec."Dto2" := 0;
            rec."Dto3" := 0;
        end;
    end;

    #endregion


}