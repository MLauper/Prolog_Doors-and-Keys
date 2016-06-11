:- [ labyrinth_impossible,
	 doors_and_keys_quick
       ].
	   
:- initialization(main).

main :-
	play(
	    room0, [],
	    [], _,
	    [], _,
	    [], _,
	    [], _,
	    0, _,
	    100, _).