codeunit 50001 "ConvertImage"
{
    procedure ConvertItemPictureToBase64(Item: Record Item): Text
    var
        TenantMedia: Record "Tenant Media";
        Base64Convert: Codeunit "Base64 Convert";
        ImageBase64: Text;
        ImgInStream: InStream;
    begin
        TenantMedia.Get(Rec.Picture.Item(1));

        TenantMedia.CalcFields(Content);

        TenantMedia.Content.CreateInStream(ImgInStream);

        ImageBase64 := Base64Convert.ToBase64(ImgInStream);
        exit(ImageBase64);
    end;
}