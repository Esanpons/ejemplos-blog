table 50100 "Setup Extension"
{
    Caption = 'Setup Extension';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key', Locked = true;
            DataClassification = CustomerContent;
        }
        field(2; "Maximum Date"; Date)
        {
            Caption = 'Maximum Date', Comment = 'ESP="Fecha máxima"';
            DataClassification = CustomerContent;
        }
        field(3; "Quantity of Days"; Integer)
        {
            Caption = 'Quantity of Days', Comment = 'ESP="Cantidad de días"';
            DataClassification = CustomerContent;
        }
        field(4; "Destination Warehouse"; Code[20])
        {
            Caption = 'Destination Warehouse', Comment = 'ESP="Almacén de destino"';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
