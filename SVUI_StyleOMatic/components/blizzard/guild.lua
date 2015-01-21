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
local unpack  	= _G.unpack;
local select  	= _G.select;
local ipairs  	= _G.ipairs;
local pairs   	= _G.pairs;
local next    	= _G.next;
local time 		= _G.time;
local date 		= _G.date;
local ceil, modf = math.ceil, math.modf;
--[[ ADDON ]]--
local SV = _G.SVUI;
local L = SV.L;
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
local BAGS = SV.SVBag
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local format = string.format;
local internalTest = false;

local GuildFrameList = {	
	"GuildNewPerksFrame",
	"GuildFrameInset",
	"GuildFrameBottomInset",
	"GuildAllPerksFrame",
	"GuildMemberDetailFrame",
	"GuildMemberNoteBackground",
	"GuildInfoFrameInfo",
	"GuildLogContainer",
	"GuildLogFrame",
	"GuildRewardsFrame",
	"GuildMemberOfficerNoteBackground",
	"GuildTextEditContainer",
	"GuildTextEditFrame",
	"GuildRecruitmentRolesFrame",
	"GuildRecruitmentAvailabilityFrame",
	"GuildRecruitmentInterestFrame",
	"GuildRecruitmentLevelFrame",
	"GuildRecruitmentCommentFrame",
	"GuildRecruitmentCommentInputFrame",
	"GuildInfoFrameApplicantsContainer",
	"GuildInfoFrameApplicants",
	"GuildNewsBossModel",
	"GuildNewsBossModelTextFrame"
};

local GuildButtonList = {
	"GuildPerksToggleButton",
	"GuildMemberRemoveButton",
	"GuildMemberGroupInviteButton",
	"GuildAddMemberButton",
	"GuildViewLogButton",
	"GuildControlButton",
	"GuildRecruitmentListGuildButton",
	"GuildTextEditFrameAcceptButton",
	"GuildRecruitmentInviteButton",
	"GuildRecruitmentMessageButton",
	"GuildRecruitmentDeclineButton"
};

local GuildCheckBoxList = {
	"GuildRecruitmentQuestButton",
	"GuildRecruitmentDungeonButton",
	"GuildRecruitmentRaidButton",
	"GuildRecruitmentPvPButton",
	"GuildRecruitmentRPButton",
	"GuildRecruitmentWeekdaysButton",
	"GuildRecruitmentWeekendsButton",
	"GuildRecruitmentLevelAnyButton",
	"GuildRecruitmentLevelMaxButton"
};

local CalendarIconList = {
	[CALENDAR_EVENTTYPE_PVP] = "Interface\\Calendar\\UI-Calendar-Event-PVP",
	[CALENDAR_EVENTTYPE_MEETING] = "Interface\\Calendar\\MeetingIcon",
	[CALENDAR_EVENTTYPE_OTHER] = "Interface\\Calendar\\UI-Calendar-Event-Other"
};

local LFGFrameList = {  
  "LookingForGuildPvPButton",
  "LookingForGuildWeekendsButton",
  "LookingForGuildWeekdaysButton",
  "LookingForGuildRPButton",
  "LookingForGuildRaidButton",
  "LookingForGuildQuestButton",
  "LookingForGuildDungeonButton"
};

local function GCTabHelper(tab)
	tab.Panel:Hide()
	tab.bg1 = tab:CreateTexture(nil,"BACKGROUND")
	tab.bg1:SetDrawLayer("BACKGROUND",4)
	tab.bg1:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	tab.bg1:SetVertexColor(unpack(SV.Media.color.default))
	tab.bg1:SetAllPointsIn(tab.Panel,1)
	tab.bg3 = tab:CreateTexture(nil,"BACKGROUND")
	tab.bg3:SetDrawLayer("BACKGROUND",2)
	tab.bg3:SetTexture(0,0,0,1)
	tab.bg3:SetAllPoints(tab.Panel) 
end

local function Tab_OnEnter(this)
	this.backdrop:SetBackdropColor(0.1, 0.8, 0.8)
	this.backdrop:SetBackdropBorderColor(0.1, 0.8, 0.8)
end

local function Tab_OnLeave(this)
	this.backdrop:SetBackdropColor(0,0,0,1)
	this.backdrop:SetBackdropBorderColor(0,0,0,1)
end

