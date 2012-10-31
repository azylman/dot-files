#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -s $DIR/.emacs ~/.emacs
ln -s $DIR/.emacs.d/ ~/.emacs.d
ln -s $DIR/.slate ~/.slate
