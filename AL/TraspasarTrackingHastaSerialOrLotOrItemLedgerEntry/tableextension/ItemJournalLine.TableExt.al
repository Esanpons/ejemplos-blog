tableextension 60002 "Item Journal Line" extends "Item Journal Line"
{
    fields
    {
        field(60000; "Serial No. 2"; Code[50])
        {
            Caption = 'Serial No. 2', Comment = 'ESP="Nº serial 2"';
            DataClassification = CustomerContent;
            NotBlank = true;

        }
        field(60001; "Serial No. 3"; Code[50])
        {
            Caption = 'Serial No. 3', Comment = 'ESP="Nº serial 3"';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(60002; "Serial No. 4"; Code[50])
        {
            Caption = 'Serial No. 4', Comment = 'ESP="Nº serial 4"';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(60003; "Lot No. 2"; Code[50])
        {
            Caption = 'Lot No. 2', Comment = 'ESP="Nº lote 2"';
            DataClassification = CustomerContent;
            NotBlank = true;

        }
        field(60004; "Lot No. 3"; Code[50])
        {
            Caption = 'Lot No. 3', Comment = 'ESP="Nº lote 3"';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(60005; "Lot No. 4"; Code[50])
        {
            Caption = 'Lot No. 4', Comment = 'ESP="Nº lote 4"';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
    }
}