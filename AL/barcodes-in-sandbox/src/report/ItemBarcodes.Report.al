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
                GenerateBarcode: Codeunit "Generate Barcode";
            begin
                //Code-39
                Barcode39Txt := GenerateBarcode.GenerateCode39(Items."No.");

                //Code-93
                Barcode93Txt := GenerateBarcode.GenerateCode93(Items."No.");

                //Code-128
                Barcode128Txt := GenerateBarcode.GenerateCode128(Items."No.");
            end;
        }
    }
    var
        Barcode93Txt: text;
        Barcode39Txt: text;
        Barcode128Txt: text;

}











