BrokenBlockHooks = {}

BrokenBlockHooks[E_BLOCK_DEAD_BUSH] =  function(Player, BlockX, BlockY, BlockZ, BlockFace, BlockMeta)

	-- Only call this handler if the bush was broken by a player
	if Player == nil then
		return false
	end


	local equipped = Player:GetEquippedItem()

	-- Only drop things if the player is not equipping shears
	if equipped.m_ItemType ~= E_ITEM_SHEARS then
		Pickups = cItems()

		-- Give 1 to 2 sticks
		Pickups:Add(cItem(E_ITEM_STICK, math.random(1,2)))

		-- Only spawn seeds every once in a while
		if math.random() < 0.5 then
			Pickups:Add(w_Items['wasteland:seed']:CopyOne())
		end

		-- Spawn the item drops
		local World = Player:GetWorld()
		World:SpawnItemPickups(Pickups, BlockX,BlockY,BlockZ, 0)
	return true
	end
	return false
end