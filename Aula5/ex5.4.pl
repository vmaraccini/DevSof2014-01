%Ex 5.4
%Implementar fatorial em Prolog.

%Solucao

fatorial(1,1).

fatorial(N,NF) :-
	A is N-1,
	fatorial(A,AF),
	NF is N*AF.