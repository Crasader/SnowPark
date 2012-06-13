
var main_swf_id = "snow-swf";

function get_swf_params() {
    var params = window.location.search.substring(1).split("&");
    var hash = {};
    for (var i in params) {
        var val = params[i].split("=");
        hash[val[0]] = val[1];
    }
    return hash;
}

function snow_embed_swf(swf_url,  widthStr, heightStr) {
    var params = {};
    params.allowfullscreen = "true";
    params.allowscriptaccess = "always";
    params.allownetworking = "all";
    params.bgcolor = params.bgcolor || "#FFFFFF";
    params.wmode = "opaque";

    var attributes = {};
    attributes.type = "application/x-shockwave-flash";

    swfobject.embedSWF(swf_url, main_swf_id, widthStr, heightStr, "10.0.0", "iframe/expressinstall.swf", get_swf_params(), params, attributes)
}

