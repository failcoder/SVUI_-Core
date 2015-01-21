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
--]]
--[[ GLOBALS ]]--
local _G = _G;
local unpack  = _G.unpack;
local select  = _G.select;
local ipairs  = _G.ipairs;
local pairs   = _G.pairs;

local SV = _G["SVUI"];
local L = SV.L;
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
--[[ 
########################################################## 
FRAME LISTS
##########################################################
]]--
local proButtons = {
	"PrimaryProfession1SpellButtonTop", 
	"PrimaryProfession1SpellButtonBottom", 
	"PrimaryProfession2SpellButtonTop", 
	"PrimaryProfession2SpellButtonBottom", 
	"SecondaryProfession1SpellButtonLeft", 
	"SecondaryProfession1SpellButtonRight", 
	"SecondaryProfession2SpellButtonLeft", 
	"SecondaryProfession2SpellButtonRight", 
	"SecondaryProfession3SpellButtonLeft", 
	"SecondaryProfession3SpellButtonRight", 
	"SecondaryProfession4SpellButtonLeft", 
	"SecondaryProfession4SpellButtonRight"
}

local proFrames = {
	"PrimaryProfession1", 
	"PrimaryProfession2", 
	"SecondaryProfession1", 
	"SecondaryProfession2", 
	"SecondaryProfession3", 
	"SecondaryProfession4"
}
local proBars = {
	"PrimaryProfession1StatusBar", 
	"PrimaryProfession2StatusBar", 
	"SecondaryProfession1StatusBar", 
	"SecondaryProfession2StatusBar", 
	"SecondaryProfession3StatusBar", 
	"SecondaryProfession4StatusBar"
}
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local Tab_OnEnter = function(self)
	self.backdrop:SetBackdropColor(0.1, 0.8, 0.8)
	self.backdrop:SetBackdropBorderColor(0.1, 0.8, 0.8)
end

local Tab_OnLeave = function(self)
	self.backdrop:SetBackdropColor(0,0,0,1)
	self.backdrop:SetBackdropBorderColor(0,0,0,1)
end

local function ChangeTabHelper(tab)
	if(tab.backdrop) then return end

	local nTex = tab:GetNormalTexture()
	tab:RemoveTextures()
	if(nTex) then
		nTex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		nTex:SetAllPointsIn()
	end

	tab.pushed = true;

	tab.backdrop = CreateFrame("Frame", nil, tab)
	tab.backdrop:SetAllPointsOut(tab,1,1)
	tab.backdrop:SetFrameLevel(0)
	tab.backdrop:SetBackdrop({
		bgFile = [[Interface\BUTTONS\WHITE8X8]], 
        tile = false, 
        tileSize = 0,
        edgeFile = [[Interface\AddOns\SVUI\assets\artwork\Template\GLOW]],
        edgeSize = 3,
        insets = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0
        }
    });
    tab.backdrop:SetBackdropColor(0,0,0,1)
	tab.backdrop:SetBackdropBorderColor(0,0,0,1)
	tab:SetScript("OnEnter", Tab_OnEnter)
	tab:SetScript("OnLeave", Tab_OnLeave)

	local a1, p, a2, x, y = tab:GetPoint()
	tab:SetPointToScale(a1, p, a2, 1, y)
end 

local function GetSpecTabHelper(index)
	local tab = SpellBookCoreAbilitiesFrame.SpecTabs[index]
	if(not tab) then return end
	ChangeTabHelper(tab)
	if(index > 1) then 
		local a1, p, a2, x, y = tab:GetPoint()
		tab:ClearAllPoints()
		tab:SetPoint(a1, p, a2, 0, y)
	end 
end  

local function AbilityButtonHelper(index)
	local button = SpellBookCoreAbilitiesFrame.Abilities[index]

	if(button and (not button.Panel)) then
		local icon = button.iconTexture;

		if(not InCombatLockdown()) then
			if not button.properFrameLevel then 
			 	button.properFrameLevel = button:GetFrameLevel() + 1 
			end 
			button:SetFrameLevel(button.properFrameLevel)
		end

		button:RemoveTextures()
		button:SetStylePanel("Frame", "Slot", true, 2, 0, 0)

		if(button.iconTexture) then
			button.iconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			button.iconTexture:ClearAllPoints()
			button.iconTexture:SetAllPointsIn(button, 1, 1) 
		end

		if(button.Name) then 
			button.Name:SetFontObject(NumberFont_Outline_Large) 
			button.Name:SetTextColor(1,1,0) 
		end

		if(button.InfoText) then 
			button.InfoText:SetFontObject(NumberFont_Shadow_Small) 
			button.InfoText:SetTextColor(0.9,0.9,0.9) 
		end
	end
end 

local ButtonUpdateHelper = function(self)
	local name = self:GetName();
	local icon = _G[name.."IconTexture"];

	if(not self.Panel) then
    	local iconTex;

		if(not InCombatLockdown()) then
			self:SetFrameLevel(SpellBookFrame:GetFrameLevel() + 5)
		end 

		if(icon) then
			iconTex = icon:GetTexture()
		end

		self:RemoveTextures() 
		self:SetStylePanel("Frame", "Slot", true, 2, 0, 0)

		if(icon) then
			icon:SetTexture(iconTex)
			icon:ClearAllPoints()
			icon:SetAllPointsIn(self, 1, 1)
		end

		self.SpellName:SetFontObject(NumberFontNormal)

		if(self.FlyoutArrow) then
			self.FlyoutArrow:SetTexture([[Interface\Buttons\ActionBarFlyoutButton]])
		end
	end

	if(icon) then 
		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9) 
	end

	if(self.SpellName) then
		self.SpellName:SetTextColor(1,1,0)
	end
	
	if(self.SpellSubName) then
		self.SpellSubName:SetTextColor(0.9,0.9,0.9)
	end
