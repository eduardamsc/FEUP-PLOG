

initialBoard([
    [ee, ee, ee, ee, ee],
    [ee, ee, ee, ee, ee],
    [ee, ee, ee, ee, ee],
    [ee, ee, ee, ee, ee],
    [ee, ee, ee, ee, ee]
]).

initialBoard(N, Board):-
    fillListWithValue(Row, ee, N),
    fillListWithValue(Board,Row,N).

exampleBoard([
    [ee, 'A', ee, 'B', 'C'],
    ['B', ee, 'C', ee, 'A'],
    ['A', 'C', ee, ee, 'B'],
    ['C', ee, 'B', 'A', ee],
    [ee, 'B', 'A', 'C', ee]
]).

horizontalFrontierBoard([
    [hf, hf, hf, hf, hf],
    [hf, hf, hf, hf, he],
    [he, hf, hf, he, he],
    [he, he, hf, he, he],
    [he, hf, hf, hf, he],
    [hf, hf, hf, hf, hf]
]).

horizontalFrontierBoard(0, _):- !, write('BoardLength must be an odd number!'),fail.
horizontalFrontierBoard(1, [[hf],[hf]]):-!.
horizontalFrontierBoard(N, FrontierBoard):-
    N2 is N-2,
    horizontalFrontierBoard(N2,FrontierBoardRest),

    fillListWithValue(Top, hf, N),
    horizontalFrontierBoardAux(N, FrontierBoardRest, Center),
    fillListWithValue(Bottom, hf, N),

    append([Top], Center, TC),
    append(TC, [Bottom], FrontierBoard).

horizontalFrontierBoardAux(_,[],[]).
horizontalFrontierBoardAux(N, [Row|Rest], Center):-
    N1 is N-1,
    length([Row|Rest],N1),
    !,
    horizontalFrontierBoardAux(N, Rest, CenterRest),

    append([hf],Row,HFR),
    append(HFR,[he],NewRow),

    append([NewRow], CenterRest, Center).

horizontalFrontierBoardAux(N, [Row|Rest], Center):-
    !,
    horizontalFrontierBoardAux(N, Rest, CenterRest),

    append([he],Row,HER),
    append(HER,[he],NewRow),

    append([NewRow], CenterRest, Center).



verticalFrontierBoard([
    [ve, ve, ve, ve, ve, vf],
    [vf, ve, ve, ve, vf, vf],
    [vf, vf, ve, vf, vf, vf],
    [vf, vf, ve, ve, vf, vf],
    [vf, ve, ve, ve, ve, vf]
]).

verticalFrontierBoard(0, _):- !, write('BoardLength must be an odd number!'),fail.
verticalFrontierBoard(1, [[ve,vf]]):-!.
verticalFrontierBoard(N, FrontierBoard):-
    N2 is N-2,
    verticalFrontierBoard(N2, FrontierBoardRest),

    fillListWithValue(ATop, ve, N),
    append(ATop, [vf], Top),

    verticalFrontierBoardAux(N, FrontierBoardRest, Center),

    N1 is N-1,
    fillListWithValue(CBottom,ve,N1),
    append([vf], CBottom, LBottom),
    append(LBottom, [vf], Bottom),

    append([Top], Center, TC),
    append(TC, [Bottom], FrontierBoard).
    
verticalFrontierBoardAux(_,[],[]).
verticalFrontierBoardAux(N, [Row|Rest], Center):-
    verticalFrontierBoardAux(N, Rest, CenterRest),

    append([vf],Row,VFR),
    append(VFR,[vf],NewRow),

    append([NewRow], CenterRest, Center).


% -- Logo --
titleFrame :-
        write(' ______________________________________________________________'),nl,
        write('|                                                              |'),nl,
        write('|      __  __             _         _____             _ _      |'), nl,                                               
        write('|     |  \\/  |           (_)       / ____|           (_) |     |'), nl,
        write('|     | \\  / | __ _  __ _ _  ___  | (___  _ __   __ _ _| |     |'), nl,
        write('|     | |\\/| |/ _` |/ _` | |/ __|  \\___ \\| \'_ \\ / _` | | |     |'), nl,
        write('|     | |  | | (_| | (_| | | (__   ____) | | | | (_| | | |     |'), nl,
        write('|     |_|  |_|\\__,_|\\__, |_|\\___| |_____/|_| |_|\\__,_|_|_|     |'), nl,
        write('|                    __/ |                                     |'), nl,               
        write('|                   |___/                                      |'), nl,
        write('|                                                              |'),nl,
        write('|______________________________________________________________|'),nl,
        spacing(3).


buildBoard(Matrix, BoardLength, Board):-
    horizontalFrontierBoard(BoardLength, HF),
    verticalFrontierBoard(BoardLength, VF),
    buildBoard(Matrix, HF, VF, BoardLength, Board).

buildBoard([], [RowHF], [], _, [Result]):-
    horizontalFrontierParser(RowHF, Result).

buildBoard([RowElems|RestElems], [RowHF|RestHF], [RowVF|RestVF], BoardLength, Result):-
    buildBoard(RestElems, RestHF, RestVF, BoardLength, RestResult),
    
    fillListWithValue(NEmpty, ee, BoardLength),

    horizontalFrontierParser(RowHF, RowHead),
    verticalFrontierParser(RowVF, NEmpty, RowContentTop),
    verticalFrontierParser(RowVF, RowElems, RowContent),
    verticalFrontierParser(RowVF, NEmpty, RowContentBottom),

    Result = [RowHead, RowContentTop, RowContent, RowContentBottom|RestResult].


displayBoard([]).
displayBoard([Row|Rest]):-
    write('               '),
    displayRow(Row), nl,
    displayBoard(Rest).
    

horizontalFrontierParser([], ['+']).
horizontalFrontierParser([R1|Rest], Result):-
    horizontalFrontierParser(Rest,RecResult),
    
    translate(R1, Ascii),
    Result = [Ascii|RecResult].


verticalFrontierParser([R1], [], Result):-
    translate(R1, Ascii),
    Result = [Ascii].

verticalFrontierParser([R1|Rest], [Elem|RemainingRow], Result):-
    verticalFrontierParser(Rest, RemainingRow, RecResult),
    
    translate(R1, Ascii),
    translate(Elem, TElem),
    Result = [Ascii, TElem |RecResult].

translate(ee, '     '):-!.
translate(he, '+     '):-!.
translate(hf, '+-----'):-!.
translate(ve, ' '):-!.
translate(vf, '|'):-!.
translate(X, Res):-
    atom_concat('  ', X, X1),
    atom_concat(X1, '  ', Res).

displayRow([]).
displayRow([Elem|Rest]):-
    write(Elem),
    displayRow(Rest).


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