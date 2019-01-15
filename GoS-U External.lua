--            ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄               ▄         ▄ 
--           ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌             ▐░▌       ▐░▌
--           ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀              ▐░▌       ▐░▌
--           ▐░▌          ▐░▌       ▐░▌▐░▌                       ▐░▌       ▐░▌
--           ▐░▌ ▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌
--           ▐░▌▐░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌
--           ▐░▌ ▀▀▀▀▀▀█░▌▐░▌       ▐░▌ ▀▀▀▀▀▀▀▀▀█░▌ ▀▀▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌
--           ▐░▌       ▐░▌▐░▌       ▐░▌          ▐░▌             ▐░▌       ▐░▌
--           ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌ ▄▄▄▄▄▄▄▄▄█░▌             ▐░█▄▄▄▄▄▄▄█░▌
--           ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌             ▐░░░░░░░░░░░▌
--            ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀               ▀▀▀▀▀▀▀▀▀▀▀
-- ...###.########.##.....##.########.########.########..##....##....###....##.......###..
-- ..##...##........##...##.....##....##.......##.....##.###...##...##.##...##.........##.
-- .##....##.........##.##......##....##.......##.....##.####..##..##...##..##..........##
-- .##....######......###.......##....######...########..##.##.##.##.....##.##..........##
-- .##....##.........##.##......##....##.......##...##...##..####.#########.##..........##
-- ..##...##........##...##.....##....##.......##....##..##...###.##.....##.##.........##.
-- ...###.########.##.....##....##....########.##.....##.##....##.##.....##.########.###..
-- ==================
-- == Introduction ==
-- ==================
-- Current version: 1.0.5.4
-- Intermediate GoS script which supports only ADC champions.
-- Features:
-- + Supports Ashe, Caitlyn, Ezreal, Jinx, Kalista, Vayne
-- + 2 choosable predictions (HPrediction, TPrediction),
-- + 3 managers (Enemies-around, Mana, HP),
-- + Configurable casting settings (Auto, Combo, Harass),
-- + Different types of making combat,
-- + Advanced farm logic (LastHit & LaneClear).
-- + Additional Anti-Gapcloser,
-- + Spell range drawings (circular),
-- + Special damage indicator over HP bar of enemy,
-- + Offensive items usage & stacking tear,
-- + Includes GoS-U Utility
-- (Summoner spells & items usage, Auto-LevelUp, killable AA drawings)
-- ==================
-- == Requirements ==
-- ==================
-- + Orbwalker: GoS, IC
-- + Predictions: HPred, TPred
-- ===============
-- == Changelog ==
-- ===============
-- 1.0.5.4
-- + Fixed error related to GetEnemyHeroes function
-- 1.0.5.3
-- + Added BaseUlt modes
-- + Fixed HPred callback
-- 1.0.5.2
-- + Added GSO support
-- 1.0.5.1
-- + Fixed Harass with Caitlyn W
-- 1.0.5
-- + Added Kaisa
-- 1.0.4.1
-- + Fixed R Cast
-- 1.0.4 BETA
-- + Added Caitlyn
-- 1.0.3 BETA
-- + Added Kalista
-- 1.0.2.3 BETA
-- + Updated calc damage for Patch 8.13
-- + Improved R spell casting
-- + Minor changes
-- 1.0.2.2 BETA
-- + Fixed menu value check
-- 1.0.2.1 BETA
-- + Improved Jinx's spells logic
-- 1.0.2 BETA
-- + Added Vayne
-- 1.0.1 BETA
-- + Added Ezreal
-- + Fixed spell casting
-- 1.0 BETA
-- + Initial release

if FileExist(COMMON_PATH .. "MapPositionGOS.lua") then
	require 'MapPositionGOS'
else
	PrintChat("MapPositionGOS.lua missing!")
end
if FileExist(COMMON_PATH .. "TPred.lua") then
	require 'TPred'
else
	PrintChat("TPred.lua missing!")
end

---------------
-- Functions --
---------------

function CalcMagicalDamage(source, target, amount)
	local mr = target.magicResist
	local value = 100 / (100 + (mr * source.magicPenPercent) - source.magicPen)
	if mr < 0 then
		value = 2 - 100 / (100 - mr)
	elseif (mr * source.magicPenPercent) - source.magicPen < 0 then
		value = 1
	end
	return math.max(0, math.floor(value * amount))
end

function CalcPhysicalDamage(source, target, amount)
	local ArmorPenPercent = source.armorPenPercent
	local ArmorPenFlat = source.armorPen * (0.6 + (0.4 * (target.levelData.lvl / 18))) 
	local BonusArmorPen = source.bonusArmorPenPercent
	if source.type == Obj_AI_Minion then
		ArmorPenPercent = 1
		ArmorPenFlat = 0
		BonusArmorPen = 1
	elseif source.type == Obj_AI_Turret then
		ArmorPenFlat = 0
		BonusArmorPen = 1
		if source.charName:find("3") or source.charName:find("4") then
			ArmorPenPercent = 0.25
		else
			ArmorPenPercent = 0.7
		end	
		if target.type == Obj_AI_Minion then
			amount = amount * 1.25
			if target.charName:find("MinionSiege") then
				amount = amount * 0.7
			end
			return amount
		end
	end
	local armor = target.armor
	local bonusArmor = target.bonusArmor
	local value = 100 / (100 + (armor * ArmorPenPercent) - (bonusArmor * (1 - BonusArmorPen)) - ArmorPenFlat)
	if armor < 0 then
		value = 2 - 100 / (100 - armor)
	elseif (armor * ArmorPenPercent) - (bonusArmor * (1 - BonusArmorPen)) - ArmorPenFlat < 0 then
		value = 1
	end
	return math.max(0, math.floor(value * amount))
end

-- <--
castSpell = {state = 0, tick = GetTickCount(), casting = GetTickCount() - 1000, mouse = mousePos}
function CastSpell(spell, pos, range, delay)
	range = range or math.huge
	delay = delay or 250
	ticker = GetTickCount()
	if castSpell.state == 0 and GetDistance(myHero.pos,pos) < range and ticker - castSpell.casting > delay + Game.Latency() and pos:ToScreen().onScreen then
		castSpell.state = 1
		castSpell.mouse = mousePos
		castSpell.tick = ticker
	end
	if castSpell.state == 1 then
		if ticker - castSpell.tick < Game.Latency() then
			Control.SetCursorPos(pos)
			Control.KeyDown(spell)
			Control.KeyUp(spell)
			castSpell.casting = ticker + delay
			DelayAction(function()
				if castSpell.state == 1 then
					Control.SetCursorPos(castSpell.mouse)
					castSpell.state = 0
				end
			end, Game.Latency()/1000)
		end
		if ticker - castSpell.casting > Game.Latency() then
			Control.SetCursorPos(castSpell.mouse)
			castSpell.state = 0
		end
	end
end
-- --> #Noddy

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

function GetAllyHeroes()
	AllyHeroes = {}
	for i = 1, Game.HeroCount() do
		local Hero = Game.Hero(i)
		if Hero.isAlly and not Hero.isMe then
			table.insert(AllyHeroes, Hero)
		end
	end
	return AllyHeroes
end

function GetBestCircularFarmPos(range, radius)
	local BestPos = nil
	local MostHit = 0
	for i = 1, Game.MinionCount() do
		local m = Game.Minion(i)
		if m and m.isEnemy and not m.dead then
			local Count = MinionsAround(m.pos, radius, 300-myHero.team)
			if Count > MostHit then
				MostHit = Count
				BestPos = m.pos
			end
		end
	end
	return BestPos, MostHit
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

function GetDistance(Pos1, Pos2)
	return math.sqrt(GetDistanceSqr(Pos1, Pos2))
end

function GetEnemyHeroes(range)
	local range = range or math.huge
	EnemyHeroes = {}
	for i = 1, Game.HeroCount() do
		local Hero = Game.Hero(i)
		if Hero.isEnemy and GetDistance(Hero.pos) <= range then
			table.insert(EnemyHeroes, Hero)
		end
	end
	return EnemyHeroes
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

function GetPercentMana(unit)
	return 100*unit.mana/unit.maxMana
end

function GetTarget(range)
	if _G.SDK then
		return _G.SDK.TargetSelector:GetTarget(range, _G.SDK.DAMAGE_TYPE_PHYSICAL);
	elseif _G.gsoSDK then
		return _G.gsoSDK.TargetSelector:GetTarget(GetEnemyHeroes(5000), false)
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

function IsReady(spell)
	return Game.CanUseSpell(spell) == 0
end

function MinionsAround(pos, range, team)
	local Count = 0
	for i = 1, Game.MinionCount() do
		local m = Game.Minion(i)
		if m and m.team == team and not m.dead and GetDistance(pos, m.pos) <= range then
			Count = Count + 1
		end
	end
	return Count
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
		end
	elseif _G.gsoSDK then
		return _G.gsoSDK.Orbwalker:GetMode()
	else
		return GOS.GetMode()
	end
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

-------------
-- Utility --
-------------

class "GoSuUtility"

function GoSuUtility:__init()
	Callback.Add("Tick", function() self:UtilityTick() end)
	Callback.Add("Draw", function() self:UtilityDraw() end)
	Callback.Add("ProcessRecall", function(unit, recall) self:ProcessRecall(unit, recall) end)
	self:UtilityMenu()
	self.HitTime = 0
	Enemies = {}
	EnemiesData = {}
	Recalling = {}
	Item_HK = {}
	for i = 1, Game.HeroCount() do
		local unit = Game.Hero(i)
		if unit.isMe then
			goto A
		end
		if unit.isEnemy then 
			EnemiesData[unit.networkID] = 0
			table.insert(Enemies, unit)
		end
		::A::
	end
	for i = 1, Game.ObjectCount() do
		local object = Game.Object(i)
		if object.isAlly or object.type ~= Obj_AI_SpawnPoint then 
			goto A
		end
		EnemySpawnPos = object
		break
		::A::
	end
end

function GoSuUtility:UtilityMenu()
	self.UMenu = MenuElement({type = MENU, id = "GoSuUtility", name = "[GoS-U] Utility"})
	self.UMenu:MenuElement({id = "BaseUlt", name = "BaseUlt", type = MENU})
	self.UMenu.BaseUlt:MenuElement({id = "BU", name = "Enable BaseUlt", value = true})
	self.UMenu.BaseUlt:MenuElement({id = "BUM", name = "BaseUlt Mode", drop = {"Cast Spell", "Draw Info"}, value = 2})
	
	self.UMenu:MenuElement({id = "Draws", name = "Draws", type = MENU})
	self.UMenu.Draws:MenuElement({id = "DrawAA", name = "Draw Killable AAs", value = true})
	self.UMenu.Draws:MenuElement({id = "DrawJng", name = "Draw Jungler Info", value = true})
	
	self.UMenu:MenuElement({id = "Items", name = "Items", type = MENU})
	self.UMenu.Items:MenuElement({id = "UseBC", name = "Use Bilgewater Cutlass", value = true})
	self.UMenu.Items:MenuElement({id = "UseBOTRK", name = "Use BOTRK", value = true})
	self.UMenu.Items:MenuElement({id = "UseHG", name = "Use Hextech Gunblade", value = true})
	self.UMenu.Items:MenuElement({id = "UseMS", name = "Use Mercurial Scimitar", value = true})
	self.UMenu.Items:MenuElement({id = "UseQS", name = "Use Quicksilver Sash", value = true})
	self.UMenu.Items:MenuElement({id = "OI", name = "%HP To Use Offensive Items", value = 35, min = 0, max = 100, step = 5})
	
	self.UMenu:MenuElement({id = "SS", name = "Summoner Spells", type = MENU})
	self.UMenu.SS:MenuElement({id = "UseHeal", name = "Use Heal", value = true})
	self.UMenu.SS:MenuElement({id = "UseSave", name = "Save Ally Using Heal", value = true})
	self.UMenu.SS:MenuElement({id = "UseBarrier", name = "Use Barrier", value = true})
	self.UMenu.SS:MenuElement({id = "HealMe", name = "%HP To Use Heal: MyHero", value = 15, min = 0, max = 100, step = 5})
	self.UMenu.SS:MenuElement({id = "HealAlly", name = "%HP To Use Heal: Ally", value = 15, min = 0, max = 100, step = 5})
	self.UMenu.SS:MenuElement({id = "BarrierMe", name = "%HP To Use Barrier", value = 15, min = 0, max = 100, step = 5})
end

function GoSuUtility:UtilityTick()
	target = GetTarget(5000)
	Item_HK[ITEM_1] = HK_ITEM_1
	Item_HK[ITEM_2] = HK_ITEM_2
	Item_HK[ITEM_3] = HK_ITEM_3
	Item_HK[ITEM_4] = HK_ITEM_4
	Item_HK[ITEM_5] = HK_ITEM_5
	Item_HK[ITEM_6] = HK_ITEM_6
	Item_HK[ITEM_7] = HK_ITEM_7
	self:BaseUlt()
	self:Items()
	self:SS()
end

function GoSuUtility:ProcessRecall(unit, recall)
	if not unit.isEnemy then return end
	if recall.isStart then
    	table.insert(Recalling, {object = unit, start = Game.Timer(), duration = (recall.totalTime/1000)})
    else
      	for i, recallunits in pairs(Recalling) do
        	if recallunits.object.networkID == unit.networkID then
          		table.remove(Recalling, i)
        	end
      	end
    end
end

function GetRecallData(unit)
	for i, recall in pairs(Recalling) do
		if recall.object.networkID == unit.networkID then
			return {isRecalling = true, RecallTime = recall.start+recall.duration-Game.Timer()}
		end
	end
	return {isRecalling = false, RecallTime = 0}
end

function GoSuUtility:BaseUlt()
	for i, enemy in pairs(Enemies) do
		if enemy.visible then
			EnemiesData[enemy.networkID] = Game.Timer()
		end
	end
	if not self.UMenu.BaseUlt.BU:Value() or myHero.dead or not IsReady(_R) then return end
	for i, enemy in pairs(Enemies) do
		if enemy.valid and not enemy.dead and GetRecallData(enemy).isRecalling then
			if myHero.charName == "Ashe" then
				local AsheRDmg = CalcMagicalDamage(myHero, enemy, (({200, 400, 600})[myHero:GetSpellData(_R).level] + myHero.ap))
				if AsheRDmg >= (enemy.health + enemy.hpRegen * 20) then
					if self.UMenu.BaseUlt.BUM:Value() == 2 then
						Draw.Text("Recalling "..tostring(enemy.charName).." with "..tostring(math.ceil(enemy.health)).." HP", 19, myHero.pos2D.x-100, myHero.pos2D.y+60, Draw.Color(0xFFFFA500))
					end
					local Distance = enemy.pos:DistanceTo(EnemySpawnPos.pos)
					local Delay = 0.25
					local Speed = 1600
					local HitTime = Distance / Speed + Delay
					local RecallTime = GetRecallData(enemy).RecallTime
					self.HitTime = HitTime
					if RecallTime - HitTime > 0.1 then return end
					if self.UMenu.BaseUlt.BUM:Value() == 1 then
						local CastPos = myHero.pos-(myHero.pos-EnemySpawnPos.pos):Normalized()*300
						CastSpell(HK_R, CastPos, 300, Delay*1000)
					elseif self.UMenu.BaseUlt.BUM:Value() == 2 then
						Draw.Text("Press R on enemy base now!", 19, myHero.pos2D.x-100, myHero.pos2D.y+85, Draw.Color(0xFFFF4500))
					end
					self.HitTime = 0
				end
			elseif myHero.charName == "Ezreal" then
				local EzrealRDmg = CalcMagicalDamage(myHero, enemy, (0.3*(({350, 500, 650})[myHero:GetSpellData(_R).level] + myHero.bonusDamage + 0.9 * myHero.ap)))
				if EzrealRDmg >= (enemy.health + enemy.hpRegen * 20) then
					if self.UMenu.BaseUlt.BUM:Value() == 2 then
						Draw.Text("Recalling "..tostring(enemy.charName).." with "..tostring(math.ceil(enemy.health)).." HP", 19, myHero.pos2D.x-100, myHero.pos2D.y+60, Draw.Color(0xFFFFA500))
					end
					local Distance = enemy.pos:DistanceTo(EnemySpawnPos.pos)
					local Delay = 1
					local Speed = 2000
					local HitTime = Distance / Speed + Delay
					local RecallTime = GetRecallData(enemy).RecallTime
					self.HitTime = HitTime
					if RecallTime - HitTime > 0.1 then return end
					if self.UMenu.BaseUlt.BUM:Value() == 1 then
						local CastPos = myHero.pos-(myHero.pos-EnemySpawnPos.pos):Normalized()*300
						CastSpell(HK_R, CastPos, 300, Delay*1000)
					elseif self.UMenu.BaseUlt.BUM:Value() == 2 then
						Draw.Text("Press R on enemy base now!", 19, myHero.pos2D.x-100, myHero.pos2D.y+85, Draw.Color(0xFFFF4500))
					end
					self.HitTime = 0
				end
			elseif myHero.charName == "Jinx" then
				local JinxRDmg = CalcPhysicalDamage(myHero, enemy, (({250, 350, 450})[myHero:GetSpellData(_R).level] + ({25, 30, 35})[myHero:GetSpellData(_R).level] / 100 * (enemy.maxHealth - enemy.health) + 1.5 * myHero.totalDamage))
				if JinxRDmg >= (enemy.health + enemy.hpRegen * 20) then
					if self.UMenu.BaseUlt.BUM:Value() == 2 then
						Draw.Text("Recalling "..tostring(enemy.charName).." with "..tostring(math.ceil(enemy.health)).." HP", 19, myHero.pos2D.x-100, myHero.pos2D.y+60, Draw.Color(0xFFFFA500))
					end
					local Distance = enemy.pos:DistanceTo(EnemySpawnPos.pos)
					local Delay = 0.6
					local Speed = Distance > 1350 and (2295000 + (Distance - 1350) * 2200) / Distance or 1700
					local HitTime = Distance / Speed + Delay
					local RecallTime = GetRecallData(enemy).RecallTime
					self.HitTime = HitTime
					if RecallTime - HitTime > 0.1 then return end
					if self.UMenu.BaseUlt.BUM:Value() == 1 then
						local CastPos = myHero.pos-(myHero.pos-EnemySpawnPos.pos):Normalized()*300
						CastSpell(HK_R, CastPos, 300, Delay*1000)
					elseif self.UMenu.BaseUlt.BUM:Value() == 2 then
						Draw.Text("Press R on enemy base now!", 19, myHero.pos2D.x-100, myHero.pos2D.y+85, Draw.Color(0xFFFF4500))
					end
					self.HitTime = 0
				end
			end
		end
	end
end

function GoSuUtility:UtilityDraw()
	for i, enemy in pairs(GetEnemyHeroes(25000)) do
		if self.UMenu.Draws.DrawJng:Value() then
			SmiteSlot = (enemy:GetSpellData(SUMMONER_1).name:lower():find("smite") and SUMMONER_1 or (enemy:GetSpellData(SUMMONER_2).name:lower():find("smite") and SUMMONER_2 or nil))
			if SmiteSlot then
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
		if self.UMenu.Draws.DrawAA:Value() then
			if ValidTarget(enemy) then
				AALeft = enemy.health / myHero.totalDamage
				Draw.Text("AA Left: "..tostring(math.ceil(AALeft)), 17, enemy.pos2D.x-38, enemy.pos2D.y+10, Draw.Color(0xFF00BFFF))
			end
		end
	end
end

function GoSuUtility:Items()
	if target == nil then return end
	if EnemiesAround(myHero, 1000) >= 1 then
		if (target.health / target.maxHealth)*100 <= self.UMenu.Items.OI:Value() then
			if self.UMenu.Items.UseBC:Value() then
				if GetItemSlot(myHero, 3144) > 0 and ValidTarget(target, 550) then
					if myHero:GetSpellData(GetItemSlot(myHero, 3144)).currentCd == 0 then
						Control.CastSpell(Item_HK[GetItemSlot(myHero, 3144)], target)
					end
				end
			end
			if self.UMenu.Items.UseBOTRK:Value() then
				if GetItemSlot(myHero, 3153) > 0 and ValidTarget(target, 550) then
					if myHero:GetSpellData(GetItemSlot(myHero, 3153)).currentCd == 0 then
						Control.CastSpell(Item_HK[GetItemSlot(myHero, 3153)], target)
					end
				end
			end
			if self.UMenu.Items.UseHG:Value() then
				if GetItemSlot(myHero, 3146) > 0 and ValidTarget(target, 700) then
					if myHero:GetSpellData(GetItemSlot(myHero, 3146)).currentCd == 0 then
						Control.CastSpell(Item_HK[GetItemSlot(myHero, 3146)], target)
					end
				end
			end
		end
	end
	if self.UMenu.Items.UseMS:Value() then
		if GetItemSlot(myHero, 3139) > 0 then
			if myHero:GetSpellData(GetItemSlot(myHero, 3139)).currentCd == 0 then
				if IsImmobile(myHero) then
					Control.CastSpell(Item_HK[GetItemSlot(myHero, 3139)], myHero)
				end
			end
		end
	end
	if self.UMenu.Items.UseQS:Value() then
		if GetItemSlot(myHero, 3140) > 0 then
			if myHero:GetSpellData(GetItemSlot(myHero, 3140)).currentCd == 0 then
				if IsImmobile(myHero) then
					Control.CastSpell(Item_HK[GetItemSlot(myHero, 3140)], myHero)
				end
			end
		end
	end
end

function GoSuUtility:SS()
	if EnemiesAround(myHero, 2500) >= 1 then
		if self.UMenu.SS.UseHeal:Value() then
			if myHero.alive and myHero.health > 0 and GetPercentHP(myHero) <= self.UMenu.SS.HealMe:Value() then
				if myHero:GetSpellData(SUMMONER_1).name == "SummonerHeal" and IsReady(SUMMONER_1) then
					Control.CastSpell(HK_SUMMONER_1)
				elseif myHero:GetSpellData(SUMMONER_2).name == "SummonerHeal" and IsReady(SUMMONER_2) then
					Control.CastSpell(HK_SUMMONER_2)
				end
				for _, ally in pairs(GetAllyHeroes()) do
					if ValidTarget(ally, 850) then
						if ally.alive and ally.health > 0 and GetPercentHP(ally) <= self.UMenu.SS.HealAlly:Value() then
							if myHero:GetSpellData(SUMMONER_1).name == "SummonerHeal" and IsReady(SUMMONER_1) then
								Control.CastSpell(HK_SUMMONER_1, ally.pos)
							elseif myHero:GetSpellData(SUMMONER_2).name == "SummonerHeal" and IsReady(SUMMONER_2) then
								Control.CastSpell(HK_SUMMONER_2, ally.pos)
							end
						end
					end
				end
			end
		end
		if self.UMenu.SS.UseBarrier:Value() then
			if myHero.alive and myHero.health > 0 and GetPercentHP(myHero) <= self.UMenu.SS.BarrierMe:Value() then
				if myHero:GetSpellData(SUMMONER_1).name == "SummonerBarrier" and IsReady(SUMMONER_1) then
					Control.CastSpell(HK_SUMMONER_2)
				elseif myHero:GetSpellData(SUMMONER_2).name == "SummonerBarrier" and IsReady(SUMMONER_2) then
					Control.CastSpell(HK_SUMMONER_1)
				end
			end
		end
	end
