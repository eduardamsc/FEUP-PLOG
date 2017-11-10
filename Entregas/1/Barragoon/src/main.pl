:- include('Utilities.pl').
:- include('Interface.pl').
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