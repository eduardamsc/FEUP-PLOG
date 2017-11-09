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
	displayBoard(Board),
	Game = [Board, pvp], !.

playGame(Game) :-
	whitePlayerTurn.
       %-- playloopHH(_, Board) :- display(Board),nl, write('White won!!'),  nl.


playloopHH(_, Board) :- 
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
  humanplayer(P, Board, NewBoard).



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