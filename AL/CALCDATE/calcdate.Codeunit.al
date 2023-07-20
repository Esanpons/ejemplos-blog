codeunit 50000 "calcdate"
{

    procedure FinalTrimestre() NewDate: Boolean
    begin
        NewDate := CalcDate('<CQ>');
    end;

    procedure MenosUnYear(ValueDate: Date) NewDate: Boolean
    begin
        NewDate := CalcDate('<-1Y>', ValueDate);
    end;

    procedure UltimoDiaDelMesActual() NewDate: Boolean
    begin
        NewDate := CalcDate('<CM>');
    end;
}