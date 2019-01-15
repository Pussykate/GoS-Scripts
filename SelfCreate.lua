-- 
--   ██████ ▓█████  ██▓      █████▒▄████▄   ██▀███  ▓█████ ▄▄▄     ▄▄▄█████▓▓█████ 
-- ▒██    ▒ ▓█   ▀ ▓██▒    ▓██   ▒▒██▀ ▀█  ▓██ ▒ ██▒▓█   ▀▒████▄   ▓  ██▒ ▓▒▓█   ▀ 
-- ░ ▓██▄   ▒███   ▒██░    ▒████ ░▒▓█    ▄ ▓██ ░▄█ ▒▒███  ▒██  ▀█▄ ▒ ▓██░ ▒░▒███   
--   ▒   ██▒▒▓█  ▄ ▒██░    ░▓█▒  ░▒▓▓▄ ▄██▒▒██▀▀█▄  ▒▓█  ▄░██▄▄▄▄██░ ▓██▓ ░ ▒▓█  ▄ 
-- ▒██████▒▒░▒████▒░██████▒░▒█░   ▒ ▓███▀ ░░██▓ ▒██▒░▒████▒▓█   ▓██▒ ▒██▒ ░ ░▒████▒
-- ▒ ▒▓▒ ▒ ░░░ ▒░ ░░ ▒░▓  ░ ▒ ░   ░ ░▒ ▒  ░░ ▒▓ ░▒▓░░░ ▒░ ░▒▒   ▓▒█░ ▒ ░░   ░░ ▒░ ░
-- ░ ░▒  ░ ░ ░ ░  ░░ ░ ▒  ░ ░       ░  ▒     ░▒ ░ ▒░ ░ ░  ░ ▒   ▒▒ ░   ░     ░ ░  ░
-- ░  ░  ░     ░     ░ ░    ░ ░   ░          ░░   ░    ░    ░   ▒    ░         ░   
--       ░     ░  ░    ░  ░       ░ ░         ░        ░  ░     ░  ░           ░  ░
--                                ░                                                
-- ==================
-- == Requirements ==
-- ==================
-- + Orbwalker: IOW/GosWalk
-- ===============
-- == Changelog ==
-- ===============
-- 1.0
-- + Initial release

local SCVer = 1.0

function AutoUpdate(data)
	local num = tonumber(data)
	if num > SCVer then
		PrintChat("<font color='#1E90FF'>[<font color='#00BFFF'>GoS-U<font color='#1E90FF'>] <font color='#00BFFF'>New version found! " .. data)
		PrintChat("<font color='#1E90FF'>[<font color='#00BFFF'>GoS-U<font color='#1E90FF'>] <font color='#00BFFF'>Downloading update, please wait...")
		DownloadFileAsync("https://raw.githubusercontent.com/Ark223/GoS-Scripts/master/SelfCreate.lua", SCRIPT_PATH .. "SelfCreate.lua", function() PrintChat("<font color='#1E90FF'>[<font color='#00BFFF'>GoS-U<font color='#1E90FF'>] <font color='#00BFFF'>Successfully updated. Please 2x F6!") return end)
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/Ark223/GoS-Scripts/master/SelfCreate.version", AutoUpdate)

require('Inspired')
require('IPrediction')
require('OpenPredict')

function Mode()
	if _G.IOW_Loaded and IOW:Mode() then
		return IOW:Mode()
	elseif GoSWalkLoaded and GoSWalk.CurrentMode then
		return ({"Combo", "Harass", "LaneClear", "LastHit"})[GoSWalk.CurrentMode+1]
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

PrintChat("<font color='#1E90FF'>[<font color='#00BFFF'>SelfCreate<font color='#1E90FF'>] <font color='#00BFFF'>Script loaded successfully!")

local SCMenu = Menu("SelfCreate", "SelfCreate")
SCMenu:Menu("QSpell", "Q Spell")
SCMenu.QSpell:Boolean('QAuto', 'Auto Q', true)
SCMenu.QSpell:DropDown('QAutoMode', 'Auto Q Mode:', 1, {"Standard", "On Immobile"})
SCMenu.QSpell:Slider('QAutoMP', 'Mana-Manager: Auto', 40, 0, 100, 1)
SCMenu.QSpell:Boolean('QCombo', 'Use Q In Combo', true)
SCMenu.QSpell:Boolean('QHarass', 'Use Q In Harass', true)
SCMenu.QSpell:Slider('QHarassMP', 'Mana-Manager: Harass', 40, 0, 100, 1)
SCMenu.QSpell:DropDown('QOrigin', 'Spell Origin', 5, {"SelfCast", "SkillShot", "SkillShot2", "SkillShot3", "Targeted"})
SCMenu.QSpell:DropDown('QType', 'Spell Type', 1, {"line", "circular", "cone"})
SCMenu.QSpell:DropDown('QUsage', 'Spell Usage', 2, {"On Allies", "On Enemies"})
SCMenu.QSpell:DropDown('QPred', "Prediction", 2, {"CurrentPos", "GoSPred", "GPrediction", "OpenPredict"})
SCMenu.QSpell:Slider('QSpeed', 'Speed', 2000, 10, 8000, 10)
SCMenu.QSpell:Slider('QRange', 'Range', 600, 10, 3000, 10)
SCMenu.QSpell:Slider('QDelay', 'Delay', 0.25, 0, 4, 0.01)
SCMenu.QSpell:Slider('QAngle', 'Angle', 1, 1, 180, 1)
SCMenu.QSpell:Slider('QRadius', 'Radius', 5, 5, 1000, 5)
SCMenu.QSpell:Boolean('QRangeDraw', 'Draw Range', true)
SCMenu.QSpell:Boolean('QCol', 'Check Collision', false)
SCMenu.QSpell:Boolean('QAA', 'Check AA Reset', true)
SCMenu.QSpell:Boolean('QPush', 'Push To Cast', false)
SCMenu.QSpell:Key('QKey', 'Cast Key', string.byte("A"))
SCMenu:Menu("WSpell", "W Spell")
SCMenu.WSpell:Boolean('WAuto', 'Auto W', false)
SCMenu.WSpell:DropDown('WAutoMode', 'Auto W Mode:', 2, {"Standard", "On Immobile"})
SCMenu.WSpell:Slider('WAutoMP', 'Mana-Manager: Auto', 40, 0, 100, 1)
SCMenu.WSpell:Boolean('WCombo', 'Use W In Combo', true)
SCMenu.WSpell:Boolean('WHarass', 'Use W In Harass', true)
SCMenu.WSpell:Slider('WHarassMP', 'Mana-Manager: Harass', 40, 0, 100, 1)
SCMenu.WSpell:DropDown('WOrigin', 'Spell Origin', 2, {"SelfCast", "SkillShot", "SkillShot2", "SkillShot3", "Targeted"})
SCMenu.WSpell:DropDown('WType', 'Spell Type', 2, {"line", "circular", "cone"})
SCMenu.WSpell:DropDown('WUsage', 'Spell Usage', 2, {"On Allies", "On Enemies"})
SCMenu.WSpell:DropDown('WPred', "Prediction", 2, {"CurrentPos", "GoSPred", "GPrediction", "OpenPredict"})
SCMenu.WSpell:Slider('WSpeed', 'Speed', 8000, 10, 8000, 10)
SCMenu.WSpell:Slider('WRange', 'Range', 700, 10, 3000, 10)
SCMenu.WSpell:Slider('WDelay', 'Delay', 1.33, 0, 4, 0.01)
SCMenu.WSpell:Slider('WAngle', 'Angle', 1, 1, 180, 1)
SCMenu.WSpell:Slider('WRadius', 'Radius', 290, 5, 1000, 5)
SCMenu.WSpell:Boolean('WRangeDraw', 'Draw Range', true)
SCMenu.WSpell:Boolean('WCol', 'Check Collision', false)
SCMenu.WSpell:Boolean('WAA', 'Check AA Reset', false)
SCMenu.WSpell:Boolean('WPush', 'Push To Cast', false)
SCMenu.WSpell:Key('WKey', 'Cast Key', string.byte("A"))
SCMenu:Menu("ESpell", "E Spell")
SCMenu.ESpell:Boolean('EAuto', 'Auto E', true)
SCMenu.ESpell:DropDown('EAutoMode', 'Auto E Mode:', 1, {"Standard", "On Immobile"})
SCMenu.ESpell:Slider('EAutoMP', 'Mana-Manager: Auto', 40, 0, 100, 1)
SCMenu.ESpell:Boolean('ECombo', 'Use E In Combo', true)
SCMenu.ESpell:Boolean('EHarass', 'Use E In Harass', true)
SCMenu.ESpell:Slider('EHarassMP', 'Mana-Manager: Harass', 40, 0, 100, 1)
SCMenu.ESpell:DropDown('EOrigin', 'Spell Origin', 4, {"SelfCast", "SkillShot", "SkillShot2", "SkillShot3", "Targeted"})
SCMenu.ESpell:DropDown('EType', 'Spell Type', 1, {"line", "circular", "cone"})
SCMenu.ESpell:DropDown('EUsage', 'Spell Usage', 2, {"On Allies", "On Enemies"})
SCMenu.ESpell:DropDown('EPred', "Prediction", 2, {"CurrentPos", "GoSPred", "GPrediction", "OpenPredict"})
SCMenu.ESpell:Slider('ESpeed', 'Speed', 1350, 10, 8000, 10)
SCMenu.ESpell:Slider('ERange', 'Range', 1025, 10, 3000, 10)
SCMenu.ESpell:Slider('EDelay', 'Delay', 0, 0, 4, 0.01)
SCMenu.ESpell:Slider('EAngle', 'Angle', 1, 1, 180, 1)
SCMenu.ESpell:Slider('ERadius', 'Radius', 80, 5, 1000, 5)
SCMenu.ESpell:Boolean('ERangeDraw', 'Draw Range', true)
SCMenu.ESpell:Boolean('ECol', 'Check Collision', false)
SCMenu.ESpell:Boolean('EAA', 'Check AA Reset', false)
SCMenu.ESpell:Boolean('EPush', 'Push To Cast', false)
SCMenu.ESpell:Key('EKey', 'Cast Key', string.byte("A"))
SCMenu:Menu("RSpell", "R Spell")
SCMenu.RSpell:Boolean('RCombo', 'Use R In Combo', true)
SCMenu.RSpell:Slider('X','Minimum Enemies: R', 1, 0, 5, 1)
SCMenu.RSpell:Slider('HP','HP-Manager: R', 40, 0, 100, 5)
SCMenu.RSpell:DropDown('ROrigin', 'Spell Origin', 2, {"SelfCast", "SkillShot", "SkillShot2", "SkillShot3", "Targeted"})
SCMenu.RSpell:DropDown('RType', 'Spell Type', 2, {"line", "circular", "cone"})
SCMenu.RSpell:DropDown('RUsage', 'Spell Usage', 2, {"On Allies", "On Enemies"})
SCMenu.RSpell:DropDown('RPred', "Prediction", 4, {"CurrentPos", "GoSPred", "GPrediction", "OpenPredict"})
SCMenu.RSpell:Slider('RSpeed', 'Speed', 8000, 10, 8000, 10)
SCMenu.RSpell:Slider('RRange', 'Range', 700, 10, 3000, 10)
SCMenu.RSpell:Slider('RDelay', 'Delay', 0.25, 0, 4, 0.01)
SCMenu.RSpell:Slider('RAngle', 'Angle', 1, 1, 180, 1)
SCMenu.RSpell:Slider('RRadius', 'Radius', 290, 5, 1000, 5)
SCMenu.RSpell:Boolean('RRangeDraw', 'Draw Range', true)
SCMenu.RSpell:Boolean('RCol', 'Check Collision', false)
SCMenu.RSpell:Boolean('RAA', 'Check AA Reset', false)
SCMenu.RSpell:Boolean('RPush', 'Push To Cast', false)
SCMenu.RSpell:Key('RKey', 'Cast Key', string.byte("A"))
SCMenu:Menu("SS2", "SkillShot2")
SCMenu.SS2:Key('SS2Key', 'Release Key', string.byte("A"))
SCMenu:Menu("SS3", "SkillShot3")
SCMenu.SS3:Slider('SS3Range', 'Effect Range', 500, 5, 2000, 5)

