An Envoy ext-proc to configure and invoke guardrails for MCP Gateway.

## Quick Install

* Expects configured [kubectl](https://kubernetes.io/docs/reference/kubectl/) in cli
* Use pre-built image to deploy
    ```
    git clone https://github.com/kagenti/plugins-adapter.git
    cd plugins-adapter
    make deploy_quay
    ```


## Full Dev Build

* Build protobufs
	```
	python3 -m venv .venv
	source .venv/bin/activate

	./proto-build.sh

	```
* Verify src folder contains `/envoy`,`/validate`,`/xds`,`/udpa`
* Deploy to kind cluster
	```
	make all
	``` 

## Configure Plugins

* Update `resources/config/config.yaml` with list of plugins
* `make all`

### Build proto step by step, instead of running proto-build.sh

1. Install protoc. See instructions if [needed](https://betterproto.github.io/python-betterproto2/getting-started/).
- Install the proto compiler and tools:
```sh
pip install -r requirements-proto.txt
```
2. Build the python `envoy` protobufs
- Code to help pull and build the python code from proto files: `https://github.com/cetanu/envoy_data_plane.git`
- Run: `python build.py`.
NOTE: This will build the envoy protos in `src/envoy_data_plane_pb2/` Copy the `src/envoy_data_plane_pb2/envoy` directory to where you need it.
```sh
git clone git@github.com:cetanu/envoy_data_plane.git
cd envoy_data_plane
python build.py
cd ..
cp -r envoy_data_plane/src/envoy_data_plane_pb2/envoy plugins-adapter/src/
```

3. Get the python xds protobufs:
```sh
git clone https://github.com/cncf/xds.git
cp -rf xds/python/xds xds/python/validate xds/python/udpa plugins-adapter/src/
```
NOTE: This repo contains the python code for `validate`, `xds`, and `udpa`. Go to folder `python`. Copy the needed folders or run
setup.py to install.

4. In the end you need `envoy`, `validate`, `xds`, `udpa` python protobufs folders copied into `src` to run example server.py
5. `pip install -r requirements.py`
6. Run `python server.py`

### Deploy to kind cluster

make all


### Enable debug logs for mcp-gateway envoy routes if needed
* From mcp-gateway folder:
`make debug-envoy-impl`
