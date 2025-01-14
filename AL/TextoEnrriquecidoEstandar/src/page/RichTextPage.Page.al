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
                field("RichText"; Rec.GetRichText())
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
}