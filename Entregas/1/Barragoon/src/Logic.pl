%-------------------------------%
%-----------Game Logic----------%
%-------------------------------%

% -------------------------------------------------------------------------
% ----------------------------------- GAME  -------------------------------
% -------------------------------------------------------------------------

startGame(Mode):-
        initializeGame(Game, Mode),
        playGame(Game).

initializeGame(Game, Mode):-
        initialBoard(Board),
        Game = [Board, w, Mode], !.

% --- Game Loop ---
playGame(Game) :-
        ifelse(isGameOver(Game),
                (
                        switchPlayer(Game, EndGame),
                        gameOver(EndGame)
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

gameOver(Game) :-

        nl, write('And the Winner is...'), nl, nl, 
        displayGame(Game),
        nl, write('Bye').




playerTurn(Game, NewGame) :- 
        displayGame(Game),

        %do playerMove while not validateMove:

        getPlayerType(Game, PlayerType),
        repeat,
        (        
                PlayerType = player -> playerMove(Game, RowSrc, ColSrc, Path);
                PlayerType = bot -> botMove(Game, RowSrc, ColSrc, Path)
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

botMove(Game, Row, Column, Path):-

        repeat,
        (
                getPlayerPieces(Game, Pieces),

                getRandomElemFromList(Pieces, [Row, Column]),

                getMovesAvailable(Game, Row, Column, MovesAvailable)
        ),
        getRandomElemFromList(MovesAvailable, Path).
        


        




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

        getDestCellFromPath(RowSrc, ColSrc, Path, RowDest, ColDest),
        moveFromSrcToDest(Game,RowSrc,ColSrc,RowDest,ColDest,NewGame).

moveFromSrcToDest(Game, RowSrc, ColSrc, RowDest, ColDest, NewGame) :-
        clearCell(Game,  RowSrc,  ColSrc,  Value, NewGame1),
        setCell(NewGame1,RowDest, ColDest, Value, NewGame).

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

        getCurrentPlayer(Game, CurrentPlayer),

        getCell(Game, RowSrc, ColSrc, Piece),

        Piece = CurrentPlayer-_.

validateTile(_Game, _RowSrc, _ColSrc) :-
        write('There\'s not a movable piece in that position.'), nl,
        write('Please, try another position.'), nl,
        fail. 
%go_back to repeat cycle


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

        getCell(Game, RowSrc,ColSrc, Piece),
        (
                isShortMove(Piece, Path) -> IsFullMove is 0;
                isFullMove(Piece, Path) -> IsFullMove is 1;

                (ErrorMessageFlag -> write('Invalid number of movimentations.\nPlease introduce another move\n\n'); true),
                fail
        ),

        validateCrossMovements(Game, RowSrc, ColSrc, Path, IsFullMove, Piece, PieceCaptured, ErrorMessageFlag).     


%validateCrossMovements -> verify capture issues.
validateCrossMovements(Game, RowSrc, ColSrc, [LastMove], IsFullMove, PieceMoved, PieceCaptured, ErrorMessageFlag) :-
        getCurrentPlayer(Game, CurrentPlayer),

        getDestCellFromPath(RowSrc,ColSrc,[LastMove], RowDest, ColDest),
        getCell(Game, RowDest, ColDest, Piece),

        
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

        getDestCellFromPath(RowSrc,ColSrc,[FirstMove], RowDest1, ColDest1),
        getDestCellFromPath(RowDest1,ColDest1,[SecondMove], RowDest2, ColDest2),

        getCell(Game, RowDest1, ColDest1, Piece1),


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
        switchPlayer(Game, NewGame1),    
        insertBarragoon(NewGame1, FirstBarragoonAddedGame),

        switchPlayer(FirstBarragoonAddedGame,NewGame2),
        insertBarragoon(NewGame2, NewGame).
        
        

% --- Insert new barragoon ---
insertBarragoon(Game, NewGame) :-
        %displayGame(Game),
        
        getPlayerType(Game, PlayerType),
        repeat,
        (
                PlayerType = player -> chooseTile(Row, Column, 'Where do you wish to place your barragoon?');
                PlayerType = bot -> botChooseTile(Game, Row, Column)
        ),
        getCell(Game, Row, Column, empty),
        !,
        

        write('Which barragoon do you wish to insert?'),nl,
        write('The options are:'),nl,
        write( '1-  X'),nl,
        write('2-  + (All Directions)'),nl,
        write('3-  => (One Direction)'),nl,
        write('4-  <=> (Two Directions)'),nl,
        write('5-  \'> (Left Turn)'),nl,
        write('6-  <\' (Right Turn)'),nl,
        getPlayerType(Game, PlayerType),
        (
                PlayerType = player -> getCharThenEnter(Option);
                PlayerType = bot -> (
                        random(1,7, OptionInt), 
                        numbersAxis(Numbers), 
                        nth1(OptionInt, Numbers, Option)
                )
        ),
        (
           Option = '1' -> setCell(Game, Row, Column, bg-'barraX', NewGame);
           Option = '2' -> setCell(Game, Row, Column, bg-'allDir', NewGame);
           Option = '3' -> insertOneDirectionBg(Game, Row, Column, NewGame);
           Option = '4' -> insertTwoDirectionsBg(Game, Row, Column, NewGame);
           Option = '5' -> insertTurnToTheLeft(Game, Row, Column, NewGame);
           Option = '6' -> insertTurnToTheRight(Game, Row, Column, NewGame)
        ).

insertOneDirectionBg(Game, Row, Column, NewGame):-
        nl, write('In which diretion you want to set the barragoon?'),nl,
        write('The options are:'),nl,
        write( '1-  A (Up)'),nl,
        write('2-  V (Down)'),nl,
        write('3-  => (Right)'),nl,
        write('4-  <= (Left)'),nl,

        getPlayerType(Game, PlayerType),
        (
                PlayerType = player -> getCharThenEnter(Option);
                PlayerType = bot -> (
                        random(1,5, OptionInt), 
                        numbersAxis(Numbers), 
                        nth1(OptionInt, Numbers, Option)
                )
        ),        
        (
                Option = '1' -> setCell(Game, Row, Column, bg-'oDirU', NewGame);
                Option = '2' -> setCell(Game, Row, Column, bg-'oDirD', NewGame);
                Option = '3' -> setCell(Game, Row, Column, bg-'oDirR', NewGame);
                Option = '4' -> setCell(Game, Row, Column, bg-'oDirL', NewGame)
        ).

insertTwoDirectionsBg(Game, Row, Column, NewGame):-
        nl, write('In which diretion you want to set the barragoon?'),nl,
        write('The options are:'),nl,
        write( '1-  <> (Horizontal)'),nl,
        write('2-  I (Vertical)'),nl,
        getPlayerType(Game, PlayerType),
        (
                PlayerType = player -> getCharThenEnter(Option);
                PlayerType = bot -> (
                        random(1,3, OptionInt), 
                        numbersAxis(Numbers), 
                        nth1(OptionInt, Numbers, Option)
                )
        ),        
        (
                Option = '1' -> setCell(Game, Row, Column, bg-'tDirH', NewGame);
                Option = '2' -> setCell(Game, Row, Column, bg-'tDirV', NewGame)
        ).

insertTurnToTheLeft(Game, Row, Column, NewGame):-
        nl, write('In which diretion you want to set the barragoon?'),nl,
        write('The options are:'),nl,
        write('1-  <. (Down to Left)'),nl,
        write('2-  -^ (Left to Up)'),nl,
        write('3-  \'> (Up to Right)'),nl,
        write('4-  v- (Right to Down)'),nl,
        getPlayerType(Game, PlayerType),
        (
                PlayerType = player -> getCharThenEnter(Option);
                PlayerType = bot -> (
                        random(1,5, OptionInt), 
                        numbersAxis(Numbers), 
                        nth1(OptionInt, Numbers, Option)
                )
        ),        
        (
                Option = '1' -> setCell(Game, Row, Column, bg-'DtoL', NewGame);
                Option = '2' -> setCell(Game, Row, Column, bg-'LtoU', NewGame);
                Option = '3' -> setCell(Game, Row, Column, bg-'UtoR', NewGame);
                Option = '4' -> setCell(Game, Row, Column, bg-'RtoD', NewGame)
        ).

insertTurnToTheRight(Game, Row, Column, NewGame):-
        nl, write('In which diretion you want to set the barragoon?'),nl,
        write('The options are:'),nl,
        write( '1-  .> (Down to Right)'),nl,
        write('2-  ^- (Right to Up)'),nl,
        write('3-  <\' (Up to Left)'),nl,
        write('4-  -v (Left to Down)'),nl,
        getPlayerType(Game, PlayerType),
        (
                PlayerType = player -> getCharThenEnter(Option);
                PlayerType = bot -> (
                        random(1,5, OptionInt), 
                        numbersAxis(Numbers), 
                        nth1(OptionInt, Numbers, Option)
                )
        ),        
        (
                Option = '1' -> setCell(Game, Row, Column, bg-'DtoR', NewGame);
                Option = '2' -> setCell(Game, Row, Column, bg-'RtoU', NewGame);
                Option = '3' -> setCell(Game, Row, Column, bg-'UtoL', NewGame);
                Option = '4' -> setCell(Game, Row, Column, bg-'LtoD', NewGame)
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

        getCurrentPlayer(Game, Player),

        getPlayerPiecesAux(Game, Player, 0, 0, List).

getPlayerPiecesAux(_,_,9,_,[]).
getPlayerPiecesAux(Game,CurrentPlayer,Row,7,List) :-
        Row1 is Row+1,
        getPlayerPiecesAux(Game,CurrentPlayer,Row1,0,List).
getPlayerPiecesAux(Game, CurrentPlayer, Row, Column, List) :-

        Column1 is Column+1,

        ifelse( getCell(Game, Row, Column, CurrentPlayer-_),
                (
                        getPlayerPiecesAux(Game, CurrentPlayer, Row, Column1, List1),
                        List = [[Row, Column] | List1]
                ),
                getPlayerPiecesAux(Game, CurrentPlayer, Row, Column1, List)
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

countMovesAvailable(Game, Row, Column, Count):-
        getMovesAvailable(Game, Row, Column, List),
        length(List, Count).



getMovesAvailable(Game, Row, Column, List) :-

        getCell(Game, Row, Column, _Player-NDots),
        availableMoves(NDots, AllMovesAvailable),

        getMovesAvailableAux(Game, Row, Column, AllMovesAvailable, List).

getMovesAvailableAux(_,_,_,[],[]).
getMovesAvailableAux(Game, Row, Column, [Path | Tail], List) :-
        ifelse( (validatePath(Row, Column, Path, false), validateMove(Game, Row, Column, Path, _, false)),
                (
                        getMovesAvailableAux(Game, Row, Column, Tail, List1),
                        List = [Path | List1]
                ),
                (
                        getMovesAvailableAux(Game, Row, Column, Tail, List)
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







