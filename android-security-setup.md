# Android: see who tracks you and catch hacking attempts

Setup takes about 30 minutes. Menu names vary a little by brand (Samsung, Pixel, Xiaomi), so use the Settings search bar if a path doesn't match.

## 1. Tracker blocking with alerts (pick ONE)

Android allows only one VPN-type app at a time, and both options below use that slot.

**Option A: DuckDuckGo App Tracking Protection** (easiest, sends notifications)
1. Install **DuckDuckGo** from the Play Store.
2. Open it → Settings → **App Tracking Protection** → Enable.
3. Allow notifications. It tells you how many tracking attempts it blocked and which companies (for example Google, Meta, TikTok) each app tried to send data to.

**Option B: TrackerControl** (more detail: company and destination country per app)
1. Install it from **F-Droid** or GitHub (`TrackerControl/tracker-control-android`). The Play Store version can monitor but not block.
2. Open it → Start → accept the VPN request.
3. Tap any app to see its trackers, the company behind each one, and which country the data goes to. Block them per app.

## 2. Log every domain your phone contacts (NextDNS)

1. Sign up free at **nextdns.io** and note your config ID.
2. In the NextDNS dashboard → Privacy → add the **NextDNS Ads & Trackers** blocklist and turn on **Native Tracking Protection** for your phone brand.
3. On the phone: Settings → Network & internet → **Private DNS** → *Private DNS provider hostname* → `YOURID.dns.nextdns.io`.
4. The dashboard's **Logs** tab shows each domain contacted, which ones were blocked, and the countries traffic went to.

If this conflicts with the app from step 1 (pages stop loading), keep only one of them.

## 3. Detect hacking and spyware

- **Play Protect**: Play Store → profile icon → Play Protect → turn on and run a scan.
- **iVerify Basic** (Play Store): scans for known spyware and flags risky settings.
- **Check for hidden control apps**. Remove anything you don't recognize from:
  - Settings → Security & privacy → More → **Device admin apps**
  - Settings → **Accessibility** → Installed apps (spyware often hides here)
  - Settings → Apps → Special app access → **Install unknown apps** (turn all off)
- **Android 16: Advanced Protection**: Settings → Security & privacy → **Advanced Protection** → On. This is Google's strictest mode.
- **Fake cell towers**: Settings → Network & internet → SIMs → turn **Allow 2G** off. If your phone has *Network notifications* or *cellular security* alerts, turn them on.

## 4. Get alerted when someone tries your accounts

- Go to **myaccount.google.com/security-checkup**. Turn on **2-Step Verification** (use a passkey or the phone prompt, not SMS), remove devices you don't know, and review third-party access.
- Google then emails and notifies you on **every new sign-in**, with the device and approximate location.
- Do the same in **WhatsApp** (Settings → Account → Two-step verification), your email, and your banking apps.
- **haveibeenpwned.com** → Notify me: you get an email if your address appears in a data breach.

## 5. Ongoing: stop apps watching you

- Settings → Security & privacy → **Privacy dashboard**: shows which apps used location, camera, or microphone in the last 24 hours.
- A green dot in the top corner means the camera or mic is in use right now. Swipe down and tap it to see which app.
- Settings → **Permission manager**: set location to "Only while using" or "Don't allow". Remove microphone, camera, contacts, and SMS access from apps that don't need them.
- Settings → Google → Ads → **Delete advertising ID**.
- Keep Android and apps updated, and only install apps from the Play Store.

## If you think you are already hacked

1. Back up photos and contacts.
2. From a **different, trusted device**, change your Google and email passwords and sign out all other sessions.
3. Factory reset the phone (Settings → System → Reset options → Erase all data) and set it up fresh, without restoring apps from the old backup.