OnDraw(function(myHero)
	if SCMenu.QSpell.QRangeDraw:Value() then DrawCircle(GetOrigin(myHero),SCMenu.QSpell.QRange:Value(),1,25,0xff00bfff) end
	if SCMenu.WSpell.WRangeDraw:Value() then DrawCircle(GetOrigin(myHero),SCMenu.WSpell.WRange:Value(),1,25,0xff4169e1) end
	if SCMenu.ESpell.ERangeDraw:Value() then DrawCircle(GetOrigin(myHero),SCMenu.ESpell.ERange:Value(),1,25,0xff1e90ff) end
	if SCMenu.RSpell.RRangeDraw:Value() then DrawCircle(GetOrigin(myHero),SCMenu.RSpell.RRange:Value(),1,25,0xff0000ff) end
end)
OnTick(function(myHero)
	target = GetCurrentTarget()
	Combo()
	Harass()
	Auto()
end)

function Combo()
	if Mode() == "Combo" then
		if SCMenu.QSpell.QCombo:Value() then
			if CanUseSpell(myHero,_Q) == READY then
				if SCMenu.QSpell.QUsage:Value() == 1 then
					for _,ally in pairs(GoS:GetAllyHeroes()) do
						if ValidTarget(ally, SCMenu.QSpell.QRange:Value()) then
							if SCMenu.QSpell.QOrigin:Value() == 1 then
								if SCMenu.QSpell.QAA:Value() then
									if AA == true then
										CastSpell(_Q)
									end
								else
									CastSpell(_Q)
								end
							elseif SCMenu.QSpell.QOrigin:Value() == 2 or SCMenu.QSpell.QOrigin:Value() == 3 or SCMenu.QSpell.QOrigin:Value() == 4 then
								if SCMenu.QSpell.QAA:Value() then
									if AA == true then
										useQ(ally)
									end
								else
									useQ(ally)
								end
							elseif SCMenu.QSpell.QOrigin:Value() == 5 then
								if SCMenu.QSpell.QAA:Value() then
									if AA == true then
										CastTargetSpell(ally, _Q)
									end
								else
									CastTargetSpell(ally, _Q)
								end
							end
						end
					end
				elseif SCMenu.QSpell.QUsage:Value() == 2 then
					if ValidTarget(target, SCMenu.QSpell.QRange:Value()) then
						if SCMenu.QSpell.QOrigin:Value() == 1 then
							if SCMenu.QSpell.QAA:Value() then
								if AA == true then
									CastSpell(_Q)
								end
							else
								CastSpell(_Q)
							end
						elseif SCMenu.QSpell.QOrigin:Value() == 2 or SCMenu.QSpell.QOrigin:Value() == 3 or SCMenu.QSpell.QOrigin:Value() == 4 then
							if SCMenu.QSpell.QAA:Value() then
								if AA == true then
									useQ(target)
								end
							else
								useQ(target)
							end
						elseif SCMenu.QSpell.QOrigin:Value() == 5 then
							if SCMenu.QSpell.QAA:Value() then
								if AA == true then
									CastTargetSpell(target, _Q)
								end
							else
								CastTargetSpell(target, _Q)
							end
						end
					end
				end
			end
		end
		if SCMenu.WSpell.WCombo:Value() then
			if CanUseSpell(myHero,_W) == READY then
				if SCMenu.WSpell.WUsage:Value() == 1 then
					for _,ally in pairs(GoS:GetAllyHeroes()) do
						if ValidTarget(ally, SCMenu.WSpell.WRange:Value()) then
							if SCMenu.WSpell.WOrigin:Value() == 1 then
								if SCMenu.WSpell.WAA:Value() then
									if AA == true then
										CastSpell(_W)
									end
								else
									CastSpell(_W)
								end
							elseif SCMenu.WSpell.WOrigin:Value() == 2 or SCMenu.WSpell.WOrigin:Value() == 3 or SCMenu.WSpell.WOrigin:Value() == 4 then
								if SCMenu.WSpell.WAA:Value() then
									if AA == true then
										useW(ally)
									end
								else
									useW(ally)
								end
							elseif SCMenu.WSpell.WOrigin:Value() == 5 then
								if SCMenu.WSpell.WAA:Value() then
									if AA == true then
										CastTargetSpell(ally, _W)
									end
								else
									CastTargetSpell(ally, _W)
								end
							end
						end
					end
				elseif SCMenu.WSpell.WUsage:Value() == 2 then
					if ValidTarget(target, SCMenu.WSpell.WRange:Value()) then
						if SCMenu.WSpell.WOrigin:Value() == 1 then
							if SCMenu.WSpell.WAA:Value() then
								if AA == true then
									CastSpell(_W)
								end
							else
								CastSpell(_W)
							end
						elseif SCMenu.WSpell.WOrigin:Value() == 2 or SCMenu.WSpell.WOrigin:Value() == 3 or SCMenu.WSpell.WOrigin:Value() == 4 then
							if SCMenu.WSpell.WAA:Value() then
								if AA == true then
									useW(target)
								end
							else
								useW(target)
							end
						elseif SCMenu.WSpell.WOrigin:Value() == 5 then
							if SCMenu.WSpell.WAA:Value() then
								if AA == true then
									CastTargetSpell(target, _W)
								end
							else
								CastTargetSpell(target, _W)
							end
						end
					end
				end
			end
		end
		if SCMenu.ESpell.ECombo:Value() then
			if CanUseSpell(myHero,_E) == READY then
				if SCMenu.ESpell.EUsage:Value() == 1 then
					for _,ally in pairs(GoS:GetAllyHeroes()) do
						if ValidTarget(ally, SCMenu.ESpell.ERange:Value()) then
							if SCMenu.ESpell.EOrigin:Value() == 1 then
								if SCMenu.ESpell.EAA:Value() then
									if AA == true then
										CastSpell(_E)
									end
								else
									CastSpell(_E)
								end
							elseif SCMenu.ESpell.EOrigin:Value() == 2 or SCMenu.ESpell.EOrigin:Value() == 3 or SCMenu.ESpell.EOrigin:Value() == 4 then
								if SCMenu.ESpell.EAA:Value() then
									if AA == true then
										useE(ally)
									end
								else
									useE(ally)
								end
							elseif SCMenu.ESpell.EOrigin:Value() == 5 then
								if SCMenu.ESpell.EAA:Value() then
									if AA == true then
										CastTargetSpell(ally, _E)
									end
								else
									CastTargetSpell(ally, _E)
								end
							end
						end
					end
				elseif SCMenu.ESpell.EUsage:Value() == 2 then
					if ValidTarget(target, SCMenu.ESpell.ERange:Value()) then
						if SCMenu.ESpell.EOrigin:Value() == 1 then
							if SCMenu.ESpell.EAA:Value() then
								if AA == true then
									CastSpell(_E)
								end
							else
								CastSpell(_E)
							end
						elseif SCMenu.ESpell.EOrigin:Value() == 2 or SCMenu.ESpell.EOrigin:Value() == 3 or SCMenu.ESpell.EOrigin:Value() == 4 then
							if SCMenu.ESpell.EAA:Value() then
								if AA == true then
									useE(target)
								end
							else
								useE(target)
							end
						elseif SCMenu.ESpell.EOrigin:Value() == 5 then
							if SCMenu.ESpell.EAA:Value() then
								if AA == true then
									CastTargetSpell(target, _E)
								end
							else
								CastTargetSpell(target, _E)
							end
						end
					end
				end
			end
		end
		if SCMenu.RSpell.RCombo:Value() then
			if 100*GetCurrentHP(target)/GetMaxHP(target) < SCMenu.RSpell.HP:Value() then
				if EnemiesAround(myHero, SCMenu.RSpell.RRange:Value()+100) >= SCMenu.RSpell.X:Value() then
					if CanUseSpell(myHero,_R) == READY then
						if SCMenu.RSpell.RUsage:Value() == 1 then
							for _,ally in pairs(GoS:GetAllyHeroes()) do
								if ValidTarget(ally, SCMenu.RSpell.RRange:Value()) then
									if SCMenu.RSpell.ROrigin:Value() == 1 then
										if SCMenu.RSpell.RAA:Value() then
											if AA == true then
												CastSpell(_R)
											end
										else
											CastSpell(_R)
										end
									elseif SCMenu.RSpell.ROrigin:Value() == 2 or SCMenu.RSpell.ROrigin:Value() == 3 or SCMenu.RSpell.ROrigin:Value() == 4 then
										if SCMenu.RSpell.RAA:Value() then
											if AA == true then
												useR(ally)
											end
										else
											useR(ally)
										end
									elseif SCMenu.RSpell.ROrigin:Value() == 5 then
										if SCMenu.RSpell.RAA:Value() then
											if AA == true then
												CastTargetSpell(ally, _R)
											end
										else
											CastTargetSpell(ally, _R)
										end
									end
								end
							end
						elseif SCMenu.RSpell.RUsage:Value() == 2 then
							if ValidTarget(target, SCMenu.RSpell.RRange:Value()) then
								if SCMenu.RSpell.ROrigin:Value() == 1 then
									if SCMenu.RSpell.RAA:Value() then
										if AA == true then
											CastSpell(_R)
										end
									else
										CastSpell(_R)
									end
								elseif SCMenu.RSpell.ROrigin:Value() == 2 or SCMenu.RSpell.ROrigin:Value() == 3 or SCMenu.RSpell.ROrigin:Value() == 4 then
									if SCMenu.RSpell.RAA:Value() then
										if AA == true then
											useR(target)
										end
									else
										useR(target)
									end
								elseif SCMenu.RSpell.ROrigin:Value() == 5 then
									if SCMenu.RSpell.RAA:Value() then
										if AA == true then
											CastTargetSpell(target, _R)
										end
									else
										CastTargetSpell(target, _R)
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
function Harass()
	if Mode() == "Harass" then
		if SCMenu.QSpell.QHarass:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > SCMenu.QSpell.QHarassMP:Value() then
				if CanUseSpell(myHero,_Q) == READY then
					if SCMenu.QSpell.QUsage:Value() == 1 then
						for _,ally in pairs(GoS:GetAllyHeroes()) do
							if ValidTarget(ally, SCMenu.QSpell.QRange:Value()) then
								if SCMenu.QSpell.QOrigin:Value() == 1 then
									if SCMenu.QSpell.QAA:Value() then
										if AA == true then
											CastSpell(_Q)
										end
									else
										CastSpell(_Q)
									end
								elseif SCMenu.QSpell.QOrigin:Value() == 2 or SCMenu.QSpell.QOrigin:Value() == 3 or SCMenu.QSpell.QOrigin:Value() == 4 then
									if SCMenu.QSpell.QAA:Value() then
										if AA == true then
											useQ(ally)
										end
									else
										useQ(ally)
									end
								elseif SCMenu.QSpell.QOrigin:Value() == 5 then
									if SCMenu.QSpell.QAA:Value() then
										if AA == true then
											CastTargetSpell(ally, _Q)
										end
									else
										CastTargetSpell(ally, _Q)
									end
								end
							end
						end
					elseif SCMenu.QSpell.QUsage:Value() == 2 then
						if ValidTarget(target, SCMenu.QSpell.QRange:Value()) then
							if SCMenu.QSpell.QOrigin:Value() == 1 then
								if SCMenu.QSpell.QAA:Value() then
									if AA == true then
										CastSpell(_Q)
									end
								else
									CastSpell(_Q)
								end
							elseif SCMenu.QSpell.QOrigin:Value() == 2 or SCMenu.QSpell.QOrigin:Value() == 3 or SCMenu.QSpell.QOrigin:Value() == 4 then
								if SCMenu.QSpell.QAA:Value() then
									if AA == true then
										useQ(target)
									end
								else
									useQ(target)
								end
							elseif SCMenu.QSpell.QOrigin:Value() == 5 then
								if SCMenu.QSpell.QAA:Value() then
									if AA == true then
										CastTargetSpell(target, _Q)
									end
								else
									CastTargetSpell(target, _Q)
								end
							end
						end
					end
				end
			end
		end
		if SCMenu.WSpell.WHarass:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > SCMenu.WSpell.WHarassMP:Value() then
				if CanUseSpell(myHero,_W) == READY then
					if SCMenu.WSpell.WUsage:Value() == 1 then
						for _,ally in pairs(GoS:GetAllyHeroes()) do
							if ValidTarget(ally, SCMenu.WSpell.WRange:Value()) then
								if SCMenu.WSpell.WOrigin:Value() == 1 then
									if SCMenu.WSpell.WAA:Value() then
										if AA == true then
											CastSpell(_W)
										end
									else
										CastSpell(_W)
									end
								elseif SCMenu.WSpell.WOrigin:Value() == 2 or SCMenu.WSpell.WOrigin:Value() == 3 or SCMenu.WSpell.WOrigin:Value() == 4 then
									if SCMenu.WSpell.WAA:Value() then
										if AA == true then
											useW(ally)
										end
									else
										useW(ally)
									end
								elseif SCMenu.WSpell.WOrigin:Value() == 5 then
									if SCMenu.WSpell.WAA:Value() then
										if AA == true then
											CastTargetSpell(ally, _W)
										end
									else
										CastTargetSpell(ally, _W)
									end
								end
							end
						end
					elseif SCMenu.WSpell.WUsage:Value() == 2 then
						if ValidTarget(target, SCMenu.WSpell.WRange:Value()) then
							if SCMenu.WSpell.WOrigin:Value() == 1 then
								if SCMenu.WSpell.WAA:Value() then
									if AA == true then
										CastSpell(_W)
									end
								else
									CastSpell(_W)
								end
							elseif SCMenu.WSpell.WOrigin:Value() == 2 or SCMenu.WSpell.WOrigin:Value() == 3 or SCMenu.WSpell.WOrigin:Value() == 4 then
								if SCMenu.WSpell.WAA:Value() then
									if AA == true then
										useW(target)
									end
								else
									useW(target)
								end
							elseif SCMenu.WSpell.WOrigin:Value() == 5 then
								if SCMenu.WSpell.WAA:Value() then
									if AA == true then
										CastTargetSpell(target, _W)
									end
								else
									CastTargetSpell(target, _W)
								end
							end
						end
					end
				end
			end
		end
		if SCMenu.ESpell.EHarass:Value() then
			if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > SCMenu.ESpell.EHarassMP:Value() then
				if CanUseSpell(myHero,_E) == READY then
					if SCMenu.ESpell.EUsage:Value() == 1 then
						for _,ally in pairs(GoS:GetAllyHeroes()) do
							if ValidTarget(ally, SCMenu.ESpell.ERange:Value()) then
								if SCMenu.ESpell.EOrigin:Value() == 1 then
									if SCMenu.ESpell.EAA:Value() then
										if AA == true then
											CastSpell(_E)
										end
									else
										CastSpell(_E)
									end
								elseif SCMenu.ESpell.EOrigin:Value() == 2 or SCMenu.ESpell.EOrigin:Value() == 3 or SCMenu.ESpell.EOrigin:Value() == 4 then
									if SCMenu.ESpell.EAA:Value() then
										if AA == true then
											useE(ally)
										end
									else
										useE(ally)
									end
								elseif SCMenu.ESpell.EOrigin:Value() == 5 then
									if SCMenu.ESpell.EAA:Value() then
										if AA == true then
											CastTargetSpell(ally, _E)
										end
									else
										CastTargetSpell(ally, _E)
									end
								end
							end
						end
					elseif SCMenu.ESpell.EUsage:Value() == 2 then
						if ValidTarget(target, SCMenu.ESpell.ERange:Value()) then
							if SCMenu.ESpell.EOrigin:Value() == 1 then
								if SCMenu.ESpell.EAA:Value() then
									if AA == true then
										CastSpell(_E)
									end
								else
									CastSpell(_E)
								end
							elseif SCMenu.ESpell.EOrigin:Value() == 2 or SCMenu.ESpell.EOrigin:Value() == 3 or SCMenu.ESpell.EOrigin:Value() == 4 then
								if SCMenu.ESpell.EAA:Value() then
									if AA == true then
										useE(target)
									end
								else
									useE(target)
								end
							elseif SCMenu.ESpell.EOrigin:Value() == 5 then
								if SCMenu.ESpell.EAA:Value() then
									if AA == true then
										CastTargetSpell(target, _E)
									end
								else
									CastTargetSpell(target, _E)
								end
							end
						end
					end
				end
			end
		end
	end
