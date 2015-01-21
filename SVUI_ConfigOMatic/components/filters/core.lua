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
local wipe       =  _G.wipe;
--[[ TABLE METHODS ]]--
local tsort = table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = _G["SVUI"];
local L = SV.L;
local MOD = SV.SVUnit
if(not MOD) then return end

local _, ns = ...;

ns.FilterOptionGroups = {};
ns.FilterSpellGroups = {};

local allFilterTable, userFilterTable = {},{};
local CURRENT_FILTER_TYPE = NONE;

local NONE = _G.NONE;
local GetSpellInfo = _G.GetSpellInfo;
local collectgarbage = _G.collectgarbage;

local function GetUserFilterList()
	wipe(userFilterTable);

	userFilterTable[""] = NONE;
	for filter in pairs(SV.filters.Custom) do
		userFilterTable[filter] = filter
	end
	return userFilterTable 
end
local function GetAllFilterList()
	wipe(allFilterTable);

	allFilterTable[""] = NONE;
	allFilterTable["BlackList"] = "Blacklist";
	allFilterTable["WhiteList"] = "Whitelist";
	allFilterTable["Raid"] = "Consolidated";
	allFilterTable["AuraBars"] = "AuraBars";
	allFilterTable["Player"] = "Player";
	allFilterTable["BuffWatch"] = "AuraWatch";
	allFilterTable["PetBuffWatch"] = "PetAuraWatch";
	for filter in pairs(SV.filters.Custom) do
		allFilterTable[filter] = filter
	end
	return allFilterTable 
end

SV.Options.args.filters = {
	type = "group",
	name = L["Aura Filters"],
	order = 9997,
	args = {	
		createFilter = {	
			order = 1,
			name = L["Create Filter"],
			desc = L["Create a custom filter."],
			type = "input",
			get = function(key) return "" end,
			set = function(key, value)
				if(not value or (value and value == '')) then 
					SV:AddonMessage(L["Not a usable filter name"])
				elseif(SV.filters.Custom[value]) then 
					SV:AddonMessage(L["Filter already exists"])
				else
					SV.filters.Custom[value] = {};
					ns:SetFilterOptions(value);
				end
			end
		},
		deleteFilter = {
			type = "select",
			order = 2,
			name = L["Delete Filter"],
			desc = L["Delete a custom filter."],
			get = function(key) return "" end,
			set = function(key, value)
				SV.filters.Custom[value] = nil;
				SV.Options.args.filters.args.filterGroup = nil  
			end,
			values = GetUserFilterList()
		},
		selectFilter = {
			order = 3,
			type = "select",
			name = L["Select Filter"],
			get = function(key) return CURRENT_FILTER_TYPE end,
			set = function(key, value) ns:SetFilterOptions(value) end,
			values = GetAllFilterList()
		}
	}
};

function ns:SetFilterOptions(filterType, selectedSpell)
	local FILTER
	CURRENT_FILTER_TYPE = filterType
	if(SV.filters.Custom[filterType]) then 
		FILTER = SV.filters.Custom[filterType] 
	else
		FILTER = SV.filters[filterType]
	end
	if((not filterType) or (filterType == "") or (not FILTER)) then
		SV.Options.args.filters.args.filterGroup = nil;
		SV.Options.args.filters.args.spellGroup = nil;
		return 
	end

	if(not self.FilterOptionGroups[filterType]) then
		self.FilterOptionGroups[filterType] = self.FilterOptionGroups['_NEW'](filterType);
	end

	SV.Options.args.filters.args.filterGroup = self.FilterOptionGroups[filterType](selectedSpell)

	if(not self.FilterSpellGroups[filterType]) then
		self.FilterSpellGroups[filterType] = self.FilterSpellGroups['_NEW'](filterType);
	end

	SV.Options.args.filters.args.spellGroup = self.FilterSpellGroups[filterType](selectedSpell);


	MOD:RefreshUnitFrames()

	collectgarbage("collect")
end


function ns:SetToFilterConfig(newFilter)
	local filter = newFilter or "BuffWatch";
	self:SetFilterOptions(filter);
	_G.LibStub("AceConfigDialog-3.0"):SelectGroup(SV.NameID, "filters");
end