namespace Esanpons.Utils;
using Microsoft.Inventory.Item;
using System.Text;
using Microsoft.Pricing.Calculation;
using Microsoft.Sales.Pricing;
using Microsoft.Pricing.PriceList;
using Microsoft.Inventory.Tracking;
using Microsoft.Sales.Document;
using System.Azure.Identity;
using System.Environment;
using Microsoft.Foundation.Attachment;
using System.Utilities;
using System.Reflection;
using System.Environment.Configuration;
using Microsoft.Foundation.Reporting;

codeunit 59001 "Utils"
{
    // #Creado por Esteve Sanpons Carballares.
    // #https://github.com/Esanpons
    // #Se da acceso libre a modificar y utilizar este objeto libremente. Siempre y cuando se haga referencia al autor.

    #region Functions Rec temporary
    procedure RecordIsTemporary(RecVariant: Variant)
    var
        RecordRefe: RecordRef;
        Text001Err: Label 'The table has to be temporary. Contact the system administrator', Comment = 'ESP="La tabla tiene que ser temporal. Ponte en contacto con el administrador del sistema"';
    begin
        RecordRefe.GetTable(RecVariant);
        if not RecordRefe.IsTemporary() then
            Error(Text001Err);

    end;

    procedure RecordIsTemporaryAndDeleteAll(RecVariant: Variant)
    var
        RecordRefe: RecordRef;
    begin
        this.RecordIsTemporary(RecVariant);
        RecordRefe.GetTable(RecVariant);
        RecordRefe.Reset();
        RecordRefe.DeleteAll();
    end;
    #endregion

    #region function salto de linea
    procedure LineBreak(QtyLineBreak: Integer) ReturnValue: Text
    var
        TypeHelper: Codeunit "Type Helper";
        i: Integer;
    begin
        ReturnValue := '';

        for i := 1 to QtyLineBreak do
            ReturnValue += TypeHelper.CRLFSeparator();
    end;

    procedure SaltoDeLinea() ReturnValue: Text
    var
        CR: Char;
        LF: Char;
    begin
        CR := 13;
        LF := 10;
        ReturnValue := FORMAT(CR) + FORMAT(LF);
    end;

    #endregion

    #region Dialog, message, confirms
    procedure ProcessDialogOpen(NewMaxCount: Integer)
    var
        Text001Lbl: Label 'Progress to %1: ', Comment = 'ESP="Progreso hasta %1: "';
        Text002Lbl: Label '#1#####', Locked = true;
        ValueText: Text;
    begin
        if not GuiAllowed then
            exit;

        this.MyNext := 0;
        this.MaxCount := NewMaxCount;
        ValueText := StrSubstNo(Text001Lbl, this.MaxCount) + Text002Lbl;
        this.MyDialog.Open(ValueText, this.MyNext);
    end;

    procedure ProcessDialogUpdate()
    begin
        if not GuiAllowed then
            exit;

        this.MyNext := this.MyNext + 1;
        this.MyDialog.Update();
    end;

    procedure ProcessDialogClose()
    begin
        if not GuiAllowed then
            exit;

        this.MyDialog.Close();
    end;

    procedure ConfirmContinue(NewTextConfirm: Text) ReturnValue: Boolean
    var
        ConfirmMgt: Codeunit "Confirm Management";
        TextConfirm: Text;
        Text001Qst: Label 'Do you want to continue?', Comment = 'ESP="¿Quieres continuar?"';
    begin
        TextConfirm := Text001Qst;
        if NewTextConfirm <> '' then
            TextConfirm := NewTextConfirm;

        ReturnValue := ConfirmMgt.GetResponseOrDefault(TextConfirm, true);
    end;

    procedure MessageCompleteProcess()
    var
        Text001Msg: Label 'The process has been completed', Comment = 'ESP="Se ha completado el proceso"';
    begin
        this.MessageCompleteProcess(Text001Msg);
    end;

    procedure MessageCompleteProcess(Msg: Text)
    begin
        if not GuiAllowed then
            exit;

        Message(Msg);
    end;
    #endregion

    #region Conver Base64
    procedure InsertTextBase64ToDocumentAttachment(Base64Text: Text; TableId: Integer; No: Code[20]; AttachmentDocumentType: Enum "Attachment Document Type"; LineNo: Integer; FileName: Text; FileExtension: Text)
    var
        DocumentAttachment: Record "Document Attachment";
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
    begin
        Clear(InStream);
        Clear(TempBlob);
        Clear(Base64Convert);
        Clear(OutStream);

        TempBlob.CreateOutStream(OutStream);
        Base64Convert.FromBase64(Base64Text, OutStream);
        TempBlob.CreateInStream(InStream);


        DocumentAttachment.Init();
        DocumentAttachment.Validate("Table ID", TableId);
        DocumentAttachment.Validate("No.", No);
        DocumentAttachment.Validate("Document Type", AttachmentDocumentType);
        DocumentAttachment.Validate("Line No.", LineNo);
        DocumentAttachment.Validate("Attached Date", CurrentDateTime());
        DocumentAttachment.Validate("File Name", FileName);
        DocumentAttachment.Validate("File Extension", FileExtension);
        DocumentAttachment."Document Reference ID".ImportStream(InStream, FileName, FileExtension);
        DocumentAttachment.Insert(true);
    end;

    procedure ConvertTextBase64ToInStream(Base64Text: Text; var InStream: InStream)
    var
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
    begin
        Clear(InStream);
        Clear(TempBlob);
        Clear(Base64Convert);
        Clear(OutStream);

        TempBlob.CreateOutStream(OutStream);
        Base64Convert.FromBase64(Base64Text, OutStream);
        TempBlob.CreateInStream(InStream);

    end;

    procedure ConvertTextBase64ToTempBlob(TextBase64: Text) TempBlob: Codeunit "Temp Blob"
    var
        Base64Convert: Codeunit "Base64 Convert";
        OutStream: OutStream;
    begin
        if TextBase64 = '' then
            exit;

        Clear(TempBlob);
        Clear(Base64Convert);
        Clear(OutStream);

        TempBlob.CreateOutStream(OutStream);
        Base64Convert.FromBase64(TextBase64, OutStream);
    end;

    procedure ConvertMediaSetToBase64(MediaId: Text) ReturnValue: Text
    var
        TenantMedia: Record "Tenant Media";
        Base64Convert: Codeunit "Base64 Convert";
        InStream: InStream;
    begin
        ReturnValue := '';
        Clear(InStream);
        TenantMedia.Reset();

        if TenantMedia.Get(MediaId) then begin
            TenantMedia.CalcFields(Content);
            TenantMedia.Content.CreateInStream(InStream);
            ReturnValue := Base64Convert.ToBase64(InStream);
        end;
    end;

    procedure ConvertDocumentToBase64(RecVariant: Variant; ReportSelectionUsage: Enum "Report Selection Usage") ReturnValue: Text;
    var
        ReportSelections: Record "Report Selections";
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        RecordRef: RecordRef;
        InStream: InStream;
        OutStream: OutStream;
    begin
        //funcion para guardar e convertir el documento en base64
        Clear(Base64Convert);
        Clear(InStream);
        Clear(OutStream);
        Clear(TempBlob);
        Clear(RecordRef);

        //reinicializa el recref con la variable de la tabla
        RecordRef.GetTable(RecVariant);

        //se busca el informe configurado
        ReportSelections.Reset();
        ReportSelections.SetRange(Usage, ReportSelectionUsage);
        ReportSelections.FindFirst();

        ReportSelections.TestField("Report ID");

        //se guarda el informe en un instream
        TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
        REPORT.SaveAs(ReportSelections."Report ID", '', SearchReportFormat(ReportSelections."Report ID"), OutStream, RecordRef);
        TempBlob.CreateInStream(InStream, TextEncoding::UTF8);

        //se convierte el instream en base64
        ReturnValue := Base64Convert.ToBase64(InStream);
    end;

    procedure SearchReportFormat(ReportID: Integer) ReturnValue: ReportFormat
    var
        ReportLayoutList: Record "Report Layout List";
        DefaultReportLayoutList: Record "Report Layout List";
        IsDefaultLayout: Boolean;
        ValueMimeType: Text;
        Pos: Integer;
    begin
        //funcion para buscar el tipo de layout que tiene el informe configurado. Esto se usa para guardar el report.
        ReturnValue := ReturnValue::Pdf;

        ReportLayoutList.Reset();
        ReportLayoutList.SetRange("Report ID", ReportID);
        if ReportLayoutList.FindSet() then
            repeat
                if DefaultReportLayoutList."Report ID" <> ReportLayoutList."Report ID" then
                    GetDefaultReportLayoutSelection(ReportLayoutList."Report ID", DefaultReportLayoutList);

                //si esta como default entonces se busca el tipo y se añade
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
                            //esta casuistica es por si no lo detectara en alguno de los tipos por ser custom y busque al menos el tipo de word y de excel segun el Mime Type
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
        //Copia de funcion estandar para buscar el layout por defecto que esta marcado y configurado
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
    #endregion

    #region functions BBDD, Enviorement
    procedure GetTenant() ReturnValue: Text
    var
        AzureADTenant: Codeunit "Azure AD Tenant";
    begin
        ReturnValue := AzureADTenant.GetAadTenantId();
    end;

    procedure GetEnviorement() ReturnValue: Text
    var
        EnvironmentInformation: Codeunit "Environment Information";
    begin
        ReturnValue := EnvironmentInformation.GetEnvironmentName();
    end;
    #endregion

    #region Convert Escape Unicode
    procedure ConvertEscapeUnicode(TextToConvert: Text) ReturnValue: Text
    var
        ValueText: Text;
    begin
        ValueText := TextToConvert;

        ValueText := ValueText.Replace('\u00c0', 'À');
        ValueText := ValueText.Replace('\u00c1', 'Á');
        ValueText := ValueText.Replace('\u00c2', 'Â');
        ValueText := ValueText.Replace('\u00c3', 'Ã');
        ValueText := ValueText.Replace('\u00c4', 'Ä');
        ValueText := ValueText.Replace('\u00c5', 'Å');
        ValueText := ValueText.Replace('\u00c6', 'Æ');
        ValueText := ValueText.Replace('\u00c7', 'Ç');
        ValueText := ValueText.Replace('\u00c8', 'È');
        ValueText := ValueText.Replace('\u00c9', 'É');
        ValueText := ValueText.Replace('\u00ca', 'Ê');
        ValueText := ValueText.Replace('\u00cb', 'Ë');
        ValueText := ValueText.Replace('\u00cc', 'Ì');
        ValueText := ValueText.Replace('\u00cd', 'Í');
        ValueText := ValueText.Replace('\u00ce', 'Î');
        ValueText := ValueText.Replace('\u00cf', 'Ï');
        ValueText := ValueText.Replace('\u00d1', 'Ñ');
        ValueText := ValueText.Replace('\u00d2', 'Ò');
        ValueText := ValueText.Replace('\u00d3', 'Ó');
        ValueText := ValueText.Replace('\u00d4', 'Ô');
        ValueText := ValueText.Replace('\u00d5', 'Õ');
        ValueText := ValueText.Replace('\u00d6', 'Ö');
        ValueText := ValueText.Replace('\u00d8', 'Ø');
        ValueText := ValueText.Replace('\u00d9', 'Ù');
        ValueText := ValueText.Replace('\u00da', 'Ú');
        ValueText := ValueText.Replace('\u00db', 'Û');
        ValueText := ValueText.Replace('\u00dc', 'Ü');
        ValueText := ValueText.Replace('\u00dd', 'Ý');
        ValueText := ValueText.Replace('\u00df', 'ß');
        ValueText := ValueText.Replace('\u00e0', 'à');
        ValueText := ValueText.Replace('\u00e1', 'á');
        ValueText := ValueText.Replace('\u00e2', 'â');
        ValueText := ValueText.Replace('\u00e3', 'ã');
        ValueText := ValueText.Replace('\u00e4', 'ä');
        ValueText := ValueText.Replace('\u00e5', 'å');
        ValueText := ValueText.Replace('\u00e6', 'æ');
        ValueText := ValueText.Replace('\u00e7', 'ç');
        ValueText := ValueText.Replace('\u00e8', 'è');
        ValueText := ValueText.Replace('\u00e9', 'é');
        ValueText := ValueText.Replace('\u00ea', 'ê');
        ValueText := ValueText.Replace('\u00eb', 'ë');
        ValueText := ValueText.Replace('\u00ec', 'ì');
        ValueText := ValueText.Replace('\u00ed', 'í');
        ValueText := ValueText.Replace('\u00ee', 'î');
        ValueText := ValueText.Replace('\u00ef', 'ï');
        ValueText := ValueText.Replace('\u00f0', 'ð');
        ValueText := ValueText.Replace('\u00f1', 'ñ');
        ValueText := ValueText.Replace('\u00f2', 'ò');
        ValueText := ValueText.Replace('\u00f3', 'ó');
        ValueText := ValueText.Replace('\u00f4', 'ô');
        ValueText := ValueText.Replace('\u00f5', 'õ');
        ValueText := ValueText.Replace('\u00f6', 'ö');
        ValueText := ValueText.Replace('\u00f8', 'ø');
        ValueText := ValueText.Replace('\u00f9', 'ù');
        ValueText := ValueText.Replace('\u00fa', 'ú');
        ValueText := ValueText.Replace('\u00fb', 'û');
        ValueText := ValueText.Replace('\u00fc', 'ü');
        ValueText := ValueText.Replace('\u00fd', 'ý');
        ValueText := ValueText.Replace('\u00ff', 'ÿ');

        ReturnValue := ValueText;
    end;
    #endregion

    #region ANSI <-> ASCII converter
    procedure Ansi2Ascii(_Text: Text[250]): Text[250]
    begin
        this.MakeVars();
        exit(CONVERTSTR(_Text, this.AnsiStr, this.AsciiStr));
    end;

    procedure Ascii2Ansi(_Text: Text[250]): Text[250]
    begin
        this.MakeVars();
        exit(CONVERTSTR(_Text, this.AsciiStr, this.AnsiStr));
    end;

    procedure MakeVars()
    begin
        this.AsciiStr := 'ÇüéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜø£Ø×ƒáíóúñÑªº¿®¬½¼¡«»¦¦¦¦¦ÁÂÀ©¦¦++¢¥++--+-+ãÃ++--¦-+';
        this.AsciiStr := this.AsciiStr + '¤ðÐÊËÈiÍÎÏ++¦_¦Ì¯ÓßÔÒõÕµþÞÚÛÙýÝ¯´­±=¾¶§÷¸°¨·¹³²¦ ';
        this.CharVar[1] := 196;
        this.CharVar[2] := 197;
        this.CharVar[3] := 201;
        this.CharVar[4] := 242;
        this.CharVar[5] := 220;
        this.CharVar[6] := 186;
        this.CharVar[7] := 191;
        this.CharVar[8] := 188;
        this.CharVar[9] := 187;
        this.CharVar[10] := 193;
        this.CharVar[11] := 194;
        this.CharVar[12] := 192;
        this.CharVar[13] := 195;
        this.CharVar[14] := 202;
        this.CharVar[15] := 203;
        this.CharVar[16] := 200;
        this.CharVar[17] := 205;
        this.CharVar[18] := 206;
        this.CharVar[19] := 204;
        this.CharVar[20] := 175;
        this.CharVar[21] := 223;
        this.CharVar[22] := 213;
        this.CharVar[23] := 254;
        this.CharVar[24] := 218;
        this.CharVar[25] := 219;
        this.CharVar[26] := 217;
        this.CharVar[27] := 180;
        this.CharVar[28] := 177;
        this.CharVar[29] := 176;
        this.CharVar[30] := 185;
        this.CharVar[31] := 179;
        this.CharVar[32] := 178;
        this.AnsiStr := 'Ã³ÚÔõÓÕþÛÙÞ´¯ý' + FORMAT(this.CharVar[1]) + FORMAT(this.CharVar[2]) + FORMAT(this.CharVar[3]) + 'µã¶÷' + FORMAT(this.CharVar[4]);
        this.AnsiStr := this.AnsiStr + '¹¨ Í' + FORMAT(this.CharVar[5]) + '°úÏÎâßÝ¾·±Ð¬' + FORMAT(this.CharVar[6]) + FORMAT(this.CharVar[7]);
        this.AnsiStr := this.AnsiStr + '«¼¢' + FORMAT(this.CharVar[8]) + 'í½' + FORMAT(this.CharVar[9]) + '___ªª' + FORMAT(this.CharVar[10]) + FORMAT(this.CharVar[11]);
        this.AnsiStr := this.AnsiStr + FORMAT(this.CharVar[12]) + '®ªª++óÑ++--+-+Ò' + FORMAT(this.CharVar[13]) + '++--ª-+ñ­ð';
        this.AnsiStr := this.AnsiStr + FORMAT(this.CharVar[14]) + FORMAT(this.CharVar[15]) + FORMAT(this.CharVar[16]) + 'i' + FORMAT(this.CharVar[17]) + FORMAT(this.CharVar[18]);
        this.AnsiStr := this.AnsiStr + '¤++__ª' + FORMAT(this.CharVar[19]) + FORMAT(this.CharVar[20]) + 'Ë' + FORMAT(this.CharVar[21]) + 'ÈÊ§';
        this.AnsiStr := this.AnsiStr + FORMAT(this.CharVar[22]) + 'Á' + FORMAT(this.CharVar[23]) + 'Ì' + FORMAT(this.CharVar[24]) + FORMAT(this.CharVar[25]);
        this.AnsiStr := this.AnsiStr + FORMAT(this.CharVar[26]) + '²¦»' + FORMAT(this.CharVar[27]) + '¡' + FORMAT(this.CharVar[28]) + '=¥Âº¸©' + FORMAT(this.CharVar[29]);
        this.AnsiStr := this.AnsiStr + '¿À' + FORMAT(this.CharVar[30]) + FORMAT(this.CharVar[31]) + FORMAT(this.CharVar[32]) + '_ ';
    end;

    #endregion

    #region Control de Errores
    procedure ActionError(MessageErr: Text; PageNo: Integer; FieldNo: Integer; RecordId: RecordId; CaptionButton: Text)
    var
        ErrorInfo: ErrorInfo;
    begin
        Clear(ErrorInfo);
        ErrorInfo.Message(MessageErr);
        ErrorInfo.PageNo := PageNo;
        ErrorInfo.RecordId := RecordId;
        if FieldNo <> 0 then
            ErrorInfo.FieldNo := FieldNo;
        if CaptionButton <> '' then
            ErrorInfo.AddNavigationAction(CaptionButton);

        if GuiAllowed() then
            Error(ErrorInfo);
    end;
    #endregion

    #region RecordLink
    procedure InsertNewNote(RecVariant: Variant; NoteText: Text)
    var
        RecordLink: Record "Record Link";
        LinkManagement: Codeunit "Record Link Management";
        RecordRef: RecordRef;
    begin
        Clear(RecordRef);
        RecordRef.GetTable(RecVariant);

        RecordLink.Init();
        RecordLink."Record ID" := RecordRef.RecordId();
        RecordLink.Company := CopyStr(CompanyName(), 1, 30);
        RecordLink."User ID" := CopyStr(UserId(), 1, 132);
        RecordLink.Created := CurrentDateTime();
        RecordLink.Type := RecordLink.Type::Note;
        RecordLink.Insert();

        Clear(LinkManagement);
        LinkManagement.WriteNote(RecordLink, NoteText);
        RecordLink.Modify();
    end;

    procedure GetNote(RecordLink: Record "Record Link"): Text;
    var
        LinkManagement: Codeunit "Record Link Management";
    begin
        Clear(LinkManagement);
        exit(LinkManagement.ReadNote(RecordLink));
    end;

    procedure RemoveLinks(RecVariant: Variant)
    var
        LinkManagement: Codeunit "Record Link Management";
    begin
        Clear(LinkManagement);
        LinkManagement.RemoveLinks(RecVariant);
    end;

    procedure CopyLinks(FromRecVariant: Variant; ToRecVariant: Variant)
    var
        LinkManagement: Codeunit "Record Link Management";
    begin
        Clear(LinkManagement);
        LinkManagement.CopyLinks(FromRecVariant, ToRecVariant);
    end;
    #endregion

    #region conversion de fechas a UNIX
    procedure ConvertUnixTimestampToDateTime(Timestamp: BigInteger) ReturnValue: DateTime
    var
        UnixTimestamp: Codeunit "Unix Timestamp";
    begin
        Clear(UnixTimestamp);
        ReturnValue := UnixTimestamp.EvaluateTimestamp(Timestamp);
    end;

    procedure ConvertDateTimeToUnixTimestamp(DateTimeFrom: DateTime) ReturnValue: BigInteger;
    var
        UnixTimestamp: Codeunit "Unix Timestamp";
    begin
        Clear(UnixTimestamp);
        ReturnValue := UnixTimestamp.CreateTimestampSeconds(DateTimeFrom);
    end;
    #endregion


    #region funciones con variables Time
    procedure RoundTimeToNearestMinutes(InputTime: Time; MinutesRound: Integer) ReturnValue: Time
    var
        TotalMinutes: Integer;
        Remainder: Integer;
        RoundedMinutes: Integer;
        Time0: Time;
    begin
        Time0 := 000000T;
        ReturnValue := InputTime;
        if InputTime = Time0 then
            exit;

        // Convertir de Time a minutos desde la medianoche usando Duration
        TotalMinutes := (InputTime - Time0) div (60 * 1000);

        // Calcular el residuo al dividir por MinutosRound
        Remainder := TotalMinutes mod MinutesRound;

        // Redondear al múltiplo más cercano de MinutosRound
        if Remainder < (MinutesRound / 2) then
            RoundedMinutes := TotalMinutes - Remainder
        else
            RoundedMinutes := TotalMinutes + (MinutesRound - Remainder);

        // Convertir minutos de vuelta a Time sumando desde 00:00:00 (0T)
        ReturnValue := Time0 + (RoundedMinutes * 60 * 1000);
    end;

    procedure SubtractTwoTimes(Time1: Time; Time2: Time) ReturnValue: Time
    var
        ValueTime: Time;
        ValueDecimal: Decimal;
    begin
        ValueTime := 000000T;
        ValueDecimal := Time2 - Time1;

        // lo convierto a segundos
        ValueDecimal := ValueDecimal / 1000;
        ValueTime := ValueTime + (ValueDecimal mod 60) * 1000;

        // lo convierto a minutos
        ValueDecimal := ValueDecimal div 60;
        ValueTime := ValueTime + (ValueDecimal mod 60) * 1000 * 60;

        // lo convierto a horas
        ValueDecimal := ValueDecimal div 60;
        ReturnValue := ValueTime + (ValueDecimal mod 60) * 1000 * 60 * 60;
    end;
    #endregion

    #region Varios
    procedure GenerateQRCodeToText(BarcodeText: Text) QRCode: Text
    var
        BarcodeSymbology2D: Enum "Barcode Symbology 2D";
        BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
    begin
        //la fuente en el informe tiene que ser IDAutomation2D
        Clear(QRCode);
        Clear(BarcodeFontProvider2D);

        BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
        QRCode := BarcodeFontProvider2D.EncodeFont(BarcodeText, BarcodeSymbology2D);
    end;

    procedure GeFilterLotFromSalesLine(SalesLine: record "Sales Line") ReturnValue: Text
    var
        ReservationEntry: Record "Reservation Entry";
        TrackingSpecification: Record "Tracking Specification";
    begin
        Clear(ReturnValue);

        if SalesLine."Line No." = 0 then
            exit;

        ReservationEntry.SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date");

        ReservationEntry.SetRange("Source ID", SalesLine."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
        ReservationEntry.SetRange("Source Type", Database::"Sales Line");
        ReservationEntry.SetRange("Source Subtype", SalesLine."Document Type");
        if ReservationEntry.FindSet() then
            repeat
                if ReturnValue <> '' then
                    ReturnValue += '|';

                ReturnValue += ReservationEntry."Lot No.";
            until ReservationEntry.Next() = 0;

        TrackingSpecification.SetCurrentKey("Source ID", "Source Type", "Source Subtype",
                                     "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");
        TrackingSpecification.SetRange("Source ID", SalesLine."Document No.");
        TrackingSpecification.SetRange("Source Type", Database::"Sales Line");
        TrackingSpecification.SetRange("Source Subtype", SalesLine."Document Type");
        TrackingSpecification.SetRange("Source Ref. No.", SalesLine."Line No.");
        if TrackingSpecification.FindSet() then
            repeat
                if ReturnValue <> '' then
                    ReturnValue += '|';

                ReturnValue += TrackingSpecification."Lot No.";
            until TrackingSpecification.Next() = 0;

    end;

    procedure CalcPVP(ItemNo: Code[20]; PVPCode: Code[20]) ReturnValue: Decimal
    var
        TempSalesLine: Record "Sales Line" temporary;
        TempPriceListLine: Record "Price List Line" temporary;
        SalesLinePrice: Codeunit "Sales Line - Price";
        PriceCalculationMgt: codeunit "Price Calculation Mgt.";
        PriceCalculation: Interface "Price Calculation";
        LineWithPrice: Interface "Line With Price";
        PriceType: Enum "Price Type";
        InsertValue: Boolean;
    begin
        Clear(PriceCalculation);
        Clear(LineWithPrice);
        Clear(SalesLinePrice);
        Clear(PriceCalculationMgt);

        ReturnValue := 0;
        InsertValue := false;

        //rellenamos las variables para buscar el pvp
        TempSalesLine.Init();
        TempSalesLine.Type := TempSalesLine.Type::Item;
        TempSalesLine."No." := ItemNo;
        TempSalesLine.Quantity := 1;
        TempSalesLine.Insert();

        LineWithPrice := SalesLinePrice;
        LineWithPrice.SetLine(PriceType::Sale, TempSalesLine);

        //añadimos las variables
        PriceCalculationMgt.GetHandler(LineWithPrice, PriceCalculation);

        //rellanamos la variable temporal
        PriceCalculation.FindPrice(TempPriceListLine, true);

        //filtramos los datos recogidos
        TempPriceListLine.Reset();
        TempPriceListLine.SetRange("Price List Code", PVPCode);
        TempPriceListLine.SetRange("Product No.", ItemNo);

        //si despues del filtro da 0 es porque no hay producto especifico y se busca sin producto
        if TempPriceListLine.Count = 0 then
            TempPriceListLine.SetRange("Product No.");

        if TempPriceListLine.FindSet() then
            repeat
                if (format(TempPriceListLine."Starting Date") = '') and (format(TempPriceListLine."Ending Date") = '') then
                    InsertValue := true;

                if (TempPriceListLine."Starting Date" <= Today()) and (format(TempPriceListLine."Ending Date") = '') then
                    InsertValue := true;

                if (TempPriceListLine."Starting Date" <= Today()) and (TempPriceListLine."Ending Date" > Today()) then
                    InsertValue := true;

                if InsertValue then begin
                    if TempPriceListLine."Unit Price" < ReturnValue then
                        ReturnValue := TempPriceListLine."Unit Price";

                    if ReturnValue = 0 then
                        ReturnValue := TempPriceListLine."Unit Price";
                end;
            until TempPriceListLine.Next() = 0;
    end;
    #endregion

    var
        MyDialog: Dialog;
        MyNext: Integer;
        MaxCount: Integer;
        AsciiStr: Text;
        AnsiStr: Text;
        CharVar: array[32] of Char;
}