dotnet
{
    assembly(EjemploBasicoDLL)
    {
        type(EjemploBasicoDLL.Class.PruebasDLL; PruebasDLL)
        {

        }
    }
}


pageextension 70100 "CustomerListExt" extends "Customer List"
{
    trigger OnOpenPage();
    var
        BConPremPruebasDLL: DotNet PruebasDLL;
        TextoMensaje: Text;
    begin
        BConPremPruebasDLL := BConPremPruebasDLL.PruebasDLL();
        TextoMensaje := BConPremPruebasDLL.DevolverTexto('Esteve Sanpons');
        MESSAGE(TextoMensaje);
    end;
}