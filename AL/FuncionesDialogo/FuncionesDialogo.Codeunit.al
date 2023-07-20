codeunit 70101 "Funciones Dialogo"
{


    procedure EjecuteConfirm() ReturnValue: Boolean
    begin
        If Confirm('¿Está seguro de que desea eliminar este registro?') Then begin
            // El usuario ha hecho clic en "Sí"
            // Realiza la acción de eliminación aquí
            ReturnValue := true;
        end else begin
            // El usuario ha hecho clic en "No"
            // Cancela la acción de eliminación aquí
            ReturnValue := false;
        end;

    end;

    procedure EjecuteError()
    begin
        Error('No se pudo completar la operación debido a un error en el sistema. Por favor, inténtelo de nuevo más tarde.');
    end;


    procedure EjecuteMessage()
    begin
        Message('El registro se ha guardado correctamente.');
    end;


    procedure EjecuteStrMenu() ReturnValue: Integer;
    begin
        ReturnValue := StrMenu('Opción 1,Opción 2,Opción 3', 0, 'Seleccione una opción:');
    end;

    procedure CombinacionDeFunciones()
    var
        SelOption: Integer;
    begin

        If Confirm('¿Está seguro de que desea realizar esta acción?') Then begin
            // El usuario ha hecho clic en "Sí"
            // Realiza la acción aquí
            Message('La acción se ha realizado correctamente.');
        end else begin
            // El usuario ha hecho clic en "No"
            // Muestra un mensaje de error
            Error('La acción ha sido cancelada.');
        end;

        SelOption := StrMenu('Eliminar registro,Editar registro,Cancelar', 0, 'Seleccione una opción:');

        case SelOption of
            1:
                begin
                    // El usuario ha seleccionado "Eliminar registro"
                    If Confirm('¿Está seguro de que desea eliminar este registro?') Then begin
                        // El usuario ha hecho clic en "Sí"
                        // Realiza la acción de eliminación aquí
                        Message('El registro ha sido eliminado correctamente.');
                    end else begin
                        // El usuario ha hecho clic en "No"
                        // Muestra un mensaje de error
                        Error('La eliminación del registro ha sido cancelada.');
                    end;
                end;
            2:
                begin
                    // El usuario ha seleccionado "Editar registro"
                    // Realiza la acción de edición aquí
                    Message('El registro ha sido editado correctamente.');
                end;
            3:
                begin
                    // El usuario ha seleccionado "Cancelar" o ha cerrado el menú desplegable
                    // No se realiza ninguna acción
                    Message('La acción ha sido cancelada.');
                end;
        end;



    end;
}