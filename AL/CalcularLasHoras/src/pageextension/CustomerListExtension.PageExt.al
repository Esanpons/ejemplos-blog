pageextension 50000 "Customer List Extension" extends "Customer List"
{
    trigger OnOpenPage()
    var
        MgtCalcWithTimes: Codeunit "Mgt Calc. With Times";
        ValueTime01: Time;
        ValueTime02: Time;
        ValueTime03: Time;
        ValueDecimal: Decimal;
    begin
        ValueTime01 := 163000T;
        ValueTime02 := 183000T;

        ValueTime03 := MgtCalcWithTimes.SumTimes(ValueTime01, ValueTime02);

        Message('La suma es: ' + ValueTime03);

        ValueTime03 := MgtCalcWithTimes.SubstractTimes(ValueTime02, ValueTime01);

        Message('La resta es: ' + ValueTime03);

        ValueDecimal := MgtCalcWithTimes.ConvertTimeToDecimal(ValueTime03);

        Message('La diferencia en decimales es: ' + ValueDecimal);

        ValueTime03 := MgtCalcWithTimes.ConvertDecimalToTime(ValueDecimal);

        Message('La conversion de decimal a Time es: ' + ValueTime03);
    end;


}