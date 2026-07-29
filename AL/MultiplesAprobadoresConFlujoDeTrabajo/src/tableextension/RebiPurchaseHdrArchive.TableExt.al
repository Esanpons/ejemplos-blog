tableextension 60002 "Rebi Purchase Hdr Archive" extends "Purchase Header Archive"
{
    //REPLICA (38, 120, 122, 124, 5109, 6650)
    fields
    {
        field(60000; "Rebi Approval Group"; Code[20])
        {
            Caption = 'Approval Group', Comment = 'ESP="Grupo aprobador"';
            DataClassification = CustomerContent;
            TableRelation = "Workflow User Group";
            Editable = false;
        }
    }
}