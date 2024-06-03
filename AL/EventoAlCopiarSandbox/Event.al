codeunit 78000 "Standard Subscriber"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Environment Cleanup", 'OnClearCompanyConfig', '', false, false)]
    local procedure OnClearConfiguration(CompanyName: Text; SourceEnv: Enum "Environment Type"; DestinationEnv: Enum "Environment Type")
    var
        CompanyInformation: Record "Company Information";
        EnvironmentInformation: Codeunit "Environment Information";
        IsHandled: Boolean;
        url: Text;
        QALbl: Label 'QA';
        UATLbl: Label 'UAT';
        DEVLbl: Label 'DEV';
    begin
        if DestinationEnv = DestinationEnv::Sandbox then begin
            url := EnvironmentInformation.GetEnvironmentName();
            CompanyInformation.ChangeCompany(CompanyName);
            CompanyInformation.get();
            OnBeforeCompareNameEnvironmentInformation(url, CompanyInformation, IsHandled);
            if IsHandled then
                exit;
            CompanyInformation."System Indicator" := CompanyInformation."System Indicator"::Custom;
            IF STRPOS(url, QALbl) > 0 THEN BEGIN
                CompanyInformation."Custom System Indicator Text" := QALbl;
                CompanyInformation."System Indicator Style" := CompanyInformation."System Indicator Style"::Accent4;
            END else
                IF STRPOS(url, DEVLbl) > 0 THEN BEGIN
                    CompanyInformation."Custom System Indicator Text" := DEVLbl;
                    CompanyInformation."System Indicator Style" := CompanyInformation."System Indicator Style"::Accent2;
                END ELSE begin
                    CompanyInformation."Custom System Indicator Text" := UATLbl;
                    CompanyInformation."System Indicator Style" := CompanyInformation."System Indicator Style"::Accent6;
                end;
            OnBeforeModifyCompanyInformation(CompanyInformation);
            CompanyInformation.Modify(TRUE);
        end;
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeCompareNameEnvironmentInformation(var url: text; CompanyInformation: Record "Company Information"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeModifyCompanyInformation(CompanyInformation: Record "Company Information")
    begin
    end;
}