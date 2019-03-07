--[[
	   ___                _            ___             ___     __  _         
	  / _ \_______ __ _  (_)_ ____ _  / _ \_______ ___/ (_)___/ /_(_)__  ___ 
	 / ___/ __/ -_)  ' \/ / // /  ' \/ ___/ __/ -_) _  / / __/ __/ / _ \/ _ \
	/_/  /_/  \__/_/_/_/_/\_,_/_/_/_/_/  /_/  \__/\_,_/_/\__/\__/_/\___/_//_/

	-> Generic prediction callbacks

	* GetFastPrediction(source, unit, speed, delay)
	> return: PredPos, TimeToHit
	* GetPrediction(source, unit, speed, range, delay, radius, angle, collision)
	* GetDashPrediction(source, unit, speed, range, delay, radius, collision)
	* GetImmobilePrediction(source, unit, speed, range, delay, radius, collision)
	* GetStandardPrediction(source, unit, speed, range, delay, radius, angle, collision)
	> return: CastPos, PredPos, HitChance, TimeToHit

	-> AOE prediction callbacks

	* GetLinearAOEPrediction(source, unit, speed, range, delay, radius, angle, collision)
	* GetCircularAOEPrediction(source, unit, speed, range, delay, radius, angle, collision)
	* GetConicAOEPrediction(source, unit, speed, range, delay, radius, angle, collision)
	> return: CastPos, HitChance

	-> Hitchances

	-1             Minion or hero collision
	0              Unit is out of range
	0.1 - 0.24     Low accuracy
	0.25 - 0.49    Medium accuracy
	0.50 - 0.74    High accuracy
	0.75 - 0.99    Very high accuracy
	1              Unit is immobile or dashing

--]]

local a = Game.Latency
local b = Game.Timer
local c = Game.HeroCount
local d = Game.Hero
local e = Game.MinionCount
local f = Game.Minion
local g = math.abs
local h = math.atan
local i = math.atan2
local j = math.acos
local k = math.ceil
local l = math.cos
local m = math.deg
local n = math.floor
local o = math.huge
local p = math.max
local q = math.min
local r = math.pi
local q = math.min
local s = math.sin
local t = math.sqrt
local u = table.insert
local v = table.remove
local w = "https://raw.githubusercontent.com/Ark223/GoS-Scripts/master/PremiumPrediction.version"
local x = "https://raw.githubusercontent.com/Ark223/GoS-Scripts/master/PremiumPrediction.lua"
local y = "1.14"

function DownloadFile(z, A)
	DownloadFileAsync(z, A, function() end)
	while not FileExist(A) do end
end

function ReadFile(A)
	local B = io.open(A, "r")
	local C = B:read()
	B:close()
	return C
end

function AutoUpdate()
	DownloadFile(w, COMMON_PATH .. "PremiumPrediction.version", function() end)
	if tonumber(ReadFile(COMMON_PATH .. "PremiumPrediction.version")) > tonumber(y) then
		print("PremiumPrediction: Downloading update...")
		DownloadFile(x, COMMON_PATH .. "PremiumPrediction.lua", function() end)
		print("PremiumPrediction: Successfully updated. 2xF6!")
	end
end

function OnLoad()
	require("MapPositionGOS")
	PremiumPrediction()
	AutoUpdate()
end

class("PremiumPrediction")

local D = {}
function PremiumPrediction:__init()
end

--[[
	╔═╗┌─┐┌─┐┌┬┐┌─┐┌┬┐┬─┐┬ ┬
	║ ╦├┤ │ ││││├┤  │ ├┬┘└┬┘
	╚═╝└─┘└─┘┴ ┴└─┘ ┴ ┴└─ ┴ 
--]]

function PremiumPrediction:CalculateInterceptionTime(E, F, G, H)
	local I = G.x * G.x + G.z * G.z - H * H
	local J = 2 * (G.x * (F.x - E.x) + G.z * (F.z - E.z))
	local K = F.x * F.x + F.z * F.z + E.x * E.x + E.z * E.z - 2 * E.x * F.x - 2 * E.z * F.z
	local L = J * J - 4 * I * K
	local M = (-J + t(L)) / (2 * I)
	local N = (-J - t(L)) / (2 * I)
	return M, N
