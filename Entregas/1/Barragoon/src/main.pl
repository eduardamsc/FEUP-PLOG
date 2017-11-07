/* -*- Mode:Prolog; coding:iso-8859-1; indent-tabs-mode:nil; prolog-indent-width:8; prolog-paren-indent:3; tab-width:8; -*- */

:- include('Utilities.pl').
:- include('Menus.pl').
:- include('Logic.pl').
:- use_module(library(system)).

%--------------------------------%
%-----------Barragoon -----------%
%--------------------------------%
%------- escreva startGame ------%
%---- na consola para correr ----%
%--------------------------------%
%--------------------------------%

startGame :-
        clearScreen,
        mainMenu.

display :- 
        printTopAxis,nl,
        printInitialSeparator, nl,
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
displayrow(['empty'|R]) :- write('    '), write('|'), !, displayrow(R).
displayrow(['white2'|R]) :- write(' w2 '), write('|'), !, displayrow(R).
displayrow(['white3'|R]) :- write(' w3 '), write('|'), !, displayrow(R).
displayrow(['white4'|R]) :- write(' w4 '), write('|'), !, displayrow(R).
displayrow(['black2'|R]) :- write(' b2 '), write('|'), !, displayrow(R).
displayrow(['black3'|R]) :- write(' b3 '), write('|'), !, displayrow(R).
displayrow(['black4'|R]) :- write(' b4 '), write('|'), !, displayrow(R).
displayrow(['barraX'|R]) :- write( '  X '), write('|'), !, displayrow(R).
displayrow(['allDir'|R]) :- write( '  * '), write('|'), !, displayrow(R).
displayrow(['right'|R]) :- write( '  > '), write('|'), !, displayrow(R).
displayrow(['left'|R]) :- write( ' <  '), write('|'), !, displayrow(R).

printInitialSeparator:-write(' ----------------------------------').

printTopAxis:-write('   A    B    C    D    E    F    G').