%-------------------------------%
%--------Useful functions-------%
%-------------------------------%

spacing(Lines) :-
        spacing(0, Lines).
spacing(Line, Limit) :-
        Line < Limit,
        LineInc is Line + 1,
        nl,
        spacing(LineInc, Limit).
spacing(_,_).

next :-
        write('Press any key to continue...'),
        get_code(_), clearScreen.

clearScreen :- spacing(50), !.

getCharThenEnter(CharInput) :-
        get_char(CharInput),
        get_char(_). 

getMatrixElemAt(0, ElemCol, [ListAtTheHead|_], Elem):-
        getListElemAt(ElemCol, ListAtTheHead, Elem).
getMatrixElemAt(ElemRow, ElemCol, [_|RemainingLists], Elem):-
        ElemRow > 0,
        ElemRow1 is ElemRow-1,
        getMatrixElemAt(ElemRow1, ElemCol, RemainingLists, Elem).

getListElemAt(0, [ElemAtTheHead|_], ElemAtTheHead).
getListElemAt(Pos, [_|RemainingElems], Elem):-
        Pos > 0,
        Pos1 is Pos-1,
        getListElemAt(Pos1, RemainingElems, Elem).

setMatrixElemAtWith(0, ElemCol, NewElem, [RowAtTheHead|RemainingRows], [NewRowAtTheHead|RemainingRows]):-
        setListElemAtWith(ElemCol, NewElem, RowAtTheHead, NewRowAtTheHead).
setMatrixElemAtWith(ElemRow, ElemCol, NewElem, [RowAtTheHead|RemainingRows], [RowAtTheHead|ResultRemainingRows]):-
        ElemRow > 0,
        ElemRow1 is ElemRow-1,
        setMatrixElemAtWith(ElemRow1, ElemCol, NewElem, RemainingRows, ResultRemainingRows).

setListElemAtWith(0, Elem, [_|L], [Elem|L]).
setListElemAtWith(I, Elem, [H|L], [H|ResL]):-
        I > 0,
        I1 is I-1,
        setListElemAtWith(I1, Elem, L, ResL).

move(Player, Board, X, Y, NewBoard) :-
  nth0(X, Board, Row, T1),
  nth0(Y, Row, ' ', T2),
  nth0(Y, NewRow, Player, T2),
  nth0(X, NewBoard, NewRow, T1).

%===============================================%
%=============   Codigo novo   =================%
%===============================================%


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