end

function PremiumPrediction:GenerateCastPos(E, O, P, Q, R, S)
	local T = (i(Q.z - P.z, Q.x - P.x) - i(E.z - O.z, E.x - O.x)) % (2 * r)
	local U = 1 - g(T % r - r / 2) / (r / 2)
	local V = T < r and h(S / 2 / R) or -h(S / 2 / R)
	local W, X = O.x - E.x, O.z - E.z
	return Vector(l(V) * W - s(V) * X + E.x, O.y, s(V) * W + l(V) * X + E.z)
end

function PremiumPrediction:GetDistanceSqr(Y, Z)
	local Z = Z or myHero.pos
	local W = Y.x - Z.x
	local X = (Y.z or Y.y) - (Z.z or Z.y)
	return W * W + X * X
end

function PremiumPrediction:GetDistance(Y, Z)
	return t(self:GetDistanceSqr(Y, Z))
end

function PremiumPrediction:IsInRange(Y, Z, _)
	local a0 = Y.x - Z.x
	local a1 = Y.z - Z.z
	return a0 * a0 + a1 * a1 <= _ * _
end

function PremiumPrediction:IsZero(a2)
	return a2.x == 0 and a2.y == 0 and a2.z == 0
end

function PremiumPrediction:MinionCollision(a3, a4, H, _, a5, S)
	for a6 = 1, e() do
		local a7 = f(a6)
		if a7 and a7.isEnemy then
			local a8, R = self:GetFastPrediction(a3, a7, H, a5)
			if self:GetDistanceSqr(myHero.pos, a8) <= (_ + S) * (_ + S) then
				local a9, aa, ab = self:VectorPointProjectionOnLineSegment(a3, a4, a8)
				if ab and self:GetDistanceSqr(a9, a8) <= (S + a7.boundingRadius + 15) ^ 2 or self:GetDistance(a3, a8) < a7.boundingRadius or self:GetDistance(a4, a8) < a7.boundingRadius then
					return true
				end
			end
		end
	end
	return false
end

function PremiumPrediction:VectorPointProjectionOnLineSegment(ac, ad, ae)
	local af, ag, ah, ai, aj, ak = ad.z or ae.x, ae.z or ae.y, ac.x, ac.z or ac.y, ad.x, ad.y
	local al = ((af - ah) * (aj - ah) + (ag - ai) * (ak - ai)) / ((aj - ah) ^ 2 + (ak - ai) ^ 2)
	local aa = {
		x = ah + al * (aj - ah),
		y = ai + al * (ak - ai)
	}
	local am = al < 0 and 0 or al > 1 and 1 or al
	local ab = am == al
	local a9 = ab and aa or {
		x = ah + am * (aj - ah),
		y = ai + am * (ak - ai)
	}
	return a9, aa, ab
end

--[[
	┬ ┬┌┐┌┬┌┬┐┌─┐
	│ │││││ │ └─┐
	└─┘┘└┘┴ ┴ └─┘
--]]

function PremiumPrediction:GetAllyMinions(_)
	local an = {}
	for a6 = 1, e() do
		local a7 = f(a6)
		if a7 and a7.team == myHero.team and self:ValidTarget(a7, _) then
			u(an, a7)
		end
	end
	return an
end

function PremiumPrediction:GetEnemyHeroes()
	local ao = {}
	for a6 = 1, c() do
		local ap = d(a6)
		if ap.isEnemy then
			u(ao, ap)
		end
	end
	return ao
end

function PremiumPrediction:IsAttacking(F)
	if F.activeSpell then
		return b() < F.activeSpell.startTime + F.activeSpell.windup, F.activeSpell.startTime + F.activeSpell.windup - b()
	end
end

function PremiumPrediction:IsDashing(F)
	return F.pathing.isDashing
end

