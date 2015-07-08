

function CraftingRecipe_GetIndex(self, X,Y)
	return Y * self.width + X + 1
end

function CraftingRecipe_new(width, height)
	local tmp = { width=3, height=3, items={}, result=cItem()}

	-- set values
	if width ~= nil then tmp.width = width end
	if height ~= nil then tmp.height = height end

	-- Initialize item grid
	for x = 1,tmp.width do
		for y = 1, tmp.height do
			tmp.items[CraftingRecipe_GetIndex(tmp,x,y)] = cItem()
		end
	end


	return tmp
end

function CraftingRecipe_GetWidth(self)
	return self.width
end

function CraftingRecipe_GetHeight(self)
	return self.height
end

function CraftingRecipe_GetItem(self, X,Y)
	if X >= self.width or Y >= self.height or X < 0 or Y < 0 then return false end
	local idx = CraftingRecipe_GetIndex(self, X,Y)
	return self.items[idx]
end

function CraftingRecipe_SetItem(self, X, Y, a_Item)
	if X >= self.width or Y >= self.height or X < 0 or Y < 0 then return false end

	-- Get the index
	local idx = CraftingRecipe_GetIndex(self,X,Y)
	-- Get the previous value
	local previous = self.items[idx]

	-- 
	self.items[idx] = a_Item
	return previous
end

function CraftingRecipe_GetResult(self) 
	return self.result
end

function CraftingRecipe_SetResult(self, a_Item)
	local previous = self.result
	self.result = a_Item
	return previous
end

function CraftingRecipe_ClearItem(self, X,Y)
	return CraftingRecipe_SetItem(self, X,Y, cItem())
end

-- Returns true when the two CraftingRecipe objects have the same crafting inputs
function CraftingRecipe_CompareCraftingRecipe(self, a_Recipe)
	if a_Recipe.width ~= self.width or a_Recipe.height ~= self.height then return false end

	local equal = true

	for x=0,self.width-1 do
		for y=0,self.height-1 do
			local idx = CraftingRecipe_GetIndex(self, x,y)
			local i1 = self.items[idx]
			local i2 = a_Recipe.items[idx]
			equal = equal and i1.m_ItemType == i2.m_ItemType and i1.m_ItemDamage == i2.m_ItemDamage and i1.m_CustomName == i2.m_CustomName
			if not equal then
				return false
			end
		end
	end

	return true
end

function CraftingRecipe_CompareCraftingGrid(self, a_Grid)
	local found = false
	local matching_positions = {}
	local offset_width = a_Grid:GetWidth() - CraftingRecipe_GetWidth(self)
	local offset_height = a_Grid:GetHeight() - CraftingRecipe_GetHeight(self)
	for x_offset = 0, offset_width do
		for y_offset = 0, a_Grid:GetHeight() - CraftingRecipe_GetHeight(self) do
			local equal = true
			for x = 0,CraftingRecipe_GetWidth(self)-1 do
				for y=0,CraftingRecipe_GetHeight(self)-1 do
					local i1 = CraftingRecipe_GetItem(self, x, y)
					local i2 = a_Grid:GetItem(x+x_offset, y+y_offset)
					equal = equal and i1.m_ItemType == i2.m_ItemType and i1.m_ItemDamage == i2.m_ItemDamage and i1.m_CustomName == i2.m_CustomName
					matching_positions[(x_offset + x) .. (y_offset+y)] = true
				end
			end
			if equal then
				found = true
				break
			else
				matching_positions = {}
			end
		end
		if found then break end
	end

	if found  then
		for x=0,a_Grid:GetWidth() - 1 do
			for y=0,a_Grid:GetHeight()-1 do
				local idx = x .. y
				if matching_positions[idx] == nil then
					local item = a_Grid:GetItem(x,y)
					if item.m_ItemCount ~= 0 then
						found = false
						break
					end
				end
			end
			if not found then break end
		end
	end

	return found
end


function CraftingRecipe_Compare(self, a_Comparable, isCraftingRecipeType)
	if isCraftingRecipeType == nil then
		return CraftingRecipe_CompareCraftingGrid(self, a_Comparable)
	else
		return CraftingRecipe_CompareCraftingRecipe(self, a_Recipe)
	end
end
