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
GET ADDON DATA
##########################################################
]]--
if(select(2, UnitClass("player")) ~= 'DRUID') then return end;

local SV = select(2, ...)

--[[ DRUID FILTERS ]]--

SV.filterdefaults["BuffWatch"] = {
    ["774"] = {-- Rejuvenation
        ["enable"] = true, 
        ["id"] = 774, 
        ["point"] = "TOPRIGHT", 
        ["color"] = {["r"] = 0.8, ["g"] = 0.4, ["b"] = 0.8}, 
        ["anyUnit"] = false, 
        ["onlyShowMissing"] = false, 
        ['style'] = 'coloredIcon', 
        ['displayText'] = false, 
        ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
        ['textThreshold'] = -1, 
        ['xOffset'] = 0, 
        ['yOffset'] = 0
    },
    ["8936"] = {-- Regrowth
        ["enable"] = true, 
        ["id"] = 8936, 
        ["point"] = "BOTTOMLEFT", 
        ["color"] = {["r"] = 0.2, ["g"] = 0.8, ["b"] = 0.2}, 
        ["anyUnit"] = false, 
        ["onlyShowMissing"] = false, 
        ['style'] = 'coloredIcon', 
        ['displayText'] = false, 
        ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
        ['textThreshold'] = -1, 
        ['xOffset'] = 0, 
        ['yOffset'] = 0
    },
    ["33763"] = {-- Lifebloom
        ["enable"] = true, 
        ["id"] = 33763, 
        ["point"] = "TOPLEFT", 
        ["color"] = {["r"] = 0.4, ["g"] = 0.8, ["b"] = 0.2}, 
        ["anyUnit"] = false, 
        ["onlyShowMissing"] = false, 
        ['style'] = 'coloredIcon', 
        ['displayText'] = false, 
        ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
        ['textThreshold'] = -1, 
        ['xOffset'] = 0, 
        ['yOffset'] = 0
    },
    ["48438"] = {-- Wild Growth
        ["enable"] = true, 
        ["id"] = 48438, 
        ["point"] = "BOTTOMRIGHT", 
        ["color"] = {["r"] = 0.8, ["g"] = 0.4, ["b"] = 0}, 
        ["anyUnit"] = false, 
        ["onlyShowMissing"] = false, 
        ['style'] = 'coloredIcon', 
        ['displayText'] = false, 
        ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
        ['textThreshold'] = -1, 
        ['xOffset'] = 0, 
        ['yOffset'] = 0
    },
};