function PremiumPrediction:IsImmobile(F)
	for a6 = 0, F.buffCount do
		local aq = F:GetBuff(a6)
		if aq and (aq.type == 5 or aq.type == 11 or aq.type == 18 or aq.type == 22 or aq.type == 24 or aq.type == 28 or aq.type == 29) and 0 < aq.duration then
			return b() < aq.expireTime, aq.expireTime - b()
		end
	end
	return false
end

function PremiumPrediction:IsMoving(F)
	return F.pathing.hasMovePath
end

function PremiumPrediction:IsSlowed(F)
	for a6 = 0, F.buffCount do
		local aq = F:GetBuff(a6)
		if aq and aq.type == 10 and 0 < aq.duration then
			return b() < aq.expireTime
		end
	end
	return false
end

function PremiumPrediction:ValidTarget(ar, _)
	if not _ or not _ then
		_ = o
	end
	return ar ~= nil and ar.valid and ar.visible and not ar.dead and _ >= ar.distance
end

--[[
	┌─┐┌─┐┬  ┬  ┌┐ ┌─┐┌─┐┬┌─┌─┐
	│  ├─┤│  │  ├┴┐├─┤│  ├┴┐└─┐
	└─┘┴ ┴┴─┘┴─┘└─┘┴ ┴└─┘┴ ┴└─┘
--]]

function PremiumPrediction:GetPrediction(E, F, H, _, a5, S, as, at)
	local au = Vector(F.pos)
	if au then
		local H = H or o
		local _ = _ or 12500
		local av = F.networkID
		if self:IsMoving(F) then
			if self:IsDashing(F) then
				local aw, ax, ay, R = self:GetDashPrediction(E, F, H, _, a5, S, at)
				return aw, ax, ay, R
			else
				local aw, ax, ay, R = self:GetStandardPrediction(E, F, H, _, a5, S, as, at)
				return aw, ax, ay, R
			end
		else
			local aw, ax, ay, R = self:GetImmobilePrediction(E, F, H, _, a5, S, at)
			return aw, ax, ay, R
		end
	end
end

function PremiumPrediction:GetFastPrediction(E, F, H, a5)
	local az = Vector(E)
	local E = self:IsZero(az) and Vector(E.pos) or az
	local au = F.pos
	local ax = self:IsMoving(F) and F:GetPrediction(H, a5) or au
	local R = H ~= o and self:GetDistance(E, ax) / H + a5 or a5
	return ax, R
end

function PremiumPrediction:GetDashPrediction(E, F, H, _, a5, S, at)
	if self:IsDashing(F) then
		local az = Vector(E)
		local E = self:IsZero(az) and Vector(E.pos) or az
		local au = Vector(F.pos)
		local a5 = a5 + a() / 1000
		local aA = F.pathing.dashSpeed
		local aw, ax = au, au
		local ay = 1
		local a3, a4 = Vector(F.pathing.startPos), Vector(F.pathing.endPos)
		local aB, aC, aD = a4.x - a3.x, a4.y - a3.y, a4.z - a3.z
		local aE = t(aB * aB + aD * aD)
		local aF = Vector(aB / aE * aA, aC / aE, aD / aE * aA)
		local M, N = self:CalculateInterceptionTime(E, a3, aF, H)
		local R = a5 + p(M, N)
		local aG = a5 + self:GetDistance(au, a4) / H
		if R <= aG then
			aw = a3:Extended(a4, aA * R)
		else
			aw = a4
		end
		ax = aw
		if at and self:MinionCollision(E, aw, H, _, a5, S) or MapPosition:inWall(aw) then
			ay = -1
		elseif self:GetDistanceSqr(aw, E) > _ * _ then
			ay = 0
		end
		return aw, ax, ay, R
	end
end

function PremiumPrediction:GetImmobilePrediction(E, F, H, _, a5, S, at, aA)
	local az = Vector(E)
	local E = self:IsZero(az) and Vector(E.pos) or az
	local au = Vector(F.pos)
	local aA = F.ms
	local aw, ax = au, au
	local ay = 0
	local R = self:GetDistance(E, aw) / H + a5 + a() / 1000
	local aH, aI = self:IsAttacking(F)
	local aJ, aK = self:IsImmobile(F)
	if aH then
		ay = q(1, S * 2 / aA / (R - aI))
	elseif aJ then
		if R < aK then
			ay = 1
		else
			ay = q(1, S * 2 / aA / (R - aK))
		end
	else
		ay = q(1, S * 2 / aA / R)
	end
	if not F.visible then
		ay = ay / 2
	end
	if at and self:MinionCollision(E, aw, H, _, a5, S) or MapPosition:inWall(aw) then
		ay = -1
	elseif self:GetDistanceSqr(aw, E) > _ * _ then
		ay = 0
	end
	return aw, ax, ay, R