end
function Auto()
	if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > SCMenu.QSpell.QAutoMP:Value() then
		if CanUseSpell(myHero,_Q) == READY then
			if SCMenu.QSpell.QAuto:Value() then
				if SCMenu.QSpell.QUsage:Value() == 1 then
					for _,ally in pairs(GoS:GetAllyHeroes()) do
						if ValidTarget(ally, SCMenu.QSpell.QRange:Value()) then
							if SCMenu.QSpell.QOrigin:Value() == 1 then
								CastSpell(_Q)
							elseif SCMenu.QSpell.QOrigin:Value() == 2 or SCMenu.QSpell.QOrigin:Value() == 3 or SCMenu.QSpell.QOrigin:Value() == 4 then
								useQ(ally)
							elseif SCMenu.QSpell.QOrigin:Value() == 5 then
								CastTargetSpell(ally, _Q)
							end
						end
					end
				elseif SCMenu.QSpell.QUsage:Value() == 2 then
					if ValidTarget(target, SCMenu.QSpell.QRange:Value()) then
						if SCMenu.QSpell.QAutoMode:Value() == 1 then
							if SCMenu.QSpell.QOrigin:Value() == 1 then
								CastSpell(_Q)
							elseif SCMenu.QSpell.QOrigin:Value() == 2 or SCMenu.QSpell.QOrigin:Value() == 3 or SCMenu.QSpell.QOrigin:Value() == 4 then
								useQ(target)
							elseif SCMenu.QSpell.QOrigin:Value() == 5 then
								CastTargetSpell(target, _Q)
							end
						elseif SCMenu.QSpell.QAutoMode:Value() == 2 then
							if GotBuff(target, "veigareventhorizonstun") > 0 or GotBuff(target, "Stun") > 0 or GotBuff(target, "Taunt") > 0 or GotBuff(target, "Slow") > 0 or GotBuff(target, "Snare") > 0 or GotBuff(target, "Charm") > 0 or GotBuff(target, "Suppression") > 0 or GotBuff(target, "Flee") > 0 or GotBuff(target, "Knockup") > 0 then
								if SCMenu.QSpell.QOrigin:Value() == 1 then
									CastSpell(_Q)
								elseif SCMenu.QSpell.QOrigin:Value() == 2 or SCMenu.QSpell.QOrigin:Value() == 3 or SCMenu.QSpell.QOrigin:Value() == 4 then
									useQ(target)
								elseif SCMenu.QSpell.QOrigin:Value() == 5 then
									CastTargetSpell(target, _Q)
								end
							end
						end
					end
				end
			end
			if SCMenu.QSpell.QKey:Value() and SCMenu.QSpell.QPush:Value() then
				if SCMenu.QSpell.QUsage:Value() == 1 then
					for _,ally in pairs(GoS:GetAllyHeroes()) do
						if ValidTarget(ally, SCMenu.QSpell.QRange:Value()) then
							if SCMenu.QSpell.QOrigin:Value() == 1 then
								CastSpell(_Q)
							elseif SCMenu.QSpell.QOrigin:Value() == 2 or SCMenu.QSpell.QOrigin:Value() == 3 or SCMenu.QSpell.QOrigin:Value() == 4 then
								useQ(ally)
							elseif SCMenu.QSpell.QOrigin:Value() == 5 then
								CastTargetSpell(ally, _Q)
							end
						end
					end
				elseif SCMenu.QSpell.QUsage:Value() == 2 then
					if ValidTarget(target, SCMenu.QSpell.QRange:Value()) then
						if SCMenu.QSpell.QAutoMode:Value() == 1 then
							useQ(target)
						elseif SCMenu.QSpell.QAutoMode:Value() == 2 then
							if GotBuff(target, "veigareventhorizonstun") > 0 or GotBuff(target, "Stun") > 0 or GotBuff(target, "Taunt") > 0 or GotBuff(target, "Slow") > 0 or GotBuff(target, "Snare") > 0 or GotBuff(target, "Charm") > 0 or GotBuff(target, "Suppression") > 0 or GotBuff(target, "Flee") > 0 or GotBuff(target, "Knockup") > 0 then
								if SCMenu.QSpell.QOrigin:Value() == 1 then
									CastSpell(_Q)
								elseif SCMenu.QSpell.QOrigin:Value() == 2 or SCMenu.QSpell.QOrigin:Value() == 3 or SCMenu.QSpell.QOrigin:Value() == 4 then
									useQ(target)
								elseif SCMenu.QSpell.QOrigin:Value() == 5 then
									CastTargetSpell(target, _Q)
								end
							end
						end
					end
				end
			end
			if SCMenu.WSpell.WAuto:Value() then
				if SCMenu.WSpell.WUsage:Value() == 1 then
					for _,ally in pairs(GoS:GetAllyHeroes()) do
						if ValidTarget(ally, SCMenu.WSpell.WRange:Value()) then
							if SCMenu.WSpell.WOrigin:Value() == 1 then
								CastSpell(_W)
							elseif SCMenu.WSpell.WOrigin:Value() == 2 or SCMenu.WSpell.WOrigin:Value() == 3 or SCMenu.WSpell.WOrigin:Value() == 4 then
								useW(ally)
							elseif SCMenu.WSpell.WOrigin:Value() == 5 then
								CastTargetSpell(ally, _W)
							end
						end
					end
				elseif SCMenu.WSpell.WUsage:Value() == 2 then
					if ValidTarget(target, SCMenu.WSpell.WRange:Value()) then
						if SCMenu.WSpell.WAutoMode:Value() == 1 then
							if SCMenu.WSpell.WOrigin:Value() == 1 then
								CastSpell(_W)
							elseif SCMenu.WSpell.WOrigin:Value() == 2 or SCMenu.WSpell.WOrigin:Value() == 3 or SCMenu.WSpell.WOrigin:Value() == 4 then
								useW(target)
							elseif SCMenu.WSpell.WOrigin:Value() == 5 then
								CastTargetSpell(target, _W)
							end
						elseif SCMenu.WSpell.WAutoMode:Value() == 2 then
							if GotBuff(target, "veigareventhorizonstun") > 0 or GotBuff(target, "Stun") > 0 or GotBuff(target, "Taunt") > 0 or GotBuff(target, "Slow") > 0 or GotBuff(target, "Snare") > 0 or GotBuff(target, "Charm") > 0 or GotBuff(target, "Suppression") > 0 or GotBuff(target, "Flee") > 0 or GotBuff(target, "Knockup") > 0 then
								if SCMenu.WSpell.WOrigin:Value() == 1 then
									CastSpell(_W)
								elseif SCMenu.WSpell.WOrigin:Value() == 2 or SCMenu.WSpell.WOrigin:Value() == 3 or SCMenu.WSpell.WOrigin:Value() == 4 then
									useW(target)
								elseif SCMenu.WSpell.WOrigin:Value() == 5 then
									CastTargetSpell(target, _W)
								end
							end
						end
					end
				end
			end
			if SCMenu.WSpell.WKey:Value() and SCMenu.WSpell.WPush:Value() then
				if SCMenu.WSpell.WUsage:Value() == 1 then
					for _,ally in pairs(GoS:GetAllyHeroes()) do
						if ValidTarget(ally, SCMenu.WSpell.WRange:Value()) then
							if SCMenu.WSpell.WOrigin:Value() == 1 then
								CastSpell(_W)
							elseif SCMenu.WSpell.WOrigin:Value() == 2 or SCMenu.WSpell.WOrigin:Value() == 3 or SCMenu.WSpell.WOrigin:Value() == 4 then
								useW(ally)
							elseif SCMenu.WSpell.WOrigin:Value() == 5 then
								CastTargetSpell(ally, _W)
							end
						end
					end
				elseif SCMenu.WSpell.WUsage:Value() == 2 then
					if ValidTarget(target, SCMenu.WSpell.WRange:Value()) then
						if SCMenu.WSpell.WAutoMode:Value() == 1 then
							useW(target)
						elseif SCMenu.WSpell.WAutoMode:Value() == 2 then
							if GotBuff(target, "veigareventhorizonstun") > 0 or GotBuff(target, "Stun") > 0 or GotBuff(target, "Taunt") > 0 or GotBuff(target, "Slow") > 0 or GotBuff(target, "Snare") > 0 or GotBuff(target, "Charm") > 0 or GotBuff(target, "Suppression") > 0 or GotBuff(target, "Flee") > 0 or GotBuff(target, "Knockup") > 0 then
								if SCMenu.WSpell.WOrigin:Value() == 1 then
									CastSpell(_W)
								elseif SCMenu.WSpell.WOrigin:Value() == 2 or SCMenu.WSpell.WOrigin:Value() == 3 or SCMenu.WSpell.WOrigin:Value() == 4 then
									useW(target)
								elseif SCMenu.WSpell.WOrigin:Value() == 5 then
									CastTargetSpell(target, _W)
								end
							end
						end
					end
				end
			end
			if SCMenu.ESpell.EAuto:Value() then
				if SCMenu.ESpell.EUsage:Value() == 1 then
					for _,ally in pairs(GoS:GetAllyHeroes()) do
						if ValidTarget(ally, SCMenu.ESpell.ERange:Value()) then
							if SCMenu.ESpell.EOrigin:Value() == 1 then
								CastSpell(_E)
							elseif SCMenu.ESpell.EOrigin:Value() == 2 or SCMenu.ESpell.EOrigin:Value() == 3 or SCMenu.ESpell.EOrigin:Value() == 4 then
								useE(ally)
							elseif SCMenu.ESpell.EOrigin:Value() == 5 then
								CastTargetSpell(ally, _E)
							end
						end
					end
				elseif SCMenu.ESpell.EUsage:Value() == 2 then
					if ValidTarget(target, SCMenu.ESpell.ERange:Value()) then
						if SCMenu.ESpell.EAutoMode:Value() == 1 then
							if SCMenu.ESpell.EOrigin:Value() == 1 then
								CastSpell(_E)
							elseif SCMenu.ESpell.EOrigin:Value() == 2 or SCMenu.ESpell.EOrigin:Value() == 3 or SCMenu.ESpell.EOrigin:Value() == 4 then
								useE(target)
							elseif SCMenu.ESpell.EOrigin:Value() == 5 then
								CastTargetSpell(target, _E)
							end
						elseif SCMenu.ESpell.EAutoMode:Value() == 2 then
							if GotBuff(target, "veigareventhorizonstun") > 0 or GotBuff(target, "Stun") > 0 or GotBuff(target, "Taunt") > 0 or GotBuff(target, "Slow") > 0 or GotBuff(target, "Snare") > 0 or GotBuff(target, "Charm") > 0 or GotBuff(target, "Suppression") > 0 or GotBuff(target, "Flee") > 0 or GotBuff(target, "Knockup") > 0 then
								if SCMenu.ESpell.EOrigin:Value() == 1 then
									CastSpell(_E)
								elseif SCMenu.ESpell.EOrigin:Value() == 2 or SCMenu.ESpell.EOrigin:Value() == 3 or SCMenu.ESpell.EOrigin:Value() == 4 then
									useE(target)
								elseif SCMenu.ESpell.EOrigin:Value() == 5 then
									CastTargetSpell(target, _E)
								end
							end
						end
					end
				end
			end
			if SCMenu.ESpell.EKey:Value() and SCMenu.ESpell.EPush:Value() then
				if SCMenu.ESpell.EUsage:Value() == 1 then
					for _,ally in pairs(GoS:GetAllyHeroes()) do
						if ValidTarget(ally, SCMenu.ESpell.ERange:Value()) then
							if SCMenu.ESpell.EOrigin:Value() == 1 then
								CastSpell(_E)
							elseif SCMenu.ESpell.EOrigin:Value() == 2 or SCMenu.ESpell.EOrigin:Value() == 3 or SCMenu.ESpell.EOrigin:Value() == 4 then
								useE(ally)
							elseif SCMenu.ESpell.EOrigin:Value() == 5 then
								CastTargetSpell(ally, _E)
							end
						end
					end
				elseif SCMenu.ESpell.EUsage:Value() == 2 then
					if ValidTarget(target, SCMenu.ESpell.ERange:Value()) then
						if SCMenu.ESpell.EAutoMode:Value() == 1 then
							useE(target)
						elseif SCMenu.ESpell.EAutoMode:Value() == 2 then
							if GotBuff(target, "veigareventhorizonstun") > 0 or GotBuff(target, "Stun") > 0 or GotBuff(target, "Taunt") > 0 or GotBuff(target, "Slow") > 0 or GotBuff(target, "Snare") > 0 or GotBuff(target, "Charm") > 0 or GotBuff(target, "Suppression") > 0 or GotBuff(target, "Flee") > 0 or GotBuff(target, "Knockup") > 0 then
								if SCMenu.ESpell.EOrigin:Value() == 1 then
									CastSpell(_E)
								elseif SCMenu.ESpell.EOrigin:Value() == 2 or SCMenu.ESpell.EOrigin:Value() == 3 or SCMenu.ESpell.EOrigin:Value() == 4 then
									useE(target)
								elseif SCMenu.ESpell.EOrigin:Value() == 5 then
									CastTargetSpell(target, _E)
								end
							end
						end
					end
				end
			end
		end
	end
