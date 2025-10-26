codeunit 78000 "Events"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Email", OnBeforeSendEmail, '', false, false)]
    local procedure C8901_BeforeSendEmail(var EmailMessage: Codeunit "Email Message")
    begin
        EmailMessage.SetRecipients(Enum::"Email Recipient Type"::"To", 'esteve@aesva.es');
        EmailMessage.SetRecipients(Enum::"Email Recipient Type"::Cc, '');
        EmailMessage.SetRecipients(Enum::"Email Recipient Type"::BCC, '');
    end;


}