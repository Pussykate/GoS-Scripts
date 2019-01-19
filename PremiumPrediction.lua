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
local y = "1.07"

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

function PremiumPrediction:ProcessWaypoint(a7)
	for a2 = 1, #a7 do
		local B = a7[a2]
		local a8 = B.networkID
		if not z[a8] then
			z[a8] = {}
		end
		if B.pathing.hasMovePath then
			local a9 = #z[a8]
			if a9 > 0 then
				local a0 = Vector(B.pathing.endPos)
				local aa = z[a8][a9].endPos
				if not self:IsInRange(aa, a0, 10) then
					u(z[a8], {
						startPos = Vector(B.pathing.startPos),
						endPos = Vector(B.pathing.endPos),
						ticker = GetTickCount()
					})
				end
			else
				u(z[a8], {
					startPos = Vector(B.pathing.startPos),
					endPos = Vector(B.pathing.endPos),
					ticker = GetTickCount()
				})
			end
			for a2, ab in pairs(z[a8]) do
				if ab.endPos then
					if a2 > 4 then
						v(z[a8], 1)
					end
					if GetTickCount() > ab.ticker + 150 then
						v(z[a8], a2)
					end
				end
			end
		else
			for a2 = 0, 5 do
				v(z[a8], a2)
			end
		end
	end
end

function PremiumPrediction:VectorPointProjectionOnLineSegment(ac, ad, ae)
	local af, ag, ah, ai, aj, ak = ad.z or ae.x, ae.z or ae.y, ac.x, ac.z or ac.y, ad.x, ad.y
	local al = ((af - ah) * (aj - ah) + (ag - ai) * (ak - ai)) / ((aj - ah) ^ 2 + (ak - ai) ^ 2)
	local a5 = {
		x = ah + al * (aj - ah),
		y = ai + al * (ak - ai)
	}
	local am = al < 0 and 0 or al > 1 and 1 or al
	local a6 = am == al
	local a4 = a6 and a5 or {
		x = ah + am * (aj - ah),
		y = ai + am * (ak - ai)
	}
	return a4, a5, a6
end

--[[
	┬ ┬┌┐┌┬┌┬┐┌─┐
	│ │││││ │ └─┐
	└─┘┘└┘┴ ┴ └─┘
--]]

