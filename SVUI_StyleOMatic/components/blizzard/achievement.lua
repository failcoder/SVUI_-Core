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
local unpack        = _G.unpack;
local select        = _G.select;
local assert        = _G.assert;
local type          = _G.type;
local error         = _G.error;
local pcall         = _G.pcall;
local print         = _G.print;
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
local AchievementFrameList = {
	"AchievementFrame", 
	"AchievementFrameCategories", 
	"AchievementFrameSummary", 
	"AchievementFrameHeader", 
	"AchievementFrameSummaryCategoriesHeader", 
	"AchievementFrameSummaryAchievementsHeader", 
	"AchievementFrameStatsBG", 
	"AchievementFrameAchievements", 
	"AchievementFrameComparison", 
	"AchievementFrameComparisonHeader", 
	"AchievementFrameComparisonSummaryPlayer", 
	"AchievementFrameComparisonSummaryFriend"
}

local AchievementTextureList = {
	"AchievementFrameStats", 
	"AchievementFrameSummary", 
	"AchievementFrameAchievements", 
	"AchievementFrameComparison"
}

local AchievementItemButtons = {
	"AchievementFrameAchievementsContainerButton1",
	"AchievementFrameAchievementsContainerButton2",
	"AchievementFrameAchievementsContainerButton3",
	"AchievementFrameAchievementsContainerButton4",
	"AchievementFrameAchievementsContainerButton5",
	"AchievementFrameAchievementsContainerButton6",
	"AchievementFrameAchievementsContainerButton7",
}

local _hook_DescriptionColor = function(self, r, g, b)
	if(r ~= 0.6 or g ~= 0.6 or b ~= 0.6) then 
		self:SetTextColor(0.6, 0.6, 0.6)
	end 
end

local _hook_HiddenDescriptionColor = function(self, r, g, b)
	if(r ~= 1 or g ~= 1 or b ~= 1) then 
		self:SetTextColor(1, 1, 1)
	end 
end

local _hook_TrackingPoint = function(self, anchor, parent, relative, x, y)
	local actual = self.ListParent
	if(anchor ~= "BOTTOMLEFT" or parent ~= actual or relative ~= "BOTTOMLEFT" or x ~= 5 or y ~= 5) then 
		self:ClearAllPoints()
		self:SetPointToScale("BOTTOMLEFT", actual, "BOTTOMLEFT", 5, 5)
	end 
end

local _hook_AchievementsUpdate = function()
	for i = 1, ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do
		local globalName = ("AchievementFrameSummaryAchievement%d"):format(i)
		local summary = _G[globalName]
		if(summary) then
			summary:RemoveTextures()
			summary:SetStylePanel("Button")

			local highlight = _G[("%sHighlight"):format(globalName)]
			local desc = _G[("%sDescription"):format(globalName)]
			local icon = _G[("%sIcon"):format(globalName)]
			local iconbling = _G[("%sIconBling"):format(globalName)]
			local iconover = _G[("%sIconOverlay"):format(globalName)]
			local icontex = _G[("%sIconTexture"):format(globalName)]

			if(highlight) then highlight:Die() end
			if(desc) then desc:SetTextColor(0.6, 0.6, 0.6) end
			if(iconbling) then iconbling:Die() end
			if(iconover) then iconover:Die() end
			if(icontex) then 
				icontex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				icontex:SetAllPointsIn()
			end
			if(icon and not icon.Panel) then 
				icon:SetStylePanel("!_Frame", "Slot")
				icon:SetHeightToScale(icon:GetHeight() - 14)
				icon:SetWidthToScale(icon:GetWidth() - 14)
				icon:ClearAllPoints()
				icon:SetPointToScale("LEFT", 6, 0)
			end

			if summary.accountWide then 
				summary:SetBackdropBorderColor(ACHIEVEMENTUI_BLUEBORDER_R, ACHIEVEMENTUI_BLUEBORDER_G, ACHIEVEMENTUI_BLUEBORDER_B)
			else 
				summary:SetBackdropBorderColor(0,0,0,1)
			end
		end
	end
end

