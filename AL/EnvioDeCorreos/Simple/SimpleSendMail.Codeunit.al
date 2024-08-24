namespace SendMail.Base;
using System.Email;

codeunit 60000 "Simple Send Mail"
{
    procedure SendSimpleEmail(ToRecipients: Text; IsSendDirectly: Boolean; Body: Text; Subject: Text) EmailAction: Enum "Email Action";
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        IsSend: Boolean;
    begin
        Clear(EmailMessage);
        Clear(Email);

        EmailMessage.Create(ToRecipients, Subject, Body, true);

        if IsSendDirectly then begin
            IsSend := Email.Send(EmailMessage);

            EmailAction := EmailAction::Discarded;
            if IsSend then
                EmailAction := EmailAction::Sent;
        end else
            EmailAction := Email.OpenInEditorModally(EmailMessage);
    end;
}