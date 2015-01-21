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
--LUA
local unpack        = unpack;
local select        = select;
local pairs         = pairs;
local type          = type;
local rawset        = rawset;
local rawget        = rawget;
local tostring      = tostring;
local tonumber      = tonumber;
local error         = error;
local next          = next;
local pcall         = pcall;
local getmetatable  = getmetatable;
local setmetatable  = setmetatable;
local assert        = assert;
--BLIZZARD
local _G            = _G;
local tinsert       = _G.tinsert;
local tremove       = _G.tremove;
local twipe         = _G.wipe;
--STRING
local string        = string;
local format        = string.format;
local sub           = string.sub;
local upper         = string.upper;
local match         = string.match;
local gsub          = string.gsub;
--MATH
local math          = math;
local numMin        = math.min;
--TABLE
local table         = table;
local tsort         = table.sort;
local tremove       = table.remove;

local SV = select(2, ...)
local oUF_Villain = SV.oUF

assert(oUF_Villain, "SVUI was unable to locate oUF.")

local L = SV.L;
local LSM = LibStub("LibSharedMedia-3.0")
local MOD = SV.SVUnit

if(not MOD) then return end 
--[[ 
########################################################## 
LOCAL DATA
##########################################################
]]--
local CONSTRUCTORS = {}
local lastArenaFrame, lastBossFrame
--[[ 
########################################################## 
ALL UNIT HELPERS
##########################################################
]]--
local UpdateTargetGlow = function(self)
    if not self.unit then return end 
    local unit = self.unit;
    if(UnitIsUnit(unit, "target")) then 
        self.TargetGlow:Show()
        local reaction = UnitReaction(unit, "player")
        if(UnitIsPlayer(unit)) then 
            local _, class = UnitClass(unit)
            if class then 
                local colors = RAID_CLASS_COLORS[class]
                self.TargetGlow:SetBackdropBorderColor(colors.r, colors.g, colors.b)
            else 
                self.TargetGlow:SetBackdropBorderColor(1, 1, 1)
            end 
        elseif(reaction) then 
            local colors = FACTION_BAR_COLORS[reaction]
            self.TargetGlow:SetBackdropBorderColor(colors.r, colors.g, colors.b)
        else 
            self.TargetGlow:SetBackdropBorderColor(1, 1, 1)
        end 
    else 
        self.TargetGlow:Hide()
    end 
end

local AllowElement = function(self)
    if InCombatLockdown() then return; end
    
    if not self.isForced then 
        self.sourceElement = self.unit;
        self.unit = "player"
        self.isForced = true;
        self.sourceEvent = self:GetScript("OnUpdate")
    end

    self:SetScript("OnUpdate", nil)
    self.forceShowAuras = true;
    UnregisterUnitWatch(self)
    RegisterUnitWatch(self, true)

    self:Show()
    if self:IsVisible() and self.Update then 
        self:Update()
    end 
end

local RestrictElement = function(self)
    if(InCombatLockdown() or (not self.isForced)) then return; end

    self.forceShowAuras = nil
    self.isForced = nil

    UnregisterUnitWatch(self)
    RegisterUnitWatch(self)

    if self.sourceEvent then 
        self:SetScript("OnUpdate", self.sourceEvent)
        self.sourceEvent = nil 
    end

    self.unit = self.sourceElement or self.unit;

    if self:IsVisible() and self.Update then 
        self:Update()
    end 
