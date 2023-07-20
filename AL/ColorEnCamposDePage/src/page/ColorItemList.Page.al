page 50100 "Color Item List"
{
    PageType = List;
    SourceTable = Item;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Item List With Color', Comment = 'ESP="Lista de productos con color"';


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                    ApplicationArea = All;
                    StyleExpr = StyleExpresion;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                    ApplicationArea = All;
                    StyleExpr = StyleExpresion;
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                    ApplicationArea = All;
                    StyleExpr = StyleExpresion;
                }
                field(Inventory; Rec.Inventory)
                {
                    ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                    ApplicationArea = All;
                    StyleExpr = StyleExpresion;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        ColourStyleExpr: Enum ColourStyleExpr;
    begin
        StyleExpresion := '';

        if Rec.Inventory < 10 then
            StyleExpresion := format(Enum::"ColourStyleExpr"::Ambiguous);

        if Rec.Blocked then
            StyleExpresion := Format(ColourStyleExpr::Attention);
    end;

    var
        StyleExpresion: Text;
}

