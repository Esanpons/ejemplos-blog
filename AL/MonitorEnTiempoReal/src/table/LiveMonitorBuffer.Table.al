table 50150 "Live Monitor Buffer"
{
    Caption = 'Live Monitor Buffer', Comment = 'ESP="Buffer del monitor en vivo"';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.', Comment = 'ESP="N.º movimiento"';
            DataClassification = SystemMetadata;
        }
        field(2; "Key Value"; Text[100])
        {
            Caption = 'Key Value', Comment = 'ESP="Clave"';
            DataClassification = SystemMetadata;
        }
        field(3; "Name"; Text[100])
        {
            Caption = 'Name', Comment = 'ESP="Nombre"';
            DataClassification = SystemMetadata;
        }
        field(4; "Description"; Text[250])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
            DataClassification = SystemMetadata;
        }
        field(5; "Status Text"; Text[50])
        {
            Caption = 'Status', Comment = 'ESP="Estado"';
            DataClassification = SystemMetadata;
        }
        field(6; "Detail Text"; Text[250])
        {
            Caption = 'Detail', Comment = 'ESP="Detalle"';
            DataClassification = SystemMetadata;
        }
        field(7; "Indicator"; Text[10])
        {
            Caption = 'Indicator', Comment = 'ESP="Indicador"';
            DataClassification = SystemMetadata;
        }
        field(8; "Style"; Text[30])
        {
            Caption = 'Style', Comment = 'ESP="Estilo"';
            DataClassification = SystemMetadata;
        }
        field(9; "Sort Order"; Integer)
        {
            Caption = 'Sort Order', Comment = 'ESP="Orden"';
            DataClassification = SystemMetadata;
        }
        field(10; "Snapshot At"; DateTime)
        {
            Caption = 'Snapshot At', Comment = 'ESP="Instantánea"';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(ByKeyValue; "Key Value")
        {
        }
        key(BySortOrder; "Sort Order", "Name")
        {
        }
    }
}