end
--[[
########################################################## 
PLAYER
##########################################################
]]--
local UpdatePlayerFrame = function(self)
    local db = SV.db.SVUnit["player"]
    local UNIT_WIDTH = db.width;
    local UNIT_HEIGHT = db.height;
    local USE_CLASSBAR = db.classbar.enable;
    local classBarHeight = db.classbar.height;
    local classBarWidth = db.width * 0.4;
    local MASTER_GRIP = self.MasterGrip
    local iconDB = db.icons
    self:RegisterForClicks(SV.db.SVUnit.fastClickTarget and "AnyDown" or "AnyUp")

    MOD.RefreshUnitMedia(self, "player")

    self.colors = oUF_Villain.colors;
    self:SetSizeToScale(UNIT_WIDTH, UNIT_HEIGHT)
    local lossSize = UNIT_WIDTH * 0.6
    self.LossOfControl.stunned:SetSize(lossSize, lossSize)
    _G[self:GetName().."_MOVE"]:SetSizeToScale(self:GetSize())

    MOD:RefreshUnitLayout(self, "player")

    do 
        local resting = self.Resting;
        if resting then
            if iconDB and iconDB.restIcon and iconDB.restIcon.enable then
                local size = iconDB.restIcon.size;
                resting:ClearAllPoints()
                resting:SetSizeToScale(size)
                SV:SetReversePoint(resting, iconDB.restIcon.attachTo, MASTER_GRIP, iconDB.restIcon.xOffset, iconDB.restIcon.yOffset)
                if not self:IsElementEnabled("Resting")then 
                    self:EnableElement("Resting")
                end 
            elseif self:IsElementEnabled("Resting")then 
                self:DisableElement("Resting")
                resting:Hide()
            end
        end
    end 
    do 
        local combat = self.Combat;
        if combat then
            if iconDB and iconDB.combatIcon and iconDB.combatIcon.enable then
                local size = iconDB.combatIcon.size;
                combat:ClearAllPoints()
                combat:SetSizeToScale(size)
                SV:SetReversePoint(combat, iconDB.combatIcon.attachTo, MASTER_GRIP, iconDB.combatIcon.xOffset, iconDB.combatIcon.yOffset)
                if not self:IsElementEnabled("Combat")then 
                    self:EnableElement("Combat")
                end 
            elseif self:IsElementEnabled("Combat")then 
                self:DisableElement("Combat")
                combat:Hide()
            end
        end
    end 
    do 
        local pvp = self.PvPText;
        local point = db.pvp.position;
        pvp:ClearAllPoints()
        pvp:SetPointToScale(db.pvp.position, MASTER_GRIP, db.pvp.position)
        self:Tag(pvp, db.pvp.tags)
    end 
    do
        if(self.ClassBar) then
            if USE_CLASSBAR and self.ClassBarRefresh then 
                self.ClassBarRefresh(self)
            end 
            if(self.ClassBar) then
                local classBar = self[self.ClassBar];
                if USE_CLASSBAR then
                    if(not self:IsElementEnabled(self.ClassBar)) then 
                        self:EnableElement(self.ClassBar)
                    end
                    classBar:Show()
                else
                    if(self:IsElementEnabled(self.ClassBar)) then 
                        self:DisableElement(self.ClassBar)
                    end
                    classBar:Hide()
                end
            end
        end
    end 

    do 
        if db.combatfade and not self:IsElementEnabled("CombatFade")then 
            self:EnableElement("CombatFade")
        elseif 
            not db.combatfade and self:IsElementEnabled("CombatFade")then 
            self:DisableElement("CombatFade")
        end 
    end 
    self:UpdateAllElements()
end

CONSTRUCTORS["player"] = function(self, unit)
    local key = "player"
    self.unit = unit
    self.___key = key

    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:SetFrameLevel(2)

    MOD:SetActionPanel(self, key)
    self.Health = MOD:CreateHealthBar(self, true)
    self.Health.frequentUpdates = true
    self.Power = MOD:CreatePowerBar(self, true)
    self.Power.frequentUpdates = true
    MOD:CreatePortrait(self, false, true)
    self.Buffs = MOD:CreateBuffs(self, key)
    self.Debuffs = MOD:CreateDebuffs(self, key)
    self.Castbar = MOD:CreateCastbar(self, false, L["Player Castbar"], true, true, false, true)
    MOD:CreateExperienceRepBar(self)
    self.ClassBar = MOD:CreateClassBar(self)
    self.RaidIcon = MOD:CreateRaidIcon(self)
    MOD:CreatePlayerIndicators(self)
    self.PvPText = self.TextGrip:CreateFontString(nil,'OVERLAY')
    self.PvPText:SetFontObject(SpellFont_Small)
    self.Afflicted = MOD:CreateAfflicted(self)
    self.HealPrediction = MOD:CreateHealPrediction(self, true)
    self.AuraBars = MOD:CreateAuraBarHeader(self, key)
    self.ResolveBar = MOD:CreateResolveBar(self)
    self.CombatFade = true;
    self:SetPointToScale("BOTTOMLEFT", SV.Screen, "BOTTOM", -413, 182)
    SV.Mentalo:Add(self, L["Player Frame"])

    self.MediaUpdate = MOD.RefreshUnitMedia
    self.Update = UpdatePlayerFrame
    
    return self 
