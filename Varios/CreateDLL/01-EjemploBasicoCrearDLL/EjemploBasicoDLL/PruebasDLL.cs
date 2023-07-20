using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.JSInterop;


namespace EjemploBasicoDLL
{
    public class PruebasDLL
    {
        [JSInvokable("DevolverTexto")]
       public String DevolverTexto(String NewText)
        {
            String ReturnString = "Hola mundo! Este es el texto insertado: " + NewText;
            return ReturnString;
        }

    }


}
