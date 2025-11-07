pageextension 55204 "Customer Report Selections" extends "Customer Report Selections"
{
    // #Creado por Esteve Sanpons Carballares.
    // #https://github.com/Esanpons
    // #Se da acceso libre a modificar y utilizar este objeto libremente. Siempre y cuando se haga referencia al autor.

    layout
    {

        addafter("Use for Email Attachment")
        {
            field("jbcUT Language Code"; Rec."Language Code")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
        }
        addbefore("Use for Email Body")
        {
            field("jbcUT Mail Only Option"; Rec."Mail Only Option")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
            field("jbcUT Use for Email Subject"; Rec."Use for Email Subject")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;
            }
        }
        addbefore("Email Body Layout Description")
        {

            field("jbcUT Subject Layout Descr."; Rec."Email Subject Layout Descr.")
            {
                ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                ApplicationArea = All;

                trigger OnDrillDown()
                begin
                    Rec.LookupLayout_Subject();
                end;
            }
        }
    }
}