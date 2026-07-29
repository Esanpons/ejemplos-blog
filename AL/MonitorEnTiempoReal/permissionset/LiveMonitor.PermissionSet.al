permissionset 50150 "Live Monitor"
{
    Assignable = true;
    Caption = 'Live Monitor', MaxLength = 30, Comment = 'ESP="Monitor en vivo"';
    Permissions =
        table "Live Monitor Buffer" = X,
        tabledata "Live Monitor Buffer" = RIMD,
        page "Live Monitor" = X,
        codeunit "Live Monitor Mgt." = X,
        codeunit "Live Monitor PBT" = X,
        codeunit "Live Mon. Src. Job Queue" = X,
        codeunit "Live Mon. Src. Sessions" = X;
}
