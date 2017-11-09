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
	playGame.

startGamePvC:-
	initializeGamePvC(Game),
	playGame(Game).

startGameCvC:-
	initializeGameCvC(Game),
	playGame(Game).

initializeGamePvP(Game):-
	initialBoard(GameBoard),
	Game = [GameBoard, pvp], !.

initializeGamePvC(Game):-
	initialBoard(GameBoard),
	Game = [GameBoard, pvc], !.

initializeGameCvC(Game):-
	initialBoard(GameBoard),
	Game = [GameBoard, cvc], !.

initialBoard([[um, empty, black4, black3, empty, black3, black4, empty],
	      [dois, empty, empty, black2, black3, black2, empty, empty],
	      [tres,empty, empty, empty, empty, empty, empty, empty],
	      [quatro, empty, barraX, empty, empty, empty, barraX, empty],
	      [cinco, barraX, empty, barraX, empty, barraX, empty, barraX],
	      [seis, empty, barraX, empty, empty, empty, barraX, empty],
	      [sete, empty, empty, empty, empty, empty, empty, empty],
	      [oito, empty, empty, white2, white3, white2, empty, empty],
	      [nove, empty, white4, white3, empty, white3, white4, empty]]).

playGame :-
	whitePlayerTurn.


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