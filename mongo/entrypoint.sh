#!/bin/bash

mongod --fork --logpath /var/log/mongodb/mongodb.log

node /root/ide/src-gen/backend/main.js --hostname=0.0.0.0 --port=3030 --plugins=local-dir:/root/ide/plugins
