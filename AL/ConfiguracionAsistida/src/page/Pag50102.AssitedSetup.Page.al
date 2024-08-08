page 50102 "Assited Setup"
{
    PageType = NavigatePage;
    SourceTable = "Integer";
    SourceTableTemporary = true;
    Caption = 'Configuration wizard', Comment = 'ESP="Asistente de configuración"';

    layout
    {
        area(content)
        {
            group(Step1)
            {
                Description = 'este grupo es para la presentación del asistente de configuración';
                Visible = Step1Visible;

                group(Welcome)
                {
                    Caption = 'Welcome to the Configuration', Comment = 'ESP="Bienvenido a la configuración"';
                    group(group11)
                    {
                        Caption = '';
                        InstructionalText = 'Use this guide to get everything set up for your business.', Comment = 'ESP="Utilice esta guía para configurar todo lo necesario para su empresa."';
                    }
                }
                group("Let's go")
                {
                    Caption = 'Let is go', Comment = 'ESP="Vamos"';
                    group(group12)
                    {
                        Caption = '';
                        InstructionalText = 'Select Next to get started.', Comment = 'ESP="Seleccione Siguiente para comenzar."';
                    }
                }
            }

            group(Step2)
            {
                Description = 'este grupo es para las configuraciones necesarias. Se pueden hacer varios grupos de configuraciones.';
                Caption = 'Enter the necessary information', Comment = 'ESP="Entra la información necesaria"';
                Visible = Step2Visible;

                field("Maximum Date"; Rec."Maximum Date")
                {
                    Caption = 'Maximum Date', Comment = 'ESP="Fecha máxima"';
                    ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                    ApplicationArea = All;
                }
                field("Quantity of Days"; Rec."Quantity of Days")
                {
                    Caption = 'Quantity of Days', Comment = 'ESP="Cantidad de días"';
                    ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                    ApplicationArea = All;
                }
                field("Destination Warehouse"; Rec."Destination Warehouse")
                {
                    Caption = 'Destination Warehouse', Comment = 'ESP="Almacén de destino"';
                    ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                    ApplicationArea = All;
                }
            }

            group(Step3)
            {
                Description = 'este grupo es para la ventana final.';
                InstructionalText = 'Select Finish to save the settings.', Comment = 'ESP="Seleccione Finalizar para guardar las configuraciones."';
                Visible = Step3Visible;

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Back)
            {
                ApplicationArea = All;
                Caption = 'Back', Comment = 'ESP="Atrás"';
                Enabled = BackEnable;
                InFooterBar = true;
                Image = PreviousRecord;

                trigger OnAction()
                begin
                    NextStep(true);
                end;
            }
            action("Next")
            {
                ApplicationArea = All;
                Caption = 'Next', Comment = 'ESP="Siguiente"';
                Enabled = NextEnable;
                InFooterBar = true;
                Image = NextRecord;

                trigger OnAction()
                begin
                    NextStep(false);
                end;
            }
            action(Finish)
            {
                ApplicationArea = All;
                Caption = 'Finish', Comment = 'ESP="Finalizar"';
                Enabled = FinishEnable;
                InFooterBar = true;
                Image = Approve;

                trigger OnAction()
                begin
                    Finished();
                end;
            }
        }
    }

    trigger OnInit()
    begin
        EnableControls();

        if not SetupExtension.Get() then
            SetupExtension.Insert();

        TempSetupExtension.GetRecOrInsert();
        TempSetupExtension := SetupExtension;
    end;

    trigger OnClosePage()
    var
        GuidedExperience: Codeunit "Guided Experience";
    begin
        if (TempSetupExtension."Maximum Date" <> 0D) And (TempSetupExtension."Quantity of Days" <> 0) And (TempSetupExtension."Destination Warehouse" <> '') then
            GuidedExperience.CompleteAssistedSetup(ObjectType::Page, Page::"Assited Setup")
        else
            GuidedExperience.ResetAssistedSetup(ObjectType::Page, Page::"Assited Setup");
    end;


    local procedure NextStep(Backwards: Boolean)
    begin
        if Backwards then
            Step := Step - 1
        else
            Step := Step + 1;

        EnableControls();
    end;

    local procedure Finished()
    begin
        InsertRecSetup();
        CurrPage.Close();
    end;

    local procedure EnableControls()
    begin
        ResetControls();
        case Step of
            Step::Start:
                ShowStep1();
            Step::Fill:
                ShowStep2();
            Step::Finish:
                ShowStep3();
        end;
    end;

    local procedure ShowStep1()
    begin
        Step1Visible := true;
        BackEnable := false;
        NextEnable := true;
        FinishEnable := false;
    end;

    local procedure ShowStep2()
    begin
        Step2Visible := true;
        BackEnable := true;
        NextEnable := true;
        FinishEnable := false;
    end;

    local procedure ShowStep3()
    begin
        Step3Visible := true;
        BackEnable := true;
        NextEnable := false;
        FinishEnable := true;
    end;

    local procedure ResetControls()
    begin
        FinishEnable := false;
        BackEnable := true;
        NextEnable := true;
        Step1Visible := false;
        Step2Visible := false;
        Step3Visible := false;

    end;

    local procedure InsertRecSetup()
    begin
        SetupExtension.GetRecOrInsert();
        SetupExtension.TransferFields(TempSetupExtension);
        SetupExtension.Modify();
    end;

    var
        SetupExtension: Record "Setup Extension";
        TempSetupExtension: Record "Setup Extension" temporary;
        BackEnable: Boolean;
        NextEnable: Boolean;
        FinishEnable: Boolean;
        Step1Visible: Boolean;
        Step2Visible: Boolean;
        Step3Visible: Boolean;
        Step: Option Start,Fill,Finish;
}