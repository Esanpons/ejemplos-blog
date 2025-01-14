page 51001 "Setup Table Migr. InterCompany"
{
    ApplicationArea = All;
    Caption = 'Setup Of Tables To Be Migrated Between Companies', Comment = 'ESP="Configuración tablas a migrar entre empresas"';
    PageType = List;
    SourceTable = "Setup Table Migr. InterCompany";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Id Table"; Rec."Id Table")
                {
                    ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                    ApplicationArea = All;
                }
                field("Name Table"; Rec."Name Table")
                {
                    ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ExportJsonTables)
            {
                ApplicationArea = All;
                Caption = 'Export Data', Comment = 'ESP="Exportar datos"';
                ToolTip = 'Export Data', Comment = 'ESP="Exportar datos"';
                Image = Export;

                trigger OnAction()
                var
                    SetupTableMigrInterCompany: Record "Setup Table Migr. InterCompany";
                begin
                    CurrPage.SetSelectionFilter(SetupTableMigrInterCompany);
                    Rec.ExportJsonTables(SetupTableMigrInterCompany);
                end;
            }
            action(ImportJsonTables)
            {
                ApplicationArea = All;
                Caption = 'Import Data', Comment = 'ESP="Importar datos"';
                ToolTip = 'Import Data', Comment = 'ESP="Importar datos"';
                Image = Import;

                trigger OnAction()
                begin
                    Rec.ImportJsonTables();
                end;
            }
        }
        area(Promoted)
        {
            actionref(ExportJsonTables_Promoted; ExportJsonTables) { }
            actionref(ImportJsonTables_Promoted; ImportJsonTables) { }
        }
    }

}
