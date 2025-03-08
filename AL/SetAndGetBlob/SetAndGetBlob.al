tableextension 58001 "SetAndGetBlob" extends "Customer"
{
    fields
    {

        field(58001; "Json Recived"; Blob)
        {
            Caption = 'Json', Comment = 'ESP="Json"';
            DataClassification = CustomerContent;
        }

    }

    procedure SetJsonRecived(NewValue: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Rec."Json Recived");
        Rec."Json Recived".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewValue);
        Rec.Modify();
    end;

    procedure GetJsonRecived() ReturnValue: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        Rec.CalcFields("Json Recived");
        Rec."Json Recived".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName(Rec."Json Recived")));
    end;
}
