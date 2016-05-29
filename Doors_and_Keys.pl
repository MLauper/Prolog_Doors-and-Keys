treasure_in(room2).
door(room0,room1,key1).
door(room1,room2,key2).
contains_keys(room0,[key1, key99]).
contains_keys(room1,[key2]).

/* Player starts in a room with a list of keys */

play(ROOM, _, STEPS_IN, STEPS_OUT) :-
	treasure_in(ROOM),
	string_concat("Treasure found in Room ", ROOM, MESSAGE),
	append(STEPS_IN, [MESSAGE], STEPS_OUT).
play(ROOM, PLAYER_KEYS, STEPS_IN, STEPS_OUT) :-
	switchRoom(ROOM,PLAYER_KEYS,NEW_ROOM, STEPS_IN, STEPS_X),
	play(NEW_ROOM, PLAYER_KEYS, STEPS_X, STEPS_OUT).
play(ROOM, PLAYER_KEYS, STEPS_IN, STEPS_OUT) :-
	pickupKey(ROOM, PLAYER_KEYS, NEW_PLAYER_KEYS, STEPS_IN, STEPS_X),
	play(ROOM, NEW_PLAYER_KEYS, STEPS_X, STEPS_OUT).
switchRoom(ROOM, PLAYER_KEYS, NEW_ROOM, STEPS_IN, STEPS_OUT) :-
	door(ROOM, NEW_ROOM, KEY),
	member(KEY, PLAYER_KEYS),
	string_concat("Switch from Room ", ROOM, MESSAGE2),
	string_concat(MESSAGE2, " to Room ", MESSAGE3),
	string_concat(MESSAGE3, NEW_ROOM, MESSAGE4),
	append(STEPS_IN, [MESSAGE4], STEPS_OUT).
pickupKey(ROOM, PLAYER_KEYS, NEW_PLAYER_KEYS, STEPS_IN, STEPS_OUT) :-
	contains_keys(ROOM,KEYS),
	append(PLAYER_KEYS, KEYS, NEW_PLAYER_KEYS),
	atomics_to_string(KEYS, ", ", MESSAGE1),
	string_concat("Pickup Keys ", MESSAGE1, MESSAGE2),
	string_concat(MESSAGE2, " in Room", MESSAGE3),
	string_concat(MESSAGE3, ROOM, MESSAGE4),
	append(STEPS_IN, [MESSAGE4], STEPS_OUT).









