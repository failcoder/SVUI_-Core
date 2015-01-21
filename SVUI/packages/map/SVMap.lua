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
local unpack    = _G.unpack;
local select    = _G.select;
local pairs     = _G.pairs;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local tinsert   = _G.tinsert;
local string    = _G.string;
local math      = _G.math;
--[[ STRING METHODS ]]--
local lower, upper, len = string.lower, string.upper, string.len;
local match, gsub, find = string.match, string.gsub, string.find;
--[[ MATH METHODS ]]--
local parsefloat = math.parsefloat;  -- Uncommon
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L
local MOD = SV:NewPackage("SVMap", L["Minimap"]);
MOD.MinimapButtons = {}
--[[ 
########################################################## 
LOCALIZED GLOBALS
##########################################################
]]--
local CUSTOM_CLASS_COLORS = _G.CUSTOM_CLASS_COLORS
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local temp = SLASH_CALENDAR1:gsub("/", "");
local calendar_string = temp:gsub("^%l", upper)
local cColor = RAID_CLASS_COLORS[SV.class];
local MMBHolder, MMBBar;

local NewHook = hooksecurefunc
local Initialized = false
--[[ 
########################################################## 
DATA UPVALUES
##########################################################
]]--
local MM_XY_COORD = "SIMPLE";
local WM_TINY = false;
local NARR_TEXT = "Meanwhile";
local NARR_PREFIX = "In ";
local NARR_ENABLE = true;
local MM_COLOR = {"VERTICAL", 0.65, 0.65, 0.65, 0.95, 0.95, 0.95}
local MM_BRDR = 0
local MM_SIZE = 240
local MM_OFFSET_TOP = (MM_SIZE * 0.07)
local MM_OFFSET_BOTTOM = (MM_SIZE * 0.11)
local MM_WIDTH = MM_SIZE + (MM_BRDR * 2)
local MM_HEIGHT = (MM_SIZE - (MM_OFFSET_TOP + MM_OFFSET_BOTTOM) + (MM_BRDR * 2))
local WM_ALPHA = false;
local SVUI_MinimapFrame = CreateFrame("Frame", "SVUI_MinimapFrame", UIParent)
local WMCoords = CreateFrame('Frame', 'SVUI_WorldMapCoords', WorldMapFrame)
SVUI_MinimapFrame:SetSize(MM_WIDTH, MM_HEIGHT)

local CUSTOM_BLIPS = [[Interface\AddOns\SVUI\assets\artwork\Minimap\MINIMAP-OBJECTICONS]]
local DEFAULT_BLIPS = [[Interface\AddOns\SVUI\assets\artwork\Minimap\DEFAULT-OBJECTICONS]]
--[[ 
########################################################## 
GENERAL HELPERS
##########################################################
]]--
--[[
 /$$$$$$$  /$$   /$$ /$$$$$$$$/$$$$$$$$/$$$$$$  /$$   /$$  /$$$$$$ 
| $$__  $$| $$  | $$|__  $$__/__  $$__/$$__  $$| $$$ | $$ /$$__  $$
| $$  \ $$| $$  | $$   | $$     | $$ | $$  \ $$| $$$$| $$| $$  \__/
| $$$$$$$ | $$  | $$   | $$     | $$ | $$  | $$| $$ $$ $$|  $$$$$$ 
| $$__  $$| $$  | $$   | $$     | $$ | $$  | $$| $$  $$$$ \____  $$
| $$  \ $$| $$  | $$   | $$     | $$ | $$  | $$| $$\  $$$ /$$  \ $$
| $$$$$$$/|  $$$$$$/   | $$     | $$ |  $$$$$$/| $$ \  $$|  $$$$$$/
|_______/  \______/    |__/     |__/  \______/ |__/  \__/ \______/                                                                
--]]
local MMB_OnEnter = function(self)
	if(not SV.db.SVMap.minimapbar.mouseover or SV.db.SVMap.minimapbar.styleType == "NOANCHOR") then return end
	UIFrameFadeIn(SVUI_MiniMapButtonBar, 0.2, SVUI_MiniMapButtonBar:GetAlpha(), 1)
	if self:GetName() ~= "SVUI_MiniMapButtonBar" then 
		self:SetBackdropBorderColor(.7, .7, 0)
	end 
end 

local MMB_OnLeave = function(self)
	if(not SV.db.SVMap.minimapbar.mouseover or SV.db.SVMap.minimapbar.styleType == "NOANCHOR") then return end
	UIFrameFadeOut(SVUI_MiniMapButtonBar, 0.2, SVUI_MiniMapButtonBar:GetAlpha(), 0)
	if self:GetName() ~= "SVUI_MiniMapButtonBar" then 
		self:SetBackdropBorderColor(0, 0, 0)
	end 
end

