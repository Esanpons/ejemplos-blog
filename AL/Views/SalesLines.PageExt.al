pageextension 60022 "Sales Lines" extends "Sales Lines"
{
    views
    {
        addfirst
        {
            view("Orders")
            {
                Caption = 'Orders', Comment = 'ESP="Pedidos"';
                OrderBy = ascending("Sell-to Customer No.", "Document No.");
                Filters = where("Document Type" = const("Order"));
                SharedLayout = false;

                layout
                {
                    movefirst(Control1; "Sell-to Customer No.")

                    modify("Document Type")
                    {
                        Visible = false;
                    }
                }
            }
            view("OrdersLastMonthOfTheYear")
            {
                Caption = 'Orders Last Month Of The Year', Comment = 'ESP="Pedidos ultimo mes del año"';
                OrderBy = ascending("Sell-to Customer No.", "Document No.");
                Filters = where("Document Type" = const("Order"), "Posting Date" = filter('<CY-CM>..<CY>'));
                SharedLayout = false;

                layout
                {
                    movefirst(Control1; "Sell-to Customer No.")

                    modify("Document Type")
                    {
                        Visible = false;
                    }
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        ChangeVisibleViewOrders();
    end;

    local procedure ChangeVisibleViewOrders()
    begin
        VisibleViewEmailConfirmation := false;
        if Rec.GetFilter("Document Type") = format(Rec."Document Type"::"Order") then
            VisibleViewEmailConfirmation := true;
    end;

    var
        VisibleViewEmailConfirmation: Boolean;
}