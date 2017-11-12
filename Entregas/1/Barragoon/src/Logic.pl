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
        ifelse(isGameOver(Game),
                (
                        switchPlayer(Game, EndGame),
                        getCurrentPlayer(EndGame, Winner),
                        gameOver(Winner)
                ),
                (
                        playerTurn(Game, UpdatedGame),
                        switchPlayer(UpdatedGame, NextPlayerGame),
                        playGame(NextPlayerGame)
                )).

isGameOver(Game) :-
        getBoard(Game, Board),
        getCurrentPlayer(Game, CurrentPlayer),
        
        %check is current player still has any piece
        countPlayerPieces(Board, CurrentPlayer, CountPieces),
        !,
        ifelse(CountPieces = 0,
                true,
                (
                        countMovesAvailableAllPieces(Game, CountMoves),
                        !,
                        ifelse(CountMoves = 0,
                                true,
                                fail
                        )
                )
        ).

gameOver(Winner) :-

        nl, write('And the Winner is...'), nl, nl, 

        displayPlayerTurn(Winner),
        nl, write('Bye').




playerTurn(Game, NewGame) :- 
        displayGame(Game),

        %do playerMove while not validateMove:
        repeat,
        (        
                playerMove(Game, RowSrc, ColSrc, Path)
        ),
        validateMove(Game, RowSrc, ColSrc, Path, PieceCaptured),
        !,

        movePiece(Game, RowSrc, ColSrc, Path, NewGame1),

        (
                PieceCaptured = barragoonPiece -> barragoonCaptured(NewGame1,NewGame);               
                PieceCaptured = playerPiece -> playerPieceCaptured(NewGame1, NewGame);
                PieceCaptured = empty -> NewGame = NewGame1
        ).


playerMove(Game, RowSrc, ColSrc, Path) :-
        %do chooseTile while not validateTile:
        repeat,
        (
        chooseTile(RowSrc, ColSrc, 'Which tile would you like to move?')
        ),

        validateTile(Game, RowSrc, ColSrc),
        !,

        %do choosePath while not validatePath:
        repeat,
        (
        choosePath(Path, 'Please insert the path that you want that piece to follow:\n(Use WASD - eg. wwwd + Enter).')
        ),

        validatePath(RowSrc, ColSrc, Path),
        !.


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
movePiece(Game, RowSrc, ColSrc, Path, NewGame) :-
        getBoard(Game, GameBoard),

        getDestCellFromPath(RowSrc, ColSrc, Path, RowDest, ColDest),
        moveFromSrcToDest(GameBoard,RowSrc,ColSrc,RowDest,ColDest,NewGameBoard),

        setBoard(Game, NewGameBoard, NewGame).

moveFromSrcToDest(GameBoard, RowSrc, ColSrc, RowDest, ColDest, NewGameBoard) :-
        clearCell(GameBoard,  RowSrc,  ColSrc,  Value, NewGameBoard1),
        setCell(NewGameBoard1,RowDest, ColDest, Value, NewGameBoard).

% --- Check if it is a short move ---
%isShortMove(+Piece, +Path)
isShortMove(_Player-NDots, Path) :-
        length(Path, N),

        N1 is N+1,
        N1 == NDots.

% --- Check if it is a long move ---
%isFullMove(+Piece, +Path)
isFullMove(_Player-NDots, Path) :-
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
isBarragoon(Board, Row, Collumn, PlaceBarragoon) :-
        getCell(Board, Row, Collumn, Piece),
        validBarragoons(Barragoons),
        ifelse(member(Piece,Barragoons), PlaceBarragoon is 0, PlaceBarragoon is 1).

% -------------------------------------------------------------------------
% ---------------------------- MOVEMENT RULES -----------------------------
% -------------------------------------------------------------------------

% --- Check if it is a valid path ---
validatePathValues([]).
validatePathValues([H|T]) :- 
        member(H,['w','a','s','d']), 
        validatePathValues(T).

validatePath(RowSrc, ColSrc, Path) :-
        validatePath(RowSrc, ColSrc, Path, true).

validatePath(RowSrc, ColSrc, Path, _) :-
        %verify if it ends inside the board
        getDestCellFromPath(RowSrc, ColSrc, Path, RowDest, ColDest),
        RowDest < 9, RowDest >= 0,
        ColDest < 9, ColDest >= 0,

        %verify if it turns just once
        verifyTurnsOnce(Path).

validatePath(_, _, _, ErrorMessageFlag) :-
        (ErrorMessageFlag -> (
                write('That path is not valid!'), nl,
                write('Please, try another path.'), nl
        ); true),
        fail. 
