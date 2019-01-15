--
--  ██████╗  █████╗ ██████╗ ███████╗██████╗ ███████╗██╗     ██╗     ███████╗
-- ██╔════╝ ██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔════╝██║     ██║     ██╔════╝
-- ██║  ███╗███████║██████╔╝███████╗██████╔╝█████╗  ██║     ██║     ███████╗
-- ██║   ██║██╔══██║██╔═══╝ ╚════██║██╔═══╝ ██╔══╝  ██║     ██║     ╚════██║
-- ╚██████╔╝██║  ██║██║     ███████║██║     ███████╗███████╗███████╗███████║
--  ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝     ╚══════╝╚══════╝╚══════╝╚══════╝
--
-- ██████╗  █████╗ ████████╗ █████╗ ██████╗  █████╗ ███████╗███████╗        
-- ██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔════╝        
-- ██║  ██║███████║   ██║   ███████║██████╔╝███████║███████╗█████╗          
-- ██║  ██║██╔══██║   ██║   ██╔══██║██╔══██╗██╔══██║╚════██║██╔══╝          
-- ██████╔╝██║  ██║   ██║   ██║  ██║██████╔╝██║  ██║███████║███████╗        
-- ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝        
--
-- ===============
-- == Changelog ==
-- ===============
-- [01-06] Initial release for patch 8.11

