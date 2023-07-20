pageextension 50101 VendorListExt extends "Vendor List"
{
    trigger OnOpenPage();
    var
        IsolatedStorageKey: text;
        IsolatedStorageValue: Text;
    begin
        IsolatedStorageKey := 'CustomerFirstNo';
        if IsolatedStorage.Contains(IsolatedStorageKey, DataScope::CompanyAndUser) then begin
            IsolatedStorage.Get(IsolatedStorageKey, DataScope::CompanyAndUser, IsolatedStorageValue);
            message(IsolatedStorageValue);
        end;
    end;
}