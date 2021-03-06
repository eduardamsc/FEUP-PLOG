%-------------------------------%
%----------Interface------------%
%-------------------------------%

% -------------------------------------------------------------------------
% ----------------------------------- MENUS -------------------------------
% -------------------------------------------------------------------------

% -- Menus --
mainMenu :-
        displayMainMenu,
        getCharThenEnter(Option),
        (
           Option = '1' -> startGame(pvp);
           Option = '2' -> startGame(pvc-easy);
           Option = '3' -> startGame(pvc-hard);
           Option = '4' -> startGame(cvc-hard);
           Option = '5' -> displayRules;
           Option = '6';

           clearScreen,
           write('ERROR : invalid input...'), spacing(1),
           mainMenu
        ).

displayMainMenu :- 
        upperFrame,
        titleFrame,
        write('|                ***************************                |'),nl,
        write('|                *        Main Menu        *                |'),nl,
        write('|                ***************************                |'),nl,
        write('|                Play:                                      |'),nl,
        write('|                1 - Player vs Player                       |'),nl,
        write('|                2 - Player vs Computer Easy                |'),nl,
        write('|                3 - Player vs Computer Hard                |'),nl,
        write('|                4 - Computer vs Computer                   |'),nl,
        write('|                                                           |'),nl,
        write('|                5 - Rules                                  |'),nl,
        write('|                6 - Quit                                   |'),nl,

        lowerFrame.

displayRules :- 
        clearScreen,
        upperFrame,
        titleFrame,
        write('|                ***************************                |'),nl,
        write('|                *        Game Rules       *                |'),nl,
        write('|                ***************************                |'),nl,
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
        write('|  7. During a move, there can only be one change of        |'),nl, 
        write('|     direction.                                            |'),nl,
        write('|  8. Movements can only be vertical or horizontal, never   |'),nl, 
        write('|     diagonal.                                             |'),nl,
        lowerFrame,
        spacing(2),
        next, mainMenu, !.

displayPlayerTurn(Player) :-
        ifelse(
                 Player = w ,
                 (
                    write('*************************************'),nl,
                    write('*            White Player           *'),nl,
                    write('*************************************'),nl,nl
                 ),
                 (
                    write('*************************************'),nl,
                    write('*            Black Player           *'),nl,
                    write('*************************************'),nl,nl
                 )).

% -- Logo --
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

% -- Frames --
upperFrame :- 
        write(' ___________________________________________________________'),nl,
        write('|                                                           |'),nl.

lowerFrame :-
        write('|                                                           |'),nl,
        write('|___________________________________________________________|'),nl.

% -------------------------------------------------------------------------
% ----------------------------------- BOARD -------------------------------
% -------------------------------------------------------------------------

% -- BOARD --
initialBoard(   [[empty, b-4, b-3, empty, b-3, b-4, empty],
                 [empty, empty, b-2, b-3, b-2, empty, empty],
                 [empty, empty, empty, empty, empty, empty, empty],
                 [empty, bg-barraX, empty, empty, empty, bg-barraX, empty],
                 [bg-barraX, empty, bg-barraX, empty, bg-barraX, empty, bg-barraX],
                 [empty, bg-barraX, empty, empty, empty, bg-barraX, empty],
                 [empty, empty, empty, empty, empty, empty, empty],
                 [empty, empty, w-2, w-3, w-2, empty, empty],
                 [empty, w-4, w-3, empty, w-3, w-4, empty]]).

displayGame(Game) :-
        getBoard(Game, Board),
        getCurrentPlayer(Game, Player),

        clearScreen,
        displayPlayerTurn(Player),
        lettersAxis,nl,
        horizontalBorder, nl,
        numbersAxis(RowNumbers),
        displayBoard(Board, RowNumbers), nl.

