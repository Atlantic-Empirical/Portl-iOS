## Rooms Data Source

### Reloads:

- when entering foreground (last reload > 2 min)
- when switching to room list (last reload > 2 min)

### Updates:

- room added
- room removed
- room updated
- new message
- new activity

## Activity Data Source

### Reloads:

- when entering foreground (last reload > 5 min)
- when switching to activity tab (last reload > 2 min)
- when entering foreground while in activity tab (last reload > 2 min)
- new activity

## Friends Data Source

### Reloads:

- when entering foreground (last reload > 5 min)
- when switching to people tab (last reload > 2 min)
- when entering foreground while in people tab (last reload > 2 min)

### Updates:

- friend added
- friend removed

## Contacts Data Source

### Reloads:

- when entering foreground (last reload > 5 min)
- when switching to people tab (last reload > 2 min)
- when entering foreground while in people tab (last reload > 2 min)
- when Address Book changes

### Updates:

- new contact joins (`kNotificationContactJoined`)

## Blocked Data Source

### Reloads:

- when entering foreground (last reload > 10 min)

### Updates:

- user blocked
- user unblocked

## Room Presence Data Source

### Reloads:

- when entering room
- when opening room members tray
- when entering foreground (last reload > 2 min)
- when coming back from room list to the same room (last reload > 2 min)

### Updates:

- member added (`kNotificationRoomMembersAdded`)
- member removed (`kNotificationRoomMembersRemoved`)
- room presence updated (`kNotificationPresenceSynced`)

## Pending Friends Data Source

### Reloads:

- when entering foreground (last reload > 10 min)
- when switching to people tab (last reload > 2 min)
- when entering foreground while in people tab (last reload > 2 min)

### Updates:

- added you as friend (`kNotificationAddedYouAsFriend`)
- friend added (`kNotificationFriendAdded`)

## Messages Data Source

### Reloads:

- when entering a room
- when entering foreground (last reload > 2 min)
- when coming back from room list to the same room (last reload > 2 min)
- when history is cleared (`kNotificationRoomClearHistory`)

### Updates:

- new message (`kNotificationRoomNewMessage`)
- message removed (`kNotificationRoomDeletedMessage`)
- message updated (`kNotificationRoomUpdatedMessage`)
