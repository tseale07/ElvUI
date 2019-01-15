local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

local NP = E:GetModule('NamePlates')

function NP:Construct_Castbar(nameplate)
	local Castbar = CreateFrame('StatusBar', nameplate:GetDebugName()..'Castbar', nameplate)
	Castbar:SetFrameStrata(nameplate:GetFrameStrata())
	Castbar:SetFrameLevel(6)
	Castbar:CreateBackdrop('Transparent')
	Castbar:SetStatusBarTexture(E.LSM:Fetch('statusbar', self.db.statusbar))
	NP.StatusBars[Castbar] = true

	Castbar.Button = CreateFrame('Frame', nil, Castbar)
	Castbar.Button:SetTemplate()

	Castbar.Icon = Castbar.Button:CreateTexture(nil, 'ARTWORK')
	Castbar.Icon:SetInside()
	Castbar.Icon:SetTexCoord(unpack(E.TexCoords))

	Castbar.Time = Castbar:CreateFontString(nil, 'OVERLAY')
	Castbar.Time:SetPoint('RIGHT', Castbar, 'RIGHT', -4, 0)
	Castbar.Time:SetJustifyH('RIGHT')
	Castbar.Time:SetFont(E.LSM:Fetch('font', self.db.font), self.db.fontSize, self.db.fontOutline)

	Castbar.Text = Castbar:CreateFontString(nil, 'OVERLAY')
	Castbar.Text:SetJustifyH('LEFT')
	Castbar.Text:SetFont(E.LSM:Fetch('font', self.db.font), self.db.fontSize, self.db.fontOutline)

	function Castbar:CheckInterrupt(unit)
		if (unit == 'vehicle') then
			unit = 'player'
		end

		if (self.notInterruptible and UnitCanAttack('player', unit)) then
			self:SetStatusBarColor(NP.db.colors.castNoInterruptColor.r, NP.db.colors.castNoInterruptColor.g, NP.db.colors.castNoInterruptColor.b, .7)
		else
			self:SetStatusBarColor(NP.db.colors.castColor.r, NP.db.colors.castColor.g, NP.db.colors.castColor.b, .7)
		end
	end

	function Castbar:PostCastStart(unit)
		self:CheckInterrupt(unit)
	end

	function Castbar:PostCastInterruptible(unit)
		self:CheckInterrupt(unit)
	end

	function Castbar:PostCastNotInterruptible(unit)
		self:CheckInterrupt(unit)
	end

	function Castbar:PostChannelStart(unit)
		self:CheckInterrupt(unit)
	end

	return Castbar
end

function NP:Update_Castbar(nameplate)
	local db = NP.db.units[nameplate.frameType]

	if db.castbar.enable then
		nameplate:EnableElement('Castbar')

		nameplate.Castbar.timeToHold = db.castbar.timeToHold
		nameplate.Castbar:SetSize(db.castbar.width, db.castbar.height)
		nameplate.Castbar:SetPoint('TOPLEFT', nameplate, 'BOTTOMLEFT', 0, -20) -- need option

		if db.castbar.showIcon then
			nameplate.Castbar.Button:Show()
			nameplate.Castbar.Button:SetSize(db.castbar.iconSize, db.castbar.iconSize)
			nameplate.Castbar.Button:ClearAllPoints()
			nameplate.Castbar.Button:SetPoint(db.castbar.iconPosition == 'RIGHT' and 'LEFT' or 'RIGHT', nameplate.Castbar, db.castbar.iconPosition == 'RIGHT' and 'RIGHT' or 'LEFT', db.castbar.iconOffsetX, db.castbar.iconOffsetY)
		else
			nameplate.Castbar.Button:Hide()
		end

		nameplate.Castbar.Time:SetPoint('RIGHT', nameplate.Castbar, 'RIGHT', -4, 0)
		nameplate.Castbar.Text:SetPoint('LEFT', nameplate.Castbar, 'LEFT', 4, 0) -- need option
	else
		nameplate:DisableElement('Castbar')
	end
end