end

local QNoCol = { range = SCMenu.QSpell.QRange:Value(), angle = SCMenu.QSpell.QAngle:Value(), radius = SCMenu.QSpell.QRadius:Value(), width = SCMenu.QSpell.QRadius:Value()*2, speed = SCMenu.QSpell.QSpeed:Value(), delay = SCMenu.QSpell.QDelay:Value(), type = ""..tostring(SCMenu.QSpell.QType:Value()), collision = false, source = myHero }
local QCol = { range = SCMenu.QSpell.QRange:Value(), angle = SCMenu.QSpell.QAngle:Value(), radius = SCMenu.QSpell.QRadius:Value(), width = SCMenu.QSpell.QRadius:Value()*2, speed = SCMenu.QSpell.QSpeed:Value(), delay = SCMenu.QSpell.QDelay:Value(), type = ""..tostring(SCMenu.QSpell.QType:Value()), collision = true, source = myHero, col = {"minion","champion"}}
local WNoCol = { range = SCMenu.WSpell.WRange:Value(), angle = SCMenu.WSpell.WAngle:Value(), radius = SCMenu.WSpell.WRadius:Value(), width = SCMenu.WSpell.WRadius:Value()*2, speed = SCMenu.WSpell.WSpeed:Value(), delay = SCMenu.WSpell.WDelay:Value(), type = ""..tostring(SCMenu.WSpell.WType:Value()), collision = false, source = myHero }
local WCol = { range = SCMenu.WSpell.WRange:Value(), angle = SCMenu.WSpell.WAngle:Value(), radius = SCMenu.WSpell.WRadius:Value(), width = SCMenu.WSpell.WRadius:Value()*2, speed = SCMenu.WSpell.WSpeed:Value(), delay = SCMenu.WSpell.WDelay:Value(), type = ""..tostring(SCMenu.WSpell.WType:Value()), collision = true, source = myHero, col = {"minion","champion"}}
local ENoCol = { range = SCMenu.ESpell.ERange:Value(), angle = SCMenu.ESpell.EAngle:Value(), radius = SCMenu.ESpell.ERadius:Value(), width = SCMenu.ESpell.ERadius:Value()*2, speed = SCMenu.ESpell.ESpeed:Value(), delay = SCMenu.ESpell.EDelay:Value(), type = ""..tostring(SCMenu.ESpell.EType:Value()), collision = false, source = myHero }
local ECol = { range = SCMenu.ESpell.ERange:Value(), angle = SCMenu.ESpell.EAngle:Value(), radius = SCMenu.ESpell.ERadius:Value(), width = SCMenu.ESpell.ERadius:Value()*2, speed = SCMenu.ESpell.ESpeed:Value(), delay = SCMenu.ESpell.EDelay:Value(), type = ""..tostring(SCMenu.ESpell.EType:Value()), collision = true, source = myHero, col = {"minion","champion"}}
local RNoCol = { range = SCMenu.RSpell.RRange:Value(), angle = SCMenu.RSpell.RAngle:Value(), radius = SCMenu.RSpell.RRadius:Value(), width = SCMenu.RSpell.RRadius:Value()*2, speed = SCMenu.RSpell.RSpeed:Value(), delay = SCMenu.RSpell.RDelay:Value(), type = ""..tostring(SCMenu.RSpell.RType:Value()), collision = false, source = myHero }
local RCol = { range = SCMenu.RSpell.RRange:Value(), angle = SCMenu.RSpell.RAngle:Value(), radius = SCMenu.RSpell.RRadius:Value(), width = SCMenu.RSpell.RRadius:Value()*2, speed = SCMenu.RSpell.RSpeed:Value(), delay = SCMenu.RSpell.RDelay:Value(), type = ""..tostring(SCMenu.RSpell.RType:Value()), collision = true, source = myHero, col = {"minion","champion"}}

