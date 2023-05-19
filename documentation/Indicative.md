# Indicative

## #WorstDecisionEver

Luckily we already moved away from them, but here is a dump/rant of my complaints, so that we don't repeat the past:

TL;DR; If we're going to pay for a service, stick with the expensive one that has been around for years and has worked perfectly. Don't be cheap.

- We had to spend hours emailing and calling with Rahul in order to wrap our heads around their Alias flow, quirks and edge cases.
- We eventually understood their flow, and needed to make changes to their client SDK. We communicated this and said we would send a pull request within the day. We send a PR and send them an email. It takes an entire month to be merged in. It was the second pull request they ever received in two years.
- The web analytics dashboards and graphs take way too long to load. I imagine this getting worse as we have more data.
- They have no people properties. Instead, we need to send any of this data on every single event. This just bloats every event and data usage.
- The Indicative client does absolutely no logic to account for clock skew between devices and the server, or manual clock adjustments by users.
- The Indicative client does absolutely no logic for event persistence. The app dies/crashes/quits? No internet connection? Bye bye events!
- God knows what else a professional analytics solution does that Indicative doesn't, that we simply are unaware of because... we are not in the analytics business!

</rant>
