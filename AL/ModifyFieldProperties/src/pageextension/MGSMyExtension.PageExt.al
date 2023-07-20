pageextension 50100 "MGSMyExtension" extends "Sales Order"
{
    layout
    {
        modify("Sell-to Customer No.")
        {
            Caption = 'Sell-to Vendor No.', Comment = 'ESP="Nº proveedor"';
            trigger OnLookup(var Text: Text): Boolean
            var
                Vendor: Record Vendor;
                VendorList: Page "Vendor List";
            begin
                clear(VendorList);
                if VendorList.RunModal() = ACTION::OK then begin
                    VendorList.GetRecord(Vendor);
                    rec."Sell-to Customer No." := Vendor."No.";
                end;
            end;
        }
    }
}