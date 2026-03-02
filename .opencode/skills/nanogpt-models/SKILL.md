---
name: nanogpt-models
description: Update nanogpt models in opencode config by fetching from API and merging into opencode.json
compatibility: opencode
---

## What I do

Manage the list of available nanogpt models in opencode's configuration. When requested, I will:

1. Run the fetch script to get the latest models from nanogpt API
2. Save the model list to nanogpt-models.json
3. Merge the models into opencode.json under provider.NanoGPT.models

## When to use me

Use this when you need to update the nanogpt models list in opencode config, either:
- On a scheduled basis (e.g., monthly)
- When new models are announced
- When model pricing or limits change

## How to update models

### Step 1: Fetch models from API

```bash
./fetch.sh --opencode > nanogpt-models.json
```

This produces a single object with model IDs as keys:
```json
{
  "model-id": { "name": "...", "cost": {...}, "limit": {...} },
  ...
}
```

### Step 2: Look up specific models

```bash
jq '."claude-sonnet-4-5-20250929"' nanogpt-models.json
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

Merge the fetched models into opencode.json:

```bash
jq --argfile models nanogpt-models.json '.provider.NanoGPT.models = $models' \
   opencode.json > opencode.json.tmp && mv opencode.json.tmp opencode.json
```
