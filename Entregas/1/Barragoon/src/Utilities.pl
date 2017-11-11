:- use_module(library(lists)).
%-------------------------------%
%--------Useful functions-------%
%-------------------------------%

% -------------------------------------------------------------------------
% ----------------------------- VISUALIZATION -----------------------------
% -------------------------------------------------------------------------

% -- Visualization --
spacing(Lines) :-
        spacing(0, Lines).
spacing(Line, Limit) :-
        Line < Limit,
        LineInc is Line + 1,
        nl,
        spacing(LineInc, Limit).
spacing(_,_).

clearScreen :- spacing(50), !.


% -------------------------------------------------------------------------
% ----------------------------- RECEIVE INPUT -----------------------------
% -------------------------------------------------------------------------

% --- Receive input ---
next :-
        write('Press any key to continue...'),
        get_code(_), clearScreen.

getCharThenEnter(X) :-
        get_char(X),
        get_char(_), !. 

getCodeThenEnter(X) :-
        get_code(X),
        get_char(_), !.

% --- Get collumns and rows ---
readCharFromUser(X, Possibilities, Message, _Error) :- 
        write(Message),
        getCharThenEnter(X),
        member(X, Possibilities).
readCharFromUser(X, Possibilities, Message, Error) :- 
        !,
        write(Error),
        readCharFromUser(X, Possibilities, Message, Error).

readCodeFromUser(X, Condition, Message, _Error) :- 
        write(Message),
        getCodeThenEnter(X),
        Condition.
readCodeFromUser(X, Condition, Message, Error) :- 
        !,
        write(Error),
        readCodeFromUser(X, Condition, Message, Error).

% --- Get position ---
getPositionFromUser(Row, Column) :-
        readCodeFromUser(Row, validRow(Row), 'Row: ', 'Invalid Row! Rows must be between 1 and 9.\n'),
        !,
        validColumns(ValidCols),
        readCharFromUser(Column, ValidCols, 'Column: ', 'Invalid Column! Columns must be between A and G.\n'),
        !.

chooseTile(Row, Column, Message) :-
        write(Message), nl,
        getPositionFromUser(RowCode, ColumnChar),
        validColumns(Possibilities),

        nth0(ColPosInPossibilities, Possibilities, ColumnChar),
        Column is ColPosInPossibilities mod 7,
        Row is RowCode-49.

choosePath(Path, Message) :- 
        write(Message), nl,
        readCharUntilEnter(Path),

        validatePathValues(Path),
        write(Path).


validatePathValues([]).
validatePathValues([H|T]) :- 
        member(H,['w','a','s','d']), 
        validatePathValues(T).

readCharUntilEnter(List) :- 
        get_char(Char),
        readCharAux([Char|Tail],Char),
        List = [Char|Tail].

readCharUntilEnterAux([],'\n').
readCharUntilEnterAux([Char|Tail], Char) :-
        get_char(NewChar),
        readCharAuxUntilEnter(Tail,NewChar).
        

% -------------------------------------------------------------------------
% ----------------------------- CONDITIONS --------------------------------
% -------------------------------------------------------------------------

% --- operators ---
ifelse(Condition, If, _Else) :- Condition, !, If.
ifelse(_, _, Else) :- Else.

not(X) :- X, !, fail.
not(_X).

% -------------------------------------------------------------------------
% ----------------------------- READ BOARD --------------------------------
% -------------------------------------------------------------------------

% --- Get cell value ---
getCell(Board, Row, Column, Value) :-
        nth0(Row,Board,RowList),
        nth0(Column,RowList,Value).

% --- Get board ---
getBoard(Game, GameBoard):-
        nth0(0, Game, GameBoard).

% --- Get player ---
getCurrentPlayer(Game, CurrentPlayer):-
        nth0(1, Game, CurrentPlayer).

% --- Get game mode ---
getGameMode(Game, Mode):-
        nth0(2, Game, Mode).

% -------------------------------------------------------------------------
% ---------------------------- CHANGE BOARD -------------------------------
% -------------------------------------------------------------------------

% --- Replace ---
replaceInList([_|T], 0, X, [X|T]).
replaceInList([H|T], I, X, [H|R]):- I > -1, NI is I-1, replaceInList(T, NI, X, R), !.
replaceInList(L, _, _, L).

% --- Clear a cell ---
clearCell(Board, NRow, NColumn, Value, NewBoard) :-
        /*Get Value*/
        nth0(NRow, Board, Row),
        nth0(NColumn, Row, Value),
        /*Clear cell*/
        replaceInList(Row, NColumn, empty, NewRow),
        replaceInList(Board, NRow, NewRow, NewBoard).

% --- Change cell value ---
setCell(Board, NRow, NColumn, Value, NewBoard) :-
        nth0(NRow, Board, Row),
        /*Set cell with Value*/
        replaceInList(Row, NColumn, Value, NewRow),
        replaceInList(Board, NRow, NewRow, NewBoard).

% --- Change board ---
setBoard(Game, NewBoard, NewGame):-
        replaceInList(Game, 0, NewBoard, NewGame).

% --- Change player ---
switchPlayer(Game, NextPlayerGame):-
        getBoard(Game, Board),
        getCurrentPlayer(Game, CurrentPlayer),
        getGameMode(Game, Mode),
        ifelse( CurrentPlayer == w ,
                NextPlayer = b,
                NextPlayer = w),
        NextPlayerGame = [Board, NextPlayer, Mode].

complementary('w','s').
complementary('s','w').
complementary('a','d').
complementary('d','a').
