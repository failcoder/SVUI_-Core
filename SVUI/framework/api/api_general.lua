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
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack    = _G.unpack;
local select    = _G.select;
local pairs     = _G.pairs;
local ipairs    = _G.ipairs;
local type      = _G.type;
local error     = _G.error;
local pcall     = _G.pcall;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local table     = _G.table;
local string     = _G.string;
local math      = _G.math;
--[[ MATH METHODS ]]--
local floor, abs, min, max = math.floor, math.abs, math.min, math.max;
local parsefloat, ceil = math.parsefloat, math.ceil;
--[[ STRING METHODS ]]--
local lower, upper = string.lower, string.upper;
--[[ TABLE METHODS ]]--
local tremove, tcopy, twipe, tsort, tconcat, tdump = table.remove, table.copy, table.wipe, table.sort, table.concat, table.dump;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L
local SVLib = LibSuperVillain("Registry");
local LSM = LibStub("LibSharedMedia-3.0");
local STANDARD_TEXT_FONT = _G.STANDARD_TEXT_FONT;
--[[ 
########################################################## 
APPENDED POSITIONING METHODS
##########################################################
]]--
local SetSizeToScale = function(self, width, height)
    if(type(width) == "number") then
        local h = (height and type(height) == "number") and height or width
        self:SetSize(SV:Scale(width), SV:Scale(h))
    end
end

local SetWidthToScale = function(self, width)
    if(type(width) == "number") then
        self:SetWidth(SV:Scale(width))
    end
end

local SetHeightToScale = function(self, height)
    if(type(height) == "number") then
        self:SetHeight(SV:Scale(height))
    end
end

local SetAllPointsOut = function(self, parent, x, y)
    x = type(x) == "number" and x or 1
    y = y or x
    local nx = SV:Scale(x);
    local ny = SV:Scale(y);
    parent = parent or self:GetParent()
    if self:GetPoint() then 
        self:ClearAllPoints()
    end 
    self:SetPoint("TOPLEFT", parent, "TOPLEFT", -nx, ny)
    self:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", nx, -ny)
end 

local SetAllPointsIn = function(self, parent, x, y)
    x = type(x) == "number" and x or 1
    y = y or x
    local nx = SV:Scale(x);
    local ny = SV:Scale(y);
    parent = parent or self:GetParent()
    if self:GetPoint() then 
        self:ClearAllPoints()
    end 
    self:SetPoint("TOPLEFT", parent, "TOPLEFT", nx, -ny)
    self:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -nx, ny)
end

local SetPointToScale;
do
    local PARAMS = {}
    SetPointToScale = function(self, ...)
        local n = select('#', ...) 
        PARAMS = {...}
        local arg
        for i = 1, n do
            arg = PARAMS[i]
            if(arg and type(arg) == "number") then 
                PARAMS[i] = SV:Scale(arg)
            end 
        end 
        self:SetPoint(unpack(PARAMS))
    end
end
--[[ 
########################################################## 
APPENDED DESTROY METHODS
##########################################################
]]--
local _purgatory = CreateFrame("Frame", nil)
_purgatory:Hide()

local Die = function(self)
    if(self.UnregisterAllEvents) then 
        self:UnregisterAllEvents()
        self:SetParent(_purgatory)
    else 
        self:Hide()
        self.Show = SV.fubar
    end
end

local RemoveTextures = function(self, option)
    if(self.Panel) then return end
    local region, layer, texture
    for i = 1, self:GetNumRegions()do 
        region = select(i, self:GetRegions())
        if(region and (region:GetObjectType() == "Texture")) then

            layer = region:GetDrawLayer()
            texture = region:GetTexture()

            if(option) then
                if(type(option) == "boolean") then 
                    if region.UnregisterAllEvents then 
                        region:UnregisterAllEvents()
                        region:SetParent(_purgatory)
                    else 
                        region.Show = region.Hide 
                    end 
                    region:Hide()
                elseif(type(option) == "string" and ((layer == option) or (texture ~= option))) then
                    region:SetTexture(0,0,0,0)
                end
            else 
                region:SetTexture(0,0,0,0)
            end
        end 
    end