%go_back to repeat cycle


validateMove(Game, RowSrc, ColSrc, Path, PieceCaptured) :-
        validateMove(Game, RowSrc, ColSrc, Path, PieceCaptured, true).
        

validateMove(Game, RowSrc, ColSrc, Path, PieceCaptured, ErrorMessageFlag) :- 
        getBoard(Game, Board), 

        getCell(Board, RowSrc,ColSrc, Piece),
        (
                isShortMove(Piece, Path) -> IsFullMove is 0;
                isFullMove(Piece, Path) -> IsFullMove is 1;

                (ErrorMessageFlag -> write('Invalid number of movimentations.\nPlease introduce another move\n\n'); true),
                fail
        ),

        validateCrossMovements(Game, RowSrc, ColSrc, Path, IsFullMove, Piece, PieceCaptured, ErrorMessageFlag).     


%validateCrossMovements -> verify capture issues.
validateCrossMovements(Game, RowSrc, ColSrc, [LastMove], IsFullMove, PieceMoved, PieceCaptured, ErrorMessageFlag) :-
        getBoard(Game, Board),
        getCurrentPlayer(Game, CurrentPlayer),

        getDestCellFromPath(RowSrc,ColSrc,[LastMove], RowDest, ColDest),
        getCell(Board, RowDest, ColDest, Piece),

        
        ifelse(Piece = 'empty',
                emptyTile(PieceCaptured),
                ifelse(Piece = bg-BgType,
                        ifelse(IsFullMove == 1,
                                ifelse((PieceMoved = _P-2, BgType = 'allDir'),
                                        ((ErrorMessageFlag -> write('You cannot capture an All Directions Barragoon piece with a Two Dotted Tile.\n\n'); true), fail),
                                        true),
                                ((ErrorMessageFlag -> write('You cannot capture a piece during a short move.\n\n'); true), fail)),
                        ifelse(Piece = CurrentPlayer-_,
                                ((ErrorMessageFlag -> write('You may not capture your own piece.\n\n'); true), fail),
                                playerPieceCaptured(PieceCaptured)))).

%validateCrossMovements -> verify cross issues.
validateCrossMovements(Game, RowSrc, ColSrc, [FirstMove, SecondMove | PathRest], IsFullMove, PieceMoved,PieceCaptured, ErrorMessageFlag) :-
        getBoard(Game, Board), 

        getDestCellFromPath(RowSrc,ColSrc,[FirstMove], RowDest1, ColDest1),
        getDestCellFromPath(RowDest1,ColDest1,[SecondMove], RowDest2, ColDest2),

        getCell(Board, RowDest1, ColDest1, Piece1),


        ifelse(Piece1 = bg-BgType,
                verifyBarragoonCrossability(RowSrc,ColSrc,RowDest1,ColDest1,RowDest2,ColDest2,BgType,ErrorMessageFlag),
                ifelse(Piece1 = 'empty',
                        true,
                        ((ErrorMessageFlag -> write('You cannot cross any player piece.\n\n'); true), fail))),
                        
        validateCrossMovements(Game, RowDest1, ColDest1, [SecondMove | PathRest], IsFullMove, PieceMoved, PieceCaptured, ErrorMessageFlag).




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

