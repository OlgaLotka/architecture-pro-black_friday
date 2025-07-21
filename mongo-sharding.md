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
docker exec -it shard1 mongosh --port 27018
```
5. Выполните для инциализации шарда 1
```shell
 rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1:27018" },
       // { _id : 1, host : "shard2:27019" }
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
docker exec -it shard2 mongosh --port 27019
```
8. Выполните для инциализации шарда 2
```shell
rs.initiate(
    {
      _id : "shard2",
      members: [
       // { _id : 0, host : "shard1:27018" },
        { _id : 1, host : "shard2:27019" }
      ]
    }
  );
```
9. Отключится от шарда 2
```shell
 exit();
```