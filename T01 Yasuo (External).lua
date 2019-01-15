--  _______  _______  ____     __   __  _______  _______  __   __  _______ 
-- |       ||  _    ||    |   |  | |  ||   _   ||       ||  | |  ||       |
-- |_     _|| | |   | |   |   |  |_|  ||  |_|  ||  _____||  | |  ||   _   |
--   |   |  | | |   | |   |   |       ||       || |_____ |  |_|  ||  | |  |
--   |   |  | |_|   | |   |   |_     _||       ||_____  ||       ||  |_|  |
--   |   |  |       | |   |     |   |  |   _   | _____| ||       ||       |
--   |___|  |_______| |___|     |___|  |__| |__||_______||_______||_______|
--
-- Current version: 1.0.8
-- ===============
-- == Changelog ==
-- ===============
-- 1.0.8
-- + Added Under-Turret Logic
-- 1.0.7
-- + Added Pyke Q to spell database
-- + Optimized code
-- 1.0.6.1
-- + Added Q to Flee
-- 1.0.6
-- + Added Flee
-- 1.0.5
-- + Finished spell database
-- 1.0.4
-- + Imported spell database (50% done)
-- + Added W usage and lasthit with Q
-- 1.0.3
-- + Added Auto-Ignite
-- 1.0.2
-- + Added library checker
-- 1.0.1
-- + Added offensive items usage
-- 1.0
-- + Initial release

if FileExist(COMMON_PATH .. "HPred.lua") then
	require 'HPred'
else
	PrintChat("HPred.lua missing!")
end
if FileExist(COMMON_PATH .. "TPred.lua") then
	require 'TPred'
else
	PrintChat("TPred.lua missing!")
end

function EnemiesAround(pos, range)
	local N = 0
	for i = 1,Game.HeroCount() do
		local hero = Game.Hero(i)
		if ValidTarget(hero,range + hero.boundingRadius) and hero.isEnemy and not hero.dead then
			N = N + 1
		end
	end
	return N
end

function GetBestLinearFarmPos(range, width)
	local BestPos = nil
	local MostHit = 0
	for i = 1, Game.MinionCount() do
		local m = Game.Minion(i)
		if m and m.isEnemy and not m.dead then
			local EndPos = myHero.pos + (m.pos - myHero.pos):Normalized() * range
			local Count = MinionsOnLine(myHero.pos, EndPos, width, 300-myHero.team)
			if Count > MostHit then
				MostHit = Count
				BestPos = m.pos
			end
		end
	end
	return BestPos, MostHit
end

function GetDistanceSqr(Pos1, Pos2)
	local Pos2 = Pos2 or myHero.pos
	local dx = Pos1.x - Pos2.x
	local dz = (Pos1.z or Pos1.y) - (Pos2.z or Pos2.y)
	return dx^2 + dz^2
end

function GetDashPos(unit)
	return myHero.pos+(unit.pos-myHero.pos):Normalized()*500
end

function GetDistance(Pos1, Pos2)
	return math.sqrt(GetDistanceSqr(Pos1, Pos2))
end

function GetEnemyHeroes()
	EnemyHeroes = {}
	for i = 1, Game.HeroCount() do
		local Hero = Game.Hero(i)
		if Hero.isEnemy then
			table.insert(EnemyHeroes, Hero)
		end
	end
	return EnemyHeroes
end

function GetHeroByHandle(handle)
	for i = 1, Game.HeroCount() do
		local hr = Game.Hero(i)
		if hr.handle == handle then
			return hr
		end
	end
end

function GetItemSlot(unit, id)
	for i = ITEM_1, ITEM_7 do
		if unit:GetItemData(i).itemID == id then
			return i
		end
	end
	return 0
end

function GetPercentHP(unit)
	return 100*unit.health/unit.maxHealth
end

function GetTarget(range)
	if _G.SDK then
		return _G.SDK.TargetSelector:GetTarget(range, _G.SDK.DAMAGE_TYPE_PHYSICAL);
	else
		return _G.GOS:GetTarget(range,"AD")
	end
end

function GotBuff(unit, buffname)
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff.name == buffname and buff.count > 0 then 
			return buff.count
		end
	end
	return 0
end

function IsImmobile(unit)
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff and (buff.type == 5 or buff.type == 11 or buff.type == 18 or buff.type == 22 or buff.type == 24 or buff.type == 28 or buff.type == 29 or buff.name == "recall") and buff.count > 0 then
			return true
		end
	end
	return false
end

function IsKnocked(unit)
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff and (buff.type == 29 or buff.type == 30 or buff.type == 31) and buff.count > 0 then
			return true
		end
	end
	return false
end

function IsReady(spell)
	return Game.CanUseSpell(spell) == 0
end

function MinionsOnLine(startpos, endpos, width, team)
	local Count = 0
	for i = 1, Game.MinionCount() do
		local m = Game.Minion(i)
		if m and m.team == team and not m.dead then
			local w = width + m.boundingRadius
			local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(startpos, endpos, m.pos)
			if isOnSegment and GetDistanceSqr(pointSegment, m.pos) < w^2 and GetDistanceSqr(startpos, endpos) > GetDistanceSqr(startpos, m.pos) then
				Count = Count + 1
			end
		end
	end
	return Count
end

function Mode()
	if _G.SDK then
		if _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO] then
			return "Combo"
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_HARASS] then
			return "Harass"
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LANECLEAR] then
			return "Clear"
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_FLEE] then
			return "Flee"
		end
	else
		return GOS.GetMode()
	end
end

