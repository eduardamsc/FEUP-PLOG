%-------------------------------%
%-----------Game Logic----------%
%-------------------------------%

% -------------------------------------------------------------------------
% ----------------------------------- GAME  -------------------------------
% -------------------------------------------------------------------------

% --- Game Loop ---
startGamePvP:-
        initializeGamePvP(Game),
        playGame(Game).

initializeGamePvP(Game):-
        initialBoard(Board),
        Game = [Board, w, pvp], !.

playGame(Game) :-
        playerTurn(Game, UpdatedGame),
        switchPlayer(UpdatedGame, NextPlayerGame),
        playGame(NextPlayerGame).

playerTurn(Game, NewGame) :- 
        displayGame(Game),
        repeat,
        (
           chooseTile(RowSrc, ColSrc, 'Which tile would you like to move?')
        ),

        validateTile(Game, RowSrc, ColSrc),
        !,

        repeat,
        (
           choosePath(Path, 'Please insert the path that you want that piece to follow:\n(Use WASD - eg. wwwd + Enter).')
        ),

        validatePath(RowSrc, ColSrc, Path),
        !,

        /*validateMove() -> validate move acording to the rules.*/

        getBoard(Game, GameBoard),
        movePiece(Game,GameBoard, RowSrc, ColSrc, Path, NewGameBoard),

        setBoard(Game, NewGameBoard, NewGame).


% -------------------------------------------------------------------------
% ------------------------------ MOVEMENTS --------------------------------
% -------------------------------------------------------------------------

getDestCellFromPath(RowSrc, ColSrc, [], RowDest, ColDest):-
        RowDest = RowSrc,
        ColDest = ColSrc.
getDestCellFromPath(RowSrc, ColSrc, [Move|Tail], RowDest, ColDest) :-
        (
           Move == 'w' -> (RowDest1 is RowSrc-1, getDestCellFromPath(RowDest1,ColSrc,Tail,RowDest,ColDest));
           Move == 's' -> (RowDest1 is RowSrc+1, getDestCellFromPath(RowDest1,ColSrc,Tail,RowDest,ColDest));
           Move == 'a' -> (ColDest1 is ColSrc-1, getDestCellFromPath(RowSrc,ColDest1,Tail,RowDest,ColDest));
           Move == 'd' -> (ColDest1 is ColSrc+1, getDestCellFromPath(RowSrc,ColDest1,Tail,RowDest,ColDest))
        ).

% --- Move piece ---
movePiece(Game,GameBoard, RowSrc, ColSrc, Path, NewGameBoard) :-
        getDestCellFromPath(RowSrc, ColSrc, Path, RowDest, ColDest),
        isBarragoon(Game, RowDest, ColDest, GameBoard),
        moveFromSrcToDest(GameBoard,RowSrc,ColSrc,RowDest,ColDest,NewGameBoard).

moveFromSrcToDest(GameBoard, RowSrc, ColSrc, RowDest, ColDest, NewGameBoard) :-
        clearCell(GameBoard,  RowSrc,  ColSrc,  Value, NewGameBoard1),
        setCell(NewGameBoard1,RowDest, ColDest, Value, NewGameBoard).

% --- Check if it is a short move ---
%isShortMove(+Piece, +Path)
isShortMove(_Player-NDots, Path) :-
        length(Path, N),

        N1 is N-1,
        N1 == NDots.

% --- Check if it is a long move ---
%isLongMove(+Piece, +Path)
isLongMove(_Player-NDots, Path) :-
        length(Path, N),
        N == NDots.

% -------------------------------------------------------------------------
% ---------------------------- IDENTIFY PIECES ----------------------------
% -------------------------------------------------------------------------

% --- Check if it is a valid tile ---
%validateTile(+Game, +RowSrcPos, +ColSrcPos): make sure the position corresponds to a piece of the player
validateTile(Game, RowSrc, ColSrc) :-

        getBoard(Game, Board),
        getCurrentPlayer(Game, CurrentPlayer),

        getCell(Board, RowSrc, ColSrc, Piece),

        Piece = CurrentPlayer-_.

