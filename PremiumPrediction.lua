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
local y = "1.09"

function AutoUpdate()
	DownloadFileAsync(w, COMMON_PATH .. "PremiumPrediction.version", function()
	end)
	if tonumber(ReadFile(COMMON_PATH, "PremiumPrediction.version")) > tonumber(y) then
		print("PP: Update found, downloading...")
		DownloadFileAsync(x, COMMON_PATH .. "PremiumPrediction.lua", function()
		end)
		print("PP: Successfully updated. Reload!")
		DeleteFile(COMMON_PATH .. "PremiumPrediction.version", function()
		end)
	else
		DeleteFile(COMMON_PATH .. "PremiumPrediction.version", function()
		end)
	end
end

function OnLoad()
	require("MapPositionGOS")
	PremiumPrediction()
	AutoUpdate()
end

class("PremiumPrediction")

local z = {}
function PremiumPrediction:__init()
end

--[[
	╔═╗┌─┐┌─┐┌┬┐┌─┐┌┬┐┬─┐┬ ┬
	║ ╦├┤ │ ││││├┤  │ ├┬┘└┬┘
	╚═╝└─┘└─┘┴ ┴└─┘ ┴ ┴└─ ┴ 
--]]

function PremiumPrediction:CalculateInterceptionTime(A, B, C, D)
	local E = C.x * C.x + C.z * C.z - D * D
	local F = 2 * (C.x * (B.x - A.x) + C.z * (B.z - A.z))
	local G = B.x * B.x + B.z * B.z + A.x * A.x + A.z * A.z - 2 * A.x * B.x - 2 * A.z * B.z
	local H = F * F - 4 * E * G
	local I = (-F + t(H)) / (2 * E)
	local J = (-F - t(H)) / (2 * E)
	return I, J
end

function PremiumPrediction:GenerateCastPos(A, K, L, M, N, O)
	local P = (i(M.z - L.z, M.x - L.x) - i(A.z - K.z, A.x - K.x)) % (2 * r)
	local Q = 1 - g(P % r - r / 2) / (r / 2)
	local R = P < r and h(O / 2 / N) or -h(O / 2 / N)
	local S, T = K.x - A.x, K.z - A.z
	return Vector(l(R) * S - s(R) * T + A.x, K.y, s(R) * S + l(R) * T + A.z)
end

function PremiumPrediction:GetDistanceSqr(U, V)
	local V = V or myHero.pos
	local S = U.x - V.x
	local T = (U.z or U.y) - (V.z or V.y)
	return S * S + T * T
end

function PremiumPrediction:GetDistance(U, V)
	return t(self:GetDistanceSqr(U, V))
end

function PremiumPrediction:IsInRange(U, V, W)
	local X = U.x - V.x
	local Y = U.z - V.z
	return X * X + Y * Y <= W * W
end

function PremiumPrediction:IsZero(Z)
	return Z.x == 0 and Z.y == 0 and Z.z == 0
end

function PremiumPrediction:MinionCollision(_, a0, D, W, a1, O)
	for a2 = 1, e() do
		local a3 = f(a2)
		if a3 and a3.isEnemy then
			local a4, a5, a6 = self:VectorPointProjectionOnLineSegment(_, a0, a3.pos)
			if a6 and self:GetDistanceSqr(a4, a3.pos) <= (O + a3.boundingRadius * 2) ^ 2 and self:GetHealthPrediction(a3, self:GetAllyMinions(W), a1 + self:GetDistance(_, a3.pos) / D) > 0 then
				return true
			end
		end
	end
	return false
end

function PremiumPrediction:VectorPointProjectionOnLineSegment(a7, a8, a9)
	local aa, ab, ac, ad, ae, af = a8.z or a9.x, a9.z or a9.y, a7.x, a7.z or a7.y, a8.x, a8.y
	local ag = ((aa - ac) * (ae - ac) + (ab - ad) * (af - ad)) / ((ae - ac) ^ 2 + (af - ad) ^ 2)
	local a5 = {
		x = ac + ag * (ae - ac),
		y = ad + ag * (af - ad)
	}
	local ah = ag < 0 and 0 or ag > 1 and 1 or ag
	local a6 = ah == ag
	local a4 = a6 and a5 or {
		x = ac + ah * (ae - ac),
		y = ad + ah * (af - ad)
	}
	return a4, a5, a6