function IsUnderTurret(unit)
	for i = 1, Game.TurretCount() do
		local turret = Game.Turret(i);
		if turret and turret.isEnemy and turret.valid and turret.health > 0 then
			if GetDistance(unit, turret.pos) <= 850 then
				return true
			end
		end
	end
	return false
end

function ValidTarget(target, range)
	range = range and range or math.huge
	return target ~= nil and target.valid and target.visible and not target.dead and target.distance <= range
end

function VectorPointProjectionOnLineSegment(v1, v2, v)
	local cx, cy, ax, ay, bx, by = v.x, (v.z or v.y), v1.x, (v1.z or v1.y), v2.x, (v2.z or v2.y)
	local rL = ((cx - ax) * (bx - ax) + (cy - ay) * (by - ay)) / ((bx - ax) ^ 2 + (by - ay) ^ 2)
	local pointLine = { x = ax + rL * (bx - ax), y = ay + rL * (by - ay) }
	local rS = rL < 0 and 0 or (rL > 1 and 1 or rL)
	local isOnSegment = rS == rL
	local pointSegment = isOnSegment and pointLine or {x = ax + rS * (bx - ax), y = ay + rS * (by - ay)}
	return pointSegment, pointLine, isOnSegment
end

class "Yasuo"

local HeroIcon = "https://www.mobafire.com/images/avatars/yasuo-classic.png"
local IgniteIcon = "http://pm1.narvii.com/5792/0ce6cda7883a814a1a1e93efa05184543982a1e4_hq.jpg"
local QIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/e/e5/Steel_Tempest.png"
local Q3Icon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/4/4b/Steel_Tempest_3.png"
local WIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/6/61/Wind_Wall.png"
local EIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/f/f8/Sweeping_Blade.png"
local RIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/c/c6/Last_Breath.png"
local ETravel = true
local IS = {}

function Yasuo:Menu()
	self.YasuoMenu = MenuElement({type = MENU, id = "Yasuo", name = "[T01] Yasuo", leftIcon = HeroIcon})
	self.YasuoMenu:MenuElement({id = "Auto", name = "Auto", type = MENU})
	self.YasuoMenu.Auto:MenuElement({id = "UseQ", name = "Use Q [Steel Tempest]", value = true, leftIcon = QIcon})
	self.YasuoMenu.Auto:MenuElement({id = "UseQ3", name = "Use Q3 [Gathering Storm]", value = true, leftIcon = Q3Icon})
	self.YasuoMenu.Auto:MenuElement({id = "UseW", name = "Use W [Wind Wall]", value = true, leftIcon = WIcon})
	
	self.YasuoMenu:MenuElement({id = "Combo", name = "Combo", type = MENU})
	self.YasuoMenu.Combo:MenuElement({id = "UseQ", name = "Use Q [Steel Tempest]", value = true, leftIcon = QIcon})
	self.YasuoMenu.Combo:MenuElement({id = "UseQ3", name = "Use Q3 [Gathering Storm]", value = true, leftIcon = Q3Icon})
	self.YasuoMenu.Combo:MenuElement({id = "UseE", name = "Use E [Sweeping Blade]", value = true, leftIcon = EIcon})
	self.YasuoMenu.Combo:MenuElement({id = "UseR", name = "Use R [Last Breath]", value = true, leftIcon = RIcon})
	self.YasuoMenu.Combo:MenuElement({id = "Turret", name = "Under-Turret Logic", value = false})
	self.YasuoMenu.Combo:MenuElement({id = "X", name = "Minimum Enemies: R", value = 1, min = 0, max = 5, step = 1})
	self.YasuoMenu.Combo:MenuElement({id = "HP", name = "HP-Manager: R", value = 40, min = 0, max = 100, step = 5})
	
	self.YasuoMenu:MenuElement({id = "Harass", name = "Harass", type = MENU})
	self.YasuoMenu.Harass:MenuElement({id = "UseQ", name = "Use Q [Steel Tempest]", value = true, leftIcon = QIcon})
	self.YasuoMenu.Harass:MenuElement({id = "UseQ3", name = "Use Q3 [Gathering Storm]", value = true, leftIcon = Q3Icon})
	self.YasuoMenu.Harass:MenuElement({id = "UseE", name = "Use E [Sweeping Blade]", value = true, leftIcon = EIcon})
	self.YasuoMenu.Harass:MenuElement({id = "Turret", name = "Under-Turret Logic", value = true})
	
	self.YasuoMenu:MenuElement({id = "KillSteal", name = "KillSteal", type = MENU})
	self.YasuoMenu.KillSteal:MenuElement({id = "UseR", name = "Use R [Last Breath]", value = true, leftIcon = RIcon})
	self.YasuoMenu.KillSteal:MenuElement({id = "UseIgnite", name = "Use Ignite", value = true, leftIcon = IgniteIcon})
	
	self.YasuoMenu:MenuElement({id = "LaneClear", name = "LaneClear", type = MENU})
	self.YasuoMenu.LaneClear:MenuElement({id = "UseQ", name = "Use Q [Steel Tempest]", value = true, leftIcon = QIcon})
	self.YasuoMenu.LaneClear:MenuElement({id = "UseQ3", name = "Use Q3 [Gathering Storm]", value = true, leftIcon = Q3Icon})
	self.YasuoMenu.LaneClear:MenuElement({id = "UseE", name = "Use E [Sweeping Blade]", value = false, leftIcon = EIcon})
	
	self.YasuoMenu:MenuElement({id = "LastHit", name = "LastHit", type = MENU})
	self.YasuoMenu.LastHit:MenuElement({id = "UseQ", name = "Use Q [Steel Tempest]", value = false, leftIcon = QIcon})
	self.YasuoMenu.LastHit:MenuElement({id = "UseE", name = "Use E [Sweeping Blade]", value = true, leftIcon = EIcon})
	
	self.YasuoMenu:MenuElement({id = "AntiGapcloser", name = "Anti-Gapcloser", type = MENU})
	self.YasuoMenu.AntiGapcloser:MenuElement({id = "UseQ3", name = "Use Q3 [Gathering Storm]", value = true, leftIcon = Q3Icon})
	self.YasuoMenu.AntiGapcloser:MenuElement({id = "Distance", name = "Distance: Q3", value = 400, min = 25, max = 500, step = 25})
	
	self.YasuoMenu:MenuElement({id = "Flee", name = "Flee", type = MENU})
	self.YasuoMenu.Flee:MenuElement({id = "UseQ", name = "Use Q [Steel Tempest]", value = true, leftIcon = QIcon})
	self.YasuoMenu.Flee:MenuElement({id = "UseE", name = "Use E [Sweeping Blade]", value = true, leftIcon = EIcon})
	
	self.YasuoMenu:MenuElement({id = "HitChance", name = "HitChance", type = MENU})
	self.YasuoMenu.HitChance:MenuElement({id = "HPredHit", name = "HitChance: HPrediction", value = 1, min = 1, max = 5, step = 1})
	self.YasuoMenu.HitChance:MenuElement({id = "TPredHit", name = "HitChance: TPrediction", value = 1, min = 0, max = 5, step = 1})
	
	self.YasuoMenu:MenuElement({id = "Prediction", name = "Prediction", type = MENU})
	self.YasuoMenu.Prediction:MenuElement({id = "PredictionQ", name = "Prediction: Q", drop = {"HPrediction", "TPrediction"}, value = 2})
	self.YasuoMenu.Prediction:MenuElement({id = "PredictionQ3", name = "Prediction: Q3", drop = {"HPrediction", "TPrediction"}, value = 2})
	
	self.YasuoMenu:MenuElement({id = "Drawings", name = "Drawings", type = MENU})
	self.YasuoMenu.Drawings:MenuElement({id = "DrawQE", name = "Draw QE Range", value = true})
	self.YasuoMenu.Drawings:MenuElement({id = "DrawQ3", name = "Draw Q3 Range", value = true})
	self.YasuoMenu.Drawings:MenuElement({id = "DrawW", name = "Draw W Range", value = true})
	self.YasuoMenu.Drawings:MenuElement({id = "DrawR", name = "Draw R Range", value = true})
	self.YasuoMenu.Drawings:MenuElement({id = "DrawAA", name = "Draw Killable AAs", value = true})
	self.YasuoMenu.Drawings:MenuElement({id = "DrawJng", name = "Draw Jungler Info", value = true})
	
	self.YasuoMenu:MenuElement({id = "Items", name = "Items", type = MENU})
	self.YasuoMenu.Items:MenuElement({id = "UseBC", name = "Use Bilgewater Cutlass", value = true})
	self.YasuoMenu.Items:MenuElement({id = "UseBOTRK", name = "Use BOTRK", value = true})
	self.YasuoMenu.Items:MenuElement({id = "UseHG", name = "Use Hextech Gunblade", value = true})
	self.YasuoMenu.Items:MenuElement({id = "UseMS", name = "Use Mercurial Scimitar", value = true})
	self.YasuoMenu.Items:MenuElement({id = "UseQS", name = "Use Quicksilver Sash", value = true})
	self.YasuoMenu.Items:MenuElement({id = "OI", name = "%HP To Use Offensive Items", value = 35, min = 0, max = 100, step = 5})
