# Theme architecture

- `theme/HN-Prism-X/xfwm4/`: XFWM4 title-bar and control assets.
- `theme/gtk-3.0/gtk.css`: GTK/VTE terminal surface styling.
- `apply-prism-theme.sh`: installs the XFWM theme and GTK CSS, applies terminal palette/font, snapshots each changed XFConf property, and writes a restore script.
- `enable-prism-blur.sh`: optional X11 Picom blur; separate from theme installation because GL blur may be costly under VMware.

XFWM4 decoration, GTK widget styling, VTE terminal colors and compositor blur are four distinct layers. Applying GTK CSS alone cannot create a neon window border; the XFWM4 theme provides the actual outer frame.
