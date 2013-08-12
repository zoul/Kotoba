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
    image.src = "img/" + img;
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

window.onload = function()
{
    hook_links();
    decorate_arrows(document.body);
    expand_anchor();
}