end

function Yasuo:Spells()
	YasuoQ = {speed = math.huge, range = 475, delay = myHero.attackData.windUpTime, width = 40, collision = false, aoe = true, type = "line"}
	YasuoQ3 = {speed = 1200, range = 1000, delay = myHero.attackData.windUpTime, width = 90, collision = false, aoe = true, type = "line"}
	YasuoW = {range = 400}
	YasuoE = {range = 475}
	YasuoR = {range = 1400}
end

function Yasuo:__init()
	Item_HK = {}
	self:Menu()
	self:Spells()
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("Draw", function() self:Draw() end)
end

function Yasuo:Tick()
	if myHero.dead or Game.IsChatOpen() == true then return end
	target = GetTarget(2000)
	Item_HK[ITEM_1] = HK_ITEM_1
	Item_HK[ITEM_2] = HK_ITEM_2
	Item_HK[ITEM_3] = HK_ITEM_3
	Item_HK[ITEM_4] = HK_ITEM_4
	Item_HK[ITEM_5] = HK_ITEM_5
	Item_HK[ITEM_6] = HK_ITEM_6
	Item_HK[ITEM_7] = HK_ITEM_7
	self:Auto()
	self:WindWall()
	self:KillSteal()
	if Mode() == "Combo" then
		self:Items1()
		self:Items2()
		self:Combo()
	end
	if Mode() == "Harass" then
		self:Harass()
	end
	if Mode() == "Clear" then
		self:LaneClear()
		self:LastHit()
	end
	if Mode() == "Flee" then
		self:Flee()
	end
end

