# Gsettings / `dconf` Configuration.

The GNOME Foundation built `dconf` to manage application settings in a binary format for fast retrieval. The `dconf` and `dconf-editor` tools
are intended to make editing these settings easy. Information is held within an unstructured key value pair database, which is the `user` file
contained within this folder. It's advisable to back up your individual user database to preserve settings between devices.. Defaults are loaded from
schemas located within the `$XDG_DATA_DIRS/glib-2.0/schemas` folder, which follows the [XDG path spec][XDG_SPEC], where `$XDG_DATA_DIRS` is an array of folders
structured similarly to the `$PATH`.

I've made some security focused changes to my settings such as the following:
 * `org.blueman.plugins.powermanager auto-power-on` is now off to prevent bluetooth being left on when never used. This also reduces power consumption.
 * `org.gnome.desktop.privacy remember-app-usage` is turned off.
 * `org.gnome.desktop.privacy remember-recent-files` is turned off.
 * `org.gnome.desktop.privacy send-software-usage-stats` is turned off because I no likey tracking.
 * `org.gnome.desktop.privacy report-technical-problems` is turned off becuase I'm a power user who will email them directly with a solution if I find an issue.
 * `org.gnome.desktop.privacy hide-identity` is turned on. Helpful: *"system will make an effort to not divulge the user’s identity on screen or on the network."*
 * `org.gnome.desktop.screensaver user-switch-enabled` is turned off. This just makes it harder for law enforcement or a thief to scrape info out of running memory.
   Though law enforcement uses key-jigglers to key devices alive. So this is less impactful there.
 * `org.gnome.desktop.lockdown user-administration-disabled` is true. We only want the `root` administrator to be able to edit system settings. **Hardening**
 * `org.gnome.desktop.lockdown disable-application-handlers` is true. Anti-profiling (TODO: link Weak Web news segment regarding this profiling scheme)
 * `org.gnome.desktop.lockdown disable-user-switching` is true. We want to enforce manditory logouts on inactivity to prevent data leakage. **Hardening**
 * `org.gnome.desktop.thumbnail-cache maximum-age` Has been reduced from the default 180, to 30. Realistically, you shouldn't use a web browser that caches
   Images or thumbnails, any type of asset for that matter. Because trackers can embed tracking data into those cached objects. But this saves drive space
   and forces tracker servers to do a little extra work because fuck'em. You could reset this to make local applications that use thumbnails, like your
   file browser more efficient since they'll have to regenerate thumbnails for file previews less frequently. I mostly just use the CLI so this isn't 
   something I really need to worry about.
 * `org.gnome.desktop.media-handling autorun-never` is now true. This could prevent newbs from pwning your system. A script kiddie is not the same thing.
   BEWARE USB DEVICES, If you're watching your laptop or computer while it's inserted, that's probably fine. No rubber duckies allowed.
 * `org.mate.lockdown disable-application-handlers` Same as `org.gnome.desktop.lockdown`.
 * `org.mate.lockdown disable-user-switching` Same as `org.gnome.desktop.lockdown`.
 * `org.mate.thumbnail-cache maximum-age` Same as `org.gnome.desktop.thumbnail-cache`.
 * `org.gnome.system.location enabled` Turned off to make it impossible for applications to track you if they use the gnome system. Obviously most large businesses
   like google have their own tracking infrastructure which uses your native network information. So it doesn't do a lot, but it's something.
 * `org.gnome.system.location max-accuracy` Set max accuracy to `city` which is helpful on a laptop. Obviously you'd want this to be different if you
   were using the gnome desktop on your phone for services like travel directions. Configure at your leisure.


These settings might get updated in the future, and it's not great security. But it's better than nothing. My scripts in these dotfiles should provide more
robust security options.
 

[XDG_SPEC]: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