% --- Verify crossability for each barragoon piece ---
verifyBarragoonCrossability(RowSrc,ColSrc,RowBg,ColBg,RowDest,ColDest,BgType,ErrorMessageFlag):-
        (
                BgType = 'barraX' -> (
                        (ErrorMessageFlag -> (nl, write('You cannot cross an X barragoon piece.', nl, nl )); true),
                        fail
                );

                BgType = 'allDir' -> (
                        (
                                RowSrc \= RowDest,
                                ColSrc \= ColDest
                        );

                        (ErrorMessageFlag -> (nl, write('You are crossing an All Direction Barragoon in a wrong way.'), nl, nl); true),
                        fail
                );

                %One direction
                BgType = 'oDirU' -> (
                        (
                                RowSrc2 is RowSrc-2,
                                RowSrc2 = RowDest,
                                ColSrc = ColDest
                        );
                        (ErrorMessageFlag -> (nl, write('You are crossing a Single Direction Barragoon in a wrong way.'), nl, nl); true),
                        fail
                );
                BgType = 'oDirD' -> (
                        (
                                RowSrc2 is RowSrc+2,
                                RowSrc2 = RowDest,
                                ColSrc = ColDest
                        );
                        (ErrorMessageFlag -> (nl, write('You are crossing a Single Direction Barragoon in a wrong way.'), nl, nl); true),
                        fail
                );
                BgType = 'oDirR' -> (
                        (
                                ColSrc2 is ColSrc+2,
                                ColSrc2 = ColDest,
                                RowSrc = RowDest
                        );
                        (ErrorMessageFlag -> (nl, write('You are crossing a Single Direction Barragoon in a wrong way.'), nl, nl); true),
                        fail
                );
                BgType = 'oDirL' -> (
                        (
                                ColSrc2 is ColSrc-2,
                                ColSrc2 = ColDest,
                                RowSrc = RowDest
                        );
                        (ErrorMessageFlag -> (nl, write('You are crossing a Single Direction Barragoon in a wrong way.'), nl, nl); true),
                        fail
                );

                %Two directions
                BgType = 'tDirH' -> (
                        (
                                (
                                        ColSrc2 is ColSrc-2,
                                        ColSrc2 = ColDest,
                                        RowSrc = RowDest
                                );
                                (
                                        ColSrc2 is ColSrc+2,
                                        ColSrc2 = ColDest,
                                        RowSrc = RowDest
                                )
                        );
                        (ErrorMessageFlag -> (nl, write('You are crossing a Double Direction Barragoon in a wrong way.'), nl, nl); true),
                        fail
                );
                BgType = 'tDirV' -> (
                        (
                                (
                                        RowSrc2 is RowSrc-2,
                                        RowSrc2 = RowDest,
                                        ColSrc = ColDest
                                );
                                (
                                        RowSrc2 is RowSrc+2,
                                        RowSrc2 = RowDest,
                                        ColSrc = ColDest
                                )
                        );
                        (ErrorMessageFlag -> (nl, write('You are crossing a Double Direction Barragoon in a wrong way.'), nl, nl); true),
                        fail
                );

                %Turn to right
                BgType = 'DtoR' -> (
                        (
                              RowSrcU is RowSrc-1,
                              RowBg = RowSrcU,

                              ColBgR is ColBg+1,
                              ColDest = ColBgR
                        );
                        (ErrorMessageFlag -> (nl, write('You are crossing a Right Turn Barragoon in a wrong way.'), nl, nl); true),
                        fail
                );
                BgType = 'RtoU' -> (
                        (
                              ColSrcL is ColSrc-1,
                              ColBg = ColSrcL,

                              RowBgU is RowBg-1,
                              RowDest = RowBgU
                        );
                        (ErrorMessageFlag -> (nl, write('You are crossing a Right Turn Barragoon in a wrong way.'), nl, nl); true),
                        fail
                );
                BgType = 'UtoL' -> (
                        (
                              RowSrcD is RowSrc+1,
                              RowBg = RowSrcD,

                              ColBgL is ColBg-1,
                              ColDest = ColBgL
                        );
                        (ErrorMessageFlag -> (nl, write('You are crossing a Right Turn Barragoon in a wrong way.'), nl, nl); true),
                        fail
                );
                BgType = 'LtoD' -> (
                        (
                              ColSrcR is ColSrc+1,
                              ColBg = ColSrcR,

                              RowBgD is RowBg+1,
                              RowDest = RowBgD
                        );
                        (ErrorMessageFlag -> (nl, write('You are crossing a Right Turn Barragoon in a wrong way.'), nl, nl); true),
                        fail
                );

                %Turn to left
                BgType = 'DtoL' -> (
                        (
                              RowSrcU is RowSrc-1,
                              RowBg = RowSrcU,

                              ColBgL is ColBg-1,
                              ColDest = ColBgL
                        );
                        (ErrorMessageFlag -> (nl, write('You are crossing a Left Turn Barragoon in a wrong way.'), nl, nl); true),
                        fail
                );
                BgType = 'LtoU' -> (
                        (
                              ColSrcR is ColSrc+1,
                              ColBg = ColSrcR,

                              RowBgU is RowBg-1,
                              RowDest = RowBgU
                        );
                        (ErrorMessageFlag -> (nl, write('You are crossing a Left Turn Barragoon in a wrong way.'), nl, nl); true),
                        fail
                );
                BgType = 'UtoR' -> (
                        (
                              RowSrcD is RowSrc+1,
                              RowBg = RowSrcD,

                              ColBgR is ColBg+1,
                              ColDest = ColBgR
                        );
                        (ErrorMessageFlag -> (nl, write('You are crossing a Left Turn Barragoon in a wrong way.'), nl, nl); true),
                        fail
                );
                BgType = 'RtoD' -> (
                        (
                              ColSrcL is ColSrc-1,
                              ColBg = ColSrcL,

                              RowBgD is RowBg+1,
                              RowDest = RowBgD
                        );
                        (ErrorMessageFlag -> (nl, write('You are crossing a Left Turn Barragoon in a wrong way.'), nl, nl); true),
                        fail
                )
        ).

