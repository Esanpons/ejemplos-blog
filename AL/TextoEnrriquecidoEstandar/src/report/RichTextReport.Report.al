report 50000 "RichTextReport"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = DefaultLayout;

    dataset
    {
        dataitem("RichTextTable"; "RichTextTable")
        {
            column(RichTextContent; GetRichText())
            {
            }
        }
    }

    rendering
    {
        layout(DefaultLayout)
        {
            Type = RDLC;
            LayoutFile = '.\src\report\layouts\RichTextLayout.rdl';
        }
    }
}