codeunit 50001 "RecRef And FieldRef"
{
    trigger OnRun()
    begin
        Customer.Get('10000');
        Message(StrSubstNo(txt01Lbl, Customer.Name));


        ModificarValorDeCualquierCampoDesDeUnaTablaEspecifica(Customer, Customer.FieldNo(Name), txt02Lbl);
        TxtResult := DevolverValorDeCualquierCampoDesDeUnaTablaEspecifica(Customer, Customer.FieldNo(Name));
        Message(StrSubstNo(txt03Lbl, TxtResult));


        BooResult := BuscarRetornarElValorDeUnCampoAtravesDeIdDeTabla(18, Customer.FieldNo("No."), '10000..20000');
        Message(StrSubstNo(txt04Lbl, format(BooResult)));
    end;


    local procedure ModificarValorDeCualquierCampoDesDeUnaTablaEspecifica(RecVariant: Variant; FieldNo: Integer; VariantValue: Variant)
    begin
        Clear(MyRecordRef);
        Clear(MyFieldRef);

        MyRecordRef.GetTable(RecVariant);
        MyFieldRef := MyRecordRef.Field(FieldNo);
        MyFieldRef.Validate(VariantValue);
        MyRecordRef.Modify(true);
    end;

    local procedure DevolverValorDeCualquierCampoDesDeUnaTablaEspecifica(RecVariant: Variant; FieldNo: Integer): Text
    begin
        Clear(MyRecordRef);
        Clear(MyFieldRef);

        MyRecordRef.GetTable(RecVariant);
        MyFieldRef := MyRecordRef.Field(FieldNo);

        exit(format(MyFieldRef.Value));

    end;

    local procedure BuscarRetornarElValorDeUnCampoAtravesDeIdDeTabla(IdTable: Integer; FieldNo: Integer; FilterValueText: Text): Boolean
    begin
        Clear(MyRecordRef);
        Clear(MyFieldRef);

        MyRecordRef.Open(IdTable);
        MyFieldRef := MyRecordRef.Field(FieldNo);
        MyFieldRef.SetFilter(FilterValueText);

        exit(MyRecordRef.FindFirst());
    end;

    var
        Customer: Record "Customer";
        MyRecordRef: RecordRef;
        MyFieldRef: FieldRef;
        TxtResult: Text;
        BooResult: Boolean;
        txt01Lbl: Label 'First Msg: client name is: %1', Comment = 'ESP="Primer Msg: el nombre del cliente es: %1"';
        txt02Lbl: Label 'New name', Comment = 'ESP="Nuevo nombre"';
        txt03Lbl: Label 'Second Msg: client name is: %1', Comment = 'ESP="Segundo Msg: el nombre del cliente es: %1"';
        txt04Lbl: Label 'After filtering, exists: %1', Comment = 'ESP="Despues de filtrar, existe: %1"';

}

