tableextension 60010 "Sales Line" extends "Sales Line"
{
    fields
    {
        field(50101; "Dto1"; Decimal)
        {
            Caption = 'Discount 1', Comment = 'ESP="Descuento 1"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ibacomMgtCascadingDiscounts: Codeunit "MgtCascadingDiscounts";
            begin
                Clear(ibacomMgtCascadingDiscounts);
                ibacomMgtCascadingDiscounts.CalcDiscountAndAddAmount(Rec, 1);
            end;
        }
        field(50102; "Dto2"; Decimal)
        {
            Caption = 'Discount 2', Comment = 'ESP="Descuento 2"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ibacomMgtCascadingDiscounts: Codeunit "MgtCascadingDiscounts";
            begin
                Clear(ibacomMgtCascadingDiscounts);
                ibacomMgtCascadingDiscounts.CalcDiscountAndAddAmount(Rec, 2);
            end;
        }
        field(50103; "Dto3"; Decimal)
        {
            Caption = 'Discount 3', Comment = 'ESP="Descuento 3"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ibacomMgtCascadingDiscounts: Codeunit "MgtCascadingDiscounts";
            begin
                Clear(ibacomMgtCascadingDiscounts);
                ibacomMgtCascadingDiscounts.CalcDiscountAndAddAmount(Rec, 3);
            end;
        }
    }
}