end
--[[ 
########################################################## 
TARGET
##########################################################
]]--
local UpdateTargetFrame = function(self)
    local db = SV.db.SVUnit["target"]
    local UNIT_WIDTH = db.width;
    local UNIT_HEIGHT = db.height;
    local USE_COMBOBAR = db.combobar.enable;
    local comboBarHeight = db.combobar.height;
    self:RegisterForClicks(SV.db.SVUnit.fastClickTarget and "AnyDown" or "AnyUp")

    MOD.RefreshUnitMedia(self, "target")
    self.colors = oUF_Villain.colors;
    self:SetSizeToScale(UNIT_WIDTH, UNIT_HEIGHT)
    _G[self:GetName().."_MOVE"]:SetSizeToScale(self:GetSize())
    if not self:IsElementEnabled("ActionPanel")then 
        self:EnableElement("ActionPanel")
    end

    if not self:IsElementEnabled("Friendship")then 
        self:EnableElement("Friendship")
    end
    MOD:RefreshUnitLayout(self, "target")

    if(SV.db.SVUnit.xrayFocus) then
        self.XRay:Show()
    else
        self.XRay:Hide()
    end

    if(not IsAddOnLoaded("Clique")) then 
        if db.middleClickFocus then 
            self:SetAttribute("type3", "focus")
        elseif self:GetAttribute("type3") == "focus"then 
            self:SetAttribute("type3", nil)
        end 
    end

    self:UpdateAllElements()
end

CONSTRUCTORS["target"] = function(self, unit)
    local key = "target"
    self.unit = unit
    self.___key = key

    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:SetFrameLevel(2)

    MOD:SetActionPanel(self, key)

    self.Health = MOD:CreateHealthBar(self, true, true)
    self.Health.frequentUpdates = true
    self.HealPrediction = MOD:CreateHealPrediction(self, true)

    self.Power = MOD:CreatePowerBar(self, true, true)
    self.Power.frequentUpdates = true

    MOD:CreatePortrait(self)

    self.Castbar = MOD:CreateCastbar(self, true, L["Target Castbar"], true)

    self.Buffs = MOD:CreateBuffs(self, key)
    self.Debuffs = MOD:CreateDebuffs(self, key)
    self.AuraBars = MOD:CreateAuraBarHeader(self, key)
    self.Afflicted = MOD:CreateAfflicted(self)
    self.RaidIcon = MOD:CreateRaidIcon(self)

    --self.GPS = MOD:CreateGPS(self)
    self.Friendship = MOD:CreateFriendshipBar(self)
    self.Range = { insideAlpha = 1, outsideAlpha = 1 }
    self.XRay = MOD:CreateXRay(self)
    self.XRay:SetPoint("TOPRIGHT", 12, 12)
    self:SetPointToScale("BOTTOMRIGHT", SV.Screen, "BOTTOM", 413, 182)
    SV.Mentalo:Add(self, L["Target Frame"])

    self.MediaUpdate = MOD.RefreshUnitMedia
    self.Update = UpdateTargetFrame
    return self 
end 
--[[ 
########################################################## 
TARGET OF TARGET
##########################################################
]]--
local UpdateTargetTargetFrame = function(self)
    local db = SV.db.SVUnit["targettarget"]
    local UNIT_WIDTH = db.width
    local UNIT_HEIGHT = db.height
    self:RegisterForClicks(SV.db.SVUnit.fastClickTarget and "AnyDown" or "AnyUp")
    MOD.RefreshUnitMedia(self, "targettarget")
    self.colors = oUF_Villain.colors;
    self:SetSizeToScale(UNIT_WIDTH, UNIT_HEIGHT)
    _G[self:GetName().."_MOVE"]:SetSizeToScale(self:GetSize())
    MOD:RefreshUnitLayout(self, "targettarget")
    self:UpdateAllElements()
end

CONSTRUCTORS["targettarget"] = function(self, unit)
    local key = "targettarget"
    self.unit = unit
    self.___key = key

    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:SetFrameLevel(2)

    MOD:SetActionPanel(self, key)
    self.Health = MOD:CreateHealthBar(self, true)
    self.Power = MOD:CreatePowerBar(self, true)
    MOD:CreatePortrait(self, true)
    self.Buffs = MOD:CreateBuffs(self, key)
    self.Debuffs = MOD:CreateDebuffs(self, key)
    self.RaidIcon = MOD:CreateRaidIcon(self)
    self.Range = { insideAlpha = 1, outsideAlpha = 1 }
    self:SetPointToScale("BOTTOM", SV.Screen, "BOTTOM", 0, 182)
    SV.Mentalo:Add(self, L["TargetTarget Frame"])

    self.MediaUpdate = MOD.RefreshUnitMedia
    self.Update = UpdateTargetTargetFrame
    return self 
