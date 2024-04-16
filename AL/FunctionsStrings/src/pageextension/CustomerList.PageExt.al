pageextension 50100 "Customer List" extends "Customer List"
{
    trigger OnOpenPage()
    var
        FunctionsString: Codeunit "FunctionsString";
    begin
        FunctionsString.Run();
    end;
}