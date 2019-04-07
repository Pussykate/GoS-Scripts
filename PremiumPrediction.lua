--[[
	   ___                _            ___             ___     __  _         
	  / _ \_______ __ _  (_)_ ____ _  / _ \_______ ___/ (_)___/ /_(_)__  ___ 
	 / ___/ __/ -_)  ' \/ / // /  ' \/ ___/ __/ -_) _  / / __/ __/ / _ \/ _ \
	/_/  /_/  \__/_/_/_/_/\_,_/_/_/_/_/  /_/  \__/\_,_/_/\__/\__/_/\___/_//_/
                                                             Powered by GoS!

	-> Generic API

	* GetPrediction(source, unit, speed, range, delay, radius, angle, collision)
	> returns: CastPos, PredPos, HitChance, TimeToHit

	* GetDashPrediction(source, unit, speed, delay, radius)
	> returns: CastPos, TimeToHit

	* GetHitChance(source, unit, predPos, timeToHit, speed, range, delay, radius, angle, collision)
	> returns: HitChance

	* PredictTargetPosition(source, minion, speed, delay, radius)
	> returns: CastPos, PredPos, TimeToHit

	-> Hitchances

	-1             Minion or hero collision
	0              Unit is out of range
	0.1 - 0.24     Low accuracy
	0.25 - 0.49    Medium accuracy
	0.50 - 0.74    High accuracy
	0.75 - 0.99    Very high accuracy
	1              Unit is immobile or dashing

--]]

local a = "2.0"
require("MapPositionGOS")
local b, c, d, e, f, g = Game.Latency, Game.Timer, Game.HeroCount, Game.Hero, Game.MinionCount, Game.Minion
local h, i, j, k, l, m, n, o, p, q, r, s, t, u, v = math.abs, math.atan, math.atan2, math.acos, math.ceil, math.cos, math.deg, math.floor, math.huge, math.max, math.min, math.pi, math.rad, math.sin, math.sqrt
local w, x = table.insert, table.remove
local y = "https://raw.githubusercontent.com/Ark223/GoS-Scripts/master/PremiumPrediction.version"
local z = "https://raw.githubusercontent.com/Ark223/GoS-Scripts/master/PremiumPrediction.lua"

local A, B, C = {
	5,
	8,
	11,
	18,
	21,
	22,
	24,
	28,
	29
}, {}, {}

function DownloadFile(D, E)
	DownloadFileAsync(D, E, function() end)
	while not FileExist(E) do end
end

function ReadFile(E)
	local F = io.open(E, "r")
	local G = F:read()
	F:close()
	return G
end

function AutoUpdate()
	DownloadFile(y, COMMON_PATH .. "PremiumPrediction.version", function()
	end)
	if tonumber(ReadFile(COMMON_PATH .. "PremiumPrediction.version")) > tonumber(a) then
		print("PremiumPrediction: Downloading update...")
		DownloadFile(z, COMMON_PATH .. "PremiumPrediction.lua", function()
		end)
		print("PremiumPrediction: Successfully updated. 2xF6!")
	end
end

--[[
	┬  ┌─┐┌─┐┌┬┐
	│  │ │├─┤ ││
	┴─┘└─┘┴ ┴─┴┘
--]]

class("PremiumPrediction")

function PremiumPrediction:__init()
	self.Debug, self.Loaded = false, false
	for H = 1, d() do
		local I = e(H)
		if I and I.team ~= myHero.team then
			w(C, I)
		end
	end
	self.Loaded = true
	if self.Loaded then
		Callback.Add("Tick", function()
			self:Tick()
		end)
		if self.Debug then
			Callback.Add("Draw", function()
				self:Draw()
			end)
		end
	end
end

--[[
	┌─┐┌─┐┌─┐┌┬┐┌─┐┌┬┐┬─┐┬ ┬
	│ ┬├┤ │ ││││├┤  │ ├┬┘└┬┘
	└─┘└─┘└─┘┴ ┴└─┘ ┴ ┴└─ ┴ 
--]]

