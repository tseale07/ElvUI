local DB, C, L = unpack(ElvUI) -- Import Functions/Constants, Config, Locales


if not C["raidframes"].enable == true or C["raidframes"].gridonly == true then return end

local font2 = C["media"].uffont
local font1 = C["media"].font
local normTex = C["media"].normTex

--Frame Size
local party_height = DB.Scale(28)*C["raidframes"].scale
local party_width = DB.Scale(130)*C["raidframes"].scale
local ptarget_height = DB.Scale(17)*C["raidframes"].scale
local ptarget_width = (party_width/2)*C["raidframes"].scale


local function Shared(self, unit)
	self.colors = DB.oUF_colors
	self:RegisterForClicks("AnyUp")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	self.menu = DB.SpawnMenu
	
	-- an update script to all elements
	self:HookScript("OnShow", DB.updateAllElements)
	
	self:SetBackdrop({bgFile = C["media"].blank, insets = {top = -DB.mult, left = -DB.mult, bottom = -DB.mult, right = -DB.mult}})
	self:SetBackdropColor(0.1, 0.1, 0.1)
	
	if unit == "raidtarget" then
		local health = CreateFrame('StatusBar', nil, self)
		health:SetPoint("TOPLEFT")
		health:SetPoint("BOTTOMRIGHT")
		health:SetStatusBarTexture(normTex)
		self.Health = health	
		
		health.bg = health:CreateTexture(nil, 'BORDER')
		health.bg:SetAllPoints(health)
		self.Health.bg = health.bg
		
		health.PostUpdate = DB.PostUpdateHealth
		health.frequentUpdates = true
		
		if C.unitframes.classcolor ~= true then
			health.colorClass = false
			health:SetStatusBarColor(unpack(C["unitframes"].healthcolor))
			health.bg:SetTexture(unpack(C["unitframes"].healthbackdropcolor))
		else
			health.colorClass = true
			health.colorReaction = true	
			health.bg.multiplier = 0.3			
		end
		health.colorDisconnected = false
		
		-- border for all frames
		local FrameBorder = CreateFrame("Frame", nil, self)
		FrameBorder:SetPoint("TOPLEFT", self, "TOPLEFT", DB.Scale(-2), DB.Scale(2))
		FrameBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", DB.Scale(2), DB.Scale(-2))
		DB.SetTemplate(FrameBorder)
		FrameBorder:SetBackdropBorderColor(unpack(C["media"].altbordercolor))
		FrameBorder:SetFrameLevel(2)
		self.FrameBorder = FrameBorder
		
		local name = health:CreateFontString(nil, "OVERLAY")
		name:SetPoint("CENTER", health, 0, 1)
		name:SetFont(font2, C["raidframes"].fontsize, "THINOUTLINE")
		name:SetShadowOffset(1, -1)
		
		self:Tag(name, "[Elvui:getnamecolor][Elvui:nameshort]")
		self.Name = name
		
		if C["unitframes"].debuffhighlight == true then
			local dbh = health:CreateTexture(nil, "OVERLAY", health)
			dbh:SetAllPoints(health)
			dbh:SetTexture(C["media"].normTex)
			dbh:SetBlendMode("ADD")
			dbh:SetVertexColor(0,0,0,0)
			self.DebuffHighlight = dbh
			self.DebuffHighlightFilter = true
			self.DebuffHighlightAlpha = 0.4		
		end

		if C["unitframes"].showsmooth == true then
			health.Smooth = true
		end
	else
		local health = CreateFrame('StatusBar', nil, self)
		health:SetHeight(party_height*.80)
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		self.Health = health
		
		health.bg = health:CreateTexture(nil, 'BORDER')
		health.bg:SetAllPoints(health)
		
		self.Health.bg = health.bg
			
		health.value = health:CreateFontString(nil, "OVERLAY")
		health.value:SetPoint("RIGHT", health, -3, 1)
		health.value:SetFont(font2, C["raidframes"].fontsize, "THINOUTLINE")
		health.value:SetTextColor(1,1,1)
		health.value:SetShadowOffset(1, -1)
		self.Health.value = health.value
		
		health.PostUpdate = DB.PostUpdateHealth
		health.frequentUpdates = true
		
		if C.unitframes.classcolor ~= true then
			health.colorClass = false
			health:SetStatusBarColor(unpack(C["unitframes"].healthcolor))
			health.bg:SetTexture(unpack(C["unitframes"].healthbackdropcolor))
		else
			health.colorClass = true
			health.colorReaction = true	
			health.bg.multiplier = 0.3			
		end
		health.colorDisconnected = false
		
		-- border for all frames
		local FrameBorder = CreateFrame("Frame", nil, self)
		FrameBorder:SetPoint("TOPLEFT", self, "TOPLEFT", DB.Scale(-2), DB.Scale(2))
		FrameBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", DB.Scale(2), DB.Scale(-2))
		DB.SetTemplate(FrameBorder)
		FrameBorder:SetBackdropBorderColor(unpack(C["media"].altbordercolor))
		FrameBorder:SetFrameLevel(2)
		self.FrameBorder = FrameBorder
		
		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:SetPoint("TOPLEFT", health, "BOTTOMLEFT", 0, DB.Scale(-1)+(-DB.mult*2))
		power:SetPoint("TOPRIGHT", health, "BOTTOMRIGHT", 0, DB.Scale(-1)+(-DB.mult*2))
		power:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
		power:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
		power:SetStatusBarTexture(normTex)
		self.Power = power

		-- border between health and power
		self.HealthBorder = CreateFrame("Frame", nil, power)
		self.HealthBorder:SetPoint("TOPLEFT", health, "BOTTOMLEFT", 0, -DB.mult)
		self.HealthBorder:SetPoint("TOPRIGHT", health, "BOTTOMRIGHT", 0, -DB.mult)
		self.HealthBorder:SetPoint("BOTTOMLEFT", power, "TOPLEFT", 0, DB.mult)
		self.HealthBorder:SetPoint("BOTTOMRIGHT", power, "TOPRIGHT", 0, DB.mult)
		DB.SetTemplate(self.HealthBorder)
		self.HealthBorder:SetBackdropBorderColor(unpack(C["media"].altbordercolor))		
		power.frequentUpdates = true

		power.bg = self.Power:CreateTexture(nil, "BORDER")
		power.bg:SetAllPoints(power)
		power.bg:SetTexture(normTex)
		power.bg.multiplier = 0.3
		self.Power.bg = power.bg
			
		power.colorPower = true
		power.colorTapping = false
		power.colorDisconnected = true
		
		local name = health:CreateFontString(nil, "OVERLAY")
		name:SetPoint("LEFT", health, 3, 1)
		name:SetFont(font2, C["raidframes"].fontsize, "THINOUTLINE")
		name:SetShadowOffset(1, -1)
		
		self:Tag(name, "[Elvui:getnamecolor][Elvui:namelong]")
		self.Name = name
		
		local leader = health:CreateTexture(nil, "OVERLAY")
		leader:SetHeight(DB.Scale(12))
		leader:SetWidth(DB.Scale(12))
		leader:SetPoint("TOPLEFT", 0, 6)
		self.Leader = leader
		
		local LFDRole = health:CreateTexture(nil, "OVERLAY")
		LFDRole:SetHeight(DB.Scale(6))
		LFDRole:SetWidth(DB.Scale(6))
		LFDRole:SetPoint("TOPRIGHT", DB.Scale(-2), DB.Scale(-2))
		LFDRole:SetTexture("Interface\\AddOns\\ElvUI\\media\\textures\\lfdicons.blp")
		self.LFDRole = LFDRole
		
		local MasterLooter = health:CreateTexture(nil, "OVERLAY")
		MasterLooter:SetHeight(DB.Scale(12))
		MasterLooter:SetWidth(DB.Scale(12))
		self.MasterLooter = MasterLooter
		self:RegisterEvent("PARTY_LEADER_CHANGED", DB.MLAnchorUpdate)
		self:RegisterEvent("PARTY_MEMBERS_CHANGED", DB.MLAnchorUpdate)
		
		if C["unitframes"].aggro == true then
			table.insert(self.__elements, DB.UpdateThreat)
			self:RegisterEvent('PLAYER_TARGET_CHANGED', DB.UpdateThreat)
			self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', DB.UpdateThreat)
			self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', DB.UpdateThreat)
		end
		
		if C["unitframes"].showsymbols == true then
			local RaidIcon = health:CreateTexture(nil, 'OVERLAY')
			RaidIcon:SetHeight(DB.Scale(15))
			RaidIcon:SetWidth(DB.Scale(15))
			RaidIcon:SetPoint('CENTER', self, 'TOP')
			RaidIcon:SetTexture("Interface\\AddOns\\ElvUI\\media\\textures\\raidicons.blp")
			self.RaidIcon = RaidIcon
		end
		
		local ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
		ReadyCheck:SetHeight(C["raidframes"].fontsize)
		ReadyCheck:SetWidth(C["raidframes"].fontsize)
		ReadyCheck:SetPoint('LEFT', self.Name, 'RIGHT', 4, 0)
		self.ReadyCheck = ReadyCheck

		local debuffs = CreateFrame('Frame', nil, self)
		debuffs:SetPoint('LEFT', self, 'RIGHT', 5, 0)
		debuffs:SetHeight(party_height*.9)
		debuffs:SetWidth(200)
		debuffs.size = party_height*.9
		debuffs.spacing = 2
		debuffs.initialAnchor = 'LEFT'
		debuffs.num = 5
		debuffs.PostCreateIcon = DB.PostCreateAura
		debuffs.PostUpdateIcon = DB.PostUpdateAura
		self.Debuffs = debuffs
		
		if C["unitframes"].debuffhighlight == true then
			local dbh = health:CreateTexture(nil, "OVERLAY", health)
			dbh:SetAllPoints(health)
			dbh:SetTexture(C["media"].normTex)
			dbh:SetBlendMode("ADD")
			dbh:SetVertexColor(0,0,0,0)
			self.DebuffHighlight = dbh
			self.DebuffHighlightFilter = true
			self.DebuffHighlightAlpha = 0.4		
		end
		
		-- Debuff Aura Filter
		self.Debuffs.CustomFilter = DB.AuraFilter
		
		if C["raidframes"].showrange == true then
			local range = {insideAlpha = 1, outsideAlpha = C["raidframes"].raidalphaoor}
			self.Range = range
		end
		
		if C["unitframes"].showsmooth == true then
			health.Smooth = true
			power.Smooth = true
		end
			
		if C["auras"].raidunitbuffwatch == true then
			DB.createAuraWatch(self,unit)
		end
	end
	-- execute an update on every raids unit if party or raid member changed
	-- should fix issues with names/symbols/etc not updating introduced with 4.0.3 patch
	self:RegisterEvent("PARTY_MEMBERS_CHANGED", DB.updateAllElements)
	self:RegisterEvent("RAID_ROSTER_UPDATE", DB.updateAllElements)
	
	return self
