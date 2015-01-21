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
--[[ ADDON ]]--
local SV = _G.SVUI;
local L = SV.L;
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
local ceil = math.ceil
--[[ 
########################################################## 
MASSIVE LIST OF LISTS
##########################################################
]]--
local SystemPopList = {
	"StaticPopup1",
	"StaticPopup2",
	"StaticPopup3"
};
local SystemDropDownList = {
	"DropDownList1MenuBackdrop",
	"DropDownList2MenuBackdrop",
	"DropDownList1Backdrop",
	"DropDownList2Backdrop",
};
local SystemFrameList1 = {
	"GameMenuFrame",
	"TicketStatusFrameButton",
	"AutoCompleteBox",
	"ConsolidatedBuffsTooltip",
	"ReadyCheckFrame",
	"StackSplitFrame",
	"QueueStatusFrame",
	"InterfaceOptionsFrame",
	"VideoOptionsFrame",
	"AudioOptionsFrame",
};
local SystemFrameList4 = {
	"Options",
	"Store",
	"SoundOptions", 
	"UIOptions", 
	"Keybindings", 
	"Macros",
	"Ratings",
	"AddOns", 
	"Logout", 
	"Quit", 
	"Continue", 
	"MacOptions",
	"Help",
	"WhatsNew",
	"Addons"
};
local SystemFrameList5 = {
	"GameMenuFrame", 
	"InterfaceOptionsFrame", 
	"AudioOptionsFrame", 
	"VideoOptionsFrame",
};
local SystemFrameList6 = {
	"VideoOptionsFrameOkay", 
	"VideoOptionsFrameCancel", 
	"VideoOptionsFrameDefaults", 
	"VideoOptionsFrameApply", 
	"AudioOptionsFrameOkay", 
	"AudioOptionsFrameCancel", 
	"AudioOptionsFrameDefaults", 
	"InterfaceOptionsFrameDefaults", 
	"InterfaceOptionsFrameOkay", 
	"InterfaceOptionsFrameCancel",
	"ReadyCheckFrameYesButton",
	"ReadyCheckFrameNoButton",
	"StackSplitOkayButton",
	"StackSplitCancelButton",
	"RolePollPopupAcceptButton"
};

