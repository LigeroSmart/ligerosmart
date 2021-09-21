// Load All Dashboards
// @TODO: Load this only on required screens, Dashboard screen for example
if(window.deferAfterjQueryLoaded){
	$.each(window.deferAfterjQueryLoaded, function(index, fn) {
	    fn();
	});
}

function asyncDashboardLoad(dashboardName, options={}) {
	let dashboardBox = $(`#Dashboard${dashboardName}-box`)
	let dashboardContent = $(`#Dashboard${dashboardName}`)
	let dashboardPath = Core.Config.Get('Baselink') + window.location.search.replace(/^[?]/,'') + ';Subaction=Element;Name=' + dashboardName
	dashboardBox.addClass('Loading');
	Core.AJAX.ContentUpdate(dashboardContent, dashboardPath, () => {
		dashboardBox.removeClass('Loading')
		if(options.callDefer) {
			$.each(window.deferAfterjQueryLoaded, function(index, fn) {
				fn();
			});
		}
	});
}