end
--[[ 
########################################################## 
PET
##########################################################
]]--
local UpdatePetFrame = function(self)
    local db = SV.db.SVUnit["pet"]
    local UNIT_WIDTH = db.width;
    local UNIT_HEIGHT = db.height;
    self:RegisterForClicks(SV.db.SVUnit.fastClickTarget and "AnyDown" or "AnyUp")
    MOD.RefreshUnitMedia(self, "pet")
    self.colors = oUF_Villain.colors;
    self:SetSizeToScale(UNIT_WIDTH, UNIT_HEIGHT)
    _G[self:GetName().."_MOVE"]:SetSizeToScale(self:GetSize())
    MOD:RefreshUnitLayout(self, "pet")
    do 
        if SVUI_Player and not InCombatLockdown()then 
            self:SetParent(SVUI_Player)
        end 
    end 
    self:UpdateAllElements()
end

CONSTRUCTORS["pet"] = function(self, unit)
    local key = "pet"
    self.unit = unit
    self.___key = key
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:SetFrameLevel(2)
    MOD:SetActionPanel(self, key)
    self.Health = MOD:CreateHealthBar(self, true)
    self.Health.frequentUpdates = true;
    self.HealPrediction = MOD:CreateHealPrediction(self)
    self.Power = MOD:CreatePowerBar(self, true)
    self.Power.frequentUpdates = false;
    MOD:CreatePortrait(self, true)
    self.Castbar = MOD:CreateCastbar(self, false, nil, false)
    self.Buffs = MOD:CreateBuffs(self, key)
    self.Debuffs = MOD:CreateDebuffs(self, key)
    self.AuraWatch = MOD:CreateAuraWatch(self, key)
    self.RaidIcon = MOD:CreateRaidIcon(self)
    self.Range = { insideAlpha = 1, outsideAlpha = 1 }
    self:SetPointToScale("RIGHT", SVUI_Player, "LEFT", -2, 0)
    SV.Mentalo:Add(self, L["Pet Frame"])
    self.MediaUpdate = MOD.RefreshUnitMedia
    self.Update = UpdatePetFrame
    return self 
end 
--[[ 
########################################################## 
TARGET OF PET
##########################################################
]]--
local UpdatePetTargetFrame = function(self)
    local db = SV.db.SVUnit["pettarget"]
    local UNIT_WIDTH = db.width;
    local UNIT_HEIGHT = db.height;
    self:RegisterForClicks(SV.db.SVUnit.fastClickTarget and "AnyDown" or "AnyUp")
    MOD.RefreshUnitMedia(self, "pettarget")
    self.colors = oUF_Villain.colors;
    self:SetSizeToScale(UNIT_WIDTH, UNIT_HEIGHT)
    _G[self:GetName().."_MOVE"]:SetSizeToScale(self:GetSize())
    MOD:RefreshUnitLayout(self, "pettarget")
    do 
        if SVUI_Pet and not InCombatLockdown()then 
            self:SetParent(SVUI_Pet)
        end 
    end 
    self:UpdateAllElements()
end

CONSTRUCTORS["pettarget"] = function(self, unit)
    local key = "pettarget"
    self.unit = unit
    self.___key = key

    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:SetFrameLevel(2)
    
    MOD:SetActionPanel(self, key)
    self.Health = MOD:CreateHealthBar(self, true)
    self.Power = MOD:CreatePowerBar(self, true)
    self.Buffs = MOD:CreateBuffs(self, key)
    self.Debuffs = MOD:CreateDebuffs(self, key)
    self.Range = { insideAlpha = 1, outsideAlpha = 1 }
    self:SetPointToScale("BOTTOM", SVUI_Pet, "TOP", 0, 7)
    SV.Mentalo:Add(self, L["PetTarget Frame"], -7)

    self.MediaUpdate = MOD.RefreshUnitMedia
    self.Update = UpdatePetTargetFrame
    return self 
end 
--[[ 
########################################################## 
FOCUS
##########################################################
]]--
local UpdateFocusFrame = function(self)
    local db = SV.db.SVUnit["focus"]
    local UNIT_WIDTH = db.width;
    local UNIT_HEIGHT = db.height;
    self:RegisterForClicks(SV.db.SVUnit.fastClickTarget and "AnyDown" or "AnyUp")
    MOD.RefreshUnitMedia(self, "focus")
    self.colors = oUF_Villain.colors;
    self:SetSizeToScale(UNIT_WIDTH, UNIT_HEIGHT)
    _G[self:GetName().."_MOVE"]:SetSizeToScale(self:GetSize())
    MOD:RefreshUnitLayout(self, "focus")

    if(SV.db.SVUnit.xrayFocus) then
        self.XRay:Show()
    else
        self.XRay:Hide()
    end

    self:UpdateAllElements()
end

