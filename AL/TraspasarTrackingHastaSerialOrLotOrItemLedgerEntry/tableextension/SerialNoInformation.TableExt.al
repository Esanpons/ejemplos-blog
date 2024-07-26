tableextension 60004 "Serial No. Information" extends "Serial No. Information"
{
    fields
    {
        field(60000; "Serial No. 2"; Code[50])
        {
            Caption = 'Serial No.2 ', Comment = 'ESP="Nº serial 2"';
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
    }


}