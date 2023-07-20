pageextension 50100 "Extension Customer" extends "Customer Card"
{
    actions
    {
        addfirst(processing)
        {
            action("Export Simple Rec")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Export Simple Rec', comment = 'ESP="Exportar Rec Simple"';
                Image = Export;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SimpleMgtJson: Codeunit "Simple Mgt. Json";
                    Text01: Text;
                begin
                    Text01 := SimpleMgtJson.CreateJsonToRec(Rec);
                    Message(text01);
                end;
            }
            action("Export Advanced Rec")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Export Advanced Rec', comment = 'ESP="Exportar Rec Avanzado"';
                Image = Export;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    AdvancedMgtJson: Codeunit "Advanced Mgt. Json";
                    JObject: JsonObject;
                    Text01: Text;
                begin
                    JObject := AdvancedMgtJson.Rec2Json(Rec);
                    JObject.ReadFrom(Text01);
                    Message(text01);
                end;
            }
            action("Import Advanced Rec")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Advanced Rec', comment = 'ESP="Importar Rec Avanzado"';
                Image = Import;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Customer: Record Customer;
                    AdvancedMgtJson: Codeunit "Advanced Mgt. Json";
                begin
                    Customer := AdvancedMgtJson.UploadJson2Rec(Rec);
                    Message(Customer.Name);
                end;
            }
        }
    }
}