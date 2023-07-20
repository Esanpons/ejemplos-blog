pageextension 50100 CustomerListExt extends "Customer List"
{
    trigger OnOpenPage();
    var
        IsolatedStorageKey: text;
    begin
        IsolatedStorageKey := 'CustomerFirstNo';
        if IsolatedStorage.Contains(IsolatedStorageKey, DataScope::CompanyAndUser) then
            IsolatedStorage.Delete(IsolatedStorageKey, DataScope::CompanyAndUser);
        IsolatedStorage.Set(IsolatedStorageKey, Format(Today) + ' ' + Rec."No.", DataScope::CompanyAndUser);
    end;
}