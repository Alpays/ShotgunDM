// This is the main file you need to set gamemode to main.nut in order to make your script work.

function Random(from, to) return (rand()*(to+1-from)) / (RAND_MAX+1)+from;

dofile("scripts/definitions.nut");
dofile("scripts/player.nut");   
dofile("scripts/gamemode.nut");
dofile("scripts/commands.nut");
