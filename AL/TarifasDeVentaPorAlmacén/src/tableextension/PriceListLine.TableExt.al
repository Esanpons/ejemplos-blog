tableextension 60052 "Price List Line" extends "Price List Line"
{
    fields
    {
        field(60000; "Location Code"; Code[20])
        {
            Caption = 'Location Code', Comment = 'ESP="Cód. almacén"';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }

    }
}