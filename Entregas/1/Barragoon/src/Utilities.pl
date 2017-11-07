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