end

class "Ashe"

local HeroIcon = "https://d1u5p3l4wpay3k.cloudfront.net/lolesports_gamepedia_en/4/4a/AsheSquare.png"
local QIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/2/2a/Ranger%27s_Focus_2.png"
local WIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/5/5d/Volley.png"
local RIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/2/28/Enchanted_Crystal_Arrow.png"

function Ashe:Menu()
	self.AsheMenu = MenuElement({type = MENU, id = "Ashe", name = "[GoS-U] Ashe", leftIcon = HeroIcon})
	self.AsheMenu:MenuElement({id = "Auto", name = "Auto", type = MENU})
	self.AsheMenu.Auto:MenuElement({id = "UseW", name = "Use W [Volley]", value = true, leftIcon = WIcon})
	self.AsheMenu.Auto:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	
	self.AsheMenu:MenuElement({id = "Combo", name = "Combo", type = MENU})
	self.AsheMenu.Combo:MenuElement({id = "UseQ", name = "Use Q [Ranger's Focus]", value = true, leftIcon = QIcon})
	self.AsheMenu.Combo:MenuElement({id = "UseW", name = "Use W [Volley]", value = true, leftIcon = WIcon})
	self.AsheMenu.Combo:MenuElement({id = "UseR", name = "Use R [Enchanted Crystal Arrow]", value = true, leftIcon = RIcon})
	self.AsheMenu.Combo:MenuElement({id = "Distance", name = "Distance: R", value = 2000, min = 100, max = 5000, step = 50})
	self.AsheMenu.Combo:MenuElement({id = "X", name = "Minimum Enemies: R", value = 1, min = 0, max = 5, step = 1})
	self.AsheMenu.Combo:MenuElement({id = "HP", name = "HP-Manager: R", value = 40, min = 0, max = 100, step = 5})
	
	self.AsheMenu:MenuElement({id = "Harass", name = "Harass", type = MENU})
	self.AsheMenu.Harass:MenuElement({id = "UseQ", name = "Use Q [Ranger's Focus]", value = true, leftIcon = QIcon})
	self.AsheMenu.Harass:MenuElement({id = "UseW", name = "Use W [Volley]", value = true, leftIcon = WIcon})
	self.AsheMenu.Harass:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	
	self.AsheMenu:MenuElement({id = "KillSteal", name = "KillSteal", type = MENU})
	self.AsheMenu.KillSteal:MenuElement({id = "UseW", name = "Use W [Volley]", value = true, leftIcon = WIcon})
	self.AsheMenu.KillSteal:MenuElement({id = "UseR", name = "Use R [Enchanted Crystal Arrow]", value = true, leftIcon = RIcon})
	self.AsheMenu.KillSteal:MenuElement({id = "Distance", name = "Distance: R", value = 2000, min = 100, max = 5000, step = 50})
	
	self.AsheMenu:MenuElement({id = "LaneClear", name = "LaneClear", type = MENU})
	self.AsheMenu.LaneClear:MenuElement({id = "UseQ", name = "Use Q [Ranger's Focus]", value = true, leftIcon = QIcon})
	self.AsheMenu.LaneClear:MenuElement({id = "UseW", name = "Use W [Volley]", value = true, leftIcon = WIcon})
	self.AsheMenu.LaneClear:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	
	self.AsheMenu:MenuElement({id = "AntiGapcloser", name = "Anti-Gapcloser", type = MENU})
	self.AsheMenu.AntiGapcloser:MenuElement({id = "UseW", name = "Use W [Volley]", value = true, leftIcon = WIcon})
	self.AsheMenu.AntiGapcloser:MenuElement({id = "DistanceW", name = "Distance: W", value = 400, min = 25, max = 500, step = 25})
	
	self.AsheMenu:MenuElement({id = "HitChance", name = "HitChance", type = MENU})
	self.AsheMenu.HitChance:MenuElement({id = "HPredHit", name = "HitChance: HPrediction", value = 1, min = 1, max = 5, step = 1})
	self.AsheMenu.HitChance:MenuElement({id = "TPredHit", name = "HitChance: TPrediction", value = 1, min = 0, max = 5, step = 1})
	
	self.AsheMenu:MenuElement({id = "Prediction", name = "Prediction", type = MENU})
	self.AsheMenu.Prediction:MenuElement({id = "PredictionW", name = "Prediction: W", drop = {"HPrediction", "TPrediction"}, value = 2})
	self.AsheMenu.Prediction:MenuElement({id = "PredictionR", name = "Prediction: R", drop = {"HPrediction", "TPrediction"}, value = 2})
	
	self.AsheMenu:MenuElement({id = "Drawings", name = "Drawings", type = MENU})
	self.AsheMenu.Drawings:MenuElement({id = "DrawW", name = "Draw W Range", value = true})
	self.AsheMenu.Drawings:MenuElement({id = "DrawR", name = "Draw R Range", value = true})
end

function Ashe:Spells()
	AsheW = {speed = 1500, range = 1200, delay = 0.25, width = 20, collision = true, aoe = true, type = "line"}
	AsheR = {speed = 1600, range = 25000, delay = 0.25, width = 130, collision = false, aoe = false, type = "line"}
end

function Ashe:__init()
	self:Menu()
	self:Spells()
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("Draw", function() self:Draw() end)
end

function Ashe:Tick()
	if myHero.dead or Game.IsChatOpen() == true then return end
	self:Auto()
	self:KillSteal()
	self:AntiGapcloser()
	if Mode() == "Combo" then
		self:Combo()
	elseif Mode() == "Harass" then
		self:Harass()
	elseif Mode() == "Clear" then
		self:LaneClear()
	end
end

function Ashe:Draw()
	if myHero.dead then return end
	if self.AsheMenu.Drawings.DrawW:Value() then Draw.Circle(myHero.pos, AsheW.range, 1, Draw.Color(255, 65, 105, 225)) end
	if self.AsheMenu.Drawings.DrawR:Value() then Draw.Circle(myHero.pos, self.AsheMenu.Combo.Distance:Value(), 1, Draw.Color(255, 0, 0, 255)) end
end

function Ashe:UseW(target)
	if self.AsheMenu.Prediction.PredictionW:Value() == 1 then
		local target, aimPosition = HPred:GetReliableTarget(myHero.pos, AsheW.range, AsheW.delay, AsheW.speed, AsheW.width, self.AsheMenu.HitChance.HPredHit:Value(), AsheW.collision)
		if target and HPred:IsInRange(myHero.pos, aimPosition, AsheW.range) then
			Control.CastSpell(HK_W, aimPosition)
		else
			local hitChance, aimPosition = HPred:GetUnreliableTarget(myHero.pos, AsheW.range, AsheW.delay, AsheW.speed, AsheW.width, AsheW.collision, self.AsheMenu.HitChance.HPredHit:Value(), nil)
			if hitChance and HPred:IsInRange(myHero.pos, aimPosition, AsheW.range) then
				Control.CastSpell(HK_W, aimPosition)
			end
		end
	elseif self.AsheMenu.Prediction.PredictionW:Value() == 2 then
		local castpos,HitChance, pos = TPred:GetBestCastPosition(target, AsheW.delay, AsheW.width, AsheW.range, AsheW.speed, myHero.pos, AsheW.collision, AsheW.type)
		if (HitChance >= self.AsheMenu.HitChance.TPredHit:Value() ) then
			Control.CastSpell(HK_W, castpos)
		end
	end
end

function Ashe:UseR(target)
	if self.AsheMenu.Prediction.PredictionR:Value() == 1 then
		local target, aimPosition = HPred:GetReliableTarget(myHero.pos, AsheR.range, AsheR.delay, AsheR.speed, AsheR.width, self.AsheMenu.HitChance.HPredHit:Value(), AsheR.collision)
		if target and HPred:IsInRange(myHero.pos, aimPosition, AsheR.range) then
			local RCastPos = myHero.pos-(myHero.pos-aimPosition):Normalized()*300
			CastSpell(HK_R, RCastPos, 300, AsheR.delay*1000)
		else
			local hitChance, aimPosition = HPred:GetUnreliableTarget(myHero.pos, AsheR.range, AsheR.delay, AsheR.speed, AsheR.width, AsheR.collision, self.AsheMenu.HitChance.HPredHit:Value(), nil)
			if hitChance and HPred:IsInRange(myHero.pos, aimPosition, AsheR.range) then
				local RCastPos = myHero.pos-(myHero.pos-aimPosition):Normalized()*300
				CastSpell(HK_R, RCastPos, 300, AsheR.delay*1000)
			end
		end
	elseif self.AsheMenu.Prediction.PredictionR:Value() == 2 then
		local castpos,HitChance, pos = TPred:GetBestCastPosition(target, AsheR.delay, AsheR.width, AsheR.range, AsheR.speed, myHero.pos, AsheR.collision, AsheR.type)
		if (HitChance >= self.AsheMenu.HitChance.TPredHit:Value() ) then
			local RCastPos = myHero.pos-(myHero.pos-castpos):Normalized()*300
			CastSpell(HK_R, RCastPos, 300, AsheR.delay*1000)
		end
	end
end

function Ashe:Auto()
	if target == nil then return end
	if self.AsheMenu.Auto.UseW:Value() then
		if GetPercentMana(myHero) > self.AsheMenu.Auto.MP:Value() then
			if IsReady(_W) then
				if ValidTarget(target, AsheW.range) then
					self:UseW(target)
				end
			end
		end
	end
end

function Ashe:Combo()
	if target == nil then return end
	if self.AsheMenu.Combo.UseQ:Value() then
		if IsReady(_Q) then
			if ValidTarget(target, myHero.range+100) then
				if GotBuff(myHero, "asheqcastready") == 4 then
					Control.CastSpell(HK_Q)
				end
			end
		end
	end
	if self.AsheMenu.Combo.UseW:Value() then
		if IsReady(_W) and myHero.attackData.state ~= STATE_WINDUP then
			if ValidTarget(target, AsheW.range) then
				self:UseW(target)
			end
		end
	end
	if self.AsheMenu.Combo.UseR:Value() then
		if IsReady(_R) then
			if ValidTarget(target, self.AsheMenu.Combo.Distance:Value()) then
				if GetPercentHP(target) < self.AsheMenu.Combo.HP:Value() then
					if EnemiesAround(myHero, self.AsheMenu.Combo.Distance:Value()+myHero.range) >= self.AsheMenu.Combo.X:Value() then
						self:UseR(target)
					end
				end
			end
		end
	end
end

function Ashe:Harass()
	if target == nil then return end
	if self.AsheMenu.Harass.UseQ:Value() then
		if IsReady(_Q) then
			if ValidTarget(target, myHero.range+100) then
				if GotBuff(myHero, "asheqcastready") == 4 then
					Control.CastSpell(HK_Q)
				end
			end
		end
	end
	if self.AsheMenu.Harass.UseW:Value() then
		if GetPercentMana(myHero) > self.AsheMenu.Harass.MP:Value() then
			if IsReady(_W) and myHero.attackData.state ~= STATE_WINDUP then
				if ValidTarget(target, AsheW.range) then
					self:UseW(target)
				end
			end
		end
	end
end

function Ashe:KillSteal()
	for i,enemy in pairs(GetEnemyHeroes(5000)) do
		if IsReady(_R) then
			if self.AsheMenu.KillSteal.UseR:Value() then
				if ValidTarget(enemy, self.AsheMenu.KillSteal.Distance:Value()) then
					local AsheRDmg = CalcMagicalDamage(myHero, enemy, (({200, 400, 600})[myHero:GetSpellData(_R).level] + myHero.ap))
					if (enemy.health + enemy.hpRegen * 6) < AsheRDmg then
						self:UseR(enemy)
					end
				end
			end
		elseif IsReady(_W) then
			if self.AsheMenu.KillSteal.UseW:Value() then
				if ValidTarget(enemy, AsheW.range) then
					local AsheWDmg = CalcPhysicalDamage(myHero, enemy, (({20, 35, 50, 65, 80})[myHero:GetSpellData(_W).level] + myHero.totalDamage))
					if (enemy.health + enemy.hpRegen * 4) < AsheWDmg then
						self:UseW(enemy)
					end
				end
			end
		end
	end
end

function Ashe:LaneClear()
	if self.AsheMenu.LaneClear.UseW:Value() then
		if GetPercentMana(myHero) > self.AsheMenu.LaneClear.MP:Value() then
			if IsReady(_W) then
				local BestPos, BestHit = GetBestLinearFarmPos(AsheW.range, AsheW.width*9)
				if BestPos and BestHit >= 3 then
					Control.SetCursorPos(BestPos)
					Control.CastSpell(HK_W, BestPos)
				end
			end
		end
	end
	if self.AsheMenu.LaneClear.UseQ:Value() then
		for i = 1, Game.MinionCount() do
			local minion = Game.Minion(i)
			if minion and minion.isEnemy then
				if ValidTarget(minion, myHero.range) then
					if GotBuff(myHero, "asheqcastready") == 4 then
						Control.CastSpell(HK_Q)
					end
				end
			end
		end
	end
end

function Ashe:AntiGapcloser()
	for i,antigap in pairs(GetEnemyHeroes(AsheW.range)) do
		if IsReady(_W) then
			if self.AsheMenu.AntiGapcloser.UseW:Value() then
				if ValidTarget(antigap, self.AsheMenu.AntiGapcloser.DistanceW:Value()) then
					self:UseW(antigap)
				end
			end
		end
	end
end

class "Caitlyn"

local HeroIcon = "https://www.mobafire.com/images/champion/square/caitlyn.png"
local QIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/f/fd/Piltover_Peacemaker.png"
local WIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/0/03/Yordle_Snap_Trap.png"
local EIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/0/0b/90_Caliber_Net.png"
local RIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/a/aa/Ace_in_the_Hole.png"

function Caitlyn:Menu()
	self.CaitlynMenu = MenuElement({type = MENU, id = "Caitlyn", name = "[GoS-U] Caitlyn", leftIcon = HeroIcon})
	self.CaitlynMenu:MenuElement({id = "Auto", name = "Auto", type = MENU})
	self.CaitlynMenu.Auto:MenuElement({id = "UseQ", name = "Use Q [Piltover Peacemaker]", value = true, leftIcon = QIcon})
	self.CaitlynMenu.Auto:MenuElement({id = "UseW", name = "Use W [Yordle Snap Trap]", value = true, leftIcon = WIcon})
	self.CaitlynMenu.Auto:MenuElement({id = "ModeQ", name = "Cast Mode: Q", drop = {"Standard", "On Immobile"}, value = 2})
	self.CaitlynMenu.Auto:MenuElement({id = "ModeW", name = "Cast Mode: W", drop = {"Standard", "On Immobile"}, value = 2})
	self.CaitlynMenu.Auto:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	
	self.CaitlynMenu:MenuElement({id = "Combo", name = "Combo", type = MENU})
	self.CaitlynMenu.Combo:MenuElement({id = "UseQ", name = "Use Q [Piltover Peacemaker]", value = true, leftIcon = QIcon})
	self.CaitlynMenu.Combo:MenuElement({id = "UseW", name = "Use W [Yordle Snap Trap]", value = true, leftIcon = WIcon})
	self.CaitlynMenu.Combo:MenuElement({id = "UseE", name = "Use E [90 Caliber Net]", value = true, leftIcon = EIcon})
	self.CaitlynMenu.Combo:MenuElement({id = "ModeQ", name = "Cast Mode: Q", drop = {"Standard", "On Immobile"}, value = 1})
	self.CaitlynMenu.Combo:MenuElement({id = "ModeW", name = "Cast Mode: W", drop = {"Standard", "On Immobile"}, value = 1})
	
	self.CaitlynMenu:MenuElement({id = "Harass", name = "Harass", type = MENU})
	self.CaitlynMenu.Harass:MenuElement({id = "UseQ", name = "Use Q [Piltover Peacemaker]", value = true, leftIcon = QIcon})
	self.CaitlynMenu.Harass:MenuElement({id = "UseW", name = "Use W [Yordle Snap Trap]", value = true, leftIcon = WIcon})
	self.CaitlynMenu.Harass:MenuElement({id = "UseE", name = "Use E [90 Caliber Net]", value = true, leftIcon = EIcon})
	self.CaitlynMenu.Harass:MenuElement({id = "ModeQ", name = "Cast Mode: Q", drop = {"Standard", "On Immobile"}, value = 1})
	self.CaitlynMenu.Harass:MenuElement({id = "ModeW", name = "Cast Mode: W", drop = {"Standard", "On Immobile"}, value = 2})
	self.CaitlynMenu.Harass:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	
	self.CaitlynMenu:MenuElement({id = "KillSteal", name = "KillSteal", type = MENU})
	self.CaitlynMenu.KillSteal:MenuElement({id = "UseQ", name = "Use Q [Piltover Peacemaker]", value = true, leftIcon = QIcon})
	self.CaitlynMenu.KillSteal:MenuElement({id = "UseR", name = "Draw Killable With R", value = true, leftIcon = RIcon})
	
	self.CaitlynMenu:MenuElement({id = "LaneClear", name = "LaneClear", type = MENU})
	self.CaitlynMenu.LaneClear:MenuElement({id = "UseQ", name = "Use Q [Piltover Peacemaker]", value = false, leftIcon = QIcon})
	self.CaitlynMenu.LaneClear:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	
	self.CaitlynMenu:MenuElement({id = "AntiGapcloser", name = "Anti-Gapcloser", type = MENU})
	self.CaitlynMenu.AntiGapcloser:MenuElement({id = "UseW", name = "Use W [Yordle Snap Trap]", value = true, leftIcon = WIcon})
	self.CaitlynMenu.AntiGapcloser:MenuElement({id = "UseE", name = "Use E [90 Caliber Net]", value = true, leftIcon = EIcon})
	self.CaitlynMenu.AntiGapcloser:MenuElement({id = "DistanceW", name = "Distance: W", value = 300, min = 25, max = 500, step = 25})
	self.CaitlynMenu.AntiGapcloser:MenuElement({id = "DistanceE", name = "Distance: E", value = 300, min = 25, max = 500, step = 25})
	
	self.CaitlynMenu:MenuElement({id = "HitChance", name = "HitChance", type = MENU})
	self.CaitlynMenu.HitChance:MenuElement({id = "HPredHit", name = "HitChance: HPrediction", value = 1, min = 1, max = 5, step = 1})
	self.CaitlynMenu.HitChance:MenuElement({id = "TPredHit", name = "HitChance: TPrediction", value = 1, min = 0, max = 5, step = 1})
	
	self.CaitlynMenu:MenuElement({id = "Prediction", name = "Prediction", type = MENU})
	self.CaitlynMenu.Prediction:MenuElement({id = "PredictionQ", name = "Prediction: Q", drop = {"HPrediction", "TPrediction"}, value = 2})
	self.CaitlynMenu.Prediction:MenuElement({id = "PredictionW", name = "Prediction: W", drop = {"HPrediction", "TPrediction"}, value = 2})
	self.CaitlynMenu.Prediction:MenuElement({id = "PredictionE", name = "Prediction: E", drop = {"HPrediction", "TPrediction"}, value = 2})
	
	self.CaitlynMenu:MenuElement({id = "Drawings", name = "Drawings", type = MENU})
	self.CaitlynMenu.Drawings:MenuElement({id = "DrawQ", name = "Draw Q Range", value = true})
	self.CaitlynMenu.Drawings:MenuElement({id = "DrawW", name = "Draw W Range", value = true})
	self.CaitlynMenu.Drawings:MenuElement({id = "DrawE", name = "Draw E Range", value = true})
	self.CaitlynMenu.Drawings:MenuElement({id = "DrawR", name = "Draw R Range", value = true})
end

function Caitlyn:Spells()
	CaitlynQ = {speed = 2200, range = 1250, delay = 0.625, width = 60, collision = false, aoe = true, type = "line"}
	CaitlynW = {speed = math.huge, range = 800, delay = 0.25, width = 75, collision = false, aoe = false, type = "circular"}
	CaitlynE = {speed = 1600, range = 750, delay = 0.25, width = 70, collision = true, aoe = false, type = "linear"}
	CaitlynR = {range = myHero:GetSpellData(_R).range}
end

function Caitlyn:__init()
	self:Menu()
	self:Spells()
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("Draw", function() self:Draw() end)
end

function Caitlyn:Tick()
	if myHero.dead or Game.IsChatOpen() == true then return end
	self:Auto()
	self:KillSteal()
	self:AntiGapcloser()
	if Mode() == "Combo" then
		self:Combo()
	elseif Mode() == "Harass" then
		self:Harass()
	elseif Mode() == "Clear" then
		self:LaneClear()
	end
end

function Caitlyn:Draw()
	if myHero.dead then return end
	if self.CaitlynMenu.Drawings.DrawQ:Value() then Draw.Circle(myHero.pos, CaitlynQ.range, 1, Draw.Color(255, 0, 191, 255)) end
	if self.CaitlynMenu.Drawings.DrawW:Value() then Draw.Circle(myHero.pos, CaitlynW.range, 1, Draw.Color(255, 65, 105, 225)) end
	if self.CaitlynMenu.Drawings.DrawE:Value() then Draw.Circle(myHero.pos, CaitlynE.range, 1, Draw.Color(255, 30, 144, 255)) end
	if self.CaitlynMenu.Drawings.DrawR:Value() then Draw.Circle(myHero.pos, CaitlynR.range, 1, Draw.Color(255, 0, 0, 255)) end
end

