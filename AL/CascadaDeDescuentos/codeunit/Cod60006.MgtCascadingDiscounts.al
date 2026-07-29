codeunit 60006 "MgtCascadingDiscounts"
{
    procedure CalcDiscountAndAddAmount(var SalesLine: Record "Sales Line"; NumDiscount: Integer) ReturnValue: Decimal;
    var
        AmountDto: Decimal;
    begin
        if SalesLine."Dto1" = 0 then
            exit;

        SalesLine.TestField(Quantity);
        SalesLine.TestField("Unit Price");

        ReturnCurrentAmount(SalesLine, NumDiscount, AmountDto, ReturnValue, true);
        SalesLine.Validate(Amount, ReturnValue);
        SalesLine.Validate("Line Amount", ReturnValue);
    end;

    procedure RecalculateAllLine(var SalesLine: Record "Sales Line")
    var
        CurrentAmount: Decimal;
        AmountDto: Decimal;
    begin
        if SalesLine."Dto1" = 0 then
            exit;

        Clear(CurrentAmount);
        ReturnCurrentAmount(SalesLine, 3, AmountDto, CurrentAmount, true);
        SalesLine.Validate(Amount, CurrentAmount);
        SalesLine.Validate("Line Amount", CurrentAmount);
    end;

    procedure ReturnTotalAmountFromFactbox(var SalesLine: Record "Sales Line"; NumDiscount: Integer) ReturnValue: Decimal
    var
        AmountDto: Decimal;
    begin
        Clear(AmountDto);
        Clear(ReturnValue);

        if SalesLine."Dto1" = 0 then
            exit;

        ReturnCurrentAmount(SalesLine, NumDiscount, AmountDto, ReturnValue, false);
    end;

    procedure ReturnAmountFromFactbox(var SalesLine: Record "Sales Line"; NumDiscount: Integer) ReturnValue: Decimal
    var
        CurrentAmount: Decimal;
    begin
        Clear(CurrentAmount);
        Clear(ReturnValue);

        if SalesLine."Dto1" = 0 then
            exit;

        ReturnCurrentAmount(SalesLine, NumDiscount, ReturnValue, CurrentAmount, false);
    end;

    local procedure ReturnCurrentAmount(var SalesLine: Record "Sales Line"; NumDiscount: Integer; var AmountDto: Decimal; var CurrentAmount: Decimal; EjecuteTestFields: Boolean)
    begin
        CurrentAmount := SalesLine.Quantity * SalesLine."Unit Price";

        case NumDiscount of
            1:
                begin
                    if SalesLine."Dto1" = 0 then begin
                        SalesLine."Dto2" := 0;
                        SalesLine."Dto3" := 0;
                    end else
                        if EjecuteTestFields then
                            SalesLine.TestField("Dto1");

                    CalcCurrentAmount(SalesLine."Dto1", CurrentAmount, AmountDto);
                end;
            2:
                begin
                    if EjecuteTestFields then
                        SalesLine.TestField("Dto1");

                    if SalesLine."Dto2" = 0 then
                        SalesLine."Dto3" := 0
                    else
                        if EjecuteTestFields then
                            SalesLine.TestField("Dto2");

                    CalcCurrentAmount(SalesLine."Dto1", CurrentAmount, AmountDto);
                    CalcCurrentAmount(SalesLine."Dto2", CurrentAmount, AmountDto);
                end;
            3:
                begin
                    if EjecuteTestFields then begin
                        SalesLine.TestField("Dto1");
                        SalesLine.TestField("Dto2");

                        if SalesLine."Dto3" <> 0 then
                            SalesLine.TestField("Dto3");

                    end;

                    CalcCurrentAmount(SalesLine."Dto1", CurrentAmount, AmountDto);
                    CalcCurrentAmount(SalesLine."Dto2", CurrentAmount, AmountDto);
                    CalcCurrentAmount(SalesLine."Dto3", CurrentAmount, AmountDto);
                end;
        end;

    end;


    local procedure CalcCurrentAmount(Dto: Decimal; var CurrentAmount: Decimal; var AmountDto: Decimal)
    begin
        AmountDto := (CurrentAmount * Dto) / 100;
        CurrentAmount := CurrentAmount - AmountDto;
    end;

}