page 90020 "Table MetadataMGS"
{
    ApplicationArea = All;
    Caption = 'Table Metadata';
    PageType = List;
    SourceTable = "Table Metadata";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Caption; Rec.Caption)
                {
                    ToolTip = 'Specifies the value of the Caption field.';
                    ApplicationArea = All;
                }
                field(CompressionType; Rec.CompressionType)
                {
                    ToolTip = 'Specifies the value of the CompressionType field.';
                    ApplicationArea = All;
                }
                field(DataCaptionFields; Rec.DataCaptionFields)
                {
                    ToolTip = 'Specifies the value of the DataCaptionFields field.';
                    ApplicationArea = All;
                }
                field(DataClassification; Rec."DataClassification")
                {
                    ToolTip = 'Specifies the value of the DataClassification field.';
                    ApplicationArea = All;
                }
                field(DataIsExternal; Rec.DataIsExternal)
                {
                    ToolTip = 'Specifies the value of the DataIsExternal field.';
                    ApplicationArea = All;
                }
                field(DataPerCompany; Rec.DataPerCompany)
                {
                    ToolTip = 'Specifies the value of the DataPerCompany field.';
                    ApplicationArea = All;
                }
                field(DrillDownPageId; Rec.DrillDownPageId)
                {
                    ToolTip = 'Specifies the value of the DrillDownPageId field.';
                    ApplicationArea = All;
                }
                field(ExternalName; Rec.ExternalName)
                {
                    ToolTip = 'Specifies the value of the ExternalName field.';
                    ApplicationArea = All;
                }
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.';
                    ApplicationArea = All;
                }
                field(LinkedObject; Rec.LinkedObject)
                {
                    ToolTip = 'Specifies the value of the LinkedObject field.';
                    ApplicationArea = All;
                }
                field(LookupPageID; Rec.LookupPageID)
                {
                    ToolTip = 'Specifies the value of the LookupPageID field.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the names of the available Windows languages.';
                    ApplicationArea = All;
                }
                field(ObsoleteReason; Rec.ObsoleteReason)
                {
                    ToolTip = 'Specifies the value of the ObsoleteReason field.';
                    ApplicationArea = All;
                }
                field(ObsoleteState; Rec.ObsoleteState)
                {
                    ToolTip = 'Specifies the value of the ObsoleteState field.';
                    ApplicationArea = All;
                }
                field(PasteIsValid; Rec.PasteIsValid)
                {
                    ToolTip = 'Specifies the value of the PasteIsValid field.';
                    ApplicationArea = All;
                }
                field(ReplicateData; Rec.ReplicateData)
                {
                    ToolTip = 'Specifies the value of the ReplicateData field.';
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.';
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                    ApplicationArea = All;
                }
                field(TableType; Rec.TableType)
                {
                    ToolTip = 'Specifies the value of the TableType field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
