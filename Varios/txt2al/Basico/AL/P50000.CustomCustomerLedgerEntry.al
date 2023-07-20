page 50000 "Custom Customer Ledger Entry"
{
    PageType = List;
    SourceTable = Table50000;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No.";"Entry No.")
                {
                    Editable = false;
                }
                field("Customer No.";"Customer No.")
                {
                }
                field("Customer Name";"Customer Name")
                {
                    Editable = false;
                }
                field("Is blocked";"Is blocked")
                {
                    Visible = false;
                }
                field(Comment;Comment)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec : Boolean);
    begin
        "Entry No." :=  NewLine();
    end;

    local procedure NewLine() ReturnValue : Integer;
    var
        CustomCustomerLedgerEntry : Record "50000";
    begin
        ReturnValue := 1;
        CustomCustomerLedgerEntry.RESET;
        IF CustomCustomerLedgerEntry.FINDLAST THEN
          ReturnValue := CustomCustomerLedgerEntry."Entry No." + 1;
    end;
}

