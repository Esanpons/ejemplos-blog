codeunit 70101 "Mgt. Dialogo De Proceso"
{


    trigger OnRun()
    var
        Customer: Record Customer;
    begin
        if Customer.FindSet() then begin
            ProcessDialogOpen(Customer.Count);

            repeat
                ProcessDialogUpdate();

            until Customer.Next() = 0;

            ProcessDialogClose();
        end;
    end;

    procedure ProcessDialogOpen(NewMaxCount: Integer)
    var
        Text001Lbl: Label 'Progress to %1: ', Comment = 'ESP="Progreso hasta %1: "';
        Text002Lbl: Label '#1#####', Locked = true;
        ValueText: Text;
    begin
        MyNext := 0;
        MaxCount := NewMaxCount;
        ValueText := StrSubstNo(Text001Lbl, MaxCount) + Text002Lbl;
        MyDialog.Open(ValueText, MyNext);
    end;

    procedure ProcessDialogUpdate()
    begin
        MyNext := MyNext + 1;
        MyDialog.Update();
    end;

    procedure ProcessDialogClose()
    begin
        MyDialog.Close();
    end;

    var
        MyDialog: Dialog;
        MyNext: Integer;
        MaxCount: Integer;
}