function useQ(target)
	if SCMenu.QSpell.QUsage:Value() == 2 then
		local StartPos = Vector(myHero)-(SCMenu.QSpell.QRange:Value()-SCMenu.SS3.SS3Range:Value())*(Vector(myHero)-Vector(target)):normalized()
		if SCMenu.QSpell.QPred:Value() == 1 then
			if SCMenu.QSpell.QOrigin:Value() == 2 then
				CastSkillShot(_Q, GetOrigin(target))
			elseif SCMenu.QSpell.QOrigin:Value() == 3 then
				if GotBuff(myHero, "XerathArcanopulseChargeUp") == 0 and GotBuff(myHero, "VarusQLaunch") == 0 then
					CastSkillShot(_Q, GetMousePos())
				else
					if SCMenu.SS2.SS2Key:Value() then
						CastSkillShot2(_Q, GetOrigin(target))
					end
				end
			elseif SCMenu.QSpell.QOrigin:Value() == 4 then
				CastSkillShot3(_Q, StartPos, target)
			end
		elseif SCMenu.QSpell.QPred:Value() == 2 then
			if SCMenu.QSpell.QOrigin:Value() == 2 then
				if SCMenu.QSpell.QCol:Value() then
					local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),SCMenu.QSpell.QSpeed:Value(),SCMenu.QSpell.QDelay:Value()*1000,SCMenu.QSpell.QRange:Value(),SCMenu.QSpell.QRadius:Value()*2,true,true)
					if QPred.HitChance == 1 then
						CastSkillShot(_Q, QPred.PredPos)
					end
				else
					local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),SCMenu.QSpell.QSpeed:Value(),SCMenu.QSpell.QDelay:Value()*1000,SCMenu.QSpell.QRange:Value(),SCMenu.QSpell.QRadius:Value()*2,false,true)
					if QPred.HitChance == 1 then
						CastSkillShot(_Q, QPred.PredPos)
					end
				end
			elseif SCMenu.QSpell.QOrigin:Value() == 3 then
				if GotBuff(myHero, "XerathArcanopulseChargeUp") == 0 and GotBuff(myHero, "VarusQLaunch") == 0 then
					CastSkillShot(_Q, GetMousePos())
				else
					if SCMenu.SS2.SS2Key:Value() then
						local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),SCMenu.QSpell.QSpeed:Value(),SCMenu.QSpell.QDelay:Value()*1000,SCMenu.QSpell.QRange:Value(),SCMenu.QSpell.QRadius:Value()*2,false,false)
						if QPred.HitChance == 1 then
							CastSkillShot2(_Q, QPred.PredPos)
						end
					end
				end
			elseif SCMenu.QSpell.QOrigin:Value() == 4 then
				local QPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),SCMenu.QSpell.QSpeed:Value(),SCMenu.QSpell.QDelay:Value()*1000,SCMenu.QSpell.QRange:Value(),SCMenu.QSpell.QRadius:Value()*2,false,true)
				if QPred.HitChance == 1 then
					CastSkillShot3(_Q, StartPos, QPred.PredPos)
				end
			end
		elseif SCMenu.QSpell.QPred:Value() == 3 then
			if SCMenu.QSpell.QOrigin:Value() == 2 then
				if SCMenu.QSpell.QCol:Value() then
					local QPred = _G.gPred:GetPrediction(target,myHero,QCol,true,false)
					if QPred and QPred.HitChance >= 3 then
						CastSkillShot(_Q, QPred.CastPosition)
					end
				else
					local QPred = _G.gPred:GetPrediction(target,myHero,QNoCol,false,false)
					if QPred and QPred.HitChance >= 3 then
						CastSkillShot(_Q, QPred.CastPosition)
					end
				end
			end
		elseif SCMenu.QSpell.QPred:Value() == 4 then
			if SCMenu.QSpell.QOrigin:Value() == 2 then
				if SCMenu.QSpell.QType:Value() == 1 then
					if SCMenu.QSpell.QCol:Value() then
						local QPrediction = GetLinearAOEPrediction(target,QCol)
						if QPrediction.hitChance > 0.9 then
							CastSkillShot(_Q, QPrediction.castPos)
						end
					else
						local QPrediction = GetLinearAOEPrediction(target,QNoCol)
						if QPrediction.hitChance > 0.9 then
							CastSkillShot(_Q, QPrediction.castPos)
						end
					end
				elseif SCMenu.QSpell.QType:Value() == 2 then
					local QPrediction = GetCircularAOEPrediction(target,QNoCol)
					if QPrediction.hitChance > 0.9 then
						CastSkillShot(_Q, QPrediction.castPos)
					end
				elseif SCMenu.QSpell.QType:Value() == 3 then
					local QPrediction = GetConicAOEPrediction(target,QNoCol)
					if QPrediction.hitChance > 0.9 then
						CastSkillShot(_Q, QPrediction.castPos)
					end
				end
			elseif SCMenu.QSpell.QOrigin:Value() == 3 then
				if GotBuff(myHero, "XerathArcanopulseChargeUp") == 0 and GotBuff(myHero, "VarusQLaunch") == 0 then
					CastSkillShot(_Q, GetMousePos())
				else
					if SCMenu.SS2.SS2Key:Value() then
						local QPrediction = GetLinearAOEPrediction(target,QNoCol)
						if QPrediction.hitChance > 0.9 then
							CastSkillShot2(_Q, QPrediction.castPos)
						end
					end
				end
			elseif SCMenu.QSpell.QOrigin:Value() == 4 then
				local QPrediction = GetLinearAOEPrediction(target,QNoCol)
				if QPrediction.hitChance > 0.9 then
					CastSkillShot3(_Q, StartPos, QPrediction.castPos)
				end
			end
		end
	elseif SCMenu.QSpell.QUsage:Value() == 1 then
		if SCMenu.QSpell.QOrigin:Value() == 2 then
			CastSkillShot(_Q, GetOrigin(ally))
		end
	end