end 
--[[ 
########################################################## 
SECURE FADING
##########################################################
]]--
local FRAMES_TO_HIDE = {};
local FRAMES_TO_SHOW = {};

local FadeEventManager_OnEvent = function(self, event)
    if(event == 'PLAYER_REGEN_ENABLED') then
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
        for frame in pairs(FRAMES_TO_HIDE) do
            frame:Hide()
            if(frame.___forcehidefunc) then
                local _, catch = pcall(frame.___forcehidefunc, frame)
                if(catch) then
                    frame.___forcehidefunc = nil
                end
            end
        end
        wipe(FRAMES_TO_HIDE)
        for frame in pairs(FRAMES_TO_SHOW) do
            frame:Show()
            if(frame.___forceshowfunc) then
                local _, catch = pcall(frame.___forceshowfunc, frame)
                if(catch) then
                    frame.___forceshowfunc = nil
                end
            end
        end
        wipe(FRAMES_TO_SHOW)
    end
end

local FadeEventManager = CreateFrame('Frame')
FadeEventManager:SetScript("OnEvent", FadeEventManager_OnEvent)

local SecureFade_OnUpdate = function(self, elasped)
    local frame = self.owner;
    if(frame) then
        local state = frame.___fadeset;
        state[4] = (state[4] or 0) + elasped;
        if(state[4] < state[3]) then 

            if(frame.___fademode == "IN") then 
                frame:SetAlpha((state[4] / state[3]) * (state[2] - state[1]) + state[1])
            elseif(frame.___fademode == "OUT") then 
                frame:SetAlpha(((state[3] - state[4]) / state[3]) * (state[1] - state[2]) + state[2])
            end 

        else
            state[4] = 0
            frame:SetAlpha(state[2])
            local canfade = (not InCombatLockdown()) or (InCombatLockdown() and (not frame:IsProtected()))
            if(frame.___fadehide) then
                if(canfade) then 
                    frame:Hide()
                    if(frame.___fadefunc) then
                        local _, catch = pcall(frame.___fadefunc, frame)
                        if(not catch) then
                            frame.___fadefunc = nil
                        end
                    end

                    self.Running = false;
                    self:SetScript("OnUpdate", nil);
                else
                    FRAMES_TO_HIDE[frame] = true;
                    FadeEventManager:RegisterEvent("PLAYER_REGEN_ENABLED");
                end
            else
                if(frame.___fadefunc) then
                    local _, catch = pcall(frame.___fadefunc, frame)
                    if(not catch) then
                        frame.___fadefunc = nil
                    end
                end

                self.Running = false;
                self:SetScript("OnUpdate", nil);
            end
        end
    end
end

local SecureFadeIn = function(self, duration, alphaStart, alphaEnd)
    local alpha1 = alphaStart or 0;
    local alpha2 = alphaEnd or 1;
    local timer = duration or 0.1;

    local canfade = (not InCombatLockdown()) or (InCombatLockdown() and (not self:IsProtected()))
    if((not self:IsShown()) and canfade) then
        self:Show() 
    end

    if((not self:IsShown()) and (not canfade)) then
        FRAMES_TO_SHOW[self] = true
    end

    if(self:IsShown() and self:GetAlpha() == alpha2) then return end
    if(not self.___fadehandler) then 
        self.___fadehandler = CreateFrame("Frame", nil)
        self.___fadehandler.owner = self;
    end
    if(not self.___fademode or (self.___fademode and self.___fademode == "OUT")) then
        if(FRAMES_TO_HIDE[self]) then
            FRAMES_TO_HIDE[self] = nil
        end

        self.___fademode = "IN";
        self.___fadehide = false;
        self.___fadefunc = nil;

        if(not self.___fadeset) then
            self.___fadeset = {};
        end
        self.___fadeset[1] = alpha1;
        self.___fadeset[2] = alpha2;
        self.___fadeset[3] = timer;

        self:SetAlpha(alpha1)
    end
    if(not self.___fadehandler.Running) then
        self.___fadehandler.Running = true;
        self.___fadehandler:SetScript("OnUpdate", SecureFade_OnUpdate)
    end
end 

