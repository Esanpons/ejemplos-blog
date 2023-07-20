codeunit 50000 "Mgt Calc. With Times"
{

    procedure SumTimes(ValueTime01: Time; ValueTime02: Time) ReturnValue: Time
    var
        ValueTime03: Time;
        ValueDuration01: Duration;
        ValueDuration02: Duration;
        ValueDuration03: Duration;
    begin
        ValueTime03 := 000000T;

        if (Format(ValueTime01) = '') or (Format(ValueTime02) = '') then
            exit(ValueTime03);

        ValueDuration01 := ValueTime01 - ValueTime03;
        ValueDuration02 := ValueTime02 - ValueTime03;

        ValueDuration03 := ValueDuration01 + ValueDuration02;
        ReturnValue := ValueTime03 + ValueDuration03;
        ReturnValue := FormatTime(ReturnValue);
    end;


    // ValueTime01 := valor grande y ValueTime02 := valor pequeño
    procedure SubstractTimes(ValueTime01: Time; ValueTime02: Time) ReturnValue: Time
    var
        ValueTime03: Time;
        ValueDuration: Duration;
    begin
        ValueTime03 := 000000T;

        if (Format(ValueTime01) = '') or (Format(ValueTime02) = '') then
            exit(ValueTime03);

        ValueDuration := ValueTime01 - ValueTime02;
        ReturnValue := ValueTime03 + ValueDuration;
        ReturnValue := FormatTime(ReturnValue);
    end;

    local procedure FormatTime(ValueTime: Time) ReturnValueTime: Time
    var
        ValueText: Text;
    begin
        ValueText := Format(ValueTime, 0, '<Hours24>.<Minutes,2>.<Seconds,2>');
        Evaluate(ReturnValueTime, ValueText);
    end;

    procedure ConvertTimeToDecimal(ValueTime: Time) ReturnValue: Decimal
    begin
        if format(ValueTime) = '' then
            exit(0);

        ReturnValue := ValueTime - 000000T;
        ReturnValue := ReturnValue / 3600000;
    end;

    procedure ConvertDecimalToTime(ValueDecimal: Decimal) ReturnValue: Time
    var
        ValueDuration: Duration;
        ValueTime: Time;
    begin
        ValueDecimal := Round(ValueDecimal, 0.00001);
        ValueDuration := ValueDecimal * 3600000;
        ValueTime := 000000T;

        ReturnValue := ValueTime + ValueDuration;
        ReturnValue := FormatTime(ReturnValue);
    end;
}