end
function useW(target)
	if SCMenu.WSpell.WUsage:Value() == 2 then
		local StartPos = Vector(myHero)-(SCMenu.WSpell.WRange:Value()-SCMenu.SS3.SS3Range:Value())*(Vector(myHero)-Vector(target)):normalized()
		if SCMenu.WSpell.WPred:Value() == 1 then
			if SCMenu.WSpell.WOrigin:Value() == 2 then
				CastSkillShot(_W, GetOrigin(target))
			elseif SCMenu.WSpell.WOrigin:Value() == 3 then
				if GotBuff(myHero, "XerathArcanopulseChargeUp") == 0 and GotBuff(myHero, "VarusQLaunch") == 0 then
					CastSkillShot(_W, GetMousePos())
				else
					if SCMenu.SS2.SS2Key:Value() then
						CastSkillShot2(_W, GetOrigin(target))
					end
				end
			elseif SCMenu.WSpell.WOrigin:Value() == 4 then
				CastSkillShot3(_W, StartPos, target)
			end
		elseif SCMenu.WSpell.WPred:Value() == 2 then
			if SCMenu.WSpell.WOrigin:Value() == 2 then
				if SCMenu.WSpell.WCol:Value() then
					local WPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),SCMenu.WSpell.WSpeed:Value(),SCMenu.WSpell.WDelay:Value()*1000,SCMenu.WSpell.WRange:Value(),SCMenu.WSpell.WRadius:Value()*2,true,true)
					if WPred.HitChance == 1 then
						CastSkillShot(_W, WPred.PredPos)
					end
				else
					local WPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),SCMenu.WSpell.WSpeed:Value(),SCMenu.WSpell.WDelay:Value()*1000,SCMenu.WSpell.WRange:Value(),SCMenu.WSpell.WRadius:Value()*2,false,true)
					if WPred.HitChance == 1 then
						CastSkillShot(_W, WPred.PredPos)
					end
				end
			elseif SCMenu.WSpell.WOrigin:Value() == 3 then
				if GotBuff(myHero, "XerathArcanopulseChargeUp") == 0 and GotBuff(myHero, "VarusQLaunch") == 0 then
					CastSkillShot(_W, GetMousePos())
				else
					if SCMenu.SS2.SS2Key:Value() then
						local WPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),SCMenu.WSpell.WSpeed:Value(),SCMenu.WSpell.WDelay:Value()*1000,SCMenu.WSpell.WRange:Value(),SCMenu.WSpell.WRadius:Value()*2,false,false)
						if WPred.HitChance == 1 then
							CastSkillShot2(_W, WPred.PredPos)
						end
					end
				end
			elseif SCMenu.WSpell.WOrigin:Value() == 4 then
				local WPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),SCMenu.WSpell.WSpeed:Value(),SCMenu.WSpell.WDelay:Value()*1000,SCMenu.WSpell.WRange:Value(),SCMenu.WSpell.WRadius:Value()*2,false,true)
				if WPred.HitChance == 1 then
					CastSkillShot3(_W, StartPos, WPred.PredPos)
				end
			end
		elseif SCMenu.WSpell.WPred:Value() == 3 then
			if SCMenu.WSpell.WOrigin:Value() == 2 then
				if SCMenu.WSpell.WCol:Value() then
					local WPred = _G.gPred:GetPrediction(target,myHero,WCol,true,false)
					if WPred and WPred.HitChance >= 3 then
						CastSkillShot(_W, WPred.CastPosition)
					end
				else
					local WPred = _G.gPred:GetPrediction(target,myHero,WNoCol,false,false)
					if WPred and WPred.HitChance >= 3 then
						CastSkillShot(_W, WPred.CastPosition)
					end
				end
			end
		elseif SCMenu.WSpell.WPred:Value() == 4 then
			if SCMenu.WSpell.WOrigin:Value() == 2 then
				if SCMenu.WSpell.WType:Value() == 1 then
					if SCMenu.WSpell.WCol:Value() then
						local WPrediction = GetLinearAOEPrediction(target,WCol)
						if WPrediction.hitChance > 0.9 then
							CastSkillShot(_W, WPrediction.castPos)
						end
					else
						local WPrediction = GetLinearAOEPrediction(target,WNoCol)
						if WPrediction.hitChance > 0.9 then
							CastSkillShot(_W, WPrediction.castPos)
						end
					end
				elseif SCMenu.WSpell.WType:Value() == 2 then
					local WPrediction = GetCircularAOEPrediction(target,WNoCol)
					if WPrediction.hitChance > 0.9 then
						CastSkillShot(_W, WPrediction.castPos)
					end
				elseif SCMenu.WSpell.WType:Value() == 3 then
					local WPrediction = GetConicAOEPrediction(target,WNoCol)
					if WPrediction.hitChance > 0.9 then
						CastSkillShot(_W, WPrediction.castPos)
					end
				end
			elseif SCMenu.WSpell.WOrigin:Value() == 3 then
				if GotBuff(myHero, "XerathArcanopulseChargeUp") == 0 and GotBuff(myHero, "VarusQLaunch") == 0 then
					CastSkillShot(_W, GetMousePos())
				else
					if SCMenu.SS2.SS2Key:Value() then
						local WPrediction = GetLinearAOEPrediction(target,WNoCol)
						if WPrediction.hitChance > 0.9 then
							CastSkillShot2(_W, WPrediction.castPos)
						end
					end
				end
			elseif SCMenu.WSpell.WOrigin:Value() == 4 then
				local WPrediction = GetLinearAOEPrediction(target,WNoCol)
				if WPrediction.hitChance > 0.9 then
					CastSkillShot3(_W, StartPos, WPrediction.castPos)
				end
			end
		end
	elseif SCMenu.WSpell.WUsage:Value() == 1 then
		if SCMenu.WSpell.WOrigin:Value() == 2 then
			CastSkillShot(_W, GetOrigin(ally))
		end
	end