function Caitlyn:UseQ(target)
	if self.CaitlynMenu.Prediction.PredictionQ:Value() == 1 then
		local target, aimPosition = HPred:GetReliableTarget(myHero.pos, CaitlynQ.range, CaitlynQ.delay, CaitlynQ.speed, CaitlynQ.width, self.CaitlynMenu.HitChance.HPredHit:Value(), CaitlynQ.collision)
		if target and HPred:IsInRange(myHero.pos, aimPosition, CaitlynQ.range) then
			Control.CastSpell(HK_Q, aimPosition)
		else
			local hitChance, aimPosition = HPred:GetUnreliableTarget(myHero.pos, CaitlynQ.range, CaitlynQ.delay, CaitlynQ.speed, CaitlynQ.width, CaitlynQ.collision, self.CaitlynMenu.HitChance.HPredHit:Value(), nil)
			if hitChance and HPred:IsInRange(myHero.pos, aimPosition, CaitlynQ.range) then
				Control.CastSpell(HK_Q, aimPosition)
			end
		end
	elseif self.CaitlynMenu.Prediction.PredictionQ:Value() == 2 then
		local castpos,HitChance, pos = TPred:GetBestCastPosition(target, CaitlynQ.delay, CaitlynQ.width, CaitlynQ.range, CaitlynQ.speed, myHero.pos, CaitlynQ.collision, CaitlynQ.type)
		if (HitChance >= self.CaitlynMenu.HitChance.TPredHit:Value() ) then
			Control.CastSpell(HK_Q, castpos)
		end
	end
end

function Caitlyn:UseW(target)
	if self.CaitlynMenu.Prediction.PredictionW:Value() == 1 then
		local target, aimPosition = HPred:GetReliableTarget(myHero.pos, CaitlynW.range, CaitlynW.delay, CaitlynW.speed, CaitlynW.width, self.CaitlynMenu.HitChance.HPredHit:Value(), CaitlynW.collision)
		if target and HPred:IsInRange(myHero.pos, aimPosition, CaitlynW.range) then
			Control.CastSpell(HK_W, aimPosition)
		else
			local hitChance, aimPosition = HPred:GetUnreliableTarget(myHero.pos, CaitlynW.range, CaitlynW.delay, CaitlynW.speed, CaitlynW.width, CaitlynW.collision, self.CaitlynMenu.HitChance.HPredHit:Value(), nil)
			if hitChance and HPred:IsInRange(myHero.pos, aimPosition, CaitlynW.range) then
				Control.CastSpell(HK_W, aimPosition)
			end
		end
	elseif self.CaitlynMenu.Prediction.PredictionW:Value() == 2 then
		local castpos,HitChance, pos = TPred:GetBestCastPosition(target, CaitlynW.delay, CaitlynW.width, CaitlynW.range, CaitlynW.speed, myHero.pos, CaitlynW.collision, CaitlynW.type)
		if (HitChance >= self.CaitlynMenu.HitChance.TPredHit:Value() ) then
			Control.CastSpell(HK_W, castpos)
		end
	end
end

function Caitlyn:UseE(target)
	if self.CaitlynMenu.Prediction.PredictionE:Value() == 1 then
		local target, aimPosition = HPred:GetReliableTarget(myHero.pos, CaitlynE.range, CaitlynE.delay, CaitlynE.speed, CaitlynE.width, self.CaitlynMenu.HitChance.HPredHit:Value(), CaitlynE.collision)
		if target and HPred:IsInRange(myHero.pos, aimPosition, CaitlynE.range) then
			Control.CastSpell(HK_E, aimPosition)
		else
			local hitChance, aimPosition = HPred:GetUnreliableTarget(myHero.pos, CaitlynE.range, CaitlynE.delay, CaitlynE.speed, CaitlynE.width, CaitlynE.collision, self.CaitlynMenu.HitChance.HPredHit:Value(), nil)
			if hitChance and HPred:IsInRange(myHero.pos, aimPosition, CaitlynE.range) then
				Control.CastSpell(HK_E, aimPosition)
			end
		end
	elseif self.CaitlynMenu.Prediction.PredictionE:Value() == 2 then
		local castpos,HitChance, pos = TPred:GetBestCastPosition(target, CaitlynE.delay, CaitlynE.width, CaitlynE.range, CaitlynE.speed, myHero.pos, CaitlynE.collision, CaitlynE.type)
		if (HitChance >= self.CaitlynMenu.HitChance.TPredHit:Value() ) then
			Control.CastSpell(HK_E, castpos)
		end
	end
end

function Caitlyn:Auto()
	if target == nil then return end
	if GetPercentMana(myHero) > self.CaitlynMenu.Auto.MP:Value() then
		if self.CaitlynMenu.Auto.UseQ:Value() then
			if IsReady(_Q) then
				if ValidTarget(target, CaitlynQ.range) then
					if self.CaitlynMenu.Auto.ModeQ:Value() == 1 then
						self:UseQ(target)
					elseif self.CaitlynMenu.Auto.ModeQ:Value() == 2 then
						if IsImmobile(target) then
							self:UseQ(target)
						end
					end
				end
			end
		end
		if self.CaitlynMenu.Auto.UseW:Value() then
			if IsReady(_W) then
				if ValidTarget(target, CaitlynW.range) then
					if self.CaitlynMenu.Auto.ModeW:Value() == 1 then
						self:UseW(target)
					elseif self.CaitlynMenu.Auto.ModeW:Value() == 2 then
						if IsImmobile(target) then
							self:UseW(target)
						end
					end
				end
			end
		end
	end
end

function Caitlyn:Combo()
	if target == nil then return end
	if self.CaitlynMenu.Combo.UseQ:Value() then
		if IsReady(_Q) and myHero.attackData.state ~= STATE_WINDUP then
			if ValidTarget(target, CaitlynQ.range) then
				if self.CaitlynMenu.Combo.ModeQ:Value() == 1 then
					self:UseQ(target)
				elseif self.CaitlynMenu.Combo.ModeQ:Value() == 2 then
					if IsImmobile(target) then
						self:UseQ(target)
					end
				end
			end
		end
	end
	if self.CaitlynMenu.Combo.UseW:Value() then
		if IsReady(_W) and myHero.attackData.state ~= STATE_WINDUP then
			if ValidTarget(target, CaitlynW.range) then
				if self.CaitlynMenu.Combo.ModeW:Value() == 1 then
					self:UseW(target)
				elseif self.CaitlynMenu.Combo.ModeW:Value() == 2 then
					if IsImmobile(target) then
						self:UseW(target)
					end
				end
			end
		end
	end
	if self.CaitlynMenu.Combo.UseE:Value() then
		if IsReady(_E) and myHero.attackData.state ~= STATE_WINDUP then
			if ValidTarget(target, CaitlynE.range) then
				self:UseE(target)
			elseif ValidTarget(target, CaitlynE.range+400) then
				local EPos = Vector(myHero.pos)+(Vector(myHero.pos)-Vector(target.pos))
				Control.CastSpell(HK_E, EPos)
			end
		end
	end
end

function Caitlyn:Harass()
	if target == nil then return end
	if GetPercentMana(myHero) > self.CaitlynMenu.Harass.MP:Value() then
		if self.CaitlynMenu.Harass.UseQ:Value() then
			if IsReady(_Q) and myHero.attackData.state ~= STATE_WINDUP then
				if ValidTarget(target, CaitlynQ.range) then
					if self.CaitlynMenu.Harass.ModeQ:Value() == 1 then
						self:UseQ(target)
					elseif self.CaitlynMenu.Harass.ModeQ:Value() == 2 then
						if IsImmobile(target) then
							self:UseQ(target)
						end
					end
				end
			end
		end
		if self.CaitlynMenu.Harass.UseW:Value() then
			if IsReady(_W) and myHero.attackData.state ~= STATE_WINDUP then
				if ValidTarget(target, CaitlynW.range) then
					if self.CaitlynMenu.Harass.ModeW:Value() == 1 then
						self:UseW(target)
					elseif self.CaitlynMenu.Harass.ModeW:Value() == 2 then
						if IsImmobile(target) then
							self:UseW(target)
						end
					end
				end
			end
		end
		if self.CaitlynMenu.Harass.UseE:Value() then
			if IsReady(_E) and myHero.attackData.state ~= STATE_WINDUP then
				if ValidTarget(target, CaitlynE.range) then
					self:UseE(target)
				elseif ValidTarget(target, CaitlynE.range+400) then
					local EPos = Vector(myHero.pos)+(Vector(myHero.pos)-Vector(target.pos))
					Control.CastSpell(HK_E, EPos)
				end
			end
		end
	end
end

function Caitlyn:KillSteal()
	for i,enemy in pairs(GetEnemyHeroes(CaitlynR.range)) do
		if IsReady(_Q) then
			if self.CaitlynMenu.KillSteal.UseQ:Value() then
				if ValidTarget(enemy, CaitlynQ.range) then
					local CaitlynQDmg = CalcPhysicalDamage(myHero, enemy, ((({20.1, 46.9, 73.7, 100.5, 127.3})[myHero:GetSpellData(_Q).level]) + ((0.067 * myHero:GetSpellData(_Q).level + 0.804) * myHero.totalDamage)))
					if (enemy.health + enemy.hpRegen * 4) < CaitlynQDmg then
						self:UseQ(enemy)
					end
				end
			end
		elseif IsReady(_R) then
			if self.CaitlynMenu.KillSteal.UseR:Value() then
				if ValidTarget(enemy, CaitlynR.range) then
					local CaitlynRDmg = CalcPhysicalDamage(myHero, enemy, ((({250, 475, 700})[myHero:GetSpellData(_R).level]) + (2 * myHero.bonusDamage)))
					if (enemy.health + enemy.hpRegen * 4) < CaitlynRDmg then
						Draw.Circle(enemy.pos, 100, 5, Draw.Color(255, 255, 215, 0))
					end
				end
			end
		end
	end
end

function Caitlyn:LaneClear()
	if self.CaitlynMenu.LaneClear.UseQ:Value() then
		if GetPercentMana(myHero) > self.CaitlynMenu.LaneClear.MP:Value() then
			if IsReady(_Q) then
				local BestPos, BestHit = GetBestLinearFarmPos(CaitlynQ.range, CaitlynQ.width)
				if BestPos and BestHit >= 4 then
					Control.SetCursorPos(BestPos)
					Control.CastSpell(HK_Q, BestPos)
				end
			end
		end
	end
end

function Caitlyn:AntiGapcloser()
	for i,antigap in pairs(GetEnemyHeroes(CaitlynW.range)) do
		if IsReady(_E) then
			if self.CaitlynMenu.AntiGapcloser.UseE:Value() then
				if ValidTarget(antigap, self.CaitlynMenu.AntiGapcloser.DistanceE:Value()) then
					local EPos = Vector(myHero.pos)+(Vector(myHero.pos)-Vector(antigap.pos))
					Control.CastSpell(HK_E, EPos)
				end
			end
		elseif IsReady(_W) then
			if self.CaitlynMenu.AntiGapcloser.UseW:Value() then
				if ValidTarget(antigap, self.CaitlynMenu.AntiGapcloser.DistanceW:Value()) then
					self:UseW(antigap)
				end
			end
		end
	end
end

class "Ezreal"

local HeroIcon = "http://i1.17173cdn.com/1tx6lh/YWxqaGBf/images/hero/ezreal_square_0.jpg"
local QIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/5/5a/Mystic_Shot.png"
local WIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/9/9e/Essence_Flux.png"
local EIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/f/fb/Arcane_Shift.png"
local RIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/0/02/Trueshot_Barrage.png"

function Ezreal:Menu()
	self.EzrealMenu = MenuElement({type = MENU, id = "Ezreal", name = "[GoS-U] Ezreal", leftIcon = HeroIcon})
	self.EzrealMenu:MenuElement({id = "Auto", name = "Auto", type = MENU})
	self.EzrealMenu.Auto:MenuElement({id = "UseQ", name = "Use Q [Mystic Shot]", value = true, leftIcon = QIcon})
	self.EzrealMenu.Auto:MenuElement({id = "UseW", name = "Use W [Essence Flux]", value = true, leftIcon = WIcon})
	self.EzrealMenu.Auto:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	
	self.EzrealMenu:MenuElement({id = "Combo", name = "Combo", type = MENU})
	self.EzrealMenu.Combo:MenuElement({id = "UseQ", name = "Use Q [Mystic Shot]", value = true, leftIcon = QIcon})
	self.EzrealMenu.Combo:MenuElement({id = "UseW", name = "Use W [Essence Flux]", value = true, leftIcon = WIcon})
	self.EzrealMenu.Combo:MenuElement({id = "UseE", name = "Use E [Arcane Shift]", value = true, leftIcon = EIcon})
	self.EzrealMenu.Combo:MenuElement({id = "UseR", name = "Use R [Trueshot Barrage]", value = true, leftIcon = RIcon})
	self.EzrealMenu.Combo:MenuElement({id = "Distance", name = "Distance: R", value = 2000, min = 100, max = 5000, step = 50})
	self.EzrealMenu.Combo:MenuElement({id = "X", name = "Minimum Enemies: R", value = 1, min = 0, max = 5, step = 1})
	self.EzrealMenu.Combo:MenuElement({id = "HP", name = "HP-Manager: R", value = 40, min = 0, max = 100, step = 5})
	
	self.EzrealMenu:MenuElement({id = "Harass", name = "Harass", type = MENU})
	self.EzrealMenu.Harass:MenuElement({id = "UseQ", name = "Use Q [Mystic Shot]", value = true, leftIcon = QIcon})
	self.EzrealMenu.Harass:MenuElement({id = "UseW", name = "Use W [Essence Flux]", value = true, leftIcon = WIcon})
	self.EzrealMenu.Harass:MenuElement({id = "UseE", name = "Use E [Arcane Shift]", value = true, leftIcon = WIcon})
	self.EzrealMenu.Harass:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	
	self.EzrealMenu:MenuElement({id = "KillSteal", name = "KillSteal", type = MENU})
	self.EzrealMenu.KillSteal:MenuElement({id = "UseR", name = "Use R [Trueshot Barrage]", value = true, leftIcon = RIcon})
	self.EzrealMenu.KillSteal:MenuElement({id = "Distance", name = "Distance: R", value = 2000, min = 100, max = 5000, step = 50})
	
	self.EzrealMenu:MenuElement({id = "LaneClear", name = "LaneClear", type = MENU})
	self.EzrealMenu.LaneClear:MenuElement({id = "UseQ", name = "Use Q [Mystic Shot]", value = false, leftIcon = QIcon})
	self.EzrealMenu.LaneClear:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	
	self.EzrealMenu:MenuElement({id = "LastHit", name = "LastHit", type = MENU})
	self.EzrealMenu.LastHit:MenuElement({id = "UseQ", name = "Use Q [Mystic Shot]", value = true, leftIcon = QIcon})
	self.EzrealMenu.LastHit:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	
	self.EzrealMenu:MenuElement({id = "HitChance", name = "HitChance", type = MENU})
	self.EzrealMenu.HitChance:MenuElement({id = "HPredHit", name = "HitChance: HPrediction", value = 1, min = 1, max = 5, step = 1})
	self.EzrealMenu.HitChance:MenuElement({id = "TPredHit", name = "HitChance: TPrediction", value = 1, min = 0, max = 5, step = 1})
	
	self.EzrealMenu:MenuElement({id = "Prediction", name = "Prediction", type = MENU})
	self.EzrealMenu.Prediction:MenuElement({id = "PredictionQ", name = "Prediction: Q", drop = {"HPrediction", "TPrediction"}, value = 2})
	self.EzrealMenu.Prediction:MenuElement({id = "PredictionW", name = "Prediction: W", drop = {"HPrediction", "TPrediction"}, value = 2})
	self.EzrealMenu.Prediction:MenuElement({id = "PredictionR", name = "Prediction: R", drop = {"HPrediction", "TPrediction"}, value = 2})
	
	self.EzrealMenu:MenuElement({id = "Drawings", name = "Drawings", type = MENU})
	self.EzrealMenu.Drawings:MenuElement({id = "DrawQ", name = "Draw Q Range", value = true})
	self.EzrealMenu.Drawings:MenuElement({id = "DrawW", name = "Draw W Range", value = true})
	self.EzrealMenu.Drawings:MenuElement({id = "DrawE", name = "Draw E Range", value = true})
	self.EzrealMenu.Drawings:MenuElement({id = "DrawR", name = "Draw R Range", value = true})
end

function Ezreal:Spells()
	EzrealQ = {speed = 2000, range = 1150, delay = 0.25, width = 60, collision = true, aoe = false, type = "line"}
	EzrealW = {speed = 1600, range = 1000, delay = 0.25, width = 80, collision = false, aoe = true, type = "line"}
	EzrealE = {range = 475}
	EzrealR = {speed = 2000, range = 25000, delay = 1, width = 160, collision = false, aoe = true, type = "line"}
end

function Ezreal:__init()
	self:Menu()
	self:Spells()
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("Draw", function() self:Draw() end)
end

function Ezreal:Tick()
	if myHero.dead or Game.IsChatOpen() == true then return end
	self:Auto()
	self:KillSteal()
	if Mode() == "Combo" then
		self:Combo()
	elseif Mode() == "Harass" then
		self:Harass()
	elseif Mode() == "Clear" then
		self:LaneClear()
		self:LastHit()
	end
end

function Ezreal:Draw()
	if myHero.dead then return end
	if self.EzrealMenu.Drawings.DrawQ:Value() then Draw.Circle(myHero.pos, EzrealQ.range, 1, Draw.Color(255, 0, 191, 255)) end
	if self.EzrealMenu.Drawings.DrawW:Value() then Draw.Circle(myHero.pos, EzrealW.range, 1, Draw.Color(255, 65, 105, 225)) end
	if self.EzrealMenu.Drawings.DrawE:Value() then Draw.Circle(myHero.pos, EzrealE.range, 1, Draw.Color(255, 30, 144, 255)) end
	if self.EzrealMenu.Drawings.DrawR:Value() then Draw.Circle(myHero.pos, self.EzrealMenu.Combo.Distance:Value(), 1, Draw.Color(255, 0, 0, 255)) end
end

function Ezreal:UseQ(target)
	if self.EzrealMenu.Prediction.PredictionQ:Value() == 1 then
		local target, aimPosition = HPred:GetReliableTarget(myHero.pos, EzrealQ.range, EzrealQ.delay, EzrealQ.speed, EzrealQ.width, self.EzrealMenu.HitChance.HPredHit:Value(), EzrealQ.collision)
		if target and HPred:IsInRange(myHero.pos, aimPosition, EzrealQ.range) then
			Control.CastSpell(HK_Q, aimPosition)
		else
			local hitChance, aimPosition = HPred:GetUnreliableTarget(myHero.pos, EzrealQ.range, EzrealQ.delay, EzrealQ.speed, EzrealQ.width, EzrealQ.collision, self.EzrealMenu.HitChance.HPredHit:Value(), nil)
			if hitChance and HPred:IsInRange(myHero.pos, aimPosition, EzrealQ.range) then
				Control.CastSpell(HK_Q, aimPosition)
			end
		end
	elseif self.EzrealMenu.Prediction.PredictionQ:Value() == 2 then
		local castpos,HitChance, pos = TPred:GetBestCastPosition(target, EzrealQ.delay, EzrealQ.width, EzrealQ.range, EzrealQ.speed, myHero.pos, EzrealQ.collision, EzrealQ.type)
		if (HitChance >= self.EzrealMenu.HitChance.TPredHit:Value() ) then
			Control.CastSpell(HK_Q, castpos)
		end
	end
end

function Ezreal:UseW(target)
	if self.EzrealMenu.Prediction.PredictionW:Value() == 1 then
		local target, aimPosition = HPred:GetReliableTarget(myHero.pos, EzrealW.range, EzrealW.delay, EzrealW.speed, EzrealW.width, self.EzrealMenu.HitChance.HPredHit:Value(), EzrealW.collision)
		if target and HPred:IsInRange(myHero.pos, aimPosition, EzrealW.range) then
			Control.CastSpell(HK_W, aimPosition)
		else
			local hitChance, aimPosition = HPred:GetUnreliableTarget(myHero.pos, EzrealW.range, EzrealW.delay, EzrealW.speed, EzrealW.width, EzrealW.collision, self.EzrealMenu.HitChance.HPredHit:Value(), nil)
			if hitChance and HPred:IsInRange(myHero.pos, aimPosition, EzrealW.range) then
				Control.CastSpell(HK_W, aimPosition)
			end
		end
	elseif self.EzrealMenu.Prediction.PredictionW:Value() == 2 then
		local castpos,HitChance, pos = TPred:GetBestCastPosition(target, EzrealW.delay, EzrealW.width, EzrealW.range, EzrealW.speed, myHero.pos, EzrealW.collision, EzrealW.type)
		if (HitChance >= self.EzrealMenu.HitChance.TPredHit:Value() ) then
			Control.CastSpell(HK_W, castpos)
		end
	end
end

function Ezreal:UseR(target)
	if self.EzrealMenu.Prediction.PredictionR:Value() == 1 then
		local target, aimPosition = HPred:GetReliableTarget(myHero.pos, EzrealR.range, EzrealR.delay, EzrealR.speed, EzrealR.width, self.EzrealMenu.HitChance.HPredHit:Value(), EzrealR.collision)
		if target and HPred:IsInRange(myHero.pos, aimPosition, EzrealR.range) then
			local RCastPos = myHero.pos-(myHero.pos-aimPosition):Normalized()*300
			CastSpell(HK_R, RCastPos, 300, EzrealR.delay*1000)
		else
			local hitChance, aimPosition = HPred:GetUnreliableTarget(myHero.pos, EzrealR.range, EzrealR.delay, EzrealR.speed, EzrealR.width, EzrealR.collision, self.EzrealMenu.HitChance.HPredHit:Value(), nil)
			if hitChance and HPred:IsInRange(myHero.pos, aimPosition, EzrealR.range) then
				local RCastPos = myHero.pos-(myHero.pos-aimPosition):Normalized()*300
				CastSpell(HK_R, RCastPos, 300, EzrealR.delay*1000)
			end
		end
	elseif self.EzrealMenu.Prediction.PredictionR:Value() == 2 then
		local castpos,HitChance, pos = TPred:GetBestCastPosition(target, EzrealR.delay, EzrealR.width, EzrealR.range, EzrealR.speed, myHero.pos, EzrealR.collision, EzrealR.type)
		if (HitChance >= self.EzrealMenu.HitChance.TPredHit:Value() ) then
			local RCastPos = myHero.pos-(myHero.pos-castpos):Normalized()*300
			CastSpell(HK_R, RCastPos, 300, EzrealR.delay*1000)
		end
	end
