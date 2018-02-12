# Pong

A game of pong for 1 or 2 players, implemented in Lua with
[LÖVE](https://love2d.org/).


## Prerequisites

Install LÖVE v0.10:

```bash
$ wget https://bitbucket.org/rude/love/downloads/liblove0_0.10.2ppa1_amd64.deb

$ wget https://bitbucket.org/rude/love/downloads/love_0.10.2ppa1_amd64.deb

$ sudo apt install ./liblove0_0.10.2ppa1_amd64.deb ./love_0.10.2ppa1_amd64.deb
```


## Usage

```bash
$ cd /path/to/project

$ make

$ love pong.love
```

Use <kbd>Space</kbd> to serve or to pause the game.  Use the <kbd>1</kbd>
and <kbd>2</kbd> keys to switch between single-player and two-player
modes.  Use the <kbd>W</kbd>/<kbd>S</kbd> or <kbd>Up</kbd>/<kbd>Down</kbd>
arrow keys to control the left paddle.  In two-player mode, use the
<kbd>I</kbd>/<kbd>K</kbd> keys to control the right paddle.