function Yasuo:Items1()
	if target == nil then return end
	if (target.health / target.maxHealth)*100 <= self.YasuoMenu.Items.OI:Value() then
		if self.YasuoMenu.Items.UseBC:Value() then
			if GetItemSlot(myHero, 3144) > 0 and ValidTarget(target, 550) then
				if myHero:GetSpellData(GetItemSlot(myHero, 3144)).currentCd == 0 then
					Control.CastSpell(Item_HK[GetItemSlot(myHero, 3144)], target)
				end
			end
		end
		if self.YasuoMenu.Items.UseBOTRK:Value() then
			if GetItemSlot(myHero, 3153) > 0 and ValidTarget(target, 550) then
				if myHero:GetSpellData(GetItemSlot(myHero, 3153)).currentCd == 0 then
					Control.CastSpell(Item_HK[GetItemSlot(myHero, 3153)], target)
				end
			end
		end
		if self.YasuoMenu.Items.UseHG:Value() then
			if GetItemSlot(myHero, 3146) > 0 and ValidTarget(target, 700) then
				if myHero:GetSpellData(GetItemSlot(myHero, 3146)).currentCd == 0 then
					Control.CastSpell(Item_HK[GetItemSlot(myHero, 3146)], target)
				end
			end
		end
	end
end

function Yasuo:Items2()
	if target == nil then return end
	if self.YasuoMenu.Items.UseMS:Value() then
		if GetItemSlot(myHero, 3139) > 0 then
			if myHero:GetSpellData(GetItemSlot(myHero, 3139)).currentCd == 0 then
				if IsImmobile(myHero) then
					Control.CastSpell(Item_HK[GetItemSlot(myHero, 3139)], myHero)
				end
			end
		end
	end
	if self.YasuoMenu.Items.UseQS:Value() then
		if GetItemSlot(myHero, 3140) > 0 then
			if myHero:GetSpellData(GetItemSlot(myHero, 3140)).currentCd == 0 then
				if IsImmobile(myHero) then
					Control.CastSpell(Item_HK[GetItemSlot(myHero, 3140)], myHero)
				end
			end
		end
	end
end

function Yasuo:Draw()
	if myHero.dead then return end
	if self.YasuoMenu.Drawings.DrawQE:Value() then Draw.Circle(myHero.pos, YasuoQ.range, 1, Draw.Color(255, 0, 191, 255)) end
	if self.YasuoMenu.Drawings.DrawQ3:Value() then Draw.Circle(myHero.pos, YasuoQ3.range, 1, Draw.Color(255, 65, 105, 225)) end
	if self.YasuoMenu.Drawings.DrawW:Value() then Draw.Circle(myHero.pos, YasuoW.range, 1, Draw.Color(255, 30, 144, 255)) end
	if self.YasuoMenu.Drawings.DrawR:Value() then Draw.Circle(myHero.pos, YasuoR.range, 1, Draw.Color(255, 0, 0, 255)) end
	for i, enemy in pairs(GetEnemyHeroes()) do
		if self.YasuoMenu.Drawings.DrawJng:Value() then
			if enemy:GetSpellData(SUMMONER_1).name == "SummonerSmite" or enemy:GetSpellData(SUMMONER_2).name == "SummonerSmite" then
				Smite = true
			else
				Smite = false
			end
			if Smite then
				if enemy.alive then
					if ValidTarget(enemy) then
						if GetDistance(myHero.pos, enemy.pos) > 3000 then
							Draw.Text("Jungler: Visible", 17, myHero.pos2D.x-45, myHero.pos2D.y+10, Draw.Color(0xFF32CD32))
						else
							Draw.Text("Jungler: Near", 17, myHero.pos2D.x-43, myHero.pos2D.y+10, Draw.Color(0xFFFF0000))
						end
					else
						Draw.Text("Jungler: Invisible", 17, myHero.pos2D.x-55, myHero.pos2D.y+10, Draw.Color(0xFFFFD700))
					end
				else
					Draw.Text("Jungler: Dead", 17, myHero.pos2D.x-45, myHero.pos2D.y+10, Draw.Color(0xFF32CD32))
				end
			end
		end
		if self.YasuoMenu.Drawings.DrawAA:Value() then
			if ValidTarget(enemy) then
				AALeft = enemy.health / myHero.totalDamage
				Draw.Text("AA Left: "..tostring(math.ceil(AALeft)), 17, enemy.pos2D.x-38, enemy.pos2D.y+10, Draw.Color(0xFF00BFFF))
			end
		end
	end
end

function Yasuo:UseQ(target)
	if self.YasuoMenu.Prediction.PredictionQ:Value() == 1 then
		local target, aimPosition = HPred:GetReliableTarget(myHero.pos, YasuoQ.range, YasuoQ.delay, YasuoQ.speed, YasuoQ.width, self.YasuoMenu.HitChance.HPredHit:Value(), YasuoQ.collision)
		if target and HPred:IsInRange(myHero.pos, aimPosition, YasuoQ.range) then
			Control.SetCursorPos(aimPosition)
			Control.CastSpell(HK_Q, aimPosition)
		else
			local hitChance, aimPosition = HPred:GetUnreliableTarget(myHero.pos, YasuoQ.range, YasuoQ.delay, YasuoQ.speed, YasuoQ.width, YasuoQ.collision, self.YasuoMenu.HitChance.HPredHit:Value(), nil)
			if hitChance and HPred:IsInRange(myHero.pos, aimPosition, YasuoQ.range) then
				Control.SetCursorPos(aimPosition)
				Control.CastSpell(HK_Q, aimPosition)
			end
		end
	elseif self.YasuoMenu.Prediction.PredictionQ:Value() == 2 then
		local castpos,HitChance, pos = TPred:GetBestCastPosition(target, YasuoQ.delay, YasuoQ.width, YasuoQ.range, YasuoQ.speed, myHero.pos, YasuoQ.collision, YasuoQ.type)
		if (HitChance >= self.YasuoMenu.HitChance.TPredHit:Value() ) then
			Control.SetCursorPos(castpos)
			Control.CastSpell(HK_Q, castpos)
		end
	end
