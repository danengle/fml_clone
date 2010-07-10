document.createElement("nav");
document.createElement("header");
document.createElement("footer");
document.createElement("section");
document.createElement("aside");
document.createElement("article");
document.createElement("meter");

// Check html5 support
function hasColorSupport(){ 
	input = document.createElement("input");
	input.setAttribute("type", "color");
	return(input.type !== "text");
}
if (!hasColorSupport()){
	// TODO checkout simpleColor jquery plugin
	$('input[type=color]').simpleColor();
}