displayBoard([], []).
displayBoard([RowToDisplay|RemainingBoard], [RowToDisplayNumber|RemainingRowNumbers]) :-
        translate([RowToDisplayNumber]),
        translate(RowToDisplay),border, nl,
        horizontalBorder, nl,
        displayBoard(RemainingBoard, RemainingRowNumbers).

% -- Board Translation --
translate([]).
translate(['empty'|R]) :- border, write('    '), !, translate(R).
translate([w-2|R]) :- border, write(' w2 '), !, translate(R).
translate([w-3|R]) :- border, write(' w3 '), !, translate(R).
translate([w-4|R]) :- border, write(' w4 '), !, translate(R).
translate([b-2|R]) :- border, write(' b2 '), !, translate(R).
translate([b-3|R]) :- border, write(' b3 '), !, translate(R).
translate([b-4|R]) :- border, write(' b4 '), !, translate(R).
translate([bg-'barraX'|R]) :- border, write('  X '), !, translate(R).
translate([bg-'allDir'|R]) :- border, write('  + '), !, translate(R).
translate([bg-'oDirU'|R]) :- border, write('  A '), !, translate(R).
translate([bg-'oDirD'|R]) :- border, write('  V '), !, translate(R).
translate([bg-'oDirL'|R]) :- border, write(' <= '), !, translate(R).
translate([bg-'oDirR'|R]) :- border, write(' => '), !, translate(R).
translate([bg-'tDirH'|R]) :- border, write(' <> '), !, translate(R).
translate([bg-'tDirV'|R]) :- border, write('  I '), !, translate(R).
translate([bg-'DtoR'|R]) :- border, write(' .> '), !, translate(R).
translate([bg-'DtoL'|R]) :- border, write(' <. '), !, translate(R).
translate([bg-'UtoR'|R]) :- border, write(' \'> '), !, translate(R).
translate([bg-'UtoL'|R]) :- border, write(' <\' '), !, translate(R).
translate([bg-'LtoU'|R]) :- border, write(' -^ '), !, translate(R).
translate([bg-'LtoD'|R]) :- border, write(' -v '), !, translate(R).
translate([bg-'RtoU'|R]) :- border, write(' ^- '), !, translate(R).
translate([bg-'RtoD'|R]) :- border, write(' v- '), !, translate(R).
translate(['1'|R]) :- write('1'), !, translate(R).
translate(['2'|R]) :- write('2'), !, translate(R).
translate(['3'|R]) :- write('3'), !, translate(R).
translate(['4'|R]) :- write('4'), !, translate(R).
translate(['5'|R]) :- write('5'), !, translate(R).
translate(['6'|R]) :- write('6'), !, translate(R).
translate(['7'|R]) :- write('7'), !, translate(R).
translate(['8'|R]) :- write('8'), !, translate(R).
translate(['9'|R]) :- write('9'), !, translate(R).

% -- Board Axis --
numbersAxis(['1', '2', '3', '4', '5', '6', '7', '8', '9']).

lettersAxis :- write('    A    B    C    D    E    F    G').

% -- Board Borders --
horizontalBorder :- write('  ----------------------------------').

border :- write('|').



/* =================== TESTE ====================*/

finalBoard([     [bg-'barraX', b-4, empty, b-2, b-3, b-4, bg-'barraX'],
                 [empty, bg-'barraX', empty, empty, empty, bg-'barraX', empty],
                 [empty, bg-'barraX', empty, empty, w-2, empty, empty],
                 [bg-'barraX', w-2, bg-'barraX', empty, empty, bg-barraX, empty],
                 [empty, bg-'barraX', empty, empty, bg-barraX, empty, bg-barraX],
                 [empty, bg-barraX, empty, empty, empty, bg-barraX, empty],
                 [empty, empty, empty, empty, empty, empty, empty],
                 [empty, empty, bg-'barraX', b-3, bg-'barraX', empty, empty],
                 [empty, bg-'barraX', w-3, bg-'barraX', w-3, bg-'barraX', empty]]).