end

function Ezreal:Auto()
	if target == nil then return end
	if self.EzrealMenu.Auto.UseQ:Value() then
		if GetPercentMana(myHero) > self.EzrealMenu.Auto.MP:Value() then
			if IsReady(_Q) then
				if ValidTarget(target, EzrealQ.range) then
					self:UseQ(target)
				end
			end
		end
	end
	if self.EzrealMenu.Auto.UseW:Value() then
		if GetPercentMana(myHero) > self.EzrealMenu.Auto.MP:Value() then
			if IsReady(_W) then
				if ValidTarget(target, EzrealW.range) then
					self:UseW(target)
				end
			end
		end
	end
end

function Ezreal:Combo()
	if target == nil then return end
	if self.EzrealMenu.Combo.UseQ:Value() then
		if IsReady(_Q) and myHero.attackData.state ~= STATE_WINDUP then
			if ValidTarget(target, EzrealQ.range) then
				self:UseQ(target)
			end
		end
	end
	if self.EzrealMenu.Combo.UseW:Value() then
		if IsReady(_W) and myHero.attackData.state ~= STATE_WINDUP then
			if ValidTarget(target, EzrealW.range) then
				self:UseW(target)
			end
		end
	end
	if self.EzrealMenu.Combo.UseE:Value() then
		if IsReady(_E) then
			if ValidTarget(target, EzrealE.range+myHero.range) then
				Control.CastSpell(HK_E, mousePos)
			end
		end
	end
	if self.EzrealMenu.Combo.UseR:Value() then
		if IsReady(_R) then
			if ValidTarget(target, self.EzrealMenu.Combo.Distance:Value()) then
				if GetPercentHP(target) < self.EzrealMenu.Combo.HP:Value() then
					if EnemiesAround(myHero, self.EzrealMenu.Combo.Distance:Value()+myHero.range) >= self.EzrealMenu.Combo.X:Value() then
						self:UseR(target)
					end
				end
			end
		end
	end
end

function Ezreal:Harass()
	if target == nil then return end
	if self.EzrealMenu.Harass.UseQ:Value() then
		if GetPercentMana(myHero) > self.EzrealMenu.Harass.MP:Value() then
			if IsReady(_Q) and myHero.attackData.state ~= STATE_WINDUP then
				if ValidTarget(target, EzrealQ.range) then
					self:UseQ(target)
				end
			end
		end
	end
	if self.EzrealMenu.Harass.UseW:Value() then
		if GetPercentMana(myHero) > self.EzrealMenu.Harass.MP:Value() then
			if IsReady(_W) and myHero.attackData.state ~= STATE_WINDUP then
				if ValidTarget(target, EzrealW.range) then
					self:UseW(target)
				end
			end
		end
	end
end

function Ezreal:KillSteal()
	for i,enemy in pairs(GetEnemyHeroes(5000)) do
		if IsReady(_R) then
			if self.EzrealMenu.KillSteal.UseR:Value() then
				if ValidTarget(enemy, self.EzrealMenu.KillSteal.Distance:Value()) then
					local EzrealRDmg = CalcMagicalDamage(myHero, enemy, (0.3*(({350, 500, 650})[myHero:GetSpellData(_R).level] + myHero.bonusDamage + 0.9 * myHero.ap)))
					if (enemy.health + enemy.hpRegen * 6) < EzrealRDmg then
						self:UseR(enemy)
					end
				end
			end
		end
	end
end

function Ezreal:LaneClear()
	if self.EzrealMenu.LaneClear.UseQ:Value() then
		if GetPercentMana(myHero) > self.EzrealMenu.LaneClear.MP:Value() then
			for i = 1, Game.MinionCount() do
				local minion = Game.Minion(i)
				if minion and minion.isEnemy then
					if ValidTarget(minion, EzrealQ.range) then
						Control.CastSpell(HK_Q, minion)
					end
				end
			end
		end
	end
end

function Ezreal:LastHit()
	if self.EzrealMenu.LastHit.UseQ:Value() then
		if GetPercentMana(myHero) > self.EzrealMenu.LastHit.MP:Value() then
			for i = 1, Game.MinionCount() do
				local minion = Game.Minion(i)
				if minion and minion.isEnemy then
					if ValidTarget(minion, EzrealQ.range) then
						local EzrealQDmg = (({15, 40, 65, 90, 115})[myHero:GetSpellData(_Q).level] + 1.1 * myHero.bonusDamage + 0.4 * myHero.ap)
						if minion.health < EzrealQDmg then
							local castpos,HitChance, pos = TPred:GetBestCastPosition(minion, EzrealQ.delay, EzrealQ.width, EzrealQ.range, EzrealQ.speed, myHero.pos, EzrealQ.collision, EzrealQ.type)
							if HitChance >= 1 then
								Control.CastSpell(HK_Q, castpos)
							end
						end
					end
				end
			end
		end
	end
end

class "Jinx"

local HeroIcon = "https://www.mobafire.com/images/avatars/jinx-classic.png"
local QIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/d/dd/Switcheroo%21.png"
local WIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/7/76/Zap%21.png"
local EIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/b/bb/Flame_Chompers%21.png"
local RIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/a/a8/Super_Mega_Death_Rocket%21.png"

function Jinx:Menu()
	self.JinxMenu = MenuElement({type = MENU, id = "Jinx", name = "[GoS-U] Jinx", leftIcon = HeroIcon})
	self.JinxMenu:MenuElement({id = "Auto", name = "Auto", type = MENU})
	self.JinxMenu.Auto:MenuElement({id = "UseW", name = "Use W [Zap!]", value = true, leftIcon = WIcon})
	self.JinxMenu.Auto:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	
	self.JinxMenu:MenuElement({id = "Combo", name = "Combo", type = MENU})
	self.JinxMenu.Combo:MenuElement({id = "UseQ", name = "Use Q [Switcheroo!]", value = true, leftIcon = QIcon})
	self.JinxMenu.Combo:MenuElement({id = "UseW", name = "Use W [Zap!]", value = true, leftIcon = WIcon})
	self.JinxMenu.Combo:MenuElement({id = "UseE", name = "Use E [Flame Chompers!]", value = true, leftIcon = EIcon})
	self.JinxMenu.Combo:MenuElement({id = "UseR", name = "Use R [Mega Death Rocket!]", value = true, leftIcon = RIcon})
	self.JinxMenu.Combo:MenuElement({id = "Distance", name = "Distance: R", value = 2000, min = 100, max = 5000, step = 50})
	self.JinxMenu.Combo:MenuElement({id = "ModeE", name = "Cast Mode: E", drop = {"Standard", "On Immobile"}, value = 1})
	self.JinxMenu.Combo:MenuElement({id = "X", name = "Minimum Enemies: R", value = 1, min = 0, max = 5, step = 1})
	self.JinxMenu.Combo:MenuElement({id = "HP", name = "HP-Manager: R", value = 40, min = 0, max = 100, step = 5})
	
	self.JinxMenu:MenuElement({id = "Harass", name = "Harass", type = MENU})
	self.JinxMenu.Harass:MenuElement({id = "UseQ", name = "Use Q [Switcheroo!]", value = true, leftIcon = QIcon})
	self.JinxMenu.Harass:MenuElement({id = "UseW", name = "Use W [Zap!]", value = true, leftIcon = WIcon})
	self.JinxMenu.Harass:MenuElement({id = "UseE", name = "Use E [Flame Chompers!]", value = true, leftIcon = EIcon})
	self.JinxMenu.Harass:MenuElement({id = "ModeE", name = "Cast Mode: E", drop = {"Standard", "On Immobile"}, value = 2})
	self.JinxMenu.Harass:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	
	self.JinxMenu:MenuElement({id = "KillSteal", name = "KillSteal", type = MENU})
	self.JinxMenu.KillSteal:MenuElement({id = "UseW", name = "Use W [Zap!]", value = true, leftIcon = WIcon})
	self.JinxMenu.KillSteal:MenuElement({id = "UseR", name = "Use R [Mega Death Rocket!]", value = true, leftIcon = RIcon})
	self.JinxMenu.KillSteal:MenuElement({id = "Distance", name = "Distance: R", value = 2000, min = 100, max = 5000, step = 50})
	
	self.JinxMenu:MenuElement({id = "LaneClear", name = "LaneClear", type = MENU})
	self.JinxMenu.LaneClear:MenuElement({id = "UseQ", name = "Use Q [Switcheroo!]", value = false, leftIcon = QIcon})
	self.JinxMenu.LaneClear:MenuElement({id = "UseE", name = "Use E [Flame Chompers!]", value = false, leftIcon = EIcon})
	self.JinxMenu.LaneClear:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	
	self.JinxMenu:MenuElement({id = "AntiGapcloser", name = "Anti-Gapcloser", type = MENU})
	self.JinxMenu.AntiGapcloser:MenuElement({id = "UseW", name = "Use W [Zap!]", value = true, leftIcon = WIcon})
	self.JinxMenu.AntiGapcloser:MenuElement({id = "UseE", name = "Use E [Flame Chompers!]", value = true, leftIcon = EIcon})
	self.JinxMenu.AntiGapcloser:MenuElement({id = "DistanceW", name = "Distance: W", value = 400, min = 25, max = 500, step = 25})
	self.JinxMenu.AntiGapcloser:MenuElement({id = "DistanceE", name = "Distance: E", value = 300, min = 25, max = 500, step = 25})
	
	self.JinxMenu:MenuElement({id = "HitChance", name = "HitChance", type = MENU})
	self.JinxMenu.HitChance:MenuElement({id = "HPredHit", name = "HitChance: HPrediction", value = 1, min = 1, max = 5, step = 1})
	self.JinxMenu.HitChance:MenuElement({id = "TPredHit", name = "HitChance: TPrediction", value = 1, min = 0, max = 5, step = 1})
	
	self.JinxMenu:MenuElement({id = "Prediction", name = "Prediction", type = MENU})
	self.JinxMenu.Prediction:MenuElement({id = "PredictionW", name = "Prediction: W", drop = {"HPrediction", "TPrediction"}, value = 2})
	self.JinxMenu.Prediction:MenuElement({id = "PredictionE", name = "Prediction: E", drop = {"HPrediction", "TPrediction"}, value = 2})
	self.JinxMenu.Prediction:MenuElement({id = "PredictionR", name = "Prediction: R", drop = {"HPrediction", "TPrediction"}, value = 2})
	
	self.JinxMenu:MenuElement({id = "Drawings", name = "Drawings", type = MENU})
	self.JinxMenu.Drawings:MenuElement({id = "DrawW", name = "Draw W Range", value = true})
	self.JinxMenu.Drawings:MenuElement({id = "DrawE", name = "Draw E Range", value = true})
	self.JinxMenu.Drawings:MenuElement({id = "DrawR", name = "Draw R Range", value = true})
end

function Jinx:Spells()
	JinxW = {speed = 3300, range = 1450, delay = 0.6, width = 60, collision = true, aoe = false, type = "line"}
	JinxE = {speed = 1100, range = 900, delay = 1.5, width = 120, collision = false, aoe = true, type = "circular"}
	JinxR = {speed = 1700, range = 25000, delay = 0.6, width = 140, collision = false, aoe = false, type = "line"}
end

function Jinx:__init()
	self:Menu()
	self:Spells()
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("Draw", function() self:Draw() end)
end

function Jinx:Tick()
	if myHero.dead or Game.IsChatOpen() == true then return end
	self:Auto()
	self:KillSteal()
	self:AntiGapcloser()
	if Mode() == "Combo" then
		self:Combo()
	elseif Mode() == "Harass" then
		self:Harass()
	elseif Mode() == "Clear" then
		self:LaneClear()
	end
end

function Jinx:Draw()
	if myHero.dead then return end
	if self.JinxMenu.Drawings.DrawW:Value() then Draw.Circle(myHero.pos, JinxW.range, 1, Draw.Color(255, 65, 105, 225)) end
	if self.JinxMenu.Drawings.DrawE:Value() then Draw.Circle(myHero.pos, JinxE.range, 1, Draw.Color(255, 30, 144, 255)) end
	if self.JinxMenu.Drawings.DrawR:Value() then Draw.Circle(myHero.pos, self.JinxMenu.Combo.Distance:Value(), 1, Draw.Color(255, 0, 0, 255)) end
end

function Jinx:UseW(target)
	if self.JinxMenu.Prediction.PredictionW:Value() == 1 then
		local target, aimPosition = HPred:GetReliableTarget(myHero.pos, JinxW.range, JinxW.delay, JinxW.speed, JinxW.width, self.JinxMenu.HitChance.HPredHit:Value(), JinxW.collision)
		if target and HPred:IsInRange(myHero.pos, aimPosition, JinxW.range) then
			Control.CastSpell(HK_W, aimPosition)
		else
			local hitChance, aimPosition = HPred:GetUnreliableTarget(myHero.pos, JinxW.range, JinxW.delay, JinxW.speed, JinxW.width, JinxW.collision, self.JinxMenu.HitChance.HPredHit:Value(), nil)
			if hitChance and HPred:IsInRange(myHero.pos, aimPosition, JinxW.range) then
				Control.CastSpell(HK_W, aimPosition)
			end
		end
	elseif self.JinxMenu.Prediction.PredictionW:Value() == 2 then
		local castpos,HitChance, pos = TPred:GetBestCastPosition(target, JinxW.delay, JinxW.width, JinxW.range, JinxW.speed, myHero.pos, JinxW.collision, JinxW.type)
		if (HitChance >= self.JinxMenu.HitChance.TPredHit:Value() ) then
			Control.CastSpell(HK_W, castpos)
		end
	end
end

function Jinx:UseE(target)
	if self.JinxMenu.Prediction.PredictionE:Value() == 1 then
		local target, aimPosition = HPred:GetReliableTarget(myHero.pos, JinxE.range, JinxE.delay, JinxE.speed, JinxE.width, self.JinxMenu.HitChance.HPredHit:Value(), JinxE.collision)
		if target and HPred:IsInRange(myHero.pos, aimPosition, JinxE.range) then
			Control.CastSpell(HK_E, aimPosition)
		else
			local hitChance, aimPosition = HPred:GetUnreliableTarget(myHero.pos, JinxE.range, JinxE.delay, JinxE.speed, JinxE.width, JinxE.collision, self.JinxMenu.HitChance.HPredHit:Value(), nil)
			if hitChance and HPred:IsInRange(myHero.pos, aimPosition, JinxE.range) then
				Control.CastSpell(HK_E, aimPosition)
			end
		end
	elseif self.JinxMenu.Prediction.PredictionE:Value() == 2 then
		local castpos,HitChance, pos = TPred:GetBestCastPosition(target, JinxE.delay, JinxE.width, JinxE.range, JinxE.speed, myHero.pos, JinxE.collision, JinxE.type)
		if (HitChance >= self.JinxMenu.HitChance.TPredHit:Value() ) then
			Control.CastSpell(HK_E, castpos)
		end
	end
end

function Jinx:UseR(target)
	if self.JinxMenu.Prediction.PredictionR:Value() == 1 then
		local target, aimPosition = HPred:GetReliableTarget(myHero.pos, JinxR.range, JinxR.delay, JinxR.speed, JinxR.width, self.JinxMenu.HitChance.HPredHit:Value(), JinxR.collision)
		if target and HPred:IsInRange(myHero.pos, aimPosition, JinxR.range) then
			local RCastPos = myHero.pos-(myHero.pos-aimPosition):Normalized()*300
			CastSpell(HK_R, RCastPos, 300, JinxR.delay*1000)
		else
			local hitChance, aimPosition = HPred:GetUnreliableTarget(myHero.pos, JinxR.range, JinxR.delay, JinxR.speed, JinxR.width, JinxR.collision, self.JinxMenu.HitChance.HPredHit:Value(), nil)
			if hitChance and HPred:IsInRange(myHero.pos, aimPosition, JinxR.range) then
				local RCastPos = myHero.pos-(myHero.pos-aimPosition):Normalized()*300
				CastSpell(HK_R, RCastPos, 300, JinxR.delay*1000)
			end
		end
	elseif self.JinxMenu.Prediction.PredictionR:Value() == 2 then
		local castpos,HitChance, pos = TPred:GetBestCastPosition(target, JinxR.delay, JinxR.width, JinxR.range, JinxR.speed, myHero.pos, JinxR.collision, JinxR.type)
		if (HitChance >= self.JinxMenu.HitChance.TPredHit:Value() ) then
			local RCastPos = myHero.pos-(myHero.pos-castpos):Normalized()*300
			CastSpell(HK_R, RCastPos, 300, JinxR.delay*1000)
		end
	end
end

function Jinx:Auto()
	if target == nil then return end
	if self.JinxMenu.Auto.UseW:Value() then
		if GetPercentMana(myHero) > self.JinxMenu.Auto.MP:Value() then
			if IsReady(_W) then
				if ValidTarget(target, JinxW.range) and GetDistance(myHero.pos, target.pos) > 500 then
					self:UseW(target)
				end
			end
		end
	end
end

function Jinx:Combo()
	if target == nil then return end
	if self.JinxMenu.Combo.UseQ:Value() then
		if IsReady(_Q) then
			if ValidTarget(target, myHero.range) then
				if myHero:GetSpellData(_Q).toggleState == 2 then
					if EnemiesAround(target, 150) <= 1 then
						Control.CastSpell(HK_Q)
					end
				else
					if EnemiesAround(target, 150) > 1 then
						Control.CastSpell(HK_Q)
					end
				end
			elseif ValidTarget(target, myHero.range+200) then
				if GetDistance(myHero.pos, target.pos) > 600 and myHero:GetSpellData(_Q).toggleState == 1 then
					Control.CastSpell(HK_Q)
				elseif GetDistance(myHero.pos, target.pos) < 600 and myHero:GetSpellData(_Q).toggleState == 2 then
					Control.CastSpell(HK_Q)
				end
			end
		end
	end
	if self.JinxMenu.Combo.UseW:Value() then
		if IsReady(_W) and myHero.attackData.state ~= STATE_WINDUP then
			if ValidTarget(target, JinxW.range) and GetDistance(myHero.pos, target.pos) > 500 then
				self:UseW(target)
			end
		end
	end
	if self.JinxMenu.Combo.UseE:Value() then
		if IsReady(_E) then
			if ValidTarget(target, JinxE.range) then
				if self.JinxMenu.Combo.ModeE:Value() == 1 then
					self:UseE(target)
				elseif self.JinxMenu.Combo.ModeE:Value() == 2 then
					if IsImmobile(target) then
						self:UseE(target)
					end
				end
			end
		end
	end
	if self.JinxMenu.Combo.UseR:Value() then
		if IsReady(_R) then
			if ValidTarget(target, self.JinxMenu.Combo.Distance:Value()) then
				if GetPercentHP(target) < self.JinxMenu.Combo.HP:Value() then
					if EnemiesAround(myHero, self.JinxMenu.Combo.Distance:Value()+myHero.range) >= self.JinxMenu.Combo.X:Value() then
						self:UseR(target)
					end
				end
			end
		end
	end
end

function Jinx:Harass()
	if target == nil then return end
	if self.JinxMenu.Harass.UseQ:Value() then
		if IsReady(_Q) then
			if ValidTarget(target, myHero.range) then
				if myHero:GetSpellData(_Q).toggleState == 2 then
					if EnemiesAround(target, 150) <= 1 then
						Control.CastSpell(HK_Q)
					end
				else
					if GetPercentMana(myHero) > self.JinxMenu.Harass.MP:Value() then
						if EnemiesAround(target, 150) > 1 then
							Control.CastSpell(HK_Q)
						end
					end
				end
			elseif ValidTarget(target, myHero.range+200) then
				if GetDistance(myHero.pos, target.pos) > 600 and myHero:GetSpellData(_Q).toggleState == 1 and GetPercentMana(myHero) > self.JinxMenu.Harass.MP:Value() then
					Control.CastSpell(HK_Q)
				elseif GetDistance(myHero.pos, target.pos) < 600 and myHero:GetSpellData(_Q).toggleState == 2 then
					Control.CastSpell(HK_Q)
				end
			end
		end
	end
	if self.JinxMenu.Harass.UseW:Value() then
		if GetPercentMana(myHero) > self.JinxMenu.Harass.MP:Value() then
			if IsReady(_W) and myHero.attackData.state ~= STATE_WINDUP then
				if ValidTarget(target, JinxW.range) and GetDistance(myHero.pos, target.pos) > 500 then
					self:UseW(target)
				end
			end
		end
	end
	if self.JinxMenu.Harass.UseE:Value() then
		if GetPercentMana(myHero) > self.JinxMenu.Harass.MP:Value() then
			if IsReady(_E) then
				if ValidTarget(target, JinxE.range) then
					if self.JinxMenu.Harass.ModeE:Value() == 1 then
						self:UseE(target)
					elseif self.JinxMenu.Harass.ModeE:Value() == 2 then
						if IsImmobile(target) then
							self:UseE(target)
						end
					end
				end
			end
		end
	end
end

function Jinx:KillSteal()
	for i,enemy in pairs(GetEnemyHeroes(5000)) do
		if IsReady(_R) then
			if self.JinxMenu.KillSteal.UseR:Value() then
				if ValidTarget(enemy, self.JinxMenu.KillSteal.Distance:Value()) then
					local JinxRDmg = CalcPhysicalDamage(myHero, enemy, (({125, 175, 225})[myHero:GetSpellData(_R).level] + 0.75 * myHero.bonusDamage + (({0.25, 0.3, 0.35})[myHero:GetSpellData(_R).level])*(enemy.maxHealth - enemy.health)))
					if (enemy.health + enemy.hpRegen * 6) < JinxRDmg then
						self:UseR(enemy)
					end
				end
			end
		elseif IsReady(_W) then
			if self.JinxMenu.KillSteal.UseW:Value() then
				if ValidTarget(enemy, JinxW.range) then
					local JinxWDmg = CalcPhysicalDamage(myHero, enemy, (({10, 60, 110, 160, 210})[myHero:GetSpellData(_W).level] + 1.6 * myHero.totalDamage))
					if (enemy.health + enemy.hpRegen * 4) < JinxWDmg then
						self:UseW(enemy)
					end
				end
			end
		end
	end
end