do
	local reserved = {"Node", "Tab", "Pin", "SVUI_ConsolidatedBuffs", "GameTimeframe", "HelpOpenTicketButton", "SVUI_MinimapFrame", "SVUI_EnhancedMinimap", "QueueStatusMinimapButton", "TimeManagerClockButton", "Archy", "GatherMatePin", "GatherNote", "GuildInstance", "HandyNotesPin", "MinimMap", "Spy_MapNoteList_mini", "ZGVMarker"}

	local function UpdateMinimapButtons()
		if(not SV.db.SVMap.minimapbar.enable) then return end

		MMBBar:SetPoint("CENTER", MMBHolder, "CENTER", 0, 0)
		MMBBar:SetHeightToScale(SV.db.SVMap.minimapbar.buttonSize + 4)
		MMBBar:SetWidthToScale(SV.db.SVMap.minimapbar.buttonSize + 4)
		MMBBar:SetFrameStrata("LOW")
		MMBBar:SetFrameLevel(0)

		local lastButton, anchor, relative, xPos, yPos;
		local list  = MOD.MinimapButtons
		local count = 1

		for name,btn in pairs(list) do 
			local preset = btn.preset;
			if(SV.db.SVMap.minimapbar.styleType == "NOANCHOR") then 
				btn:SetParent(preset.Parent)
				if preset.DragStart then 
					btn:SetScript("OnDragStart", preset.DragStart)
				end 
				if preset.DragEnd then 
					btn:SetScript("OnDragStop", preset.DragEnd)
				end 
				btn:ClearAllPoints()
				btn:SetSize(preset.Width, preset.Height)
				btn:SetPoint(preset.Point, preset.relativeTo, preset.relativePoint, preset.xOfs, preset.yOfs)
				btn:SetFrameStrata(preset.FrameStrata)
				btn:SetFrameLevel(preset.FrameLevel)
				btn:SetScale(preset.Scale)
				btn:SetMovable(true)
			else 
				btn:SetParent(MMBBar)
				btn:SetMovable(false)
				btn:SetScript("OnDragStart", nil)
				btn:SetScript("OnDragStop", nil)
				btn:ClearAllPoints()
				btn:SetFrameStrata("LOW")
				btn:SetFrameLevel(20)
				btn:SetSizeToScale(SV.db.SVMap.minimapbar.buttonSize)
				if SV.db.SVMap.minimapbar.styleType == "HORIZONTAL"then 
					anchor = "RIGHT"
					relative = "LEFT"
					xPos = -2;
					yPos = 0 
				else 
					anchor = "TOP"
					relative = "BOTTOM"
					xPos = 0;
					yPos = -2 
				end 
				if not lastButton then 
					btn:SetPoint(anchor, MMBBar, anchor, xPos, yPos)
				else 
					btn:SetPoint(anchor, lastButton, relative, xPos, yPos)
				end 
			end 
			lastButton = btn
			count = count + 1
		end 
		if (SV.db.SVMap.minimapbar.styleType ~= "NOANCHOR" and (count > 0)) then 
			if SV.db.SVMap.minimapbar.styleType == "HORIZONTAL" then 
				MMBBar:SetWidthToScale((SV.db.SVMap.minimapbar.buttonSize * count) + count * 2)
			else 
				MMBBar:SetHeightToScale((SV.db.SVMap.minimapbar.buttonSize * count) + count * 2)
			end 
			MMBHolder:SetSize(MMBBar:GetSize())
			MMBBar:Show()
		else 
			MMBBar:Hide()
		end 
	end 

	local function SetMinimapButton(btn)
		if btn == nil or btn:GetName() == nil or btn:GetObjectType() ~= "Button" or not btn:IsVisible() then return end 
		local name = btn:GetName()
		local isLib = false;
		if name:sub(1,len("LibDBIcon")) == "LibDBIcon" then isLib = true end
		if(not isLib) then
			local count = #reserved
			for i = 1, count do
				if name:sub(1,len(reserved[i])) == reserved[i] then return end 
				if name:find(reserved[i]) ~= nil then return end
			end
		end

		btn:SetPushedTexture("")
		btn:SetHighlightTexture("")
		btn:SetDisabledTexture("")
		 
		if not btn.isStyled then
			btn:HookScript("OnEnter", MMB_OnEnter)
			btn:HookScript("OnLeave", MMB_OnLeave)
			btn:HookScript("OnClick", UpdateMinimapButtons)
			btn.preset = {}
			btn.preset.Width, btn.preset.Height = btn:GetSize()
			btn.preset.Point, btn.preset.relativeTo, btn.preset.relativePoint, btn.preset.xOfs, btn.preset.yOfs = btn:GetPoint()
			btn.preset.Parent = btn:GetParent()
			btn.preset.FrameStrata = btn:GetFrameStrata()
			btn.preset.FrameLevel = btn:GetFrameLevel()
			btn.preset.Scale = btn:GetScale()
			if btn:HasScript("OnDragStart") then 
				btn.preset.DragStart = btn:GetScript("OnDragStart")
			end 
			if btn:HasScript("OnDragEnd") then 
				btn.preset.DragEnd = btn:GetScript("OnDragEnd")
			end
			for i = 1, btn:GetNumRegions() do 
				local frame = select(i, btn:GetRegions())
				if frame:GetObjectType() == "Texture" then 
					local iconFile = frame:GetTexture()
					if(iconFile ~= nil and (iconFile:find("Border") or iconFile:find("Background") or iconFile:find("AlphaMask"))) then 
						frame:SetTexture(0,0,0,0)
					else 
						frame:ClearAllPoints()
						frame:SetPointToScale("TOPLEFT", btn, "TOPLEFT", 2, -2)
						frame:SetPointToScale("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -2, 2)
						frame:SetTexCoord(0.1, 0.9, 0.1, 0.9 )
						frame:SetDrawLayer("ARTWORK")
						if name == "PS_MinimapButton" then 
							frame.SetPoint = SV.fubar
						end 
					end 
				end 
			end

			btn:SetStylePanel("Slot", 2, -1, -1)

			if(name == "DBMMinimapButton") then 
				btn:SetNormalTexture("Interface\\Icons\\INV_Helmet_87")
			end 

			if(name == "SmartBuff_MiniMapButton") then 
				btn:SetNormalTexture(select(3, GetSpellInfo(12051)))
			end

			btn.isStyled = true

			MOD.MinimapButtons[name] = btn
		end
	end 

	local StyleMinimapButtons = function()
		local count = Minimap:GetNumChildren()

		for i=1, count do
			local child = select(i,Minimap:GetChildren())
			SetMinimapButton(child)
		end

		UpdateMinimapButtons()

		if SV.db.SVMap.minimapbar.mouseover then 
			MMBBar:SetAlpha(0)
		else 
			MMBBar:SetAlpha(1)
		end
	end

	function MOD:UpdateMinimapButtonSettings(notimer)
		if(not SV.db.SVMap.minimapbar.enable or not MMBBar:IsShown()) then return end
		if(notimer) then
			StyleMinimapButtons()
		else
			SV.Timers:ExecuteTimer(StyleMinimapButtons, 4)
		end
	end
end

local function UpdateMapCoords()
	local xF, yF = "|cffFFCC00X:  |r%.1f", "|cffFFCC00Y:  |r%.1f"
	local skip = IsInInstance()
	local c, d = GetPlayerMapPosition("player")
	if((not skip) and (c ~= 0 and d ~= 0)) then
		c = parsefloat(100 * c, 2)
		d = parsefloat(100 * d, 2)
		if(MM_XY_COORD == "SIMPLE") then
			xF, yF = "%.1f", "%.1f";
		end
		if c ~= 0 and d ~= 0 then
			SVUI_MiniMapCoords.playerXCoords:SetFormattedText(xF, c)
			SVUI_MiniMapCoords.playerYCoords:SetFormattedText(yF, d)
			if(WorldMapFrame:IsShown()) then
				SVUI_WorldMapCoords.playerCoords:SetText(PLAYER..":   "..c..", "..d)
			end
		else
			SVUI_MiniMapCoords.playerXCoords:SetText("")
			SVUI_MiniMapCoords.playerYCoords:SetText("")
			if(WorldMapFrame:IsShown()) then
				SVUI_WorldMapCoords.playerCoords:SetText("")
			end
		end
		if(WorldMapFrame:IsShown()) then
			local e = WorldMapDetailFrame:GetEffectiveScale()
			local f = WorldMapDetailFrame:GetWidth()
			local g = WorldMapDetailFrame:GetHeight()
			local h, i = WorldMapDetailFrame:GetCenter()
			local c, d = GetCursorPosition()
			local j = (c / e - (h - (f / 2))) / f;
			local k = (i + (g / 2)-d / e) / g;
			if j >= 0 and k >= 0 and j <= 1 and k <= 1 then 
				j = parsefloat(100 * j, 2)
				k = parsefloat(100 * k, 2)
				SVUI_WorldMapCoords.mouseCoords:SetText(MOUSE_LABEL..":   "..j..", "..k)
			else 
				SVUI_WorldMapCoords.mouseCoords:SetText("")
			end
		end
	else
		SVUI_MiniMapCoords.playerXCoords:SetText("")
		SVUI_MiniMapCoords.playerYCoords:SetText("")
		if(WorldMapFrame:IsShown()) then
			SVUI_WorldMapCoords.playerCoords:SetText("")
		end
	end
	if(WM_ALPHA and WorldMapFrame:IsShown() and (not WorldMapFrame_InWindowedMode())) then
		local speed = GetUnitSpeed("player")
		if(speed ~= 0) then
			WorldMapFrame:SetAlpha(0.2)
		else
			WorldMapFrame:SetAlpha(1)
		end 
	end
end

--[[
 /$$      /$$  /$$$$$$  /$$$$$$$  /$$       /$$$$$$$  /$$      /$$  /$$$$$$  /$$$$$$$ 
| $$  /$ | $$ /$$__  $$| $$__  $$| $$      | $$__  $$| $$$    /$$$ /$$__  $$| $$__  $$
| $$ /$$$| $$| $$  \ $$| $$  \ $$| $$      | $$  \ $$| $$$$  /$$$$| $$  \ $$| $$  \ $$
| $$/$$ $$ $$| $$  | $$| $$$$$$$/| $$      | $$  | $$| $$ $$/$$ $$| $$$$$$$$| $$$$$$$/
| $$$$_  $$$$| $$  | $$| $$__  $$| $$      | $$  | $$| $$  $$$| $$| $$__  $$| $$____/ 
| $$$/ \  $$$| $$  | $$| $$  \ $$| $$      | $$  | $$| $$\  $ | $$| $$  | $$| $$      
| $$/   \  $$|  $$$$$$/| $$  | $$| $$$$$$$$| $$$$$$$/| $$ \/  | $$| $$  | $$| $$      
|__/     \__/ \______/ |__/  |__/|________/|_______/ |__/     |__/|__/  |__/|__/                                                                                        
--]]

local function SetLargeWorldMap()
	if InCombatLockdown() then return end

	if SV.db.SVMap.tinyWorldMap == true then
		-- WorldMapFrame:SetParent(SV.Screen)
		WorldMapFrame:EnableMouse(false)
		WorldMapFrame:EnableKeyboard(false)
		WorldMapFrame:SetScale(1)
		if WorldMapFrame:GetAttribute('UIPanelLayout-area') ~= 'center'then
			SetUIPanelAttribute(WorldMapFrame, "area", "center")
		end 
		if WorldMapFrame:GetAttribute('UIPanelLayout-allowOtherPanels') ~= true then
			SetUIPanelAttribute(WorldMapFrame, "allowOtherPanels", true)
		end
	end

	WorldMapFrameSizeUpButton:Hide()
	WorldMapFrameSizeDownButton:Show()
end 

local function SetSmallWorldMap()
	if InCombatLockdown() then return end 
	WorldMapFrameSizeUpButton:Show()
	WorldMapFrameSizeDownButton:Hide()
end

local function AdjustMapSize()
	if InCombatLockdown() then return end

	if WORLDMAP_SETTINGS.size == WORLDMAP_FULLMAP_SIZE then 
		WorldMapFrame:SetPoint("TOP", SV.Screen, "TOP", 0, 0)
	end
	
	if SV.db.SVMap.tinyWorldMap == true then
		BlackoutWorld:SetTexture(0,0,0,0)
	else
		BlackoutWorld:SetTexture(0, 0, 0, 1)
	end
end  

local function UpdateWorldMapConfig()
	if(not MM_XY_COORD or MM_XY_COORD == "HIDE") then
		if MOD.CoordTimer then
			SV.Timers:RemoveLoop(MOD.CoordTimer)
			MOD.CoordTimer = nil;
		end
		SVUI_MiniMapCoords.playerXCoords:SetText("")
		SVUI_MiniMapCoords.playerYCoords:SetText("")
	else
		if((not InCombatLockdown()) and (not SVUI_MiniMapCoords:IsShown())) then SVUI_MiniMapCoords:Show() end
		UpdateMapCoords()
		MOD.CoordTimer = SV.Timers:ExecuteLoop(UpdateMapCoords, 0.1)
	end

	if InCombatLockdown()then return end
	if(not MOD.WorldMapHooked) then
		NewHook("WorldMap_ToggleSizeUp", AdjustMapSize)
		NewHook("WorldMap_ToggleSizeDown", SetSmallWorldMap)
		MOD.WorldMapHooked = true
	end
	AdjustMapSize() 
end
--[[ 
########################################################## 
HANDLERS
##########################################################
]]--
local MiniMap_MouseUp = function(self, btn)
	local position = self:GetPoint()
	if btn == "RightButton" then
		local xoff = -1
		if position:match("RIGHT") then xoff = -16 end
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self, xoff, -3)
	else
		Minimap_OnClick(self)
	end
