

function OnTickGrassBlock(World, BlockX, BlockY, BlockZ, BlockType, BlockMeta, SkyLight, BlockLight)
	if math.random() < (SkyLight / 16) and not World:IsBlockDirectlyWatered(BlockX, BlockY, BlockZ) then
		World:SetBlock(BlockX, BlockY, BlockZ, E_BLOCK_DIRT, E_META_DIRT_NORMAL)
		return true
	end
end

local to_lava = {}

-- Number to beat to turn into lava
to_lava[E_BLOCK_COBBLESTONE] = 0.5
to_lava[E_BLOCK_STONE] = 0.5
to_lava[E_BLOCK_GRAVEL] = 0.5
to_lava[E_BLOCK_NETHERRACK] = 0.5
to_lava[E_BLOCK_COAL_ORE] = 0.25
to_lava[E_BLOCK_LAPIS_ORE] = 0.1
to_lava[E_BLOCK_IRON_ORE] = 0.09
to_lava[E_BLOCK_GOLD_ORE] = 0.08
to_lava[E_BLOCK_REDSTONE_ORE] = 0.05
to_lava[E_BLOCK_OBSIDIAN] = 0.05
to_lava[E_BLOCK_DIAMOND_ORE] = 0
to_lava[E_BLOCK_EMERALD_ORE] = 0

local from_lava = {}
from_lava[1] = {E_BLOCK_COBBLESTONE}
from_lava[0.8] = {E_BLOCK_STONE}
from_lava[0.6] = {E_BLOCK_COAL_ORE}
from_lava[0.5] = {E_BLOCK_GOLD_ORE}
from_lava[0.45] = {E_BLOCK_IRON_ORE}
from_lava[0.15] = {E_BLOCK_LAPIS_ORE, E_BLOCK_REDSTONE_ORE}
from_lava[0.2] = {E_BLOCK_OBSIDIAN}
from_lava[0.1] = {E_BLOCK_DIAMOND_ORE,E_BLOCK_EMERALD_ORE}

local type_names = {}

type_names[E_BLOCK_COAL_ORE] = 'Coal Ore'
type_names[E_BLOCK_COBBLESTONE] = 'Cobblestone'
type_names[E_BLOCK_STONE] = 'Stone'
type_names[E_BLOCK_GOLD_ORE] = 'Gold Ore'
type_names[E_BLOCK_IRON_ORE] = 'Iron Ore'
type_names[E_BLOCK_LAPIS_ORE] = 'Lapis Ore'
type_names[E_BLOCK_REDSTONE_ORE] = 'Redstone Ore'
type_names[E_BLOCK_OBSIDIAN] = 'Obsidian'
type_names[E_BLOCK_DIAMOND_ORE] = 'Diamond Ore'
type_names[E_BLOCK_EMERALD_ORE] = 'Emerald Ore'


function OnMagmaCore(World, BlockX, BlockY, BlockZ, BlockType, BlockMeta, SkyLight, BlockLight)
	local heat = 1/(BlockY+12)
	local test = to_lava[BlockType]
	if test ~= nil and (math.random() - heat) < test then
		World:SetBlock(BlockX, BlockY, BlockZ, E_BLOCK_STATIONARY_LAVA, 0)
		return true
	end
end

function OnSolidifying(World, BlockX, BlockY, BlockZ, BlockType, BlockMeta, SkyLight, BlockLight)
	if BlockType == E_BLOCK_STATIONARY_LAVA then
		local heat = 1/(BlockY+12)
		local solid_point = math.random() - heat

		local last_match = nil
		for test, types in pairs(from_lava) do
			if solid_point < test then
				last_match = types
			end
		end
		local match =  math.random(table.getn(last_match))
		local name = type_names[last_match[match]]
		World:SetBlock(BlockX, BlockY, BlockZ, last_match[match], 0)
		return true
	end
end