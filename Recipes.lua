wasteland_Recipes = {}

local function setup()
	local stick = cItem(E_ITEM_STICK)
	local seeds = w_Items['wasteland:seed']

	-- Planks
	local tmp = CraftingRecipe_new(2,2)
	CraftingRecipe_SetResult(tmp, w_Items['wasteland:dry_planks'])
	CraftingRecipe_SetItem(tmp, 0,0, stick)
	CraftingRecipe_SetItem(tmp, 0,1, stick)
	CraftingRecipe_SetItem(tmp, 1,0, stick)
	CraftingRecipe_SetItem(tmp, 1,1, stick)
	table.insert(wasteland_Recipes, tmp)

	-- Water Bucket
	tmp = CraftingRecipe_new(3,3)
	CraftingRecipe_SetResult(tmp, w_Items['wasteland:murky_water_bucket'])
	CraftingRecipe_SetItem(tmp,0,0, seeds)
	CraftingRecipe_SetItem(tmp,1,0, seeds)
	CraftingRecipe_SetItem(tmp,2,0, seeds)
	CraftingRecipe_SetItem(tmp,0,1, seeds)
	CraftingRecipe_SetItem(tmp,1,1, cItem(E_ITEM_BUCKET))
	CraftingRecipe_SetItem(tmp,2,1, seeds)
	CraftingRecipe_SetItem(tmp,0,2, seeds)
	CraftingRecipe_SetItem(tmp,1,2, seeds)
	CraftingRecipe_SetItem(tmp,2,2, seeds)


	table.insert(wasteland_Recipes, tmp)
end

setup()