CONSTRUCTORS["focus"] = function(self, unit)
    local key = "focus"
    self.unit = unit
    self.___key = key

    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:SetFrameLevel(2)
    
    MOD:SetActionPanel(self, key)
    
    self.Health = MOD:CreateHealthBar(self, true, true)
    self.Health.frequentUpdates = true

    self.HealPrediction = MOD:CreateHealPrediction(self, true)
    self.Power = MOD:CreatePowerBar(self, true)

    self.Castbar = MOD:CreateCastbar(self, false, L["Focus Castbar"])
    self.Castbar.SafeZone = nil

    self.Castbar.LatencyTexture:Hide()
    self.Buffs = MOD:CreateBuffs(self, key)
    self.Debuffs = MOD:CreateDebuffs(self, key)
    self.AuraBars = MOD:CreateAuraBarHeader(self, key)
    self.AuraWatch = MOD:CreateAuraWatch(self, key)
    self.RaidIcon = MOD:CreateRaidIcon(self)
    self.Range = { insideAlpha = 1, outsideAlpha = 1 }
    self.XRay = MOD:CreateXRay_Closer(self)
    self.XRay:SetPoint("RIGHT", 20, 0)
    self:SetPointToScale("BOTTOMRIGHT", SVUI_Target, "TOPRIGHT", 0, 220)
    SV.Mentalo:Add(self, L["Focus Frame"])

    self.MediaUpdate = MOD.RefreshUnitMedia
    self.Update = UpdateFocusFrame
    return self 
end
--[[ 
########################################################## 
TARGET OF FOCUS
##########################################################
]]--
local UpdateFocusTargetFrame = function(self)
    local db = SV.db.SVUnit["focustarget"]
    local UNIT_WIDTH = db.width;
    local UNIT_HEIGHT = db.height;
    self:RegisterForClicks(SV.db.SVUnit.fastClickTarget and "AnyDown" or "AnyUp")
    MOD.RefreshUnitMedia(self, "focustarget")
    self.colors = oUF_Villain.colors;
    self:SetSizeToScale(UNIT_WIDTH, UNIT_HEIGHT)
    _G[self:GetName().."_MOVE"]:SetSizeToScale(self:GetSize())
    MOD:RefreshUnitLayout(self, "focustarget")
    self:UpdateAllElements()
end

CONSTRUCTORS["focustarget"] = function(self, unit)
    local key = "focustarget"
    self.unit = unit
    self.___key = key

    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:SetFrameLevel(2)
    
    MOD:SetActionPanel(self, key)
    self.Health = MOD:CreateHealthBar(self, true)
    self.Power = MOD:CreatePowerBar(self, true)
    self.Buffs = MOD:CreateBuffs(self, key)
    self.Debuffs = MOD:CreateDebuffs(self, key)
    self.RaidIcon = MOD:CreateRaidIcon(self)
    self.Range = { insideAlpha = 1, outsideAlpha = 1 }
    self:SetPointToScale("LEFT", SVUI_Focus, "RIGHT", 12, 0)
    SV.Mentalo:Add(self, L["FocusTarget Frame"], -7)

    self.MediaUpdate = MOD.RefreshUnitMedia
    self.Update = UpdateFocusTargetFrame
    return self 
end 
--[[ 
########################################################## 
BOSS
##########################################################
]]--
local UpdateBossFrame = function(self)
    local db = SV.db.SVUnit["boss"]
    local INDEX = self:GetID() or 1;
    local holder = _G["SVUI_Boss_MOVE"]
    local UNIT_WIDTH = db.width;
    local UNIT_HEIGHT = db.height;

    MOD.RefreshUnitMedia(self, "boss")

    self.colors = oUF_Villain.colors;
    self:SetSizeToScale(UNIT_WIDTH, UNIT_HEIGHT)
    self:ClearAllPoints()

    if(tonumber(INDEX) == 1) then
        holder:SetWidthToScale(UNIT_WIDTH)
        holder:SetHeightToScale(UNIT_HEIGHT + (UNIT_HEIGHT + 12 + db.castbar.height) * 4)
        if db.showBy == "UP"then 
            self:SetPointToScale("BOTTOMRIGHT", holder, "BOTTOMRIGHT")
        else 
            self:SetPointToScale("TOPRIGHT", holder, "TOPRIGHT")
        end 
    else
        local yOffset = (UNIT_HEIGHT + 12 + db.castbar.height) * (INDEX - 1)
        if db.showBy == "UP"then 
            self:SetPointToScale("BOTTOMRIGHT", holder, "BOTTOMRIGHT", 0, yOffset)
        else 
            self:SetPointToScale("TOPRIGHT", holder, "TOPRIGHT", 0, -yOffset)
        end 
    end 

    self:RegisterForClicks(SV.db.SVUnit.fastClickTarget and "AnyDown" or "AnyUp")
    MOD:RefreshUnitLayout(self, "boss")
    self:UpdateAllElements()
