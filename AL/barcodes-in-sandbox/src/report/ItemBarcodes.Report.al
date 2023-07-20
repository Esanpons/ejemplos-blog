/// <summary>
/// Report Item Barcodes (ID 50001).
/// </summary>

report 50001 "Item Barcodes"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Item Barcodes';
    RDLCLayout = './src/Report/ItemBarcodes.rdl';

    dataset
    {
        dataitem(Items; Item)
        {
            column(No; Items."No.")
            {
                IncludeCaption = true;
            }
            column(Description; Items."Description")
            {
                IncludeCaption = true;
            }
            column(Barcode128Txt; Barcode128Txt)
            {
            }
            column(Barcode39Txt; Barcode39Txt)
            {
            }
            column(Barcode93Txt; Barcode93Txt)
            {
            }

            trigger OnPreDataItem()
            begin
                Items.SetRange("No.", '1896-S');
            end;

            trigger OnAfterGetRecord()
            var
                BarcodeSymbology: Enum "Barcode Symbology";
                BarcodeFontProvider: Interface "Barcode Font Provider";
            begin
                BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;

                //Code-39
                BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
                Barcode39Txt := BarcodeFontProvider.EncodeFont(Items."No.", BarcodeSymbology);

                //Code-93
                BarcodeSymbology := Enum::"Barcode Symbology"::Code93;
                Barcode93Txt := BarcodeFontProvider.EncodeFont(Items."No.", BarcodeSymbology);

                //Code-128
                BarcodeSymbology := Enum::"Barcode Symbology"::Code128;
                Barcode128Txt := BarcodeFontProvider.EncodeFont(Items."No.", BarcodeSymbology);
            end;
        }
    }
    var
        Barcode93Txt: text;
        Barcode39Txt: text;
        Barcode128Txt: text;

}