end

--[[
	┬ ┬┌┐┌┬┌┬┐┌─┐
	│ │││││ │ └─┐
	└─┘┘└┘┴ ┴ └─┘
--]]

function PremiumPrediction:GetAllyMinions(W)
	local ai = {}
	for a2 = 1, e() do
		local a3 = f(a2)
		if a3 and a3.team == myHero.team and self:ValidTarget(a3, W) then
			u(ai, a3)
		end
	end
	return ai
end

function PremiumPrediction:GetEnemyHeroes()
	local aj = {}
	for a2 = 1, c() do
		local ak = d(a2)
		if ak.isEnemy then
			u(aj, Hero)
		end
	end
	return aj
end

function PremiumPrediction:IsAttacking(B)
	if B.activeSpell then
		return b() < B.activeSpell.startTime + B.activeSpell.windup, B.activeSpell.startTime + B.activeSpell.windup - b()
	end
end

function PremiumPrediction:IsDashing(B)
	return B.pathing.isDashing
end

function PremiumPrediction:IsImmobile(B)
	for a2 = 0, B.buffCount do
		local al = B:GetBuff(a2)
		if al and (al.type == 5 or al.type == 11 or al.type == 18 or al.type == 22 or al.type == 24 or al.type == 28 or al.type == 29) and 0 < al.duration then
			return b() < al.expireTime, al.expireTime - b()
		end
	end
	return false
end

function PremiumPrediction:IsMoving(B)
	return B.pathing.hasMovePath
end

function PremiumPrediction:IsSlowed(B)
	for a2 = 0, B.buffCount do
		local al = B:GetBuff(a2)
		if al and al.type == 10 and 0 < al.duration then
			return b() < al.expireTime
		end
	end
	return false
end

function PremiumPrediction:ValidTarget(am, W)
	if not W or not W then
		W = o
	end
	return am ~= nil and am.valid and am.visible and not am.dead and W >= am.distance
end

--[[
	┌─┐┌─┐┬  ┬  ┌┐ ┌─┐┌─┐┬┌─
	│  ├─┤│  │  ├┴┐├─┤│  ├┴┐
	└─┘┴ ┴┴─┘┴─┘└─┘┴ ┴└─┘┴ ┴
--]]

function PremiumPrediction:GetPrediction(A, B, D, W, a1, O, an, ao)
	local ap = Vector(B.pos)
	if ap then
		local D = D or o
		local W = W or 12500
		local aq = B.networkID
		if self:IsMoving(B) then
			if self:IsDashing(B) then
				local ar, as, at, N = self:GetDashPrediction(A, B, D, W, a1, O, ao)
				return ar, as, at, N
			else
				local ar, as, at, N = self:GetStandardPrediction(A, B, D, W, a1, O, an, ao)
				return ar, as, at, N
			end
		else
			local ar, as, at, N = self:GetImmobilePrediction(A, B, D, W, a1, O, ao)
			return ar, as, at, N
		end
	end
end

function PremiumPrediction:GetDashPrediction(A, B, D, W, a1, O, ao)
	if self:IsDashing(B) then
		local au = Vector(A)
		local A = self:IsZero(au) and Vector(A.pos) or au
		local ap = Vector(B.pos)
		local a1 = a1 + a() / 1000
		local av = B.pathing.dashSpeed
		local ar, as = ap, ap
		local at = 1
		local _, a0 = Vector(B.pathing.startPos), Vector(B.pathing.endPos)
		local aw, ax, ay = a0.x - _.x, a0.y - _.y, a0.z - _.z
		local az = t(aw * aw + ay * ay)
		local aA = Vector(aw / az * av, ax / az, ay / az * av)
		local I, J = self:CalculateInterceptionTime(A, _, aA, D)
		local N = a1 + p(I, J)
		local aB = a1 + self:GetDistance(ap, a0) / D
		if N <= aB then
			ar = _:Extended(a0, av * N)
		else
			ar = a0
		end
		as = ar
		if ao and self:MinionCollision(A, ar, D, W, a1, O) or MapPosition:inWall(ar) then
			at = -1
		elseif self:GetDistanceSqr(ar, A) > W * W then
			at = 0
		end
		return ar, as, at, N
	end
end

