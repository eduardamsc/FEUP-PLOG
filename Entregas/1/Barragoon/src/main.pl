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
        clearScreen,
        topAxis,nl,
        horizontalBorder, nl,
        displayBoard(
                       [[um, empty, black4, black3, empty, black3, black4, empty],
                        [dois, empty, empty, black2, black3, black2, empty, empty],
                        [tres,empty, empty, empty, empty, empty, empty, empty],
                        [quatro, empty, barraX, empty, empty, empty, barraX, empty],
                        [cinco, barraX, empty, barraX, empty, barraX, empty, barraX],
                        [seis, empty, barraX, empty, empty, empty, barraX, empty],
                        [sete, empty, empty, empty, empty, empty, empty, empty],
                        [oito, empty, empty, white2, white3, white2, empty, empty],
                        [nove, empty, white4, white3, empty, white3, white4, empty]]).

displayBoard([]).
displayBoard([L|R]) :-
   displayrow(L),border, nl,
   horizontalBorder, nl,
   displayBoard(R).

displayrow([]).
displayrow(['empty'|R]) :- border, write('    '), !, displayrow(R).
displayrow(['white2'|R]) :- border, write(' w2 '), !, displayrow(R).
displayrow(['white3'|R]) :- border, write(' w3 '), !, displayrow(R).
displayrow(['white4'|R]) :- border, write(' w4 '), !, displayrow(R).
displayrow(['black2'|R]) :- border, write(' b2 '), !, displayrow(R).
displayrow(['black3'|R]) :- border, write(' b3 '), !, displayrow(R).
displayrow(['black4'|R]) :- border, write(' b4 '), !, displayrow(R).
displayrow(['barraX'|R]) :- border, write('  X '), !, displayrow(R).
displayrow(['allDir'|R]) :- border, write('  * '), !, displayrow(R).
displayrow(['right'|R]) :- border, write('  > '), !, displayrow(R).
displayrow(['left'|R]) :- border, write(' <  '), !, displayrow(R).
displayrow(['um'|R]) :- write('1'), !, displayrow(R).
displayrow(['dois'|R]) :- write('2'), !, displayrow(R).
displayrow(['tres'|R]) :- write('3'), !, displayrow(R).
displayrow(['quatro'|R]) :- write('4'), !, displayrow(R).
displayrow(['cinco'|R]) :- write('5'), !, displayrow(R).
displayrow(['seis'|R]) :- write('6'), !, displayrow(R).
displayrow(['sete'|R]) :- write('7'), !, displayrow(R).
displayrow(['oito'|R]) :- write('8'), !, displayrow(R).
displayrow(['nove'|R]) :- write('9'), !, displayrow(R).

topAxis :- write('    A    B    C    D    E    F    G').
horizontalBorder :- write('  ----------------------------------').
border :- write('|').