local function BarStyleHelper(bar)
	bar:RemoveTextures()
	bar:SetStatusBarTexture(SV.Media.bar.default)
	bar:SetStatusBarColor(4/255, 179/255, 30/255)
	bar:SetStylePanel("Frame", "Default")
	if _G[bar:GetName().."Title"]then 
		_G[bar:GetName().."Title"]:SetPoint("LEFT", 4, 0)
	end 
	if _G[bar:GetName().."Label"]then 
		_G[bar:GetName().."Label"]:SetPoint("LEFT", 4, 0)
	end 
	if _G[bar:GetName().."Text"]then 
		_G[bar:GetName().."Text"]:SetPoint("RIGHT", -4, 0)
	end 
end 
--[[ 
########################################################## 
ACHIEVEMENTFRAME PLUGINR
##########################################################
]]--
local function AchievementStyle()
	if PLUGIN.db.blizzard.enable  ~= true or PLUGIN.db.blizzard.achievement  ~= true then 
		return 
	end

	AchievementFrameHeader:EnableMouse(false)

	for _, gName in pairs(AchievementFrameList) do 
		local frame = _G[gName]
		if(frame) then
			frame:RemoveTextures(true)
		end
	end
	
	for _, gName in pairs(AchievementTextureList) do
		local frame = _G[gName]
		if(frame) then
			local count = frame:GetNumChildren()
			for i = 1, count do 
				local childFrame = select(i, frame:GetChildren())
				if(childFrame and not childFrame:GetName()) then 
					childFrame:SetBackdrop(nil)
				end 
			end
		end
	end 

	PLUGIN:ApplyWindowStyle(AchievementFrame)

	AchievementFrameSummaryAchievements:RemoveTextures(true)
	AchievementFrameSummaryAchievements:SetStylePanel("Frame", 'Inset')
	AchievementFrameHeaderTitle:ClearAllPoints()
	AchievementFrameHeaderTitle:SetPointToScale("TOPLEFT", AchievementFrame.Panel, "TOPLEFT", -30, -8)
	AchievementFrameHeaderPoints:ClearAllPoints()
	AchievementFrameHeaderPoints:SetPointToScale("LEFT", AchievementFrameHeaderTitle, "RIGHT", 2, 0)
	AchievementFrameCategoriesContainer:SetStylePanel("Frame", "Inset", true, 2, -2, 2)
	AchievementFrameAchievementsContainer:SetStylePanel("Frame", "Default")
	AchievementFrameAchievementsContainer.Panel:SetPointToScale("TOPLEFT", 0, 2)
	AchievementFrameAchievementsContainer.Panel:SetPointToScale("BOTTOMRIGHT", -3, -3)
	PLUGIN:ApplyCloseButtonStyle(AchievementFrameCloseButton, AchievementFrame.Panel)
	PLUGIN:ApplyDropdownStyle(AchievementFrameFilterDropDown)
	AchievementFrameFilterDropDown:SetPointToScale("TOPRIGHT", AchievementFrame, "TOPRIGHT", -44, 5)

	PLUGIN:ApplyScrollFrameStyle(AchievementFrameCategoriesContainerScrollBar, 5)
	PLUGIN:ApplyScrollFrameStyle(AchievementFrameAchievementsContainerScrollBar, 5)
	PLUGIN:ApplyScrollFrameStyle(AchievementFrameStatsContainerScrollBar, 5)
	PLUGIN:ApplyScrollFrameStyle(AchievementFrameComparisonContainerScrollBar, 5)
	PLUGIN:ApplyScrollFrameStyle(AchievementFrameComparisonStatsContainerScrollBar, 5)

	for i = 1, 3 do
		local tab = _G["AchievementFrameTab"..i]
		if(tab) then
			PLUGIN:ApplyTabStyle(tab)
			tab:SetFrameLevel(tab:GetFrameLevel() + 2)
		end
	end 

	BarStyleHelper(AchievementFrameSummaryCategoriesStatusBar)
	BarStyleHelper(AchievementFrameComparisonSummaryPlayerStatusBar)
	BarStyleHelper(AchievementFrameComparisonSummaryFriendStatusBar)

	AchievementFrameComparisonSummaryFriendStatusBar.text:ClearAllPoints()
	AchievementFrameComparisonSummaryFriendStatusBar.text:SetPoint("CENTER")
	AchievementFrameComparisonHeader:SetPointToScale("BOTTOMRIGHT", AchievementFrameComparison, "TOPRIGHT", 45, -20)

	for i = 1, 12 do
		local categoryName = ("AchievementFrameSummaryCategoriesCategory%d"):format(i)
		if(_G[categoryName]) then
			if _G[categoryName.."Button"] then
				_G[categoryName.."Button"]:RemoveTextures()
			end
			local hlName = categoryName.."ButtonHighlight"
			local highlight = _G[hlName]
			if(highlight) then
				highlight:RemoveTextures()
				_G[hlName.."Middle"]:SetTexture(1, 1, 1, 0.3)
				_G[hlName.."Middle"]:SetAllPoints(categoryName)
			end
			BarStyleHelper(_G[categoryName])
		end
	end

	AchievementFrame:HookScript("OnShow", function(self)
		if(self.containerStyled) then return end 
		for i = 1, 20 do
			PLUGIN:ApplyItemButtonStyle(_G["AchievementFrameCategoriesContainerButton"..i])
		end 
		self.containerStyled = true 
	end)

	hooksecurefunc("AchievementButton_DisplayAchievement", function(self)
		if(self.accountWide and self.bg3) then 
			self.bg3:SetTexture(ACHIEVEMENTUI_BLUEBORDER_R, ACHIEVEMENTUI_BLUEBORDER_G, ACHIEVEMENTUI_BLUEBORDER_B)
		elseif self.bg3 then 
			self.bg3:SetTexture(0,0,0,1)
		end 
	end)

	hooksecurefunc("AchievementFrameSummary_UpdateAchievements", _hook_AchievementsUpdate)

	for i = 1, #AchievementItemButtons do
		local gName = AchievementItemButtons[i]
		local button = _G[gName]

		if(button) then
			local hl = _G[gName.."Highlight"]
			local desc = _G[gName.."Description"]
			local hdesc = _G[gName.."HiddenDescription"]
			local icon = _G[gName.."Icon"]
			local track = _G[gName.."Tracked"]

			if(hl) then hl:Die() end

			button:RemoveTextures(true)

			button.bg1 = button:CreateTexture(nil, "BACKGROUND", nil, 4)
			button.bg1:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
			button.bg1:SetVertexColor(unpack(SV.Media.color.default))
			button.bg1:SetPointToScale("TOPLEFT", 1, -1)
			button.bg1:SetPointToScale("BOTTOMRIGHT", -1, 1)

			button.bg3 = button:CreateTexture(nil, "BACKGROUND", nil, 2)
			button.bg3:SetTexture(unpack(SV.Media.color.default))
			button.bg3:SetAllPointsOut(1)

			if(desc) then
				desc:SetTextColor(0.6, 0.6, 0.6)
				hooksecurefunc(desc, "SetTextColor", _hook_DescriptionColor)
			end

			if(hdesc) then
				hdesc:SetTextColor(1, 1, 1)
				hooksecurefunc(hdesc, "SetTextColor", _hook_HiddenDescriptionColor)
			end

			if(icon) then
				local bling = _G[gName.."IconBling"]
				local over = _G[gName.."IconOverlay"]
				local tex = _G[gName.."IconTexture"]
				if(bling) then bling:Die() end
				if(over) then over:Die() end
				if(tex) then 
					tex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					tex:SetAllPointsIn()
				end

				icon:SetStylePanel("!_Frame", "Default")
				icon:SetHeightToScale(icon:GetHeight()-14)
				icon:SetWidthToScale(icon:GetWidth()-14)
				icon:ClearAllPoints()
				icon:SetPointToScale("LEFT", 6, 0)
			end
			
			if(track) then
				track:ClearAllPoints()
				track:SetPointToScale("BOTTOMLEFT", 1, 1)
				track:RemoveTextures()
				track:SetStylePanel("Checkbox", true)
				track.ListParent = button
			end
		end
	end

	local u = {"Player", "Friend"}
	for c, v in pairs(u) do 
		for f = 1, 9 do 
			local d = "AchievementFrameComparisonContainerButton"..f..v;
			_G[d]:RemoveTextures()
			_G[d.."Background"]:Die()
			if _G[d.."Description"]then 
				_G[d.."Description"]:SetTextColor(0.6, 0.6, 0.6)
				hooksecurefunc(_G[d.."Description"], "SetTextColor", _hook_DescriptionColor)
			end 
			_G[d].bg1 = _G[d]:CreateTexture(nil, "BACKGROUND")
			_G[d].bg1:SetDrawLayer("BACKGROUND", 4)
			_G[d].bg1:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
			_G[d].bg1:SetVertexColor(unpack(SV.Media.color.default))
			_G[d].bg1:SetPointToScale("TOPLEFT", 4, -4)
			_G[d].bg1:SetPointToScale("BOTTOMRIGHT", -4, 4)
			_G[d].bg2 = _G[d]:CreateTexture(nil, "BACKGROUND")
			_G[d].bg2:SetDrawLayer("BACKGROUND", 3)
			_G[d].bg2:SetTexture(0, 0, 0)
			_G[d].bg2:SetPointToScale("TOPLEFT", 3, -3)
			_G[d].bg2:SetPointToScale("BOTTOMRIGHT", -3, 3)
			_G[d].bg3 = _G[d]:CreateTexture(nil, "BACKGROUND")
			_G[d].bg3:SetDrawLayer("BACKGROUND", 2)
			_G[d].bg3:SetTexture(0,0,0,1)
			_G[d].bg3:SetPointToScale("TOPLEFT", 2, -2)
			_G[d].bg3:SetPointToScale("BOTTOMRIGHT", -2, 2)
			_G[d].bg4 = _G[d]:CreateTexture(nil, "BACKGROUND")
			_G[d].bg4:SetDrawLayer("BACKGROUND", 1)
			_G[d].bg4:SetTexture(0, 0, 0)
			_G[d].bg4:SetPointToScale("TOPLEFT", 1, -1)
			_G[d].bg4:SetPointToScale("BOTTOMRIGHT", -1, 1)

			if v == "Friend"then 
				_G[d.."Shield"]:SetPointToScale("TOPRIGHT", _G["AchievementFrameComparisonContainerButton"..f.."Friend"], "TOPRIGHT", -20, -3)
			end 

			_G[d.."IconBling"]:Die()
			_G[d.."IconOverlay"]:Die()
			_G[d.."Icon"]:SetStylePanel("!_Frame", "Default")
			_G[d.."Icon"]:SetHeightToScale(_G[d.."Icon"]:GetHeight()-14)
			_G[d.."Icon"]:SetWidthToScale(_G[d.."Icon"]:GetWidth()-14)
			_G[d.."Icon"]:ClearAllPoints()
			_G[d.."Icon"]:SetPointToScale("LEFT", 6, 0)
			_G[d.."IconTexture"]:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			_G[d.."IconTexture"]:SetAllPointsIn()
		end 
	end

	hooksecurefunc("AchievementFrameComparison_DisplayAchievement", function(i)
		local w = i.player;
		local x = i.friend 
		w.titleBar:Die()
		x.titleBar:Die()
		if not w.bg3 or not x.bg3 then 
			return 
		end 
		if w.accountWide then 
			w.bg3:SetTexture(ACHIEVEMENTUI_BLUEBORDER_R, ACHIEVEMENTUI_BLUEBORDER_G, ACHIEVEMENTUI_BLUEBORDER_B)
		else 
			w.bg3:SetTexture(0,0,0,1)
		end 

		if x.accountWide then 
			x.bg3:SetTexture(ACHIEVEMENTUI_BLUEBORDER_R, ACHIEVEMENTUI_BLUEBORDER_G, ACHIEVEMENTUI_BLUEBORDER_B)
		else 
			x.bg3:SetTexture(0,0,0,1)
		end 
	end)

	for f = 1, 20 do
		local d = _G["AchievementFrameStatsContainerButton"..f]
		_G["AchievementFrameStatsContainerButton"..f.."BG"]:SetTexture(1, 1, 1, 0.2)
		_G["AchievementFrameStatsContainerButton"..f.."HeaderLeft"]:Die()
		_G["AchievementFrameStatsContainerButton"..f.."HeaderRight"]:Die()
		_G["AchievementFrameStatsContainerButton"..f.."HeaderMiddle"]:Die()
		local d = "AchievementFrameComparisonStatsContainerButton"..f;
		_G[d]:RemoveTextures()
		_G[d]:SetStylePanel("Frame", "Default")
		_G[d.."BG"]:SetTexture(1, 1, 1, 0.2)
		_G[d.."HeaderLeft"]:Die()
		_G[d.."HeaderRight"]:Die()
		_G[d.."HeaderMiddle"]:Die()
	end

	hooksecurefunc("AchievementButton_GetProgressBar", function(y)
		local d = _G["AchievementFrameProgressBar"..y]
		if d then 
			if not d.styled then 
				d:RemoveTextures()
				d:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
				d:SetStatusBarColor(4/255, 179/255, 30/255)
				d:SetFrameLevel(d:GetFrameLevel()+3)
				d:SetHeightToScale(d:GetHeight()-2)
				d.bg1 = d:CreateTexture(nil, "BACKGROUND")
				d.bg1:SetDrawLayer("BACKGROUND", 4)
				d.bg1:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
				d.bg1:SetVertexColor(unpack(SV.Media.color.default))
				d.bg1:SetAllPoints()
				d.bg3 = d:CreateTexture(nil, "BACKGROUND")
				d.bg3:SetDrawLayer("BACKGROUND", 2)
				d.bg3:SetTexture(0,0,0,1)
				d.bg3:SetPointToScale("TOPLEFT", -1, 1)
				d.bg3:SetPointToScale("BOTTOMRIGHT", 1, -1);
				d.text:ClearAllPoints()
				d.text:SetPoint("CENTER", d, "CENTER", 0, -1)
				d.text:SetJustifyH("CENTER")
				if y>1 then 
					d:ClearAllPoints()
					d:SetPointToScale("TOP", _G["AchievementFrameProgressBar"..y-1], "BOTTOM", 0, -5)
					hooksecurefunc(d, "SetPoint", function(k, p, q, r, s, t, z)
						if not z then 
							k:ClearAllPoints()k:SetPoint("TOP", _G["AchievementFrameProgressBar"..y-1], "BOTTOM", 0, -5, true)
						end 
					end)
				end 
				d.styled = true 
			end 
		end 
	end)

	hooksecurefunc("AchievementObjectives_DisplayCriteria", function(A, B)
		local C = GetAchievementNumCriteria(B)
		local D, E = 0, 0;
		for f = 1, C do 
			local F, G, H, I, J, K, L, M, N = GetAchievementCriteriaInfo(B, f)
			if G == CRITERIA_TYPE_ACHIEVEMENT and M then 
				E = E+1;
				local O = AchievementButton_GetMeta(E)
				if A.completed and H then 
					O.label:SetShadowOffset(0, 0)
					O.label:SetTextColor(1, 1, 1, 1)
				elseif H then 
					O.label:SetShadowOffset(1, -1)
					O.label:SetTextColor(0, 1, 0, 1)
				else 
					O.label:SetShadowOffset(1, -1)
					O.label:SetTextColor(.6, .6, .6, 1)
				end 
			elseif G  ~= 1 then 
				D = D+1;
				local P = AchievementButton_GetCriteria(D)
				if A.completed and H then 
					P.name:SetTextColor(1, 1, 1, 1)
					P.name:SetShadowOffset(0, 0)
				elseif H then 
					P.name:SetTextColor(0, 1, 0, 1)
					P.name:SetShadowOffset(1, -1)
				else 
					P.name:SetTextColor(.6, .6, .6, 1)
					P.name:SetShadowOffset(1, -1)
				end 
			end 
		end 
	end)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle("Blizzard_AchievementUI", AchievementStyle)