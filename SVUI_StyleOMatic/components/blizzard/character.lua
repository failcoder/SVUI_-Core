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
--[[ ADDON ]]--
local SV = _G.SVUI;
local L = SV.L;
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local SlotListener = CreateFrame("Frame")

local CharacterSlotNames = {
	"HeadSlot",
	"NeckSlot",
	"ShoulderSlot",
	"BackSlot",
	"ChestSlot",
	"ShirtSlot",
	"TabardSlot",
	"WristSlot",
	"HandsSlot",
	"WaistSlot",
	"LegsSlot",
	"FeetSlot",
	"Finger0Slot",
	"Finger1Slot",
	"Trinket0Slot",
	"Trinket1Slot",
	"MainHandSlot",
	"SecondaryHandSlot"
};

local CharFrameList = {
	"CharacterFrame",
	"CharacterModelFrame",
	"CharacterFrameInset",
	"CharacterStatsPane",
	"CharacterFrameInsetRight",
	"PaperDollFrame",
	"PaperDollSidebarTabs",
	"PaperDollEquipmentManagerPane"
};

local function SetItemFrame(frame, point)
	point = point or frame
	local noscalemult = 2 * UIParent:GetScale()
	if point.bordertop then return end
	point.backdrop = frame:CreateTexture(nil, "BORDER")
	point.backdrop:SetDrawLayer("BORDER", -4)
	point.backdrop:SetAllPoints(point)
	point.backdrop:SetTexture(SV.Media.bar.default)
	point.backdrop:SetVertexColor(unpack(SV.Media.color.default))	
	point.bordertop = frame:CreateTexture(nil, "BORDER")
	point.bordertop:SetPoint("TOPLEFT", point, "TOPLEFT", -noscalemult, noscalemult)
	point.bordertop:SetPoint("TOPRIGHT", point, "TOPRIGHT", noscalemult, noscalemult)
	point.bordertop:SetHeight(noscalemult)
	point.bordertop:SetTexture(0,0,0)	
	point.bordertop:SetDrawLayer("BORDER", 1)
	point.borderbottom = frame:CreateTexture(nil, "BORDER")
	point.borderbottom:SetPoint("BOTTOMLEFT", point, "BOTTOMLEFT", -noscalemult, -noscalemult)
	point.borderbottom:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", noscalemult, -noscalemult)
	point.borderbottom:SetHeight(noscalemult)
	point.borderbottom:SetTexture(0,0,0)	
	point.borderbottom:SetDrawLayer("BORDER", 1)
	point.borderleft = frame:CreateTexture(nil, "BORDER")
	point.borderleft:SetPoint("TOPLEFT", point, "TOPLEFT", -noscalemult, noscalemult)
	point.borderleft:SetPoint("BOTTOMLEFT", point, "BOTTOMLEFT", noscalemult, -noscalemult)
	point.borderleft:SetWidth(noscalemult)
	point.borderleft:SetTexture(0,0,0)	
	point.borderleft:SetDrawLayer("BORDER", 1)
	point.borderright = frame:CreateTexture(nil, "BORDER")
	point.borderright:SetPoint("TOPRIGHT", point, "TOPRIGHT", noscalemult, noscalemult)
	point.borderright:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", -noscalemult, -noscalemult)
	point.borderright:SetWidth(noscalemult)
	point.borderright:SetTexture(0,0,0)	
	point.borderright:SetDrawLayer("BORDER", 1)	
end

