local license = ... or {}
license.Key = script_key or license.Key or nil
repeat task.wait() until game:IsLoaded()
if shared.vape then shared.vape:Uninject() end

local vape
local loadstring = function(...)
	local res, err = loadstring(...)
	if err and vape then
		vape:CreateNotification('Vape', 'Failed to load : '..err, 30, 'alert')
	end
	return res
end
local queue_on_teleport = queue_on_teleport or function() end
local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local cloneref = cloneref or function(obj)
	return obj
end
local playersService = cloneref(game:GetService('Players'))
local httpService = cloneref(game:GetService('HttpService'))

local redirect = function()
	local body = httpService:JSONEncode({
		nonce = httpService:GenerateGUID(false),
		args = {
			invite = {code = 'tumbavape'},
			code = 'tumbavape'
		},
		cmd = 'INVITE_BROWSER'
	})

	for i = 1, 2 do
		task.spawn(function()
			request({
				Method = 'POST',
				Url = 'http://127.0.0.1:6463/rpc?v=1',
				Headers = {
					['Content-Type'] = 'application/json',
					Origin = 'https://discord.com'
				},
				Body = body
			})
		end)
	end
end

local function downloadFile(path, func)
	if not isfile(path) then
		warn(path)
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/zxcbest957-pixel/tumba-vape/'..readfile('tumbavape/profiles/commit.txt')..'/'..select(1, path:gsub('tumbavape/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			task.spawn(error, res)
		end
		if suc then
			if path:find('.lua') then
				res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
			end
			writefile(path, res)
		end
	end
	return (func or readfile)(path)
end

local function finishLoading()
	vape.Init = nil
	vape:Load()
	task.spawn(function()
		repeat
			vape:Save()
			task.wait(10)
		until not vape.Loaded
	end)

	local teleportedServers
	vape:Clean(playersService.LocalPlayer.OnTeleport:Connect(function(state)
		if (not teleportedServers) and (not shared.VapeIndependent) then
			teleportedServers = true
			local teleportScript = [[
				if shared.VapeDeveloper then
					loadstring(readfile('tumbavape/main.lua'), 'main')(_scriptconfig)
				else
					loadstring(game:HttpGet('https://api.tumbavape.dev/script?key=_key'), 'init')(_scriptconfig)
				end
			]]
			local teleportConfig = httpService:JSONEncode(license)
			teleportConfig = teleportConfig:gsub('":true', "=true"):gsub('{"', '{')
			teleportConfig = teleportConfig:gsub(',"', ','):gsub('":', '=')
			teleportConfig = teleportConfig:gsub('%[', '{'):gsub('%]', '}')
			teleportScript = teleportScript:gsub('_key', tostring(license.Key or '_key'))
			teleportScript = teleportScript:gsub('_scriptconfig', teleportConfig)
			if shared.VapeDeveloper then
				teleportScript = 'shared.VapeDeveloper = true\n'..teleportScript
			end
			if shared.VapeCustomProfile then
				teleportScript = 'shared.VapeCustomProfile = "'..shared.VapeCustomProfile..'"\n'..teleportScript
			end
			queue_on_teleport(teleportScript)
		end
	end))

	if not shared.vapereload then
		if not vape.Categories then return end
		if vape.Categories.Main.Options['GUI bind indicator'].Enabled then
			if getgenv().tumbarole == 'HWID MISMATCH' then
				vape:CreateNotification('Tumba Vape', 'HWID MISMATCH, Go to the script panel to reset hwid', 25, 'alert')
				getgenv().tumbarole = ''
				task.wait(0.1)
			end
			if vape.Place ~= 6872274481 and not license.Closet then
				task.spawn(redirect)
			end
			vape:CreateNotification('Finished Loading', (getgenv().tumbaname and `Authenticated as {getgenv().tumbaname} with {getgenv().tumbarole}, ` or '').. (vape.VapeButton and 'Press the button in the top right' or 'Press '..table.concat(vape.Keybind, ' + '):upper())..' to open GUI', 5)
			task.delay(1, function()
				if shared.updated then
					vape:CreateNotification('Tumba Vape', `Script has updated from {shared.updated} to {readfile('tumbavape/profiles/commit.txt')}`, 10, 'info')
				end
			end)
		end
	end
end

if not isfile('tumbavape/profiles/gui.txt') then
	writefile('tumbavape/profiles/gui.txt', 'new')
end
local gui = 'new'--readfile('tumbavape/profiles/gui.txt')

if not isfolder('tumbavape/assets/'..gui) then
	makefolder('tumbavape/assets/'..gui)
end
if not isfile('tumbavape/profiles/commit.txt') then
	writefile('tumbavape/profiles/commit.txt', 'main')
end

getgenv().used_init = true
vape = loadstring(downloadFile('tumbavape/guis/'..gui..'.lua'), 'gui')(license)
_G.vape = vape
shared.vape = vape

if shared.maincat then
	redirect()
	playersService.LocalPlayer:Kick('Your script is outdated, Get new one at discord.gg/tumbavape')
	return
end

if not shared.VapeIndependent then
	loadstring(downloadFile('tumbavape/games/universal.lua'), 'universal')(license)
	if isfile('tumbavape/games/'..game.PlaceId..'.lua') then
		loadstring(readfile('tumbavape/games/'..game.PlaceId..'.lua'), tostring(game.PlaceId))(license)
	else
		if not shared.VapeDeveloper then
			local suc, res = pcall(function()
				return game:HttpGet('https://raw.githubusercontent.com/zxcbest957-pixel/tumba-vape/'..readfile('tumbavape/profiles/commit.txt')..'/games/'..game.PlaceId..'.lua', true)
			end)
			if suc and res ~= '404: Not Found' then
				loadstring(downloadFile('tumbavape/games/'..game.PlaceId..'.lua'), tostring(game.PlaceId))(license)
			end
		end
	end
	loadstring(downloadFile('tumbavape/libraries/premium.lua'), 'premium')(license)
	finishLoading()
else
	vape.Init = finishLoading
	return vape
end
