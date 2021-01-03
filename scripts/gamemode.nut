/* 
Shotgun-DM is Deatmatch Gamemode only with shotgun/stubby pistols submachines.
Teams starts around downtown.
*/

local version = "1.0"

playerData <- array( GetMaxPlayers(), null);



function onScriptLoad() {
    print("Shotgun-DM Gamemode started version: " + version)
    SetServerName("Shotgun Deathmatch!");
    SetGameModeName("Shotgun-DM v1.0");
    // Server Settings
    SetTaxiBoostJump( true );
    SetDrivebyEnabled( false );
    SetFriendlyFire( false );
    SetDeathMessages( false );
    SetFrameLimiter( false );
    // Databases
    accountDb <- ConnectSQL( "accounts.db" );
    QuerySQL(accountDb, "CREATE TABLE IF NOT EXISTS players(name TEXT, password TEXT, adminlevel INTEGER, kills INTEGER, deaths INTEGER, cash INTEGER, stubbykills, shotgunkills,PRIMARY KEY(name, password));");
    // Classes
    AddClass(0, RGB(60,60,60), 93, Vector(-597, 653, 11), 1.0, 0,0,0,0,0,0)
    AddClass(0, RGB(60,60,60), 94, Vector(-597, 653, 11), 1.0, 0,0,0,0,0,0)
    AddClass(1, RGB(0,102,204), 1, Vector(-657, 762, 11.6), 2.52, 0,0,0,0,0,0)
    AddClass(1, RGB(0,102,204), 101, Vector(-657, 762, 11.6), 2.52, 0,0,0,0,0,0)
    AddClass(2, RGB(255,0,0), 42, Vector(-570, 794, 22.8), 1.52, 0,0,0,0,0,0)
    AddClass(2, RGB(255,0,0), 52, Vector(-570, 794, 22.8), 1.52, 0,0,0,0,0,0)
    AddClass(3, RGB(255,102,102), 108, Vector(-875, 1159, 11.2), -1.52, 0,0,0,0,0,0)
    AddClass(4, RGB(0,0,255), 5, Vector(-786, 1146, 12.4), 0.16, 0,0,0,0,0,0)
    AddClass(5, RGB(239,129,19), 87, Vector(12, 1114, 16.6), 3.16, 0,0,0,0,0,0)
    AddClass(5, RGB(239,129,19), 88, Vector(12, 1114, 16.6), 3.16, 0,0,0,0,0,0)
    AddClass(6, RGB(232,14,159), 7, Vector(-1073, 1330, 13.9), -1.54, 0,0,0,0,0,0)

    // Spheres for teleportation
    CreatePickup(505,Vector(-410,1120,11.14))
    CreatePickup(505,Vector(-558,782,22.97))
    CreatePickup(505,Vector(-552, 788.3, 97.51))
    CreatePickup(505,Vector(-811, 1353.3, 66.41))
    CreatePickup(505,Vector(-831, 1312.3, 11.51))

    // No need for sql based vehicle system since playground is pretty small
    CreateVehicle(139, 0, Vector(-838, 1040, 15.7), 3.12, 1, 1)
    CreateVehicle(145, 0, Vector(-781, 995, 11.5), 1.58, 0, 6)
    CreateVehicle(205, 0, Vector(-781, 1007, 11.5), 1.58, 1, 1)
    CreateVehicle(191, 0, Vector(-919, 770, 11.08), -1.52, 6, 6)
    CreateVehicle(156, 0, Vector(-665, 774, 11.5), 0.06, 3, 1)
    CreateVehicle(156, 0, Vector(-665, 801, 11.04), 0.06, 3, 1)
    CreateVehicle(166, 0, Vector(-592, 655, 11.04), 1.51, 3, 1)
    CreateVehicle(193, 0, Vector(-586, 655, 11.04), 1.51, 1, 1)
    CreateVehicle(191, 0, Vector(-575, 640, 11.5), -1.49, 46, 46)
    CreateVehicle(137, 0, Vector(-692, 902, 11.5), -0.41, 1,3)
    CreateVehicle(212, 0, Vector(46, 1098, 16.6), -3.04, 0,0)
    CreateVehicle(199, 0, Vector(76, 1105, 32.6), -3.11, 57,0)
    CreateVehicle(146, 0, Vector(-773, 1137, 12.4), 0.02, 1,3)
    CreateVehicle(232, 0, Vector(-1130, 1241, 8.71), -2.07, 56,90)
    CreateVehicle(145, 0, Vector(-1060, 1415, 8.51), -0.73, 3,3)
    CreateVehicle(198, 0, Vector(-725, 1392, 11.71), -0.73, 35,35)
    CreateVehicle(141, 0, Vector(-308, 1346, 11.41), -0.73, 0,0)
    CreateVehicle(174, 0, Vector(-592, 796, 11.11), -3.11, 10,10)
    CreateVehicle(218, 0, Vector(-469, 1123, 64.71), -1.57, 1,1)
    CreateVehicle(218, 0, Vector(-851,1354,69.5), 1.56, 1,1)
}

function SpawnProtection(playerid) {
    local player = FindPlayer(playerid)
    if(player) {
        player.World = 1;
    }
}

function Ann(text, playerid, style) {
    local player = FindPlayer(playerid)
    if(player) {
        Announce(text, player, style)
    }
}

function onScriptUnload() {
    DisconnectSQL(accountDb)
}


