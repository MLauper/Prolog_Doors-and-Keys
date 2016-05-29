/* door(FROM, TO, KEY) */
/* SIMPLE MAP
 * ==========
treasure_in(room2).

door(room0,room1,key1).
door(room1,room2,key2).

contains_key(room0,key1).
contains_key(room0,key99).
contains_key(room1,key2).
*/

//* COMPLEX MAP
// * ===========
treasure_in(room18).

door(room0, room1, key1)



/* Player starts in a room with a list of keys */
/* play(ROOM, PLAYER_KEYS, STEPS) :- pickup_key(ROOM,PLAYER_KEYS,PLAYER_KEYS_EXT), treasure(ROOM). */

/* play(ROOM, PLAYER_KEYS) */
play(ROOM, PLAYER_KEYS, STEPS_IN, STEPS_OUT, ROOMS_TRAVERSED_IN, ROOMS_TRAVERSED_OUT, KEYS_USED_IN, KEYS_USED_OUT) :-
	treasure_in(ROOM),
	all_keys_used(PLAYER_KEYS, KEYS_USED_IN),
	string_concat("Treasure found in Room ", ROOM, MESSAGE),
	append(STEPS_IN, [MESSAGE], STEPS_OUT),
	append(ROOMS_TRAVERSED_IN, [], ROOMS_TRAVERSED_OUT),
	append(KEYS_USED_IN, [], KEYS_USED_OUT).

play(ROOM, PLAYER_KEYS,
     STEPS_IN, STEPS_OUT,
     ROOMS_TRAVERSED_IN, ROOMS_TRAVERSED_OUT,
     KEYS_USED_IN, KEYS_USED_OUT) :-
	switchRoom(
	    ROOM,PLAYER_KEYS,NEW_ROOM,
	    STEPS_IN, STEPS_X,
	    ROOMS_TRAVERSED_IN, ROOMS_TRAVERSED_X,
	    KEYS_USED_IN, KEYS_USED_X),
	play(
	    NEW_ROOM, PLAYER_KEYS,
	    STEPS_X, STEPS_OUT,
	    ROOMS_TRAVERSED_X, ROOMS_TRAVERSED_OUT,
	    KEYS_USED_X, KEYS_USED_OUT).

play(ROOM, PLAYER_KEYS,
     STEPS_IN, STEPS_OUT,
     ROOMS_TRAVERSED_IN, ROOMS_TRAVERSED_OUT,
     KEYS_USED_IN, KEYS_USED_OUT) :-
	pickupKey(
	    ROOM, PLAYER_KEYS, NEW_PLAYER_KEYS,
	    STEPS_IN, STEPS_X,
	    ROOMS_TRAVERSED_IN, ROOMS_TRAVERSED_X,
	    KEYS_USED_IN, KEYS_USED_X),
	play(
	    ROOM, NEW_PLAYER_KEYS,
	    STEPS_X, STEPS_OUT,
	    ROOMS_TRAVERSED_X, ROOMS_TRAVERSED_OUT,
	    KEYS_USED_X, KEYS_USED_OUT).

switchRoom(ROOM, PLAYER_KEYS, NEW_ROOM,
	   STEPS_IN, STEPS_OUT,
	   ROOMS_TRAVERSED_IN, ROOMS_TRAVERSED_OUT,
	   KEYS_USED_IN, KEYS_USED_OUT) :-

	door(ROOM, NEW_ROOM, KEY),
	member(KEY, PLAYER_KEYS),

	string_concat("Switch from Room ", ROOM, MESSAGE2),
	string_concat(MESSAGE2, " to Room ", MESSAGE3),
	string_concat(MESSAGE3, NEW_ROOM, MESSAGE4),
	append(STEPS_IN, [MESSAGE4], STEPS_OUT),

	append(ROOMS_TRAVERSED_IN, [NEW_ROOM], ROOMS_TRAVERSED_OUT),

	append(KEYS_USED_IN, [KEY], KEYS_USED_OUT).

pickupKey(ROOM, PLAYER_KEYS, NEW_PLAYER_KEYS,
	  STEPS_IN, STEPS_OUT,
	  ROOMS_TRAVERSED_IN, ROOMS_TRAVERSED_OUT,
	  KEYS_USED_IN, KEYS_USED_OUT) :-

	contains_key(ROOM,ROOM_KEY),
	not(member(ROOM_KEY, PLAYER_KEYS)),
	append(PLAYER_KEYS, [ROOM_KEY], NEW_PLAYER_KEYS),

	atomic_concat("Pickup Key ", ROOM_KEY, MESSAGE2),
	string_concat(MESSAGE2, " in Room ", MESSAGE3),
	string_concat(MESSAGE3, ROOM, MESSAGE4),
	append(STEPS_IN, [MESSAGE4], STEPS_OUT),

	append(ROOMS_TRAVERSED_IN, [], ROOMS_TRAVERSED_OUT),

	append(KEYS_USED_IN, [], KEYS_USED_OUT).

all_keys_used(KEYS, _) :-
	KEYS = [].

all_keys_used(KEYS, USED_KEYS) :-
	[KEY | REST] = KEYS,
	member(KEY, USED_KEYS),
	all_keys_used(REST, USED_KEYS).