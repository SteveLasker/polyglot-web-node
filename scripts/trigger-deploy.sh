#!/bin/bash

curl -i -u $1 -H "Content-Type: application/json" -X POST -d '{ "definition": { "id": 8 }, "sourceBranch": "refs/heads/master" }' https://azuredevex.visualstudio.com/DefaultCollection/Polyglot/_apis/build/builds?api-version=2.0
