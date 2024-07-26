tableextension 60000 "Lot No. Information" extends "Lot No. Information"
{
    fields
    {
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