% -------------------------------------------------------------------------
% ----------------------------- CONSEQUENCES ------------------------------
% ------------------------------------------------------------------------- 

% --- When a barragoon is captured ---
barragoonCaptured(Game, NewGame) :-      
        insertBarragoon(Game, NewGame).

% --- When a player piece is captured ---
playerPieceCaptured(Game, NewGame) :-      
        insertBarragoon(Game, FirstBarragoonAddedGame),

        switchPlayer(FirstBarragoonAddedGame, NextPlayerGame),
        insertBarragoon(NextPlayerGame, SecondBarragoonAddedGame),
        
        switchPlayer(SecondBarragoonAddedGame,NewGame).

% --- Insert new barragoon ---
insertBarragoon(Game, NewGame) :-
        getBoard(Game, Board),

        displayGame(Game),

        chooseTile(Row, Collumn, 'Where do you wish to place your barragoon?'),
        write('Which barragoon do you wish to insert?'),nl,
        write('The options are:'),nl,
        write( '1-  X'),nl,
        write('2-  + (All Directions)'),nl,
        write('3-  => (One Direction)'),nl,
        write('4-  <=> (Two Directions)'),nl,
        write('5-  \'> (Left Turn)'),nl,
        write('6-  <\' (Right Turn)'),nl,
        getCharThenEnter(Option),
        (
           Option = '1' -> setCell(Board, Row, Collumn, bg-'barraX', NewBoard);
           Option = '2' -> setCell(Board, Row, Collumn, bg-'allDir', NewBoard);
           Option = '3' -> insertOneDirectionBg(Board, Row, Collumn, NewBoard);
           Option = '4' -> insertTwoDirectionsBg(Board, Row, Collumn, NewBoard);
           Option = '5' -> insertTurnToTheLeft(Board, Row, Collumn, NewBoard);
           Option = '6' -> insertTurnToTheRight(Board, Row, Collumn, NewBoard)
        ),
        
        setBoard(Game, NewBoard, NewGame).

insertOneDirectionBg(Board, Row, Collumn, NewBoard):-
        nl, write('In which diretion you want to set the barragoon?'),nl,
        write('The options are:'),nl,
        write( '1-  A (Up)'),nl,
        write('2-  V (Down)'),nl,
        write('3-  => (Right)'),nl,
        write('4-  <= (Left)'),nl,
        getCharThenEnter(Option),
        (
                Option = '1' -> setCell(Board, Row, Collumn, bg-'oDirU', NewBoard);
                Option = '2' -> setCell(Board, Row, Collumn, bg-'oDirD', NewBoard);
                Option = '3' -> setCell(Board, Row, Collumn, bg-'oDirR', NewBoard);
                Option = '4' -> setCell(Board, Row, Collumn, bg-'oDirL', NewBoard)
        ).

insertTwoDirectionsBg(Board, Row, Collumn, NewBoard):-
        nl, write('In which diretion you want to set the barragoon?'),nl,
        write('The options are:'),nl,
        write( '1-  <> (Horizontal)'),nl,
        write('2-  I (Vertical)'),nl,
        getCharThenEnter(Option),
        (
                Option = '1' -> setCell(Board, Row, Collumn, bg-'tDirH', NewBoard);
                Option = '2' -> setCell(Board, Row, Collumn, bg-'tDirV', NewBoard)
        ).

insertTurnToTheLeft(Board, Row, Collumn, NewBoard):-
        nl, write('In which diretion you want to set the barragoon?'),nl,
        write('The options are:'),nl,
        write( '1-  <. (Down to Left)'),nl,
        write('2-  -^ (Left to Up)'),nl,
        write('3-  \'> (Up to Right)'),nl,
        write('4-  v- (Right to Down)'),nl,
        getCharThenEnter(Option),
        (
                Option = '1' -> setCell(Board, Row, Collumn, bg-'DtoL', NewBoard);
                Option = '2' -> setCell(Board, Row, Collumn, bg-'LtoU', NewBoard);
                Option = '3' -> setCell(Board, Row, Collumn, bg-'UtoR', NewBoard);
                Option = '4' -> setCell(Board, Row, Collumn, bg-'RtoD', NewBoard)
        ).

