verify(InputFileName) :- see(InputFileName),
read(Prems), read(Goal), read(Proof),
seen,
valid_proof(Prems, Goal, Proof, Proof).

valid_proof(Prems, Goal, [X|[]],Back):-
    (premiserule(X, Prems, Back); andintro(X, Back);
     andeli1(X, Back); andeli2(X, Back);
     orintro1(X, Back); orintro2(X, Back);
     orelim(X, Back); copyrule(X, Back);
     impintro(X, Back); impelim(X, Back);
     negintro(X, Back); negelim(X, Back);
     contelim(X, Back); negnegintro(X, Back);
     negnegelim(X, Back); mtrule(X, Back);
     pbcrule(X, Back); lemrule(X, Back);
     verify_box(Prems, X, Back) ),
	 X = [_,Goal,_].

valid_proof(Prems, Goal, [X|T],Back):-
    (premiserule(X, Prems, Back); andintro(X, Back);
     andeli1(X, Back); andeli2(X, Back);
     orintro1(X, Back); orintro2(X, Back);
     orelim(X, Back); copyrule(X, Back);
     impintro(X, Back); impelim(X, Back);
     negintro(X, Back); negelim(X, Back);
     contelim(X, Back); negnegintro(X, Back);
     negnegelim(X, Back); mtrule(X, Back);
     pbcrule(X, Back); lemrule(X, Back);
     verify_box(Prems, X, Back) ),
     valid_proof(Prems, Goal, T, Back).


%--------------------------------------regler-----------------------------------------%
%And introduction
andintro([Num, and(X, Y), andint(Pos1, Pos2)], Back):-
    Num > Pos1,
    Num > Pos2,
    member([Pos1, X, _], Back),
    member([Pos2, Y, _], Back).

%And elimination of left field
andeli1([Num, X, andel1(Pos)], Back):-
    Num > Pos,
    member([Pos, and(X,_), _], Back).

%And elimination of right field
andeli2([Num, X, andel2(Pos)], Back):-
    Num > Pos,
    member([Pos, and(_, X), _], Back).

%Or intro left
orintro1([Num, or(X, _), orint1(Pos)], Back):-
    Num > Pos,
    member([Pos, X, _], Back).

%or intro right
orintro2([Num, or(_, X), orint2(Pos)], Back):-
    Num > Pos,
    member([Pos, X, _], Back).

%or elim
%BOx?
orelim([Num, X, orel(Pos1, Pos2, Pos3, Pos4, Pos5)], Back):-
    Num > Pos1,
    Num > Pos2,
    Num > Pos3,
    Num > Pos4,
    Num > Pos5,
    member([Pos1, or(Y, Z) , _], Back),

    member([[Pos2, Y, assumption]| Box], Back),
    lastline([[Pos2, Y, assumption]|Box], Lastlineinbox),
    [Pos3, X, _] = Lastlineinbox,

    member([[Pos4, Z, assumption]|Box2], Back),
    lastline([[Pos4, Z, assumption]|Box2], Lastlineinbox2),
    [Pos5, X, _] = Lastlineinbox2.



%copy fel?
copyrule([Num, X, copy(Pos)], Back):-
    Num > Pos,
    member([Pos, X, _], Back).

%premise
premiserule([_, X, premise], Prems, _):-
    member(X, Prems).
%or elimination

%implication intro
%BOX?
impintro([Num, imp(X,Y), impint(Pos1,Pos2)], Back):-
    Num > Pos1,
    Num > Pos2,
    member([[Pos1, X, assumption]|Box], Back),
    lastline([[Pos1, X, assumption]| Box], Lastlineinbox),
    [Pos2, Y, _] = Lastlineinbox.

%implication elim
impelim([Num, X, impel(Pos1, Pos2)], Back):-
    Num > Pos1,
    Num > Pos2,
    member([Pos1, Y, _], Back),
    member([Pos2, imp(Y,X), _], Back).

%negation intro
%BOX?
negintro([Num, neg(X), negint(Pos1, Pos2)], Back):-
    Num > Pos1,
    Num > Pos2,
    member([[Pos1, X, assumption]|Box], Back),
    lastline([[Pos1, X, assumption]|Box], Lastlineinbox),
    [Pos2, cont, _] = Lastlineinbox.
    

%negation elim
negelim([Num, cont, negel(Pos1, Pos2)], Back):-
    Num > Pos1,
    Num > Pos2,
    member([Pos1, X, _], Back),
    member([Pos2, neg(X), _], Back).

%cont elim
contelim([Num, _, contel(Pos)], Back):-
    Num > Pos,
    member([Pos, cont, _], Back).
    
%negation negation intro
negnegintro([Num, neg(neg(X)), negnegint(Pos)], Back):-
    Num > Pos,
    member([Pos, X, _], Back).


%negation negation elim
negnegelim([Num, X, negnegel(Pos)], Back):-
    Num > Pos,
    member([Pos, neg(neg(X)), _], Back).
    

%mt
mtrule([Num, neg(X), mt(Pos1, Pos2)], Back):-
    Num > Pos1,
    Num > Pos2,
    member([Pos1, imp(X, Y),_], Back),
    member([Pos2, neg(Y), _], Back).

%pbc
%BOX
pbcrule([Num, X, pbc(Pos1, Pos2)], Back):-
    Num > Pos1,
    Num > Pos2,
    member([[Pos1, neg(X), assumption]|Box],Back),
    lastline([[Pos1, neg(X), assumption]|Box], Lastlineinbox),
    [Pos2, cont, _] = Lastlineinbox.
    

%lem
lemrule([Num, or(X, neg(X)), lem], Back).

%BOX
verify_box(_, [X], Back):-
    X = [_, _, assumption],
    append([X], Back, _).

verify_box(Prems, [X|T], Back):-
    X = [_, _, assumption],
    append([X|T], Back, Bevis),
    valid_proof(Prems, _, T, Bevis).

lastline([[Num, X, Rule]], [Num, X, Rule]).

lastline([_|T], Next):-
    lastline(T, Next).
    
    
    


   