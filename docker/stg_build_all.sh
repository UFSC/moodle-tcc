#!/bin/bash

cd latex_passenger
./dev_build.sh
cd ..
cd staging_passenger
./stg_build_base.sh
./stg_build.sh
cd ..
