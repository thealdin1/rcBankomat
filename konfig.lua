Config = {}
Translation = {}

Config.Locale = 'en'
Config.CopsRequiredToSell = 0

Config.InteractionKey = 47
Config.AbortKey = 73

Config.useBlips = false 
Config.showMarker = false 
Config.showInfobar = true 

Config.useSound = true 

Config.RequireCrowbarWeapon = true
Config.LockpickItem = 'lockpick'


Config.Atms   = {
    {x = 146.06, y = -1034.82, z = 29.34, timeout = 10, money = {min = 3600, max = 9000}},
    {x = -303.48263549805, y = -831.02526855469, z = 32.08687210083, timeout = 10, money = {min = 4000, max = 8000}},
    {x = -56.362201690674, y = -1752.3922119141, z = 29.421005249023, timeout = 10, money = {min = 2600, max = 4000}},
    {x = -821.26617431641, y = -1082.509765625, z = 11.132418632507, timeout = 10, money = {min = 3200, max = 7000}},
    {x = -2073.240234375, y = -317.16448974609, z = 13.315970420837, timeout = 10, money = {min = 3600, max = 69000}},
    {x = 1172.6140136719, y = 2701.9362792969, z = 38.174629211426, timeout = 10, money = {min = 3800, max = 8200}},
    {x = -1091.0859375, y = 2708.2854003906, z = 18.970090866089, timeout = 10, money = {min = 3900, max = 7800}},
    {x = 2559.6220703125, y = 351.03356933594, z = 108.6215133667, timeout = 10, money = {min = 4100, max = 7000}},
}

Config.AlarmTime = 15 
Config.Step3Time = 15 

Config.IntervalCount = 6
Config.IntervalTime = 20.0 

Translation = {

    ['en'] = {
        ['blip_text'] = 'Rob ATM',
        ['infobar_start'] = 'Pritisni ~r~G~s~, da opljackas bankomat',
        ['recently_robbed'] = '~r~Ovaj bankomat je nedavno opljackan!',
        ['step_1'] = 'Pocinjete da razbijate kuciste bankomata',
        ['step_2'] = 'Sada uklonite kablove sa alarmnog sistema',
        ['step_3'] = 'The alarm system is deactivated! Now just clamp off the ink cassette',
        ['step_4'] = 'The cash box is cracked. You start taking money from the ATM',
        ['got_money'] = '~y~Uzet novac: ~g~',
        ['got_money2'] = '$~s~ The ATM is ~r~empty~s~. Now RUN!',
        ['got_money3'] = '$~s~ Ostani ovde da uzmes jos novca...',
        ['rob_aborted'] = 'Pljacka je  ~r~prekinuta~s~! Ti si dobio ~g~',
        ['rob_aborted2'] = '$',
        ['rob_aborted_nothing'] = 'The robbery was aborted without ~r~loot~s~...',
        ['cop_notify'] = '~r~Alarm ~s~at bankomata je ~y~',
        ['cop_notify2'] = '~s~. GPS je poslat!',
        ['cop_atm'] = 'Bezbednost bankomat',
        ['cop_heading'] = 'Tihi alarm',
        ['rob_aborted_chat'] = 'Pljacka je ~r~prekinuta~s~!',
        ['rob_abort_title'] = 'Pljacka prekinuta',
        ['not_enough_cops'] = 'Nema dovoljno ~d~Policajaca ~s~na duznosti!',
        ['timeout'] = '~r~Ovaj bankomat je nedavno opljackan!',
        ['no_lockpick'] = '~r~You do not have a lockpick!',
    }

}