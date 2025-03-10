#  NewsFlash
## Clefer Code Challenge

-------------------------------

### Running the app

You need to define a config file called `Secrets.xcconfig` to fill in for the one that isn't in this repository. You only need to set add a single directive: `NEWS_API_KEY = <# your API key #>`. This gets interpolated into the `Info.plist` so it can be read and given to the API manager

I did this little song-and-dance so I wouldn't have to keep the API key in this repository, as that's the most common way that API keys get exposed. Note that it's trivial to read this out of the decrypted bundle as an attacker, so I'm going to consider protecting the API key that aggressively to be out-of-scope for this challenge. The reason being that due to the nature of front-end code, anything included in the bundle is inherently exposed, so the only way to be generally confident in the secrecy of a front-end API key is to stand up a public API endpoint that requires authentication with Apple via the `DeviceCheck` stuff and then passes it to the frontend over certificate-pinned HTTPS, which stores it in its keychain. That's a lot of work, so you're going to have to pay me if you want me to do that

I could've also dumped it in the `Info.plist` directly and ignored that, though that feels like overkill since there's a lot more that naturally goes in an `Info.plist` than just keys, and I don't want to completely break the app for you without thinking about it if I end up adding more stuff as I build this

All that said, I just realized this service emailed me my API key in plain text, so this is realistically all just theater to show you that I know what I'm doing, anyway
