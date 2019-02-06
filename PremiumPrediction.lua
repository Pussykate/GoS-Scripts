--[[
	   ___                _            ___             ___     __  _         
	  / _ \_______ __ _  (_)_ ____ _  / _ \_______ ___/ (_)___/ /_(_)__  ___ 
	 / ___/ __/ -_)  ' \/ / // /  ' \/ ___/ __/ -_) _  / / __/ __/ / _ \/ _ \
	/_/  /_/  \__/_/_/_/_/\_,_/_/_/_/_/  /_/  \__/\_,_/_/\__/\__/_/\___/_//_/

	>> Generic prediction callbacks

	* GetPrediction(source, unit, speed, range, delay, radius, angle, collision)
	* GetDashPrediction(source, unit, speed, range, delay, radius, collision)
	* GetImmobilePrediction(source, unit, speed, range, delay, radius, collision)
	* GetStandardPrediction(source, unit, speed, range, delay, radius, angle, collision)
	> return: CastPos, PredPos, HitChance, TimeToHit

	>> AOE prediction callbacks

	* GetLinearAOEPrediction(source, unit, speed, range, delay, radius, angle, collision)
	* GetCircularAOEPrediction(source, unit, speed, range, delay, radius, angle, collision)
	* GetConicAOEPrediction(source, unit, speed, range, delay, radius, angle, collision)
	> return: CastPos, HitChance

	>> Hitchances

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
local y = "1.11"

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
			local a8, a9, aa = self:VectorPointProjectionOnLineSegment(a3, a4, a7.pos)
			if aa and self:GetDistanceSqr(a8, a7.pos) <= (S + a7.boundingRadius * 2 + 10) ^ 2 and self:GetHealthPrediction(a7, self:GetAllyMinions(_), a5 + self:GetDistance(a3, a7.pos) / H) > 0 then
				return true
			end
		end
	end
	return false
end

function PremiumPrediction:VectorPointProjectionOnLineSegment(ab, ac, ad)
	local ae, af, ag, ah, ai, aj = ac.z or ad.x, ad.z or ad.y, ab.x, ab.z or ab.y, ac.x, ac.y
	local ak = ((ae - ag) * (ai - ag) + (af - ah) * (aj - ah)) / ((ai - ag) ^ 2 + (aj - ah) ^ 2)
	local a9 = {
		x = ag + ak * (ai - ag),
		y = ah + ak * (aj - ah)
	}
	local al = ak < 0 and 0 or ak > 1 and 1 or ak
	local aa = al == ak
	local a8 = aa and a9 or {
		x = ag + al * (ai - ag),
		y = ah + al * (aj - ah)
	}
	return a8, a9, aa
end

--[[
	┬ ┬┌┐┌┬┌┬┐┌─┐
	│ │││││ │ └─┐
	└─┘┘└┘┴ ┴ └─┘
--]]

function PremiumPrediction:GetAllyMinions(_)
	local am = {}
	for a6 = 1, e() do
		local a7 = f(a6)
		if a7 and a7.team == myHero.team and self:ValidTarget(a7, _) then
			u(am, a7)
		end
	end
	return am
end

function PremiumPrediction:GetEnemyHeroes()
	local an = {}
	for a6 = 1, c() do
		local ao = d(a6)
		if ao.isEnemy then
			u(an, Hero)
		end
	end
	return an
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
		local ap = F:GetBuff(a6)
		if ap and (ap.type == 5 or ap.type == 11 or ap.type == 18 or ap.type == 22 or ap.type == 24 or ap.type == 28 or ap.type == 29) and 0 < ap.duration then
			return b() < ap.expireTime, ap.expireTime - b()
		end
	end
	return false
end

function PremiumPrediction:IsMoving(F)
	return F.pathing.hasMovePath
end

function PremiumPrediction:IsSlowed(F)
	for a6 = 0, F.buffCount do
		local ap = F:GetBuff(a6)
		if ap and ap.type == 10 and 0 < ap.duration then
			return b() < ap.expireTime
		end
	end
	return false
end

function PremiumPrediction:ValidTarget(aq, _)
	if not _ or not _ then
		_ = o
	end
	return aq ~= nil and aq.valid and aq.visible and not aq.dead and _ >= aq.distance
end

--[[
	┌─┐┌─┐┬  ┬  ┌┐ ┌─┐┌─┐┬┌─┌─┐
	│  ├─┤│  │  ├┴┐├─┤│  ├┴┐└─┐
	└─┘┴ ┴┴─┘┴─┘└─┘┴ ┴└─┘┴ ┴└─┘
--]]

function PremiumPrediction:GetPrediction(E, F, H, _, a5, S, ar, as)
	local at = Vector(F.pos)
	if at then
		local H = H or o
		local _ = _ or 12500
		local au = F.networkID
		if self:IsMoving(F) then
			if self:IsDashing(F) then
				local av, aw, ax, R = self:GetDashPrediction(E, F, H, _, a5, S, as)
				return av, aw, ax, R
			else
				local av, aw, ax, R = self:GetStandardPrediction(E, F, H, _, a5, S, ar, as)
				return av, aw, ax, R
			end
		else
			local av, aw, ax, R = self:GetImmobilePrediction(E, F, H, _, a5, S, as)
			return av, aw, ax, R
		end
	end
