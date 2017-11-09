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
