table 50000 "RichTextTable"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "ID"; Integer)
        {
            DataClassification = CustomerContent;
        }

        field(2; "RichText"; BLOB)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "ID")
        {
            Clustered = true;
        }
    }

    procedure SetRichText(value: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Rec."RichText");
        Rec."RichText".CreateOutStream(OutStream);
        OutStream.WriteText(value);
    end;

    procedure GetRichText(): Text
    var
        InStream: InStream;
        Result: Text;
    begin
        if Rec."RichText".HasValue then begin
            Rec."RichText".CreateInStream(InStream);
            InStream.ReadText(Result);
        end;
        exit(Result);
    end;
}