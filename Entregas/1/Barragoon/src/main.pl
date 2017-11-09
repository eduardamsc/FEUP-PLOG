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

% --- START ---
startGame :-
        clearScreen,
        mainMenu.

% --- OTHERS ---
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
        translate(L),border, nl,
        horizontalBorder, nl,
        displayBoard(R).

translate([]).
translate(['empty'|R]) :- border, write('    '), !, translate(R).
translate(['white2'|R]) :- border, write(' w2 '), !, translate(R).
translate(['white3'|R]) :- border, write(' w3 '), !, translate(R).
translate(['white4'|R]) :- border, write(' w4 '), !, translate(R).
translate(['black2'|R]) :- border, write(' b2 '), !, translate(R).
translate(['black3'|R]) :- border, write(' b3 '), !, translate(R).
translate(['black4'|R]) :- border, write(' b4 '), !, translate(R).
translate(['barraX'|R]) :- border, write('  X '), !, translate(R).
translate(['allDir'|R]) :- border, write('  * '), !, translate(R).
translate(['right'|R]) :- border, write('  > '), !, translate(R).
translate(['left'|R]) :- border, write(' <  '), !, translate(R).
translate(['um'|R]) :- write('1'), !, translate(R).
translate(['dois'|R]) :- write('2'), !, translate(R).
translate(['tres'|R]) :- write('3'), !, translate(R).
translate(['quatro'|R]) :- write('4'), !, translate(R).
translate(['cinco'|R]) :- write('5'), !, translate(R).
translate(['seis'|R]) :- write('6'), !, translate(R).
translate(['sete'|R]) :- write('7'), !, translate(R).
translate(['oito'|R]) :- write('8'), !, translate(R).
translate(['nove'|R]) :- write('9'), !, translate(R).

topAxis :- 
        write('    A    B    C    D    E    F    G').
horizontalBorder :- 
        write('  ----------------------------------').
border :- 
        write('|').