end

CONSTRUCTORS["boss"] = function(self, unit)
    local key = "boss"
    local selfID = unit:match('boss(%d)')
    self.unit = unit
    self.___key = key
    self:SetID(selfID)

    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:SetFrameLevel(2)
    
    MOD:SetActionPanel(self, key)
    self.Health = MOD:CreateHealthBar(self, true, true)
    self.Health.frequentUpdates = true
    self.Power = MOD:CreatePowerBar(self, true, true)
    MOD:CreatePortrait(self)
    self.Buffs = MOD:CreateBuffs(self, key)
    self.Debuffs = MOD:CreateDebuffs(self, key)
    self.Afflicted = MOD:CreateAfflicted(self)
    self.Castbar = MOD:CreateCastbar(self, true, nil, true, nil, true)
    self.RaidIcon = MOD:CreateRaidIcon(self)
    self.AltPowerBar = MOD:CreateAltPowerBar(self)

    self.Restrict = RestrictElement
    self.Allow = AllowElement

    self.Range = { insideAlpha = 1, outsideAlpha = 1 }
    self:SetAttribute("type2", "focus")

    if(not _G["SVUI_Boss_MOVE"]) then
        self:SetPointToScale("RIGHT", SV.Screen, "RIGHT", -105, 0)
        SV.Mentalo:Add(self, L["Boss Frames"], nil, nil, "SVUI_Boss")
    else
        self:SetPointToScale("TOPRIGHT", lastBossFrame, "BOTTOMRIGHT", 0, -20)
    end

    self.MediaUpdate = MOD.RefreshUnitMedia
    self.Update = UpdateBossFrame
    lastBossFrame = self
    return self 
end
--[[ 
########################################################## 
ARENA
##########################################################
]]--
local UpdateArenaFrame = function(self)
    local db = SV.db.SVUnit["arena"]
    local INDEX = self:GetID() or 1;
    local holder = _G["SVUI_Arena_MOVE"]
    local UNIT_WIDTH = db.width;
    local UNIT_HEIGHT = db.height

    MOD.RefreshUnitMedia(self, "arena")

    self.colors = oUF_Villain.colors;
    self:SetSizeToScale(UNIT_WIDTH, UNIT_HEIGHT)
    self:RegisterForClicks(SV.db.SVUnit.fastClickTarget and "AnyDown" or "AnyUp")

    self:ClearAllPoints()

    if(tonumber(INDEX) == 1) then
        holder:SetWidthToScale(UNIT_WIDTH)
        holder:SetHeightToScale(UNIT_HEIGHT + (UNIT_HEIGHT + 12 + db.castbar.height) * 4)
        if(db.showBy == "UP") then 
            self:SetPointToScale("BOTTOMRIGHT", holder, "BOTTOMRIGHT")
        else 
            self:SetPointToScale("TOPRIGHT", holder, "TOPRIGHT")
        end 
    else
        local yOffset = (UNIT_HEIGHT + 12 + db.castbar.height) * (INDEX - 1)
        if(db.showBy == "UP") then 
            self:SetPointToScale("BOTTOMRIGHT", holder, "BOTTOMRIGHT", 0, yOffset)
        else 
            self:SetPointToScale("TOPRIGHT", holder, "TOPRIGHT", 0, -yOffset)
        end 
    end

    MOD:RefreshUnitLayout(self, "arena")

    if(self.Gladiator) then
        local pvp = self.Gladiator
        local trinket = pvp.Trinket
        local badge = pvp.Badge

        local leftAnchor = self
        local rightAnchor = self

        trinket:SetSizeToScale(db.pvp.trinketSize)
        trinket:ClearAllPoints()
        if(db.pvp.trinketPosition == "RIGHT") then 
            trinket:SetPointToScale("LEFT", rightAnchor, "RIGHT", db.pvp.trinketX, db.pvp.trinketY)
            rightAnchor = trinket
        else 
            trinket:SetPointToScale("RIGHT", leftAnchor, "LEFT", db.pvp.trinketX, db.pvp.trinketY)
            leftAnchor = trinket
        end

        badge:SetSizeToScale(db.pvp.specSize)
        badge:ClearAllPoints()
        if(db.pvp.specPosition == "RIGHT") then 
            badge:SetPointToScale("LEFT", rightAnchor, "RIGHT", db.pvp.specX, db.pvp.specY)
            rightAnchor = badge
        else 
            badge:SetPointToScale("RIGHT", leftAnchor, "LEFT", db.pvp.specX, db.pvp.specY)
            leftAnchor = badge
        end

        pvp:ClearAllPoints()
        pvp:SetPoint("TOPLEFT", leftAnchor, "TOPLEFT", 0, 0)
        pvp:SetPoint("BOTTOMRIGHT", rightAnchor, "BOTTOMRIGHT", 0, 0)

        if(db.pvp.enable and (not self:IsElementEnabled("Gladiator"))) then
            self:EnableElement("Gladiator")
            pvp:Show()
        elseif((not db.pvp.enable) and self:IsElementEnabled("Gladiator")) then 
            self:DisableElement("Gladiator")
            pvp:Hide()
        end
    end

    self:UpdateAllElements()
