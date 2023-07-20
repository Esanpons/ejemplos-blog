pageextension 50100 "MGS Customer List" extends "Customer List"
{
    trigger OnOpenPage()
    var
        MGSFunctionsString: Codeunit "MGS FunctionsString";
    begin
        MGSFunctionsString.Run();
    end;
}