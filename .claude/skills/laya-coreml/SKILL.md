---
name: laya-coreml
description: Run local typed decisions (choice / score / yes-no probabilities, zero generated tokens) with the laya-coreml Python package on Apple Silicon via Core ML and the Neural Engine. Use when the user wants a fast on-device classifier/router/decision model on a Mac, mentions Laya, laya-coreml, Core ML or ANE inference of Laya, wants to run the Laya Snake demo, or wants to convert Laya checkpoints to Core ML. Requires macOS 15+ on Apple Silicon — it cannot run on Linux or in cloud containers.
---

# laya-coreml

[laya-coreml](https://github.com/mizorewww/laya-coreml) (Apache-2.0, PyPI
`laya-coreml`) is an independent Core ML port of
[Laya](https://github.com/NandhaKishorM/laya). Given a *state* (text or a dict)
and a dict of typed *questions*, it returns calibrated probabilities directly —
no autoregressive decoding, no JSON to parse (`usage.output_tokens` is always 0).

## Check the platform first

- Requires **Apple Silicon, macOS 15+, Python 3.11–3.13**. Run `uname -sm`;
  anything other than `Darwin arm64` cannot run inference. On Linux / cloud
  sessions, write the code and explain how to run it on a Mac — do not try to
  install or execute it there.
- Inference needs only Core ML Tools, NumPy, Tokenizers, Safetensors and
  Hugging Face Hub — no PyTorch, Transformers or MLX.

## Install

```bash
python -m pip install laya-coreml            # inference
python -m pip install 'laya-coreml[demo]'    # + terminal Snake demo
python -m pip install 'laya-coreml[convert]' # + PyTorch, for exporting checkpoints
```

## Pick a model (all under `aac6fef/` on Hugging Face)

| Bundle | Default compute | Token capacity | Use |
|---|---|---:|---|
| `laya-multilingual-coreml` | CPU+GPU | 1024 | **Default choice** — general multilingual, 322M |
| `laya-coreml` | CPU+GPU | 512 | Original English, 421M |
| `laya-typed-decisions-coreml` | CPU+GPU | 1024 | Upstream typed-decisions checkpoint |
| `laya-multilingual-coreml-ane` | CPU+ANE | **96 total** | Fastest (~5 ms P50 on M3 Max) short decisions |
| `laya-multilingual-coreml-ane-w8` | CPU+ANE | 96 total | Approximate W8 weights, FP16 compute |
| `laya-multilingual-coreml-snake` | CPU+GPU | 64, batch 3 | Snake demo only |

The ANE bundles' 96-token budget covers question + options + markers + state;
requests that don't fit raise a capacity error. Use the 1024-token model for
anything longer.

## Python API

```python
import laya_coreml as laya

agent = laya.load("aac6fef/laya-multilingual-coreml")  # or a local dir
result = agent.predict(
    "The customer asks for a refund of a duplicate payment.",
    {
        "department": {
            "type": "choice",
            "instructions": "Which department should handle this request?",
            "criteria": {  # dict of label -> description, or a plain list of labels
                "billing": "Payments, invoices, refunds, and duplicate charges.",
                "technical": "Broken features, errors, and product troubleshooting.",
                "sales": "Pricing, upgrades, and new purchases.",
            },
        },
        "urgency": {
            "type": "score",  # ordinal; returns expected zero-based index
            "instructions": "How urgent is the request?",
            "criteria": ["low", "medium", "high"],
        },
        "refund": {
            "type": "noul",   # boolean; returns probability of true
            "instructions": "Does the customer request a refund?",
        },
    },
)
print(result["answers"])
```

- Question types: `choice` (selected label + per-label probabilities),
  `score` (expected index, legend, probabilities), `noul` (P(true)).
- `predict` and `system_one` are aliases. Dict states are serialized using the
  original Laya conventions. Questions run in insertion order, one model call
  each (batch 1) — no cross-question caching.
- `load(..., compute_units="cpu_gpu" | "cpu_ne" | "cpu" | "all")` overrides the
  bundle default; `revision="<commit SHA>"` pins a Hub snapshot.
- Calibration temperatures are clamped to `[0.5, 5.0]` (a `RuntimeWarning` names
  clamped buckets); raw values are on `agent.temperature_raw`.
- Probabilities are model estimates and can be wrong — the project's validation
  covers conversion fidelity, not task accuracy. Say so when presenting results.

## Offline use

```bash
hf download aac6fef/laya-multilingual-coreml-ane --local-dir models/ane
```

```python
agent = laya.load("./models/ane", local_files_only=True)
```

Hub-cache loads are materialized as regular files under
`~/.cache/laya-coreml/packages/` (override with `LAYA_COREML_CACHE`).
First-time Core ML initialization can take tens of seconds.

## CLI

```bash
laya-coreml predict ./models/ane --offline \
  --state 'The customer requests a refund.' --questions questions.json
laya-coreml convert laya-multilingual models/custom   # needs [convert]
```

`questions.json` holds the same question dict as the Python API.

## Snake demo

```bash
pip install 'laya-coreml[demo]'
hf download aac6fef/laya-multilingual-coreml-ane --local-dir models/snake
laya-coreml-snake --model ./models/snake
```

Needs a 104×35 terminal. Space pauses, ↑/↓ speed, R reset, Q quit.

## Further docs

Usage, conversion, benchmarks and release pins live in the upstream `docs/`
folder: `USAGE.md`, `CONVERSION.md`, `ANE_BENCHMARKS.md`, `SNAKE_DEMO.md`,
`RELEASE.md`.