local function StyleCharacterSlots()
	for _,slotName in pairs(CharacterSlotNames) do
		local globalName = ("Character%s"):format(slotName)
		local charSlot = _G[globalName]
		if(charSlot) then
			if(not charSlot.Panel) then
				charSlot:RemoveTextures()
				charSlot.ignoreTexture:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-LeaveItem-Transparent]])
				charSlot:SetStylePanel("Slot", 1, 0, 0)

				local iconTex = _G[globalName.."IconTexture"]
				if(iconTex) then
					iconTex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					iconTex:SetAllPointsIn(charSlot)
					iconTex:SetParent(charSlot.Panel)
				end
			end

			local slotID = GetInventorySlotInfo(slotName)
			if(slotID) then
				local itemID = GetInventoryItemID("player", slotID)
				if(itemID) then 
					local info = select(3, GetItemInfo(itemID))
					if info and info > 1 then
						 charSlot:SetBackdropBorderColor(GetItemQualityColor(info))
					else
						 charSlot:SetBackdropBorderColor(0,0,0,1)
					end 
				else
					 charSlot:SetBackdropBorderColor(0,0,0,1)
				end
			end
		end 
	end

	for i = 1, #PAPERDOLL_SIDEBARS do 
		local tab = _G["PaperDollSidebarTab"..i]
		if(tab) then
			if(not tab.Panel) then
				tab.Highlight:SetTexture(1, 1, 1, 0.3)
				tab.Highlight:SetPointToScale("TOPLEFT", 3, -4)
				tab.Highlight:SetPointToScale("BOTTOMRIGHT", -1, 0)
				tab.Hider:SetTexture(0.4, 0.4, 0.4, 0.4)
				tab.Hider:SetPointToScale("TOPLEFT", 3, -4)
				tab.Hider:SetPointToScale("BOTTOMRIGHT", -1, 0)
				tab.TabBg:Die()
				if i == 1 then
					for x = 1, tab:GetNumRegions()do 
						local texture = select(x, tab:GetRegions())
						texture:SetTexCoord(0.16, 0.86, 0.16, 0.86)
					end 
				end 
				tab:SetStylePanel("Frame", "Default", true, 2)
				tab.Panel:SetPointToScale("TOPLEFT", 2, -3)
				tab.Panel:SetPointToScale("BOTTOMRIGHT", 0, -2)
			end
			if(i == 1) then
				tab:ClearAllPoints()
				tab:SetPoint("BOTTOM", CharacterFrameInsetRight, "TOP", -30, 4)
			else
				tab:ClearAllPoints()
				tab:SetPoint("LEFT",  _G["PaperDollSidebarTab"..i-1], "RIGHT", 4, 0)
			end
		end 
	end
end 

local function EquipmentFlyout_OnShow()
	EquipmentFlyoutFrameButtons:RemoveTextures()
	local counter = 1;
	local button = _G["EquipmentFlyoutFrameButton"..counter]
	while button do 
		local texture = _G["EquipmentFlyoutFrameButton"..counter.."IconTexture"]
		button:SetStylePanel("Button")
		texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		button:GetNormalTexture():SetTexture(0,0,0,0)
		texture:SetAllPointsIn()
		button:SetFrameLevel(button:GetFrameLevel() + 2)
		if not button.Panel then
			button:SetStylePanel("Frame", "Default")
			button.Panel:SetAllPoints()
		end 
		counter = counter + 1;
		button = _G["EquipmentFlyoutFrameButton"..counter]
	end 
end

local function Reputation_OnShow()
	for i = 1, GetNumFactions()do 
		local bar = _G["ReputationBar"..i.."ReputationBar"]
		if bar then
			 bar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
			if not bar.Panel then
				 bar:SetStylePanel("Frame", "Inset")
			end 
			_G["ReputationBar"..i.."Background"]:SetTexture(0,0,0,0)
			_G["ReputationBar"..i.."ReputationBarHighlight1"]:SetTexture(0,0,0,0)
			_G["ReputationBar"..i.."ReputationBarHighlight2"]:SetTexture(0,0,0,0)
			_G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:SetTexture(0,0,0,0)
			_G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:SetTexture(0,0,0,0)
			_G["ReputationBar"..i.."ReputationBarLeftTexture"]:SetTexture(0,0,0,0)
			_G["ReputationBar"..i.."ReputationBarRightTexture"]:SetTexture(0,0,0,0)
		end 
	end 
end

local function PaperDollTitlesPane_OnShow()
	for i,btn in pairs(PaperDollTitlesPane.buttons) do
		if(btn) then
			btn.BgTop:SetTexture(0,0,0,0)
			btn.BgBottom:SetTexture(0,0,0,0)
			btn.BgMiddle:SetTexture(0,0,0,0)
		end
	end
	PaperDollTitlesPane_Update()
end

