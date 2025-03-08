page 81001 "Headline Aesva"
{
    Caption = 'Headline Aesva', Comment = 'ESP="Titular Aesva"';
    PageType = HeadlinePart;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field(GreetingText; RCHeadlinesPageCommon.GetGreetingText())
                {
                    ShowCaption = false;
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group(Control2)
            {
                ShowCaption = false;
                field(Aesva; Txt001Lbl)
                {
                    ShowCaption = false;
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        HyperLink('https://www.aesva.es/');
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        RCHeadlinesPageCommon.HeadlineOnOpenPage(Page::"Headline RC Project Manager");
    end;

    var
        RCHeadlinesPageCommon: Codeunit "RC Headlines Page Common";
        Txt001Lbl: Label 'Do you want to know more about Esteve Sanpons or Business Central?', Comment = 'ESP="¿Quieres saber más sobre Esteve Sanpons o Business Central?"';

}

