pageextension 50100 "Extension Customer" extends "Customer Card"
{
    trigger OnOpenPage()
    var
        EnTextoDejarSoloNumeros: Codeunit EnTextoDejarSoloNumeros;
        Text01: Text;
    begin
        Text01 := EnTextoDejarSoloNumeros.DejarSoloNumeros('AB12C3D4');
        Message(text01);
    end;
}