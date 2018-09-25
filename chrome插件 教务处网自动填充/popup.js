window.onload=function(){
    document.getElementById("submit_btn").addEventListener("click", (e) =>{
        var xm = getRadioValue().toString();
        var xh, id_card;
        switch (xm) {
            case "董文杰":
                xh = "";
                id_card = "";
                break;
            case "赵杰羽":
                xh = "";
                id_card = "";
                break;
            case "雷骏杰": xh = "";id_card = "";break;
            case "刘熠珺": xh = "";id_card = "";break;
            default:
                xh = "xxxxx";
                id_card = "xxxxx";
                break;
        };
        chrome.storage.local.set(
            {"xm": xm,
            "xh": xh,
            "id_card": id_card
            }, function() {
                console.log('xm is set to ' + xm);
            });
        // localStorage.setItem("options", getRadioValue().toString());
        window.close();
    });
};


function getRadioValue() {
    let radios = document.getElementsByName("xm");
    let value;
    for(let i=0;i<radios .length;i++) {
        if (radios[i].checked) {
            value = radios[i].value;
            break;
        }
    }
    console.log(value);
    return value;

};

//
// function show(){
//     alert(localStorage.getItem("options"));
// }
