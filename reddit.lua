--best URL's ever of all time
scriptId = 'ca.leemr2.reddit.myo'
scriptDetailsUrl = ''
scriptTitle = 'reddit hands'

--unlimited window works
function onForegroundWindowChange(app, title)
    return true
end

function activeAppName()
    return "Keyboard"
end

-- flag to de/activate shuttling feature
supportShuttle = false


function forward()
    myo.keyboard("k", "press")
end

function expand()
	myo.keyboard("x","down")
end

function backward ()
	myo.keyboard("j","press")
end

function upvote ()
	local position = myo.getRoll()
	if position < (-math.pi/4) then
		myo.keyboard ("z","press")
	elseif position > (0.5) then
		myo.keyboard("s","press")
	else
		myo.keyboard("a","press")
	end
end

function off()
	myo.lock()
end

--defines action to be done
function shuttleBurst()
    if shuttleDirection == "forward" then
        forward()
    elseif shuttleDirection == "backward" then
        backward()
	elseif shuttleDirection == "close" then
		upvote()
	elseif shuttleDirection == "open" then
		expand()
	elseif shuttleDirection == "tap" then
		off()
    end
end

function onPoseEdge(pose, edge)
    -- gesture and shuttle
    if pose ~="rest" then
        local now = myo.getTimeMilliseconds()

        if edge == "on" then

			if pose == "fingersSpread" then
				shuttleDirection = "open"
			elseif pose == "waveOut" then
				shuttleDirection = "forward"
			elseif pose == "waveIn" then
				shuttleDirection = "backward"
			elseif pose == "fist" then
				shuttleDirection = "close"
			elseif pose == "doubleTap" then
				shuttleDirection = "tap"
			end

            -- Extend unlock and notify user
            myo.unlock("hold")
            myo.notifyUserAction()

            -- Initial burst
            shuttleBurst()
            shuttleSince = now
            shuttleTimeout = SHUTTLE_CONTINUOUS_TIMEOUT
        end
        if edge == "off" then
            myo.unlock("hold")
            shuttleTimeout = nil
        end
    end
end

-- All timeouts in milliseconds
SHUTTLE_CONTINUOUS_TIMEOUT = 600
SHUTTLE_CONTINUOUS_PERIOD = 300

function onPeriodic()
    local now = myo.getTimeMilliseconds()
    if supportShuttle and shuttleTimeout then
        if (now - shuttleSince) > shuttleTimeout then
            shuttleBurst()
            shuttleTimeout = SHUTTLE_CONTINUOUS_PERIOD
            shuttleSince = now
        end
    end
end