pageextension 60008 "Sales Order" extends "Sales Order"

{
    layout
    {
        addlast(factboxes)
        {
            part("Cascading Disc FactBox"; "Cascading Disc FactBox")
            {
                ApplicationArea = Suite;
                Provider = SalesLines;
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("Document No."),
                              "Line No." = field("Line No.");
            }
        }
    }
}
