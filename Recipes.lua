wasteland_Recipes = {}

local function setup()
	local stick = cItem(E_ITEM_STICK)

	local tmp = CraftingRecipe_new(2,2)
	CraftingRecipe_SetResult(tmp, w_Items['wasteland:dry_planks'])
	CraftingRecipe_SetItem(tmp, 0,0, stick)
	CraftingRecipe_SetItem(tmp, 0,1, stick)
	CraftingRecipe_SetItem(tmp, 1,0, stick)
	CraftingRecipe_SetItem(tmp, 1,1, stick)

	table.insert(wasteland_Recipes, tmp)
end

setup()