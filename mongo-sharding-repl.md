Инициализация шагов шардирования в MongoDB

1. Подключаемся к конфиг серверу
```shell
docker exec -it configSrv mongosh --port 27017
```

2. Выполните для инциализации конфигурации
```shell
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
```shell
exit(); 
```

4. Подключаемся к шарду 1 серверу

```shell
docker exec -it shard1-rs1 mongosh --port 27018
```
5. Выполните для инциализации шарда 1
```shell
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
```shell
exit();
```
7. Подключаемся к шарду 2 серверу
```shell
docker exec -it shard2-rs1 mongosh --port 27021
```
8. Выполните для инциализации шарда 2
```shell
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
```shell
 exit();
```

10. Подключаемся роутеру
```shell
docker exec -it mongos_router mongosh --port 27020
```
11. Добавляем реплику 1 для шарда1
```shell
sh.addShard( "shard1/shard1-rs1:27018");
```
12. Добавляем реплику 2 для шарда1
```shell
sh.addShard( "shard1/shard1-rs2:27019");
```
13. Добавляем реплику 1 для шарда2
```shell
sh.addShard( "shard1/shard2-rs1:27018");
```
14. Добавляем реплику 2 для шарда2
```shell
sh.addShard( "shard1/shard2-rs2:27019");
```
15. Инициализируем шардинг для бд
```shell
sh.enableSharding("somedb");
```
16. Инициализируем коллекцию
```shell
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
```
17. Отключится от роута
```shell
 exit();
```