local SystemFrameList13 = {
	"VideoOptionsFrameCategoryFrame",
	"VideoOptionsFramePanelContainer",
	"InterfaceOptionsFrameCategories",
	"InterfaceOptionsFramePanelContainer",
	"InterfaceOptionsFrameAddOns",
	"AudioOptionsSoundPanelPlayback",
	"AudioOptionsSoundPanelVolume",
	"AudioOptionsSoundPanelHardware",
	"AudioOptionsVoicePanelTalking",
	"AudioOptionsVoicePanelBinding",
	"AudioOptionsVoicePanelListening",
};
local SystemFrameList14 = {
	"InterfaceOptionsFrameTab1",
	"InterfaceOptionsFrameTab2",
};
local SystemFrameList15 = {
	"ControlsPanelBlockChatChannelInvites",
	"ControlsPanelStickyTargeting",
	"ControlsPanelAutoDismount",
	"ControlsPanelAutoClearAFK",
	"ControlsPanelBlockTrades",
	"ControlsPanelBlockGuildInvites",
	"ControlsPanelLootAtMouse",
	"ControlsPanelAutoLootCorpse",
	"ControlsPanelInteractOnLeftClick",
	"ControlsPanelAutoOpenLootHistory",
	"CombatPanelEnemyCastBarsOnOnlyTargetNameplates",
	"CombatPanelEnemyCastBarsNameplateSpellNames",
	"CombatPanelAttackOnAssist",
	"CombatPanelStopAutoAttack",
	"CombatPanelNameplateClassColors",
	"CombatPanelTargetOfTarget",
	"CombatPanelShowSpellAlerts",
	"CombatPanelReducedLagTolerance",
	"CombatPanelActionButtonUseKeyDown",
	"CombatPanelEnemyCastBarsOnPortrait",
	"CombatPanelEnemyCastBarsOnNameplates",
	"CombatPanelAutoSelfCast",
	"CombatPanelLossOfControl",
	"DisplayPanelShowCloak",
	"DisplayPanelShowHelm",
	"DisplayPanelShowAggroPercentage",
	"DisplayPanelPlayAggroSounds",
	"DisplayPanelDetailedLootInfo",
	"DisplayPanelShowSpellPointsAvg",
	"DisplayPanelemphasizeMySpellEffects",
	"DisplayPanelShowFreeBagSpace",
	"DisplayPanelCinematicSubtitles",
	"DisplayPanelRotateMinimap",
	"DisplayPanelScreenEdgeFlash",
	"DisplayPanelShowAccountAchievments",
	"ObjectivesPanelAutoQuestTracking",
	"ObjectivesPanelAutoQuestProgress",
	"ObjectivesPanelMapQuestDifficulty",
	"ObjectivesPanelAdvancedWorldMap",
	"ObjectivesPanelWatchFrameWidth",
	"SocialPanelProfanityFilter",
	"SocialPanelSpamFilter",
	"SocialPanelChatBubbles",
	"SocialPanelPartyChat",
	"SocialPanelChatHoverDelay",
	"SocialPanelGuildMemberAlert",
	"SocialPanelChatMouseScroll",
	"ActionBarsPanelLockActionBars",
	"ActionBarsPanelSecureAbilityToggle",
	"ActionBarsPanelAlwaysShowActionBars",
	"ActionBarsPanelBottomLeft",
	"ActionBarsPanelBottomRight",
	"ActionBarsPanelRight",
	"ActionBarsPanelRightTwo",
	"NamesPanelMyName",
	"NamesPanelFriendlyPlayerNames",
	"NamesPanelFriendlyPets",
	"NamesPanelFriendlyGuardians",
	"NamesPanelFriendlyTotems",
	"NamesPanelUnitNameplatesFriends",
	"NamesPanelUnitNameplatesFriendlyGuardians",
	"NamesPanelUnitNameplatesFriendlyPets",
	"NamesPanelUnitNameplatesFriendlyTotems",
	"NamesPanelGuilds",
	"NamesPanelGuildTitles",
	"NamesPanelTitles",
	"NamesPanelMinus",
	"NamesPanelNonCombatCreature",
	"NamesPanelEnemyPlayerNames",
	"NamesPanelEnemyPets",
	"NamesPanelEnemyGuardians",
	"NamesPanelEnemyTotems",
	"NamesPanelUnitNameplatesEnemyPets",
	"NamesPanelUnitNameplatesEnemies",
	"NamesPanelUnitNameplatesEnemyGuardians",
	"NamesPanelUnitNameplatesEnemyTotems",
	"NamesPanelUnitNameplatesEnemyMinus",
	"CombatTextPanelTargetDamage",
	"CombatTextPanelPeriodicDamage",
	"CombatTextPanelPetDamage",
	"CombatTextPanelHealing",
	"CombatTextPanelHealingAbsorbTarget",
	"CombatTextPanelHealingAbsorbSelf",
	"CombatTextPanelTargetEffects",
	"CombatTextPanelOtherTargetEffects",
	"CombatTextPanelEnableFCT",
	"CombatTextPanelDodgeParryMiss",
	"CombatTextPanelDamageReduction",
	"CombatTextPanelRepChanges",
	"CombatTextPanelReactiveAbilities",
	"CombatTextPanelFriendlyHealerNames",
	"CombatTextPanelCombatState",
	"CombatTextPanelComboPoints",
	"CombatTextPanelLowManaHealth",
	"CombatTextPanelEnergyGains",
	"CombatTextPanelPeriodicEnergyGains",
	"CombatTextPanelHonorGains",
	"CombatTextPanelAuras",
	"CombatTextPanelPetBattle",
	"BuffsPanelBuffDurations",
	"BuffsPanelDispellableDebuffs",
	"BuffsPanelCastableBuffs",
	"BuffsPanelConsolidateBuffs",
	"BuffsPanelShowAllEnemyDebuffs",
	"CameraPanelFollowTerrain",
	"CameraPanelHeadBob",
	"CameraPanelWaterCollision",
	"CameraPanelSmartPivot",
	"MousePanelInvertMouse",
	"MousePanelClickToMove",
	"MousePanelWoWMouse",
	"HelpPanelShowTutorials",
	"HelpPanelLoadingScreenTips",
	"HelpPanelEnhancedTooltips",
	"HelpPanelBeginnerTooltips",
	"HelpPanelShowLuaErrors",
	"HelpPanelColorblindMode",
	"HelpPanelMovePad",
	"BattlenetPanelOnlineFriends",
	"BattlenetPanelOfflineFriends",
	"BattlenetPanelBroadcasts",
	"BattlenetPanelFriendRequests",
	"BattlenetPanelConversations",
	"BattlenetPanelShowToastWindow",
	"StatusTextPanelPlayer",
	"StatusTextPanelPet",
	"StatusTextPanelParty",
	"StatusTextPanelTarget",
	"StatusTextPanelAlternateResource",
	"StatusTextPanelPercentages",
	"StatusTextPanelXP",
	"UnitFramePanelPartyBackground",
	"UnitFramePanelPartyPets",
	"UnitFramePanelArenaEnemyFrames",
	"UnitFramePanelArenaEnemyCastBar",
	"UnitFramePanelArenaEnemyPets",
	"UnitFramePanelFullSizeFocusFrame",
	"NamesPanelUnitNameplatesNameplateClassColors",
};
local SystemFrameList16 ={
	"ControlsPanelAutoLootKeyDropDown",
	"CombatPanelTOTDropDown",
	"CombatPanelFocusCastKeyDropDown",
	"CombatPanelSelfCastKeyDropDown",
	"CombatPanelLossOfControlFullDropDown",
	"CombatPanelLossOfControlSilenceDropDown",
	"CombatPanelLossOfControlInterruptDropDown",
	"CombatPanelLossOfControlDisarmDropDown",
	"CombatPanelLossOfControlRootDropDown",
	"CombatTextPanelTargetModeDropDown",
	"DisplayPanelAggroWarningDisplay",
	"DisplayPanelWorldPVPObjectiveDisplay",
	"DisplayPanelOutlineDropDown",
	"ObjectivesPanelQuestSorting",
	"SocialPanelChatStyle",
	"SocialPanelWhisperMode",
	"SocialPanelTimestamps",
	"SocialPanelBnWhisperMode",
	"SocialPanelConversationMode",
	"ActionBarsPanelPickupActionKeyDropDown",
	"NamesPanelNPCNamesDropDown",
	"NamesPanelUnitNameplatesMotionDropDown",
	"CombatTextPanelFCTDropDown",
	"CameraPanelStyleDropDown",
	"MousePanelClickMoveStyleDropDown",
	"LanguagesPanelLocaleDropDown",
	"LanguagesPanelAudioLocaleDropDown",
	"StatusTextPanelDisplayDropDown"
};
local SystemFrameList17 = {
	"Advanced_MaxFPSCheckBox",
	"Advanced_MaxFPSBKCheckBox",
	"Advanced_DesktopGamma",
	"Advanced_UseUIScale",
	"AudioOptionsSoundPanelEnableSound",
	"AudioOptionsSoundPanelSoundEffects",
	"AudioOptionsSoundPanelErrorSpeech",
	"AudioOptionsSoundPanelEmoteSounds",
	"AudioOptionsSoundPanelPetSounds",
	"AudioOptionsSoundPanelMusic",
	"AudioOptionsSoundPanelLoopMusic",
	"AudioOptionsSoundPanelAmbientSounds",
	"AudioOptionsSoundPanelSoundInBG",
	"AudioOptionsSoundPanelReverb",
	"AudioOptionsSoundPanelHRTF",
	"AudioOptionsSoundPanelEnableDSPs",
	"AudioOptionsSoundPanelUseHardware",
	"AudioOptionsVoicePanelEnableVoice",
	"AudioOptionsVoicePanelEnableMicrophone",
	"AudioOptionsVoicePanelPushToTalkSound",
	"AudioOptionsVoicePanelDialogVolume",
	"AudioOptionsSoundPanelPetBattleMusic",
	"NetworkOptionsPanelOptimizeSpeed",
	"NetworkOptionsPanelUseIPv6",
	"NetworkOptionsPanelAdvancedCombatLogging"
};
local SystemFrameList18 = {
	"Display_AntiAliasingDropDown",
	"Display_DisplayModeDropDown",
	"Display_ResolutionDropDown",
	"Display_RefreshDropDown",
	"Display_PrimaryMonitorDropDown",
	"Display_MultiSampleDropDown",
	"Display_VerticalSyncDropDown",
	"Graphics_TextureResolutionDropDown",
	"Graphics_FilteringDropDown",
	"Graphics_ProjectedTexturesDropDown",
	"Graphics_ViewDistanceDropDown",
	"Graphics_EnvironmentalDetailDropDown",
	"Graphics_GroundClutterDropDown",
	"Graphics_ShadowsDropDown",
	"Graphics_LiquidDetailDropDown",
	"Graphics_SunshaftsDropDown",
	"Graphics_ParticleDensityDropDown",
	"Graphics_SSAODropDown",
	"Graphics_RefractionDropDown",
	"Advanced_BufferingDropDown",
	"Advanced_LagDropDown",
	"Advanced_HardwareCursorDropDown",
	"Advanced_GraphicsAPIDropDown",
	"AudioOptionsSoundPanelHardwareDropDown",
	"AudioOptionsSoundPanelSoundChannelsDropDown",
	"AudioOptionsVoicePanelInputDeviceDropDown",
	"AudioOptionsVoicePanelChatModeDropDown",
	"AudioOptionsVoicePanelOutputDeviceDropDown",
	"CompactUnitFrameProfilesProfileSelector",
	"CompactUnitFrameProfilesGeneralOptionsFrameHealthTextDropdown",
	"CompactUnitFrameProfilesGeneralOptionsFrameSortByDropdown",
};
local SystemFrameList19 = {
	"RecordLoopbackSoundButton",
	"PlayLoopbackSoundButton",
	"AudioOptionsVoicePanelChatMode1KeyBindingButton",
	"CompactUnitFrameProfilesSaveButton",
	"CompactUnitFrameProfilesDeleteButton",
};
local SystemFrameList20 = {
	"KeepGroupsTogether",
	"DisplayIncomingHeals",
	"DisplayPowerBar",
	"DisplayAggroHighlight",
	"UseClassColors",
	"DisplayPets",
	"DisplayMainTankAndAssist",
	"DisplayBorder",
	"ShowDebuffs",
	"DisplayOnlyDispellableDebuffs",
	"AutoActivate2Players",
	"AutoActivate3Players",
	"AutoActivate5Players",
	"AutoActivate10Players",
	"AutoActivate15Players",
	"AutoActivate25Players",
	"AutoActivate40Players",
	"AutoActivateSpec1",
	"AutoActivateSpec2",
	"AutoActivatePvP",
	"AutoActivatePvE",
};
local SystemFrameList21 = {
	"Graphics_Quality",
	"Advanced_UIScaleSlider",
	"Advanced_MaxFPSSlider",
	"Advanced_MaxFPSBKSlider",
	"AudioOptionsSoundPanelSoundQuality",
	"AudioOptionsSoundPanelMasterVolume",
	"AudioOptionsSoundPanelSoundVolume",
	"AudioOptionsSoundPanelMusicVolume",
	"AudioOptionsSoundPanelAmbienceVolume",
	"AudioOptionsVoicePanelMicrophoneVolume",
	"AudioOptionsVoicePanelSpeakerVolume",
	"AudioOptionsVoicePanelSoundFade",
	"AudioOptionsVoicePanelMusicFade",
	"AudioOptionsVoicePanelAmbienceFade",
	"InterfaceOptionsCombatPanelSpellAlertOpacitySlider",
	"InterfaceOptionsCombatPanelMaxSpellStartRecoveryOffset",
	"InterfaceOptionsBattlenetPanelToastDurationSlider",
	"InterfaceOptionsCameraPanelMaxDistanceSlider",
	"InterfaceOptionsCameraPanelFollowSpeedSlider",
	"InterfaceOptionsMousePanelMouseSensitivitySlider",
	"InterfaceOptionsMousePanelMouseLookSpeedSlider",
	"AddonListScrollFrameScrollBar",
	"OpacityFrameSlider",
};
--[[ 
########################################################## 
HELPER FUNCTIONS
##########################################################
]]--
local _hook_GhostFrameBackdropColor = function(self, r, g, b, a)
	if r ~= 0 or g ~= 0 or b ~= 0 or a ~= 0 then
		self:SetBackdropColor(0,0,0,0)
		self:SetBackdropBorderColor(0,0,0,0)
	end
