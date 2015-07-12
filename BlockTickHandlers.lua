

function OnTickGrassBlock(World, BlockX, BlockY, BlockZ, BlockType, BlockMeta, SkyLight, BlockLight)
	if math.random() < (SkyLight / 16) and not World:IsBlockDirectlyWatered(BlockX, BlockY, BlockZ) then
		World:SetBlock(BlockX, BlockY, BlockZ, E_BLOCK_DIRT, E_META_DIRT_NORMAL)
		return true
	end
end


function OnMagmaCore(World, BlockX, BlockY, BlockZ, BlockType, BlockMeta, SkyLight, BlockLight)
	if BlockY < 4 and BlockY > 0 and BlockType ~= E_BLOCK_STATIONARY_LAVA then
		World:SetBlock(BlockX, BlockY, BlockZ, E_BLOCK_STATIONARY_LAVA, 0)
		return true
	end
end