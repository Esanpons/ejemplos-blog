codeunit 50000 Events
{
    [EventSubscriber(ObjectType::Page, Page::"Report Selection - Sales", 'OnSetUsageFilterOnAfterSetFiltersByReportUsage', '', false, false)]
    local procedure OnSetUsageFilterOnAfterSetFiltersByReportUsage(var Rec: Record "Report Selections"; ReportUsage2: Option)
    var
        ReportSelectionUsageSales: Enum "Report Selection Usage Sales";
    begin
        if ReportUsage2 = ReportSelectionUsageSales::"Claim".AsInteger() then
            Rec.SetRange(Usage, Rec.Usage::"Claim");
    end;

    [EventSubscriber(ObjectType::Page, Page::"Report Selection - Sales", 'OnInitUsageFilterOnElseCase', '', false, false)]
    local procedure OnInitUsageFilterOnElseCase(ReportUsage: Enum "Report Selection Usage"; var ReportUsage2: Enum "Report Selection Usage Sales")
    begin
        if ReportUsage = ReportUsage::"Claim" then
            ReportUsage2 := ReportUsage2::"Claim";
    end;
}