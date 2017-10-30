%-------------------------------%
%-------------------------------%
%-----------Game Menus----------%
%-------------------------------%
%-------------------------------%

mainMenu :-
        write(' ____'), nl,                                               
        write('|  _ \\'), nl,
        write('| |_) | __ _ _ __ _ __ __ _  __ _  ___   ___  _ __'), nl,
        write('|  _ < / _` | \'__| \'__/ _` |/ _` |/ _ \\ / _ \\| \'_ \\'), nl,
        write('| |_) | (_| | |  | | | (_| | (_| | (_) | (_) | | | |'), nl,
        write('|____/ \\__,_|_|  |_|  \\__,_|\\__, |\\___/ \\___/|_| |_|'), nl,
        write('                             __/ |'), nl,               
        write('                            |___/'), nl,
        spacing(2),
        write('***************************\n'),
        write('*        Main Menu        *\n'),
        write('***************************'),
        write('1 - Play\n2 - Rules\n3 - Quit\n\n> '),
        get_single_char(Option),
        (
                Option = 49 -> gameMenu;
                Option = 50 -> rulesMenu;
                Option = 51;
                write(Option), nl,
                write('ERROR : invalid input...'), spacing(1),
                mainMenu
        ).

rulesMenu :- 
        write('***************************\n'),
        write('*        Rules Menu       *\n'),
        write('***************************'),
        write('1. A piece is captured if the oponent\'s piece finishes in the same cell.'), nl,
        write('2. Captures are only allowed during a full move.'), nl,
        write('3. Tiles with 2 circles can\'t capture barragoons with the "all directions" symbol turned up.'), nl,
        write('4. If a barragoon is captured, it must be placed back in the board, in a free place, with whichever symbol the player preffers.'), nl,
        write('5. When a tile is captured, 2 barragoons are added to the board, 1 per player and the first to place it is the one whose tile was captured.'), nl,
        write('6. Once a barragoon is placed, it can\'t be moved.'), nl,
        write('7. During a move, there can only be one 90º change of direction.'), nl,
        write('8. Movements can only be vertical or horizontal, never diagonal.'),
        spacing(2),
        next, mainMenu, !.
        