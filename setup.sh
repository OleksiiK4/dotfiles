#!/bin/bash

pip install debugpy pynvim

if [ "$(uname)" == "Darwin" ]; then
	brew install curl lazygit mingw-64 node ripgrep
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
	choco install curl lazygit mingw nodejs ripgrep -y
fi