local function PaperDollEquipmentManagerPane_OnShow()
	for i,btn in pairs(PaperDollEquipmentManagerPane.buttons) do
		if(btn) then
			btn.BgTop:SetTexture(0,0,0,0)
			btn.BgBottom:SetTexture(0,0,0,0)
			btn.BgMiddle:SetTexture(0,0,0,0)
			btn.icon:SetSizeToScale(36, 36)
			btn.Check:SetTexture(0,0,0,0)
			btn.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			btn.icon:SetPoint("LEFT", btn, "LEFT", 4, 0)
			if not btn.icon.bordertop then
				 SetItemFrame(btn, btn.icon)
			end 
		end
	end

	GearManagerDialogPopup:RemoveTextures()
	GearManagerDialogPopup:SetStylePanel("Frame", "Inset", true)
	GearManagerDialogPopup:SetPointToScale("LEFT", PaperDollFrame, "RIGHT", 4, 0)
	GearManagerDialogPopupScrollFrame:RemoveTextures()
	GearManagerDialogPopupEditBox:RemoveTextures()
	GearManagerDialogPopupEditBox:SetStylePanel("Frame", 'Inset')
	GearManagerDialogPopupOkay:SetStylePanel("Button")
	GearManagerDialogPopupCancel:SetStylePanel("Button")

	for i = 1, NUM_GEARSET_ICONS_SHOWN do 
		local btn = _G["GearManagerDialogPopupButton"..i]
		if(btn and (not btn.Panel)) then
			btn:RemoveTextures()
			btn:SetFrameLevel(btn:GetFrameLevel() + 2)
			btn:SetStylePanel("Button")
			if(btn.icon) then
				btn.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				btn.icon:SetTexture(0,0,0,0)
				btn.icon:SetAllPointsIn()
			end 
		end 
	end