local SecureFadeOut = function(self, duration, alphaStart, alphaEnd, hideOnFinished)
    local alpha1 = alphaStart or 1;
    local alpha2 = alphaEnd or 0;
    local timer = duration or 0.1;

    if(not self:IsShown() or self:GetAlpha() == alpha2) then return end
    if(not self.___fadehandler) then 
        self.___fadehandler = CreateFrame("Frame", nil)
        self.___fadehandler.owner = self;
    end
    if(not self.___fademode or (self.___fademode and self.___fademode == "IN")) then
        if(FRAMES_TO_SHOW[self]) then
            FRAMES_TO_SHOW[self] = nil
        end

        self.___fademode = "OUT";
        self.___fadehide = hideOnFinished;
        self.___fadefunc = nil;

        if(not self.___fadeset) then
            self.___fadeset = {};
        end

        self.___fadeset[1] = alpha1;
        self.___fadeset[2] = alpha2;
        self.___fadeset[3] = timer;

        self:SetAlpha(alpha1)
    end
    if(not self.___fadehandler.Running) then
        self.___fadehandler.Running = true;
        self.___fadehandler:SetScript("OnUpdate", SecureFade_OnUpdate)
    end
end

local SecureFadeCallback = function(self, callback, onForceHide, onForceShow)
    if(onForceHide) then
        self.___forcehidefunc = callback;
    elseif(onForceShow) then
        self.___forceshowfunc = callback;
    else
        self.___fadefunc = callback;
    end
end
--[[ 
########################################################## 
HOOKED ATLAS HIJACKER
##########################################################
]]--
local ATLAS_THIEF = {} -- Wasn't this the name of a movie?
local ATLAS_HACKS = {} -- Couldn't think of anything clever honestly.
ATLAS_HACKS["default"] = function(self)
  self:SetTexture("")
end

local StealAtlas = function(self, atlas)
    if(not self or not atlas) then return end
    local hack = ATLAS_THIEF[atlas];
    if(hack) then
        local fn = ATLAS_HACKS[hack] or ATLAS_HACKS["default"]
        local pass, catch = pcall(fn, self, atlas)
        if(catch) then
            SV:Debugger(catch)
            return
        end
    end
end

function SV:SetAtlasFunc(atlas, fn)
    ATLAS_HACKS[atlas] = fn
end

function SV:SetAtlasFilter(atlas, fn)
    if(not fn) then
        fn = "default"
    end
    ATLAS_THIEF[atlas] = fn
end
--[[ 
########################################################## 
ENUMERATION
##########################################################
]]--
local function AppendMethods(OBJECT)
    local META = getmetatable(OBJECT).__index
    if not OBJECT.SetSizeToScale then META.SetSizeToScale = SetSizeToScale end
    if not OBJECT.SetWidthToScale then META.SetWidthToScale = SetWidthToScale end
    if not OBJECT.SetHeightToScale then META.SetHeightToScale = SetHeightToScale end
    if not OBJECT.SetPointToScale then META.SetPointToScale = SetPointToScale end
    if not OBJECT.SetAllPointsOut then META.SetAllPointsOut = SetAllPointsOut end
    if not OBJECT.SetAllPointsIn then META.SetAllPointsIn = SetAllPointsIn end
    if not OBJECT.Die then META.Die = Die end
    if not OBJECT.RemoveTextures then META.RemoveTextures = RemoveTextures end
    if not OBJECT.FadeIn then META.FadeIn = SecureFadeIn end
    if not OBJECT.FadeOut then META.FadeOut = SecureFadeOut end
    if not OBJECT.FadeCallback then META.FadeCallback = SecureFadeCallback end
    if(OBJECT.SetAtlas) then
        hooksecurefunc(META, "SetAtlas", StealAtlas)
    end
end

local HANDLER, OBJECT = {["Frame"] = true}, CreateFrame("Frame")
AppendMethods(OBJECT)
AppendMethods(OBJECT:CreateTexture())
AppendMethods(OBJECT:CreateFontString())

OBJECT = EnumerateFrames()
while OBJECT do
    local objType = OBJECT:GetObjectType()
    if not HANDLER[objType] then
		AppendMethods(OBJECT)
		HANDLER[objType] = true
	end
	OBJECT = EnumerateFrames(OBJECT)
end