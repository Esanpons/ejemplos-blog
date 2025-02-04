codeunit 50001 "Generate Barcode"
{
    procedure GenerateCodabar(BarcodeString: Text) ReturnValue: Text
    var
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeFontProvider: Interface "Barcode Font Provider";

    begin
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::Codabar;
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        ReturnValue := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
    end;

    procedure GenerateCode128(BarcodeString: Text) ReturnValue: Text
    var
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeFontProvider: Interface "Barcode Font Provider";

    begin
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::Code128;
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        ReturnValue := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
    end;

    procedure GenerateCode39(BarcodeString: Text) ReturnValue: Text
    var
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeFontProvider: Interface "Barcode Font Provider";

    begin
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        ReturnValue := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
    end;

    procedure GenerateCode93(BarcodeString: Text) ReturnValue: Text
    var
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeFontProvider: Interface "Barcode Font Provider";

    begin
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::Code93;
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        ReturnValue := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
    end;

    procedure GenerateInterleaved2of5(BarcodeString: Text) ReturnValue: Text
    var
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeFontProvider: Interface "Barcode Font Provider";

    begin
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::Interleaved2of5;
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        ReturnValue := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
    end;

    procedure GenerateInterMSI(BarcodeString: Text) ReturnValue: Text
    var
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeFontProvider: Interface "Barcode Font Provider";

    begin
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::MSI;
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        ReturnValue := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
    end;

    procedure GetFontCodabar(): Text
    begin
        exit(CodabarLbl);
    end;

    procedure GetFontBarcode128(): Text
    begin
        exit(Barcode128Lbl);
    end;

    procedure GetFontBarcode39(): Text
    begin
        exit(Barcode39Lbl);
    end;

    procedure GetFontBarcode93(): Text
    begin
        exit(Barcode93Lbl);
    end;

    procedure GetFontInterleaved_2_Of_5(): Text
    begin
        exit(Interleaved_2_Of_5Lbl);
    end;

    procedure GetFontMSI(): Text
    begin
        exit(MSILbl);
    end;

    var
        CodabarLbl: Label 'IDAutomationHCBL', Locked = true;
        Barcode128Lbl: Label 'IDAutomationC128S', Locked = true;
        Barcode39Lbl: Label 'IDAutomationHC39M', Locked = true;
        Barcode93Lbl: Label 'IDAutomationC93M', Locked = true;
        Interleaved_2_Of_5Lbl: Label 'IDAutomationHI25M', Locked = true;
        MSILbl: Label 'IDAutomationMSIM', Locked = true;
}