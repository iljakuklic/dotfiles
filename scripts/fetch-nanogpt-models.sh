#!/usr/bin/env bash
curl --request GET --url 'https://nano-gpt.com/api/v1/models?detailed=true' | jq .