local function ChangeTabHelper(this)
	this:RemoveTextures()
	local nTex = this:GetNormalTexture()
	if(nTex) then
		nTex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		nTex:SetAllPointsIn()
	end

	this.pushed = true;

	this.backdrop = CreateFrame("Frame", nil, this)
	this.backdrop:SetAllPointsOut(this,1,1)
	this.backdrop:SetFrameLevel(0)
	this.backdrop:SetBackdrop({
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
    this.backdrop:SetBackdropColor(0,0,0,1)
	this.backdrop:SetBackdropBorderColor(0,0,0,1)
	this:SetScript("OnEnter", Tab_OnEnter)
	this:SetScript("OnLeave", Tab_OnLeave)

	local a,b,c,d,e = this:GetPoint()
	this:SetPointToScale(a,b,c,1,e)
end 

local function StyleSortingButton(button)
	if button.styled then return end 

	local outer = button:CreateTexture(nil, "OVERLAY")
	outer:SetAllPointsOut(button, 6, 6)
	outer:SetTexture([[Interface\Addons\SVUI\assets\artwork\Template\ROUND]])
	outer:SetGradient("VERTICAL", 0.4, 0.47, 0.5, 0.3, 0.33, 0.35)

	if button.SetNormalTexture then 
		iconTex = button:GetNormalTexture()
		iconTex:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
	end 
	
	local icon = button:CreateTexture(nil, "OVERLAY")
	icon:SetAllPointsOut(button, 6, 6)
	SetPortraitToTexture(icon, iconTex)
	hooksecurefunc(icon, "SetTexture", SetPortraitToTexture)

	local hover = button:CreateTexture(nil, "HIGHLIGHT")
	hover:SetAllPointsOut(button, 6, 6)
	hover:SetTexture([[Interface\Addons\SVUI\assets\artwork\Template\ROUND]])
	hover:SetGradient(unpack(SV.Media.gradient.yellow))

	if button.SetPushedTexture then 
		local pushed = button:CreateTexture(nil, "BORDER")
		pushed:SetAllPointsOut(button, 6, 6)
		pushed:SetTexture([[Interface\Addons\SVUI\assets\artwork\Template\ROUND]])
		pushed:SetGradient(unpack(SV.Media.gradient.highlight))
		button:SetPushedTexture(pushed)
	end 

	if button.SetCheckedTexture then 
		local checked = button:CreateTexture(nil, "BORDER")
		checked:SetAllPointsOut(button, 6, 6)
		checked:SetTexture([[Interface\Addons\SVUI\assets\artwork\Template\ROUND]])
		checked:SetGradient(unpack(SV.Media.gradient.green))
		button:SetCheckedTexture(checked)
	end 

	if button.SetDisabledTexture then 
		local disabled = button:CreateTexture(nil, "BORDER")
		disabled:SetAllPointsOut(button, 6, 6)
		disabled:SetTexture([[Interface\Addons\SVUI\assets\artwork\Template\ROUND]])
		disabled:SetGradient(unpack(SV.Media.gradient.default))
		button:SetDisabledTexture(disabled)
	end 

	local cd = button:GetName() and _G[button:GetName().."Cooldown"]
	if cd then 
		cd:ClearAllPoints()
		cd:SetAllPointsIn()
	end 
	button.styled = true
end

local _hook_RankOrder_OnUpdate = function()
	for i = 1, GuildControlGetNumRanks()do 
		local frame = _G["GuildControlUIRankOrderFrameRank"..i]
		if frame then 
			frame.downButton:SetStylePanel("Button")
			frame.upButton:SetStylePanel("Button")
			frame.deleteButton:SetStylePanel("Button")
			if not frame.nameBox.Panel then 
				frame.nameBox:SetStylePanel("Editbox")
			end 
			frame.nameBox.Panel:SetPointToScale("TOPLEFT",-2,-4)
			frame.nameBox.Panel:SetPointToScale("BOTTOMRIGHT",-4,4)
		end 
	end 
end 

function GuildInfoEvents_SetButton(button, eventIndex)
	local dateData = date("*t")
	local month, day, weekday, hour, minute, eventType, title, calendarType, textureName = CalendarGetGuildEventInfo(eventIndex)
	local formattedTime = GameTime_GetFormattedTime(hour, minute, true)
	local unformattedText;
	if dateData["day"] == day and dateData["month"] == month then
		unformattedText = NORMAL_FONT_COLOR_CODE..GUILD_EVENT_TODAY..FONT_COLOR_CODE_CLOSE 
	else
		local year = dateData["year"]
		if month < dateData["month"] then
			year = year + 1 
		end 
		local newTime = time{year = year, month = month, day = day}
		if(((newTime - time()) < 518400) and CALENDAR_WEEKDAY_NAMES[weekday]) then
			unformattedText = CALENDAR_WEEKDAY_NAMES[weekday]
		elseif CALENDAR_WEEKDAY_NAMES[weekday]and day and month then 
			unformattedText = format(GUILD_NEWS_DATE, CALENDAR_WEEKDAY_NAMES[weekday], day, month)
		end 
	end 
	if button.text and unformattedText then
		button.text:SetFormattedText(GUILD_EVENT_FORMAT, unformattedText, formattedTime, title)
	end 
	button.index = eventIndex;
	if button.icon.type ~= "event" then
		button.icon.type = "event"
		button.icon:SetTexCoord(0, 1, 0, 1)
		button.icon:SetWidth(14)
		button.icon:SetHeight(14)
	end 
	if CalendarIconList[eventType] then
		button.icon:SetTexture(CalendarIconList[eventType])
	else
		button.icon:SetTexture("Interface\\LFGFrame\\LFGIcon-"..textureName)
	end 
end

local _hook_UIRankOrder = function(self)
	SV.Timers:ExecuteTimer(1, _hook_RankOrder_OnUpdate)
end

local _hook_GuildBankFrame_Update = function(self)
	if GuildBankFrame.mode ~= "bank" then return end 
	local curTab = GetCurrentGuildBankTab()
	local numSlots = NUM_SLOTS_PER_GUILDBANK_GROUP
	local maxSlots = MAX_GUILDBANK_SLOTS_PER_TAB
	local button, btnName, btnID, slotID, itemLink;
	for i = 1, maxSlots do
		btnID = i % numSlots
		if btnID == 0 then
			btnID = numSlots 
		end
		slotID = ceil((i - 0.5) / numSlots)
		btnName = ("GuildBankColumn%dButton%d"):format(slotID, btnID)
		button = _G[btnName]
		if(button) then
			itemLink = GetGuildBankItemLink(curTab, i)
			local r, g, b, a = 0,0,0,1
			if(itemLink) then
				local quality = select(3, GetItemInfo(itemLink))
				if(quality > 1) then
					r, g, b = GetItemQualityColor(quality)
				end
			end 
			button:SetBackdropBorderColor(r, g, b, a)
		end
	end 
end

local _hook_BankTabPermissions = function(self)
	local tab, tabs, baseName, ownedName, purchase, view, stack, deposit, update

	tabs = GetNumGuildBankTabs()

	if tabs < MAX_BUY_GUILDBANK_TABS then 
		tabs = tabs + 1 
	end

	for i = 1, tabs do 
		baseName = ("GuildControlBankTab%d"):format(i)
		ownedName = ("%sOwned"):format(baseName)
		tab = _G[ownedName]
		
		if(tab) then
			if(tab.tabIcon) then tab.tabIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9) end
			if(tab.editBox) then tab.editBox:SetStylePanel("Editbox") end

			if internalTest == false then
				purchase =  _G[baseName.."BuyPurchaseButton"]
				if(purchase) then
					purchase:SetStylePanel("Button")
				end
				view =  _G[ownedName.."ViewCheck"]
				if(view) then
					view:SetStylePanel("Checkbox", true)
					GCTabHelper(view)
				end
				stack =  _G[ownedName.."StackBox"]
				if(stack) then
					stack:SetStylePanel("Editbox")
					GCTabHelper(stack)
				end
				deposit =  _G[ownedName.."DepositCheck"]
				if(deposit) then
					deposit:SetStylePanel("Checkbox", true)
					GCTabHelper(deposit)
				end
				update =  _G[ownedName.."UpdateInfoCheck"]
				if(update) then
					update:SetStylePanel("Checkbox", true)
					GCTabHelper(update)
				end
			end
		end
	end 
	internalTest = true 
end
--[[ 
########################################################## 
GUILDFRAME PLUGINRS
##########################################################
]]--
local function GuildBankStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.gbank ~= true then
		return 
	end

	PLUGIN:ApplyWindowStyle(GuildBankFrame)

	GuildBankEmblemFrame:RemoveTextures(true)
	GuildBankMoneyFrameBackground:Die()
	PLUGIN:ApplyScrollFrameStyle(GuildBankPopupScrollFrameScrollBar)

	for i = 1, GuildBankFrame:GetNumChildren() do 
		local child = select(i, GuildBankFrame:GetChildren())
		if(child and child.GetPushedTexture and child:GetPushedTexture() and not child:GetName()) then
			PLUGIN:ApplyCloseButtonStyle(child)
		end 
	end

	GuildBankFrameDepositButton:SetStylePanel("Button")
	GuildBankFrameWithdrawButton:SetStylePanel("Button")
	GuildBankInfoSaveButton:SetStylePanel("Button")
	GuildBankFramePurchaseButton:SetStylePanel("Button")


	local sortButton = CreateFrame("Button", nil, GuildBankFrame)
	sortButton:SetPointToScale("BOTTOMLEFT", GuildBankFrame, "BOTTOMRIGHT", 2, 0)
	sortButton:SetSizeToScale(36, 36)
	sortButton:SetStylePanel("HeavyButton") 
	sortButton:SetNormalTexture([[Interface\AddOns\SVUI\assets\artwork\Icons\BAGS-CLEANUP]])
	--StyleSortingButton(sortButton)
	local Sort_OnClick = BAGS:RunSortingProcess(BAGS.Sort, "guild")
	sortButton:SetScript("OnClick", Sort_OnClick)

	GuildBankFrameWithdrawButton:SetPointToScale("RIGHT", GuildBankFrameDepositButton, "LEFT", -2, 0)
	GuildBankInfoScrollFrame:SetPointToScale('TOPLEFT', GuildBankInfo, 'TOPLEFT', -10, 12)
	GuildBankInfoScrollFrame:RemoveTextures()
	GuildBankInfoScrollFrame:SetWidthToScale(GuildBankInfoScrollFrame:GetWidth()-8)
	GuildBankTransactionsScrollFrame:RemoveTextures()
	
	for i = 1, NUM_GUILDBANK_COLUMNS do
		local frame = _G["GuildBankColumn"..i]
		if(frame) then
			frame:RemoveTextures()
			local baseName = ("GuildBankColumn%dButton"):format(i)
			for slotID = 1, NUM_SLOTS_PER_GUILDBANK_GROUP do 
				local btnName = ("%s%d"):format(baseName, slotID)
				local button = _G[btnName]
				if(button) then
					local texture = _G[btnName.."NormalTexture"]
					if texture then
						texture:SetTexture(0,0,0,0)
					end
					button:RemoveTextures()
					button:SetStylePanel("Slot", 2, 0, 0)

					local icon = _G[btnName.."IconTexture"]
					if(icon) then
						icon:SetAllPointsIn()
						icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					end
				end
			end
		end
	end 

	for i = 1, 8 do
		local baseName = ("GuildBankTab%d"):format(i)
		local tab = _G[baseName]
		if(tab) then
			tab:RemoveTextures(true)
			local btnName = ("%sButton"):format(baseName)
			local button = _G[btnName]
			if(button) then
				button:RemoveTextures()
				button:SetStylePanel("Button")
				local texture = _G[btnName.."IconTexture"]
				if(texture) then
					texture:SetAllPointsIn()
					texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				end
			end
		end
	end 

	for i = 1, 4 do
		local baseName = ("GuildBankFrameTab%d"):format(i)
		local frame = _G[baseName]
		if(frame) then
			PLUGIN:ApplyTabStyle(_G[baseName])
		end
	end 

	hooksecurefunc('GuildBankFrame_Update', _hook_GuildBankFrame_Update)

	GuildBankPopupFrame:RemoveTextures()
	GuildBankPopupScrollFrame:RemoveTextures()
	GuildBankPopupFrame:SetStylePanel("!_Frame", "Transparent", true)
	GuildBankPopupFrame:SetPointToScale("TOPLEFT", GuildBankFrame, "TOPRIGHT", 1, -30)
	GuildBankPopupOkayButton:SetStylePanel("Button")
	GuildBankPopupCancelButton:SetStylePanel("Button")
	GuildBankPopupEditBox:SetStylePanel("Editbox")
	GuildBankPopupNameLeft:Die()
	GuildBankPopupNameRight:Die()
	GuildBankPopupNameMiddle:Die()
	GuildItemSearchBox:RemoveTextures()
	GuildItemSearchBox:SetStylePanel("Frame", "Overlay")
	GuildItemSearchBox.Panel:SetPointToScale("TOPLEFT", 10, -1)
	GuildItemSearchBox.Panel:SetPointToScale("BOTTOMRIGHT", 4, 1)

	for i = 1, 16 do
		local btnName = ("GuildBankPopupButton%d"):format(i)
		local button = _G[btnName]
		if(button) then
			button:RemoveTextures()
			button:SetStylePanel("!_Frame", "Default")
			button:SetStylePanel("Button")

			local icon = _G[btnName.."Icon"]
			if(icon) then
				icon:SetAllPointsIn()
				icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			end
		end
	end 

	PLUGIN:ApplyScrollFrameStyle(GuildBankTransactionsScrollFrameScrollBar)
	PLUGIN:ApplyScrollFrameStyle(GuildBankInfoScrollFrameScrollBar)
end 

local function GuildFrameStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.guild ~= true then
		return 
	end
	
	PLUGIN:ApplyWindowStyle(GuildFrame)

	PLUGIN:ApplyCloseButtonStyle(GuildMemberDetailCloseButton)
	PLUGIN:ApplyCloseButtonStyle(GuildFrameCloseButton)
	GuildRewardsFrameVisitText:ClearAllPoints()
	GuildRewardsFrameVisitText:SetPoint("TOP", GuildRewardsFrame, "TOP", 0, 30)

	for i = 1, #GuildFrameList do
		local frame = _G[GuildFrameList[i]]
		if(frame) then
			frame:RemoveTextures()
		end
	end

	for i = 1, #GuildButtonList do
		local button = _G[GuildButtonList[i]]
		if(button) then
			button:RemoveTextures(true)
			button:SetStylePanel("Button")
		end
	end 

	for i = 1, #GuildCheckBoxList do
		local check = _G[GuildCheckBoxList[i]]
		if(check) then check:SetStylePanel("Checkbox", true) end
	end 

	for i = 1, 5 do
		local tab = _G["GuildFrameTab"..i]
		if(tab) then
			PLUGIN:ApplyTabStyle(tab)
			if i == 1 then
				tab:SetPointToScale("TOPLEFT", GuildFrame, "BOTTOMLEFT", -10, 3)
			end
		end
	end
	
	GuildNewsBossModel:SetStylePanel("Frame", 'Transparent')
	GuildNewsBossModelTextFrame:SetStylePanel("Frame", "Default")
	GuildNewsBossModelTextFrame.Panel:SetPointToScale("TOPLEFT", GuildNewsBossModel.Panel, "BOTTOMLEFT", 0, -1)
	GuildNewsBossModel:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 4, -43)

	GuildRecruitmentTankButton.checkButton:SetStylePanel("Checkbox", true)
	GuildRecruitmentHealerButton.checkButton:SetStylePanel("Checkbox", true)
	GuildRecruitmentDamagerButton.checkButton:SetStylePanel("Checkbox", true)

	GuildFactionBar:RemoveTextures()
	GuildFactionBar.progress:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	GuildFactionBar:SetStylePanel("Frame", "Inset")
	GuildFactionBar.Panel:SetPointToScale("TOPLEFT", GuildFactionBar.progress, "TOPLEFT", -1, 1)
	GuildFactionBar.Panel:SetPointToScale("BOTTOMRIGHT", GuildFactionBar, "BOTTOMRIGHT", 1, 1)
	
	GuildRosterContainer:SetStylePanel("Frame", "Inset")
	PLUGIN:ApplyScrollFrameStyle(GuildRosterContainerScrollBar, 4, -4)
	GuildRosterShowOfflineButton:SetStylePanel("Checkbox", true)

	for i = 1, 4 do
		local btn = _G["GuildRosterColumnButton"..i]
		if(btn) then
			btn:RemoveTextures(true)
		end
	end 

	PLUGIN:ApplyDropdownStyle(GuildRosterViewDropdown, 200)

	for i = 1, 14 do
		local btn = _G["GuildRosterContainerButton"..i.."HeaderButton"]
		if(btn) then
			btn:RemoveTextures()
			btn:SetStylePanel("Button")
		end
	end

	GuildMemberDetailFrame:SetStylePanel("Frame", "Default", true)
	GuildMemberNoteBackground:SetStylePanel("Frame", 'Transparent')
	GuildMemberOfficerNoteBackground:SetStylePanel("Frame", 'Transparent')

	PLUGIN:ApplyDropdownStyle(GuildMemberRankDropdown, 182)
	GuildMemberRankDropdown:HookScript("OnShow", function() GuildMemberDetailRankText:Hide() end)
	GuildMemberRankDropdown:HookScript("OnHide", function() GuildMemberDetailRankText:Show() end)
	GuildNewsFrame:RemoveTextures()
	GuildNewsContainer:SetStylePanel("Frame", "Inset")

	for i = 1, 17 do
		local btn = _G["GuildNewsContainerButton"..i]
		if(btn) then
			if(btn.header) then btn.header:Die() end
			btn:RemoveTextures()
			btn:SetStylePanel("Button")
		end 
	end 

	GuildNewsFiltersFrame:RemoveTextures()
	GuildNewsFiltersFrame:SetStylePanel("!_Frame", "Transparent", true)
	PLUGIN:ApplyCloseButtonStyle(GuildNewsFiltersFrameCloseButton)

	for i = 1, 7 do
		local btn = _G["GuildNewsFilterButton"..i]
		if(btn) then
			btn:SetStylePanel("Checkbox", true)
		end
	end 

	GuildNewsFiltersFrame:SetPointToScale("TOPLEFT", GuildFrame, "TOPRIGHT", 4, -20)
	PLUGIN:ApplyScrollFrameStyle(GuildNewsContainerScrollBar, 4, 4)
	PLUGIN:ApplyScrollFrameStyle(GuildInfoDetailsFrameScrollBar, 4, 4)

	for i = 1, 3 do
		local tab = _G["GuildInfoFrameTab"..i]
		if(tab) then
			tab:RemoveTextures()
		end
	end

	local panel1 = CreateFrame("Frame", nil, GuildInfoFrameInfo)
	panel1:SetPoint("TOPLEFT", GuildInfoFrameInfo, "TOPLEFT", 2, -22)
	panel1:SetPoint("BOTTOMRIGHT", GuildInfoFrameInfo, "BOTTOMRIGHT", 0, 200)
	panel1:SetStylePanel("Frame", 'Transparent')

	local panel2 = CreateFrame("Frame", nil, GuildInfoFrameInfo)
	panel2:SetPoint("TOPLEFT", GuildInfoFrameInfo, "TOPLEFT", 2, -158)
	panel2:SetPoint("BOTTOMRIGHT", GuildInfoFrameInfo, "BOTTOMRIGHT", 0, 118)
	panel2:SetStylePanel("Frame", 'Transparent')

	local panel3 = CreateFrame("Frame", nil, GuildInfoFrameInfo)
	panel3:SetPoint("TOPLEFT", GuildInfoFrameInfo, "TOPLEFT", 2, -233)
	panel3:SetPoint("BOTTOMRIGHT", GuildInfoFrameInfo, "BOTTOMRIGHT", 0, 3)
	panel3:SetStylePanel("Frame", 'Transparent')

	GuildRecruitmentCommentInputFrame:SetStylePanel("!_Frame", "Default")
	GuildTextEditFrame:SetStylePanel("!_Frame", "Transparent", true)
	PLUGIN:ApplyScrollFrameStyle(GuildTextEditScrollFrameScrollBar, 4, 4)
	GuildTextEditContainer:SetStylePanel("!_Frame", "Default")

	local editChildren = GuildTextEditFrame:GetNumChildren()

	for i = 1, editChildren do 
		local child = select(i, GuildTextEditFrame:GetChildren())
		if(child:GetName() == "GuildTextEditFrameCloseButton") then
			if(child:GetWidth() < 33) then
				PLUGIN:ApplyCloseButtonStyle(child)
			else
				child:SetStylePanel("Button")
			end
		end 
	end

	PLUGIN:ApplyScrollFrameStyle(GuildLogScrollFrameScrollBar, 4, 4)
	GuildLogFrame:SetStylePanel("Frame", 'Transparent')

	local logChildren = GuildLogFrame:GetNumChildren()

	for i = 1, logChildren do 
		local child = select(i, GuildLogFrame:GetChildren())
		if child:GetName() == "GuildLogFrameCloseButton" then 
			if(child:GetWidth() < 33) then
				PLUGIN:ApplyCloseButtonStyle(child)
			else
				child:SetStylePanel("Button")
			end
		end 
	end 

	GuildRewardsFrame:SetStylePanel("Frame", "Inset")
	PLUGIN:ApplyScrollFrameStyle(GuildRewardsContainerScrollBar, 4, -4)
	PLUGIN:ApplyScrollFrameStyle(GuildPerksContainerScrollBar, 4, 2)

	for i = 1, 8 do 
		local button = _G["GuildPerksContainerButton"..i]
		if button then
			button:RemoveTextures()
			PLUGIN:ApplyItemButtonStyle(button, nil, true)
			local icon = button.icon or button.Icon
			if icon then
				icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				icon:ClearAllPoints()
				icon:SetPointToScale("TOPLEFT", button, "TOPLEFT", 2, -2)
				icon:SetParent(button.Panel)
			end
		end
	end 
	
	for i = 1, 8 do 
		local button = _G["GuildRewardsContainerButton"..i]
		if button then
			button:RemoveTextures()
			PLUGIN:ApplyItemButtonStyle(button)
		end
	end 

	local maxCalendarEvents = CalendarGetNumGuildEvents();
	local scrollFrame = GuildInfoFrameApplicantsContainer;
  	local offset = HybridScrollFrame_GetOffset(scrollFrame);
  	local buttonIndex,counter = 0,0;

	for _,button in next, GuildInfoFrameApplicantsContainer.buttons do
		counter = counter + 1;
		buttonIndex = offset + counter;
		button.selectedTex:Die()
		button:GetHighlightTexture():Die()
		button:SetBackdrop(nil)
	end 
