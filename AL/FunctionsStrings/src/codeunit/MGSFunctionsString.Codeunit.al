codeunit 50100 "MGS FunctionsString"
{
    trigger OnRun()
    begin
        //Example_StrSubstNo();
        //Example_StrPos();
        //Example_StrLen();
        //Example_IncStr();
        //Example_CopyStr();
        //Example_MaxStrLen();
        //Example_PadStr();
        //Example_DelChr();
        //Example_StrCheckSum();
        //Example_ConvertStr();
        //Example_LowerCase();
        //Example_UpperCase();
        //Example_SelectStr();
        //Example_DelStr();
        Example_InsStr();

    end;

    local procedure Example_StrSubstNo()
    var
        Customer: Record Customer;
        MyTxt: Text;
        MyLbl: Label 'Customer number %1 has name %2',
            Comment = 'ESP="El número de cliente %1 tiene el nombre %2"';
    begin
        Customer.get('10000');
        MyTxt := StrSubstNo(MyLbl, Customer."No.", Customer.Name);
        Message(MyTxt);
    end;

    local procedure Example_StrPos()
    var
        Customer: Record Customer;
        MyInt: Integer;
        MyLbl: Label 'S.A.', Locked = true;
        MyMsgLbl: Label 'The text "%1" starts at position %2, from client name: %3',
            Comment = 'ESP="El texto "%1" empieza en la posición %2, del nombre de cliente: %3"';
    begin
        Customer.get('10000');
        MyInt := StrPos(Customer.Name, MyLbl);
        Message(MyMsgLbl, MyLbl, Format(MyInt), Customer.Name);
    end;

    local procedure Example_StrLen()
    var
        Customer: Record Customer;
        MyInt: Integer;
        MyMsgLbl: Label 'The text "%1", has %2 characters.',
            Comment = 'ESP="El texto "%1", tiene %2 caracteres."';
    begin
        Customer.get('10000');
        MyInt := StrLen(Customer.Name);
        Message(MyMsgLbl, Customer.Name, Format(MyInt));
    end;

    local procedure Example_IncStr()
    var
        MyTxt: Text;
        MyLbl: Label 'There are 99 Bottles.',
            Comment = 'ESP="Hay 99 Botellas."';
        MyMsgLbl: Label 'Initial text was: "%1" and new text is: "%2"',
            Comment = 'ESP="El texto Inicial era: "%1" y el nuevo texto es: "%2""';
    begin
        MyTxt := IncStr(MyLbl);
        Message(MyMsgLbl, MyLbl, MyTxt);
    end;

    local procedure Example_CopyStr()
    var
        Customer: Record Customer;
        MyTxt: Text;
        MyMsgLbl: Label 'Initial text was: "%1" and new text is: "%2"',
            Comment = 'ESP="El texto Inicial era: "%1" y el nuevo texto es: "%2""';
    begin
        Customer.get('10000');
        MyTxt := CopyStr(Customer.Name, 5, 12);
        Message(MyMsgLbl, Customer.Name, MyTxt);
    end;

    local procedure Example_MaxStrLen()
    var
        Customer: Record Customer;
        MyInt: Integer;
        MyMsgLbl: Label 'The text "%1", has %2 maximum capacity.',
            Comment = 'ESP="El texto "%1", tiene %2 capacidad maxima."';
    begin
        Customer.get('10000');
        MyInt := MaxStrLen(Customer.Name);
        Message(MyMsgLbl, Customer.Name, MyInt);
    end;

    local procedure Example_PadStr()
    var
        Customer: Record Customer;
        My1Txt: Text;
        My2Txt: Text;
        MyMsg1Lbl: Label 'The original text is: "%1".\',
            Comment = 'ESP="El texto original es: "%1".\"';
        MyMsg2Lbl: Label 'The result of the first example is: "%2".\',
            Comment = 'ESP="El resultado del primer ejemplo es: "%2".\"';
        MyMsg3Lbl: Label 'The result of the second example is: "%3".',
            Comment = 'ESP=" El resultado del segundo ejemplo es: "%3"."';
    begin
        Customer.get('10000');
        My1Txt := PadStr(Customer."No.", 2);
        My2Txt := PadStr(Customer."No.", 15, '0');
        Message(MyMsg1Lbl + MyMsg2Lbl + MyMsg3Lbl, Customer."No.", My1Txt, My2Txt);
    end;

    local procedure Example_DelChr()
    var
        Customer: Record Customer;
        MyTxt: Text;
        WhereLbl: Label '=', Locked = true;
        WhichLbl: Label 'D', Locked = true;
        MyMsg1Lbl: Label 'The original text is: "%1".\',
            Comment = 'ESP="El texto original es: "%1".\"';
        MyMsg2Lbl: Label 'The new text is: "%2".',
            Comment = 'ESP="El nuevo texto es: "%2"."';
    begin
        Customer.get('10000');
        MyTxt := DelChr(Customer.Name, WhereLbl, WhichLbl);
        Message(MyMsg1Lbl + MyMsg2Lbl, Customer.Name, MyTxt);
    end;

    local procedure Example_StrCheckSum()
    var
        MyInt: Integer;
        Modulus: Integer;
        NumLbl: Label '4378', Locked = true;
        WeighLbl: Label '1234', Locked = true;

        MyMsg1Lbl: Label 'The original number is: %1.\',
            Comment = 'ESP="El número original es: %1.\"';
        MyMsg2Lbl: Label 'The result of the checksum is: %2.',
            Comment = 'ESP="El resultado de la verificación de suma es: %2."';
    begin
        Modulus := 7;
        MyInt := StrCheckSum(NumLbl, WeighLbl, Modulus);
        Message(MyMsg1Lbl + MyMsg2Lbl, NumLbl, format(MyInt));
    end;

    local procedure Example_ConvertStr()
    var
        Customer: Record Customer;
        My1Lbl: Label 'GDE', Locked = true;
        My2Lbl: Label 'gde', Locked = true;
        MyTxt: Text;
        MyMsg1Lbl: Label 'The original text is: %1.\',
            Comment = 'ESP="El texto original es: %1.\"';
        MyMsg2Lbl: Label 'The new text is: "%2".',
            Comment = 'ESP="El nuevo texto es: "%2"."';
    begin
        Customer.get('10000');
        MyTxt := ConvertStr(Customer.Name, My1Lbl, My2Lbl);
        Message(MyMsg1Lbl + MyMsg2Lbl, Customer.Name, MyTxt);
    end;

    local procedure Example_LowerCase()
    var
        Customer: Record Customer;
        MyTxt: Text;
        MyMsg1Lbl: Label 'The original text is: %1.\',
            Comment = 'ESP="El texto original es: %1.\"';
        MyMsg2Lbl: Label 'The new text is: "%2".',
            Comment = 'ESP="El nuevo texto es: "%2"."';
    begin
        Customer.get('10000');
        MyTxt := LowerCase(Customer.Name);
        Message(MyMsg1Lbl + MyMsg2Lbl, Customer.Name, MyTxt);
    end;

    local procedure Example_UpperCase()
    var
        Customer: Record Customer;
        MyTxt: Text;
        MyMsg1Lbl: Label 'The original text is: %1.\',
            Comment = 'ESP="El texto original es: %1.\"';
        MyMsg2Lbl: Label 'The new text is: "%2".',
            Comment = 'ESP="El nuevo texto es: "%2"."';
    begin
        Customer.get('10000');
        MyTxt := UpperCase(Customer.Name);
        Message(MyMsg1Lbl + MyMsg2Lbl, Customer.Name, MyTxt);
    end;

    local procedure Example_SelectStr()
    var
        MyTxt: Text;
        MyLbl: Label 'Esteve, Sanpons, Carballares', Locked = true;
        MyMsg1Lbl: Label 'The original text is: %1.\',
            Comment = 'ESP="El texto original es: %1.\"';
        MyMsg2Lbl: Label 'The new text is: "%2".',
            Comment = 'ESP="El nuevo texto es: "%2"."';
    begin
        MyTxt := SelectStr(2, MyLbl);
        Message(MyMsg1Lbl + MyMsg2Lbl, MyLbl, MyTxt);
    end;

    local procedure Example_DelStr()
    var
        Customer: Record Customer;
        MyTxt: Text;
        MyMsg1Lbl: Label 'The original text is: %1.\',
            Comment = 'ESP="El texto original es: %1.\"';
        MyMsg2Lbl: Label 'The new text is: "%2".',
            Comment = 'ESP="El nuevo texto es: "%2"."';
    begin
        Customer.get('10000');
        MyTxt := DelStr(Customer.Name, 1, 4);
        Message(MyMsg1Lbl + MyMsg2Lbl, Customer.Name, MyTxt);
    end;

    local procedure Example_InsStr()
    var
        Customer: Record Customer;
        MyLbl: Label 's',
            Comment = 'ESP="es"';
        MyTxt: Text;
        MyMsg1Lbl: Label 'The original text is: %1.\',
            Comment = 'ESP="El texto original es: %1.\"';
        MyMsg2Lbl: Label 'The new text is: "%2".',
            Comment = 'ESP="El nuevo texto es: "%2"."';
    begin
        Customer.get('10000');
        MyTxt := InsStr(Customer.Name, MyLbl, 17);
        Message(MyMsg1Lbl + MyMsg2Lbl, Customer.Name, MyTxt);
    end;
}