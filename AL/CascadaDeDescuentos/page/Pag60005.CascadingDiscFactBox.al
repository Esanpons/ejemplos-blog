page 60005 "Cascading Disc FactBox"
{
    Caption = 'Cascading Discounts FactBox', Comment = 'ESP="Cuadro info. cascada descuentos"';
    PageType = CardPart;
    SourceTable = "Sales Line";

    layout
    {
        area(content)
        {
            group(Dto1)
            {
                ShowCaption = false;
                grid(mygrid01)
                {
                    ShowCaption = false;
                    GridLayout = Rows;

                    field(Discount1; Format(Rec."Dto1") + '%   ')
                    {
                        Caption = 'Discount 1', Comment = 'ESP="Descuento 1"';
                        ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                        ApplicationArea = All;
                    }
                    field(DiscountTotalAmount1; AmountDto(1))
                    {
                        Caption = '   Amount Dto ', Comment = 'ESP="   Importe Dto "';
                        ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                        ApplicationArea = All;
                    }

                }
            }
            group(Dto2)
            {
                ShowCaption = false;
                grid(mygrid02)
                {
                    ShowCaption = false;
                    GridLayout = Rows;

                    field(Discount2; Format(Rec."Dto2") + '%   ')
                    {
                        Caption = 'Discount 2', Comment = 'ESP="Descuento 2"';
                        ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                        ApplicationArea = All;
                    }
                    field(DiscountTotalAmount2; AmountDto(2))
                    {
                        Caption = '   Amount Dto ', Comment = 'ESP="   Importe Dto "';
                        ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                        ApplicationArea = All;
                    }

                }
            }
            group(Dto3)
            {
                ShowCaption = false;
                grid(mygrid03)
                {
                    ShowCaption = false;
                    GridLayout = Rows;

                    field(Discount3; Format(Rec."Dto3") + '%   ')
                    {
                        Caption = 'Discount 3', Comment = 'ESP="Descuento 3"';
                        ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                        ApplicationArea = All;
                    }
                    field(DiscountTotalAmount3; AmountDto(3))
                    {
                        Caption = '   Amount Dto ', Comment = 'ESP="   Importe Dto "';
                        ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                        ApplicationArea = All;
                    }

                }
            }

            group(EmptyGroup)
            {
                ShowCaption = false;
                field("Empty"; ' ---------------------- ')
                {
                    ShowCaption = false;
                    ApplicationArea = All;
                }
            }
            group(TotalGroup)
            {
                ShowCaption = false;
                field(Total; TotalAmountDto())
                {
                    Caption = 'Total', Locked = true;
                    ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                    ApplicationArea = All;
                }
            }
        }
    }

    local procedure AmountDto(NumDiscount: Integer) ReturnValue: Text
    begin
        ReturnValue := format(MgtCascadingDiscounts.ReturnAmountFromFactbox(Rec, NumDiscount)) + ' €';

    end;

    local procedure TotalAmountDto() ReturnValue: Text
    var
        ValueDec: Decimal;
    begin
        ValueDec := MgtCascadingDiscounts.ReturnAmountFromFactbox(Rec, 1) + MgtCascadingDiscounts.ReturnAmountFromFactbox(Rec, 2) + MgtCascadingDiscounts.ReturnAmountFromFactbox(Rec, 3);
        ReturnValue := Format(ValueDec) + '  €'
    end;

    var
        MgtCascadingDiscounts: Codeunit "MgtCascadingDiscounts";
}