end 
--[[ 
########################################################## 
SPELLBOOK PLUGINR
##########################################################
]]--
local function SpellBookStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.spellbook ~= true then return end

	PLUGIN:ApplyWindowStyle(SpellBookFrame)
	PLUGIN:ApplyCloseButtonStyle(SpellBookFrameCloseButton)

	if(SpellBookFrameInset) then 
		SpellBookFrameInset:RemoveTextures()
		SpellBookFrameInset:SetStylePanel("!_Frame", "Inset", true, 6)
	end
	if(SpellBookSpellIconsFrame) then SpellBookSpellIconsFrame:RemoveTextures() end
	if(SpellBookSideTabsFrame) then SpellBookSideTabsFrame:RemoveTextures() end
	if(SpellBookPageNavigationFrame) then SpellBookPageNavigationFrame:RemoveTextures() end

	for i = 1, 3 do
		local page = _G["SpellBookPage" .. i]
		if(page) then
			page:SetDrawLayer('BACKGROUND')
		end
	end

	SpellBookFrameTutorialButton:Die()

	PLUGIN:ApplyPaginationStyle(SpellBookPrevPageButton)
	PLUGIN:ApplyPaginationStyle(SpellBookNextPageButton)

	hooksecurefunc("SpellButton_UpdateButton", ButtonUpdateHelper)
	hooksecurefunc("SpellBook_GetCoreAbilityButton", AbilityButtonHelper)

	for i = 1, MAX_SKILLLINE_TABS do
		local tabName = "SpellBookSkillLineTab" .. i
		local tab = _G[tabName]
		if(tab) then 
			if(_G[tabName .. "Flash"]) then _G[tabName .. "Flash"]:Die() end
			ChangeTabHelper(tab) 
		end
	end

	hooksecurefunc('SpellBook_GetCoreAbilitySpecTab', GetSpecTabHelper)

	for _, gName in pairs(proFrames)do
		local frame = _G[gName]
		if(frame) then
			if(_G[gName .. "Missing"]) then 
				_G[gName .. "Missing"]:SetTextColor(1, 1, 0) 
			end
			if(frame.missingText) then 
				frame.missingText:SetTextColor(1, 0, 0) 
			end
	    	if(frame.missingHeader) then 
	    		frame.missingHeader:SetFontObject(NumberFont_Outline_Large) 
	    		frame.missingHeader:SetTextColor(1,1,0) 
	    	end
	    	if(frame.missingText) then 
	    		frame.missingText:SetFontObject(NumberFont_Shadow_Small) 
	    		frame.missingText:SetTextColor(0.9,0.9,0.9) 
	    	end
	    	if(frame.rank) then 
	    		frame.rank:SetFontObject(NumberFontNormal) 
	    		frame.rank:SetTextColor(0.9,0.9,0.9) 
	    	end
	    	if(frame.professionName) then 
	    		frame.professionName:SetFontObject(NumberFont_Outline_Large) 
	    		frame.professionName:SetTextColor(1,1,0) 
	    	end
	    end
	end

	for _, gName in pairs(proButtons)do
		local button = _G[gName]
		local buttonTex = _G[("%sIconTexture"):format(gName)]
		if(button) then
			button:RemoveTextures()
			if(buttonTex) then
				buttonTex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				buttonTex:SetAllPointsIn()
				button:SetFrameLevel(button:GetFrameLevel() + 2)
				if not button.Panel then
					button:SetStylePanel("Frame", "Inset", false, 3, 3, 3)
					button.Panel:SetAllPoints()
				end 
			end
			if(button.spellString) then 
				button.spellString:SetFontObject(NumberFontNormal) 
				button.spellString:SetTextColor(1,1,0) 
			end
			if(button.subSpellString) then
				button.subSpellString:SetFontObject(SubSpellFont)
			end
		end
	end

	for _, gName in pairs(proBars) do 
		local bar = _G[gName]
		if(bar) then
			bar:RemoveTextures()
			bar:SetHeight(12)
			bar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Bars\DEFAULT]])
			bar:SetStatusBarColor(0, 220/255, 0)
			bar:SetStylePanel("Frame", "Default")
			bar.rankText:ClearAllPoints()
			bar.rankText:SetPoint("CENTER")
		end
	end

	if(SpellBookFrameTabButton1) then 
		PLUGIN:ApplyTabStyle(SpellBookFrameTabButton1)
		SpellBookFrameTabButton1:ClearAllPoints()
		SpellBookFrameTabButton1:SetPoint('TOPLEFT', SpellBookFrame, 'BOTTOMLEFT', 0, 2)
	end
	if(SpellBookFrameTabButton2) then 
		PLUGIN:ApplyTabStyle(SpellBookFrameTabButton2) 
	end
	if(SpellBookFrameTabButton3) then 
		PLUGIN:ApplyTabStyle(SpellBookFrameTabButton3) 
	end
	if(SpellBookFrameTabButton4) then 
		PLUGIN:ApplyTabStyle(SpellBookFrameTabButton4) 
	end
	if(SpellBookFrameTabButton5) then 
		PLUGIN:ApplyTabStyle(SpellBookFrameTabButton5) 
	end
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveCustomStyle(SpellBookStyle)