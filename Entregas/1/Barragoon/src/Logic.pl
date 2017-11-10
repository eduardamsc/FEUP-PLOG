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
        Game = [Board, whitePlayer, pvp], !.

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
           chooseTile(RowSrc, ColSrc, 'Which tile would you like to move?'),

           validColumns(Possibilities),

           nth0(ColSrcPosInPossibilities, Possibilities, ColSrc),
           ColSrcPos is ColSrcPosInPossibilities mod 7,
           RowSrcPos is RowSrc-49
        ),


        /*validateTile(Row, Column) -> make sure the position corresponds to a piece of the player*/
        validateTile(GameBoard, RowSrcPos, ColSrcPos),
        !,
        chooseTile(RowDest, ColDest, 'Where do you want to move the tile?'),

        /*validateDestTile -> Empty or with Barragoon pieces*/

        /*validateMove() -> validate move acording to the rules.*/
        !,

        nth0(ColDestPosInPossibilities, Possibilities, ColDest),
        /*Tranform letters and ascii codes to Row and Column Indexes*/
        ColDestPos is ColDestPosInPossibilities mod 7,
        RowDestPos is RowDest-49,

        moveFromSrcToDest(GameBoard, RowSrcPos, ColSrcPos, RowDestPos, ColDestPos, NewGameBoard),

        setBoard(Game, NewGameBoard, NewGame).


% -------------------------------------------------------------------------
% ------------------------------ MOVEMENTS --------------------------------
% -------------------------------------------------------------------------

moveFromSrcToDest(GameBoard, RowSrc, ColSrc, RowDest, ColDest, NewGameBoard) :-
        clearCell(GameBoard,  RowSrc,  ColSrc,  Value, NewGameBoard1),
        setCell(NewGameBoard1,RowDest, ColDest, Value, NewGameBoard).

% -------------------------------------------------------------------------
% ------------------------------ VALIDATIONS ------------------------------
% -------------------------------------------------------------------------

% --- Check if it is a tile ---
validateTile(Board, RowSrc, ColSrc) :-
        getCell(Board, RowSrc, ColSrc, Piece),
        validTiles(Tiles),
        member(Piece, Tiles).
validateTile(_Board, _RowSrc, _ColSrc) :-
        write('There\'s not a movable piece in that position.'), nl,
        write('Please, try another position.').

% --- Check if it is a barragoon ---
validateBarragoon.

% --- Check if it movement is possible ---
validateMovement.

% --- Valid collumns ---
validColumns(['a','b','c','d','e','f','g','A','B','C','D','E','F','G']).

validRow(Y):- Y > 48, Y < 60.

% --- Valid pieces ---
validTiles(['black2','black3','black4','white2','white3','white4']).

validBarragoons(['alldir','right','left','barraX']).
