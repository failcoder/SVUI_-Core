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
local FrameSuffix = {
	"LeftDisabled",
	"MiddleDisabled",
	"RightDisabled",
	"Left",
	"Middle",
	"Right"
};
local FriendsFrameList1 = {
	"ScrollOfResurrectionSelectionFrame",
	"ScrollOfResurrectionSelectionFrameList",
	"FriendsListFrame",
	"FriendsTabHeader",
	"FriendsFrameFriendsScrollFrame",
	"WhoFrameColumnHeader1",
	"WhoFrameColumnHeader2",
	"WhoFrameColumnHeader3",
	"WhoFrameColumnHeader4",
	"ChannelListScrollFrame",
	"ChannelRoster",
	"FriendsFramePendingButton1",
	"FriendsFramePendingButton2",
	"FriendsFramePendingButton3",
	"FriendsFramePendingButton4",
	"ChannelFrameDaughterFrame",
	"AddFriendFrame",
	"AddFriendNoteFrame"
};
-- local FriendsFrameList2 = {
-- 	"FriendsFrameBroadcastInputLeft",
-- 	"FriendsFrameBroadcastInputRight",
-- 	"FriendsFrameBroadcastInputMiddle",
-- 	"ChannelFrameDaughterFrameChannelNameLeft",
-- 	"ChannelFrameDaughterFrameChannelNameRight",
-- 	"ChannelFrameDaughterFrameChannelNameMiddle",
-- 	"ChannelFrameDaughterFrameChannelPasswordLeft",
-- 	"ChannelFrameDaughterFrameChannelPasswordRight",
-- 	"ChannelFrameDaughterFrameChannelPasswordMiddle"
-- };
local FriendsFrameButtons = {
	"FriendsFrameAddFriendButton",
	"FriendsFrameSendMessageButton",
	"WhoFrameWhoButton",
	"WhoFrameAddFriendButton",
	"WhoFrameGroupInviteButton",
	"ChannelFrameNewButton",
	"FriendsFrameIgnorePlayerButton",
	"FriendsFrameUnsquelchButton",
	"FriendsFramePendingButton1AcceptButton",
	"FriendsFramePendingButton1DeclineButton",
	"FriendsFramePendingButton2AcceptButton",
	"FriendsFramePendingButton2DeclineButton",
	"FriendsFramePendingButton3AcceptButton",
	"FriendsFramePendingButton3DeclineButton",
	"FriendsFramePendingButton4AcceptButton",
	"FriendsFramePendingButton4DeclineButton",
	"ChannelFrameDaughterFrameOkayButton",
	"ChannelFrameDaughterFrameCancelButton",
	"AddFriendEntryFrameAcceptButton",
	"AddFriendEntryFrameCancelButton",
	"AddFriendInfoFrameContinueButton",
	"ScrollOfResurrectionSelectionFrameAcceptButton",
	"ScrollOfResurrectionSelectionFrameCancelButton"
};

local function TabCustomHelper(this)
	if not this then return end 
	for _,prop in pairs(FrameSuffix) do 
		local frame = _G[this:GetName()..prop]
		frame:SetTexture(0,0,0,0)
	end 
	this:GetHighlightTexture():SetTexture(0,0,0,0)
	this.backdrop = CreateFrame("Frame", nil, this)
	this.backdrop:SetStylePanel("!_Frame", "Default")
	this.backdrop:SetFrameLevel(this:GetFrameLevel()-1)
	this.backdrop:SetPointToScale("TOPLEFT", 3, -8)
	this.backdrop:SetPointToScale("BOTTOMRIGHT", -6, 0)
end 

local function ChannelList_OnUpdate()
	for i = 1, MAX_DISPLAY_CHANNEL_BUTTONS do 
		local btn = _G["ChannelButton"..i]
		if btn then
			btn:RemoveTextures()
			btn:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight")
			_G["ChannelButton"..i.."Text"]:SetFontObject(SVUI_Font_Default)
		end 
	end 
