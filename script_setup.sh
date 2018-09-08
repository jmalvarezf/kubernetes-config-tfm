#!/bin/bash

curl -X DELETE http://192.168.99.100:30912/events
curl -v -X POST -d @elastic-connector-config.json -H "Content-type: application/json" http://192.168.99.100:32190/connectors
curl -f -XPOST -H "Content-Type: application/json" -H "kbn-xsrf: cluster" 'http://192.168.99.100:31096/api/saved_objects/index-pattern/events*' -d'{"attributes":{"title":"events*"}}'

