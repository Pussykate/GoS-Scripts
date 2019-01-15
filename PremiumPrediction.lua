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
local y = "1.06"

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
function PremiumPrediction:__init()
	ActiveWaypoints = {}
	Callback.Add("Tick", function()
		self:Tick()
	end)
end

function PremiumPrediction:Tick()
	self:ProcessWaypoint(self:GetEnemyHeroes())
end

--[[
	╔═╗┌─┐┌─┐┌┬┐┌─┐┌┬┐┬─┐┬ ┬
	║ ╦├┤ │ ││││├┤  │ ├┬┘└┬┘
	╚═╝└─┘└─┘┴ ┴└─┘ ┴ ┴└─ ┴ 
--]]

function PremiumPrediction:CalculateInterceptionTime(z, A, B, C)
	local D = B.x * B.x + B.z * B.z - C * C
	local E = 2 * (B.x * (A.x - z.x) + B.z * (A.z - z.z))
	local F = A.x * A.x + A.z * A.z + z.x * z.x + z.z * z.z - 2 * z.x * A.x - 2 * z.z * A.z
	local G = E * E - 4 * D * F
	local H = (-E + t(G)) / (2 * D)
	local I = (-E - t(G)) / (2 * D)
	return H, I
end

function PremiumPrediction:GenerateCastPos(z, J, K, L, M, N)
	local O = (i(L.z - K.z, L.x - K.x) - i(z.z - J.z, z.x - J.x)) % (2 * r)
	local P = 1 - g(O % r - r / 2) / (r / 2)
	local Q = O < r and h(N / 2 / M) or -h(N / 2 / M)
	local R, S = J.x - z.x, J.z - z.z
	return Vector(l(Q) * R - s(Q) * S + z.x, J.y, s(Q) * R + l(Q) * S + z.z)
end

function PremiumPrediction:GetDistanceSqr(T, U)
	local U = U or myHero.pos
	local R = T.x - U.x
	local S = (T.z or T.y) - (U.z or U.y)
	return R * R + S * S
end

function PremiumPrediction:GetDistance(T, U)
	return t(self:GetDistanceSqr(T, U))
end

function PremiumPrediction:IsInRange(T, U, V)
	local W = T.x - U.x
	local X = T.z - U.z
	return W * W + X * X <= V * V
end

function PremiumPrediction:IsZero(Y)
	return Y.x == 0 and Y.y == 0 and Y.z == 0
end

function PremiumPrediction:MinionCollision(Z, _, C, V, a0, N)
	for a1 = 1, e() do
		local a2 = f(a1)
		if a2 and a2.isEnemy then
			local a3, a4, a5 = self:VectorPointProjectionOnLineSegment(Z, _, a2.pos)
			if a5 and self:GetDistanceSqr(a3, a2.pos) <= (N + a2.boundingRadius * 2) ^ 2 and self:GetHealthPrediction(a2, self:GetAllyMinions(V), a0 + self:GetDistance(Z, a2.pos) / C) > 0 then
				return true
			end
		end
	end
	return false
end

function PremiumPrediction:ProcessWaypoint(a6)
	for a1 = 1, #a6 do
		local A = a6[a1]
		local a7 = A.networkID
		if not ActiveWaypoints[a7] then
			ActiveWaypoints[a7] = {}
		end
		if A.pathing.hasMovePath then
			local a8 = #ActiveWaypoints[a7]
			if a8 > 0 then
				local _ = Vector(A.pathing.endPos)
				local a9 = ActiveWaypoints[a7][a8].endPos
				if not self:IsInRange(a9, _, 10) then
					u(ActiveWaypoints[a7], {
						startPos = Vector(A.pathing.startPos),
						endPos = Vector(A.pathing.endPos),
						ticker = GetTickCount()
					})
				end
			else
				u(ActiveWaypoints[a7], {
					startPos = Vector(A.pathing.startPos),
					endPos = Vector(A.pathing.endPos),
					ticker = GetTickCount()
				})
			end
			for a1, aa in pairs(ActiveWaypoints[a7]) do
				if aa.endPos then
					if a1 > 5 then
						v(ActiveWaypoints[a7], 1)
					end
					if GetTickCount() > aa.ticker + 175 then
						v(ActiveWaypoints[a7], a1)
					end
				end
			end
		else
			for a1 = 1, 5 do
				v(ActiveWaypoints[a7], a1)
			end
		end
	end
end

