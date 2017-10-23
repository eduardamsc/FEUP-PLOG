/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */

display :- printInitialSeparator, nl,
        displayBoard([[empty, black4, black3, empty, black3, black4, empty],
 [empty, empty, black2, black3, black2, empty, empty],
 [empty, empty, empty, empty, empty, empty, empty],
 [empty, barraX, empty, empty, empty, barraX, empty],
 [barraX, empty, barraX, empty, barraX, empty, barraX],
 [empty, barraX, empty, empty, empty, barraX, empty],
 [empty, empty, empty, empty, empty, empty, empty],
 [empty, empty, white2, white3, white2, empty, empty],
 [empty, white4, white3, empty, white3, white4, empty]]).

displayBoard([]).
displayBoard([L|R]) :-
   write('|'), displayrow(L), nl,
   write(' ----------------------------------'), nl,
  displayBoard(R).

displayrow([]).
displayrow(['empty'|R]) :- write('    |'), !, displayrow(R).
displayrow(['white2'|R]) :- write(' w2 |'), !, displayrow(R).
displayrow(['white3'|R]) :- write(' w3 |'), !, displayrow(R).
displayrow(['white4'|R]) :- write(' w4 |'), !, displayrow(R).
displayrow(['black2'|R]) :- write(' b2 |'), !, displayrow(R).
displayrow(['black3'|R]) :- write(' b3 |'), !, displayrow(R).
displayrow(['black4'|R]) :- write(' b4 |'), !, displayrow(R).
displayrow(['barraX'|R]) :- write( '  X |'), !, displayrow(R).
displayrow(['allDir'|R]) :- write( '  * |'), !, displayrow(R).
displayrow(['right'|R]) :- write( '  > |'), !, displayrow(R).
displayrow(['left'|R]) :- write( ' <  |'), !, displayrow(R).

printInitialSeparator:-write(' ----------------------------------').