end

oUF:RegisterStyle('ElvuiDPSParty', Shared)
oUF:Factory(function(self)
	oUF:SetActiveStyle("ElvuiDPSParty")
	local party
	if C["raidframes"].partytarget ~= true then
		party = self:SpawnHeader("ElvuiDPSParty", nil, "custom [@raid6,exists] hide;show", 
			'oUF-initialConfigFunction', [[
				local header = self:GetParent()
				self:SetWidth(header:GetAttribute('initial-width'))
				self:SetHeight(header:GetAttribute('initial-height'))
			]],
			'initial-width', party_width,
			'initial-height', party_height,			
			"showParty", true, 
			"showPlayer", C["raidframes"].showplayerinparty, 
			"showRaid", true, 
			"showSolo", false,
			"yOffset", DB.Scale(-8)
		)
	else
		party = self:SpawnHeader("ElvuiDPSParty", nil, "custom [@raid6,exists] hide;show", 
			'oUF-initialConfigFunction', ([[
				local header = self:GetParent()
				local ptarget = header:GetChildren():GetName()
				self:SetWidth(%d)
				self:SetHeight(%d)
				for i = 1, 5 do
					if ptarget == "ElvuiDPSPartyUnitButton"..i.."Target" then
						header:GetChildren():SetWidth(%d)
						header:GetChildren():SetHeight(%d)		
					end
				end
			]]):format(party_width, party_height, ptarget_width, ptarget_height),			
			"showParty", true, 
			"showPlayer", C["raidframes"].showplayerinparty, 
			"showRaid", true, 
			"showSolo", false,
			"yOffset", DB.Scale(-27),
			'template', 'DPSPartyTarget'
		)	
	end
	party:SetPoint("BOTTOMLEFT", ChatLBackground2, "TOPLEFT", DB.Scale(2), DB.Scale(40))
	
	
	local partyToggle = CreateFrame("Frame")
	partyToggle:RegisterEvent("PLAYER_ENTERING_WORLD")
	partyToggle:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	partyToggle:SetScript("OnEvent", function(self, event)
		local inInstance, instanceType = IsInInstance()
		local _, _, _, _, maxPlayers, _, _ = GetInstanceInfo()
		if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent("PLAYER_REGEN_ENABLED") end
		if not InCombatLockdown() then
			if inInstance and instanceType == "raid" and maxPlayers ~= 40 then
				ElvuiDPSParty:SetAttribute("showRaid", false)
				ElvuiDPSParty:SetAttribute("showParty", false)			
			else
				ElvuiDPSParty:SetAttribute("showParty", true)
				ElvuiDPSParty:SetAttribute("showRaid", true)
			end
		else
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
		end
	end)
end)