end
function useE(target)
	if SCMenu.ESpell.EUsage:Value() == 2 then
		local StartPos = Vector(myHero)-(SCMenu.ESpell.ERange:Value()-SCMenu.SS3.SS3Range:Value())*(Vector(myHero)-Vector(target)):normalized()
		if SCMenu.ESpell.EPred:Value() == 1 then
			if SCMenu.ESpell.EOrigin:Value() == 2 then
				CastSkillShot(_E, GetOrigin(target))
			elseif SCMenu.ESpell.EOrigin:Value() == 3 then
				if GotBuff(myHero, "XerathArcanopulseChargeUp") == 0 and GotBuff(myHero, "VarusQLaunch") == 0 then
					CastSkillShot(_E, GetMousePos())
				else
					if SCMenu.SS2.SS2Key:Value() then
						CastSkillShot2(_E, GetOrigin(target))
					end
				end
			elseif SCMenu.ESpell.EOrigin:Value() == 4 then
				CastSkillShot3(_E, StartPos, target)
			end
		elseif SCMenu.ESpell.EPred:Value() == 2 then
			if SCMenu.ESpell.EOrigin:Value() == 2 then
				if SCMenu.ESpell.ECol:Value() then
					local EPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),SCMenu.ESpell.ESpeed:Value(),SCMenu.ESpell.EDelay:Value()*1000,SCMenu.ESpell.ERange:Value(),SCMenu.ESpell.ERadius:Value()*2,true,true)
					if EPred.HitChance == 1 then
						CastSkillShot(_E, EPred.PredPos)
					end
				else
					local EPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),SCMenu.ESpell.ESpeed:Value(),SCMenu.ESpell.EDelay:Value()*1000,SCMenu.ESpell.ERange:Value(),SCMenu.ESpell.ERadius:Value()*2,false,true)
					if EPred.HitChance == 1 then
						CastSkillShot(_E, EPred.PredPos)
					end
				end
			elseif SCMenu.ESpell.EOrigin:Value() == 3 then
				if GotBuff(myHero, "XerathArcanopulseChargeUp") == 0 and GotBuff(myHero, "VarusQLaunch") == 0 then
					CastSkillShot(_E, GetMousePos())
				else
					if SCMenu.SS2.SS2Key:Value() then
						local EPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),SCMenu.ESpell.ESpeed:Value(),SCMenu.ESpell.EDelay:Value()*1000,SCMenu.ESpell.ERange:Value(),SCMenu.ESpell.ERadius:Value()*2,false,false)
						if EPred.HitChance == 1 then
							CastSkillShot2(_E, EPred.PredPos)
						end
					end
				end
			elseif SCMenu.ESpell.EOrigin:Value() == 4 then
				local EPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),SCMenu.ESpell.ESpeed:Value(),SCMenu.ESpell.EDelay:Value()*1000,SCMenu.ESpell.ERange:Value(),SCMenu.ESpell.ERadius:Value()*2,false,true)
				if EPred.HitChance == 1 then
					CastSkillShot3(_E, StartPos, EPred.PredPos)
				end
			end
		elseif SCMenu.ESpell.EPred:Value() == 3 then
			if SCMenu.ESpell.EOrigin:Value() == 2 then
				if SCMenu.ESpell.ECol:Value() then
					local EPred = _G.gPred:GetPrediction(target,myHero,ECol,true,false)
					if EPred and EPred.HitChance >= 3 then
						CastSkillShot(_E, EPred.CastPosition)
					end
				else
					local EPred = _G.gPred:GetPrediction(target,myHero,ENoCol,false,false)
					if EPred and EPred.HitChance >= 3 then
						CastSkillShot(_E, EPred.CastPosition)
					end
				end
			end
		elseif SCMenu.ESpell.EPred:Value() == 4 then
			if SCMenu.ESpell.EOrigin:Value() == 2 then
				if SCMenu.ESpell.EType:Value() == 1 then
					if SCMenu.ESpell.ECol:Value() then
						local EPrediction = GetLinearAOEPrediction(target,ECol)
						if EPrediction.hitChance > 0.9 then
							CastSkillShot(_E, EPrediction.castPos)
						end
					else
						local EPrediction = GetLinearAOEPrediction(target,ENoCol)
						if EPrediction.hitChance > 0.9 then
							CastSkillShot(_E, EPrediction.castPos)
						end
					end
				elseif SCMenu.ESpell.EType:Value() == 2 then
					local EPrediction = GetCircularAOEPrediction(target,ENoCol)
					if EPrediction.hitChance > 0.9 then
						CastSkillShot(_E, EPrediction.castPos)
					end
				elseif SCMenu.ESpell.EType:Value() == 3 then
					local EPrediction = GetConicAOEPrediction(target,ENoCol)
					if EPrediction.hitChance > 0.9 then
						CastSkillShot(_E, EPrediction.castPos)
					end
				end
			elseif SCMenu.ESpell.EOrigin:Value() == 3 then
				if GotBuff(myHero, "XerathArcanopulseChargeUp") == 0 and GotBuff(myHero, "VarusQLaunch") == 0 then
					CastSkillShot(_E, GetMousePos())
				else
					if SCMenu.SS2.SS2Key:Value() then
						local EPrediction = GetLinearAOEPrediction(target,ENoCol)
						if EPrediction.hitChance > 0.9 then
							CastSkillShot2(_E, EPrediction.castPos)
						end
					end
				end
			elseif SCMenu.ESpell.EOrigin:Value() == 4 then
				local EPrediction = GetLinearAOEPrediction(target,ENoCol)
				if EPrediction.hitChance > 0.9 then
					CastSkillShot3(_E, StartPos, EPrediction.castPos)
				end
			end
		end
	elseif SCMenu.ESpell.EUsage:Value() == 1 then
		if SCMenu.ESpell.EOrigin:Value() == 2 then
			CastSkillShot(_E, GetOrigin(ally))
		end
	end