end 
--[[ 
########################################################## 
FRIENDSFRAME PLUGINR
##########################################################
]]--FriendsFrameBattlenetFrameScrollFrame
local function FriendsFrameStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.friends ~= true then
		 return 
	end

	PLUGIN:ApplyWindowStyle(FriendsFrame)

	PLUGIN:ApplyScrollFrameStyle(FriendsFrameFriendsScrollFrameScrollBar, 5)
	PLUGIN:ApplyScrollFrameStyle(WhoListScrollFrameScrollBar, 5)
	PLUGIN:ApplyScrollFrameStyle(ChannelRosterScrollFrameScrollBar, 5)
	PLUGIN:ApplyScrollFrameStyle(FriendsFriendsScrollFrameScrollBar)
	FriendsFrameInset:RemoveTextures()
	WhoFrameListInset:RemoveTextures()
	WhoFrameEditBoxInset:RemoveTextures()
	PLUGIN:ApplyEditBoxStyle(WhoFrameEditBoxInset)
	ChannelFrameRightInset:RemoveTextures()
	ChannelFrameLeftInset:RemoveTextures()
	ChannelFrameRightInset:SetStylePanel("!_Frame", "ModelBorder")
	ChannelFrameLeftInset:SetStylePanel("!_Frame", "ModelBorder")
	LFRQueueFrameListInset:RemoveTextures()
	LFRQueueFrameRoleInset:RemoveTextures()
	LFRQueueFrameCommentInset:RemoveTextures()
	LFRQueueFrameListInset:SetStylePanel("!_Frame", "ModelBorder")
	FriendsFrameInset:SetStylePanel("!_Frame", "ModelBorder")
	FriendsFrameFriendsScrollFrame:SetStylePanel("!_Frame", "Model")
	WhoFrameListInset:SetStylePanel("!_Frame", "ModelBorder")
	RaidFrame:SetStylePanel("!_Frame", "ModelBorder")

	for c, e in pairs(FriendsFrameButtons)do
		 _G[e]:SetStylePanel("Button")
	end 

	-- for c, texture in pairs(FriendsFrameList2)do
	-- 	 _G[texture]:Die()
	-- end 

	for c, V in pairs(FriendsFrameList1)do
		 _G[V]:RemoveTextures()
	end 

	for u = 1, FriendsFrame:GetNumRegions()do 
		local a1 = select(u, FriendsFrame:GetRegions())
		if a1:GetObjectType() == "Texture"then
			a1:SetTexture(0,0,0,0)
			a1:SetAlpha(0)
		end 
	end 
	
	FriendsFrameStatusDropDown:SetPoint('TOPLEFT', FriendsTabHeader, 'TOPLEFT', 0, -27)
	PLUGIN:ApplyDropdownStyle(FriendsFrameStatusDropDown, 70)
	FriendsFrameBattlenetFrame:RemoveTextures()
	FriendsFrameBattlenetFrame:SetHeight(22)
	FriendsFrameBattlenetFrame:SetPoint('TOPLEFT', FriendsFrameStatusDropDown, 'TOPRIGHT', 0, -1)
	FriendsFrameBattlenetFrame:SetStylePanel("!_Frame", "Inset")
	FriendsFrameBattlenetFrame:SetBackdropColor(0,0,0,0.8)
	
	-- FriendsFrameBattlenetFrame.BroadcastButton:GetNormalTexture():SetTexCoord(.28, .72, .28, .72)
	-- FriendsFrameBattlenetFrame.BroadcastButton:GetPushedTexture():SetTexCoord(.28, .72, .28, .72)
	-- FriendsFrameBattlenetFrame.BroadcastButton:GetHighlightTexture():SetTexCoord(.28, .72, .28, .72)
	FriendsFrameBattlenetFrame.BroadcastButton:RemoveTextures()
	FriendsFrameBattlenetFrame.BroadcastButton:SetSize(22,22)
	FriendsFrameBattlenetFrame.BroadcastButton:SetPoint('TOPLEFT', FriendsFrameBattlenetFrame, 'TOPRIGHT', 8, 0)
	FriendsFrameBattlenetFrame.BroadcastButton:SetStylePanel("Button")
	FriendsFrameBattlenetFrame.BroadcastButton:SetBackdropColor(0.4,0.4,0.4)
	FriendsFrameBattlenetFrame.BroadcastButton:SetNormalTexture([[Interface\FriendsFrame\UI-Toast-BroadcastIcon]])
	FriendsFrameBattlenetFrame.BroadcastButton:SetPushedTexture([[Interface\FriendsFrame\UI-Toast-BroadcastIcon]])
	FriendsFrameBattlenetFrame.BroadcastButton:SetScript('OnClick', function()
		SV:StaticPopup_Show("SET_BN_BROADCAST")
	end)
	FriendsFrameBattlenetFrame.Tag:SetFontObject(SVUI_Font_Narrator)
	AddFriendNameEditBox:SetStylePanel("Editbox")
	AddFriendFrame:SetStylePanel("!_Frame", "Transparent", true)
	ScrollOfResurrectionSelectionFrame:SetStylePanel("!_Frame", 'Transparent')
	ScrollOfResurrectionSelectionFrameList:SetStylePanel("!_Frame", 'Default')
	PLUGIN:ApplyScrollFrameStyle(ScrollOfResurrectionSelectionFrameListScrollFrameScrollBar, 4)
	ScrollOfResurrectionSelectionFrameTargetEditBox:SetStylePanel("Editbox")
	FriendsFrameBroadcastInput:SetStylePanel("Frame", "Default")
	ChannelFrameDaughterFrameChannelName:SetStylePanel("Frame", "Default")
	ChannelFrameDaughterFrameChannelPassword:SetStylePanel("Frame", "Default")
	
	ChannelFrame:HookScript("OnShow", function()
		ChannelRosterScrollFrame:RemoveTextures()
	end)

	hooksecurefunc("FriendsFrame_OnEvent", function()
		ChannelRosterScrollFrame:RemoveTextures()
	end)

	WhoFrame:HookScript("OnShow", function()
		ChannelRosterScrollFrame:RemoveTextures()
	end)

	hooksecurefunc("FriendsFrame_OnEvent", function()
		WhoListScrollFrame:RemoveTextures()
	end)

	ChannelFrameDaughterFrame:SetStylePanel("Frame", 'Inset')
	PLUGIN:ApplyCloseButtonStyle(ChannelFrameDaughterFrameDetailCloseButton, ChannelFrameDaughterFrame)
	PLUGIN:ApplyCloseButtonStyle(FriendsFrameCloseButton, FriendsFrame.Panel)
	PLUGIN:ApplyDropdownStyle(WhoFrameDropDown, 150)

	for i = 1, 4 do
		 PLUGIN:ApplyTabStyle(_G["FriendsFrameTab"..i])
	end 

	for i = 1, 3 do
		 TabCustomHelper(_G["FriendsTabHeaderTab"..i])
	end 

	hooksecurefunc("ChannelList_Update", ChannelList_OnUpdate)
	FriendsFriendsFrame:SetStylePanel("Frame", 'Inset')

	_G["FriendsFriendsFrame"]:RemoveTextures()
	_G["FriendsFriendsList"]:RemoveTextures()
	_G["FriendsFriendsNoteFrame"]:RemoveTextures()

	_G["FriendsFriendsSendRequestButton"]:SetStylePanel("Button")
	_G["FriendsFriendsCloseButton"]:SetStylePanel("Button")

	FriendsFriendsList:SetStylePanel("Editbox")
	FriendsFriendsNoteFrame:SetStylePanel("Editbox")
	PLUGIN:ApplyDropdownStyle(FriendsFriendsFrameDropDown, 150)
	BNConversationInviteDialog:RemoveTextures()
	BNConversationInviteDialog:SetStylePanel("Frame", 'Transparent')
	BNConversationInviteDialogList:RemoveTextures()
	BNConversationInviteDialogList:SetStylePanel("!_Frame", 'Default')
	BNConversationInviteDialogInviteButton:SetStylePanel("Button")
	BNConversationInviteDialogCancelButton:SetStylePanel("Button")
	for i = 1, BN_CONVERSATION_INVITE_NUM_DISPLAYED do
		 _G["BNConversationInviteDialogListFriend"..i].checkButton:SetStylePanel("Checkbox", true)
	end 
	FriendsTabHeaderSoRButton:SetStylePanel("!_Frame", 'Default')
	FriendsTabHeaderSoRButton:SetStylePanel("Button")
	FriendsTabHeaderSoRButtonIcon:SetDrawLayer('OVERLAY')
	FriendsTabHeaderSoRButtonIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	FriendsTabHeaderSoRButtonIcon:SetAllPointsIn()
	FriendsTabHeaderSoRButton:SetPointToScale('TOPRIGHT', FriendsTabHeader, 'TOPRIGHT', -8, -56)
	FriendsTabHeaderRecruitAFriendButton:SetStylePanel("!_Frame", 'Default')
	FriendsTabHeaderRecruitAFriendButton:SetStylePanel("Button")
	FriendsTabHeaderRecruitAFriendButtonIcon:SetDrawLayer('OVERLAY')
	FriendsTabHeaderRecruitAFriendButtonIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	FriendsTabHeaderRecruitAFriendButtonIcon:SetAllPointsIn()
	
	FriendsFrameIgnoreScrollFrame:SetStylePanel("!_Frame", "ModelBorder")
	PLUGIN:ApplyScrollFrameStyle(FriendsFrameIgnoreScrollFrameScrollBar, 4)
	FriendsFramePendingScrollFrame:SetStylePanel("!_Frame", "Inset")
	PLUGIN:ApplyScrollFrameStyle(FriendsFramePendingScrollFrameScrollBar, 4)
	IgnoreListFrame:RemoveTextures()
	PendingListFrame:RemoveTextures()
	ScrollOfResurrectionFrame:RemoveTextures()
	ScrollOfResurrectionFrameAcceptButton:SetStylePanel("Button")
	ScrollOfResurrectionFrameCancelButton:SetStylePanel("Button")
	ScrollOfResurrectionFrameTargetEditBoxLeft:SetTexture(0,0,0,0)
	ScrollOfResurrectionFrameTargetEditBoxMiddle:SetTexture(0,0,0,0)
	ScrollOfResurrectionFrameTargetEditBoxRight:SetTexture(0,0,0,0)
	ScrollOfResurrectionFrameNoteFrame:RemoveTextures()
	ScrollOfResurrectionFrameNoteFrame:SetStylePanel("!_Frame")
	ScrollOfResurrectionFrameTargetEditBox:SetStylePanel("!_Frame")
	ScrollOfResurrectionFrame:SetStylePanel("!_Frame", 'Transparent')
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveCustomStyle(FriendsFrameStyle)