function Jinx:LaneClear()
	if self.JinxMenu.LaneClear.UseE:Value() then
		if GetPercentMana(myHero) > self.JinxMenu.LaneClear.MP:Value() then
			if IsReady(_E) then
				local BestPos, BestHit = GetBestCircularFarmPos(JinxE.range, JinxE.width)
				if BestPos and BestHit >= 3 then
					Control.SetCursorPos(BestPos)
					Control.CastSpell(HK_E, BestPos)
				end
			end
		end
	end
	if self.JinxMenu.LaneClear.UseQ:Value() then
		for i = 1, Game.MinionCount() do
			local minion = Game.Minion(i)
			if minion and minion.isEnemy then
				if ValidTarget(minion, myHero.range) then
					if myHero:GetSpellData(_Q).toggleState == 2 then
						if MinionsAround(minion.pos, 150, minion.team) <= 1 then
							Control.CastSpell(HK_Q)
						end
					else
						if GetPercentMana(myHero) > self.JinxMenu.LaneClear.MP:Value() then
							if MinionsAround(minion.pos, 150, minion.team) > 1 then
								Control.CastSpell(HK_Q)
							end
						end
					end
				end
			end
		end
	end
end

function Jinx:AntiGapcloser()
	for i,antigap in pairs(GetEnemyHeroes(JinxW.range)) do
		if IsReady(_W) then
			if self.JinxMenu.AntiGapcloser.UseW:Value() then
				if ValidTarget(antigap, self.JinxMenu.AntiGapcloser.DistanceW:Value()) then
					self:UseW(antigap)
				end
			end
		elseif IsReady(_E) then
			if self.JinxMenu.AntiGapcloser.UseE:Value() then
				if ValidTarget(antigap, self.JinxMenu.AntiGapcloser.DistanceE:Value()) then
					self:UseE(antigap)
				end
			end
		end
	end
end

class "Kaisa"

local HeroIcon = "https://www.mobafire.com/images/champion/square/kaisa.png"
local QIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/9/9a/Icathian_Rain.png"
local WIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/8/89/Void_Seeker.png"
local EIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/e/e4/Supercharge.png"
local RIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/2/2c/Killer_Instinct.png"

function Kaisa:Menu()
	self.KaisaMenu = MenuElement({type = MENU, id = "Kaisa", name = "[GoS-U] Kaisa", leftIcon = HeroIcon})
	self.KaisaMenu:MenuElement({id = "Auto", name = "Auto", type = MENU})
	self.KaisaMenu.Auto:MenuElement({id = "UseQ", name = "Use Q [Icathian Rain]", value = true, leftIcon = QIcon})
	self.KaisaMenu.Auto:MenuElement({id = "UseW", name = "Use W [Void Seeker]", value = true, leftIcon = WIcon})
	self.KaisaMenu.Auto:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	
	self.KaisaMenu:MenuElement({id = "Combo", name = "Combo", type = MENU})
	self.KaisaMenu.Combo:MenuElement({id = "UseQ", name = "Use Q [Icathian Rain]", value = true, leftIcon = QIcon})
	self.KaisaMenu.Combo:MenuElement({id = "UseW", name = "Use W [Void Seeker]", value = true, leftIcon = WIcon})
	self.KaisaMenu.Combo:MenuElement({id = "UseE", name = "Use E [Supercharge]", value = true, leftIcon = EIcon})
	
	self.KaisaMenu:MenuElement({id = "Harass", name = "Harass", type = MENU})
	self.KaisaMenu.Harass:MenuElement({id = "UseQ", name = "Use Q [Icathian Rain]", value = true, leftIcon = QIcon})
	self.KaisaMenu.Harass:MenuElement({id = "UseW", name = "Use W [Void Seeker]", value = true, leftIcon = WIcon})
	self.KaisaMenu.Harass:MenuElement({id = "UseE", name = "Use E [Supercharge]", value = true, leftIcon = EIcon})
	self.KaisaMenu.Harass:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	
	self.KaisaMenu:MenuElement({id = "KillSteal", name = "KillSteal", type = MENU})
	self.KaisaMenu.KillSteal:MenuElement({id = "UseW", name = "Use W [Void Seeker]", value = true, leftIcon = WIcon})
	
	self.KaisaMenu:MenuElement({id = "LaneClear", name = "LaneClear", type = MENU})
	self.KaisaMenu.LaneClear:MenuElement({id = "UseQ", name = "Use Q [Icathian Rain]", value = false, leftIcon = QIcon})
	self.KaisaMenu.LaneClear:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	
	self.KaisaMenu:MenuElement({id = "AntiGapcloser", name = "Anti-Gapcloser", type = MENU})
	self.KaisaMenu.AntiGapcloser:MenuElement({id = "UseE", name = "Use E [Supercharge]", value = true, leftIcon = EIcon})
	self.KaisaMenu.AntiGapcloser:MenuElement({id = "Distance", name = "Distance: E", value = 300, min = 25, max = 500, step = 25})
	
	self.KaisaMenu:MenuElement({id = "HitChance", name = "HitChance", type = MENU})
	self.KaisaMenu.HitChance:MenuElement({id = "HPredHit", name = "HitChance: HPrediction", value = 1, min = 1, max = 5, step = 1})
	self.KaisaMenu.HitChance:MenuElement({id = "TPredHit", name = "HitChance: TPrediction", value = 1, min = 0, max = 5, step = 1})
	
	self.KaisaMenu:MenuElement({id = "Prediction", name = "Prediction", type = MENU})
	self.KaisaMenu.Prediction:MenuElement({id = "PredictionW", name = "Prediction: W", drop = {"HPrediction", "TPrediction"}, value = 2})
	
	self.KaisaMenu:MenuElement({id = "Drawings", name = "Drawings", type = MENU})
	self.KaisaMenu.Drawings:MenuElement({id = "DrawQ", name = "Draw Q Range", value = true})
	self.KaisaMenu.Drawings:MenuElement({id = "DrawW", name = "Draw W Range", value = true})
	self.KaisaMenu.Drawings:MenuElement({id = "DrawR", name = "Draw R Range", value = true})
end

function Kaisa:Spells()
	KaisaQ = {range = 600}
	KaisaW = {speed = 1750, range = 3000, delay = 0.4, width = 100, collision = true, aoe = false, type = "line"}
	KaisaR = {range = myHero:GetSpellData(_R).range}
end

function Kaisa:__init()
	self:Menu()
	self:Spells()
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("Draw", function() self:Draw() end)
end

function Kaisa:Tick()
	if myHero.dead or Game.IsChatOpen() == true then return end
	self:Auto()
	self:CheckE()
	self:KillSteal()
	if Mode() == "Combo" then
		self:Combo()
	elseif Mode() == "Harass" then
		self:Harass()
	elseif Mode() == "Clear" then
		self:LaneClear()
	end
end

function Kaisa:Draw()
	if myHero.dead then return end
	if self.KaisaMenu.Drawings.DrawQ:Value() then Draw.Circle(myHero.pos, KaisaQ.range, 1, Draw.Color(255, 0, 191, 255)) end
	if self.KaisaMenu.Drawings.DrawW:Value() then Draw.Circle(myHero.pos, KaisaW.range, 1, Draw.Color(255, 65, 105, 225)) end
	if self.KaisaMenu.Drawings.DrawR:Value() then Draw.Circle(myHero.pos, KaisaR.range, 1, Draw.Color(255, 0, 0, 255)) end
end

function Kaisa:UseW(target)
	if self.KaisaMenu.Prediction.PredictionW:Value() == 1 then
		local target, aimPosition = HPred:GetReliableTarget(myHero.pos, KaisaW.range, KaisaW.delay, KaisaW.speed, KaisaW.width, self.KaisaMenu.HitChance.HPredHit:Value(), KaisaW.collision)
		if target and HPred:IsInRange(myHero.pos, aimPosition, KaisaW.range) then
			Control.CastSpell(HK_W, aimPosition)
		else
			local hitChance, aimPosition = HPred:GetUnreliableTarget(myHero.pos, KaisaW.range, KaisaW.delay, KaisaW.speed, KaisaW.width, KaisaW.collision, self.KaisaMenu.HitChance.HPredHit:Value(), nil)
			if hitChance and HPred:IsInRange(myHero.pos, aimPosition, KaisaW.range) then
				Control.CastSpell(HK_W, aimPosition)
			end
		end
	elseif self.KaisaMenu.Prediction.PredictionW:Value() == 2 then
		local castpos,HitChance, pos = TPred:GetBestCastPosition(target, KaisaW.delay, KaisaW.width, KaisaW.range, KaisaW.speed, myHero.pos, KaisaW.collision, KaisaW.type)
		if (HitChance >= self.KaisaMenu.HitChance.TPredHit:Value() ) then
			Control.CastSpell(HK_W, castpos)
		end
	end
end

function Kaisa:CheckE()
	if GotBuff(myHero, "KaisaE") > 0 then
		if _G.SDK then
			_G.SDK.Orbwalker:SetAttack(false)
		else
			GOS.BlockAttack = true
		end
	else
		if _G.SDK then
			_G.SDK.Orbwalker:SetAttack(true)
		else
			GOS.BlockAttack = false
		end
	end
end

function Kaisa:Auto()
	if target == nil then return end
	if GetPercentMana(myHero) > self.KaisaMenu.Auto.MP:Value() then
		if self.KaisaMenu.Auto.UseQ:Value() then
			if IsReady(_Q) then
				if ValidTarget(target, KaisaQ.range) then
					Control.KeyDown(HK_Q)
					Control.KeyUp(HK_Q)
				end
			end
		end
		if self.KaisaMenu.Auto.UseW:Value() then
			if IsReady(_W) then
				if ValidTarget(target, KaisaW.range) then
					self:UseW(target)
				end
			end
		end
	end
end

function Kaisa:Combo()
	if target == nil then return end
	if self.KaisaMenu.Combo.UseQ:Value() then
		if IsReady(_Q) and myHero.attackData.state ~= STATE_WINDUP then
			if ValidTarget(target, KaisaQ.range) then
				Control.KeyDown(HK_Q)
				Control.KeyUp(HK_Q)
			end
		end
	end
	if self.KaisaMenu.Combo.UseW:Value() then
		if IsReady(_W) and myHero.attackData.state ~= STATE_WINDUP then
			if ValidTarget(target, KaisaW.range) then
				self:UseW(target)
			end
		end
	end
	if self.KaisaMenu.Combo.UseE:Value() then
		if IsReady(_E) and myHero.attackData.state ~= STATE_WINDUP then
			if ValidTarget(target, myHero.range+500) and GetDistance(myHero.pos, target.pos) > myHero.range then
				Control.KeyDown(HK_E)
				Control.KeyUp(HK_E)
			end
		end
	end
end

function Kaisa:Harass()
	if target == nil then return end
	if GetPercentMana(myHero) > self.KaisaMenu.Harass.MP:Value() then
		if self.KaisaMenu.Harass.UseQ:Value() then
			if IsReady(_Q) and myHero.attackData.state ~= STATE_WINDUP then
				if ValidTarget(target, KaisaQ.range) then
					Control.KeyDown(HK_Q)
					Control.KeyUp(HK_Q)
				end
			end
		end
		if self.KaisaMenu.Harass.UseW:Value() then
			if IsReady(_W) and myHero.attackData.state ~= STATE_WINDUP then
				if ValidTarget(target, KaisaW.range) then
					self:UseW(target)
				end
			end
		end
		if self.KaisaMenu.Harass.UseE:Value() then
			if IsReady(_E) and myHero.attackData.state ~= STATE_WINDUP then
				if ValidTarget(target, myHero.range+500) and GetDistance(myHero.pos, target.pos) > myHero.range then
					Control.KeyDown(HK_E)
					Control.KeyUp(HK_E)
				end
			end
		end
	end
end

function Kaisa:KillSteal()
	for i,enemy in pairs(GetEnemyHeroes(KaisaW.range)) do
		if IsReady(_W) then
			if self.KaisaMenu.KillSteal.UseW:Value() then
				if ValidTarget(enemy, KaisaW.range) then
					local KaisaWDmg = CalcMagicalDamage(myHero, enemy, ((({20, 45, 70, 95, 120})[myHero:GetSpellData(_W).level]) + (1.5 * myHero.totalDamage) + (0.6 * myHero.ap)))
					if (enemy.health + enemy.hpRegen * 5) < KaisaWDmg then
						self:UseW(enemy)
					end
				end
			end
		end
	end
end

function Kaisa:LaneClear()
	if self.KaisaMenu.LaneClear.UseQ:Value() then
		if GetPercentMana(myHero) > self.KaisaMenu.LaneClear.MP:Value() then
			if IsReady(_Q) then
				for i = 1, Game.MinionCount() do
					local minion = Game.Minion(i)
					if minion and minion.isEnemy then
						if MinionsAround(myHero.pos, KaisaQ.range, minion.team) >= 4 then
							Control.KeyDown(HK_Q)
							Control.KeyUp(HK_Q)
						end
					end
				end
			end
		end
	end
end

function Kaisa:AntiGapcloser()
	for i,antigap in pairs(GetEnemyHeroes(500)) do
		if IsReady(_E) then
			if self.KaisaMenu.AntiGapcloser.UseE:Value() then
				if ValidTarget(antigap, self.KaisaMenu.AntiGapcloser.Distance:Value()) then
					Control.KeyDown(HK_E)
					Control.KeyUp(HK_E)
				end
			end
		end
	end
end

class "Kalista"

local HeroIcon = "https://www.mobafire.com/images/champion/square/kalista.png"
local QIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/9/9b/Pierce.png"
local WIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/9/91/Sentinel.png"
local EIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/b/b8/Rend.png"
local RIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/e/e9/Fate%27s_Call.png"

function Kalista:Menu()
	self.KalistaMenu = MenuElement({type = MENU, id = "Kalista", name = "[GoS-U] Kalista", leftIcon = HeroIcon})
	self.KalistaMenu:MenuElement({id = "Auto", name = "Auto", type = MENU})
	self.KalistaMenu.Auto:MenuElement({id = "UseR", name = "Use R [Fate's Call]", value = true, leftIcon = RIcon})
	self.KalistaMenu.Auto:MenuElement({id = "HP", name = "HP-Manager: R", value = 20, min = 0, max = 100, step = 5})
	
	self.KalistaMenu:MenuElement({id = "ERend", name = "E [Rend]", type = MENU})
	self.KalistaMenu.ERend:MenuElement({id = "ResetE", name = "Use E (Reset)", value = true})
	self.KalistaMenu.ERend:MenuElement({id = "OutOfAA", name = "Use E (Out Of AA)", value = false})
	self.KalistaMenu.ERend:MenuElement({id = "MS", name = "Minimum Spears", value = 6, min = 0, max = 20, step = 1})
	
	self.KalistaMenu:MenuElement({id = "Combo", name = "Combo", type = MENU})
	self.KalistaMenu.Combo:MenuElement({id = "UseQ", name = "Use Q [Pierce]", value = true, leftIcon = QIcon})
	self.KalistaMenu.Combo:MenuElement({id = "UseE", name = "Use E [Rend]", value = true, leftIcon = EIcon})
	
	self.KalistaMenu:MenuElement({id = "Harass", name = "Harass", type = MENU})
	self.KalistaMenu.Harass:MenuElement({id = "UseQ", name = "Use Q [Pierce]", value = true, leftIcon = QIcon})
	self.KalistaMenu.Harass:MenuElement({id = "UseE", name = "Use E [Rend]", value = true, leftIcon = EIcon})
	self.KalistaMenu.Harass:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	
	self.KalistaMenu:MenuElement({id = "KillSteal", name = "KillSteal", type = MENU})
	self.KalistaMenu.KillSteal:MenuElement({id = "UseQ", name = "Use Q [Pierce]", value = true, leftIcon = QIcon})
	self.KalistaMenu.KillSteal:MenuElement({id = "UseE", name = "Use E [Rend]", value = true, leftIcon = EIcon})
	
	self.KalistaMenu:MenuElement({id = "LaneClear", name = "LaneClear", type = MENU})
	self.KalistaMenu.LaneClear:MenuElement({id = "UseQ", name = "Use Q [Pierce]", value = false, leftIcon = QIcon})
	self.KalistaMenu.LaneClear:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	
	self.KalistaMenu:MenuElement({id = "LastHit", name = "LastHit", type = MENU})
	self.KalistaMenu.LastHit:MenuElement({id = "UseE", name = "Use E [Rend]", value = true, leftIcon = EIcon})
	self.KalistaMenu.LastHit:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	
	self.KalistaMenu:MenuElement({id = "HitChance", name = "HitChance", type = MENU})
	self.KalistaMenu.HitChance:MenuElement({id = "HPredHit", name = "HitChance: HPrediction", value = 1, min = 1, max = 5, step = 1})
	self.KalistaMenu.HitChance:MenuElement({id = "TPredHit", name = "HitChance: TPrediction", value = 1, min = 0, max = 5, step = 1})
	
	self.KalistaMenu:MenuElement({id = "Prediction", name = "Prediction", type = MENU})
	self.KalistaMenu.Prediction:MenuElement({id = "PredictionQ", name = "Prediction: Q", drop = {"HPrediction", "TPrediction"}, value = 2})
	
	self.KalistaMenu:MenuElement({id = "Drawings", name = "Drawings", type = MENU})
	self.KalistaMenu.Drawings:MenuElement({id = "DrawQ", name = "Draw Q Range", value = true})
	self.KalistaMenu.Drawings:MenuElement({id = "DrawE", name = "Draw E Range", value = true})
	self.KalistaMenu.Drawings:MenuElement({id = "DrawR", name = "Draw R Range", value = true})
end

function Kalista:Spells()
	KalistaQ = {speed = 2400, range = 1150, delay = 0.35, width = 40, collision = true, aoe = false, type = "line"}
	KalistaE = {range = 1000}
	KalistaR = {range = 1200}
end

function Kalista:__init()
	self:Menu()
	self:Spells()
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("Draw", function() self:Draw() end)
end

function Kalista:Tick()
	if myHero.dead or Game.IsChatOpen() == true then return end
	self:Auto()
	self:KillSteal()
	if Mode() == "Combo" then
		self:Combo()
	elseif Mode() == "Harass" then
		self:Harass()
	elseif Mode() == "Clear" then
		self:LaneClear()
		self:LastHit()
	end
end

function Kalista:Draw()
	if myHero.dead then return end
	if self.KalistaMenu.Drawings.DrawQ:Value() then Draw.Circle(myHero.pos, KalistaQ.range, 1, Draw.Color(255, 0, 191, 255)) end
	if self.KalistaMenu.Drawings.DrawE:Value() then Draw.Circle(myHero.pos, KalistaE.range, 1, Draw.Color(255, 30, 144, 255)) end
	if self.KalistaMenu.Drawings.DrawR:Value() then Draw.Circle(myHero.pos, KalistaR.range, 1, Draw.Color(255, 0, 0, 255)) end
end

function Kalista:UseQ(target)
	if self.KalistaMenu.Prediction.PredictionQ:Value() == 1 then
		local target, aimPosition = HPred:GetReliableTarget(myHero.pos, KalistaQ.range, KalistaQ.delay, KalistaQ.speed, KalistaQ.width, self.KalistaMenu.HitChance.HPredHit:Value(), KalistaQ.collision)
		if target and HPred:IsInRange(myHero.pos, aimPosition, KalistaQ.range) then
			Control.CastSpell(HK_Q, aimPosition)
		else
			local hitChance, aimPosition = HPred:GetUnreliableTarget(myHero.pos, KalistaQ.range, KalistaQ.delay, KalistaQ.speed, KalistaQ.width, KalistaQ.collision, self.KalistaMenu.HitChance.HPredHit:Value(), nil)
			if hitChance and HPred:IsInRange(myHero.pos, aimPosition, KalistaQ.range) then
				Control.CastSpell(HK_Q, aimPosition)
			end
		end
	elseif self.KalistaMenu.Prediction.PredictionQ:Value() == 2 then
		local castpos,HitChance, pos = TPred:GetBestCastPosition(target, KalistaQ.delay, KalistaQ.width, KalistaQ.range, KalistaQ.speed, myHero.pos, KalistaQ.collision, KalistaQ.type)
		if (HitChance >= self.KalistaMenu.HitChance.TPredHit:Value() ) then
			Control.CastSpell(HK_Q, castpos)
		end
	end
end

function Kalista:Auto()
	if target == nil then return end
	if self.KalistaMenu.Auto.UseR:Value() then
		for _, ally in pairs(GetAllyHeroes()) do
			if IsReady(_R) and GotBuff(ally, "kalistacoopstrikeally") == 1 then
				if ValidTarget(ally, KalistaR.range) and EnemiesAround(ally, 1500) >= 1 then
					if GetPercentHP(ally) <= self.KalistaMenu.Auto.HP:Value() then
						Control.CastSpell(HK_R)
					end
				end
			end
		end
	end
end

function Kalista:Combo()
	if target == nil then return end
	if self.KalistaMenu.Combo.UseQ:Value() then
		if IsReady(_Q) and myHero.attackData.state ~= STATE_WINDUP then
			if ValidTarget(target, KalistaQ.range) then
				self:UseQ(target)
			end
		end
	end
	if self.KalistaMenu.Combo.UseE:Value() then
		if IsReady(_E) then
			if ValidTarget(target, KalistaE.range) then
				if GetDistance(target.pos, myHero.pos) <= myHero.range then
					if self.KalistaMenu.ERend.ResetE:Value() then
						for i = 1, Game.MinionCount() do
							local minion = Game.Minion(i)
							if minion and minion.isEnemy then
								if ValidTarget(minion, KalistaE.range) and GotBuff(minion, "kalistaexpungemarker") >= 1 then
									local KalistaECDmg = ((({20, 30, 40, 50, 60})[myHero:GetSpellData(_E).level] + (0.6 * myHero.totalDamage)) + ((({10, 14, 19, 25, 32})[myHero:GetSpellData(_E).level] + ((0.025 * myHero:GetSpellData(_E).level + 0.175) * myHero.totalDamage)) * (GotBuff(minion,"kalistaexpungemarker")-1)))
									if minion.health < KalistaECDmg then
										if GotBuff(target, "kalistaexpungemarker") >= self.KalistaMenu.ERend.MS:Value() then
											Control.CastSpell(HK_E)
										end
									end
								end
							end
						end
					end
				elseif GetDistance(target.pos, myHero.pos) >= myHero.range then
					if self.KalistaMenu.ERend.OutOfAA:Value() then
						if GotBuff(target, "kalistaexpungemarker") >= self.KalistaMenu.ERend.MS:Value() then
							Control.CastSpell(HK_E)
						end
					end
				end
			end
		end
	end
