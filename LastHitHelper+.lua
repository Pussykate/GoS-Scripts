--   _                 _    _   _  _  _    _   _        _                          
--  | |     __ _  ___ | |_ | | | |(_)| |_ | | | |  ___ | | _ __    ___  _ __   _   
--  | |    / _` |/ __|| __|| |_| || || __|| |_| | / _ \| || '_ \  / _ \| '__|_| |_ 
--  | |___| (_| |\__ \| |_ |  _  || || |_ |  _  ||  __/| || |_) ||  __/| |  |_   _|
--  |_____|\__,_||___/ \__||_| |_||_| \__||_| |_| \___||_|| .__/  \___||_|    |_|  
--                                                        |_|                      
-- ==================
-- == Introduction ==
-- ==================
-- GoS script which uses your spells to farm/lasthit perfectly.
-- Actually supports 25 champions.
-- Features:
-- + LastHit [Auto/Manual]
-- * Auto - lasthits automatically
-- * Manual - lasthits by holding LaneClear key (default: V)
-- + Lasthit marker drawings
-- + Perfect calculations
-- ==================
-- == Requirements ==
-- ==================
-- + GPrediction (Use IOW or GoSWalk)
-- + Inspired
-- ===============
-- == Changelog ==
-- ===============
-- 1.1.1
-- + Corrected Ryze's E damage
-- 1.1
-- + Added Kayle, Kennen, KogMaw, LeBlanc, Malphite, Nasus, Ryze
-- 1.0.7 BETA
-- + Improved lasthit marker drawings
-- + Fixed spell casting
-- 1.0.6 BETA
-- + Removed marker for Yasuo's Q
-- 1.0.5 BETA
-- + Fixed Yasuo's Q
-- 1.0.4 BETA
-- + Added Yasuo
-- 1.0.3 BETA
-- + Added Fiddlesticks, Fizz, Gnar, Irelia, Jax, Kalista, Karthus, Kassadin, Katarina
-- + Improved damage calculations & minor functions
-- 1.0.2 BETA
-- + Improved farming (use LaneClear key, default: V)
-- + Fixed lasthit marker drawings
-- 1.0.1 BETA
-- + Added Darius, DrMundo, Ezreal
-- 1.0
-- + Initial release
-- + Imported Akali, Amumu, Anivia, Annie, Cassiopeia
-- + Imported Lasthit marker

require('Inspired')

PrintChat("<b><font color='#FFD700'>LastHitHelper+ <b><font color='#FFFF00'>v1.1")

function Mode()
	if _G.IOW_Loaded and IOW:Mode() then
		return IOW:Mode()
	elseif GoSWalkLoaded and GoSWalk.CurrentMode then
		return ({"Combo", "Harass", "LaneClear", "LastHit"})[GoSWalk.CurrentMode+1]
	end
end

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for i,minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if GetItemSlot(myHero, 3074) >= 1 and ValidTarget(minion, 400) then
					if CanUseSpell(myHero, GetItemSlot(myHero, 3074)) == READY then
						local HydraTiamat = (GetBonusDmg(myHero) + GetBaseDamage(myHero)) * 0.6
						if GetCurrentHP(minion) < HydraTiamat then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							CastSpell(GetItemSlot(myHero, 3074))
						end -- Ravenous Hydra
					end
				end
				if GetItemSlot(myHero, 3077) >= 1 and ValidTarget(minion, 400) then
					if CanUseSpell(myHero, GetItemSlot(myHero, 3077)) == READY then
						local HydraTiamat = (GetBonusDmg(myHero) + GetBaseDamage(myHero)) * 0.6
						if GetCurrentHP(minion) < HydraTiamat then
							CastSpell(GetItemSlot(myHero, 3077))
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end -- Tiamat
					end
				end
			end
		end
	end
end)

-- Akali

if "Akali" == GetObjectName(myHero) then

local AkaliQ = { range = 600 }
local AkaliE = { range = 300 }

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>Akali loaded successfully!")
local AkaliLHMenu = Menu("[LH+] Akali", "[LH+] Akali")
AkaliLHMenu:Menu("Auto", "Auto")
AkaliLHMenu.Auto:Boolean('AutoQ', 'Use Q', false)
AkaliLHMenu.Auto:Boolean('AutoE', 'Use E', false)
AkaliLHMenu:Menu("Manual", "Manual")
AkaliLHMenu.Manual:Boolean('UseQ', 'Use Q', true)
AkaliLHMenu.Manual:Boolean('UseE', 'Use E', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if AkaliLHMenu.Manual.UseQ:Value() then
					if CanUseSpell(myHero,_Q) == READY then
						if ValidTarget(minion, AkaliQ.range) then
							local AkaliQDmg = (20*GetCastLevel(myHero,_Q)+15)+(0.4*GetBonusAP(myHero))
							if GetCurrentHP(minion) < AkaliQDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastTargetSpell(minion, _Q)
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
				if AkaliLHMenu.Manual.UseE:Value() then
					if CanUseSpell(myHero,_E) == READY then
						if ValidTarget(minion, AkaliE.range) then
							local AkaliEDmg = (30*GetCastLevel(myHero,_E)+40)+(0.8*GetBonusDmg(myHero))+(0.6*GetBonusAP(myHero))
							if GetCurrentHP(minion) < AkaliEDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastSpell(_E)
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if AkaliLHMenu.Auto.AutoQ:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, AkaliQ.range) then
						local AkaliQDmg = (20*GetCastLevel(myHero,_Q)+15)+(0.4*GetBonusAP(myHero))
						if GetCurrentHP(minion) < AkaliQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							CastTargetSpell(minion, _Q)
						end
					end
				end
			else
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, AkaliQ.range) then
						local AkaliQDmg = (20*GetCastLevel(myHero,_Q)+15)+(0.4*GetBonusAP(myHero))
						if GetCurrentHP(minion) < AkaliQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if AkaliLHMenu.Auto.AutoE:Value() then
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(minion, AkaliE.range) then
						local AkaliEDmg = (30*GetCastLevel(myHero,_E)+40)+(0.8*GetBonusDmg(myHero))+(0.6*GetBonusAP(myHero))
						if GetCurrentHP(minion) < AkaliEDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							CastSpell(_E)
						end
					end
				end
			else
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(minion, AkaliE.range) then
						local AkaliEDmg = (30*GetCastLevel(myHero,_E)+40)+(0.8*GetBonusDmg(myHero))+(0.6*GetBonusAP(myHero))
						if GetCurrentHP(minion) < AkaliEDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)

-- Amumu

elseif "Amumu" == GetObjectName(myHero) then

local AmumuE = { range = 350 }

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>Amumu loaded successfully!")
local AmumuLHMenu = Menu("[LH+] Amumu", "[LH+] Amumu")
AmumuLHMenu:Menu("Auto", "Auto")
AmumuLHMenu.Auto:Boolean('AutoE', 'Use E', false)
AmumuLHMenu:Menu("Manual", "Manual")
AmumuLHMenu.Manual:Boolean('UseE', 'Use E', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if AmumuLHMenu.Manual.UseE:Value() then
					if CanUseSpell(myHero,_E) == READY then
						if ValidTarget(minion, AmumuE.range) then
							local AmumuEDmg = (25*GetCastLevel(myHero,_E)+50)+(0.5*GetBonusAP(myHero))
							if GetCurrentHP(minion) < AmumuEDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastSpell(_E)
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if AmumuLHMenu.Auto.AutoE:Value() then
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(minion, AmumuE.range) then
						local AmumuEDmg = (25*GetCastLevel(myHero,_E)+50)+(0.5*GetBonusAP(myHero))
						if GetCurrentHP(minion) < AmumuEDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							CastSpell(_E)
						end
					end
				end
			else
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(minion, AmumuE.range) then
						local AmumuEDmg = (25*GetCastLevel(myHero,_E)+50)+(0.5*GetBonusAP(myHero))
						if GetCurrentHP(minion) < AmumuEDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)

-- Anivia

elseif "Anivia" == GetObjectName(myHero) then

local AniviaE = { range = 650 }

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>Anivia loaded successfully!")
local AniviaLHMenu = Menu("[LH+] Anivia", "[LH+] Anivia")
AniviaLHMenu:Menu("Auto", "Auto")
AniviaLHMenu.Auto:Boolean('AutoE', 'Use E', false)
AniviaLHMenu:Menu("Manual", "Manual")
AniviaLHMenu.Manual:Boolean('UseE', 'Use E', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if AniviaLHMenu.Manual.UseE:Value() then
					if CanUseSpell(myHero,_E) == READY then
						if ValidTarget(minion, AniviaE.range) then
							local AniviaEDmg = (25*GetCastLevel(myHero,_E)+25)+(0.5*GetBonusAP(myHero))
							if GetCurrentHP(minion) < AniviaEDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastTargetSpell(minion, _E)
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if AniviaLHMenu.Auto.AutoE:Value() then
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(minion, AniviaE.range) then
						local AniviaEDmg = (25*GetCastLevel(myHero,_E)+25)+(0.5*GetBonusAP(myHero))
						if GetCurrentHP(minion) < AniviaEDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							CastTargetSpell(minion, _E)
						end
					end
				end
			else
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(minion, AniviaE.range) then
						local AniviaEDmg = (25*GetCastLevel(myHero,_E)+25)+(0.5*GetBonusAP(myHero))
						if GetCurrentHP(minion) < AniviaEDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)

-- Annie

elseif "Annie" == GetObjectName(myHero) then

local AnnieQ = { range = 625 }

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>Annie loaded successfully!")
local AnnieLHMenu = Menu("[LH+] Annie", "[LH+] Annie")
AnnieLHMenu:Menu("Auto", "Auto")
AnnieLHMenu.Auto:Boolean('AutoQ', 'Use Q', false)
AnnieLHMenu:Menu("Manual", "Manual")
AnnieLHMenu.Manual:Boolean('UseQ', 'Use Q', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if AnnieLHMenu.Manual.UseQ:Value() then
					if CanUseSpell(myHero,_Q) == READY then
						if ValidTarget(minion, AnnieQ.range) then
							local AnnieQDmg = (35*GetCastLevel(myHero,_Q)+45)+(0.8*GetBonusAP(myHero))
							if GetCurrentHP(minion) < AnnieQDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastTargetSpell(minion, _Q)
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if AnnieLHMenu.Auto.AutoQ:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, AnnieQ.range) then
						local AnnieQDmg = (35*GetCastLevel(myHero,_Q)+45)+(0.8*GetBonusAP(myHero))
						if GetCurrentHP(minion) < AnnieQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							CastTargetSpell(minion, _Q)
						end
					end
				end
			else
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, AnnieQ.range) then
						local AnnieQDmg = (35*GetCastLevel(myHero,_Q)+45)+(0.8*GetBonusAP(myHero))
						if GetCurrentHP(minion) < AnnieQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)

-- Cassiopeia

elseif "Cassiopeia" == GetObjectName(myHero) then

local CassiopeiaE = { range = 700 }

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>Cassiopeia loaded successfully!")
local CassiopeiaLHMenu = Menu("[LH+] Cassiopeia", "[LH+] Cassiopeia")
CassiopeiaLHMenu:Menu("Auto", "Auto")
CassiopeiaLHMenu.Auto:Boolean('AutoE', 'Use E', false)
CassiopeiaLHMenu:Menu("Manual", "Manual")
CassiopeiaLHMenu.Manual:Boolean('UseE', 'Use E', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if CassiopeiaLHMenu.Manual.UseE:Value() then
					if CanUseSpell(myHero,_E) == READY then
						if ValidTarget(minion, CassiopeiaE.range) then
							local CassiopeiaE1Dmg = (4*GetLevel(myHero)+48)+(0.1*GetBonusAP(myHero))
							local CassiopeiaE2Dmg = CassiopeiaE1Dmg+(20*GetCastLevel(myHero,_E)-10)+(0.6*GetBonusAP(myHero))
							if GotBuff(minion, "cassiopeiaqdebuff") > 0 then
								if GetCurrentHP(minion) < CassiopeiaE2Dmg then
									BlockInput(true)
									if _G.IOW then
										IOW.attacksEnabled = false
									elseif _G.GoSWalkLoaded then
										_G.GoSWalk:EnableAttack(false)
									end
									DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
									CastTargetSpell(minion, _E)
									BlockInput(false)
									if _G.IOW then
										IOW.attacksEnabled = true
									elseif _G.GoSWalkLoaded then
										_G.GoSWalk:EnableAttack(true)
									end
								end
							else
								if GetCurrentHP(minion) < CassiopeiaE1Dmg then
									BlockInput(true)
									if _G.IOW then
										IOW.attacksEnabled = false
									elseif _G.GoSWalkLoaded then
										_G.GoSWalk:EnableAttack(false)
									end
									DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
									CastTargetSpell(minion, _E)
									BlockInput(false)
									if _G.IOW then
										IOW.attacksEnabled = true
									elseif _G.GoSWalkLoaded then
										_G.GoSWalk:EnableAttack(true)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if CassiopeiaLHMenu.Auto.AutoE:Value() then
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(minion, CassiopeiaE.range) then
						local CassiopeiaE1Dmg = (4*GetLevel(myHero)+48)+(0.1*GetBonusAP(myHero))
						local CassiopeiaE2Dmg = CassiopeiaE1Dmg+(20*GetCastLevel(myHero,_E)-10)+(0.6*GetBonusAP(myHero))
						if GotBuff(minion, "cassiopeiaqdebuff") > 0 then
							if GetCurrentHP(minion) < CassiopeiaE2Dmg then
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastTargetSpell(minion, _E)
							end
						else
							if GetCurrentHP(minion) < CassiopeiaE1Dmg then
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastTargetSpell(minion, _E)
							end
						end
					end
				end
			else
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(minion, CassiopeiaE.range) then
						local CassiopeiaE1Dmg = (4*GetLevel(myHero)+48)+(0.1*GetBonusAP(myHero))
						local CassiopeiaE2Dmg = CassiopeiaE1Dmg+(20*GetCastLevel(myHero,_E)-10)+(0.6*GetBonusAP(myHero))
						if GotBuff(minion, "cassiopeiaqdebuff") > 0 then
							if GetCurrentHP(minion) < CassiopeiaE2Dmg then
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							end
						else
							if GetCurrentHP(minion) < CassiopeiaE1Dmg then
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							end
						end
					end
				end
			end
		end
	end
end)

-- Darius

elseif "Darius" == GetObjectName(myHero) then

local DariusW = { range = 300 }

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>Darius loaded successfully!")
local DariusLHMenu = Menu("[LH+] Darius", "[LH+] Darius")
DariusLHMenu:Menu("Auto", "Auto")
DariusLHMenu.Auto:Boolean('AutoW', 'Use W', false)
DariusLHMenu:Menu("Manual", "Manual")
DariusLHMenu.Manual:Boolean('UseW', 'Use W', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if DariusLHMenu.Manual.UseW:Value() then
					if CanUseSpell(myHero,_W) == READY then
						if ValidTarget(minion, DariusW.range) then
							local DariusWDmg = 1.4*(GetBonusDmg(myHero)+GetBaseDamage(myHero))
							if GetCurrentHP(minion) < DariusWDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastSpell(_W)
								AttackUnit(minion)
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if DariusLHMenu.Auto.AutoW:Value() then
				if CanUseSpell(myHero,_W) == READY then
					if ValidTarget(minion, DariusW.range) then
						local DariusWDmg = 1.4*(GetBonusDmg(myHero)+GetBaseDamage(myHero))
						if GetCurrentHP(minion) < DariusWDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							CastSpell(_W)
							AttackUnit(minion)
						end
					end
				end
			else
				if CanUseSpell(myHero,_W) == READY then
					if ValidTarget(minion, DariusW.range) then
						local DariusWDmg = 1.4*(GetBonusDmg(myHero)+GetBaseDamage(myHero))
						if GetCurrentHP(minion) < DariusWDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)

-- DrMundo

elseif "DrMundo" == GetObjectName(myHero) then

local DrMundoE = { range = 250 }

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>DrMundo loaded successfully!")
local DrMundoLHMenu = Menu("[LH+] DrMundo", "[LH+] DrMundo")
DrMundoLHMenu:Menu("Auto", "Auto")
DrMundoLHMenu.Auto:Boolean('AutoE', 'Use E', false)
DrMundoLHMenu:Menu("Manual", "Manual")
DrMundoLHMenu.Manual:Boolean('UseE', 'Use E', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if DrMundoLHMenu.Manual.UseE:Value() then
					if CanUseSpell(myHero,_E) == READY then
						if ValidTarget(minion, DrMundoE.range) then
							local DrMundoEDmg = (GetBaseDamage(myHero)+GetBonusDmg(myHero))+((20*GetCastLevel(myHero,_E)+10)*((1-(GetCurrentHP(myHero)/GetMaxHP(myHero)))+1))+((0.005*GetCastLevel(myHero,_E)+0.025)*GetMaxHP(myHero))
							if GetCurrentHP(minion) < DrMundoEDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastSpell(_E)
								AttackUnit(minion)
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if DrMundoLHMenu.Auto.AutoE:Value() then
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(minion, DrMundoE.range) then
						local DrMundoEDmg = (GetBaseDamage(myHero)+GetBonusDmg(myHero))+((20*GetCastLevel(myHero,_E)+10)*((1-(GetCurrentHP(myHero)/GetMaxHP(myHero)))+1))+((0.005*GetCastLevel(myHero,_E)+0.025)*GetMaxHP(myHero))
						if GetCurrentHP(minion) < DrMundoEDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							CastSpell(_E)
							AttackUnit(minion)
						end
					end
				end
			else
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(minion, DrMundoE.range) then
						local DrMundoEDmg = (GetBaseDamage(myHero)+GetBonusDmg(myHero))+((20*GetCastLevel(myHero,_E)+10)*((1-(GetCurrentHP(myHero)/GetMaxHP(myHero)))+1))+((0.005*GetCastLevel(myHero,_E)+0.025)*GetMaxHP(myHero))
						if GetCurrentHP(minion) < DrMundoEDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)

-- Ezreal

elseif "Ezreal" == GetObjectName(myHero) then

local EzrealQ = { range = 1150, radius = 60, speed = 2000, delay = 0.25, type = "line", col = {"minion","champion","yasuowall"}}

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>Ezreal loaded successfully!")
local EzrealLHMenu = Menu("[LH+] Ezreal", "[LH+] Ezreal")
EzrealLHMenu:Menu("Auto", "Auto")
EzrealLHMenu.Auto:Boolean('AutoQ', 'Use Q', false)
EzrealLHMenu:Menu("Manual", "Manual")
EzrealLHMenu.Manual:Boolean('UseQ', 'Use Q', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if EzrealLHMenu.Manual.UseQ:Value() then
					if CanUseSpell(myHero,_Q) == READY then
						if ValidTarget(minion, EzrealQ.range) then
							local EzrealQDmg = (20*GetCastLevel(myHero,_Q)+15)+(1.1*(GetBonusDmg(myHero)+GetBaseDamage(myHero)))+(0.4*GetBonusAP(myHero))
							if GetCurrentHP(minion) < EzrealQDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								local qPred = _G.gPred:GetPrediction(minion,myHero,EzrealQ,false,true)
								if qPred and qPred.HitChance >= 3 then
									DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
									CastSkillShot(_Q, qPred.CastPosition)
								end
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if EzrealLHMenu.Auto.AutoQ:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, EzrealQ.range) then
						local EzrealQDmg = (20*GetCastLevel(myHero,_Q)+15)+(1.1*(GetBonusDmg(myHero)+GetBaseDamage(myHero)))+(0.4*GetBonusAP(myHero))
						if GetCurrentHP(minion) < EzrealQDmg then
							local qPred = _G.gPred:GetPrediction(minion,myHero,EzrealQ,false,true)
							if qPred and qPred.HitChance >= 3 then
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastSkillShot(_Q, qPred.CastPosition)
							end
						end
					end
				end
			else
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, EzrealQ.range) then
						local EzrealQDmg = (20*GetCastLevel(myHero,_Q)+15)+(1.1*(GetBonusDmg(myHero)+GetBaseDamage(myHero)))+(0.4*GetBonusAP(myHero))
						if GetCurrentHP(minion) < EzrealQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)

-- Fiddlesticks

elseif "Fiddlesticks" == GetObjectName(myHero) then

local FiddlesticksE = { range = 750 }

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>Fiddlesticks loaded successfully!")
local FiddlesticksLHMenu = Menu("[LH+] Fiddlesticks", "[LH+] Fiddlesticks")
FiddlesticksLHMenu:Menu("Auto", "Auto")
FiddlesticksLHMenu.Auto:Boolean('AutoE', 'Use E', false)
FiddlesticksLHMenu:Menu("Manual", "Manual")
FiddlesticksLHMenu.Manual:Boolean('UseE', 'Use E', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if FiddlesticksLHMenu.Manual.UseE:Value() then
					if CanUseSpell(myHero,_E) == READY then
						if ValidTarget(minion, FiddlesticksE.range) then
							local FiddlesticksEDmg = (30*GetCastLevel(myHero,_E)+67.5)+(0.675*GetBonusAP(myHero))
							if GetCurrentHP(minion) < FiddlesticksEDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastTargetSpell(minion, _E)
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if FiddlesticksLHMenu.Auto.AutoE:Value() then
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(minion, FiddlesticksE.range) then
						local FiddlesticksEDmg = (30*GetCastLevel(myHero,_E)+67.5)+(0.675*GetBonusAP(myHero))
						if GetCurrentHP(minion) < FiddlesticksEDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							CastTargetSpell(minion, _E)
						end
					end
				end
			else
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(minion, FiddlesticksE.range) then
						local FiddlesticksEDmg = (30*GetCastLevel(myHero,_E)+67.5)+(0.675*GetBonusAP(myHero))
						if GetCurrentHP(minion) < FiddlesticksEDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)

elseif "Fizz" == GetObjectName(myHero) then

local FizzW = { range = 300 }

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>Fizz loaded successfully!")
local FizzLHMenu = Menu("[LH+] Fizz", "[LH+] Fizz")
FizzLHMenu:Menu("Auto", "Auto")
FizzLHMenu.Auto:Boolean('AutoW', 'Use W', false)
FizzLHMenu:Menu("Manual", "Manual")
FizzLHMenu.Manual:Boolean('UseW', 'Use W', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if FizzLHMenu.Manual.UseW:Value() then
					if CanUseSpell(myHero,_W) == READY then
						if ValidTarget(minion, FizzW.range) then
							local FizzWDmg = (GetBaseDamage(myHero)+GetBonusDmg(myHero))+(10*GetCastLevel(myHero,_W)+10)+(0.4*GetBonusDmg(myHero))
							if GetCurrentHP(minion) < FizzWDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastSpell(_W)
								AttackUnit(minion)
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if FizzLHMenu.Auto.AutoW:Value() then
				if CanUseSpell(myHero,_W) == READY then
					if ValidTarget(minion, FizzW.range) then
						local FizzWDmg = (GetBaseDamage(myHero)+GetBonusDmg(myHero))+(10*GetCastLevel(myHero,_W)+10)+(0.4*GetBonusDmg(myHero))
						if GetCurrentHP(minion) < FizzWDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							CastSpell(_W)
							AttackUnit(minion)
						end
					end
				end
			else
				if CanUseSpell(myHero,_W) == READY then
					if ValidTarget(minion, FizzW.range) then
						local FizzWDmg = (GetBaseDamage(myHero)+GetBonusDmg(myHero))+(10*GetCastLevel(myHero,_W)+10)+(0.4*GetBonusDmg(myHero))
						if GetCurrentHP(minion) < FizzWDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)

-- Gnar

elseif "Gnar" == GetObjectName(myHero) then

local GnarQ = { range = 1100, radius = 55, speed = 1400, delay = 0.25, type = "line", col = {"champion","yasuowall"}}

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>Gnar loaded successfully!")
local GnarLHMenu = Menu("[LH+] Gnar", "[LH+] Gnar")
GnarLHMenu:Menu("Auto", "Auto")
GnarLHMenu.Auto:Boolean('AutoQ', 'Use Q', false)
GnarLHMenu:Menu("Manual", "Manual")
GnarLHMenu.Manual:Boolean('UseQ', 'Use Q', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if GnarLHMenu.Manual.UseQ:Value() then
					if CanUseSpell(myHero,_Q) == READY then
						if ValidTarget(minion, GnarQ.range) then
							local GnarQDmg = (40*GetCastLevel(myHero,_Q)-35)+(1.15*(GetBonusDmg(myHero)+GetBaseDamage(myHero)))
							if GetCurrentHP(minion) < GnarQDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								local qPred = _G.gPred:GetPrediction(minion,myHero,GnarQ,false,true)
								if qPred and qPred.HitChance >= 3 then
									DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
									CastSkillShot(_Q, qPred.CastPosition)
								end
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if GnarLHMenu.Auto.AutoQ:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, GnarQ.range) then
						local GnarQDmg = (40*GetCastLevel(myHero,_Q)-35)+(1.15*(GetBonusDmg(myHero)+GetBaseDamage(myHero)))
						if GetCurrentHP(minion) < GnarQDmg then
							local qPred = _G.gPred:GetPrediction(minion,myHero,GnarQ,false,true)
							if qPred and qPred.HitChance >= 3 then
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastSkillShot(_Q, qPred.CastPosition)
							end
						end
					end
				end
			else
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, GnarQ.range) then
						local GnarQDmg = (40*GetCastLevel(myHero,_Q)-35)+(1.15*(GetBonusDmg(myHero)+GetBaseDamage(myHero)))
						if GetCurrentHP(minion) < GnarQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)

-- Irelia

elseif "Irelia" == GetObjectName(myHero) then

local IreliaQ = { range = 625 }

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>Irelia loaded successfully!")
local IreliaLHMenu = Menu("[LH+] Irelia", "[LH+] Irelia")
IreliaLHMenu:Menu("Auto", "Auto")
IreliaLHMenu.Auto:Boolean('AutoQ', 'Use Q', false)
IreliaLHMenu:Menu("Manual", "Manual")
IreliaLHMenu.Manual:Boolean('UseQ', 'Use Q', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if IreliaLHMenu.Manual.UseQ:Value() then
					if CanUseSpell(myHero,_Q) == READY then
						if ValidTarget(minion, IreliaQ.range) then
							local IreliaQDmg = (30*GetCastLevel(myHero,_Q)-10)+(1.2*(GetBonusDmg(myHero)+GetBaseDamage(myHero)))
							if GetCurrentHP(minion) < IreliaQDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastTargetSpell(minion, _Q)
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if IreliaLHMenu.Auto.AutoQ:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, IreliaQ.range) then
						local IreliaQDmg = (30*GetCastLevel(myHero,_Q)-10)+(1.2*(GetBonusDmg(myHero)+GetBaseDamage(myHero)))
						if GetCurrentHP(minion) < IreliaQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							CastTargetSpell(minion, _Q)
						end
					end
				end
			else
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, IreliaQ.range) then
						local IreliaQDmg = (30*GetCastLevel(myHero,_Q)-10)+(1.2*(GetBonusDmg(myHero)+GetBaseDamage(myHero)))
						if GetCurrentHP(minion) < IreliaQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)

elseif "Jax" == GetObjectName(myHero) then

local JaxW = { range = 250 }

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>Jax loaded successfully!")
local JaxLHMenu = Menu("[LH+] Jax", "[LH+] Jax")
JaxLHMenu:Menu("Auto", "Auto")
JaxLHMenu.Auto:Boolean('AutoW', 'Use W', false)
JaxLHMenu:Menu("Manual", "Manual")
JaxLHMenu.Manual:Boolean('UseW', 'Use W', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if JaxLHMenu.Manual.UseW:Value() then
					if CanUseSpell(myHero,_W) == READY then
						if ValidTarget(minion, JaxW.range) then
							local JaxWDmg = (GetBaseDamage(myHero)+GetBonusDmg(myHero))+(35*GetCastLevel(myHero,_W)+5)+(0.6*GetBonusDmg(myHero))
							if GetCurrentHP(minion) < JaxWDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastSpell(_W)
								AttackUnit(minion)
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if JaxLHMenu.Auto.AutoW:Value() then
				if CanUseSpell(myHero,_W) == READY then
					if ValidTarget(minion, JaxW.range) then
						local JaxWDmg = (GetBaseDamage(myHero)+GetBonusDmg(myHero))+(35*GetCastLevel(myHero,_W)+5)+(0.6*GetBonusDmg(myHero))
						if GetCurrentHP(minion) < JaxWDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							CastSpell(_W)
							AttackUnit(minion)
						end
					end
				end
			else
				if CanUseSpell(myHero,_W) == READY then
					if ValidTarget(minion, JaxW.range) then
						local JaxWDmg = (GetBaseDamage(myHero)+GetBonusDmg(myHero))+(35*GetCastLevel(myHero,_W)+5)+(0.6*GetBonusDmg(myHero))
						if GetCurrentHP(minion) < JaxWDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)

-- Kalista

elseif "Kalista" == GetObjectName(myHero) then

local KalistaE = { range = 1000 }

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>Kalista loaded successfully!")
local KalistaLHMenu = Menu("[LH+] Kalista", "[LH+] Kalista")
KalistaLHMenu:Menu("Auto", "Auto")
KalistaLHMenu.Auto:Boolean('AutoE', 'Use E', false)
KalistaLHMenu:Menu("Manual", "Manual")
KalistaLHMenu.Manual:Boolean('UseE', 'Use E', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if KalistaLHMenu.Manual.UseE:Value() then
					if CanUseSpell(myHero,_E) == READY then
						if ValidTarget(minion, KalistaE.range) then
							local KalistaEDmg = (10*GetCastLevel(myHero,_E)+10+(0.6*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))+(((({[1]=10,[2]=14,[3]=19,[4]=25,[5]=32})[GetCastLevel(myHero,_E)])+((0.025*GetCastLevel(myHero,_E)+0.175)*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))*(GotBuff(enemy,"kalistaexpungemarker")-1))
							if GetCurrentHP(minion) < KalistaEDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastSpell(_E)
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if KalistaLHMenu.Auto.AutoE:Value() then
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(minion, KalistaE.range) then
						local KalistaEDmg = (10*GetCastLevel(myHero,_E)+10+(0.6*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))+(((({[1]=10,[2]=14,[3]=19,[4]=25,[5]=32})[GetCastLevel(myHero,_E)])+((0.025*GetCastLevel(myHero,_E)+0.175)*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))*(GotBuff(enemy,"kalistaexpungemarker")-1))
						if GetCurrentHP(minion) < KalistaEDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							CastSpell(_E)
						end
					end
				end
			else
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(minion, KalistaE.range) then
						local KalistaEDmg = (10*GetCastLevel(myHero,_E)+10+(0.6*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))+(((({[1]=10,[2]=14,[3]=19,[4]=25,[5]=32})[GetCastLevel(myHero,_E)])+((0.025*GetCastLevel(myHero,_E)+0.175)*(GetBaseDamage(myHero)+GetBonusDmg(myHero))))*(GotBuff(enemy,"kalistaexpungemarker")-1))
						if GetCurrentHP(minion) < KalistaEDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)

-- Karthus

elseif "Karthus" == GetObjectName(myHero) then

local KarthusQ = { range = 625 }

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>Karthus loaded successfully!")
local KarthusLHMenu = Menu("[LH+] Karthus", "[LH+] Karthus")
KarthusLHMenu:Menu("Auto", "Auto")
KarthusLHMenu.Auto:Boolean('AutoQ', 'Use Q', false)
KarthusLHMenu:Menu("Manual", "Manual")
KarthusLHMenu.Manual:Boolean('UseQ', 'Use Q', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if KarthusLHMenu.Manual.UseQ:Value() then
					if CanUseSpell(myHero,_Q) == READY then
						if ValidTarget(minion, KarthusQ.range) then
							local KarthusQDmg = (20*GetCastLevel(myHero,_Q)+20)+(0.3*GetBonusAP(myHero))
							if GetCurrentHP(minion) < KarthusQDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastSkillShot(_Q,GetOrigin(minion))
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if KarthusLHMenu.Auto.AutoQ:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, KarthusQ.range) then
						local KarthusQDmg = (20*GetCastLevel(myHero,_Q)+20)+(0.3*GetBonusAP(myHero))
						if GetCurrentHP(minion) < KarthusQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							CastSkillShot(_Q,GetOrigin(minion))
						end
					end
				end
			else
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, KarthusQ.range) then
						local KarthusQDmg = (20*GetCastLevel(myHero,_Q)+20)+(0.3*GetBonusAP(myHero))
						if GetCurrentHP(minion) < KarthusQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)

-- Kassadin

elseif "Kassadin" == GetObjectName(myHero) then

local KassadinQ = { range = 650 }
local KassadinW = { range = 300 }

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>Kassadin loaded successfully!")
local KassadinLHMenu = Menu("[LH+] Kassadin", "[LH+] Kassadin")
KassadinLHMenu:Menu("Auto", "Auto")
KassadinLHMenu.Auto:Boolean('AutoQ', 'Use Q', false)
KassadinLHMenu.Auto:Boolean('AutoW', 'Use W', false)
KassadinLHMenu:Menu("Manual", "Manual")
KassadinLHMenu.Manual:Boolean('UseQ', 'Use Q', true)
KassadinLHMenu.Manual:Boolean('UseW', 'Use W', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if KassadinLHMenu.Manual.UseQ:Value() then
					if CanUseSpell(myHero,_Q) == READY then
						if ValidTarget(minion, KassadinQ.range) then
							local KassadinQDmg = (30*GetCastLevel(myHero,_Q)+35)+(0.7*GetBonusAP(myHero))
							if GetCurrentHP(minion) < KassadinQDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastTargetSpell(minion, _Q)
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
				if KassadinLHMenu.Manual.UseW:Value() then
					if CanUseSpell(myHero,_W) == READY then
						if ValidTarget(minion, KassadinW.range) then
							local KassadinWDmg = (GetBaseDamage(myHero)+GetBonusDmg(myHero))+(25*GetCastLevel(myHero,_W)+15)+(0.7*GetBonusDmg(myHero))
							if GetCurrentHP(minion) < KassadinWDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastSpell(_W)
								AttackUnit(minion)
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)

OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if KassadinLHMenu.Auto.AutoQ:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, KassadinQ.range) then
						local KassadinQDmg = (30*GetCastLevel(myHero,_Q)+35)+(0.7*GetBonusAP(myHero))
						if GetCurrentHP(minion) < KassadinQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							CastTargetSpell(minion, _Q)
						end
					end
				end
			else
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, KassadinQ.range) then
						local KassadinQDmg = (30*GetCastLevel(myHero,_Q)+35)+(0.7*GetBonusAP(myHero))
						if GetCurrentHP(minion) < KassadinQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if KassadinLHMenu.Auto.AutoW:Value() then
				if CanUseSpell(myHero,_W) == READY then
					if ValidTarget(minion, KassadinW.range) then
						local KassadinWDmg = (GetBaseDamage(myHero)+GetBonusDmg(myHero))+(25*GetCastLevel(myHero,_W)+15)+(0.7*GetBonusDmg(myHero))
						if GetCurrentHP(minion) < KassadinWDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							CastSpell(_W)
							AttackUnit(minion)
						end
					end
				end
			else
				if CanUseSpell(myHero,_W) == READY then
					if ValidTarget(minion, KassadinW.range) then
						local KassadinWDmg = (GetBaseDamage(myHero)+GetBonusDmg(myHero))+(25*GetCastLevel(myHero,_W)+15)+(0.7*GetBonusDmg(myHero))
						if GetCurrentHP(minion) < KassadinWDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)

-- Katarina

elseif "Katarina" == GetObjectName(myHero) then

local KatarinaQ = { range = 625 }

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>Katarina loaded successfully!")
local KatarinaLHMenu = Menu("[LH+] Katarina", "[LH+] Katarina")
KatarinaLHMenu:Menu("Auto", "Auto")
KatarinaLHMenu.Auto:Boolean('AutoQ', 'Use Q', false)
KatarinaLHMenu:Menu("Manual", "Manual")
KatarinaLHMenu.Manual:Boolean('UseQ', 'Use Q', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if KatarinaLHMenu.Manual.UseQ:Value() then
					if CanUseSpell(myHero,_Q) == READY then
						if ValidTarget(minion, KatarinaQ.range) then
							local KatarinaQDmg = (30*GetCastLevel(myHero,_Q)+45)+(0.3*GetBonusAP(myHero))
							if GetCurrentHP(minion) < KatarinaQDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastTargetSpell(minion, _Q)
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if KatarinaLHMenu.Auto.AutoQ:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, KatarinaQ.range) then
						local KatarinaQDmg = (30*GetCastLevel(myHero,_Q)+45)+(0.3*GetBonusAP(myHero))
						if GetCurrentHP(minion) < KatarinaQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							CastTargetSpell(minion, _Q)
						end
					end
				end
			else
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, KatarinaQ.range) then
						local KatarinaQDmg = (30*GetCastLevel(myHero,_Q)+45)+(0.3*GetBonusAP(myHero))
						if GetCurrentHP(minion) < KatarinaQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)

-- Kayle

elseif "Kayle" == GetObjectName(myHero) then

local KayleQ = { range = 650 }

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>Kayle loaded successfully!")
local KayleLHMenu = Menu("[LH+] Kayle", "[LH+] Kayle")
KayleLHMenu:Menu("Auto", "Auto")
KayleLHMenu.Auto:Boolean('AutoQ', 'Use Q', false)
KayleLHMenu:Menu("Manual", "Manual")
KayleLHMenu.Manual:Boolean('UseQ', 'Use Q', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if KayleLHMenu.Manual.UseQ:Value() then
					if CanUseSpell(myHero,_Q) == READY then
						if ValidTarget(minion, KayleQ.range) then
							local KayleQDmg = (50*GetCastLevel(myHero,_Q)+10)+(0.6*GetBonusAP(myHero))+GetBonusDmg(myHero)
							if GetCurrentHP(minion) < KayleQDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastTargetSpell(minion, _Q)
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if KayleLHMenu.Auto.AutoQ:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, KayleQ.range) then
						local KayleQDmg = (50*GetCastLevel(myHero,_Q)+10)+(0.6*GetBonusAP(myHero))+GetBonusDmg(myHero)
						if GetCurrentHP(minion) < KayleQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							CastTargetSpell(minion, _Q)
						end
					end
				end
			else
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, KayleQ.range) then
						local KayleQDmg = (50*GetCastLevel(myHero,_Q)+10)+(0.6*GetBonusAP(myHero))+GetBonusDmg(myHero)
						if GetCurrentHP(minion) < KayleQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)

-- Kennen

elseif "Kennen" == GetObjectName(myHero) then

local KennenQ = { range = 1050, radius = 50, speed = 1650, delay = 0.18, type = "line", col = {"minion","champion","yasuowall"}}

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>Kennen loaded successfully!")
local KennenLHMenu = Menu("[LH+] Kennen", "[LH+] Kennen")
KennenLHMenu:Menu("Auto", "Auto")
KennenLHMenu.Auto:Boolean('AutoQ', 'Use Q', false)
KennenLHMenu:Menu("Manual", "Manual")
KennenLHMenu.Manual:Boolean('UseQ', 'Use Q', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if KennenLHMenu.Manual.UseQ:Value() then
					if CanUseSpell(myHero,_Q) == READY then
						if ValidTarget(minion, KennenQ.range) then
							local KennenQDmg = (40*GetCastLevel(myHero,_Q)+35)+(0.75*GetBonusAP(myHero))
							if GetCurrentHP(minion) < KennenQDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								local qPred = _G.gPred:GetPrediction(minion,myHero,KennenQ,false,true)
								if qPred and qPred.HitChance >= 3 then
									DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
									CastSkillShot(_Q, qPred.CastPosition)
								end
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if KennenLHMenu.Auto.AutoQ:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, KennenQ.range) then
						local KennenQDmg = (40*GetCastLevel(myHero,_Q)+35)+(0.75*GetBonusAP(myHero))
						if GetCurrentHP(minion) < KennenQDmg then
							local qPred = _G.gPred:GetPrediction(minion,myHero,KennenQ,false,true)
							if qPred and qPred.HitChance >= 3 then
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastSkillShot(_Q, qPred.CastPosition)
							end
						end
					end
				end
			else
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, KennenQ.range) then
						local KennenQDmg = (40*GetCastLevel(myHero,_Q)+35)+(0.75*GetBonusAP(myHero))
						if GetCurrentHP(minion) < KennenQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)

-- KogMaw

elseif "KogMaw" == GetObjectName(myHero) then

local KogMawQ = { range = 1175, radius = 70, speed = 1650, delay = 0.25, type = "line", col = {"minion","champion","yasuowall"}}

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>KogMaw loaded successfully!")
local KogMawLHMenu = Menu("[LH+] KogMaw", "[LH+] KogMaw")
KogMawLHMenu:Menu("Auto", "Auto")
KogMawLHMenu.Auto:Boolean('AutoQ', 'Use Q', false)
KogMawLHMenu:Menu("Manual", "Manual")
KogMawLHMenu.Manual:Boolean('UseQ', 'Use Q', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if KogMawLHMenu.Manual.UseQ:Value() then
					if CanUseSpell(myHero,_Q) == READY then
						if ValidTarget(minion, KogMawQ.range) then
							local KogMawQDmg = (50*GetCastLevel(myHero,_Q)+30)+(0.5*GetBonusAP(myHero))
							if GetCurrentHP(minion) < KogMawQDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								local qPred = _G.gPred:GetPrediction(minion,myHero,KogMawQ,false,true)
								if qPred and qPred.HitChance >= 3 then
									DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
									CastSkillShot(_Q, qPred.CastPosition)
								end
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if KogMawLHMenu.Auto.AutoQ:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, KogMawQ.range) then
						local KogMawQDmg = (50*GetCastLevel(myHero,_Q)+30)+(0.5*GetBonusAP(myHero))
						if GetCurrentHP(minion) < KogMawQDmg then
							local qPred = _G.gPred:GetPrediction(minion,myHero,KogMawQ,false,true)
							if qPred and qPred.HitChance >= 3 then
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastSkillShot(_Q, qPred.CastPosition)
							end
						end
					end
				end
			else
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, KogMawQ.range) then
						local KogMawQDmg = (50*GetCastLevel(myHero,_Q)+30)+(0.5*GetBonusAP(myHero))
						if GetCurrentHP(minion) < KogMawQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)

-- LeBlanc

elseif "LeBlanc" == GetObjectName(myHero) then

local LeBlancQ = { range = 650 }

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>LeBlanc loaded successfully!")
local LeBlancLHMenu = Menu("[LH+] LeBlanc", "[LH+] LeBlanc")
LeBlancLHMenu:Menu("Auto", "Auto")
LeBlancLHMenu.Auto:Boolean('AutoQ', 'Use Q', false)
LeBlancLHMenu:Menu("Manual", "Manual")
LeBlancLHMenu.Manual:Boolean('UseQ', 'Use Q', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if LeBlancLHMenu.Manual.UseQ:Value() then
					if CanUseSpell(myHero,_Q) == READY then
						if ValidTarget(minion, LeBlancQ.range) then
							local LeBlancQDmg = (35*GetCastLevel(myHero,_Q)+20)+(0.5*GetBonusAP(myHero))
							if GetCurrentHP(minion) < LeBlancQDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastTargetSpell(minion, _Q)
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if LeBlancLHMenu.Auto.AutoQ:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, LeBlancQ.range) then
						local LeBlancQDmg = (35*GetCastLevel(myHero,_Q)+20)+(0.5*GetBonusAP(myHero))
						if GetCurrentHP(minion) < LeBlancQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							CastTargetSpell(minion, _Q)
						end
					end
				end
			else
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, LeBlancQ.range) then
						local LeBlancQDmg = (35*GetCastLevel(myHero,_Q)+20)+(0.5*GetBonusAP(myHero))
						if GetCurrentHP(minion) < LeBlancQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)

-- Malphite

elseif "Malphite" == GetObjectName(myHero) then

local MalphiteQ = { range = 650 }

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>Malphite loaded successfully!")
local MalphiteLHMenu = Menu("[LH+] Malphite", "[LH+] Malphite")
MalphiteLHMenu:Menu("Auto", "Auto")
MalphiteLHMenu.Auto:Boolean('AutoQ', 'Use Q', false)
MalphiteLHMenu:Menu("Manual", "Manual")
MalphiteLHMenu.Manual:Boolean('UseQ', 'Use Q', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if MalphiteLHMenu.Manual.UseQ:Value() then
					if CanUseSpell(myHero,_Q) == READY then
						if ValidTarget(minion, MalphiteQ.range) then
							local MalphiteQDmg = (50*GetCastLevel(myHero,_Q)+20)+(0.6*GetBonusAP(myHero))
							if GetCurrentHP(minion) < MalphiteQDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastTargetSpell(minion, _Q)
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if MalphiteLHMenu.Auto.AutoQ:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, MalphiteQ.range) then
						local MalphiteQDmg = (50*GetCastLevel(myHero,_Q)+20)+(0.6*GetBonusAP(myHero))
						if GetCurrentHP(minion) < MalphiteQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							CastTargetSpell(minion, _Q)
						end
					end
				end
			else
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, MalphiteQ.range) then
						local MalphiteQDmg = (50*GetCastLevel(myHero,_Q)+20)+(0.6*GetBonusAP(myHero))
						if GetCurrentHP(minion) < MalphiteQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)

elseif "Nasus" == GetObjectName(myHero) then

local NasusQ = { range = 250 }

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>Nasus loaded successfully!")
local NasusLHMenu = Menu("[LH+] Nasus", "[LH+] Nasus")
NasusLHMenu:Menu("Auto", "Auto")
NasusLHMenu.Auto:Boolean('AutoQ', 'Use Q', false)
NasusLHMenu:Menu("Manual", "Manual")
NasusLHMenu.Manual:Boolean('UseQ', 'Use Q', true)

function Stacking()
	NasusQstacks = GetBuffData(myHero,"nasusqstacks")
	QStack = NasusQstacks.Stacks
end

OnTick(function(myHero)
	Stacking()
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if NasusLHMenu.Manual.UseQ:Value() then
					if CanUseSpell(myHero,_Q) == READY then
						if ValidTarget(minion, NasusQ.range) then
							local NasusQDmg = (GetBaseDamage(myHero)+GetBonusDmg(myHero))+(20*GetCastLevel(myHero,_Q)+10)+QStack
							if GetCurrentHP(minion) < NasusQDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastSpell(_Q)
								AttackUnit(minion)
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if NasusLHMenu.Auto.AutoQ:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, NasusQ.range) then
						local NasusQDmg = (GetBaseDamage(myHero)+GetBonusDmg(myHero))+(20*GetCastLevel(myHero,_Q)+10)+QStack
						if GetCurrentHP(minion) < NasusQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							CastSpell(_Q)
							AttackUnit(minion)
						end
					end
				end
			else
				if CanUseSpell(myHero,_Q) == READY then
					if ValidTarget(minion, NasusQ.range) then
						local NasusQDmg = (GetBaseDamage(myHero)+GetBonusDmg(myHero))+(20*GetCastLevel(myHero,_Q)+10)+QStack
						if GetCurrentHP(minion) < NasusQDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)

-- Ryze

elseif "Ryze" == GetObjectName(myHero) then

local RyzeE = { range = 615 }

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>Ryze loaded successfully!")
local RyzeLHMenu = Menu("[LH+] Ryze", "[LH+] Ryze")
RyzeLHMenu:Menu("Auto", "Auto")
RyzeLHMenu.Auto:Boolean('AutoE', 'Use E', false)
RyzeLHMenu:Menu("Manual", "Manual")
RyzeLHMenu.Manual:Boolean('UseE', 'Use E', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if RyzeLHMenu.Manual.UseE:Value() then
					if CanUseSpell(myHero,_E) == READY then
						if ValidTarget(minion, RyzeE.range) then
							local RyzeEDmg = (20*GetCastLevel(myHero,_E)+50)+(0.3*GetBonusAP(myHero))
							if GetCurrentHP(minion) < RyzeEDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastTargetSpell(minion, _E)
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if RyzeLHMenu.Auto.AutoE:Value() then
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(minion, RyzeE.range) then
						local RyzeEDmg = (20*GetCastLevel(myHero,_E)+50)+(0.3*GetBonusAP(myHero))
						if GetCurrentHP(minion) < RyzeEDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							CastTargetSpell(minion, _E)
						end
					end
				end
			else
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(minion, RyzeE.range) then
						local RyzeEDmg = (20*GetCastLevel(myHero,_E)+50)+(0.3*GetBonusAP(myHero))
						if GetCurrentHP(minion) < RyzeEDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)

-- Yasuo

elseif "Yasuo" == GetObjectName(myHero) then

local YasuoQ = { range = 475 }
local YasuoQ3 = { range = 1000 }
local YasuoE = { range = 475 }

PrintChat("<font color='#F0E68C'>[<font color='#FFD700'>LastHitHelper+<font color='#F0E68C'>] <font color='#FFD700'>Yasuo loaded successfully!")
local YasuoLHMenu = Menu("[LH+] Yasuo", "[LH+] Yasuo")
YasuoLHMenu:Menu("Auto", "Auto")
YasuoLHMenu.Auto:Boolean('AutoQ', 'Use Q', false)
YasuoLHMenu.Auto:Boolean('AutoE', 'Use E', false)
YasuoLHMenu:Menu("Manual", "Manual")
YasuoLHMenu.Manual:Boolean('UseQ', 'Use Q', true)
YasuoLHMenu.Manual:Boolean('UseE', 'Use E', true)

OnTick(function(myHero)
	if Mode() == "LaneClear" then
		for _, minion in pairs(minionManager.objects) do
			if GetTeam(minion) == MINION_ENEMY then
				if YasuoLHMenu.Manual.UseQ:Value() then
					if CanUseSpell(myHero,_Q) == READY then
						if GetCastRange(myHero,_Q) > 600 then
							if ValidTarget(minion, YasuoQ3.range) then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								CastSkillShot(_Q,GetOrigin(minion))
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						else
							if ValidTarget(minion, YasuoQ.range) then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								CastSkillShot(_Q,GetOrigin(minion))
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
				if YasuoLHMenu.Manual.UseE:Value() then
					if CanUseSpell(myHero,_E) == READY then
						if ValidTarget(minion, YasuoE.range) then
							local YasuoEDmg = (10*GetCastLevel(myHero,_E)+50)+(0.2*GetBonusDmg(myHero))+(0.6*GetBonusAP(myHero))
							if GetCurrentHP(minion) < YasuoEDmg then
								BlockInput(true)
								if _G.IOW then
									IOW.attacksEnabled = false
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(false)
								end
								DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
								CastTargetSpell(minion, _E)
								BlockInput(false)
								if _G.IOW then
									IOW.attacksEnabled = true
								elseif _G.GoSWalkLoaded then
									_G.GoSWalk:EnableAttack(true)
								end
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if YasuoLHMenu.Auto.AutoQ:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if GetCastRange(myHero,_Q) > 600 then
						if ValidTarget(minion, YasuoQ3.range) then
							BlockInput(true)
							if _G.IOW then
								IOW.attacksEnabled = false
							elseif _G.GoSWalkLoaded then
								_G.GoSWalk:EnableAttack(false)
							end
							CastSkillShot(_Q,GetOrigin(minion))
							BlockInput(false)
							if _G.IOW then
								IOW.attacksEnabled = true
							elseif _G.GoSWalkLoaded then
								_G.GoSWalk:EnableAttack(true)
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if YasuoLHMenu.Auto.AutoQ:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if GetCastRange(myHero,_Q) > 600 then
						if ValidTarget(minion, YasuoQ3.range) then
							BlockInput(true)
							if _G.IOW then
								IOW.attacksEnabled = false
							elseif _G.GoSWalkLoaded then
								_G.GoSWalk:EnableAttack(false)
							end
							CastSkillShot(_Q,GetOrigin(minion))
							BlockInput(false)
							if _G.IOW then
								IOW.attacksEnabled = true
							elseif _G.GoSWalkLoaded then
								_G.GoSWalk:EnableAttack(true)
							end
						end
					else
						if ValidTarget(minion, YasuoQ.range) then
							BlockInput(true)
							if _G.IOW then
								IOW.attacksEnabled = false
							elseif _G.GoSWalkLoaded then
								_G.GoSWalk:EnableAttack(false)
							end
							CastSkillShot(_Q,GetOrigin(minion))
							BlockInput(false)
							if _G.IOW then
								IOW.attacksEnabled = true
							elseif _G.GoSWalkLoaded then
								_G.GoSWalk:EnableAttack(true)
							end
						end
					end
				end
			end
		end
	end
end)
OnTick(function(myHero)
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			if YasuoLHMenu.Auto.AutoE:Value() then
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(minion, YasuoE.range) then
						local YasuoEDmg = (10*GetCastLevel(myHero,_E)+50)+(0.2*GetBonusDmg(myHero))+(0.6*GetBonusAP(myHero))
						if GetCurrentHP(minion) < YasuoEDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
							CastTargetSpell(minion, _E)
						end
					end
				end
			else
				if CanUseSpell(myHero,_E) == READY then
					if ValidTarget(minion, YasuoE.range) then
						local YasuoEDmg = (10*GetCastLevel(myHero,_E)+50)+(0.2*GetBonusDmg(myHero))+(0.6*GetBonusAP(myHero))
						if GetCurrentHP(minion) < YasuoEDmg then
							DrawCircle(GetOrigin(minion),100,2,25,0xffffff00)
						end
					end
				end
			end
		end
	end
end)
end