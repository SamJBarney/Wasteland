PlayerRightClick = {}

PlayerRightClick[E_ITEM_SEEDS] = function(Player, HeldItem, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ)
	
	if HeldItem.m_CustomName == w_Items['wasteland:seed'].m_CustomName then
		local World = Player:GetWorld()
		local Valid, BlockType, BlockMeta = World:GetBlockInfo(BlockX, BlockY, BlockZ)
		local above = World:GetBlock(BlockX, BlockY + 1, BlockZ)

		if BlockType == E_BLOCK_FARMLAND and BlockFace == BLOCK_FACE_TOP and (World:IsBlockDirectlyWatered(BlockX, BlockY, BlockZ) or World:GetBiomeAt(BlockX, BlockZ) ~= biDesert) then
			local choice = math.random(5)
			local crop = {E_BLOCK_CARROTS,E_BLOCK_MELON_STEM, E_BLOCK_POTATOES, E_BLOCK_CROPS, E_BLOCK_PUMPKIN_STEM}
			crop = crop[choice]
			if above == E_BLOCK_AIR then
				World:SetBlock(BlockX, BlockY + 1, BlockZ, crop, 0)
				HeldItem.m_ItemCount = HeldItem.m_ItemCount - 1
				if HeldItem.m_ItemCount == 0 then
					HeldItem.m_ItemType = E_BLOCK_AIR
				end
			end
		elseif BlockType == E_BLOCK_DIRT  and above == E_BLOCK_AIR and (BlockMeta == E_META_DIRT_NORMAL or (BlockMeta == E_META_DIRT_COARSE and math.random() < 0.5 )) then
			local trees = {E_META_SAPLING_ACACIA, E_META_SAPLING_APPLE, E_META_SAPLING_BIRCH, E_META_SAPLING_CONIFER, E_META_SAPLING_DARK_OAK, E_META_SAPLING_JUNGLE}
			local meta = trees[math.random(6)]
			World:SetBlock(BlockX, BlockY + 1, BlockZ, E_BLOCK_SAPLING, meta)
			HeldItem.m_ItemCount = HeldItem.m_ItemCount - 1
			if HeldItem.m_ItemCount == 0 then
				HeldItem.m_ItemType = E_BLOCK_AIR
			end
		end
	end
	return true
end
