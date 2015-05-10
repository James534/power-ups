--best URL's ever of all time
scriptId = 'ca.nodomain.superpowerelders.myo'
scriptDetailsUrl = ''
scriptTitle = 'Keyboard Supliment'

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
    myo.keyboard("space", "press")
end

function undo()
    myo.keyboard("z", "press","control")
end

function backward ()
	myo.keyboard("backspace","press")
end

function submit ()
	myo.keyboard("a","press","control")
	myo.keyboard("c","press","control")
end

--defines action to be done
function shuttleBurst()
    if shuttleDirection == "forward" then
        forward()
    elseif shuttleDirection == "backward" then
        backward()
	elseif shuttleDirection == "close" then
		undo()
	elseif shuttleDirection == "open" then
		submit()
    end
end

function onPoseEdge(pose, edge)
    -- gesture and shuttle
    if pose ~="rest"  then
        local now = myo.getTimeMilliseconds()

        if edge == "on" then
            -- Deal with direction and arm
            if pose == "fist" then
                shuttleDirection = "close"
            elseif pose == "waveOut" then
                shuttleDirection = "forward"
            elseif pose == "waveIn" then
				shuttleDirection = "backward"
			elseif pose == "fingersSpread" then
				shuttleDirection = "open"
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
		myo.unlock("timed")
            shuttleTimeout = nil
        end
    end
end

-- All timeouts in milliseconds
SHUTTLE_CONTINUOUS_TIMEOUT = 2000
SHUTTLE_CONTINUOUS_PERIOD = 1000

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