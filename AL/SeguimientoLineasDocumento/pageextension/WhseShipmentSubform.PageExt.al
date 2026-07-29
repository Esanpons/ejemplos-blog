pageextension 50102 "Whse. Shipment Subform" extends "Whse. Shipment Subform"
{
    actions
    {
        addlast("&Line")
        {
            action(DocumentLineTracking)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Document &Line Tracking', Comment = 'ESP="Seguimiento de línea de documento"';
                Image = Navigate;
                ToolTip = 'View related open, posted, or archived documents or document lines.', Comment = 'ESP="Ver documentos o líneas de documentos relacionados abiertos, publicados o archivados."';

                trigger OnAction()
                var
                    MgtDocumentTracking: Codeunit "Mgt. Document Tracking";
                begin
                    Clear(MgtDocumentTracking);
                    MgtDocumentTracking.OpenDocumentLineTracking(Rec."Source Type", Rec."Source No.", Rec."Source Line No.");
                end;
            }
        }
    }
}