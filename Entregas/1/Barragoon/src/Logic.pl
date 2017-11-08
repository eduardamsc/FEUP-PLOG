%-------------------------------%
%-----------Game Logic----------%
%-------------------------------%

/* The variable Game is a list with the game status.
    List content:
        GameBoard - matrix with the current board status;
        GameMode - PvP, PvC or CvC;
        GameDifficulty - Hard or Easy.
        */

startGamePvP:-
	initializeGamePvP(Game),
	playGame(Game).

startGamePvC:-
	initializeGamePvC(Game),
	playGame(Game).

startGameCvC:-
	initializeGameCvC(Game),
	playGame(Game).

initializeGamePvP(Game):-
	initialBoard(GameBoard),
	Game = [GameBoard, [16, 16], whitePlayer, pvp], !.

initializeGamePvC(Game):-
	initialBoard(GameBoard),
	Game = [GameBoard, [16, 16], whitePlayer, pvc], !.

initializeGameCvC(Game):-
	initialBoard(GameBoard),
	Game = [GameBoard, [16, 16], whitePlayer, cvc], !.