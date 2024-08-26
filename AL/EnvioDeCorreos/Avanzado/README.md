# Manual de Usuario: Envío de Correos

## Objetivo

Se requiere el desarrollo de un sistema de envío de correos personalizado que permita adaptar el asunto, el cuerpo del mensaje y los archivos adjuntos en varios idiomas. Esto debe parametrizarse en las selecciones de informe para que funcione de la manera más estándar posible.

## Manual de Usuario

### Configuraciones

#### Cuentas de correo electrónico

Es necesario configurar una cuenta de correo electrónico predeterminada, la cual debe ser una cuenta de la empresa para que funcione correctamente.

![Imagen 1](../img/image_9.png)

He añadido dos enlaces a tutoriales para configurar cuentas en Business Central:

- [Configurar cuenta de correo electrónico 365 en Business Central](#)
- [Configurar correo Gmail en Business Central](#)

### Selección de informes de venta

A continuación, se muestra un ejemplo de configuración para el envío de factura proforma, aunque se puede aplicar a cualquier tipo de documento deseado.

Se debe configurar el tipo y después el ID del informe como adjunto. Este suele ser el que se utiliza para imprimir y que se marcará como adjunto.

![Imagen 2](../img/image_1.png)

También deben informarse los informes para el asunto y cuerpo del mensaje.

![Imagen 2](../img/image_12.png)

En este caso, lo ideal es utilizar el mismo informe para obtener los datos en el layout. Se debe configurar el asunto y el cuerpo, y como opción, se puede establecer cada uno en un idioma diferente. Si se deja el idioma en blanco, se usará para todos los idiomas del documento.

#### Configuración del Asunto

Hacer clic en el campo de descripción de diseño del asunto de correo electrónico.

![Imagen 2](../img/image_8.png)

Crear uno nuevo.

![Imagen 2](../img/image_5.png)

Marcar la opción de insertar diseño de Word.

![Imagen 2](../img/image_4.png)

Configurar una descripción para el asunto correctamente.

![Imagen 2](../img/image_2.png)

Importar y/o exportar el layout para modificarlo.

![Imagen 2](../img/image_11.png)

#### Configuración del Cuerpo del Mensaje

El proceso es similar al del asunto, pero aplicándolo al campo correspondiente al cuerpo del mensaje.

### Importantes

Es importante que, si no es una opción especial, se marque el booleano “opción solo para correos” en los cuerpos y los asuntos para que al imprimir no aparezca toda la secuencia.

![Imagen 2](../img/image_3.png)

### Diferentes idiomas

Todo este proceso debe realizarse para cada idioma que se desee añadir. Un ejemplo con varios idiomas sería algo así:

![Imagen 2](../img/image_13.png)

## Revisar el Envío de Correos

En las cuentas de correo electrónico se puede ir a los correos electrónicos enviados los mensajes que se han enviado.

![Imagen 2](../img/image_9.png)

En los correos enviados se puede visualizar los correos que se han enviado, quien los ha enviado, la fecha y la hora.

![Imagen 2](../img/image_10.png)
