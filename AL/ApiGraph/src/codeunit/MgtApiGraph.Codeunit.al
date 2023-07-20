codeunit 62000 "Mgt Api Graph"
{
    trigger OnRun()
    var
        URL: Text;
        JsonRespuesta: Text;
        UrlMailsUserLbl: Label 'https://graph.microsoft.com/v1.0/users/%1/mailFolders/inbox/messages?$count=true', Locked = true;
        FiltersURLLbl: Label '&$filter=isread%20eq%20false', Locked = true;
    begin
        //Añadir el dato extraido de Azure
        ClientID := '';
        ClientSecret := '';
        Tenant := '';
        UserID := '';

        URL := StrSubstNo(UrlMailsUserLbl, UserID);
        URL += FiltersURLLbl;

        AccessToken := GetTocken();
        Message('el token es: ' + AccessToken);

        JsonRespuesta := Connection(URL, 1, '');
        Message('El Json de respuesta es: ' + JsonRespuesta);
    end;

    local procedure GetTocken() AccessToken: text
    var
        OAuth2: Codeunit OAuth2;
        Scopes: List of [Text];
        URL: Text;
        ScopeLbl: Label 'https://graph.microsoft.com/.default', Locked = true;
        UrlTokenLbl: Label 'https://login.microsoftonline.com/%1/oauth2/v2.0/token', Locked = true;
    begin
        Clear(Scopes);
        clear(OAuth2);

        Scopes.Add(ScopeLbl);

        URL := StrSubstNo(UrlTokenLbl, Tenant);
        OAuth2.AcquireTokenWithClientCredentials(ClientID, ClientSecret, URL, '', Scopes, AccessToken);

    end;

    procedure Connection(URL: Text; TypeConection: Integer; BodyData: Text) ReturnValue: Text
    var
        HttpCliente: HttpClient;
        HttpResponseMessages: HttpResponseMessage;
        Authorization: Text;
        Success: Boolean;
        BearerLbl: Label 'Bearer %1', Locked = true;
        Txt01Err: Label 'Request was blocked by environment', Comment = 'ESP="La solicitud fue bloqueada por el entorno"';
        Txt02Err: Label 'Request to Business Central failed\%1 %2', Comment = 'ESP="Solicitud a Business Central fallida\%1 %2"';
        Txt03Err: Label 'Request to Business Central failed\%1', Comment = 'ESP="La solicitud a Business Central falló\%1"';
    begin
        if AccessToken = '' then
            AccessToken := GetTocken();

        Authorization := StrSubstNo(BearerLbl, AccessToken);

        HttpCliente.DefaultRequestHeaders().Add('Authorization', Authorization);
        HttpCliente.DefaultRequestHeaders.Add('Accept', 'application/json');
        Success := HttpCliente.Get(Url, HttpResponseMessages);

        if not Success then
            if HttpResponseMessages.IsBlockedByEnvironment then
                Error(Txt01Err)
            else
                Error(Txt03Err, GetLastErrorText());

        if not HttpResponseMessages.IsSuccessStatusCode then
            Error(Txt02Err, HttpResponseMessages.HttpStatusCode, HttpResponseMessages.ReasonPhrase);

        HttpResponseMessages.Content.ReadAs(ReturnValue);
    end;

    var
        AccessToken: Text;
        ClientID: Text;
        ClientSecret: Text;
        Tenant: Text;
        UserID: Text;





}