end

function Yasuo:UseQ3(target)
	if self.YasuoMenu.Prediction.PredictionQ3:Value() == 1 then
		local target, aimPosition = HPred:GetReliableTarget(myHero.pos, YasuoQ3.range, YasuoQ3.delay, YasuoQ3.speed, YasuoQ3.width, self.YasuoMenu.HitChance.HPredHit:Value(), YasuoQ3.collision)
		if target and HPred:IsInRange(myHero.pos, aimPosition, YasuoQ3.range) then
			Control.SetCursorPos(aimPosition)
			Control.CastSpell(HK_Q, aimPosition)
		else
			local hitChance, aimPosition = HPred:GetUnreliableTarget(myHero.pos, YasuoQ3.range, YasuoQ3.delay, YasuoQ3.speed, YasuoQ3.width, YasuoQ3.collision, self.YasuoMenu.HitChance.HPredHit:Value(), nil)
			if hitChance and HPred:IsInRange(myHero.pos, aimPosition, YasuoQ3.range) then
				Control.SetCursorPos(aimPosition)
				Control.CastSpell(HK_Q, aimPosition)
			end
		end
	elseif self.YasuoMenu.Prediction.PredictionQ3:Value() == 2 then
		local castpos,HitChance, pos = TPred:GetBestCastPosition(target, YasuoQ3.delay, YasuoQ3.width, YasuoQ3.range, YasuoQ3.speed, myHero.pos, YasuoQ3.collision, YasuoQ3.type)
		if (HitChance >= self.YasuoMenu.HitChance.TPredHit:Value() ) then
			Control.SetCursorPos(castpos)
			Control.CastSpell(HK_Q, castpos)
		end
	end
end

function Yasuo:Auto()
	if target == nil then return end
	if IsReady(_Q) then
		if self.YasuoMenu.Auto.UseQ:Value() then
			if GotBuff(myHero, "YasuoQ3W") == 0 then
				if ValidTarget(target, YasuoQ.range) then
					self:UseQ(target)
				end
			end
		end
		if self.YasuoMenu.Auto.UseQ3:Value() then
			if GotBuff(myHero, "YasuoQ3W") > 0 and ETravel then
				if ValidTarget(target, YasuoQ3.range) then
					self:UseQ3(target)
				end
			end
		end
	end
	for i,antigap in pairs(GetEnemyHeroes()) do
		if IsReady(_Q) and GotBuff(myHero, "YasuoQ3W") > 0 then
			if self.YasuoMenu.AntiGapcloser.UseQ3:Value() then
				if ValidTarget(antigap, self.YasuoMenu.AntiGapcloser.Distance:Value()) then
					self:UseQ3(antigap)
				end
			end
		end
	end
end

