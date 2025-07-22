Инициализация шагов шардирования в MongoDB

1. Подключаемся к конфиг серверу
```bash
docker exec -it configSrv mongosh --port 27017
```

2. Выполните для инциализации конфигурации
```bash
rs.initiate(
{
    _id : "config_server",
    configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
    }
);
```
3. Отключится от сервера конфигурации
```bash
exit(); 
```

4. Подключаемся к шарду 1 серверу

```bash
docker exec -it shard1-rs1 mongosh --port 27018
```
5. Выполните для инциализации шарда 1
```bash
 rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1-rs1:27018" },
        { _id : 1, host : "shard1-rs2:27019" }
      ]
    }
);
```  
6. Отключится от шарда 1
```bash
exit();
```
7. Подключаемся к шарду 2 серверу
```bash
docker exec -it shard2-rs1 mongosh --port 27021
```
8. Выполните для инциализации шарда 2
```bash
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 0, host : "shard2-rs1:27021" },
        { _id : 1, host : "shard2-rs2:27022" }
      ]
    }
  );
```
9. Отключится от шарда 2
```bash
 exit();
```

10. Подключаемся роутеру
```bash
docker exec -it mongos_router mongosh --port 27025
```
11. Добавляем реплику 1 для шарда1
```bash
sh.addShard("shard1/shard1-rs1:27018");
```
12. Добавляем реплику 2 для шарда1
```bash
sh.addShard("shard1/shard1-rs2:27019");
```
13. Добавляем реплику 1 для шарда2
```bash
sh.addShard("shard2/shard2-rs1:27021");
```
14. Добавляем реплику 2 для шарда2
```bash
sh.addShard("shard2/shard2-rs2:27022");
```
15. Инициализируем шардинг для бд
```bash
sh.enableSharding("somedb");
```
16. Инициализируем коллекцию
```bash
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
```
17. Отключится от роута
```bash
 exit();
```
18. Инициализируем кластер из нод редиса
```bash
docker exec -it redis_1 /bin/bash
echo "yes" | redis-cli --cluster create   173.17.0.13:6379   173.17.0.14:6379   173.17.0.15:6379   173.17.0.16:6379   173.17.0.17:6379   173.17.0.18:6379   --cluster-replicas 1
```
19. Отключится от редиса
```bash
 exit();
```