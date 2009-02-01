// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function togglerowhighlight(element_id){
	var div1 = document.getElementById(element_id)
	if (div1.className=="highlighted") {
		div1.className = "not"
	} else {
		div1.className="highlighted"
	}
}
