--[[
##############################################################################
_____/\\\\\\\\\\\____/\\\________/\\\__/\\\________/\\\__/\\\\\\\\\\\_       #
 ___/\\\/////////\\\_\/\\\_______\/\\\_\/\\\_______\/\\\_\/////\\\///__      #
  __\//\\\______\///__\//\\\______/\\\__\/\\\_______\/\\\_____\/\\\_____     #
   ___\////\\\__________\//\\\____/\\\___\/\\\_______\/\\\_____\/\\\_____    #
    ______\////\\\________\//\\\__/\\\____\/\\\_______\/\\\_____\/\\\_____   #
     _________\////\\\______\//\\\/\\\_____\/\\\_______\/\\\_____\/\\\_____  #
      __/\\\______\//\\\______\//\\\\\______\//\\\______/\\\______\/\\\_____ #
       _\///\\\\\\\\\\\/________\//\\\________\///\\\\\\\\\/____/\\\\\\\\\\\_#
        ___\///////////___________\///___________\/////////_____\///////////_#
##############################################################################
S U P E R - V I L L A I N - U I   By: Munglunch                              #
##############################################################################
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack        = _G.unpack;
local select        = _G.select;
local assert        = _G.assert;
local type          = _G.type;
local error         = _G.error;
local pcall         = _G.pcall;
local print         = _G.print;
local ipairs        = _G.ipairs;
local pairs         = _G.pairs;
local next          = _G.next;
local rawset        = _G.rawset;
local rawget        = _G.rawget;
local tostring      = _G.tostring;
local tonumber      = _G.tonumber;
local getmetatable  = _G.getmetatable;
local setmetatable  = _G.setmetatable;
local tinsert 	 =  _G.tinsert;
local table 	 =  _G.table;
--[[ TABLE METHODS ]]--
local tsort = table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = _G["SVUI"];
local MOD = SV.SVUnit;
if(not MOD) then return end
local L = SV.L;
local _, ns = ...;
local tempFilterTable = {};
local watchedBuffs = {};

local NONE = _G.NONE;
local GetSpellInfo = _G.GetSpellInfo;
local collectgarbage = _G.collectgarbage;

local DEFAULT_COLOR = {["r"] = 1, ["g"] = 0, ["b"] = 0};
local STYLE_SELECT = {["coloredIcon"] = L["Colored Icon"], ["texturedIcon"] = L["Textured Icon"], [""] = NONE};
local POSITION_SELECT = {
	["TOPLEFT"] = "TOPLEFT", 
	["TOPRIGHT"] = "TOPRIGHT", 
	["BOTTOMLEFT"] = "BOTTOMLEFT", 
	["BOTTOMRIGHT"] = "BOTTOMRIGHT", 
	["LEFT"] = "LEFT", 
	["RIGHT"] = "RIGHT", 
	["TOP"] = "TOP", 
	["BOTTOM"] = "BOTTOM"
};

if(not SV.filters.PetBuffWatch) then 
	SV.filters.PetBuffWatch = {}
end

if(not SV.filters.BuffWatch) then 
	SV.filters.BuffWatch = {}
end

local function CacheWatchedBuffs(data)
	wipe(watchedBuffs)
	for spellID, watchData in pairs(data) do 
		tinsert(watchedBuffs, watchData)
	end
end

local function SetWatchedBuff(stringID, id, data, enable, point, color, anyUnit)
	if(not data[id]) then
		data[stringID] = {["enable"] = enable, ["id"] = id, ["point"] = point, ["color"] = color, ["anyUnit"] = anyUnit}
	else
		data[stringID]["id"] = id;
		data[stringID]["enable"] = enable;
		data[stringID]["point"] = point;
		data[stringID]["color"] = color;
		data[stringID]["anyUnit"] = anyUnit;
	end
end

local function UpdateBuffWatch()
	MOD:SetUnitFrame("focus")
	MOD:SetGroupFrame("raid")
	MOD:SetGroupFrame("party") 
end

local function UpdatePetBuffWatch()
	MOD:SetUnitFrame("pet")
	MOD:SetGroupFrame("raidpet")
end

ns.FilterOptionGroups['BuffWatch'] = function(selectedSpell)
	local FILTER = SV.filters.BuffWatch;

	--CacheWatchedBuffs(SV.filters.BuffWatch)

	local RESULT = {
		type = "group", 
		name = 'BuffWatch', 
		guiInline = true, 
		order = 4, 
		args = {
			addSpellID = {
				order = 1, 
				name = L["Add SpellID"], 
				desc = L["Add a spell to the filter."], 
				type = "input", 
				get = function(key)return""end, 
				set = function(key, value)
					local spellID = tonumber(value);
					if(not spellID) then 
						SV:AddonMessage(L["Value must be a number"])
					elseif(not GetSpellInfo(spellID)) then 
						SV:AddonMessage(L["Not valid spell id"])
					else
						SetWatchedBuff(value, spellID, FILTER, true, "TOPRIGHT", DEFAULT_COLOR, false)
						UpdateBuffWatch()
						ns:SetFilterOptions('BuffWatch', spellID)
					end 
				end
			}, 
			removeSpellID = {
				order = 2, 
				name = L["Remove SpellID"], 
				desc = L["Remove a spell from the filter."], 
				type = "input", 
				get = function(key)return""end, 
				set = function(key, value)
					local spellID = tonumber(value);
					if(not spellID) then 
						SV:AddonMessage(L["Value must be a number"])
					elseif(not GetSpellInfo(spellID)) then 
						SV:AddonMessage(L["Not valid spell id"])
					else 
						local temp;
						for id, data in pairs(FILTER) do 
							if(tonumber(id) == spellID) then 
								temp = data;
								FILTER[id] = nil  
							end 
						end 
						if temp == nil then 
							SV:AddonMessage(L["Spell not found in list."])
						else 
							ns:SetFilterOptions('BuffWatch')
						end 
					end
					UpdateBuffWatch("raid")
					UpdateBuffWatch("party")
					ns:SetFilterOptions('BuffWatch')
				end
			}, 
			selectSpell = {
				name = L["Select Spell"], 
				type = "select", 
				order = 3, 
				values = function()
					--CacheWatchedBuffs(SV.filters.BuffWatch)
					wipe(tempFilterTable)
					for id, watchData in pairs(FILTER) do
						local spellID = tonumber(id)
						local name = GetSpellInfo(spellID)
						if(name) then 
							tempFilterTable[spellID] = name 
						end 
					end 
					return tempFilterTable  
				end, 
				get = function(key) return selectedSpell end, 
				set = function(key, value) ns:SetFilterOptions('BuffWatch', value) end
			}
		}
	}
	return RESULT;
end;

ns.FilterSpellGroups['BuffWatch'] = function(selectedSpell)
	local RESULT;
	local FILTER = SV.filters.BuffWatch;

	if(selectedSpell) then
		local registeredSpell;

		for id, watchData in pairs(FILTER)do 
			if(tonumber(id) == selectedSpell) then 
				registeredSpell = id 
			end 
		end

		local currentSpell = GetSpellInfo(selectedSpell)

		if(currentSpell and registeredSpell) then

			RESULT = {
				name = currentSpell.." (Spell ID#: "..selectedSpell..")", 
				type = "group", 
				guiInline = true, 
				get = function(key) return FILTER[registeredSpell][key[#key]] end, 
				set = function(key, value)
					SV.filters.BuffWatch[registeredSpell][key[#key]] = value;
					UpdateBuffWatch();
				end, 
				order = 5, 
				args = {
					enable = {
						name = L["Enable"], 
						width = 'full',
						order = 0, 
						type = "toggle"
					},  
					displayText = {
						name = L["Display Text"], 
						width = 'full',
						type = "toggle", 
						order = 1,
					}, 
					anyUnit = {
						name = L["Show Aura From Other Players"], 
						width = 'full',
						order = 2, 
						type = "toggle"
					}, 
					onlyShowMissing = {
						name = L["Show When Not Active"], 
						width = 'full',
						order = 3, 
						type = "toggle", 
						disabled = function() return FILTER[registeredSpell].style == "text" end
					},
					point = {
						name = L["Anchor Point"], 
						order = 4, 
						type = "select", 
						values = POSITION_SELECT
					}, 
					style = {
						name = L["Style"], 
						order = 5, 
						type = "select", 
						values = STYLE_SELECT
					},
					color = {
						name = L["Color"], 
						type = "color", 
						order = 6, 
						get = function(key)
							local abColor = FILTER[registeredSpell][key[#key]]
							return abColor.r,  abColor.g,  abColor.b,  abColor.a 
						end, 
						set = function(key, r, g, b)
							local abColor = FILTER[registeredSpell][key[#key]]
							abColor.r,  abColor.g,  abColor.b = r, g, b;
							UpdateBuffWatch()
						end
					}, 
					textColor = {
						name = L["Text Color"], 
						type = "color", 
						order = 7, 
						get = function(key)
							local abColor = FILTER[registeredSpell][key[#key]]
							if abColor then 
								return abColor.r,  abColor.g,  abColor.b,  abColor.a 
							else 
								return 1, 1, 1, 1 
							end 
						end, 
						set = function(key, r, g, b)
							FILTER[registeredSpell][key[#key]] = FILTER[registeredSpell][key[#key]] or {}
							local abColor = FILTER[registeredSpell][key[#key]]
							abColor.r,  abColor.g,  abColor.b = r, g, b;
							UpdateBuffWatch()
						end
					},
					textThreshold = {
						name = L["Text Threshold"], 
						desc = L["At what point should the text be displayed. Set to -1 to disable."], 
						type = "range", 
						order = 8, 
						width = 'full', 
						min = -1, 
						max = 60, 
						step = 1
					}, 
					xOffset = {order = 9, type = "range", width = 'full', name = L["xOffset"], min = -75, max = 75, step = 1}, 
					yOffset = {order = 10, type = "range", width = 'full', name = L["yOffset"], min = -75, max = 75, step = 1}, 
				}
			}
		end
	end
	return RESULT;
end;

ns.FilterOptionGroups['PetBuffWatch'] = function(selectedSpell)
	--CacheWatchedBuffs(SV.filters.PetBuffWatch)
	local FILTER = SV.filters.PetBuffWatch;
	local RESULT = {
		type = "group", 
		name = 'PetBuffWatch', 
		guiInline = true, 
		order = 4,  
		args = {
			addSpellID = {
				order = 1, 
				name = L["Add SpellID"], 
				desc = L["Add a spell to the filter."], 
				type = "input", 
				get = function(key) return "" end, 
				set = function(key, value)
					local spellID = tonumber(value);
					if(not spellID) then 
						SV:AddonMessage(L["Value must be a number"])
					elseif(not GetSpellInfo(spellID)) then 
						SV:AddonMessage(L["Not valid spell id"])
					else  
						SetWatchedBuff(value, spellID, FILTER, true, "TOPRIGHT", DEFAULT_COLOR, true)
						UpdatePetBuffWatch()
						ns:SetFilterOptions('PetBuffWatch', spellID)
					end 
				end
			}, 
			removeSpellID = {
				order = 2, 
				name = L["Remove SpellID"], 
				desc = L["Remove a spell from the filter."], 
				type = "input", 
				get = function(key) return "" end, 
				set = function(key, value)
					local spellID = tonumber(value);
					if(not spellID) then 
						SV:AddonMessage(L["Value must be a number"])
					elseif(not GetSpellInfo(spellID)) then 
						SV:AddonMessage(L["Not valid spell id"])
					else  
						local success = false;
						for id, data in pairs(FILTER) do 
							if(tonumber(id) == spellID) then 
								success = true;
								data.enable = false; 
							end 
						end 
						if not success then 
							SV:AddonMessage(L["Spell not found in list."])
						else 
							ns:SetFilterOptions()
						end 
					end 
					UpdatePetBuffWatch()
					ns:SetFilterOptions('PetBuffWatch', value)
				end
			}, 
			selectSpell = {
				name = L["Select Spell"], 
				type = "select", 
				order = 3, 
				values = function()
					--CacheWatchedBuffs(FILTER)
					wipe(tempFilterTable)
					for id, watchData in pairs(FILTER) do
						local spellID = tonumber(id)
						local name = GetSpellInfo(spellID)
						if(name) then 
							tempFilterTable[spellID] = name 
						end 
					end 
					return tempFilterTable
				end, 
				get = function(key) return selectedSpell end, 
				set = function(key, value) ns:SetFilterOptions('PetBuffWatch', value) end
			}
		}
	};

	return RESULT;
end;

ns.FilterSpellGroups['PetBuffWatch'] = function(selectedSpell)
	local RESULT;
	local FILTER = SV.filters.PetBuffWatch;

	if(selectedSpell) then
		local registeredSpell;

		for id, watchData in pairs(FILTER)do 
			if(tonumber(id) == selectedSpell) then 
				registeredSpell = id 
			end 
		end

		local currentSpell = GetSpellInfo(selectedSpell)

		if(currentSpell and registeredSpell) then

			RESULT = {
				name = currentSpell.." ("..selectedSpell..")", 
				type = "group", 
				get = function(key)return FILTER[registeredSpell][key[#key]] end, 
				set = function(key, value)
					FILTER[registeredSpell][key[#key]] = value;
					UpdatePetBuffWatch()
				end, 
				order = 5, 
				guiInline = true,
				args = {
					enable = {
						name = L["Enable"], 
						order = 0, 
						type = "toggle"
					}, 
					point = {
						name = L["Anchor Point"], 
						order = 1, 
						type = "select", 
						values = POSITION_SELECT
					}, 
					xOffset = {order = 2, type = "range", name = L["xOffset"], min = -75, max = 75, step = 1}, 
					yOffset = {order = 2, type = "range", name = L["yOffset"], min = -75, max = 75, step = 1}, 
					style = {
						name = L["Style"], 
						order = 3, 
						type = "select", 
						values = STYLE_SELECT

					}, 
					color = {
						name = L["Color"], 
						type = "color", 
						order = 4, 
						get = function(key)
							local abColor = FILTER[registeredSpell][key[#key]]
							return abColor.r,  abColor.g,  abColor.b,  abColor.a 
						end, 
						set = function(key, r, g, b)
							local abColor = FILTER[registeredSpell][key[#key]]
							abColor.r,  abColor.g,  abColor.b = r, g, b;
							UpdatePetBuffWatch()
						end
					}, 
					displayText = {
						name = L["Display Text"],
						type = "toggle",
						order = 5
					},
					textColor = {
						name = L["Text Color"],
						type = "color",
						order = 6,
						get = function(key)
							local abColor = FILTER[registeredSpell][key[#key]]
							if abColor then 
								return abColor.r,abColor.g,abColor.b,abColor.a 
							else 
								return 1,1,1,1 
							end 
						end,
						set = function(key, r, g, b)
							local abColor = FILTER[registeredSpell][key[#key]]
							abColor.r,abColor.g,abColor.b = r, g, b;
							UpdatePetBuffWatch()
						end
					},
					textThreshold = {
						name = L["Text Threshold"],
						desc = L["At what point should the text be displayed. Set to -1 to disable."],
						type = "range",
						order = 6,
						min = -1,
						max = 60,
						step = 1
					},
					anyUnit = {
						name = L["Show Aura From Other Players"],
						order = 7,
						type = "toggle"
					},
					onlyShowMissing = {
						name = L["Show When Not Active"],
						order = 8,
						type = "toggle",
						disabled = function() return FILTER[registeredSpell].style == "text" end
					}
				}
			}
		end
	end

	return RESULT;
end;