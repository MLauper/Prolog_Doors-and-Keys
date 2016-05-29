/* play(room0, [], [], STEPS, [], ROOMS, [], KEYS, [room0], DIRTY_ROOMS). */

/* door(FROM, TO, KEY) */
/* * SIMPLE MAP
 * ==========
 *
treasure_in(room2).

door(room0,room1,key1).
door(room1,room2,key2).
/* door(room1,room0,key1).
door(room2,room1,key2). */

contains_key(room0,key1).
contains_key(room0,key99).
contains_key(room1,key2).
*/

/* COMPLEX MAP
 * ===========
 */
/*
treasure_in(room18).

door(room0, room1, key1).
door(room0, room2, key18).
door(room0, room2, key20).
door(room0, room3, key7).
door(room0, room4, key11).
door(room0, room4, key12).
door(room0, room5, key21).
door(room0, room6, key3).
door(room0, room7, key16).
door(room0, room14, key14).
door(room1, room9, key6).
door(room5, room10, key17).
door(room6, room11, key4).
door(room6, room11, key5).
door(room6, room12, key2).
door(room6, room13, key8).
door(room6, room14, key9).
door(room7, room15, key19).
door(room8, room16, key15).
door(room14, room17, key10).
door(room15, room18, key13).

contains_key(room0, key1).
contains_key(room1, key2).
contains_key(room1, key3).
contains_key(room1, key21).
contains_key(room1, key7).
contains_key(room1, key5).
contains_key(room1, key14).
contains_key(room2, key19).
contains_key(room4, key13).
contains_key(room10, key20).
contains_key(room6, key10).
contains_key(room6, key15).
contains_key(room11, key6).
contains_key(room12, key4).
contains_key(room13, key11).
contains_key(room17, key12).
contains_key(room7, key17).
contains_key(room7, key18).
contains_key(room16, key16).
*/

/* EDGE MAP: Triangle
*  ==================
*/
treasure_in(room4).

door(room0, room1, key01).
door(room0, room2, key02).
door(room1, room2, key12).
door(room0, room4, key04).

contains_key(room0, key01).
contains_key(room1, key02).
contains_key(room2, key12).
contains_key(room2, key04).



exist_door(FROM, TO, KEY) :- door(FROM, TO, KEY).
exist_door(FROM, TO, KEY) :- door(TO, FROM, KEY).

/* Player starts in a room with a list of keys */
/* play(ROOM, PLAYER_KEYS, STEPS) :- pickup_key(ROOM,PLAYER_KEYS,PLAYER_KEYS_EXT), treasure(ROOM). */

/* play(ROOM, PLAYER_KEYS) */
play(
    ROOM, PLAYER_KEYS,
    STEPS_IN, STEPS_OUT,
    ROOMS_TRAVERSED_IN, ROOMS_TRAVERSED_OUT,
    KEYS_USED_IN, KEYS_USED_OUT,
    DIRTY_ROOMS_IN, DIRTY_ROOMS_OUT) :-
	treasure_in(ROOM),
	all_keys_used(PLAYER_KEYS, KEYS_USED_IN),
	string_concat("Treasure found in Room ", ROOM, MESSAGE),
	append(STEPS_IN, [MESSAGE], STEPS_OUT),
	append(ROOMS_TRAVERSED_IN, [], ROOMS_TRAVERSED_OUT),
	append(KEYS_USED_IN, [], KEYS_USED_OUT),
	append(DIRTY_ROOMS_IN, [], DIRTY_ROOMS_OUT).

play(ROOM, PLAYER_KEYS,
     STEPS_IN, STEPS_OUT,
     ROOMS_TRAVERSED_IN, ROOMS_TRAVERSED_OUT,
     KEYS_USED_IN, KEYS_USED_OUT,
     DIRTY_ROOMS_IN, DIRTY_ROOMS_OUT) :-
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
	    DIRTY_ROOMS_X, DIRTY_ROOMS_OUT).

play(ROOM, PLAYER_KEYS,
     STEPS_IN, STEPS_OUT,
     ROOMS_TRAVERSED_IN, ROOMS_TRAVERSED_OUT,
     KEYS_USED_IN, KEYS_USED_OUT,
     DIRTY_ROOMS_IN, DIRTY_ROOMS_OUT) :-
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
	    DIRTY_ROOMS_X, DIRTY_ROOMS_OUT).

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

all_keys_used(KEYS, _) :-
	KEYS = [].

all_keys_used(KEYS, USED_KEYS) :-
	[KEY | REST] = KEYS,
	member(KEY, USED_KEYS),
	all_keys_used(REST, USED_KEYS).