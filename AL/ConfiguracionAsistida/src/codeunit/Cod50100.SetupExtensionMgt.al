codeunit 50100 "Setup Extension Mgt"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', false, false)]
    local procedure C1990_OnRegisterAssistedSetup()
    var
        GuidedExperience: Codeunit "Guided Experience";
        TitleLbl: Label 'Setup Extension', Comment = 'ESP="Configuración extensión"';
        DescriptionLbl: Label 'This is an assisted setup test', Comment = 'ESP="Esto es una prueba de configuración asistida"';
    begin

        if not GuidedExperience.Exists(Enum::"Guided Experience Type"::"Assisted Setup", ObjectType::Page, Page::"Setup Extension") then
            GuidedExperience.InsertAssistedSetup(TitleLbl, //titulo de la aplicación
                                                 TitleLbl, //titulo corto 
                                                 DescriptionLbl, //Descripción
                                                 2, //cuantos minitos se espera que dure la configuración
                                                 ObjectType::Page, //Tipo de objeto que se espera abrir
                                                 Page::"Setup Extension", //Id del objeto a abrir
                                                 Enum::"Assisted Setup Group"::Extensions, //El grupo del asistente 
                                                 '', //aquí pondremos la URL del video si la hubiera
                                                 Enum::"Video Category"::Extensions,//categoria del video
                                                 'https://www.aesva.es'); // URL de ayuda 

        if not GuidedExperience.Exists(Enum::"Guided Experience Type"::"Assisted Setup", ObjectType::Page, Page::"Assited Setup") then
            GuidedExperience.InsertAssistedSetup(TitleLbl, //titulo de la aplicación
                                                 TitleLbl, //titulo corto 
                                                 DescriptionLbl, //Descripción
                                                 2, //cuantos minitos se espera que dure la configuración
                                                 ObjectType::Page, //Tipo de objeto que se espera abrir
                                                 Page::"Assited Setup", //Id del objeto a abrir
                                                 Enum::"Assisted Setup Group"::Extensions, //El grupo del asistente 
                                                 '', //aquí pondremos la URL del video si la hubiera
                                                 Enum::"Video Category"::Uncategorized,//categoria del video
                                                 'https://www.aesva.es'); // URL de ayuda 

    end;
}
