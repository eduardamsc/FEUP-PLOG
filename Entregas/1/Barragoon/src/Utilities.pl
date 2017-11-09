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
        get_char(_). 

getPosition(X, Y) :-
        get_char(X),
        get_code(Y),
        get_char(_),
        
        isCollumn(X),
        write(X),
        isLine(Y).
       % -- (   Y < 49 -> write('Line can\'t be inferior to 1!');
          % --  Y > 60 -> write('Line can\'t be over 9!');
           % -- write('Valid line!')
              % ---     ).

% --- CHECK IF POSITION IS VALID ---
isCollumn(X):-
    member(X, "abcdefgABCDEFG").

isLine(Y):-
    Y > 49, Y < 60.



% --- OTHERS ---

% replace(+List,+Index,+Value,-NewList).
replaceInList([_|T], 0, X, [X|T]).
replaceInList([H|T], I, X, [H|R]):- I > -1, NI is I-1, replaceInList(T, NI, X, R), !.
replaceInList(L, _, _, L).

clearCell(Board, NRow, NColumn, Value, NewBoard) :-
  nth0(NRow, Board, Row),
  nth1(NColumn, Row, Value),
  
  replaceInList(Row, NColumn, empty, NewRow),
  replaceInList(Board, NRow, NewRow, NewBoard).

setCell(Board, NRow, NColumn, Value, NewBoard) :-
  nth0(NRow, Board, Row),
  
  replaceInList(Row, NColumn, Value, NewRow),
  replaceInList(Board, NRow, NewRow, NewBoard).
