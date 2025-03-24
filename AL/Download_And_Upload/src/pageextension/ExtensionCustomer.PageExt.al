pageextension 50100 "Extension Customer" extends "Customer List"
{
    actions
    {
        addfirst(processing)
        {
            action("Import")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import', comment = 'ESP="Import"';
                Image = Import;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Import', comment = 'ESP="Import"';

                trigger OnAction()
                begin
                    MgtDownloadUpload.Upload();
                end;
            }
            action("Export")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Export', comment = 'ESP="Export"';
                Image = Export;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Export', comment = 'ESP="Export"';

                trigger OnAction()
                begin
                    MgtDownloadUpload.Download();
                end;
            }

            fileuploadaction(UploadMultiple)
            {
                ApplicationArea = All;
                Caption = 'Upload Multiple', Comment = 'ESP="Carga Multiple"';
                ToolTip = 'Upload Multiple', Comment = 'ESP="Carga Multiple"';
                Image = Import;
                AllowMultipleFiles = true;

                trigger OnAction(files: List of [FileUpload])
                begin
                    MgtDownloadUpload.UploadMultipleFilesManual(files);
                end;
            }
        }
    }

    var
        MgtDownloadUpload: Codeunit "Mgt. Download/Upload";

}