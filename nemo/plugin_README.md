Steps:
- Added a `NemoWrapperPlugin` in `plugin_external.py` - this is meant to invoke the simple flow in `pii_detect_config` which leverages an ollama model through host.docker.internal.
- Referenced `NemoWrapperPlugin` in the plugins list under `resources/config` and confirmed 2 plugins are loaded
- Built plugins adapter image with the entire `nemo` directory - note this requires gcc/g++ for annoy with nemoguardrails.
- Replaced the plugins adapter image referenced by the ext-proc as usual.
- Ran `make inspect-gateway` for the gateway to test with `test2_hello_world`