local Spells = {
	["Aatrox"] = {"AatroxE"},
	["Ahri"] = {"AhriOrbofDeception", "AhriFoxFire", "AhriSeduce", "AhriTumble"},
	["Akali"] = {"AkaliMota"},
	["Amumu"] = {"BandageToss"},
	["Anivia"] = {"FlashFrostSpell", "Frostbite"},
	["Annie"] = {"Disintegrate"},
	["Ashe"] = {"Volley", "EnchantedCrystalArrow"},
	["AurelionSol"] = {"AurelionSolQ"},
	["Bard"] = {"BardQ"},
	["Blitzcrank"] = {"RocketGrab"},
	["Brand"] = {"BrandQ", "BrandR"},
	["Braum"] = {"BraumQ", "BraumR"},
	["Caitlyn"] = {"CaitlynPiltoverPeacemaker", "CaitlynEntrapment", "CaitlynAceintheHole"},
	["Cassiopeia"] = {"CassiopeiaW", "CassiopeiaTwinFang"},
	["Corki"] = {"PhosphorusBomb", "MissileBarrageMissile", "MissileBarrageMissile2"},
	["Diana"] = {"DianaArc", "DianaOrbs"},
	["DrMundo"] = {"InfectedCleaverMissileCast"},
	["Draven"] = {"DravenDoubleShot", "DravenRCast"},
	["Ekko"] = {"EkkoQ"},
	["Elise"] = {"EliseHumanQ", "EliseHumanE"},
	["Evelynn"] = {"EvelynnQ"},
	["Ezreal"] = {"EzrealMysticShot", "EzrealEssenceFlux", "EzrealArcaneShift", "EzrealTrueshotBarrage"},
	["Fiddlesticks"] = {"FiddlesticksDarkWind"},
	["Fiora"] = {"FioraW"},
	["Fizz"] = {"FizzR"},
	["Galio"] = {"GalioQ"},
	["Gangplank"] = {"GangplankQ"},
	["Gnar"] = {"GnarQMissile", "GnarBigQMissile"},
	["Gragas"] = {"GragasQ", "GragasR"},
	["Graves"] = {"GravesQLineSpell", "GravesSmokeGrenade", "GravesChargeShot"},
	["Hecarim"] = {"HecarimUlt"},
	["Heimerdinger"] = {"HeimerdingerQ", "HeimerdingerW", "HeimerdingerE", "HeimerdingerEUlt"},
	["Illaoi"] = {"IllaoiE"},
	["Irelia"] = {"IreliaR"},
	["Ivern"] = {"IvernQ"},
	["Janna"] = {"HowlingGale", "SowTheWind"},
	["Jayce"] = {"JayceShockBlast", "JayceShockBlastWallMis"},
	["Jhin"] = {"JhinQ", "JhinW", "JhinR"},
	["Jinx"] = {"JinxW", "JinxE", "JinxR"},
	["Kaisa"] = {"KaisaQ", "KaisaW"},
	["Kalista"] = {"KalistaMysticShot"},
	["Karma"] = {"KarmaQ", "KarmaQMantra"},
	["Kassadin"] = {"NullLance"},
	["Katarina"] = {"KatarinaQ", "KatarinaR"},
	["Kayle"] = {"JudicatorReckoning"},
	["Kennen"] = {"KennenShurikenHurlMissile1"},
	["Khazix"] = {"KhazixW", "KhazixWLong"},
	["Kindred"] = {"KindredQ", "KindredE"},
	["Kled"] = {"KledQ", "KledQRider"},
	["KogMaw"] = {"KogMawQ", "KogMawVoidOoze"},
	["Leblanc"] = {"LeblancQ", "LeblancE", "LeblancRQ", "LeblancRE"},
	["Leesin"] = {"BlinkMonkQOne"},
	["Leona"] = {"LeonaZenithBlade"},
	["Lissandra"] = {"LissandraQMissile", "LissandraEMissile"},
	["Lucian"] = {"LucianW", "LucianRMis"},
	["Lulu"] = {"LuluQ", "LuluW"},
	["Lux"] = {"LuxLightBinding", "LuxPrismaticWave", "LuxLightStrikeKugel"},
	["Malphite"] = {"SeismicShard"},
	["Maokai"] = {"MaokaiQ", "MaokaiR"},
	["MissFortune"] = {"MissFortuneRicochetShot", "MissFortuneBulletTime"},
	["Morgana"] = {"DarkBindingMissile"},
	["Nami"] = {"NamiQ", "NamiW", "NamiRMissile"},
	["Nautilus"] = {"NautilusAnchorDragMissile"},
	["Nidalee"] = {"JavelinToss"},
	["Nocturne"] = {"NocturneDuskbringer"},
	["Nunu"] = {"IceBlast"},
	["Olaf"] = {"OlafAxeThrowCast"},
	["Orianna"] = {"OrianaIzunaCommand", "OrianaRedactCommand"},
	["Ornn"] = {"OrnnQ", "OrnnR", "OrnnRCharge"},
	["Pantheon"] = {"PantheonQ"},
	["Poppy"] = {"PoppyRSpell"},
	["Pyke"] = {"PykeQRange"},
	["Quinn"] = {"QuinnQ"},
	["Rakan"] = {"RakanQ"},
	["Reksai"] = {"RekSaiQBurrowed"},
	["Rengar"] = {"RengarE"},
	["Riven"] = {"RivenIzunaBlade"},
	["Rumble"] = {"RumbleGrenade"},
	["Ryze"] = {"RyzeQ", "RyzeE"},
	["Sejuani"] = {"SejuaniE", "SejuaniR"},
	["Shaco"] = {"TwoShivPoison"},
	["Shyvana"] = {"ShyvanaFireball", "ShyvanaFireballDragon2"},
	["Sion"] = {"SionE"},
	["Sivir"] = {"SivirQ"},
	["Skarner"] = {"SkarnerFractureMissile"},
	["Sona"] = {"SonaQ", "SonaR"},
	["Swain"] = {"SwainE"},
	["Syndra"] = {"SyndraR"},
	["TahmKench"] = {"TahmKenchQ"},
	["Taliyah"] = {"TaliyahQ"},
	["Talon"] = {"TalonW", "TalonR"},
	["Teemo"] = {"BlindingDart", "TeemoRCast"},
	["Thresh"] = {"ThreshQInternal"},
	["Tristana"] = {"TristanaE", "TristanaR"},
	["TwistedFate"] = {"WildCards"},
	["Twitch"] = {"TwitchVenomCask"},
	["Urgot"] = {"UrgotQ", "UrgotR"},
	["Varus"] = {"VarusQ", "VarusR"},
	["Vayne"] = {"VayneCondemn", "VayneCondemnMissile"},
	["Veigar"] = {"VeigarBalefulStrike", "VeigarR"},
	["VelKoz"] = {"VelKozQ", "VelkozQMissileSplit", "VelKozW", "VelKozE"},
	["Viktor"] = {"ViktorPowerTransfer", "ViktorDeathRay"},
	["Vladimir"] = {"VladimirE"},
	["Xayah"] = {"XayahQ", "XayahE", "XayahR"},
	["Xerath"] = {"XerathMageSpear"},
	["Yasuo"] = {"YasuoQ3W"},
	["Yorick"] = {"YorickE"},
	["Zac"] = {"ZacQ"},
	["Zed"] = {"ZedQ"},
	["Ziggs"] = {"ZiggsQ", "ZiggsW", "ZiggsE"},
	["Zilean"] = {"ZileanQ", "ZileanQAttachAudio"},
	["Zoe"] = {"ZoeQMissile", "ZoeQRecast", "ZoeE"},
	["Zyra"] = {"ZyraE"},
}