end
--[[ 
########################################################## 
CHARACTERFRAME PLUGINR
##########################################################
]]--
local function CharacterFrameStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.character ~= true then
		 return 
	end

	PLUGIN:ApplyWindowStyle(CharacterFrame, true)

	PLUGIN:ApplyCloseButtonStyle(CharacterFrameCloseButton)
	PLUGIN:ApplyScrollFrameStyle(CharacterStatsPaneScrollBar)
	PLUGIN:ApplyScrollFrameStyle(ReputationListScrollFrameScrollBar)
	PLUGIN:ApplyScrollFrameStyle(TokenFrameContainerScrollBar)
	PLUGIN:ApplyScrollFrameStyle(GearManagerDialogPopupScrollFrameScrollBar)
	
	StyleCharacterSlots()

	SlotListener:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	SlotListener:SetScript("OnEvent", StyleCharacterSlots)
	CharacterFrame:HookScript("OnShow", StyleCharacterSlots)

	PLUGIN:ApplyPaginationStyle(CharacterFrameExpandButton)

	hooksecurefunc('CharacterFrame_Collapse', function()
		CharacterFrameExpandButton:RemoveTextures()
		SquareButton_SetIcon(CharacterFrameExpandButton, 'RIGHT')
	end)

	hooksecurefunc('CharacterFrame_Expand', function()
		CharacterFrameExpandButton:RemoveTextures()
		SquareButton_SetIcon(CharacterFrameExpandButton, 'LEFT')
	end)

	if GetCVar("characterFrameCollapsed") ~= "0" then
		 SquareButton_SetIcon(CharacterFrameExpandButton, 'RIGHT')
	else
		 SquareButton_SetIcon(CharacterFrameExpandButton, 'LEFT')
	end 

	PLUGIN:ApplyCloseButtonStyle(ReputationDetailCloseButton)
	PLUGIN:ApplyCloseButtonStyle(TokenFramePopupCloseButton)
	ReputationDetailAtWarCheckBox:SetStylePanel("Checkbox", true)
	ReputationDetailMainScreenCheckBox:SetStylePanel("Checkbox", true)
	ReputationDetailInactiveCheckBox:SetStylePanel("Checkbox", true)
	ReputationDetailLFGBonusReputationCheckBox:SetStylePanel("Checkbox", true)
	TokenFramePopupInactiveCheckBox:SetStylePanel("Checkbox", true)
	TokenFramePopupBackpackCheckBox:SetStylePanel("Checkbox", true)
	EquipmentFlyoutFrameHighlight:Die()
	EquipmentFlyoutFrame:HookScript("OnShow", EquipmentFlyout_OnShow)
	hooksecurefunc("EquipmentFlyout_Show", EquipmentFlyout_OnShow)
	CharacterFramePortrait:Die()
	PLUGIN:ApplyScrollFrameStyle(_G["PaperDollTitlesPaneScrollBar"], 5)
	PLUGIN:ApplyScrollFrameStyle(_G["PaperDollEquipmentManagerPaneScrollBar"], 5)

	for _,gName in pairs(CharFrameList) do
		if(_G[gName]) then _G[gName]:RemoveTextures(true) end
	end 

	CharacterFrameInsetRight:SetStylePanel("Frame", 'Inset')

	for i=1, 6 do
		local pane = _G["CharacterStatsPaneCategory"..i]
		if(pane) then
			pane:RemoveTextures()
		end
	end

	CharacterModelFrameBackgroundTopLeft:SetTexture(0,0,0,0)
	CharacterModelFrameBackgroundTopRight:SetTexture(0,0,0,0)
	CharacterModelFrameBackgroundBotLeft:SetTexture(0,0,0,0)
	CharacterModelFrameBackgroundBotRight:SetTexture(0,0,0,0)

	CharacterModelFrame:SetStylePanel("!_Frame", "Model")
	CharacterFrameExpandButton:SetFrameLevel(CharacterModelFrame:GetFrameLevel() + 5)

	PaperDollTitlesPane:RemoveTextures()
	PaperDollTitlesPaneScrollChild:RemoveTextures()
	PaperDollTitlesPane:SetStylePanel("Frame", 'Inset')
	PaperDollTitlesPane:HookScript("OnShow", PaperDollTitlesPane_OnShow)

	PaperDollEquipmentManagerPane:SetStylePanel("Frame", 'Inset')
	PaperDollEquipmentManagerPaneEquipSet:SetStylePanel("Button")
	PaperDollEquipmentManagerPaneSaveSet:SetStylePanel("Button")
	PaperDollEquipmentManagerPaneEquipSet:SetWidthToScale(PaperDollEquipmentManagerPaneEquipSet:GetWidth()-8)
	PaperDollEquipmentManagerPaneSaveSet:SetWidthToScale(PaperDollEquipmentManagerPaneSaveSet:GetWidth()-8)
	PaperDollEquipmentManagerPaneEquipSet:SetPointToScale("TOPLEFT", PaperDollEquipmentManagerPane, "TOPLEFT", 8, 0)
	PaperDollEquipmentManagerPaneSaveSet:SetPointToScale("LEFT", PaperDollEquipmentManagerPaneEquipSet, "RIGHT", 4, 0)
	PaperDollEquipmentManagerPaneEquipSet.ButtonBackground:SetTexture(0,0,0,0)

	PaperDollEquipmentManagerPane:HookScript("OnShow", PaperDollEquipmentManagerPane_OnShow)

	for i = 1, 4 do
		 PLUGIN:ApplyTabStyle(_G["CharacterFrameTab"..i])
	end


	ReputationFrame:RemoveTextures(true)
	ReputationListScrollFrame:RemoveTextures()
	ReputationListScrollFrame:SetStylePanel("Frame", "Inset")
	ReputationDetailFrame:RemoveTextures()
	ReputationDetailFrame:SetStylePanel("Frame", "Inset", true)
	ReputationDetailFrame:SetPointToScale("TOPLEFT", ReputationFrame, "TOPRIGHT", 4, -28)
	ReputationFrame:HookScript("OnShow", Reputation_OnShow)
	hooksecurefunc("ExpandFactionHeader", Reputation_OnShow)
	hooksecurefunc("CollapseFactionHeader", Reputation_OnShow)
	TokenFrameContainer:SetStylePanel("Frame", 'Inset')

	TokenFrame:HookScript("OnShow", function()
		for i = 1, GetCurrencyListSize() do 
			local currency = _G["TokenFrameContainerButton"..i]
			if(currency) then
				currency.highlight:Die()
				currency.categoryMiddle:Die()
				currency.categoryLeft:Die()
				currency.categoryRight:Die()
				if currency.icon then
					 currency.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				end 
			end 
		end 
		TokenFramePopup:RemoveTextures()
		TokenFramePopup:SetStylePanel("Frame", "Inset", true)
		TokenFramePopup:SetPointToScale("TOPLEFT", TokenFrame, "TOPRIGHT", 4, -28)
	end)

	PetModelFrame:SetStylePanel("Frame", "Premium", false, 1, -7, -7)
	PetPaperDollPetInfo:GetRegions():SetTexCoord(.12, .63, .15, .55)
	PetPaperDollPetInfo:SetFrameLevel(PetPaperDollPetInfo:GetFrameLevel() + 10)
	PetPaperDollPetInfo:SetStylePanel("Frame", "Slot")
	PetPaperDollPetInfo.Panel:SetFrameLevel(0)
	PetPaperDollPetInfo:SetSizeToScale(24, 24)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveCustomStyle(CharacterFrameStyle)