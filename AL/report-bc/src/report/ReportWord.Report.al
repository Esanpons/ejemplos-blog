report 50000 "Report Word"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    WordLayout = 'src/layout/ReportWord.docx';
    DefaultLayout = Word;
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;
    WordMergeDataItem = Customer;


    dataset
    {
        dataitem(Customer; Customer)
        {
            column(No; Customer."No.")
            {

            }
            column(Name; Customer.Name)
            {

            }
            column(Index; index)
            {

            }

            trigger OnAfterGetRecord()
            begin
                index += 1;
            end;
        }
    }

    var
        index: Integer;

}