end

local MiniMap_MouseWheel = function(self, delta)
	if delta > 0 then
		_G.MinimapZoomIn:Click()
	elseif delta < 0 then
		_G.MinimapZoomOut:Click()
	end
end

local Calendar_OnClick = function(self)
	GameTimeFrame:Click();
end

local Tracking_OnClick = function(self)
	local position = self:GetPoint()
	local xoff = -1
	if position:match("RIGHT") then xoff = -16 end
	ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self, xoff, -3)
end

local Basic_OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(self.TText, 1, 1, 1)
	GameTooltip:Show()
end 

local Basic_OnLeave = function(self)
	GameTooltip:Hide() 
end

local Tour_OnEnter = function(self, ...)
	if InCombatLockdown() then
		GameTooltip:Hide()
	else
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -4)
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(L["Click : "], L["Toggle WorldMap"], 0.7, 0.7, 1, 0.7, 0.7, 1)
		GameTooltip:AddDoubleLine(L["ShiftClick : "], L["Announce your position in chat"],0.7, 0.7, 1, 0.7, 0.7, 1)
		GameTooltip:Show()
	end
end 

local Tour_OnLeave = function(self, ...)
	GameTooltip:Hide()
end 

local Tour_OnClick = function(self, btn)
	if IsShiftKeyDown() then
		local zoneText = GetRealZoneText() or UNKNOWN;
		local subZone = GetSubZoneText() or UNKNOWN;
		local edit_box = ChatEdit_ChooseBoxForSend();
		local x, y = GetPlayerMapPosition("player");
		x = tonumber(parsefloat(100 * x, 0));
		y = tonumber(parsefloat(100 * y, 0));
		local coords = ("%d, %d"):format(x, y);

		ChatEdit_ActivateChat(edit_box)

		if(zoneText ~= subZone) then
			local message = ("%s: %s (%s)"):format(zoneText, subZone, coords)
			edit_box:Insert(message)
		else
			local message = ("%s (%s)"):format(zoneText, coords)
			edit_box:Insert(message)
		end 
	else
		ToggleFrame(WorldMapFrame)
	end
	GameTooltip:Hide()
