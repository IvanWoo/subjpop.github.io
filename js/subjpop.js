// open external link in a new tab
$(document).ready(function () {
    $('a[href^="http://"]').attr('target', '_blank')
    $('a[href^="https://"]').attr('target', '_blank')
});