local M = {}
local timer = vim.loop.new_timer()

local BACKUP_INTERVAL = 60000

function M.setup(opts)
	opts = opts or {}
	M.files_to_track = opts.files or {}
end

local function git_commit(file)
	vim.fn.system("git add " .. file)
	vim.fn.system("git commit -m 'Auto backup: " .. file .. " at " .. os.date() .. "'")
end

local function auto_save()
	for _, file in ipairs(M.files_to_track) do
		if vim.fn.filereadable(file) == 1 then
			vim.cmd("write " .. file)
			git_commit(file)
		end
	end
end

function M.start_backup(interval)
	timer:start(0, interval or BACKUP_INTERVAL, vim.schedule_wrap(auto_save))
end

function M.stop_backup()
	timer:stop()
end

return M
