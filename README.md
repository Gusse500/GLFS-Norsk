# Gaming Linux From Scatch (GLFS)

Gaming Linux From Scratch is a book that covers how to install packages
like Steam and Wine after the Linux From Scratch book.

# Where to Read

Go to https://glfs-book.github.io/glfs/ and start going through the book!

The book online is rolling release but there is a stable version in the GLFS
source via the `stable` branch.

You can switch to it by running the following command:
```Bash
git checkout stable
```

Then render the book by running `make STAB=release`.

There are also [Releases](https://github.com/glfs-book/glfs/releases) that you
can download. All of them contain both the SysV and Systemd editions of the
book, chunked HTML.

# Installation

How do I convert these XML files to HTML myself? You need to have some software
installed that deal with these conversions. Please read the `INSTALL.md` file to
determine what programs you need to install and where to get instructions to
install that software.

After that, you can build the HTML with a simple `make` command.
You can change the revision, ie. systemd vs sysv by adding `REV=<rev>` to the
`make` command. `<rev>` can be:
- `sysv` (default)
- `systemd`

Example: `make REV=systemd`.

The default target (sysv) builds the HTML in `~/public_html/glfs`,
whereas for systemd, it would be in `~/public_html/glfs-systemd`.

It will by default make each package and section its own page then link
everything together for a smooth experience.

The dark theme is also the default, but you can switch the theme by
running `make GLFS_THEME=<theme>`. `<theme>` can equal:
- light
- dark

Defaults can be changed in a file that isn't tracked (`local.mk`) by declaring
variables found in `Makefile` in `local.mk`, such as `REV` and `GLFS_THEME`.
This file must be created manually.

Makefile targets are: `pdf`, `nochunks`, `validate`, and `glfs-patch-list`.

`pdf`: builds GLFS as a PDF file.

`nochunks`: builds GLFS in one huge file.

`validate`:  does an extensive check for XML errors in the book.

`glfs-patch-list`: generates a list of all GLFS controlled patches in the book.
