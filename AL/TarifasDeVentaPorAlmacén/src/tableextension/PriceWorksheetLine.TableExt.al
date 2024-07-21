tableextension 60053 "Price Worksheet Line" extends "Price Worksheet Line"
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