GapcloseSpells = {
	["AatroxQ"]={charName="Aatrox",slot=_Q,type="skillshot",danger=2},
	["AhriTumble"]={charName="Ahri",slot=_R,type="skillshot",danger=2},
	["AkaliShadowDance"]{charName="Akali",slot=_R,type="targeted",danger=2},
	["Headbutt"]={charName="Alistar",slot=_W,type="targeted",danger=2},
	["BandageToss"]={charName="Amumu",slot=_Q,type="skillshot",danger=2},
	["AzirE"]={charName="Azir",slot=_E,type="skillshot",danger=1},
	["BraumW"]={charName="Braum",slot=_W,type="targeted",danger=1},
	["CaitlynEntrapmentMissile"]={charName="Caitlyn",slot=_E,type="skillshot",danger=2},
	["CamilleE"]={charName="Caitlyn",slot=_E,type="skillshot",danger=2},
	["CarpetBomb"]={charName="Corki",slot=_W,type="skillshot",danger=1},
	["CarpetBombMega"]={charName="Corki",slot=_W,type="skillshot",danger=1},
	["DianaTeleport"]={charName="Diana",slot=_R,type="targeted",danger=2},
	["EkkoE"]={charName="Ekko",slot=_E,type="skillshot",danger=1},
	["EkkoEAttack"]={charName="Ekko",slot=_E,type="targeted",danger=1},
	["EliseSpiderQCast"]={charName="Elise",slot=_Q,type="targeted",danger=2},
	["EzrealArcaneShift"]={charName="Ezreal",slot=_E,type="skillshot",danger=1},
	["Crowstorm"]={charName="Fiddlesticks",slot=_R,type="skillshot",danger=3},
	["FioraQ"]={charName="Fiora",slot=_Q,type="skillshot",danger=1},
	["FizzQ"]={charName="Fizz",slot=_Q,type="targeted",danger=1},
	["FizzE"]={charName="Fizz",slot=_E,type="skillshot",danger=2},
	["GalioE"]={charName="Galio",slot=_E,type="skillshot",danger=2},
	["GnarE"]={charName="Gnar",slot=_E,type="skillshot",danger=1},
	["GnarBigE"]={charName="Gnar",slot=_E,type="skillshot",danger=2},
	["GragasE"]={charName="Gragas",slot=_E,type="skillshot",danger=2},
	["GravesMove"]={charName="Graves",slot=_E,type="skillshot",danger=1},
	["HecarimUlt"]={charName="Hecarim",slot=_R,type="skillshot",danger=3},
	["IreliaQ"]={charName="Irelia",slot=_Q,type="targeted",danger=2},
	["IvernQ"]={charName="Ivern",slot=_Q,type="skillshot",danger=2},
	["JarvanIVDragonStrike"]={charName="Jarvan",slot=_Q,type="skillshot",danger=2},
	["JaxLeapStrike"]={charName="Jax",slot=_Q,type="targeted",danger=1},
	["JayceToTheSkies"]={charName="Jayce",slot=_Q,type="targeted",danger=2},
	["KaisaE"]={charName="Kaisa",slot=_E,type="skillshot",danger=1},
	["Riftwalk"]={charName="Kassadin",slot=_R,type="skillshot",danger=2},
	["KatarinaE"]={charName="KatarinaE",slot=_E,type="skillshot",danger=1},
	["KaynQ"]={charName="KaynQ",slot=_Q,type="skillshot",danger=1},
	["KhazixE"]={charName="Khazix",slot=_E,type="skillshot",danger=1},
	["KhazixELong"]={charName="Khazix",slot=_E,type="skillshot",danger=2},
	["KindredQ"]={charName="Kindred",slot=_Q,type="skillshot",danger=1},
	["KledQ"]={charName="Kled",slot=_Q,type="skillshot",danger=2},
	["KledQRider"]={charName="Kled",slot=_Q,type="skillshot",danger=1},
	["KledEDash"]={charName="Kled",slot=_E,type="skillshot",danger=1},
	["LeblancW"]={charName="Leblanc",slot=_W,type="skillshot",danger=1},
	["LeblancRW"]={charName="Leblanc",slot=_W,type="skillshot",danger=1},
	["BlindMonkQTwo"]={charName="LeeSin",slot=_Q,type="skillshot",danger=1},
	["LeonaE"]={charName="Leona",slot=_E,type="skillshot",danger=2},
	["LissandraE"]={charName="Lissandra",slot=_E,type="skillshot",danger=2},
	["LucianE"]={charName="Lucian",slot=_E,type="skillshot",danger=1},
	["UFSlash"]={charName="Malphite",slot=_R,type="skillshot",danger=3},
	["MaokaiW"]={charName="Maokai",slot=_W,type="targeted",danger=2},
	["AlphaStrike"]={charName="MasterYi",slot=_Q,type="targeted",danger=2},
	["NautilusAnchorDrag"]={charName="Nautilus",slot=_Q,type="skillshot",danger=2},
	["Pounce"]={charName="Nidalee",slot=_W,type="skillshot",danger=2},
	["NocturneParanoia"]={charName="Nocturne",slot=_R,type="targeted",danger=2},
	["OrnnE"]={charName="Ornn",slot=_E,type="skillshot",danger=2},
	["PantheonW"]={charName="Pantheon",slot=_W,type="targeted",danger=2},
	["PoppyE"]={charName="Poppy",slot=_E,type="targeted",danger=2},
	["PykeQRange"]={charName="Pyke",slot=_Q,type="skillshot",danger=2},
	["PykeE"]={charName="Pyke",slot=_E,type="skillshot",danger=1},
	["QuinnE"]={charName="Quinn",slot=_E,type="targeted",danger=2},
	["RakanW"]={charName="Rakan",slot=_W,type="skillshot",danger=2},
	["RekSaiEBurrowed"]={charName="RekSai",slot=_E,type="skillshot",danger=2},
	["RenektonSliceAndDice"]={charName="Renekton",slot=_E,type="skillshot",danger=2},
	["RivenTriCleave"]={charName="Riven",slot=_Q,type="skillshot",danger=2},
	["RivenFeint"]={charName="Riven",slot=_E,type="skillshot",danger=1},
	["SejuaniQ"]={charName="Sejuani",slot=_Q,type="skillshot",danger=2},
	["Deceive"]={charName="Shaco",slot=_Q,type="skillshot",danger=1},
	["ShenE"]={charName="Shen",slot=_E,type="skillshot",danger=2},
	["ShyvanaTransformLeap"]={charName="Shyvana",slot=_R,type="skillshot",danger=3},
	["TaliyahR"]={charName="Taliyah",slot=_R,type="skillshot",danger=3},
	["TalonQDashAttack"]={charName="Talon",slot=_Q,type="targeted",danger=2},
	["TalonE2"]={charName="Talon",slot=_E,type="targeted",danger=1},
	["ThreshQ"]={charName="Thresh",slot=_Q,type="skillshot",danger=2},
	["RocketJump"]={charName="Tristana",slot=_W,type="skillshot",danger=2},
	["TryndamereE"]={charName="Tryndamere",slot=_E,type="skillshot",danger=2},
	["UrgotE"]={charName="Urgot",slot=_E,type="skillshot",danger=2},
	["VayneTumble"]={charName="Vayne",slot=_Q,type="skillshot",danger=1},
	["ViQ"]={charName="Vi",slot=_Q,type="skillshot",danger=2},
	["WarwickR"]={charName="Warwick",slot=_R,type="skillshot",danger=3},
	["MonkeyKingNimbus"]={charName="MonkeyKing",slot=_E,type="skillshot",danger=2},
	["XinZhaoE"]={charName="XinZhao",slot=_E,type="targeted",danger=2},
	["YasuoDashWrapper"]={charName="Yasuo",slot=_E,type="targeted",danger=2},
	["ZacE"]={charName="Zac",slot=_E,type="skillshot",danger=2},
	["ZedW2"]={charName="Zed",slot=_W,type="skillshot",danger=2},
	["ZedR"]={charName="Zed",slot=_R,type="targeted",danger=2},
	["ZiggsW"]={charName="Ziggs",slot=_W,type="skillshot",danger=2},
	["ZoeR"]={charName="Zoe",slot=_R,type="skillshot",danger=2},
}