end

function Kalista:Harass()
	if target == nil then return end
	if GetPercentMana(myHero) > self.KalistaMenu.Harass.MP:Value() then
		if self.KalistaMenu.Harass.UseQ:Value() then
			if IsReady(_Q) and myHero.attackData.state ~= STATE_WINDUP then
				if ValidTarget(target, KalistaQ.range) then
					self:UseQ(target)
				end
			end
		end
		if self.KalistaMenu.Harass.UseE:Value() then
			if IsReady(_E) then
				if ValidTarget(target, KalistaE.range) then
					if GetDistance(target.pos, myHero.pos) <= myHero.range then
						if self.KalistaMenu.ERend.ResetE:Value() then
							for i = 1, Game.MinionCount() do
								local minion = Game.Minion(i)
								if minion and minion.isEnemy then
									if ValidTarget(minion, KalistaE.range) and GotBuff(minion, "kalistaexpungemarker") >= 1 then
										local KalistaEHDmg = ((({20, 30, 40, 50, 60})[myHero:GetSpellData(_E).level] + (0.6 * myHero.totalDamage)) + ((({10, 14, 19, 25, 32})[myHero:GetSpellData(_E).level] + ((0.025 * myHero:GetSpellData(_E).level + 0.175) * myHero.totalDamage)) * (GotBuff(minion,"kalistaexpungemarker")-1)))
										if minion.health < KalistaEHDmg then
											if GotBuff(target, "kalistaexpungemarker") >= self.KalistaMenu.ERend.MS:Value() then
												Control.CastSpell(HK_E)
											end
										end
									end
								end
							end
						end
					elseif GetDistance(target.pos, myHero.pos) >= myHero.range then
						if self.KalistaMenu.ERend.OutOfAA:Value() then
							if GotBuff(target, "kalistaexpungemarker") >= self.KalistaMenu.ERend.MS:Value() then
								Control.CastSpell(HK_E)
							end
						end
					end
				end
			end
		end
	end
end

function Kalista:KillSteal()
	for i,enemy in pairs(GetEnemyHeroes(KalistaQ.range)) do
		if IsReady(_Q) then
			if self.KalistaMenu.KillSteal.UseQ:Value() then
				if ValidTarget(enemy, KalistaQ.range) then
					local KalistaQDmg = CalcPhysicalDamage(myHero, enemy, (({10, 70, 130, 190, 250})[myHero:GetSpellData(_Q).level] + myHero.totalDamage))
					if (enemy.health + enemy.hpRegen * 2) < KalistaQDmg then
						self:UseQ(enemy)
					end
				end
			end
		elseif IsReady(_E) then
			if self.KalistaMenu.KillSteal.UseE:Value() then
				if ValidTarget(enemy, KalistaE.range) then
					if GotBuff(enemy, "kalistaexpungemarker") > 0 then
						local KalistaEDmg = CalcPhysicalDamage(myHero, enemy, ((({20, 30, 40, 50, 60})[myHero:GetSpellData(_E).level] + (0.6 * myHero.totalDamage)) + ((({10, 14, 19, 25, 32})[myHero:GetSpellData(_E).level] + ((0.025 * myHero:GetSpellData(_E).level + 0.175) * myHero.totalDamage)) * (GotBuff(enemy,"kalistaexpungemarker")-1))))
						local KalistaKS = (KalistaEDmg / enemy.health) * 100
						Draw.Text("E KS [%]: "..tostring(math.ceil(KalistaKS)), 17, enemy.pos2D.x-38, enemy.pos2D.y+10, Draw.Color(0xFFFF4500))
						if (enemy.health + enemy.hpRegen * 2) < KalistaEDmg then
							Control.CastSpell(HK_E)
						end
					end
				end
			end
		end
	end
end

function Kalista:LaneClear()
	if self.KalistaMenu.LaneClear.UseQ:Value() then
		if GetPercentMana(myHero) > self.KalistaMenu.LaneClear.MP:Value() then
			for i = 1, Game.MinionCount() do
				local minion = Game.Minion(i)
				if minion and minion.isEnemy and minion.alive then
					if ValidTarget(minion, KalistaQ.range) then
						Control.CastSpell(HK_Q, minion)
					end
				end
			end
		end
	end
end

function Kalista:LastHit()
	if self.KalistaMenu.LastHit.UseE:Value() then
		if GetPercentMana(myHero) > self.KalistaMenu.LastHit.MP:Value() then
			for i = 1, Game.MinionCount() do
				local minion = Game.Minion(i)
				if minion and minion.isEnemy and minion.alive then
					if ValidTarget(minion, KalistaE.range) then
						if GotBuff(minion, "kalistaexpungemarker") > 0 then
							local KalistaELHDmg = ((({20, 30, 40, 50, 60})[myHero:GetSpellData(_E).level] + (0.6 * myHero.totalDamage)) + ((({10, 14, 19, 25, 32})[myHero:GetSpellData(_E).level] + ((0.025 * myHero:GetSpellData(_E).level + 0.175) * myHero.totalDamage)) * (GotBuff(minion,"kalistaexpungemarker")-1)))
							if minion.health < KalistaELHDmg then
								Control.CastSpell(HK_E)
							end
						end
					end
				end
			end
		end
	end
end

class "Vayne"

local HeroIcon = "https://www.mobafire.com/images/champion/square/vayne.png"
local QIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/8/8d/Tumble.png"
local EIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/6/66/Condemn.png"
local RIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/b/b4/Final_Hour.png"

function Vayne:Menu()
	self.VayneMenu = MenuElement({type = MENU, id = "Vayne", name = "[GoS-U] Vayne", leftIcon = HeroIcon})
	self.VayneMenu:MenuElement({id = "Auto", name = "Auto", type = MENU})
	self.VayneMenu.Auto:MenuElement({id = "UseE", name = "Use E [Condemn]", value = true, leftIcon = EIcon})
	self.VayneMenu.Auto:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	
	self.VayneMenu:MenuElement({id = "Combo", name = "Combo", type = MENU})
	self.VayneMenu.Combo:MenuElement({id = "UseQ", name = "Use Q [Tumble]", value = true, leftIcon = QIcon})
	self.VayneMenu.Combo:MenuElement({id = "UseE", name = "Use E [Condemn]", value = true, leftIcon = EIcon})
	self.VayneMenu.Combo:MenuElement({id = "UseR", name = "Use R [Final Hour]", value = true, leftIcon = RIcon})
	self.VayneMenu.Combo:MenuElement({id = "ModeQ", name = "Cast Mode: Q", drop = {"Standard", "On Stacked"}, value = 2})
	self.VayneMenu.Combo:MenuElement({id = "X", name = "Minimum Enemies: R", value = 1, min = 0, max = 5, step = 1})
	self.VayneMenu.Combo:MenuElement({id = "HP", name = "HP-Manager: R", value = 40, min = 0, max = 100, step = 5})
	
	self.VayneMenu:MenuElement({id = "Harass", name = "Harass", type = MENU})
	self.VayneMenu.Harass:MenuElement({id = "UseQ", name = "Use Q [Tumble]", value = true, leftIcon = QIcon})
	self.VayneMenu.Harass:MenuElement({id = "UseE", name = "Use E [Condemn]", value = true, leftIcon = EIcon})
	self.VayneMenu.Harass:MenuElement({id = "ModeQ", name = "Cast Mode: Q", drop = {"Standard", "On Stacked"}, value = 1})
	self.VayneMenu.Harass:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	
	self.VayneMenu:MenuElement({id = "KillSteal", name = "KillSteal", type = MENU})
	self.VayneMenu.KillSteal:MenuElement({id = "UseE", name = "Use E [Condemn]", value = true, leftIcon = EIcon})
	
	self.VayneMenu:MenuElement({id = "LastHit", name = "LastHit", type = MENU})
	self.VayneMenu.LastHit:MenuElement({id = "UseQ", name = "Use Q [Tumble]", value = true, leftIcon = QIcon})
	self.VayneMenu.LastHit:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	
	self.VayneMenu:MenuElement({id = "AntiGapcloser", name = "Anti-Gapcloser", type = MENU})
	self.VayneMenu.AntiGapcloser:MenuElement({id = "UseE", name = "Use E [Condemn]", value = true, leftIcon = EIcon})
	self.VayneMenu.AntiGapcloser:MenuElement({id = "Distance", name = "Distance: E", value = 175, min = 25, max = 500, step = 25})
	
	self.VayneMenu:MenuElement({id = "Drawings", name = "Drawings", type = MENU})
	self.VayneMenu.Drawings:MenuElement({id = "DrawQ", name = "Draw Q Range", value = true})
	self.VayneMenu.Drawings:MenuElement({id = "DrawE", name = "Draw E Range", value = true})
	
	self.VayneMenu:MenuElement({id = "Misc", name = "Misc", type = MENU})
	self.VayneMenu.Misc:MenuElement({id = "BlockAA", name = "Block AA While Stealthed", value = true})
	self.VayneMenu.Misc:MenuElement({id = "Distance", name = "Distance: E", value = 400, min = 100, max = 475, step = 5})
end

function Vayne:Spells()
	VayneQ = {range = 300}
	VayneE = {speed = 2000, range = 550, delay = 0.25}
end

function Vayne:__init()
	self:Menu()
	self:Spells()
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("Draw", function() self:Draw() end)
end

function Vayne:Tick()
	if myHero.dead or Game.IsChatOpen() == true then return end
	self:Auto()
	self:KillSteal()
	self:AntiGapcloser()
	if Mode() == "Combo" then
		self:Combo()
	elseif Mode() == "Harass" then
		self:Harass()
	elseif Mode() == "Clear" then
		self:LastHit()
	end
end

function Vayne:Draw()
	if myHero.dead then return end
	if self.VayneMenu.Drawings.DrawQ:Value() then Draw.Circle(myHero.pos, VayneQ.range, 1, Draw.Color(255, 0, 191, 255)) end
	if self.VayneMenu.Drawings.DrawE:Value() then Draw.Circle(myHero.pos, VayneE.range, 1, Draw.Color(255, 30, 144, 255)) end
end

function Vayne:UseE(target)
	local VayneEStun = target:GetPrediction(VayneE.speed,VayneE.delay)
	for Length = 0, self.VayneMenu.Misc.Distance:Value(), 50 do
		local TotalPos = VayneEStun + Vector(VayneEStun-Vector(myHero.pos)):Normalized() * Length
		if MapPosition:inWall(TotalPos) then
			Control.CastSpell(HK_E, target)
			break
		end
	end
end

function Vayne:Auto()
	if target == nil then return end
	if self.VayneMenu.Auto.UseE:Value() then
		if GetPercentMana(myHero) > self.VayneMenu.Auto.MP:Value() then
			if IsReady(_E) then
				if ValidTarget(target, VayneE.range) then
					self:UseE(target)
				end
			end
		end
	end
	if self.VayneMenu.Misc.BlockAA:Value() then
		if GotBuff(myHero, "vaynetumblefade") > 0 then
			if _G.SDK then
				_G.SDK.Orbwalker:SetAttack(false)
			else
				GOS.BlockAttack = true
			end
		else
			if _G.SDK then
				_G.SDK.Orbwalker:SetAttack(true)
			else
				GOS.BlockAttack = false
			end
		end
	end
end

function Vayne:Combo()
	if target == nil then return end
	if self.VayneMenu.Combo.UseQ:Value() then
		if IsReady(_Q) and myHero.attackData.state ~= STATE_WINDUP then
			if ValidTarget(target, VayneQ.range+myHero.range) then
				if self.VayneMenu.Combo.ModeQ:Value() == 1 then
					Control.CastSpell(HK_Q, mousePos)
				elseif self.VayneMenu.Combo.ModeQ:Value() == 2 then
					if GotBuff(target, "VayneSilveredDebuff") >= 2 then 
						Control.CastSpell(HK_Q, mousePos)
					end
				end
			end
		end
	end
	if self.VayneMenu.Combo.UseE:Value() then
		if IsReady(_E) and myHero.attackData.state ~= STATE_WINDUP then
			if ValidTarget(target, VayneE.range) then
				self:UseE(target)
			end
		end
	end
	if self.VayneMenu.Combo.UseR:Value() then
		if IsReady(_R) then
			if ValidTarget(target, myHero.range+500) then
				if GetPercentHP(target) < self.VayneMenu.Combo.HP:Value() then
					if EnemiesAround(myHero, VayneQ.range+myHero.range+100) >= self.VayneMenu.Combo.X:Value() then
						Control.CastSpell(HK_R)
					end
				end
			end
		end
	end
end

function Vayne:Harass()
	if target == nil then return end
	if self.VayneMenu.Harass.UseQ:Value() then
		if GetPercentMana(myHero) > self.VayneMenu.Harass.MP:Value() then
			if IsReady(_Q) and myHero.attackData.state ~= STATE_WINDUP then
				if ValidTarget(target, VayneQ.range+myHero.range) then
					if self.VayneMenu.Harass.ModeQ:Value() == 1 then
						Control.CastSpell(HK_Q, mousePos)
					elseif self.VayneMenu.Harass.ModeQ:Value() == 2 then
						if GotBuff(target, "VayneSilveredDebuff") >= 2 then 
							Control.CastSpell(HK_Q, mousePos)
						end
					end
				end
			end
		end
	end
	if self.VayneMenu.Harass.UseE:Value() then
		if GetPercentMana(myHero) > self.VayneMenu.Harass.MP:Value() then
			if IsReady(_E) and myHero.attackData.state ~= STATE_WINDUP then
				if ValidTarget(target, VayneE.range) then
					self:UseE(target)
				end
			end
		end
	end
end

function Vayne:KillSteal()
	for i,enemy in pairs(GetEnemyHeroes(VayneE.range)) do
		if IsReady(_E) and myHero.attackData.state ~= STATE_WINDUP then
			if self.VayneMenu.KillSteal.UseE:Value() then
				if ValidTarget(enemy, VayneE.range) then
					local VayneEDmg = CalcPhysicalDamage(myHero, enemy, (({50, 90, 120, 155, 190})[myHero:GetSpellData(_E).level] + 0.5 * myHero.bonusDamage))
					if (enemy.health + enemy.hpRegen * 2) < VayneEDmg then
						self:UseE(enemy)
					end
				end
			end
		end
	end
end

function Vayne:LastHit()
	if self.VayneMenu.LastHit.UseQ:Value() then
		if GetPercentMana(myHero) > self.VayneMenu.LastHit.MP:Value() then
			for i = 1, Game.MinionCount() do
				local minion = Game.Minion(i)
				if minion and minion.isEnemy then
					if ValidTarget(minion, myHero.range) then
						local VayneQDmg = (((0.05 * myHero:GetSpellData(_Q).level + 0.45) * myHero.totalDamage) + myHero.totalDamage)
						if minion.health < VayneQDmg then
							Control.CastSpell(HK_Q, mousePos)
						end
					end
				end
			end
		end
	end
end

function Vayne:AntiGapcloser()
	for i,antigap in pairs(GetEnemyHeroes(VayneE.range)) do
		if IsReady(_E) then
			if self.VayneMenu.AntiGapcloser.UseE:Value() then
				if ValidTarget(antigap, self.VayneMenu.AntiGapcloser.Distance:Value()) then
					self:UseE(antigap)
				end
			end
		end
	end
end

function OnLoad()
	GoSuUtility()
	if _G[myHero.charName] then
		_G[myHero.charName]()
	end
end


------------------------------
-- Credits to sikaka for HPred   v
------------------------------

class "AutoUtil"

function AutoUtil:FindEnemyWithBuff(buffName, range, stackCount)
	for i = 1, LocalGameHeroCount() do
		local hero = LocalGameHero(i)    
		if hero ~= nil and hero.isEnemy and HPred:IsInRange(myHero.pos, hero.pos, range) then
			for bi = 1, hero.buffCount do 
			local Buff = hero:GetBuff(bi)
				if Buff.name == buffName and Buff.duration > 0 and Buff.count >= stackCount then
					return hero
				end
			end
		end
	end
end

function AutoUtil:__init()
	itemKey = {}
	_ccNames = 
	{
		["Cripple"] = 3,
		["Stun"] = 5,
		["Silence"] = 7,
		["Taunt"] = 8,
		["Polymorph"] = 9,
		["Slow"] = 10,
		["Snare"] = 11,
		["Sleep"] = 18,
		["Nearsight"] = 19,
		["Fear"] = 21,
		["Charm"] = 22,
		["Poison"] = 23,
		["Suppression"] = 24,
		["Blind"] = 25,
		-- ["Shred"] = 27,
		["Flee"] = 28,
		-- ["Knockup"] = 29,
		["Airborne"] = 30,
		["Disarm"] = 31
	}
end

function AutoUtil:CalculatePhysicalDamage(target, damage)			
	local targetArmor = target.armor * myHero.armorPenPercent - myHero.armorPen
	local damageReduction = 100 / ( 100 + targetArmor)
	if targetArmor < 0 then
		damageReduction = 2 - (100 / (100 - targetArmor))
	end		
	damage = damage * damageReduction	
	return damage
end

function AutoUtil:CalculateMagicDamage(target, damage)			
	local targetMR = target.magicResist * myHero.magicPenPercent - myHero.magicPen
	local damageReduction = 100 / ( 100 + targetMR)
	if targetMR < 0 then
		damageReduction = 2 - (100 / (100 - targetMR))
	end		
	damage = damage * damageReduction
	
	return damage
end

function AutoUtil:GetNearestAlly(entity, range)
	local ally = nil
	local distance = _huge
	for i = 1,LocalGameHeroCount()  do
		local hero = LocalGameHero(i)	
		if hero and hero ~= entity and hero.isAlly and HPred:CanTargetALL(hero) then
			local d = HPred:GetDistanceSqr(entity.pos, hero.pos)
			if d < distance and d < range * range then
				distance = d
				ally = hero
			end
		end
	end
	if distance <  range then
		return ally
	end
end

function AutoUtil:NearestEnemy(entity)
	local distance = 999999
	local enemy = nil
	for i = 1,LocalGameHeroCount()  do
		local hero = LocalGameHero(i)	
		if hero and HPred:CanTarget(hero) then
			local d = HPred:GetDistanceSqr(entity.pos, hero.pos)
			if d < distance then
				distance = d
				enemy = hero
			end
		end
	end
	return _sqrt(distance), enemy
end

function AutoUtil:CountEnemiesNear(origin, range)
	local count = 0
	for i  = 1,LocalGameHeroCount(i) do
		local enemy = LocalGameHero(i)
		if enemy and  HPred:CanTarget(enemy) and HPred:IsInRange(origin, enemy.pos, range) then
			count = count + 1
		end			
	end
	return count
end

function AutoUtil:GetItemSlot(id)
	for i = 6, 12 do
		if myHero:GetItemData(i).itemID == id then
			return i
		end
	end

	return nil
end

function AutoUtil:IsItemReady(id, ward)
	if not self.itemKey or #self.itemKey == 0 then
		self.itemKey = 
		{
			HK_ITEM_1,
			HK_ITEM_2,
			HK_ITEM_3,
			HK_ITEM_4,
			HK_ITEM_5,
			HK_ITEM_6,
			HK_ITEM_7
		}
	end
	local slot = self:GetItemSlot(id)
	if slot then
		return myHero:GetSpellData(slot).currentCd == 0 and not (ward and myHero:GetSpellData(slot).ammo == 0)
	end
end

function AutoUtil:CastItem(unit, id, range)
	if unit == myHero or HPred:GetDistance(myHero.pos, unit.pos, range) then
		local keyIndex = self:GetItemSlot(id) - 5
		local key = self.itemKey[keyIndex]

		if key then
			if unit ~= myHero then
				Control.CastSpell(key, unit.pos or unit)
			else
				Control.CastSpell(key)
			end
		end
	end
end
function AutoUtil:CastItemMiniMap(pos, id)
	local keyIndex = self:GetItemSlot(id) - 5
	local key = self.itemKey[keyIndex]
	if key then
		CastSpellMM(key, pos)
	end
end

function AutoUtil:HasBuffType(unit, buffType, duration)	
	for i = 1, unit.buffCount do 
		local Buff = unit:GetBuff(i)
		if Buff.duration > duration and Buff.count > 0  and Buff.type == buffType then 
			return true 
		end
	end
	return false
end



function AutoUtil:UseSupportItems()
	--Use crucible on carry if they are CCd
	if AutoUtil:IsItemReady(3222) then
		AutoUtil:AutoCrucible()
	end	
	
	--Use Locket
	if AutoUtil:IsItemReady(3190) then
		AutoUtil:AutoLocket()
	end
	
	--Use Redemption
	if AutoUtil:IsItemReady(3107) then
		AutoUtil:AutoRedemption()
	end
end


function AutoUtil:AutoCrucible()
	for i = 1, LocalGameHeroCount() do
		local hero = LocalGameHero(i)
		if hero and hero.isAlly and hero.alive and hero ~= myHero then
			if Menu.Items.Crucible.Targets[hero.charName] and Menu.Items.Crucible.Targets[hero.charName]:Value() then
				for ccName, ccType in pairs(_ccNames) do
					if Menu.Items.Crucible.CC[ccName] and Menu.Items.Crucible.CC[ccName]:Value() and self:HasBuffType(hero, ccType, Menu.Items.Crucible.CC.CleanseTime:Value()) then
						AutoUtil:CastItem(hero, 3222, 650)
					end
				end
			end
		end
	end
end

function AutoUtil:AutoLocket()
	local injuredCount = 0
	for i = 1, LocalGameHeroCount() do
		local hero = LocalGameHero(i)
		if hero and _allyHealthPercentage and _allyHealthPercentage[hero.networkID] and hero.isAlly and hero.alive and  HPred:IsInRange(myHero.pos, hero.pos, 700) then			
			local deltaLifeLost = _allyHealthPercentage[hero.networkID] - CurrentPctLife(hero)
			if deltaLifeLost >= Menu.Items.Locket.Threshold:Value() then
				injuredCount = injuredCount + 1
			end
		end
	end	
	if injuredCount >= Menu.Items.Locket.Count:Value() then
		AutoUtil:CastItem(myHero, 3190, _huge)
	end
end