end

CONSTRUCTORS["arena"] = function(self, unit)
    local key = "arena"
    local selfID = unit:match('arena(%d)')
    self.unit = unit
    self.___key = key
    self:SetID(selfID)

    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:SetFrameLevel(2)
    
    local selfName = self:GetName()
    local prepName = selfName.."PrepFrame";
    

    MOD:SetActionPanel(self, key)
    self.Health = MOD:CreateHealthBar(self, true, true)
    self.Power = MOD:CreatePowerBar(self, true)
    MOD:CreatePortrait(self)
    self.Buffs = MOD:CreateBuffs(self, key)
    self.Debuffs = MOD:CreateDebuffs(self, key)
    self.Castbar = MOD:CreateCastbar(self, true, nil, true, nil, true)
    self.Gladiator = MOD:CreateGladiator(self)
    self.Range = { insideAlpha = 1, outsideAlpha = 1 }
    self:SetAttribute("type2", "focus")

    self.Restrict = RestrictElement
    self.Allow = AllowElement

    if(not _G[prepName]) then
        local prep = CreateFrame("Frame", prepName, UIParent)
        prep:SetFrameStrata("MEDIUM")
        prep:SetAllPoints(self)
        prep:SetID(selfID)
        prep:SetStylePanel("Frame", "Bar", true, 3, 1, 1)

        local health = CreateFrame("StatusBar", nil, prep)
        health:SetAllPoints(prep)
        health:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Bars\DEFAULT]])
        prep.Health = health

        local icon = CreateFrame("Frame", nil, prep)
        icon:SetSize(45,45)
        icon:SetPoint("LEFT", prep, "RIGHT", 2, 0)
        icon:SetBackdrop({
            bgFile = [[Interface\BUTTONS\WHITE8X8]], 
            tile = false, 
            tileSize = 0, 
            edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
            edgeSize = 2, 
            insets = {
                left = 0, 
                right = 0, 
                top = 0, 
                bottom = 0
            }
        })
        icon:SetBackdropColor(0, 0, 0, 0)
        icon:SetBackdropBorderColor(0, 0, 0)
        icon.Icon = icon:CreateTexture(nil, "OVERLAY")
        icon.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        icon.Icon:SetAllPointsIn(icon, 2, 2)
        prep.SpecIcon = icon

        local text = prep.Health:CreateFontString(nil, "OVERLAY")
        text:SetFont(SV.Media.font.dialog, 16, "OUTLINE")
        text:SetTextColor(1, 1, 1)
        text:SetPoint("CENTER")
        prep.SpecClass = text

        prep:Hide()
    end

    if(not _G["SVUI_Arena_MOVE"]) then
        self:SetPointToScale("RIGHT", SV.Screen, "RIGHT", -105, 0)
        SV.Mentalo:Add(self, L["Arena Frames"], nil, nil, "SVUI_Arena")
    else
        self:SetPointToScale("TOPRIGHT", lastArenaFrame, "BOTTOMRIGHT", 0, -20)
    end

    self.MediaUpdate = MOD.RefreshUnitMedia
    self.Update = UpdateArenaFrame
    lastArenaFrame = self
    return self 
