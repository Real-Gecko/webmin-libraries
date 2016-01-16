function getFile(lib, ver, file, sender) {
//    alert(lib + " " + ver + " " + file);
    var xhr = new XMLHttpRequest();
    xhr.open('GET', 'get_file.cgi?lib=' + lib + '&ver=' + ver + '&file=' + file);
    xhr.send();
    xhr.onloadend = function () {
        if(xhr.responseText == 'Done') {
            var textnode = document.createTextNode("Local");
            sender.parentNode.replaceChild(textnode, sender);
        };
    };
}