end
--[[ 
########################################################## 
HOOKS
##########################################################
]]--
local _hook_WorldMapZoneDropDownButton_OnClick = function(self)
	DropDownList1:ClearAllPoints()
	DropDownList1:SetPointToScale("TOPRIGHT",self,"BOTTOMRIGHT",-17,-4)
end 

local _hook_WorldMapFrame_OnShow = function()
	MOD:RegisterEvent("PLAYER_REGEN_DISABLED");

	if InCombatLockdown()then return end

	if(not SV.db.SVMap.tinyWorldMap and not Initialized) then 
      WorldMap_ToggleSizeUp()
      Initialized = true
    end
end 

local _hook_WorldMapFrame_OnHide = function()
	MOD:UnregisterEvent("PLAYER_REGEN_DISABLED")
end

local _hook_DropDownList1 = function(self)
	local parentScale = UIParent:GetScale()
	if(self:GetScale() ~= parentScale) then 
		self:SetScale(parentScale)
	end 
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:RefreshMiniMap()
	if(not SV.db.SVMap.enable) then return; end
	if(InCombatLockdown()) then 
		self.CombatLocked = true
		return 
	end

	self:UpdateLocals()

	NARR_TEXT = "";
	NARR_PREFIX = "";

	if(self.Holder and self.Holder:IsShown()) then
		local minimapRotationEnabled = GetCVar("rotateMinimap") ~= "0"

		if(minimapRotationEnabled) then
			SV.Dock.TopRight:SetSizeToScale(MM_WIDTH, (MM_WIDTH + 4))
			self.Holder:SetSizeToScale(MM_WIDTH, MM_WIDTH)
			Minimap:SetSizeToScale(MM_SIZE,MM_SIZE)
			self.Holder.Square:Hide()
			self.Holder.Circle:Show()
			--self.Holder.Circle:SetGradient(unpack(MM_COLOR))
			Minimap:SetHitRectInsets(0, 0, 0, 0)
			Minimap:SetAllPointsIn(self.Holder, MM_BRDR, MM_BRDR)
			Minimap:SetMaskTexture('Textures\\MinimapMask')
		else
			SV.Dock.TopRight:SetSizeToScale(MM_WIDTH, (MM_HEIGHT + 4))
			self.Holder:SetSizeToScale(MM_WIDTH, MM_HEIGHT)
			Minimap:SetSizeToScale(MM_SIZE,MM_SIZE)
			self.Holder.Circle:Hide()
			self.Holder.Square:Show()
			self.Holder.Square.Panel.Skin:SetGradient(unpack(MM_COLOR))

			if SV.db.SVMap.customshape then
				Minimap:SetPoint("BOTTOMLEFT", self.Holder, "BOTTOMLEFT", MM_BRDR, -(MM_OFFSET_BOTTOM - MM_BRDR))
				Minimap:SetPoint("TOPRIGHT", self.Holder, "TOPRIGHT", -MM_BRDR, (MM_OFFSET_TOP - MM_BRDR))
				Minimap:SetMaskTexture('Interface\\AddOns\\SVUI\\assets\\artwork\\Minimap\\MINIMAP_MASK_RECTANGLE')
			else
				Minimap:SetHitRectInsets(0, 0, 0, 0)
				Minimap:SetAllPointsIn(self.Holder, MM_BRDR, MM_BRDR)
				Minimap:SetMaskTexture('Interface\\AddOns\\SVUI\\assets\\artwork\\Minimap\\MINIMAP_MASK_SQUARE')
			end
		end
		Minimap:SetParent(self.Holder)
		Minimap:SetZoom(1)
		Minimap:SetZoom(0)
	else
		SV.Dock.TopRight:SetSizeToScale(MM_WIDTH, (MM_HEIGHT + 4))
	end

	self.Zone:SetSize(MM_WIDTH,28)
	self.Zone.Text:SetSize(MM_WIDTH,32)

	if(not NARR_ENABLE or NARR_ENABLE == "HIDE") then
		self.Narrator:Hide();
		self.Zone:Hide();
	else
		if(NARR_ENABLE == "SIMPLE") then
			self.Narrator:Hide();
			self.Zone:Show();
			self.Narrator.Text:SetText(NARR_TEXT)
		else
			self.Narrator:Show();
			self.Zone:Show();
			NARR_TEXT = L['Meanwhile...'];
			NARR_PREFIX = L["..at "];
			self.Narrator.Text:SetText(NARR_TEXT)
		end
		local zone = GetMinimapZoneText();
		zone = zone:sub(1, 25);
		local zoneText = ("%s%s"):format(NARR_PREFIX, zone);
		self.Zone.Text:SetText(zoneText)
	end

	if SVUI_AurasAnchor then
		SVUI_AurasAnchor:SetHeightToScale(MM_HEIGHT)
		if SVUI_AurasAnchor_MOVE and not SV.Mentalo:HasMoved('SVUI_AurasAnchor_MOVE') and not SV.Mentalo:HasMoved('SVUI_MinimapFrame_MOVE') then
			SVUI_AurasAnchor_MOVE:ClearAllPoints()
			SVUI_AurasAnchor_MOVE:SetPointToScale("TOPRIGHT", SVUI_MinimapFrame_MOVE, "TOPLEFT", -8, 0)
		end
		if SVSVUI_AurasAnchor_MOVE then
			SVUI_AurasAnchor_MOVE:SetHeightToScale(MM_HEIGHT)
		end
	end
	if SVUI_HyperBuffs then
		SV.SVAura:Update_HyperBuffsSettings()
	end
	if TimeManagerClockButton then
		TimeManagerClockButton:Die()
	end

	UpdateWorldMapConfig()
