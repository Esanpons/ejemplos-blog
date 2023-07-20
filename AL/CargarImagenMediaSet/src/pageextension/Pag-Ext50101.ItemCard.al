
pageextension 50101 "Item Card" extends "Item Card"
{
    layout
    {
        addlast(Item)
        {
            part("CardPicture"; "CarPart Picture")
            {
                ApplicationArea = All;
                Caption = ' ';
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        CurrPage."CardPicture".Page.SetParams(Rec, Rec.FieldNo(Picture));
    end;
}
