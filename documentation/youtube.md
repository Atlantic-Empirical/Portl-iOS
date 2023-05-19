### Unplayable videos

> Have you ever tried to show a user a YouTube video embedded on your site only to find out that they don’t have access to view it? For instance, if you try to play the video below, it’ll say “This video contains content from test_yt_owner, who has blocked it on copyright grounds.” There are many reasons why video playback can be restricted. The user might be in a country where the video is blocked, or the video’s content owner might have decided to block access to the video from all mobile applications.

> With enhanced content controls comes increased complexity. **The only foolproof way to determine if a user has access to watch a video is to ask them to try watching it.**

http://youtube-eng.blogspot.co.uk/2011/12/understanding-playback-restrictions_28.html

> Unfortunately, no. That specific video can only be played when it's embedded on a real website with a real referring URL, due to the way domain white/blacklisting works. **And no, we don't expose those lists via the API.** It's a longstanding feature request, though. –  Jeff Posnick

> There are even more subtle restrictions that occasionally come into play. Not all of these are currently queryable via the API. For instance, some videos are only playable on a certain set of domains. As I mentioned above, the only foolproof way to know if a user has access to watch a video is to have them try watching it.

http://stackoverflow.com/a/13463245/314042