end

function PremiumPrediction:GetDashPrediction(E, F, H, _, a5, S, as)
	if self:IsDashing(F) then
		local ay = Vector(E)
		local E = self:IsZero(ay) and Vector(E.pos) or ay
		local at = Vector(F.pos)
		local a5 = a5 + a() / 1000
		local az = F.pathing.dashSpeed
		local av, aw = at, at
		local ax = 1
		local a3, a4 = Vector(F.pathing.startPos), Vector(F.pathing.endPos)
		local aA, aB, aC = a4.x - a3.x, a4.y - a3.y, a4.z - a3.z
		local aD = t(aA * aA + aC * aC)
		local aE = Vector(aA / aD * az, aB / aD, aC / aD * az)
		local M, N = self:CalculateInterceptionTime(E, a3, aE, H)
		local R = a5 + p(M, N)
		local aF = a5 + self:GetDistance(at, a4) / H
		if R <= aF then
			av = a3:Extended(a4, az * R)
		else
			av = a4
		end
		aw = av
		if as and self:MinionCollision(E, av, H, _, a5, S) or MapPosition:inWall(av) then
			ax = -1
		elseif self:GetDistanceSqr(av, E) > _ * _ then
			ax = 0
		end
		return av, aw, ax, R
	end
end

function PremiumPrediction:GetImmobilePrediction(E, F, H, _, a5, S, as, az)
	local ay = Vector(E)
	local E = self:IsZero(ay) and Vector(E.pos) or ay
	local at = Vector(F.pos)
	local az = F.ms
	local av, aw = at, at
	local ax = 0
	local R = self:GetDistance(E, av) / H + a5 + a() / 1000
	local aG, aH = self:IsAttacking(F)
	local aI, aJ = self:IsImmobile(F)
	if aG then
		ax = q(1, S * 2 / az / (R - aH))
	elseif aI then
		if R < aJ then
			ax = 1
		else
			ax = q(1, S * 2 / az / (R - aJ))
		end
	else
		ax = q(1, S * 2 / az / R)
	end
	if not F.visible then
		ax = ax / 2
	end
	if as and self:MinionCollision(E, av, H, _, a5, S) or MapPosition:inWall(av) then
		ax = -1
	elseif self:GetDistanceSqr(av, E) > _ * _ then
		ax = 0
	end
	return av, aw, ax, R
end

function PremiumPrediction:GetStandardPrediction(E, F, H, _, a5, S, ar, as, az)
	local ay = Vector(E)
	local E = self:IsZero(ay) and Vector(E.pos) or ay
	local at = F.pos
	local a5 = a5 + a() / 1000
	local az = F.ms
	local aw, av = at, at
	local ax, R = 0, a5
	local au = F.networkID
	if self:IsMoving(F) then
		local a3, a4 = at, Vector(F.pathing.endPos)
		local aA, aB, aC = a4.x - a3.x, a4.y - a3.y, a4.z - a3.z
		local aD = t(aA * aA + aC * aC)
		local aE = Vector(aA / aD * az, aB / aD * az, aC / aD * az)
		if H ~= o then
			local M, N = self:CalculateInterceptionTime(E, a3, aE, H)
			R = a5 + p(M, N)
		end
		local aK = q(R * az, aD)
		if ar and ar > 0 then
			S = t(2 * aK * aK - 2 * aK * aK * l(ar))
		end
		aw = Vector(a3.x + aK * aE.x / az, a3.y + aK * aE.y / az, a3.z + aK * aE.z / az)
		av = self:GenerateCastPos(E, aw, a3, a4, H * R, S)
		local aL, aM, aN = at, 0, 0
		for a6 = F.pathing.pathIndex, F.pathing.pathCount do
			local aO, aP = F:GetPath(a6)
			if aO then
				local aQ = t((aL.x - aO.x) ^ 2 + (aL.z - aO.z) ^ 2)
				if aN < a5 + aN + aQ / az then
					if a6 == F.pathing.pathIndex and a5 < aQ / az then
						aL = aL + (aO - aL) / aQ * az * (aN + a5)
						aQ = t((aL.x - aO.x) ^ 2 + (aL.z - aO.z) ^ 2)
					end
					do
						local G = (aO - aL) / aQ
						local M, N = self:CalculateInterceptionTime(E, aL, G, H)
						aP = aM + aQ / az
						if not N or not (aM < N) or not (N < aP - aM) or not N then
							N = nil
						end
						M = M and aM < M and M < aP - aM and M or nil
						local aR = M and N and q(M, N) or M or N
						if aR then
							R = H ~= o and a5 + aR or a5
							aw = aL + G * az * aR
							av = self:GenerateCastPos(E, aw, aL, aO, H * R, S)
							break
						end
					end
					aN = p(0, aN - aQ / az)
				end
			end
			aL = aO
			aM = aP
		end
		ax = q(1, S * 2 / az / R)
		if self:IsSlowed(F) then
			ax = q(1, ax * 1.25)
		end
		if not F.visible then
			ax = ax / 2
		end
		if as and self:MinionCollision(E, av, H, _, a5, S) or MapPosition:inWall(av) then
			ax = -1
		elseif self:GetDistanceSqr(av, E) > _ * _ or av == at then
			ax = 0
		end
		return av, aw, ax, R
	end
