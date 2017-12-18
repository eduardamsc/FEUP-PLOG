

initialBoard([
    [e, e, e, e, e],
    [e, e, e, e, e],
    [e, e, e, e, e],
    [e, e, e, e, e],
    [e, e, e, e, e]
]).

exampleBoard([
    [e, 'A', e, 'B', 'C'],
    ['B', e, 'C', e, 'A'],
    ['A', 'C', e, e, 'B'],
    ['C', e, 'B', 'A', e],
    [e, 'B', 'A', 'C', e]
]).

horizontalFrontierBoard([
    [hf, hf, hf, hf, hf],
    [hf, hf, hf, hf, he],
    [he, hf, hf, he, he],
    [he, he, hf, he, he],
    [he, hf, hf, hf, he],
    [hf, hf, hf, hf, hf]
]).

verticalFrontierBoard([
    [ve, ve, ve, ve, ve, vf],
    [vf, ve, ve, ve, vf, vf],
    [vf, vf, ve, vf, vf, vf],
    [vf, vf, ve, ve, vf, vf],
    [vf, ve, ve, ve, ve, vf]
]).

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


buildBoard([], [RowHF], [], [Result]):-
    horizontalFrontierParser(RowHF, Result).

buildBoard([RowElems|RestElems], [RowHF|RestHF], [RowVF|RestVF], Result):-
    buildBoard(RestElems, RestHF, RestVF, RestResult),

    horizontalFrontierParser(RowHF, RowHead),
    verticalFrontierParser(RowVF, [e,e,e,e,e], RowContentTop),
    verticalFrontierParser(RowVF, RowElems, RowContent),
    verticalFrontierParser(RowVF, [e,e,e,e,e], RowContentBottom),

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

translate(e, '     ').
translate(he, '+     ').
translate(hf, '+-----').
translate(ve, ' ').
translate(vf, '|').
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