function AutoUtil:AutoRedemption()
	local targetCount = 0
	local aimPos
	for i = 1, LocalGameHeroCount() do
		local hero = LocalGameHero(i)
		if hero and hero.isAlly and HPred:CanTargetALL(hero) and HPred:IsInRange(myHero.pos, hero.pos, 5500) and Menu.Items.Redemption.Targets[hero.charName] and Menu.Items.Redemption.Targets[hero.charName]:Value() >= CurrentPctLife(hero) then		
			--Check if they are immobile for at least the duration we specified
			if HPred:GetImmobileTime(hero) >= Menu.Items.Redemption.Duration:Value() then
				targetCount = 0
				aimPos = hero.pos
				--we can start adding targets within range!!
				for z = 1, LocalGameHeroCount() do
					local target = LocalGameHero(z)
					if target and HPred:CanTargetALL(target) and HPred:IsInRange(hero.pos, HPred:PredictUnitPosition(target, 2),525) then
						targetCount = targetCount + 1						
					end
				end
				if targetCount >= Menu.Items.Redemption.Count:Value() then
					break
				end
			end
		end
	end	
	if aimPos and targetCount >= Menu.Items.Redemption.Count:Value() then		
		AutoUtil:CastItemMiniMap(aimPos, 3107)
	end
end

function AutoUtil:GetExhaust()
	local exhaustHotkey
	local exhaustData = myHero:GetSpellData(SUMMONER_1)
	if exhaustData.name ~= "SummonerExhaust" then
		exhaustData = myHero:GetSpellData(SUMMONER_2)
		exhaustHotkey = HK_SUMMONER_2
	else 
		exhaustHotkey = HK_SUMMONER_1
	end
	
	if exhaustData.name == "SummonerExhaust" and exhaustData.currentCd == 0 then 
		return exhaustHotkey
	end	
end

function AutoUtil:AutoExhaust()
	local exhaustHotkey = AutoUtil:GetExhaust()	
	if not exhaustHotkey or not Menu.Skills.Exhaust then return end
	
	for i = 1, LocalGameHeroCount() do
		local enemy = LocalGameHero(i)
		--It's an enemy who is within exhaust range and is toggled ON in ExhaustList
		if enemy and enemy.isEnemy and HPred:IsInRange(myHero.pos, enemy.pos, 600 + enemy.boundingRadius) and HPred:CanTarget(enemy, 650) and Menu.Skills.Exhaust.Targets[enemy.charName] and Menu.Skills.Exhaust.Targets[enemy.charName]:Value() then
			for allyIndex = 1, LocalGameHeroCount() do
				local ally = LocalGameHero(allyIndex)
				if ally and ally.isAlly and ally.alive and HPred:IsInRange(enemy.pos, ally.pos, 600 + Menu.Skills.Exhaust.Radius:Value()) and CurrentPctLife(ally) <= Menu.Skills.Exhaust.Health:Value() then
					Control.CastSpell(exhaustHotkey, enemy)
					return
				end
			end
		end
	end
end

function AutoUtil:GetCleanse()
	local cleanseHotkey
	local cleanseData = myHero:GetSpellData(SUMMONER_1)
	if cleanseData.name ~= "SummonerBoost" then
		cleanseData = myHero:GetSpellData(SUMMONER_2)
		cleanseHotkey = HK_SUMMONER_2
	else 
		cleanseHotkey = HK_SUMMONER_1
	end	
	if cleanseData.name == "SummonerBoost" and cleanseData.currentCd < 2 then 
		return cleanseHotkey
	end	
end

function AutoUtil:AutoCleanse()
	local cleanseHotkey = AutoUtil:GetCleanse()	
	if not cleanseHotkey or not Menu.Skills.Cleanse then return end
	if not Menu.Skills.Combo then return end
	if Menu.Skills.Cleanse.Enabled:Value() and (Menu.Skills.Combo:Value() or not Menu.Skills.Cleanse.Combo:Value()) then
		for ccName, ccType in pairs(_ccNames) do
			if Menu.Skills.Cleanse.CC[ccName] and Menu.Skills.Cleanse.CC[ccName]:Value() and AutoUtil:HasBuffType(myHero, ccType, Menu.Skills.Cleanse.CleanseTime:Value()) then
				Control.CastSpell(cleanseHotkey)
				return
			end
		end
	end
end

class "HPred"

local LocalGameHeroCount = Game.HeroCount;
local LocalGameMinionCount = Game.MinionCount;
local LocalGameHero = Game.Hero;
local LocalGameMinion = Game.Minion;
local _insert = table.insert
local _sort = table.sort
local _atan = math.atan2
local _pi = math.pi
local _max = math.max
local _min = math.min
local _abs = math.abs
local _sqrt = math.sqrt
local _find = string.find
local _sub = string.sub
local _len = string.len
	
local _tickFrequency = .2
local _nextTick = Game.Timer()
local _reviveLookupTable = 
	{ 
		["LifeAura.troy"] = 4, 
		["ZileanBase_R_Buf.troy"] = 3,
		["Aatrox_Base_Passive_Death_Activate"] = 3
		
		--TwistedFate_Base_R_Gatemarker_Red
			--String match would be ideal.... could be different in other skins
	}

--Stores a collection of spells that will cause a character to blink
	--Ground targeted spells go towards mouse castPos with a maximum range
	--Hero/Minion targeted spells have a direction type to determine where we will land relative to our target (in front of, behind, etc)
	
--Key = Spell name
--Value = range a spell can travel, OR a targeted end position type, OR a list of particles the spell can teleport to	
local _blinkSpellLookupTable = 
	{ 
		["EzrealArcaneShift"] = 475, 
		["RiftWalk"] = 500,
		
		--Ekko and other similar blinks end up between their start pos and target pos (in front of their target relatively speaking)
		["EkkoEAttack"] = 0,
		["AlphaStrike"] = 0,
		
		--Katarina E ends on the side of her target closest to where her mouse was... 
		["KatarinaE"] = -255,
		
		--Katarina can target a dagger to teleport directly to it: Each skin has a different particle name. This should cover all of them.
		["KatarinaEDagger"] = { "Katarina_Base_Dagger_Ground_Indicator","Katarina_Skin01_Dagger_Ground_Indicator","Katarina_Skin02_Dagger_Ground_Indicator","Katarina_Skin03_Dagger_Ground_Indicator","Katarina_Skin04_Dagger_Ground_Indicator","Katarina_Skin05_Dagger_Ground_Indicator","Katarina_Skin06_Dagger_Ground_Indicator","Katarina_Skin07_Dagger_Ground_Indicator" ,"Katarina_Skin08_Dagger_Ground_Indicator","Katarina_Skin09_Dagger_Ground_Indicator"  }, 
	}

local _blinkLookupTable = 
	{ 
		"global_ss_flash_02.troy",
		"Lissandra_Base_E_Arrival.troy",
		"LeBlanc_Base_W_return_activation.troy"
		--TODO: Check if liss/leblanc have diff skill versions. MOST likely dont but worth checking for completion sake
		
		--Zed uses 'switch shadows'... It will require some special checks to choose the shadow he's going TO not from...
		--Shaco deceive no longer has any particles where you jump to so it cant be tracked (no spell data or particles showing path)
		
	}

local _cachedBlinks = {}
local _cachedRevives = {}
local _cachedTeleports = {}

--Cache of all TARGETED missiles currently running
local _cachedMissiles = {}
local _incomingDamage = {}

--Cache of active enemy windwalls so we can calculate it when dealing with collision checks
local _windwall
local _windwallStartPos
local _windwallWidth

local _OnVision = {}
function HPred:OnVision(unit)
	if unit == nil or type(unit) ~= "userdata" then return end
	if _OnVision[unit.networkID] == nil then _OnVision[unit.networkID] = {visible = unit.visible , tick = GetTickCount(), pos = unit.pos } end
	if _OnVision[unit.networkID].visible == true and not unit.visible then _OnVision[unit.networkID].visible = false _OnVision[unit.networkID].tick = GetTickCount() end
	if _OnVision[unit.networkID].visible == false and unit.visible then _OnVision[unit.networkID].visible = true _OnVision[unit.networkID].tick = GetTickCount() _OnVision[unit.networkID].pos = unit.pos end
	return _OnVision[unit.networkID]
end

--This must be called manually - It's not on by default because we've tracked down most of the freeze issues to this.
function HPred:Tick()
	
	
	--Update missile cache
	--DISABLED UNTIL LATER.
	--self:CacheMissiles()
	
	--Limit how often tick logic runs
	if _nextTick > Game.Timer() then return end
	_nextTick = Game.Timer() + _tickFrequency
	
	--Update hero movement history	
	for i = 1, LocalGameHeroCount() do
		local t = LocalGameHero(i)
		if t then
			if t.isEnemy then
				HPred:OnVision(t)
			end
		end
	end
	
	--Do not run rest of logic until freeze issues are fully tracked down
	if true then return end
	
	
	--Remove old cached teleports	
	for _, teleport in pairs(_cachedTeleports) do
		if teleport and Game.Timer() > teleport.expireTime + .5 then
			_cachedTeleports[_] = nil
		end
	end	
	
	--Update teleport cache
	HPred:CacheTeleports()	
	
	
	--Record windwall
	HPred:CacheParticles()
	
	--Remove old cached revives
	for _, revive in pairs(_cachedRevives) do
		if Game.Timer() > revive.expireTime + .5 then
			_cachedRevives[_] = nil
		end
	end
	
	--Remove old cached blinks
	for _, revive in pairs(_cachedRevives) do
		if Game.Timer() > revive.expireTime + .5 then
			_cachedRevives[_] = nil
		end
	end
	
	for i = 1, LocalGameParticleCount() do 
		local particle = LocalGameParticle(i)
		--Record revives
		if particle and not _cachedRevives[particle.networkID] and  _reviveLookupTable[particle.name] then
			_cachedRevives[particle.networkID] = {}
			_cachedRevives[particle.networkID]["expireTime"] = Game.Timer() + _reviveLookupTable[particle.name]			
			local target = HPred:GetHeroByPosition(particle.pos)
			if target.isEnemy then				
				_cachedRevives[particle.networkID]["target"] = target
				_cachedRevives[particle.networkID]["pos"] = target.pos
				_cachedRevives[particle.networkID]["isEnemy"] = target.isEnemy	
			end
		end
		
		--Record blinks
		if particle and not _cachedBlinks[particle.networkID] and  _blinkLookupTable[particle.name] then
			_cachedBlinks[particle.networkID] = {}
			_cachedBlinks[particle.networkID]["expireTime"] = Game.Timer() + _reviveLookupTable[particle.name]			
			local target = HPred:GetHeroByPosition(particle.pos)
			if target.isEnemy then				
				_cachedBlinks[particle.networkID]["target"] = target
				_cachedBlinks[particle.networkID]["pos"] = target.pos
				_cachedBlinks[particle.networkID]["isEnemy"] = target.isEnemy	
			end
		end
	end
	
end

function HPred:GetEnemyNexusPosition()
	--This is slightly wrong. It represents fountain not the nexus. Fix later.
	if myHero.team == 100 then return Vector(14340, 171.977722167969, 14390); else return Vector(396,182.132507324219,462); end
end


function HPred:GetGuarenteedTarget(source, range, delay, speed, radius, timingAccuracy, checkCollision)
	--Get hourglass enemies
	local target, aimPosition =self:GetHourglassTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	if target and aimPosition then
		return target, aimPosition
	end
	
	--Get reviving target
	local target, aimPosition =self:GetRevivingTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	if target and aimPosition then
		return target, aimPosition
	end	
	
	--Get teleporting enemies
	local target, aimPosition =self:GetTeleportingTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)	
	if target and aimPosition then
		return target, aimPosition
	end
	
	--Get stunned enemies
	local target, aimPosition =self:GetImmobileTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	if target and aimPosition then
		return target, aimPosition
	end
end


function HPred:GetReliableTarget(source, range, delay, speed, radius, timingAccuracy, checkCollision)
	--TODO: Target whitelist. This will target anyone which is definitely not what we want
	--For now we can handle in the champ script. That will cause issues with multiple people in range who are goood targets though.
	
	
	--Get hourglass enemies
	local target, aimPosition =self:GetHourglassTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	if target and aimPosition then
		return target, aimPosition
	end
	
	--Get reviving target
	local target, aimPosition =self:GetRevivingTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	if target and aimPosition then
		return target, aimPosition
	end
	
	--Get channeling enemies
	--local target, aimPosition =self:GetChannelingTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	--	if target and aimPosition then
	--	return target, aimPosition
	--end
	
	--Get teleporting enemies
	local target, aimPosition =self:GetTeleportingTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)	
	if target and aimPosition then
		return target, aimPosition
	end
	
	--Get instant dash enemies
	local target, aimPosition =self:GetInstantDashTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	if target and aimPosition then
		return target, aimPosition
	end	
	
	--Get dashing enemies
	local target, aimPosition =self:GetDashingTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius, midDash)
	if target and aimPosition then
		return target, aimPosition
	end
	
	--Get stunned enemies
	local target, aimPosition =self:GetImmobileTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	if target and aimPosition then
		return target, aimPosition
	end
	
	--Get blink targets
	local target, aimPosition =self:GetBlinkTarget(source, range, speed, delay, checkCollision, radius)
	if target and aimPosition then
		return target, aimPosition
	end	
end

--Will return how many allies or enemies will be hit by a linear spell based on current waypoint data.
function HPred:GetLineTargetCount(source, aimPos, delay, speed, width, targetAllies)
	local targetCount = 0
	for i = 1, LocalGameHeroCount() do
		local t = LocalGameHero(i)
		if t and self:CanTargetALL(t) and ( targetAllies or t.isEnemy) then
			
			local predictedPos = self:PredictUnitPosition(t, delay+ self:GetDistance(source, t.pos) / speed)
			local proj1, pointLine, isOnSegment = self:VectorPointProjectionOnLineSegment(source, aimPos, predictedPos)
			if proj1 and isOnSegment and (self:GetDistanceSqr(predictedPos, proj1) <= (t.boundingRadius + width) * (t.boundingRadius + width)) then
				targetCount = targetCount + 1
			end
		end
	end
	return targetCount
end

--Will return the valid target who has the highest hit chance and meets all conditions (minHitChance, whitelist check, etc)
function HPred:GetUnreliableTarget(source, range, delay, speed, radius, checkCollision, minimumHitChance, whitelist, isLine)
	local _validTargets = {}
	for i = 1, LocalGameHeroCount() do
		local t = LocalGameHero(i)		
		if t and self:CanTarget(t, true) and (not whitelist or whitelist[t.charName]) then
			local hitChance, aimPosition = self:GetHitchance(source, t, range, delay, speed, radius, checkCollision, isLine)		
			if hitChance >= minimumHitChance then
				_insert(_validTargets, {aimPosition,hitChance, hitChance * 100 + AutoUtil:CalculateMagicDamage(t, 400)})
			end
		end
	end	
	_sort(_validTargets, function( a, b ) return a[3] >b[3] end)	
	if #_validTargets > 0 then	
		return _validTargets[1][2], _validTargets[1][1]
	end
end

function HPred:GetHitchance(source, target, range, delay, speed, radius, checkCollision, isLine)

	if isLine == nil and checkCollision then
		isLine = true
	end
	
	local hitChance = 1
	local aimPosition = self:PredictUnitPosition(target, delay + self:GetDistance(source, target.pos) / speed)	
	local interceptTime = self:GetSpellInterceptTime(source, aimPosition, delay, speed)
	local reactionTime = self:PredictReactionTime(target, .1, isLine)
	
	--Check if they are walking the same path as the line or very close to it
	if isLine then
		local pathVector = aimPosition - target.pos
		local castVector = (aimPosition - myHero.pos):Normalized()
		if pathVector.x + pathVector.z ~= 0 then
			pathVector = pathVector:Normalized()
			if pathVector:DotProduct(castVector) < -.85 or pathVector:DotProduct(castVector) > .85 then
				if speed > 3000 then
					reactionTime = reactionTime + .25
				else
					reactionTime = reactionTime + .15
				end
			end
		end
	end			

	--If they are standing still give a higher accuracy because they have to take actions to react to it
	if not target.pathing or not target.pathing.hasMovePath then
		hitChancevisionData = 2
	end	
	
	
	local origin,movementRadius = self:UnitMovementBounds(target, interceptTime, reactionTime)
	--Our spell is so wide or the target so slow or their reaction time is such that the spell will be nearly impossible to avoid
	if movementRadius - target.boundingRadius <= radius /2 then
		origin,movementRadius = self:UnitMovementBounds(target, interceptTime, 0)
		if movementRadius - target.boundingRadius <= radius /2 then
			hitChance = 4
		else		
			hitChance = 3
		end
	end	
	
	--If they are casting a spell then the accuracy will be fairly high. if the windup is longer than our delay then it's quite likely to hit. 
	--Ideally we would predict where they will go AFTER the spell finishes but that's beyond the scope of this prediction
	if target.activeSpell and target.activeSpell.valid then
		if target.activeSpell.startTime + target.activeSpell.windup - Game.Timer() >= delay then
			hitChance = 5
		else			
			hitChance = 3
		end
	end
	
	local visionData = HPred:OnVision(target)
	if visionData and visionData.visible == false then
		local hiddenTime = visionData.tick -GetTickCount()
		if hiddenTime < -1000 then
			hitChance = -1
		else
			local targetSpeed = self:GetTargetMS(target)
			local unitPos = target.pos + Vector(target.pos,target.posTo):Normalized() * ((GetTickCount() - visionData.tick)/1000 * targetSpeed)
			local aimPosition = unitPos + Vector(target.pos,target.posTo):Normalized() * (targetSpeed * (delay + (self:GetDistance(myHero.pos,unitPos)/speed)))
			if self:GetDistance(target.pos,aimPosition) > self:GetDistance(target.pos,target.posTo) then aimPosition = target.posTo end
			hitChance = _min(hitChance, 2)
		end
	end
	
	--Check for out of range
	if not self:IsInRange(source, aimPosition, range) then
		hitChance = -1
	end
	
	--Check minion block
	if hitChance > 0 and checkCollision then
		if self:IsWindwallBlocking(source, aimPosition) then
			hitChance = -1		
		elseif self:CheckMinionCollision(source, aimPosition, delay, speed, radius) then
			hitChance = -1
		end
	end
	
	return hitChance, aimPosition
end

function HPred:PredictReactionTime(unit, minimumReactionTime)
	local reactionTime = minimumReactionTime
	
	--If the target is auto attacking increase their reaction time by .15s - If using a skill use the remaining windup time
	if unit.activeSpell and unit.activeSpell.valid then
		local windupRemaining = unit.activeSpell.startTime + unit.activeSpell.windup - Game.Timer()
		if windupRemaining > 0 then
			reactionTime = windupRemaining
		end
	end	
	return reactionTime
end

function HPred:GetDashingTarget(source, range, delay, speed, dashThreshold, checkCollision, radius, midDash)

	local target
	local aimPosition
	for i = 1, LocalGameHeroCount() do
		local t = LocalGameHero(i)
		if t and t.isEnemy and t.pathing.hasMovePath and t.pathing.isDashing and t.pathing.dashSpeed>500  then
			local dashEndPosition = t:GetPath(1)
			if self:IsInRange(source, dashEndPosition, range) then				
				--The dash ends within range of our skill. We now need to find if our spell can connect with them very close to the time their dash will end
				local dashTimeRemaining = self:GetDistance(t.pos, dashEndPosition) / t.pathing.dashSpeed
				local skillInterceptTime = self:GetSpellInterceptTime(source, dashEndPosition, delay, speed)
				local deltaInterceptTime =skillInterceptTime - dashTimeRemaining
				if deltaInterceptTime > 0 and deltaInterceptTime < dashThreshold and (not checkCollision or not self:CheckMinionCollision(source, dashEndPosition, delay, speed, radius)) then
					target = t
					aimPosition = dashEndPosition
					return target, aimPosition
				end
			end			
		end
	end
end

function HPred:GetHourglassTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	local target
	local aimPosition
	for i = 1, LocalGameHeroCount() do
		local t = LocalGameHero(i)
		if t and t.isEnemy then		
			local success, timeRemaining = self:HasBuff(t, "zhonyasringshield")
			if success then
				local spellInterceptTime = self:GetSpellInterceptTime(source, t.pos, delay, speed)
				local deltaInterceptTime = spellInterceptTime - timeRemaining
				if spellInterceptTime > timeRemaining and deltaInterceptTime < timingAccuracy and (not checkCollision or not self:CheckMinionCollision(source, interceptPosition, delay, speed, radius)) then
					target = t
					aimPosition = t.pos
					return target, aimPosition
				end
			end
		end
	end
end

function HPred:GetRevivingTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	local target
	local aimPosition
	for _, revive in pairs(_cachedRevives) do	
		if revive.isEnemy then
			local interceptTime = self:GetSpellInterceptTime(source, revive.pos, delay, speed)
			if interceptTime > revive.expireTime - Game.Timer() and interceptTime - revive.expireTime - Game.Timer() < timingAccuracy then
				target = revive.target
				aimPosition = revive.pos
				return target, aimPosition
			end
		end
	end	
end

function HPred:GetInstantDashTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	local target
	local aimPosition
	for i = 1, LocalGameHeroCount() do
		local t = LocalGameHero(i)
		if t and t.isEnemy and t.activeSpell and t.activeSpell.valid and _blinkSpellLookupTable[t.activeSpell.name] then
			local windupRemaining = t.activeSpell.startTime + t.activeSpell.windup - Game.Timer()
			if windupRemaining > 0 then
				local endPos
				local blinkRange = _blinkSpellLookupTable[t.activeSpell.name]
				if type(blinkRange) == "table" then
					--Find the nearest matching particle to our mouse
					--local target, distance = self:GetNearestParticleByNames(t.pos, blinkRange)
					--if target and distance < 250 then					
					--	endPos = target.pos		
					--end
				elseif blinkRange > 0 then
					endPos = Vector(t.activeSpell.placementPos.x, t.activeSpell.placementPos.y, t.activeSpell.placementPos.z)					
					endPos = t.activeSpell.startPos + (endPos- t.activeSpell.startPos):Normalized() * _min(self:GetDistance(t.activeSpell.startPos,endPos), range)
				else
					local blinkTarget = self:GetObjectByHandle(t.activeSpell.target)
					if blinkTarget then				
						local offsetDirection						
						
						--We will land in front of our target relative to our starting position
						if blinkRange == 0 then				

							if t.activeSpell.name ==  "AlphaStrike" then
								windupRemaining = windupRemaining + .75
								--TODO: Boost the windup time by the number of targets alpha will hit. Need to calculate the exact times this is just rough testing right now
							end						
							offsetDirection = (blinkTarget.pos - t.pos):Normalized()
						--We will land behind our target relative to our starting position
						elseif blinkRange == -1 then						
							offsetDirection = (t.pos-blinkTarget.pos):Normalized()
						--They can choose which side of target to come out on , there is no way currently to read this data so we will only use this calculation if the spell radius is large
						elseif blinkRange == -255 then
							if radius > 250 then
								endPos = blinkTarget.pos
							end							
						end
						
						if offsetDirection then
							endPos = blinkTarget.pos - offsetDirection * blinkTarget.boundingRadius
						end
						
					end
				end	
				
				local interceptTime = self:GetSpellInterceptTime(source, endPos, delay,speed)
				local deltaInterceptTime = interceptTime - windupRemaining
				if self:IsInRange(source, endPos, range) and deltaInterceptTime < timingAccuracy and (not checkCollision or not self:CheckMinionCollision(source, endPos, delay, speed, radius)) then
					target = t
					aimPosition = endPos
					return target,aimPosition					
				end
			end
		end
	end
