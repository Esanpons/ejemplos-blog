namespace SendMail.Base;
using System.Email;
using System.Utilities;
using Microsoft.Warehouse.Setup;
using Microsoft.Foundation.Reporting;
using System.Globalization;
using Microsoft.Service.History;
using Microsoft.Projects.Project.Job;
using Microsoft.Service.Document;
using Microsoft.Sales.Document;
using Microsoft.Sales.History;
using System.Environment.Configuration;
using System.Reflection;

codeunit 60007 "Mgt. Send Mail"
{
    #region FUNCIONES SEND
    procedure SendSimpleEmail(RecVariant: Variant; NewToRecipients: Text; IsSendDirectly: Boolean; Body: Text; Subject: Text) EmailAction: Enum "Email Action";
    begin
        Clear(EmailMessage);

        SetToRecipients(NewToRecipients);
        CreateMail(RecVariant, IsSendDirectly);
        SetBody(Body);
        SetSubject(Subject);
        EmailAction := SendEmail();
    end;

    procedure SendEmailReportSelection(RecVariant: Variant; NewReportSelectionUsage: Enum "Report Selection Usage"; IsSendDirectly: Boolean; FileName: Text[250]) EmailAction: Enum "Email Action";
    begin
        //REPORT SELECCTION
        Clear(EmailMessage);

        CreateMail(RecVariant, IsSendDirectly);
        SetReportSelectionUsage(NewReportSelectionUsage);
        AddSubjectReportSelections();
        AddBodyReportSelections();
        if SendSeparateAttachments then
            AddSeparateAttachments(RecVariant, OptionAttachment::ReportSelections)
        else
            AddAttachmentReportSelections(FileName);

        EmailAction := SendEmail();
    end;

    procedure SendEmailReportSelection(RecVariant: Variant; NewReportSelectionUsage: Enum "Report Selection Usage"; IsSendDirectly: Boolean; FileName: Text[250]; NewLanguageCode: Code[10]) EmailAction: Enum "Email Action";
    begin
        //REPORT SELECCTION
        SetLanguage(LanguageCode);
        EmailAction := SendEmailReportSelection(RecVariant, NewReportSelectionUsage, IsSendDirectly, FileName);
    end;

    procedure SendEmailReportSelectionWarehouse(RecVariant: Variant; NewSelectionWarehouseUsage: Enum "Report Selection Warehouse Usage"; IsSendDirectly: Boolean; FileName: Text[250]) EmailAction: Enum "Email Action";
    begin
        //REPORT SELECTION WAREHOUSE
        Clear(EmailMessage);

        CreateMail(RecVariant, IsSendDirectly);
        SetReportSelectionWarehouseUsage(NewSelectionWarehouseUsage);
        AddSubjectReportSelectionsWarehouse();
        AddBodyReportSelectionWarehouse();
        if SendSeparateAttachments then
            AddSeparateAttachments(RecVariant, OptionAttachment::ReportSelectionWarehouse)
        else
            AddAttachmentReportSelectionWarehouse(FileName);

        EmailAction := SendEmail();
    end;

    procedure SendEmailReportSelectionWarehouse(RecVariant: Variant; NewSelectionWarehouseUsage: Enum "Report Selection Warehouse Usage"; IsSendDirectly: Boolean; FileName: Text[250]; NewLanguageCode: Code[10]) EmailAction: Enum "Email Action";
    begin
        //REPORT SELECTION WAREHOUSE
        SetLanguage(LanguageCode);
        EmailAction := SendEmailReportSelectionWarehouse(RecVariant, NewSelectionWarehouseUsage, IsSendDirectly, FileName);
    end;

    procedure SendEmail() EmailAction: Enum "Email Action";
    var
        IsSend: Boolean;
    begin
        if RecipientsCC <> '' then
            AddRecipientsCC(RecipientsCC);

        if ToRecipients <> '' then
            AddRecipients(ToRecipients);

        if SendDirectly then begin
            IsSend := Email.Send(EmailMessage);

            EmailAction := EmailAction::Discarded;
            if IsSend then
                EmailAction := EmailAction::Sent;
        end else
            EmailAction := Email.OpenInEditorModally(EmailMessage);

    end;

    #endregion

    #region FUNCIONES CREATE
    procedure CreateMail(RecVariant: Variant; IsSendDirectly: Boolean)
    begin
        if not IsModifyGetTable then begin
            Clear(RecordRef);
            RecordRef.GetTable(RecVariant);
        end;

        CreateMail(IsSendDirectly);
    end;

    procedure CreateMail(IsSendDirectly: Boolean)
    begin
        SendDirectly := IsSendDirectly;

        //crear el correo base
        EmailMessage.Create(ToRecipients, SubjectTxt, BodyText, true);
    end;

    procedure CreateFileName() ReturnValue: Text[250]
    begin
        //funcion para extraer nombre del fichero estandar
        ReturnValue := CopyStr(CreateTextFromRecord() + ' ' + GetDocumentNo(RecordRef), 1, 250);
    end;

    procedure CreateSubject() ReturnValue: Text[250]
    begin
        //funcion para crear asunto estandar
        ReturnValue := CreateTextFromRecord();
    end;

    #endregion

    #region FUNCIONES ADD REPORT SELECCTION
    procedure AddSubjectReportSelections() ReturnValue: Text;
    var
        ReportSelections: Record "Report Selections";
        AuxSubjectTxt: Text;
        InitPosition: Integer;
        Length: Integer;
        Text001Lbl: Label ' / ', Locked = true;
    begin
        if HideAddSubject then
            exit;

        if SubjectTxt <> '' then
            exit;

        Clear(AuxSubjectTxt);
        Clear(ReportLayoutSelection);

        ReportSelections.Reset();
        ReportSelections.SetRange(Usage, ReportSelectionUsage);
        ReportSelections.SetRange("Use for Email Subject", true);

        if LanguageCode <> '' then begin
            ReportSelections.SetRange("Language Code", LanguageCode);

            if ReportSelections.IsEmpty() then
                ReportSelections.SetRange("Language Code");
        end;

        if ReportSelections.FindFirst() then begin
            Clear(TempBlob);
            Clear(OutStream);
            Clear(InStream);

            ChangeGlobalLanguaje(LanguageCode);

            if ReportSelections."Subject Layout Code" <> '' then
                ReportLayoutSelection.SetTempLayoutSelected(ReportSelections."Subject Layout Code");

            TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
            REPORT.SaveAs(ReportSelections."Report ID", '', ReportFormat::Html, OutStream, RecordRef);
            TempBlob.CreateInStream(InStream, TextEncoding::UTF8);
            InStream.Read(AuxSubjectTxt);

            if ReportSelections."Subject Layout Code" <> '' then
                ReportLayoutSelection.SetTempLayoutSelected('');

            //buscamos la posicion incial y el tamaño del texto
            InitPosition := StrPos(AuxSubjectTxt, '<span>') + 6;
            Length := StrPos(AuxSubjectTxt, '</span>');
            Length := Length - InitPosition;

            AuxSubjectTxt := CopyStr(AuxSubjectTxt, InitPosition, Length);
        end;

        if SubjectTxt <> '' then
            SubjectTxt += Text001Lbl;

        SubjectTxt += AuxSubjectTxt;

        if SubjectTxt = '' then
            SubjectTxt := CreateSubject();

        ReturnValue := SubjectTxt;

        if LanguageCode <> '' then
            GlobalLanguage(InitLanguageID);

        EmailMessage.SetSubject(SubjectTxt);
    end;

    procedure AddBodyReportSelections() ReturnValue: Text;
    var
        ReportSelections: Record "Report Selections";
        AuxBodyText: Text;
        Text001Lbl: Label '<br> <br> <hr> <br> <br> <br> <br>', Locked = true;
    begin
        if HideAddBody then
            exit;

        if BodyText <> '' then
            exit;

        Clear(AuxBodyText);
        Clear(ReportLayoutSelection);

        ReportSelections.Reset();
        ReportSelections.SetRange(Usage, ReportSelectionUsage);
        ReportSelections.SetRange("Use for Email Body", true);

        if LanguageCode <> '' then begin
            ReportSelections.SetRange("Language Code", LanguageCode);

            if ReportSelections.IsEmpty() then
                ReportSelections.SetRange("Language Code");
        end;

        if ReportSelections.FindFirst() then begin
            Clear(TempBlob);
            Clear(OutStream);
            Clear(InStream);

            ChangeGlobalLanguaje(LanguageCode);

            if ReportSelections."Email Body Layout Code" <> '' then
                ReportLayoutSelection.SetTempLayoutSelected(ReportSelections."Email Body Layout Code");

            TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
            REPORT.SaveAs(ReportSelections."Report ID", '', ReportFormat::Html, OutStream, RecordRef);
            TempBlob.CreateInStream(InStream, TextEncoding::UTF8);
            InStream.Read(AuxBodyText);

            if ReportSelections."Email Body Layout Code" <> '' then
                ReportLayoutSelection.SetTempLayoutSelected('');
        end;

        if BodyText <> '' then
            BodyText += Text001Lbl;

        BodyText += AuxBodyText;

        ReturnValue := BodyText;

        if LanguageCode <> '' then
            GlobalLanguage(InitLanguageID);

        EmailMessage.SetBody(BodyText);
    end;

    procedure AddAttachmentReportSelections(FileName: Text[250])
    var
        ReportSelections: Record "Report Selections";
        VersionFileName: Integer;
    begin
        if HideAddAttachment then
            exit;

        VersionFileName := 0;

        if FileName = '' then
            FileName := CreateFileName();

        ChangeGlobalLanguaje(LanguageCode);

        ReportSelections.Reset();
        ReportSelections.SetRange(Usage, ReportSelectionUsage);
        ReportSelections.SetRange("Use for Email Attachment", true);
        if LanguageCode <> '' then begin
            ReportSelections.SetRange("Language Code", LanguageCode);

            if ReportSelections.IsEmpty() then
                ReportSelections.SetRange("Language Code");
        end;

        if ReportSelections.FindSet() then
            repeat
                SelectAttachmentFormat(ReportSelections."Report ID");

                Clear(TempBlob);
                Clear(OutStream);
                Clear(InStream);

                VersionFileName += 1;

                if VersionFileName > 1 then
                    FileName += '_' + Format(VersionFileName);

                FileName += '.' + format(ContentTypeAddAttachment);

                TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
                REPORT.SaveAs(ReportSelections."Report ID", '', AttachmentFormat, OutStream, RecordRef);
                TempBlob.CreateInStream(InStream, TextEncoding::UTF8);
                EmailMessage.AddAttachment(FileName, ContentTypeAddAttachment, InStream);
            until ReportSelections.Next() = 0;


        if LanguageCode <> '' then
            GlobalLanguage(InitLanguageID);
    end;
    #endregion

    #region FUNCIONES ADD REPORT SELECTION WAREHOUSE

    procedure AddSubjectReportSelectionsWarehouse() ReturnValue: Text;
    var
        ReportSelectionWarehouse: Record "Report Selection Warehouse";
        AuxSubjectTxt: Text;
        InitPosition: Integer;
        Length: Integer;
        Text001Lbl: Label ' / ', Locked = true;
    begin
        if HideAddSubject then
            exit;

        if SubjectTxt <> '' then
            exit;

        Clear(AuxSubjectTxt);
        Clear(ReportLayoutSelection);

        ReportSelectionWarehouse.Reset();
        ReportSelectionWarehouse.SetRange(Usage, ReportSelectionUsage);
        ReportSelectionWarehouse.SetRange("Use for Email Subject", true);

        if LanguageCode <> '' then begin
            ReportSelectionWarehouse.SetRange("Language Code", LanguageCode);

            if ReportSelectionWarehouse.IsEmpty() then
                ReportSelectionWarehouse.SetRange("Language Code");
        end;

        if ReportSelectionWarehouse.FindFirst() then begin
            Clear(TempBlob);
            Clear(OutStream);
            Clear(InStream);

            ChangeGlobalLanguaje(LanguageCode);

            if ReportSelectionWarehouse."Subject Layout Code" <> '' then
                ReportLayoutSelection.SetTempLayoutSelected(ReportSelectionWarehouse."Subject Layout Code");

            TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
            REPORT.SaveAs(ReportSelectionWarehouse."Report ID", '', ReportFormat::Html, OutStream, RecordRef);
            TempBlob.CreateInStream(InStream, TextEncoding::UTF8);
            InStream.Read(AuxSubjectTxt);

            if ReportSelectionWarehouse."Subject Layout Code" <> '' then
                ReportLayoutSelection.SetTempLayoutSelected('');

            //buscamos la posicion incial y el tamaño del texto
            InitPosition := StrPos(AuxSubjectTxt, '<span>') + 6;
            Length := StrPos(AuxSubjectTxt, '</span>');
            Length := Length - InitPosition;

            AuxSubjectTxt := CopyStr(AuxSubjectTxt, InitPosition, Length);
        end;

        if SubjectTxt <> '' then
            SubjectTxt += Text001Lbl;

        SubjectTxt += AuxSubjectTxt;

        if SubjectTxt = '' then
            SubjectTxt := CreateSubject();

        ReturnValue := SubjectTxt;

        if LanguageCode <> '' then
            GlobalLanguage(InitLanguageID);

        EmailMessage.SetSubject(SubjectTxt);
    end;

    procedure AddBodyReportSelectionWarehouse() ReturnValue: Text;
    var
        ReportSelectionWarehouse: Record "Report Selection Warehouse";
        AuxBodyText: Text;
        Text001Lbl: Label '<br> <br> <hr> <br> <br> <br> <br>', Locked = true;
    begin
        if HideAddBody then
            exit;

        if BodyText <> '' then
            exit;

        Clear(AuxBodyText);
        Clear(ReportLayoutSelection);

        ReportSelectionWarehouse.Reset();
        ReportSelectionWarehouse.SetRange(Usage, SelectionWarehouseUsage);

        if LanguageCode <> '' then begin
            ReportSelectionWarehouse.SetRange("Language Code", LanguageCode);

            if ReportSelectionWarehouse.IsEmpty() then
                ReportSelectionWarehouse.SetRange("Language Code");
        end;

        if ReportSelectionWarehouse.FindFirst() then begin
            Clear(TempBlob);
            Clear(OutStream);
            Clear(InStream);

            ChangeGlobalLanguaje(LanguageCode);

            if ReportSelectionWarehouse."Email Body Layout Code" <> '' then
                ReportLayoutSelection.SetTempLayoutSelected(ReportSelectionWarehouse."Email Body Layout Code");

            TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
            REPORT.SaveAs(ReportSelectionWarehouse."Report ID", '', ReportFormat::Html, OutStream, RecordRef);
            TempBlob.CreateInStream(InStream, TextEncoding::UTF8);
            InStream.Read(AuxBodyText);

            if ReportSelectionWarehouse."Email Body Layout Code" <> '' then
                ReportLayoutSelection.SetTempLayoutSelected('');

        end;

        if BodyText <> '' then
            BodyText += Text001Lbl;

        BodyText += AuxBodyText;

        ReturnValue := BodyText;

        if LanguageCode <> '' then
            GlobalLanguage(InitLanguageID);

        EmailMessage.SetBody(BodyText);
    end;

    procedure AddAttachmentReportSelectionWarehouse(FileName: Text[250])
    var
        ReportSelectionWarehouse: Record "Report Selection Warehouse";
        VersionFileName: Integer;
    begin
        if HideAddAttachment then
            exit;

        VersionFileName := 0;

        if FileName = '' then
            FileName := CreateFileName();

        ChangeGlobalLanguaje(LanguageCode);

        ReportSelectionWarehouse.Reset();
        ReportSelectionWarehouse.SetRange(Usage, SelectionWarehouseUsage);

        if LanguageCode <> '' then begin
            ReportSelectionWarehouse.SetRange("Language Code", LanguageCode);

            if ReportSelectionWarehouse.IsEmpty() then
                ReportSelectionWarehouse.SetRange("Language Code");
        end;

        if ReportSelectionWarehouse.FindSet() then
            repeat
                SelectAttachmentFormat(ReportSelectionWarehouse."Report ID");

                Clear(TempBlob);
                Clear(OutStream);
                Clear(InStream);

                VersionFileName += 1;

                if VersionFileName > 1 then
                    FileName += '_' + Format(VersionFileName);

                FileName += '.' + format(ContentTypeAddAttachment);

                TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
                REPORT.SaveAs(ReportSelectionWarehouse."Report ID", '', AttachmentFormat, OutStream, RecordRef);
                TempBlob.CreateInStream(InStream, TextEncoding::UTF8);
                EmailMessage.AddAttachment(FileName, ContentTypeAddAttachment, InStream);

            until ReportSelectionWarehouse.Next() = 0;

        if LanguageCode <> '' then
            GlobalLanguage(InitLanguageID);
    end;
    #endregion

    #region FUNCIONES ADD VARIOS
    procedure AddRecipientsCC(NewRecipientsCC: Text)
    begin
        //adjuntamos los correos en copia
        RecipientsCC := NewRecipientsCC;
        EmailMessage.AddRecipient(Enum::"Email Recipient Type"::Cc, NewRecipientsCC);
    end;

    procedure AddRecipients(NewToRecipients: Text)
    begin
        //adjuntamos los correos de envio
        ToRecipients := NewToRecipients;
        EmailMessage.AddRecipient(Enum::"Email Recipient Type"::"To", NewToRecipients);
    end;

    procedure AddAttachment(NewInStream: InStream; NewFileName: Text[250]; NewContentType: Text[250])
    begin
        EmailMessage.AddAttachment(NewFileName, NewContentType, NewInStream);
    end;
    #endregion

    #region FUNCIONES SET
    procedure SetToRecipients(NewRecipients: Text)
    begin
        ToRecipients := NewRecipients;
    end;

    procedure SetRecipientsCC(NewRecipientsCC: Text)
    begin
        RecipientsCC := NewRecipientsCC;
    end;

    procedure SetSubject(NewSubject: Text)
    begin
        SubjectTxt := NewSubject;
        EmailMessage.SetSubject(SubjectTxt);
    end;

    procedure SetBody(NewBody: Text)
    begin
        BodyText := NewBody;
        EmailMessage.SetBody(BodyText);
    end;

    procedure SetRecord(RecVariant: Variant)
    begin
        Clear(RecordRef);
        RecordRef.GetTable(RecVariant);
        IsModifyGetTable := true;
    end;

    procedure SetReportSelectionUsage(NewReportSelectionUsage: Enum "Report Selection Usage")
    begin
        ReportSelectionUsage := NewReportSelectionUsage;
    end;

    procedure SetReportSelectionWarehouseUsage(NewReportSelectionWarehouseUsage: Enum "Report Selection Warehouse Usage")
    begin
        SelectionWarehouseUsage := NewReportSelectionWarehouseUsage;
    end;

    procedure SetLanguage(NewLanguageCode: Code[10])
    begin
        LanguageCode := NewLanguageCode;
    end;

    procedure SetHideAddAttachment(NewHideAddAttachment: Boolean)
    begin
        HideAddAttachment := NewHideAddAttachment;
    end;

    procedure SetHideAddBody(NewHideAddBody: Boolean)
    begin
        HideAddBody := NewHideAddBody;
    end;

    procedure SetHideAddSubject(NewHideAddSubject: Boolean)
    begin
        HideAddSubject := NewHideAddSubject;
    end;

    procedure SetAttachmentFormat(NewAttachmentFormat: ReportFormat)
    begin
        AttachmentFormat := NewAttachmentFormat;
        IsModifyAttachmentFormat := true;
    end;

    procedure SetSendSeparateAttachments()
    begin
        SendSeparateAttachments := true;
    end;
    #endregion

    #region Eventos
    [EventSubscriber(ObjectType::Table, Database::"Report Selections", OnBeforeCheckEmailBodyUsage, '', false, false)]
    local procedure T77_OnBeforeCheckEmailBodyUsage(var IsHandled: Boolean)
    begin
        //este evento lo ponemos para omitir el error de varios checks para el cuerpo
        IsHandled := true;
    end;
    #endregion

    #region FUNCIONES LOCALES
    local procedure ChangeGlobalLanguaje(NewLanguageCode: Code[10])
    var
        Language: Record Language;
        LanguageID: Integer;
    begin
        if NewLanguageCode = '' then
            exit;

        InitLanguageID := GlobalLanguage();

        Language.Reset();
        Language.SetRange(Code, NewLanguageCode);
        Language.FindFirst();

        LanguageID := Language."Windows Language ID";
        if LanguageID = 1034 then
            LanguageID := 3082;

        GlobalLanguage(LanguageID);
    end;

    local procedure CreateTextFromRecord() ReturnValue: Text[250]
    var
        ReportDistributionManagement: Codeunit "Report Distribution Management";
    begin
        ChangeGlobalLanguaje(LanguageCode);

        Clear(ReportDistributionManagement);

        Clear(ReportDistributionManagement);
        ReturnValue := ReportDistributionManagement.GetFullDocumentTypeText(RecordRef);

        if ReturnValue = '' then
            ReturnValue := CopyStr(RecordRef.Caption(), 1, 250);

        if LanguageCode <> '' then
            GlobalLanguage(InitLanguageID);
    end;

    local procedure SelectAttachmentFormat(ReportID: Integer)
    begin
        if not IsModifyAttachmentFormat then
            AttachmentFormat := SearchReportFormat(ReportID);

        case AttachmentFormat of
            AttachmentFormat::Pdf:
                ContentTypeAddAttachment := 'pdf';
            AttachmentFormat::Excel:
                ContentTypeAddAttachment := 'xlsx';
            AttachmentFormat::Html:
                ContentTypeAddAttachment := 'html';
            AttachmentFormat::Word:
                ContentTypeAddAttachment := 'docx';
            AttachmentFormat::Xml:
                ContentTypeAddAttachment := 'xml';

        end;
    end;


    local procedure SearchReportFormat(ReportID: Integer) ReturnValue: ReportFormat
    var
        ReportLayoutList: Record "Report Layout List";
        DefaultReportLayoutList: Record "Report Layout List";
        IsDefaultLayout: Boolean;
        ValueMimeType: Text;
        Pos: Integer;
    begin
        ReturnValue := ReturnValue::Pdf;

        ReportLayoutList.Reset();
        ReportLayoutList.SetRange("Report ID", ReportID);
        if ReportLayoutList.FindSet() then
            repeat
                if DefaultReportLayoutList."Report ID" <> ReportLayoutList."Report ID" then
                    GetDefaultReportLayoutSelection(ReportLayoutList."Report ID", DefaultReportLayoutList);

                IsDefaultLayout := (DefaultReportLayoutList."Report ID" = ReportLayoutList."Report ID") and (DefaultReportLayoutList.Name = ReportLayoutList.Name) and (DefaultReportLayoutList."Application ID" = ReportLayoutList."Application ID");

                if IsDefaultLayout then begin
                    case ReportLayoutList."Layout Format" of
                        ReportLayoutList."Layout Format"::Excel:
                            ReturnValue := ReturnValue::Excel;
                        ReportLayoutList."Layout Format"::RDLC:
                            ReturnValue := ReturnValue::Pdf;
                        ReportLayoutList."Layout Format"::Word:
                            ReturnValue := ReturnValue::Word;
                        else begin
                            ValueMimeType := ReportLayoutList."MIME Type";
                            Pos := StrPos(ValueMimeType, '/');
                            ValueMimeType := CopyStr(ValueMimeType, Pos, StrLen(ValueMimeType));

                            case ValueMimeType of
                                'docx':
                                    ReturnValue := ReturnValue::Word;
                                'xlsx':
                                    ReturnValue := ReturnValue::Excel;
                            end;
                        end;
                    end;
                    exit;
                end;
            until ReportLayoutList.Next() = 0;
    end;


    local procedure GetDefaultReportLayoutSelection(ReportId: Integer; var DefaultReportLayoutList: Record "Report Layout List"): Boolean
    var
        ReportMetadata: Record "Report Metadata";
        TenantReportLayoutSelection: Record "Tenant Report Layout Selection";
        EmptyGuid: Guid;
    begin
        TenantReportLayoutSelection.Init();
        DefaultReportLayoutList.Init();

        if TenantReportLayoutSelection.Get(ReportId, CompanyName(), EmptyGuid) then begin
            // Filter Default Report Layout List by the layout name and application id and report id
            DefaultReportLayoutList.SetRange("Name", TenantReportLayoutSelection."Layout Name");
            DefaultReportLayoutList.SetRange("Application ID", TenantReportLayoutSelection."App ID");
            DefaultReportLayoutList.SetRange("Report ID", ReportId);

            // Retrive the record based on filters
            if DefaultReportLayoutList.FindFirst() then
                exit(true);
        end else
            if ReportMetadata.Get(ReportId) then begin
                DefaultReportLayoutList.SetRange("Name", ReportMetadata."DefaultLayoutName");
                DefaultReportLayoutList.SetFilter("Application ID", '<>%1', EmptyGuid);
                DefaultReportLayoutList.SetRange("Report ID", ReportId);

                if DefaultReportLayoutList.FindFirst() then
                    exit(true);
            end;

        exit(false);
    end;


    local procedure GetDocumentNo(var DocumentRecordRef: RecordRef) ReturnValue: Code[20]
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesHeader: Record "Sales Header";
        ServiceInvoiceHeader: Record "Service Invoice Header";
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
        ServiceHeader: Record "Service Header";
        Job: Record Job;
        SEPADirectDebitMandate: Record "SEPA Direct Debit Mandate";
        DocumentVariant: Variant;
    begin
        Clear(ReturnValue);

        if DocumentRecordRef.Count = 1 then
            DocumentRecordRef.FindFirst()
        else
            exit;

        DocumentVariant := DocumentRecordRef;
        case DocumentRecordRef.Number of
            DATABASE::"Sales Invoice Header":
                begin
                    SalesInvoiceHeader := DocumentVariant;
                    ReturnValue := SalesInvoiceHeader."No.";
                end;
            DATABASE::"Sales Cr.Memo Header":
                begin
                    SalesCrMemoHeader := DocumentVariant;
                    ReturnValue := SalesCrMemoHeader."No.";
                end;
            DATABASE::"Service Invoice Header":
                begin
                    ServiceInvoiceHeader := DocumentVariant;
                    ReturnValue := ServiceInvoiceHeader."No.";
                end;
            DATABASE::"Service Cr.Memo Header":
                begin
                    ServiceCrMemoHeader := DocumentVariant;
                    ReturnValue := ServiceCrMemoHeader."No.";
                end;
            DATABASE::"Service Header":
                begin
                    ServiceHeader := DocumentVariant;
                    ReturnValue := ServiceHeader."No.";
                end;
            DATABASE::"Sales Header":
                begin
                    SalesHeader := DocumentVariant;
                    ReturnValue := SalesHeader."No.";
                end;
            DATABASE::Job:
                begin
                    Job := DocumentVariant;
                    ReturnValue := Job."No.";
                end;
            Database::"SEPA Direct Debit Mandate":
                begin
                    SEPADirectDebitMandate := DocumentVariant;
                    ReturnValue := format(SEPADirectDebitMandate.ID);
                end;

        end;
    end;

    local procedure AddSeparateAttachments(RecVariant: Variant; IntOptionAttachment: Integer)
    var
        AllDocRecordRef: RecordRef;
    begin
        Clear(AllDocRecordRef);
        AllDocRecordRef.GetTable(RecVariant);


        if AllDocRecordRef.FindSet() then
            repeat
                Clear(RecordRef);
                RecordRef.Open(AllDocRecordRef.Number);
                RecordRef.SetPosition(AllDocRecordRef.GetPosition());
                RecordRef.SetRecFilter();
                case IntOptionAttachment of
                    OptionAttachment::ReportSelections:
                        AddAttachmentReportSelections('');
                    OptionAttachment::ReportSelectionWarehouse:
                        AddAttachmentReportSelectionWarehouse('');

                end;
            until AllDocRecordRef.Next() = 0;
    end;
    #endregion

    #region eventos
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Report Distribution Management", OnAfterGetFullDocumentTypeText, '', false, false)]
    local procedure C542_OnAfterGetFullDocumentTypeText(DocumentVariant: Variant; var DocumentTypeText: Text[50]; var DocumentRecordRef: RecordRef)
    var
        SEPAMandateTxt: Label 'SEPA Mandate', Comment = 'ESP="Mandato SEPA"';
    begin
        //evento para ponerle texto a los que no estan configurados
        case DocumentRecordRef.Number of
            Database::"SEPA Direct Debit Mandate":
                DocumentTypeText := SEPAMandateTxt;

        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Report Selections", OnPrintDocumentsOnAfterSelectTempReportSelectionsToPrint, '', false, false)]
    local procedure T77_OnPrintDocumentsOnAfterSelectTempReportSelectionsToPrint(RecordVariant: Variant; var TempReportSelections: Record "Report Selections" temporary; var TempNameValueBuffer: Record "Name/Value Buffer" temporary; var WithCheck: Boolean; ReportUsage: Integer; TableNo: Integer)
    begin
        //evento para que no imprima los que estan marcados
        TempReportSelections.SetRange("Mail Only Option", false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Report Selections", OnSaveAsDocumentAttachmentOnBeforeCanSaveReportAsPDF, '', false, false)]
    local procedure T77_OnSaveAsDocumentAttachmentOnBeforeCanSaveReportAsPDF(var TempAttachReportSelections: Record "Report Selections" temporary; RecRef: RecordRef; DocumentNo: Code[20]; AccountNo: Code[20]; NumberOfReportsAttached: Integer)
    begin
        //evento para que no imprima los que estan marcados
        TempAttachReportSelections.SetRange("Mail Only Option", false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Report Selections", OnSendEmailDirectlyOnBeforeSendFiles, '', false, false)]
    local procedure T77_OnSendEmailDirectlyOnBeforeSendFiles(ReportUsage: Integer; RecordVariant: Variant; var DefaultEmailAddress: Text[250]; var TempAttachReportSelections: Record "Report Selections" temporary; var CustomReportSelection: Record "Custom Report Selection")
    begin
        //evento para que no imprima los que estan marcados
        TempAttachReportSelections.SetRange("Mail Only Option", false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Report Selections", OnSendToDiskForCustOnBeforeFindReportUsage, '', false, false)]
    local procedure T77_OnSendToDiskForCustOnBeforeFindReportUsage(var ReportSelectionsOrg: Record "Report Selections"; ReportUsage: Enum "Report Selection Usage"; RecordVariant: Variant; CustNo: Code[20]; var ReportSelectionsPart: Record "Report Selections"; var IsHandled: Boolean)
    begin
        //evento para que no imprima los que estan marcados
        ReportSelectionsOrg.SetRange("Mail Only Option", false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Report Selections", OnSendToZipForCustOnBeforeFindReportUsageForCust, '', false, false)]
    local procedure T77_OnSendToZipForCustOnBeforeFindReportUsageForCust(var ReportSelectionsOrg: Record "Report Selections"; ReportUsage: Enum "Report Selection Usage"; RecordVariant: Variant; CustNo: Code[20]; var ReportSelectionsPart: Record "Report Selections"; var IsHandled: Boolean)
    begin
        //evento para que no imprima los que estan marcados
        ReportSelectionsOrg.SetRange("Mail Only Option", false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Report Selections", OnFindReportSelections, '', false, false)]
    local procedure T77_OnFindReportSelections(var FilterReportSelections: Record "Report Selections"; var IsHandled: Boolean; var ReturnReportSelections: Record "Report Selections"; AccountNo: Code[20]; TableNo: Integer)
    begin
        //evento para que no imprima los que estan marcados
        FilterReportSelections.SetRange("Mail Only Option", false);
    end;


    #endregion

    var
        ReportLayoutSelection: Record "Report Layout Selection";
        TempBlob: Codeunit "Temp Blob";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        RecordRef: RecordRef;
        OutStream: OutStream;
        InStream: InStream;
        ReportSelectionUsage: Enum "Report Selection Usage";
        SelectionWarehouseUsage: Enum "Report Selection Warehouse Usage";
        OptionAttachment: Option " ",ReportSelections,ReportSelectionWarehouse;
        RecipientsCC: Text;
        ToRecipients: Text;
        SubjectTxt: Text;
        BodyText: Text;
        ContentTypeAddAttachment: Text[250];
        SendSeparateAttachments: Boolean;
        SendDirectly: Boolean;
        HideAddAttachment: Boolean;
        HideAddBody: Boolean;
        HideAddSubject: Boolean;
        IsModifyAttachmentFormat: Boolean;
        IsModifyGetTable: Boolean;
        LanguageCode: Code[10];
        InitLanguageID: Integer;
        AttachmentFormat: ReportFormat;
}