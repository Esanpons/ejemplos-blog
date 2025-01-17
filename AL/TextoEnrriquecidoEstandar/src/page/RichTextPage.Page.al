page 50000 "RichTextPage"
{
    PageType = Card;
    SourceTable = "RichTextTable";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("RichText"; ValueText)
                {
                    ApplicationArea = All;
                    ExtendedDatatype = RichContent;
                    MultiLine = true;
                    ToolTip = 'Texto enriquecido con formato HTML';
                    Caption = 'Texto enriquecido con formato HTML';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        ValueText := Rec.GetRichText();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        Rec.SetRichText(ValueText);
    end;

    var
        ValueText: Text;
}