end

function PremiumPrediction:GetLinearAOEPrediction(E, F, H, _, a5, S, ar, as)
	local av, aw, ax, R = self:GetPrediction(E, F, H, _, a5, S, ar, as)
	local E = Vector(E.pos)
	local aS = 2 * S * 2 * S
	local aT = av
	local aU, aV = av.x, av.z
	do
		local aA, aC = aU - E.x, aV - E.z
		local aD = t(aA * aC + aC * aC)
		aU = aU + aA / aD * _
		aV = aV + aC / aD * _
	end
	for a6, aW in pairs(self:GetEnemyHeroes()) do
		if self:ValidTarget(aW) and aW ~= F then
			local aX, aY, aZ = self:GetPrediction(E, aW, H, _, a5, S, ar, as)
			local K = (aX.x - E.x) * (aU - E.x) + (aX.z - E.z) * (aV - E.z)
			if _ > self:GetDistance(aX, E) then
				local aR = K / (_ * _)
				if aR > 0 and aR < 1 then
					local a_ = Vector(E.x + aR * (aU - E.x), 0, E.z + aR * (aV - E.z))
					local b0 = (aX.x - a_.x) * (aX.x - a_.x) + (aX.z - a_.z) * (aX.z - a_.z)
					if aS > b0 then
						aT = Vector(0.5 * (aT.x + aX.x), aT.y, 0.5 * (aT.z + aX.z))
						aS = aS - 0.5 * b0
					end
				end
			end
		end
	end
	av = aT
	return av, ax
end

function PremiumPrediction:GetCircularAOEPrediction(E, F, H, _, a5, S, ar, as)
	local av, aw, ax, R = self:GetPrediction(E, F, H, _, a5, S, ar, as)
	local E = Vector(E.pos)
	local aS = 2 * S * 2 * S
	local aT = av
	local aU, aV = av.x, av.z
	for a6, aW in pairs(self:GetEnemyHeroes()) do
		if self:ValidTarget(aW) and aW ~= F then
			local aX, aY, aZ = self:GetPrediction(E, aW, H, _, a5, S, ar, as)
			local b1 = (aX.x - aU) * (aX.x - aU) + (aX.z - aV) * (aX.z - aV)
			if aS > b1 then
				aT = Vector(0.5 * (aT.x + aX.x), aT.y, 0.5 * (aT.z + aX.z))
				aS = aS - 0.5 * b1
			end
		end
	end
	av = aT
	return av, ax
end

function PremiumPrediction:GetConicAOEPrediction(E, F, H, _, a5, S, ar, as)
	if ar and ar > 0 then
		local av, aw, ax, R = self:GetPrediction(E, F, H, _, a5, S, ar, as)
		local E = Vector(E.pos)
		local aS = 2 * ar
		local aT = av
		local aU, aV = av.x, av.z
		local aA, aC = aU - E.x, aV - E.z
		do
			local aD = t(aA * aC + aC * aC)
			aU = aU + aA / aD * _
			aV = aV + aC / aD * _
		end
		for a6, aW in pairs(self:GetEnemyHeroes()) do
			if self:ValidTarget(aW) and aW ~= F then
				local aX, aY, aZ = self:GetPrediction(E, aW, H, _, a5, S, ar, as)
				local b2 = self:GetDistance(aX, E)
				if _ > b2 then
					local b3 = self:GetDistance(aT, E)
					local b4 = (aT.x - E.x) * (aX.x - E.x) + (aT.z - E.z) * (aX.z - E.z)
					local b5 = m(j(b4 / (b2 * b3)))
					if aS > b5 then
						aT = Vector(0.5 * (aT.x + aX.x), aT.y, 0.5 * (aT.z + aX.z))
						aS = b5
					end
				end
			end
		end
		av = aT
		return av, ax
	end
end

function PremiumPrediction:GetHealthPrediction(a7, b6, R)
	local b7 = a7.health
	for a6 = 1, #b6 do
		local b8 = b6[a6]
		if b8.attackData.target == a7.handle then
			local b9 = b8.totalDamage * (1 + b8.bonusDamagePercent) - a7.flatDamageReduction
			local ba
			if b8.attackData.projectileSpeed and b8.attackData.projectileSpeed > 0 then
				ba = self:GetDistance(b8.pos, a7.pos) / b8.attackData.projectileSpeed
			else
				ba = 0
			end
			local bb = b8.attackData.endTime - b8.attackData.animationTime + ba + b8.attackData.windUpTime
			if bb <= b() then
				bb = bb + b8.attackData.animationTime + ba
			end
			while R > bb - b() do
				b7 = b7 - b9
				bb = bb + b8.attackData.animationTime + ba
			end
		end
	end
	return b7
end
