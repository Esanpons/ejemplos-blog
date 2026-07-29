codeunit 60000 "Rebi Events"
{
    #region CODEUNITS
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnBeforeIsPurchaseApprovalsWorkflowEnabled, '', false, false)]
    local procedure C1535_OnBeforeIsPurchaseApprovalsWorkflowEnabled(var PurchaseHeader: Record "Purchase Header")
    begin
        AddApprovalGroupForPurchase(PurchaseHeader);
    end;
    #endregion

    #region FUNCIONES PRIVADAS PARA EVENTOS
    local procedure AddApprovalGroupForPurchase(var PurchaseHeader: Record "Purchase Header")
    var
        RebiApprovalGroupSetup: Record "Rebi Approval Group Setup";
    begin
        RebiApprovalGroupSetup.Reset();
        RebiApprovalGroupSetup.SetRange("User Name", UserId());
        RebiApprovalGroupSetup.FindFirst();

        RebiApprovalGroupSetup.TestField("Code Approval Group");

        PurchaseHeader."Rebi Approval Group" := RebiApprovalGroupSetup."Code Approval Group";
        PurchaseHeader.Modify();
    end;

    #endregion
}