end

function HPred:GetBlinkTarget(source, range, speed, delay, checkCollision, radius)
	local target
	local aimPosition
	for _, particle in pairs(_cachedBlinks) do
		if particle  and self:IsInRange(source, particle.pos, range) then
			local t = particle.target
			local pPos = particle.pos
			if t and t.isEnemy and (not checkCollision or not self:CheckMinionCollision(source, pPos, delay, speed, radius)) then
				target = t
				aimPosition = pPos
				return target,aimPosition
			end
		end		
	end
end

function HPred:GetChannelingTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	local target
	local aimPosition
	for i = 1, LocalGameHeroCount() do
		local t = LocalGameHero(i)
		if t then
			local interceptTime = self:GetSpellInterceptTime(source, t.pos, delay, speed)
			if self:CanTarget(t) and self:IsInRange(source, t.pos, range) and self:IsChannelling(t, interceptTime) and (not checkCollision or not self:CheckMinionCollision(source, t.pos, delay, speed, radius)) then
				target = t
				aimPosition = t.pos	
				return target, aimPosition
			end
		end
	end
end

function HPred:GetImmobileTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	local target
	local aimPosition
	for i = 1, LocalGameHeroCount() do
		local t = LocalGameHero(i)
		if t and self:CanTarget(t) and self:IsInRange(source, t.pos, range) then
			local immobileTime = self:GetImmobileTime(t)
			
			local interceptTime = self:GetSpellInterceptTime(source, t.pos, delay, speed)
			if immobileTime - interceptTime > timingAccuracy and (not checkCollision or not self:CheckMinionCollision(source, t.pos, delay, speed, radius)) then
				target = t
				aimPosition = t.pos
				return target, aimPosition
			end
		end
	end
end

function HPred:CacheTeleports()
	--Get enemies who are teleporting to towers
	for i = 1, LocalGameTurretCount() do
		local turret = LocalGameTurret(i);
		if turret and turret.isEnemy and not _cachedTeleports[turret.networkID] then
			local hasBuff, expiresAt = self:HasBuff(turret, "teleport_target")
			if hasBuff then
				self:RecordTeleport(turret, self:GetTeleportOffset(turret.pos,223.31),expiresAt)
			end
		end
	end	
	
	--Get enemies who are teleporting to wards	
	for i = 1, LocalGameWardCount() do
		local ward = LocalGameWard(i);
		if ward and ward.isEnemy and not _cachedTeleports[ward.networkID] then
			local hasBuff, expiresAt = self:HasBuff(ward, "teleport_target")
			if hasBuff then
				self:RecordTeleport(ward, self:GetTeleportOffset(ward.pos,100.01),expiresAt)
			end
		end
	end
	
	--Get enemies who are teleporting to minions
	for i = 1, LocalGameMinionCount() do
		local minion = LocalGameMinion(i);
		if minion and minion.isEnemy and not _cachedTeleports[minion.networkID] then
			local hasBuff, expiresAt = self:HasBuff(minion, "teleport_target")
			if hasBuff then
				self:RecordTeleport(minion, self:GetTeleportOffset(minion.pos,143.25),expiresAt)
			end
		end
	end	
end

function HPred:RecordTeleport(target, aimPos, endTime)
	_cachedTeleports[target.networkID] = {}
	_cachedTeleports[target.networkID]["target"] = target
	_cachedTeleports[target.networkID]["aimPos"] = aimPos
	_cachedTeleports[target.networkID]["expireTime"] = endTime + Game.Timer()
end


function HPred:CalculateIncomingDamage()
	_incomingDamage = {}
	local currentTime = Game.Timer()
	for _, missile in pairs(_cachedMissiles) do
		if missile then 
			local dist = self:GetDistance(missile.data.pos, missile.target.pos)			
			if missile.name == "" or currentTime >= missile.timeout or dist < missile.target.boundingRadius then
				_cachedMissiles[_] = nil
			else
				if not _incomingDamage[missile.target.networkID] then
					_incomingDamage[missile.target.networkID] = missile.damage
				else
					_incomingDamage[missile.target.networkID] = _incomingDamage[missile.target.networkID] + missile.damage
				end
			end
		end
	end	
end

function HPred:GetIncomingDamage(target)
	local damage = 0
	if _incomingDamage[target.networkID] then
		damage = _incomingDamage[target.networkID]
	end
	return damage
end


local _maxCacheRange = 3000

--Right now only used to cache enemy windwalls
function HPred:CacheParticles()	
	if _windwall and _windwall.name == "" then
		_windwall = nil
	end
	
	for i = 1, LocalGameParticleCount() do
		local particle = LocalGameParticle(i)		
		if particle and self:IsInRange(particle.pos, myHero.pos, _maxCacheRange) then			
			if _find(particle.name, "W_windwall%d") and not _windwall then
				--We don't care about ally windwalls for now
				local owner =  self:GetObjectByHandle(particle.handle)
				if owner and owner.isEnemy then
					_windwall = particle
					_windwallStartPos = Vector(particle.pos.x, particle.pos.y, particle.pos.z)				
					
					local index = _len(particle.name) - 5
					local spellLevel = _sub(particle.name, index, index) -1
					--Simple fix
					if type(spellLevel) ~= "number" then
						spellLevel = 1
					end
					_windwallWidth = 150 + spellLevel * 25					
				end
			end
		end
	end
end

function HPred:CacheMissiles()
	local currentTime = Game.Timer()
	for i = 1, LocalGameMissileCount() do
		local missile = LocalGameMissile(i)
		if missile and not _cachedMissiles[missile.networkID] and missile.missileData then
			--Handle targeted missiles
			if missile.missileData.target and missile.missileData.owner then
				local missileName = missile.missileData.name
				local owner =  self:GetObjectByHandle(missile.missileData.owner)	
				local target =  self:GetObjectByHandle(missile.missileData.target)		
				if owner and target and _find(target.type, "Hero") then			
					--The missile is an auto attack of some sort that is targeting a player	
					if (_find(missileName, "BasicAttack") or _find(missileName, "CritAttack")) then
						--Cache it all and update the count
						_cachedMissiles[missile.networkID] = {}
						_cachedMissiles[missile.networkID].target = target
						_cachedMissiles[missile.networkID].data = missile
						_cachedMissiles[missile.networkID].danger = 1
						_cachedMissiles[missile.networkID].timeout = currentTime + 1.5
						
						local damage = owner.totalDamage
						if _find(missileName, "CritAttack") then
							--Leave it rough we're not that concerned
							damage = damage * 1.5
						end						
						_cachedMissiles[missile.networkID].damage = self:CalculatePhysicalDamage(target, damage)
					end
				end
			end
		end
	end
end

function HPred:CalculatePhysicalDamage(target, damage)			
	local targetArmor = target.armor * myHero.armorPenPercent - myHero.armorPen
	local damageReduction = 100 / ( 100 + targetArmor)
	if targetArmor < 0 then
		damageReduction = 2 - (100 / (100 - targetArmor))
	end		
	damage = damage * damageReduction	
	return damage
end

function HPred:CalculateMagicDamage(target, damage)			
	local targetMR = target.magicResist * myHero.magicPenPercent - myHero.magicPen
	local damageReduction = 100 / ( 100 + targetMR)
	if targetMR < 0 then
		damageReduction = 2 - (100 / (100 - targetMR))
	end		
	damage = damage * damageReduction
	
	return damage
end


function HPred:GetTeleportingTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)

	local target
	local aimPosition
	for _, teleport in pairs(_cachedTeleports) do
		if teleport.expireTime > Game.Timer() and self:IsInRange(source,teleport.aimPos, range) then			
			local spellInterceptTime = self:GetSpellInterceptTime(source, teleport.aimPos, delay, speed)
			local teleportRemaining = teleport.expireTime - Game.Timer()
			if spellInterceptTime > teleportRemaining and spellInterceptTime - teleportRemaining <= timingAccuracy and (not checkCollision or not self:CheckMinionCollision(source, teleport.aimPos, delay, speed, radius)) then								
				target = teleport.target
				aimPosition = teleport.aimPos
				return target, aimPosition
			end
		end
	end		
end

function HPred:GetTargetMS(target)
	local ms = target.pathing.isDashing and target.pathing.dashSpeed or target.ms
	return ms
end

function HPred:Angle(A, B)
	local deltaPos = A - B
	local angle = _atan(deltaPos.x, deltaPos.z) *  180 / _pi	
	if angle < 0 then angle = angle + 360 end
	return angle
end

--Returns where the unit will be when the delay has passed given current pathing information. This assumes the target makes NO CHANGES during the delay.
function HPred:PredictUnitPosition(unit, delay)
	local predictedPosition = unit.pos
	local timeRemaining = delay
	local pathNodes = self:GetPathNodes(unit)
	for i = 1, #pathNodes -1 do
		local nodeDistance = self:GetDistance(pathNodes[i], pathNodes[i +1])
		local nodeTraversalTime = nodeDistance / self:GetTargetMS(unit)
			
		if timeRemaining > nodeTraversalTime then
			--This node of the path will be completed before the delay has finished. Move on to the next node if one remains
			timeRemaining =  timeRemaining - nodeTraversalTime
			predictedPosition = pathNodes[i + 1]
		else
			local directionVector = (pathNodes[i+1] - pathNodes[i]):Normalized()
			predictedPosition = pathNodes[i] + directionVector *  self:GetTargetMS(unit) * timeRemaining
			break;
		end
	end
	return predictedPosition
end

function HPred:IsChannelling(target, interceptTime)
	if target.activeSpell and target.activeSpell.valid and target.activeSpell.isChanneling then
		return true
	end
end

function HPred:HasBuff(target, buffName, minimumDuration)
	local duration = minimumDuration
	if not minimumDuration then
		duration = 0
	end
	local durationRemaining
	for i = 1, target.buffCount do 
		local buff = target:GetBuff(i)
		if buff.duration > duration and buff.name == buffName then
			durationRemaining = buff.duration
			return true, durationRemaining
		end
	end
end

--Moves an origin towards the enemy team nexus by magnitude
function HPred:GetTeleportOffset(origin, magnitude)
	local teleportOffset = origin + (self:GetEnemyNexusPosition()- origin):Normalized() * magnitude
	return teleportOffset
end

function HPred:GetSpellInterceptTime(startPos, endPos, delay, speed)	
	local interceptTime = Game.Latency()/2000 + delay + self:GetDistance(startPos, endPos) / speed
	return interceptTime
end

--Checks if a target can be targeted by abilities or auto attacks currently.
--CanTarget(target)
	--target : gameObject we are trying to hit
function HPred:CanTarget(target, allowInvisible)
	return target.isEnemy and target.alive and target.health > 0  and (allowInvisible or target.visible) and target.isTargetable
end

--Derp: dont want to fuck with the isEnemy checks elsewhere. This will just let us know if the target can actually be hit by something even if its an ally
function HPred:CanTargetALL(target)
	return target.alive and target.health > 0 and target.visible and target.isTargetable
end

--Returns a position and radius in which the target could potentially move before the delay ends. ReactionTime defines how quick we expect the target to be able to change their current path
function HPred:UnitMovementBounds(unit, delay, reactionTime)
	local startPosition = self:PredictUnitPosition(unit, delay)
	
	local radius = 0
	local deltaDelay = delay -reactionTime- self:GetImmobileTime(unit)	
	if (deltaDelay >0) then
		radius = self:GetTargetMS(unit) * deltaDelay	
	end
	return startPosition, radius	
end

--Returns how long (in seconds) the target will be unable to move from their current location
function HPred:GetImmobileTime(unit)
	local duration = 0
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i);
		if buff.count > 0 and buff.duration> duration and (buff.type == 5 or buff.type == 8 or buff.type == 21 or buff.type == 22 or buff.type == 24 or buff.type == 11 or buff.type == 29 or buff.type == 30 or buff.type == 39 ) then
			duration = buff.duration
		end
	end
	return duration		
end

--Returns how long (in seconds) the target will be slowed for
function HPred:GetSlowedTime(unit)
	local duration = 0
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i);
		if buff.count > 0 and buff.duration > duration and buff.type == 10 then
			duration = buff.duration			
			return duration
		end
	end
	return duration		
end

--Returns all existing path nodes
function HPred:GetPathNodes(unit)
	local nodes = {}
	table.insert(nodes, unit.pos)
	if unit.pathing.hasMovePath then
		for i = unit.pathing.pathIndex, unit.pathing.pathCount do
			path = unit:GetPath(i)
			table.insert(nodes, path)
		end
	end		
	return nodes
end

--Finds any game object with the correct handle to match (hero, minion, wards on either team)
function HPred:GetObjectByHandle(handle)
	local target
	for i = 1, LocalGameHeroCount() do
		local enemy = LocalGameHero(i)
		if enemy and enemy.handle == handle then
			target = enemy
			return target
		end
	end
	
	for i = 1, LocalGameMinionCount() do
		local minion = LocalGameMinion(i)
		if minion and minion.handle == handle then
			target = minion
			return target
		end
	end
	
	for i = 1, LocalGameWardCount() do
		local ward = LocalGameWard(i);
		if ward and ward.handle == handle then
			target = ward
			return target
		end
	end
	
	for i = 1, LocalGameTurretCount() do 
		local turret = LocalGameTurret(i)
		if turret and turret.handle == handle then
			target = turret
			return target
		end
	end
	
	for i = 1, LocalGameParticleCount() do 
		local particle = LocalGameParticle(i)
		if particle and particle.handle == handle then
			target = particle
			return target
		end
	end
end

function HPred:GetHeroByPosition(position)
	local target
	for i = 1, LocalGameHeroCount() do
		local enemy = LocalGameHero(i)
		if enemy and enemy.pos.x == position.x and enemy.pos.y == position.y and enemy.pos.z == position.z then
			target = enemy
			return target
		end
	end
end

function HPred:GetObjectByPosition(position)
	local target
	for i = 1, LocalGameHeroCount() do
		local enemy = LocalGameHero(i)
		if enemy and enemy.pos.x == position.x and enemy.pos.y == position.y and enemy.pos.z == position.z then
			target = enemy
			return target
		end
	end
	
	for i = 1, LocalGameMinionCount() do
		local enemy = LocalGameMinion(i)
		if enemy and enemy.pos.x == position.x and enemy.pos.y == position.y and enemy.pos.z == position.z then
			target = enemy
			return target
		end
	end
	
	for i = 1, LocalGameWardCount() do
		local enemy = LocalGameWard(i);
		if enemy and enemy.pos.x == position.x and enemy.pos.y == position.y and enemy.pos.z == position.z then
			target = enemy
			return target
		end
	end
	
	for i = 1, LocalGameParticleCount() do 
		local enemy = LocalGameParticle(i)
		if enemy and enemy.pos.x == position.x and enemy.pos.y == position.y and enemy.pos.z == position.z then
			target = enemy
			return target
		end
	end
end

function HPred:GetEnemyHeroByHandle(handle)	
	local target
	for i = 1, LocalGameHeroCount() do
		local enemy = LocalGameHero(i)
		if enemy and enemy.handle == handle then
			target = enemy
			return target
		end
	end
end

--Finds the closest particle to the origin that is contained in the names array
function HPred:GetNearestParticleByNames(origin, names)
	local target
	local distance = 999999
	for i = 1, LocalGameParticleCount() do 
		local particle = LocalGameParticle(i)
		if particle then 
			local d = self:GetDistance(origin, particle.pos)
			if d < distance then
				distance = d
				target = particle
			end
		end
	end
	return target, distance
end

--Returns the total distance of our current path so we can calculate how long it will take to complete
function HPred:GetPathLength(nodes)
	local result = 0
	for i = 1, #nodes -1 do
		result = result + self:GetDistance(nodes[i], nodes[i + 1])
	end
	return result
end


--I know this isn't efficient but it works accurately... Leaving it for now.
function HPred:CheckMinionCollision(origin, endPos, delay, speed, radius, frequency)
		
	if not frequency then
		frequency = radius
	end
	local directionVector = (endPos - origin):Normalized()
	local checkCount = self:GetDistance(origin, endPos) / frequency
	for i = 1, checkCount do
		local checkPosition = origin + directionVector * i * frequency
		local checkDelay = delay + self:GetDistance(origin, checkPosition) / speed
		if self:IsMinionIntersection(checkPosition, radius, checkDelay, radius * 3) then
			return true
		end
	end
	return false
end


function HPred:IsMinionIntersection(location, radius, delay, maxDistance)
	if not maxDistance then
		maxDistance = 500
	end
	for i = 1, LocalGameMinionCount() do
		local minion = LocalGameMinion(i)
		if minion and self:CanTarget(minion) and self:IsInRange(minion.pos, location, maxDistance) then
			local predictedPosition = self:PredictUnitPosition(minion, delay)
			if self:IsInRange(location, predictedPosition, radius + minion.boundingRadius) then
				return true
			end
		end
	end
	return false
end

function HPred:VectorPointProjectionOnLineSegment(v1, v2, v)
	assert(v1 and v2 and v, "VectorPointProjectionOnLineSegment: wrong argument types (3 <Vector> expected)")
	local cx, cy, ax, ay, bx, by = v.x, (v.z or v.y), v1.x, (v1.z or v1.y), v2.x, (v2.z or v2.y)
	local rL = ((cx - ax) * (bx - ax) + (cy - ay) * (by - ay)) / ((bx - ax) * (bx - ax) + (by - ay) * (by - ay))
	local pointLine = { x = ax + rL * (bx - ax), y = ay + rL * (by - ay) }
	local rS = rL < 0 and 0 or (rL > 1 and 1 or rL)
	local isOnSegment = rS == rL
	local pointSegment = isOnSegment and pointLine or { x = ax + rS * (bx - ax), y = ay + rS * (by - ay) }
	return pointSegment, pointLine, isOnSegment
end

--Determines if there is a windwall between the source and target pos. 
function HPred:IsWindwallBlocking(source, target)
	if _windwall then
		local windwallFacing = (_windwallStartPos-_windwall.pos):Normalized()
		return self:DoLineSegmentsIntersect(source, target, _windwall.pos + windwallFacing:Perpendicular() * _windwallWidth, _windwall.pos + windwallFacing:Perpendicular2() * _windwallWidth)
	end	
	return false
end
--Returns if two line segments cross eachother. AB is segment 1, CD is segment 2.
function HPred:DoLineSegmentsIntersect(A, B, C, D)

	local o1 = self:GetOrientation(A, B, C)
	local o2 = self:GetOrientation(A, B, D)
	local o3 = self:GetOrientation(C, D, A)
	local o4 = self:GetOrientation(C, D, B)
	
	if o1 ~= o2 and o3 ~= o4 then
		return true
	end
	
	if o1 == 0 and self:IsOnSegment(A, C, B) then return true end
	if o2 == 0 and self:IsOnSegment(A, D, B) then return true end
	if o3 == 0 and self:IsOnSegment(C, A, D) then return true end
	if o4 == 0 and self:IsOnSegment(C, B, D) then return true end
	
	return false
end

--Determines the orientation of ordered triplet
--0 = Colinear
--1 = Clockwise
--2 = CounterClockwise
function HPred:GetOrientation(A,B,C)
	local val = (B.z - A.z) * (C.x - B.x) -
		(B.x - A.x) * (C.z - B.z)
	if val == 0 then
		return 0
	elseif val > 0 then
		return 1
	else
		return 2
	end
	
end

function HPred:IsOnSegment(A, B, C)
	return B.x <= _max(A.x, C.x) and 
		B.x >= _min(A.x, C.x) and
		B.z <= _max(A.z, C.z) and
		B.z >= _min(A.z, C.z)
end

--Gets the slope between two vectors. Ignores Y because it is non-needed height data. Its all 2d math.
function HPred:GetSlope(A, B)
	return (B.z - A.z) / (B.x - A.x)
end

function HPred:GetEnemyByName(name)
	local target
	for i = 1, LocalGameHeroCount() do
		local enemy = LocalGameHero(i)
		if enemy and enemy.isEnemy and enemy.charName == name then
			target = enemy
			return target
		end
	end
end

function HPred:IsPointInArc(source, origin, target, angle, range)
	local deltaAngle = _abs(HPred:Angle(origin, target) - HPred:Angle(source, origin))
	if deltaAngle < angle and self:IsInRange(origin,target,range) then
		return true
	end
end

function HPred:GetDistanceSqr(p1, p2)
	if not p1 or not p2 then
		local dInfo = debug.getinfo(2)
		print("Undefined GetDistanceSqr target. Please report. Method: " .. dInfo.name .. "  Line: " .. dInfo.linedefined)
		return _huge
	end
	return (p1.x - p2.x) *  (p1.x - p2.x) + ((p1.z or p1.y) - (p2.z or p2.y)) * ((p1.z or p1.y) - (p2.z or p2.y)) 
end

function HPred:IsInRange(p1, p2, range)
	if not p1 or not p2 then
		local dInfo = debug.getinfo(2)
		print("Undefined IsInRange target. Please report. Method: " .. dInfo.name .. "  Line: " .. dInfo.linedefined)
		return false
	end
	return (p1.x - p2.x) *  (p1.x - p2.x) + ((p1.z or p1.y) - (p2.z or p2.y)) * ((p1.z or p1.y) - (p2.z or p2.y)) < range * range 
end

function HPred:GetDistance(p1, p2)
	if not p1 or not p2 then
		local dInfo = debug.getinfo(2)
		print("Undefined GetDistance target. Please report. Method: " .. dInfo.name .. "  Line: " .. dInfo.linedefined)
		return _huge
	end
	return _sqrt(self:GetDistanceSqr(p1, p2))
end