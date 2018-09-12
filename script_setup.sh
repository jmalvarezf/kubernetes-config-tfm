#!/bin/bash

curl -X DELETE http://elasticsearch.elejandria.site:9200/events
curl -v -X POST -d @elastic-connector-config.json -H "Content-type: application/json" http://kafka-connect.elejandria.site:8083/connectors
curl -f -XPOST -H "Content-Type: application/json" -H "kbn-xsrf: cluster" 'http://kibana.elejandria.site/api/saved_objects/index-pattern/events*' -d'{"attributes":{"title":"events*"}}'

