# Nemo guardrails trial

Repo: https://github.com/NVIDIA-NeMo/Guardrails

All examples here were tried with an [ollama](https://ollama.com/) model to avoid use of a legitimate/paid-for OpenAI API key. For the server deployment, this required updating the example [here](https://github.com/NVIDIA-NeMo/Guardrails/blob/develop/examples/bots/hello_world/config.yml) to point to a locally-run `ollama` model `llama3.2:3b-instruct-fp16`.

```yaml
models:
  - type: main
    engine: ollama
    model: llama3.2:3b-instruct-fp16
    parameters:
      base_url: http://host.docker.internal:11434
```

Result quality may vary. For 'refusals', my results included mostly message repetition.

## Local

`local_test.py` is a small example of trying out a locally-provided config. THe configs generally point to an `ollama`-served model via localhost
- The `hello_world_config` dir has the most basic example with its `rails.co` a replica of https://github.com/NVIDIA-NeMo/Guardrails/blob/develop/examples/bots/hello_world/rails.co.
- The `pii_detect_config` dir has a simple regex implementation that results in stopped generation with PII detected.

## Server deployment

- The Nemo guardrails server can be built from https://github.com/NVIDIA-NeMo/Guardrails/blob/develop/Dockerfile with `docker build -t nemoguardrails:latest .` This already includes example configs from https://github.com/NVIDIA-NeMo/Guardrails/tree/develop/examples/bots.
- A k8s service and deployment resource are included in `deploy.yaml` in this directory.
- The guardrails server typically uses port `8000`. The service uses port `50053`.
- After deployment, the service can be port-forwarded to try out the server with `oc port-forward svc/nemoguardrails-server-service 50053:50053 -n istio-system`.
- Commands like that in `trial_commands.sh` can be tried out. Other server commands can be found here: https://docs.nvidia.com/nemo/guardrails/0.19.0/user-guides/server-guide.html
