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
    // #Creado por Esteve Sanpons Carballares.
    // #https://github.com/Esanpons
    // #Se da acceso libre a modificar y utilizar este objeto libremente. Siempre y cuando se haga referencia al autor.

    #region FUNCIONES SEND
    procedure SendSimpleEmail(NewToRecipients: Text; IsSendDirectly: Boolean; Body: Text; Subject: Text) EmailAction: Enum "Email Action";
    begin
        Clear(this.EmailMessage);

        this.SetToRecipients(NewToRecipients);
        this.CreateMail(IsSendDirectly);
        this.SetBody(Body);
        this.SetSubject(Subject);
        EmailAction := this.SendEmail();
    end;

    procedure SendSimpleEmail(RecVariant: Variant; NewToRecipients: Text; IsSendDirectly: Boolean; Body: Text; Subject: Text) EmailAction: Enum "Email Action";
    begin
        Clear(this.EmailMessage);

        this.SetToRecipients(NewToRecipients);
        this.CreateMail(RecVariant, IsSendDirectly);
        this.SetBody(Body);
        this.SetSubject(Subject);
        EmailAction := this.SendEmail();
    end;

    procedure SendEmailReportSelection(RecVariant: Variant; NewReportSelectionUsage: Enum "Report Selection Usage"; IsSendDirectly: Boolean; FileName: Text[250]) EmailAction: Enum "Email Action";
    begin
        //REPORT SELECCTION
        Clear(this.EmailMessage);

        this.CreateMail(RecVariant, IsSendDirectly);
        this.SetReportSelectionUsage(NewReportSelectionUsage);
        this.AddSubjectReportSelections();
        this.AddBodyReportSelections();
        if this.SendSeparateAttachments then
            this.AddSeparateAttachments(RecVariant, this.OptionAttachment::ReportSelections)
        else
            this.AddAttachmentReportSelections(FileName);

        EmailAction := this.SendEmail();
    end;

    procedure SendEmailReportSelection(RecVariant: Variant; NewReportSelectionUsage: Enum "Report Selection Usage"; IsSendDirectly: Boolean; FileName: Text[250]; NewLanguageCode: Code[10]) EmailAction: Enum "Email Action";
    begin
        //REPORT SELECCTION
        this.SetLanguage(NewLanguageCode);
        EmailAction := this.SendEmailReportSelection(RecVariant, NewReportSelectionUsage, IsSendDirectly, FileName);
    end;

    procedure SendEmailReportSelectionWarehouse(RecVariant: Variant; NewSelectionWarehouseUsage: Enum "Report Selection Warehouse Usage"; IsSendDirectly: Boolean; FileName: Text[250]) EmailAction: Enum "Email Action";
    begin
        //REPORT SELECTION WAREHOUSE
        Clear(this.EmailMessage);

        this.CreateMail(RecVariant, IsSendDirectly);
        this.SetReportSelectionWarehouseUsage(NewSelectionWarehouseUsage);
        this.AddSubjectReportSelectionsWarehouse();
        this.AddBodyReportSelectionWarehouse();
        if this.SendSeparateAttachments then
            this.AddSeparateAttachments(RecVariant, this.OptionAttachment::ReportSelectionWarehouse)
        else
            this.AddAttachmentReportSelectionWarehouse(FileName);

        EmailAction := this.SendEmail();
    end;

    procedure SendEmailReportSelectionWarehouse(RecVariant: Variant; NewSelectionWarehouseUsage: Enum "Report Selection Warehouse Usage"; IsSendDirectly: Boolean; FileName: Text[250]; NewLanguageCode: Code[10]) EmailAction: Enum "Email Action";
    begin
        //REPORT SELECTION WAREHOUSE
        this.SetLanguage(NewLanguageCode);
        EmailAction := this.SendEmailReportSelectionWarehouse(RecVariant, NewSelectionWarehouseUsage, IsSendDirectly, FileName);
    end;

    procedure SendEmail() EmailAction: Enum "Email Action";
    var
        IsSend: Boolean;
    begin
        if this.RecipientsCC <> '' then
            this.AddRecipientsCC(RecipientsCC);

        if this.ToRecipients <> '' then
            this.AddRecipients(ToRecipients);

        if this.SendDirectly then begin
            IsSend := this.Email.Send(EmailMessage);

            EmailAction := EmailAction::Discarded;
            if IsSend then
                EmailAction := EmailAction::Sent;
        end else
            EmailAction := this.Email.OpenInEditorModally(EmailMessage);

    end;

    #endregion

    #region FUNCIONES CREATE
    procedure CreateMail(RecVariant: Variant; IsSendDirectly: Boolean)
    begin
        if not this.IsModifyGetTable then begin
            Clear(this.RecordRef);
            this.RecordRef.GetTable(RecVariant);
        end;

        this.CreateMail(IsSendDirectly);
    end;

    procedure CreateMail(IsSendDirectly: Boolean)
    begin
        this.SendDirectly := IsSendDirectly;

        //crear el correo base
        if this.SkipHtmlFormatting then
            this.EmailMessage.Create(this.ToRecipients, this.SubjectTxt, this.BodyText)
        else
            this.EmailMessage.Create(this.ToRecipients, this.SubjectTxt, this.BodyText, true);
    end;

    procedure CreateFileName() ReturnValue: Text[250]
    begin
        //funcion para extraer nombre del fichero estandar
        ReturnValue := CopyStr(this.CreateTextFromRecord() + ' ' + this.GetDocumentNo(this.RecordRef), 1, 250);
    end;

    procedure CreateSubject() ReturnValue: Text[250]
    begin
        //funcion para crear asunto estandar
        ReturnValue := this.CreateTextFromRecord();
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
        if this.HideAddSubject then
            exit;

        if this.SubjectTxt <> '' then
            exit;

        Clear(AuxSubjectTxt);
        Clear(this.ReportLayoutSelection);

        ReportSelections.Reset();
        ReportSelections.SetRange(Usage, this.ReportSelectionUsage);
        ReportSelections.SetRange("Use for Email Subject", true);
        ReportSelections.SetRange("Language Code", this.LanguageCode);

        if ReportSelections.IsEmpty() then
            ReportSelections.SetRange("Language Code");

        if ReportSelections.FindFirst() then begin
            Clear(this.TempBlob);
            Clear(this.OutStream);
            Clear(this.InStream);

            ChangeGlobalLanguaje(this.LanguageCode);

            if ReportSelections."Subject Layout Code" <> '' then
                this.ReportLayoutSelection.SetTempLayoutSelected(ReportSelections."Subject Layout Code");

            this.TempBlob.CreateOutStream(this.OutStream, TextEncoding::UTF8);
            REPORT.SaveAs(ReportSelections."Report ID", '', ReportFormat::Html, this.OutStream, this.RecordRef);
            this.TempBlob.CreateInStream(this.InStream, TextEncoding::UTF8);
            this.InStream.Read(AuxSubjectTxt);

            if ReportSelections."Subject Layout Code" <> '' then
                this.ReportLayoutSelection.SetTempLayoutSelected('');

            //buscamos la posicion incial y el tamaño del texto
            InitPosition := StrPos(AuxSubjectTxt, '<span>') + 6;
            Length := StrPos(AuxSubjectTxt, '</span>');
            Length := Length - InitPosition;

            AuxSubjectTxt := CopyStr(AuxSubjectTxt, InitPosition, Length);
        end;

        if this.SubjectTxt <> '' then
            this.SubjectTxt += Text001Lbl;

        this.SubjectTxt += AuxSubjectTxt;

        if this.SubjectTxt = '' then
            this.SubjectTxt := this.CreateSubject();

        ReturnValue := this.SubjectTxt;

        if this.LanguageCode <> '' then
            GlobalLanguage(this.InitLanguageID);

        this.EmailMessage.SetSubject(this.SubjectTxt);
    end;

    procedure AddBodyReportSelections() ReturnValue: Text;
    var
        ReportSelections: Record "Report Selections";
        AuxBodyText: Text;
        Text001Lbl: Label '<br> <br> <hr> <br> <br> <br> <br>', Locked = true;
    begin
        if this.HideAddBody then
            exit;

        if this.BodyText <> '' then
            exit;

        Clear(AuxBodyText);
        Clear(this.ReportLayoutSelection);

        ReportSelections.Reset();
        ReportSelections.SetRange(Usage, this.ReportSelectionUsage);
        ReportSelections.SetRange("Use for Email Body", true);
        ReportSelections.SetRange("Language Code", this.LanguageCode);

        if ReportSelections.IsEmpty() then
            ReportSelections.SetRange("Language Code");

        if ReportSelections.FindFirst() then begin
            Clear(this.TempBlob);
            Clear(this.OutStream);
            Clear(this.InStream);

            this.ChangeGlobalLanguaje(this.LanguageCode);

            if ReportSelections."Email Body Layout Code" <> '' then
                this.ReportLayoutSelection.SetTempLayoutSelected(ReportSelections."Email Body Layout Code");

            this.TempBlob.CreateOutStream(this.OutStream, TextEncoding::UTF8);
            REPORT.SaveAs(ReportSelections."Report ID", '', ReportFormat::Html, this.OutStream, this.RecordRef);
            this.TempBlob.CreateInStream(this.InStream, TextEncoding::UTF8);
            this.InStream.Read(AuxBodyText);

            if ReportSelections."Email Body Layout Code" <> '' then
                this.ReportLayoutSelection.SetTempLayoutSelected('');
        end;

        if this.BodyText <> '' then
            this.BodyText += Text001Lbl;

        this.BodyText += AuxBodyText;

        ReturnValue := this.BodyText;

        if this.LanguageCode <> '' then
            GlobalLanguage(this.InitLanguageID);

        this.EmailMessage.SetBody(this.BodyText);
    end;

    procedure AddAttachmentReportSelections(FileName: Text[250])
    var
        ReportSelections: Record "Report Selections";
        VersionFileName: Integer;
        l_FileName: Text[250];
    begin
        if this.HideAddAttachment then
            exit;

        VersionFileName := 0;

        if FileName = '' then
            FileName := this.CreateFileName();

        this.ChangeGlobalLanguaje(this.LanguageCode);

        ReportSelections.Reset();
        ReportSelections.SetRange(Usage, this.ReportSelectionUsage);
        ReportSelections.SetRange("Use for Email Attachment", true);
        ReportSelections.SetRange("Language Code", this.LanguageCode);

        if ReportSelections.IsEmpty() then
            ReportSelections.SetRange("Language Code");

        if ReportSelections.FindSet() then
            repeat
                this.SelectAttachmentFormat(ReportSelections."Report ID");

                Clear(this.TempBlob);
                Clear(this.OutStream);
                Clear(this.InStream);

                VersionFileName += 1;

                if VersionFileName > 1 then
                    FileName += '_' + Format(VersionFileName);

                l_FileName := CopyStr(FileName + '.' + format(this.ContentTypeAddAttachment), 1, 250);

                this.TempBlob.CreateOutStream(this.OutStream, TextEncoding::UTF8);
                REPORT.SaveAs(ReportSelections."Report ID", '', this.AttachmentFormat, this.OutStream, this.RecordRef);
                this.TempBlob.CreateInStream(this.InStream, TextEncoding::UTF8);
                this.EmailMessage.AddAttachment(l_FileName, this.ContentTypeAddAttachment, this.InStream);
            until ReportSelections.Next() = 0;


        if this.LanguageCode <> '' then
            GlobalLanguage(this.InitLanguageID);
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
        if this.HideAddSubject then
            exit;

        if this.SubjectTxt <> '' then
            exit;

        Clear(AuxSubjectTxt);
        Clear(this.ReportLayoutSelection);

        ReportSelectionWarehouse.Reset();
        ReportSelectionWarehouse.SetRange(Usage, this.ReportSelectionUsage);
        ReportSelectionWarehouse.SetRange("Use for Email Subject", true);
        ReportSelectionWarehouse.SetRange("Language Code", this.LanguageCode);

        if ReportSelectionWarehouse.IsEmpty() then
            ReportSelectionWarehouse.SetRange("Language Code");

        if ReportSelectionWarehouse.FindFirst() then begin
            Clear(this.TempBlob);
            Clear(this.OutStream);
            Clear(this.InStream);

            this.ChangeGlobalLanguaje(this.LanguageCode);

            if ReportSelectionWarehouse."Subject Layout Code" <> '' then
                this.ReportLayoutSelection.SetTempLayoutSelected(ReportSelectionWarehouse."Subject Layout Code");

            this.TempBlob.CreateOutStream(this.OutStream, TextEncoding::UTF8);
            REPORT.SaveAs(ReportSelectionWarehouse."Report ID", '', ReportFormat::Html, this.OutStream, this.RecordRef);
            this.TempBlob.CreateInStream(this.InStream, TextEncoding::UTF8);
            this.InStream.Read(AuxSubjectTxt);

            if ReportSelectionWarehouse."Subject Layout Code" <> '' then
                this.ReportLayoutSelection.SetTempLayoutSelected('');

            //buscamos la posicion incial y el tamaño del texto
            InitPosition := StrPos(AuxSubjectTxt, '<span>') + 6;
            Length := StrPos(AuxSubjectTxt, '</span>');
            Length := Length - InitPosition;

            AuxSubjectTxt := CopyStr(AuxSubjectTxt, InitPosition, Length);
        end;

        if this.SubjectTxt <> '' then
            this.SubjectTxt += Text001Lbl;

        this.SubjectTxt += AuxSubjectTxt;

        if this.SubjectTxt = '' then
            this.SubjectTxt := CreateSubject();

        ReturnValue := this.SubjectTxt;

        if this.LanguageCode <> '' then
            GlobalLanguage(this.InitLanguageID);

        this.EmailMessage.SetSubject(this.SubjectTxt);
    end;

    procedure AddBodyReportSelectionWarehouse() ReturnValue: Text;
    var
        ReportSelectionWarehouse: Record "Report Selection Warehouse";
        AuxBodyText: Text;
        Text001Lbl: Label '<br> <br> <hr> <br> <br> <br> <br>', Locked = true;
    begin
        if this.HideAddBody then
            exit;

        if this.BodyText <> '' then
            exit;

        Clear(AuxBodyText);
        Clear(this.ReportLayoutSelection);

        ReportSelectionWarehouse.Reset();
        ReportSelectionWarehouse.SetRange(Usage, this.SelectionWarehouseUsage);
        ReportSelectionWarehouse.SetRange("Language Code", this.LanguageCode);

        if ReportSelectionWarehouse.IsEmpty() then
            ReportSelectionWarehouse.SetRange("Language Code");

        if ReportSelectionWarehouse.FindFirst() then begin
            Clear(this.TempBlob);
            Clear(this.OutStream);
            Clear(this.InStream);

            this.ChangeGlobalLanguaje(this.LanguageCode);

            if ReportSelectionWarehouse."Email Body Layout Code" <> '' then
                this.ReportLayoutSelection.SetTempLayoutSelected(ReportSelectionWarehouse."Email Body Layout Code");

            this.TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
            REPORT.SaveAs(ReportSelectionWarehouse."Report ID", '', ReportFormat::Html, this.OutStream, this.RecordRef);
            this.TempBlob.CreateInStream(this.InStream, TextEncoding::UTF8);
            this.InStream.Read(AuxBodyText);

            if ReportSelectionWarehouse."Email Body Layout Code" <> '' then
                this.ReportLayoutSelection.SetTempLayoutSelected('');

        end;

        if this.BodyText <> '' then
            this.BodyText += Text001Lbl;

        this.BodyText += AuxBodyText;

        ReturnValue := this.BodyText;

        if this.LanguageCode <> '' then
            GlobalLanguage(this.InitLanguageID);

        this.EmailMessage.SetBody(this.BodyText);
    end;

    procedure AddAttachmentReportSelectionWarehouse(FileName: Text[250])
    var
        ReportSelectionWarehouse: Record "Report Selection Warehouse";
        VersionFileName: Integer;
        l_FileName: Text[250];
    begin
        if this.HideAddAttachment then
            exit;

        VersionFileName := 0;

        if FileName = '' then
            FileName := this.CreateFileName();

        this.ChangeGlobalLanguaje(this.LanguageCode);

        ReportSelectionWarehouse.Reset();
        ReportSelectionWarehouse.SetRange(Usage, this.SelectionWarehouseUsage);
        ReportSelectionWarehouse.SetRange("Language Code", this.LanguageCode);

        if ReportSelectionWarehouse.IsEmpty() then
            ReportSelectionWarehouse.SetRange("Language Code");

        if ReportSelectionWarehouse.FindSet() then
            repeat
                this.SelectAttachmentFormat(ReportSelectionWarehouse."Report ID");

                Clear(this.TempBlob);
                Clear(this.OutStream);
                Clear(this.InStream);

                VersionFileName += 1;

                if VersionFileName > 1 then
                    FileName += '_' + Format(VersionFileName);

                FileName += '.' + format(this.ContentTypeAddAttachment);

                l_FileName := CopyStr(FileName + '.' + format(ContentTypeAddAttachment), 1, 250);

                this.TempBlob.CreateOutStream(this.OutStream, TextEncoding::UTF8);
                REPORT.SaveAs(ReportSelectionWarehouse."Report ID", '', this.AttachmentFormat, this.OutStream, this.RecordRef);
                this.TempBlob.CreateInStream(InStream, TextEncoding::UTF8);
                this.EmailMessage.AddAttachment(l_FileName, this.ContentTypeAddAttachment, this.InStream);

            until ReportSelectionWarehouse.Next() = 0;

        if this.LanguageCode <> '' then
            GlobalLanguage(this.InitLanguageID);
    end;
    #endregion

    #region FUNCIONES ADD VARIOS
    procedure AddRecipientsCC(NewRecipientsCC: Text)
    begin
        //adjuntamos los correos en copia
        this.RecipientsCC := NewRecipientsCC;
        this.EmailMessage.AddRecipient(Enum::"Email Recipient Type"::Cc, NewRecipientsCC);
    end;

    procedure AddRecipients(NewToRecipients: Text)
    begin
        //adjuntamos los correos de envio
        this.ToRecipients := NewToRecipients;
        this.EmailMessage.AddRecipient(Enum::"Email Recipient Type"::"To", NewToRecipients);
    end;

    procedure AddAttachment(NewInStream: InStream; NewFileName: Text[250]; NewContentType: Text[250])
    begin
        this.EmailMessage.AddAttachment(NewFileName, NewContentType, NewInStream);
    end;
    #endregion

    #region FUNCIONES SET
    procedure SetToRecipients(NewRecipients: Text)
    begin
        this.ToRecipients := NewRecipients;
    end;

    procedure SetRecipientsCC(NewRecipientsCC: Text)
    begin
        this.RecipientsCC := NewRecipientsCC;
    end;

    procedure SetSubject(NewSubject: Text)
    begin
        this.SubjectTxt := NewSubject;
        this.EmailMessage.SetSubject(SubjectTxt);
    end;

    procedure SetBody(NewBody: Text)
    begin
        this.BodyText := NewBody;
        this.EmailMessage.SetBody(BodyText);
    end;

    procedure SetRecord(RecVariant: Variant)
    begin
        Clear(this.RecordRef);
        this.RecordRef.GetTable(RecVariant);
        this.IsModifyGetTable := true;
    end;

    procedure SetReportSelectionUsage(NewReportSelectionUsage: Enum "Report Selection Usage")
    begin
        this.ReportSelectionUsage := NewReportSelectionUsage;
    end;

    procedure SetReportSelectionWarehouseUsage(NewReportSelectionWarehouseUsage: Enum "Report Selection Warehouse Usage")
    begin
        this.SelectionWarehouseUsage := NewReportSelectionWarehouseUsage;
    end;

    procedure SetLanguage(NewLanguageCode: Code[10])
    begin
        this.LanguageCode := NewLanguageCode;
    end;

    procedure SetHideAddAttachment(NewHideAddAttachment: Boolean)
    begin
        this.HideAddAttachment := NewHideAddAttachment;
    end;

    procedure SetHideAddBody(NewHideAddBody: Boolean)
    begin
        this.HideAddBody := NewHideAddBody;
    end;

    procedure SetHideAddSubject(NewHideAddSubject: Boolean)
    begin
        this.HideAddSubject := NewHideAddSubject;
    end;

    procedure SetAttachmentFormat(NewAttachmentFormat: ReportFormat)
    begin
        this.AttachmentFormat := NewAttachmentFormat;
        this.IsModifyAttachmentFormat := true;
    end;

    procedure SetSendSeparateAttachments()
    begin
        this.SendSeparateAttachments := true;
    end;

    procedure SetSkipHtmlFormatting()
    begin
        this.SkipHtmlFormatting := true;
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

        this.InitLanguageID := GlobalLanguage();

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
        this.ChangeGlobalLanguaje(this.LanguageCode);

        Clear(ReportDistributionManagement);

        Clear(ReportDistributionManagement);
        ReturnValue := ReportDistributionManagement.GetFullDocumentTypeText(this.RecordRef);

        if ReturnValue = '' then
            ReturnValue := CopyStr(this.RecordRef.Caption(), 1, 250);

        if this.LanguageCode <> '' then
            GlobalLanguage(this.InitLanguageID);
    end;

    local procedure SelectAttachmentFormat(ReportID: Integer)
    begin
        if not this.IsModifyAttachmentFormat then
            this.AttachmentFormat := this.SearchReportFormat(ReportID);

        case this.AttachmentFormat of
            this.AttachmentFormat::Pdf:
                this.ContentTypeAddAttachment := 'pdf';
            this.AttachmentFormat::Excel:
                this.ContentTypeAddAttachment := 'xlsx';
            this.AttachmentFormat::Html:
                this.ContentTypeAddAttachment := 'html';
            this.AttachmentFormat::Word:
                this.ContentTypeAddAttachment := 'docx';
            this.AttachmentFormat::Xml:
                this.ContentTypeAddAttachment := 'xml';

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
                    this.GetDefaultReportLayoutSelection(ReportLayoutList."Report ID", DefaultReportLayoutList);

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
                this.RecordRef.Open(AllDocRecordRef.Number);
                this.RecordRef.SetPosition(AllDocRecordRef.GetPosition());
                this.RecordRef.SetRecFilter();
                case IntOptionAttachment of
                    this.OptionAttachment::ReportSelections:
                        this.AddAttachmentReportSelections('');
                    this.OptionAttachment::ReportSelectionWarehouse:
                        this.AddAttachmentReportSelectionWarehouse('');

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

    [EventSubscriber(ObjectType::Table, Database::"Report Selections", OnBeforeCheckEmailBodyUsage, '', false, false)]
    local procedure T77_OnBeforeCheckEmailBodyUsage(var IsHandled: Boolean)
    begin
        //este evento lo ponemos para omitir el error de varios checks para el cuerpo
        IsHandled := true;
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
        SkipHtmlFormatting: Boolean;
        LanguageCode: Code[10];
        InitLanguageID: Integer;
        AttachmentFormat: ReportFormat;
}