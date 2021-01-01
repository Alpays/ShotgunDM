/* 
Shotgun-DM is Deatmatch Gamemode only with shotgun/stubby pistols submachines.
Teams starts around downtown.
*/

local version = "1.0"

class PlayerData {
    weaponset = 1;
    spawnProtection = false;
    timesmuted = 0;
}

playerData <- array( GetMaxPlayers(), null);

function onScriptLoad() {
    print("Shotgun-DM Gamemode started version: " + version)
    SetServerName("Shotgun Deatmatch!");
    SetGameModeName("Shotgun-DM v1.0");
    // Server Settings
    SetTaxiBoostJump( true )
    SetDrivebyEnabled( false )
    SetFriendlyFire( false )
    SetDeathMessages( false )
    SetFrameLimiter( false )
    // Databases
    accountDb <- ConnectSQL( "accounts.db" );
    vehiclesDb <- ConnectSQL( "vehicles.db" );

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
}

function onPlayerSpawn( player ) {
    switch(playerData[player.ID].weaponset) {
        case 1:
        {
            player.SetWeapon( Weapons.STUBBY, 9999);
            player.SetWeapon( Weapons.COLT45, 9999);
            player.SetWeapon( Weapons.MP5, 9999);
            player.SetWeapon( Weapons.BRASS_KNUCKLES, 9999);
            break;
        }
        case 2: 
        {
            player.SetWeapon( Weapons.SHOTGUN, 9999);
            player.SetWeapon( Weapons.PYTHON, 9999);
            player.SetWeapon( Weapons.TEC9, 9999);
            player.SetWeapon( Weapons.GOLFCLUB, 9999);
            break;
        }
        case 3:
        {
            player.SetWeapon( Weapons.STUBBY, 9999);
            player.SetWeapon( Weapons.COLT45, 9999);
            player.SetWeapon( Weapons.INGRAM, 9999);
            player.SetWeapon( Weapons.BASEBALLBAT, 9999);
        }
    }
}

function onPlayerJoin( player ) {
    playerData[player.ID] = PlayerData();
}

function onPlayerPart( player, reason) {
    playerData[player.ID] = null;
}