insertTurnToTheRight(Board, Row, Collumn, NewBoard):-
        nl, write('In which diretion you want to set the barragoon?'),nl,
        write('The options are:'),nl,
        write( '1-  .> (Down to Right)'),nl,
        write('2-  ^- (Right to Up)'),nl,
        write('3-  <\' (Up to Left)'),nl,
        write('4-  -v (Left to Down)'),nl,
        getCharThenEnter(Option),
        (
                Option = '1' -> setCell(Board, Row, Collumn, bg-'DtoR', NewBoard);
                Option = '2' -> setCell(Board, Row, Collumn, bg-'RtoU', NewBoard);
                Option = '3' -> setCell(Board, Row, Collumn, bg-'UtoL', NewBoard);
                Option = '4' -> setCell(Board, Row, Collumn, bg-'LtoD', NewBoard)
        ).


% --- Valid coordinates ---
validColumns(['a','b','c','d','e','f','g','A','B','C','D','E','F','G']).

validRow(Y):- Y > 48, Y < 60.

validBarragoons([bg-barraX, bg-allDir, bg-oDirU, bg-oDirD, bg-oDirL, bg-oDirR, bg-oDirH, bg-oDirV, bg-left, bg-right]).

complementary('w','s').
complementary('s','w').
complementary('a','d').
complementary('d','a').

barragoonCaptured(barragoonPiece).
playerPieceCaptured(playerPiece).
emptyTile(empty).

% --- Get Player Pieces ---

getPlayerPieces(Game, List):-

        getBoard(Game, Board),
        getCurrentPlayer(Game, Player),

        getPlayerPiecesAux(Board, Player, 0, 0, List).

getPlayerPiecesAux(_,_,9,_,[]).
getPlayerPiecesAux(Board,CurrentPlayer,Row,7,List) :-
        Row1 is Row+1,
        getPlayerPiecesAux(Board,CurrentPlayer,Row1,0,List).
getPlayerPiecesAux(Board, CurrentPlayer, Row, Column, List) :-

        Column1 is Column+1,

        ifelse( getCell(Board, Row, Column, CurrentPlayer-_),
                (
                        getPlayerPiecesAux(Board, CurrentPlayer, Row, Column1, List1),
                        List = [[Row, Column] | List1]
                ),
                getPlayerPiecesAux(Board, CurrentPlayer, Row, Column1, List)
        ).


% --- Count player pieces ---

countPlayerPieces([], _, 0).
countPlayerPieces([[] | BoardRest], CurrentPlayer, Count) :-
        countPlayerPieces(BoardRest, CurrentPlayer, Count).

countPlayerPieces([[CurrentPlayer-_ | RowRest] | BoardRest], CurrentPlayer, Count) :-
        countPlayerPieces([RowRest | BoardRest], CurrentPlayer, N), 
        Count is N+1 .

countPlayerPieces([[_Piece | RowRest] | BoardRest], CurrentPlayer, Count) :-
        countPlayerPieces([RowRest | BoardRest], CurrentPlayer, Count).


% --- Count Moves Available ---

countMovesAvailable(Game, Row, Column, Count) :-
        getBoard(Game, Board),

        getCell(Board, Row, Column, _Player-NDots),
        availableMoves(NDots, AllMovesAvailable),

        countMovesAvailableAux(Game, Row, Column, AllMovesAvailable, Count).

countMovesAvailableAux(_,_,_,[],0).
countMovesAvailableAux(Game, Row, Column, [Path | Tail], Count) :-
        ifelse( (validatePath(Row, Column, Path, false), validateMove(Game, Row, Column, Path, _, false)),
                (
                        countMovesAvailableAux(Game, Row, Column, Tail, Count1),
                        Count is Count1+1
                ),
                (
                        countMovesAvailableAux(Game, Row, Column, Tail, Count)
                )
        ).

% --- Count Moves Available for All Pieces of Player ---
countMovesAvailableAllPieces(Game, Count) :- 
        
        getPlayerPieces(Game, PlayerPieces),
        
        countMovesAvailableAllPiecesAux(Game, PlayerPieces, Count).

countMovesAvailableAllPiecesAux(_, [], 0).
countMovesAvailableAllPiecesAux(Game, [[Row, Column] | RemainingPlayerPieces], Count):-
        countMovesAvailable(Game, Row, Column, Count1),
        countMovesAvailableAllPiecesAux(Game, RemainingPlayerPieces, Count2),
        Count is Count1+Count2.