end

local function RotationHook()
	MOD:RefreshMiniMap()
end
--[[ 
########################################################## 
EVENTS
##########################################################
]]--
function MOD:ZONE_CHANGED()
	local zone = GetRealZoneText() or UNKNOWN
	zone = zone:sub(1, 25)
	local zoneText = ("%s%s"):format(NARR_PREFIX, zone)
	self.Zone.Text:SetText(zoneText)
end

function MOD:ZONE_CHANGED_NEW_AREA()
	local zone = GetRealZoneText() or UNKNOWN
	zone = zone:sub(1, 25)
	local zoneText = ("%s%s"):format(NARR_PREFIX, zone)
	self.Zone.Text:SetText(zoneText)
end

function MOD:ADDON_LOADED(event, addon)
	if TimeManagerClockButton then
		TimeManagerClockButton:Die()
	end
	self:UnregisterEvent("ADDON_LOADED")
	if addon == "Blizzard_FeedbackUI" then
		FeedbackUIButton:Die()
	end
	self:UpdateMinimapButtonSettings()
end

function MOD:PLAYER_REGEN_ENABLED()
	WorldMapFrameSizeDownButton:Enable()
	WorldMapFrameSizeUpButton:Enable()
	if(self.CombatLocked) then
		self:RefreshMiniMap()
		self.CombatLocked = nil
	end
