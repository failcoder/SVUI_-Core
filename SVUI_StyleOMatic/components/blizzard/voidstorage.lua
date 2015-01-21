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
local unpack    = _G.unpack;
local select    = _G.select;
local ipairs    = _G.ipairs;
local pairs     = _G.pairs;
local type    = _G.type;
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
local NO_TEXTURE = [[Interface\AddOns\SVUI\assets\artwork\Template\EMPTY]];

local VoidStorageList = {
  "VoidStorageBorderFrame",
  "VoidStorageDepositFrame",
  "VoidStorageWithdrawFrame",
  "VoidStorageCostFrame",
  "VoidStorageStorageFrame",
  "VoidStoragePurchaseFrame",
  "VoidItemSearchBox"
};

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
    nTex:SetTexture([[Interface\ICONS\INV_Enchant_VoidSphere]])
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

local SlotBorderColor_Hook = function(self, ...)
  local parent = self:GetParent()
  if(parent) then
    parent:SetBackdropBorderColor(...)
  end
end
local SlotBorder_OnHide = function(self, ...)
  local parent = self:GetParent()
  if(parent) then
    parent:SetBackdropBorderColor(0,0,0,0.5)
  end
end

local function VoidSlotStyler(name, index)
  local gName = ("%sButton%d"):format(name, index)
  local button = _G[gName]
  local icon = _G[gName .. "IconTexture"]
  local bg = _G[gName .. "Bg"]
  if(button) then
    local border = button.IconBorder
    if(bg) then bg:Hide() end
    button:SetStylePanel("Slot", 2, 0, 0)
    if(icon) then
      icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
      icon:SetAllPointsIn(button)
    end
    if(border) then
      border:SetTexture(NO_TEXTURE)
      hooksecurefunc(border, "Hide", SlotBorder_OnHide)
      hooksecurefunc(border, "SetVertexColor", SlotBorderColor_Hook)
    end
  end
end
--[[ 
########################################################## 
VOIDSTORAGE PLUGINR
##########################################################
]]--
local function VoidStorageStyle()
  PLUGIN.Debugging = true
  if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.voidstorage ~= true then
     return 
  end

  PLUGIN:ApplyWindowStyle(VoidStorageFrame, true)

  for _,gName in pairs(VoidStorageList) do
    local frame = _G[gName]
    if(frame) then 
      frame:RemoveTextures()
    end
  end

  VoidStoragePurchaseFrame:SetFrameStrata('DIALOG')
  VoidStoragePurchaseFrame:SetStylePanel("!_Frame", "Button", true)
  VoidStorageFrameMarbleBg:Die()
  VoidStorageFrameLines:Die()

  select(2, VoidStorageFrame:GetRegions()):Die()

  VoidStoragePurchaseButton:SetStylePanel("Button")
  VoidStorageHelpBoxButton:SetStylePanel("Button")
  VoidStorageTransferButton:SetStylePanel("Button")

  PLUGIN:ApplyCloseButtonStyle(VoidStorageBorderFrame.CloseButton)

  VoidItemSearchBox:SetStylePanel("Frame", "Inset")
  VoidItemSearchBox.Panel:SetPointToScale("TOPLEFT", 10, -1)
  VoidItemSearchBox.Panel:SetPointToScale("BOTTOMRIGHT", 4, 1)

  for i = 1, 9 do
    VoidSlotStyler("VoidStorageDeposit", i)
    VoidSlotStyler("VoidStorageWithdraw", i)
  end 

  for i = 1, 80 do
    VoidSlotStyler("VoidStorageStorage", i)
  end

  ChangeTabHelper(VoidStorageFrame.Page1)
  ChangeTabHelper(VoidStorageFrame.Page2)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle("Blizzard_VoidStorageUI", VoidStorageStyle)