%-------------------------------%
%-----------Game Logic----------%
%-------------------------------%
:- include('Utilities.pl').
:- include('Menus.pl').

/* The variable Game is a list with the game status.
    List content:
        GameBoard - matrix with the current board status;
        GameMode - PvP, PvC or CvC;
       */

startGamePvP:-
	initializeGamePvP(Game),
	playGame(Game).

initializeGamePvP(Game):-
	initialBoard(Board),
	Game = [Board, pvp], !.

playGame(Game) :-
	nth0(0, Game, GameBoard),
	playerTurn(GameBoard, GameBoardAfterWhite, whitePlayer),
	write('ACABOU TURNO BRANCO'),
	playerTurn(GameBoardAfterWhite, GameBoardAfterBlack, blackPlayer).

/*playloopHH(_, Board) :- 
	display(Board),nl, write('White won!!'),  nl.

playloopHH(Player, Board) :-
  humanplayer(Player, Board, B1),
  switch(Player, NewPlayer), !,
  playloopHH(NewPlayer, B1).

humanplayer(P, Board, NewBoard) :-
  display(Board),
  nl,nl,
  movmessage(P, M), write(M),
  getCoordinate(X, Y), nl,
  move(P, Board, X, Y, NewBoard).

humanplayer(P, Board, NewBoard) :-
  write('Invalid move. Try again.'), nl,
  humanplayer(P, Board, NewBoard).*/


playerTurn(GameBoard, NewGameBoard, Player) :- 
                displayGame(GameBoard),

                displayPlayerTurn(Player),

                chooseTile(RowSrc, ColSrc, 'Which tile would you like to move?'),
                
                /*
                /*validateTile(Row, Column) -> make sure the position corresponds to a piece of the player*/

                chooseTile(RowDest, ColDest, 'Where do you want to move the tile?'),

                /*validateDestTile -> Empty or with Barragoon pieces*/

                /*validateMove() -> validate move acording to the rules.*/
				!,
				write('moveFromSrcToDest'),
                moveFromSrcToDest(GameBoard, RowSrc, ColSrc, RowDest, ColDest, NewGameBoard).

moveFromSrcToDest(GameBoard, RowSrc, ColSrc, RowDest, ColDest, NewGameBoard) :-
        clearCell(GameBoard,  RowSrc,  ColSrc,  Value, NewGameBoard1),
        setCell(NewGameBoard1,RowDest, ColDest, Value, NewGameBoard).
		

/*letHumanPlay(Game, ResultantGame):-
	getGameBoard(Game, Board), getGamePlayerTurn(Game, Player),

	repeat,

	clearConsole,
	printBoard(Board),
	printTurnInfo(Player), nl, nl,
	getPieceToBeMovedSourceCoords(SrcRow, SrcCol),
	validateChosenPieceOwnership(SrcRow, SrcCol, Board, Player),

	clearConsole,
	printBoard(Board),
	printTurnInfo(Player), nl, nl,
	getPieceToBeMovedDestinyCoords(DestRow, DestCol),
	validateDifferentCoordinates(SrcRow, SrcCol, DestRow, DestCol),

	validateMove(SrcRow, SrcCol, DestRow, DestCol, Game, TempGame),
	changePlayer(TempGame, ResultantGame), !.*/