end 

local function GuildControlStyle()
	if PLUGIN.db.blizzard.enable~=true or PLUGIN.db.blizzard.guildcontrol~=true then return end

	GuildControlUI:RemoveTextures()
	GuildControlUIHbar:RemoveTextures()
	GuildControlUIRankBankFrameInset:RemoveTextures()
	GuildControlUIRankBankFrameInsetScrollFrame:RemoveTextures()

	PLUGIN:ApplyWindowStyle(GuildControlUI)

	PLUGIN:ApplyScrollFrameStyle(GuildControlUIRankBankFrameInsetScrollFrameScrollBar)

	hooksecurefunc("GuildControlUI_RankOrder_Update", _hook_RankOrder_OnUpdate)
	GuildControlUIRankOrderFrameNewButton:HookScript("OnClick", _hook_UIRankOrder)

	PLUGIN:ApplyDropdownStyle(GuildControlUINavigationDropDown)
	PLUGIN:ApplyDropdownStyle(GuildControlUIRankSettingsFrameRankDropDown,180)
	GuildControlUINavigationDropDownButton:SetWidthToScale(20)
	GuildControlUIRankSettingsFrameRankDropDownButton:SetWidthToScale(20)

	for i=1, NUM_RANK_FLAGS do
		local check = _G["GuildControlUIRankSettingsFrameCheckbox"..i]
		if(check) then check:SetStylePanel("Checkbox", true) end 
	end

	GuildControlUIRankOrderFrameNewButton:SetStylePanel("Button")
	GuildControlUIRankSettingsFrameGoldBox:SetStylePanel("Editbox")
	GuildControlUIRankSettingsFrameGoldBox.Panel:SetPointToScale("TOPLEFT",-2,-4)
	GuildControlUIRankSettingsFrameGoldBox.Panel:SetPointToScale("BOTTOMRIGHT",2,4)
	GuildControlUIRankSettingsFrameGoldBox:RemoveTextures()
	GuildControlUIRankBankFrame:RemoveTextures()

	hooksecurefunc("GuildControlUI_BankTabPermissions_Update", _hook_BankTabPermissions)

	PLUGIN:ApplyDropdownStyle(GuildControlUIRankBankFrameRankDropDown, 180)

	GuildControlUIRankBankFrameRankDropDownButton:SetWidthToScale(20)