function PremiumPrediction:GetImmobilePrediction(A, B, D, W, a1, O, ao, av)
	local au = Vector(A)
	local A = self:IsZero(au) and Vector(A.pos) or au
	local ap = Vector(B.pos)
	local av = B.ms
	local ar, as = ap, ap
	local at = 0
	local N = self:GetDistance(A, ar) / D + a1 + a() / 1000
	local aC, aD = self:IsAttacking(B)
	local aE, aF = self:IsImmobile(B)
	if aC then
		at = q(1, O * 2 / av / (N - aD))
	elseif aE then
		if N < aF then
			at = 1
		else
			at = q(1, O * 2 / av / (N - aF))
		end
	else
		at = q(1, O * 2 / av / N)
	end
	if not B.visible then
		at = at / 2
	end
	if ao and self:MinionCollision(A, ar, D, W, a1, O) or MapPosition:inWall(ar) then
		at = -1
	elseif self:GetDistanceSqr(ar, A) > W * W then
		at = 0
	end
	return ar, as, at, N
end

function PremiumPrediction:GetStandardPrediction(A, B, D, W, a1, O, an, ao, av)
	local au = Vector(A)
	local A = self:IsZero(au) and Vector(A.pos) or au
	local ap = B.pos
	local a1 = a1 + a() / 1000
	local av = B.ms
	local as, ar = ap, ap
	local at, N = 0, a1
	local aq = B.networkID
	if self:IsMoving(B) then
		local _, a0 = ap, Vector(B.pathing.endPos)
		local aw, ax, ay = a0.x - _.x, a0.y - _.y, a0.z - _.z
		local az = t(aw * aw + ay * ay)
		local aA = Vector(aw / az * av, ax / az * av, ay / az * av)
		if D ~= o then
			local I, J = self:CalculateInterceptionTime(A, _, aA, D)
			N = a1 + p(I, J)
		end
		local aG = q(N * av, az)
		if an and an > 0 then
			O = t(2 * aG * aG - 2 * aG * aG * l(an))
		end
		as = Vector(_.x + aG * aA.x / av, _.y + aG * aA.y / av, _.z + aG * aA.z / av)
		ar = self:GenerateCastPos(A, as, _, a0, D * N, O)
		local aH, aI, aJ = ap, 0, 0
		for a2 = B.pathing.pathIndex, B.pathing.pathCount do
			local aK, aL = B:GetPath(a2)
			if aK then
				local aM = t((aH.x - aK.x) ^ 2 + (aH.z - aK.z) ^ 2)
				if aJ < a1 + aJ + aM / av then
					if a2 == B.pathing.pathIndex and a1 < aM / av then
						aH = aH + (aK - aH) / aM * av * (aJ + a1)
						aM = t((aH.x - aK.x) ^ 2 + (aH.z - aK.z) ^ 2)
					end
					do
						local C = (aK - aH) / aM
						local I, J = self:CalculateInterceptionTime(A, aH, C, D)
						aL = aI + aM / av
						if not J or not (aI < J) or not (J < aL - aI) or not J then
							J = nil
						end
						I = I and aI < I and I < aL - aI and I or nil
						local aN = I and J and q(I, J) or I or J
						if aN then
							N = D ~= o and a1 + aN or a1
							as = aH + C * av * aN
							ar = self:GenerateCastPos(A, as, aH, aK, D * N, O)
							break
						end
					end
					aJ = p(0, aJ - aM / av)
				end
			end
			aH = aK
			aI = aL
		end
		at = q(1, O * 2 / av / N)
		if self:IsSlowed(B) then
			at = q(1, at * 1.25)
		end
		if not B.visible then
			at = at / 2
		end
		if ao and self:MinionCollision(A, ar, D, W, a1, O) or MapPosition:inWall(ar) then
			at = -1
		elseif self:GetDistanceSqr(ar, A) > W * W or ar == ap then
			at = 0
		end
		return ar, as, at, N
	end
end

