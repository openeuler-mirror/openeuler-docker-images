#!/bin/bash

if [ ! -d debug ]; then
    mkdir debug || echo -e "failed to make directory for build"
fi

cd debug && cmake .. -DBUILD_TOOLS=true -DBUILD_CONTRIB=true -DCMAKE_INSTALL_LIBDIR=lib64  && make -j4
