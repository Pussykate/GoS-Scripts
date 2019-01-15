--  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄               ▄         ▄ 
-- ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌             ▐░▌       ▐░▌
-- ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀              ▐░▌       ▐░▌
-- ▐░▌          ▐░▌       ▐░▌▐░▌                       ▐░▌       ▐░▌
-- ▐░▌ ▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌
-- ▐░▌▐░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌
-- ▐░▌ ▀▀▀▀▀▀█░▌▐░▌       ▐░▌ ▀▀▀▀▀▀▀▀▀█░▌ ▀▀▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌
-- ▐░▌       ▐░▌▐░▌       ▐░▌          ▐░▌             ▐░▌       ▐░▌
-- ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌ ▄▄▄▄▄▄▄▄▄█░▌             ▐░█▄▄▄▄▄▄▄█░▌
-- ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌             ▐░░░░░░░░░░░▌
--  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀               ▀▀▀▀▀▀▀▀▀▀▀ 
-- ==================
-- == Introduction ==
-- ==================
-- Current version: 1.1.6.1
-- Intermediate GoS script which supports only ADC champions.
-- Features:
-- + Supports Ashe, Caitlyn, Corki, Draven, Ezreal, Jhin, Jinx, Kaisa, Kalista,
--   KogMaw, Lucian, MissFortune, Sivir, Tristana, Varus, Vayne
-- + 4 choosable predictions (GoS, IPrediction, GPrediction, OpenPredict) + CurrentPos casting,
-- + 3 managers (Enemies-around, Mana, HP),
-- + Configurable casting settings (Auto, Combo, Harass),
-- + Different types of making combat,
-- + Advanced farm logic (LastHit & LaneClear).
-- + Additional Anti-Gapcloser and Interrupter,
-- + Spell range drawings (circular),
-- + Special damage indicator over HP bar of enemy,
-- + Offensive items usage & stacking tear,
-- + Includes GoS-U Utility
-- (Summoner spells & items usage, Auto-LevelUp, killable AA drawings)
-- ==================
-- == Requirements ==
-- ==================
-- + Orbwalker: IOW/GosWalk/DAC/DAC:R
-- ===============
-- == Changelog ==
-- ===============
-- 1.1.6.1
-- + Updated damage calc for Patch 8.13
-- + Improved logic for Jinx's Q
-- 1.1.6
-- + Added DAC & DAC:R support
-- 1.1.5.4
-- + Corrected Kaisa & Varus damage calc
-- 1.1.5.3
-- + Corrected data for Kaisa & Lucian
-- 1.1.5.2
-- + Reworked Jungler Tracker
-- 1.1.5.1
-- + Imported Jungler Tracker
-- 1.1.5
-- + Added Tristana
-- 1.1.4.1
-- + Improved Kaisa's E
-- 1.1.4
-- + Added Varus
-- 1.1.3
-- + Added Sivir
-- 1.1.2.1
-- + Minor changes
-- 1.1.2
-- + Added Kaisa
-- 1.1.1.2
-- + Corrected Jhin's Q damage
-- 1.1.1.1
-- + Fixed Heal
-- 1.1.1
-- + Added Lucian
-- 1.1
-- + Added Vayne
-- 1.0.9
-- + Added MissFortune
-- 1.0.8
-- + Added KogMaw
-- 1.0.7
-- + Added Kalista
-- 1.0.6
-- + Added Jinx
-- + Restored modes for Ezreal's W
-- 1.0.5.1
-- + Removed modes from Ezreal's W
-- 1.0.5
-- + Added Jhin
-- 1.0.4
-- + Added Ezreal
-- 1.0.3
-- + Added Draven & BaseUlt
-- 1.0.2
-- + Added Corki
-- 1.0.1
-- + Added Caitlyn
-- 1.0
-- + Initial release
-- + Imported Ashe & Utility

local GSVer = 1.161

function AutoUpdate(data)
	local num = tonumber(data)
	if num > GSVer then
		PrintChat("<font color='#1E90FF'>[<font color='#00BFFF'>GoS-U<font color='#1E90FF'>] <font color='#00BFFF'>New version found! " .. data)
		PrintChat("<font color='#1E90FF'>[<font color='#00BFFF'>GoS-U<font color='#1E90FF'>] <font color='#00BFFF'>Downloading update, please wait...")
		DownloadFileAsync("https://raw.githubusercontent.com/Ark223/GoS-Scripts/master/GoS-U.lua", SCRIPT_PATH .. "GoS-U.lua", function() PrintChat("<font color='#1E90FF'>[<font color='#00BFFF'>GoS-U<font color='#1E90FF'>] <font color='#00BFFF'>Successfully updated. Please 2x F6!") return end)
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/Ark223/GoS-Scripts/master/GoS-U.version", AutoUpdate)

require('Inspired')
require('IPrediction')
require('OpenPredict')

function Mode()
	if _G.IOW and IOW:Mode() then
		return IOW:Mode()
	elseif _G.GoSWalkLoaded and GoSWalk.CurrentMode then
		return ({"Combo", "Harass", "LaneClear", "LastHit"})[GoSWalk.CurrentMode+1]
	elseif _G.DAC_Loaded and DAC:Mode() then
		return DAC:Mode()
	elseif _G.AutoCarry_Loaded and DACR:Mode() then
		return DACR:Mode()
	end
end

OnProcessSpell(function(unit, spell)
	if unit == myHero then
		if spell.name:lower():find("attack") then
			DelayAction(function()
				AA = true
			end, GetWindUp(myHero)+0.01)
		else
			AA = false
		end
	end
end)

CHANELLING_SPELLS = {
    ["Caitlyn"]                     = {_R},
    ["Darius"]                      = {_R},
    ["FiddleSticks"]                = {_W, _R},
    ["Galio"]                       = {_W},
    ["Gragas"]                      = {_W},
    ["Janna"]                       = {_R},
    ["Karthus"]                     = {_R},
    ["Katarina"]                    = {_R},
    ["Lucian"]                      = {_R},
    ["Malzahar"]                    = {_R},
    ["MasterYi"]                    = {_W},
    ["MissFortune"]                 = {_R},
    ["Nunu"]                        = {_R},
    ["Pantheon"]                    = {_E, _R},
    ["Shen"]                        = {_R},
    ["Sion"]                        = {_Q},
    ["TahmKench"]                   = {_R},
    ["TwistedFate"]                 = {_R},
    ["Warwick"]                     = {_R},
    ["Varus"]                       = {_Q},
    ["VelKoz"]                      = {_R},
    ["Vi"]                          = {_Q},
    ["Xerath"]                      = {_Q, _R},
    ["Zac"]                         = {_E},
}

GAPCLOSER_SPELLS = {
    ["Aatrox"]                      = {_Q},
    ["Akali"]                       = {_R},
    ["Alistar"]                     = {_W},
    ["Amumu"]                       = {_Q},
    ["Corki"]                       = {_W},
    ["Diana"]                       = {_R},
    ["Elise"]                       = {_Q, _E},
    ["FiddleSticks"]                = {_R},
    ["Ezreal"]                      = {_E},
    ["Fiora"]                       = {_Q},
    ["Fizz"]                        = {_Q},
    ["Galio"]                       = {_E},
    ["Gnar"]                        = {_E},
    ["Gragas"]                      = {_E},
    ["Graves"]                      = {_E},
    ["Hecarim"]                     = {_R},
    ["Irelia"]                      = {_Q},
    ["JarvanIV"]                    = {_Q, _R},
    ["Jax"]                         = {_Q},
    ["Jayce"]                       = {_Q},
    ["Kaisa"]                       = {_E, _R},
    ["Katarina"]                    = {_E},
    ["Kassadin"]                    = {_R},
    ["Kayn"]                        = {_Q},
    ["Kennen"]                      = {_E},
    ["KhaZix"]                      = {_E},
    ["Lissandra"]                   = {_E},
    ["LeBlanc"]                     = {_W, _R},
    ["LeeSin"]                      = {_Q, _W},
    ["Leona"]                       = {_E},
    ["Lucian"]                      = {_E},
    ["Malphite"]                    = {_R},
    ["MasterYi"]                    = {_Q},
    ["MonkeyKing"]                  = {_E},
    ["Nautilus"]                    = {_Q},
    ["Nocturne"]                    = {_R},
    ["Olaf"]                        = {_R},
    ["Ornn"]                        = {_E},
    ["Pantheon"]                    = {_W, _R},
    ["Poppy"]                       = {_E},
    ["RekSai"]                      = {_E},
    ["Renekton"]                    = {_E},
    ["Riven"]                       = {_Q, _E},
    ["Rengar"]                      = {_R},
    ["Sejuani"]                     = {_Q},
    ["Sion"]                        = {_R},
    ["Shen"]                        = {_E},
    ["Shyvana"]                     = {_R},
    ["Talon"]                       = {_E},
    ["Thresh"]                      = {_Q},
    ["Tristana"]                    = {_W},
    ["Tryndamere"]                  = {_E},
    ["Udyr"]                        = {_E},
    ["Urgot"]                       = {_E},
    ["Volibear"]                    = {_Q},
    ["Vi"]                          = {_Q},
    ["XinZhao"]                     = {_E},
    ["Yasuo"]                       = {_E},
    ["Zac"]                         = {_E},
    ["Ziggs"]                       = {_W},
    ["Zoe"]                         = {_R},
}

local UtilityMenu = Menu("[GoS-U] Utility", "[GoS-U] Utility")
UtilityMenu:Menu("BaseUlt", "BaseUlt")
UtilityMenu.BaseUlt:Boolean('BU', 'Enable BaseUlt', true)
UtilityMenu:Menu("Draws", "Draws")
UtilityMenu.Draws:Boolean('DrawAA', 'Draw Killable AAs', true)
UtilityMenu.Draws:Boolean('DrawJng', 'Draw Jungler Info', true)
UtilityMenu:Menu("Items", "Items")
UtilityMenu.Items:Boolean('UseBC', 'Use Bilgewater Cutlass', true)
UtilityMenu.Items:Boolean('UseBOTRK', 'Use BOTRK', true)
UtilityMenu.Items:Boolean('UseHG', 'Use Hextech Gunblade', true)
UtilityMenu.Items:Boolean('UseMS', 'Use Mercurial Scimitar', true)
UtilityMenu.Items:Boolean('UseQS', 'Use Quicksilver Sash', true)
UtilityMenu.Items:Slider("OI","%HP To Use Offensive Items", 35, 0, 100, 5)
UtilityMenu:Menu("LevelUp", "LevelUp")
UtilityMenu.LevelUp:Boolean('LvlUp', 'Enable Level-Up', true)
UtilityMenu:Menu("SS", "Summoner Spells")
UtilityMenu.SS:Boolean('UseHeal', 'Use Heal', true)
UtilityMenu.SS:Boolean('UseSave', 'Save Ally Using Heal', true)
UtilityMenu.SS:Boolean('UseBarrier', 'Use Barrier', true)
UtilityMenu.SS:Slider("HealMe","%HP To Use Heal: MyHero", 15, 0, 100, 5)
UtilityMenu.SS:Slider("HealAlly","%HP To Use Heal: Ally", 15, 0, 100, 5)
UtilityMenu.SS:Slider("BarrierMe","%HP To Use Barrier", 15, 0, 100, 5)

SpawnPos = nil
Recalling = {}
local GlobalTimer = 0
OnObjectLoad(function(Object)
	if GetObjectType(Object) == Obj_AI_SpawnPoint and GetTeam(Object) ~= GetTeam(myHero) then
		SpawnPos = Object
	end
end)
OnCreateObj(function(Object)
	if GetObjectType(Object) == Obj_AI_SpawnPoint and GetTeam(Object) ~= GetTeam(myHero) then
		SpawnPos = Object
	end
end)
function BaseUlt()
	if UtilityMenu.BaseUlt.BU:Value() then
		if CanUseSpell(myHero, _R) == READY then
			for i, recall in pairs(Recalling) do
				if GetObjectName(myHero) == "Ashe" then
					local AsheRDmg = (200*GetCastLevel(myHero,_R))+GetBonusAP(myHero)
					if AsheRDmg >= (GetCurrentHP(recall.champ)+GetMagicResist(recall.champ)+GetHPRegen(recall.champ)*20) and SpawnPos ~= nil then
						local RecallTime = recall.duration-(GetGameTimer()-recall.start)+GetLatency()/2000
						local HitTime = 0.25+GetDistance(SpawnPos)/1600+GetLatency()/2000
						if RecallTime < HitTime and HitTime < 7.8 and HitTime-RecallTime < 1.5 then
							CastSkillShot(_R, GetOrigin(SpawnPos))
						end
					end
				elseif GetObjectName(myHero) == "Draven" then
					local DravenRDmg = (80*GetCastLevel(myHero,_R)+60)+(0.88*GetBonusDmg(myHero))
					if DravenRDmg >= (GetCurrentHP(recall.champ)+GetArmor(recall.champ)+GetHPRegen(recall.champ)*20) and SpawnPos ~= nil then
						local RecallTime = recall.duration-(GetGameTimer()-recall.start)+GetLatency()/2000
						local HitTime = 0.5+GetDistance(SpawnPos)/2000+GetLatency()/2000
						if RecallTime < HitTime and HitTime < 7.8 and HitTime-RecallTime < 1.5 then
							local Timer = GetTickCount()
							if (GlobalTimer + 12500) < Timer then
								CastSkillShot(_R, GetOrigin(SpawnPos))
								GlobalTimer = Timer
							end
						end
					end
				elseif GetObjectName(myHero) == "Ezreal" then
					local EzrealRDmg = (0.3*(150*GetCastLevel(myHero,_R)+200)+GetBonusDmg(myHero)+(0.9*GetBonusAP(myHero)))
					if EzrealRDmg >= (GetCurrentHP(recall.champ)+GetMagicResist(recall.champ)+GetHPRegen(recall.champ)*20) and SpawnPos ~= nil then
						local RecallTime = recall.duration-(GetGameTimer()-recall.start)+GetLatency()/2000
						local HitTime = 1+GetDistance(SpawnPos)/2000+GetLatency()/2000
						if RecallTime < HitTime and HitTime < 7.8 and HitTime-RecallTime < 1.5 then
							CastSkillShot(_R, GetOrigin(SpawnPos))
						end
					end
				elseif GetObjectName(myHero) == "Jinx" then
					local JinxRDmg = math.max(50*GetCastLevel(myHero,_R)+75+GetBonusDmg(myHero)+(0.05*GetCastLevel(myHero,_R)+0.2)*(GetMaxHP(recall.champ)-GetCurrentHP(recall.champ)))
					if JinxRDmg >= (GetCurrentHP(recall.champ)+GetMagicResist(recall.champ)+GetHPRegen(recall.champ)*20) and SpawnPos ~= nil then
						local RecallTime = recall.duration-(GetGameTimer()-recall.start)+GetLatency()/2000
						JinxRSpeed = GetDistance(SpawnPos) > 1350 and (2295000+(GetDistance(SpawnPos)-1350)*2200)/GetDistance(SpawnPos) or 700
						local HitTime = 0.6+GetDistance(SpawnPos)/JinxRSpeed+GetLatency()/2000
						if RecallTime < HitTime and HitTime < 7.8 and HitTime-RecallTime < 1.5 then
							CastSkillShot(_R, GetOrigin(SpawnPos))
						end
					end
				end
			end
		end
	end
end
OnProcessRecall(function(unit,recall)
	if GetTeam(unit) ~= GetTeam(myHero) then 
		if recall.isStart then
			table.insert(Recalling, {champ = unit, start = GetGameTimer(), duration = (recall.totalTime/1000)})
		else
			for i, recall in pairs(Recalling) do
				if recall.champ == unit then
					table.remove(Recalling, i)
				end
			end
		end
	end
end)

Heal = (GetCastName(myHero,SUMMONER_1):lower():find("summonerheal") and SUMMONER_1 or (GetCastName(myHero,SUMMONER_2):lower():find("summonerheal") and SUMMONER_2 or nil))
Barrier = (GetCastName(myHero,SUMMONER_1):lower():find("summonerbarrier") and SUMMONER_1 or (GetCastName(myHero,SUMMONER_2):lower():find("summonerbarrier") and SUMMONER_2 or nil))

OnTick(function(myHero)
	target = GetCurrentTarget()
	BaseUlt()
	Items1()
	Items2()
	LevelUp()
	SS()
end)

OnDraw(function(myHero)
	for _, enemy in pairs(GetEnemyHeroes()) do
		if UtilityMenu.Draws.DrawJng:Value() then
			if GetCastName(enemy,SUMMONER_1):lower():find("smite") and SUMMONER_1 or (GetCastName(enemy,SUMMONER_2):lower():find("smite") and SUMMONER_2 or nil) then
				DrawJng = WorldToScreen(1,GetOrigin(myHero).x, GetOrigin(myHero).y, GetOrigin(myHero).z)
				if IsObjectAlive(enemy) then
					if ValidTarget(enemy) then
						if GetDistance(myHero, enemy) > 3000 then
							DrawText("Jungler: Visible", 17, DrawJng.x-45, DrawJng.y+10, 0xff32cd32)
						else
							DrawText("Jungler: Near", 17, DrawJng.x-43, DrawJng.y+10, 0xffff0000)
						end
					else
						DrawText("Jungler: Invisible", 17, DrawJng.x-55, DrawJng.y+10, 0xffffd700)
					end
				else
					DrawText("Jungler: Dead", 17, DrawJng.x-45, DrawJng.y+10, 0xff32cd32)
				end
			end
		end
		if UtilityMenu.Draws.DrawAA:Value() then
			if ValidTarget(enemy) then
				DrawAA = WorldToScreen(1,GetOrigin(enemy).x, GetOrigin(enemy).y, GetOrigin(enemy).z)
				AALeft = (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy))/(GetBonusDmg(myHero)+GetBaseDamage(myHero))
				DrawText("AA Left: "..tostring(math.ceil(AALeft)), 17, DrawAA.x-38, DrawAA.y+10, 0xff00bfff)
			end
		end
	end
end)

function Items1()
	if EnemiesAround(myHero, 1000) >= 1 then
		if (GetCurrentHP(target)/GetMaxHP(target))*100 <= UtilityMenu.Items.OI:Value() then
			if UtilityMenu.Items.UseBC:Value() then
				if GetItemSlot(myHero, 3144) >= 1 and ValidTarget(target, 550) then
					if CanUseSpell(myHero, GetItemSlot(myHero, 3144)) == READY then
						CastTargetSpell(target, GetItemSlot(myHero, 3144))
					end
				end
			end
			if UtilityMenu.Items.UseBOTRK:Value() then
				if GetItemSlot(myHero, 3153) >= 1 and ValidTarget(target, 550) then
					if CanUseSpell(myHero, GetItemSlot(myHero, 3153)) == READY then
						CastTargetSpell(target, GetItemSlot(myHero, 3153))
					end
				end
			end
			if UtilityMenu.Items.UseHG:Value() then
				if GetItemSlot(myHero, 3146) >= 1 and ValidTarget(target, 700) then
					if CanUseSpell(myHero, GetItemSlot(myHero, 3146)) == READY then
						CastTargetSpell(target, GetItemSlot(myHero, 3146))
					end
				end
			end
		end
	end
end

function Items2()
	if UtilityMenu.Items.UseMS:Value() then
		if GetItemSlot(myHero, 3139) >= 1 then
			if CanUseSpell(myHero, GetItemSlot(myHero, 3139)) == READY then
				if GotBuff(myHero, "veigareventhorizonstun") > 0 or GotBuff(myHero, "stun") > 0 or GotBuff(myHero, "taunt") > 0 or GotBuff(myHero, "slow") > 0 or GotBuff(myHero, "snare") > 0 or GotBuff(myHero, "charm") > 0 or GotBuff(myHero, "suppression") > 0 or GotBuff(myHero, "flee") > 0 or GotBuff(myHero, "knockup") > 0 then
					CastTargetSpell(myHero, GetItemSlot(myHero, 3139))
				end
			end
		end
	end
	if UtilityMenu.Items.UseQS:Value() then
		if GetItemSlot(myHero, 3140) >= 1 then
			if CanUseSpell(myHero, GetItemSlot(myHero, 3140)) == READY then
				if GotBuff(myHero, "veigareventhorizonstun") > 0 or GotBuff(myHero, "stun") > 0 or GotBuff(myHero, "taunt") > 0 or GotBuff(myHero, "slow") > 0 or GotBuff(myHero, "snare") > 0 or GotBuff(myHero, "charm") > 0 or GotBuff(myHero, "suppression") > 0 or GotBuff(myHero, "flee") > 0 or GotBuff(myHero, "knockup") > 0 then
					CastTargetSpell(myHero, GetItemSlot(myHero, 3140))
				end
			end
		end
	end
end

function LevelUp()
	if UtilityMenu.LevelUp.LvlUp:Value() then
		if "Ashe" == GetObjectName(myHero) or "KogMaw" == GetObjectName(myHero) then
			leveltable = {_W, _Q, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				DelayAction(function() LevelSpell(leveltable[GetLevel(myHero) + 1 - GetLevelPoints(myHero)]) end, 0.5)
			end
		elseif "Caitlyn" == GetObjectName(myHero) or "Draven" == GetObjectName(myHero) or "Jhin" == GetObjectName(myHero) or "Jinx" == GetObjectName(myHero) or "MissFortune" == GetObjectName(myHero) or "Sivir" == GetObjectName(myHero) or "Vayne" == GetObjectName(myHero) then
			leveltable = {_Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				DelayAction(function() LevelSpell(leveltable[GetLevel(myHero) + 1 - GetLevelPoints(myHero)]) end, 0.5)
			end
		elseif "Corki" == GetObjectName(myHero) or "Ezreal" == GetObjectName(myHero) or "Lucian" == GetObjectName(myHero) then
			leveltable = {_Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W}
			if GetLevelPoints(myHero) > 0 then
				DelayAction(function() LevelSpell(leveltable[GetLevel(myHero) + 1 - GetLevelPoints(myHero)]) end, 0.5)
			end
		elseif "Kalista" == GetObjectName(myHero) or "Tristana" == GetObjectName(myHero) then
			leveltable = {_E, _Q, _W, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W}
			if GetLevelPoints(myHero) > 0 then
				DelayAction(function() LevelSpell(leveltable[GetLevel(myHero) + 1 - GetLevelPoints(myHero)]) end, 0.5)
			end
		elseif "Varus" == GetObjectName(myHero) then
			leveltable = {_E, _W, _Q, _E, _E, _R, _E, _W, _E, _W, _R, _W, _W, _Q, _Q, _R, _Q, _Q}
			if GetLevelPoints(myHero) > 0 then
				DelayAction(function() LevelSpell(leveltable[GetLevel(myHero) + 1 - GetLevelPoints(myHero)]) end, 0.5)
			end
		end
	end
end

function SS()
	if EnemiesAround(myHero, 2500) >= 1 then
		if UtilityMenu.SS.UseHeal:Value() then
			if Heal then
				if IsObjectAlive(myHero) and GetCurrentHP(myHero) > 0 and (GetCurrentHP(myHero)/GetMaxHP(myHero))*100 <= UtilityMenu.SS.HealMe:Value() then
					CastSpell(Heal)
				end
				for _, ally in pairs(GetAllyHeroes()) do
					if ValidTarget(ally, 850) then
						if IsObjectAlive(ally) and GetCurrentHP(ally) > 0 and (GetCurrentHP(ally)/GetMaxHP(ally))*100 <= UtilityMenu.SS.HealAlly:Value() then
							CastTargetSpell(ally, Heal)
						end
					end
				end
			end
		end
		if UtilityMenu.SS.UseBarrier:Value() then
			if Barrier then
				if IsObjectAlive(myHero) and GetCurrentHP(myHero) > 0 and (GetCurrentHP(myHero)/GetMaxHP(myHero))*100 <= UtilityMenu.SS.BarrierMe:Value() then
					CastSpell(Barrier)
				end
			end
		end
	end
end

-- Ashe

if "Ashe" == GetObjectName(myHero) then

PrintChat("<font color='#1E90FF'>[<font color='#00BFFF'>GoS-U<font color='#1E90FF'>] <font color='#00BFFF'>Ashe loaded successfully!")
local AsheMenu = Menu("[GoS-U] Ashe", "[GoS-U] Ashe")
AsheMenu:Menu("Auto", "Auto")
AsheMenu.Auto:Boolean('UseW', 'Use W [Volley]', true)
AsheMenu.Auto:Slider("MP","Mana-Manager", 40, 0, 100, 5)
AsheMenu:Menu("Combo", "Combo")
AsheMenu.Combo:Boolean('UseQ', 'Use Q [Rangers Focus]', true)
AsheMenu.Combo:Boolean('UseW', 'Use W [Volley]', true)
AsheMenu.Combo:Boolean('UseR', 'Use R [Crystal Arrow]', true)
AsheMenu.Combo:Slider('Distance','Distance: R', 2000, 100, 10000, 100)
AsheMenu.Combo:Slider('X','Minimum Enemies: R', 1, 0, 5, 1)
AsheMenu.Combo:Slider('HP','HP-Manager: R', 40, 0, 100, 5)
AsheMenu:Menu("Harass", "Harass")
AsheMenu.Harass:Boolean('UseQ', 'Use Q [Rangers Focus]', true)
AsheMenu.Harass:Boolean('UseW', 'Use W [Volley]', true)
AsheMenu.Harass:Slider("MP","Mana-Manager", 40, 0, 100, 5)
AsheMenu:Menu("KillSteal", "KillSteal")
AsheMenu.KillSteal:Boolean('UseW', 'Use W [Volley]', true)
AsheMenu.KillSteal:Boolean('UseR', 'Use R [Crystal Arrow]', true)
AsheMenu.KillSteal:Slider('Distance','Distance: R', 2000, 100, 10000, 100)
AsheMenu:Menu("LaneClear", "LaneClear")
AsheMenu.LaneClear:Boolean('UseQ', 'Use Q [Rangers Focus]', true)
AsheMenu.LaneClear:Boolean('UseW', 'Use W [Volley]', true)
AsheMenu.LaneClear:Slider("MP","Mana-Manager", 40, 0, 100, 5)
AsheMenu:Menu("AntiGapcloser", "Anti-Gapcloser")
AsheMenu.AntiGapcloser:Boolean('UseW', 'Use W [Volley]', true)
AsheMenu.AntiGapcloser:Boolean('UseR', 'Use R [Crystal Arrow]', true)
AsheMenu.AntiGapcloser:Slider('DistanceW','Distance: W', 200, 25, 500, 25)
AsheMenu.AntiGapcloser:Slider('DistanceR','Distance: R', 200, 25, 500, 25)
AsheMenu:Menu("Interrupter", "Interrupter")
AsheMenu.Interrupter:Boolean('UseR', 'Use R [Crystal Arrow]', true)
AsheMenu.Interrupter:Slider('Distance','Distance: R', 400, 50, 1000, 50)
AsheMenu:Menu("Prediction", "Prediction")
AsheMenu.Prediction:DropDown("PredictionW", "Prediction: W", 2, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
AsheMenu.Prediction:DropDown("PredictionR", "Prediction: R", 2, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
AsheMenu:Menu("Drawings", "Drawings")
AsheMenu.Drawings:Boolean('DrawW', 'Draw W Range', true)
AsheMenu.Drawings:Boolean('DrawR', 'Draw R Range', true)
AsheMenu.Drawings:Boolean('DrawDMG', 'Draw Max QWR Damage', false)

local AsheW = { range = 1200, radius = 20, width = 40, speed = 2000, delay = 0.25, type = "line", collision = true, source = myHero, col = {"minion","yasuowall"}}
local AsheR = { range = AsheMenu.Combo.Distance:Value(), radius = 125, width = 250, speed = 1600, delay = 0.25, type = "line", collision = false, source = myHero }

OnTick(function(myHero)
	Auto()
	Combo()
	Harass()
	KillSteal()
	LaneClear()
	AntiGapcloser()
end)
OnDraw(function(myHero)
	Ranges()
	DrawDamage()
end)

function Ranges()
local pos = GetOrigin(myHero)
if AsheMenu.Drawings.DrawW:Value() then DrawCircle(pos,AsheW.range,1,25,0xff4169e1) end
if AsheMenu.Drawings.DrawR:Value() then DrawCircle(pos,AsheR.range,1,25,0xff0000ff) end
end

function DrawDamage()
	for _, enemy in pairs(GetEnemyHeroes()) do
		local QDmg = (0.05*GetCastLevel(myHero,_Q)+1)+(GetBonusDmg(myHero)+GetBaseDamage(myHero))
		local WDmg = (15*GetCastLevel(myHero,_W)+5)+(GetBonusDmg(myHero)+GetBaseDamage(myHero))
		local RDmg = (200*GetCastLevel(myHero,_R))+(GetBonusAP(myHero))
		local ComboDmg = QDmg + WDmg + RDmg
		local WRDmg = WDmg + RDmg
		local QRDmg = QDmg + RDmg
		local QWDmg = QDmg + WDmg
		if ValidTarget(enemy) then
			if AsheMenu.Drawings.DrawDMG:Value() then
				if Ready(_Q) and Ready(_W) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ComboDmg), 0xff008080)
				elseif Ready(_W) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WRDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QRDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_W) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QWDmg), 0xff008080)
				elseif Ready(_Q) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QDmg), 0xff008080)
				elseif Ready(_W) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WDmg), 0xff008080)
				elseif Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, RDmg), 0xff008080)
				end
			end
		end
	end
end

function useQ(target)
	CastSpell(_Q)
end
function useW(target)
	if GetDistance(target) < AsheW.range then
		if AsheMenu.Prediction.PredictionW:Value() == 1 then
			CastSkillShot(_W,GetOrigin(target))
		elseif AsheMenu.Prediction.PredictionW:Value() == 2 then
			local WPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),AsheW.speed,AsheW.delay*1000,AsheW.range,AsheW.width,true,true)
			if WPred.HitChance == 1 then
				CastSkillShot(_W, WPred.PredPos)
			end
		elseif AsheMenu.Prediction.PredictionW:Value() == 3 then
			local WPred = _G.gPred:GetPrediction(target,myHero,AsheW,false,true)
			if WPred and WPred.HitChance >= 3 then
				CastSkillShot(_W, WPred.CastPosition)
			end
		elseif AsheMenu.Prediction.PredictionW:Value() == 4 then
			local WSpell = IPrediction.Prediction({name="Volley", range=AsheW.range, speed=AsheW.speed, delay=AsheW.delay, width=AsheW.width, type="linear", collision=true})
			ts = TargetSelector()
			target = ts:GetTarget(AsheW.range)
			local x, y = WSpell:Predict(target)
			if x > 2 then
				CastSkillShot(_W, y.x, y.y, y.z)
			end
		elseif AsheMenu.Prediction.PredictionW:Value() == 5 then
			local WPrediction = GetLinearAOEPrediction(target,AsheW)
			if WPrediction.hitChance > 0.9 then
				CastSkillShot(_W, WPrediction.castPos)
			end
		end
	end
end
function useR(target)
	if GetDistance(target) < AsheR.range then
		if AsheMenu.Prediction.PredictionR:Value() == 1 then
			CastSkillShot(_R,GetOrigin(target))
		elseif AsheMenu.Prediction.PredictionR:Value() == 2 then
			local RPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),AsheR.speed,AsheR.delay*1000,AsheR.range,AsheR.width,false,false)
			if RPred.HitChance == 1 then
				CastSkillShot(_R, RPred.PredPos)
			end
		elseif AsheMenu.Prediction.PredictionR:Value() == 3 then
			local RPred = _G.gPred:GetPrediction(target,myHero,AsheR,false,false)
			if RPred and RPred.HitChance >= 3 then
				CastSkillShot(_R, RPred.CastPosition)
			end
		elseif AsheMenu.Prediction.PredictionR:Value() == 4 then
			local RSpell = IPrediction.Prediction({name="EnchantedCrystalArrow", range=AsheR.range, speed=AsheR.speed, delay=AsheR.delay, width=AsheR.width, type="linear", collision=false})
			ts = TargetSelector()
			target = ts:GetTarget(AsheR.range)
			local x, y = RSpell:Predict(target)
			if x > 2 then
				CastSkillShot(_R, y.x, y.y, y.z)
			end
		elseif AsheMenu.Prediction.PredictionR:Value() == 5 then
			local RPrediction = GetLinearAOEPrediction(target,AsheR)
			if RPrediction.hitChance > 0.9 then
				CastSkillShot(_R, RPrediction.castPos)
			end
		end
	end
end

-- Auto

function Auto()
	if AsheMenu.Auto.UseW:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > AsheMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_W) == READY then
				if ValidTarget(target, AsheW.range) then
					useW(target)
				end
			end
		end
	end
end

-- Combo

function Combo()
	if Mode() == "Combo" then
		if AsheMenu.Combo.UseQ:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if ValidTarget(target, GetRange(myHero)+GetHitBox(myHero)) then
					if GotBuff(myHero,"asheqcastready") == 4 then
						useQ(target)
					end
				end
			end
		end
		if AsheMenu.Combo.UseW:Value() then
			if CanUseSpell(myHero,_W) == READY and AA == true then
				if ValidTarget(target, AsheW.range) then
					useW(target)
				end
			end
		end
		if AsheMenu.Combo.UseR:Value() then
			if CanUseSpell(myHero,_R) == READY then
				if ValidTarget(target, AsheR.range) then
					if 100*GetCurrentHP(target)/GetMaxHP(target) < AsheMenu.Combo.HP:Value() then
						if EnemiesAround(myHero, AsheR.range+GetRange(myHero)) >= AsheMenu.Combo.X:Value() then
							useR(target)
						end
					end
				end
			end
		end
	end
end

-- Harass

function Harass()
	if Mode() == "Harass" then
		if AsheMenu.Harass.UseQ:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > AsheMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(target, GetRange(myHero)+GetHitBox(myHero)) then
						if GotBuff(myHero,"asheqcastready") == 4 then
							useQ(target)
						end
					end
				end
			end
		end
		if AsheMenu.Harass.UseW:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > AsheMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_W) == READY and AA == true then
					if ValidTarget(target, AsheW.range) then
						useW(target)
					end
				end
			end
		end
	end
end

-- KillSteal

function KillSteal()
	for i,enemy in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_W) == READY then
			if AsheMenu.KillSteal.UseW:Value() then
				if ValidTarget(enemy, AsheW.range) then
					local AsheWDmg = (15*GetCastLevel(myHero,_W)+5)+(GetBonusDmg(myHero)+GetBaseDamage(myHero))
					if (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*4) < AsheWDmg then
						useW(enemy)
					end
				end
			end
		elseif CanUseSpell(myHero,_R) == READY then
			if AsheMenu.KillSteal.UseR:Value() then
				if ValidTarget(enemy, AsheMenu.KillSteal.Distance:Value()) then
					local AsheRDmg = (200*GetCastLevel(myHero,_R))+(GetBonusAP(myHero))
					if (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*4) < AsheRDmg then
						useR(enemy)
					end
				end
			end
		end
	end
end

-- LaneClear

function LaneClear()
	if Mode() == "LaneClear" then
		if AsheMenu.LaneClear.UseW:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > AsheMenu.LaneClear.MP:Value() then
				if CanUseSpell(myHero,_W) == READY and AA == true then
					local BestPos, BestHit = GetFarmPosition(AsheW.range, 230, MINION_ENEMY)
					if BestPos and BestHit > 3 then
						CastSkillShot(_W, BestPos)
					end
				end
			end
		end
		if AsheMenu.LaneClear.UseQ:Value() then
			for _, minion in pairs(minionManager.objects) do
				if GetTeam(minion) == MINION_ENEMY then
					if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > AsheMenu.LaneClear.MP:Value() then
						if ValidTarget(minion, GetRange(myHero)+GetHitBox(myHero)) then
							if CanUseSpell(myHero,_Q) == READY then
								CastSpell(_Q)
							end
						end
					end
				end
			end
		end
	end
end

-- Anti-Gapcloser

function AntiGapcloser()
	for i,antigap in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_W) == READY then
			if AsheMenu.AntiGapcloser.UseW:Value() then
				if ValidTarget(antigap, AsheMenu.AntiGapcloser.DistanceW:Value()) then
					useW(antigap)
				end
			end
		elseif CanUseSpell(myHero,_R) == READY then
			if AsheMenu.AntiGapcloser.UseR:Value() then
				if ValidTarget(antigap, AsheMenu.AntiGapcloser.DistanceR:Value()) then
					useR(antigap)
				end
			end
		end
	end
end

-- Interrupter

OnProcessSpell(function(unit, spell)
	if AsheMenu.Interrupter.UseR:Value() then
		for _, enemy in pairs(GetEnemyHeroes()) do
			if ValidTarget(enemy, AsheMenu.Interrupter.Distance:Value()) then
				if CanUseSpell(myHero,_R) == READY then
					local UnitName = GetObjectName(enemy)
					local UnitChanellingSpells = CHANELLING_SPELLS[UnitName]
					local UnitGapcloserSpells = GAPCLOSER_SPELLS[UnitName]
					if UnitChanellingSpells then
						for _, slot in pairs(UnitChanellingSpells) do
							if spell.name == GetCastName(enemy, slot) then useR(enemy) end
						end
					elseif UnitGapcloserSpells then
						for _, slot in pairs(UnitGapcloserSpells) do
							if spell.name == GetCastName(enemy, slot) then useR(enemy) end
						end
					end
				end
			end
		end
    end
end)

-- Caitlyn

elseif "Caitlyn" == GetObjectName(myHero) then

PrintChat("<font color='#1E90FF'>[<font color='#00BFFF'>GoS-U<font color='#1E90FF'>] <font color='#00BFFF'>Caitlyn loaded successfully!")
local CaitlynMenu = Menu("[GoS-U] Caitlyn", "[GoS-U] Caitlyn")
CaitlynMenu:Menu("Auto", "Auto")
CaitlynMenu.Auto:Boolean('UseQ', 'Use Q [Piltover Peacemaker]', true)
CaitlynMenu.Auto:Boolean('UseW', 'Use W [Yordle Snap Trap]', true)
CaitlynMenu.Auto:DropDown("ModeQ", "Cast Mode: Q", 2, {"Standard", "On Immobile"})
CaitlynMenu.Auto:DropDown("ModeW", "Cast Mode: W", 2, {"Standard", "On Immobile"})
CaitlynMenu.Auto:Slider("MP","Mana-Manager", 40, 0, 100, 5)
CaitlynMenu:Menu("Combo", "Combo")
CaitlynMenu.Combo:Boolean('UseQ', 'Use Q [Piltover Peacemaker]', true)
CaitlynMenu.Combo:Boolean('UseW', 'Use W [Yordle Snap Trap]', true)
CaitlynMenu.Combo:Boolean('UseE', 'Use E [90 Caliber Net]', true)
CaitlynMenu.Combo:DropDown("ModeQ", "Cast Mode: Q", 1, {"Standard", "On Immobile"})
CaitlynMenu.Combo:DropDown("ModeW", "Cast Mode: W", 1, {"Standard", "On Immobile"})
CaitlynMenu:Menu("Harass", "Harass")
CaitlynMenu.Harass:Boolean('UseQ', 'Use Q [Piltover Peacemaker]', true)
CaitlynMenu.Harass:Boolean('UseW', 'Use W [Yordle Snap Trap]', true)
CaitlynMenu.Harass:Boolean('UseE', 'Use E [90 Caliber Net]', true)
CaitlynMenu.Harass:DropDown("ModeQ", "Cast Mode: Q", 1, {"Standard", "On Immobile"})
CaitlynMenu.Harass:DropDown("ModeW", "Cast Mode: W", 2, {"Standard", "On Immobile"})
CaitlynMenu.Harass:Slider("MP","Mana-Manager", 40, 0, 100, 5)
CaitlynMenu:Menu("KillSteal", "KillSteal")
CaitlynMenu.KillSteal:Boolean('UseQ', 'Use Q [Piltover Peacemaker]', true)
CaitlynMenu.KillSteal:Boolean('UseR', 'Draw Killable With R', true)
CaitlynMenu:Menu("LaneClear", "LaneClear")
CaitlynMenu.LaneClear:Boolean('UseQ', 'Use Q [Piltover Peacemaker]', true)
CaitlynMenu.LaneClear:Slider("MP","Mana-Manager", 40, 0, 100, 5)
CaitlynMenu:Menu("AntiGapcloser", "Anti-Gapcloser")
CaitlynMenu.AntiGapcloser:Boolean('UseW', 'Use W [Yordle Snap Trap]', true)
CaitlynMenu.AntiGapcloser:Boolean('UseE', 'Use E [90 Caliber Net]', true)
CaitlynMenu.AntiGapcloser:Slider('DistanceW','Distance: W', 300, 25, 500, 25)
CaitlynMenu.AntiGapcloser:Slider('DistanceE','Distance: E', 200, 25, 500, 25)
CaitlynMenu:Menu("Interrupter", "Interrupter")
CaitlynMenu.Interrupter:Boolean('UseW', 'Use W [Yordle Snap Trap]', true)
CaitlynMenu.Interrupter:Slider('Distance','Distance: W', 500, 50, 1000, 50)
CaitlynMenu:Menu("Prediction", "Prediction")
CaitlynMenu.Prediction:DropDown("PredictionQ", "Prediction: Q", 2, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
CaitlynMenu.Prediction:DropDown("PredictionW", "Prediction: W", 5, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
CaitlynMenu.Prediction:DropDown("PredictionE", "Prediction: E", 2, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
CaitlynMenu:Menu("Drawings", "Drawings")
CaitlynMenu.Drawings:Boolean('DrawQ', 'Draw Q Range', true)
CaitlynMenu.Drawings:Boolean('DrawW', 'Draw W Range', true)
CaitlynMenu.Drawings:Boolean('DrawE', 'Draw E Range', true)
CaitlynMenu.Drawings:Boolean('DrawR', 'Draw R Range', true)
CaitlynMenu.Drawings:Boolean('DrawDMG', 'Draw Max QWER Damage', false)

local CaitlynQ = { range = 1250, radius = 60, width = 120, speed = 2200, delay = 0.625, type = "line", collision = false, source = myHero, col = {"yasuowall"}}
local CaitlynW = { range = 800, radius = 75, width = 150, speed = math.huge, delay = 0.25, type = "circular", collision = false, source = myHero }
local CaitlynE = { range = 750, radius = 65, width = 130, speed = 1500, delay = 0.25, type = "line", collision = true, source = myHero, col = {"minion","yasuowall"}}
local CaitlynR = { range = GetCastRange(myHero,_R) }

OnTick(function(myHero)
	Auto()
	Combo()
	Harass()
	KillSteal()
	LaneClear()
	AntiGapcloser()
end)
OnDraw(function(myHero)
	Ranges()
	DrawDamage()
end)

function Ranges()
local pos = GetOrigin(myHero)
if CaitlynMenu.Drawings.DrawQ:Value() then DrawCircle(pos,CaitlynQ.range,1,25,0xff00bfff) end
if CaitlynMenu.Drawings.DrawW:Value() then DrawCircle(pos,CaitlynW.range,1,25,0xff4169e1) end
if CaitlynMenu.Drawings.DrawE:Value() then DrawCircle(pos,CaitlynE.range,1,25,0xff1e90ff) end
if CaitlynMenu.Drawings.DrawR:Value() then DrawCircle(pos,CaitlynR.range,1,25,0xff0000ff) end
end

function DrawDamage()
	local QDmg = (40*GetCastLevel(myHero,_Q)-10)+((0.1*GetCastLevel(myHero,_Q)+1.2)*(GetBonusDmg(myHero)+GetBaseDamage(myHero)))
	local WDmg = (50*GetCastLevel(myHero,_W)-10)+((0.15*GetCastLevel(myHero,_W)+0.25)*GetBonusDmg(myHero))
	local EDmg = (40*GetCastLevel(myHero,_E)+30)+(0.8*GetBonusAP(myHero))
	local RDmg = (225*GetCastLevel(myHero,_R)+25)+(2*GetBonusDmg(myHero))
	local ComboDmg = QDmg + WDmg + EDmg + RDmg
	local WERDmg = WDmg + EDmg + RDmg
	local QERDmg = QDmg + EDmg + RDmg
	local QWRDmg = QDmg + WDmg + RDmg
	local QWEDmg = QDmg + WDmg + EDmg
	local ERDmg = EDmg + RDmg
	local WRDmg = WDmg + RDmg
	local QRDmg = QDmg + RDmg
	local WEDmg = WDmg + EDmg
	local QEDmg = QDmg + EDmg
	local QWDmg = QDmg + WDmg
	for _, enemy in pairs(GetEnemyHeroes()) do
		if ValidTarget(enemy) then
			if CaitlynMenu.Drawings.DrawDMG:Value() then
				if Ready(_Q) and Ready(_W) and Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ComboDmg), 0xff008080)
				elseif Ready(_W) and Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WERDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QERDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_W) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QWRDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_W) and Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QWEDmg), 0xff008080)
				elseif Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ERDmg), 0xff008080)
				elseif Ready(_W) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WRDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QRDmg), 0xff008080)
				elseif Ready(_W) and Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WEDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QEDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_W) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QWDmg), 0xff008080)
				elseif Ready(_Q) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QDmg), 0xff008080)
				elseif Ready(_W) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WDmg), 0xff008080)
				elseif Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, EDmg), 0xff008080)
				elseif Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, RDmg), 0xff008080)
				end
			end
		end
	end
end

function useQ(target)
	if GetDistance(target) < CaitlynQ.range then
		if CaitlynMenu.Prediction.PredictionQ:Value() == 1 then
			CastSkillShot(_Q,GetOrigin(target))
		elseif CaitlynMenu.Prediction.PredictionQ:Value() == 2 then
			local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),CaitlynQ.speed,CaitlynQ.delay*1000,CaitlynQ.range,CaitlynQ.width,false,true)
			if QPred.HitChance == 1 then
				CastSkillShot(_Q, QPred.PredPos)
			end
		elseif CaitlynMenu.Prediction.PredictionQ:Value() == 3 then
			local qPred = _G.gPred:GetPrediction(target,myHero,CaitlynQ,false,true)
			if qPred and qPred.HitChance >= 3 then
				CastSkillShot(_Q, qPred.CastPosition)
			end
		elseif CaitlynMenu.Prediction.PredictionQ:Value() == 4 then
			local QSpell = IPrediction.Prediction({name="CaitlynPiltoverPeacemaker", range=CaitlynQ.range, speed=CaitlynQ.speed, delay=CaitlynQ.delay, width=CaitlynQ.width, type="linear", collision=false})
			ts = TargetSelector()
			target = ts:GetTarget(CaitlynQ.range)
			local x, y = QSpell:Predict(target)
			if x > 2 then
				CastSkillShot(_Q, y.x, y.y, y.z)
			end
		elseif CaitlynMenu.Prediction.PredictionQ:Value() == 5 then
			local QPrediction = GetLinearAOEPrediction(target,CaitlynQ)
			if QPrediction.hitChance > 0.9 then
				CastSkillShot(_Q, QPrediction.castPos)
			end
		end
	end
end
function useW(target)
	if GetDistance(target) < CaitlynW.range then
		if CaitlynMenu.Prediction.PredictionW:Value() == 1 then
			CastSkillShot(_W,GetOrigin(target))
		elseif CaitlynMenu.Prediction.PredictionW:Value() == 2 then
			local WPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),CaitlynW.speed,CaitlynW.delay*1000,CaitlynW.range,CaitlynW.width,false,true)
			if WPred.HitChance == 1 then
				CastSkillShot(_W, WPred.PredPos)
			end
		elseif CaitlynMenu.Prediction.PredictionW:Value() == 3 then
			local WPred = _G.gPred:GetPrediction(target,myHero,CaitlynW,true,false)
			if WPred and WPred.HitChance >= 3 then
				CastSkillShot(_W, WPred.CastPosition)
			end
		elseif CaitlynMenu.Prediction.PredictionW:Value() == 4 then
			local WSpell = IPrediction.Prediction({name="CaitlynYordleTrap", range=CaitlynW.range, speed=CaitlynW.speed, delay=CaitlynW.delay, width=CaitlynW.width, type="circular", collision=false})
			ts = TargetSelector()
			target = ts:GetTarget(CaitlynW.range)
			local x, y = WSpell:Predict(target)
			if x > 2 then
				CastSkillShot(_W, y.x, y.y, y.z)
			end
		elseif CaitlynMenu.Prediction.PredictionW:Value() == 5 then
			local WPrediction = GetCircularAOEPrediction(target,CaitlynW)
			if WPrediction.hitChance > 0.9 then
				CastSkillShot(_W, WPrediction.castPos)
			end
		end
	end
end
function useE(target)
	if GetDistance(target) < CaitlynE.range then
		if CaitlynMenu.Prediction.PredictionE:Value() == 1 then
			CastSkillShot(_E,GetOrigin(target))
		elseif CaitlynMenu.Prediction.PredictionE:Value() == 2 then
			local EPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),CaitlynE.speed,CaitlynE.delay*1000,CaitlynE.range,CaitlynE.width,true,false)
			if EPred.HitChance == 1 then
				CastSkillShot(_E, EPred.PredPos)
			end
		elseif CaitlynMenu.Prediction.PredictionE:Value() == 3 then
			local EPred = _G.gPred:GetPrediction(target,myHero,CaitlynE,false,true)
			if EPred and EPred.HitChance >= 3 then
				CastSkillShot(_E, EPred.CastPosition)
			end
		elseif CaitlynMenu.Prediction.PredictionE:Value() == 4 then
			local ESpell = IPrediction.Prediction({name="CaitlynEntrapmentMissile", range=CaitlynE.range, speed=CaitlynE.speed, delay=CaitlynE.delay, width=CaitlynE.width, type="linear", collision=true})
			ts = TargetSelector()
			target = ts:GetTarget(CaitlynE.range)
			local x, y = ESpell:Predict(target)
			if x > 2 then
				CastSkillShot(_E, y.x, y.y, y.z)
			end
		elseif CaitlynMenu.Prediction.PredictionE:Value() == 5 then
			local EPrediction = GetLinearAOEPrediction(target,CaitlynE)
			if EPrediction.hitChance > 0.9 then
				CastSkillShot(_E, EPrediction.castPos)
			end
		end
	end
end

-- Auto

function Auto()
	if CaitlynMenu.Auto.UseQ:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > CaitlynMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if ValidTarget(target, CaitlynQ.range) then
					if CaitlynMenu.Auto.ModeQ:Value() == 1 then
						useQ(target)
					elseif CaitlynMenu.Auto.ModeQ:Value() == 2 then
						if GotBuff(target, "veigareventhorizonstun") > 0 or GotBuff(target, "Stun") > 0 or GotBuff(target, "Taunt") > 0 or GotBuff(target, "Slow") > 0 or GotBuff(target, "Snare") > 0 or GotBuff(target, "Charm") > 0 or GotBuff(target, "Suppression") > 0 or GotBuff(target, "Flee") > 0 or GotBuff(target, "Knockup") > 0 then
							useQ(target)
						end
					end
				end
			end
		end
	end
	if CaitlynMenu.Auto.UseW:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > CaitlynMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_W) == READY then
				if ValidTarget(target, CaitlynW.range) then
					if CaitlynMenu.Auto.ModeW:Value() == 1 then
						useW(target)
					elseif CaitlynMenu.Auto.ModeW:Value() == 2 then
						if GotBuff(target, "veigareventhorizonstun") > 0 or GotBuff(target, "Stun") > 0 or GotBuff(target, "Taunt") > 0 or GotBuff(target, "Slow") > 0 or GotBuff(target, "Snare") > 0 or GotBuff(target, "Charm") > 0 or GotBuff(target, "Suppression") > 0 or GotBuff(target, "Flee") > 0 or GotBuff(target, "Knockup") > 0 then
							useW(target)
						end
					end
				end
			end
		end
	end
end

-- Combo

function Combo()
	if Mode() == "Combo" then
		if CaitlynMenu.Combo.UseQ:Value() then
			if CanUseSpell(myHero,_Q) == READY and AA == true then
				if ValidTarget(target, CaitlynQ.range) then
					if CaitlynMenu.Combo.ModeQ:Value() == 1 then
						useQ(target)
					elseif CaitlynMenu.Combo.ModeQ:Value() == 2 then
						if GotBuff(target, "veigareventhorizonstun") > 0 or GotBuff(target, "Stun") > 0 or GotBuff(target, "Taunt") > 0 or GotBuff(target, "Slow") > 0 or GotBuff(target, "Snare") > 0 or GotBuff(target, "Charm") > 0 or GotBuff(target, "Suppression") > 0 or GotBuff(target, "Flee") > 0 or GotBuff(target, "Knockup") > 0 then
							useQ(target)
						end
					end
				end
			end
		end
		if CaitlynMenu.Combo.UseW:Value() then
			if CanUseSpell(myHero,_W) == READY and AA == true then
				if ValidTarget(target, CaitlynW.range) then
					if CaitlynMenu.Combo.ModeW:Value() == 1 then
						useW(target)
					elseif CaitlynMenu.Combo.ModeW:Value() == 2 then
						if GotBuff(target, "veigareventhorizonstun") > 0 or GotBuff(target, "Stun") > 0 or GotBuff(target, "Taunt") > 0 or GotBuff(target, "Slow") > 0 or GotBuff(target, "Snare") > 0 or GotBuff(target, "Charm") > 0 or GotBuff(target, "Suppression") > 0 or GotBuff(target, "Flee") > 0 or GotBuff(target, "Knockup") > 0 then
							useW(target)
						end
					end
				end
			end
		end
		if CaitlynMenu.Combo.UseE:Value() then
			if CanUseSpell(myHero,_E) == READY then
				if ValidTarget(target, CaitlynE.range+GetHitBox(myHero)) then
					useE(target)
				elseif ValidTarget(target, 400+GetRange(myHero)+GetHitBox(myHero)) then
					local EPos = Vector(myHero)+(Vector(myHero)-Vector(target))
					CastSkillShot(_E, EPos)
				end
			end
		end
	end
end

-- Harass

function Harass()
	if Mode() == "Harass" then
		if CaitlynMenu.Harass.UseQ:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > CaitlynMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_Q) == READY and AA == true then
					if ValidTarget(target, CaitlynQ.range) then
						if CaitlynMenu.Harass.ModeQ:Value() == 1 then
							useQ(target)
						elseif CaitlynMenu.Harass.ModeQ:Value() == 2 then
							if GotBuff(target, "veigareventhorizonstun") > 0 or GotBuff(target, "Stun") > 0 or GotBuff(target, "Taunt") > 0 or GotBuff(target, "Slow") > 0 or GotBuff(target, "Snare") > 0 or GotBuff(target, "Charm") > 0 or GotBuff(target, "Suppression") > 0 or GotBuff(target, "Flee") > 0 or GotBuff(target, "Knockup") > 0 then
								useQ(target)
							end
						end
					end
				end
			end
		end
		if CaitlynMenu.Harass.UseW:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > CaitlynMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_W) == READY and AA == true then
					if ValidTarget(target, CaitlynW.range) then
						if CaitlynMenu.Harass.ModeW:Value() == 1 then
							useW(target)
						elseif CaitlynMenu.Harass.ModeW:Value() == 2 then
							if GotBuff(target, "veigareventhorizonstun") > 0 or GotBuff(target, "Stun") > 0 or GotBuff(target, "Taunt") > 0 or GotBuff(target, "Slow") > 0 or GotBuff(target, "Snare") > 0 or GotBuff(target, "Charm") > 0 or GotBuff(target, "Suppression") > 0 or GotBuff(target, "Flee") > 0 or GotBuff(target, "Knockup") > 0 then
								useW(target)
							end
						end
					end
				end
			end
		end
		if CaitlynMenu.Harass.UseE:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > CaitlynMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(target, CaitlynE.range+GetHitBox(myHero)) then
						useE(target)
					elseif ValidTarget(target, 400+GetRange(myHero)+GetHitBox(myHero)) then
						local EPos = Vector(myHero)+(Vector(myHero)-Vector(target))
						CastSkillShot(_E, EPos)
					end
				end
			end
		end
	end
end

-- KillSteal

function KillSteal()
	for i,enemy in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_R) == READY then
			if CaitlynMenu.KillSteal.UseR:Value() then
				if ValidTarget(enemy, CaitlynR.range) then
					local CaitlynRDmg = (225*GetCastLevel(myHero,_R)+25)+(2*GetBonusDmg(myHero))
					if (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*4) < CaitlynRDmg then
						DrawCircle(enemy,200,5,25,0xffffd700)
					end
				end
			end
		elseif CanUseSpell(myHero,_Q) == READY then
			if CaitlynMenu.KillSteal.UseQ:Value() then
				if ValidTarget(enemy, CaitlynQ.range) then
					local CaitlynQDmg = ((40*GetCastLevel(myHero,_Q)-10)+((0.1*GetCastLevel(myHero,_Q)+1.2)*(GetBonusDmg(myHero)+GetBaseDamage(myHero))))/3
					if (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*4) < CaitlynQDmg then
						useQ(enemy)
					end
				end
			end
		end
	end
end

-- LaneClear

function LaneClear()
	if Mode() == "LaneClear" then
		if CaitlynMenu.LaneClear.UseQ:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > CaitlynMenu.LaneClear.MP:Value() then
				if CanUseSpell(myHero,_Q) == READY and AA == true then
					local BestPos, BestHit = GetLineFarmPosition(CaitlynQ.range, CaitlynQ.radius, MINION_ENEMY)
					if BestPos and BestHit > 4 then
						CastSkillShot(_Q, BestPos)
					end
				end
			end
		end
	end
end

-- Anti-Gapcloser

function AntiGapcloser()
	for i,antigap in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_W) == READY then
			if CaitlynMenu.AntiGapcloser.UseW:Value() then
				if ValidTarget(antigap, CaitlynMenu.AntiGapcloser.DistanceW:Value()) then
					useW(antigap)
				end
			end
		elseif CanUseSpell(myHero,_E) == READY then
			if CaitlynMenu.AntiGapcloser.UseE:Value() then
				if ValidTarget(antigap, CaitlynMenu.AntiGapcloser.DistanceE:Value()) then
					local EPos = Vector(myHero)+(Vector(myHero)-Vector(antigap))
					CastSkillShot(_E, EPos)
				end
			end
		end
	end
end

-- Interrupter

OnProcessSpell(function(unit, spell)
	if CaitlynMenu.Interrupter.UseW:Value() then
		for _, enemy in pairs(GetEnemyHeroes()) do
			if ValidTarget(enemy, CaitlynMenu.Interrupter.Distance:Value()) then
				if CanUseSpell(myHero,_W) == READY then
					local UnitName = GetObjectName(enemy)
					local UnitChanellingSpells = CHANELLING_SPELLS[UnitName]
					local UnitGapcloserSpells = GAPCLOSER_SPELLS[UnitName]
					if UnitGapcloserSpells then
						for _, slot in pairs(UnitGapcloserSpells) do
							if spell.name == GetCastName(enemy, slot) then useW(enemy) end
						end
					end
				end
			end
		end
    end
end)

-- Corki

elseif "Corki" == GetObjectName(myHero) then

PrintChat("<font color='#1E90FF'>[<font color='#00BFFF'>GoS-U<font color='#1E90FF'>] <font color='#00BFFF'>Corki loaded successfully!")
local CorkiMenu = Menu("[GoS-U] Corki", "[GoS-U] Corki")
CorkiMenu:Menu("Auto", "Auto")
CorkiMenu.Auto:Boolean('UseQ', 'Use Q [Phosphorus Bomb]', true)
CorkiMenu.Auto:Boolean('UseR', 'Use R [Missile Barrage]', true)
CorkiMenu.Auto:Slider("MP","Mana-Manager", 40, 0, 100, 5)
CorkiMenu:Menu("Combo", "Combo")
CorkiMenu.Combo:Boolean('UseQ', 'Use Q [Phosphorus Bomb]', true)
CorkiMenu.Combo:Boolean('UseW', 'Use W [Valkyrie]', true)
CorkiMenu.Combo:Boolean('UseE', 'Use E [Gatling Gun]', true)
CorkiMenu.Combo:Boolean('UseR', 'Use R [Missile Barrage]', true)
CorkiMenu:Menu("Harass", "Harass")
CorkiMenu.Harass:Boolean('UseQ', 'Use Q [Phosphorus Bomb]', true)
CorkiMenu.Harass:Boolean('UseW', 'Use W [Valkyrie]', true)
CorkiMenu.Harass:Boolean('UseE', 'Use E [Gatling Gun]', true)
CorkiMenu.Harass:Boolean('UseR', 'Use R [Missile Barrage]', true)
CorkiMenu.Harass:Slider("MP","Mana-Manager", 40, 0, 100, 5)
CorkiMenu:Menu("KillSteal", "KillSteal")
CorkiMenu.KillSteal:Boolean('UseQ', 'Use Q [Phosphorus Bomb]', true)
CorkiMenu.KillSteal:Boolean('UseR', 'Use R [Missile Barrage]', true)
CorkiMenu:Menu("LaneClear", "LaneClear")
CorkiMenu.LaneClear:Boolean('UseQ', 'Use Q [Phosphorus Bomb]', true)
CorkiMenu.LaneClear:Boolean('UseE', 'Use E [Gatling Gun]', true)
CorkiMenu.LaneClear:Boolean('UseR', 'Use R [Missile Barrage]', true)
CorkiMenu.LaneClear:Slider("MP","Mana-Manager", 40, 0, 100, 5)
CorkiMenu:Menu("Prediction", "Prediction")
CorkiMenu.Prediction:DropDown("PredictionQ", "Prediction: Q", 5, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
CorkiMenu.Prediction:DropDown("PredictionW", "Prediction: W", 2, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
CorkiMenu.Prediction:DropDown("PredictionR", "Prediction: R", 2, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
CorkiMenu:Menu("Drawings", "Drawings")
CorkiMenu.Drawings:Boolean('DrawQ', 'Draw Q Range', true)
CorkiMenu.Drawings:Boolean('DrawW', 'Draw W Range', true)
CorkiMenu.Drawings:Boolean('DrawE', 'Draw E Range', true)
CorkiMenu.Drawings:Boolean('DrawR', 'Draw R Range', true)
CorkiMenu.Drawings:Boolean('DrawDMG', 'Draw Max QWER Damage', false)

local CorkiQ = { range = 825, radius = 250, width = 500, speed = 1000, delay = 0.25, type = "circular", collision = false, source = myHero }
local CorkiW = { range = GetCastRange(myHero,_W), radius = 100, width = 200, speed = 1500, delay = 0, type = "line", collision = false, source = myHero }
local CorkiE = { range = 600 }
local CorkiR = { range = 1225, radius = 35, width = 70, speed = 1950, delay = 0.175, type = "line", collision = true, source = myHero, col = {"minion","yasuowall"}}

OnTick(function(myHero)
	Auto()
	Combo()
	Harass()
	KillSteal()
	LaneClear()
end)
OnDraw(function(myHero)
	Ranges()
	DrawDamage()
end)

function Ranges()
local pos = GetOrigin(myHero)
if CorkiMenu.Drawings.DrawQ:Value() then DrawCircle(pos,CorkiQ.range,1,25,0xff00bfff) end
if CorkiMenu.Drawings.DrawW:Value() then DrawCircle(pos,CorkiW.range,1,25,0xff4169e1) end
if CorkiMenu.Drawings.DrawE:Value() then DrawCircle(pos,CorkiE.range,1,25,0xff1e90ff) end
if CorkiMenu.Drawings.DrawR:Value() then DrawCircle(pos,CorkiR.range,1,25,0xff0000ff) end
end

function DrawDamage()
	for _, enemy in pairs(GetEnemyHeroes()) do
		local QDmg = (45*GetCastLevel(myHero,_Q)+30)+(0.5*GetBonusDmg(myHero))+(0.5*GetBonusAP(myHero))
		local WDmg = (75*GetCastLevel(myHero,_W)+75)+GetBonusAP(myHero)
		local EDmg = (60*GetCastLevel(myHero,_E)+20)+(1.6*GetBonusDmg(myHero))
		local RDmg = (50*GetCastLevel(myHero,_R)+100)+((0.6*GetCastLevel(myHero,_R)-0.3)*(GetBaseDamage(myHero)+GetBonusDmg(myHero)))+(0.4*GetBonusAP(myHero))
		local ComboDmg = QDmg + WDmg + EDmg + RDmg
		local WERDmg = WDmg + EDmg + RDmg
		local QERDmg = QDmg + EDmg + RDmg
		local QWRDmg = QDmg + WDmg + RDmg
		local QWEDmg = QDmg + WDmg + EDmg
		local ERDmg = EDmg + RDmg
		local WRDmg = WDmg + RDmg
		local QRDmg = QDmg + RDmg
		local WEDmg = WDmg + EDmg
		local QEDmg = QDmg + EDmg
		local QWDmg = QDmg + WDmg
		if ValidTarget(enemy) then
			if CorkiMenu.Drawings.DrawDMG:Value() then
				if Ready(_Q) and Ready(_W) and Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ComboDmg), 0xff008080)
				elseif Ready(_W) and Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WERDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QERDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_W) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QWRDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_W) and Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QWEDmg), 0xff008080)
				elseif Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ERDmg), 0xff008080)
				elseif Ready(_W) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WRDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QRDmg), 0xff008080)
				elseif Ready(_W) and Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WEDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QEDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_W) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QWDmg), 0xff008080)
				elseif Ready(_Q) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QDmg), 0xff008080)
				elseif Ready(_W) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WDmg), 0xff008080)
				elseif Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, EDmg), 0xff008080)
				elseif Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, RDmg), 0xff008080)
				end
			end
		end
	end
end

function useQ(target)
	if GetDistance(target) < CorkiQ.range then
		if CorkiMenu.Prediction.PredictionQ:Value() == 1 then
			CastSkillShot(_Q,GetOrigin(target))
		elseif CorkiMenu.Prediction.PredictionQ:Value() == 2 then
			local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),CorkiQ.speed,CorkiQ.delay*1000,CorkiQ.range,CorkiQ.radius,false,true)
			if QPred.HitChance == 1 then
				CastSkillShot(_Q, QPred.PredPos)
			end
		elseif CorkiMenu.Prediction.PredictionQ:Value() == 3 then
			local qPred = _G.gPred:GetPrediction(target,myHero,CorkiQ,true,false)
			if qPred and qPred.HitChance >= 3 then
				CastSkillShot(_Q, qPred.CastPosition)
			end
		elseif CorkiMenu.Prediction.PredictionQ:Value() == 4 then
			local QSpell = IPrediction.Prediction({name="PhosphorusBomb", range=CorkiQ.range, speed=CorkiQ.speed, delay=CorkiQ.delay, width=CorkiQ.radius, type="circular", collision=false})
			ts = TargetSelector()
			target = ts:GetTarget(CorkiQ.range)
			local x, y = QSpell:Predict(target)
			if x > 2 then
				CastSkillShot(_Q, y.x, y.y, y.z)
			end
		elseif CorkiMenu.Prediction.PredictionQ:Value() == 5 then
			local QPrediction = GetCircularAOEPrediction(target,CorkiQ)
			if QPrediction.hitChance > 0.9 then
				CastSkillShot(_Q, QPrediction.castPos)
			end
		end
	end
end
function useW(target)
	if GetDistance(target) < CorkiW.range then
		if CorkiMenu.Prediction.PredictionW:Value() == 1 then
			CastSkillShot(_W,GetOrigin(target))
		elseif CorkiMenu.Prediction.PredictionW:Value() == 2 then
			local WPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),CorkiW.speed,CorkiW.delay*1000,CorkiW.range,CorkiW.width,false,true)
			if WPred.HitChance == 1 then
				CastSkillShot(_W, WPred.PredPos)
			end
		elseif CorkiMenu.Prediction.PredictionW:Value() == 3 then
			local WPred = _G.gPred:GetPrediction(target,myHero,CorkiW,true,false)
			if WPred and WPred.HitChance >= 3 then
				CastSkillShot(_W, WPred.CastPosition)
			end
		elseif CorkiMenu.Prediction.PredictionW:Value() == 4 then
			local WSpell = IPrediction.Prediction({name="CarpetBomb", range=CorkiW.range, speed=CorkiW.speed, delay=CorkiW.delay, width=CorkiW.width, type="linear", collision=false})
			ts = TargetSelector()
			target = ts:GetTarget(CorkiW.range)
			local x, y = WSpell:Predict(target)
			if x > 2 then
				CastSkillShot(_W, y.x, y.y, y.z)
			end
		elseif CorkiMenu.Prediction.PredictionW:Value() == 5 then
			local WPrediction = GetLinearAOEPrediction(target,CorkiW)
			if WPrediction.hitChance > 0.9 then
				CastSkillShot(_W, WPrediction.castPos)
			end
		end
	end
end
function useE(target)
	CastSkillShot(_E, GetOrigin(target))
end
function useR(target)
	if GetDistance(target) < CorkiR.range then
		if CorkiMenu.Prediction.PredictionR:Value() == 1 then
			CastSkillShot(_R,GetOrigin(target))
		elseif CorkiMenu.Prediction.PredictionR:Value() == 2 then
			local RPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),CorkiR.speed,CorkiR.delay*1000,CorkiR.range,CorkiR.width,true,false)
			if RPred.HitChance == 1 then
				CastSkillShot(_R, RPred.PredPos)
			end
		elseif CorkiMenu.Prediction.PredictionR:Value() == 3 then
			local RPred = _G.gPred:GetPrediction(target,myHero,CorkiR,false,true)
			if RPred and RPred.HitChance >= 3 then
				CastSkillShot(_R, RPred.CastPosition)
			end
		elseif CorkiMenu.Prediction.PredictionR:Value() == 4 then
			local RSpell = IPrediction.Prediction({name="MissileBarrageMissile", range=CorkiR.range, speed=CorkiR.speed, delay=CorkiR.delay, width=CorkiR.width, type="linear", collision=true})
			ts = TargetSelector()
			target = ts:GetTarget(CorkiR.range)
			local x, y = RSpell:Predict(target)
			if x > 2 then
				CastSkillShot(_R, y.x, y.y, y.z)
			end
		elseif CorkiMenu.Prediction.PredictionR:Value() == 5 then
			local RPrediction = GetLinearAOEPrediction(target,CorkiR)
			if RPrediction.hitChance > 0.9 then
				CastSkillShot(_R, RPrediction.castPos)
			end
		end
	end
end

-- Auto

function Auto()
	if CorkiMenu.Auto.UseQ:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > CorkiMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if ValidTarget(target, CorkiQ.range) then
					useQ(target)
				end
			end
		end
	end
	if CorkiMenu.Auto.UseR:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > CorkiMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_R) == READY then
				if ValidTarget(target, CorkiR.range) then
					useR(target)
				end
			end
		end
	end
end

-- Combo

function Combo()
	if Mode() == "Combo" then
		if CorkiMenu.Combo.UseQ:Value() then
			if CanUseSpell(myHero,_Q) == READY and AA == true then
				if ValidTarget(target, CorkiQ.range) then
					useQ(target)
				end
			end
		end
		if CorkiMenu.Combo.UseW:Value() then
			if CanUseSpell(myHero,_W) == READY then
				if ValidTarget(target, CorkiW.range) then
					useW(target)
				end
			end
		end
		if CorkiMenu.Combo.UseE:Value() then
			if CanUseSpell(myHero,_E) == READY then
				if ValidTarget(target, CorkiE.range) then
					useE(target)
				end
			end
		end
		if CorkiMenu.Combo.UseR:Value() then
			if CanUseSpell(myHero,_R) == READY and AA == true then
				if ValidTarget(target, CorkiR.range) then
					useR(target)
				end
			end
		end
	end
end

-- Harass

function Harass()
	if Mode() == "Harass" then
		if CorkiMenu.Harass.UseQ:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > CorkiMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_Q) == READY and AA == true then
					if ValidTarget(target, CorkiQ.range) then
						useQ(target)
					end
				end
			end
		end
		if CorkiMenu.Harass.UseW:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > CorkiMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_W) == READY then
					if ValidTarget(target, CorkiW.range) then
						useW(target)
					end
				end
			end
		end
		if CorkiMenu.Harass.UseE:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > CorkiMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(target, CorkiE.range) then
						useE(target)
					end
				end
			end
		end
		if CorkiMenu.Harass.UseR:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > CorkiMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_R) == READY and AA == true then
					if ValidTarget(target, CorkiR.range) then
						useR(target)
					end
				end
			end
		end
	end
end

-- KillSteal

function KillSteal()
	for i,enemy in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_Q) == READY then
			if CorkiMenu.KillSteal.UseQ:Value() then
				if ValidTarget(enemy, CorkiQ.range) then
					local CorkiQDmg = (45*GetCastLevel(myHero,_Q)+30)+(0.5*GetBonusDmg(myHero))+(0.5*GetBonusAP(myHero))
					if (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*4) < CorkiQDmg then
						useQ(enemy)
					end
				end
			end
		elseif CanUseSpell(myHero,_R) == READY then
			if CorkiMenu.KillSteal.UseR:Value() then
				if ValidTarget(enemy, CorkiR.range) then
					local CorkiRDmg = (25*GetCastLevel(myHero,_R)+50)+((0.3*GetCastLevel(myHero,_R)-0.15)*(GetBaseDamage(myHero)+GetBonusDmg(myHero)))+(0.2*GetBonusAP(myHero))
					if (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*4) < CorkiRDmg then
						useR(enemy)
					end
				end
			end
		end
	end
end

-- LaneClear

function LaneClear()
	if Mode() == "LaneClear" then
		if CorkiMenu.LaneClear.UseQ:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > CorkiMenu.LaneClear.MP:Value() then
				if CanUseSpell(myHero,_Q) == READY and AA == true then
					local BestPos, BestHit = GetFarmPosition(CorkiQ.range, CorkiQ.radius, MINION_ENEMY)
					if BestPos and BestHit > 3 then
						CastSkillShot(_Q, BestPos)
					end
				end
			end
		end
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if CorkiMenu.LaneClear.UseE:Value() then
					if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > CorkiMenu.LaneClear.MP:Value() then
						if ValidTarget(minion, CorkiE.range) then
							if CanUseSpell(myHero,_E) == READY then
								CastSkillShot(_E, GetOrigin(minion))
							end
						end
					end
				end
				if CorkiMenu.LaneClear.UseR:Value() then
					if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > CorkiMenu.LaneClear.MP:Value() then
						if ValidTarget(minion, CorkiR.range) then
							if CanUseSpell(myHero,_R) == READY then
								CastSkillShot(_R, GetOrigin(minion))
							end
						end
					end
				end
			end
		end
	end
end

-- Draven

elseif "Draven" == GetObjectName(myHero) then

PrintChat("<font color='#1E90FF'>[<font color='#00BFFF'>GoS-U<font color='#1E90FF'>] <font color='#00BFFF'>Draven loaded successfully!")
local DravenMenu = Menu("[GoS-U] Draven", "[GoS-U] Draven")
DravenMenu:Menu("Combo", "Combo")
DravenMenu.Combo:Boolean('UseQ', 'Use Q [Spinning Axe]', true)
DravenMenu.Combo:Boolean('UseW', 'Use W [Blood Rush]', true)
DravenMenu.Combo:Boolean('UseE', 'Use E [Stand Aside]', true)
DravenMenu.Combo:Boolean('UseR', 'Use R [Whirling Death]', true)
DravenMenu.Combo:Slider('Distance','Distance: R', 2000, 100, 10000, 100)
DravenMenu.Combo:Slider('X','Minimum Enemies: R', 1, 0, 5, 1)
DravenMenu.Combo:Slider('HP','HP-Manager: R', 40, 0, 100, 5)
DravenMenu:Menu("Harass", "Harass")
DravenMenu.Harass:Boolean('UseQ', 'Use Q [Spinning Axe]', true)
DravenMenu.Harass:Boolean('UseW', 'Use W [Blood Rush]', true)
DravenMenu.Harass:Boolean('UseE', 'Use E [Stand Aside]', true)
DravenMenu.Harass:Slider("MP","Mana-Manager", 40, 0, 100, 5)
DravenMenu:Menu("KillSteal", "KillSteal")
DravenMenu.KillSteal:Boolean('UseE', 'Use E [Stand Aside]', true)
DravenMenu.KillSteal:Boolean('UseR', 'Use R [Whirling Death]', true)
DravenMenu.KillSteal:Slider('Distance','Distance: R', 2000, 100, 10000, 100)
DravenMenu:Menu("LaneClear", "LaneClear")
DravenMenu.LaneClear:Boolean('UseQ', 'Use Q [Spinning Axe]', true)
DravenMenu.LaneClear:Boolean('UseE', 'Use E [Stand Aside]', true)
DravenMenu.LaneClear:Slider("MP","Mana-Manager", 40, 0, 100, 5)
DravenMenu:Menu("AntiGapcloser", "Anti-Gapcloser")
DravenMenu.AntiGapcloser:Boolean('UseE', 'Use E [Stand Aside]', true)
DravenMenu.AntiGapcloser:Slider('Distance','Distance: E', 400, 25, 500, 25)
DravenMenu:Menu("Interrupter", "Interrupter")
DravenMenu.Interrupter:Boolean('UseE', 'Use E [Stand Aside]', true)
DravenMenu.Interrupter:Slider('Distance','Distance: E', 700, 50, 1000, 50)
DravenMenu:Menu("Prediction", "Prediction")
DravenMenu.Prediction:DropDown("PredictionE", "Prediction: E", 2, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
DravenMenu.Prediction:DropDown("PredictionR", "Prediction: R", 2, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
DravenMenu:Menu("Drawings", "Drawings")
DravenMenu.Drawings:Boolean('DrawE', 'Draw E Range', true)
DravenMenu.Drawings:Boolean('DrawR', 'Draw R Range', true)
DravenMenu.Drawings:Boolean('DrawDMG', 'Draw Max QER Damage', false)

local DravenE = { range = 1050, radius = 120, width = 240, speed = 1400, delay = 0.25, type = "line", collision = false, source = myHero }
local DravenR = { range = DravenMenu.Combo.Distance:Value(), radius = 130, width = 260, speed = 2000, delay = 0.5, type = "line", collision = false, source = myHero }

OnTick(function(myHero)
	Combo()
	Harass()
	KillSteal()
	LaneClear()
	AntiGapcloser()
end)
OnDraw(function(myHero)
	Ranges()
	DrawDamage()
end)

function Ranges()
local pos = GetOrigin(myHero)
if DravenMenu.Drawings.DrawE:Value() then DrawCircle(pos,DravenE.range,1,25,0xff1e90ff) end
if DravenMenu.Drawings.DrawR:Value() then DrawCircle(pos,DravenR.range,1,25,0xff0000ff) end
end

function DrawDamage()
	local QDmg = (5*GetCastLevel(myHero,_Q)+30)+((0.1*GetCastLevel(myHero,_Q)+0.55)*GetBonusDmg(myHero))
	local EDmg = (35*GetCastLevel(myHero,_E)+40)+(0.5*GetBonusDmg(myHero))
	local RDmg = (200*GetCastLevel(myHero,_R)+150)+(2.2*GetBonusDmg(myHero))
	local ComboDmg = QDmg + EDmg + RDmg
	local QRDmg = QDmg + RDmg
	local ERDmg = EDmg + RDmg
	local QEDmg = QDmg + EDmg
	for _, enemy in pairs(GetEnemyHeroes()) do
		if ValidTarget(enemy) then
			if DravenMenu.Drawings.DrawDMG:Value() then
				if Ready(_Q) and Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ComboDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QRDmg), 0xff008080)
				elseif Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ERDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QEDmg), 0xff008080)
				elseif Ready(_Q) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QDmg), 0xff008080)
				elseif Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, EDmg), 0xff008080)
				elseif Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, RDmg), 0xff008080)
				end
			end
		end
	end
end

function useQ(target)
	CastSpell(_Q)
end
function useW(target)
	CastSpell(_W)
end
function useE(target)
	if GetDistance(target) < DravenE.range then
		if DravenMenu.Prediction.PredictionE:Value() == 1 then
			CastSkillShot(_E,GetOrigin(target))
		elseif DravenMenu.Prediction.PredictionE:Value() == 2 then
			local EPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),DravenE.speed,DravenE.delay*1000,DravenE.range,DravenE.width,true,true)
			if EPred.HitChance == 1 then
				CastSkillShot(_E, EPred.PredPos)
			end
		elseif DravenMenu.Prediction.PredictionE:Value() == 3 then
			local EPred = _G.gPred:GetPrediction(target,myHero,DravenE,true,false)
			if EPred and EPred.HitChance >= 3 then
				CastSkillShot(_E, EPred.CastPosition)
			end
		elseif DravenMenu.Prediction.PredictionE:Value() == 4 then
			local ESpell = IPrediction.Prediction({name="DravenDoubleShot", range=DravenE.range, speed=DravenE.speed, delay=DravenE.delay, width=DravenE.width, type="linear", collision=false})
			ts = TargetSelector()
			target = ts:GetTarget(DravenE.range)
			local x, y = ESpell:Predict(target)
			if x > 2 then
				CastSkillShot(_E, y.x, y.y, y.z)
			end
		elseif DravenMenu.Prediction.PredictionE:Value() == 5 then
			local EPrediction = GetLinearAOEPrediction(target,DravenE)
			if EPrediction.hitChance > 0.9 then
				CastSkillShot(_E, EPrediction.castPos)
			end
		end
	end
end
function useR(target)
	if GetDistance(target) < DravenR.range then
		if DravenMenu.Prediction.PredictionR:Value() == 1 then
			CastSkillShot(_R,GetOrigin(target))
		elseif DravenMenu.Prediction.PredictionR:Value() == 2 then
			local RPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),DravenR.speed,DravenR.delay*1000,DravenR.range,DravenR.width,true,true)
			if RPred.HitChance == 1 then
				CastSkillShot(_R, RPred.PredPos)
			end
		elseif DravenMenu.Prediction.PredictionR:Value() == 3 then
			local RPred = _G.gPred:GetPrediction(target,myHero,DravenR,true,false)
			if RPred and RPred.HitChance >= 3 then
				CastSkillShot(_R, RPred.CastPosition)
			end
		elseif DravenMenu.Prediction.PredictionR:Value() == 4 then
			local RSpell = IPrediction.Prediction({name="DravenRCast", range=DravenR.range, speed=DravenR.speed, delay=DravenR.delay, width=DravenR.width, type="linear", collision=false})
			ts = TargetSelector()
			target = ts:GetTarget(DravenR.range)
			local x, y = RSpell:Predict(target)
			if x > 2 then
				CastSkillShot(_R, y.x, y.y, y.z)
			end
		elseif DravenMenu.Prediction.PredictionR:Value() == 5 then
			local RPrediction = GetLinearAOEPrediction(target,DravenR)
			if RPrediction.hitChance > 0.9 then
				CastSkillShot(_R, RPrediction.castPos)
			end
		end
	end
end

-- Combo

function Combo()
	if Mode() == "Combo" then
		if DravenMenu.Combo.UseQ:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if ValidTarget(target, GetRange(myHero)+GetHitBox(myHero)) then
					useQ(target)
				end
			end
		end
		if DravenMenu.Combo.UseW:Value() then
			if CanUseSpell(myHero,_W) == READY then
				if ValidTarget(target, 1000) then
					useW(target)
				end
			end
		end
		if DravenMenu.Combo.UseE:Value() then
			if CanUseSpell(myHero,_E) == READY and AA == true then
				if ValidTarget(target, DravenE.range) then
					useE(target)
				end
			end
		end
		if DravenMenu.Combo.UseR:Value() then
			if CanUseSpell(myHero,_R) == READY then
				if ValidTarget(target, DravenR.range) then
					if 100*GetCurrentHP(target)/GetMaxHP(target) < DravenMenu.Combo.HP:Value() then
						if EnemiesAround(myHero, DravenR.range) >= DravenMenu.Combo.X:Value() then
							useR(target)
						end
					end
				end
			end
		end
	end
end

-- Harass

function Harass()
	if Mode() == "Harass" then
		if DravenMenu.Harass.UseQ:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > DravenMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(target, GetRange(myHero)+GetHitBox(myHero)) then
						useQ(target)
					end
				end
			end
		end
		if DravenMenu.Harass.UseW:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > DravenMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_W) == READY then
					if ValidTarget(target, 1000) then
						useW(target)
					end
				end
			end
		end
		if DravenMenu.Harass.UseE:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > DravenMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_E) == READY and AA == true then
					if ValidTarget(target, DravenE.range) then
						useE(target)
					end
				end
			end
		end
	end
end

-- KillSteal

function KillSteal()
	for i,enemy in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_E) == READY then
			if DravenMenu.KillSteal.UseE:Value() then
				if ValidTarget(enemy, DravenE.range) then
					local DravenEDmg = (35*GetCastLevel(myHero,_E)+40)+(0.5*GetBonusDmg(myHero))
					if (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*4) < DravenEDmg then
						useE(enemy)
					end
				end
			end
		elseif CanUseSpell(myHero,_R) == READY then
			if DravenMenu.KillSteal.UseR:Value() then
				if ValidTarget(enemy, DravenMenu.KillSteal.Distance:Value()) then
					local DravenRDmg = (40*GetCastLevel(myHero,_R)+30)+(0.44*GetBonusDmg(myHero))
					if (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*4) < DravenRDmg then
						useR(enemy)
					end
				end
			end
		end
	end
end

-- LaneClear

function LaneClear()
	if Mode() == "LaneClear" then
		if DravenMenu.LaneClear.UseE:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > DravenMenu.LaneClear.MP:Value() then
				if CanUseSpell(myHero,_E) == READY and AA == true then
					local BestPos, BestHit = GetLineFarmPosition(DravenE.range, DravenE.radius, MINION_ENEMY)
					if BestPos and BestHit > 5 then
						CastSkillShot(_E, BestPos)
					end
				end
			end
		end
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if DravenMenu.LaneClear.UseQ:Value() then
					if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > DravenMenu.LaneClear.MP:Value() then
						if ValidTarget(minion, GetRange(myHero)+GetHitBox(myHero)) then
							if CanUseSpell(myHero,_Q) == READY then
								CastSpell(_Q)
							end
						end
					end
				end
			end
		end
	end
end

-- Anti-Gapcloser

function AntiGapcloser()
	for i,antigap in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_E) == READY then
			if DravenMenu.AntiGapcloser.UseE:Value() then
				if ValidTarget(antigap, DravenMenu.AntiGapcloser.Distance:Value()) then
					useE(antigap)
				end
			end
		end
	end
end

-- Interrupter

OnProcessSpell(function(unit, spell)
	if DravenMenu.Interrupter.UseE:Value() then
		for _, enemy in pairs(GetEnemyHeroes()) do
			if ValidTarget(enemy, DravenMenu.Interrupter.Distance:Value()) then
				if CanUseSpell(myHero,_E) == READY then
					local UnitName = GetObjectName(enemy)
					local UnitChanellingSpells = CHANELLING_SPELLS[UnitName]
					local UnitGapcloserSpells = GAPCLOSER_SPELLS[UnitName]
					if UnitChanellingSpells then
						for _, slot in pairs(UnitChanellingSpells) do
							if spell.name == GetCastName(enemy, slot) then useE(enemy) end
						end
					elseif UnitGapcloserSpells then
						for _, slot in pairs(UnitGapcloserSpells) do
							if spell.name == GetCastName(enemy, slot) then useE(enemy) end
						end
					end
				end
			end
		end
    end
end)

-- Ezreal

elseif "Ezreal" == GetObjectName(myHero) then

PrintChat("<font color='#1E90FF'>[<font color='#00BFFF'>GoS-U<font color='#1E90FF'>] <font color='#00BFFF'>Ezreal loaded successfully!")
local EzrealMenu = Menu("[GoS-U] Ezreal", "[GoS-U] Ezreal")
EzrealMenu:Menu("Auto", "Auto")
EzrealMenu.Auto:Boolean('UseQ', 'Use Q [Mystic Shot]', true)
EzrealMenu.Auto:Boolean('UseW', 'Use W [Essence Flux]', true)
EzrealMenu.Auto:Slider("MP","Mana-Manager", 40, 0, 100, 5)
EzrealMenu:Menu("Combo", "Combo")
EzrealMenu.Combo:Boolean('UseQ', 'Use Q [Mystic Shot]', true)
EzrealMenu.Combo:Boolean('UseW', 'Use W [Essence Flux]', true)
EzrealMenu.Combo:Boolean('UseE', 'Use E [Arcane Shift]', true)
EzrealMenu.Combo:Boolean('UseR', 'Use R [Trueshot Barrage]', true)
EzrealMenu.Combo:DropDown("ModeW", "Cast Mode: W", 2, {"On Ally", "On Enemy"})
EzrealMenu.Combo:Slider('Distance','Distance: R', 2000, 100, 10000, 100)
EzrealMenu.Combo:Slider('X','Minimum Enemies: R', 1, 0, 5, 1)
EzrealMenu.Combo:Slider('HP','HP-Manager: R', 40, 0, 100, 5)
EzrealMenu:Menu("Harass", "Harass")
EzrealMenu.Harass:Boolean('UseQ', 'Use Q [Mystic Shot]', true)
EzrealMenu.Harass:Boolean('UseW', 'Use W [Essence Flux]', true)
EzrealMenu.Harass:Boolean('UseE', 'Use E [Arcane Shift]', false)
EzrealMenu.Harass:DropDown("ModeW", "Cast Mode: W", 1, {"On Ally", "On Enemy"})
EzrealMenu.Harass:Slider("MP","Mana-Manager", 40, 0, 100, 5)
EzrealMenu:Menu("KillSteal", "KillSteal")
EzrealMenu.KillSteal:Boolean('UseQ', 'Use Q [Mystic Shot]', true)
EzrealMenu.KillSteal:Boolean('UseR', 'Use R [Trueshot Barrage]', true)
EzrealMenu.KillSteal:Slider('Distance','Distance: R', 2000, 100, 10000, 100)
EzrealMenu:Menu("LastHit", "LastHit")
EzrealMenu.LastHit:Boolean('UseQ', 'Use Q [Mystic Shot]', true)
EzrealMenu.LastHit:Slider("MP","Mana-Manager", 40, 0, 100, 5)
EzrealMenu:Menu("LaneClear", "LaneClear")
EzrealMenu.LaneClear:Boolean('UseQ', 'Use Q [Mystic Shot]', false)
EzrealMenu.LaneClear:Slider("MP","Mana-Manager", 40, 0, 100, 5)
EzrealMenu:Menu("Prediction", "Prediction")
EzrealMenu.Prediction:DropDown("PredictionQ", "Prediction: Q", 2, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
EzrealMenu.Prediction:DropDown("PredictionW", "Prediction: W", 2, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
EzrealMenu.Prediction:DropDown("PredictionR", "Prediction: R", 2, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
EzrealMenu:Menu("Drawings", "Drawings")
EzrealMenu.Drawings:Boolean('DrawQ', 'Draw Q Range', true)
EzrealMenu.Drawings:Boolean('DrawW', 'Draw W Range', true)
EzrealMenu.Drawings:Boolean('DrawE', 'Draw E Range', true)
EzrealMenu.Drawings:Boolean('DrawR', 'Draw R Range', true)
EzrealMenu.Drawings:Boolean('DrawDMG', 'Draw Max QWER Damage', false)

local EzrealQ = { range = 1150, radius = 60, width = 120, speed = 2000, delay = 0.25, type = "line", collision = true, source = myHero, col = {"minion","yasuowall"}}
local EzrealW = { range = 1000, radius = 80, width = 160, speed = 1550, delay = 0.25, type = "line", collision = false, source = myHero, col = {"yasuowall"}}
local EzrealE = { range = 475 }
local EzrealR = { range = EzrealMenu.Combo.Distance:Value(), radius = 160, width = 320, speed = 2000, delay = 1, type = "line", collision = false, source = myHero, col = {"yasuowall"}}

OnTick(function(myHero)
	Auto()
	Combo()
	Harass()
	KillSteal()
	LastHit()
	LaneClear()
end)
OnDraw(function(myHero)
	Ranges()
	DrawDamage()
end)

function Ranges()
local pos = GetOrigin(myHero)
if EzrealMenu.Drawings.DrawQ:Value() then DrawCircle(pos,EzrealQ.range,1,25,0xff00bfff) end
if EzrealMenu.Drawings.DrawW:Value() then DrawCircle(pos,EzrealW.range,1,25,0xff4169e1) end
if EzrealMenu.Drawings.DrawE:Value() then DrawCircle(pos,EzrealE.range,1,25,0xff1e90ff) end
if EzrealMenu.Drawings.DrawR:Value() then DrawCircle(pos,EzrealMenu.Combo.Distance:Value(),1,25,0xff0000ff) end
end

function DrawDamage()
	for _, enemy in pairs(GetEnemyHeroes()) do
		local QDmg = (25*GetCastLevel(myHero,_Q)-10)+(1.1*(GetBaseDamage(myHero)+GetBonusDmg(myHero)))+(0.4*GetBonusAP(myHero))
		local WDmg = (45*GetCastLevel(myHero,_W)+25)+(0.8*GetBonusAP(myHero))
		local EDmg = (50*GetCastLevel(myHero,_E)+30)+(0.5*GetBonusDmg(myHero))+(0.75*GetBonusAP(myHero))
		local RDmg = (150*GetCastLevel(myHero,_R)+200)+GetBonusDmg(myHero)+(0.9*GetBonusAP(myHero))
		local ComboDmg = QDmg + WDmg + EDmg + RDmg
		local WERDmg = WDmg + EDmg + RDmg
		local QERDmg = QDmg + EDmg + RDmg
		local QWRDmg = QDmg + WDmg + RDmg
		local QWEDmg = QDmg + WDmg + EDmg
		local ERDmg = EDmg + RDmg
		local WRDmg = WDmg + RDmg
		local QRDmg = QDmg + RDmg
		local WEDmg = WDmg + EDmg
		local QEDmg = QDmg + EDmg
		local QWDmg = QDmg + WDmg
		if ValidTarget(enemy) then
			if EzrealMenu.Drawings.DrawDMG:Value() then
				if Ready(_Q) and Ready(_W) and Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ComboDmg), 0xff008080)
				elseif Ready(_W) and Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WERDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QERDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_W) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QWRDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_W) and Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QWEDmg), 0xff008080)
				elseif Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ERDmg), 0xff008080)
				elseif Ready(_W) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WRDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QRDmg), 0xff008080)
				elseif Ready(_W) and Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WEDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QEDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_W) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QWDmg), 0xff008080)
				elseif Ready(_Q) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QDmg), 0xff008080)
				elseif Ready(_W) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WDmg), 0xff008080)
				elseif Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, EDmg), 0xff008080)
				elseif Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, RDmg), 0xff008080)
				end
			end
		end
	end
end

function useQ(target)
	if GetDistance(target) < EzrealQ.range then
		if EzrealMenu.Prediction.PredictionQ:Value() == 1 then
			CastSkillShot(_Q,GetOrigin(target))
		elseif EzrealMenu.Prediction.PredictionQ:Value() == 2 then
			local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),EzrealQ.speed,EzrealQ.delay*1000,EzrealQ.range,EzrealQ.width,true,false)
			if QPred.HitChance == 1 then
				CastSkillShot(_Q, QPred.PredPos)
			end
		elseif EzrealMenu.Prediction.PredictionQ:Value() == 3 then
			local qPred = _G.gPred:GetPrediction(target,myHero,EzrealQ,false,true)
			if qPred and qPred.HitChance >= 3 then
				CastSkillShot(_Q, qPred.CastPosition)
			end
		elseif EzrealMenu.Prediction.PredictionQ:Value() == 4 then
			local QSpell = IPrediction.Prediction({name="EzrealMysticShot", range=EzrealQ.range, speed=EzrealQ.speed, delay=EzrealQ.delay, width=EzrealQ.width, type="linear", collision=true})
			ts = TargetSelector()
			target = ts:GetTarget(EzrealQ.range)
			local x, y = QSpell:Predict(target)
			if x > 2 then
				CastSkillShot(_Q, y.x, y.y, y.z)
			end
		elseif EzrealMenu.Prediction.PredictionQ:Value() == 5 then
			local QPrediction = GetLinearAOEPrediction(target,EzrealQ)
			if QPrediction.hitChance > 0.9 then
				CastSkillShot(_Q, QPrediction.castPos)
			end
		end
	end
end
function useW(target)
	if GetDistance(target) < EzrealW.range then
		if EzrealMenu.Prediction.PredictionW:Value() == 1 then
			CastSkillShot(_W,GetOrigin(target))
		elseif EzrealMenu.Prediction.PredictionW:Value() == 2 then
			local WPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),EzrealW.speed,EzrealW.delay*1000,EzrealW.range,EzrealW.width,false,true)
			if WPred.HitChance == 1 then
				CastSkillShot(_W, WPred.PredPos)
			end
		elseif EzrealMenu.Prediction.PredictionW:Value() == 3 then
			local WPred = _G.gPred:GetPrediction(target,myHero,EzrealW,false,true)
			if WPred and WPred.HitChance >= 3 then
				CastSkillShot(_W, WPred.CastPosition)
			end
		elseif EzrealMenu.Prediction.PredictionW:Value() == 4 then
			local WSpell = IPrediction.Prediction({name="EzrealEssenceFlux", range=EzrealW.range, speed=EzrealW.speed, delay=EzrealW.delay, width=EzrealW.width, type="linear", collision=false})
			ts = TargetSelector()
			target = ts:GetTarget(EzrealW.range)
			local x, y = WSpell:Predict(target)
			if x > 2 then
				CastSkillShot(_W, y.x, y.y, y.z)
			end
		elseif EzrealMenu.Prediction.PredictionW:Value() == 5 then
			local WPrediction = GetLinearAOEPrediction(target,EzrealW)
			if WPrediction.hitChance > 0.9 then
				CastSkillShot(_W, WPrediction.castPos)
			end
		end
	end
end
function useR(target)
	if GetDistance(target) < EzrealR.range then
		if EzrealMenu.Prediction.PredictionR:Value() == 1 then
			CastSkillShot(_R,GetOrigin(target))
		elseif EzrealMenu.Prediction.PredictionR:Value() == 2 then
			local RPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),EzrealR.speed,EzrealR.delay*1000,EzrealR.range,EzrealR.width,false,true)
			if RPred.HitChance == 1 then
				CastSkillShot(_R, RPred.PredPos)
			end
		elseif EzrealMenu.Prediction.PredictionR:Value() == 3 then
			local RPred = _G.gPred:GetPrediction(target,myHero,EzrealR,false,true)
			if RPred and RPred.HitChance >= 3 then
				CastSkillShot(_R, RPred.CastPosition)
			end
		elseif EzrealMenu.Prediction.PredictionR:Value() == 4 then
			local RSpell = IPrediction.Prediction({name="EzrealTrueshotBarrage", range=EzrealR.range, speed=EzrealR.speed, delay=EzrealR.delay, width=EzrealR.width, type="linear", collision=false})
			ts = TargetSelector()
			target = ts:GetTarget(EzrealR.range)
			local x, y = RSpell:Predict(target)
			if x > 2 then
				CastSkillShot(_R, y.x, y.y, y.z)
			end
		elseif EzrealMenu.Prediction.PredictionR:Value() == 5 then
			local RPrediction = GetLinearAOEPrediction(target,EzrealR)
			if RPrediction.hitChance > 0.9 then
				CastSkillShot(_R, RPrediction.castPos)
			end
		end
	end
end

-- Auto

function Auto()
	if EzrealMenu.Auto.UseQ:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > EzrealMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if ValidTarget(target, EzrealQ.range) then
					useQ(target)
				end
			end
		end
	end
	if EzrealMenu.Auto.UseW:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > EzrealMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_W) == READY then
				if ValidTarget(target, EzrealW.range) then
					useW(target)
				end
			end
		end
	end
end

-- Combo

function Combo()
	if Mode() == "Combo" then
		if EzrealMenu.Combo.UseQ:Value() then
			if CanUseSpell(myHero,_Q) == READY and AA == true then
				if ValidTarget(target, EzrealQ.range) then
					useQ(target)
				end
			end
		end
		if EzrealMenu.Combo.UseW:Value() then
			if CanUseSpell(myHero,_W) == READY and AA == true then
				if EzrealMenu.Combo.ModeW:Value() == 1 then
					for _, ally in pairs(GoS:GetAllyHeroes()) do
						if ValidTarget(ally, EzrealW.range) and GetDistance(ally, target) >= EzrealW.range+GetRange(myHero) then
							useW(ally)
						elseif ValidTarget(target, EzrealW.range) then
							useW(target)
						end
					end
				elseif EzrealMenu.Combo.ModeW:Value() == 2 then
					if ValidTarget(target, EzrealW.range) then
						useW(target)
					end
				end
			end
		end
		if EzrealMenu.Combo.UseE:Value() then
			if CanUseSpell(myHero,_E) == READY then
				if ValidTarget(target, EzrealE.range+GetRange(myHero)) then
					CastSkillShot(_E, GetMousePos())
				end
			end
		end
		if EzrealMenu.Combo.UseR:Value() then
			if CanUseSpell(myHero,_R) == READY then
				if ValidTarget(target, EzrealR.range) then
					if 100*GetCurrentHP(target)/GetMaxHP(target) < EzrealMenu.Combo.HP:Value() then
						if EnemiesAround(myHero, EzrealR.range+GetRange(myHero)) >= EzrealMenu.Combo.X:Value() then
							useR(target)
						end
					end
				end
			end
		end
	end
end

-- Harass

function Harass()
	if Mode() == "Harass" then
		if EzrealMenu.Harass.UseQ:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > EzrealMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_Q) == READY and AA == true then
					if ValidTarget(target, EzrealQ.range) then
						useQ(target)
					end
				end
			end
		end
		if EzrealMenu.Harass.UseW:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > EzrealMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_W) == READY and AA == true then
					if EzrealMenu.Harass.ModeW:Value() == 1 then
						for _, ally in pairs(GoS:GetAllyHeroes()) do
							if ValidTarget(ally, EzrealW.range) and GetDistance(ally, target) >= EzrealW.range+GetRange(myHero) then
								useW(ally)
							elseif ValidTarget(target, EzrealW.range) then
								useW(target)
							end
						end
					elseif EzrealMenu.Harass.ModeW:Value() == 2 then
						if ValidTarget(target, EzrealW.range) then
							useW(target)
						end
					end
				end
			end
		end
		if EzrealMenu.Harass.UseE:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > EzrealMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(target, EzrealE.range+GetRange(myHero)) then
						CastSkillShot(_E, GetMousePos())
					end
				end
			end
		end
	end
end

-- KillSteal

function KillSteal()
	for i,enemy in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_Q) == READY then
			if EzrealMenu.KillSteal.UseQ:Value() then
				if ValidTarget(enemy, EzrealQ.range) then
					local EzrealQDmg = (25*GetCastLevel(myHero,_Q)-10)+(1.1*(GetBaseDamage(myHero)+GetBonusDmg(myHero)))+(0.4*GetBonusAP(myHero))
					if (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*4) < EzrealQDmg then
						useQ(enemy)
					end
				end
			end
		elseif CanUseSpell(myHero,_R) == READY then
			if EzrealMenu.KillSteal.UseR:Value() then
				if ValidTarget(enemy, EzrealMenu.KillSteal.Distance:Value()) then
					local EzrealRDmg = (45*GetCastLevel(myHero,_R)+60)+(0.3*GetBonusDmg(myHero))+(0.27*GetBonusAP(myHero))
					if (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*4) < EzrealRDmg then
						useR(enemy)
					end
				end
			end
		end
	end
end

-- LastHit

function LastHit()
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if ValidTarget(minion, EzrealQ.range) then
					if EzrealMenu.LastHit.UseQ:Value() then
						if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > EzrealMenu.LastHit.MP:Value() then
							if CanUseSpell(myHero,_Q) == READY then
								local EzrealQDmg = (25*GetCastLevel(myHero,_Q)-10)+(1.1*(GetBaseDamage(myHero)+GetBonusDmg(myHero)))+(0.4*GetBonusAP(myHero))
								if GetCurrentHP(minion) < EzrealQDmg then
									local QPredMin = GetLinearAOEPrediction(minion,EzrealQ)
									if QPredMin.hitChance > 0.9 then
										CastSkillShot(_Q, QPredMin.castPos)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

-- LaneClear

function LaneClear()
	if Mode() == "LaneClear" then
		if EzrealMenu.LaneClear.UseQ:Value() then
			for _, minion in pairs(minionManager.objects) do
				if GetTeam(minion) == MINION_ENEMY then
					if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > EzrealMenu.LaneClear.MP:Value() then
						if ValidTarget(minion, EzrealQ.range) then
							if CanUseSpell(myHero,_Q) == READY and AA == true then
								CastSkillShot(_Q, GetOrigin(minion))
							end
						end
					end
				end
			end
		end
	end
end

-- Jhin

elseif "Jhin" == GetObjectName(myHero) then

PrintChat("<font color='#1E90FF'>[<font color='#00BFFF'>GoS-U<font color='#1E90FF'>] <font color='#00BFFF'>Jhin loaded successfully!")
local JhinMenu = Menu("[GoS-U] Jhin", "[GoS-U] Jhin")
JhinMenu:Menu("Auto", "Auto")
JhinMenu.Auto:Boolean('UseQ', 'Use Q [Dancing Grenade]', true)
JhinMenu.Auto:DropDown("ModeQ", "Cast Mode: Q", 2, {"Standard", "Bounce"})
JhinMenu.Auto:Slider("MP","Mana-Manager", 40, 0, 100, 5)
JhinMenu:Menu("Combo", "Combo")
JhinMenu.Combo:Boolean('UseQ', 'Use Q [Dancing Grenade]', true)
JhinMenu.Combo:Boolean('UseW', 'Use W [Deadly Flourish]', true)
JhinMenu.Combo:Boolean('UseE', 'Use E [Captive Audience]', true)
JhinMenu.Combo:DropDown("ModeQ", "Cast Mode: Q", 1, {"Standard", "Bounce"})
JhinMenu:Menu("Harass", "Harass")
JhinMenu.Harass:Boolean('UseQ', 'Use Q [Dancing Grenade]', true)
JhinMenu.Harass:Boolean('UseW', 'Use W [Deadly Flourish]', true)
JhinMenu.Harass:Boolean('UseE', 'Use E [Captive Audience]', true)
JhinMenu.Harass:DropDown("ModeQ", "Cast Mode: Q", 2, {"Standard", "Bounce"})
JhinMenu.Harass:Slider("MP","Mana-Manager", 40, 0, 100, 5)
JhinMenu:Menu("KillSteal", "KillSteal")
JhinMenu.KillSteal:Boolean('UseW', 'Use W [Deadly Flourish]', true)
JhinMenu.KillSteal:Key("UseR", "Use R [Curtain Call]", string.byte("A"))
JhinMenu.KillSteal:Boolean('UseRD', 'Draw Killable With R', true)
JhinMenu:Menu("LaneClear", "LaneClear")
JhinMenu.LaneClear:Boolean('UseQ', 'Use Q [Dancing Grenade]', true)
JhinMenu.LaneClear:Slider("MP","Mana-Manager", 40, 0, 100, 5)
JhinMenu:Menu("AntiGapcloser", "Anti-Gapcloser")
JhinMenu.AntiGapcloser:Boolean('UseW', 'Use W [Deadly Flourish]', true)
JhinMenu.AntiGapcloser:Slider('Distance','Distance: W', 400, 25, 500, 25)
JhinMenu:Menu("Interrupter", "Interrupter")
JhinMenu.Interrupter:Boolean('UseW', 'Use W [Deadly Flourish]', true)
JhinMenu.Interrupter:Slider('Distance','Distance: W', 400, 50, 1000, 50)
JhinMenu:Menu("Prediction", "Prediction")
JhinMenu.Prediction:DropDown("PredictionW", "Prediction: W", 2, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
JhinMenu.Prediction:DropDown("PredictionE", "Prediction: E", 5, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
JhinMenu.Prediction:DropDown("PredictionR", "Prediction: R", 2, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
JhinMenu:Menu("Drawings", "Drawings")
JhinMenu.Drawings:Boolean('DrawQ', 'Draw Q Range', true)
JhinMenu.Drawings:Boolean('DrawW', 'Draw W Range', true)
JhinMenu.Drawings:Boolean('DrawE', 'Draw E Range', true)
JhinMenu.Drawings:Boolean('DrawR', 'Draw R Range', true)
JhinMenu.Drawings:Boolean('DrawDMG', 'Draw Max QWE Damage', false)

local JhinQ = { range = 550 }
local JhinW = { range = 3000, radius = 40, width = 80, speed = 5000, delay = 0.75, type = "line", collision = false, source = myHero, col = {"yasuowall"}}
local JhinE = { range = 750, radius = 140, width = 280, speed = 1650, delay = 0.25, type = "circular", collision = false, source = myHero }
local JhinR = { range = 3500, radius = 80, width = 160, speed = 5000, delay = 0.25, type = "line", collision = false, source = myHero, col = {"yasuowall"}}

OnTick(function(myHero)
	Auto()
	Combo()
	Harass()
	KillSteal()
	KillSteal2()
	LaneClear()
	AntiGapcloser()
end)
OnDraw(function(myHero)
	Ranges()
	DrawDamage()
end)

function Ranges()
local pos = GetOrigin(myHero)
if JhinMenu.Drawings.DrawQ:Value() then DrawCircle(pos,JhinQ.range,1,25,0xff00bfff) end
if JhinMenu.Drawings.DrawW:Value() then DrawCircle(pos,JhinW.range,1,25,0xff4169e1) end
if JhinMenu.Drawings.DrawE:Value() then DrawCircle(pos,JhinE.range,1,25,0xff1e90ff) end
if JhinMenu.Drawings.DrawR:Value() then DrawCircle(pos,JhinR.range,1,25,0xff0000ff) end
end

function DrawDamage()
	for _, enemy in pairs(GetEnemyHeroes()) do
		local QDmg = (25*GetCastLevel(myHero,_Q)+20)+((0.075*GetCastLevel(myHero,_Q)+0.325)*(GetBonusDmg(myHero)+GetBaseDamage(myHero)))+(0.6*GetBonusAP(myHero))
		local WDmg = (35*GetCastLevel(myHero,_W)+15)+(0.5*(GetBonusDmg(myHero)+GetBaseDamage(myHero)))
		local EDmg = (60*GetCastLevel(myHero,_E)-40)+(1.2*(GetBonusDmg(myHero)+GetBaseDamage(myHero)))+GetBonusAP(myHero)
		local ComboDmg = QDmg + WDmg + EDmg
		local WEDmg = WDmg + EDmg
		local QEDmg = QDmg + EDmg
		local QWDmg = QDmg + WDmg
		if ValidTarget(enemy) then
			if JhinMenu.Drawings.DrawDMG:Value() then
				if Ready(_Q) and Ready(_W) and Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ComboDmg), 0xff008080)
				elseif Ready(_W) and Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WEDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QEDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_W) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QWDmg), 0xff008080)
				elseif Ready(_Q) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QDmg), 0xff008080)
				elseif Ready(_W) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WDmg), 0xff008080)
				elseif Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, EDmg), 0xff008080)
				end
			end
		end
	end
end

function useQ(target)
	CastTargetSpell(target, _Q)
end
function useW(target)
	if GetDistance(target) < JhinW.range then
		if JhinMenu.Prediction.PredictionW:Value() == 1 then
			CastSkillShot(_W,GetOrigin(target))
		elseif JhinMenu.Prediction.PredictionW:Value() == 2 then
			local WPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),JhinW.speed,JhinW.delay*1000,JhinW.range,JhinW.width,false,true)
			if WPred.HitChance == 1 then
				CastSkillShot(_W, WPred.PredPos)
			end
		elseif JhinMenu.Prediction.PredictionW:Value() == 3 then
			local WPred = _G.gPred:GetPrediction(target,myHero,JhinW,false,true)
			if WPred and WPred.HitChance >= 3 then
				CastSkillShot(_W, WPred.CastPosition)
			end
		elseif JhinMenu.Prediction.PredictionW:Value() == 4 then
			local WSpell = IPrediction.Prediction({name="JhinW", range=JhinW.range, speed=JhinW.speed, delay=JhinW.delay, width=JhinW.width, type="linear", collision=false})
			ts = TargetSelector()
			target = ts:GetTarget(JhinW.range)
			local x, y = WSpell:Predict(target)
			if x > 2 then
				CastSkillShot(_W, y.x, y.y, y.z)
			end
		elseif JhinMenu.Prediction.PredictionW:Value() == 5 then
			local WPrediction = GetLinearAOEPrediction(target,JhinW)
			if WPrediction.hitChance > 0.9 then
				CastSkillShot(_W, WPrediction.castPos)
			end
		end
	end
end
function useE(target)
	if GetDistance(target) < JhinE.range then
		if JhinMenu.Prediction.PredictionE:Value() == 1 then
			CastSkillShot(_E,GetOrigin(target))
		elseif JhinMenu.Prediction.PredictionE:Value() == 2 then
			local EPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),JhinE.speed,JhinE.delay*1000,JhinE.range,JhinE.width,false,true)
			if EPred.HitChance == 1 then
				CastSkillShot(_E, EPred.PredPos)
			end
		elseif JhinMenu.Prediction.PredictionE:Value() == 3 then
			local EPred = _G.gPred:GetPrediction(target,myHero,JhinE,true,false)
			if EPred and EPred.HitChance >= 3 then
				CastSkillShot(_W, WPred.CastPosition)
			end
		elseif JhinMenu.Prediction.PredictionE:Value() == 4 then
			local WSpell = IPrediction.Prediction({name="JhinE", range=JhinE.range, speed=JhinE.speed, delay=JhinE.delay, width=JhinE.width, type="circular", collision=false})
			ts = TargetSelector()
			target = ts:GetTarget(JhinE.range)
			local x, y = ESpell:Predict(target)
			if x > 2 then
				CastSkillShot(_E, y.x, y.y, y.z)
			end
		elseif JhinMenu.Prediction.PredictionE:Value() == 5 then
			local EPrediction = GetCircularAOEPrediction(target,JhinE)
			if EPrediction.hitChance > 0.9 then
				CastSkillShot(_E, EPrediction.castPos)
			end
		end
	end
end

-- Auto

function Auto()
	if JhinMenu.Auto.UseQ:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > JhinMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if ValidTarget(target, JhinQ.range) then
					if JhinMenu.Auto.ModeQ:Value() == 1 then
						useQ(target)
					elseif JhinMenu.Auto.ModeQ:Value() == 2 then
						for _, minion in pairs(minionManager.objects) do
							if GetTeam(minion) == MINION_ENEMY then
								if EnemiesAround(minion, 400) >= 1 then
									useQ(minion)
								end
							end
						end
					end
				end
			end
		end
	end
end

-- Combo

function Combo()
	if Mode() == "Combo" then
		if JhinMenu.Combo.UseQ:Value() then
			if CanUseSpell(myHero,_Q) == READY and AA == true then
				if ValidTarget(target, JhinQ.range) then
					if JhinMenu.Combo.ModeQ:Value() == 1 then
						useQ(target)
					elseif JhinMenu.Combo.ModeQ:Value() == 2 then
						for _, minion in pairs(minionManager.objects) do
							if GetTeam(minion) == MINION_ENEMY then
								if EnemiesAround(minion, 400) >= 1 then
									useQ(minion)
								end
							end
						end
					end
				end
			end
		end
		if JhinMenu.Combo.UseW:Value() then
			if CanUseSpell(myHero,_W) == READY and AA == true then
				if ValidTarget(target, JhinW.range) then
					useW(target)
				end
			end
		end
		if JhinMenu.Combo.UseE:Value() then
			if CanUseSpell(myHero,_E) == READY then
				if ValidTarget(target, JhinE.range) then
					useE(target)
				end
			end
		end
	end
end

-- Harass

function Harass()
	if Mode() == "Harass" then
		if JhinMenu.Harass.UseQ:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > JhinMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_Q) == READY and AA == true then
					if ValidTarget(target, JhinQ.range) then
						if JhinMenu.Harass.ModeQ:Value() == 1 then
							useQ(target)
						elseif JhinMenu.Harass.ModeQ:Value() == 2 then
							for _, minion in pairs(minionManager.objects) do
								if GetTeam(minion) == MINION_ENEMY then
									if EnemiesAround(minion, 400) >= 1 then
										useQ(minion)
									end
								end
							end
						end
					end
				end
			end
		end
		if JhinMenu.Harass.UseW:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > JhinMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_W) == READY and AA == true then
					if ValidTarget(target, JhinW.range) then
						useW(target)
					end
				end
			end
		end
		if JhinMenu.Harass.UseE:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > JhinMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(target, JhinE.range) then
						useE(target)
					end
				end
			end
		end
	end
end

-- KillSteal

function KillSteal()
	for i,enemy in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_W) == READY then
			if JhinMenu.KillSteal.UseW:Value() then
				if ValidTarget(enemy, JhinW.range) then
					local JhinWDmg = (35*GetCastLevel(myHero,_W)+15)+(0.5*(GetBonusDmg(myHero)+GetBaseDamage(myHero)))
					if (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*4) < JhinWDmg then
						useW(enemy)
					end
				end
			end
		end
	end
end
function KillSteal2()
	if CanUseSpell(myHero,_R) == READY then
		if JhinMenu.KillSteal.UseR:Value() then
			local EnemyToHit = ClosestEnemy(GetMousePos())
			if JhinMenu.Prediction.PredictionR:Value() == 1 then
				CastSkillShot(_R,GetOrigin(EnemyToHit))
			elseif JhinMenu.Prediction.PredictionR:Value() == 2 then
				local RPred = GetPredictionForPlayer(GetOrigin(myHero),EnemyToHit,GetMoveSpeed(target),JhinR.speed,JhinR.delay*1000,JhinR.range,JhinR.width,false,true)
				if RPred.HitChance == 1 then
					CastSkillShot(_R, RPred.PredPos)
				end
			elseif JhinMenu.Prediction.PredictionR:Value() == 3 then
				local RPred = _G.gPred:GetPrediction(EnemyToHit,myHero,JhinR,false,false)
				if RPred and RPred.HitChance >= 3 then
					CastSkillShot(_R, RPred.CastPosition)
				end
			elseif JhinMenu.Prediction.PredictionR:Value() == 4 then
				local RSpell = IPrediction.Prediction({name="JhinRCast", range=JhinR.range, speed=JhinR.speed, delay=JhinR.delay, width=JhinR.width, type="linear", collision=false})
				local x, y = RSpell:Predict(EnemyToHit)
				if x > 2 then
					CastSkillShot(_R, y.x, y.y, y.z)
				end
			elseif JhinMenu.Prediction.PredictionR:Value() == 5 then
				local RPrediction = GetCircularAOEPrediction(EnemyToHit,JhinR)
				if RPrediction.hitChance > 0.9 then
					CastSkillShot(_R, RPrediction.castPos)
				end
			end
		end
		for _, enemy in pairs(GetEnemyHeroes()) do
			local JhinRDmg = ((75*GetCastLevel(myHero,_R)-25)+0.2*(GetBonusDmg(myHero)+GetBaseDamage(myHero))*(1+(100-GetPercentHP(enemy))*1.025))*4
			if ValidTarget(enemy) then
				if (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*4) < JhinRDmg then
					if JhinMenu.KillSteal.UseRD:Value() then
						DrawCircle(enemy,100,5,25,0xffffd700)
					end
				end
			end
		end
	end
end

-- LaneClear

function LaneClear()
	if Mode() == "LaneClear" then
		if JhinMenu.LaneClear.UseQ:Value() then
			for _, minion in pairs(minionManager.objects) do
				if GetTeam(minion) == MINION_ENEMY then
					if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > JhinMenu.LaneClear.MP:Value() then
						if ValidTarget(minion, JhinQ.range) then
							if CanUseSpell(myHero,_Q) == READY then
								CastTargetSpell(minion, _Q)
							end
						end
					end
				end
			end
		end
	end
end

-- Anti-Gapcloser

function AntiGapcloser()
	for i,antigap in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_W) == READY then
			if JhinMenu.AntiGapcloser.UseW:Value() then
				if ValidTarget(antigap, JhinMenu.AntiGapcloser.Distance:Value()) then
					useW(antigap)
				end
			end
		end
	end
end

-- Interrupter

OnProcessSpell(function(unit, spell)
	if JhinMenu.Interrupter.UseW:Value() then
		for _, enemy in pairs(GetEnemyHeroes()) do
			if ValidTarget(enemy, JhinMenu.Interrupter.Distance:Value()) then
				if CanUseSpell(myHero,_W) == READY then
					local UnitName = GetObjectName(enemy)
					local UnitChanellingSpells = CHANELLING_SPELLS[UnitName]
					local UnitGapcloserSpells = GAPCLOSER_SPELLS[UnitName]
					if UnitGapcloserSpells then
						for _, slot in pairs(UnitGapcloserSpells) do
							if spell.name == GetCastName(enemy, slot) then useW(enemy) end
						end
					end
				end
			end
		end
    end
end)

-- Jinx

elseif "Jinx" == GetObjectName(myHero) then

PrintChat("<font color='#1E90FF'>[<font color='#00BFFF'>GoS-U<font color='#1E90FF'>] <font color='#00BFFF'>Jinx loaded successfully!")
local JinxMenu = Menu("[GoS-U] Jinx", "[GoS-U] Jinx")
JinxMenu:Menu("Auto", "Auto")
JinxMenu.Auto:Boolean('UseW', 'Use W [Zap!]', true)
JinxMenu.Auto:Slider("MP","Mana-Manager", 40, 0, 100, 5)
JinxMenu:Menu("Combo", "Combo")
JinxMenu.Combo:Boolean('UseQ', 'Use Q [Switcheroo!]', true)
JinxMenu.Combo:Boolean('UseW', 'Use W [Zap!]', true)
JinxMenu.Combo:Boolean('UseE', 'Use E [Flame Chompers!]', true)
JinxMenu.Combo:Boolean('UseR', 'Use R [Death Rocket!]', true)
JinxMenu.Combo:Slider('Distance','Distance: R', 4000, 100, 10000, 100)
JinxMenu.Combo:Slider('X','Minimum Enemies: R', 1, 0, 5, 1)
JinxMenu.Combo:Slider('HP','HP-Manager: R', 40, 0, 100, 5)
JinxMenu:Menu("Harass", "Harass")
JinxMenu.Harass:Boolean('UseQ', 'Use Q [Switcheroo!]', true)
JinxMenu.Harass:Boolean('UseW', 'Use W [Zap!]', true)
JinxMenu.Harass:Boolean('UseE', 'Use E [Flame Chompers!]', true)
JinxMenu.Harass:Slider("MP","Mana-Manager", 40, 0, 100, 5)
JinxMenu:Menu("KillSteal", "KillSteal")
JinxMenu.KillSteal:Boolean('UseW', 'Use W [Zap!]', true)
JinxMenu.KillSteal:Boolean('UseR', 'Use R [Death Rocket!]', true)
JinxMenu.KillSteal:Slider('Distance','Distance: R', 4000, 100, 10000, 100)
JinxMenu:Menu("LaneClear", "LaneClear")
JinxMenu.LaneClear:Boolean('UseQ', 'Use Q [Switcheroo!]', true)
JinxMenu.LaneClear:Boolean('UseE', 'Use E [Flame Chompers!]', true)
JinxMenu.LaneClear:Slider("MP","Mana-Manager", 40, 0, 100, 5)
JinxMenu:Menu("AntiGapcloser", "Anti-Gapcloser")
JinxMenu.AntiGapcloser:Boolean('UseW', 'Use W [Zap!]', true)
JinxMenu.AntiGapcloser:Boolean('UseE', 'Use E [Flame Chompers!]', true)
JinxMenu.AntiGapcloser:Slider('DistanceW','Distance: W', 400, 25, 500, 25)
JinxMenu.AntiGapcloser:Slider('DistanceE','Distance: E', 300, 25, 500, 25)
JinxMenu:Menu("Interrupter", "Interrupter")
JinxMenu.Interrupter:Boolean('UseE', 'Use E [Flame Chompers!]', true)
JinxMenu.Interrupter:Slider('Distance','Distance: E', 400, 50, 1000, 50)
JinxMenu:Menu("Prediction", "Prediction")
JinxMenu.Prediction:DropDown("PredictionW", "Prediction: W", 2, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
JinxMenu.Prediction:DropDown("PredictionE", "Prediction: E", 5, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
JinxMenu.Prediction:DropDown("PredictionR", "Prediction: R", 2, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
JinxMenu:Menu("Drawings", "Drawings")
JinxMenu.Drawings:Boolean('DrawW', 'Draw W Range', true)
JinxMenu.Drawings:Boolean('DrawE', 'Draw E Range', true)
JinxMenu.Drawings:Boolean('DrawR', 'Draw R Range', true)
JinxMenu.Drawings:Boolean('DrawDMG', 'Draw Max WER Damage', false)

local JinxW = { range = 1450, radius = 45, width = 90, speed = 3200, delay = 0.6, type = "line", collision = true, source = myHero, col = {"minion","yasuowall"}}
local JinxE = { range = 900, radius = 100, width = 200, speed = 2570, delay = 0.75, type = "circular", collision = false, source = myHero }
local JinxR = { range = JinxMenu.Combo.Distance:Value(), radius = 110, width = 220, speed = 1700, delay = 0.6, type = "line", collision = false, source = myHero }

OnTick(function(myHero)
	Auto()
	Combo()
	Harass()
	KillSteal()
	LaneClear()
	AntiGapcloser()
end)
OnDraw(function(myHero)
	Ranges()
	DrawDamage()
end)

function Ranges()
local pos = GetOrigin(myHero)
if JinxMenu.Drawings.DrawW:Value() then DrawCircle(pos,JinxW.range,1,25,0xff4169e1) end
if JinxMenu.Drawings.DrawE:Value() then DrawCircle(pos,JinxE.range,1,25,0xff1e90ff) end
if JinxMenu.Drawings.DrawR:Value() then DrawCircle(pos,JinxR.range,1,25,0xff0000ff) end
end

function DrawDamage()
	for _, enemy in pairs(GetEnemyHeroes()) do
		local WDmg = (50*GetCastLevel(myHero,_Q)-40)+(1.6*(GetBaseDamage(myHero)+GetBonusDmg(myHero)))
		local EDmg = (50*GetCastLevel(myHero,_W)+20)+GetBonusAP(myHero)
		local RDmg = (100*GetCastLevel(myHero,_R)+150)+(1.5*GetBonusDmg(myHero))+((0.05*GetCastLevel(myHero,_R)+0.2)*(GetMaxHP(enemy)-GetCurrentHP(enemy)))
		local ComboDmg = WDmg + EDmg + RDmg
		local ERDmg = EDmg + RDmg
		local WRDmg = WDmg + RDmg
		local WEDmg = WDmg + EDmg
		if ValidTarget(enemy) then
			if JinxMenu.Drawings.DrawDMG:Value() then
				if Ready(_W) and Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ComboDmg), 0xff008080)
				elseif Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ERDmg), 0xff008080)
				elseif Ready(_W) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WRDmg), 0xff008080)
				elseif Ready(_W) and Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WEDmg), 0xff008080)
				elseif Ready(_W) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WDmg), 0xff008080)
				elseif Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, EDmg), 0xff008080)
				elseif Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, RDmg), 0xff008080)
				end
			end
		end
	end
end

function useQ(target)
	CastSpell(_Q)
end
function useW(target)
	if GetDistance(target) < JinxW.range then
		if JinxMenu.Prediction.PredictionW:Value() == 1 then
			CastSkillShot(_W,GetOrigin(target))
		elseif JinxMenu.Prediction.PredictionW:Value() == 2 then
			local WPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),JinxW.speed,JinxW.delay*1000,JinxW.range,JinxW.width,true,false)
			if WPred.HitChance == 1 then
				CastSkillShot(_W, WPred.PredPos)
			end
		elseif JinxMenu.Prediction.PredictionW:Value() == 3 then
			local WPred = _G.gPred:GetPrediction(target,myHero,JinxW,false,true)
			if WPred and WPred.HitChance >= 3 then
				CastSkillShot(_W, WPred.CastPosition)
			end
		elseif JinxMenu.Prediction.PredictionW:Value() == 4 then
			local WSpell = IPrediction.Prediction({name="JinxW", range=JinxW.range, speed=JinxW.speed, delay=JinxW.delay, width=JinxW.width, type="linear", collision=true})
			ts = TargetSelector()
			target = ts:GetTarget(JinxW.range)
			local x, y = WSpell:Predict(target)
			if x > 2 then
				CastSkillShot(_W, y.x, y.y, y.z)
			end
		elseif JinxMenu.Prediction.PredictionW:Value() == 5 then
			local WPrediction = GetLinearAOEPrediction(target,JinxW)
			if WPrediction.hitChance > 0.9 then
				CastSkillShot(_W, WPrediction.castPos)
			end
		end
	end
end
function useE(target)
	if GetDistance(target) < JinxE.range then
		if JinxMenu.Prediction.PredictionE:Value() == 1 then
			CastSkillShot(_E,GetOrigin(target))
		elseif JinxMenu.Prediction.PredictionE:Value() == 2 then
			local EPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),JinxE.speed,JinxE.delay*1000,JinxE.range,JinxE.width,false,true)
			if EPred.HitChance == 1 then
				CastSkillShot(_E, EPred.PredPos)
			end
		elseif JinxMenu.Prediction.PredictionE:Value() == 3 then
			local EPred = _G.gPred:GetPrediction(target,myHero,JinxE,true,false)
			if EPred and EPred.HitChance >= 3 then
				CastSkillShot(_W, WPred.CastPosition)
			end
		elseif JinxMenu.Prediction.PredictionE:Value() == 4 then
			local ESpell = IPrediction.Prediction({name="JinxE", range=JinxE.range, speed=JinxE.speed, delay=JinxE.delay, width=JinxE.width, type="circular", collision=false})
			ts = TargetSelector()
			target = ts:GetTarget(JinxE.range)
			local x, y = ESpell:Predict(target)
			if x > 2 then
				CastSkillShot(_E, y.x, y.y, y.z)
			end
		elseif JinxMenu.Prediction.PredictionE:Value() == 5 then
			local EPrediction = GetCircularAOEPrediction(target,JinxE)
			if EPrediction.hitChance > 0.9 then
				CastSkillShot(_E, EPrediction.castPos)
			end
		end
	end
end
function useR(target)
	if GetDistance(target) < JinxR.range then
		if JinxMenu.Prediction.PredictionR:Value() == 1 then
			CastSkillShot(_R,GetOrigin(target))
		elseif JinxMenu.Prediction.PredictionR:Value() == 2 then
			local RPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),JinxR.speed,JinxR.delay*1000,JinxR.range,JinxR.width,false,false)
			if RPred.HitChance == 1 then
				CastSkillShot(_R, RPred.PredPos)
			end
		elseif JinxMenu.Prediction.PredictionR:Value() == 3 then
			local RPred = _G.gPred:GetPrediction(target,myHero,JinxR,false,false)
			if RPred and RPred.HitChance >= 3 then
				CastSkillShot(_R, RPred.CastPosition)
			end
		elseif JinxMenu.Prediction.PredictionR:Value() == 4 then
			local RSpell = IPrediction.Prediction({name="JinxR", range=JinxR.range, speed=JinxR.speed, delay=JinxR.delay, width=JinxR.width, type="linear", collision=false})
			ts = TargetSelector()
			target = ts:GetTarget(JinxR.range)
			local x, y = RSpell:Predict(target)
			if x > 2 then
				CastSkillShot(_R, y.x, y.y, y.z)
			end
		elseif JinxMenu.Prediction.PredictionR:Value() == 5 then
			local RPrediction = GetLinearAOEPrediction(target,JinxR)
			if RPrediction.hitChance > 0.9 then
				CastSkillShot(_R, RPrediction.castPos)
			end
		end
	end
end
OnUpdateBuff(function(unit,buff)
	if unit == myHero and buff.Name == "jinxqicon" then
		Q2 = false
	end
end)
OnRemoveBuff(function(unit,buff)
	if unit == myHero and buff.Name == "jinxqicon" then
		Q2 = true
	end
end)

-- Auto

function Auto()
	if JinxMenu.Auto.UseW:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > JinxMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_W) == READY then
				if ValidTarget(target, JinxW.range) then
					useW(target)
				end
			end
		end
	end
end

-- Combo

function Combo()
	if Mode() == "Combo" then
		if JinxMenu.Combo.UseQ:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if ValidTarget(target, GetRange(myHero)) then
					if Q2 then
						if EnemiesAround(target, 150) <= 1 then
							useQ(target)
						end
					else
						if EnemiesAround(target, 150) > 1 then
							useQ(target)
						end
					end
				elseif ValidTarget(target, GetRange(myHero)+200) then
					if GetDistance(myHero, target) > 600 and not Q2 then
						useQ(target)
					elseif GetDistance(myHero, target) < 600 and Q2 then
						useQ(target)
					end
				end
			end
		end
		if JinxMenu.Combo.UseW:Value() then
			if CanUseSpell(myHero,_W) == READY and AA == true then
				if ValidTarget(target, JinxW.range) then
					useW(target)
				end
			end
		end
		if JinxMenu.Combo.UseE:Value() then
			if CanUseSpell(myHero,_E) == READY and AA == true then
				if ValidTarget(target, JinxE.range) then
					useE(target)
				end
			end
		end
		if JinxMenu.Combo.UseR:Value() then
			if CanUseSpell(myHero,_R) == READY then
				if ValidTarget(target, JinxR.range) then
					if 100*GetCurrentHP(target)/GetMaxHP(target) < JinxMenu.Combo.HP:Value() then
						if EnemiesAround(myHero, JinxR.range+GetRange(myHero)) >= JinxMenu.Combo.X:Value() then
							useR(target)
						end
					end
				end
			end
		end
	end
end

-- Harass

function Harass()
	if Mode() == "Harass" then
		if JinxMenu.Harass.UseQ:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if ValidTarget(target, GetRange(myHero)) then
					if Q2 then
						if EnemiesAround(target, 150) <= 1 then
							useQ(target)
						end
					else
						if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > JinxMenu.Harass.MP:Value() then
							if EnemiesAround(target, 150) > 1 then
								useQ(target)
							end
						end
					end
				elseif ValidTarget(target, GetRange(myHero)+200) then
					if GetDistance(myHero, target) > 600 and not Q2 then
						if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > JinxMenu.Harass.MP:Value() then
							useQ(target)
						end
					elseif GetDistance(myHero, target) < 600 and Q2 then
						useQ(target)
					end
				end
			end
		end
		if JinxMenu.Harass.UseW:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > JinxMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_W) == READY and AA == true then
					if ValidTarget(target, JinxW.range) then
						useW(target)
					end
				end
			end
		end
		if JinxMenu.Harass.UseE:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > JinxMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(target, JinxE.range) then
						useE(target)
					end
				end
			end
		end
	end
end

-- KillSteal

function KillSteal()
	for i,enemy in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_W) == READY then
			if JinxMenu.KillSteal.UseW:Value() then
				if ValidTarget(enemy, JinxW.range) then
					local JinxWDmg = (15*GetCastLevel(myHero,_W)+5)+(GetBonusDmg(myHero)+GetBaseDamage(myHero))
					if (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*2) < JinxWDmg then
						useW(enemy)
					end
				end
			end
		elseif CanUseSpell(myHero,_R) == READY then
			if JinxMenu.KillSteal.UseR:Value() then
				if ValidTarget(enemy, JinxMenu.KillSteal.Distance:Value()) and GetDistance(enemy, myHero) >= 1500 then
					local JinxRDmg = math.max(50*GetCastLevel(myHero,_R)+75+GetBonusDmg(myHero)+(0.05*GetCastLevel(myHero,_R)+0.2)*(GetMaxHP(enemy)-GetCurrentHP(enemy)))
					if (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*8) < JinxRDmg then
						useR(enemy)
					end
				end
			end
		end
	end
end

-- LaneClear

function LaneClear()
	if Mode() == "LaneClear" then
		if JinxMenu.LaneClear.UseE:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > JinxMenu.LaneClear.MP:Value() then
				if CanUseSpell(myHero,_E) == READY then
					local BestPos, BestHit = GetFarmPosition(JinxE.range, JinxE.radius, MINION_ENEMY)
					if BestPos and BestHit > 3 then
						CastSkillShot(_E, BestPos)
					end
				end
			end
		end
		if JinxMenu.LaneClear.UseQ:Value() then
			for _, minion in pairs(minionManager.objects) do
				if GetTeam(minion) == MINION_ENEMY then
					if ValidTarget(minion, GetRange(myHero)+GetHitBox(myHero)) then
						if CanUseSpell(myHero,_Q) == READY then
							if Q2 then
								if MinionsAround(minion, 150) <= 1 then
									useQ(minion)
								end
							else
								if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > JinxMenu.LaneClear.MP:Value() then
									if MinionsAround(minion, 150) > 1 then
										useQ(minion)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

-- Anti-Gapcloser

function AntiGapcloser()
	for i,antigap in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_W) == READY then
			if JinxMenu.AntiGapcloser.UseW:Value() then
				if ValidTarget(antigap, JinxMenu.AntiGapcloser.DistanceW:Value()) then
					useW(antigap)
				end
			end
		elseif CanUseSpell(myHero,_E) == READY then
			if JinxMenu.AntiGapcloser.UseE:Value() then
				if ValidTarget(antigap, JinxMenu.AntiGapcloser.DistanceE:Value()) then
					useE(antigap)
				end
			end
		end
	end
end

-- Interrupter

OnProcessSpell(function(unit, spell)
	if JinxMenu.Interrupter.UseE:Value() then
		for _, enemy in pairs(GetEnemyHeroes()) do
			if ValidTarget(enemy, JinxMenu.Interrupter.Distance:Value()) then
				if CanUseSpell(myHero,_E) == READY then
					local UnitName = GetObjectName(enemy)
					local UnitChanellingSpells = CHANELLING_SPELLS[UnitName]
					local UnitGapcloserSpells = GAPCLOSER_SPELLS[UnitName]
					if UnitGapcloserSpells then
						for _, slot in pairs(UnitGapcloserSpells) do
							if spell.name == GetCastName(enemy, slot) then useE(enemy) end
						end
					end
				end
			end
		end
    end
end)

-- Kaisa

elseif "Kaisa" == GetObjectName(myHero) then

PrintChat("<font color='#1E90FF'>[<font color='#00BFFF'>GoS-U<font color='#1E90FF'>] <font color='#00BFFF'>Kaisa loaded successfully!")
local KaisaMenu = Menu("[GoS-U] Kaisa", "[GoS-U] Kaisa")
KaisaMenu:Menu("Auto", "Auto")
KaisaMenu.Auto:Boolean('UseQ', 'Use Q [Icathian Rain]', true)
KaisaMenu.Auto:Boolean('UseW', 'Use W [Void Seeker]', false)
KaisaMenu.Auto:Slider("MP","Mana-Manager", 40, 0, 100, 5)
KaisaMenu:Menu("Combo", "Combo")
KaisaMenu.Combo:Boolean('UseQ', 'Use Q [Icathian Rain]', true)
KaisaMenu.Combo:Boolean('UseW', 'Use W [Void Seeker]', true)
KaisaMenu.Combo:Boolean('UseE', 'Use E [Supercharger]', true)
KaisaMenu:Menu("Harass", "Harass")
KaisaMenu.Harass:Boolean('UseQ', 'Use Q [Icathian Rain]', true)
KaisaMenu.Harass:Boolean('UseW', 'Use W [Void Seeker]', true)
KaisaMenu.Harass:Boolean('UseE', 'Use E [Supercharger]', true)
KaisaMenu.Harass:Slider("MP","Mana-Manager", 40, 0, 100, 5)
KaisaMenu:Menu("KillSteal", "KillSteal")
KaisaMenu.KillSteal:Boolean('UseW', 'Use W [Void Seeker]', true)
KaisaMenu:Menu("LaneClear", "LaneClear")
KaisaMenu.LaneClear:Boolean('UseQ', 'Use Q [Icathian Rain]', true)
KaisaMenu.LaneClear:Slider("MP","Mana-Manager", 40, 0, 100, 5)
KaisaMenu:Menu("Prediction", "Prediction")
KaisaMenu.Prediction:DropDown("PredictionW", "Prediction: W", 2, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
KaisaMenu:Menu("Drawings", "Drawings")
KaisaMenu.Drawings:Boolean('DrawQ', 'Draw Q Range', true)
KaisaMenu.Drawings:Boolean('DrawW', 'Draw W Range', true)
KaisaMenu.Drawings:Boolean('DrawR', 'Draw R Range', true)
KaisaMenu.Drawings:Boolean('DrawDMG', 'Draw Max QW Damage', false)

local KaisaQ = { range = 600 }
local KaisaW = { range = 3000, radius = 65, width = 130, speed = 1750, delay = 0.4, type = "line", collision = true, source = myHero, col = {"minion","yasuowall"}}
local KaisaR = { range = GetCastRange(myHero,_R) }

OnTick(function(myHero)
	Auto()
	ECheck()
	Combo()
	Harass()
	KillSteal()
	LaneClear()
end)
OnDraw(function(myHero)
	Ranges()
	DrawDamage()
end)

function Ranges()
local pos = GetOrigin(myHero)
if KaisaMenu.Drawings.DrawQ:Value() then DrawCircle(pos,KaisaQ.range,1,25,0xff00bfff) end
if KaisaMenu.Drawings.DrawW:Value() then DrawCircle(pos,KaisaW.range,1,25,0xff4169e1) end
if KaisaMenu.Drawings.DrawR:Value() then DrawCircle(pos,KaisaR.range,1,25,0xff0000ff) end
end

function DrawDamage()
	for _, enemy in pairs(GetEnemyHeroes()) do
		local QDmg = (39.625*GetCastLevel(myHero,_Q)+72.875)+(0.875*GetBonusDmg(myHero))+GetBonusAP(myHero)
		local WDmg = (25*GetCastLevel(myHero,_W)-5)+(1.5*(GetBonusDmg(myHero)+GetBaseDamage(myHero)))+(0.45*GetBonusAP(myHero))
		local ComboDmg = QDmg + WDmg
		if ValidTarget(enemy) then
			if KaisaMenu.Drawings.DrawDMG:Value() then
				if Ready(_Q) and Ready(_W) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ComboDmg), 0xff008080)
				elseif Ready(_Q) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QDmg), 0xff008080)
				elseif Ready(_W) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WDmg), 0xff008080)
				end
			end
		end
	end
end

function useW(target)
	if GetDistance(target) < KaisaW.range then
		if KaisaMenu.Prediction.PredictionW:Value() == 1 then
			CastSkillShot(_W,GetOrigin(target))
		elseif KaisaMenu.Prediction.PredictionW:Value() == 2 then
			local WPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),KaisaW.speed,KaisaW.delay*1000,KaisaW.range,KaisaW.width,true,false)
			if WPred.HitChance == 1 then
				CastSkillShot(_W, WPred.PredPos)
			end
		elseif KaisaMenu.Prediction.PredictionW:Value() == 3 then
			local WPred = _G.gPred:GetPrediction(target,myHero,KaisaW,false,true)
			if WPred and WPred.HitChance >= 3 then
				CastSkillShot(_W, WPred.CastPosition)
			end
		elseif KaisaMenu.Prediction.PredictionW:Value() == 4 then
			local WSpell = IPrediction.Prediction({name="KaisaW", range=KaisaW.range, speed=KaisaW.speed, delay=KaisaW.delay, width=KaisaW.width, type="linear", collision=true})
			ts = TargetSelector()
			target = ts:GetTarget(KaisaW.range)
			local x, y = WSpell:Predict(target)
			if x > 2 then
				CastSkillShot(_W, y.x, y.y, y.z)
			end
		elseif KaisaMenu.Prediction.PredictionW:Value() == 5 then
			local WPrediction = GetLinearAOEPrediction(target,KaisaW)
			if WPrediction.hitChance > 0.9 then
				CastSkillShot(_W, WPrediction.castPos)
			end
		end
	end
end
function ECheck()
	if GotBuff(myHero, "KaisaE") > 0 then
		if _G.IOW then
			IOW.attacksEnabled = false
		elseif _G.GoSWalkLoaded then
			_G.GoSWalk:EnableAttack(false)
		elseif _G.DAC_Loaded then
			DAC:AttacksEnabled(false)
		elseif _G.AutoCarry_Loaded then
			DACR.attacksEnabled = false
		end
	else
		if _G.IOW then
			IOW.attacksEnabled = true
		elseif _G.GoSWalkLoaded then
			_G.GoSWalk:EnableAttack(true)
		elseif _G.DAC_Loaded then
			DAC:AttacksEnabled(true)
		elseif _G.AutoCarry_Loaded then
			DACR.attacksEnabled = true
		end
	end
end

-- Auto

function Auto()
	if KaisaMenu.Auto.UseQ:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KaisaMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if ValidTarget(target, KaisaQ.range) then
					CastSpell(_Q)
				end
			end
		end
	end
	if KaisaMenu.Auto.UseW:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KaisaMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_W) == READY then
				if ValidTarget(target, KaisaW.range) then
					useW(target)
				end
			end
		end
	end
end

-- Combo

function Combo()
	if Mode() == "Combo" then
		if KaisaMenu.Combo.UseQ:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if ValidTarget(target, KaisaQ.range) then
					CastSpell(_Q)
				end
			end
		end
		if KaisaMenu.Combo.UseW:Value() then
			if CanUseSpell(myHero,_W) == READY and AA == true then
				if ValidTarget(target, KaisaW.range) then
					useW(target)
				end
			end
		end
		if KaisaMenu.Combo.UseE:Value() then
			if CanUseSpell(myHero,_E) == READY then
				if ValidTarget(target, 600+GetRange(myHero)+GetHitBox(myHero)) then
					if GetDistance(target) > GetRange(myHero) then
						if GotBuff(myHero, "KaisaE") == 0 then
							CastSpell(_E)
						end
					end
				end
			end
		end
	end
end

-- Harass

function Harass()
	if Mode() == "Harass" then
		if KaisaMenu.Harass.UseQ:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KaisaMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(target, KaisaQ.range) then
						useQ(target)
					end
				end
			end
		end
		if KaisaMenu.Harass.UseW:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KaisaMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_W) == READY and AA == true then
					if ValidTarget(target, KaisaW.range) then
						useW(target)
					end
				end
			end
		end
		if KaisaMenu.Harass.UseE:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KaisaMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(target, 600+GetRange(myHero)+GetHitBox(myHero)) then
						if GetDistance(target) > GetRange(myHero) then
							if GotBuff(myHero, "KaisaE") == 0 then
								CastSpell(_E)
							end
						end
					end
				end
			end
		end
	end
end

-- KillSteal

function KillSteal()
	for i,enemy in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_W) == READY then
			if KaisaMenu.KillSteal.UseW:Value() then
				if ValidTarget(enemy, KaisaW.range) then
					local KaisaWDmg = (25*GetCastLevel(myHero,_W)-5)+(1.5*(GetBonusDmg(myHero)+GetBaseDamage(myHero)))+(0.65*GetBonusAP(myHero))
					if (GetCurrentHP(enemy)+GetMagicResist(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*6) < KaisaWDmg then
						useW(enemy)
					end
				end
			end
		end
	end
end

-- LaneClear

function LaneClear()
	if Mode() == "LaneClear" then
		if KaisaMenu.LaneClear.UseQ:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KaisaMenu.LaneClear.MP:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					local BestPos, BestHit = GetFarmPosition(1, KaisaQ.range, MINION_ENEMY)
					if BestPos and BestHit > 3 then
						CastSkillShot(_Q, BestPos)
					end
				end
			end
		end
	end
end

-- Kalista

elseif "Kalista" == GetObjectName(myHero) then

PrintChat("<font color='#1E90FF'>[<font color='#00BFFF'>GoS-U<font color='#1E90FF'>] <font color='#00BFFF'>Kalista loaded successfully!")
local KalistaMenu = Menu("[GoS-U] Kalista", "[GoS-U] Kalista")
KalistaMenu:Menu("Auto", "Auto")
KalistaMenu.Auto:Boolean('UseW', 'Use W [Sentinel]', true)
KalistaMenu.Auto:Boolean('UseR', 'Use R [Fates Call]', true)
KalistaMenu.Auto:Slider("MP","Mana-Manager: W", 40, 0, 100, 5)
KalistaMenu.Auto:Slider('HP','HP-Manager: R', 20, 0, 100, 5)
KalistaMenu:Menu("ERend", "E [Rend]")
KalistaMenu.ERend:Boolean('ResetE', 'Use E (Reset)', true)
KalistaMenu.ERend:Boolean('OutOfAA', 'Use E (Out Of AA)', true)
KalistaMenu.ERend:Slider("MS","Minimum Spears", 6, 0, 20, 1)
KalistaMenu:Menu("Combo", "Combo")
KalistaMenu.Combo:Boolean('UseQ', 'Use Q [Pierce]', true)
KalistaMenu.Combo:Boolean('UseE', 'Use E [Rend]', true)
KalistaMenu:Menu("Harass", "Harass")
KalistaMenu.Harass:Boolean('UseQ', 'Use Q [Pierce]', true)
KalistaMenu.Harass:Boolean('UseE', 'Use E [Rend]', true)
KalistaMenu.Harass:Slider("MP","Mana-Manager", 40, 0, 100, 5)
KalistaMenu:Menu("KillSteal", "KillSteal")
KalistaMenu.KillSteal:Boolean('UseQ', 'Use Q [Pierce]', true)
KalistaMenu.KillSteal:Boolean('UseE', 'Use E [Rend]', true)
KalistaMenu:Menu("LastHit", "LastHit")
KalistaMenu.LastHit:Boolean('UseE', 'Use E [Rend]', true)
KalistaMenu:Menu("LaneClear", "LaneClear")
KalistaMenu.LaneClear:Boolean('UseQ', 'Use Q [Pierce]', true)
KalistaMenu.LaneClear:Slider("MP","Mana-Manager", 40, 0, 100, 5)
KalistaMenu:Menu("Prediction", "Prediction")
KalistaMenu.Prediction:DropDown("PredictionQ", "Prediction: Q", 2, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
KalistaMenu:Menu("Drawings", "Drawings")
KalistaMenu.Drawings:Boolean('DrawQ', 'Draw Q Range', true)
KalistaMenu.Drawings:Boolean('DrawE', 'Draw E Range', true)
KalistaMenu.Drawings:Boolean('DrawR', 'Draw R Range', true)
KalistaMenu.Drawings:Boolean('DrawDMG', 'Draw Max QE Damage', false)

local KalistaQ = { range = 1150, radius = 35, width = 70, speed = 2100, delay = 0.35, type = "line", collision = true, source = myHero, col = {"minion","yasuowall"}}
local KalistaE = { range = 1000 }
local KalistaR = { range = 1200 }

OnTick(function(myHero)
	Auto()
	Combo()
	Harass()
	KillSteal()
	LastHit()
	LaneClear()
end)
OnDraw(function(myHero)
	Ranges()
	DrawDamage()
end)

function Ranges()
local pos = GetOrigin(myHero)
if KalistaMenu.Drawings.DrawQ:Value() then DrawCircle(pos,KalistaQ.range,1,25,0xff00bfff) end
if KalistaMenu.Drawings.DrawE:Value() then DrawCircle(pos,KalistaE.range,1,25,0xff1e90ff) end
if KalistaMenu.Drawings.DrawR:Value() then DrawCircle(pos,KalistaR.range,1,25,0xff0000ff) end
end

function DrawDamage()
	for _, enemy in pairs(GetEnemyHeroes()) do
		local QDmg = (60*GetCastLevel(myHero,_Q)-50)+(GetBaseDamage(myHero)+GetBonusDmg(myHero))
		local EDmg = (10*GetCastLevel(myHero,_E)+10+(0.6*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))+(((4*GetCastLevel(myHero,_E)+6)+((0.0375*GetCastLevel(myHero,_E)+0.1625)*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))*(GotBuff(enemy,"kalistaexpungemarker")-1))
		local ComboDmg = QDmg + EDmg
		if ValidTarget(enemy) then
			if KalistaMenu.Drawings.DrawDMG:Value() then
				if Ready(_Q) and Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ComboDmg), 0xff008080)
				elseif Ready(_Q) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QDmg), 0xff008080)
				elseif Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, EDmg), 0xff008080)
				end
			end
		end
	end
end

function useQ(target)
	if GetDistance(target) < KalistaQ.range then
		if KalistaMenu.Prediction.PredictionQ:Value() == 1 then
			CastSkillShot(_Q,GetOrigin(target))
		elseif KalistaMenu.Prediction.PredictionQ:Value() == 2 then
			local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),KalistaQ.speed,KalistaQ.delay*1000,KalistaQ.range,KalistaQ.width,true,false)
			if QPred.HitChance == 1 then
				CastSkillShot(_Q, QPred.PredPos)
			end
		elseif KalistaMenu.Prediction.PredictionQ:Value() == 3 then
			local qPred = _G.gPred:GetPrediction(target,myHero,KalistaQ,false,true)
			if qPred and qPred.HitChance >= 3 then
				CastSkillShot(_Q, qPred.CastPosition)
			end
		elseif KalistaMenu.Prediction.PredictionQ:Value() == 4 then
			local QSpell = IPrediction.Prediction({name="KalistaMysticShot", range=KalistaQ.range, speed=KalistaQ.speed, delay=KalistaQ.delay, width=KalistaQ.width, type="linear", collision=true})
			ts = TargetSelector()
			target = ts:GetTarget(KalistaQ.range)
			local x, y = QSpell:Predict(target)
			if x > 2 then
				CastSkillShot(_Q, y.x, y.y, y.z)
			end
		elseif KalistaMenu.Prediction.PredictionQ:Value() == 5 then
			local QPrediction = GetLinearAOEPrediction(target,KalistaQ)
			if QPrediction.hitChance > 0.9 then
				CastSkillShot(_Q, QPrediction.castPos)
			end
		end
	end
end

-- Auto

function Auto()
	if KalistaMenu.Auto.UseW:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KalistaMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_W) == READY then
				if EnemiesAround(myHero, 2500) == 0 then
					if GetDistance(Vector(9882.892, -71.24, 4438.446)) < GetDistance(Vector(5087.77, -71.24, 10471.3808)) and GetDistance(Vector(9882.892, -71.24, 4438.446)) < 5200 then
						CastSkillShot(_W,9882.892, -71.24, 4438.446)
					elseif GetDistance(Vector(5087.77, -71.24, 10471.3808)) < 5200 then
						CastSkillShot(_W,5087.77, -71.24, 10471.3808)
					end
				end
			end
		end
	end
	if KalistaMenu.Auto.UseR:Value() then
		for _, ally in pairs(GetAllyHeroes()) do
			if CanUseSpell(myHero,_R) == READY and GotBuff(ally,"kalistacoopstrikeally") == 1 then
				if ValidTarget(ally, KalistaR.range) and EnemiesAround(ally, 1500) >= 1 then
					if (GetCurrentHP(ally)/GetMaxHP(ally))*100 <= KalistaMenu.Auto.HP:Value() then
						CastSpell(_R)
					end
				end
			end
		end
	end
end

-- Combo

function Combo()
	if Mode() == "Combo" then
		if KalistaMenu.Combo.UseQ:Value() then
			if CanUseSpell(myHero,_Q) == READY and AA == true then
				if ValidTarget(target, KalistaQ.range) then
					useQ(target)
				end
			end
		end
		if KalistaMenu.Combo.UseE:Value() then
			if CanUseSpell(myHero,_E) == READY then
				if ValidTarget(target, KalistaE.range) then
					if GetDistance(target, myHero) <= GetRange(myHero) then
						if KalistaMenu.ERend.ResetE:Value() then
							for i,minion in pairs(minionManager.objects) do
								if GetTeam(minion) == MINION_ENEMY then
									if ValidTarget(minion, KalistaE.range) and GotBuff(minion,"kalistaexpungemarker") >= 1 then
										local KalistaEDmg = (10*GetCastLevel(myHero,_E)+10+(0.6*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))+(((4*GetCastLevel(myHero,_E)+6)+((0.025*GetCastLevel(myHero,_E)+0.175)*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))*(GotBuff(minion,"kalistaexpungemarker")-1))
										if GetCurrentHP(minion)+GetDmgShield(minion) < KalistaEDmg then
											if GotBuff(target,"kalistaexpungemarker") >= KalistaMenu.ERend.MS:Value() then
												CastSpell(_E)
											end
										end
									end
								end
							end
						end
					elseif GetDistance(target, myHero) >= GetRange(myHero) then
						if KalistaMenu.ERend.OutOfAA:Value() then
							if GotBuff(target,"kalistaexpungemarker") >= KalistaMenu.ERend.MS:Value() then
								CastSpell(_E)
							end
						end
					end
				end
			end
		end
	end
end

-- Harass

function Harass()
	if Mode() == "Harass" then
		if KalistaMenu.Harass.UseQ:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KalistaMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_Q) == READY and AA == true then
					if ValidTarget(target, KalistaQ.range) then
						useQ(target)
					end
				end
			end
		end
		if KalistaMenu.Harass.UseE:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KalistaMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(target, KalistaE.range) then
						if GetDistance(target, myHero) <= GetRange(myHero) then
							if KalistaMenu.ERend.ResetE:Value() then
								for i,minion in pairs(minionManager.objects) do
									if GetTeam(minion) == MINION_ENEMY then		
										if GotBuff(minion,"kalistaexpungemarker") >= 1 then
											local KalistaEDmg = (10*GetCastLevel(myHero,_E)+10+(0.6*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))+(((4*GetCastLevel(myHero,_E)+6)+((0.025*GetCastLevel(myHero,_E)+0.175)*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))*(GotBuff(minion,"kalistaexpungemarker")-1))
											if GetCurrentHP(minion) < KalistaEDmg then
												if GotBuff(target,"kalistaexpungemarker") >= KalistaMenu.ERend.MS:Value() then
													CastSpell(_E)
												end
											end
										end
									end
								end
							end
						elseif GetDistance(target, myHero) >= GetRange(myHero) then
							if KalistaMenu.ERend.OutOfAA:Value() then
								if GotBuff(target,"kalistaexpungemarker") >= KalistaMenu.ERend.MS:Value() then
									CastSpell(_E)
								end
							end
						end
					end
				end
			end
		end
	end
end

-- KillSteal

function KillSteal()
	for i,enemy in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_Q) == READY then
			if KalistaMenu.KillSteal.UseQ:Value() then
				if ValidTarget(enemy, KalistaQ.range) then
					local KalistaQDmg = (60*GetCastLevel(myHero,_Q)-50)+(GetBaseDamage(myHero)+GetBonusDmg(myHero))
					if (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*2) < KalistaQDmg then
						useQ(enemy)
					end
				end
			end
		elseif CanUseSpell(myHero,_E) == READY then
			if KalistaMenu.KillSteal.UseE:Value() then
				if ValidTarget(enemy, KalistaE.range) and GotBuff(enemy,"kalistaexpungemarker") >= 1 then
					local KalistaEDmg = (10*GetCastLevel(myHero,_E)+10+(0.6*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))+(((4*GetCastLevel(myHero,_E)+6)+((0.025*GetCastLevel(myHero,_E)+0.175)*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))*(GotBuff(enemy,"kalistaexpungemarker")-1))
					if (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)) < KalistaEDmg then
						CastSpell(_E)
					end
				end
			end
		end
	end
end

-- LastHit

function LastHit()
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if ValidTarget(minion, KalistaE.range) and GotBuff(minion,"kalistaexpungemarker") >= 1 then
					if KalistaMenu.LastHit.UseE:Value() then
						if CanUseSpell(myHero,_E) == READY then
							local KalistaEDmg = (10*GetCastLevel(myHero,_E)+10+(0.6*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))+(((4*GetCastLevel(myHero,_E)+6)+((0.025*GetCastLevel(myHero,_E)+0.175)*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))*(GotBuff(minion,"kalistaexpungemarker")-1))
							if GetCurrentHP(minion)+GetDmgShield(minion) < KalistaEDmg then
								CastSpell(_E)
							end
						end
					end
				end
			end
		end
	end
end

-- LaneClear

function LaneClear()
	if Mode() == "LaneClear" then
		if KalistaMenu.LaneClear.UseQ:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KalistaMenu.LaneClear.MP:Value() then
				for _, minion in pairs(minionManager.objects) do
					if GetTeam(minion) == MINION_ENEMY then
						if ValidTarget(minion, KalistaQ.range) then
							if CanUseSpell(myHero,_Q) == READY then
								CastSkillShot(_Q, GetOrigin(minion))
							end
						end
					end
				end
			end
		end
	end
end

-- KogMaw

elseif "KogMaw" == GetObjectName(myHero) then

PrintChat("<font color='#1E90FF'>[<font color='#00BFFF'>GoS-U<font color='#1E90FF'>] <font color='#00BFFF'>KogMaw loaded successfully!")
local KogMawMenu = Menu("[GoS-U] KogMaw", "[GoS-U] KogMaw")
KogMawMenu:Menu("Auto", "Auto")
KogMawMenu.Auto:Boolean('UseQ', 'Use Q [Caustic Spittle]', true)
KogMawMenu.Auto:Boolean('UseR', 'Use R [Living Artillery]', true)
KogMawMenu.Auto:Slider("MP","Mana-Manager", 40, 0, 100, 5)
KogMawMenu:Menu("Combo", "Combo")
KogMawMenu.Combo:Boolean('UseQ', 'Use Q [Caustic Spittle]', true)
KogMawMenu.Combo:Boolean('UseW', 'Use W [Bio-Arcane Barrage]', true)
KogMawMenu.Combo:Boolean('UseE', 'Use E [Void Ooze]', true)
KogMawMenu.Combo:Boolean('UseR', 'Use R [Living Artillery]', true)
KogMawMenu:Menu("Harass", "Harass")
KogMawMenu.Harass:Boolean('UseQ', 'Use Q [Caustic Spittle]', true)
KogMawMenu.Harass:Boolean('UseW', 'Use W [Bio-Arcane Barrage]', true)
KogMawMenu.Harass:Boolean('UseE', 'Use E [Void Ooze]', true)
KogMawMenu.Harass:Boolean('UseR', 'Use R [Living Artillery]', true)
KogMawMenu.Harass:Slider("MP","Mana-Manager", 40, 0, 100, 5)
KogMawMenu:Menu("KillSteal", "KillSteal")
KogMawMenu.KillSteal:Boolean('UseE', 'Use E [Void Ooze]', true)
KogMawMenu.KillSteal:Boolean('UseR', 'Use R [Living Artillery]', true)
KogMawMenu:Menu("LastHit", "LastHit")
KogMawMenu.LastHit:Boolean('UseQ', 'Use Q [Caustic Spittle]', true)
KogMawMenu.LastHit:Slider("MP","Mana-Manager", 40, 0, 100, 5)
KogMawMenu:Menu("LaneClear", "LaneClear")
KogMawMenu.LaneClear:Boolean('UseQ', 'Use Q [Caustic Spittle]', false)
KogMawMenu.LaneClear:Boolean('UseW', 'Use W [Bio-Arcane Barrage]', true)
KogMawMenu.LaneClear:Boolean('UseE', 'Use E [Void Ooze]', false)
KogMawMenu.LaneClear:Boolean('UseR', 'Use R [Living Artillery]', true)
KogMawMenu.LaneClear:Slider("MP","Mana-Manager", 40, 0, 100, 5)
KogMawMenu:Menu("AntiGapcloser", "Anti-Gapcloser")
KogMawMenu.AntiGapcloser:Boolean('UseE', 'Use E [Void Ooze]', true)
KogMawMenu.AntiGapcloser:Slider('Distance','Distance: E', 450, 25, 500, 25)
KogMawMenu:Menu("Prediction", "Prediction")
KogMawMenu.Prediction:DropDown("PredictionQ", "Prediction: Q", 2, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
KogMawMenu.Prediction:DropDown("PredictionE", "Prediction: E", 2, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
KogMawMenu.Prediction:DropDown("PredictionR", "Prediction: R", 5, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
KogMawMenu:Menu("Drawings", "Drawings")
KogMawMenu.Drawings:Boolean('DrawQ', 'Draw Q Range', true)
KogMawMenu.Drawings:Boolean('DrawE', 'Draw E Range', true)
KogMawMenu.Drawings:Boolean('DrawR', 'Draw R Range', true)
KogMawMenu.Drawings:Boolean('DrawDMG', 'Draw Max QWER Damage', false)

local KogMawQ = { range = 1175, radius = 60, width = 120, speed = 1600, delay = 0.25, type = "line", collision = true, source = myHero, col = {"minion","yasuowall"}}
local KogMawE = { range = 1280, radius = 115, width = 230, speed = 1350, delay = 0.25, type = "line", collision = false, source = myHero }
local KogMawR = { range = GetCastRange(myHero,_R), radius = 200, width = 400, speed = math.huge, delay = 0.85, type = "circular", collision = false, source = myHero }

OnTick(function(myHero)
	Auto()
	Combo()
	Harass()
	LastHit()
	KillSteal()
	LaneClear()
	AntiGapcloser()
end)
OnDraw(function(myHero)
	Ranges()
	DrawDamage()
end)

function Ranges()
local pos = GetOrigin(myHero)
if KogMawMenu.Drawings.DrawQ:Value() then DrawCircle(pos,KogMawQ.range,1,25,0xff00bfff) end
if KogMawMenu.Drawings.DrawE:Value() then DrawCircle(pos,KogMawE.range,1,25,0xff1e90ff) end
if KogMawMenu.Drawings.DrawR:Value() then DrawCircle(pos,KogMawR.range,1,25,0xff0000ff) end
end

function DrawDamage()
	for _, enemy in pairs(GetEnemyHeroes()) do
		local QDmg = (50*GetCastLevel(myHero,_Q)+30)+(0.5*GetBonusAP(myHero))
		local WDmg = (0.0075*GetCastLevel(myHero,_W)+0.0225)+((0.01*GetBonusAP(myHero))*GetMaxHP(enemy))
		local EDmg = (45*GetCastLevel(myHero,_E)+15)+(0.5*GetBonusAP(myHero))
		local RDmg = ((40*GetCastLevel(myHero,_R)+60)+(0.65*GetBonusDmg(myHero))+(0.25*GetBonusAP(myHero)))*(GetPercentHP(enemy) < 25 and 3 or (GetPercentHP(enemy) < 50 and 2 or 1))
		local ComboDmg = QDmg + WDmg + EDmg + RDmg
		local WERDmg = WDmg + EDmg + RDmg
		local QERDmg = QDmg + EDmg + RDmg
		local QWRDmg = QDmg + WDmg + RDmg
		local QWEDmg = QDmg + WDmg + EDmg
		local ERDmg = EDmg + RDmg
		local WRDmg = WDmg + RDmg
		local QRDmg = QDmg + RDmg
		local WEDmg = WDmg + EDmg
		local QEDmg = QDmg + EDmg
		local QWDmg = QDmg + WDmg
		if ValidTarget(enemy) then
			if KogMawMenu.Drawings.DrawDMG:Value() then
				if Ready(_Q) and Ready(_W) and Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ComboDmg), 0xff008080)
				elseif Ready(_W) and Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WERDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QERDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_W) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QWRDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_W) and Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QWEDmg), 0xff008080)
				elseif Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ERDmg), 0xff008080)
				elseif Ready(_W) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WRDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QRDmg), 0xff008080)
				elseif Ready(_W) and Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WEDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QEDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_W) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QWDmg), 0xff008080)
				elseif Ready(_Q) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QDmg), 0xff008080)
				elseif Ready(_W) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WDmg), 0xff008080)
				elseif Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, EDmg), 0xff008080)
				elseif Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, RDmg), 0xff008080)
				end
			end
		end
	end
end

function useQ(target)
	if GetDistance(target) < KogMawQ.range then
		if KogMawMenu.Prediction.PredictionQ:Value() == 1 then
			CastSkillShot(_Q,GetOrigin(target))
		elseif KogMawMenu.Prediction.PredictionQ:Value() == 2 then
			local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),KogMawQ.speed,KogMawQ.delay*1000,KogMawQ.range,KogMawQ.width,true,false)
			if QPred.HitChance == 1 then
				CastSkillShot(_Q, QPred.PredPos)
			end
		elseif KogMawMenu.Prediction.PredictionQ:Value() == 3 then
			local qPred = _G.gPred:GetPrediction(target,myHero,KogMawQ,false,true)
			if qPred and qPred.HitChance >= 3 then
				CastSkillShot(_Q, qPred.CastPosition)
			end
		elseif KogMawMenu.Prediction.PredictionQ:Value() == 4 then
			local QSpell = IPrediction.Prediction({name="KogMawQ", range=KogMawQ.range, speed=KogMawQ.speed, delay=KogMawQ.delay, width=KogMawQ.width, type="linear", collision=true})
			ts = TargetSelector()
			target = ts:GetTarget(KogMawQ.range)
			local x, y = QSpell:Predict(target)
			if x > 2 then
				CastSkillShot(_Q, y.x, y.y, y.z)
			end
		elseif KogMawMenu.Prediction.PredictionQ:Value() == 5 then
			local QPrediction = GetLinearAOEPrediction(target,KogMawQ)
			if QPrediction.hitChance > 0.9 then
				CastSkillShot(_Q, QPrediction.castPos)
			end
		end
	end
end
function useW(target)
	CastSpell(_W)
end
function useE(target)
	if GetDistance(target) < KogMawE.range then
		if KogMawMenu.Prediction.PredictionE:Value() == 1 then
			CastSkillShot(_E,GetOrigin(target))
		elseif KogMawMenu.Prediction.PredictionE:Value() == 2 then
			local EPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),KogMawE.speed,KogMawE.delay*1000,KogMawE.range,KogMawE.width,true,true)
			if EPred.HitChance == 1 then
				CastSkillShot(_E, EPred.PredPos)
			end
		elseif KogMawMenu.Prediction.PredictionE:Value() == 3 then
			local EPred = _G.gPred:GetPrediction(target,myHero,KogMawE,true,false)
			if EPred and EPred.HitChance >= 3 then
				CastSkillShot(_E, EPred.CastPosition)
			end
		elseif KogMawMenu.Prediction.PredictionE:Value() == 4 then
			local ESpell = IPrediction.Prediction({name="KogMawVoidOoze", range=KogMawE.range, speed=KogMawE.speed, delay=KogMawE.delay, width=KogMawE.width, type="linear", collision=false})
			ts = TargetSelector()
			target = ts:GetTarget(KogMawE.range)
			local x, y = ESpell:Predict(target)
			if x > 2 then
				CastSkillShot(_E, y.x, y.y, y.z)
			end
		elseif KogMawMenu.Prediction.PredictionE:Value() == 5 then
			local EPrediction = GetLinearAOEPrediction(target,KogMawE)
			if EPrediction.hitChance > 0.9 then
				CastSkillShot(_E, EPrediction.castPos)
			end
		end
	end
end
function useR(target)
	if GetDistance(target) < KogMawR.range then
		if KogMawMenu.Prediction.PredictionR:Value() == 1 then
			CastSkillShot(_R,GetOrigin(target))
		elseif KogMawMenu.Prediction.PredictionR:Value() == 2 then
			local RPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),KogMawR.speed,KogMawR.delay*1000,KogMawR.range,KogMawR.width,false,true)
			if RPred.HitChance == 1 then
				CastSkillShot(_R, RPred.PredPos)
			end
		elseif KogMawMenu.Prediction.PredictionR:Value() == 3 then
			local RPred = _G.gPred:GetPrediction(target,myHero,KogMawR,true,false)
			if RPred and RPred.HitChance >= 3 then
				CastSkillShot(_R, RPred.CastPosition)
			end
		elseif KogMawMenu.Prediction.PredictionR:Value() == 4 then
			local RSpell = IPrediction.Prediction({name="KogMawLivingArtillery", range=KogMawR.range, speed=KogMawR.speed, delay=KogMawR.delay, width=KogMawR.width, type="circular", collision=false})
			ts = TargetSelector()
			target = ts:GetTarget(KogMawR.range)
			local x, y = RSpell:Predict(target)
			if x > 2 then
				CastSkillShot(_R, y.x, y.y, y.z)
			end
		elseif KogMawMenu.Prediction.PredictionR:Value() == 5 then
			local RPrediction = GetLinearAOEPrediction(target,KogMawR)
			if RPrediction.hitChance > 0.9 then
				CastSkillShot(_R, RPrediction.castPos)
			end
		end
	end
end

-- Auto

function Auto()
	if KogMawMenu.Auto.UseQ:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KogMawMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if ValidTarget(target, KogMawQ.range) then
					useQ(target)
				end
			end
		end
	end
	if KogMawMenu.Auto.UseR:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KogMawMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_R) == READY then
				if ValidTarget(target, KogMawR.range) then
					useR(target)
				end
			end
		end
	end
end

-- Combo

function Combo()
	if Mode() == "Combo" then
		if KogMawMenu.Combo.UseQ:Value() then
			if CanUseSpell(myHero,_Q) == READY and AA == true then
				if ValidTarget(target, KogMawQ.range) then
					useQ(target)
				end
			end
		end
		if KogMawMenu.Combo.UseW:Value() then
			if CanUseSpell(myHero,_W) == READY then
				if ValidTarget(target, GetRange(myHero)+GetHitBox(myHero)) then
					useW(target)
				end
			end
		end
		if KogMawMenu.Combo.UseE:Value() then
			if CanUseSpell(myHero,_E) == READY and AA == true then
				if ValidTarget(target, KogMawE.range) then
					useE(target)
				end
			end
		end
		if KogMawMenu.Combo.UseR:Value() then
			if CanUseSpell(myHero,_R) == READY then
				if ValidTarget(target, KogMawR.range) then
					useR(target)
				end
			end
		end
	end
end

-- Harass

function Harass()
	if Mode() == "Harass" then
		if KogMawMenu.Harass.UseQ:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KogMawMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_Q) == READY and AA == true then
					if ValidTarget(target, KogMawQ.range) then
						useQ(target)
					end
				end
			end
		end
		if KogMawMenu.Harass.UseW:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KogMawMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_W) == READY then
					if ValidTarget(target, GetRange(myHero)+GetHitBox(myHero)) then
						useW(target)
					end
				end
			end
		end
		if KogMawMenu.Harass.UseE:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KogMawMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_E) == READY and AA == true then
					if ValidTarget(target, KogMawE.range) then
						useE(target)
					end
				end
			end
		end
		if KogMawMenu.Harass.UseR:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KogMawMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_R) == READY then
					if ValidTarget(target, KogMawR.range) then
						useR(target)
					end
				end
			end
		end
	end
end

-- KillSteal

function KillSteal()
	for i,enemy in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_E) == READY then
			if KogMawMenu.KillSteal.UseE:Value() then
				if ValidTarget(enemy, KogMawE.range) then
					local KogMawEDmg = (45*GetCastLevel(myHero,_E)+15)+(0.5*GetBonusAP(myHero))
					if (GetCurrentHP(enemy)+GetMagicResist(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*4) < KogMawEDmg then
						useE(enemy)
					end
				end
			end
		elseif CanUseSpell(myHero,_R) == READY then
			if KogMawMenu.KillSteal.UseR:Value() then
				if ValidTarget(enemy, KogMawR.range) then
					local KogMawRDmg = ((40*GetCastLevel(myHero,_R)+60)+(0.65*GetBonusDmg(myHero))+(0.25*GetBonusAP(myHero)))*(GetPercentHP(enemy) < 25 and 3 or (GetPercentHP(enemy) < 50 and 2 or 1))
					if (GetCurrentHP(enemy)+GetMagicResist(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*4) < KogMawRDmg then
						useR(enemy)
					end
				end
			end
		end
	end
end

-- LastHit

function LastHit()
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if ValidTarget(minion, KogMawQ.range) then
					if KogMawMenu.LastHit.UseQ:Value() then
						if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KogMawMenu.LastHit.MP:Value() then
							if CanUseSpell(myHero,_Q) == READY then
								local KogMawQDmg = (50*GetCastLevel(myHero,_Q)+30)+(0.5*GetBonusAP(myHero))
								if GetCurrentHP(minion) < KogMawQDmg then
									local QPredMin = GetLinearAOEPrediction(minion,KogMawQ)
									if QPredMin.hitChance > 0.9 then
										CastSkillShot(_Q, QPredMin.castPos)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

-- LaneClear

function LaneClear()
	if Mode() == "LaneClear" then
		if KogMawMenu.LaneClear.UseE:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KogMawMenu.LaneClear.MP:Value() then
				if CanUseSpell(myHero,_E) == READY and AA == true then
					local BestPos, BestHit = GetLineFarmPosition(KogMawE.range, KogMawE.radius, MINION_ENEMY)
					if BestPos and BestHit > 5 then
						CastSkillShot(_E, BestPos)
					end
				end
			end
		end
		if KogMawMenu.LaneClear.UseR:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KogMawMenu.LaneClear.MP:Value() then
				if CanUseSpell(myHero,_R) == READY then
					local BestPos, BestHit = GetFarmPosition(KogMawR.range, KogMawR.radius, MINION_ENEMY)
					if BestPos and BestHit > 3 then
						CastSkillShot(_R, BestPos)
					end
				end
			end
		end
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if KogMawMenu.LaneClear.UseQ:Value() then
					if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KogMawMenu.LaneClear.MP:Value() then
						if ValidTarget(minion, KogMawQ.range) then
							if CanUseSpell(myHero,_Q) == READY and AA == true then
								CastSkillShot(_Q, GetOrigin(minion))
							end
						end
					end
				end
				if KogMawMenu.LaneClear.UseW:Value() then
					if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KogMawMenu.LaneClear.MP:Value() then
						if ValidTarget(minion, GetRange(myHero)+GetHitBox(myHero)) then
							if CanUseSpell(myHero,_W) == READY then
								CastSpell(_W)
							end
						end
					end
				end
			end
		end
	end
end

function AntiGapcloser()
	for i,antigap in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_E) == READY then
			if KogMawMenu.AntiGapcloser.UseE:Value() then
				if ValidTarget(antigap, KogMawMenu.AntiGapcloser.Distance:Value()) then
					useE(antigap)
				end
			end
		end
	end
end

-- Lucian

elseif "Lucian" == GetObjectName(myHero) then

PrintChat("<font color='#1E90FF'>[<font color='#00BFFF'>GoS-U<font color='#1E90FF'>] <font color='#00BFFF'>Lucian loaded successfully!")
local LucianMenu = Menu("[GoS-U] Lucian", "[GoS-U] Lucian")
LucianMenu:Menu("Auto", "Auto")
LucianMenu.Auto:Boolean('UseQ', 'Use Q [Piercing Light]', true)
LucianMenu.Auto:Boolean('UseQEx', 'Use Extended Q', true)
LucianMenu.Auto:Boolean('UseW', 'Use W [Ardent Blaze]', false)
LucianMenu.Auto:Slider("MP","Mana-Manager", 40, 0, 100, 5)
LucianMenu:Menu("Combo", "Combo")
LucianMenu.Combo:Boolean('UseQ', 'Use Q [Piercing Light]', true)
LucianMenu.Combo:Boolean('UseQEx', 'Use Extended Q', true)
LucianMenu.Combo:Boolean('UseW', 'Use W [Ardent Blaze]', true)
LucianMenu.Combo:Boolean('UseE', 'Use E [Relentless Pursuit]', true)
LucianMenu.Combo:Boolean('UseR', 'Use R [The Culling]', true)
LucianMenu.Combo:DropDown("ModeE", "Cast Mode: E", 2, {"Gapclose To Target", "Mouse Position"})
LucianMenu.Combo:Slider('X','Minimum Enemies: R', 1, 0, 5, 1)
LucianMenu.Combo:Slider('HP','HP-Manager: R', 40, 0, 100, 5)
LucianMenu:Menu("Harass", "Harass")
LucianMenu.Harass:Boolean('UseQ', 'Use Q [Piercing Light]', true)
LucianMenu.Harass:Boolean('UseQEx', 'Use Extended Q', true)
LucianMenu.Harass:Boolean('UseW', 'Use W [Ardent Blaze]', true)
LucianMenu.Harass:Boolean('UseE', 'Use E [Relentless Pursuit]', false)
LucianMenu.Harass:DropDown("ModeE", "Cast Mode: E", 2, {"Gapclose To Target", "Mouse Position"})
LucianMenu.Harass:Slider("MP","Mana-Manager", 40, 0, 100, 5)
LucianMenu:Menu("KillSteal", "KillSteal")
LucianMenu.KillSteal:Boolean('UseW', 'Use W [Ardent Blaze]', true)
LucianMenu:Menu("LaneClear", "LaneClear")
LucianMenu.LaneClear:Boolean('UseQ', 'Use Q [Piercing Light]', true)
LucianMenu.LaneClear:Boolean('UseW', 'Use W [Ardent Blaze]', false)
LucianMenu.LaneClear:Slider("MP","Mana-Manager", 40, 0, 100, 5)
LucianMenu:Menu("Prediction", "Prediction")
LucianMenu.Prediction:DropDown("PredictionW", "Prediction: W", 2, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
LucianMenu:Menu("Drawings", "Drawings")
LucianMenu.Drawings:Boolean('DrawQ', 'Draw Q Range', true)
LucianMenu.Drawings:Boolean('DrawW', 'Draw W Range', true)
LucianMenu.Drawings:Boolean('DrawE', 'Draw E Range', true)
LucianMenu.Drawings:Boolean('DrawR', 'Draw R Range', true)
LucianMenu.Drawings:Boolean('DrawDMG', 'Draw Max QWR Damage', false)
LucianMenu:Menu("Misc", "Misc")
LucianMenu.Misc:Slider("EW","Extra Windup", 1, 0, 50, 1)

local LucianQ = { range = 500 }
local LucianQExtended = { range = 900 , delay = 0.4, speed = math.huge, width = 60, collision = false, aoe = false, type = "linear" }
local LucianW = { range = 900, radius = 65, width = 130, speed = 1600, delay = 0.25, type = "line", collision = true, source = myHero, col = {"minion","yasuowall"}}
local LucianE = { range = 425 }
local LucianR = { range = 1200 }
local GTimerR = 0
local QCast = false
local WCast = false
local ECast = false
local RCast = false

OnTick(function(myHero)
	Auto()
	Combo()
	Harass()
	KillSteal()
	LaneClear()
end)
OnDraw(function(myHero)
	Ranges()
	DrawDamage()
end)

function Ranges()
local pos = GetOrigin(myHero)
if LucianMenu.Drawings.DrawQ:Value() then DrawCircle(pos,LucianQ.range,1,25,0xff00bfff) end
if LucianMenu.Drawings.DrawW:Value() then DrawCircle(pos,LucianW.range,1,25,0xff4169e1) end
if LucianMenu.Drawings.DrawE:Value() then DrawCircle(pos,LucianE.range,1,25,0xff1e90ff) end
if LucianMenu.Drawings.DrawR:Value() then DrawCircle(pos,LucianR.range,1,25,0xff0000ff) end
end

function DrawDamage()
	for _, enemy in pairs(GetEnemyHeroes()) do
		local QDmg = (35*GetCastLevel(myHero,_Q)+50)+((0.1*GetCastLevel(myHero,_Q)+0.5)*GetBonusDmg(myHero))
		local WDmg = (40*GetCastLevel(myHero,_W)+45)+(0.9*GetBonusAP(myHero))
		local RDmg = ((15*GetCastLevel(myHero,_R)+5)+(0.25*(GetBonusDmg(myHero)+GetBaseDamage(myHero)))+(0.1*GetBonusAP(myHero)))*(5*GetCastLevel(myHero,_R)+15)
		local ComboDmg = QDmg + WDmg + RDmg
		local WRDmg = WDmg + RDmg
		local QRDmg = QDmg + RDmg
		local QWDmg = QDmg + WDmg
		if ValidTarget(enemy) then
			if LucianMenu.Drawings.DrawDMG:Value() then
				if Ready(_Q) and Ready(_W) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ComboDmg), 0xff008080)
				elseif Ready(_W) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WRDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QRDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_W) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QWDmg), 0xff008080)
				elseif Ready(_Q) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QDmg), 0xff008080)
				elseif Ready(_W) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WDmg), 0xff008080)
				elseif Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, RDmg), 0xff008080)
				end
			end
		end
	end
end

function useQ(target)
	CastTargetSpell(target, _Q)
end
local VectorExtend = function(v1, v2, distance)
	return v1 + distance * (v2 - v1):normalized()
end
function useQEx(target)
	local Pred = GetPrediction(target, LucianQExtended)
	local TargetPos = VectorExtend(Vector(myHero), Vector(Pred.castPos), LucianQExtended.range)
	if GetDistance(Pred.castPos) <= LucianQExtended.range then
		for i, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY and ValidTarget(minion, LucianQ.range) then
				local MinionPos = VectorExtend(Vector(myHero), Vector(minion), LucianQExtended.range)
        		if GetDistance(TargetPos, MinionPos) <= LucianQExtended.width then
        			CastTargetSpell(minion, _Q)
        		end
			end
		end
	end
end
function useW(target)
	if GetDistance(target) < LucianW.range then
		if LucianMenu.Prediction.PredictionW:Value() == 1 then
			CastSkillShot(_W,GetOrigin(target))
		elseif LucianMenu.Prediction.PredictionW:Value() == 2 then
			local WPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),LucianW.speed,LucianW.delay*1000,LucianW.range,LucianW.width,true,true)
			if WPred.HitChance == 1 then
				CastSkillShot(_W, WPred.PredPos)
			end
		elseif LucianMenu.Prediction.PredictionW:Value() == 3 then
			local WPred = _G.gPred:GetPrediction(target,myHero,LucianW,true,false)
			if WPred and WPred.HitChance >= 3 then
				CastSkillShot(_W, WPred.castPosition)
			end
		elseif LucianMenu.Prediction.PredictionW:Value() == 4 then
			local WSpell = IPrediction.Prediction({name="LucianW", range=LucianW.range, speed=LucianW.speed, delay=LucianW.delay, width=LucianW.width, type="linear", collision=true})
			ts = TargetSelector()
			target = ts:GetTarget(LucianW.range)
			local x, y = WSpell:Predict(target)
			if x > 2 then
				CastSkillShot(_W, y.x, y.y, y.z)
			end
		elseif LucianMenu.Prediction.PredictionW:Value() == 5 then
			local WPrediction = GetLinearAOEPrediction(target,LucianW)
			if WPrediction.hitChance > 0.9 then
				CastSkillShot(_W, WPrediction.castPos)
			end
		end
	end
end
OnProcessSpell(function(unit,spell)
	if unit == myHero then
		if spell.name == "LucianQ" then
			QCast = true
			DelayAction(function() QCast = false end, spell.windUpTime+(LucianMenu.Misc.EW:Value()/100))
		end
		if spell.name == "LucianW" then
			WCast = true
			DelayAction(function() WCast = false end, spell.windUpTime+(LucianMenu.Misc.EW:Value()/100))
		end
		if spell.name == "LucianE" then
			ECast = true
			if _G.IOW then
				IOW:ResetAA()
			elseif _G.GoSWalkLoaded then
				_G.GoSWalk:ResetAttack()
			elseif _G.DAC_Loaded then
				DAC:ResetAA()
			elseif _G.AutoCarry_Loaded then
				DACR:ResetAA()
			end
			DelayAction(function() ECast = false end, spell.windUpTime+(LucianMenu.Misc.EW:Value()/100))
		end
		if spell.name == "LucianR" then
			if _G.IOW then
				IOW.attacksEnabled = false
			elseif _G.GoSWalkLoaded then
				_G.GoSWalk:EnableAttack(false)
			elseif _G.DAC_Loaded then
				DAC:AttacksEnabled(false)
			elseif _G.AutoCarry_Loaded then
				DACR.attacksEnabled = false
			end
			RCast = true
			DelayAction(function()
				RCast = false
				if _G.IOW then
					IOW.attacksEnabled = true
				elseif _G.GoSWalkLoaded then
					_G.GoSWalk:EnableAttack(true)
				elseif _G.DAC_Loaded then
					DAC:AttacksEnabled(true)
				elseif _G.AutoCarry_Loaded then
					DACR.attacksEnabled = true
				end
			end, 3+(LucianMenu.Misc.EW:Value()/100))
		end
	end
end)

-- Auto

function Auto()
	if LucianMenu.Auto.UseQ:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > LucianMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if ValidTarget(target, LucianQ.range) then
					useQ(target)
				end
			end
		end
	end
	if LucianMenu.Auto.UseQEx:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > LucianMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if ValidTarget(target, LucianQExtended.range) then
					useQEx(target)
				end
			end
		end
	end
	if LucianMenu.Auto.UseW:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > LucianMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_W) == READY then
				if ValidTarget(target, LucianW.range) then
					useW(target)
				end
			end
		end
	end
end

-- Combo

function Combo()
	if Mode() == "Combo" then
		if LucianMenu.Combo.UseQ:Value() then
			if CanUseSpell(myHero,_Q) == READY and AA == true and not WCast and not ECast and not RCast then
				if ValidTarget(target, LucianQ.range) then
					useQ(target)
				end
			end
		end
		if LucianMenu.Combo.UseQEx:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if ValidTarget(target, LucianQExtended.range) then
					useQEx(target)
				end
			end
		end
		if LucianMenu.Combo.UseW:Value() then
			if CanUseSpell(myHero,_W) == READY and AA == true and not QCast and not ECast and not RCast then
				if ValidTarget(target, LucianW.range) then
					useW(target)
				end
			end
		end
		if LucianMenu.Combo.UseE:Value() then
			if CanUseSpell(myHero,_E) == READY and AA == true and not QCast and not WCast and not RCast then
				if ValidTarget(target, LucianE.range+GetRange(myHero)+GetHitBox(myHero)) then
					if LucianMenu.Combo.ModeE:Value() == 1 then
						CastSkillShot(_E, GetOrigin(target))
					elseif LucianMenu.Combo.ModeE:Value() == 2 then
						CastSkillShot(_E, GetMousePos())
					end
				end
			end
		end
		if LucianMenu.Combo.UseR:Value() then
			if CanUseSpell(myHero,_R) == READY and not QCast and not WCast and not ECast then
				if ValidTarget(target, LucianR.range) then
					if 100*GetCurrentHP(target)/GetMaxHP(target) < LucianMenu.Combo.HP:Value() then
						if EnemiesAround(myHero, LucianR.range+GetRange(myHero)) >= LucianMenu.Combo.X:Value() then
							local TimerR = GetTickCount()
							if (GTimerR + 3000) < TimerR then
								CastSkillShot(_R, GetOrigin(target))
								GTimerR = TimerR
							end
						end
					end
				end
			end
		end
	end
end

-- Harass

function Harass()
	if Mode() == "Harass" then
		if LucianMenu.Harass.UseQ:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > LucianMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_Q) == READY and AA == true and not WCast and not ECast and not RCast then
					if ValidTarget(target, LucianQ.range) then
						useQ(target)
					end
				end
			end
		end
		if LucianMenu.Harass.UseQEx:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > LucianMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(target, LucianQExtended.range) then
						useQEx(target)
					end
				end
			end
		end
		if LucianMenu.Harass.UseW:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > LucianMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_W) == READY and AA == true and not QCast and not ECast and not RCast then
					if ValidTarget(target, LucianW.range) then
						useW(target)
					end
				end
			end
		end
		if LucianMenu.Harass.UseE:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > LucianMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_E) == READY and AA == true and not QCast and not WCast and not RCast then
					if ValidTarget(target, LucianE.range+GetRange(myHero)+GetHitBox(myHero)) then
						if LucianMenu.Combo.ModeE:Value() == 1 then
							CastSkillShot(_E, GetOrigin(target))
						elseif LucianMenu.Combo.ModeE:Value() == 2 then
							CastSkillShot(_E, GetMousePos())
						end
					end
				end
			end
		end
	end
end

-- KillSteal

function KillSteal()
	for i,enemy in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_W) == READY then
			if LucianMenu.KillSteal.UseW:Value() then
				if ValidTarget(enemy, LucianW.range) then
					local LucianWDmg = (40*GetCastLevel(myHero,_W)+20)+(0.9*GetBonusAP(myHero))
					if (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*4) < LucianWDmg then
						useW(enemy)
					end
				end
			end
		end
	end
end

-- LaneClear

function LaneClear()
	if Mode() == "LaneClear" then
		if LucianMenu.LaneClear.UseW:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > LucianMenu.LaneClear.MP:Value() then
				if CanUseSpell(myHero,_W) == READY then
					local BestPos, BestHit = GetFarmPosition(LucianW.range, LucianW.radius, MINION_ENEMY)
					if BestPos and BestHit > 3 then  
						CastSkillShot(_W, BestPos)
					end
				end
			end
		end
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if LucianMenu.LaneClear.UseQ:Value() then
					if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > LucianMenu.LaneClear.MP:Value() then
						if ValidTarget(minion, LucianQ.range) then
							if CanUseSpell(myHero,_Q) == READY then
								CastTargetSpell(minion, _Q)
							end
						end
					end
				end
			end
		end
	end
end

-- MissFortune

elseif "MissFortune" == GetObjectName(myHero) then

PrintChat("<font color='#1E90FF'>[<font color='#00BFFF'>GoS-U<font color='#1E90FF'>] <font color='#00BFFF'>MissFortune loaded successfully!")
local MissFortuneMenu = Menu("[GoS-U] MissFortune", "[GoS-U] MissFortune")
MissFortuneMenu:Menu("Auto", "Auto")
MissFortuneMenu.Auto:Boolean('UseQ', 'Use Q [Double Up]', true)
MissFortuneMenu.Auto:Boolean('UseQEx', 'Use Extended Q', true)
MissFortuneMenu.Auto:Boolean('UseE', 'Use E [Make It Rain]', true)
MissFortuneMenu.Auto:Slider("MP","Mana-Manager", 40, 0, 100, 5)
MissFortuneMenu:Menu("Combo", "Combo")
MissFortuneMenu.Combo:Boolean('UseQ', 'Use Q [Double Up]', true)
MissFortuneMenu.Combo:Boolean('UseQEx', 'Use Extended Q', true)
MissFortuneMenu.Combo:Boolean('UseW', 'Use W [Strut]', true)
MissFortuneMenu.Combo:Boolean('UseE', 'Use E [Make It Rain]', true)
MissFortuneMenu.Combo:Boolean('UseR', 'Use R [Bullet Time]', true)
MissFortuneMenu.Combo:Slider('X','Minimum Enemies: R', 1, 0, 5, 1)
MissFortuneMenu.Combo:Slider('HP','HP-Manager: R', 40, 0, 100, 5)
MissFortuneMenu:Menu("Harass", "Harass")
MissFortuneMenu.Harass:Boolean('UseQ', 'Use Q [Double Up]', true)
MissFortuneMenu.Harass:Boolean('UseQEx', 'Use Extended Q', true)
MissFortuneMenu.Harass:Boolean('UseW', 'Use W [Strut]', true)
MissFortuneMenu.Harass:Boolean('UseE', 'Use E [Make It Rain]', false)
MissFortuneMenu.Harass:Slider("MP","Mana-Manager", 40, 0, 100, 5)
MissFortuneMenu:Menu("KillSteal", "KillSteal")
MissFortuneMenu.KillSteal:Boolean('UseQ', 'Use Q [Double Up]', true)
MissFortuneMenu.KillSteal:Boolean('UseQEx', 'Use Extended Q', true)
MissFortuneMenu:Menu("LastHit", "LastHit")
MissFortuneMenu.LastHit:Boolean('UseQ', 'Use Q [Double Up]', false)
MissFortuneMenu.LastHit:Slider("MP","Mana-Manager", 40, 0, 100, 5)
MissFortuneMenu:Menu("LaneClear", "LaneClear")
MissFortuneMenu.LaneClear:Boolean('UseQ', 'Use Q [Double Up]', false)
MissFortuneMenu.LaneClear:Boolean('UseE', 'Use E [Make It Rain]', true)
MissFortuneMenu.LaneClear:Slider("MP","Mana-Manager", 40, 0, 100, 5)
MissFortuneMenu:Menu("AntiGapcloser", "Anti-Gapcloser")
MissFortuneMenu.AntiGapcloser:Boolean('UseE', 'Use E [Make It Rain]', false)
MissFortuneMenu.AntiGapcloser:Slider('Distance','Distance: E', 400, 25, 500, 25)
MissFortuneMenu:Menu("Prediction", "Prediction")
MissFortuneMenu.Prediction:DropDown("PredictionE", "Prediction: E", 5, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
MissFortuneMenu.Prediction:DropDown("PredictionR", "Prediction: R", 5, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
MissFortuneMenu:Menu("Drawings", "Drawings")
MissFortuneMenu.Drawings:Boolean('DrawQ', 'Draw Q Range', true)
MissFortuneMenu.Drawings:Boolean('DrawE', 'Draw E Range', true)
MissFortuneMenu.Drawings:Boolean('DrawR', 'Draw R Range', true)
MissFortuneMenu.Drawings:Boolean('DrawDMG', 'Draw Max QWR Damage', false)

local MissFortuneQ = { range = 650, radius = 500 }
local MissFortuneE = { range = 1000, radius = 400, width = 800, speed = math.huge, delay = 0.5, type = "circular", collision = false, source = myHero }
local MissFortuneR = { range = 1400, width = 350, speed = math.huge, delay = 0.001 }
local MFGTimer = 0

OnTick(function(myHero)
	Auto()
	Combo()
	Harass()
	KillSteal()
	LastHit()
	LaneClear()
end)
OnDraw(function(myHero)
	Ranges()
	DrawDamage()
end)

function Ranges()
local pos = GetOrigin(myHero)
if MissFortuneMenu.Drawings.DrawQ:Value() then DrawCircle(pos,MissFortuneQ.range,1,25,0xff00bfff) end
if MissFortuneMenu.Drawings.DrawE:Value() then DrawCircle(pos,MissFortuneE.range,1,25,0xff1e90ff) end
if MissFortuneMenu.Drawings.DrawR:Value() then DrawCircle(pos,MissFortuneR.range,1,25,0xff0000ff) end
end

function DrawDamage()
	local QDmg = (20*GetCastLevel(myHero,_Q))+(GetBaseDamage(myHero)+GetBonusDmg(myHero))+(0.35*GetBonusAP(myHero))
	local EDmg = (35*GetCastLevel(myHero,_E)+45)+(0.8*GetBonusAP(myHero))
	local RDmg = (1.5*(GetBaseDamage(myHero)+GetBonusDmg(myHero))+7.5)+(0.4*GetBonusAP(myHero)+2)
	local ComboDmg = QDmg + EDmg + RDmg
	local QRDmg = QDmg + RDmg
	local ERDmg = EDmg + RDmg
	local QEDmg = QDmg + EDmg
	for _, enemy in pairs(GetEnemyHeroes()) do
		if ValidTarget(enemy) then
			if MissFortuneMenu.Drawings.DrawDMG:Value() then
				if Ready(_Q) and Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ComboDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QRDmg), 0xff008080)
				elseif Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ERDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QEDmg), 0xff008080)
				elseif Ready(_Q) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QDmg), 0xff008080)
				elseif Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, EDmg), 0xff008080)
				elseif Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, RDmg), 0xff008080)
				end
			end
		end
	end
end

function useQ(target)
	CastTargetSpell(target, _Q)
end
function useQEx(target)
	for i,minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if ValidTarget(minion, MissFortuneQ.range) and GetDistance(minion, target) < MissFortuneQ.radius then
				local QPos = myHero+(VectorWay(myHero,minion)/GetDistance(myHero,minion))*775
				local QPred = GetPredictionForPlayer(myHero,target,GetMoveSpeed(target),1400,250,MissFortuneQ.range+MissFortuneQ.radius,1,false,false)
				if QPred.HitChance == 1 and GetDistance(QPred.PredPos, QPos) < 250 then
					CastTargetSpell(minion, _Q)
				end
			end
		end
	end
end
function useE(target)
	if GetDistance(target) < MissFortuneE.range then
		if MissFortuneMenu.Prediction.PredictionE:Value() == 1 then
			CastSkillShot(_E,GetOrigin(target))
		elseif MissFortuneMenu.Prediction.PredictionE:Value() == 2 then
			local EPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),MissFortuneE.speed,MissFortuneE.delay*1000,MissFortuneE.range,MissFortuneE.width,false,true)
			if EPred.HitChance == 1 then
				CastSkillShot(_E, EPred.PredPos)
			end
		elseif MissFortuneMenu.Prediction.PredictionE:Value() == 3 then
			local EPred = _G.gPred:GetPrediction(target,myHero,MissFortuneE,true,false)
			if EPred and EPred.HitChance >= 3 then
				CastSkillShot(_W, WPred.CastPosition)
			end
		elseif MissFortuneMenu.Prediction.PredictionE:Value() == 4 then
			local WSpell = IPrediction.Prediction({name="MissFortuneScattershot", range=MissFortuneE.range, speed=MissFortuneE.speed, delay=MissFortuneE.delay, width=MissFortuneE.width, type="circular", collision=false})
			ts = TargetSelector()
			target = ts:GetTarget(MissFortuneE.range)
			local x, y = ESpell:Predict(target)
			if x > 2 then
				CastSkillShot(_E, y.x, y.y, y.z)
			end
		elseif MissFortuneMenu.Prediction.PredictionE:Value() == 5 then
			local EPrediction = GetCircularAOEPrediction(target,MissFortuneE)
			if EPrediction.hitChance > 0.9 then
				CastSkillShot(_E, EPrediction.castPos)
			end
		end
	end
end

OnSpellCast(function(_Q)
	if GotBuff(myHero,"missfortunebulletsound") > 0 then
		BlockCast()
	end
end)
OnSpellCast(function(_W)
	if GotBuff(myHero,"missfortunebulletsound") > 0 then
		BlockCast()
	end
end)
OnSpellCast(function(_E)
	if GotBuff(myHero,"missfortunebulletsound") > 0 then
		BlockCast()
	end
end)

-- Auto

function Auto()
	if MissFortuneMenu.Auto.UseQ:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > MissFortuneMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if ValidTarget(target, MissFortuneQ.range) then
					useQ(target)
				end
			end
		end
	end
	if MissFortuneMenu.Auto.UseQEx:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > MissFortuneMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if ValidTarget(target, MissFortuneQ.range+MissFortuneQ.radius) then
					useQEx(target)
				end
			end
		end
	end
	if MissFortuneMenu.Auto.UseE:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > MissFortuneMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_E) == READY then
				if ValidTarget(target, MissFortuneE.range) then
					useE(target)
				end
			end
		end
	end
end

-- Combo

function Combo()
	if Mode() == "Combo" then
		if MissFortuneMenu.Combo.UseQ:Value() then
			if CanUseSpell(myHero,_Q) == READY and AA == true then
				if ValidTarget(target, MissFortuneQ.range) then
					useQ(target)
				end
			end
		end
		if MissFortuneMenu.Combo.UseQEx:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if ValidTarget(target, MissFortuneQ.range+MissFortuneQ.radius) then
					useQEx(target)
				end
			end
		end
		if MissFortuneMenu.Combo.UseW:Value() then
			if CanUseSpell(myHero,_W) == READY then
				if ValidTarget(target, GetRange(myHero)+GetHitBox(myHero)) then
					CastSpell(_W)
				end
			end
		end
		if MissFortuneMenu.Combo.UseE:Value() then
			if CanUseSpell(myHero,_E) == READY and AA == true then
				if ValidTarget(target, MissFortuneE.range) then
					useE(target)
				end
			end
		end
		if MissFortuneMenu.Combo.UseR:Value() then
			if CanUseSpell(myHero,_R) == READY then
				if ValidTarget(target, MissFortuneR.range) then
					if 100*GetCurrentHP(target)/GetMaxHP(target) < MissFortuneMenu.Combo.HP:Value() then
						if EnemiesAround(myHero, MissFortuneR.range+GetRange(myHero)) >= MissFortuneMenu.Combo.X:Value() then
							local RPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),MissFortuneR.speed,MissFortuneR.delay*1000,MissFortuneR.range,MissFortuneR.width,false,false)
							if RPred.HitChance == 1 then
								BlockF7OrbWalk(true)
								BlockF7Dodge(true)
								BlockInput(true)
								if _G.IOW then
									IOW.movementEnabled = false
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableMovement(false)
									_G.GoSWalk:EnableAttack(false)
								elseif _G.DAC_Loaded then
									DAC:MovementEnabled(false)
									DAC:AttacksEnabled(false)
								elseif _G.AutoCarry_Loaded then
									DACR.movementEnabled = false
									DACR.attacksEnabled = false
								end
								CastSkillShot(_R, RPred.PredPos)
								DelayAction(function()
									BlockF7OrbWalk(false)
									BlockF7Dodge(false)
									BlockInput(false)
									if _G.IOW then
										IOW.movementEnabled = true
										IOW.attacksEnabled = true
									elseif _G.GoSWalkLoaded then
										_G.GoSWalk:EnableMovement(true)
										_G.GoSWalk:EnableAttack(true)
									elseif _G.DAC_Loaded then
										DAC:MovementEnabled(true)
										DAC:AttacksEnabled(true)
									elseif _G.AutoCarry_Loaded then
										DACR.movementEnabled = true
										DACR.attacksEnabled = true
									end
								end, 3)
							end
						end
					end
				end
			end
		end
	end
end

-- Harass

function Harass()
	if Mode() == "Harass" then
		if MissFortuneMenu.Harass.UseQ:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > MissFortuneMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_Q) == READY and AA == true then
					if ValidTarget(target, MissFortuneQ.range) then
						useQ(target)
					end
				end
			end
		end
		if MissFortuneMenu.Harass.UseQEx:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > MissFortuneMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(target, MissFortuneQ.range+MissFortuneQ.radius) then
						useQEx(target)
					end
				end
			end
		end
		if MissFortuneMenu.Harass.UseW:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > MissFortuneMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_W) == READY then
					if ValidTarget(target, MissFortuneW.range) then
						useW(target)
					end
				end
			end
		end
		if MissFortuneMenu.Harass.UseE:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > MissFortuneMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_E) == READY and AA == true then
					if ValidTarget(target, GetRange(myHero)+GetHitBox(myHero)) then
						useE(target)
					end
				end
			end
		end
	end
end

-- KillSteal

function KillSteal()
	for i,enemy in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_Q) == READY then
			if MissFortuneMenu.KillSteal.UseQ:Value() then
				if ValidTarget(enemy, MissFortuneQ.range) then
					local MissFortuneQDmg = (20*GetCastLevel(myHero,_Q))+(GetBaseDamage(myHero)+GetBonusDmg(myHero))+(0.35*GetBonusAP(myHero))
					if (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*4) < MissFortuneQDmg then
						useQ(enemy)
					end
				end
			end
			if MissFortuneMenu.KillSteal.UseQEx:Value() then
				if ValidTarget(enemy, MissFortuneQ.range+MissFortuneQ.radius) then
					local MissFortuneQExDmg = (20*GetCastLevel(myHero,_Q))+(2.5*(GetBaseDamage(myHero)+GetBonusDmg(myHero)))+(0.35*GetBonusAP(myHero))
					if (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*4) < MissFortuneQExDmg then
						useQEx(enemy)
					end
				end
			end
		end
	end
end

-- LastHit

function LastHit()
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if ValidTarget(minion, MissFortuneQ.range) then
					if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > MissFortuneMenu.LastHit.MP:Value() then
						if MissFortuneMenu.LastHit.UseQ:Value() then
							if CanUseSpell(myHero,_Q) == READY then
								local MissFortuneQDmg = (20*GetCastLevel(myHero,_Q))+(GetBaseDamage(myHero)+GetBonusDmg(myHero))+(0.35*GetBonusAP(myHero))
								if GetCurrentHP(minion)+GetDmgShield(minion) < MissFortuneQDmg then
									CastTargetSpell(minion, _Q)
								end
							end
						end
					end
				end
			end
		end
	end
end

-- LaneClear

function LaneClear()
	if Mode() == "LaneClear" then
		if MissFortuneMenu.LaneClear.UseE:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > MissFortuneMenu.LaneClear.MP:Value() then
				if CanUseSpell(myHero,_E) == READY then
					local BestPos, BestHit = GetFarmPosition(MissFortuneE.range, MissFortuneE.radius, MINION_ENEMY)
					if BestPos and BestHit > 3 then  
						CastSkillShot(_E, BestPos)
					end
				end
			end
		end
		if MissFortuneMenu.LaneClear.UseQ:Value() then
			for _, minion in pairs(minionManager.objects) do
				if GetTeam(minion) == MINION_ENEMY then
					if ValidTarget(minion, MissFortuneQ.range) then
						if CanUseSpell(myHero,_Q) == READY then
							CastTargetSpell(minion, _Q)
						end
					end
				end
			end
		end
	end
end

-- Anti-Gapcloser

function AntiGapcloser()
	for i,antigap in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_E) == READY then
			if MissFortuneMenu.AntiGapcloser.UseE:Value() then
				if ValidTarget(antigap, MissFortuneMenu.AntiGapcloser.Distance:Value()) then
					useE(antigap)
				end
			end
		end
	end
end

function VectorWay(A,B)
	WayX = B.x - A.x
	WayY = B.y - A.y
	WayZ = B.z - A.z
	return Vector(WayX, WayY, WayZ)
end

-- Sivir

elseif "Sivir" == GetObjectName(myHero) then

PrintChat("<font color='#1E90FF'>[<font color='#00BFFF'>GoS-U<font color='#1E90FF'>] <font color='#00BFFF'>Sivir loaded successfully!")
local SivirMenu = Menu("[GoS-U] Sivir", "[GoS-U] Sivir")
SivirMenu:Menu("Auto", "Auto")
SivirMenu.Auto:Boolean('UseQ', 'Use Q [Boomerang Blade]', true)
SivirMenu.Auto:Boolean('UseE', 'Use E [Spell Shield]', true)
SivirMenu.Auto:Slider("HP","Block Only CC When >%HP", 40, 0, 100, 5)
SivirMenu.Auto:Slider("MP","Mana-Manager: Q", 40, 0, 100, 5)
SivirMenu:Menu("Blocklist", "Blocklist")
SivirMenu.Blocklist:Boolean('BA', 'Block AOE Spells', true)
SivirMenu.Blocklist:Boolean('BC', 'Block Circular Spells', true)
SivirMenu.Blocklist:Boolean('BL', 'Block Linear Spells', true)
SivirMenu.Blocklist:Boolean('BT', 'Block Targeted Spells', true)
SivirMenu:Menu("Combo", "Combo")
SivirMenu.Combo:Boolean('UseQ', 'Use Q [Boomerang Blade]', true)
SivirMenu.Combo:Boolean('UseW', 'Use W [Ricochet]', true)
SivirMenu.Combo:Boolean('UseR', 'Use R [On The Hunt]', true)
SivirMenu.Combo:Slider('Distance','Distance: R', 1500, 100, 2000, 50)
SivirMenu.Combo:Slider('X','Minimum Enemies: R', 1, 0, 5, 1)
SivirMenu.Combo:Slider('HP','HP-Manager: R', 40, 0, 100, 5)
SivirMenu:Menu("Harass", "Harass")
SivirMenu.Harass:Boolean('UseQ', 'Use Q [Boomerang Blade]', true)
SivirMenu.Harass:Boolean('UseW', 'Use W [Ricochet]', true)
SivirMenu.Harass:Slider("MP","Mana-Manager", 40, 0, 100, 5)
SivirMenu:Menu("KillSteal", "KillSteal")
SivirMenu.KillSteal:Boolean('UseQ', 'Use Q [Boomerang Blade]', true)
SivirMenu:Menu("LaneClear", "LaneClear")
SivirMenu.LaneClear:Boolean('UseQ', 'Use Q [Boomerang Blade]', true)
SivirMenu.LaneClear:Boolean('UseW', 'Use W [Ricochet]', true)
SivirMenu.LaneClear:Slider("MP","Mana-Manager", 40, 0, 100, 5)
SivirMenu:Menu("Prediction", "Prediction")
SivirMenu.Prediction:DropDown("PredictionQ", "Prediction: Q", 2, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
SivirMenu:Menu("Drawings", "Drawings")
SivirMenu.Drawings:Boolean('DrawQ', 'Draw Q Range', true)
SivirMenu.Drawings:Boolean('DrawDMG', 'Draw Max QW Damage', true)

local SivirQ = { range = 1250, radius = 75, width = 150, speed = 1350, delay = 0.25, type = "line", collision = false, source = myHero, col = {"yasuowall"}}

OnTick(function(myHero)
	target = GetCurrentTarget()
	Auto()
	LineE()
	Combo()
	Harass()
	KillSteal()
	LaneClear()
end)
OnDraw(function(myHero)
	Ranges()
	DrawDamage()
end)

function Ranges()
local pos = GetOrigin(myHero)
if SivirMenu.Drawings.DrawQ:Value() then DrawCircle(pos,SivirQ.range,1,25,0xff00bfff) end
end

function DrawDamage()
	for _, enemy in pairs(GetEnemyHeroes()) do
		local QDmg = (37*GetCastLevel(myHero,_Q)+27.75)+((0.185*GetCastLevel(myHero,_Q)+1.11)*(GetBonusDmg(myHero)+GetBaseDamage(myHero)))+(0.925*GetBonusAP(myHero))
		local WDmg = (0.15*GetCastLevel(myHero,_W)+1.35)*(GetBonusDmg(myHero)+GetBaseDamage(myHero))
		local ComboDmg = QDmg + WDmg
		if ValidTarget(enemy) then
			if SivirMenu.Drawings.DrawDMG:Value() then
				if Ready(_Q) and Ready(_W) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ComboDmg), 0xff008080)
				elseif Ready(_Q) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QDmg), 0xff008080)
				elseif Ready(_W) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WDmg), 0xff008080)
				end
			end
		end
	end
end

function useQ(target)
	if GetDistance(target) < SivirQ.range then
		if SivirMenu.Prediction.PredictionQ:Value() == 1 then
			CastSkillShot(_Q,GetOrigin(target))
		elseif SivirMenu.Prediction.PredictionQ:Value() == 2 then
			local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),SivirQ.speed,SivirQ.delay*1000,SivirQ.range,SivirQ.width,false,true)
			if QPred.HitChance == 1 then
				CastSkillShot(_Q, QPred.PredPos)
			end
		elseif SivirMenu.Prediction.PredictionQ:Value() == 3 then
			local qPred = _G.gPred:GetPrediction(target,myHero,SivirQ,false,true)
			if qPred and qPred.HitChance >= 3 then
				CastSkillShot(_Q, qPred.CastPosition)
			end
		elseif SivirMenu.Prediction.PredictionQ:Value() == 4 then
			local QSpell = IPrediction.Prediction({name="SivirQ", range=SivirQ.range, speed=SivirQ.speed, delay=SivirQ.delay, width=SivirQ.width, type="linear", collision=false})
			ts = TargetSelector()
			target = ts:GetTarget(SivirQ.range)
			local x, y = QSpell:Predict(target)
			if x > 2 then
				CastSkillShot(_Q, y.x, y.y, y.z)
			end
		elseif SivirMenu.Prediction.PredictionQ:Value() == 5 then
			local QPrediction = GetLinearAOEPrediction(target,SivirQ)
			if QPrediction.hitChance > 0.9 then
				CastSkillShot(_Q, QPrediction.castPos)
			end
		end
	end
end

-- Auto

function Auto()
	if SivirMenu.Auto.UseQ:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > SivirMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if ValidTarget(target, SivirQ.range) then
					useQ(target)
				end
			end
		end
	end
end

Block = {
["AatroxQ"] = { slot = _Q, champName = "Aatrox", SType = "circular", SSpeed = 450, SRange = 650, SDelay = 250, SRadius = 275, CC = true }, 
["AatroxE"] = { slot = _E , champName = "Aatrox", SType = "linear", SSpeed = 1200, SRange = 1000, SDelay = 250, SRadius = 120, CC = true }, 
["AhriSeduce"] = { slot = _E, champName = "Ahri", SType = "linear", SSpeed = 1600, SRange = 975, SDelay = 250, SRadius = 50, CC = true }, 
["Pulverize"] = { slot = _Q, champName = "Alistar", SType = "aoe", SRange = 365, CC = true }, 
["Headbutt"] = { slot = _W, champName = "Alistar", SType = "target", SRange = 650, CC = true }, 
["BandageToss"] = { slot = _Q, champName = "Amumu", SType = "linear", SSpeed = 2000, SRange = 1100, SDelay = 250, SRadius = 70, CC = true }, 
["CurseoftheSadMummy"] = { slot = _R, champName = "Amumu", SType = "aoe", SRange = 550, CC = true }, 
["FlashFrost"] = { slot = _Q, champName = "Anivia", SType = "linear", SSpeed = 850, SRange = 1075, SDelay = 250, SRadius = 225, CC = true }, 
["Frostbite"] = { slot = _E, champName = "Anivia", SType = "target", SRange = 1000, CC = false }, 
["Disintegrate"] = { slot = _Q, champName = "Annie", SType = "target", SRange = 625, CC = false }, 
["Incinerate"] = { slot = _W, champName = "Annie", SType = "aoe", SRange = 625, CC = false }, 
["InfernalGuardian"] = { slot = _R, champName = "Annie", SType = "circular", SSpeed = math.huge, SRange = 600, SDelay = 250, SRadius = 290, CC = true }, 
["Volley"] = { slot = _W, champName = "Ashe", SType = "linear", SSpeed = 2000, SRange = 1200, SDelay = 250, SRadius = 20, CC = true }, 
["EnchantedCrystalArrow"] = { slot = _R, champName = "Ashe", SType = "linear", SSpeed = 1600, SRange = 25000, SDelay = 250, SRadius = 125, CC = true }, 
["AurelionSolQ"] = { slot = _Q, champName = "AurelionSol", SType = "linear", SSpeed = 600, SRange = 1075, SDelay = 250, SRadius = 210, CC = true }, 
["AurelionSolR"] = { slot = _R, champName = "AurelionSol", SType = "linear", SSpeed = 4285, SRange = 1500, SDelay = 350, SRadius = 120, CC = true }, 
["AzirE"] = { slot = _E, champName = "Azir", SType = "aoe", SRange = 1100, CC = false }, 
["AzirR"] = { slot = _R, champName = "Azir", SType = "aoe", SRange = 250, CC = true }, 
["BardQ"] = { slot = _Q, champName = "Bard", SType = "linear", SSpeed = 1500, SRange = 950, SDelay = 250, SRadius = 80, CC = true }, 
["RocketGrab"] = { slot = _Q, champName = "Blitzcrank", SType = "linear", SSpeed = 1750, SRange = 925, SDelay = 250, SRadius = 60, CC = true }, 
["StaticField"] = { slot = _R, champName = "Blitzcrank", SType = "aoe", SRange = 600, CC = true }, 
["BrandQ"] = { slot = _Q, champName = "Brand", SType = "linear", SSpeed = 1550, SRange = 1050, SDelay = 250, SRadius = 65, CC = true }, 
["BrandW"] = { slot = _W, champName = "Brand", SType = "circular", SSpeed = math.huge, SRange = 900, SDelay = 625, SRadius = 250, CC = false }, 
["BrandE"] = { slot = _E, champName = "Brand", SType = "target", SRange = 625, CC = false }, 
["BrandR"] = { slot = _R, champName = "Brand", SType = "target", SRange = 750, CC = true }, 
["BraumQ"] = { slot = _Q, champName = "Braum", SType = "linear", SSpeed = 1670, SRange = 1000, SDelay = 250, SRadius = 60, CC = true }, 
["BraumRWrapper"] = { slot = _R, champName = "Braum", SType = "linear", SSpeed = 1400, SRange = 1250, SDelay = 500, SRadius = 115, CC = true }, 
["CaitlynPiltoverPeacemaker"] = { slot = _Q, champName = "Caitlyn", SType = "linear", SSpeed = 2200, SRange = 1250, SDelay = 625, SRadius = 90, CC = false }, 
["CaitlynYordleTrap"] = { slot = _W, champName = "Caitlyn", SType = "circular", SSpeed = math.huge, SRange = 800, SDelay = 250, SRadius = 75, CC = true }, 
["CaitlynEntrapmentMissile"] = { slot = _E, champName = "Caitlyn", SType = "linear", SSpeed = 1500, SRange = 750, SDelay = 250, SRadius = 60, CC = true }, 
["CaitlynAceintheHole"] = { slot = _R, champName = "Caitlyn", SType = "target", SRange = 3000, CC = false }, 
["CamilleW"] = { slot = _W, champName = "Camille", SType = "aoe", SRange = 610, CC = true }, 
["CamilleE"] = { slot = _E, champName = "Camille", SType = "linear", SSpeed = 1350, SRange = 800, SDelay = 250, SRadius = 45, CC = true }, 
["CassiopeiaQ"] = { slot = _Q, champName = "Cassiopeia", SType = "circular", SSpeed = math.huge, SRange = 850, SDelay = 400, SRadius = 150, CC = false }, 
["CassiopeiaE"] = { slot = _E, champName = "Cassiopeia", SType = "target", SRange = 700, CC = false }, 
["CassiopeiaR"] = { slot = _R, champName = "Cassiopeia", SType = "aoe", SRange = 825, CC = true }, 
["Rupture"] = { slot = _Q, champName = "ChoGath", SType = "circular", SSpeed = math.huge, SRange = 950, SDelay = 500, SRadius = 175, CC = true }, 
["FeralScream"] = { slot = _W, champName = "ChoGath", SType = "aoe", SRange = 650, CC = true }, 
["Feast"] = { slot = _R, champName = "ChoGath", SType = "target", SRange = 175, CC = false }, 
["PhosphorusBomb"] = { slot = _Q, champName = "Corki", SType = "circular", SSpeed = 1000, SRange = 825, SDelay = 250, SRadius = 250, CC = false }, 
["MissileBarrageMissile"] = { slot = _R, champName = "Corki", SType = "linear", SSpeed = 1950, SRange = 1225, SDelay = 175, SRadius = 35, CC = false }, 
["MissileBarrageMissile2"] = { slot = _R, champName = "Corki", SType = "linear", SSpeed = 1950, SRange = 1225, SDelay = 175, SRadius = 35, CC = false }, 
["DariusCleave"] = { slot = _Q, champName = "Darius", SType = "circular", SSpeed = math.huge, SRange = 1, SDelay = 750, SRadius = 425, CC = false }, 
["DariusAxeGrabCone"] = { slot = _E, champName = "Darius", SType = "aoe", SRange = 535, CC = true }, 
["DariusExecute"] = { slot = _R, champName = "Darius", SType = "target", SRange = 460, CC = false }, 
["DianaArc"] = { slot = _Q, champName = "Diana", SType = "circular", SSpeed = 1400, SRange = 900, SDelay = 250, SRadius = 205, CC = false }, 
["DianaOrbs"] = { slot = _W, champName = "Diana", SType = "aoe", SRange = 200, CC = false }, 
["DianaVortex"] = { slot = _E, champName = "Diana", SType = "aoe", SRange = 450, CC = true }, 
["DianaTeleport"] = { slot = _R, champName = "Diana", SType = "target", SRange = 825, CC = false }, 
["InfectedCleaverMissileCast"] = { slot = _Q, champName = "DrMundo", SType = "linear", SSpeed = 1850, SRange = 975, SDelay = 250, SRadius = 60, CC = true }, 
["DravenDoubleShot"] = { slot = _E, champName = "Draven", SType = "linear", SSpeed = 1400, SRange = 1050, SDelay = 250, SRadius = 120, CC = true }, 
["DravenRCast"] = { slot = _R, champName = "Draven", SType = "linear", SSpeed = 2000, SRange = 25000, SDelay = 500, SRadius = 130, CC = false }, 
["EkkoW"] = { slot = _W, champName = "Ekko", SType = "circular", SSpeed = 1650, SRange = 1600, SDelay = 3750, SRadius = 400, CC = true }, 
["EkkoR"] = { slot = _R, champName = "Ekko", SType = "circular", SSpeed = 1650, SRange = 1600, SDelay = 250, SRadius = 375, CC = true }, 
["EliseSpiderQCast"] = { slot = _Q, champName = "Elise", SType = "target", SRange = 475, CC = false }, 
["EliseHumanQ"] = { slot = _Q, champName = "Elise", SType = "target", SRange = 625, CC = false }, 
["EliseHumanE"] = { slot = _E, champName = "Elise", SType = "linear", SSpeed = 1600, SRange = 1075, SDelay = 250, SRadius = 55, CC = true }, 
["EvelynnQ"] = { slot = _Q, champName = "Evelynn", SType = "linear", SSpeed = 2200, SRange = 800, SDelay = 250, SRadius = 35, CC = false }, 
["EvelynnE"] = { slot = _E, champName = "Evelynn", SType = "target", SRange = 800, CC = false }, 
["EvelynnR"] = { slot = _R, champName = "Evelynn", SType = "aoe", SRange = 450, CC = false }, 
["EzrealMysticShot"] = { slot = _Q, champName = "Ezreal", SType = "linear", SSpeed = 2000, SRange = 1150, SDelay = 250, SRadius = 80, CC = false }, 
["EzrealEssenceFlux"] = { slot = _W, champName = "Ezreal", SType = "linear", SSpeed = 1550, SRange = 1000, SDelay = 250, SRadius = 80, CC = false }, 
["EzrealTrueshotBarrage"] = { slot = _R, champName = "Ezreal", SType = "linear", SSpeed = 2000, SRange = 25000, SDelay = 1000, SRadius = 160, CC = false }, 
["Terrify"] = { slot = _Q, champName = "Fiddlesticks", SType = "target", SRange = 575, CC = true }, 
["DarkWind"] = { slot = _E, champName = "Fiddlesticks", SType = "target", SRange = 750, CC = true }, 
["FioraQ"] = { slot = _Q, champName = "Fiora", SType = "linear", SSpeed = 800, SRange = 400, SDelay = 0, SRadius = 50, CC = false }, 
["FioraW"] = { slot = _W, champName = "Fiora", SType = "linear", SSpeed = math.huge, SRange = 750, SDelay = 750, SRadius = 85, CC = true }, 
["FioraR"] = { slot = _R, champName = "Fiora", SType = "target", SRange = 500, CC = false }, 
["FizzQ"] = { slot = _Q, champName = "Fizz", SType = "target", SRange = 550, CC = false }, 
["FizzE"] = { slot = _E, champName = "Fizz", SType = "circular", SSpeed = math.huge, SRange = 400, SDelay = 750, SRadius = 330, CC = true }, 
["FizzR"] = { slot = _R, champName = "Fizz", SType = "linear", SSpeed = 1300, SRange = 1300, SDelay = 250, SRadius = 120, CC = true }, 
["GalioW"] = { slot = _W, champName = "Galio", SType = "aoe", SRange = 350, CC = true }, 
["GalioE"] = { slot = _E, champName = "Galio", SType = "linear", SSpeed = 1400, SRange = 650, SDelay = 450, SRadius = 160, CC = true }, 
["GalioR"] = { slot = _R, champName = "Galio", SType = "circular", SSpeed = math.huge, SRange = 5500, SDelay = 2750, SRadius = 500, CC = true }, 
["GangplankQ"] = { slot = _Q, champName = "Gangplank", SType = "target", SRange = 625, CC = false }, 
["GangplankR"] = { slot = _R, champName = "Gangplank", SType = "circular", SSpeed = math.huge, SRange = 25000, SDelay = 250, SRadius = 600, CC = true }, 
["GarenR"] = { slot = _R, champName = "Garen", SType = "target", SRange = 400, CC = false }, 
["GnarQ"] = { slot = _Q, champName = "Gnar", SType = "linear", SSpeed = 1700, SRange = 1100, SDelay = 250, SRadius = 55, CC = true }, 
["GnarE"] = { slot = _Q, champName = "Gnar", SType = "circular", SSpeed = 900, SRange = 475, SDelay = 250, SRadius = 160, CC = true }, 
["GnarE"] = { slot = _Q, champName = "Gnar", SType = "circular", SSpeed = 900, SRange = 475, SDelay = 250, SRadius = 160, CC = true }, 
["GnarBigQ"] = { slot = _Q, champName = "Gnar", SType = "linear", SSpeed = 2100, SRange = 1100, SDelay = 500, SRadius = 90, CC = true }, 
["GnarBigW"] = { slot = _W, champName = "Gnar", SType = "linear", SSpeed = math.huge, SRange = 550, SDelay = 600, SRadius = 100, CC = true }, 
["GnarBigE"] = { slot = _E, champName = "Gnar", SType = "circular", SSpeed = 800, SRange = 600, SDelay = 250, SRadius = 375, CC = true }, 
["GnarR"] = { slot = _R, champName = "Gnar", SType = "aoe", SRange = 475, CC = true }, 
["GragasQ"] = { slot = _Q, champName = "Gragas", SType = "circular", SSpeed = 1000, SRange = 850, SDelay = 250, SRadius = 250, CC = true }, 
["GragasE"] = { slot = _E, champName = "Gragas", SType = "linear", SSpeed = 900, SRange = 600, SDelay = 250, SRadius = 170, CC = true }, 
["GragasR"] = { slot = _R, champName = "Gragas", SType = "circular", SSpeed = 1800, SRange = 1000, SDelay = 250, SRadius = 400, CC = true }, 
["GravesChargeShot"] = { slot = _R, champName = "Graves", SType = "linear", SSpeed = 1950, SRange = 1000, SDelay = 250, SRadius = 100, CC = false }, 
["GravesChargeShotFxMissile"] = { slot = _R, champName = "Graves", SType = "aoe", SRange = 800, CC = false }, 
["HecarimRapidSlash"] = { slot = _Q, champName = "Hecarim", SType = "aoe", SRange = 350, CC = false }, 
["HecarimUlt"] = { slot = _R, champName = "Hecarim", SType = "linear", SSpeed = 1200, SRange = 1000, SDelay = 10, SRadius = 210, CC = true }, 
["HeimerdingerW"] = { slot = _W, champName = "Heimerdinger", SType = "linear", SSpeed = 2050, SRange = 1325, SDelay = 250, SRadius = 70, CC = false }, 
["HeimerdingerE"] = { slot = _E, champName = "Heimerdinger", SType = "circular", SSpeed = 1200, SRange = 970, SDelay = 250, SRadius = 250, CC = true }, 
["HeimerdingerEUlt"] = { slot = _E, champName = "Heimerdinger", SType = "circular", SSpeed = 1200, SRange = 970, SDelay = 250, SRadius = 250, CC = true }, 
["IllaoiQ"] = { slot = _Q, champName = "Illaoi", SType = "linear", SSpeed = math.huge, SRange = 850, SDelay = 750, SRadius = 100, CC = false }, 
["IreliaBladesurge"] = { slot = _Q, champName = "Irelia", SType = "target", SRange = 650, CC = false }, 
["IreliaEquilibriumStrike"] = { slot = _E, champName = "Irelia", SType = "target", SRange = 325, CC = true }, 
["IreliaTranscendentBlades"] = { slot = _R, champName = "Irelia", SType = "linear", SSpeed = 1350, SRange = 1000, SDelay = 250, SRadius = 100, CC = false }, 
["IvernQ"] = { slot = _Q, champName = "Ivern", SType = "linear", SSpeed = 1300, SRange = 1075, SDelay = 250, SRadius = 50, CC = true }, 
["HowlingGale"] = { slot = _Q, champName = "Janna", SType = "linear", SSpeed = 667, SRange = 1000, SDelay = 0, SRadius = 100, CC = true }, 
["Zephyr"] = { slot = _W, champName = "Janna", SType = "target", SRange = 550, CC = true }, 
["ReapTheWhirlwind"] = { slot = _R, champName = "Janna", SType = "aoe", SRange = 725, CC = true }, 
["JarvanIVDragonStrike"] = { slot = _Q, champName = "JarvanIV", SType = "linear", SSpeed = math.huge, SRange = 770, SDelay = 400, SRadius = 60, CC = true }, 
["JarvanIVGoldenAegis"] = { slot = _W, champName = "JarvanIV", SType = "aoe", SRange = 625, CC = true }, 
["JarvanIVDemacianStandard"] = { slot = _E, champName = "JarvanIV", SType = "circular", SSpeed = 3440, SRange = 860, SDelay = 0, SRadius = 175, CC = false }, 
["JarvanIVCataclysm"] = { slot = _R, champName = "JarvanIV", SType = "target", SRange = 650, CC = true }, 
["JaxLeapStrike"] = { slot = _Q, champName = "Jax", SType = "target", SRange = 700, CC = false }, 
["JaxCounterStrike"] = { slot = _E, champName = "Jax", SType = "circular", SSpeed = math.huge, SRange = 1, SDelay = 1400, SRadius = 300, CC = true }, 
["JayceToTheSkies"] = { slot = _Q, champName = "Jayce", SType = "target", SRange = 600, CC = true }, 
["JayceThunderingBlow"] = { slot = _E, champName = "Jayce", SType = "target", SRange = 240, CC = true }, 
["JayceShockBlast"] = { slot = _Q, champName = "Jayce", SType = "linear", SSpeed = 1450, SRange = 1050, SDelay = 214, SRadius = 75, CC = false }, 
["JayceShockBlastWallMis"] = { slot = _Q, champName = "Jayce", SType = "linear", SSpeed = 1890, SRange = 2030, SDelay = 214, SRadius = 105, CC = false }, 
["JhinQ"] = { slot = _Q, champName = "Jhin", SType = "target", SRange = 550, CC = false }, 
["JhinW"] = { slot = _W, champName = "Jhin", SType = "linear", SSpeed = 5000, SRange = 3000, SDelay = 750, SRadius = 40, CC = true }, 
["JhinE"] = { slot = _E, champName = "Jhin", SType = "circular", SSpeed = 1650, SRange = 750, SDelay = 250, SRadius = 140, CC = true }, 
["JhinRShot"] = { slot = _R, champName = "Jhin", SType = "linear", SSpeed = 5000, SRange = 3500, SDelay = 250, SRadius = 80, CC = true }, 
["JinxW"] = { slot = _W, champName = "Jinx", SType = "linear", SSpeed = 3200, SRange = 1450, SDelay = 600, SRadius = 50, CC = true }, 
["JinxE"] = { slot = _E, champName = "Jinx", SType = "circular", SSpeed = 2570, SRange = 900, SDelay = 1500, SRadius = 100, CC = true }, 
["JinxR"] = { slot = _R, champName = "Jinx", SType = "linear", SSpeed = 1700, SRange = 25000, SDelay = 600, SRadius = 110, CC = false }, 
["KaisaQ"] = { slot = _Q, champName = "Kaisa", SType = "aoe", SRange = 575, CC = false }, 
["KaisaW"] = { slot = _W, champName = "Kaisa", SType = "linear", SSpeed = 1750, SRange = 3000, SDelay = 400, SRadius = 65, CC = false }, 
["KalistaMysticShot"] = { slot = _Q, champName = "Kalista", SType = "linear", SSpeed = 2100, SRange = 1150, SDelay = 350, SRadius = 35, CC = false }, 
["KarthusLayWasteA1"] = { slot = _Q, champName = "Karthus", SType = "circular", SSpeed = math.huge, SRange = 875, SDelay = 500, SRadius = 200, CC = false }, 
["KarthusLayWasteA2"] = { slot = _Q, champName = "Karthus", SType = "circular", SSpeed = math.huge, SRange = 875, SDelay = 500, SRadius = 200, CC = false }, 
["KarthusLayWasteA3"] = { slot = _Q, champName = "Karthus", SType = "circular", SSpeed = math.huge, SRange = 875, SDelay = 500, SRadius = 200, CC = false }, 
["NullSphere"] = { slot = _Q, champName = "Kassadin", SType = "target", SRange = 650, CC = false }, 
["ForcePulse"] = { slot = _E, champName = "Kassadin", SType = "aoe", SRange = 600, CC = true }, 
["Riftwalk"] = { slot = _R, champName = "Kassadin", SType = "circular", SSpeed = math.huge, SRange = 500, SDelay = 250, SRadius = 300, CC = false }, 
["KatarinaQ"] = { slot = _Q, champName = "Katarina", SType = "target", SRange = 625, CC = false }, 
["KatarinaE"] = { slot = _E, champName = "Katarina", SType = "circular", SSpeed = math.huge, SRange = 725, SDelay = 150, SRadius = 150, CC = false }, 
["KayleQ"] = { slot = _Q, champName = "Kayle", SType = "target", SRange = 650, CC = true }, 
["KaynW"] = { slot = _W, champName = "Kayn", SType = "linear", SSpeed = math.huge, SRange = 700, SDelay = 550, SRadius = 90, CC = true }, 
["KennenShurikenHurlMissile1"] = { slot = _Q, champName = "Kennen", SType = "linear", SSpeed = 1650, SRange = 1050, SDelay = 175, SRadius = 45, CC = true }, 
["KennenShurikenStorm"] = { slot = _R, champName = "Kennen", SType = "aoe", SRange = 550, CC = false }, 
["KhaZixQ"] = { slot = _Q, champName = "KhaZix", SType = "target", SRange = 375, CC = false }, 
["KhaZixW"] = { slot = _W, champName = "KhaZix", SType = "linear", SSpeed = 1650, SRange = 1000, SDelay = 250, SRadius = 60, CC = false }, 
["KhaZixWLong"] = { slot = _W, champName = "KhaZix", SType = "linear", SSpeed = 1650, SRange = 1000, SDelay = 250, SRadius = 70, CC = true }, 
["KhaZixE"] = { slot = _E, champName = "KhaZix", SType = "circular", SSpeed = 1400, SRange = 700, SDelay = 250, SRadius = 320, CC = false }, 
["KhaZixELong"] = { slot = _E, champName = "KhaZix", SType = "circular", SSpeed = 1400, SRange = 900, SDelay = 250, SRadius = 320, CC = false }, 
["KindredW"] = { slot = _W, champName = "Kindred", SType = "aoe", SRange = 800, CC = true }, 
["KindredE"] = { slot = _E, champName = "Kindred", SType = "target", SRange = 750, CC = true }, 
["KledRiderQ"] = { slot = _Q, champName = "Kled", SType = "aoe", SRange = 800, CC = false }, 
["KledEDash"] = { slot = _E, champName = "Kled", SType = "linear", SSpeed = 1100, SRange = 550, SDelay = 0, SRadius = 90, CC = false }, 
["KogMawQ"] = { slot = _Q, champName = "KogMaw", SType = "linear", SSpeed = 1600, SRange = 1175, SDelay = 250, SRadius = 60, CC = false }, 
["KogMawVoidOoze"] = { slot = _E, champName = "KogMaw", SType = "linear", SSpeed = 1350, SRange = 1280, SDelay = 250, SRadius = 115, CC = true }, 
["KogMawLivingArtillery"] = { slot = _R, champName = "KogMaw", SType = "circular", SSpeed = math.huge, SRange = 1800, SDelay = 850, SRadius = 200, CC = false }, 
["LeBlancQ"] = { slot = _Q, champName = "LeBlanc", SType = "target", SRange = 700, CC = false }, 
["LeBlancW"] = { slot = _W, champName = "LeBlanc", SType = "circular", SSpeed = 1600, SRange = 600, SDelay = 250, SRadius = 260, CC = false }, 
["LeBlancRW"] = { slot = _W, champName = "LeBlanc", SType = "circular", SSpeed = 1600, SRange = 600, SDelay = 250, SRadius = 260, CC = false }, 
["LeBlancE"] = { slot = _E, champName = "LeBlanc", SType = "linear", SSpeed = 1750, SRange = 925, SDelay = 250, SRadius = 55, CC = true }, 
["LeBlancRE"] = { slot = _E, champName = "LeBlanc", SType = "linear", SSpeed = 1750, SRange = 925, SDelay = 250, SRadius = 55, CC = true }, 
["BlinkMonkQOne"] = { slot = _Q, champName = "LeeSin", SType = "linear", SSpeed = 1750, SRange = 1100, SDelay = 250, SRadius = 50, CC = false }, 
["BlinkMonkEOne"] = { slot = _E, champName = "LeeSin", SType = "aoe", SRange = 350, CC = true }, 
["BlinkMonkR"] = { slot = _R, champName = "LeeSin", SType = "target", SRange = 375, CC = true }, 
["LeonaZenithBlade"] = { slot = _E, champName = "Leona", SType = "linear", SSpeed = 2000, SRange = 875, SDelay = 250, SRadius = 70, CC = true }, 
["LeonaSolarFlare"] = { slot = _R, champName = "Leona", SType = "circular", SSpeed = math.huge, SRange = 1200, SDelay = 625, SRadius = 250, CC = true }, 
["LissandraQ"] = { slot = _Q, champName = "Lissandra", SType = "linear", SSpeed = 2400, SRange = 825, SDelay = 251, SRadius = 65, CC = true }, 
["LissandraW"] = { slot = _W, champName = "Lissandra", SType = "aoe", SRange = 450, CC = true }, 
["LissandraE"] = { slot = _E, champName = "Lissandra", SType = "linear", SSpeed = 850, SRange = 1050, SDelay = 250, SRadius = 100, CC = false }, 
["LissandraR"] = { slot = _R, champName = "Lissandra", SType = "target", SRange = 550, CC = true }, 
["LucianQ"] = { slot = _Q, champName = "Lucian", SType = "linear", SSpeed = math.huge, SRange = 900, SDelay = 500, SRadius = 65, CC = false }, 
["LucianW"] = { slot = _W, champName = "Lucian", SType = "linear", SSpeed = 1600, SRange = 900, SDelay = 250, SRadius = 65, CC = false }, 
["LucianR"] = { slot = _R, champName = "Lucian", SType = "linear", SSpeed = 2800, SRange = 1200, SDelay = 10, SRadius = 75, CC = false }, 
["LuluQ"] = { slot = _Q, champName = "Lulu", SType = "linear", SSpeed = 1500, SRange = 925, SDelay = 250, SRadius = 45, CC = true }, 
["LuluW"] = { slot = _W, champName = "Lulu", SType = "target", SRange = 650, CC = true }, 
["LuluE"] = { slot = _E, champName = "Lulu", SType = "target", SRange = 650, CC = false }, 
["LuxLightBinding"] = { slot = _Q, champName = "Lux", SType = "linear", SSpeed = 1200, SRange = 1175, SDelay = 250, SRadius = 60, CC = true }, 
["LuxLightStrikeKugel"] = { slot = _E, champName = "Lux", SType = "circular", SSpeed = 1300, SRange = 1000, SDelay = 250, SRadius = 350, CC = true }, 
["LuxMaliceCannon"] = { slot = _R, champName = "Lux", SType = "linear", SSpeed = math.huge, SRange = 3340, SDelay = 1000, SRadius = 115, CC = false }, 
["MalphiteQ"] = { slot = _Q, champName = "Malphite", SType = "target", SRange = 625, CC = true }, -- Check
["Landslide"] = { slot = _E, champName = "Malphite", SType = "aoe", SRange = 200, CC = true }, 
["UFSlash"] = { slot = _R, champName = "Malphite", SType = "circular", SSpeed = 2170, SRange = 1000, SDelay = 0, SRadius = 300, CC = true }, 
["MalzaharQ"] = { slot = _Q, champName = "Malzahar", SType = "circular", SSpeed = math.huge, SRange = 900, SDelay = 250, SRadius = 100, CC = true }, 
["MalzaharE"] = { slot = _E, champName = "Malzahar", SType = "target", SRange = 650, CC = false }, 
["MalzaharR"] = { slot = _R, champName = "Malzahar", SType = "target", SRange = 700, CC = true }, 
["MaokaiQ"] = { slot = _Q, champName = "Maokai", SType = "linear", SSpeed = 1600, SRange = 600, SDelay = 375, SRadius = 150, CC = true }, 
["MaokaiE"] = { slot = _E, champName = "Maokai", SType = "target", SRange = 525, CC = true }, 
["MaokaiR"] = { slot = _R, champName = "Maokai", SType = "linear", SSpeed = 450, SRange = 3000, SDelay = 500, SRadius = 650, CC = true }, 
["AlphaStrike"] = { slot = _Q, champName = "MasterYi", SType = "target", SRange = 600, CC = false }, 
["MissFortuneQ"] = { slot = _Q, champName = "MissFortune", SType = "target", SRange = 650, CC = false }, -- Check
["MordekaiserSiphonOfDestruction"] = { slot = _E, champName = "Mordekaiser", SType = "aoe", SRange = 675, CC = false }, 
["MordekaiserChildrenoftheGrave"] = { slot = _R, champName = "Mordekaiser", SType = "target", SRange = 650, CC = false }, -- Check
["DarkBinding"] = { slot = _Q, champName = "Morgana", SType = "linear", SSpeed = 1200, SRange = 1175, SDelay = 250, SRadius = 60, CC = true }, 
["NamiQ"] = { slot = _Q, champName = "Nami", SType = "circular", SSpeed = math.huge, SRange = 875, SDelay = 950, SRadius = 200, CC = true }, 
["NamiW"] = { slot = _W, champName = "Nami", SType = "target", SRange = 725, CC = false }, 
["NamiR"] = { slot = _R, champName = "Nami", SType = "linear", SSpeed = 850, SRange = 2750, SDelay = 500, SRadius = 215, CC = true }, 
["NasusW"] = { slot = _W, champName = "Nasus", SType = "target", SRange = 600, CC = true }, 
["NautilusAnchorDrag"] = { slot = _Q, champName = "Nautilus", SType = "linear", SSpeed = 2000, SRange = 1100, SDelay = 250, SRadius = 75, CC = true }, 
["NautilusSplashZone"] = { slot = _E, champName = "Nautilus", SType = "aoe", SRange = 600, CC = true }, 
["NautilusR"] = { slot = _R, champName = "Nautilus", SType = "target", SRange = 825, CC = true }, 
["JavelinToss"] = { slot = _Q, champName = "Nidalee", SType = "linear", SSpeed = 1300, SRange = 1500, SDelay = 250, SRadius = 45, CC = false }, 
["Bushwhack"] = { slot = _W, champName = "Nidalee", SType = "circular", SSpeed = math.huge, SRange = 900, SDelay = 250, SRadius = 85, CC = true }, 
["Pounce"] = { slot = _W, champName = "Nidalee", SType = "circular", SSpeed = 1750, SRange = 750, SDelay = 250, SRadius = 200, CC = false }, 
["Swipe"] = { slot = _E, champName = "Nidalee", SType = "aoe", SRange = 300, CC = false }, 
["NocturneDuskbringer"] = { slot = _Q, champName = "Nocturne", SType = "linear", SSpeed = 1600, SRange = 1200, SDelay = 250, SRadius = 60, CC = false }, 
["IceBlast"] = { slot = _E, champName = "Nunu", SType = "target", SRange = 550, CC = true }, 
["AbsoluteZero"] = { slot = _R, champName = "Nunu", SType = "circular", SSpeed = math.huge, SRange = 1, SDelay = 3010, SRadius = 650, CC = true }, 
["OlafAxeThrowCast"] = { slot = _Q, champName = "Olaf", SType = "linear", SSpeed = 1550, SRange = 1000, SDelay = 250, SRadius = 80, CC = true }, 
["OlafRecklessStrike"] = { slot = _E, champName = "Olaf", SType = "target", SRange = 325, CC = false }, 
["OrianaIzunaCommand"] = { slot = _Q, champName = "Orianna", SType = "linear", SSpeed = 1400, SRange = 825, SDelay = 250, SRadius = 175, CC = false }, 
["OrianaRedactCommand"] = { slot = _E, champName = "Orianna", SType = "linear", SSpeed = 1400, SRange = 1100, SDelay = 250, SRadius = 55, CC = false }, 
["OrnnQ"] = { slot = _Q, champName = "Ornn", SType = "linear", SSpeed = 2000, SRange = 800, SDelay = 300, SRadius = 100, CC = true }, 
["OrnnE"] = { slot = _E, champName = "Ornn", SType = "linear", SSpeed = 1780, SRange = 800, SDelay = 350, SRadius = 150, CC = true }, 
["OrnnR"] = { slot = _R, champName = "Ornn", SType = "linear", SSpeed = 1200, SRange = 2500, SDelay = 500, SRadius = 225, CC = true }, 
["PantheonQ"] = { slot = _Q, champName = "Pantheon", SType = "target", SRange = 600, CC = false }, 
["PantheonW"] = { slot = _W, champName = "Pantheon", SType = "target", SRange = 600, CC = true }, 
["PantheonE"] = { slot = _E, champName = "Pantheon", SType = "aoe", SRange = 600, CC = false }, 
["PantheonR"] = { slot = _R, champName = "Pantheon", SType = "circular", SSpeed = math.huge, SRange = 5500, SDelay = 2500, SRadius = 700, CC = true }, 
["PoppyW"] = { slot = _W, champName = "Poppy", SType = "aoe", SRange = 400, CC = true }, 
["PoppyE"] = { slot = _E, champName = "Poppy", SType = "target", SRange = 425, CC = true }, 
["PoppyRSpell"] = { slot = _R, champName = "Poppy", SType = "linear", SSpeed = 1600, SRange = 1900, SDelay = 600, SRadius = 80, CC = true }, 
["QuinnQ"] = { slot = _Q, champName = "Quinn", SType = "linear", SSpeed = 1550, SRange = 1025, SDelay = 250, SRadius = 50, CC = false }, 
["QuinnE"] = { slot = _E, champName = "Quinn", SType = "target", SRange = 675, CC = true }, 
["RakanQ"] = { slot = _Q, champName = "Rakan", SType = "linear", SSpeed = 1800, SRange = 900, SDelay = 250, SRadius = 60, CC = false }, 
["RakanW"] = { slot = _W, champName = "Rakan", SType = "circular", SSpeed = 2150, SRange = 600, SDelay = 0, SRadius = 250, CC = true }, 
["PuncturingTaunt"] = { slot = _E, champName = "Rammus", SType = "target", SRange = 325, CC = true }, 
["Tremors2"] = { slot = _R, champName = "Rammus", SType = "aoe", SRange = 300, CC = true }, 
["RekSaiQBurrowed"] = { slot = _Q, champName = "RekSai", SType = "linear", SSpeed = 2100, SRange = 1650, SDelay = 125, SRadius = 50, CC = false }, 
["RekSaiWBurrowed"] = { slot = _W, champName = "RekSai", SType = "aoe", SRange = 160, CC = true }, 
["RekSaiE"] = { slot = _E, champName = "RekSai", SType = "target", SRange = 250, CC = false }, 
["RenektonCleave"] = { slot = _Q, champName = "Renekton", SType = "aoe", SRange = 325, CC = false }, 
["RenektonSliceAndDice"] = { slot = _Q, champName = "Renekton", SType = "linear", SSpeed = 1125, SRange = 450, SDelay = 250, SRadius = 45, CC = false }, 
["RengarW"] = { slot = _W, champName = "Rengar", SType = "aoe", SRange = 450, CC = false }, 
["RengarE"] = { slot = _E, champName = "Rengar", SType = "linear", SSpeed = 1500, SRange = 1000, SDelay = 250, SRadius = 60, CC = true }, 
["RivenTriCleave"] = { slot = _Q, champName = "Riven", SType = "circular", SSpeed = 1100, SRange = 260, SDelay = 250, SRadius = 200, CC = true }, 
["RivenMartyr"] = { slot = _W, champName = "Riven", SType = "aoe", SRange = 135, CC = true }, 
["RivenIzunaBlade"] = { slot = _R, champName = "Riven", SType = "aoe", SRange = 900, CC = false }, 
["RumbleGrenade"] = { slot = _E, champName = "Rumble", SType = "linear", SSpeed = 2000, SRange = 850, SDelay = 250, SRadius = 70, CC = true }, 
["RyzeQ"] = { slot = _Q, champName = "Ryze", SType = "linear", SSpeed = 1700, SRange = 1000, SDelay = 250, SRadius = 50, CC = false }, 
["RyzeW"] = { slot = _W, champName = "Ryze", SType = "target", SRange = 615, CC = true }, 
["RyzeE"] = { slot = _E, champName = "Ryze", SType = "target", SRange = 615, CC = false }, 
["SejuaniQ"] = { slot = _Q, champName = "Sejuani", SType = "linear", SSpeed = 1300, SRange = 650, SDelay = 250, SRadius = 150, CC = true }, 
["ShacoE"] = { slot = _E, champName = "Shaco", SType = "target", SRange = 625, CC = true }, -- Check
["ShenE"] = { slot = _E, champName = "Shen", SType = "linear", SSpeed = 1200, SRange = 600, SDelay = 0, SRadius = 60, CC = true }, 
["ShyvanaFireball"] = { slot = _E, champName = "Shyvana", SType = "linear", SSpeed = 1575, SRange = 925, SDelay = 250, SRadius = 60, CC = false }, 
["ShyvanaFireballDragon2"] = { slot = _E, champName = "Shyvana", SType = "linear", SSpeed = 1575, SRange = 925, SDelay = 333, SRadius = 60, CC = false }, 
["ShyvanaTransformLeap"] = { slot = _R, champName = "Shyvana", SType = "linear", SSpeed = 1130, SRange = 850, SDelay = 250, SRadius = 60, CC = true }, 
["Fling"] = { slot = _E, champName = "Singed", SType = "target", SRange = 125, CC = true }, -- Check
["SionQ"] = { slot = _Q, champName = "Sion", SType = "linear", SSpeed = math.huge, SRange = 600, SDelay = 0, SRadius = 300, CC = true }, 
["SionW"] = { slot = _W, champName = "Sion", SType = "circular", SSpeed = math.huge, SRange = 1, SDelay = 3000, SRadius = 550, CC = false }, 
["SionE"] = { slot = _E, champName = "Sion", SType = "linear", SSpeed = 1900, SRange = 725, SDelay = 250, SRadius = 80, CC = true }, 
["SionR"] = { slot = _R, champName = "Sion", SType = "linear", SSpeed = 950, SRange = 7500, SDelay = 125, SRadius = 200, CC = true }, 
["SivirQ"] = { slot = _Q, champName = "Sivir", SType = "linear", SSpeed = 1350, SRange = 1250, SDelay = 250, SRadius = 75, CC = false }, 
["SkarnerVirulentSlash"] = { slot = _Q, champName = "Skarner", SType = "aoe", SRange = 350, CC = false }, 
["SkarnerFracture"] = { slot = _E, champName = "Skarner", SType = "linear", SSpeed = 1500, SRange = 1000, SDelay = 250, SRadius = 70, CC = true }, 
["SkarnerImpale"] = { slot = _R, champName = "Skarner", SType = "target", SRange = 350, CC = true }, 
["SonaQ"] = { slot = _Q, champName = "Sona", SType = "aoe", SRange = 825, CC = false }, 
["SonaR"] = { slot = _R, champName = "Sona", SType = "linear", SSpeed = 2250, SRange = 900, SDelay = 250, SRadius = 120, CC = true }, 
["SorakaQ"] = { slot = _Q, champName = "Soraka", SType = "circular", SSpeed = 1150, SRange = 800, SDelay = 250, SRadius = 235, CC = true }, 
["SorakaE"] = { slot = _E, champName = "Soraka", SType = "circular", SSpeed = math.huge, SRange = 925, SDelay = 1500, SRadius = 300, CC = true }, 
["SwainQ"] = { slot = _Q, champName = "Swain", SType = "aoe", SRange = 725, CC = false }, 
["SwainW"] = { slot = _W, champName = "Swain", SType = "circular", SSpeed = math.huge, SRange = 3500, SDelay = 1500, SRadius = 325, CC = true }, 
["SwainE"] = { slot = _E, champName = "Swain", SType = "linear", SSpeed = 1550, SRange = 850, SDelay = 250, SRadius = 100, CC = true }, 
["SyndraQ"] = { slot = _W, champName = "Syndra", SType = "circular", SSpeed = math.huge, SRange = 800, SDelay = 625, SRadius = 200, CC = false }, 
["SyndraWCast"] = { slot = _W, champName = "Syndra", SType = "circular", SSpeed = 1450, SRange = 950, SDelay = 250, SRadius = 225, CC = true }, 
["SyndraE"] = { slot = _E, champName = "Syndra", SType = "aoe", SRange = 700, CC = true }, 
["SyndraEMissile"] = { slot = _E, champName = "Syndra", SType = "linear", SSpeed = 1600, SRange = 1250, SDelay = 250, SRadius = 50, CC = true }, 
["SyndraR"] = { slot = _R, champName = "Syndra", SType = "target", SRange = 750, CC = false }, 
["TahmKenchQ"] = { slot = _Q, champName = "TahmKench", SType = "linear", SSpeed = 2670, SRange = 800, SDelay = 250, SRadius = 70, CC = true }, 
["TahmKenchW"] = { slot = _W, champName = "TahmKench", SType = "target", SRange = 250, CC = true }, 
["TaliyahQ"] = { slot = _Q, champName = "Taliyah", SType = "linear", SSpeed = 2850, SRange = 1000, SDelay = 250, SRadius = 100, CC = false }, 
["TaliyahWVC"] = { slot = _W, champName = "Taliyah", SType = "circular", SSpeed = math.huge, SRange = 900, SDelay = 600, SRadius = 150, CC = true }, 
["TalonQ"] = { slot = _Q, champName = "Talon", SType = "target", SRange = 550, CC = false }, 
["TalonW"] = { slot = _W, champName = "Talon", SType = "aoe", SRange = 650, CC = true }, 
["TalonR"] = { slot = _R, champName = "Talon", SType = "aoe", SRange = 550, CC = false }, 
["TaricE"] = { slot = _E, champName = "Taric", SType = "linear", SSpeed = math.huge, SRange = 575, SDelay = 1000, SRadius = 70, CC = true }, 
["TeemoQ"] = { slot = _Q, champName = "Teemo", SType = "target", SRange = 680, CC = false }, 
["TeemoRCast"] = { slot = _R, champName = "Teemo", SType = "circular", SSpeed = math.huge, SRange = 900, SDelay = 1250, SRadius = 200, CC = true }, 
["ThreshQ"] = { slot = _Q, champName = "Thresh", SType = "linear", SSpeed = 1900, SRange = 1100, SDelay = 500, SRadius = 55, CC = true }, 
["ThreshE"] = { slot = _E, champName = "Thresh", SType = "aoe", SRange = 400, CC = true }, 
["ThreshRPenta"] = { slot = _R, champName = "Thresh", SType = "aoe", SRange = 450, CC = true }, 
["TristanaW"] = { slot = _W, champName = "Tristana", SType = "circular", SSpeed = 1100, SRange = 900, SDelay = 250, SRadius = 250, CC = true }, 
["TristanaE"] = { slot = _E, champName = "Tristana", SType = "target", SRange = 661, CC = false }, 
["TristanaR"] = { slot = _R, champName = "Tristana", SType = "target", SRange = 661, CC = true }, 
["TrundleR"] = { slot = _R, champName = "Trundle", SType = "target", SRange = 700, CC = false }, -- Check
["WildCards"] = { slot = _Q, champName = "TwistedFate", SType = "linear", SSpeed = 1000, SRange = 1450, SDelay = 250, SRadius = 35, CC = false }, 
["TwitchVenomCask"] = { slot = _W, champName = "Twitch", SType = "circular", SSpeed = 1400, SRange = 950, SDelay = 250, SRadius = 340, CC = true }, 
["UrgotQ"] = { slot = _Q, champName = "Urgot", SType = "circular", SSpeed = math.huge, SRange = 800, SDelay = 600, SRadius = 215, CC = true }, 
["UrgotE"] = { slot = _E, champName = "Urgot", SType = "linear", SSpeed = 1050, SRange = 475, SDelay = 450, SRadius = 100, CC = true }, 
["UrgotR"] = { slot = _R, champName = "Urgot", SType = "linear", SSpeed = 3200, SRange = 1600, SDelay = 400, SRadius = 70, CC = true }, 
["VarusQ"] = { slot = _Q, champName = "Varus", SType = "linear", SSpeed = 1850, SRange = 1625, SDelay = 0, SRadius = 40, CC = false }, 
["VarusE"] = { slot = _E, champName = "Varus", SType = "circular", SSpeed = 1500, SRange = 925, SDelay = 242, SRadius = 280, CC = true }, 
["VarusR"] = { slot = _R, champName = "Varus", SType = "linear", SSpeed = 1850, SRange = 1075, SDelay = 242, SRadius = 120, CC = true }, 
["VayneCondemn"] = { slot = _E, champName = "Vayne", SType = "target", SRange = 550, CC = true }, 
["VeigarBalefulStrike"] = { slot = _Q, champName = "Veigar", SType = "linear", SSpeed = 2000, SRange = 950, SDelay = 250, SRadius = 60, CC = false }, 
["VeigarDarkMatter"] = { slot = _W, champName = "Veigar", SType = "circular", SSpeed = math.huge, SRange = 900, SDelay = 1250, SRadius = 225, CC = false }, 
["VeigarEventHorizon"] = { slot = _E, champName = "Veigar", SType = "circular", SSpeed = math.huge, SRange = 700, SDelay = 750, SRadius = 375, CC = true }, 
["VeigarPrimordialBurst"] = { slot = _R, champName = "Veigar", SType = "target", SRange = 650, CC = false }, 
["VelKozQ"] = { slot = _Q, champName = "VelKoz", SType = "linear", SSpeed = 1235, SRange = 1050, SDelay = 251, SRadius = 55, CC = true }, 
["VelKozW"] = { slot = _W, champName = "VelKoz", SType = "linear", SSpeed = 1500, SRange = 1050, SDelay = 250, SRadius = 80, CC = false }, 
["VelKozE"] = { slot = _E, champName = "VelKoz", SType = "circular", SSpeed = math.huge, SRange = 850, SDelay = 750, SRadius = 235, CC = true }, 
["ViQ"] = { slot = _Q, champName = "Vi", SType = "linear", SSpeed = 1400, SRange = 725, SDelay = 0, SRadius = 55, CC = true }, 
["ViR"] = { slot = _R, champName = "Vi", SType = "target", SRange = 800, CC = true }, 
["ViktorSiphonPower"] = { slot = _Q, champName = "Viktor", SType = "target", SRange = 600, CC = false }, 
["ViktorGravitonField"] = { slot = _W, champName = "Viktor", SType = "circular", SSpeed = math.huge, SRange = 700, SDelay = 1333, SRadius = 290, CC = true }, 
["ViktorDeathRay"] = { slot = _E, champName = "Viktor", SType = "linear", SSpeed = 1350, SRange = 1025, SDelay = 0, SRadius = 80, CC = false }, 
["ViktorChaosStorm"] = { slot = _R, champName = "Viktor", SType = "circular", SSpeed = math.huge, SRange = 700, SDelay = 250, SRadius = 290, CC = false }, 
["VladimirQ"] = { slot = _Q, champName = "Vladimir", SType = "target", SRange = 600, CC = false }, 
["VladimirE"] = { slot = _E, champName = "Vladimir", SType = "aoe", SRange = 600, CC = true }, 
["VladimirHemoplague"] = { slot = _R, champName = "Vladimir", SType = "circular", SSpeed = math.huge, SRange = 700, SDelay = 389, SRadius = 350, CC = false }, 
["VolibearE"] = { slot = _E, champName = "Volibear", SType = "aoe", SRange = 425, CC = true }, -- Check
["WarwickQ"] = { slot = _Q, champName = "Warwick", SType = "target", SRange = 350, CC = true }, 
["WarwickE"] = { slot = _E, champName = "Warwick", SType = "aoe", SRange = 375, CC = true }, 
["WarwickR"] = { slot = _R, champName = "Warwick", SType = "linear", SSpeed = 1800, SRange = 2000, SDelay = 100, SRadius = 45, CC = true }, 
["MonkeyKingDecoy"] = { slot = _W, champName = "MonkeyKing", SType = "aoe", SRange = 175, CC = false }, 
["MonkeyKingNimbus"] = { slot = _E, champName = "MonkeyKing", SType = "linear", SSpeed = 1200, SRange = 625, SDelay = 0, SRadius = 188, CC = false }, 
["MonkeyKingSpinToWin"] = { slot = _R, champName = "MonkeyKing", SType = "aoe", SRange = 325, CC = true }, 
["XayahR"] = { slot = _R, champName = "Xayah", SType = "aoe", SRange = 1100, CC = false }, 
["XerathArcanopulse2"] = { slot = _Q, champName = "Xerath", SType = "linear", SSpeed = math.huge, SRange = 1400, SDelay = 500, SRadius = 75, CC = false }, 
["XerathArcaneBarrage2"] = { slot = _W, champName = "Xerath", SType = "circular", SSpeed = math.huge, SRange = 1100, SDelay = 500, SRadius = 235, CC = true }, 
["XerathMageSpearMissile"] = { slot = _E, champName = "Xerath", SType = "linear", SSpeed = 1350, SRange = 1050, SDelay = 250, SRadius = 60, CC = true }, 
["XerathRMissileWrapper"] = { slot = _R, champName = "Xerath", SType = "circular", SSpeed = math.huge, SRange = 6160, SDelay = 600, SRadius = 200, CC = false }, 
["XinZhaoE"] = { slot = _E, champName = "XinZhao", SType = "target", SRange = 650, CC = true }, 
["XinZhaoR"] = { slot = _R, champName = "XinZhao", SType = "aoe", SRange = 550, CC = true }, 
["YasuoQ3"] = { slot = _Q, champName = "Yasuo", SType = "linear", SSpeed = 1500, SRange = 1000, SDelay = 180, SRadius = 75, CC = true }, 
["YasuoE"] = { slot = _E, champName = "Yasuo", SType = "target", SRange = 475, CC = false }, 
["YasuoR"] = { slot = _R, champName = "Yasuo", SType = "aoe", SRange = 1400, CC = true }, 
["YorickE"] = { slot = _E, champName = "Yorick", SType = "aoe", SRange = 700, CC = true }, 
["ZacQ"] = { slot = _Q, champName = "Zac", SType = "linear", SSpeed = math.huge, SRange = 800, SDelay = 330, SRadius = 85, CC = true }, 
["ZacW"] = { slot = _W, champName = "Zac", SType = "aoe", SRange = 350, CC = true }, 
["ZacE"] = { slot = _E, champName = "Zac", SType = "circular", SSpeed = 1330, SRange = 1800, SDelay = 0, SRadius = 300, CC = true }, 
["ZacR"] = { slot = _R, champName = "Zac", SType = "aoe", SRange = 300, CC = true }, 
["ZedE"] = { slot = _E, champName = "Zed", SType = "aoe", SRange = 290, CC = true }, 
["ZiggsQ"] = { slot = _Q, champName = "Ziggs", SType = "circular", SSpeed = 1700, SRange = 1400, SDelay = 250, SRadius = 180, CC = false }, 
["ZiggsW"] = { slot = _W, champName = "Ziggs", SType = "circular", SSpeed = 2000, SRange = 1000, SDelay = 250, SRadius = 325, CC = true }, 
["ZiggsE"] = { slot = _E, champName = "Ziggs", SType = "circular", SSpeed = 1800, SRange = 900, SDelay = 250, SRadius = 325, CC = true }, 
["ZiggsR"] = { slot = _R, champName = "Ziggs", SType = "circular", SSpeed = 1500, SRange = 5300, SDelay = 375, SRadius = 550, CC = false }, 
["ZileanQ"] = { slot = _Q, champName = "Zilean", SType = "circular", SSpeed = 2050, SRange = 900, SDelay = 250, SRadius = 180, CC = true }, 
["ZileanE"] = { slot = _E, champName = "Zilean", SType = "target", SRange = 550, CC = true }, 
["ZoeQ"] = { slot = _Q, champName = "Zoe", SType = "linear", SSpeed = 1280, SRange = 800, SDelay = 250, SRadius = 40, CC = false }, 
["ZoeQRecast"] = { slot = _Q, champName = "Zoe", SType = "linear", SSpeed = 2370, SRange = 1600, SDelay = 0, SRadius = 40, CC = false }, 
["ZoeE"] = { slot = _Q, champName = "Zoe", SType = "linear", SSpeed = 1950, SRange = 800, SDelay = 300, SRadius = 55, CC = true }, 
["ZyraQPlantMissile"] = { slot = _Q, champName = "Zyra", SType = "circular", SSpeed = math.huge, SRange = 800, SDelay = 625, SRadius = 100, CC = false }, 
["ZyraE"] = { slot = _E, champName = "Zyra", SType = "linear", SSpeed = 1150, SRange = 1100, SDelay = 250, SRadius = 60, CC = true }, 
["ZyraR"] = { slot = _R, champName = "Zyra", SType = "circular", SSpeed = math.huge, SRange = 700, SDelay = 1175, SRadius = 575, CC = true }
}

local BGlobalTicker = 0
OnProcessSpell(function(unit, spellProc)
	if SivirMenu.Auto.UseE:Value() then
		local BlockSpell = Block[spellProc.name]
		if BlockSpell then
			if BlockSpell.champName == GetObjectName(unit) and GetTeam(unit) ~= GetTeam(myHero) and GetObjectType(unit) == Obj_AI_Hero and CanUseSpell(myHero,_E) == READY then
				if (GetCurrentHP(myHero)/GetMaxHP(myHero))*100 >= SivirMenu.Auto.HP:Value() then
					if BlockSpell.CC then
						if spellProc.target == myHero and BlockSpell.SType == "target" and SivirMenu.Blocklist.BT:Value() then
							CastSpell(_E)
						end
						if BlockSpell.SType == "linear" and IsInDistance(unit, BlockSpell.SRange+GetMoveSpeed(myHero)) and SivirMenu.Blocklist.BL:Value() then
							BlockVector = VectorWay(spellProc.startPos, spellProc.endPos)
							BlockDistanceStartEnd = DistanceBetween(spellProc.startPos, spellProc.endPos)
							BlockVector = (BlockVector/BlockDistanceStartEnd)*BlockSpell.SRange
							BlockSpellTimeNeed = ((BlockSpell.SRange/(BlockSpell.SSpeed+50))*1000)+BlockSpell.SDelay
							WayOnTime = BlockVector/BlockSpellTimeNeed
							startTime = GetGameTimer()
							startingPos = spellProc.startPos
							endingPos = spellProc.startPos + BlockVector
							radius = BlockSpell.SRadius
						end
						if BlockSpell.SType == "circular" and IsInDistance(unit, BlockSpell.SRange+GetMoveSpeed(myHero)) and SivirMenu.Blocklist.BC:Value() then
							local spellTime = (DistanceBetween((GetOrigin(unit)),spellProc.endPos)/BlockSpell.SSpeed)*1000+BlockSpell.SDelay
							local Ticker = GetTickCount()	
							if (BGlobalTicker) < Ticker then
								DelayAction(function()
									if GetDistance(spellProc.endPos) < BlockSpell.SRadius then
										CastSpell(_E)
									end
								end, (spellTime)/1000 - 0.23)
								BGlobalTicker = Ticker
							end	
						end
						if BlockSpell.SType == "aoe" and IsInDistance(unit, BlockSpell.SRange) and SivirMenu.Blocklist.BA:Value() then
							CastSpell(_E)
						end
					end
				else
					if spellProc.target == myHero and BlockSpell.SType == "target" and SivirMenu.Blocklist.BT:Value() then
						CastSpell(_E)
					end
					if BlockSpell.SType == "linear" and IsInDistance(unit, BlockSpell.SRange+GetMoveSpeed(myHero)) and SivirMenu.Blocklist.BL:Value() then
						BlockVector = VectorWay(spellProc.startPos, spellProc.endPos)
						BlockDistanceStartEnd = DistanceBetween(spellProc.startPos, spellProc.endPos)
						BlockVector = (BlockVector/BlockDistanceStartEnd)*BlockSpell.SRange
						BlockSpellTimeNeed = ((BlockSpell.SRange/(BlockSpell.SSpeed+50))*1000)+BlockSpell.SDelay
						WayOnTime = BlockVector/BlockSpellTimeNeed
						startTime = GetGameTimer()
						startingPos = spellProc.startPos
						endingPos = spellProc.startPos + BlockVector
						radius = BlockSpell.SRadius
					end
					if BlockSpell.SType == "circular" and IsInDistance(unit, BlockSpell.SRange+GetMoveSpeed(myHero)) and SivirMenu.Blocklist.BC:Value() then
						local spellTime = (DistanceBetween((GetOrigin(unit)),spellProc.endPos)/BlockSpell.SSpeed)*1000+BlockSpell.SDelay
						local Ticker = GetTickCount()	
						if (BGlobalTicker) < Ticker then
							DelayAction(function()
								if GetDistance(spellProc.endPos) < BlockSpell.SRadius then
									CastSpell(_E)
								end
							end, (spellTime)/1000 - 0.23)
							BGlobalTicker = Ticker
						end	
					end
					if BlockSpell.SType == "aoe" and IsInDistance(unit, BlockSpell.SRange) and SivirMenu.Blocklist.BA:Value() then
						CastSpell(_E)
					end
				end
			end
		end
	end
end)
function LineE()
	if SivirMenu.Auto.UseE:Value() then
		if startTime ~= nil then
			local Time = GetGameTimer() - startTime
			Time = Time*1000
			local spellPos = startingPos+(Time*WayOnTime)
			local spellPos1 = startingPos+((Time-150)*WayOnTime)
			local spellPos2 = startingPos+((Time-100)*WayOnTime)
			local spellPos3 = startingPos+((Time-50)*WayOnTime)
			if CanUseSpell(myHero,_E) == READY then
				if GetDistance(spellPos) <= radius+GetHitBox(myHero)*1.2 then
					CastSpell(_E)
				end
				if GetDistance(spellPos1) <= radius+GetHitBox(myHero)*1.2 then
					CastSpell(_E)
				end
				if GetDistance(spellPos2) <= radius+GetHitBox(myHero)*1.2 then
					CastSpell(_E)
				end
				if GetDistance(spellPos3) <= radius+GetHitBox(myHero)*1.2 then
					CastSpell(_E)
				end
			end
			if Time >= BlockSpellTimeNeed then
				startTime = nil
			end
		end
	end
end

-- Combo

function Combo()
	if Mode() == "Combo" then
		if SivirMenu.Combo.UseQ:Value() then
			if CanUseSpell(myHero,_Q) == READY and AA == true then
				if ValidTarget(target, SivirQ.range) then
					useQ(target)
				end
			end
		end
		if SivirMenu.Combo.UseW:Value() then
			if CanUseSpell(myHero,_W) == READY and AA == true then
				if ValidTarget(target, GetRange(myHero)+GetHitBox(myHero)) then
					CastSpell(_W)
					if _G.IOW then
						IOW:ResetAA()
					elseif _G.GoSWalkLoaded then
						_G.GoSWalk:ResetAttack()
					elseif _G.DAC_Loaded then
						DAC:ResetAA()
					elseif _G.AutoCarry_Loaded then
						DACR:ResetAA()
					end
				end
			end
		end
		if SivirMenu.Combo.UseR:Value() then
			if CanUseSpell(myHero,_R) == READY then
				if ValidTarget(target, SivirMenu.Combo.Distance:Value()) then
					if 100*GetCurrentHP(target)/GetMaxHP(target) < SivirMenu.Combo.HP:Value() then
						if EnemiesAround(myHero, 1500) >= SivirMenu.Combo.X:Value() then
							CastSpell(_R)
						end
					end
				end
			end
		end
	end
end

-- Harass

function Harass()
	if Mode() == "Harass" then
		if SivirMenu.Harass.UseQ:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > SivirMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_Q) == READY and AA == true then
					if ValidTarget(target, SivirQ.range) then
						useQ(target)
					end
				end
			end
		end
		if SivirMenu.Harass.UseW:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > SivirMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_W) == READY and AA == true then
					if ValidTarget(target, GetRange(myHero)+GetHitBox(myHero)) then
						CastSpell(_W)
						if _G.IOW then
							IOW:ResetAA()
						elseif _G.GoSWalkLoaded then
							_G.GoSWalk:ResetAttack()
						elseif _G.DAC_Loaded then
							DAC:ResetAA()
						elseif _G.AutoCarry_Loaded then
							DACR:ResetAA()
						end
					end
				end
			end
		end
	end
end

-- KillSteal

function KillSteal()
	for i,enemy in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_Q) == READY then
			if SivirMenu.KillSteal.UseQ:Value() then
				if ValidTarget(enemy, SivirQ.range) then
					local SivirQDmg = (37*GetCastLevel(myHero,_Q)+27.75)+((0.185*GetCastLevel(myHero,_Q)+1.11)*(GetBonusDmg(myHero)+GetBaseDamage(myHero)))+(0.925*GetBonusAP(myHero))
					if (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*4) < SivirQDmg then
						useQ(enemy)
					end
				end
			end
		end
	end
end

-- LaneClear

function LaneClear()
	if Mode() == "LaneClear" then
		if SivirMenu.LaneClear.UseQ:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > SivirMenu.LaneClear.MP:Value() then
				if CanUseSpell(myHero,_Q) == READY and AA == true then
					local BestPos, BestHit = GetLineFarmPosition(SivirQ.range, SivirQ.radius, MINION_ENEMY)
					if BestPos and BestHit > 4 then
						CastSkillShot(_Q, BestPos)
					end
				end
			end
		end
		if SivirMenu.LaneClear.UseW:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > SivirMenu.LaneClear.MP:Value() then
				for _, minion in pairs(minionManager.objects) do
					if GetTeam(minion) == MINION_ENEMY then
						if ValidTarget(minion, GetRange(myHero)+GetHitBox(myHero)) then
							if CanUseSpell(myHero,_W) == READY and AA == true then
								CastSpell(_W)
							end
						end
					end
				end
			end
		end
	end
end

function DistanceBetween(p1,p2)
	return math.sqrt(math.pow((p2.x - p1.x),2) + math.pow((p2.y - p1.y),2) + math.pow((p2.z - p1.z),2))
end
function VectorWay(A,B)
	WayX = B.x - A.x
	WayY = B.y - A.y
	WayZ = B.z - A.z
	return Vector(WayX, WayY, WayZ)
end

-- Tristana

elseif "Tristana" == GetObjectName(myHero) then

PrintChat("<font color='#1E90FF'>[<font color='#00BFFF'>GoS-U<font color='#1E90FF'>] <font color='#00BFFF'>Tristana loaded successfully!")
local TristanaMenu = Menu("[GoS-U] Tristana", "[GoS-U] Tristana")
TristanaMenu:Menu("Auto", "Auto")
TristanaMenu.Auto:Boolean('UseE', 'Use E [Explosive Charge]', true)
TristanaMenu.Auto:Slider("MP","Mana-Manager", 40, 0, 100, 5)
TristanaMenu:Menu("Combo", "Combo")
TristanaMenu.Combo:Boolean('UseQ', 'Use Q [Rapid Fire]', true)
TristanaMenu.Combo:Boolean('UseW', 'Use W [Rocket Jump]', true)
TristanaMenu.Combo:Boolean('UseE', 'Use E [Explosive Charge]', true)
TristanaMenu.Combo:DropDown("ModeW", "Cast Mode: W", 1, {"Gapclose To Target", "Mouse Position"})
TristanaMenu:Menu("Harass", "Harass")
TristanaMenu.Harass:Boolean('UseQ', 'Use Q [Rapid Fire]', true)
TristanaMenu.Harass:Boolean('UseW', 'Use W [Rocket Jump]', true)
TristanaMenu.Harass:Boolean('UseE', 'Use E [Explosive Charge]', true)
TristanaMenu.Harass:DropDown("ModeW", "Cast Mode: W", 2, {"Gapclose To Target", "Mouse Position"})
TristanaMenu.Harass:Slider("MP","Mana-Manager", 40, 0, 100, 5)
TristanaMenu:Menu("KillSteal", "KillSteal")
TristanaMenu.KillSteal:Boolean('UseE', 'Use E [Explosive Charge]', true)
TristanaMenu.KillSteal:Boolean('UseR', 'Use R [Buster Shot]', true)
TristanaMenu:Menu("LaneClear", "LaneClear")
TristanaMenu.LaneClear:Boolean('UseQ', 'Use Q [Rapid Fire]', true)
TristanaMenu.LaneClear:Boolean('UseE', 'Use E [Explosive Charge]', true)
TristanaMenu.LaneClear:Slider("MP","Mana-Manager", 40, 0, 100, 5)
TristanaMenu:Menu("AntiGapcloser", "Anti-Gapcloser")
TristanaMenu.AntiGapcloser:Boolean('UseR', 'Use R [Buster Shot]', true)
TristanaMenu.AntiGapcloser:Slider('Distance','Distance: R', 200, 25, 500, 25)
TristanaMenu:Menu("Interrupter", "Interrupter")
TristanaMenu.Interrupter:Boolean('UseR', 'Use R [Buster Shot]', true)
TristanaMenu.Interrupter:Slider('Distance','Distance: R', 400, 50, 1000, 50)
TristanaMenu:Menu("Prediction", "Prediction")
TristanaMenu.Prediction:DropDown("PredictionW", "Prediction: W", 5, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
TristanaMenu:Menu("Drawings", "Drawings")
TristanaMenu.Drawings:Boolean('DrawW', 'Draw W Range', true)
TristanaMenu.Drawings:Boolean('DrawER', 'Draw ER Range', true)
TristanaMenu.Drawings:Boolean('DrawDMG', 'Draw Max WER Damage', false)

local TristanaW = { range = 900, radius = 250, width = 500, speed = 1100, delay = 0.25, type = "circular", collision = false, source = myHero }
local TristanaE = { range = 525+(8*(GetLevel(myHero)-1)) }
local TristanaR = { range = 525+(8*(GetLevel(myHero)-1)) }

OnTick(function(myHero)
	Auto()
	Combo()
	Harass()
	KillSteal()
	LaneClear()
	AntiGapcloser()
end)
OnDraw(function(myHero)
	Ranges()
	DrawDamage()
end)

function Ranges()
local pos = GetOrigin(myHero)
if TristanaMenu.Drawings.DrawW:Value() then DrawCircle(pos,TristanaW.range,1,25,0xff4169e1) end
if TristanaMenu.Drawings.DrawER:Value() then DrawCircle(pos,TristanaR.range,1,25,0xff0000ff) end
end

function DrawDamage()
	for _, enemy in pairs(GetEnemyHeroes()) do
		local WDmg = (50*GetCastLevel(myHero,_W)+35)+(0.5*GetBonusAP(myHero))
		local EDmg = (22*GetCastLevel(myHero,_E)+110)+((0.33*GetCastLevel(myHero,_E)+0.77)*GetBonusDmg(myHero))+(1.1*GetBonusAP(myHero))
		local RDmg = (100*GetCastLevel(myHero,_R)+200)+GetBonusAP(myHero)
		local ComboDmg = WDmg + EDmg + RDmg
		local ERDmg = EDmg + RDmg
		local WRDmg = WDmg + RDmg
		local WEDmg = WDmg + EDmg
		if ValidTarget(enemy) then
			if TristanaMenu.Drawings.DrawDMG:Value() then
				if Ready(_W) and Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ComboDmg), 0xff008080)
				elseif Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ERDmg), 0xff008080)
				elseif Ready(_W) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WRDmg), 0xff008080)
				elseif Ready(_W) and Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WEDmg), 0xff008080)
				elseif Ready(_W) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WDmg), 0xff008080)
				elseif Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, EDmg), 0xff008080)
				elseif Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, RDmg), 0xff008080)
				end
			end
		end
	end
end

function useW(target)
	if TristanaMenu.Prediction.PredictionW:Value() == 1 then
		CastSkillShot(_W,GetOrigin(target))
	elseif TristanaMenu.Prediction.PredictionW:Value() == 2 then
		local WPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),TristanaW.speed,TristanaW.delay*1000,TristanaW.range,TristanaW.width,false,true)
		if WPred.HitChance == 1 then
			CastSkillShot(_W, WPred.PredPos)
		end
	elseif TristanaMenu.Prediction.PredictionW:Value() == 3 then
		local WPred = _G.gPred:GetPrediction(target,myHero,TristanaW,true,false)
		if WPred and WPred.HitChance >= 3 then
			CastSkillShot(_W, WPred.CastPosition)
		end
	elseif TristanaMenu.Prediction.PredictionW:Value() == 4 then
		local WSpell = IPrediction.Prediction({name="TristanaW", range=TristanaW.range, speed=TristanaW.speed, delay=TristanaW.delay, width=TristanaW.width, type="circular", collision=false})
		ts = TargetSelector()
		target = ts:GetTarget(TristanaW.range)
		local x, y = WSpell:Predict(target)
		if x > 2 then
			CastSkillShot(_W, y.x, y.y, y.z)
		end
	elseif TristanaMenu.Prediction.PredictionW:Value() == 5 then
		local WPrediction = GetCircularAOEPrediction(target,TristanaW)
		if WPrediction.hitChance > 0.9 then
			CastSkillShot(_W, WPrediction.castPos)
		end
	end
end

-- Auto

function Auto()
	if TristanaMenu.Auto.UseE:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > TristanaMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_E) == READY then
				if ValidTarget(target, TristanaE.range) then
					CastTargetSpell(target, _E)
				end
			end
		end
	end
end

-- Combo

function Combo()
	if Mode() == "Combo" then
		if TristanaMenu.Combo.UseQ:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if ValidTarget(target, GetRange(myHero)+GetHitBox(myHero)) then
					CastSpell(_Q)
				end
			end
		end
		if TristanaMenu.Combo.UseW:Value() then
			if CanUseSpell(myHero,_W) == READY then
				if ValidTarget(target, TristanaW.range) then
					if TristanaMenu.Combo.ModeW:Value() == 1 then
						useW(target)
					elseif TristanaMenu.Combo.ModeW:Value() == 2 then
						CastSkillShot(_W, GetMousePos())
					end
				end
			end
		end
		if TristanaMenu.Combo.UseE:Value() then
			if CanUseSpell(myHero,_E) == READY and AA == true then
				if ValidTarget(target, TristanaE.range) then
					CastTargetSpell(target, _E)
				end
			end
		end
	end
end

-- Harass

function Harass()
	if Mode() == "Harass" then
		if TristanaMenu.Harass.UseQ:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > TristanaMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(target, GetRange(myHero)+GetHitBox(myHero)) then
						CastSpell(_Q)
					end
				end
			end
		end
		if TristanaMenu.Harass.UseW:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > TristanaMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_W) == READY then
					if ValidTarget(target, TristanaW.range) then
						if TristanaMenu.Harass.ModeW:Value() == 1 then
							useW(target)
						elseif TristanaMenu.Harass.ModeW:Value() == 2 then
							CastSkillShot(_W, GetMousePos())
						end
					end
				end
			end
		end
		if TristanaMenu.Harass.UseE:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > TristanaMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(target, TristanaE.range) then
						CastTargetSpell(target, _E)
					end
				end
			end
		end
	end
end

-- KillSteal

function KillSteal()
	for i,enemy in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_E) == READY then
			if TristanaMenu.KillSteal.UseE:Value() then
				if ValidTarget(enemy, TristanaE.range) then
					local TristanaEDmg = (10*GetCastLevel(myHero,_E)+50)+((0.1*GetCastLevel(myHero,_E)+0.4)*GetBonusDmg(myHero))+(0.5*GetBonusAP(myHero))
					if (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*10) < TristanaEDmg then
						useE(enemy)
					end
				end
			end
		elseif CanUseSpell(myHero,_R) == READY then
			if TristanaMenu.KillSteal.UseR:Value() then
				if ValidTarget(enemy, TristanaR.range) then
					local TristanaRDmg = (100*GetCastLevel(myHero,_R)+200)+GetBonusAP(myHero)
					if (GetCurrentHP(enemy)+GetMagicResist(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*2) < TristanaRDmg then
						useR(enemy)
					end
				end
			end
		end
	end
end

-- LaneClear

function LaneClear()
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if TristanaMenu.LaneClear.UseQ:Value() then
					if ValidTarget(minion, GetRange(myHero)+GetHitBox(myHero)) then
						if CanUseSpell(myHero,_Q) == READY then
							CastSpell(_Q)
						end
					end
				end
				if TristanaMenu.LaneClear.UseE:Value() then
					if ValidTarget(minion, TristanaE.range) then
						if CanUseSpell(myHero,_E) == READY then
							if MinionsAround(minion, 150) <= 3 then
								CastTargetSpell(minion, _E)
							end
						end
					end
				end
			end
		end
	end
end

-- Anti-Gapcloser

function AntiGapcloser()
	for i,antigap in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_R) == READY then
			if TristanaMenu.AntiGapcloser.UseR:Value() then
				if ValidTarget(antigap, TristanaMenu.AntiGapcloser.Distance:Value()) then
					CastTargetSpell(antigap, _R)
				end
			end
		end
	end
end

-- Interrupter

OnProcessSpell(function(unit, spell)
	if TristanaMenu.Interrupter.UseR:Value() then
		for _, enemy in pairs(GetEnemyHeroes()) do
			if ValidTarget(enemy, TristanaMenu.Interrupter.Distance:Value()) then
				if CanUseSpell(myHero,_R) == READY then
					local UnitName = GetObjectName(enemy)
					local UnitChanellingSpells = CHANELLING_SPELLS[UnitName]
					local UnitGapcloserSpells = GAPCLOSER_SPELLS[UnitName]
					if UnitChanellingSpells then
						for _, slot in pairs(UnitChanellingSpells) do
							if spell.name == GetCastName(enemy, slot) then CastTargetSpell(enemy, _R) end
						end
					elseif UnitGapcloserSpells then
						for _, slot in pairs(UnitGapcloserSpells) do
							if spell.name == GetCastName(enemy, slot) then CastTargetSpell(enemy, _R) end
						end
					end
				end
			end
		end
    end
end)

-- Varus

elseif "Varus" == GetObjectName(myHero) then

PrintChat("<font color='#1E90FF'>[<font color='#00BFFF'>GoS-U<font color='#1E90FF'>] <font color='#00BFFF'>Varus loaded successfully!")
local VarusMenu = Menu("[GoS-U] Varus", "[GoS-U] Varus")
VarusMenu:Menu("Auto", "Auto")
VarusMenu.Auto:Boolean('UseQ', 'Use Q [Piercing Arrow]', false)
VarusMenu.Auto:Slider("MP","Mana-Manager", 40, 0, 100, 5)
VarusMenu:Menu("Combo", "Combo")
VarusMenu.Combo:Boolean('UseQ', 'Use Q [Piercing Arrow]', true)
VarusMenu.Combo:Boolean('UseE', 'Use E [Hail of Arrows]', true)
VarusMenu.Combo:Boolean('UseR', 'Use R [Chain of Corruption]', true)
VarusMenu.Combo:Slider('X','Minimum Enemies: R', 1, 0, 5, 1)
VarusMenu.Combo:Slider('HP','HP-Manager: R', 40, 0, 100, 5)
VarusMenu:Menu("Harass", "Harass")
VarusMenu.Harass:Boolean('UseQ', 'Use Q [Piercing Arrow]', true)
VarusMenu.Harass:Boolean('UseE', 'Use E [Hail of Arrows]', true)
VarusMenu.Harass:Slider("MP","Mana-Manager", 40, 0, 100, 5)
VarusMenu:Menu("KillSteal", "KillSteal")
VarusMenu.KillSteal:Boolean('UseQ', 'Use Q [Piercing Arrow]', true)
VarusMenu.KillSteal:Boolean('UseR', 'Use R [Chain of Corruption]', false)
VarusMenu:Menu("LaneClear", "LaneClear")
VarusMenu.LaneClear:Boolean('UseQ', 'Use Q [Piercing Arrow]', true)
VarusMenu.LaneClear:Boolean('UseE', 'Use E [Hail of Arrows]', true)
VarusMenu.LaneClear:Slider("MP","Mana-Manager", 40, 0, 100, 5)
VarusMenu:Menu("AntiGapcloser", "Anti-Gapcloser")
VarusMenu.AntiGapcloser:Boolean('UseE', 'Use E [Hail of Arrows]', true)
VarusMenu.AntiGapcloser:Boolean('UseR', 'Use R [Chain of Corruption]', true)
VarusMenu.AntiGapcloser:Slider('DistanceE','Distance: E', 400, 25, 500, 25)
VarusMenu.AntiGapcloser:Slider('DistanceR','Distance: R', 300, 25, 500, 25)
VarusMenu:Menu("Interrupter", "Interrupter")
VarusMenu.Interrupter:Boolean('UseR', 'Use R [Chain of Corruption]', true)
VarusMenu.Interrupter:Slider('Distance','Distance: R', 400, 25, 500, 25)
VarusMenu:Menu("Prediction", "Prediction")
VarusMenu.Prediction:DropDown("PredictionQ", "Prediction: Q", 2, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
VarusMenu.Prediction:DropDown("PredictionE", "Prediction: E", 5, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
VarusMenu.Prediction:DropDown("PredictionR", "Prediction: R", 2, {"CurrentPos", "GoSPred", "GPrediction", "IPrediction", "OpenPredict"})
VarusMenu:Menu("Drawings", "Drawings")
VarusMenu.Drawings:Boolean('DrawQ', 'Draw Q Range', true)
VarusMenu.Drawings:Boolean('DrawE', 'Draw E Range', true)
VarusMenu.Drawings:Boolean('DrawR', 'Draw R Range', true)
VarusMenu.Drawings:Boolean('DrawDMG', 'Draw Max QWER Damage', false)
VarusMenu:Menu("Misc", "Misc")
VarusMenu.Misc:Key("UseQ", "Release Q Key", string.byte("A"))
VarusMenu.Misc:Slider("StacksQ","Min W Stacks To Use Q", 2, 0, 3, 1)
VarusMenu.Misc:Slider("StacksE","Min W Stacks To Use E", 2, 0, 3, 1)
VarusMenu.Misc:Slider("StacksR","Min W Stacks To Use R", 1, 0, 3, 1)

local VarusQ = { minrange = 925, range = 1625, radius = 40, width = 80, speed = 1850, delay = 0, type = "linear", collision = true, source = myHero, col = {"yasuowall"}}
local VarusE = { range = 925, radius = 280, width = 560, speed = 1500, delay = 0.242, type = "circular", collision = false, source = myHero }
local VarusR = { range = 1075, radius = 120, width = 240, speed = 1850, delay = 0.242, type = "linear", collision = true, source = myHero, col = {"yasuowall"}}

OnTick(function(myHero)
	target = GetCurrentTarget()
	QCheck()
	Auto()
	Combo()
	Harass()
	KillSteal()
	LaneClear()
	AntiGapcloser()
end)
OnDraw(function(myHero)
	Ranges()
	DrawDamage()
end)

function Ranges()
local pos = GetOrigin(myHero)
if VarusMenu.Drawings.DrawQ:Value() then DrawCircle(pos,VarusQ.range,1,25,0xff00bfff) end
if VarusMenu.Drawings.DrawE:Value() then DrawCircle(pos,VarusE.range,1,25,0xff1e90ff) end
if VarusMenu.Drawings.DrawR:Value() then DrawCircle(pos,VarusR.range,1,25,0xff0000ff) end
end

function DrawDamage()
	for _, enemy in pairs(GetEnemyHeroes()) do
		local QDmg = (55*GetCastLevel(myHero,_Q)-40)+(1.5*(GetBonusDmg(myHero)+GetBaseDamage(myHero)))
		local WDmg = (4*GetCastLevel(myHero,_W)+1)+(0.25*GetBonusAP(myHero))+((0.0225*GetCastLevel(myHero,_W)+0.0375)+((0.06*GetBonusAP(myHero)/100)*GetMaxHP(enemy)))
		local EDmg = (35*GetCastLevel(myHero,_E)+35)+(0.6*GetBonusDmg(myHero))
		local RDmg = (75*GetCastLevel(myHero,_R)+25)+GetBonusAP(myHero)
		local ComboDmg = QDmg + WDmg + EDmg + RDmg
		local WERDmg = WDmg + EDmg + RDmg
		local QERDmg = QDmg + EDmg + RDmg
		local QWRDmg = QDmg + WDmg + RDmg
		local QWEDmg = QDmg + WDmg + EDmg
		local ERDmg = EDmg + RDmg
		local WRDmg = WDmg + RDmg
		local QRDmg = QDmg + RDmg
		local WEDmg = WDmg + EDmg
		local QEDmg = QDmg + EDmg
		local QWDmg = QDmg + WDmg
		if ValidTarget(enemy) then
			if VarusMenu.Drawings.DrawDMG:Value() then
				if Ready(_Q) and Ready(_W) and Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ComboDmg), 0xff008080)
				elseif Ready(_W) and Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WERDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QERDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_W) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QWRDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_W) and Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QWEDmg), 0xff008080)
				elseif Ready(_E) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, ERDmg), 0xff008080)
				elseif Ready(_W) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WRDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QRDmg), 0xff008080)
				elseif Ready(_W) and Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WEDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QEDmg), 0xff008080)
				elseif Ready(_Q) and Ready(_W) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QWDmg), 0xff008080)
				elseif Ready(_Q) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, QDmg), 0xff008080)
				elseif Ready(_W) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, WDmg), 0xff008080)
				elseif Ready(_E) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, EDmg), 0xff008080)
				elseif Ready(_R) then
					DrawDmgOverHpBar(enemy, GetCurrentHP(enemy), 0, CalcDamage(myHero, enemy, 0, RDmg), 0xff008080)
				end
			end
		end
	end
end

function useQ(target)
	if IsInDistance(target, VarusQ.range) then
		if GotBuff(myHero, "VarusQLaunch") > 0 then
			if VarusMenu.Misc.UseQ:Value() then
				if VarusMenu.Prediction.PredictionQ:Value() == 1 then
					CastSkillShot2(_Q,GetOrigin(target))
				elseif VarusMenu.Prediction.PredictionQ:Value() == 2 then
					local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),VarusQ.speed,VarusQ.delay*1000,VarusQ.range,VarusQ.width,false,true)
					if QPred.HitChance == 1 then
						CastSkillShot2(_Q, QPred.PredPos)
					end
				elseif VarusMenu.Prediction.PredictionQ:Value() == 3 then
					local qPred = _G.gPred:GetPrediction(target,myHero,VarusQ,false,true)
					if qPred and qPred.HitChance >= 3 then
						CastSkillShot2(_Q, qPred.CastPosition)
					end
				elseif VarusMenu.Prediction.PredictionQ:Value() == 4 then
					local QSpell = IPrediction.Prediction({name="VarusQ", range=VarusQ.range, speed=VarusQ.speed, delay=VarusQ.delay, width=VarusQ.width, type="linear", collision=false})
					ts = TargetSelector()
					target = ts:GetTarget(VarusQ.range)
					local x, y = QSpell:Predict(target)
					if x > 2 then
						CastSkillShot2(_Q, y.x, y.y, y.z)
					end
				elseif VarusMenu.Prediction.PredictionQ:Value() == 5 then
					local QPrediction = GetLinearAOEPrediction(target,VarusQ)
					if QPrediction.hitChance > 0.9 then
						CastSkillShot2(_Q, QPrediction.castPos)
					end
				end
			end
		else
			CastSkillShot(_Q,GetMousePos())
		end
	end
end
function useE(target)
	if GetDistance(target) < VarusE.range then
		if VarusMenu.Prediction.PredictionE:Value() == 1 then
			CastSkillShot(_E,GetOrigin(target))
		elseif VarusMenu.Prediction.PredictionE:Value() == 2 then
			local EPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),VarusE.speed,VarusE.delay*1000,VarusE.range,VarusE.width,false,true)
			if EPred.HitChance == 1 then
				CastSkillShot(_E, EPred.PredPos)
			end
		elseif VarusMenu.Prediction.PredictionE:Value() == 3 then
			local EPred = _G.gPred:GetPrediction(target,myHero,VarusE,true,false)
			if EPred and EPred.HitChance >= 3 then
				CastSkillShot(_W, WPred.CastPosition)
			end
		elseif VarusMenu.Prediction.PredictionE:Value() == 4 then
			local ESpell = IPrediction.Prediction({name="VarusE", range=VarusE.range, speed=VarusE.speed, delay=VarusE.delay, width=VarusE.width, type="circular", collision=false})
			ts = TargetSelector()
			target = ts:GetTarget(VarusE.range)
			local x, y = ESpell:Predict(target)
			if x > 2 then
				CastSkillShot(_E, y.x, y.y, y.z)
			end
		elseif VarusMenu.Prediction.PredictionE:Value() == 5 then
			local EPrediction = GetCircularAOEPrediction(target,VarusE)
			if EPrediction.hitChance > 0.9 then
				CastSkillShot(_E, EPrediction.castPos)
			end
		end
	end
end
function useR(target)
	if GetDistance(target) < VarusR.range then
		if VarusMenu.Prediction.PredictionR:Value() == 1 then
			CastSkillShot(_R,GetOrigin(target))
		elseif VarusMenu.Prediction.PredictionR:Value() == 2 then
			local RPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),VarusR.speed,VarusR.delay*1000,VarusR.range,VarusR.width,false,false)
			if RPred.HitChance == 1 then
				CastSkillShot(_R, RPred.PredPos)
			end
		elseif VarusMenu.Prediction.PredictionR:Value() == 3 then
			local RPred = _G.gPred:GetPrediction(target,myHero,VarusR,false,true)
			if RPred and RPred.HitChance >= 3 then
				CastSkillShot(_R, RPred.CastPosition)
			end
		elseif VarusMenu.Prediction.PredictionR:Value() == 4 then
			local RSpell = IPrediction.Prediction({name="VarusR", range=VarusR.range, speed=VarusR.speed, delay=VarusR.delay, width=VarusR.width, type="linear", collision=false})
			ts = TargetSelector()
			target = ts:GetTarget(VarusR.range)
			local x, y = RSpell:Predict(target)
			if x > 2 then
				CastSkillShot(_R, y.x, y.y, y.z)
			end
		elseif VarusMenu.Prediction.PredictionR:Value() == 5 then
			local RPrediction = GetLinearAOEPrediction(target,VarusR)
			if RPrediction.hitChance > 0.9 then
				CastSkillShot(_R, RPrediction.castPos)
			end
		end
	end
end

function QCheck()
	if GotBuff(myHero, "VarusQLaunch") > 0 then
		if _G.IOW then
			IOW.attacksEnabled = false
		elseif _G.GoSWalkLoaded then
			_G.GoSWalk:EnableAttack(false)
		elseif _G.DAC_Loaded then
			DAC:AttacksEnabled(false)
		elseif _G.AutoCarry_Loaded then
			DACR.attacksEnabled = false
		end
	else
		if _G.IOW then
			IOW.attacksEnabled = true
		elseif _G.GoSWalkLoaded then
			_G.GoSWalk:EnableAttack(true)
		elseif _G.DAC_Loaded then
			DAC:AttacksEnabled(true)
		elseif _G.AutoCarry_Loaded then
			DACR.attacksEnabled = true
		end
	end
end

-- Auto

function Auto()
	if VarusMenu.Auto.UseQ:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > VarusMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if ValidTarget(target, VarusQ.range) then
					if GotBuff(target, "VarusWDebuff") >= VarusMenu.Misc.StacksQ:Value() then
						useQ(target)
					end
				end
			end
		end
	end
end

-- Combo

function Combo()
	if Mode() == "Combo" then
		if VarusMenu.Combo.UseQ:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if ValidTarget(target, VarusQ.range) then
					if GotBuff(target, "VarusWDebuff") >= VarusMenu.Misc.StacksQ:Value() then
						useQ(target)
					end
				end
			end
		end
		if VarusMenu.Combo.UseE:Value() then
			if CanUseSpell(myHero,_E) == READY and AA == true then
				if ValidTarget(target, VarusE.range) then
					if GotBuff(target, "VarusWDebuff") >= VarusMenu.Misc.StacksE:Value() then
						useE(target)
					end
				end
			end
		end
		if VarusMenu.Combo.UseR:Value() then
			if CanUseSpell(myHero,_R) == READY then
				if ValidTarget(target, VarusR.range) then
					if 100*GetCurrentHP(target)/GetMaxHP(target) < VarusMenu.Combo.HP:Value() then
						if EnemiesAround(myHero, VarusR.range) >= VarusMenu.Combo.X:Value() then
							if GotBuff(target, "VarusWDebuff") >= VarusMenu.Misc.StacksR:Value() then
								CastSpell(_R)
							end
						end
					end
				end
			end
		end
	end
end

-- Harass

function Harass()
	if Mode() == "Harass" then
		if VarusMenu.Harass.UseQ:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > VarusMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(target, VarusQ.range) then
						if GotBuff(target, "VarusWDebuff") >= VarusMenu.Misc.StacksQ:Value() then
							useQ(target)
						end
					end
				end
			end
		end
		if VarusMenu.Harass.UseE:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > VarusMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_E) == READY and AA == true then
					if ValidTarget(target, VarusE.range) then
						if GotBuff(target, "VarusWDebuff") >= VarusMenu.Misc.StacksE:Value() then
							useE(target)
						end
					end
				end
			end
		end
	end
end

-- KillSteal

function KillSteal()
	for i,enemy in pairs(GetEnemyHeroes()) do
		if VarusMenu.KillSteal.UseQ:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if ValidTarget(enemy, VarusQ.range) then
					local VarusQDmg = (36.7*GetCastLevel(myHero,_Q)-26.7)+(GetBonusDmg(myHero)+GetBaseDamage(myHero))
					if (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*4) < VarusQDmg then
						useQ(enemy)
					end
				end
			end
		end
		if VarusMenu.KillSteal.UseR:Value() then
			if CanUseSpell(myHero,_R) == READY then
				if ValidTarget(enemy, VarusR.range) then
					local VarusRDmg = (75*GetCastLevel(myHero,_R)+25)+GetBonusAP(myHero)
					if (GetCurrentHP(enemy)+GetMagicResist(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*2) < VarusRDmg then
						useR(enemy)
					end
				end
			end
		end
	end
end

-- LaneClear

function LaneClear()
	if Mode() == "LaneClear" then
		if CanUseSpell(myHero,_Q) == READY then
			if VarusMenu.LaneClear.UseQ:Value() then
				if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > VarusMenu.LaneClear.MP:Value() then
					local BestPos, BestHit = GetLineFarmPosition(VarusQ.range, VarusQ.radius, MINION_ENEMY)
					if BestPos and BestHit > 2 then
						if GotBuff(myHero, "VarusQLaunch") > 0 then
							DelayAction(function() CastSkillShot2(_Q, BestPos) end, 0.4)
						else
							CastSkillShot(_Q,GetMousePos())
						end
					end
				end
			end
		elseif CanUseSpell(myHero,_E) == READY and AA == true then
			if VarusMenu.LaneClear.UseE:Value() then
				if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > VarusMenu.LaneClear.MP:Value() then
					local BestPos, BestHit = GetFarmPosition(VarusE.range, VarusE.radius, MINION_ENEMY)
					if BestPos and BestHit > 3 then
						CastSkillShot(_E, BestPos)
					end
				end
			end
		end
	end
end

-- AntiGapcloser

function AntiGapcloser()
	for i,antigap in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_E) == READY then
			if VarusMenu.AntiGapcloser.UseE:Value() then
				if ValidTarget(antigap, VarusMenu.AntiGapcloser.DistanceE:Value()) then
					useE(antigap)
				end
			end
		elseif CanUseSpell(myHero,_R) == READY then
			if VarusMenu.AntiGapcloser.UseR:Value() then
				if ValidTarget(antigap, VarusMenu.AntiGapcloser.DistanceR:Value()) then
					useR(antigap)
				end
			end
		end
	end
end

-- Interrupter

OnProcessSpell(function(unit, spell)
	if VarusMenu.Interrupter.UseR:Value() then
		for _, enemy in pairs(GetEnemyHeroes()) do
			if ValidTarget(enemy, VarusMenu.Interrupter.Distance:Value()) then
				if CanUseSpell(myHero,_R) == READY then
					local UnitName = GetObjectName(enemy)
					local UnitChanellingSpells = CHANELLING_SPELLS[UnitName]
					local UnitGapcloserSpells = GAPCLOSER_SPELLS[UnitName]
					if UnitGapcloserSpells then
						for _, slot in pairs(UnitGapcloserSpells) do
							if spell.name == GetCastName(enemy, slot) then useR(enemy) end
						end
					end
				end
			end
		end
    end
end)

-- Vayne

elseif "Vayne" == GetObjectName(myHero) then

require('MapPositionGOS')

PrintChat("<font color='#1E90FF'>[<font color='#00BFFF'>GoS-U<font color='#1E90FF'>] <font color='#00BFFF'>Vayne loaded successfully!")
local VayneMenu = Menu("[GoS-U] Vayne", "[GoS-U] Vayne")
VayneMenu:Menu("Auto", "Auto")
VayneMenu.Auto:Boolean('UseE', 'Use E [Condemn]', true)
VayneMenu.Auto:Slider("MP","Mana-Manager", 40, 0, 100, 5)
VayneMenu:Menu("Combo", "Combo")
VayneMenu.Combo:Boolean('UseQ', 'Use Q [Tumble]', true)
VayneMenu.Combo:Boolean('UseE', 'Use E [Condemn]', true)
VayneMenu.Combo:Boolean('UseR', 'Use R [Final Hour]', true)
VayneMenu.Combo:DropDown("ModeQ", "Cast Mode: Q", 2, {"Standard", "On Stacked"})
VayneMenu.Combo:Slider('X','Minimum Enemies: R', 1, 0, 5, 1)
VayneMenu.Combo:Slider('HP','HP-Manager: R', 40, 0, 100, 5)
VayneMenu:Menu("Harass", "Harass")
VayneMenu.Harass:Boolean('UseQ', 'Use Q [Tumble]', true)
VayneMenu.Harass:Boolean('UseE', 'Use E [Condemn]', true)
VayneMenu.Harass:DropDown("ModeQ", "Cast Mode: Q", 1, {"Standard", "On Stacked"})
VayneMenu.Harass:Slider("MP","Mana-Manager", 40, 0, 100, 5)
VayneMenu:Menu("KillSteal", "KillSteal")
VayneMenu.KillSteal:Boolean('UseE', 'Use E [Condemn]', true)
VayneMenu:Menu("LastHit", "LastHit")
VayneMenu.LastHit:Boolean('UseQ', 'Use Q [Tumble]', true)
VayneMenu.LastHit:Slider("MP","Mana-Manager", 40, 0, 100, 5)
VayneMenu:Menu("LaneClear", "LaneClear")
VayneMenu.LaneClear:Boolean('UseQ', 'Use Q [Tumble]', false)
VayneMenu.LaneClear:Slider("MP","Mana-Manager", 40, 0, 100, 5)
VayneMenu:Menu("Drawings", "Drawings")
VayneMenu.Drawings:Boolean('DrawQ', 'Draw Q Range', true)
VayneMenu.Drawings:Boolean('DrawE', 'Draw E Range', true)
VayneMenu:Menu("AntiGapcloser", "Anti-Gapcloser")
VayneMenu.AntiGapcloser:Boolean('UseE', 'Use E [Condemn]', true)
VayneMenu.AntiGapcloser:Slider('Distance','Distance: E', 175, 25, 500, 25)
VayneMenu:Menu("Interrupter", "Interrupter")
VayneMenu.Interrupter:Boolean('UseE', 'Use E [Condemn]', true)
VayneMenu.Interrupter:Slider('Distance','Distance: E', 400, 50, 1000, 50)
VayneMenu:Menu("Misc", "Misc")
VayneMenu.Misc:Boolean('BlockAA', 'Block AA While Stealthed', true)
VayneMenu.Misc:Slider('Distance','Distance: E', 400, 100, 475, 5)

local VayneQ = { range = 300 }
local VayneE = { range = 550, radius = 475, width = 1, speed = 2000, delay = 0.25 }

OnTick(function(myHero)
	Auto()
	Combo()
	Harass()
	KillSteal()
	LastHit()
	LaneClear()
	AntiGapcloser()
end)
OnDraw(function(myHero)
	Ranges()
end)

function Ranges()
local pos = GetOrigin(myHero)
if VayneMenu.Drawings.DrawQ:Value() then DrawCircle(pos,VayneQ.range,1,25,0xff00bfff) end
if VayneMenu.Drawings.DrawE:Value() then DrawCircle(pos,VayneE.range,1,25,0xff1e90ff) end
end

function useQ(target)
	CastSkillShot(_Q, GetMousePos())
end
function useE(target)
	local VayneEStun = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),VayneE.speed,VayneE.delay*1000,VayneE.range,VayneE.width,false,true).PredPos
	local VectorPos = Vector(VayneEStun)
	for Length = 0, VayneMenu.Misc.Distance:Value(), GetHitBox(target) do
		local TotalPos = VectorPos+Vector(VectorPos-Vector(myHero)):normalized()*Length
		if MapPosition:inWall(TotalPos) then
			CastTargetSpell(target, _E)
			break
		end
	end
end

-- Auto

function Auto()
	if VayneMenu.Auto.UseE:Value() then
		if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > VayneMenu.Auto.MP:Value() then
			if CanUseSpell(myHero,_E) == READY then
				if ValidTarget(target, VayneE.range) then
					useE(target)
				end
			end
		end
	end
end

-- Combo

function Combo()
	if Mode() == "Combo" then
		if VayneMenu.Combo.UseQ:Value() then
			if CanUseSpell(myHero,_Q) == READY and AA == true then
				if ValidTarget(target, VayneQ.range+GetRange(myHero)) then
					if VayneMenu.Combo.ModeQ:Value() == 1 then
						useQ(target)
					elseif VayneMenu.Combo.ModeQ:Value() == 2 then
						if GotBuff(target, "VayneSilveredDebuff") >= 2 then 
							useQ(target)
						end
					end
				end
			end
		end
		if VayneMenu.Combo.UseE:Value() then
			if CanUseSpell(myHero,_E) == READY and AA == true then
				if ValidTarget(target, VayneE.range) then
					useE(target)
				end
			end
		end
		if VayneMenu.Combo.UseR:Value() then
			if CanUseSpell(myHero,_R) == READY then
				if ValidTarget(target, GetRange(myHero)+GetHitBox(myHero)) then
					if 100*GetCurrentHP(target)/GetMaxHP(target) < VayneMenu.Combo.HP:Value() then
						if EnemiesAround(myHero, GetRange(myHero)+GetHitBox(myHero)) >= VayneMenu.Combo.X:Value() then
							CastSpell(_R)
						end
					end
				end
			end
		end
		if VayneMenu.Misc.BlockAA:Value() then
			if GotBuff(myHero, "vaynetumblefade") > 0 then
				if _G.IOW then
					IOW.attacksEnabled = false
				elseif _G.GoSWalkLoaded then
					_G.GoSWalk:EnableAttack(false)
				elseif _G.DAC_Loaded then
					DAC:AttacksEnabled(false)
				elseif _G.AutoCarry_Loaded then
					DACR.attacksEnabled = false
				end
			else
				if _G.IOW then
					IOW.attacksEnabled = true
				elseif _G.GoSWalkLoaded then
					_G.GoSWalk:EnableAttack(true)
				elseif _G.DAC_Loaded then
					DAC:AttacksEnabled(true)
				elseif _G.AutoCarry_Loaded then
					DACR.attacksEnabled = true
				end
			end
		end
	end
end

-- Harass

function Harass()
	if Mode() == "Harass" then
		if VayneMenu.Harass.UseQ:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > VayneMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_Q) == READY and AA == true then
					if ValidTarget(target, VayneQ.range+GetRange(myHero)) then
						if VayneMenu.Combo.ModeQ:Value() == 1 then
							useQ(target)
						elseif VayneMenu.Combo.ModeQ:Value() == 2 then
							if GotBuff(target, "VayneSilveredDebuff") >= 2 then 
								useQ(target)
							end
						end
					end
				end
			end
		end
		if VayneMenu.Harass.UseE:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > VayneMenu.Harass.MP:Value() then
				if CanUseSpell(myHero,_E) == READY and AA == true then
					if ValidTarget(target, VayneE.range) then
						useE(target)
					end
				end
			end
		end
		if VayneMenu.Misc.BlockAA:Value() then
			if QActive then
				if _G.IOW then
					IOW.attacksEnabled = false
				elseif _G.GoSWalkLoaded then
					_G.GoSWalk:EnableAttack(false)
				elseif _G.DAC_Loaded then
					DAC:AttacksEnabled(false)
				elseif _G.AutoCarry_Loaded then
					DACR.attacksEnabled = false
				end
			else
				if _G.IOW then
					IOW.attacksEnabled = true
				elseif _G.GoSWalkLoaded then
					_G.GoSWalk:EnableAttack(true)
				elseif _G.DAC_Loaded then
					DAC:AttacksEnabled(true)
				elseif _G.AutoCarry_Loaded then
					DACR.attacksEnabled = true
				end
			end
		end
	end
end

-- KillSteal

function KillSteal()
	for i,enemy in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_E) == READY then
			if VayneMenu.KillSteal.UseE:Value() then
				if ValidTarget(enemy, VayneE.range) then
					local VayneEDmg = (40*GetCastLevel(myHero,_E)+10)+(0.5*GetBonusDmg(myHero))
					if (GetCurrentHP(enemy)+GetArmor(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*2) < VayneEDmg then
						useE(enemy)
					end
				end
			end
		end
	end
end

-- LastHit

function LastHit()
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if ValidTarget(minion, VayneQ.range+GetRange(myHero)) then
					if VayneMenu.LastHit.UseQ:Value() then
						if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > VayneMenu.LastHit.MP:Value() then
							if CanUseSpell(myHero,_Q) == READY then
								local VayneQDmg = ((0.05*GetCastLevel(myHero,_Q)+0.45)*(GetBonusDmg(myHero)+GetBaseDamage(myHero)))+(GetBonusDmg(myHero)+GetBaseDamage(myHero))
								local MinionToLastHit = minion
								if GetCurrentHP(MinionToLastHit) < VayneQDmg then
									if _G.IOW then
										IOW.attacksEnabled = false
									elseif _G.GoSWalkLoaded then
										_G.GoSWalk:EnableAttack(false)
									elseif _G.DAC_Loaded then
										DAC:AttacksEnabled(false)
									elseif _G.AutoCarry_Loaded then
										DACR.attacksEnabled = false
									end
									CastSkillShot(_Q,GetMousePos())
									AttackUnit(MinionToLastHit)
									if _G.IOW then
										IOW.attacksEnabled = true
									elseif _G.GoSWalkLoaded then
										_G.GoSWalk:EnableAttack(true)
									elseif _G.DAC_Loaded then
										DAC:AttacksEnabled(true)
									elseif _G.AutoCarry_Loaded then
										DACR.attacksEnabled = true
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

-- LaneClear

function LaneClear()
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if VayneMenu.LaneClear.UseQ:Value() then
					if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > VayneMenu.LaneClear.MP:Value() then
						if ValidTarget(minion, VayneQ.range+GetRangemyHero+GetRange(myHero)) then
							if CanUseSpell(myHero,_Q) == READY and AA == true then
								CastSkillShot(_Q, GetMousePos())
							end
						end
					end
				end
			end
		end
	end
end

-- Anti-Gapcloser

function AntiGapcloser()
	for i,antigap in pairs(GetEnemyHeroes()) do
		if CanUseSpell(myHero,_E) == READY then
			if VayneMenu.AntiGapcloser.UseE:Value() then
				if ValidTarget(antigap, VayneMenu.AntiGapcloser.Distance:Value()) then
					useE(antigap)
				end
			end
		end
	end
end

-- Interrupter

OnProcessSpell(function(unit, spell)
	if VayneMenu.Interrupter.UseE:Value() then
		for _, enemy in pairs(GetEnemyHeroes()) do
			if ValidTarget(enemy, VayneMenu.Interrupter.Distance:Value()) then
				if CanUseSpell(myHero,_E) == READY then
					local UnitName = GetObjectName(enemy)
					local UnitChanellingSpells = CHANELLING_SPELLS[UnitName]
					local UnitGapcloserSpells = GAPCLOSER_SPELLS[UnitName]
					if UnitChanellingSpells then
						for _, slot in pairs(UnitChanellingSpells) do
							if spell.name == GetCastName(enemy, slot) then useE(enemy) end
						end
					elseif UnitGapcloserSpells then
						for _, slot in pairs(UnitGapcloserSpells) do
							if spell.name == GetCastName(enemy, slot) then useE(enemy) end
						end
					end
				end
			end
		end
    end
end)
end