end 

function MOD:PLAYER_REGEN_DISABLED()
	WorldMapFrameSizeDownButton:Disable()
	WorldMapFrameSizeUpButton:Disable()
end
--[[ 
########################################################## 
BUILD FUNCTION / UPDATE
##########################################################
]]--
function MOD:UpdateLocals()
	local db = SV.db.SVMap
	if not db then return end

	MM_XY_COORD = db.playercoords;
	WM_TINY = db.tinyWorldMap;
	NARR_ENABLE = db.locationText;
	MM_COLOR = SV.Media.gradient[db.bordercolor]
	MM_BRDR = db.bordersize or 0
	MM_SIZE = db.size or 240
	MM_OFFSET_TOP = (MM_SIZE * 0.07)
	MM_OFFSET_BOTTOM = (MM_SIZE * 0.11)
	MM_WIDTH = MM_SIZE + (MM_BRDR * 2)
	MM_HEIGHT = db.customshape and (MM_SIZE - (MM_OFFSET_TOP + MM_OFFSET_BOTTOM) + (MM_BRDR * 2)) or MM_WIDTH
	WM_ALPHA = GetCVarBool("mapFade")
end

function MOD:ReLoad()
	if(not SV.db.SVMap.enable) then return; end
	self:RefreshMiniMap()
	self:UpdateMinimapButtonSettings()
end

local _hook_BlipTextures = function(self, texture)
	if(SV.db.SVMap.customIcons and (texture ~= CUSTOM_BLIPS)) then
		self:SetBlipTexture(CUSTOM_BLIPS)
	else
		if((not SV.db.SVMap.customIcons) and texture ~= DEFAULT_BLIPS) then
			self:SetBlipTexture(DEFAULT_BLIPS)
		end
	end
end

