function character_to_image(node, chr, img)
{
    var chpos = node.nodeValue.indexOf(chr);
    if (chpos == -1)
        return;

    var before = node.nodeValue.substring(0, chpos);
    var after = node.nodeValue.substring(chpos+1, node.nodeValue.length);
    var parent = node.parentNode;

    var span = document.createElement("span");
    var image = document.createElement("img");
    image.src = "/images/" + img;
    image.className = "replaced";
    span.appendChild(document.createTextNode(before));
    span.appendChild(image);
    span.appendChild(document.createTextNode(after));

    parent.replaceChild(span, node);
}

function decorate_arrows(node)
{
    if (node.nodeType == 3)
    {
        character_to_image(node, "→", "arrow.png");
        character_to_image(node, "↔", "arrows.png");
    }
    else
        for (var i=0; i < node.childNodes.length; i++)
            decorate_arrows(node.childNodes[i]);
}

function expand_tab(name)
{
    var tab = document.getElementById(name);

    // Find the parent menu
    var menu = tab;
    while (menu.className.indexOf("column") == -1)
        menu = menu.parentNode;

    // Update the links
    var links = menu.getElementsByTagName("a");
    for (var i=0; i<links.length; i++)
        links[i].className = (links[i].href.indexOf("#"+name) == -1) ? "" : "current";

    // Find the parent column div
    var column = tab;
    while (column.className.indexOf("column") == -1)
        column = column.parentNode;

    // Update tab visibility
    var tabs = column.getElementsByTagName("div");
    for (var i=0; i<tabs.length; i++)
        if (tabs[i].className.indexOf("tab") != -1)
            tabs[i].style.display = (tabs[i] == tab) ? "block" : "none";
}

function hook_links()
{
    var links = document.getElementsByTagName("a");
    for (var i=0; i < links.length; i++)
    {
        if (links[i].href.indexOf("#") == -1)
            continue;
        links[i].onclick = function()
        {
            var hash = this.href.indexOf("#");
            var targetId = this.href.substring(hash+1, this.href.length);
            expand_tab(targetId);
            return false;
        }
    }
}

function expand_anchor()
{
    var hash = document.location.hash;
    if (hash == "")
        return;
    var id = hash.substring(1, hash.length);
    expand_tab(id);
}

function insert_hint(id, hint)
{
    var target = document.getElementById(id);
    // The value might have already been set if we’re making
    // a second turnaround with the form.
    if ((target.value != '') && (target.value != target.hint))
        target.valueChangedByUser = true;
    // Do not clobber the user-entered value with the hint.
    if (target.valueChangedByUser)
        return;

    target.value = target.hint = hint;
    target.className += ' unchanged';
    target.onfocus = function()
    {
        if (this.valueChangedByUser)
            return;
        this.value = '';
        this.className = this.className.replace("unchanged", '');
    }
    target.onblur = function()
    {
        // User already changed this field some time ago.
        if (this.valueChangedByUser)
            return;
        // User changed this field just now.
        if (this.value != '')
        {
            this.valueChangedByUser = true;
            return;
        }
        // Field unchanged.
        this.value = hint;
        this.className += " unchanged";
    }
}

function dyna_hint(triggerId, targetId, hint)
{
    var trigger = document.getElementById(triggerId);
    trigger.onclick = function()
    {
        if (!this.checked)
            return;
        insert_hint(targetId, hint);
    }
    if (trigger.checked)
        insert_hint(targetId, hint);
}

function error_message(lang)
{
    if (lang == "cs")
        return "Tento údaj je povinný.";
    return "This is a required field.";
}

function check_form(form)
{
    // Clear all errors
    var divs = form.getElementsByTagName("div");
    for (var i=0; i<divs.length; i++)
        if (divs[i].className.indexOf("error") != -1)
            divs[i].parentNode.removeChild(divs[i]);

    // Get form language
    var column = form;
    while (column.className.indexOf("column") == -1)
        column=column.parentNode;
    var language = column.getAttribute("lang");

    // Check required fields
    var inputs = form.getElementsByTagName("*");
    for (var i=0; i<inputs.length; i++)
    {
        // All textareas and textfields are required.
        if (inputs[i].nodeName != "TEXTAREA" && (inputs[i].getAttribute("type") != "text"))
            continue;
        if (inputs[i].valueChangedByUser && (inputs[i].value != ""))
            continue;

        // Find the corresponding label
        var label;
        var parent = inputs[i].parentNode;
        var kids = parent.getElementsByTagName("*");
        for (var j=0; j<kids.length; j++)
            if ((kids[j].nodeName == "LABEL") && (kids[j].htmlFor == inputs[i].id))
                label = kids[j];

        // Insert error message before label
        var error = document.createElement("div");
        error.className = (inputs[i].nodeName == "TEXTAREA") ? "wide error" : "error";
        error.innerHTML = "<p>" + error_message(language) + "</p>";
        parent.insertBefore(error, label);
        inputs[i].focus();
        return false;
    }
    
    // Find and disable the form submit button
    var submit;
    var inputs = form.getElementsByTagName("input");
    for (var i=0; i<inputs.length; i++)
        if (inputs[i].type == "submit")
            inputs[i].disabled = true;

    // Form ok, submit.
    return true;
}

function hook_forms()
{
    var forms = document.forms;
    for (var i=0; i<forms.length; i++)
        forms[i].onsubmit = function() { return check_form(this); }
}

window.onload = function()
{
    hook_links();
    decorate_arrows(document.body);
    expand_anchor();
    hook_forms();

    insert_hint('csform1', "vaše jméno, firma, …");
    insert_hint('csform2', "telefon nebo e-mail");
    dyna_hint('csform3', 'csform5', "Obor překladu, počet dokumentů, orientační rozsah v normostranách nebo slovech, zdrojový a cílový jazyk, termín, …");
    dyna_hint('csform4', 'csform5', "Obor a obsah tlumočení, místo (například město nebo obec), datum, čas, odhadovaná doba tlumočení, …");

    insert_hint('enform1', "your name, company, …");
    insert_hint('enform2', "telephone or e-mail");
    dyna_hint('enform3', 'enform5', "Translation specialization, number of documents, estimated number of words or pages, source language and destination language, term etc.");
    dyna_hint('enform4', 'enform5', "Specialization and range of interpreting services, location, date, time, estimated time of interpreting, etc.");

    insert_hint('jaform1', "会社名");
    insert_hint('jaform2', "電話番号またはメールアドレス");
    dyna_hint('jaform3', 'jaform5', "翻訳分野および内容、文書数、原文ページ数もしくはワード数、元の言語と訳出言語、希望納期");
    dyna_hint('jaform4', 'jaform5', "通訳分野および内容、場所（町、地方など）、業務日、時間、実働時間数（推測）");
}
