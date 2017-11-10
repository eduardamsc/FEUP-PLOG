
:- use_module(library(lists)).

%-------------------------------%
%--------Useful functions-------%
%-------------------------------%

% --- VISUALIZATION ---
spacing(Lines) :-
        spacing(0, Lines).
spacing(Line, Limit) :-
        Line < Limit,
        LineInc is Line + 1,
        nl,
        spacing(LineInc, Limit).
spacing(_,_).

clearScreen :- spacing(50), !.




% --- RECEIVE INPUT ---
next :-
        write('Press any key to continue...'),
        get_code(_), clearScreen.

getCharThenEnter(X) :-
        get_char(X),
        get_char(_), !. 

getCodeThenEnter(X) :-
        get_code(X),
        get_char(_), !.


%readCharFromUser(-X, +Possibilities, +Message, +Error)
readCharFromUser(X, Possibilities, Message, Error) :- 
        write(Message),
        getCharThenEnter(X),
        member(X, Possibilities).

readCharFromUser(X, Possibilities, Message, Error) :- 
        !,
        write(Error),
        readCharFromUser(X, Possibilities, Message, Error).

%readCodeFromUser(-X, +Condition, +Message, +Error)
readCodeFromUser(X, Condition, Message, Error) :- 

        write(Message),
        getCodeThenEnter(X),
        
        Condition.

readCodeFromUser(X, Condition, Message, Error) :- 

        !,
        write(Error),
        readCodeFromUser(X, Condition, Message, Error).





getPositionFromUser(Row, Column) :-
        readCodeFromUser(Row, validRow(Row), 'Row: ', 'Invalid Row! Rows must be between 1 and 9.\n'),
        !,
        validColumns(ValidCols),
        readCharFromUser(Column, ValidCols, 'Column: ', 'Invalid Column! Columns must be between A and G.\n').

        

% --- CHECK IF POSITION IS VALID ---
validColumns(['a','b','c','d','e','f','g','A','B','C','D','E','F','G']).

validRow(Y):-
    Y > 48, Y < 60.



% --- OTHERS ---

%replaceInList(+List,+Index,+Value,-NewList).
replaceInList([_|T], 0, X, [X|T]).
replaceInList([H|T], I, X, [H|R]):- I > -1, NI is I-1, replaceInList(T, NI, X, R), !.
replaceInList(L, _, _, L).

%clearCell(+Board, +NRow, +NColumn, -Value, -NewBoard)
clearCell(Board, NRow, NColumn, Value, NewBoard) :-
        /*Get Value*/
        nth0(NRow, Board, Row),
        nth0(NColumn, Row, Value),

        /*Clear cell*/
        replaceInList(Row, NColumn, empty, NewRow),
        replaceInList(Board, NRow, NewRow, NewBoard).

%setCell(+Board, +NRow, +NColumn, +Value, -NewBoard)
setCell(Board, NRow, NColumn, Value, NewBoard) :-
        nth0(NRow, Board, Row),

        /*Set cell with Value*/
        replaceInList(Row, NColumn, Value, NewRow),
        replaceInList(Board, NRow, NewRow, NewBoard).


ifelse(Condition, If, _Else) :- Condition, !, If.
ifelse(_, _, Else) :- Else.

not(X) :- X, !, fail.
not(_X).
