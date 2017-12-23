:- include('Interface.pl').
:- include('logic.pl').
:- include('utils.pl').
:- use_module(library(lists)).
:- use_module(library(system)).
:- use_module(library(timeout)).


% --- START ---
start(Key, BoardLength):-


    clearScreen,
    titleFrame,
    atom_chars(Key,KeyList),
    length(KeyList, KeyLength),

    statistics(walltime,_),
    magicSnail(IndexList,BoardLength,KeyLength),
    statistics(walltime,Runtime),

    integerToAtomUsingKey(IndexList, AtomList, KeyList),

    listToMatrix(AtomList, BoardLength, Matrix),

    buildBoard(Matrix, BoardLength, Board),

    % spacing(3),
    displayBoard(Board),
    
    anotherSolution,

    statisticsMagicRule(Runtime).
    

statisticsMagicRule(Runtime:-
    nth1(2,Runtime, Time),
    write('Runtime: '), write(Time), write(' ms.'),
    spacing(2).

