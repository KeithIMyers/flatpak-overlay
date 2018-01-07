# flatpak-overlay
A Gentoo ebuild overlay for the [Flatpak](http://flatpak.org/) application distribution format.

Note that this only installs the Flatpak application, for usage see the main Flatpak website. 

The Flatpak ebuild does not track actual applications installed by Flatpak like Gentoo would. Flatpak uses [OSTree](https://wiki.gnome.org/Projects/OSTree) to install and track applications and runtimes in /var, so the base Gentoo installation will not be touched. It is also possible to install applications and runtimes on a per user basis only.

## How to use this overlay?

There are two main methods for making use of this overlay, discussed in the sections below.

### Local overlays

For the [local overlay](https://wiki.gentoo.org/wiki/Overlay/Local_overlay) method, create a `/etc/portage/repos.conf/flatpak-overlay.conf` file containing the following bit of text.

```
[flatpak-overlay]
priority = 50
location = <repo-location>/flatpak-overlay
sync-type = git
sync-uri = git://github.com/fosero/flatpak-overlay.git
auto-sync = Yes
```

Change `repo-location` to a path of your choosing and then run `emerge --sync`, Portage should now find and update the repository.

### Layman

You can also use the Layman tool to add and sync the overlay, read the instructions on the [Gentoo Wiki](http://wiki.gentoo.org/wiki/Layman#Adding_custom_overlays).

The repositories.xml can be found at `https://raw.githubusercontent.com/fosero/flatpak-overlay/master/repositories.xml`.

### Neverware

Add the overlay to the build:

    cd src/private-overlays
    git clone git@github.com:neverware/flatpak-overlay.git
    cd flatpak-overlay
    git checkout <neverware branch>
    
Add the overlay to the board masters:

    src/private-overlays/overlay-<board>-private/metadata/layout.conf
    masters = ... flatpak-overlay

Refresh configs:

    ./setup_board --board=chromeover64 --skip_chroot_upgrade --regen_configs

Build:

    emerge-chromeover64 gdbus-codegen  # not sure why, but doing this first fixed some dependency errors
    emerge-chromeover64 Xwayland
    emerge-chromeover64 flatpak
Add flatpak as a runtime dependency somewhere, rebuild packages and
the image.

#### Runtime Notes

If running in a VM it's helpful to create a separate storage drive for
the apps:

    host$ qemu-img create data.bin 16G
      vm$ mkfs.ext4 /dev/sdb
      vm$ mkdir /var/lib/flatpak
      vm$ mount /dev/sdb /var/lib/flatpak

You must log in for the wayland socket to be active, guest user is not
enough.

Example of installing an app:

    flatpak remote-add --if-not-exists gnome https://sdk.gnome.org/gnome.flatpakrepo
    flatpak install --from https://git.gnome.org/browse/gnome-apps-nightly/plain/gedit.flatpakref?h=stable
    flatpak run org.gnome.gedit
    XDG_RUNTIME_DIR=/run/chrome flatpak run org.gnome.gedit
