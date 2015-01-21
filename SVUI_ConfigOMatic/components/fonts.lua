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
local unpack 	 =  _G.unpack;
local pairs 	 =  _G.pairs;
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
local L = SV.L;
local _, ns = ...;

local AceGUIWidgetLSMlists = AceGUIWidgetLSMlists;

local FONT_INFO = {
	{"System Dialog", 1, "The most commonly used fonts. Changing these will require reloading the UI.",
		{
			["default"] = {
				order = 1,
				name = "Default",
				desc = "Standard font for the majority of uses."
			},
			["dialog"] = {
				order = 2,
				name = "Dialog",
				desc = "Font used in places that story text appears. (ie.. quest text)"
			},
			["combat"] = {
				order = 3,
				name = "Combat",
				desc = "Scrolling combat text font."
			}, 
	    	["alert"] = {
	    		order = 4,
				name = "Alerts",
	    		desc = "Font used for on-screen message alerts."
	    	},
	    	["zone"] = {
	    		order = 5,
				name = "Zone Text",
	    		desc = "Font used for zone names. Shown when changing zones."
	    	},
	    	["title"] = {
	    		order = 6,
				name = "Titles",
	    		desc = "Font used to display various titles."
	    	},
	    	["header"] = {
	    		order = 7,
				name = "Frame Headers",
	    		desc = "Font used to large names at the top of some frames."
	    	},
	    	["caps"] = {
	    		order = 8,
				name = "Caps",
	    		desc = "Font typically used for things like tabs and fitted headers."
	    	},
		},
	},
	{"System Numeric", 2, "These fonts are used for many number values.", 
		{
			["number"] = {
				order = 1,
				name = "Numbers (Regular)",
				desc = "Font used to display most numeric values."
			},
			["number_big"] = {
	    		order = 2,
				name = "Numbers (Large)",
	    		desc = "Font used to display larger numeric values."
	    	},
			["aura"]   = {
				order = 3,
				name = "Auras",
				desc = "Aura counts and timers use this font."
			},
		},
	},
	{"Chat", 3, "Fonts used for the chat frame.", 
		{
			["chatdialog"] = {
				order = 1,
				name = "Chat",
				desc = "Font used for chat text."
			},
			["chattab"] = {
				order = 2,
				name = "Chat Tabs",
				desc = "Font used for chat tab labels."
			},
		},
	},
	{"QuestTracker", 4, "Fonts used in the SVUI Quest Tracker.", 
		{
			["questdialog"] = {
				order = 1,
				name = "Quest Tracker Dialog",
				desc = "Default font used in the quest tracker"
			},
		    ["questheader"] = {
				order = 2,
				name = "Quest Tracker Titles",
				desc = "Font used in the quest tracker for listing headers."
			}, 
		    ["questnumber"] = {
				order = 3,
				name = "Quest Tracker Numbers",
				desc = "Font used in the quest tracker to display numeric values."
			},
		},
	},
	{"NamePlate", 5, "Fonts used in name plates.", 
		{
			["platename"] = {
				order = 1,
				name = "Nameplate Names",
				desc = "Used on nameplates for unit names."
			},
			["platenumber"] = {
				order = 2,
				name = "Nameplate Numbers",
				desc = "Used on nameplates for health and level numbers."
			},
		    ["plateaura"] = {
				order = 3,
				name = "Nameplate Auras",
				desc = "Used on nameplates for aura texts."
			},
		},
	},
	{"UnitFrame", 6, "Fonts used in unit frames.", 
		{
			["unitaurabar"] = {
				order = 1,
				name = "Unitframe AuraBar",
				desc = "Used on unit aurabars."
			},
		    ["unitauramedium"] = {
				order = 2,
				name = "Unitframe Aura (Medium)",
				desc = "Used on unit frames for auras (medium scale)."
			},
		    ["unitauralarge"] = {
				order = 3,
				name = "Unitframe Aura (Large)",
				desc = "Used on unit frames for auras (large scale)."
			},
		    ["unitaurasmall"] = {
				order = 4,
				name = "Unitframe Aura (Small)",
				desc = "Used on unit frames for auras (small scale)."
			},
		    ["unitprimary"] = {
				order = 5,
				name = "Unitframe Values",
				desc = "Used on all primary unit frames for health, power and misc values.\nUnits: player, pet, target, focus, boss and arena"
			},
		    ["unitsecondary"] = {
				order = 6,
				name = "Unitframe Values",
				desc = "Used on all non-primary unit frames for health, power and misc values.\nUnits: pettarget, targettarget, focustarget, party, raid, raidpet, tank and assist."
			},
		},
	},
	{"Bags", 7, "Fonts used in bag slots.", 
		{
			["bagdialog"] = {
				order = 1,
				name = "Bag Slot Dialog",
				desc = "Default font used in bag and bank slots"
			},
		    ["bagnumber"] = {
				order = 2,
				name = "Bag Slot Numbers",
				desc = "Font used in bag and bank slots to display numeric values."
			},
		},
	},
	{"Tooltip", 8, "Fonts used in tooltips.", 
		{
			["tipdialog"] = {
				order = 1,
				name = "Tooltip Dialog",
				desc = "Default font used in tooltips"
			},
		    ["tipheader"] = {
				order = 2,
				name = "Tooltip Headers",
				desc = "Font used in tooltips to display large names."
			},
		},
	},
	{"Loot", 9, "Fonts used in loot frames.", 
		{
			["lootdialog"] = {
				order = 1,
				name = "Loot Frame Dialog",
				desc = "Default font used in the loot frame"
			},
		    ["lootnumber"] = {
				order = 2,
				name = "Loot Frame Numbers",
				desc = "Font used in the loot frame to display numeric values."
			},
			["rolldialog"] = {
				order = 3,
				name = "Roll Frame Dialog",
				desc = "Default font used in the loot-roll frame"
			},
		    ["rollnumber"] = {
				order = 4,
				name = "Roll Frame Numbers",
				desc = "Font used in the loot-roll frame to display numeric values."
			},
		},
	},
	{"Misc", 10, "Fonts used in various places including the docks.", 
		{
			["data"] = {
				order = 1,
				name = "Docked Stats",
				desc = "Font used by the bottom and top data docks."
			},
	    	["narrator"] = {
	    		order = 2,
				name = "Narratives",
	    		desc = "Font used for things like the 'Meanwhile' tag."
	    	},
	    	["pixel"] = {
	    		order = 3,
				name = "Pixel",
	    		desc = "Tiniest fonts."
	    	}, 
		},
	},
};