end 


local function GuildRegistrarStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.guildregistrar ~= true then
		return 
	end

	PLUGIN:ApplyWindowStyle(GuildRegistrarFrame, true, true)

	GuildRegistrarFrameInset:Die()
	GuildRegistrarFrameEditBox:RemoveTextures()
	GuildRegistrarGreetingFrame:RemoveTextures()

	GuildRegistrarFrameGoodbyeButton:SetStylePanel("Button")
	GuildRegistrarFrameCancelButton:SetStylePanel("Button")
	GuildRegistrarFramePurchaseButton:SetStylePanel("Button")
	PLUGIN:ApplyCloseButtonStyle(GuildRegistrarFrameCloseButton)
	GuildRegistrarFrameEditBox:SetStylePanel("Editbox")

	for i = 1, GuildRegistrarFrameEditBox:GetNumRegions() do 
		local region = select(i, GuildRegistrarFrameEditBox:GetRegions())
		if region and region:GetObjectType() == "Texture"then
			if region:GetTexture() == "Interface\\ChatFrame\\UI-ChatInputBorder-Left" or region:GetTexture() == "Interface\\ChatFrame\\UI-ChatInputBorder-Right" then 
				region:Die()
			end 
		end 
	end

	GuildRegistrarFrameEditBox:SetHeightToScale(20)

	if(_G["GuildRegistrarButton1"]) then
		_G["GuildRegistrarButton1"]:GetFontString():SetTextColor(1, 1, 1)
	end
	if(_G["GuildRegistrarButton2"]) then
		_G["GuildRegistrarButton2"]:GetFontString():SetTextColor(1, 1, 1)
	end

	GuildRegistrarPurchaseText:SetTextColor(1, 1, 1)
	AvailableServicesText:SetTextColor(1, 1, 0)
