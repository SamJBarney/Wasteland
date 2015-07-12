local PLUGIN = nil

-- Item Definitions
dofile(cPluginManager:GetPluginsPath() .. "/Wasteland/Items.lua")

-- Crafting Related
dofile(cPluginManager:GetPluginsPath() .. "/Wasteland/CraftingRecipe.lua")
dofile(cPluginManager:GetPluginsPath() .. "/Wasteland/Recipes.lua")

-- Hook Files
dofile(cPluginManager:GetPluginsPath() .. "/Wasteland/BreakBlockHooks.lua")
dofile(cPluginManager:GetPluginsPath() .. "/Wasteland/RightClickHooks.lua")

-- Block Tick Handling
dofile(cPluginManager:GetPluginsPath() .. "/Wasteland/Lib/TickerLib.lua")
dofile(cPluginManager:GetPluginsPath() .. "/Wasteland/BlockTickHandlers.lua")

local RegisteredWorlds = {}

function Initialize(Plugin)
	-- Load the Info.lua file
	dofile(cPluginManager:GetPluginsPath() .. "/Wasteland/Info.lua")

	PLUGIN = Plugin

	PLUGIN:SetName(g_PluginInfo.Name)
	PLUGIN:SetVersion(g_PluginInfo.Version)

	-- Generation Hooks
	cPluginManager.AddHook(cPluginManager.HOOK_CHUNK_GENERATING, OnChunkGenerating)
	cPluginManager.AddHook(cPluginManager.HOOK_CHUNK_GENERATED, OnChunkGenerated)

	-- Crafting Hooks
	cPluginManager.AddHook(cPluginManager.HOOK_PRE_CRAFTING, OnPreCrafting)

	-- Misc Hooks
	cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_BROKEN_BLOCK, OnBlockBroken)
	cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICK, OnPlayerRightClick)
	cPluginManager.AddHook(cPluginManager.HOOK_BLOCK_SPREAD, OnGrassSpread)

	-- Block Tick Callbacks
	TickerSetup()

	RegisterTickerCallback('world', E_BLOCK_GRASS, E_META_ANY, OnTickGrassBlock)
	RegisterTickerCallback('world', E_BLOCK_FARMLAND, E_META_ANY, OnTickGrassBlock)
	RegisterTickerCallback('world', E_BLOCK_ANY, E_META_ANY, OnMagmaCore)

	LOG("Initialized " .. PLUGIN:GetName() .. " v." .. PLUGIN:GetVersion())

	return true
end

function OnDisable()
	LOG("Disabled " .. PLUGIN:GetName() .. "!")
end


-- Generation Callbacks
function OnChunkGenerating(World, ChunkX, ChunkZ, ChunkDesc)
	--if (RegisteredWorlds[World.GetName()] ~= nil) then
		ChunkDesc:SetUseDefaultBiomes(false)
		ChunkDesc:SetUseDefaultFinish(false)
		-- Change the biome to desert
		for x=0,15 do
			for z=0,15 do
				ChunkDesc:SetBiome(x,z,biDesert)
			end
		end
		return true
	--end
	--return false
end

