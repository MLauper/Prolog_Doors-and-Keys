play(
    ROOM, _,
    STEPS_IN, STEPS_OUT,
    ROOMS_TRAVERSED_IN, ROOMS_TRAVERSED_OUT,
    KEYS_USED_IN, KEYS_USED_OUT,
    DIRTY_ROOMS_IN, DIRTY_ROOMS_OUT,
    COST_IN, COST_OUT,
    LIMIT_IN, LIMIT_OUT) :-
	COST_OUT is COST_IN,
	LIMIT_OUT is LIMIT_IN,
	treasure_in(ROOM),
	string_concat("Treasure found in Room ", ROOM, MESSAGE),
	append(STEPS_IN, [MESSAGE], STEPS_OUT),
	append(ROOMS_TRAVERSED_IN, [], ROOMS_TRAVERSED_OUT),
	append(KEYS_USED_IN, [], KEYS_USED_OUT),
	append(DIRTY_ROOMS_IN, [], DIRTY_ROOMS_OUT),
	pretty_print_steps_and_cost(STEPS_OUT, COST_OUT).

play(ROOM, PLAYER_KEYS,
     STEPS_IN, STEPS_OUT,
     ROOMS_TRAVERSED_IN, ROOMS_TRAVERSED_OUT,
     KEYS_USED_IN, KEYS_USED_OUT,
     DIRTY_ROOMS_IN, DIRTY_ROOMS_OUT,
     COST_IN, COST_OUT,
     LIMIT_IN, LIMIT_OUT) :-
	LIMIT_IN > 0,
	LIMIT_X is LIMIT_IN - 1,
	COST_X is COST_IN + 1,
	switchRoom(
	    ROOM,PLAYER_KEYS,NEW_ROOM,
	    STEPS_IN, STEPS_X,
	    ROOMS_TRAVERSED_IN, ROOMS_TRAVERSED_X,
	    KEYS_USED_IN, KEYS_USED_X,
	    DIRTY_ROOMS_IN, DIRTY_ROOMS_X),
	play(
	    NEW_ROOM, PLAYER_KEYS,
	    STEPS_X, STEPS_OUT,
	    ROOMS_TRAVERSED_X, ROOMS_TRAVERSED_OUT,
	    KEYS_USED_X, KEYS_USED_OUT,
	    DIRTY_ROOMS_X, DIRTY_ROOMS_OUT,
	    COST_X, COST_OUT,
	    LIMIT_X, LIMIT_OUT).

play(ROOM, PLAYER_KEYS,
     STEPS_IN, STEPS_OUT,
     ROOMS_TRAVERSED_IN, ROOMS_TRAVERSED_OUT,
     KEYS_USED_IN, KEYS_USED_OUT,
     DIRTY_ROOMS_IN, DIRTY_ROOMS_OUT,
     COST_IN, COST_OUT,
     LIMIT_IN, LIMIT_OUT) :-
	LIMIT_IN > 0,
	LIMIT_X is LIMIT_IN -1,
	COST_X is COST_IN + 1,
	pickupKey(
	    ROOM, PLAYER_KEYS, NEW_PLAYER_KEYS,
	    STEPS_IN, STEPS_X,
	    ROOMS_TRAVERSED_IN, ROOMS_TRAVERSED_X,
	    KEYS_USED_IN, KEYS_USED_X,
	    DIRTY_ROOMS_IN, DIRTY_ROOMS_X),
	play(
	    ROOM, NEW_PLAYER_KEYS,
	    STEPS_X, STEPS_OUT,
	    ROOMS_TRAVERSED_X, ROOMS_TRAVERSED_OUT,
	    KEYS_USED_X, KEYS_USED_OUT,
	    DIRTY_ROOMS_X, DIRTY_ROOMS_OUT,
	    COST_X, COST_OUT,
	    LIMIT_X, LIMIT_OUT).

switchRoom(ROOM, PLAYER_KEYS, NEW_ROOM,
	   STEPS_IN, STEPS_OUT,
	   ROOMS_TRAVERSED_IN, ROOMS_TRAVERSED_OUT,
	   KEYS_USED_IN, KEYS_USED_OUT,
	   DIRTY_ROOMS_IN, DIRTY_ROOMS_OUT) :-

	exist_door(ROOM, NEW_ROOM, KEY),
	member(KEY, PLAYER_KEYS),
	not(member(NEW_ROOM, DIRTY_ROOMS_IN)),

	string_concat("Switch from Room ", ROOM, MESSAGE2),
	string_concat(MESSAGE2, " to Room ", MESSAGE3),
	string_concat(MESSAGE3, NEW_ROOM, MESSAGE4),
	append(STEPS_IN, [MESSAGE4], STEPS_OUT),

	append(ROOMS_TRAVERSED_IN, [NEW_ROOM], ROOMS_TRAVERSED_OUT),

	append(KEYS_USED_IN, [KEY], KEYS_USED_OUT),

	append(DIRTY_ROOMS_IN, [NEW_ROOM], DIRTY_ROOMS_OUT).

pickupKey(ROOM, PLAYER_KEYS, NEW_PLAYER_KEYS,
	  STEPS_IN, STEPS_OUT,
	  ROOMS_TRAVERSED_IN, ROOMS_TRAVERSED_OUT,
	  KEYS_USED_IN, KEYS_USED_OUT,
	  _, DIRTY_ROOMS_OUT) :-

	contains_key(ROOM,ROOM_KEY),
	not(member(ROOM_KEY, PLAYER_KEYS)),
	append(PLAYER_KEYS, [ROOM_KEY], NEW_PLAYER_KEYS),

	atomic_concat("Pickup Key ", ROOM_KEY, MESSAGE2),
	string_concat(MESSAGE2, " in Room ", MESSAGE3),
	string_concat(MESSAGE3, ROOM, MESSAGE4),
	append(STEPS_IN, [MESSAGE4], STEPS_OUT),

	append(ROOMS_TRAVERSED_IN, [], ROOMS_TRAVERSED_OUT),

	append(KEYS_USED_IN, [], KEYS_USED_OUT),

	append([], [ROOM], DIRTY_ROOMS_OUT).
	
exist_door(FROM, TO, KEY) :- door(FROM, TO, KEY).
exist_door(FROM, TO, KEY) :- door(TO, FROM, KEY).

pretty_print_steps_and_cost(STEPS, COST) :-
	write("===============================================\n"),
	write("================DOORS AND KEYS=================\n"),
	write("===============================================\n"),	
	print_steps(STEPS,1),
	write("===============================================\n"),
	write("TOTAL COST: "), write(COST), write("\n"),
	write("===============================================\n").

print_steps(STEPS,_) :-
	STEPS = [].

print_steps(STEPS,STEP_NUMBER) :-
	[STEP | REST] = STEPS,
	write("= STEP "), write(STEP_NUMBER), write(": "),
	write(STEP), write("\n"),
	STEP_NUMBER_X is STEP_NUMBER + 1,
	print_steps(REST, STEP_NUMBER_X).