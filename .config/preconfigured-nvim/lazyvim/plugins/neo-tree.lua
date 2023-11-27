-- encontre una mejor forma, pero no se como configurarla
-- https://github.com/nvim-neo-tree/neo-tree.nvim/issues/202
--
-- over write default 'delete' command to 'trash'.
local delete = function(state)
	local inputs = require("neo-tree.ui.inputs")
	local path = state.tree:get_node().path
	local msg = "Are you sure you want to trash " .. path
	inputs.confirm(msg, function(confirmed)
		if not confirmed then
			return
		end

		vim.fn.system({ "trash", vim.fn.fnameescape(path) })
		require("neo-tree.sources.manager").refresh(state.name)
	end)
end

-- over write default 'delete_visual' command to 'trash' x n.
local delete_visual = function(state, selected_nodes)
	local inputs = require("neo-tree.ui.inputs")

	-- get table items count
	function GetTableLen(tbl)
		local len = 0
		for n in pairs(tbl) do
			len = len + 1
		end
		return len
	end

	local count = GetTableLen(selected_nodes)
	local msg = "Are you sure you want to trash " .. count .. " files ?"
	inputs.confirm(msg, function(confirmed)
		if not confirmed then
			return
		end
		for _, node in ipairs(selected_nodes) do
			vim.fn.system({ "rm", vim.fn.fnameescape(node.path) })
		end
		require("neo-tree.sources.manager").refresh(state.name)
	end)
end

return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		opts = {

			filesystem = {
				commands = {
					-- Override delete to use trash instead of rm
					delete = function(state)
						local path = state.tree:get_node().path
						vim.fn.system({ "rm", vim.fn.fnameescape(path) })
					end,
				},
			},
		},
	},
}