end

function PremiumPrediction:GetStandardPrediction(E, F, H, _, a5, S, as, at, aA)
	local az = Vector(E)
	local E = self:IsZero(az) and Vector(E.pos) or az
	local au = F.pos
	local a5 = a5 + a() / 1000
	local aA = F.ms
	local ax, aw = au, au
	local ay, R = 0, a5
	local av = F.networkID
	if self:IsMoving(F) then
		local a3, a4 = au, Vector(F.pathing.endPos)
		local aB, aC, aD = a4.x - a3.x, a4.y - a3.y, a4.z - a3.z
		local aE = t(aB * aB + aD * aD)
		local aF = Vector(aB / aE * aA, aC / aE * aA, aD / aE * aA)
		if H ~= o then
			local M, N = self:CalculateInterceptionTime(E, a3, aF, H)
			R = a5 + p(M, N)
		end
		local aL = q(R * aA, aE)
		if as and as > 0 then
			S = t(2 * aL * aL - 2 * aL * aL * l(as))
		end
		ax = Vector(a3.x + aL * aF.x / aA, a3.y + aL * aF.y / aA, a3.z + aL * aF.z / aA)
		aw = self:GenerateCastPos(E, ax, a3, a4, H * R, S)
		local aM, aN, aO = au, 0, 0
		for a6 = F.pathing.pathIndex, F.pathing.pathCount do
			local aP, aQ = F:GetPath(a6)
			if aP then
				local aR = t((aM.x - aP.x) ^ 2 + (aM.z - aP.z) ^ 2)
				if aO < a5 + aO + aR / aA then
					if a6 == F.pathing.pathIndex and a5 < aR / aA then
						aM = aM + (aP - aM) / aR * aA * (aO + a5)
						aR = t((aM.x - aP.x) ^ 2 + (aM.z - aP.z) ^ 2)
					end
					do
						local G = (aP - aM) / aR
						local M, N = self:CalculateInterceptionTime(E, aM, G, H)
						aQ = aN + aR / aA
						if not N or not (aN < N) or not (N < aQ - aN) or not N then
							N = nil
						end
						M = M and aN < M and M < aQ - aN and M or nil
						local aS = M and N and q(M, N) or M or N
						if aS then
							R = H ~= o and a5 + aS or a5
							ax = aM + G * aA * aS
							aw = self:GenerateCastPos(E, ax, aM, aP, H * R, S)
							break
						end
					end
					aO = p(0, aO - aR / aA)
				end
			end
			aM = aP
			aN = aQ
		end
		ay = q(1, S * 2 / aA / R)
		if self:IsSlowed(F) then
			ay = q(1, ay * 1.25)
		end
		if not F.visible then
			ay = ay / 2
		end
		if at and self:MinionCollision(E, aw, H, _, a5, S) or MapPosition:inWall(aw) then
			ay = -1
		elseif self:GetDistanceSqr(aw, E) > _ * _ or aw == au then
			ay = 0
		end
		return aw, ax, ay, R
	end
end

