function addSnippet(event) {
    var snippet = event.target || event.srcElement;
    if (snippet == "[object HTMLLIElement]") {
	var to_add = snippet.textContent || snippet.innerText;
	document.getElementById("mnemonic_aide").value += "(" + to_add + ")";
    }
}