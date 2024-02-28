% For SICStus, uncomment line below: (needed for member/2)
%:- use_module(library(lists)).
% Load model, initial state and formula from file.
verify(Input) :-
    see(Input), read(Transitions), read(Labeling), read(State), read(F), seen,
    check(Transitions, Labeling, State, [], F).
    % check(T, L, S, U, F)
    % T - The transitions in form of adjacency lists
    % L - The labeling
    % S - Current state
    % U - Currently recorded states
    % F - CTL Formula to check.SICStus,
    %
    % Should evaluate to true iff the sequent below is valid.
    %
    % (T,L), S |- F
    % U
    % To execute: consult('your_file.pl'). verify('input.txt').

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CTL-regler%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Literals
    check(_, Labeling, State, [], X) :-
        list(Labeling, State, Transitions1),
        member(X, Transitions1).
    
    check(_, Labeling, State, [], neg(X)) :-
        list(Labeling, State, Transitions1),
        \+member(X, Transitions1).
    
    % And
    check(Transitions, Labeling, State, [], and(F,G)) :-
        check(Transitions, Labeling, State, [], F),
        check(Transitions, Labeling, State, [], G).
    
    % Or
    check(Transitions, Labeling, State, [], or(F,G)) :-
        check(Transitions, Labeling, State, [], F);
        check(Transitions, Labeling, State, [], G).
    
    % AX
    check(Transitions, Labeling, State, [], ax(F)) :-
        list(Transitions, State, Transitions1),
        allStates(Transitions, Labeling, Transitions1, [], F).
    
    % EX
    check(Transitions, Labeling, State, [], ex(F)) :-
        list(Transitions, State, Transitions1),
        states(Transitions, Labeling, Transitions1, [], F).
    
    % AG
    check(_, _, State, Visited, ag(_)) :-
        member(State, Visited), !.
    
    check(Transitions, Labeling, State, Visited, ag(F)) :-
        check(Transitions, Labeling, State, [], F),
        list(Transitions, State, Transitions1),
        allStates(Transitions, Labeling, Transitions1, [State|Visited], ag(F)).
    
    % EG
    check(_, _, State, Visited, eg(_)) :-
        member(State, Visited), !.
    
    check(Transitions, Labeling, State, Visited, eg(F)) :-
        check(Transitions, Labeling, State, [], F),
        list(Transitions, State, Transitions1),
        states(Transitions, Labeling, Transitions1, [State|Visited], eg(F)).
    
    % EF
    check(Transitions, Labeling, State, Visited, ef(F)) :-
        \+member(State, Visited),
        check(Transitions, Labeling, State, [], F).
    
    check(Transitions, Labeling, State, Visited, ef(F)) :-
        \+member(State, Visited),
        list(Transitions, State, Transitions1),
        member(Next, Transitions1),
        check(Transitions, Labeling, Next, [State|Visited], ef(F)).
    
    % AF
    check(Transitions, Labeling, State, Visited, af(F)) :-
        \+member(State, Visited),
        check(Transitions, Labeling, State, [], F).
    
    check(Transitions, Labeling, State, Visited, af(F)) :-
        \+member(State, Visited),
        list(Transitions, State, Transitions1),
        allStates(Transitions, Labeling, Transitions1, [State|Visited], af(F)).
    
    



    %%%%%%%%%%%%%%%%%%%%hjälp-predikat%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    list([[State, K]|_], State, K).
    
    list([_|Transitions1], State, K) :-
        list(Transitions1, State, K).
    
    allStates(_, _, [], _, _).
    
    allStates(Transitions, Labeling, [H|Transitions1], Visited, B) :-
        check(Transitions, Labeling, H, Visited, B),
        allStates(Transitions, Labeling, Transitions1, Visited, B).
    
    states(_, _, [], _, _).
    
    states(Transitions, Labeling, Transitions1, Visited, B) :-
        member(Next, Transitions1),
        check(Transitions, Labeling, Next, Visited, B).
    
    