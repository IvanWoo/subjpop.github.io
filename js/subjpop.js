document.addEventListener('DOMContentLoaded', function () {
    openInNewTab();
});

// open external link in a new tab
const openInNewTab = () => {
    document.querySelectorAll('a').forEach(function (a) {
        if (! a.href.startsWith(document.location.origin)) {
            a.setAttribute('target', '_blank');
            a.setAttribute("rel", "noopener");
        }
    })
    // $('a[href^="http://"]').attr('target', '_blank').attr('rel', 'noopener')
    // $('a[href^="https://"]').attr('target', '_blank').attr('rel', 'noopener')
}
}
