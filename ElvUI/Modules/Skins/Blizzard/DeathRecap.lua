local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

--Lua functions
local _G = _G
local select, unpack = select, unpack
--WoW API / Variables
local CLOSE = CLOSE

function S:SkinDeathRecap()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.deathRecap) then return end

	local DeathRecapFrame = _G.DeathRecapFrame
	DeathRecapFrame:StripTextures()
	S:HandleCloseButton(DeathRecapFrame.CloseXButton)
	DeathRecapFrame:SetTemplate("Transparent")

	for i=1, 5 do
		local iconBorder = DeathRecapFrame["Recap"..i].SpellInfo.IconBorder
		local icon = DeathRecapFrame["Recap"..i].SpellInfo.Icon
		iconBorder:SetAlpha(0)
		icon:SetTexCoord(unpack(E.TexCoords))
		DeathRecapFrame["Recap"..i].SpellInfo:CreateBackdrop()
		DeathRecapFrame["Recap"..i].SpellInfo.backdrop:SetOutside(icon)
		icon:SetParent(DeathRecapFrame["Recap"..i].SpellInfo.backdrop)
	end

	for i=1, DeathRecapFrame:GetNumChildren() do
		local child = select(i, DeathRecapFrame:GetChildren())
		if (child:IsObjectType('Button') and child.GetText) and child:GetText() == CLOSE then
			S:HandleButton(child)
		end
	end
end

S:AddCallbackForAddon('Blizzard_DeathRecap', 'SkinDeathRecap')
