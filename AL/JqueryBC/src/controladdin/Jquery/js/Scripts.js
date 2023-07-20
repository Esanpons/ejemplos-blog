var controlAddIn;

function CrearTodoElHtmlInicial() {
    var texto = 'texto inicial insertado';
    var Html;

    var getHtml = $.get(Microsoft.Dynamics.NAV.GetImageResource("src/controladdin/Jquery/html/HtmlJquery.html"), function (htmlExterno) {
        Html = htmlExterno;
    });

    getHtml.fail(function () {
        alert("error");
    });

    getHtml.done(function () {
        controlAddIn.empty();
        controlAddIn.html(Html);

        var div1 = $("#div1");
        div1.text(texto);

        var div2 = $("#div2");
        var parDiv2 = $("<p />", { id: "pd2" });
        parDiv2.text('text par div 2');
        div2.append(parDiv2);

        var parDiv3 = $("<p />", { id: "pd3" });
        parDiv3.text('text par div 3');
        div2.append(parDiv3);

        var br = $("<br />");
        controlAddIn.append(br);

        var par = $("<p />", { id: "p1" });
        par.html("nueva línea");
        controlAddIn.append(par);

        var par2 = $("<p />", { id: "p2" });
        par2.html("nueva línea2");
        controlAddIn.append(par2);

        var img = $("<img />", { id: "imgCorazon", src: Microsoft.Dynamics.NAV.GetImageResource("src/controladdin/Jquery/images/corazon.jpg") });
        $("#imagenes").append(img);

        controlAddIn.append(br);
        controlAddIn.append(br);
        controlAddIn.append(br);

        var bt7 = $("<input />", { type: "button", id: "button7", value: "Cargando y creando de nuevo" });
        controlAddIn.append(bt7);

        controlAddIn.append(br);

        var bt8 = $("<button />", { id: "button8", text: "Quitar TODO y añadir HTML jQuery UI" });
        controlAddIn.append(bt8);

        //esto equivaldria al $(document).ready
        var NuevoTexto = "Nuevo Hola";

        $("#button1").click({ value: NuevoTexto }, notify);
        $("#button2").click(toggle);
        $("#button3").click(FadeIn);
        $("#button4").hover(HoverAndSlide);
        $("#button5").click(CssJquery);
        $("#button6").click(removeImage);
        $("#button7").click(cargando);
        $("#button8").click(RemoveAndAddJqueryUI);
    });
}

function notify(Mgs) {
    $('#div1').html(Mgs.data.value);
}
function toggle(clickEventObject) {
    //Esto muestra el evento del boton
    //oculta y desoculta
    $('#div1').toggle(500);
}
function FadeIn() {
    //oculta y desoculta pero primero hace que desaparezca
    $('#div1').fadeToggle(500);
}
function HoverAndSlide() {
    //oculta y desoculta mientras lo estes tocando
    $('#div1').slideToggle(1000);
}

function CssJquery() {
    $('p').css("font-family", "Arial").css("color", "green");
}

function removeImage() {
    $("#imgCorazon").remove();
}

async function cargando() {
    //funcion para emular el tiempo de espera se requiere el async
    var divCargando = $("<div />", { id: "divCargando" });
    var imgCargando = $("<img />",
        { id: "imgCargando", src: Microsoft.Dynamics.NAV.GetImageResource("src/controladdin/Jquery/images/ajax-loader.gif") });
    divCargando.append(imgCargando);
    controlAddIn.append(divCargando);

    for (let i = 0; i < 2; i++) {
        console.log(`Waiting ${i} seconds...`);
        await sleep(i * 1000);
    }

    console.log('Done');
    //elimina el div creado para que se quite el cargando
    $("#divCargando").remove();

    CrearTodoElHtmlInicial();
}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

function RemoveAndAddJqueryUI() {
    controlAddIn.empty();
    HtmlJqueryUI();
}

function SetDataText(SetText) {
    console.log('SetText');
    $('#div1').html(SetText);
}

function OnclickButton(evento) {
    console.log(evento);
    console.log('controlAddIn2', $("#imagenes"));

    $(document).ready(function () {
        console.log("document loaded");
    });

    $(window).on("load", function () {
        console.log("window loaded");
    });
}




