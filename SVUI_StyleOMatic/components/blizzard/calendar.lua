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
local ipairs        = _G.ipairs;
local pairs         = _G.pairs;
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
local CalendarButtons = {
	"CalendarViewEventAcceptButton",
	"CalendarViewEventTentativeButton",
	"CalendarViewEventRemoveButton",
	"CalendarViewEventDeclineButton"
};
--[[ 
########################################################## 
CALENDAR PLUGINR
##########################################################
]]--
local function CalendarStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.calendar ~= true then
		 return 
	end

	PLUGIN:ApplyWindowStyle(CalendarFrame)

	PLUGIN:ApplyCloseButtonStyle(CalendarCloseButton)
	CalendarCloseButton:SetPoint("TOPRIGHT", CalendarFrame, "TOPRIGHT", -4, -4)
	PLUGIN:ApplyPaginationStyle(CalendarPrevMonthButton)
	PLUGIN:ApplyPaginationStyle(CalendarNextMonthButton)

	do 
		local cfframe = _G["CalendarFilterFrame"];
		
		if(cfframe) then
			cfframe:RemoveTextures()
			cfframe:SetWidthToScale(155)
			cfframe:SetStylePanel("Frame", "Default")

			local cfbutton = _G["CalendarFilterButton"];
			if(cfbutton) then
				cfbutton:ClearAllPoints()
				cfbutton:SetPoint("RIGHT", cfframe, "RIGHT", -10, 3)
				PLUGIN:ApplyPaginationStyle(cfbutton, true)
				cfframe.Panel:SetPoint("TOPLEFT", 20, 2)
				cfframe.Panel:SetPoint("BOTTOMRIGHT", cfbutton, "BOTTOMRIGHT", 2, -2)

				local cftext = _G["CalendarFilterFrameText"]
				if(cftext) then
					cftext:ClearAllPoints()
					cftext:SetPoint("RIGHT", cfbutton, "LEFT", -2, 0)
				end
			end
		end
	end

	local l = CreateFrame("Frame", "CalendarFrameBackdrop", CalendarFrame)
	l:SetStylePanel("!_Frame", "Default")
	l:SetPoint("TOPLEFT", 10, -72)
	l:SetPoint("BOTTOMRIGHT", -8, 3)
	CalendarContextMenu:SetStylePanel("!_Frame", "Default")
	hooksecurefunc(CalendarContextMenu, "SetBackdropColor", function(f, r, g, b, a)
		if r ~= 0 or g ~= 0 or b ~= 0 or a ~= 0.5 then
			 f:SetBackdropColor(0, 0, 0, 0.5)
		end 
	end)
	hooksecurefunc(CalendarContextMenu, "SetBackdropBorderColor", function(f, r, g, b)
		if r ~= 0 or g ~= 0 or b ~= 0 then
			 f:SetBackdropBorderColor(0, 0, 0)
		end 
	end)
	for u = 1, 42 do
		 _G["CalendarDayButton"..u]:SetFrameLevel(_G["CalendarDayButton"..u]:GetFrameLevel()+1)
	end 
	CalendarCreateEventFrame:RemoveTextures()
	CalendarCreateEventFrame:SetStylePanel("!_Frame", "Transparent", true)
	CalendarCreateEventFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, -24)
	CalendarCreateEventTitleFrame:RemoveTextures()
	CalendarCreateEventCreateButton:SetStylePanel("Button")
	CalendarCreateEventMassInviteButton:SetStylePanel("Button")
	CalendarCreateEventInviteButton:SetStylePanel("Button")
	CalendarCreateEventInviteButton:SetPoint("TOPLEFT", CalendarCreateEventInviteEdit, "TOPRIGHT", 4, 1)
	CalendarCreateEventInviteEdit:SetWidthToScale(CalendarCreateEventInviteEdit:GetWidth()-2)
	CalendarCreateEventInviteList:RemoveTextures()
	CalendarCreateEventInviteList:SetStylePanel("!_Frame", "Default")
	CalendarCreateEventInviteEdit:SetStylePanel("Editbox")
	CalendarCreateEventTitleEdit:SetStylePanel("Editbox")
	PLUGIN:ApplyDropdownStyle(CalendarCreateEventTypeDropDown, 120)
	CalendarCreateEventDescriptionContainer:RemoveTextures()
	CalendarCreateEventDescriptionContainer:SetStylePanel("!_Frame", "Default")
	PLUGIN:ApplyCloseButtonStyle(CalendarCreateEventCloseButton)
	CalendarCreateEventLockEventCheck:SetStylePanel("Checkbox", true)
	PLUGIN:ApplyDropdownStyle(CalendarCreateEventHourDropDown, 68)
	PLUGIN:ApplyDropdownStyle(CalendarCreateEventMinuteDropDown, 68)
	PLUGIN:ApplyDropdownStyle(CalendarCreateEventAMPMDropDown, 68)
	PLUGIN:ApplyDropdownStyle(CalendarCreateEventRepeatOptionDropDown, 120)
	CalendarCreateEventIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	hooksecurefunc(CalendarCreateEventIcon, "SetTexCoord", function(f, v, w, x, y)
		local z, A, B, C = 0.1, 0.9, 0.1, 0.9 
		if v ~= z or w ~= A or x ~= B or y ~= C then
			 f:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		end 
	end)
	CalendarCreateEventInviteListSection:RemoveTextures()
	CalendarClassButtonContainer:HookScript("OnShow", function()
		for u, D in ipairs(CLASS_SORT_ORDER)do 	
			local e = _G["CalendarClassButton"..u]e:RemoveTextures()
			e:SetStylePanel("Frame", "Default")
			local E = CLASS_ICON_TCOORDS[D]
			local F = e:GetNormalTexture()
			F:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
			F:SetTexCoord(E[1]+0.015, E[2]-0.02, E[3]+0.018, E[4]-0.02)
		end 
		CalendarClassButton1:SetPoint("TOPLEFT", CalendarClassButtonContainer, "TOPLEFT", 5, 0)
		CalendarClassTotalsButton:RemoveTextures()
		CalendarClassTotalsButton:SetStylePanel("Frame", "Default")
	end)
	CalendarTexturePickerFrame:RemoveTextures()
	CalendarTexturePickerTitleFrame:RemoveTextures()
	CalendarTexturePickerFrame:SetStylePanel("!_Frame", "Transparent", true)
	PLUGIN:ApplyScrollFrameStyle(CalendarTexturePickerScrollBar)
	CalendarTexturePickerAcceptButton:SetStylePanel("Button")
	CalendarTexturePickerCancelButton:SetStylePanel("Button")
	CalendarCreateEventInviteButton:SetStylePanel("Button")
	CalendarCreateEventRaidInviteButton:SetStylePanel("Button")
	CalendarMassInviteFrame:RemoveTextures()
	CalendarMassInviteFrame:SetStylePanel("!_Frame", "Transparent", true)
	CalendarMassInviteTitleFrame:RemoveTextures()
	PLUGIN:ApplyCloseButtonStyle(CalendarMassInviteCloseButton)
	CalendarMassInviteGuildAcceptButton:SetStylePanel("Button")
	PLUGIN:ApplyDropdownStyle(CalendarMassInviteGuildRankMenu, 130)
	CalendarMassInviteGuildMinLevelEdit:SetStylePanel("Editbox")
	CalendarMassInviteGuildMaxLevelEdit:SetStylePanel("Editbox")
	CalendarViewRaidFrame:RemoveTextures()
	CalendarViewRaidFrame:SetStylePanel("!_Frame", "Transparent", true)
	CalendarViewRaidFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, -24)
	CalendarViewRaidTitleFrame:RemoveTextures()
	PLUGIN:ApplyCloseButtonStyle(CalendarViewRaidCloseButton)
	CalendarViewHolidayFrame:RemoveTextures(true)
	CalendarViewHolidayFrame:SetStylePanel("!_Frame", "Transparent", true)
	CalendarViewHolidayFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, -24)
	CalendarViewHolidayTitleFrame:RemoveTextures()
	PLUGIN:ApplyCloseButtonStyle(CalendarViewHolidayCloseButton)
	CalendarViewEventFrame:RemoveTextures()
	CalendarViewEventFrame:SetStylePanel("!_Frame", "Transparent", true)
	CalendarViewEventFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, -24)
	CalendarViewEventTitleFrame:RemoveTextures()
	CalendarViewEventDescriptionContainer:RemoveTextures()
	CalendarViewEventDescriptionContainer:SetStylePanel("!_Frame", "Transparent", true)
	CalendarViewEventInviteList:RemoveTextures()
	CalendarViewEventInviteList:SetStylePanel("!_Frame", "Transparent", true)
	CalendarViewEventInviteListSection:RemoveTextures()
	PLUGIN:ApplyCloseButtonStyle(CalendarViewEventCloseButton)
	PLUGIN:ApplyScrollFrameStyle(CalendarViewEventInviteListScrollFrameScrollBar)
	for _,btn in pairs(CalendarButtons)do
		 _G[btn]:SetStylePanel("Button")
	end 
	CalendarEventPickerFrame:RemoveTextures()
	CalendarEventPickerTitleFrame:RemoveTextures()
	CalendarEventPickerFrame:SetStylePanel("!_Frame", "Transparent", true)
	PLUGIN:ApplyScrollFrameStyle(CalendarEventPickerScrollBar)
	CalendarEventPickerCloseButton:SetStylePanel("Button")
	PLUGIN:ApplyScrollFrameStyle(CalendarCreateEventDescriptionScrollFrameScrollBar)
	PLUGIN:ApplyScrollFrameStyle(CalendarCreateEventInviteListScrollFrameScrollBar)
	PLUGIN:ApplyScrollFrameStyle(CalendarViewEventDescriptionScrollFrameScrollBar)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle("Blizzard_Calendar",CalendarStyle)