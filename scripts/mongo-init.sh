#!/bin/bash

###
# Инициализируем бд
###

docker exec -it mongos_router mongosh <<EOF
use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
EOF

