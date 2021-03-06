if DEBUG then

	Debugging = inherit(Singleton)

	function Debugging:constructor()
		setDevelopmentMode(true)
		addCommandHandler("dcrun", bind(Debugging.runString, self))
		addCommandHandler("dcreload", bind(Debugging.reloadClass, self))
		
		bindKey("lshift", "down",
			function()
				local vehicle = getPedOccupiedVehicle(localPlayer)
				if vehicle then
					local vx, vy, vz = getElementVelocity(vehicle)
					setElementVelocity(vehicle, vx, vy, 0.3)
				end
			end
		)
		bindKey("lalt", "down",
			function()
				local vehicle = getPedOccupiedVehicle(localPlayer)
				if vehicle then
					local vx, vy, vz = getElementVelocity(vehicle)
					setElementVelocity(vehicle, vx*1.5, vy*1.5, vz)
				end
			end
		)
	end

	function Debugging:runString(cmd, ...)
		local codeString = table.concat({...}, " ")
		runString(codeString, root, player)
	end
	
	function Debugging:reloadClass(cmd, file)
		if not fileExists(file) then 
			outputChatBox("file does not exist")
		else
			outputChatBox("reloading " .. file)
			local fh = fileOpen(file)
			local data = fileRead(fh, fileGetSize(fh))
			fileClose(fh)
			local fn, err = loadstring(data)
			if not fn then
				outputChatBox("Error Compiling "..err)
				return
			end
			status, err = pcall(fn)
			if not status then
				outputChatBox("Error Launching "..err)
				return
			end
			outputChatBox("Successfully reloaded")
		end
	end
end
