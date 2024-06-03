
codeunit 60003 "Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany();
    var
        MyAppInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(myAppInfo); //Obtener información sobre el módulo que se está ejecutando actualmente

        if myAppInfo.DataVersion = Version.Create(0, 0, 0, 0) then // A 'DataVersion' of 0.0.0.0 indicates a 'fresh/new' install
            HandleFreshInstall()
        else
            HandleReinstall(); // Si no es una instalación nueva, entonces estamos reinstalando la misma versión de la extensión
    end;

    local procedure HandleFreshInstall();
    begin
        //evento al instalar
    end;

    local procedure HandleReinstall();
    begin
        // Realice el trabajo necesario al reinstalar la misma versión de esta extensión en este inquilino.
        // Algunos usos posibles:
        // - Servicio de devolución de llamada/telemetría que indica que se reinstaló la extensión
        // - Trabajo de 'parcheo' de datos, por ejemplo, detectando si se han modificado nuevos registros 'base' mientras trabajaba 'sin conexión'.
        // - Configurar el mensaje de "bienvenida" para el próximo acceso del usuario.
    end;
}