function onPlayerSpawn( player ) {
    player.World = 2;
    Announce("~h~Spawn protection ends in ~g~3 ~h~seconds", player, 1);
    NewTimer( "Ann", 1000, 1, "~h~Spawn protection ends in ~g~2 ~h~seconds", player.ID, 1)
    NewTimer( "Ann", 2000, 1, "~h~Spawn protection ends in ~g~1 ~h~second", player.ID, 1)
    NewTimer( "Ann", 3000, 1, "", player.ID, 1)
    NewTimer( "SpawnProtection", 3000, 1, player.ID);
    MessagePlayer("[#0FE8F7]Info: you can change your weapon set using /weaponset", player)
    switch(playerData[player.ID].weaponset) {
        case 1:
        {
            player.SetWeapon( Weapons.STUBBY, 99999);
            player.SetWeapon( Weapons.COLT45, 99999);
            player.SetWeapon( Weapons.MP5, 99999);
            player.SetWeapon( Weapons.BRASS_KNUCKLES, 99999);
            break;
        }
        case 2: 
        {
            player.SetWeapon( Weapons.SHOTGUN, 99999);
            player.SetWeapon( Weapons.PYTHON, 99999);
            player.SetWeapon( Weapons.TEC9, 99999);
            player.SetWeapon( Weapons.GOLFCLUB, 99999);
            break;
        }
        case 3:
        {
            player.SetWeapon( Weapons.STUBBY, 99999);
            player.SetWeapon( Weapons.COLT45, 99999);
            player.SetWeapon( Weapons.INGRAM, 99999);
            player.SetWeapon( Weapons.BASEBALLBAT, 99999);
        }
    }
}

function onPlayerJoin( player ) {
    playerData[player.ID] = PlayerData();
    Message("[#0FE8F7]" + player.Name + " joined the server!");
    local q = QuerySQL( accountDb, "SELECT * FROM players WHERE name='"+player.Name+"'")
    if(q) {
        playerData[player.ID].registered = true;
        MessagePlayer("[#00FF00]This account is registered please use /login [password] to login.", player)
    }
    else {
        MessagePlayer("[#FF0000]This account is not registered please use /register [password] to register it.", player);
    }
}

function onPlayerPart( player, reason) {
    switch(reason) {
        case 0:
            Message("[#FF0000]" + player.Name + " [#00FF00]left the server reason: timeout");
            break;
        case 1:
            Message("[#FF0000]" + player.Name + " [#00FF00]left the server reason: disconnect");
            break;
        case 2:
            Message("[#FF0000]" + player.Name + " [#00FF00]left the server reason: kicked");
            break;
        case 3:
            Message("[#FF0000]" + player.Name + " [#00FF00]left the server reason: crash");
    }
    if(playerData[player.ID].logged) {
        QuerySQL( accountDb, "UPDATE players SET cash='"+player.Cash+"',kills='"+playerData[player.ID].Kills+"', deaths='"+playerData[player.ID].Deaths+"', stubbykills='"+playerData[player.ID].stubbyKills+"', shotgunKills='"+playerData[player.ID].shotgunKills+"' WHERE name='"+player.Name+"'");
    }
    playerData[player.ID] = null;
}

function onPlayerChat(player, msg) {
    if(playerData[player.ID].registered && !playerData[player.ID].logged) {
        MessagePlayer("[#00FF00]You need to login to use the chat", player)
        return 0;
    }
    return 1;
}

function onPlayerRequestSpawn( player ) {
    if(playerData[player.ID].registered && !playerData[player.ID].logged) {
        MessagePlayer("[#00FF00]This account is registered you need to login to spawn", player)
        return 0;
    }
    return 1;
}

function onPickupPickedUp(player, pickup) {
	switch(pickup.ID) 
	{
	case 0:
	    player.Pos = Vector(-438,1115,56.69 )
            break;
        case 1:
            player.Pos = Vector(-559,782,97.51 )
            break;
        case 2:
            player.Pos = Vector(-567,792,22.87)
            break;
        case 3:
            player.Pos = Vector(-817,1308,11.65)
            break;
        case 4:
            player.Pos = Vector(-818,1355,66)
	}
}

function onPlayerDeath(player, reason) {
    playerData[player.ID].Deaths++;
    Message("[#FA0BEA]" + player.Name + " [#FFFFFF]died.")
}

function onPlayerKill(killer, player, reason, bodypart) {
    playerData[player.ID].Deaths++;
    playerData[killer.ID].Kills++;
    killer.Cash+=500;
    player.Cash-=250;
    Message("[#FA0BEA]" + killer.Name + " [#FFFFFF]killed[#FA0BEA] " + player.Name + " with " + GetWeaponName(reason)+ " ("+bodypart+")")
    playerData[killer.ID].spree++;
    if(playerData[player.ID].spree > 4) {
        Message("[#FFFFFF]" + player.Name + "'s spree of " + playerData[player.ID].spree + " ended by " + killer.Name)
    }
    playerData[player.ID].spree = 0;
    if(playerData[killer.ID].spree % 5 == 0) {
        local reward = playerData[killer.ID].spree * 100;
        Message("[#FFFFFF]" + killer.Name+ " [#FA0BEA]is on killing spree of " + playerData[killer.ID].spree + " reward: " + reward)
        killer.Cash+=reward;       
    }
}

function HealPlayer(playerid) {
    local player = FindPlayer(playerid)
    if(player) {
        player.Cash-=300;
        player.Health = 100;
        MessagePlayer("[#00FF00]Successfully healed!", player)
        playerData[player.ID].healing = false;
    }
}

function onPlayerMove(player, lastx, lasty, lastz, newx, newy, newz) {
    if(playerData[player.ID].healing) {
        playerData[player.ID].healTimer.Delete();
        MessagePlayer("[#FF0000]Healing failed, you cant move while healing!", player)
        playerData[player.ID].healing = false
    }
}
