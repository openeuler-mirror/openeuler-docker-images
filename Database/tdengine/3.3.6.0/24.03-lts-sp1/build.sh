#!/bin/bash

if [ ! -d debug ]; then
    mkdir debug || echo -e "failed to make directory for build"
fi

cd debug && cmake .. -DJEMALLOC_ENABLED=ON -DBUILD_TOOLS=true -DBUILD_HTTP=false && make -j4
