permissionset 50100 "PermissionSet"
{
    Assignable = true;
    Caption = 'PermissionSet', MaxLength = 30;
    Permissions =
        table "Setup Extension" = X,
        tabledata "Setup Extension" = RMID,
        codeunit "Setup Extension Mgt" = X,
        page "Setup Extension" = X;
}
