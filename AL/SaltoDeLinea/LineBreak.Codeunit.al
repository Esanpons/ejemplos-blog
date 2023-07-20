codeunit 50000 "Line Break"
{

    trigger OnRun()
    begin
        Message('Texto inicial: ' + NewLineBreak() + 'Texto final');
    end;

    procedure NewLineBreak() ExitValue: Text
    var
        Char13: Char;
        Char10: Char;
    begin
        Char13 := 13;
        Char10 := 10;
        ExitValue := FORMAT(Char13) + FORMAT(Char10);
    end;
}