function Yasuo:WindWall()
	for i = 1, Game.HeroCount() do
		local h = Game.Hero(i);
		if h.isEnemy then
			if h.activeSpell.valid and h.activeSpell.range > 0 then
				local t = Spells[h.charName]
				if t then
					for j = 1, #t do
						if h.activeSpell.name == t[j] then
							if IS[h.networkID] == nil then
								IS[h.networkID] = {
								sPos = h.activeSpell.startPos, 
								ePos = h.activeSpell.startPos + Vector(h.activeSpell.startPos, h.activeSpell.placementPos):Normalized() * h.activeSpell.range, 
								radius = h.activeSpell.width or 100, 
								speed = h.activeSpell.speed or 9999, 
								startTime = h.activeSpell.startTime
								}
							end
						end
					end
				end
			end
		end
	end
	for key, v in pairs(IS) do
		local SpellHit = v.sPos + Vector(v.sPos,v.ePos):Normalized() * GetDistance(myHero.pos,v.sPos)
		local SpellPosition = v.sPos + Vector(v.sPos,v.ePos):Normalized() * (v.speed * (Game.Timer() - v.startTime) * 3)
		local dodge = SpellPosition + Vector(v.sPos,v.ePos):Normalized() * (v.speed * 0.1)
		if GetDistanceSqr(SpellHit,SpellPosition) <= GetDistanceSqr(dodge,SpellPosition) and GetDistance(SpellHit,v.sPos) - v.radius - myHero.boundingRadius <= GetDistance(v.sPos,v.ePos) then
			if GetDistanceSqr(myHero.pos,SpellHit) < (v.radius + myHero.boundingRadius) ^ 2 then
				if IsReady(_W) then
					local castPos = myHero.pos + Vector(myHero.pos,v.sPos):Normalized() * 100
					Control.CastSpell(HK_W, castPos)
				end
			end
		end
		if (GetDistanceSqr(SpellPosition,v.sPos) >= GetDistanceSqr(v.sPos,v.ePos)) then
			IS[key] = nil
		end
	end
end

function Yasuo:Combo()
	if target == nil then return end
	if self.YasuoMenu.Combo.UseQ:Value() then
		if IsReady(_Q) and myHero.attackData.state ~= STATE_WINDUP then
			if GotBuff(myHero, "YasuoQ3W") == 0 then
				if ValidTarget(target, YasuoQ.range) then
					self:UseQ(target)
				end
			end
		end
	end
	if self.YasuoMenu.Combo.UseQ3:Value() then
		if IsReady(_Q) and myHero.attackData.state ~= STATE_WINDUP then
			if GotBuff(myHero, "YasuoQ3W") > 0 and ETravel then
				if ValidTarget(target, YasuoQ3.range) then
					self:UseQ3(target)
				end
			end
		end
	end
	if self.YasuoMenu.Combo.UseE:Value() then
		if IsReady(_E) then
			if GetDistance(target.pos) < YasuoE.range and GetDistance(target.pos) > myHero.range then
				if GotBuff(target, "YasuoDashWrapper") == 0 then
					if self.YasuoMenu.Combo.Turret:Value() then
						if not IsUnderTurret(GetDashPos(target)) then
							Control.CastSpell(HK_E, target)
						end
					else
						Control.CastSpell(HK_E, target)
					end
				end
			elseif GetDistance(target.pos) < YasuoE.range+1300 and GetDistance(target.pos) > myHero.range then
				for i = 1, Game.MinionCount() do
					local minion = Game.Minion(i)
					if minion and minion.isEnemy then
						if GetDistance(minion.pos) <= YasuoE.range and GotBuff(minion, "YasuoDashWrapper") == 0 then
							local pointSegment,pointLine,isOnSegment = VectorPointProjectionOnLineSegment(myHero.pos, target.pos, minion.pos)
							if isOnSegment and GetDistance(pointSegment, minion.pos) < 300 then
								if self.YasuoMenu.Combo.Turret:Value() then
									if not IsUnderTurret(GetDashPos(minion)) then
										ETravel = false
										Control.CastSpell(HK_E, minion)
										DelayAction(function() ETravel = true end, 0.85)
									end
								else
									ETravel = false
									Control.CastSpell(HK_E, minion)
									DelayAction(function() ETravel = true end, 0.85)
								end
							end
						end
					end
				end
			end
		end
	end
	if self.YasuoMenu.Combo.UseR:Value() then
		if IsReady(_R) then
			if ValidTarget(target, YasuoR.range) and IsKnocked(target) then
				if GetPercentHP(target) < self.YasuoMenu.Combo.HP:Value() then
					if EnemiesAround(myHero, YasuoR.range) >= self.YasuoMenu.Combo.X:Value() then
						Control.CastSpell(HK_R, target)
					end
				end
			end
		end
	end
end

