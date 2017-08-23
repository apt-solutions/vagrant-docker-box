(function(_) {
	'use strict';

	var pingAliveUrl = window.EVALSOFT_DEMO_PING_ALIVE_URL;
	// all 5 minutes
	var pingAfterMillSec = 18000000;

	loopPingAlive(pingAliveUrl, pingAfterMillSec);

	/**
	 *
	 * @returns
	 */
	function loopPingAlive(pingAliveUrl, pingAfterMillSec) {
		var considerMouseIdleMillsec = pingAfterMillSec;

		var sendPing = function() {
			return jQuery.get({
				url: pingAliveUrl,
				timeout: 6000
			});
		};

		var trySendPing = function() {
			// Constantly shoot ping request to let evalsoft know, this demo is alive,
			// Try 3 times in case of error. This handles smaller issues of
			// e.g. bad network connectivity
			sendPing()
				.fail(function() {
					return sendPing();
				})
				.fail(function() {
					return sendPing();
				});
		};

		var mouseIsIdle = false;
		var mouseIdleTimer = 0;

		// Reset the mouse timer on mousemove
		// This listener is called multiple hundred times per second.
		// Therefore this method has to be as lightweight as possible!
		var onMouseMove = function() {
			mouseIdleTimer = 0;
		};
		window.addEventListener('mousemove', onMouseMove, false);

		// Detect mouse idle events
		window.setInterval(function() {
			mouseIdleTimer++; // Increase idle timer

			if ( (mouseIdleTimer * 1000) > considerMouseIdleMillsec ) {
				mouseIsIdle = true;
			} else {
				if ( mouseIsIdle ) {
					// if mouse was idle and switches back to active immediately send "alive ping"
					trySendPing();
				}

				mouseIsIdle = false;
			}

		}, 1000);

		// Send alive ping on any page refrehs
		trySendPing();

		// Constantly ping that we are live
		window.setInterval(function() {
			if ( mouseIsIdle ) {
				// Do not send ping if we detected idle mouse movement
				return;
			}

			trySendPing();
		}, pingAfterMillSec);
	}

})();
