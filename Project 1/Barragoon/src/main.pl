:- include('Utilities.pl').
:- include('Interface.pl').
:- include('Logic.pl').
:- use_module(library(random)).
:- use_module(library(lists)).
:- use_module(library(system)).

%--------------------------------%
%-----------Barragoon -----------%
%--------------------------------%
%--------- escreva start --------%
%---- na consola para correr ----%
%--------------------------------%
%--------------------------------%

% --- START ---
start :-
        clearScreen,
        mainMenu.