end
--[[ 
########################################################## 
SYSTEM WIDGET PLUGINRS
##########################################################
]]--
local function SystemPanelQue()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.misc ~= true then return end

	local GhostFrame = _G.GhostFrame;
	local ReadyCheckFrame = _G.ReadyCheckFrame;
	local InterfaceOptionsFrame = _G.InterfaceOptionsFrame;
	local MacOptionsFrame = _G.MacOptionsFrame;
	local GuildInviteFrame = _G.GuildInviteFrame;
	local BattleTagInviteFrame = _G.BattleTagInviteFrame;

	QueueStatusFrame:RemoveTextures()

	for i = 1, #SystemPopList do
		local this = _G[SystemPopList[i]]
		if(this) then
			this:RemoveTextures()
			PLUGIN:ApplyAlertStyle(this)
			this:SetBackdropColor(0.8, 0.2, 0.2)
		end
	end
	for i = 1, #SystemDropDownList do
		local this = _G[SystemDropDownList[i]]
		if(this) then
			this:RemoveTextures()
			this:SetStylePanel("Frame", "Heavy")
		end
	end
	for i = 1, #SystemFrameList1 do
		local this = _G[SystemFrameList1[i]]
		if(this) then
			PLUGIN:ApplyWindowStyle(this)
		end
	end
	
	LFDRoleCheckPopup:RemoveTextures()
	LFDRoleCheckPopup:SetStylePanel("!_Frame")
	LFDRoleCheckPopupAcceptButton:SetStylePanel("Button")
	LFDRoleCheckPopupDeclineButton:SetStylePanel("Button")
	LFDRoleCheckPopupRoleButtonTank.checkButton:SetStylePanel("Checkbox", true)
	LFDRoleCheckPopupRoleButtonDPS.checkButton:SetStylePanel("Checkbox", true)
	LFDRoleCheckPopupRoleButtonHealer.checkButton:SetStylePanel("Checkbox", true)
	LFDRoleCheckPopupRoleButtonTank.checkButton:SetFrameLevel(LFDRoleCheckPopupRoleButtonTank.checkButton:GetFrameLevel() + 1)
	LFDRoleCheckPopupRoleButtonDPS.checkButton:SetFrameLevel(LFDRoleCheckPopupRoleButtonDPS.checkButton:GetFrameLevel() + 1)
	LFDRoleCheckPopupRoleButtonHealer.checkButton:SetFrameLevel(LFDRoleCheckPopupRoleButtonHealer.checkButton:GetFrameLevel() + 1)
	for i = 1, 3 do
		for j = 1, 3 do
			_G["StaticPopup"..i.."Button"..j]:SetStylePanel("Button")
			_G["StaticPopup"..i.."EditBox"]:SetStylePanel("Editbox")
			_G["StaticPopup"..i.."MoneyInputFrameGold"]:SetStylePanel("Editbox")
			_G["StaticPopup"..i.."MoneyInputFrameSilver"]:SetStylePanel("Editbox")
			_G["StaticPopup"..i.."MoneyInputFrameCopper"]:SetStylePanel("Editbox")
			_G["StaticPopup"..i.."EditBox"].Panel:SetPointToScale("TOPLEFT", -2, -4)
			_G["StaticPopup"..i.."EditBox"].Panel:SetPointToScale("BOTTOMRIGHT", 2, 4)
			_G["StaticPopup"..i.."ItemFrameNameFrame"]:Die()
			_G["StaticPopup"..i.."ItemFrame"]:GetNormalTexture():Die()
			_G["StaticPopup"..i.."ItemFrame"]:SetStylePanel("!_Frame", "Default")
			_G["StaticPopup"..i.."ItemFrame"]:SetStylePanel("Button")
			_G["StaticPopup"..i.."ItemFrameIconTexture"]:SetTexCoord(0.1,0.9,0.1,0.9 )
			_G["StaticPopup"..i.."ItemFrameIconTexture"]:SetAllPointsIn()
		end
	end
	local CAPS_TEXT_FONT = LibStub("LibSharedMedia-3.0"):Fetch("font", SV.db.font.caps.file);
  	local caps_fontsize = SV.db.font.caps.size;
	for i = 1, #SystemFrameList4 do
		local this = _G["GameMenuButton"..SystemFrameList4[i]]
		if(this) then
			this:SetStylePanel("Button")
		end
	end
	if IsAddOnLoaded("OptionHouse") then
		GameMenuButtonOptionHouse:SetStylePanel("Button")
	end

	do
		GhostFrame:SetStylePanel("Button")
		GhostFrame:SetBackdropColor(0,0,0,0)
		GhostFrame:SetBackdropBorderColor(0,0,0,0)
		hooksecurefunc(GhostFrame, "SetBackdropColor", _hook_GhostFrameBackdropColor)
		hooksecurefunc(GhostFrame, "SetBackdropBorderColor", _hook_GhostFrameBackdropColor)
		GhostFrame:ClearAllPoints()
		GhostFrame:SetPoint("CENTER", SVUI_SpecialAbility, "CENTER", 0, 0)
		GhostFrameContentsFrame:SetStylePanel("Button")
		GhostFrameContentsFrameIcon:SetTexture(0,0,0,0)
		local x = CreateFrame("Frame", nil, GhostFrame)
		x:SetFrameStrata("MEDIUM")
		x:SetStylePanel("!_Frame", "Default")
		x:SetAllPointsOut(GhostFrameContentsFrameIcon)
		local tex = x:CreateTexture(nil, "OVERLAY")
		tex:SetTexture("Interface\\Icons\\spell_holy_guardianspirit")
		tex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		tex:SetAllPointsIn()
	end
	for i = 1, #SystemFrameList5 do
		local this = _G[SystemFrameList5[i].."Header"]			
		if(this) then
			this:SetTexture(0,0,0,0)
			this:ClearAllPoints()
			if this == _G["GameMenuFrameHeader"] then
				this:SetPoint("TOP", GameMenuFrame, 0, 7)
			else
				this:SetPoint("TOP", SystemFrameList5[i], 0, 0)
			end
		end
	end
	for i = 1, #SystemFrameList6 do
		local this = _G[SystemFrameList6[i]]
		if(this) then
			this:SetStylePanel("Button")
		end
	end
	VideoOptionsFrameCancel:ClearAllPoints()
	VideoOptionsFrameCancel:SetPoint("RIGHT",VideoOptionsFrameApply,"LEFT",-4,0)		 
	VideoOptionsFrameOkay:ClearAllPoints()
	VideoOptionsFrameOkay:SetPoint("RIGHT",VideoOptionsFrameCancel,"LEFT",-4,0)	
	AudioOptionsFrameOkay:ClearAllPoints()
	AudioOptionsFrameOkay:SetPoint("RIGHT",AudioOptionsFrameCancel,"LEFT",-4,0)
	InterfaceOptionsFrameOkay:ClearAllPoints()
	InterfaceOptionsFrameOkay:SetPoint("RIGHT",InterfaceOptionsFrameCancel,"LEFT", -4,0)
	ReadyCheckFrameYesButton:SetParent(ReadyCheckFrame)
	ReadyCheckFrameNoButton:SetParent(ReadyCheckFrame) 
	ReadyCheckFrameYesButton:SetPoint("RIGHT", ReadyCheckFrame, "CENTER", -1, 0)
	ReadyCheckFrameNoButton:SetPoint("LEFT", ReadyCheckFrameYesButton, "RIGHT", 3, 0)
	ReadyCheckFrameText:SetParent(ReadyCheckFrame)	
	ReadyCheckFrameText:ClearAllPoints()
	ReadyCheckFrameText:SetPoint("TOP", 0, -12)
	ReadyCheckListenerFrame:SetAlpha(0)
	ReadyCheckFrame:HookScript("OnShow", function(self) if UnitIsUnit("player", self.initiator) then self:Hide() end end)
	StackSplitFrame:GetRegions():Hide()
	RolePollPopup:SetStylePanel("!_Frame", "Transparent", true)
	InterfaceOptionsFrame:SetClampedToScreen(true)
	InterfaceOptionsFrame:SetMovable(true)
	InterfaceOptionsFrame:EnableMouse(true)
	InterfaceOptionsFrame:RegisterForDrag("LeftButton", "RightButton")
	InterfaceOptionsFrame:SetScript("OnDragStart", function(self) 
		if InCombatLockdown() then return end
		if IsShiftKeyDown() then
			self:StartMoving() 
		end
	end)
	InterfaceOptionsFrame:SetScript("OnDragStop", function(self) 
		self:StopMovingOrSizing()
	end)
	if IsMacClient() then
		MacOptionsFrame:SetStylePanel("!_Frame", "Default")
		MacOptionsFrameHeader:SetTexture(0,0,0,0)
		MacOptionsFrameHeader:ClearAllPoints()
		MacOptionsFrameHeader:SetPoint("TOP", MacOptionsFrame, 0, 0)
		MacOptionsFrameMovieRecording:SetStylePanel("!_Frame", "Default")
		MacOptionsITunesRemote:SetStylePanel("!_Frame", "Default")
		MacOptionsFrameCancel:SetStylePanel("Button")
		MacOptionsFrameOkay:SetStylePanel("Button")
		MacOptionsButtonKeybindings:SetStylePanel("Button")
		MacOptionsFrameDefaults:SetStylePanel("Button")
		MacOptionsButtonCompress:SetStylePanel("Button")
		local tPoint, tRTo, tRP, tX, tY = MacOptionsButtonCompress:GetPoint()
		MacOptionsButtonCompress:SetWidth(136)
		MacOptionsButtonCompress:ClearAllPoints()
		MacOptionsButtonCompress:SetPointToScale(tPoint, tRTo, tRP, 4, tY)
		MacOptionsFrameCancel:SetWidth(96)
		MacOptionsFrameCancel:SetHeight(22)
		tPoint, tRTo, tRP, tX, tY = MacOptionsFrameCancel:GetPoint()
		MacOptionsFrameCancel:ClearAllPoints()
		MacOptionsFrameCancel:SetPointToScale(tPoint, tRTo, tRP, -14, tY)
		MacOptionsFrameOkay:ClearAllPoints()
		MacOptionsFrameOkay:SetWidth(96)
		MacOptionsFrameOkay:SetHeight(22)
		MacOptionsFrameOkay:SetPointToScale("LEFT",MacOptionsFrameCancel, -99,0)
		MacOptionsButtonKeybindings:ClearAllPoints()
		MacOptionsButtonKeybindings:SetWidth(96)
		MacOptionsButtonKeybindings:SetHeight(22)
		MacOptionsButtonKeybindings:SetPointToScale("LEFT",MacOptionsFrameOkay, -99,0)
		MacOptionsFrameDefaults:SetWidth(96)
		MacOptionsFrameDefaults:SetHeight(22)
	end
	OpacityFrame:RemoveTextures()
	OpacityFrame:SetStylePanel("!_Frame", "Transparent", true)

	hooksecurefunc("UIDropDownMenu_InitializeHelper", function(self)
		for i = 1, UIDROPDOWNMENU_MAXLEVELS do
			local name = ("DropDownList%d"):format(i)
			local bg = _G[("%sBackdrop"):format(name)]
			bg:SetStylePanel("Frame", 'Transparent')
			local menu = _G[("%sMenuBackdrop"):format(name)]
			menu:SetStylePanel("Frame", 'Transparent')
		end
	end)

	for i=1, BattleTagInviteFrame:GetNumChildren() do
		local child = select(i, BattleTagInviteFrame:GetChildren())
		if child:GetObjectType() == 'Button' then
			child:SetStylePanel("Button")
		end
	end

	for i = 1, #SystemFrameList13 do
		local frame = _G[SystemFrameList13[i]]
		if(frame) then
			frame:RemoveTextures()
			frame:SetStylePanel("Frame", 'Transparent')
		end
	end

	for i = 1, #SystemFrameList14 do
		local this = _G[SystemFrameList14[i]]
		if(this) then
			this:RemoveTextures()
			PLUGIN:ApplyTabStyle(this)
		end
	end

	InterfaceOptionsFrameTab1:ClearAllPoints()
	InterfaceOptionsFrameTab1:SetPoint("BOTTOMLEFT",InterfaceOptionsFrameCategories,"TOPLEFT",-11,-2)
	VideoOptionsFrameDefaults:ClearAllPoints()
	InterfaceOptionsFrameDefaults:ClearAllPoints()
	InterfaceOptionsFrameCancel:ClearAllPoints()
	VideoOptionsFrameDefaults:SetPoint("TOPLEFT",VideoOptionsFrameCategoryFrame,"BOTTOMLEFT",-1,-5)
	InterfaceOptionsFrameDefaults:SetPoint("TOPLEFT",InterfaceOptionsFrameCategories,"BOTTOMLEFT",-1,-5)
	InterfaceOptionsFrameCancel:SetPoint("TOPRIGHT",InterfaceOptionsFramePanelContainer,"BOTTOMRIGHT",0,-6)
	for i = 1, #SystemFrameList15 do
		local this = _G["InterfaceOptions"..SystemFrameList15[i]]
		if(this) then
			this:SetStylePanel("Checkbox", true)
		end
	end
	for i = 1, #SystemFrameList16 do
		local this = _G["InterfaceOptions"..SystemFrameList16[i]]
		if(this) then
			PLUGIN:ApplyDropdownStyle(this)
		end
	end
	InterfaceOptionsHelpPanelResetTutorials:SetStylePanel("Button")
	for i = 1, #SystemFrameList17 do
		local this = _G[SystemFrameList17[i]]
		if(this) then
			this:SetStylePanel("Checkbox", true)
		end
	end
	for i = 1, #SystemFrameList18 do
		local this = _G[SystemFrameList18[i]]
		if(this) then
			PLUGIN:ApplyDropdownStyle(this, 165)
		end
	end
	for i = 1, #SystemFrameList19 do
		local this = _G[SystemFrameList19[i]]
		if(this) then
			this:SetStylePanel("Button")
		end
	end
	AudioOptionsVoicePanelChatMode1KeyBindingButton:ClearAllPoints()
	AudioOptionsVoicePanelChatMode1KeyBindingButton:SetPointToScale("CENTER", AudioOptionsVoicePanelBinding, "CENTER", 0, -10)
	CompactUnitFrameProfilesRaidStylePartyFrames:SetStylePanel("Checkbox", true)
	CompactUnitFrameProfilesGeneralOptionsFrameResetPositionButton:SetStylePanel("Button")

	for i = 1, #SystemFrameList20 do
		local this = _G["CompactUnitFrameProfilesGeneralOptionsFrame"..SystemFrameList20[i]]
		if(this) then
			this:SetStylePanel("Checkbox", true)
			this:SetFrameLevel(40)
		end
	end

	for i = 1, #SystemFrameList21 do
		local this = _G[SystemFrameList21[i]]
		if(this) then
			PLUGIN:ApplyScrollBarStyle(this)
		end
	end
	Graphics_RightQuality:SetBackdrop(nil)
	Graphics_RightQuality:Die()

	MacOptionsFrame:RemoveTextures()
	MacOptionsFrame:SetStylePanel("!_Frame")
	MacOptionsButtonCompress:SetStylePanel("Button")
	MacOptionsButtonKeybindings:SetStylePanel("Button")
	MacOptionsFrameDefaults:SetStylePanel("Button")
	MacOptionsFrameOkay:SetStylePanel("Button")
	MacOptionsFrameCancel:SetStylePanel("Button")
	MacOptionsFrameMovieRecording:RemoveTextures()
	MacOptionsITunesRemote:RemoveTextures()
	MacOptionsFrameMisc:RemoveTextures()
	PLUGIN:ApplyDropdownStyle(MacOptionsFrameResolutionDropDown)
	PLUGIN:ApplyDropdownStyle(MacOptionsFrameFramerateDropDown)
	PLUGIN:ApplyDropdownStyle(MacOptionsFrameCodecDropDown)
	PLUGIN:ApplyScrollBarStyle(MacOptionsFrameQualitySlider)
	for i = 1, 11 do
		local this = _G["MacOptionsFrameCheckButton"..i]
		if(this) then
			this:SetStylePanel("Checkbox", true)
		end
	end
	MacOptionsButtonKeybindings:ClearAllPoints()
	MacOptionsButtonKeybindings:SetPoint("LEFT", MacOptionsFrameDefaults, "RIGHT", 2, 0)
	MacOptionsFrameOkay:ClearAllPoints()
	MacOptionsFrameOkay:SetPoint("LEFT", MacOptionsButtonKeybindings, "RIGHT", 2, 0)
	MacOptionsFrameCancel:ClearAllPoints()
	MacOptionsFrameCancel:SetPoint("LEFT", MacOptionsFrameOkay, "RIGHT", 2, 0)
	MacOptionsFrameCancel:SetWidth(MacOptionsFrameCancel:GetWidth() - 6)	
	ReportCheatingDialog:RemoveTextures()
	ReportCheatingDialogCommentFrame:RemoveTextures()
	ReportCheatingDialogReportButton:SetStylePanel("Button")
	ReportCheatingDialogCancelButton:SetStylePanel("Button")
	ReportCheatingDialog:SetStylePanel("!_Frame", "Transparent", true)
	ReportCheatingDialogCommentFrameEditBox:SetStylePanel("Editbox")
	ReportPlayerNameDialog:RemoveTextures()
	ReportPlayerNameDialogCommentFrame:RemoveTextures()
	ReportPlayerNameDialogCommentFrameEditBox:SetStylePanel("Editbox")
	ReportPlayerNameDialog:SetStylePanel("!_Frame", "Transparent", true)
	ReportPlayerNameDialogReportButton:SetStylePanel("Button")
	ReportPlayerNameDialogCancelButton:SetStylePanel("Button")


	SideDressUpFrame:RemoveTextures(true)
	SideDressUpFrame:SetSizeToScale(300, 400)
	SideDressUpModel:RemoveTextures(true)
	SideDressUpModel:SetAllPoints(SideDressUpFrame)
	SideDressUpModel:SetStylePanel("!_Frame", "ModelBorder")
	SideDressUpModelResetButton:SetStylePanel("Button")
	SideDressUpModelResetButton:SetPoint("BOTTOM", SideDressUpModel, "BOTTOM", 0, 20)
	PLUGIN:ApplyCloseButtonStyle(SideDressUpModelCloseButton)	
	PLUGIN:ApplyCloseButtonStyle(SideDressUpModelCloseButton)
end
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveCustomStyle(SystemPanelQue)