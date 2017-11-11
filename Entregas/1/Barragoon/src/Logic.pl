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

        getBoard(Game, GameBoard),
        getCurrentPlayer(Game, Player),

        displayGame(GameBoard),

        displayPlayerTurn(Player),

        repeat,
        (
           chooseTile(RowSrc, ColSrc, 'Which tile would you like to move?')
        ),

        validateTile(Game, RowSrc, ColSrc),
        !,
        /*chooseTile(RowDest, ColDest, 'Where do you want to move the tile?'),*/

        choosePath(Path, 'Please instert the path that you want to move that piece (Use WASD - eg. wwwd + Enter).'),       

        /*validatePath -> Verify tileType*/

        /*validateMove() -> validate move acording to the rules.*/
        !,

        
        movePiece(GameBoard, RowSrc, ColSrc, Path, NewGameBoard),

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

movePiece(GameBoard, RowSrc, ColSrc, Path, NewGameBoard) :-
        getDestCellFromPath(RowSrc, ColSrc, Path, RowDest, ColDest),
        moveFromSrcToDest(GameBoard,RowSrc,ColSrc,RowDest,ColDest,NewGameBoard).

moveFromSrcToDest(GameBoard, RowSrc, ColSrc, RowDest, ColDest, NewGameBoard) :-
        clearCell(GameBoard,  RowSrc,  ColSrc,  Value, NewGameBoard1),
        setCell(NewGameBoard1,RowDest, ColDest, Value, NewGameBoard).

% -------------------------------------------------------------------------
% ------------------------------ VALIDATIONS ------------------------------
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

% --- Check if it is a valid path ---
%validatePath(+Game, +RowSrcPos, +ColSrcPos, +Path): make sure the position corresponds to a piece of the player
validatePath(Game, RowSrc, ColSrc, Path) :-

        getBoard(Game, Board),
        getCurrentPlayer(Game, CurrentPlayer),

        %verify if it ends inside the board
        getDestCellFromPath(RowSrc, ColSrc, Path, RowDest, ColDest),
        RowDest < 9, RowDest >= 0,
        ColDest < 9, ColDest >= 0,
        
        %verify if it turns just once
        verifyTurnsOnce(Path).

        

        

validatePath(_Game, _RowSrc, _ColSrc) :-
        write('There\'s not a movable piece in that position.'), nl,
        write('Please, try another position.'), nl,
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
        



% --- Check if it is a barragoon ---
validateBarragoon.

% --- Check if it movement is possible ---
validateMovement.

% --- Valid collumns ---
validColumns(['a','b','c','d','e','f','g','A','B','C','D','E','F','G']).

validRow(Y):- Y > 48, Y < 60.

% --- Valid pieces ---
/*INUTIL*/
validTiles(['black2','black3','black4','white2','white3','white4']).

validBarragoons(['alldir','right','left','barraX']).