validateTile(_Game, _RowSrc, _ColSrc) :-
        write('There\'s not a movable piece in that position.'), nl,
        write('Please, try another position.'), nl,
        fail. 
%go_back to repeat cycle

% --- Check if it is a barragoon ---
isBarragoon(Game, Row, Collumn, NewBoard) :-
        getBoard(Game, Board),
        getCell(Board, Row, Collumn, Piece),
        validBarragoons(Barragoons),
        ifelse(member(Piece,Barragoons), Option is 0, Option is 1),
        (
           Option = 0 -> write('A barragoon was eaten in this move!'),nl, insertBarragoon(Board, NewBoard);
           Option = 1 -> write('No barragoons were eaten in this move!')
        
        ),
        write('4').

% -------------------------------------------------------------------------
% ---------------------------- MOVEMENT RULES -----------------------------
% -------------------------------------------------------------------------

% --- Check if it is a valid path ---
validatePathValues([]).
validatePathValues([H|T]) :- 
        member(H,['w','a','s','d']), 
        validatePathValues(T).

validatePath(RowSrc, ColSrc, Path) :-
        %verify if it ends inside the board
        getDestCellFromPath(RowSrc, ColSrc, Path, RowDest, ColDest),
        RowDest < 9, RowDest >= 0,
        ColDest < 9, ColDest >= 0,

        %verify if it turns just once
        verifyTurnsOnce(Path).

validatePath(_, _, _) :-
        write('That path is not valid!'), nl,
        write('Please, try another path.'), nl,
        fail. 
%go_back to repeat cycle

% --- Check if it turns just once ---
verifyTurnsOnce([H|T]) :-
        complementary(H,C),
        verifyTurnsOnceAux(T,H,0,C).

verifyTurnsOnceAux([],_,N,_):-
        N < 2.
verifyTurnsOnceAux([H|T], H, N, C) :-
        verifyTurnsOnceAux(T, H, N, C).
verifyTurnsOnceAux([H|T], Z, N, C) :-
        Z \= H,
        H \= C,

        complementary(H, C1),
        N1 is N+1,      
        verifyTurnsOnceAux(T, H, N1, C1).

% -------------------------------------------------------------------------
% ----------------------------- CONSEQUENCES ------------------------------
% ------------------------------------------------------------------------- 

% --- Insert new barragoon ---
insertBarragoon(Board, NewBoard) :-
        write('Where do you wish to place your barragoon?'), nl,
        getPositionFromUser(Row, Collumn),
        write('Which barragoon do you wish to insert?'),nl,
        write('The options are:'),nl,
        write('1-  X\n2-  +\n3-  A\n4-  V\n5- <=\n6- =>\n7-  -\n8-  I\n9-  <\n10- >'),nl,
        getCharThenEnter(Option),
        (
           Option = '1' -> setCell(Board, Row, Collumn, '  X ', NewBoard);
           Option = '2' -> setCell(Board, Row, Collumn, '  + ', NewBoard);
           Option = '3' -> setCell(Board, Row, Collumn, '  A ', NewBoard);
           Option = '4' -> setCell(Board, Row, Collumn, '  V ', NewBoard);
           Option = '5' -> setCell(Board, Row, Collumn, ' <= ', NewBoard);
           Option = '6' -> setCell(Board, Row, Collumn, ' => ', NewBoard);
           Option = '7' -> setCell(Board, Row, Collumn, '  - ', NewBoard);
           Option = '8' -> setCell(Board, Row, Collumn, '  I ', NewBoard);
           Option = '9' -> setCell(Board, Row, Collumn, '  <  ', NewBoard);
           Option = '10' -> setCell(Board, Row, Collumn, '  >  ', NewBoard)
          ).


% --- Valid coordinates ---
validColumns(['a','b','c','d','e','f','g','A','B','C','D','E','F','G']).

validRow(Y):- Y > 48, Y < 60.

validBarragoons([bg-'barraX', bg-'allDir', bg-'1DirU', bg-'1DirD', bg-'1DirL', bg-'1DirR', bg-'2DirH', bg-'2DirV', bg-'right', bg-'left']).

complementary('w','s').
complementary('s','w').
complementary('a','d').
complementary('d','a').