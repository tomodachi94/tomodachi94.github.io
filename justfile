#!/usr/bin/env just --justfile

# Build the website (best for development)
build:
	hugo build

# Build using Nix to emulate production as close as possible
build-pure:
	nix build

serve:
	hugo serve

new-post slug:
	hugo new content --kind blogpost content blog/{{slug}}.md

check-links: build-pure
	lychee ./result
