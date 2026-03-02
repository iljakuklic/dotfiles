#!/usr/bin/env bash

MODELS_URL='https://nano-gpt.com/api/v1/models?detailed=true'
FETCH_CMD=(curl --request GET --url "$MODELS_URL")

# Opencode config format conversion
read -r -d '' OPENCODE << EOF
{
    (.id): {
        "name": .name,
        "cost": { "input": .pricing.prompt, "output": .pricing.completion },
        "limit": { "context": .context_length, "output": .context_length }
    }
}
EOF

FORMAT="."

while [ $# -gt 0 ]; do
    case "$1" in
        -i|--input) FETCH_CMD=(cat "$2"); shift 2;;
        --opencode) FORMAT="$OPENCODE"; shift;;
        *) echo "Bad argument: $1" >&2; exit 1;;
    esac
done

"${FETCH_CMD[@]}" | jq "[ .data.[] | $FORMAT ]"
