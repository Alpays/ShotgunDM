function onPlayerCommand(player, cmd, arg) {
    cmd = cmd.tolower();
    switch(cmd) {
        case "mypos":
        {
            MessagePlayer("[#00FF00]Your position is: X: " + player.Pos.x + " Y: " + player.Pos.y + " Z: " + player.Pos.z + " Angle: " + player.Angle, player);
            break;
        }
        case "me":
        {
            Message("*[#FFB226]" + player.Name + " " + arg)
            break;
        }
        case "rules":
        {
            MessagePlayer("[#00FF00]Following is not allowed: advertising other servers, using game modifications and trainers, racism, spamming\n using vpn and lag tools", player)
            break;
        }
        case "sit": 
        {

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
