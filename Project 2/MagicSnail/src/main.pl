:- include('Interface.pl').


% --- START ---
start :-
        clearScreen,
        titleFrame,
        exampleBoard(Elems),
        horizontalFrontierBoard(HF),
        verticalFrontierBoard(VF),

        buildBoard(Elems, HF, VF, Board),
        !,
        displayBoard(Board).