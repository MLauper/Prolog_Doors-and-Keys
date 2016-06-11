:- [ labyrinth_simple,
	 doors_and_keys
       ].
	   
:- initialization(main).

main :-
	playOptimal(room0, [],
		[], _,
		[], _,
		[], _,
		[room0], _,
		0, _,
		1000, _).
