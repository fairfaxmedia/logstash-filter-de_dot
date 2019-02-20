#!/bin/bash

find -maxdepth 1 -name '*.gem' -exec cp -v {} pkg/ \;
