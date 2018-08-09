#!/bin/sh

tmux new-session \; \
send-keys 'cd $NOTES_BASE_DIR && vim -S notesSession.vimess' C-m \; \
split-window -v -p 10 \; \
send-keys 'cd $NOTES_BASE_DIR/notes' C-m \; \
split-window -h \; \
send-keys 'cd $NOTES_BASE_DIR/status/2018' C-m \; \
rename-window 'Notes' \; \
new-window \; \
send-keys 'ygg && vim' C-m \; \
split-window -v -p 10 \; \
send-keys 'ygg' C-m \; \
rename-window 'ygg' \; \
new-window \; \
send-keys 'yggb && vim' C-m \; \
split-window -v -p 10 \; \
send-keys 'yggb' C-m \; \
rename-window 'ygg branch' \;
