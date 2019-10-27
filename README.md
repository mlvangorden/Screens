# Maiden Voyage

For this game, I wanted to make a game that was relatively simple so I could focus on how to
implement the multiple screens. The idea I came up with was similar to checkers.

In this game, you control the ship by tapping the different directions on the compass rose. Your
objective is to collect as many stars as you can as they spawn around the board. Every time you
move, two enemy nodes will travel in a random direction. If you collide with an enemy, the game
ends. After the game ends, a Game Over screen will appear and let you type in your name to
save your score on the Leaderboard.

I did all of the design aspects myself, except for the paper texture in the background. Everything
on the GameScene I did programmatically (except for the END VOYAGE button). Each space
on the game board is generated programmatically and organized. Then I set variables within each
space to point to each of its neighbors. This allows the player and enemies to access exactly which
space they are on and what the neighbors are.

Some complications when building the game related to times when an enemy gets stuck in place.
I made it so that the enemies will never occupy the same space unless one of them will be otherwise
trapped. It is important that each piece moves at the same time, or else the player and enemy
could never collide to end the game. The first time I ran the game, I unknowingly started the enemies
on spaces such that they could never collide with the player on the same space. I also made it so
that the stars never spawn within one space of a player or enemy space.

I loved creating the visual aspects of the game becase it carries the aesthetic of an old-timey pirate
map.