local function GenerateFontGroup()
    local fontGroupArgs = {};

    for _, listData in ipairs(FONT_INFO) do
    	local orderCount = 3;
    	local groupName = listData[1];
    	local groupCount = listData[2];
    	local groupOverview = listData[3];
    	local groupList = listData[4];
    	fontGroupArgs[groupName] = {
			order = groupCount, 
			type = "group", 
			name = groupName,
			args = {
				overview = {
					order = 1, 
					name = groupOverview, 
					type = "description", 
					width = "full", 
				},
				spacer0 = {
					order = 2, 
					name = "", 
					type = "description", 
					width = "full", 
				},
			}, 
		};
    	for template, info in pairs(groupList) do
	    	fontGroupArgs[groupName].args[template] = {
	    		order = orderCount + info.order, 
				type = "group",
				guiInline = true,
				name = info.name,
				get = function(key)
					return SV.db.font[template][key[#key]]
				end,
				set = function(key,value)
					SV.db.font[template][key[#key]] = value;
					if(groupCount == 1) then
						SV:StaticPopup_Show("RL_CLIENT")
					else
						SV.Events:Trigger("SVUI_FONTGROUP_UPDATED", template);
					end
				end,
				args = {
					description = {
						order = 1, 
						name = info.desc, 
						type = "description", 
						width = "full", 
					},
					spacer1 = {
						order = 2, 
						name = "", 
						type = "description", 
						width = "full", 
					},
					spacer2 = {
						order = 3, 
						name = "", 
						type = "description", 
						width = "full", 
					},
					file = {
						type = "select",
						dialogControl = 'LSM30_Font',
						order = 4,
						name = L["Font File"],
						desc = L["Set the font file to use with this font-type."],
						values = AceGUIWidgetLSMlists.font,
					},
					outline = {
						order = 5, 
						name = L["Font Outline"], 
						desc = L["Set the outlining to use with this font-type."], 
						type = "select", 
						values = {
							["NONE"] = L["None"], 
							["OUTLINE"] = "OUTLINE", 
							["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
							["THICKOUTLINE"] = "THICKOUTLINE"
						},
					},
					size = {
						order = 6,
						name = L["Font Size"],
						desc = L["Set the font size to use with this font-type."],
						type = "range",
						min = 6,
						max = 64,
						step = 1,
					},
				}
	    	}
	    end
    end

    return fontGroupArgs;
end 

SV.Options.args.fonts = {
	order = 4, 
	type = "group", 
	name = L['Fonts'],
	childGroups = "tab", 
	args = {
		resetData = {
			order = 1, 
			type = "execute", 
			name = L["Reset All Fonts"], 
			desc = L["Restore all fonts to their default settings"], 
			func = function()
				SV:ResetData("font")
				SV.Events:Trigger("SVUI_ALLFONTS_UPDATED");
			end,
		},
		commonGroup = {
			order = 2, 
			type = 'group', 
			name = L['Font Options'], 
			childGroups = "tree", 
			args = GenerateFontGroup()
		}
	}
};

function ns:SetToFontConfig(font)
	font = font or "Default";
	_G.LibStub("AceConfigDialog-3.0"):SelectGroup(SV.NameID, "fonts", "commonGroup", font);
end