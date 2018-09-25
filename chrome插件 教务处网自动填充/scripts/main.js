$("body").append('<div style="text-align:center; "><button id="fillinBtn" style=" size: landscape; background-color: #E096EB; ">一键填充</button></div>');

// canvas 和 img 用于将url转换到.png文件，可以不显示在网页上。
$("body").append(' <img id="canvasImg" src=" " > <canvas id="mycanvas"></canvas>');
$("body").append(' <style>#canvasImg {position: absolute;right: 60px; top: 0;z-index: 1;visibility: hidden; /* #mycanvas {position: absolute; left: 0; top: 0; z-index: 2; visibility: hidden;} */ </style>');

$("#fillinBtn").on("click", function() {
    chrome.storage.local.get(['xm','xh','id_card'], function(result) {
        document.getElementById("xh").value = result.xh;
        document.getElementById("xm").value = result.xm;
        document.getElementById("id_card").value = result.id_card;
        document.getElementById("RANDOMCODE").value = "error";
    });

    var CodeUrl = document.getElementById("SafeCodeImg").src;
    var canvasImg = document.getElementById("canvasImg");
    var mycanvas = document.getElementById("mycanvas");

    // 以下代码：将img标签放到画布上。再将画布转为blob，最后将blob转为文件。
    // 这样做是因为：访问验证码的url，每次都会生成新的随机数图片，因此不能通过验证码的url直接保存当前网页上的验证码图片。
    // 是不是有简单的方法，直接使用网页缓存中已经下载显示在网页上的图片？【而不是再次访问url（请求新的图片）】？
    // 答： 当<img id="canvasImg" > 中不带标签  crossorigin="anonymous" 时，浏览器不会再次访问url，而是直接使用已经下载显示在网页上的图片。
    // 哎，为了这件事纠结了很久，最后调通了。

    canvasImg.src = CodeUrl;    //更换图片src时，要等图片加载完后再进行下一步操作
    console.log(CodeUrl);
    function canvasOnload() {
        //一定要等图片加载后再获得图片的大小，这样获得的就是图片的原生大小
        //这里除以10 是因为图片较大的时候转换过程会变慢，但是图片会压缩
        //canvas大小要和图片大小一样
        var imgWidth = canvasImg.width;
        var imgHeight = canvasImg.height;
        mycanvas.setAttribute('width', imgWidth);
        mycanvas.setAttribute('height', imgHeight);
        var ctx = mycanvas.getContext("2d");
        ctx.drawImage(canvasImg, 0, 0, imgWidth, imgHeight);
        var uricode = mycanvas.toDataURL("images/png", 1.0);
        var blobs = urltoblob(uricode);
        console.log(blobs);
        var objFile = new File([blobs], "VerCode.png", {type: "images/png"});   // 将blobs转换成file，供API使用。
        // canvasImg.crossOrigin = '*'; // 本机上调试时使用，跨域访问图片(CodeUrl与本机之间跨域）
        useAPI(objFile);        // 异步请求，等待图片加载完成后再执行下面代码，访问API。  应该有异步转同步的更好解决方法，在这里只能先实现功能，熟练js后再优化代码。
    }
    canvasImg.onload = canvasOnload;
});

function urltoblob(dataURL){
    var BASE64_MARKER = ';base64,';
    if (dataURL.indexOf(BASE64_MARKER) == -1) {
        var parts = dataURL.split(',');
        var contentType = parts[0].split(':')[1];
        var raw = decodeURIComponent(parts[1]);
        return new Blob([raw], {type: contentType});
    }
    var parts = dataURL.split(BASE64_MARKER);
    var contentType = parts[0].split(':')[1];
    var raw = window.atob(parts[1]);
    var rawLength = raw.length;
    var uInt8Array = new Uint8Array(rawLength);
    for (var i = 0; i < rawLength; ++i) {
        uInt8Array[i] = raw.charCodeAt(i);
    }
    return new Blob([uInt8Array], {type: contentType});
};

function useAPI(objFile){
    console.log(objFile);
    var formData = new FormData();
    formData.append('file', objFile);
    var ajax = new XMLHttpRequest();        // 新的http post请求，发送.png文件，此处省略了文件后缀、恶意文件的检查。
    ajax.open("POST", "http://101.132.154.2:5000/VerCodeAPI", true);
    ajax.setRequestHeader('Access-Control-Allow-Origin', '*');
    ajax.send(formData);
    ajax.onreadystatechange = function() {
        if(ajax.readyState == 4) {
            if(ajax.status >= 200 && ajax.status < 300 || ajax.status == 304) {
                console.log(ajax.responseText);     //API通过POST给出应答，据此填充RANDOMCODE框。
                document.getElementById("RANDOMCODE").value = ajax.responseText;
            }
        }
    }
};



