local tumbahub = shared.tumbahub
local loadstring = function(...)
	local res, err = loadstring(...)
	if err and tumbahub then
		tumbahub:CreateNotification('Tumba Vape', 'Failed to load : '..err, 30, 'alert')
	end
	return res
end
local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/zxcbest957-pixel/tumba-vape/'..readfile('tumbavape/profiles/commit.txt')..'/'..select(1, path:gsub('tumbavape/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after tumbahub updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

tumbahub.Place = 8768229691
if isfile('tumbavape/games/'..tumbahub.Place..'.lua') then
	loadstring(readfile('tumbavape/games/'..tumbahub.Place..'.lua'), 'skywars')()
else
	if not shared.TumbaVapeDeveloper then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/zxcbest957-pixel/tumba-vape/'..readfile('tumbavape/profiles/commit.txt')..'/games/'..tumbahub.Place..'.lua', true)
		end)
		if suc and res ~= '404: Not Found' then
			loadstring(downloadFile('tumbavape/games/'..tumbahub.Place..'.lua'), 'skywars')()
		end
	end
end