function Yasuo:Harass()
	if target == nil then return end
	if self.YasuoMenu.Harass.UseQ:Value() then
		if IsReady(_Q) and myHero.attackData.state ~= STATE_WINDUP then
			if GotBuff(myHero, "YasuoQ3W") == 0 then
				if ValidTarget(target, YasuoQ.range) then
					self:UseQ(target)
				end
			end
		end
	end
	if self.YasuoMenu.Harass.UseQ3:Value() then
		if IsReady(_Q) and myHero.attackData.state ~= STATE_WINDUP then
			if GotBuff(myHero, "YasuoQ3W") > 0 and ETravel then
				if ValidTarget(target, YasuoQ3.range) then
					self:UseQ3(target)
				end
			end
		end
	end
	if self.YasuoMenu.Harass.UseE:Value() then
		if IsReady(_E) then
			if GetDistance(target.pos) < YasuoE.range and GetDistance(target.pos) > myHero.range then
				if GotBuff(target, "YasuoDashWrapper") == 0 then
					if self.YasuoMenu.Harass.Turret:Value() then
						if not IsUnderTurret(GetDashPos(target)) then
							Control.CastSpell(HK_E, target)
						end
					else
						Control.CastSpell(HK_E, target)
					end
				end
			elseif GetDistance(target.pos) < YasuoE.range+1300 and GetDistance(target.pos) > myHero.range then
				for i = 1, Game.MinionCount() do
					local minion = Game.Minion(i)
					if minion and minion.isEnemy then
						if GetDistance(minion.pos) <= YasuoE.range and GotBuff(minion, "YasuoDashWrapper") == 0 then
							local pointSegment,pointLine,isOnSegment = VectorPointProjectionOnLineSegment(myHero.pos, target.pos, minion.pos)
							if isOnSegment and GetDistance(pointSegment, minion.pos) < 300 then
								if self.YasuoMenu.Harass.Turret:Value() then
									if not IsUnderTurret(GetDashPos(minion)) then
										ETravel = false
										Control.CastSpell(HK_E, minion)
										DelayAction(function() ETravel = true end, 0.85)
									end
								else
									ETravel = false
									Control.CastSpell(HK_E, minion)
									DelayAction(function() ETravel = true end, 0.85)
								end
							end
						end
					end
				end
			end
		end
	end
end

function Yasuo:KillSteal()
	for i,enemy in pairs(GetEnemyHeroes()) do
		if self.YasuoMenu.KillSteal.UseR:Value() then
			if IsReady(_R) then
				if ValidTarget(enemy, YasuoR.range) and IsKnocked(enemy) then
					local YasuoRDmg = (({200, 300, 400})[myHero:GetSpellData(_R).level] + 1.5 * myHero.bonusDamage)
					if (enemy.health + enemy.hpRegen * 6 + enemy.armor) < YasuoRDmg then
						Control.CastSpell(HK_R, target)
					end
				end
			end
		end
		if self.YasuoMenu.KillSteal.UseIgnite:Value() then
			local IgniteDmg = (55 + 25 * myHero.levelData.lvl)
			if ValidTarget(enemy, 600) and enemy.health + enemy.shieldAD < IgniteDmg then
				if myHero:GetSpellData(SUMMONER_1).name == "SummonerDot" and IsReady(SUMMONER_1) then
					Control.CastSpell(HK_SUMMONER_1, enemy)
				elseif myHero:GetSpellData(SUMMONER_2).name == "SummonerDot" and IsReady(SUMMONER_2) then
					Control.CastSpell(HK_SUMMONER_2, enemy)
				end
			end
		end
	end
end

function Yasuo:LaneClear()
	if self.YasuoMenu.LaneClear.UseQ3:Value() then
		if IsReady(_Q) and GotBuff(myHero, "YasuoQ3W") > 0 then
			local BestPos, BestHit = GetBestLinearFarmPos(YasuoQ3.range, YasuoQ3.width)
			if BestPos and BestHit >= 3 then
				Control.CastSpell(HK_Q, BestPos)
			end
		end
	end
	for i = 1, Game.MinionCount() do
		local minion = Game.Minion(i)
		if minion and minion.isEnemy then
			if self.YasuoMenu.LaneClear.UseQ:Value() then
				if IsReady(_Q) and GotBuff(myHero, "YasuoQ3W") == 0 then
					if ValidTarget(minion, YasuoQ.range) then
						Control.CastSpell(HK_Q, minion)
					end
				end
			end
			if self.YasuoMenu.LaneClear.UseE:Value() then
				if IsReady(_E) and GotBuff(minion, "YasuoDashWrapper") == 0 then
					if ValidTarget(minion, YasuoE.range) then
						Control.CastSpell(HK_E, minion)
					end
				end
			end
		end
	end
end

function Yasuo:LastHit()
	for i = 1, Game.MinionCount() do
		local minion = Game.Minion(i)
		if minion and minion.isEnemy then
			if self.YasuoMenu.LastHit.UseQ:Value() then
				if IsReady(_Q) and GotBuff(myHero, "YasuoQ3W") == 0 then
					if ValidTarget(minion, YasuoQ.range) then
						local YasuoQDmg = ((({20, 45, 70, 95, 120})[myHero:GetSpellData(_Q).level]) + myHero.totalDamage)
						if minion.health < YasuoQDmg then
							Control.CastSpell(HK_Q, minion)
						end
					end
				end
			end
			if self.YasuoMenu.LastHit.UseE:Value() then
				if IsReady(_E) then
					if ValidTarget(minion, YasuoE.range) and GotBuff(minion, "YasuoDashWrapper") == 0 then
						local YasuoEDmg = ((({60, 70, 80, 90, 100})[myHero:GetSpellData(_E).level]) + 0.2 * myHero.bonusDamage)
						if minion.health < YasuoEDmg then
							Control.CastSpell(HK_E, minion)
						end
					end
				end
			end
		end
	end
end

function Yasuo:Flee()
	if self.YasuoMenu.Flee.UseE:Value() then
		for i = 1, Game.MinionCount() do
			local minion = Game.Minion(i)
			if minion and minion.isEnemy then
				if GetDistance(minion.pos) <= YasuoE.range and GotBuff(minion, "YasuoDashWrapper") == 0 then
					if IsReady(_Q) and IsReady(_E) then
						if GotBuff(myHero, "YasuoQ3W") == 0 then
							Control.CastSpell(HK_E, mousePos)
							Control.CastSpell(HK_Q)
						end
					elseif IsReady(_E) then
						Control.CastSpell(HK_E, mousePos)
					end
				end
			end
		end
	end
end

function OnLoad()
	Yasuo()
end
