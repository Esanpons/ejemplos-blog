table 50000 "Custom Customer Ledger Entry"
{
    CaptionML = ENU='Custom Customer Ledger Entry',
                ESP='Mov de cliente personalizado';

    fields
    {
        field(1;"Entry No.";Integer)
        {
            CaptionML = ENU='Entry No.',
                        ESP='Nº mov.';
        }
        field(2;"Customer No.";Code[20])
        {
            CaptionML = ENU='Customer No.',
                        ESP='Nº cliente';
            TableRelation = Customer.No.;

            trigger OnValidate();
            begin
                Customer.GET("Customer No.");
                "Customer Name" := Customer.Name;
            end;
        }
        field(3;"Customer Name";Code[20])
        {
            CaptionML = ENU='Customer Name',
                        ESP='Nombre cliente';
            TableRelation = Customer.Name WHERE (No.=FIELD(Customer No.));
            ValidateTableRelation = false;
        }
        field(4;"Is blocked";Boolean)
        {
            CalcFormula = Lookup(Customer.Blocked WHERE (No.=FIELD(Customer No.)));
            CaptionML = ENU='Is blocked',
                        ESP='Esta bloqueado';
            FieldClass = FlowField;
        }
        field(5;Comment;Text[250])
        {
            CaptionML = ENU='Comment',
                        ESP='Comentarios';
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Customer : Record "18";
}

