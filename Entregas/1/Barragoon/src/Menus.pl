%-------------------------------%
%-----------Menus---------------%
%-------------------------------%

mainMenu :-
        displayMainMenu,

        getCharThenEnter(Option),
        (
                Option = '1' -> startGamePvP;
                Option = '2' -> startGamePvC;
                Option = '3' -> startGameCvC;
                Option = '4' -> rulesMenu;
                Option = '5';

                nl,
                clearScreen,
                write('ERROR : invalid input...'), spacing(1),
		mainMenu
        ).


displayMainMenu :- 
        upperFrame,
        titleFrame,
        write('|                ***************************                |'),nl,
        write('|                *        Main Menu        *                |'),nl,
        write('|                ***************************                |'),nl,nl,
        write('|                Play:                                      |'),nl,
        write('|                1 - Player vs Player                       |'),nl,
        write('|                2 - Player vs Computer                     |'),nl,
        write('|                3 - Computer vs Computer                   |'),nl,
        write('|                                                           |'),nl,
        write('|                4 - Rules                                  |'),nl,
        write('|                5 - Quit                                   |'),nl,
        lowerFrame.

rulesMenu :- 
        upperFrame,
        write('|                ***************************                |'),nl,
        write('|                *        Rules Menu       *                |'),nl,
        write('|                ***************************                |'),nl,nl,
        write('|  1. A piece is captured if the oponent\'s piece finishes   |'),nl,
        write('|     in the same cell.                                     |'),nl,
        write('|  2. Captures are only allowed during a full move.         |'),nl,
        write('|  3. Tiles with 2 circles can\'t capture barragoons with    |'),nl, 
        write('|     the "all directions" symbol turned up.                |'),nl,
        write('|  4. If a barragoon is captured, it must be placed back    |'),nl, 
        write('|     in the board, in a free place, with whichever symbol  |'),nl,
        write('|     the player preffers.                                  |'),nl,
        write('|  5. When a tile is captured, 2 barragoons are added to    |'),nl, 
        write('|     the board, 1 per player and the first to place it is  |'),nl,
        write('|     the one whose tile was captured.                      |'),nl,
        write('|  6. Once a barragoon is placed, it can\'t be moved.        |'),nl, 
        write('|  7. During a move, there can only be one 90� change of    |'),nl, 
        write('|     direction.                                            |'),nl,
        write('|  8. Movements can only be vertical or horizontal, never   |'),nl, 
        write('|     diagonal.                                             |'),nl,
        lowerFrame,
        spacing(2),
        next, mainMenu, !.

upperFrame :- 
        write(' ___________________________________________________________'),nl,
        write('|                                                           |'),nl.

titleFrame :-
        write('|   ____                                                    |'), nl,                                               
        write('|  |  _ \\                                                   |'), nl,
        write('|  | |_) | __ _ _ __ _ __ __ _  __ _  ___   ___  _ __       |'), nl,
        write('|  |  _ < / _` | \'__| \'__/ _` |/ _` |/ _ \\ / _ \\| \'_ \\      |'), nl,
        write('|  | |_) | (_| | |  | | | (_| | (_| | (_) | (_) | | | |     |'), nl,
        write('|  |____/ \\__,_|_|  |_|  \\__,_|\\__, |\\___/ \\___/|_| |_|     |'), nl,
        write('|                               __/ |                       |'), nl,               
        write('|                              |___/                        |'), nl,
        write('|                                                           |'),nl.


lowerFrame :-
        write('|                                                           |'),nl,
        write('|___________________________________________________________|'),nl.