// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function toggle(targetId) {
target = document.getElementById(targetId);
if (target.style.display == "none"){
  target.style.display="block";
 } else {
  target.style.display="none";
 }
}

