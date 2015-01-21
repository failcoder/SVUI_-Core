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
local type 		= _G.type;
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
local function cleanT(a,b)
	for c=1,a:GetNumRegions()do 
		local d=select(c,a:GetRegions())
		if d and d:GetObjectType()=="Texture"then 
			local n=d:GetName();
			if n=='TabardFrameEmblemTopRight' or n=='TabardFrameEmblemTopLeft' or n=='TabardFrameEmblemBottomRight' or n=='TabardFrameEmblemBottomLeft' then return end 
			if b and type(b)=='boolean'then 
				d:Die()
			elseif d:GetDrawLayer()==b then 
				d:SetTexture(0,0,0,0)
			elseif b and type(b)=='string'and d:GetTexture()~=b then 
				d:SetTexture(0,0,0,0)
			else 
				d:SetTexture(0,0,0,0)
			end 
		end 
	end 
end
--[[ 
########################################################## 
TABARDFRAME PLUGINR
##########################################################
]]--
local function TabardFrameStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.tabard ~= true then
		 return 
	end 
	cleanT(TabardFrame, true)
	TabardFrame:SetStylePanel("Frame", "Composite2", false)
	TabardModel:SetStylePanel("!_Frame", "Transparent")
	TabardFrameCancelButton:SetStylePanel("Button")
	TabardFrameAcceptButton:SetStylePanel("Button")
	PLUGIN:ApplyCloseButtonStyle(TabardFrameCloseButton)
	TabardFrameCostFrame:RemoveTextures()
	TabardFrameCustomizationFrame:RemoveTextures()
	TabardFrameInset:Die()
	TabardFrameMoneyInset:Die()
	TabardFrameMoneyBg:RemoveTextures()
	for b = 1, 5 do 
		local c = "TabardFrameCustomization"..b;_G[c]:RemoveTextures()
		PLUGIN:ApplyPaginationStyle(_G[c.."LeftButton"])
		PLUGIN:ApplyPaginationStyle(_G[c.."RightButton"])
		if b > 1 then
			 _G[c]:ClearAllPoints()
			_G[c]:SetPointToScale("TOP", _G["TabardFrameCustomization"..b-1], "BOTTOM", 0, -6)
		else
			local d, e, f, g, h = _G[c]:GetPoint()
			_G[c]:SetPointToScale(d, e, f, g, h + 4)
		end 
	end 
	TabardCharacterModelRotateLeftButton:SetPoint("BOTTOMLEFT", 4, 4)
	TabardCharacterModelRotateRightButton:SetPoint("TOPLEFT", TabardCharacterModelRotateLeftButton, "TOPRIGHT", 4, 0)
	hooksecurefunc(TabardCharacterModelRotateLeftButton, "SetPoint", function(self, d, j, k, l, m)
		if d ~= "BOTTOMLEFT" or l ~= 4 or m ~= 4 then
			 self:SetPoint("BOTTOMLEFT", 4, 4)
		end 
	end)
	hooksecurefunc(TabardCharacterModelRotateRightButton, "SetPoint", function(self, d, j, k, l, m)
		if d ~= "TOPLEFT" or l ~= 4 or m ~= 0 then
			 self:SetPoint("TOPLEFT", _G.TabardCharacterModelRotateLeftButton, "TOPRIGHT", 4, 0)
		end 
	end)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveCustomStyle(TabardFrameStyle)