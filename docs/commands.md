# Uselful commands


iex --sname node-1 --cookie 98796e49-6e99-4b8f-8ee1-80c204723037 -S mix s

iex --sname node-2 --cookie 98796e49-6e99-4b8f-8ee1-80c204723037 -S mix

iex --sname node-3 --cookie 98796e49-6e99-4b8f-8ee1-80c204723037 -S mix


Node.self

Node.connect


docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id


docker-compose exec crash-node-1 bash

docker-compose exec crash-node-2 bash
