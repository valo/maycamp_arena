#!/bin/bash
tr -d '\r' < $1 > .dos2unix.tmp
mv .dos2unix.tmp $1

