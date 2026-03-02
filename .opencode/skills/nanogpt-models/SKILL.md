---
name: nanogpt-models
description: Update nanogpt models in opencode config by fetching from API and merging into opencode.json
compatibility: opencode
---

## What I do

Manage the list of available nanogpt models in opencode's configuration. When requested, I will:

1. Run the fetch script to get the latest models from nanogpt API
2. Format the output using jq into the opencode config format
3. Update the nanogpt-models.json file with the new model list
4. Merge the models into opencode.json under provider.NanoGPT.models

## When to use me

Use this when you need to update the nanogpt models list in opencode config, either:
- On a scheduled basis (e.g., monthly)
- When new models are announced
- When model pricing or limits change

## How to update models

### Step 1: Fetch models from API

Run the fetch script with the --opencode flag to get properly formatted output:

```bash
./fetch.sh --opencode
```

### Step 2: Process with jq

The fetch script outputs an array of objects. Use jq to convert to opencode format:

```bash
# Merge all model objects into a single object
jq -s 'add' nanogpt-models.json
```

### Step 3: Update opencode.json

The opencode config expects models in this format:

```json
"provider": {
  "NanoGPT": {
    "models": {
      "model-id": {
        "name": "Model Name",
        "cost": { "input": 0.28, "output": 0.42 },
        "limit": { "context": 163000, "output": 163000 }
      }
    }
  }
}
```

Key points:
- Model ID is the key (e.g., "deepseek/deepseek-v3.2")
- cost.input and cost.output are prices per million tokens
- limit.context and limit.output are token limits
- The fetch script's --opencode flag already produces the correct structure

### Step 4: Update nanogpt-models.json

Save the fetched model list to nanogpt-models.json for future reference:

```bash
./fetch.sh --opencode > nanogpt-models.json
```

Then merge into opencode.json using jq:

```bash
jq --argjson models "$(cat nanogpt-models.json)" \
   '.provider.NanoGPT.models = $models' \
   opencode.json > opencode.json.tmp && mv opencode.json.tmp opencode.json
```
