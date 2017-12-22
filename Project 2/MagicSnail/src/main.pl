:- include('Interface.pl').
:- include('logic.pl').
:- include('utils.pl').
:- use_module(library(lists)).


% --- START ---
start(Key, BoardLength):-
    clearScreen,
    titleFrame,
    atom_chars(Key,KeyList),
    length(KeyList, KeyLength),
    magicSnail(IndexList,BoardLength,KeyLength),
    integerToAtomUsingKey(IndexList, AtomList, KeyList),

    listToMatrix(AtomList, BoardLength, Matrix),

    buildBoard(Matrix, BoardLength, Board),
    displayBoard(Board)/* ,
    fail */.

% test(N):-
%     initialBoard(N,Matrix),
%     horizontalFrontierBoard(N, HF),
%     verticalFrontierBoard(N, VF),

%     buildBoard(Matrix, HF, VF, N, Board),
%     displayBoard(Board).
