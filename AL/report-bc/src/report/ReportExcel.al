report 50100 "ReportExcel"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = LayoutExcel;
    ExcelLayoutMultipleDataSheets = true;
    Caption = 'Sales Invoice', Comment = 'ESP="Factura de venta"';

    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";

            column(CustAddr1_SalesInvoiceHeader; CustAddr[1]) { }
            column(CustAddr2_SalesInvoiceHeader; CustAddr[2]) { }
            column(CustAddr3_SalesInvoiceHeader; CustAddr[3]) { }
            column(CustAddr4_SalesInvoiceHeader; CustAddr[4]) { }
            column(CustAddr5_SalesInvoiceHeader; CustAddr[5]) { }
            column(CustAddr6_SalesInvoiceHeader; CustAddr[6]) { }
            column(CustAddr7_SalesInvoiceHeader; CustAddr[7]) { }
            column(CustAddr8_SalesInvoiceHeader; CustAddr[8]) { }
            column(DocNo_SalesInvoiceHeader; SalesInvoiceHeader."No.") { }
            column(PostingDate_SalesInvoiceHeader; SalesInvoiceHeader."Posting Date") { }

            dataitem(SalesInvoiceLine; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = SalesInvoiceHeader;

                column(No_SalesInvoiceLine; SalesInvoiceLine."No.") { }
                column(Description_SalesInvoiceLine; SalesInvoiceLine.Description) { }
                column(Quantity_SalesInvoiceLine; SalesInvoiceLine.Quantity) { }
                column(UnitPrice_SalesInvoiceLine; SalesInvoiceLine."Unit Price") { }
                column(Amount_SalesInvoiceLine; SalesInvoiceLine.Amount) { }
                column(AmountVAT_SalesInvoiceLine; SalesInvoiceLine."Amount Including VAT" - SalesInvoiceLine."VAT Base Amount") { }
                column(AmountIncludingVAT_SalesInvoiceLine; SalesInvoiceLine."Amount Including VAT") { }

            }

            #region triggers Header
            trigger OnAfterGetRecord()
            var
                Language: Codeunit Language;
                FormatAddress: Codeunit "Format Address";
            begin
                Clear(Language);
                CurrReport.Language := Language.GetLanguageIdOrDefault(SalesInvoiceHeader."Language Code");

                Clear(FormatAddress);
                FormatAddress.SalesInvBillTo(CustAddr, SalesInvoiceHeader);
            end;
            #endregion
        }

        dataitem(CompanyInformation; "Company Information")
        {
            column(CompanyInFormation_Name; CompanyInFormation.Name) { }
            column(CompanyInFormation_Address; CompanyInFormation.Address) { }
            column(CompanyInFormation_City; CompanyInFormation.City) { }
            column(CompanyInFormation_PostCode; CompanyInFormation."Post Code") { }
            column(CompanyInFormation_County; CompanyInFormation.County) { }
            column(CompanyInFormation_CountryName; CompanyInFormationCountryName) { }

            trigger OnAfterGetRecord()
            var
                BankAccount: Record "Bank Account";
            begin
                if CountryRegion.Get(CompanyInFormation."Country/Region Code") then
                    CompanyInFormationCountryName := CountryRegion.Name
                else
                    CompanyInFormationCountryName := CompanyInFormation."Country/Region Code";
            end;
        }
    }

    rendering
    {
        layout(LayoutExcel)
        {
            Type = Excel;
            LayoutFile = './src/report/layouts/ReportExcel.xlsx';
        }
    }

    labels
    {
        #region Labels para la factura
        CompanyLbl = 'Company', Comment = 'ESP="Empresa"';
        CustomerLbl = 'Customer', Comment = 'ESP="Cliente"';
        DateLbl = 'Date', Comment = 'ESP="Fecha"';
        PartNoLbl = 'Part Number', Comment = 'ESP="Referencia"';
        DescriptionLbl = 'Description', Comment = 'ESP="Descripción"';
        QtyLbl = 'Quantity', Comment = 'ESP="Cantidad"';
        UnitPriceLbl = 'Unit price', Comment = 'ESP="Precio unitario"';
        TotalAmountLbl = 'Total amount', Comment = 'ESP="Importe total"';
        VatLbl = 'VAT:', Comment = 'ESP="IVA:"';
        TotalInvoiceLbl = 'Total Invoice:', Comment = 'ESP="Total Factura"';
        BankDetailsLbl = 'Bank details:', Comment = 'ESP="Detalles banco:"';
        #endregion
    }

    var
        CountryRegion: Record "Country/Region";
        CompanyInFormationCountryName: Text[50];
        CustAddr: array[8] of Text[50];

}