end
function useR(target)
	if SCMenu.RSpell.RUsage:Value() == 2 then
		local StartPos = Vector(myHero)-(SCMenu.RSpell.RRange:Value()-SCMenu.SS3.SS3Range:Value())*(Vector(myHero)-Vector(target)):normalized()
		if SCMenu.RSpell.RPred:Value() == 1 then
			if SCMenu.RSpell.ROrigin:Value() == 2 then
				CastSkillShot(_R, GetOrigin(target))
			elseif SCMenu.RSpell.ROrigin:Value() == 3 then
				if GotBuff(myHero, "XerathArcanopulseChargeUp") == 0 and GotBuff(myHero, "VarusQLaunch") == 0 then
					CastSkillShot(_R, GetMousePos())
				else
					if SCMenu.SS2.SS2Key:Value() then
						CastSkillShot2(_R, GetOrigin(target))
					end
				end
			elseif SCMenu.RSpell.ROrigin:Value() == 4 then
				CastSkillShot3(_R, StartPos, target)
			end
		elseif SCMenu.RSpell.RPred:Value() == 2 then
			if SCMenu.RSpell.ROrigin:Value() == 2 then
				if SCMenu.RSpell.RCol:Value() then
					local RPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),SCMenu.RSpell.RSpeed:Value(),SCMenu.RSpell.RDelay:Value()*1000,SCMenu.RSpell.RRange:Value(),SCMenu.RSpell.RRadius:Value()*2,true,true)
					if RPred.HitChance == 1 then
						CastSkillShot(_R, RPred.PredPos)
					end
				else
					local RPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),SCMenu.RSpell.RSpeed:Value(),SCMenu.RSpell.RDelay:Value()*1000,SCMenu.RSpell.RRange:Value(),SCMenu.RSpell.RRadius:Value()*2,false,true)
					if RPred.HitChance == 1 then
						CastSkillShot(_R, RPred.PredPos)
					end
				end
			elseif SCMenu.RSpell.ROrigin:Value() == 3 then
				if GotBuff(myHero, "XerathArcanopulseChargeUp") == 0 and GotBuff(myHero, "VarusQLaunch") == 0 then
					CastSkillShot(_R, GetMousePos())
				else
					if SCMenu.SS2.SS2Key:Value() then
						local RPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),SCMenu.RSpell.RSpeed:Value(),SCMenu.RSpell.RDelay:Value()*1000,SCMenu.RSpell.RRange:Value(),SCMenu.RSpell.RRadius:Value()*2,false,false)
						if RPred.HitChance == 1 then
							CastSkillShot2(_R, RPred.PredPos)
						end
					end
				end
			elseif SCMenu.RSpell.ROrigin:Value() == 4 then
				local RPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),SCMenu.RSpell.RSpeed:Value(),SCMenu.RSpell.RDelay:Value()*1000,SCMenu.RSpell.RRange:Value(),SCMenu.RSpell.RRadius:Value()*2,false,true)
				if RPred.HitChance == 1 then
					CastSkillShot3(_R, StartPos, RPred.PredPos)
				end
			end
		elseif SCMenu.RSpell.RPred:Value() == 3 then
			if SCMenu.RSpell.ROrigin:Value() == 2 then
				if SCMenu.RSpell.RCol:Value() then
					local RPred = _G.gPred:GetPrediction(target,myHero,RCol,true,false)
					if RPred and RPred.HitChance >= 3 then
						CastSkillShot(_R, RPred.CastPosition)
					end
				else
					local RPred = _G.gPred:GetPrediction(target,myHero,RNoCol,false,false)
					if RPred and RPred.HitChance >= 3 then
						CastSkillShot(_R, RPred.CastPosition)
					end
				end
			end
		elseif SCMenu.RSpell.RPred:Value() == 4 then
			if SCMenu.RSpell.ROrigin:Value() == 2 then
				if SCMenu.RSpell.RType:Value() == 1 then
					if SCMenu.RSpell.RCol:Value() then
						local RPrediction = GetLinearAOEPrediction(target,RCol)
						if RPrediction.hitChance > 0.9 then
							CastSkillShot(_R, RPrediction.castPos)
						end
					else
						local RPrediction = GetLinearAOEPrediction(target,RNoCol)
						if RPrediction.hitChance > 0.9 then
							CastSkillShot(_R, RPrediction.castPos)
						end
					end
				elseif SCMenu.RSpell.RType:Value() == 2 then
					local RPrediction = GetCircularAOEPrediction(target,RNoCol)
					if RPrediction.hitChance > 0.9 then
						CastSkillShot(_R, RPrediction.castPos)
					end
				elseif SCMenu.RSpell.RType:Value() == 3 then
					local RPrediction = GetConicAOEPrediction(target,RNoCol)
					if RPrediction.hitChance > 0.9 then
						CastSkillShot(_R, RPrediction.castPos)
					end
				end
			elseif SCMenu.RSpell.ROrigin:Value() == 3 then
				if GotBuff(myHero, "XerathArcanopulseChargeUp") == 0 and GotBuff(myHero, "VarusQLaunch") == 0 then
					CastSkillShot(_R, GetMousePos())
				else
					if SCMenu.SS2.SS2Key:Value() then
						local RPrediction = GetLinearAOEPrediction(target,RNoCol)
						if RPrediction.hitChance > 0.9 then
							CastSkillShot2(_R, RPrediction.castPos)
						end
					end
				end
			elseif SCMenu.RSpell.ROrigin:Value() == 4 then
				local RPrediction = GetLinearAOEPrediction(target,RNoCol)
				if RPrediction.hitChance > 0.9 then
					CastSkillShot3(_R, StartPos, RPrediction.castPos)
				end
			end
		end
	elseif SCMenu.RSpell.RUsage:Value() == 1 then
		if SCMenu.RSpell.ROrigin:Value() == 2 then
			CastSkillShot(_R, GetOrigin(ally))
		end
	end
end