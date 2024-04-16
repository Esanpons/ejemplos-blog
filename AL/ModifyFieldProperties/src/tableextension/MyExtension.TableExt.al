tableextension 50100 "MyExtension" extends "Sales Header"
{
    fields
    {
        modify("Sell-to Customer No.")
        {
            Caption = 'Sell-to Vendor No.', Comment = 'ESP="Nº proveedor"';

        }

        modify("Sell-to Customer Name")
        {
            Caption = 'Sell-to Vendor Name', Comment = 'ESP="Nombre proveedor"';

        }
    }
}