function PremiumPrediction:AngleBetween(J, K, L)
	local J, K = J, K
	if L then
		J, K = Vector(-L + J), Vector(-L + K)
	end
	local M = self:Polar(J) - self:Polar(K)
	if M < 0 then
		M = M + 360
	end
	if M > 180 then
		M = 360 - M
	end
	return M
end

function PremiumPrediction:CalculateInterceptionTime(N, I, O, P, Q)
	local R = {
		x = O.x - I.x,
		z = O.z - I.z
	}
	local S = v(R.x * R.x + R.z * R.z)
	R = {
		x = R.x / S * Q,
		z = R.z / S * Q
	}
	local T = R.x * R.x + R.z * R.z - P * P
	local U = 2 * (I.x * R.x + I.z * R.z - N.x * R.x - N.z * R.z)
	local V = I.x * I.x + I.z * I.z + N.x * N.x + N.z * N.z - 2 * N.x * I.x - 2 * N.z * I.z
	local W = U * U - 4 * T * V
	if W >= 0 then
		local X = (-U + v(W)) / (2 * T)
		local Y = (-U - v(W)) / (2 * T)
		return q(X, Y)
	end
	return 0
end

function PremiumPrediction:Center(J, K)
	return Vector((J + K) / 2)
end

function PremiumPrediction:CircleCircleIntersection(Z, _, a0, a1)
	local a2 = self:GetDistance(Z, _)
	local T = (a0 * a0 - a1 * a1 + a2 * a2) / (2 * a2)
	local a3 = v(a0 * a0 - T * T)
	local R = Vector(_ - Z):Normalized()
	local a4 = Vector(Z) + T * R
	local a5, a6 = a4 + a3 * R:Perpendicular(), a4 - a3 * R:Perpendicular()
	return a5, a6
end