function OnChunkGenerated(World, ChunkX, ChunkZ, ChunkDesc)
	--if (RegisteredWorlds[World.GetName()] ~= nil) then
		-- Replace all water with air
		ChunkDesc:ReplaceRelCuboid(0,15, 0,255, 0,15, E_BLOCK_STATIONARY_WATER,0, E_BLOCK_AIR,0)
		ChunkDesc:ReplaceRelCuboid(0,15, 0,255, 0,15, E_BLOCK_WATER,0, E_BLOCK_AIR,0)

		-- Replace clay with hardend clay
		ChunkDesc:ReplaceRelCuboid(0,15, 0,255, 0,15, E_BLOCK_CLAY,0, E_BLOCK_HARDENED_CLAY,0)
		ChunkDesc:ReplaceRelCuboid(0,15, 0,255, 0,15, E_BLOCK_DIRT,0, E_BLOCK_DIRT, E_META_DIRT_COARSE)

		-- Cover the chunk with 4 deep in sand
		for x = 0,15 do
			for z = 0,15 do
				local height = ChunkDesc:GetHeight(x,z)
				ChunkDesc:SetBlockType(x, height + 1, z, E_BLOCK_SAND)
				ChunkDesc:SetBlockType(x, height + 2, z, E_BLOCK_SAND)
				ChunkDesc:SetBlockType(x, height + 3, z, E_BLOCK_SAND)
				ChunkDesc:SetBlockType(x, height + 4, z, E_BLOCK_SAND)
				if math.random() < 0.0007 then
					ChunkDesc:SetBlockType(x, height + 5, z, E_BLOCK_DEAD_BUSH)
				end

				-- Place lava
				ChunkDesc:SetBlockType(x, 1, z, E_BLOCK_STATIONARY_LAVA)
				ChunkDesc:SetBlockType(x, 2, z, E_BLOCK_STATIONARY_LAVA)
				ChunkDesc:SetBlockType(x, 3, z, E_BLOCK_STATIONARY_LAVA)

				-- Seed Ores
				for y = 4,height do
					if ChunkDesc:GetBlockType(x,y,z) == E_BLOCK_STONE then
						if y < 16 and math.random() < 0.001 then
							ChunkDesc:SetBlockType(x, y, z, E_BLOCK_DIAMOND_ORE)
						elseif y < 25 and math.random() < 0.002 then
							ChunkDesc:SetBlockType(x, y, z, E_BLOCK_LAPIS_ORE)
						elseif y < 25 and math.random() < 0.002 then
							ChunkDesc:SetBlockType(x, y, z, E_BLOCK_REDSTONE_ORE)
						elseif y < 55 and math.random() < 0.01 then 
							ChunkDesc:SetBlockType(x, y, z, E_BLOCK_IRON_ORE)
						elseif math.random() < 0.05 then
							ChunkDesc:SetBlockType(x, y, z, E_BLOCK_COAL_ORE)
						elseif math.random() < 0.0001 then
							ChunkDesc:SetBlockType(x, y, z, E_BLOCK_EMERALD_ORE)
						end
					end
				end

			end
		end

		return true
	--end
	--return false
end

-- Crafting Callbacks
function OnPreCrafting(Player, Grid, Recipe)
	local recipe_found = false

	for i,recipe in ipairs(wasteland_Recipes) do 
		if recipe ~= nil and CraftingRecipe_Compare(recipe,Grid) then
			recipe_found = true
			local result = CraftingRecipe_GetResult(recipe):CopyOne()
			result.m_ItemCount = CraftingRecipe_GetResult(recipe).m_ItemCount
			Recipe:SetResult(result)

			for x = 0, Grid:GetWidth() - 1 do
				for y = 0, Grid:GetHeight() - 1 do
					Recipe:SetIngredient(x,y, Grid:GetItem(x,y):CopyOne())
				end
			end
			break
		end
	end


	return recipe_found
end





-- Block Breaking Callback
function OnBlockBroken(Player, BlockX, BlockY, BlockZ, BlockFace, BlockType, BlockMeta)
	local handler = BrokenBlockHooks[BlockType]
	if handler ~= nil then
		return handler(Player, BlockX, BlockY, BlockZ, BlockFace, BlockMeta)
	end
end

-- Player Right Click Handler
function OnPlayerRightClick(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ)
	local held_item = Player:GetEquippedItem()
	if held_item.m_ItemCount > 0 then
		local handler = PlayerRightClick[held_item.m_ItemType]

		if handler ~= nil then
			return handler(Player, held_item, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ)
		end
	end
end

-- Grass Spread Handler
function OnGrassSpread(World, BlockX, BlockY, BlockZ, Source)
	if Source == ssGrassSpread and not World:IsBlockDirectlyWatered(BlockX, BlockY, BlockZ) then
		return true
	end
end