function PremiumPrediction:GetLinearAOEPrediction(A, B, D, W, a1, O, an, ao)
	local ar, as, at, N = self:GetPrediction(A, B, D, W, a1, O, an, ao)
	local A = Vector(A.pos)
	local aO = 2 * O * 2 * O
	local aP = ar
	local aQ, aR = ar.x, ar.z
	do
		local aw, ay = aQ - A.x, aR - A.z
		local az = t(aw * ay + ay * ay)
		aQ = aQ + aw / az * W
		aR = aR + ay / az * W
	end
	for a2, aS in pairs(self:GetEnemyHeroes()) do
		if self:ValidTarget(aS) and aS ~= B then
			local aT, aU, aV = self:GetPrediction(A, aS, D, W, a1, O, an, ao)
			local G = (aT.x - A.x) * (aQ - A.x) + (aT.z - A.z) * (aR - A.z)
			if W > self:GetDistance(aT, A) then
				local aN = G / (W * W)
				if aN > 0 and aN < 1 then
					local aW = Vector(A.x + aN * (aQ - A.x), 0, A.z + aN * (aR - A.z))
					local aX = (aT.x - aW.x) * (aT.x - aW.x) + (aT.z - aW.z) * (aT.z - aW.z)
					if aO > aX then
						aP = Vector(0.5 * (aP.x + aT.x), aP.y, 0.5 * (aP.z + aT.z))
						aO = aO - 0.5 * aX
					end
				end
			end
		end
	end
	ar = aP
	return ar, at
end

function PremiumPrediction:GetCircularAOEPrediction(A, B, D, W, a1, O, an, ao)
	local ar, as, at, N = self:GetPrediction(A, B, D, W, a1, O, an, ao)
	local A = Vector(A.pos)
	local aO = 2 * O * 2 * O
	local aP = ar
	local aQ, aR = ar.x, ar.z
	for a2, aS in pairs(self:GetEnemyHeroes()) do
		if self:ValidTarget(aS) and aS ~= B then
			local aT, aU, aV = self:GetPrediction(A, aS, D, W, a1, O, an, ao)
			local aY = (aT.x - aQ) * (aT.x - aQ) + (aT.z - aR) * (aT.z - aR)
			if aO > aY then
				aP = Vector(0.5 * (aP.x + aT.x), aP.y, 0.5 * (aP.z + aT.z))
				aO = aO - 0.5 * aY
			end
		end
	end
	ar = aP
	return ar, at
end

function PremiumPrediction:GetConicAOEPrediction(A, B, D, W, a1, O, an, ao)
	if an and an > 0 then
		local ar, as, at, N = self:GetPrediction(A, B, D, W, a1, O, an, ao)
		local A = Vector(A.pos)
		local aO = 2 * an
		local aP = ar
		local aQ, aR = ar.x, ar.z
		local aw, ay = aQ - A.x, aR - A.z
		do
			local az = t(aw * ay + ay * ay)
			aQ = aQ + aw / az * W
			aR = aR + ay / az * W
		end
		for a2, aS in pairs(self:GetEnemyHeroes()) do
			if self:ValidTarget(aS) and aS ~= B then
				local aT, aU, aV = self:GetPrediction(A, aS, D, W, a1, O, an, ao)
				local aZ = self:GetDistance(aT, A)
				if W > aZ then
					local a_ = self:GetDistance(aP, A)
					local b0 = (aP.x - A.x) * (aT.x - A.x) + (aP.z - A.z) * (aT.z - A.z)
					local b1 = m(j(b0 / (aZ * a_)))
					if aO > b1 then
						aP = Vector(0.5 * (aP.x + aT.x), aP.y, 0.5 * (aP.z + aT.z))
						aO = b1
					end
				end
			end
		end
		ar = aP
		return ar, at
	end
end

function PremiumPrediction:GetHealthPrediction(a3, b2, N)
	local b3 = a3.health
	for a2 = 1, #b2 do
		local b4 = b2[a2]
		if b4.attackData.target == a3.handle then
			local b5 = b4.totalDamage * (1 + b4.bonusDamagePercent) - a3.flatDamageReduction
			local b6
			if b4.attackData.projectileSpeed and b4.attackData.projectileSpeed > 0 then
				b6 = self:GetDistance(b4.pos, a3.pos) / b4.attackData.projectileSpeed
			else
				b6 = 0
			end
			local b7 = b4.attackData.endTime - b4.attackData.animationTime + b6 + b4.attackData.windUpTime
			if b7 <= b() then
				b7 = b7 + b4.attackData.animationTime + b6
			end
			while N > b7 - b() do
				b3 = b3 - b5
				b7 = b7 + b4.attackData.animationTime + b6
			end
		end
	end
	return b3
end