function PremiumPrediction:GetLinearAOEPrediction(E, F, H, _, a5, S, as, at)
	local aw, ax, ay, R = self:GetPrediction(E, F, H, _, a5, S, as, at)
	local E = Vector(E.pos)
	local aT = 2 * S * 2 * S
	local aU = aw
	local aV, aW = aw.x, aw.z
	do
		local aB, aD = aV - E.x, aW - E.z
		local aE = t(aB * aD + aD * aD)
		aV = aV + aB / aE * _
		aW = aW + aD / aE * _
	end
	for a6, aX in pairs(self:GetEnemyHeroes()) do
		if self:ValidTarget(aX) and aX ~= F then
			local aY, aZ, a_ = self:GetPrediction(E, aX, H, _, a5, S, as, at)
			local K = (aY.x - E.x) * (aV - E.x) + (aY.z - E.z) * (aW - E.z)
			if _ > self:GetDistance(aY, E) then
				local aS = K / (_ * _)
				if aS > 0 and aS < 1 then
					local b0 = Vector(E.x + aS * (aV - E.x), 0, E.z + aS * (aW - E.z))
					local b1 = (aY.x - b0.x) * (aY.x - b0.x) + (aY.z - b0.z) * (aY.z - b0.z)
					if aT > b1 then
						aU = Vector(0.5 * (aU.x + aY.x), aU.y, 0.5 * (aU.z + aY.z))
						aT = aT - 0.5 * b1
					end
				end
			end
		end
	end
	aw = aU
	return aw, ay
end

function PremiumPrediction:GetCircularAOEPrediction(E, F, H, _, a5, S, as, at)
	local aw, ax, ay, R = self:GetPrediction(E, F, H, _, a5, S, as, at)
	local E = Vector(E.pos)
	local aT = 2 * S * 2 * S
	local aU = aw
	local aV, aW = aw.x, aw.z
	for a6, aX in pairs(self:GetEnemyHeroes()) do
		if self:ValidTarget(aX) and aX ~= F then
			local aY, aZ, a_ = self:GetPrediction(E, aX, H, _, a5, S, as, at)
			local b2 = (aY.x - aV) * (aY.x - aV) + (aY.z - aW) * (aY.z - aW)
			if aT > b2 then
				aU = Vector(0.5 * (aU.x + aY.x), aU.y, 0.5 * (aU.z + aY.z))
				aT = aT - 0.5 * b2
			end
		end
	end
	aw = aU
	return aw, ay
end

function PremiumPrediction:GetConicAOEPrediction(E, F, H, _, a5, S, as, at)
	if as and as > 0 then
		local aw, ax, ay, R = self:GetPrediction(E, F, H, _, a5, S, as, at)
		local E = Vector(E.pos)
		local aT = 2 * as
		local aU = aw
		local aV, aW = aw.x, aw.z
		local aB, aD = aV - E.x, aW - E.z
		do
			local aE = t(aB * aD + aD * aD)
			aV = aV + aB / aE * _
			aW = aW + aD / aE * _
		end
		for a6, aX in pairs(self:GetEnemyHeroes()) do
			if self:ValidTarget(aX) and aX ~= F then
				local aY, aZ, a_ = self:GetPrediction(E, aX, H, _, a5, S, as, at)
				local b3 = self:GetDistance(aY, E)
				if _ > b3 then
					local b4 = self:GetDistance(aU, E)
					local b5 = (aU.x - E.x) * (aY.x - E.x) + (aU.z - E.z) * (aY.z - E.z)
					local b6 = m(j(b5 / (b3 * b4)))
					if aT > b6 then
						aU = Vector(0.5 * (aU.x + aY.x), aU.y, 0.5 * (aU.z + aY.z))
						aT = b6
					end
				end
			end
		end
		aw = aU
		return aw, ay
	end
end

function PremiumPrediction:GetHealthPrediction(a7, b7, R)
	local b8 = a7.health
	for a6 = 1, #b7 do
		local b9 = b7[a6]
		if b9.attackData.target == a7.handle then
			local ba = b9.totalDamage * (1 + b9.bonusDamagePercent) - a7.flatDamageReduction
			local bb = 0
			if b9.attackData.projectileSpeed and 0 < b9.attackData.projectileSpeed then
				bb = self:GetDistance(b9.pos, a7.pos) / b9.attackData.projectileSpeed
			end
			local bc = b9.attackData.endTime - b9.attackData.animationTime + bb + b9.attackData.windUpTime
			if bc <= b() then
				bc = bc + b9.attackData.animationTime + bb
			end
			while R > bc - b() do
				b8 = b8 - ba
				bc = bc + b9.attackData.animationTime + bb
			end
		end
	end
	return b8
end