end 

local function LFGuildFrameStyle()
	if(PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.lfguild ~= true) then return end

	PLUGIN:ApplyWindowStyle(LookingForGuildFrame, true)

	for i = 1, #LFGFrameList do
		local check = _G[LFGFrameList[i]]
		if(check) then check:SetStylePanel("Checkbox", true) end
	end
	
	LookingForGuildTankButton.checkButton:SetStylePanel("Checkbox", true)
	LookingForGuildHealerButton.checkButton:SetStylePanel("Checkbox", true)
	LookingForGuildDamagerButton.checkButton:SetStylePanel("Checkbox", true)
	LookingForGuildFrameInset:RemoveTextures(false)
	LookingForGuildBrowseButton_LeftSeparator:Die()
	LookingForGuildRequestButton_RightSeparator:Die()

	PLUGIN:ApplyScrollFrameStyle(LookingForGuildBrowseFrameContainerScrollBar)
	LookingForGuildBrowseButton:SetStylePanel("Button")
	LookingForGuildRequestButton:SetStylePanel("Button")

	PLUGIN:ApplyCloseButtonStyle(LookingForGuildFrameCloseButton)
	LookingForGuildCommentInputFrame:SetStylePanel("Frame", "Default")
	LookingForGuildCommentInputFrame:RemoveTextures(false)

	for u = 1, 5 do
		local J = _G["LookingForGuildBrowseFrameContainerButton"..u]
		local K = _G["LookingForGuildAppsFrameContainerButton"..u]
		J:SetBackdrop(nil)
		K:SetBackdrop(nil)
	end

	for u = 1, 3 do
		local tab = _G["LookingForGuildFrameTab"..u]
		PLUGIN:ApplyTabStyle(tab)
		tab:SetFrameStrata("HIGH")
		tab:SetFrameLevel(99)
	end

	GuildFinderRequestMembershipFrame:RemoveTextures(true)
	GuildFinderRequestMembershipFrame:SetStylePanel("!_Frame", "Transparent", true)
	GuildFinderRequestMembershipFrameAcceptButton:SetStylePanel("Button")
	GuildFinderRequestMembershipFrameCancelButton:SetStylePanel("Button")
	GuildFinderRequestMembershipFrameInputFrame:RemoveTextures()
	GuildFinderRequestMembershipFrameInputFrame:SetStylePanel("!_Frame", "Default")
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle("Blizzard_GuildBankUI",GuildBankStyle)
PLUGIN:SaveBlizzardStyle("Blizzard_GuildUI",GuildFrameStyle)
PLUGIN:SaveBlizzardStyle("Blizzard_GuildControlUI",GuildControlStyle)
PLUGIN:SaveCustomStyle(GuildRegistrarStyle)
PLUGIN:SaveBlizzardStyle("Blizzard_LookingForGuildUI",LFGuildFrameStyle)