end
--[[ 
########################################################## 
PREP FRAME
##########################################################
]]--
local ArenaPrepHandler = CreateFrame("Frame")
local ArenaPrepHandler_OnEvent = function(self, event)
    local prepframe
    local _, instanceType = IsInInstance()
    if(not SV.db.SVUnit or not SV.db.SVUnit.arena or not SV.db.SVUnit.arena.enable or instanceType ~= "arena") then return end
    if event == "PLAYER_LOGIN" then
        for i = 1, 5 do
            prepframe = _G["SVUI_Arena"..i.."PrepFrame"]
            if(prepframe) then
                prepframe:SetAllPoints(_G["SVUI_Arena"..i])
            end
        end
    elseif event == "ARENA_OPPONENT_UPDATE" then
        for i = 1, 5 do
            prepframe = _G["SVUI_Arena"..i.."PrepFrame"]
            if(prepframe and prepframe:IsShown()) then
                prepframe:Hide()
            end
        end
    else
        local numOpps = GetNumArenaOpponentSpecs()
        if numOpps > 0 then
            for i = 1, 5 do
                prepframe = _G["SVUI_Arena"..i.."PrepFrame"]
                if(prepframe) then
                    if i <= numOpps then
                        local s = GetArenaOpponentSpec(i)
                        local _, spec, class, icon = nil, "UNKNOWN", "UNKNOWN", [[INTERFACE\ICONS\INV_MISC_QUESTIONMARK]]
                        if s and s > 0 then
                            _, spec, _, icon, _, _, class = GetSpecializationInfoByID(s)
                        end
                        if class and spec then
                            prepframe.SpecClass:SetText(spec .. " - " .. LOCALIZED_CLASS_NAMES_MALE[class])
                            prepframe.SpecIcon.Icon:SetTexture(icon or [[INTERFACE\ICONS\INV_MISC_QUESTIONMARK]])

                            local color = CUSTOM_CLASS_COLORS[class]
                            local textcolor = RAID_CLASS_COLORS[class] or color
                            if color then
                                prepframe.Health:SetStatusBarColor(color.r, color.g, color.b)
                                prepframe.SpecClass:SetTextColor(textcolor.r, textcolor.g, textcolor.b)
                            else
                                prepframe.Health:SetStatusBarColor(0.25, 0.25, 0.25)
                                prepframe.SpecClass:SetTextColor(1, 1, 1)
                            end

                            prepframe:Show()
                        end
                    else
                        prepframe:Hide()
                    end
                end
            end
        else
            for i = 1, 5 do
                prepframe = _G["SVUI_Arena"..i.."PrepFrame"]
                if(prepframe and prepframe:IsShown()) then
                    prepframe:Hide()
                end
            end
        end
    end
end 

ArenaPrepHandler:RegisterEvent("PLAYER_LOGIN")
ArenaPrepHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
ArenaPrepHandler:RegisterEvent("ARENA_OPPONENT_UPDATE")
ArenaPrepHandler:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
ArenaPrepHandler:SetScript("OnEvent", ArenaPrepHandler_OnEvent)
--[[ 
########################################################## 
LOAD/UPDATE METHOD
##########################################################
]]--
function MOD:SetUnitFrame(key)
    if(InCombatLockdown()) then self:RegisterEvent("PLAYER_REGEN_ENABLED"); return end
    local unit = key
    local realName = unit:gsub("(.)", upper, 1)
    realName = realName:gsub("t(arget)", "T%1")
    local styleName = "SVUI_"..realName
    local frame
    if not self.Units[unit] then
        oUF_Villain:RegisterStyle(styleName, CONSTRUCTORS[key])
        oUF_Villain:SetActiveStyle(styleName)
        frame = oUF_Villain:Spawn(unit, styleName)
        self.Units[unit] = frame
    else
        frame = self.Units[unit]
    end
    if frame:GetParent() ~= SVUI_UnitFrameParent then 
        frame:SetParent(SVUI_UnitFrameParent)
    end
    if(SV.db.SVUnit.enable and SV.db.SVUnit[key].enable) then 
        frame:Enable()
        frame:Update()
    else
        frame:Disable()
    end
end

function MOD:SetEnemyFrame(key, maxCount)
    if(InCombatLockdown()) then self:RegisterEvent("PLAYER_REGEN_ENABLED"); return end
    for i = 1, maxCount do
        local unit = key..i
        local realName = unit:gsub("(.)", upper, 1)
        realName = realName:gsub("t(arget)", "T%1")
        local styleName = "SVUI_"..realName
        local frame
        if not self.Units[unit] then
            oUF_Villain:RegisterStyle(styleName, CONSTRUCTORS[key])
            oUF_Villain:SetActiveStyle(styleName)
            frame = oUF_Villain:Spawn(unit, styleName)
            self.Units[unit] = frame
        else
            frame = self.Units[unit]
        end
        if frame:GetParent() ~= SVUI_UnitFrameParent then 
            frame:SetParent(SVUI_UnitFrameParent)
        end
        if(SV.db.SVUnit.enable and SV.db.SVUnit[key].enable) then 
            frame:Enable()
            frame:Update() 
        else 
            frame:Disable()
        end
    end
end

-- tinsert(self.__elements, ELEMENT_FUNCTION)
-- self:RegisterEvent(ELEMENT_EVENT, ELEMENT_FUNCTION)