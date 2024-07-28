codeunit 60003 "List And Dictionary"
{
    procedure SimpleList()
    var
        Customer: Record Customer;
        ListCustomer: List of [Code[20]];
        CustomerNo: Code[20];
    begin
        //Función simple para llenar y recorrer un list simple
        Clear(ListCustomer);
        Customer.Reset();
        if Customer.FindSet() then
            repeat
                ListCustomer.Add(Customer."No.");
            until Customer.Next() = 0;

        foreach CustomerNo in ListCustomer do
            Message(CustomerNo);

    end;

    procedure SimpleDictionary()
    var
        Customer: Record Customer;
        DicCustomer: Dictionary of [Code[20], Text[100]];
        CustomerNo: Code[20];
        CustomerName: Text[100];
    begin
        //Función simple para llenar y recorrer un dictionary simple
        Clear(DicCustomer);
        Customer.Reset();
        if Customer.FindSet() then
            repeat
                DicCustomer.Add(Customer."No.", Customer.Name);
            until Customer.Next() = 0;

        foreach CustomerNo in DicCustomer.Keys() do begin
            CustomerName := DicCustomer.Get(CustomerNo);
            Message(CustomerNo + ': ' + CustomerName);
        end;
    end;

    procedure MergeListWithDictionary()
    var
        Customer: Record Customer;
        ListDataCustomer: List of [Text];
        DicCustomer: Dictionary of [Code[20], List of [Text]];
        CustomerNo: Code[20];
    begin
        //Función más compleja para añadir y visualizar algunos datos de la tabla en un diccionario
        Clear(DicCustomer);
        Customer.Reset();
        if Customer.FindSet() then
            repeat
                Customer.CalcFields("Balance (LCY)");

                Clear(ListDataCustomer);
                ListDataCustomer.Add(Customer.Name);
                ListDataCustomer.Add(Customer."Name 2");
                ListDataCustomer.Add(Customer.County);
                ListDataCustomer.Add(Format(Customer."Balance (LCY)"));

                DicCustomer.Add(Customer."No.", ListDataCustomer);
            until Customer.Next() = 0;

        foreach CustomerNo in DicCustomer.Keys() do begin
            Clear(ListDataCustomer);
            DicCustomer.Get(CustomerNo, ListDataCustomer);
            Message(CustomerNo + ': ' + ListDataCustomer.Get(1) + ', ' + ListDataCustomer.Get(2) + ', ' + ListDataCustomer.Get(3));
        end;
    end;

    procedure AddDataFromEntireTable()
    var
        Customer: Record Customer;
        RecField: Record Field;
        RecRef: RecordRef;
        FieldRefe: FieldRef;
        DicDataCustomer: Dictionary of [Integer, Text];
        DicCustomer: Dictionary of [Code[20], Dictionary of [Integer, Text]];
        CustomerNo: Code[20];
        CustomerName: Text;
        CustomerName2: Text;
        Balance: Text;
    begin
        //Función compleja para añadir y visualizar todos los datos de la tabla en un diccionario 
        Clear(DicCustomer);
        Customer.Reset();
        if Customer.FindSet() then
            repeat
                Clear(DicDataCustomer);

                //recorremos la tabla de campos filtrado por la tabla de clientes para buscar cada dato que hay en el Record
                RecRef.GetTable(Customer);
                RecField.SetRange(RecField.TableNo, RecRef.Number);
                RecField.SetFilter(Type, '<>%1&<>%2&<>%3&<>%4&<>%5', RecField.Type::BLOB, RecField.Type::DateFormula, RecField.Type::GUID, RecField.Type::Media, RecField.Type::MediaSet);
                RecField.SetFilter(ObsoleteState, '<>%1&<>%2', RecField.ObsoleteState::Removed, RecField.ObsoleteState::Pending);
                if RecField.FindSet() then
                    repeat
                        FieldRefe := RecRef.Field(RecField."No.");

                        if RecField.Class = RecField.Class::FlowField then
                            FieldRefe.CalcField();

                        DicDataCustomer.Add(FieldRefe.Number, Format(FieldRefe.Value));
                    until RecField.Next() = 0;

                DicCustomer.Add(Customer."No.", DicDataCustomer);
            until Customer.Next() = 0;

        foreach CustomerNo in DicCustomer.Keys() do begin
            Clear(DicDataCustomer);
            DicCustomer.Get(CustomerNo, DicDataCustomer);

            DicDataCustomer.Get(Customer.FieldNo(Name), CustomerName);
            DicDataCustomer.Get(Customer.FieldNo("Name 2"), CustomerName2);
            DicDataCustomer.Get(Customer.FieldNo("Balance (LCY)"), Balance);

            Message(CustomerNo + ': ' + CustomerName + ', ' + CustomerName2 + ', ' + Balance);
        end;
    end;
}