function MOD:Load()
	if(not SV.db.SVMap.enable) then 
		Minimap:SetMaskTexture('Textures\\MinimapMask')
		return
	end

	self:UpdateLocals()

	Minimap:SetPlayerTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Minimap\\MINIMAP_ARROW")
	Minimap:SetCorpsePOIArrowTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Minimap\\MINIMAP_CORPSE_ARROW")
	Minimap:SetPOIArrowTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Minimap\\MINIMAP_GUIDE_ARROW")
	if(SV.db.SVMap.customIcons) then
		Minimap:SetBlipTexture(CUSTOM_BLIPS)
	else
		Minimap:SetBlipTexture(DEFAULT_BLIPS)
	end
	
	Minimap:SetClampedToScreen(false)

	local mapHolder = SVUI_MinimapFrame
	-- mapHolder:SetParent(SV.Screen);
	mapHolder:SetFrameStrata(Minimap:GetFrameStrata())
	mapHolder:SetPointToScale("TOPRIGHT", SV.Screen, "TOPRIGHT", -10, -10)
	mapHolder:SetSizeToScale(MM_WIDTH, MM_HEIGHT)

	mapHolder.Square = CreateFrame("Frame", nil, mapHolder)
	mapHolder.Square:SetAllPointsOut(mapHolder, 2)
	mapHolder.Square:SetStylePanel("Frame", "Blackout")
	mapHolder.Square.Panel.Skin:SetGradient(unpack(MM_COLOR))

	mapHolder.Circle = mapHolder:CreateTexture(nil, "BACKGROUND", nil, -2)
	mapHolder.Circle:SetAllPointsOut(mapHolder, 2)
	mapHolder.Circle:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Minimap\\MINIMAP-ROUND")
	mapHolder.Circle:SetVertexColor(0,0,0)
	mapHolder.Circle:Hide()

	if TimeManagerClockButton then
		TimeManagerClockButton:Die()
	end

	Minimap:SetQuestBlobRingAlpha(0) 
	Minimap:SetArchBlobRingAlpha(0)
	Minimap:SetParent(mapHolder)
	Minimap:SetFrameStrata("LOW")
	Minimap:SetFrameLevel(Minimap:GetFrameLevel() + 2)
	mapHolder:SetFrameLevel(Minimap:GetFrameLevel() - 2)
	ShowUIPanel(SpellBookFrame)
	HideUIPanel(SpellBookFrame)
	MinimapBorder:Hide()
	MinimapBorderTop:Hide()
	MinimapZoomIn:Hide()
	MinimapZoomOut:Hide()
	MiniMapVoiceChatFrame:Hide()
	MinimapNorthTag:Die()
	GameTimeFrame:Hide()
	MinimapZoneTextButton:Hide()
	MiniMapTracking:Hide()
	MiniMapMailFrame:ClearAllPoints()
	MiniMapMailFrame:SetPointToScale("TOPRIGHT", mapHolder, 3, 4)
	MiniMapMailBorder:Hide()
	MiniMapMailIcon:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Minimap\\MINIMAP-MAIL")
	MiniMapWorldMapButton:Hide()

	MiniMapInstanceDifficulty:ClearAllPoints()
	MiniMapInstanceDifficulty:SetParent(Minimap)
	MiniMapInstanceDifficulty:SetPointToScale("LEFT", mapHolder, "LEFT", 0, 0)

	GuildInstanceDifficulty:ClearAllPoints()
	GuildInstanceDifficulty:SetParent(Minimap)
	GuildInstanceDifficulty:SetPointToScale("LEFT", mapHolder, "LEFT", 0, 0)

	MiniMapChallengeMode:ClearAllPoints()
	MiniMapChallengeMode:SetParent(Minimap)
	MiniMapChallengeMode:SetPointToScale("LEFT", mapHolder, "LEFT", 12, 0)

	QueueStatusMinimapButton:ClearAllPoints()
	QueueStatusMinimapButton:SetPointToScale("BOTTOMLEFT", mapHolder, "BOTTOMLEFT", 2, 1)
	QueueStatusMinimapButton:SetStylePanel("Frame", "Icon", true, 1, -6, -6)

	QueueStatusFrame:SetClampedToScreen(true)
	QueueStatusMinimapButtonBorder:Hide()
	QueueStatusMinimapButton:SetScript("OnShow", function()
		MiniMapInstanceDifficulty:SetPointToScale("BOTTOMLEFT", QueueStatusMinimapButton, "TOPLEFT", 0, 0)
		GuildInstanceDifficulty:SetPointToScale("BOTTOMLEFT", QueueStatusMinimapButton, "TOPLEFT", 0, 0)
		MiniMapChallengeMode:SetPointToScale("BOTTOMLEFT", QueueStatusMinimapButton, "TOPRIGHT", 0, 0)
	end)
	QueueStatusMinimapButton:SetScript("OnHide", function()
		MiniMapInstanceDifficulty:SetPointToScale("LEFT", mapHolder, "LEFT", 0, 0)
		GuildInstanceDifficulty:SetPointToScale("LEFT", mapHolder, "LEFT", 0, 0)
		MiniMapChallengeMode:SetPointToScale("LEFT", mapHolder, "LEFT", 12, 0)
	end)

	if FeedbackUIButton then
		FeedbackUIButton:Die()
	end

	local mwfont = SV.Media.font.narrator

	local narr = CreateFrame("Frame", nil, mapHolder)
	narr:SetPointToScale("TOPLEFT", mapHolder, "TOPLEFT", 2, -2)
	narr:SetSize(100, 22)
	narr:SetStylePanel("!_Frame", "Heavy", true)
  	narr:SetPanelColor("yellow")
  	narr:SetBackdropColor(1, 1, 0, 1)
	narr:SetFrameLevel(Minimap:GetFrameLevel() + 2)
	narr:SetParent(Minimap)

	narr.Text = narr:CreateFontString(nil, "ARTWORK", nil, 7)
	narr.Text:SetFontObject(SVUI_Font_Narrator)
	narr.Text:SetJustifyH("CENTER")
	narr.Text:SetJustifyV("MIDDLE")
	narr.Text:SetAllPoints(narr)
	narr.Text:SetTextColor(1, 1, 1)
	narr.Text:SetShadowColor(0, 0, 0, 0.3)
	narr.Text:SetShadowOffset(2, -2)

	self.Narrator = narr

	local zt = CreateFrame("Frame", nil, mapHolder)
	zt:SetPointToScale("BOTTOMRIGHT", mapHolder, "BOTTOMRIGHT", 2, -3)
	zt:SetSize(MM_WIDTH, 28)
	zt:SetFrameLevel(Minimap:GetFrameLevel() + 1)
	zt:SetParent(Minimap)

	zt.Text = zt:CreateFontString(nil, "ARTWORK", nil, 7)
	zt.Text:SetFontObject(SVUI_Font_Narrator)
	zt.Text:SetJustifyH("RIGHT")
	zt.Text:SetJustifyV("MIDDLE")
	zt.Text:SetPointToScale("RIGHT", zt)
	zt.Text:SetSize(MM_WIDTH, 32)
	zt.Text:SetTextColor(1, 1, 0)
	zt.Text:SetShadowColor(0, 0, 0, 0.3)
	zt.Text:SetShadowOffset(-2, 2)

	self.Zone = zt

	Minimap:EnableMouseWheel(true)
	Minimap:SetScript("OnMouseWheel", MiniMap_MouseWheel)	
	Minimap:SetScript("OnMouseUp", MiniMap_MouseUp)

	SV.Mentalo:Add(mapHolder, L["Minimap"]) 

	if(SV.db.SVMap.tinyWorldMap) then
		setfenv(WorldMapFrame_OnShow, setmetatable({ UpdateMicroButtons = SV.fubar }, { __index = _G }))
		-- WorldMapFrame:SetParent(SV.Screen)
		WorldMapFrame:HookScript('OnShow', _hook_WorldMapFrame_OnShow)
		WorldMapFrame:HookScript('OnHide', _hook_WorldMapFrame_OnHide)
	end

	WMCoords:SetFrameLevel(WorldMapDetailFrame:GetFrameLevel() + 1)
	WMCoords:SetFrameStrata(WorldMapDetailFrame:GetFrameStrata())
	WMCoords.playerCoords = WMCoords:CreateFontString(nil,'OVERLAY')
	WMCoords.mouseCoords = WMCoords:CreateFontString(nil,'OVERLAY')
	WMCoords.playerCoords:SetTextColor(1,1,0)
	WMCoords.mouseCoords:SetTextColor(1,1,0)
	WMCoords.playerCoords:SetFontObject(NumberFontNormal)
	WMCoords.mouseCoords:SetFontObject(NumberFontNormal)
	WMCoords.playerCoords:SetPoint("BOTTOMLEFT", WorldMapFrame, "BOTTOMLEFT", 5, 5)
	WMCoords.playerCoords:SetText(PLAYER..":   0, 0")
	WMCoords.mouseCoords:SetPoint("BOTTOMLEFT", WMCoords.playerCoords, "TOPLEFT", 0, 5)
	WMCoords.mouseCoords:SetText(MOUSE_LABEL..":   0, 0")

	DropDownList1:HookScript('OnShow', _hook_DropDownList1)
	WorldFrame:SetAllPoints()

	SV:ManageVisibility(mapHolder)

	local CoordsHolder = CreateFrame("Frame", "SVUI_MiniMapCoords", Minimap)
	CoordsHolder:SetFrameLevel(Minimap:GetFrameLevel()  +  1)
	CoordsHolder:SetFrameStrata(Minimap:GetFrameStrata())
	CoordsHolder:SetPoint("TOPLEFT", mapHolder, "BOTTOMLEFT", 0, -4)
	CoordsHolder:SetPoint("TOPRIGHT", mapHolder, "BOTTOMRIGHT", 0, -4)
	CoordsHolder:SetHeight(22)
	CoordsHolder:EnableMouse(true)
	CoordsHolder:SetScript("OnEnter",Tour_OnEnter)
	CoordsHolder:SetScript("OnLeave",Tour_OnLeave)
	CoordsHolder:SetScript("OnMouseDown",Tour_OnClick)

	CoordsHolder.playerXCoords = CoordsHolder:CreateFontString(nil, "OVERLAY")
	CoordsHolder.playerXCoords:SetPoint("BOTTOMLEFT", CoordsHolder, "BOTTOMLEFT", 0, 0)
	CoordsHolder.playerXCoords:SetWidth(70)
	CoordsHolder.playerXCoords:SetHeight(22)
	CoordsHolder.playerXCoords:SetFontObject(SVUI_Font_Number)
	CoordsHolder.playerXCoords:SetTextColor(cColor.r, cColor.g, cColor.b)
	
	CoordsHolder.playerYCoords = CoordsHolder:CreateFontString(nil, "OVERLAY")
	CoordsHolder.playerYCoords:SetPoint("BOTTOMLEFT", CoordsHolder.playerXCoords, "BOTTOMRIGHT", 4, 0)
	CoordsHolder.playerXCoords:SetWidth(70)
	CoordsHolder.playerYCoords:SetHeight(22)
	CoordsHolder.playerYCoords:SetFontObject(SVUI_Font_Number)
	CoordsHolder.playerYCoords:SetTextColor(cColor.r, cColor.g, cColor.b)

	local calendarButton = CreateFrame("Button", "SVUI_CalendarButton", CoordsHolder)
	calendarButton:SetSize(22,22)
	calendarButton:SetPoint("RIGHT", CoordsHolder, "RIGHT", 0, 0)
	calendarButton:RemoveTextures()
	calendarButton:SetNormalTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Minimap\\MINIMAP-CALENDAR")
	calendarButton:SetPushedTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Minimap\\MINIMAP-CALENDAR")
	calendarButton:SetHighlightTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Minimap\\MINIMAP-CALENDAR")
	calendarButton.TText = "Calendar"
	calendarButton:RegisterForClicks("AnyUp")
	calendarButton:SetScript("OnEnter", Basic_OnEnter)
	calendarButton:SetScript("OnLeave", Basic_OnLeave)
	calendarButton:SetScript("OnClick", Calendar_OnClick)

	local trackingButton = CreateFrame("Button", "SVUI_TrackingButton", CoordsHolder)
	trackingButton:SetSize(22,22)
	trackingButton:SetPoint("RIGHT", calendarButton, "LEFT", -4, 0)
	trackingButton:RemoveTextures()
	trackingButton:SetNormalTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Minimap\\MINIMAP-TRACKING")
	trackingButton:SetPushedTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Minimap\\MINIMAP-TRACKING")
	trackingButton:SetHighlightTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Minimap\\MINIMAP-TRACKING")
	trackingButton.TText = "Tracking"
	trackingButton:RegisterForClicks("AnyUp")
	trackingButton:SetScript("OnEnter", Basic_OnEnter)
	trackingButton:SetScript("OnLeave", Basic_OnLeave)
	trackingButton:SetScript("OnClick", Tracking_OnClick)

	if(SV.db.SVMap.minimapbar.enable == true) then
		MMBHolder = CreateFrame("Frame", "SVUI_MiniMapButtonHolder", mapHolder)
		MMBHolder:SetPointToScale("TOPRIGHT", SV.Dock.TopRight, "BOTTOMRIGHT", 0, -4)
		MMBHolder:SetSizeToScale(mapHolder:GetWidth(), 32)
		MMBHolder:SetFrameStrata("BACKGROUND")
		MMBBar = CreateFrame("Frame", "SVUI_MiniMapButtonBar", MMBHolder)
		MMBBar:SetFrameStrata("LOW")
		MMBBar:ClearAllPoints()
		MMBBar:SetPoint("CENTER", MMBHolder, "CENTER", 0, 0)
		MMBBar:SetScript("OnEnter", MMB_OnEnter)
		MMBBar:SetScript("OnLeave", MMB_OnLeave)
		SV.Mentalo:Add(MMBHolder, L["Minimap Button Bar"])
		self:UpdateMinimapButtonSettings()
	end

	self.Holder = mapHolder

	self:RefreshMiniMap()

	self:RegisterEvent('ADDON_LOADED')
	self:RegisterEvent('PLAYER_REGEN_ENABLED')
	self:RegisterEvent('PLAYER_REGEN_DISABLED')
	self:RegisterEvent("ZONE_CHANGED")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")

	NewHook("Minimap_UpdateRotationSetting", RotationHook)
	--NewHook(Minimap, "SetBlipTexture", _hook_BlipTextures)
end