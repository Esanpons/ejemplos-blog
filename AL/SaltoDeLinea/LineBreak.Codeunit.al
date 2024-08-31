codeunit 50000 "Line Break"
{
    trigger OnRun()
    begin
        Message('Texto inicial: ' + NewLineBreak() + 'Texto final');
    end;

    #region function salto de linea
    procedure LineBreak(QtyLineBreak: Integer) ReturnValue: Text
    var
        TypeHelper: Codeunit "Type Helper";
        i: Integer;
    begin
        ReturnValue := '';

        for i := 1 to QtyLineBreak do
            ReturnValue += TypeHelper.CRLFSeparator();
    end;

    procedure SaltoDeLinea() ReturnValue: Text
    var
        CR: Char;
        LF: Char;
    begin
        CR := 13;
        LF := 10;
        ReturnValue := FORMAT(CR) + FORMAT(LF);
    end;

    #endregion
}