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