function PremiumPrediction:GetAllyMinions(W)
	local an = {}
	for a2 = 1, e() do
		local a3 = f(a2)
		if a3 and a3.team == myHero.team and self:ValidTarget(a3, W) then
			an[#an + 1] = a3
		end
	end
	return an
end

function PremiumPrediction:GetEnemyHeroes()
	EnemyHeroes = {}
	for a2 = 1, c() do
		local ao = d(a2)
		if ao.isEnemy then
			u(EnemyHeroes, ao)
		end
	end
	return EnemyHeroes
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
		local ap = B:GetBuff(a2)
		if ap and (ap.type == 5 or ap.type == 11 or ap.type == 18 or ap.type == 22 or ap.type == 24 or ap.type == 28 or ap.type == 29) and 0 < ap.duration then
			return b() < ap.expireTime, ap.expireTime - b()
		end
	end
	return false
end

function PremiumPrediction:IsMoving(B)
	return B.pathing.hasMovePath
end

function PremiumPrediction:IsSlowed(B)
	for a2 = 0, B.buffCount do
		local ap = B:GetBuff(a2)
		if ap and ap.type == 10 and 0 < ap.duration then
			return b() < ap.expireTime
		end
	end
	return false
end

function PremiumPrediction:ValidTarget(aq, W)
	if not W or not W then
		W = o
	end
	return aq ~= nil and aq.valid and aq.visible and not aq.dead and W >= aq.distance
end

--[[
	┌─┐┌─┐┬  ┬  ┌┐ ┌─┐┌─┐┬┌─
	│  ├─┤│  │  ├┴┐├─┤│  ├┴┐
	└─┘┴ ┴┴─┘┴─┘└─┘┴ ┴└─┘┴ ┴
--]]

function PremiumPrediction:GetPrediction(A, B, D, W, a1, O, ar, as)
	local at = Vector(B.pos)
	if at then
		local D = D or o
		local W = W or 12500
		local a8 = B.networkID
		if self:IsMoving(B) then
			if self:IsDashing(B) then
				local au, av, aw, N = self:GetDashPrediction(A, B, D, W, a1, O, as)
				return au, av, aw, N
			else
				local au, av, aw, N = self:GetStandardPrediction(A, B, D, W, a1, O, ar, as)
				return au, av, aw, N
			end
		else
			local au, av, aw, N = self:GetImmobilePrediction(A, B, D, W, a1, O, as)
			return au, av, aw, N
		end
	end
end

function PremiumPrediction:GetDashPrediction(A, B, D, W, a1, O, as)
	if self:IsDashing(B) then
		local ax = Vector(A)
		local A = self:IsZero(ax) and Vector(A.pos) or ax
		local at = Vector(B.pos)
		local a1 = a1 + a() / 1000
		local ay = B.pathing.dashSpeed
		local au, av = at, at
		local aw = 1
		local _, a0 = Vector(B.pathing.startPos), Vector(B.pathing.endPos)
		local az, aA, aB = a0.x - _.x, a0.y - _.y, a0.z - _.z
		local aC = t(az * az + aB * aB)
		local aD = Vector(az / aC * ay, aA / aC, aB / aC * ay)
		local I, J = self:CalculateInterceptionTime(A, _, aD, D)
		local N = a1 + p(I, J)
		local aE = a1 + self:GetDistance(at, a0) / D
		if N <= aE then
			au = _:Extended(a0, ay * N)
		else
			au = a0
		end
		av = au
		if as and self:MinionCollision(A, au, D, W, a1, O) or MapPosition:inWall(au) then
			aw = -1
		elseif self:GetDistanceSqr(au, A) > W * W then
			aw = 0
		end
		return au, av, aw, N
	end
end

function PremiumPrediction:GetImmobilePrediction(A, B, D, W, a1, O, as, ay)
	local ax = Vector(A)
	local A = self:IsZero(ax) and Vector(A.pos) or ax
	local at = Vector(B.pos)
	local ay = B.ms
	local au, av = at, at
	local aw = 0
	local N = self:GetDistance(A, au) / D + a1 + a() / 1000
	local aF, aG = self:IsAttacking(B)
	local aH, aI = self:IsImmobile(B)
	if aF then
		aw = q(1, O * 2 / ay / (N - aG))
	elseif aH then
		if N < aI then
			aw = 1
		else
			aw = q(1, O * 2 / ay / (N - aI))
		end
	else
		aw = q(1, O * 2 / ay / N)
	end
	if not B.visible then
		aw = aw / 2
	end
	if as and self:MinionCollision(A, au, D, W, a1, O) or MapPosition:inWall(au) then
		aw = -1
	elseif self:GetDistanceSqr(au, A) > W * W then
		aw = 0
	end
	return au, av, aw, N
end

function PremiumPrediction:GetStandardPrediction(A, B, D, W, a1, O, ar, as, ay)
	local ax = Vector(A)
	local A = self:IsZero(ax) and Vector(A.pos) or ax
	local at = B.pos
	local a1 = a1 + a() / 1000
	local ay = B.ms
	local av, au = at, at
	local aw, N = 0, a1
	local a8 = B.networkID
	if self:IsMoving(B) then
		local a9 = z[a8] and #z[a8] >= 2 and #z[a8] or 1
		local aJ = {
			x = 0,
			y = 0,
			z = 0
		}
		for a2 = a9, 1, -1 do
			local _, a0 = Vector(B.pathing.startPos), Vector(B.pathing.endPos)
			if a9 >= 2 then
				_, a0 = z[a8][a2].startPos, z[a8][a2].endPos
			end
			local az, aA, aB = a0.x - _.x, a0.y - _.y, a0.z - _.z
			local aC = t(az * az + aB * aB)
			local aD = Vector(az / aC * ay, aA / aC, aB / aC * ay)
			if D ~= o then
				local I, J = self:CalculateInterceptionTime(A, _, aD, D)
				N = a1 + p(I, J)
			end
			local aK = q(N * ay, aC)
			if ar and ar > 0 then
				O = t(2 * aK * aK - 2 * aK * aK * l(ar))
			end
			av = Vector(_.x + aK * aD.x / ay, _.y + aK * aD.y, _.z + aK * aD.z / ay)
			au = self:GenerateCastPos(A, av, _, a0, D * N, O)
			aJ = {
				x = aJ.x + au.x,
				y = aJ.y + au.y,
				z = aJ.z + au.z
			}
		end
		aJ = {
			x = aJ.x / a9,
			y = aJ.y / a9,
			z = aJ.z / a9
		}
		local aL, aM = at, 0
		for a2 = B.pathing.pathIndex, B.pathing.pathCount do
			local aN, aO = B:GetPath(a2)
			if aN then
				local aP = t((aL.x - aN.x) ^ 2 + (aL.z - aN.z) ^ 2)
				if a2 == B.pathing.pathIndex and a1 < aP / ay then
					aL = aL + (aN - aL) / aP * ay * a1
					aP = t((aL.x - aN.x) ^ 2 + (aL.z - aN.z) ^ 2)
				end
				local C = (aN - aL) / aP
				local I, J = self:CalculateInterceptionTime(A, aL, C, D)
				aO = aM + aP / ay
				if not J or not (aM < J) or not (J < aO - aM) or not J then
					J = nil
				end
				I = I and aM < I and I < aO - aM and I or nil
				local aQ = I and J and q(I, J) or I or J
				if aQ then
					N = a1 + aQ
					av = aL + C * ay * aQ
					local aR = a1 + D * aQ
					au = self:GenerateCastPos(A, av, aL, aN, aR, O)
					break
				end
			end
			aL = aN
			aM = aO
		end
		if a9 >= 2 and aJ then
			au = Vector((aJ.x + au.x) / 2, au.y, (aJ.z + au.z) / 2):Normalized()
		end
		aw = q(1, O * 2 / ay / N)
		if self:IsSlowed(B) then
			aw = q(1, aw * 1.25)
		end
		if not B.visible then
			aw = aw / 2
		end
		if as and self:MinionCollision(A, au, D, W, a1, O) or MapPosition:inWall(au) then
			aw = -1
		elseif self:GetDistanceSqr(au, A) > W * W then
			aw = 0
		end
		return au, av, aw, N
	end
end

function PremiumPrediction:GetLinearAOEPrediction(A, B, D, W, a1, O, ar, as)
	local au, av, aw, N = self:GetPrediction(A, B, D, W, a1, O, ar, as)
	local A = Vector(A.pos)
	local aS = 2 * O * 2 * O
	local aT = au
	local aU, aV = au.x, au.z
	do
		local az, aB = aU - A.x, aV - A.z
		local aC = t(az * aB + aB * aB)
		aU = aU + az / aC * W
		aV = aV + aB / aC * W
	end
	for a2, aW in pairs(self:GetEnemyHeroes()) do
		if self:ValidTarget(aW) and aW ~= B then
			local aX, aY, aZ = self:GetPrediction(A, aW, D, W, a1, O, ar, as)
			local G = (aX.x - A.x) * (aU - A.x) + (aX.z - A.z) * (aV - A.z)
			if W > self:GetDistance(aX, A) then
				local aQ = G / (W * W)
				if aQ > 0 and aQ < 1 then
					local a_ = Vector(A.x + aQ * (aU - A.x), 0, A.z + aQ * (aV - A.z))
					local b0 = (aX.x - a_.x) * (aX.x - a_.x) + (aX.z - a_.z) * (aX.z - a_.z)
					if aS > b0 then
						aT = Vector(0.5 * (aT.x + aX.x), aT.y, 0.5 * (aT.z + aX.z))
						aS = aS - 0.5 * b0
					end
				end
			end
		end
	end
	au = aT
	return au, aw
end

function PremiumPrediction:GetCircularAOEPrediction(A, B, D, W, a1, O, ar, as)
	local au, av, aw, N = self:GetPrediction(A, B, D, W, a1, O, ar, as)
	local A = Vector(A.pos)
	local aS = 2 * O * 2 * O
	local aT = au
	local aU, aV = au.x, au.z
	for a2, aW in pairs(self:GetEnemyHeroes()) do
		if self:ValidTarget(aW) and aW ~= B then
			local aX, aY, aZ = self:GetPrediction(A, aW, D, W, a1, O, ar, as)
			local b1 = (aX.x - aU) * (aX.x - aU) + (aX.z - aV) * (aX.z - aV)
			if aS > b1 then
				aT = Vector(0.5 * (aT.x + aX.x), aT.y, 0.5 * (aT.z + aX.z))
				aS = aS - 0.5 * b1
			end
		end
	end
	au = aT
	return au, aw
end

function PremiumPrediction:GetConicAOEPrediction(A, B, D, W, a1, O, ar, as)
	if ar and ar > 0 then
		local au, av, aw, N = self:GetPrediction(A, B, D, W, a1, O, ar, as)
		local A = Vector(A.pos)
		local aS = 2 * ar
		local aT = au
		local aU, aV = au.x, au.z
		local az, aB = aU - A.x, aV - A.z
		do
			local aC = t(az * aB + aB * aB)
			aU = aU + az / aC * W
			aV = aV + aB / aC * W
		end
		for a2, aW in pairs(self:GetEnemyHeroes()) do
			if self:ValidTarget(aW) and aW ~= B then
				local aX, aY, aZ = self:GetPrediction(A, aW, D, W, a1, O, ar, as)
				local b2 = self:GetDistance(aX, A)
				if W > b2 then
					local b3 = self:GetDistance(aT, A)
					local b4 = (aT.x - A.x) * (aX.x - A.x) + (aT.z - A.z) * (aX.z - A.z)
					local b5 = m(j(b4 / (b2 * b3)))
					if aS > b5 then
						aT = Vector(0.5 * (aT.x + aX.x), aT.y, 0.5 * (aT.z + aX.z))
						aS = b5
					end
				end
			end
		end
		au = aT
		return au, aw
	end
end

function PremiumPrediction:GetHealthPrediction(a3, b6, N)
	local b7 = a3.health
	for a2 = 1, #b6 do
		local b8 = b6[a2]
		if b8.attackData.target == a3.handle then
			local b9 = b8.totalDamage * (1 + b8.bonusDamagePercent) - a3.flatDamageReduction
			local ba
			if b8.attackData.projectileSpeed and b8.attackData.projectileSpeed > 0 then
				ba = self:GetDistance(b8.pos, a3.pos) / b8.attackData.projectileSpeed
			else
				ba = 0
			end
			local bb = b8.attackData.endTime - b8.attackData.animationTime + ba + b8.attackData.windUpTime
			if bb <= b() then
				bb = bb + b8.attackData.animationTime + ba
			end
			while N > bb - b() do
				b7 = b7 - b9
				bb = bb + b8.attackData.animationTime + ba
			end
		end
	end
	return b7
end
