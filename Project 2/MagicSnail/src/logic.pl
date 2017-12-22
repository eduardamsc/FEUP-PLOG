:- use_module(library(clpfd)).

magicSnail(List, BoardLength, KeyLength):-
    
    ListLength is BoardLength*BoardLength,
    length(List, ListLength),
    domain(List, 0, KeyLength),

    oncePerRow(List, BoardLength, KeyLength),
    oncePerColumn(List, BoardLength, KeyLength),
    magicSnailRule(List, BoardLength),

    labeling([], List).

test(List, BoardLength):-
    ListLength is BoardLength*BoardLength,

    KeyLength is 2,

    length(List, ListLength),
    domain(List, 0, KeyLength),

    oncePerRow(List, BoardLength, KeyLength),
    oncePerColumn(List, BoardLength, KeyLength),
    magicSnailRule(List, BoardLength),

    labeling([], List),
    write(List).


oncePerRow([],_,_):-!.
oncePerRow(List, BoardLength, KeyLength):-
    takeFirstNElemsFromList(BoardLength, List, FirstElems),
    append(FirstElems,Rest,List),
    oncePerRow(Rest,BoardLength, KeyLength),

    fillListIndexEqualsValue(KeyLength,Values),
    countEqualsList(Values, FirstElems, 1).


oncePerColumn([],_,_):-!.
oncePerColumn(List,BoardLength, KeyLength):- oncePerColumn(List,BoardLength, KeyLength, 1).

oncePerColumn(_,BoardLength,_, N):-
    N > BoardLength,!.
oncePerColumn(List, BoardLength, KeyLength, N1):-
    Next is N1+1,
    oncePerColumn(List, BoardLength, KeyLength, Next),

    takeColumnElemsFromList(N1, BoardLength, List, Column),

    oncePerRow(Column, BoardLength, KeyLength).

magicSnailRoute([d,d,d,d,s,s,s,s,a,a,a,a,w,w,w,d,d,d,s,s,a,a,w,d]).

magicSnailRoute(1,[]):-!.
magicSnailRoute(N,Route):-
    N2 is N-2,
    magicSnailRoute(N2, RouteRest),
    
    N1 is N-1,
    fillListWithValue(D, d, N1),
    fillListWithValue(S, s, N1),
    fillListWithValue(A, a, N1),
    fillListWithValue(W, w, N2),

    append(D, S, DS),
    append(DS, A, DSA),
    append(DSA, W, DSAW),
    append(DSAW, [d], RouteN),

    append(RouteN, RouteRest, Route).
    
    

magicSnailRule(List, BoardLength):-
    magicSnailRoute(BoardLength, Route),
    listToMagicSnail(List,Route, BoardLength,MagicSnail),
    orderedListWithCiclesIgnoring0s(MagicSnail,BoardLength).

orderedListWithCiclesIgnoring0s(List,BoardLength):-
    orderedListWithCiclesIgnoring0s(List,BoardLength,1,0).

orderedListWithCiclesIgnoring0s(_,BoardLength, N,_):-
    N>BoardLength.
orderedListWithCiclesIgnoring0s(List,BoardLength,Occurrence, LastOccurrence):-

    nthOccurrence(List, 1, Occurrence, Index1),
    nthOccurrence(List, 2, Occurrence, Index2),
    nthOccurrence(List, 3, Occurrence, Index3),

    LastOccurrence#<Index1,
    Index1#<Index2,
    Index2#<Index3,

    NextOccurrence is Occurrence+1,
    orderedListWithCiclesIgnoring0s(List,BoardLength,NextOccurrence, Index3).

        
numberOfOcurrencesUntil(_,_,Count,Count,Index,Index).
numberOfOcurrencesUntil(List, Element, Aux, Count, Index, IndexAux) :-
    List = [H|T],
    H #= Element #<=> YES,
    Aux2 #= Aux + YES,
    N_Index is IndexAux + 1,
    numberOfOcurrencesUntil(T, Element, Aux2, Count, Index, N_Index).
 
 
%O elemento Element aparece na lista L pela NthTime no index Index
 
nthOccurrence(List, Element, NthTime, Index) :-
 
  numberOfOcurrencesUntil(List,Element, 0, NthTime, Index, 0), %restrição de até aquele index o element aparecer nthtime
  element(Index,List,Element). % restrição de naquela posição ser aquele element
 


%countEquals(Value, List, Count) - Count equal values on a list
countEquals(_, [], 0).
countEquals(Value, [Head | Tail], Count) :-
    countEquals(Value, Tail, Count2),
    Value #= Head #<=> Flag,
    Count #= Count2 + Flag.

countEqualsList([],_,_).
countEqualsList([Value|Rest], List, Count):-
    countEqualsList(Rest, List, Count),
    countEquals(Value,List,Count).
