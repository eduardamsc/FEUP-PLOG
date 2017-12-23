:- include('Interface.pl').
:- include('logic.pl').
:- include('utils.pl').
:- use_module(library(lists)).
:- use_module(library(system)).
:- use_module(library(timeout)).


% --- START ---
% start(+Key, +BoardLength) -- Starts the execution of MagicSnail
start(Key, BoardLength):-


    clearScreen,
    titleFrame,
    atom_chars(Key,KeyList),
    length(KeyList, KeyLength),

    statistics(walltime,StartTime),
    magicSnail(IndexList,BoardLength,KeyLength),
    statistics(walltime,EndTime),
    
    statisticsMagicRule(StartTime, EndTime),

    integerToAtomUsingKey(IndexList, AtomList, KeyList),

    listToMatrix(AtomList, BoardLength, Matrix),

    buildBoard(Matrix, BoardLength, Board),

    displayBoard(Board),
    
    anotherSolution.


% statisticsMagicRule(+Runtime) -- Show runtime of MagicSnail
statisticsMagicRule(StartTime, EndTime):-


    nth1(1,StartTime, StartTimeMs),
    nth1(1,EndTime, EndTimeMs),

    RunTime is EndTimeMs - StartTimeMs,

    write('Runtime: '), write(RunTime), write(' ms.'),
    spacing(2).

