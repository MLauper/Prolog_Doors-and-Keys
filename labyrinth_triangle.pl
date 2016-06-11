treasure_in(room4).

door(room0, room1, key01).
door(room0, room2, key02).
door(room1, room2, key12).
door(room0, room4, key04).

contains_key(room0, key01).
contains_key(room1, key02).
contains_key(room2, key12).
contains_key(room2, key04).
