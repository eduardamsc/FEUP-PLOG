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
