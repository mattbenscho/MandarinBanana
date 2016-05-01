function saveCursorPosition() {
    var textarea = document.getElementById('mnemonic_aide');
    CursorCaretPos = textarea.selectionStart;
}

function insertAtCursor(event) {
    var textarea = document.getElementById('mnemonic_aide');
    var snippet = event.target || event.srcElement;
    var to_add = snippet.textContent || snippet.innerText;
    var to_add = "(" + to_add + ")";
    //IE support
    if (document.selection) {
        textarea.focus();
        sel = document.selection.createRange();
        sel.text = to_add;
    }
    //MOZILLA and others
    else if (textarea.selectionStart || textarea.selectionStart == '0') {
        var startPos = textarea.selectionStart;
        var endPos = textarea.selectionEnd;
        textarea.value = textarea.value.substring(0, startPos)
            + to_add
            + textarea.value.substring(endPos, textarea.value.length);
        textarea.selectionStart = startPos + to_add.length;
        textarea.selectionEnd = startPos + to_add.length;
    } else {
        textarea.value += to_add;
    }
    textarea.focus();
}

