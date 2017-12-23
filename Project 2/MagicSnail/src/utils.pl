
fillListWithValue([], _, 0):-!.
fillListWithValue([Value|Rest], Value, N) :- N1 is N-1, fillListWithValue(Rest, Value, N1).

fillListIndexEqualsValue(0, []):-!.
fillListIndexEqualsValue(N, List):-
    N1 is N-1,
    fillListIndexEqualsValue(N1,ListRest),
    append(ListRest,[N],List).


takeFirstNElemsFromList(N, List, Partial) :-
    takeFirstNElemsFromList(N, List, Partial,0).

takeFirstNElemsFromList(Count, _, [],Count).
takeFirstNElemsFromList(N, [Value|Rest], Partial,Count) :-
    Count1 is Count+1,
    takeFirstNElemsFromList(N, Rest, Partial1,Count1),

    append([Value], Partial1, Partial).
    


takeColumnElemsFromList(_,_,[],[]):-!.
takeColumnElemsFromList(NColumn, BoardLength, List, Result):-
    takeFirstNElemsFromList(BoardLength, List, FirstElems),
    append(FirstElems,Rest,List),

    takeColumnElemsFromList(NColumn, BoardLength, Rest, Result1),

    nth1(NColumn, FirstElems, Value),
    append([Value], Result1, Result).

listToMatrix([], _, []).
listToMatrix(List, Size, [Row|Matrix]):-
  listToMatrixRow(List, Size, Row, Tail),
  listToMatrix(Tail, Size, Matrix).

listToMatrixRow(Tail, 0, [], Tail).
listToMatrixRow([Item|List], Size, [Item|Row], Tail):-
  NSize is Size-1,
  listToMatrixRow(List, NSize, Row, Tail).

% integerToAtomUsingKey(+Before, -After, +Key)
integerToAtomUsingKey([], [], _).
integerToAtomUsingKey([Elem|Rest], After, Key):-
    integerToAtomUsingKey(Rest, AfterRest, Key),

    ifelse(nth1(Elem, Key, Atom),
        After = [Atom|AfterRest],
        After = [ee|AfterRest]).


removeElementFromList(_, [], []) :- !.
removeElementFromList(Elem, [Elem|Rest], Result) :- 
    !, 
    removeElementFromList(Elem, Rest, Result).
removeElementFromList(Elem, [NotElem|Rest], Result) :- 
    !, 
    removeElementFromList(Elem, Rest, ResultRest), 
    append([NotElem], ResultRest, Result).


% nthOccurrenceInList(+List, ?Element, ?Index, ?Occurences)
nthOccurrenceInList(List, Element, Index, Occurences):-
    nthOccurrenceInList(List, Element, Index, 0, Occurences).

nthOccurrenceInList(_, _, 0, Occurences, Occurences) :- !.
nthOccurrenceInList([Element|Tail], Element, Index, Count, Occurences):-
    Count2 is Count+1,
    !,nthOccurrenceInList(Tail, Element, Index1, Count2, Occurences),
    Index is Index1+1.
nthOccurrenceInList([_|Tail], Element, Index, Count, Occurences):-
    !,nthOccurrenceInList(Tail, Element, Index1, Count, Occurences),
    Index is Index1+1.



% --- Magic Snail process ---

listToMagicSnail(List, Route, BoardLength, MagicSnail):-
    listToMagicSnail(List, Route, BoardLength, MagicSnail, 0,0).

listToMagicSnail(List, [], BoardLength, MagicSnail ,Row,Column):-
    Index is Row*BoardLength + Column,
    nth0(Index, List, Elem),
    MagicSnail = [Elem].
    
listToMagicSnail(List, [Dir|RestRoute], BoardLength, MagicSnail, Row,Column):-

    switch(Dir, [
        d:(
            NColumn is Column+1,
            NRow is Row
        ),
        a:(
            NColumn is Column-1,
            NRow is Row
        ),
        s:(
            NColumn is Column,
            NRow is Row+1
        ),
        w:(
            NColumn is Column,
            NRow is Row-1
        )
    ]),

    listToMagicSnail(List, RestRoute, BoardLength, MagicSnailRest,NRow,NColumn),

    Index is Row*BoardLength + Column,
    nth0(Index, List, Elem),
    MagicSnail = [Elem | MagicSnailRest].



% --- operators ---
ifelse(Condition, If, _Else) :- Condition, !, If.
ifelse(_, _, Else) :- Else.

not(X) :- X, !, fail.
not(_X).

switch(X, [Case:Then|Cases]) :-
    ( X=Case ->
        call(Then)
    ;
        switch(X, Cases)
    ).

% --- gui --- 
getCharThenEnter(X) :-
        get_char(X),
        get_char(_), !.

anotherSolution:-
    write('Another Solution? (y/n)'), nl,
    getCharThenEnter(X),
    switch(X,[y:fail, n:true]).


    

