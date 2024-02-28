%   UPPGIFT 1
% ?- T=f(a,Y,Z), T=f(X,X,b).
%
% Vilka bindningar presenteras som resultat?
%
% Ge en kortfattad förklaring till ditt svar!
%
% X = a
% Y = X
% Z = b
%f(a, Y, Z)
%f(a, Y, b)
%f(a, X, b)
%f(a, a, b)

%UPPGIFT 2
/*
reverse_list([],[]).
reverse_list([Head | Tail], R):-
	reverse_list(Tail, RT),
	append(RT, [Head], R).

% Base Case
remove_duplicate([], []).

% Case 1 om head finns i tail lägg till i E
remove_duplicate([Head | Tail], E) :-
    member(Head, Tail), 
    remove_duplicate(Tail, E).

% Case 2
remove_duplicate([Head | Tail], [Head | E]) :-
    not(member(Head, Tail)),
    remove_duplicate(Tail, E).

%vänd om listan, ta bort alla duplicates, vänd listan rätt håll
remove_duplicates([Head|Tail],R):-
    reverse_list([Head|Tail], R1),
    remove_duplicate(R1,R2),
    reverse_list(R2,R).
*/


%UPPGIFT 3
/*
partstring(List,L,F):-
    append(_, T, List),
    append(F,_,T),
    length(F,L),
    F\=[].
*/

%UPPGIFT 4
/*
edge(nodA, nodB).
edge(nodA, nodC).
edge(nodB, nodD).
edge(nodC, nodD).
edge(nodC, nodE).
edge(nodE, nodB).


reverse_list([],[]).
reverse_list([Head | Tail], R):-
	reverse_list(Tail, RT),
	append(RT, [Head], R).

path(_NodA, _NodB, Path) :-
    travel(_NodA, _NodB, [_NodA], Q),
    reverse_list(Q, Path).

travel(_NodA, _NodB, P, [_NodB|P]) :-
    edge(_NodA, _NodB).
travel(_NodA, _NodB, Visited, Path) :-
    edge(_NodA, _NodC),
    _NodC \== _NodB,
    \+ member(_NodC, Visited),
    travel(_NodC, _NodB, [_NodC|Visited], Path).



*/