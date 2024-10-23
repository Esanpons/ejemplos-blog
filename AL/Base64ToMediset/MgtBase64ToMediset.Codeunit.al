codeunit 50000 "Base64ToMediset"
{
    procedure Upload()
    var
        Base64Convert: Codeunit "Base64 Convert";
        DocInStream: InStream;
        FileName: Text;
        ValueText: Text;
    begin
        if not UploadIntoStream('', '', '', FileName, DocInStream) then
            exit;

        Clear(Base64Convert);
        ValueText := Base64Convert.ToBase64(DocInStream);
        Base64ToPicture(ValueText);
    end;

    procedure Base64ToPicture(Base64Text: Text)
    var
        Item: Record Item;
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        DocOutStream: OutStream;
        DocInStream: InStream;
    begin
        Clear(TempBlob);
        Clear(Base64Convert);
        Clear(DocOutStream);
        Clear(DocInStream);

        TempBlob.CreateOutStream(DocOutStream);
        Base64Convert.FromBase64(Base64Text, DocOutStream);
        TempBlob.CreateInStream(DocInStream);

        Item.FindFirst();
        Clear(Item."picture");
        Item."picture".ImportStream(DocInStream, 'sign', 'image/jpeg');
        Item.Modify();
    end;

    local procedure GetPictureCompanyInformationBase64() ReturnValue: Text
    var
        CompanyInformation: Record "Company Information";
        Base64Convert: Codeunit "Base64 Convert";
        InStream: InStream;
    begin
        Clear(InStream);
        Clear(Base64Convert);

        CompanyInformation.GetRecordOnce();
        CompanyInformation.CalcFields(Picture);
        CompanyInformation.Picture.CreateInStream(InStream);
        ReturnValue := Base64Convert.ToBase64(InStream);
    end;

}