function PremiumPrediction:VectorPointProjectionOnLineSegment(ab, ac, ad)
	local ae, af, ag, ah, ai, aj = ac.z or ad.x, ad.z or ad.y, ab.x, ab.z or ab.y, ac.x, ac.y
	local ak = ((ae - ag) * (ai - ag) + (af - ah) * (aj - ah)) / ((ai - ag) ^ 2 + (aj - ah) ^ 2)
	local a4 = {
		x = ag + ak * (ai - ag),
		y = ah + ak * (aj - ah)
	}
	local al = ak < 0 and 0 or ak > 1 and 1 or ak
	local a5 = al == ak
	local a3 = a5 and a4 or {
		x = ag + al * (ai - ag),
		y = ah + al * (aj - ah)
	}
	return a3, a4, a5
end

--[[
	┬ ┬┌┐┌┬┌┬┐┌─┐
	│ │││││ │ └─┐
	└─┘┘└┘┴ ┴ └─┘
--]]

function PremiumPrediction:GetAllyMinions(V)
	local am = {}
	for a1 = 1, e() do
		local a2 = f(a1)
		if a2 and a2.team == myHero.team and self:ValidTarget(a2, V) then
			am[#am + 1] = a2
		end
	end
	return am
end

function PremiumPrediction:GetEnemyHeroes()
	EnemyHeroes = {}
	for a1 = 1, c() do
		local an = d(a1)
		if an.isEnemy then
			u(EnemyHeroes, an)
		end
	end
	return EnemyHeroes
end

function PremiumPrediction:IsAttacking(A)
	if A.activeSpell then
		return b() < A.activeSpell.startTime + A.activeSpell.windup, A.activeSpell.startTime + A.activeSpell.windup - b()
	end
end

function PremiumPrediction:IsDashing(A)
	return A.pathing.isDashing
end

function PremiumPrediction:IsImmobile(A)
	for a1 = 0, A.buffCount do
		local ao = A:GetBuff(a1)
		if ao and (ao.type == 5 or ao.type == 11 or ao.type == 18 or ao.type == 22 or ao.type == 24 or ao.type == 28 or ao.type == 29) and 0 < ao.duration then
			return b() < ao.expireTime, ao.expireTime - b()
		end
	end
	return false
end

function PremiumPrediction:IsMoving(A)
	return A.pathing.hasMovePath
end

function PremiumPrediction:IsSlowed(A)
	for a1 = 0, A.buffCount do
		local ao = A:GetBuff(a1)
		if ao and ao.type == 10 and 0 < ao.duration then
			return b() < ao.expireTime
		end
	end
	return false
end

function PremiumPrediction:ValidTarget(ap, V)
	if not V or not V then
		V = o
	end
	return ap ~= nil and ap.valid and ap.visible and not ap.dead and V >= ap.distance
end

--[[
	┌─┐┌─┐┬  ┬  ┌┐ ┌─┐┌─┐┬┌─
	│  ├─┤│  │  ├┴┐├─┤│  ├┴┐
	└─┘┴ ┴┴─┘┴─┘└─┘┴ ┴└─┘┴ ┴
--]]

function PremiumPrediction:GetPrediction(z, A, C, V, a0, N, aq, ar)
	local as = Vector(A.pos)
	if as then
		local C = C or o
		local V = V or 12500
		local a7 = A.networkID
		if self:IsMoving(A) then
			if self:IsDashing(A) then
				local at, au, av, M = self:GetDashPrediction(z, A, C, V, a0, N, ar)
				return at, au, av, M
			else
				local at, au, av, M = self:GetStandardPrediction(z, A, C, V, a0, N, aq, ar)
				return at, au, av, M
			end
		else
			local at, au, av, M = self:GetImmobilePrediction(z, A, C, V, a0, N, ar)
			return at, au, av, M
		end
	end
end

function PremiumPrediction:GetDashPrediction(z, A, C, V, a0, N, ar)
	if self:IsDashing(A) then
		local aw = Vector(z)
		local z = self:IsZero(aw) and Vector(z.pos) or aw
		local as = Vector(A.pos)
		local a0 = a0 + a() / 1000
		local ax = A.pathing.dashSpeed
		local at, au = as, as
		local av = 1
		local Z, _ = Vector(A.pathing.startPos), Vector(A.pathing.endPos)
		local ay, az, aA = _.x - Z.x, _.y - Z.y, _.z - Z.z
		local aB = t(ay * ay + aA * aA)
		local aC = Vector(ay / aB * ax, az / aB, aA / aB * ax)
		local H, I = self:CalculateInterceptionTime(z, Z, aC, C)
		local M = a0 + p(H, I)
		local aD = a0 + self:GetDistance(as, _) / C
		if M <= aD then
			at = Z:Extended(_, ax * M)
		else
			at = _
		end
		au = at
		if ar and self:MinionCollision(z, at, C, V, a0, N) or MapPosition:inWall(at) then
			av = -1
		elseif self:GetDistanceSqr(at, z) > V * V then
			av = 0
		end
		return at, au, av, M
	end
end

function PremiumPrediction:GetImmobilePrediction(z, A, C, V, a0, N, ar, ax)
	local aw = Vector(z)
	local z = self:IsZero(aw) and Vector(z.pos) or aw
	local as = Vector(A.pos)
	local ax = A.ms
	local at, au = as, as
	local av = 0
	local M = self:GetDistance(z, at) / C + a0 + a() / 1000
	local aE, aF = self:IsAttacking(A)
	local aG, aH = self:IsImmobile(A)
	if aE then
		av = q(1, N * 2 / ax / (M - aF))
	elseif aG then
		if M < aH then
			av = 1
		else
			av = q(1, N * 2 / ax / (M - aH))
		end
	else
		av = q(1, N * 2 / ax / M)
	end
	if not A.visible then
		av = av / 2
	end
	if ar and self:MinionCollision(z, at, C, V, a0, N) or MapPosition:inWall(at) then
		av = -1
	elseif self:GetDistanceSqr(at, z) > V * V then
		av = 0
	end
	return at, au, av, M
end

function PremiumPrediction:GetStandardPrediction(z, A, C, V, a0, N, aq, ar, ax)
	local aw = Vector(z)
	local z = self:IsZero(aw) and Vector(z.pos) or aw
	local as = A.pos
	local a0 = a0 + a() / 1000
	local ax = A.ms
	local au, at = as, as
	local av, M = 0, a0
	local a7 = A.networkID
	if self:IsMoving(A) then
		local a8 = ActiveWaypoints[a7] and #ActiveWaypoints[a7] >= 2 and #ActiveWaypoints[a7] or 1
		local aI = {
			x = 0,
			y = 0,
			z = 0
		}
		for a1 = a8, 1, -1 do
			local Z, _ = Vector(A.pathing.startPos), Vector(A.pathing.endPos)
			if a8 >= 2 then
				Z, _ = ActiveWaypoints[a7][a1].startPos, ActiveWaypoints[a7][a1].endPos
			end
			local ay, az, aA = _.x - Z.x, _.y - Z.y, _.z - Z.z
			local aB = t(ay * ay + aA * aA)
			local aC = Vector(ay / aB * ax, az / aB, aA / aB * ax)
			if C ~= o then
				local H, I = self:CalculateInterceptionTime(z, Z, aC, C)
				M = a0 + p(H, I)
			end
			local aJ = q(M * ax, aB)
			if aq and aq > 0 then
				N = t(2 * aJ * aJ - 2 * aJ * aJ * l(aq))
			end
			au = Vector(Z.x + aJ * aC.x / ax, Z.y + aJ * aC.y, Z.z + aJ * aC.z / ax)
			at = self:GenerateCastPos(z, au, Z, _, C * M, N)
			aI = {
				x = aI.x + at.x,
				y = aI.y + at.y,
				z = aI.z + at.z
			}
		end
		aI = {
			x = aI.x / a8,
			y = aI.y / a8,
			z = aI.z / a8
		}
		local aK, aL = as, 0
		for a1 = A.pathing.pathIndex, A.pathing.pathCount do
			local aM, aN = A:GetPath(a1)
			if aM then
				local aO = t((aK.x - aM.x) ^ 2 + (aK.z - aM.z) ^ 2)
				if a1 == A.pathing.pathIndex and a0 < aO / ax then
					aK = aK + (aM - aK) / aO * ax * a0
					aO = t((aK.x - aM.x) ^ 2 + (aK.z - aM.z) ^ 2)
				end
				local B = (aM - aK) / aO
				local H, I = self:CalculateInterceptionTime(z, aK, B, C)
				aN = aL + aO / ax
				if not I or not (aL < I) or not (I < aN - aL) or not I then
					I = nil
				end
				H = H and aL < H and H < aN - aL and H or nil
				local aP = H and I and q(H, I) or H or I
				if aP then
					M = a0 + aP
					au = aK + B * ax * aP
					local aQ = a0 + C * aP
					at = self:GenerateCastPos(z, au, aK, aM, aQ, N)
					break
				end
			end
			aK = aM
			aL = aN
		end
		if a8 >= 2 and aI then
			at = Vector((aI + at) / 2):Normalized()
		end
		av = q(1, N * 2 / ax / M)
		if self:IsSlowed(A) then
			av = q(1, av * 1.25)
		end
		if not A.visible then
			av = av / 2
		end
		if ar and self:MinionCollision(z, at, C, V, a0, N) or MapPosition:inWall(at) then
			av = -1
		elseif self:GetDistanceSqr(at, z) > V * V then
			av = 0
		end
		return at, au, av, M
	end
end

function PremiumPrediction:GetLinearAOEPrediction(z, A, C, V, a0, N, aq, ar)
	local at, au, av, M = self:GetPrediction(z, A, C, V, a0, N, aq, ar)
	local z = Vector(z.pos)
	local aR = 2 * N * 2 * N
	local aS = at
	local aT, aU = at.x, at.z
	do
		local ay, aA = aT - z.x, aU - z.z
		local aB = t(ay * aA + aA * aA)
		aT = aT + ay / aB * V
		aU = aU + aA / aB * V
	end
	for a1, aV in pairs(self:GetEnemyHeroes()) do
		if self:ValidTarget(aV) and aV ~= A then
			local aW, aX, aY = self:GetPrediction(z, aV, C, V, a0, N, aq, ar)
			local F = (aW.x - z.x) * (aT - z.x) + (aW.z - z.z) * (aU - z.z)
			if V > self:GetDistance(aW, z) then
				local aP = F / (V * V)
				if aP > 0 and aP < 1 then
					local aZ = Vector(z.x + aP * (aT - z.x), 0, z.z + aP * (aU - z.z))
					local a_ = (aW.x - aZ.x) * (aW.x - aZ.x) + (aW.z - aZ.z) * (aW.z - aZ.z)
					if aR > a_ then
						aS = Vector(0.5 * (aS.x + aW.x), aS.y, 0.5 * (aS.z + aW.z))
						aR = aR - 0.5 * a_
					end
				end
			end
		end
	end
	at = aS
	return at, av
end

function PremiumPrediction:GetCircularAOEPrediction(z, A, C, V, a0, N, aq, ar)
	local at, au, av, M = self:GetPrediction(z, A, C, V, a0, N, aq, ar)
	local z = Vector(z.pos)
	local aR = 2 * N * 2 * N
	local aS = at
	local aT, aU = at.x, at.z
	for a1, aV in pairs(self:GetEnemyHeroes()) do
		if self:ValidTarget(aV) and aV ~= A then
			local aW, aX, aY = self:GetPrediction(z, aV, C, V, a0, N, aq, ar)
			local b0 = (aW.x - aT) * (aW.x - aT) + (aW.z - aU) * (aW.z - aU)
			if aR > b0 then
				aS = Vector(0.5 * (aS.x + aW.x), aS.y, 0.5 * (aS.z + aW.z))
				aR = aR - 0.5 * b0
			end
		end
	end
	at = aS
	return at, av
end

function PremiumPrediction:GetConicAOEPrediction(z, A, C, V, a0, N, aq, ar)
	if aq and aq > 0 then
		local at, au, av, M = self:GetPrediction(z, A, C, V, a0, N, aq, ar)
		local z = Vector(z.pos)
		local aR = 2 * aq
		local aS = at
		local aT, aU = at.x, at.z
		local ay, aA = aT - z.x, aU - z.z
		do
			local aB = t(ay * aA + aA * aA)
			aT = aT + ay / aB * V
			aU = aU + aA / aB * V
		end
		for a1, aV in pairs(self:GetEnemyHeroes()) do
			if self:ValidTarget(aV) and aV ~= A then
				local aW, aX, aY = self:GetPrediction(z, aV, C, V, a0, N, aq, ar)
				local b1 = self:GetDistance(aW, z)
				if V > b1 then
					local b2 = self:GetDistance(aS, z)
					local b3 = (aS.x - z.x) * (aW.x - z.x) + (aS.z - z.z) * (aW.z - z.z)
					local b4 = m(j(b3 / (b1 * b2)))
					if aR > b4 then
						aS = Vector(0.5 * (aS.x + aW.x), aS.y, 0.5 * (aS.z + aW.z))
						aR = b4
					end
				end
			end
		end
		at = aS
		return at, av
	end
end

function PremiumPrediction:GetHealthPrediction(a2, b5, M)
	local b6 = a2.health
	for a1 = 1, #b5 do
		local b7 = b5[a1]
		if b7.attackData.target == a2.handle then
			local b8 = b7.totalDamage * (1 + b7.bonusDamagePercent) - a2.flatDamageReduction
			local b9
			if b7.attackData.projectileSpeed and b7.attackData.projectileSpeed > 0 then
				b9 = self:GetDistance(b7.pos, a2.pos) / b7.attackData.projectileSpeed
			else
				b9 = 0
			end
			local ba = b7.attackData.endTime - b7.attackData.animationTime + b9 + b7.attackData.windUpTime
			if ba <= b() then
				ba = ba + b7.attackData.animationTime + b9
			end
			while M > ba - b() do
				b6 = b6 - b8
				ba = ba + b7.attackData.animationTime + b9
			end
		end
	end
	return b6
end
