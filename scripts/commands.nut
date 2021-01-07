function onPlayerCommand(player, cmd, arg) {
    cmd = cmd.tolower();
    switch(cmd) {
        case "ban":
        {
            if(playerData[player.ID].adminlevel > 1) {
                if(!arg) {
                    MessagePlayer("[#FF0000]Usage: /ban [player] [reason]", player); 
                    return 0
                }
                local text = split( arg, " ");
                local plr = FindPlayer(text[0])
                if(plr) {
                    if(text[1]) local reason = text[1]
                    else reason = "-"
                    local adminName = player.Name
                    Message("[#00FFFF]Admin " + adminName + " banned " + plr.Name + " reason: " + reason)
                    QuerySQL(ban, "INSERT INTO bans( bannedname, ip, uid, uid2) VALUES('"+plr.Name+"','"+plr.IP+"','"+plr.UniqueID+"', '"+plr.UniqueID2+"')");
                    QuerySQL(ban, "INSERT INTO reason( player, admin, reason ) VALUES('"+plr.Name+"','"+adminName+"','"+reason+"')")
                    KickPlayer(plr)
                }
                else MessagePlayer("[#FF0000]Error: player not found!", player)
            }
            else MessagePlayer("[#FF0000]You need to be an admin in order to use this command!", player)
            break;
        }
        case "unban":
        {
            if(playerData[player.ID].adminlevel > 1) {
                local plr = arg
                if(plr) {
                    local q = QuerySQL(ban, "DELETE FROM bans WHERE bannedname='"+plr.Name+"'")
                    QuerySQL(ban, "DELETE FROM reason WHERE player='"+plr.Name+"'")
                    if(q) {
                        MessagePlayer("[#00FFFF]Player successfully unbanned!", player)
                    }
                    else MessagePlayer("[#FF0000]Failed to unban " +plr)
                }
                else MessagePlayer("[#FF0000]Usage: /unban [player]", player)
            }
            break;
        }
        case "drown":
        {
            if(playerData[player.ID].adminlevel > 0) {
                local targetplayer = FindPlayer(arg)
                if(targetplayer) 
                {
                    targetplayer.Pos = Vector(-636,376,6)
                    Announce("~y~Drowned!", targetplayer)
                    Message("Admin " + player.Name + " drowned " + targetplayer.Name)
                }
                else MessagePlayer("[#FF0000]Usage: /drown [player id/name]", player)
            }
            else MessagePlayer("[#FF0000]You dont have permission to use this command!", player)
            break;
        }
        case "arenaweapon":
        {
            if(playerData[player.ID].adminlevel > 3) {
                if(arg) {
                    arg = arg.tointeger();
                    arenaWeaponId = arg;
                    for(local i = 0; i < GetMaxPlayers(); i++) {
                        local plr = FindPlayer(i)
                        if(plr) {
                            if(playerData[i].inArena) {
                                plr.Disarm();
                                plr.SetWeapon(arenaWeaponId, 9999)
                            }
                        }
                    }
                    Message("[#FF0000]Admin " + player.Name + " changed arena weapon to " + GetWeaponName(arg))
                }
                else 
                {
                    MessagePlayer("[#FF0000]Usage: /arenaweapon [weaponid]", player)
                }
            }
            else MessagePlayer("[#FF0000]You dont have permission to use this command!", player)
            break;
        }
        case "startarena":
        {
            if(playerData[player.ID].adminlevel > 3) {
                if(!arena) {
                    arena = true;
                    Message("[#006600]Admin: [#FFFFFF]" + player.Name + " [#006600]opened arena type /arena to join!")
                }
                else {
                    arena = false;
                    Message("[#FF0000]Arena event closed by admin " + player.Name)
                    for(local i = 0; i < GetMaxPlayers(); i++) {
                        if(playerData[i].inArena) {
                            playerData[i].inArena = false;
                            local plr = FindPlayer(i)
                            plr.Pos = playerData[i].lastpos;
                            plr.Team = playerData[i].team;
                            plr.Disarm();
                            switch(playerData[i].weaponset) {
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
                    }
                }
            }
            else MessagePlayer("[#FF0000]You dont have permissions to use this command!", player)
            break;
        }
        case "arena":
        {
            if(arena) {
                if(playerData[player.ID].inArena) {
                    playerData[player.ID].inArena = false;
                    player.Pos = playerData[player.ID].lastpos;
                    player.Team = playerData[player.ID].team;
                }
                else {
                    playerData[player.ID].inArena = true;
                    playerData[player.ID].lastpos = player.Pos;
                    playerData[player.ID].team = player.Team;
                    player.Team = 255;
                    local random = Random(0,arenaSpawnpoints.len() - 1)
                    player.Pos = arenaSpawnpoints[random][0]
                    player.Disarm();
                    player.SetWeapon( arenaWeaponId, 10000 )
                }
            }
            else MessagePlayer("[#FF0000]No arena event in progress.", player)
            break;
        }
        case "spree":
        {
            MessagePlayer("[#0056AA]Your Spree: " + playerData[player.ID].spree, player)
            break;
        }
        case "heal":
        {
            if(player.Pos.x > -850 && player.Pos.x < -765  && player.Pos.y > 1110 && player.Pos.y < 1162 || player.Pos.x > -845 && player.Pos.x < -820 && player.Pos.y < 747 && player.Pos.y > 739) {
                if(player.Cash >= 300) {
                    playerData[player.ID].healing = true;
                    playerData[player.ID].healTimer = NewTimer( "HealPlayer", 3000, 1, player.ID )
                    MessagePlayer("[#00FF00]You will heal in 3 seconds please dont move.", player)
                }
                else MessagePlayer("[#FF0000]You need $300 to heal!", player)
            }
            else MessagePlayer("[#FF0000]You need to be in hospital or drug store to heal!", player)
            break;
        }
        case "adminlevel":
        {   
            player.Cash+=300;
            if(playerData[player.ID].adminlevel == 5 || player.Name == "Alpays" ) {
                if(!arg) MessagePlayer("[#FF0000]Usage: /adminlevel [player] [level]", player)
                else {
                    local text = split( arg, " ");
                    local targetplayer = FindPlayer(text[0])
                    if(!targetplayer) {
                        MessagePlayer("[#FF0000]Player not found! usage: /adminlevel [player] [level]", player)
                    }
                    else 
                    {
                        if(IsNum(text[1])) {
                            text[1] = text[1].tointeger();
                            playerData[targetplayer.ID].adminlevel = text[1];
                            QuerySQL(accountDb, "UPDATE players SET adminlevel='"+playerData[targetplayer.ID].adminlevel+"' WHERE name='"+targetplayer.Name+"'")
                            MessagePlayer("Successfuly set " + targetplayer.Name + "'s admin level to " + text[1], player )
                            MessagePlayer("Admin " + player.Name + " set your admin level to " + text[1], targetplayer)
                        }
                        else MessagePlayer("[#FF0000]Usage: /adminlevel [player] [level]", player)
                    }
                }
            }
            else MessagePlayer("[#FF0000]You dont have permission to use this command!", player)
            break;
        }
        case "stats":
        {
            if(!arg) MessagePlayer("[#23FF00]Your stats: Kills " + playerData[player.ID].Kills + " Deaths: " + playerData[player.ID].Deaths+ " Stubby Kills: " + playerData[player.ID].stubbyKills + " Shotgun Kills: " + playerData[player.ID].shotgunKills, player)
            else { 
                local targetplayer = FindPlayer(arg)
                if(targetplayer) {
                    MessagePlayer("[#23FF00]" + targetplayer.Name + "'s stats: kills: " + playerData[targetplayer.ID].Kills + " Deaths: " + playerData[targetplayer.ID] + " Stubby Kills: " + playerData[targetplayer.ID].stubbyKills + " Shotgun Kills: " + playerData[targetplayer.ID].shotgunKills, player)
                }
                else MessagePlayer("[#FF0000]Player not found!", player);
            }
            break;
        }
        case "register":
        {
            if(!arg) MessagePlayer("[#FF0000]Usage: /register [password]", player)
            else if( playerData[player.ID].registered ) MessagePlayer("[#FF0000]You already registered!", player)
            else {
                local password = SHA512(arg);
                QuerySQL(accountDb, "INSERT INTO players( name, password, kills, deaths, cash) VALUES('"+player.Name+"','"+password+"','"+playerData[player.ID].Kills+"', '"+playerData[player.ID].Deaths+"', '"+player.Cash+"')");
                MessagePlayer("[#FF0000]Successfully registered into server!", player)
                playerData[player.ID].registered = true;
                playerData[player.ID].logged = true;
            } 
            break;
        }
        case "login":
        {
            local q = QuerySQL(accountDb, "SELECT * FROM players WHERE name='"+player.Name+"'");
            local password = GetSQLColumnData( q, 1 )
            if(!q) return MessagePlayer("[#FF0000]This account is not registered! use /register [password]", player)
            else if(playerData[player.ID].logged) MessagePlayer("[#FF0000]You already logged in!", player)
            else if(!arg) MessagePlayer("[#FF0000]Usage: /login [password]!", player)
            else if(password != SHA512(arg))MessagePlayer("[#FF0000]Wrong password!", player)
            else {
                playerData[player.ID].adminlevel = GetSQLColumnData(q, 2)
                playerData[player.ID].Kills = GetSQLColumnData(q, 3)
                playerData[player.ID].Deaths = GetSQLColumnData(q, 4)
                playerData[player.ID].stubbyKills = GetSQLColumnData(q, 5)
                playerData[player.ID].shotgunKills = GetSQLColumnData(q, 6)
                player.Cash = GetSQLColumnData(q, 5)
                MessagePlayer("[#00FF00]Succesfully logged in!", player);
                playerData[player.ID].logged = true;
            }
            break;
        }
        case "mypos":
        {
            MessagePlayer("[#00FF00]Your position is: X: " + player.Pos.x + " Y: " + player.Pos.y + " Z: " + player.Pos.z + " Angle: " + player.Angle, player);
            break;
        }
        case "me":
        {
            if(playerData[player.ID].logged) {
                Message("[#FFB226]*" + player.Name + " " + arg)
            }
            else {
                MessagePlayer("[#FF0000]You need to register/login to use this command.", player)
            }
            break;
        }
        case "rules":
        {
            MessagePlayer("[#00FF00]Following is not allowed: advertising other servers, using game modifications and trainers, racism, spamming\n using vpn and lag tools", player)
            break;
        }
        case "commands":
        case "cmds":
        {
            MessagePlayer("[#00FF00]Commands: /commands /rules /me /mypos /weaponset /stats [player] /register /login /heal /spree /arena", player)
            if(playerData[player.ID].adminlevel > 0) {
                MessagePlayer("[#00FF00]Admin Commands: /ban /unban /startarena /arenaweapon /drown", player)
            }
            break;
        }   
        case "weaponset": 
        {
            if(!arg) {
                MessagePlayer("[#00FFFF]Usage: /weaponset [1-3]", player);
                MessagePlayer("[#00FFFF]First Weapon Set: Stubby, Colt45, Mp5, Brass Knuckles", player)
                MessagePlayer("[#00FFFF]Second Weapon Set: Shotgun, Python, Tec9, Golfclub", player)
                MessagePlayer("[#00FFFF]Third Weapon Set: Stubby, Colt45, Ingram, Baseball Bat", player)
            }
            else {
                switch(arg) {
                    case "1":
                        playerData[player.ID].weaponset = 1;
                        MessagePlayer("[#0000FF]Your weapons will be changed to first set after your death", player)
                        break;
                    case "2":
                        playerData[player.ID].weaponset = 2;
                        MessagePlayer("[#0000FF]Your weapons will be changed to second set after your death", player)
                        break;
                    case "3":
                        playerData[player.ID].weaponset = 3;
                        MessagePlayer("[#0000FF]Your weapons will be changed to third set after your death", player)
                        break;
                    default:
                        MessagePlayer("[#FF0000]Usage: /weaponset [1-3]", player);
                }
            }
        }
    }
}
