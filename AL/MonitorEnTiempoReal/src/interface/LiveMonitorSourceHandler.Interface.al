interface "Live Monitor Source Handler"
{
    /// <summary>
    /// Devuelve el título de la fuente, para mostrarlo en la cabecera del monitor.
    /// </summary>
    procedure GetCaption(): Text;

    /// <summary>
    /// Rellena el buffer temporal con la foto actual de lo que se está monitorizando.
    /// Se ejecuta dentro de una sesión hija de SOLO LECTURA: aquí no se puede escribir
    /// en base de datos, sólo leer y volcar el resultado en el buffer temporal.
    /// </summary>
    procedure BuildSnapshot(var TempLiveMonitorBuffer: Record "Live Monitor Buffer" temporary);
}
