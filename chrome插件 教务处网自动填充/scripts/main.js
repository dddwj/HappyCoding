/*dddwj 2018-09-01*/
$("body").append('<div style="text-align:center; "><button id="fillinBtn" style=" size: landscape; background-color: #E096EB; ">一键填充</button></div>');

document.getElementById("fillinBtn").addEventListener("click", (e) => {
        chrome.storage.local.get(['xm','xh','id_card'], function(result) {
            document.getElementById("xh").value = result.xh;
            document.getElementById("xm").value = result.xm;
            document.getElementById("id_card").value = result.id_card;
        });


});


