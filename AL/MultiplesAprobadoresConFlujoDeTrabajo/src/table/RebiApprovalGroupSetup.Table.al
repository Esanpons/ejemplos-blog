table 60001 "Rebi Approval Group Setup"
{
    Caption = 'Approval Group Setup', Comment = 'ESP="Configuración grupos aprobaciones"';
    DataClassification = CustomerContent;
    LookupPageId = "Rebi Approval Group Setup";
    DrillDownPageId = "Rebi Approval Group Setup";

    fields
    {
        field(1; "User Name"; Code[50])
        {
            Caption = 'User', Comment = 'ESP="Usuario"';
            DataClassification = CustomerContent;
            TableRelation = "User Setup";
        }
        field(2; "Full Name"; Text[100])
        {
            Caption = 'Full Name', Comment = 'ESP="Nombre usuario"';
            FieldClass = FlowField;
            CalcFormula = lookup("User"."Full Name" where("User Name" = field("User Name")));
            Editable = false;
        }
        field(3; "Code Approval Group"; Code[20])
        {
            Caption = 'Approval Group', Comment = 'ESP="Grupo aprobador"';
            DataClassification = CustomerContent;
            TableRelation = "Workflow User Group";
        }
        field(4; "Description Approval Group"; Text[100])
        {
            Caption = 'Description Approval Group', Comment = 'ESP="Descripción grupo aprobador"';
            FieldClass = FlowField;
            CalcFormula = lookup("Workflow User Group".Description where(Code = field("Code Approval Group")));
            Editable = false;
        }
    }
    keys
    {
        key(PK; "User Name")
        {
            Clustered = true;
        }
    }
}
