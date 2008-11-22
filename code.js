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
    image.src = "data/" + img;
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

function hook_links()
{
    var links = document.getElementsByTagName("a");
    for (var i=0; i < links.length; i++)
    {
        if (links[i].href.indexOf("#") == -1)
            continue;
        links[i].onclick = function()
        {
            for (var c=0; c < links.length; c++)
                links[c].className = '';
            this.className = "current";

            // Find the parent column div, so that we can
            // collapse all the sections.
            var parent = this;
            while (parent.className.indexOf("column") == -1)
                parent = parent.parentNode;

            // Now collapse the sections.
            var pages = parent.getElementsByTagName("div");
            for (var j=0; j < pages.length; j++)
                pages[j].style.display = "none";

            // And finally open the right one.
            var hash = this.href.indexOf("#");
            var targetId = this.href.substring(hash+1, this.href.length);
            var target = document.getElementById(targetId);
            target.style.display = "block";
            return false;
        }
    }
}

window.onload = function()
{
    hook_links();
    decorate_arrows(document.body);
}
