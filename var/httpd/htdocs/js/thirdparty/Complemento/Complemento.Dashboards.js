// Load All Dashboards
// @TODO: Load this only on required screens, Dashboard screen for example
if(window.deferAfterjQueryLoaded){
	$.each(window.deferAfterjQueryLoaded, function(index, fn) {
	    fn();
	});
}
