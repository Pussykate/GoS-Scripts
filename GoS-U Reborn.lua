
--[[
	   ______            ______        _____  _____     _______           __                                 
	 .' ___  |         .' ____ \      |_   _||_   _|   |_   __ \         [  |                                
	/ .'   \_|   .--.  | (___ \_|______ | |    | |       | |__) |  .---.  | |.--.    .--.   _ .--.  _ .--.   
	| |   ____ / .'`\ \ _.____`.|______|| '    ' |       |  __ /  / /__\\ | '/'`\ \/ .'`\ \[ `/'`\][ `.-. |  
	\ `.___]  || \__. || \____) |        \ \__/ /       _| |  \ \_| \__., |  \__/ || \__. | | |     | | | |  
	 `._____.'  '.__.'  \______.'         `.__.'       |____| |___|'.__.'[__;.__.'  '.__.' [___]   [___||__] 

	Changelog:

	v1.0
	+ Initial release

--]]

local DrawCircle = Draw.Circle
local DrawColor = Draw.Color
local DrawLine = Draw.Line
local DrawText = Draw.Text
local ControlCastSpell = Control.CastSpell
local ControlIsKeyDown = Control.IsKeyDown
local ControlKeyUp = Control.KeyUp
local ControlKeyDown = Control.KeyDown
local ControlMouseEvent = Control.mouse_event
local ControlMove = Control.Move
local ControlSetCursorPos = Control.SetCursorPos
local GameCanUseSpell = Game.CanUseSpell
local GameLatency = Game.Latency
local GameTimer = Game.Timer
local GameHeroCount = Game.HeroCount
local GameHero = Game.Hero
local GameMinionCount = Game.MinionCount
local GameMinion = Game.Minion
local GameMissileCount = Game.MissileCount
local GameMissile = Game.Missile
local GameObjectCount = Game.ObjectCount
local GameObject = Game.Object
local GameParticleCount = Game.ParticleCount
local GameParticle = Game.Particle
local GameTurretCount = Game.TurretCount
local GameTurret = Game.Turret
local GameWardCount = Game.WardCount
local GameWard = Game.Ward

local MathAbs = math.abs
local MathAcos = math.acos
local MathAtan = math.atan
local MathAtan2 = math.atan2
local MathCeil = math.ceil
local MathCos = math.cos
local MathDeg = math.deg
local MathFloor = math.floor
local MathHuge = math.huge
local MathMax = math.max
local MathMin = math.min
local MathPi = math.pi
local MathRad = math.rad
local MathRandom = math.random
local MathSin = math.sin
local MathSqrt = math.sqrt
local TableInsert = table.insert
local TableRemove = table.remove
local TableSort = table.sort

local Module = {Awareness = nil, BaseUlt = nil, Champion = nil, TargetSelector = nil, Utility = nil}
local OnDraws = {Awareness = nil, BaseUlt = nil, Champion = nil, TargetSelector = nil}
local OnRecalls = {Awareness = nil, BaseUlt = nil}
local OnTicks = {Champion = nil, Utility = nil}
local BaseUltC = {["Ashe"] = true, ["Draven"] = true, ["Ezreal"] = true, ["Jinx"] = true}
local Champions = {["Ashe"] = true, ["Caitlyn"] = false, ["Corki"] = false, ["Draven"] = false, ["Ezreal"] = false, ["Jhin"] = false, ["Jinx"] = false, ["KaiSa"] = false, ["Kalista"] = false, ["KogMaw"] = false, ["Lucian"] = false, ["MissFortune"] = false, ["Quinn"] = false, ["Sivir"] = false, ["Tristana"] = false, ["Twitch"] = false, ["Varus"] = false, ["Vayne"] = false, ["Xayah"] = false}
local Item_HK = {[ITEM_1] = HK_ITEM_1, [ITEM_2] = HK_ITEM_2, [ITEM_3] = HK_ITEM3, [ITEM_4] = HK_ITEM4, [ITEM_5] = HK_ITEM5, [ITEM_6] = HK_ITEM6, [ITEM_7] = HK_ITEM7}
local Version = "1.0"; local LuaVer = "1.0"
local VerSite = "https://raw.githubusercontent.com/Ark223/GoS-Scripts/master/GoS-U%20Reborn.version"
local LuaSite = "https://raw.githubusercontent.com/Ark223/GoS-Scripts/master/GoS-U%20Reborn.lua"

function OnLoad()
	require 'MapPositionGOS'
	require 'PremiumPrediction'
	Module.Awareness = GoSuAwareness()
	if BaseUltC[myHero.charName] then Module.BaseUlt = GoSuBaseUlt() end
	Module.Geometry = GoSuGeometry()
	Module.Manager = GoSuManager()
	Module.TargetSelector = GoSuTargetSelector()
	Module.Utility = GoSuUtility()
	if Champions[myHero.charName] then _G[myHero.charName]() end
	AutoUpdate()
end

local function DownloadFile(site, file)
	local start = os.clock()
	DownloadFileAsync(site, file, function() end)
	repeat until os.clock() - start > 5 or FileExist(file)
end

local function AutoUpdate()
	if not FileExist(COMMON_PATH .. "PremiumPrediction.lua") then
		DownloadFile("https://github.com/Ark223/GoS-Scripts/blob/master/PremiumPrediction.lua", COMMON_PATH .. "PremiumPrediction.lua")
	end
	DownloadFile(VerSite, SCRIPT_PATH .. "GoS-U Reborn.version")
	if tonumber(ReadFile(SCRIPT_PATH, "GoS-U Reborn.version")) > tonumber(Version) then
		print("Update found. Downloading...")
		DownloadFile(LuaSite, SCRIPT_PATH .. "GoS-U Reborn.lua")
		print("Successfully updated. Reload!")
		DeleteFile(SCRIPT_PATH .. "GoS-U Reborn.version", function() end)
	else
		DeleteFile(SCRIPT_PATH .. "GoS-U Reborn.version", function() end)
	end
end

local DamageTable = {
	["Ashe"] = {
		{slot = 1, state = 0, damage = function(target) return GoSuManager:CalcPhysicalDamage(myHero, target, (({20, 35, 50, 65, 80})[GoSuManager:GetCastLevel(myHero, _W)] + myHero.totalDamage)) end},
		{slot = 3, state = 0, damage = function(target) return GoSuManager:CalcMagicalDamage(myHero, target, (({200, 400, 600})[GoSuManager:GetCastLevel(myHero, _R)] + myHero.ap)) end},
		{slot = 3, state = 1, damage = function(target) return GoSuManager:CalcMagicalDamage(myHero, target, (({100, 200, 300})[GoSuManager:GetCastLevel(myHero, _R)] + 0.5 * myHero.ap)) end},
	},
}
local SpellData = {
	["Ashe"] = {
		[1] = {speed = 2000, range = 1200, delay = 0.25, radius = 20, collision = true},
		[3] = {speed = 1600, delay = 0.25, radius = 130, collision = false},
	},
	["Draven"] = {
		[3] = {speed = 2000, delay = 0.25, radius = 160, collision = false},
	},
	["Ezreal"] = {
		[3] = {speed = 2000, delay = 1, radius = 160, collision = false},
	},
	["Jinx"] = {
		[3] = {speed = 1700, delay = 0.6, radius = 140, collision = false},
	},
}

--[[
	┌─┐┌─┐┌─┐┌┬┐┌─┐┌┬┐┬─┐┬ ┬
	│ ┬├┤ │ ││││├┤  │ ├┬┘└┬┘
	└─┘└─┘└─┘┴ ┴└─┘ ┴ ┴└─ ┴ 
--]]

class "GoSuGeometry"

function GoSuGeometry:__init()
end

function GoSuGeometry:CircleCircleIntersection(c1, c2, r1, r2)
	local d = GetDistance(c1, c2); local a = (r1 * r1 - r2 * r2 + d * d ) / (2 * d); local h = MathSqrt(r1 * r1 - a * a)
	local dir = (Vector(c2) - Vector(c1)):Normalized(); local pa = Vector(c1) + a * dir
	local s1 = pa + h * dir:Perpendicular(); local s2 = pa - h * dir:Perpendicular()
	return s1, s2
end

function GoSuGeometry:GetBestCircularAOEPos(units, radius)
	local BestPos = nil; local Count, Inside = 0; local Targets = {}
	if #units == 0 then return end
	for i = 1, #units do
		local unit = units[i]
		BestPos = BestPos + unit.pos; Count = Count + 1; Targets[i] = unit
	end
	BestPos = BestPos / Count; local FarAway = 0; local ID = 0
	for i = 1, #units do
		local unit = units[i]
		local Length = self:GetDistance(unit.pos, BestPos)
		if Length <= radius then Inside = Inside + 1 end
		if Length > FarAway then FarAway = Length; ID = i end
	end
	if Inside == Count then return BestPos, Inside
	else TableRemove(targets, ID); return self:GetBestCircularAOEPos(targets, radius) end
end

function GoSuGeometry:GetBestLinearAOEPos(units, range, radius)
	local BestPos = nil; local Count, Inside = 0; local Targets = {}
	if #units == 0 then return end
	for i = 1, #units do
		local unit = list[i]
		BestPos = BestPos + unit.pos; Count = Count + 1; Targets[i] = unit
	end
	BestPos = BestPos / Count; BestPos = myHero:Extended(BestPos, range)
	local LineSegment = {BestPos,  myHero.pos}; local FarAway = 0; local ID = 0
	for i = 1, #units do
		local unit = units[i]
		local Length = self:GetDistanceBetweenPointAndLineSegment(unit.pos, LineSegment)
		if Length <= radius + unit.boundingRadius then Inside = Inside + 1 end
		if Length > FarAway then FarAway = Length; ID = i end
	end
	if Inside == Count then return BestPos, Inside
	else TableRemove(targets, ID); return self:GetBestLinearAOEPos(targets, range, radius) end
end

function GoSuGeometry:GetDistance(pos1, pos2)
	return MathSqrt(self:GetDistanceSqr(pos1, pos2))
end

function GoSuGeometry:GetDistanceBetweenPointAndLineSegment(point, lineSegment)
	local z1 = lineSegment[1].z; local z2 = lineSegment[2].z; local z3 = point.z
	local a = Vector(lineSegment[1].x, 0, z1); local b = Vector(lineSegment[2].x, 0, z2); local p = Vector(point.x, 0, z3)
	local pt = {x = point.x, z = z3}; local p1 = {x = lineSegment[1].x, z = z1}; local p2 = {x = lineSegment[2].x, z = z2}
	local dx = lineSegment[2].x - lineSegment[1].x; local dz = z2 - z1; local closest = nil
	if dx == 0 and dz == 0 then closest = lineSegment[1]; dx = point.x - lineSegment[1].x; dy = z3 - z1; return MathSqrt(dx * dx + dz * dz) end
	local t = ((pt.x - p1.x) * dx + (pt.z - p1.z) * dz) / (dx * dx + dz * dz)
	if t < 0 then closest = {x = p1.x, z = p1.z}; dx = pt.x - p1.x; dz = pt.z - p1.z
	elseif t > 1 then closest = {x = p2.x, z = p2.z}; dx = pt.x - p2.x; dz = pt.z - p2.z
	else closest = {x = p1.x + t * dx, z = p1.z + t * dz}; dx = pt.x - closest.x; dz = pt.z - closest.z end
	return MathSqrt(dx * dx + dz * dz)
end

function GoSuGeometry:GetDistanceSqr(pos1, pos2)
	local pos2 = pos2 or myHero.pos
	local dx = pos1.x - pos2.x; local dz = pos1.z - pos2.z
	return dx * dx + dz * dz
end

function GoSuGeometry:IsClockWise(a, b, c)
	return self:VectorDirection(a, b, c) <= 0
end

function GoSuGeometry:IsInRange(pos1, pos2, range)
    local dx = pos1.x - pos2.x; local dz = pos1.z - pos2.z
    return dx * dx + dz * dz <= range * range
end

function GoSuGeometry:IsLineSegmentIntersection(a, b, c, d)
	return self:IsClockWise(a, c, d) ~= self:IsClockWise(b, c, d) and self:IsClockWise(a, b, c) ~= self:IsClockWise(a, b, d)
end

function GoSuGeometry:LineSegmentIntersection(a, b, c, d)
	return self:IsLineSegmentIntersection(a, b, c, d) and self:VectorIntersection(a, b, c, d)
end

function GoSuGeometry:VectorDirection(v1, v2, v)
	return ((v.z or v.y) - (v1.z or v1.y)) * (v2.x - v1.x) - ((v2.z or v2.y) - (v1.z or v1.y)) * (v.x - v1.x) 
end

function GoSuGeometry:VectorIntersection(a1, b1, a2, b2)
	local x1, y1, x2, y2, x3, y3, x4, y4 = a1.x, a1.z or a1.y, b1.x, b1.z or b1.y, a2.x, a2.z or a2.y, b2.x, b2.z or b2.y
	local r, s, u, v, k, l = x1 * y2 - y1 * x2, x3 * y4 - y3 * x4, x3 - x4, x1 - x2, y3 - y4, y1 - y2
	local px, py, divisor = r * u - v * s, r * k - l * s, v * k - l * u
	return divisor ~= 0 and Vector(px / divisor, py / divisor)
end

function GoSuGeometry:VectorPointProjectionOnLineSegment(v1, v2, v)
	local cx, cy, ax, ay, bx, by = v.x, (v.z or v.y), v1.x, (v1.z or v1.y), v2.x, (v2.z or v2.y)
	local rL = ((cx - ax) * (bx - ax) + (cy - ay) * (by - ay)) / ((bx - ax) ^ 2 + (by - ay) ^ 2)
	local pointLine = { x = ax + rL * (bx - ax), y = ay + rL * (by - ay) }
	local rS = rL < 0 and 0 or (rL > 1 and 1 or rL)
	local isOnSegment = rS == rL
	local pointSegment = isOnSegment and pointLine or { x = ax + rS * (bx - ax), y = ay + rS * (by - ay) }
	return pointSegment, pointLine, isOnSegment
end

--[[
	┌┬┐┌─┐┌┐┌┌─┐┌─┐┌─┐┬─┐
	│││├─┤│││├─┤│ ┬├┤ ├┬┘
	┴ ┴┴ ┴┘└┘┴ ┴└─┘└─┘┴└─
--]]

class "GoSuManager"

function GoSuManager:__init()
end

function GoSuManager:CalcMagicalDamage(source, target, damage)
	local mr = target.magicResist
	local value = 100 / (100 + (mr * source.magicPenPercent) - source.magicPen)
	if mr < 0 then value = 2 - 100 / (100 - mr)
	elseif (mr * source.magicPenPercent) - source.magicPen < 0 then value = 1 end
	return MathMax(0, MathFloor(value * damage))
end

function GoSuManager:CalcPhysicalDamage(source, target, damage)
	local ArmorPenPercent = source.armorPenPercent
	local ArmorPenFlat = source.armorPen * (0.6 + (0.4 * (target.levelData.lvl / 18))) 
	local BonusArmorPen = source.bonusArmorPenPercent
	if source.type == Obj_AI_Minion then ArmorPenPercent = 1; ArmorPenFlat = 0; BonusArmorPen = 1
	elseif source.type == Obj_AI_Turret then
		ArmorPenFlat = 0; BonusArmorPen = 1
		if source.charName:find("3") or source.charName:find("4") then ArmorPenPercent = 0.25
		else ArmorPenPercent = 0.7 end	
		if target.type == Obj_AI_Minion then damage = damage * 1.25
			if target.charName:find("MinionSiege") then damage = damage * 0.7 end
			return damage
		end
	end
	local armor = target.armor; local bonusArmor = target.bonusArmor
	local value = 100 / (100 + (armor * ArmorPenPercent) - (bonusArmor * (1 - BonusArmorPen)) - ArmorPenFlat)
	if armor < 0 then value = 2 - 100 / (100 - armor)
	elseif (armor * ArmorPenPercent) - (bonusArmor * (1 - BonusArmorPen)) - ArmorPenFlat < 0 then value = 1 end
	return MathMax(0, MathFloor(value * damage))
end

function GoSuManager:GetCastLevel(unit, slot)
	return unit:GetSpellData(slot).level
end

function GoSuManager:GetCastRange(unit, spell)
	local range = unit:GetSpellData(spell).range
	if range and range > 0 then return range end
end

function GoSuManager:GetDamage(target, spell, state)
	local state = state or 0
	if spell == 0 or spell == 1 or spell == 2 or spell == 3 then
		if DamageTable[myHero.charName] then
			for i, spells in pairs(DamageTable[myHero.charName]) do
				if spells.slot == spell then
					if spells.state == state then
						return spells.damage(target)
					end
				end
			end
		end
	end
end

function GoSuManager:GetEnemyHeroes()
	local t = {}
	for i = 1, GameHeroCount() do
		local hero = GameHero(i)
		if hero.isEnemy then TableInsert(t, hero) end
	end
	return t
end

function GoSuManager:GetHeroesAround(pos, range, mode)
	local range = range or MathHuge; local t = {}; local n = 0
	for i = 1, GameHeroCount() do
		local hero = GameHero(i)
		if hero and not hero.isMe and not hero.dead and GoSuGeometry:GetDistance(pos, hero.pos) <= range then
			if mode == "allies" and hero.team == myHero.team or mode ~= "allies" then
				TableInsert(t, hero); n = n + 1
			end
		end
	end
	return t, n
end

function GoSuManager:GetItemSlot(unit, id)
	for i = ITEM_1, ITEM_7 do
		if unit:GetItemData(i).itemID == id then return i end
	end
	return 0
end

function GoSuManager:GetMinionsAround(pos, range, mode)
	local range = range or MathHuge; local t = {}; local n = 0
	for i = 1, GameMinionCount() do
		local minion = GameMinion(i)
		if minion and not minion.dead and GoSuGeometry:GetDistance(pos, minion.pos) <= range then
			if mode == "allies" and minion.isAlly or minion.isEnemy then
				TableInsert(t, minion); n = n + 1
			end
		end
	end
	return t, n
end

function GoSuManager:GetOrbwalkerMode()
	if _G.SDK then
		if _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO] then return "Combo"
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_HARASS] then return "Harass"
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LANECLEAR] then return "Clear" end
	else
		return GOS.GetMode()
	end
end

function GoSuManager:GetPercentHP(unit)
	return 100 * unit.health / unit.maxHealth
end

function GoSuManager:GetPercentMana(unit)
	return 100 * unit.mana / unit.maxMana
end

function GoSuManager:GetSpellCooldown(unit, spell)
	return MathCeil(unit:GetSpellData(spell).currentCd)
end

function GoSuManager:GotBuff(unit, buffname)
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff.name == buffname and buff.count > 0 then return buff.count end
	end
	return 0
end

function GoSuManager:IsImmobile(unit)
	if unit.ms == 0 then return true end
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff and (buff.type == 5 or buff.type == 11 or buff.type == 18 or buff.type == 22 or buff.type == 24 or buff.type == 28 or buff.type == 29 or buff.name == "recall") and buff.count > 0 then return true end
	end
	return false
end

function GoSuManager:IsReady(spell)
	return GameCanUseSpell(spell) == 0
end

function GoSuManager:IsSlowed(unit)
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff and buff.type == 10 and buff.count > 0 then return true end
	end
	return false
end

function GoSuManager:ValidTarget(target, range)
	local range = range or MathHuge
	return target and target.valid and target.visible and not target.dead and target.distance <= range
end

--[[
	┌─┐┬ ┬┌─┐┬─┐┌─┐┌┐┌┌─┐┌─┐┌─┐
	├─┤│││├─┤├┬┘├┤ │││├┤ └─┐└─┐
	┴ ┴└┴┘┴ ┴┴└─└─┘┘└┘└─┘└─┘└─┘
--]]

class "GoSuAwareness"

function GoSuAwareness:__init()
	self.AwarenessMenu = MenuElement({type = MENU, id = "Awareness", name = "[GoS-U] Awareness"})
	self.AwarenessMenu:MenuElement({id = "DrawJng", name = "Draw Jungler Info", value = true})
	self.AwarenessMenu:MenuElement({id = "DrawEnAA", name = "Draw Enemy AA Range", value = true})
	self.AwarenessMenu:MenuElement({id = "EnAARng", name = "AA Range Color", color = DrawColor(64, 192, 192, 192)})
	self.AwarenessMenu:MenuElement({id = "DrawEnRng", name = "Draw Enemy Spell Ranges", value = true})
	self.AwarenessMenu:MenuElement({id = "EnQRng", name = "Q Range Color", color = DrawColor(64, 0, 250, 154)})
	self.AwarenessMenu:MenuElement({id = "EnWRng", name = "W Range Color", color = DrawColor(64, 218, 112, 214)})
	self.AwarenessMenu:MenuElement({id = "EnERng", name = "E Range Color", color = DrawColor(64, 255, 140, 0)})
	self.AwarenessMenu:MenuElement({id = "EnRRng", name = "R Range Color", color = DrawColor(64, 220, 20, 60)})
	self.AwarenessMenu:MenuElement({id = "DrawAA", name = "Draw AA's Left", value = true})
	self.AwarenessMenu:MenuElement({id = "CDs", name = "Show Cooldowns", value = true})
	self.AwarenessMenu:MenuElement({id = "Recall", name = "Track Recalls", value = true})
	OnRecalls.Awareness = function(unit, recall) self:ProcessRecall(unit, recall) end
	OnDraws.Awareness = function() self:Draw() end
end

function GoSuAwareness:ProcessRecall(unit, recall)
	if unit.team ~= myHero.team then
		if recall.isStart then print(unit.charName.." started recalling at " ..MathCeil(unit.health).. "HP")
		elseif recall.isFinish then print(unit.charName.." successfully recalled!")
		else print(unit.charName.." canceled recalling!") end
	end
end

function GoSuAwareness:Draw()
	for i, enemy in pairs(GoSuManager:GetEnemyHeroes()) do
		if GoSuManager:ValidTarget(enemy, 3000) then
			if self.AwarenessMenu.DrawEnAA:Value() then
				DrawCircle(enemy.pos, enemy.range, 1, self.AwarenessMenu.EnAARng:Value())
			end
			if self.AwarenessMenu.DrawEnRng:Value() then
				if GoSuManager:GetCastRange(enemy, _Q) then DrawCircle(enemy.pos, GoSuManager:GetCastRange(enemy, _Q), 1, self.AwarenessMenu.EnQRng:Value()) end
				if GoSuManager:GetCastRange(enemy, _W) then DrawCircle(enemy.pos, GoSuManager:GetCastRange(enemy, _W), 1, self.AwarenessMenu.EnWRng:Value()) end
				if GoSuManager:GetCastRange(enemy, _E) then DrawCircle(enemy.pos, GoSuManager:GetCastRange(enemy, _E), 1, self.AwarenessMenu.EnERng:Value()) end
				if GoSuManager:GetCastRange(enemy, _R) then DrawCircle(enemy.pos, GoSuManager:GetCastRange(enemy, _R), 1, self.AwarenessMenu.EnRRng:Value()) end
			end
		end
		if GoSuManager:ValidTarget(enemy) then
			if self.AwarenessMenu.CDs:Value() then
				if GoSuManager:GetSpellCooldown(enemy, _Q) ~= 0 then DrawText("Q", 15, enemy.pos2D.x-85, enemy.pos2D.y+10, DrawColor(0xFFFF0000)); DrawText(GoSuManager:GetSpellCooldown(enemy, _Q), 15, enemy.pos2D.x-85, enemy.pos2D.y+25, DrawColor(0xFFFFA500))
				else DrawText("Q", 15, enemy.pos2D.x-85, enemy.pos2D.y+10, DrawColor(0xFF00FF00)) end
				if GoSuManager:GetSpellCooldown(enemy, _W) ~= 0 then DrawText("W", 15, enemy.pos2D.x-53, enemy.pos2D.y+10, DrawColor(0xFFFF0000)); DrawText(GoSuManager:GetSpellCooldown(enemy, _W), 15, enemy.pos2D.x-53, enemy.pos2D.y+25, DrawColor(0xFFFFA500))
				else DrawText("W", 15, enemy.pos2D.x-53, enemy.pos2D.y+10, DrawColor(0xFF00FF00)) end
				if GoSuManager:GetSpellCooldown(enemy, _E) ~= 0 then DrawText("E", 15, enemy.pos2D.x-17, enemy.pos2D.y+10, DrawColor(0xFFFF0000)); DrawText(GoSuManager:GetSpellCooldown(enemy, _E), 15, enemy.pos2D.x-17, enemy.pos2D.y+25, DrawColor(0xFFFFA500))
				else DrawText("E", 15, enemy.pos2D.x-17, enemy.pos2D.y+10, DrawColor(0xFF00FF00)) end
				if GoSuManager:GetSpellCooldown(enemy, _R) ~= 0 then DrawText("R", 15, enemy.pos2D.x+15, enemy.pos2D.y+10, DrawColor(0xFFFF0000)); DrawText(GoSuManager:GetSpellCooldown(enemy, _R), 15, enemy.pos2D.x+15, enemy.pos2D.y+25, DrawColor(0xFFFFA500))
				else DrawText("R", 15, enemy.pos2D.x+15, enemy.pos2D.y+10, DrawColor(0xFF00FF00)) end
				if GoSuManager:GetSpellCooldown(enemy, SUMMONER_1) ~= 0 then DrawText("SUM1", 15, enemy.pos2D.x-73, enemy.pos2D.y+40, DrawColor(0xFFFF0000))
				else DrawText("SUM1", 15, enemy.pos2D.x-73, enemy.pos2D.y+40, DrawColor(0xFF00FF00)) end
				if GoSuManager:GetSpellCooldown(enemy, SUMMONER_2) ~= 0 then DrawText("SUM2", 15, enemy.pos2D.x-19, enemy.pos2D.y+40, DrawColor(0xFFFF0000))
				else DrawText("SUM2", 15, enemy.pos2D.x-19, enemy.pos2D.y+40, DrawColor(0xFF00FF00)) end
			end
			if self.AwarenessMenu.DrawAA:Value() then
				local AALeft = enemy.health / GoSuManager:CalcPhysicalDamage(myHero, enemy, myHero.totalDamage)
				Draw.Text("AA Left: "..tostring(math.ceil(AALeft)), 15, enemy.pos2D.x+40, enemy.pos2D.y+10, Draw.Color(0xFF00BFFF))
			end
		end
		if self.AwarenessMenu.DrawJng:Value() then
			if enemy:GetSpellData(SUMMONER_1).name:lower():find("smite") and SUMMONER_1 or (enemy:GetSpellData(SUMMONER_2).name:lower():find("smite") and SUMMONER_2) then
				if enemy.alive then
					if ValidTarget(enemy) then
						if GoSuManager:GetDistance(myHero.pos, enemy.pos) > 3000 then DrawText("Jungler: Visible", 17, myHero.pos2D.x-45, myHero.pos2D.y+10, DrawColor(0xFF32CD32))
						else DrawText("Jungler: Near", 17, myHero.pos2D.x-43, myHero.pos2D.y+10, DrawColor(0xFFFF0000)) end
					else
						DrawText("Jungler: Invisible", 17, myHero.pos2D.x-55, myHero.pos2D.y+10, DrawColor(0xFFFFD700))
					end
				else
					DrawText("Jungler: Dead", 17, myHero.pos2D.x-45, myHero.pos2D.y+10, DrawColor(0xFF32CD32))
				end
			end
		end
	end
end

--[[
	┌┐ ┌─┐┌─┐┌─┐┬ ┬┬ ┌┬┐
	├┴┐├─┤└─┐├┤ │ ││  │ 
	└─┘┴ ┴└─┘└─┘└─┘┴─┘┴ 
--]]

class "GoSuBaseUlt"

function GoSuBaseUlt:__init()
	self.EnemyBase = nil; self.RecallData = {}; self.RData = SpellData[myHero.charName][3]
	for i = 1, GameObjectCount() do
		local base = GameObject(i)
		if base.isEnemy and base.type == Obj_AI_SpawnPoint then self.EnemyBase = base break end
	end
	for i = 1, GameHeroCount() do
		local unit = GameHero(i)
		if unit.isEnemy then self.RecallData[unit.charName] = {startTime = 0, duration = 0, missing = 0, isRecalling = false} end
	end
	self.BaseUltMenu = MenuElement({type = MENU, id = "BaseUlt", name = "[GoS-U] BaseUlt"})
	self.BaseUltMenu:MenuElement({id = "Enable", name = "Enable BaseUlt", value = true})
	--self.BaseUltMenu:MenuElement({id = "Check", name = "Check Collision", value = myHero.charName == "Ashe" or myHero.charName == "Jinx"})
	if self.BaseUltMenu.Enable:Value() then
		OnRecalls.BaseUlt = function(unit, recall) self:ProcessRecall(unit, recall) end
		OnDraws.BaseUlt = function() self:Tick() end
	end
end

function GoSuBaseUlt:Tick()
	if GoSuManager:IsReady(_R) then
		for i, enemy in pairs(GoSuManager:GetEnemyHeroes()) do
			local recall = self.RecallData[enemy.charName]
			if not enemy.visible then recall.missing = GameTimer() end
			if recall.isRecalling then
				local FirstStage = enemy.health <= GoSuManager:GetDamage(enemy, 3, 0)
				if FirstStage then DrawText("Possible BaseUlt!", 35, myHero.pos2D.x-85, myHero.pos2D.y+20, DrawColor(192, 220, 20, 60)) end
				local RecallTime = recall.startTime + recall.duration - GameTimer()
				local HitTime = self:CalculateTravelTime()
				if (HitTime - RecallTime) > 0 then
					local PredictedHealth = enemy.health + enemy.hpRegen * HitTime
					if not enemy.visible then PredictedHealth = PredictedHealth + enemy.hpRegen * (GameTimer() - recall.missing) end
					if PredictedHealth + enemy.maxHealth * 0.021 <= GoSuManager:GetDamage(enemy, 3, 0) then
						local BasePos = self.EnemyBase.pos:ToMM()
						ControlCastSpell(HK_R, BasePos.x, BasePos.y)
					end
				end
			end
		end
	end
end

function GoSuBaseUlt:ProcessRecall(unit, recall)
	if unit.isAlly then return end
	local recallData = self.RecallData[unit.charName]
	if recall.isStart then recallData.startTime = GameTimer(); recallData.duration = recall.totalTime / 1000; recallData.isRecalling = true
	else recallData.isRecalling = false end
end

function GoSuBaseUlt:CalculateTravelTime()
	local distance = GoSuGeometry:GetDistance(myHero.pos, self.EnemyBase.pos); local delay = self.RData.delay + 0.05
	local speed = myHero.charName == "Jinx" and distance > 1350 and (2295000 + (distance - 1350) * 2200) / distance or self.RData.speed
	return (distance / speed + delay)
end

--[[
	┬ ┬┌┬┐┬┬  ┬┌┬┐┬ ┬
	│ │ │ ││  │ │ └┬┘
	└─┘ ┴ ┴┴─┘┴ ┴  ┴ 
--]]

class "GoSuUtility"

function GoSuUtility:__init()
	self.MSIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/0/0a/Mercurial_Scimitar_item.png"
	self.QSIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/f/f9/Quicksilver_Sash_item.png"
	self.STIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/2/2b/Tear_of_the_Goddess_item.png"
	self.BCIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/4/44/Bilgewater_Cutlass_item.png"
	self.BOTRKIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/2/2f/Blade_of_the_Ruined_King_item.png"
	self.HGIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/6/64/Hextech_Gunblade_item.png"
	self.HealIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/6/6e/Heal.png"
	self.UtilityMenu = MenuElement({type = MENU, id = "Utility", name = "[GoS-U] Utility"})
	self.UtilityMenu:MenuElement({id = "Items", name = "Items", type = MENU})
	self.UtilityMenu.Items:MenuElement({id = "Defensive", name = "Defensive Items", type = MENU})
	self.UtilityMenu.Items.Defensive:MenuElement({id = "UseMS", name = "Use Mercurial Scimitar", value = true, leftIcon = self.MSIcon})
	self.UtilityMenu.Items.Defensive:MenuElement({id = "UseQS", name = "Use Quicksilver Sash", value = true, leftIcon = self.QSIcon})
	self.UtilityMenu.Items:MenuElement({id = "Offensive", name = "Offensive Items", type = MENU})
	self.UtilityMenu.Items.Offensive:MenuElement({id = "Stack", name = "Stack Tear", value = true, leftIcon = self.STIcon})
	self.UtilityMenu.Items.Offensive:MenuElement({id = "UseBC", name = "Use Bilgewater Cutlass", value = true, leftIcon = self.BCIcon})
	self.UtilityMenu.Items.Offensive:MenuElement({id = "UseBOTRK", name = "Use BOTRK", value = true, leftIcon = self.BOTRKIcon})
	self.UtilityMenu.Items.Offensive:MenuElement({id = "UseHG", name = "Use Hextech Gunblade", value = true, leftIcon = self.HGIcon})
	self.UtilityMenu.Items.Offensive:MenuElement({id = "ST", name = "Mana [%] To Stack Tear", value = 75, min = 0, max = 100, step = 5})
	self.UtilityMenu.Items.Offensive:MenuElement({id = "OI", name = "Enemy HP [%] To Use Items", value = 35, min = 0, max = 100, step = 5})
	self.UtilityMenu:MenuElement({id = "SS", name = "Summoner Spells", type = MENU})
	self.UtilityMenu.SS:MenuElement({id = "UseHeal", name = "Use Heal", value = true, leftIcon = self.HealIcon})
	self.UtilityMenu.SS:MenuElement({id = "UseSave", name = "Save Ally Using Heal", value = true, leftIcon = self.HealIcon})
	self.UtilityMenu.SS:MenuElement({id = "HealMe", name = "HP [%] To Use Heal: MyHero", value = 15, min = 0, max = 100, step = 5})
	self.UtilityMenu.SS:MenuElement({id = "HealAlly", name = "HP [%] To Use Heal: Ally", value = 15, min = 0, max = 100, step = 5})
	OnTicks.Utility = function() self:Tick() end
end

function GoSuUtility:Tick()
	local enemies, countEnemies = GoSuManager:GetHeroesAround(myHero.pos, 1500, "enemies")
	if countEnemies > 0 then
		if self.UtilityMenu.SS.UseHeal:Value() then
			if myHero.alive and myHero.health > 0 and GoSuManager:GetPercentHP(myHero) < self.UtilityMenu.SS.HealMe:Value() then
				if myHero:GetSpellData(SUMMONER_1).name == "SummonerHeal" and GoSuManager:IsReady(SUMMONER_1) then
					ControlCastSpell(HK_SUMMONER_1)
				elseif myHero:GetSpellData(SUMMONER_2).name == "SummonerHeal" and GoSuManager:IsReady(SUMMONER_2) then
					ControlCastSpell(HK_SUMMONER_2)
				end
			end
			local allies, countAllies = GoSuManager:GetHeroesAround(myHero.pos, 850, "allies")
			if countAllies > 0 then
				for i, ally in pairs(allies) do
					if GoSuManager:ValidTarget(ally, 850) then
						if ally.alive and ally.health > 0 and GoSuManager:GetPercentHP(ally) < self.UtilityMenu.SS.HealAlly:Value() then
							if myHero:GetSpellData(SUMMONER_1).name == "SummonerHeal" and GoSuManager:IsReady(SUMMONER_1) then
								ControlCastSpell(HK_SUMMONER_1, ally.pos)
							elseif myHero:GetSpellData(SUMMONER_2).name == "SummonerHeal" and GoSuManager:IsReady(SUMMONER_2) then
								ControlCastSpell(HK_SUMMONER_2, ally.pos)
							end
						end
					end
				end
			end
		end
		local target = Module.TargetSelector:GetTarget(700, nil)
		local itemSlots = {[1] = 3144, [2] = 3153, [3] = 3139, [4] = 3140}
		if GoSuManager:ValidTarget(target, 550) then
			for i = 1, 2, 1 do
				if GoSuManager:GetItemSlot(myHero, itemSlots[i]) > 0 then
					if i == 1 and self.UtilityMenu.Items.Offensive.UseBC:Value() or self.UtilityMenu.Items.Offensive.UseBOTRK:Value() then
						if GoSuManager:GetSpellCooldown(myHero, GoSuManager:GetItemSlot(myHero, itemSlots[i])) == 0 then
							ControlCastSpell(Item_HK[GoSuManager:GetItemSlot(myHero, itemSlots[i])], target.pos)
						end
					end
				end
			end
		elseif GoSuManager:ValidTarget(target, 700) then
			if self.UtilityMenu.Items.Offensive.UseHG:Value() then
				if GoSuManager:GetItemSlot(myHero, 3146) > 0 then
					if GoSuManager:GetSpellCooldown(myHero, GoSuManager:GetItemSlot(myHero, 3146)) == 0 then
						ControlCastSpell(Item_HK[GoSuManager:GetItemSlot(myHero, 3146)], target.pos)
					end
				end
			end
		end
		if GoSuManager:IsImmobile(myHero) then
			for i = 3, 4, 1 do
				if GoSuManager:GetItemSlot(myHero, itemSlots[i]) > 0 then
					if i == 3 and self.UtilityMenu.Items.Defensive.UseMS:Value() or self.UtilityMenu.Items.Defensive.UseQS:Value() then
						if GoSuManager:GetSpellCooldown(myHero, GoSuManager:GetItemSlot(myHero, itemSlots[i])) == 0 then
							ControlCastSpell(Item_HK[GoSuManager:GetItemSlot(myHero, itemSlots[i])], myHero.pos)
						end
					end
				end
			end
		end
	else
		if self.UtilityMenu.Items.Offensive.Stack:Value() then
			if GoSuManager:GetItemSlot(myHero, 3070) > 0 then
				if GoSuManager:GetPercentMana(myHero) <= self.UtilityMenu.Items.Offensive.ST:Value() then
					ControlCastSpell(HK_Q)
				end
			end
		end
	end
end

--[[
	┌┬┐┌─┐┬─┐┌─┐┌─┐┌┬┐  ┌─┐┌─┐┬  ┌─┐┌─┐┌┬┐┌─┐┬─┐
	 │ ├─┤├┬┘│ ┬├┤  │   └─┐├┤ │  ├┤ │   │ │ │├┬┘
	 ┴ ┴ ┴┴└─└─┘└─┘ ┴   └─┘└─┘┴─┘└─┘└─┘ ┴ └─┘┴└─
--]]

class "GoSuTargetSelector"

function GoSuTargetSelector:__init()
	self.Timer = 0
	self.SelectedTarget = false
	self.DamageType = {["Ashe"] = "AD", ["Caitlyn"] = "AD", ["Corki"] = "HB", ["Draven"] = "AD", ["Ezreal"] = "AD", ["Jhin"] = "AD", ["Jinx"] = "AD", ["KaiSa"] = "HB", ["Kalista"] = "AD", ["KogMaw"] = "HB", ["Lucian"] = "AD", ["MissFortune"] = "AD", ["Quinn"] = "AD", ["Sivir"] = "AD", ["Tristana"] = "AD", ["Twitch"] = "AD", ["Varus"] = "AD", ["Vayne"] = "AD", ["Xayah"] = "AD"}
	self.Damage = function(target, dmgType, value) return (dmgType == "AD" and GoSuManager:CalcPhysicalDamage(myHero, target, value)) or (GoSuManager:CalcPhysicalDamage(myHero, target, value / 2) + GoSuManager:CalcMagicalDamage(myHero, target, value / 2)) end
	self.Modes = {
		[1] = function(a,b) return self.Damage(a, self.DamageType[myHero.charName], 100) / (1 + a.health) * self:GetPriority(a) > self.Damage(b, self.DamageType[myHero.charName], 100) / (1 + b.health) * self:GetPriority(b) end,
		[2] = function(a,b) return self:GetPriority(a) > self:GetPriority(b) end,
		[3] = function(a,b) return self.Damage(a, "AD", 100) / (1 + a.health) * self:GetPriority(a) > self.Damage(b, "AD", 100) / (1 + b.health) * self:GetPriority(b) end,
		[4] = function(a,b) return self.Damage(a, "AP", 100) / (1 + a.health) * self:GetPriority(a) > self.Damage(b, "AP", 100) / (1 + b.health) * self:GetPriority(b) end,
		[5] = function(a,b) return self.Damage(a, "AD", 100) / (1 + a.health) > self.Damage(b, "AD", 100) / (1 + b.health) end,
		[6] = function(a,b) return self.Damage(a, "AP", 100) / (1 + a.health) > self.Damage(b, "AP", 100) / (1 + b.health) end,
		[7] = function(a,b) return a.health < b.health end,
		[8] = function(a,b) return a.totalDamage > b.totalDamage end,
		[9] = function(a,b) return a.ap > b.ap end,
		[10] = function(a,b) return GoSuGeometry:GetDistance(a.pos, myHero.pos) < GoSuGeometry:GetDistance(b.pos, myHero.pos) end,
		[11] = function(a,b) return GoSuGeometry:GetDistance(a.pos, mousePos) < GoSuGeometry:GetDistance(b.pos, mousePos) end
	}
	self.Priorities = {
		["Aatrox"] = 3, ["Ahri"] = 4, ["Akali"] = 4, ["Alistar"] = 1, ["Amumu"] = 1, ["Anivia"] = 4, ["Annie"] = 4, ["Ashe"] = 5, ["AurelionSol"] = 4, ["Azir"] = 4,
		["Bard"] = 3, ["Blitzcrank"] = 1, ["Brand"] = 4, ["Braum"] = 1, ["Caitlyn"] = 5, ["Camille"] = 3, ["Cassiopeia"] = 4, ["Chogath"] = 1, ["Corki"] = 5, ["Darius"] = 2,
		["Diana"] = 4, ["DrMundo"] = 1, ["Draven"] = 5, ["Ekko"] = 4, ["Elise"] = 3, ["Evelynn"] = 4, ["Ezreal"] = 5, ["Fiddlesticks"] = 3, ["Fiora"] = 3, ["Fizz"] = 4,
		["Galio"] = 1, ["Gangplank"] = 4, ["Garen"] = 1, ["Gnar"] = 1, ["Gragas"] = 2, ["Graves"] = 4, ["Hecarim"] = 2, ["Heimerdinger"] = 3, ["Illaoi"] =	3, ["Irelia"] = 3,
		["Ivern"] = 1, ["Janna"] = 2, ["JarvanIV"] = 3, ["Jax"] = 3, ["Jayce"] = 4, ["Jhin"] = 5, ["Jinx"] = 5, ["Kaisa"] = 5, ["Kalista"] = 5, ["Karma"] = 4, ["Karthus"] = 4,
		["Kassadin"] = 4, ["Katarina"] = 4, ["Kayle"] = 4, ["Kayn"] = 4, ["Kennen"] = 4, ["Khazix"] = 4, ["Kindred"] = 4, ["Kled"] = 2, ["KogMaw"] = 5, ["Leblanc"] = 4,
		["LeeSin"] = 3, ["Leona"] = 1, ["Lissandra"] = 4, ["Lucian"] = 5, ["Lulu"] = 3, ["Lux"] = 4, ["Malphite"] = 1, ["Malzahar"] = 3, ["Maokai"] = 2, ["MasterYi"] = 5,
		["MissFortune"] = 5, ["MonkeyKing"] = 3, ["Mordekaiser"] = 4, ["Morgana"] = 3, ["Nami"] = 3, ["Nasus"] = 2, ["Nautilus"] = 1, ["Neeko"] = 4, ["Nidalee"] = 4,
		["Nocturne"] = 4, ["Nunu"] = 2, ["Olaf"] = 2, ["Orianna"] = 4, ["Ornn"] = 2, ["Pantheon"] = 3, ["Poppy"] = 2, ["Pyke"] = 5, ["Quinn"] = 5, ["Rakan"] = 3, ["Rammus"] = 1,
		["RekSai"] = 2, ["Renekton"] = 2, ["Rengar"] = 4, ["Riven"] = 4, ["Rumble"] = 4, ["Ryze"] = 4, ["Sejuani"] = 2, ["Shaco"] = 4, ["Shen"] = 1, ["Shyvana"] = 2,
		["Singed"] = 1, ["Sion"] = 1, ["Sivir"] = 5, ["Skarner"] = 2, ["Sona"] = 3, ["Soraka"] = 3, ["Swain"] = 3, ["Sylas"] = 4, ["Ashe"] = 4, ["TahmKench"] = 1,
		["Taliyah"] = 4, ["Talon"] = 4, ["Taric"] = 1, ["Teemo"] = 4, ["Thresh"] = 1, ["Tristana"] = 5, ["Trundle"] = 2, ["Tryndamere"] = 4, ["TwistedFate"] = 4, ["Twitch"] = 5,
		["Udyr"] = 2, ["Urgot"] = 2, ["Varus"] = 5, ["Vayne"] = 5, ["Veigar"] = 4, ["Velkoz"] = 4, ["Vi"] = 2, ["Viktor"] = 4, ["Vladimir"] = 3, ["Volibear"] = 2, ["Warwick"] = 2,
		["Xayah"] = 5, ["Xerath"] = 4, ["XinZhao"] = 3, ["Yasuo"] = 4, ["Yorick"] = 2, ["Zac"] = 1, ["Zed"] = 4, ["Ziggs"] = 4, ["Zilean"] = 3, ["Zoe"] = 4, ["Zyra"] = 2
	}
	self.TSMenu = MenuElement({type = MENU, id = "TargetSelector", name = "[GoS-U] Target Selector"})
	self.TSMenu:MenuElement({id = "TS", name = "Target Selector Mode", drop = {"Auto", "Priority", "Less Attack Priority", "Less Cast Priority", "Less Attack", "Less Cast", "Lowest HP", "Most AD", "Most AP", "Closest", "Near Mouse"}, value = 1})
	self.TSMenu:MenuElement({id = "PR", name = "Priority Menu", type = MENU})
	self.TSMenu:MenuElement({id = "ST", name = "Selected Target", key = string.byte("Z")})
	DelayAction(function()
		for i, enemy in pairs(GoSuManager:GetEnemyHeroes()) do
			self.TSMenu.PR:MenuElement({id = "Level"..enemy.charName, name = enemy.charName, value = (self.Priorities[enemy.charName] or 3), min = 1, max = 5, step = 1})
		end
	end, 0.01)
	OnDraws.TargetSelector = function() self:Draw() end
end

function GoSuTargetSelector:Draw()
	if GameTimer() > self.Timer + 0.2 then
		if self.TSMenu.ST:Value() then
			if self.SelectedTarget == false then
				for i, enemy in pairs(GoSuManager:GetEnemyHeroes()) do
					if GoSuManager:ValidTarget(enemy) and IsInRange(mousePos, enemy.pos, 50) then self.SelectedTarget = enemy; break end
				end
			else
				self.SelectedTarget = false
			end
		end
		self.Timer = GameTimer()
	end
	local target = self.SelectedTarget
	if target then DrawCircle(target.pos, 100, 1, DrawColor(192, 255, 215, 0)) end
end

function GoSuTargetSelector:GetPriority(enemy)
	local priority = 1
	if self.TSMenu == nil then return priority end
	if self.TSMenu.PR["Level"..enemy.charName]:Value() ~= nil then
		priority = self.TSMenu.PR["Level"..enemy.charName]:Value()
	end
	if priority == 2 then return 1.5
	elseif priority == 3 then return 1.75
	elseif priority == 4 then return 2
	elseif priority == 5 then return 2.5 end
	return priority
end

function GoSuTargetSelector:GetTarget(range, mode)
	if self.SelectedTarget ~= false then return self.SelectedTarget end
	local targets = {}
	for i, enemy in pairs(GoSuManager:GetEnemyHeroes()) do
		if GoSuManager:ValidTarget(enemy, range) then TableInsert(targets, enemy) end
	end
	self.SelectedMode = mode or self.TSMenu.TS:Value() or 1
	TableSort(targets, self.Modes[self.SelectedMode])
	return #targets > 0 and targets[1] or nil
end

--[[
	┌─┐┌─┐┬ ┬┌─┐
	├─┤└─┐├─┤├┤ 
	┴ ┴└─┘┴ ┴└─┘
--]]

class "Ashe"

local target1, target2

function Ashe:__init()
	self.HeroIcon = "https://d1u5p3l4wpay3k.cloudfront.net/lolesports_gamepedia_en/4/4a/AsheSquare.png"
	self.QIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/2/2a/Ranger%27s_Focus_2.png"
	self.WIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/5/5d/Volley.png"
	self.EIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/e/e3/Hawkshot.png"
	self.RIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/2/28/Enchanted_Crystal_Arrow.png"
	self.WData = SpellData[myHero.charName][1]; self.RData = SpellData[myHero.charName][3]
	self.AsheMenu = MenuElement({type = MENU, id = "Ashe", name = "[GoS-U] Ashe", leftIcon = self.HeroIcon})
	self.AsheMenu:MenuElement({id = "Auto", name = "Auto", type = MENU})
	self.AsheMenu.Auto:MenuElement({id = "UseW", name = "Use W [Volley]", value = true, leftIcon = self.WIcon})
	self.AsheMenu.Auto:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	self.AsheMenu:MenuElement({id = "Combo", name = "Combo", type = MENU})
	self.AsheMenu.Combo:MenuElement({id = "UseQ", name = "Use Q [Ranger's Focus]", value = true, leftIcon = self.QIcon})
	self.AsheMenu.Combo:MenuElement({id = "UseW", name = "Use W [Volley]", value = true, leftIcon = self.WIcon})
	self.AsheMenu.Combo:MenuElement({id = "UseR", name = "Use R [Enchanted Crystal Arrow]", value = true, leftIcon = self.RIcon})
	self.AsheMenu.Combo:MenuElement({id = "Distance", name = "Distance: R", value = 2000, min = 100, max = 5000, step = 50})
	self.AsheMenu.Combo:MenuElement({id = "X", name = "Minimum Enemies: R", value = 1, min = 0, max = 5, step = 1})
	self.AsheMenu.Combo:MenuElement({id = "HP", name = "HP-Manager: R", value = 40, min = 0, max = 100, step = 5})
	self.AsheMenu:MenuElement({id = "Harass", name = "Harass", type = MENU})
	self.AsheMenu.Harass:MenuElement({id = "UseQ", name = "Use Q [Ranger's Focus]", value = true, leftIcon = self.QIcon})
	self.AsheMenu.Harass:MenuElement({id = "UseW", name = "Use W [Volley]", value = true, leftIcon = self.WIcon})
	self.AsheMenu.Harass:MenuElement({id = "MP", name = "Mana-Manager", value = 40, min = 0, max = 100, step = 5})
	self.AsheMenu:MenuElement({id = "KillSteal", name = "KillSteal", type = MENU})
	self.AsheMenu.KillSteal:MenuElement({id = "UseR", name = "Use R [Enchanted Crystal Arrow]", value = true, leftIcon = self.RIcon})
	self.AsheMenu.KillSteal:MenuElement({id = "Distance", name = "Distance: R", value = 2000, min = 100, max = 5000, step = 50})
	self.AsheMenu:MenuElement({id = "AntiGapcloser", name = "Anti-Gapcloser", type = MENU})
	self.AsheMenu.AntiGapcloser:MenuElement({id = "UseR", name = "Use R [Enchanted Crystal Arrow]", value = true, leftIcon = self.RIcon})
	self.AsheMenu.AntiGapcloser:MenuElement({id = "Distance", name = "Distance: R", value = 100, min = 25, max = 500, step = 25})
	self.AsheMenu:MenuElement({id = "HitChance", name = "HitChance", type = MENU})
	self.AsheMenu.HitChance:MenuElement({id = "HCW", name = "HitChance: W", value = 10, min = 0, max = 100, step = 1})
	self.AsheMenu.HitChance:MenuElement({id = "HCR", name = "HitChance: R", value = 40, min = 0, max = 100, step = 1})
	self.AsheMenu:MenuElement({id = "Drawings", name = "Drawings", type = MENU})
	self.AsheMenu.Drawings:MenuElement({id = "DrawW", name = "Draw W Range", value = true})
	self.AsheMenu.Drawings:MenuElement({id = "DrawR", name = "Draw R Range", value = true})
	self.AsheMenu.Drawings:MenuElement({id = "WRng", name = "W Range Color", color = DrawColor(192, 218, 112, 214)})
	self.AsheMenu.Drawings:MenuElement({id = "RRng", name = "R Range Color", color = DrawColor(192, 220, 20, 60)})
	self.AsheMenu:MenuElement({id = "Misc", name = "Misc", type = MENU})
	self.AsheMenu.Misc:MenuElement({id = "UseEDragon", name = "Use E On Dragon", key = string.byte("N"), leftIcon = self.EIcon})
	self.AsheMenu.Misc:MenuElement({id = "UseEBaron", name = "Use E On Baron", key = string.byte("M"), leftIcon = self.EIcon})
	self.AsheMenu:MenuElement({id = "blank", name = "GoS-U Reborn v"..LuaVer.."", type = SPACE})
	self.AsheMenu:MenuElement({id = "blank", name = "Author: Ark223", type = SPACE})
	self.AsheMenu:MenuElement({id = "blank", name = "Credits: gamsteron", type = SPACE})
	OnDraws.Champion = function() self:Draw() end
	OnTicks.Champion = function() self:Tick() end
	_G.SDK.Orbwalker:OnPreAttack(function(...) self:OnPreAttack(...) end)
end

function Ashe:Tick()
	if ((_G.ExtLibEvade and _G.ExtLibEvade.Evading) or _G.JustEvade or Game.IsChatOpen()) then return end
	self:Auto2()
	target1 = Module.TargetSelector:GetTarget(self.WData.range, nil)
	target2 = Module.TargetSelector:GetTarget(self.AsheMenu.Combo.Distance:Value(), nil)
	if target2 == nil then return end
	if GoSuManager:GetOrbwalkerMode() == "Combo" then Module.Utility:Tick(); self:Combo(target1, target2)
	elseif GoSuManager:GetOrbwalkerMode() == "Harass" then self:Harass(target1)
	else self:Auto(target1) end
end

function Ashe:Draw()
	if self.AsheMenu.Drawings.DrawW:Value() then DrawCircle(myHero.pos, self.WData.range, 1, self.AsheMenu.Drawings.WRng:Value()) end
	if self.AsheMenu.Drawings.DrawR:Value() then DrawCircle(myHero.pos, self.AsheMenu.Combo.Distance:Value(), 1, self.AsheMenu.Drawings.RRng:Value()) end
end

function Ashe:OnPreAttack(args)
	if (self.AsheMenu.Combo.UseQ:Value() and GoSuManager:GetOrbwalkerMode() == "Combo") or (GoSuManager:GetPercentMana(myHero) > self.AsheMenu.Harass.MP:Value() and self.AsheMenu.Harass.UseQ:Value() and GoSuManager:GetOrbwalkerMode() == "Harass") then
		local target = Module.TargetSelector:GetTarget(myHero.range + myHero.boundingRadius * 2, nil); args.Target = target
		if GoSuManager:IsReady(_Q) and GoSuManager:ValidTarget(target, AARange) and GoSuManager:GotBuff(myHero, "asheqcastready") == 4 then
			ControlCastSpell(HK_Q)
		end
	end
end

function Ashe:Auto(target)
	if target == nil and myHero.attackData.state == 2 then return end
	if self.AsheMenu.Auto.UseW:Value() then
		if GoSuManager:GetPercentMana(myHero) > self.AsheMenu.Auto.MP:Value() and GoSuManager:IsReady(_W) and GoSuManager:ValidTarget(target, self.WData.range) then
			self:UseW(target)
		end
	end
end

function Ashe:Auto2()
	for i, enemy in pairs(GoSuManager:GetEnemyHeroes()) do
		if GoSuManager:IsReady(_R) then
			if self.AsheMenu.AntiGapcloser.UseR:Value() and GoSuManager:ValidTarget(enemy, self.AsheMenu.AntiGapcloser.Distance:Value()) then
				self:UseR(enemy, self.AsheMenu.AntiGapcloser.Distance:Value())
			end
			if self.AsheMenu.KillSteal.UseR:Value() and GoSuManager:ValidTarget(enemy, self.AsheMenu.KillSteal.Distance:Value()) then
				local RDmg = GoSuManager:GetDamage(enemy, 3, 0)
				if RDmg > enemy.health then
					self:UseR(enemy, self.AsheMenu.KillSteal.Distance:Value())
				end
			end
		end
	end
	if GoSuManager:IsReady(_E) then
		local Spot = nil
		if self.AsheMenu.Misc.UseEBaron:Value() then Spot = Vector(4942, -71, 10400):ToMM()
		elseif self.AsheMenu.Misc.UseEDragon:Value() then Spot = Vector(9832, -71, 4360):ToMM() end
		if Spot then
			ControlCastSpell(HK_E, Spot.x, Spot.y)
		end
	end
end

function Ashe:Combo(target1, target2)
	if target2 == nil and myHero.attackData.state == 2 then return end
	if self.AsheMenu.Combo.UseW:Value() and GoSuManager:IsReady(_W) and GoSuManager:ValidTarget(target1, self.WData.range) then
		self:UseW(target1)
	end
	if self.AsheMenu.Combo.UseR:Value() and GoSuManager:IsReady(_R) and GoSuManager:ValidTarget(target2, self.AsheMenu.Combo.Distance:Value()) then
		local enemies, count = GoSuManager:GetHeroesAround(myHero.pos, self.AsheMenu.Combo.Distance:Value())
		if GoSuManager:GetPercentHP(target2) < self.AsheMenu.Combo.HP:Value() and count >= self.AsheMenu.Combo.X:Value() then			
			self:UseR(target2, self.AsheMenu.Combo.Distance:Value())
		end
	end
end

function Ashe:Harass(target)
	if target == nil and myHero.attackData.state == 2 then return end
	if GoSuManager:GetPercentMana(myHero) > self.AsheMenu.Harass.MP:Value() and self.AsheMenu.Harass.UseW:Value() and GoSuManager:IsReady(_W) and GoSuManager:ValidTarget(target, self.WData.range) then
		self:UseW(target)
	end
end

function Ashe:UseW(target)
	local CastPos, PredPos, HitChance, TimeToHit = PremiumPrediction:GetPrediction(myHero, target, self.WData.speed, self.WData.range, self.WData.delay, self.WData.radius, nil, self.WData.collision)
	if CastPos and HitChance >= (self.AsheMenu.HitChance.HCW:Value() / 100) then ControlCastSpell(HK_W, CastPos) end
end

function Ashe:UseR(target, range)
	local CastPos, PredPos, HitChance, TimeToHit = PremiumPrediction:GetPrediction(myHero, target, self.RData.speed, range, self.RData.delay, self.RData.radius, nil, self.RData.collision)
	if CastPos and HitChance >= (self.AsheMenu.HitChance.HCR:Value() / 100) then ControlCastSpell(HK_R, CastPos) end
end

--
--
--

Callback.Add("Draw", function()
	if OnDraws.Awareness then OnDraws.Awareness() end
	if OnDraws.BaseUlt then OnDraws.BaseUlt() end
	if OnDraws.Champion then OnDraws.Champion() end
	if OnDraws.TargetSelector then OnDraws.TargetSelector() end
end)
Callback.Add("ProcessRecall", function(unit, recall)
	if OnRecalls.Awareness then OnRecalls.Awareness(unit, recall) end
	if OnRecalls.BaseUlt then OnRecalls.BaseUlt(unit, recall) end
end)
Callback.Add("Tick", function()
	if OnTicks.Champion then OnTicks.Champion() end
end)
