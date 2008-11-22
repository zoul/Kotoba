window.onload = function()
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