function PremiumPrediction:CutWaypoints(waypoints, distance)
	local remaining, result = distance, {}
	if distance < 0 then
		waypoints[1] = waypoints[1] + distance * Vector(waypoints[2] - waypoints[1]):Normalized()
		return waypoints
	end
	for i = 1, #waypoints - 1 do
		local dist = self:GetDistance(waypoints[i], waypoints[i + 1])
		if dist > remaining then
			TableInsert(result, waypoints[i] + remaining * (waypoints[i + 1] - waypoints[i]):Normalized())
			for j = i + 1, #waypoints do TableInsert(result, waypoints[j]) end; break
		end
		remaining = remaining - dist
	end
	return (#result > 0 and result or {waypoints[#waypoints]})
end

function PremiumPrediction:CutWaypoints(a7, a8)
	local a9, G = a8, {}
	if a8 < 0 then
		a7[1] = a7[1] + a8 * Vector(a7[2] - a7[1]):Normalized()
		return a7
	end
	for H = 1, #a7 - 1 do
		local aa = self:GetDistance(a7[H], a7[H + 1])
		if a9 < aa then
			w(G, a7[H] + a9 * (a7[H + 1] - a7[H]):Normalized())
			for ab = H + 1, #a7 do
				w(G, a7[ab])
			end
			break
		end
		a9 = a9 - aa
	end
	return (#G > 0 and G or {a7[#a7]})
end

function PremiumPrediction:IsClose(T, U, ac)
	local ac = ac or 1.0E-9
	return ac >= h(T - U)
end

function PremiumPrediction:GenerateCastPos(N, ad, ae, af, ag, ah)
	local ai = (j(af.z - ae.z, af.x - ae.x) - j(N.z - ad.z, N.x - ad.x)) % (2 * s)
	local aj = 1 - h(ai % s - s / 2) / (s / 2)
	local ak = ai < s and i(ah / 2 / ag) or -i(ah / 2 / ag)
	local al, am, an = ad.x - N.x, ad.z - N.z, ak * aj
	return Vector(m(an) * al - u(an) * am + N.x, ad.y, u(an) * al + m(an) * am + N.z)
end

function PremiumPrediction:GetDistance(J, K)
	return v(self:GetDistanceSqr(J, K))
end

function PremiumPrediction:GetDistanceSqr(J, K)
	local K = K and K or myHero.pos
	local al = J.x - K.x
	local am = (J.z and J.z or J.y) - (K.z and K.z or K.y)
	return al * al + am * am
end

function PremiumPrediction:GetLength(J, K)
	local K = K and K or J
	return v(J.x * K.x + (J.y and J.y * K.y or 0) + (J.z and J.z * K.z or 0))
end

function PremiumPrediction:GetPathLength(a7)
	local a8 = 0
	for H = 1, #a7 - 1 do
		a8 = a8 + self:GetDistance(a7[H], a7[H + 1])
	end
	return a8
end

function PremiumPrediction:GetWaypointChangeCount(I)
	local ao = I.networkID
	if B[ao] then
		local ap = B[ao].pathChanges
		if ap then
			return #ap
		end
	end
	return 0
end

function PremiumPrediction:GetWaypoints(I)
	local a7 = {}
	if I.visible then
		w(a7, I.pos)
		if self:IsDashing(I) then
			w(a7, I.posTo)
		else
			for H = I.pathing.pathIndex, I.pathing.pathCount do
				w(a7, Vector(I:GetPath(H).x, I:GetPath(H).y, I:GetPath(H).z))
			end
		end
	end
	return a7
end

function PremiumPrediction:IsMinionCollision(N, aq, P, ar, as, ah)
	local at = self:IsVector(N) and N or N.pos
	for H = 1, f() do
		local au = g(H)
		if au and au.isEnemy and not au.dead then
			local ad, av = self:GetFastPrediction(N, au, P, as)
			if ad and self:GetDistanceSqr(at, ad) <= (ar + ah) * (ar + ah) then
				local aw, ax, ay = self:VectorPointProjectionOnLineSegment(at, aq, ad)
				if ay and self:GetDistanceSqr(aw, ad) <= (ah + au.boundingRadius * 1.5) ^ 2 or self:GetDistance(aq, ad) < au.boundingRadius or self:GetDistance(at, ad) < au.boundingRadius then
					return true
				end
			end
		end
	end
	return false
end

function PremiumPrediction:IsVector(az)
	return az and az.x and type(az.x) == "number" and (az.y and type(az.y) == "number" or az.z and type(az.z) == "number")
end

function PremiumPrediction:Polar(aA)
	if self:IsClose(aA.x, 0) then
		if 0 < (aA.z or aA.y) then
			return 90
		elseif 0 > (aA.z or aA.y) then
			return 270
		else
			return 0
		end
	else
		local M = n(i((aA.z or aA.y) / aA.x))
		if aA.x < 0 then
			M = M + 180
		end
		if M < 0 then
			M = M + 360
		end
		return M
	end
end

function PremiumPrediction:VectorPointProjectionOnLineSegment(aB, aC, aD)
	local aE, aF, aG, aH, aI, aJ = aC.z or aD.x, aD.z or aD.y, aB.x, aB.z or aB.y, aC.x, aC.y
	local aK = ((aE - aG) * (aI - aG) + (aF - aH) * (aJ - aH)) / ((aI - aG) ^ 2 + (aJ - aH) ^ 2)
	local ax = {
		x = aG + aK * (aI - aG),
		y = aH + aK * (aJ - aH)
	}
	local aL = aK < 0 and 0 or aK > 1 and 1 or aK
	local ay = aL == aK
	local aw = ay and ax or {
		x = aG + aL * (aI - aG),
		y = aH + aL * (aJ - aH)
	}
	return aw, ax, ay
end

--[[
	┌┬┐┌─┐┌┐┌┌─┐┌─┐┌─┐┬─┐
	│││├─┤│││├─┤│ ┬├┤ ├┬┘
	┴ ┴┴ ┴┘└┘┴ ┴└─┘└─┘┴└─
--]]

function PremiumPrediction:GetImmobileDuration(I)
	if I.activeSpell.isChanneling or I.activeSpell.isAutoAttack then
		return I.activeSpell.castEndTime - c()
	end
	for H = 0, I.buffCount do
		local aM = I:GetBuff(H)
		for H = 1, #A do
			if aM and aM.type == A[H] and 0 < aM.duration then
				return aM.duration
			end
		end
	end
	return 0
end

function PremiumPrediction:IsDashing(I)
	return I.pathing.isDashing
end

function PremiumPrediction:IsMoving(I)
	return I.pathing.hasMovePath
end

function PremiumPrediction:IsSlowed(I)
	for H = 0, I.buffCount do
		local aM = I:GetBuff(H)
		if aM and aM.type == 10 and 0 < aM.duration then
			return true
		end
	end
	return false
end

function PremiumPrediction:ValidTarget(aN, ar)
	local ar = ar or p
	return aN ~= nil and aN.valid and aN.visible and not aN.dead and ar >= aN.distance
end

--[[
	┌─┐┬─┐┌─┐┌┬┐┬┌─┐┌┬┐┬┌─┐┌┐┌
	├─┘├┬┘├┤  ││││   │ ││ ││││
	┴  ┴└─└─┘─┴┘┴└─┘ ┴ ┴└─┘┘└┘
--]]

local aO = {
	speed = 1600,
	range = 900,
	delay = 0.25,
	radius = 70,
	angle = nil,
	collision = true
}
function PremiumPrediction:Draw()
	for H = 1, #C do
		local aN = C[H]
		if self:ValidTarget(aN, 3000) then
			local aP, aQ, aR, aS = self:GetPrediction(myHero, aN, aO.speed, aO.range, aO.delay, aO.radius, aO.angle, aO.collision)
			if aP and aQ then
				Draw.Line(Vector(aQ):To2D(), Vector(myHero.pos):To2D(), 1, Draw.Color(128, 255, 255, 255))
				Draw.Circle(aQ, 70, 1, Draw.Color(128, 255, 255, 255))
				Draw.Line(Vector(aP):To2D(), Vector(myHero.pos):To2D(), 1, Draw.Color(128, 255, 255, 192))
				Draw.Circle(aP, 70, 1, Draw.Color(128, 255, 255, 192))
				print(aR)
			end
		end
	end
end

function PremiumPrediction:Tick()
	for H = 1, #C do
		local I = C[H]
		local ao = I.networkID
		if not B[ao] then
			B[ao] = {
				isVisible = I.visible,
				visionTimer = 0,
				pathPositions = {},
				pathTimers = {},
				predictedPaths = {}
			}
		else
			if B[ao].isVisible ~= I.visible then
				if not I.visible then
					self:OnLoseVision(I)
					B[ao].visionTimer = c()
				else
					self:OnGainVision(I)
					B[ao].visionTimer = 0
				end
				B[ao].isVisible = I.visible
			end
			if self:IsMoving(I) then
				local aT = B[ao].pathPositions
				if #aT > 0 and aT[#aT].endPos ~= I.pathing.endPos or #aT == 0 then
					self:OnProcessWaypoint(I, I.pos, I.posTo)
					w(aT, {
						startPos = I.pos,
						endPos = I.posTo
					})
					w(B[ao].pathTimers, c())
				end
			end
		end
		local aU = B[ao].pathTimers
		for H = #aU, 1, -1 do
			local aV = aU[H]
			if aV and aV + 1 < c() then
				x(aU, H)
				x(B[ao].pathPositions, H)
			end
		end
	end
end

function PremiumPrediction:OnGainVision(I)
	return
end

function PremiumPrediction:OnLoseVision(I)
	return
end

function PremiumPrediction:OnProcessWaypoint(I, aW, aX)
	return
end

function PremiumPrediction:GetHitChance(N, I, ad, av, P, ar, as, ah, an, aY)
	local at = self:IsVector(N) and N or N.pos
	local Q = self:IsDashing(I) and I.pathing.dashSpeed or I.ms
	local aZ, a_, aV = 0, av * Q, self:GetImmobileDuration(I)
	if an and an > 0 then
		ah = v(2 * a_ * a_ - 2 * a_ * a_ * m(an))
	end
	aZ = r(1, ah * 2 / Q / q(0.01, av - aV))
	if self:IsSlowed(I) then
		aZ = r(1, aZ * 1.5)
	end
	local b0 = self:GetWaypointChangeCount(I)
	if aZ ~= 1 then
		aZ = q(0, aZ - b0 / 30)
	end
	if not I.visible then
		aZ = aZ / 2
	end
	if aY and self:IsMinionCollision(N, ad, P, ar, as, ah) or MapPosition:inWall(ad) then
		aZ = -1
	elseif self:GetDistanceSqr(at, ad) > ar * ar then
		aZ = 0
	end
	return aZ
end

function PremiumPrediction:GetPrediction(N, I, P, ar, as, ah, an, aY)
	if not self:IsMoving(I) then
		local at, b1 = self:IsVector(N) and N or N.pos, I.pos
		local ag = self:GetDistance(at, b1) / P + as
		return I.pos, I.pos, self:GetHitChance(N, I, I.pos, ag, P, ar, as, ah, an, aY), ag
	elseif self:IsDashing(I) and self:GetPathLength(self:GetWaypoints(I)) > 200 then
		local aP, aS = self:GetDashPrediction(N, I, P, as, ah)
		local b2 = aP and aY and self:IsMinionCollision(N, aP, P, ar, as, ah)
		return aP and b2 == false and aP, aP, 1, aS or self:GetPrediction(N, I, P, ar, as, ah, an, aY)
	end
	local aP, aQ, aS = self:PredictTargetPosition(N, I, P, as, ah)
	return aP, aQ, self:GetHitChance(N, I, aP, aS, P, ar, as, ah, an, aY), aS
end

function PremiumPrediction:GetDashPrediction(N, I, P, as, ah)
	if not self:IsDashing(I) then
		return nil, 0
	end
	local at, b1, Q = self:IsVector(N) and N or N.pos, I.pos, I.pathing.dashSpeed
	local ah, a7 = ah or 1, self:GetWaypoints(I)
	local b3, b4 = nil, self:GetDistance(at, a7[2]) / P + as
	local b5 = self:GetDistance(b1, a7[2]) / Q + ah / I.ms
	if b5 >= b4 - 0.25 then
		b3 = a7[2]
	end
	return b3, b4
end

function PremiumPrediction:GetFastPrediction(N, I, P, as)
	local at, b1 = self:IsVector(N) and N or N.pos, I.pos
	local b6 = self:IsMoving(I) and I:GetPrediction(P, as) or b1
	local b4 = self:GetDistance(at, b6) / P + as
	return b6, b4
end

function PremiumPrediction:PredictTargetPosition(N, I, P, as, ah)
	local at, b1, Q = self:IsVector(N) and N or N.pos, I.pos, I.ms
	if self:GetDistanceSqr(at, b1) < 62500 then
		Q = Q / 1.5
	end
	local ah, a7 = ah or 1, self:GetWaypoints(I)
	local b6, b3, b4 = b1, b1, as
	if P == p then
		local b7 = b4 * Q
		local b8 = b7 - ah
		b6, b3 = self:CutWaypoints(a7, b7)[1], self:CutWaypoints(a7, q(1, b8))[1]
	else
		local b9, ba = b1, a7[#a7]
		local ag = as + self:CalculateInterceptionTime(at, b9, ba, P, Q)
		local aa = ag * Q
		b6 = self:CutWaypoints(a7, q(1, aa))[1]
		local bb = self:CutWaypoints(a7, q(1, aa - ah / 2))[1]
		b3 = self:GenerateCastPos(at, bb, b9, ba, P * b4, ah)
		b4 = self:GetDistance(at, b3) / P + as
	end
	return b3, b6, b4
end

PremiumPrediction()
