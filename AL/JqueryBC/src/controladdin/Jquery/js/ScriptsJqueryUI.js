//*********************************************************************************************************************
//jQuery UI
//*********************************************************************************************************************
function HtmlJqueryUI() {
    var Html;

    var getHtml = $.get(Microsoft.Dynamics.NAV.GetImageResource("src/controladdin/Jquery/html/HtmlJqueryUI.html"), function (htmlExterno) {
        Html = htmlExterno;
    });

    getHtml.fail(function () {
        alert("error");
    });

    getHtml.done(function () {
        controlAddIn.html(Html);


    });

}
