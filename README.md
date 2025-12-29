# PrivateGPT

Repo to build local PrivateGPT into a container

## Build steps

1. Setup a development environment, you can follow the steps [here](https://github.com/msimonelli331/DevOpsEnv)
2. Setup a local container build in you development environment
   - You could fork this repo into gitea and the container would build, assuming you setup the devopsenv following the steps linked above

## Install steps

```bash
kubectl create ns gpu-operator
kubectl label --overwrite ns gpu-operator pod-security.kubernetes.io/enforce=privileged
```

```bash
helm repo add nvidia https://helm.ngc.nvidia.com/nvidia
helm repo update
```

```bash
helm install gpu-operator -n gpu-operator --create-namespace \
  nvidia/gpu-operator \
    --set toolkit.env[0].name=CONTAINERD_CONFIG \
    --set toolkit.env[0].value=/var/snap/microk8s/current/args/containerd-template.toml \
    --set toolkit.env[1].name=CONTAINERD_SOCKET \
    --set toolkit.env[1].value=/var/snap/microk8s/common/run/containerd.sock \
    --set toolkit.env[2].name=CONTAINERD_RUNTIME_CLASS \
    --set toolkit.env[2].value=nvidia \
    --set toolkit.env[3].name=CONTAINERD_SET_AS_DEFAULT \
    --set-string toolkit.env[3].value=true
```

1. Create the host volume directory

   ```bash
   mkdir -p /mnt/devops/privategpt
   ```

2. Label the node this local volume is running on

   ```bash
   kubectl label nodes localhost.localdomain privategpt=local
   ```

3. Install the helm chart. **Note: If you did not setup a development environment using the link above, or if you changed the container registry name or domain you must edit the values file**

   ```bash
   helm repo add ghcr https://msimonelli331.github.io/PrivateGPT
   helm install privategpt ghcr/privategpt --create-namespace -n devops \
   --set env[0].name=OLLAMA_IP \
   --set env[0].value=127.0.0.1 \
   -f privategpt-values.yaml
   ```

## Resources

- https://github.com/moby/buildkit/blob/master/.github/workflows/buildkit.yml
- https://docs.github.com/en/actions/use-cases-and-examples/publishing-packages/publishing-docker-images
- https://docs.github.com/en/packages/quickstart
- https://docs.docker.com/build/ci/github-actions/configure-builder/
- https://github.com/docker/setup-buildx-action
- https://github.com/docker/build-push-action/tree/master
- https://github.com/orgs/community/discussions/25678
- https://docs.privategpt.dev/manual/general-configuration/configuration
- https://docs.privategpt.dev/manual/storage/vector-stores
- https://docs.privategpt.dev/installation/getting-started/troubleshooting
- https://helm.sh/docs/howto/chart_releaser_action/
- https://github.com/helm/chart-releaser-action
- https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
- https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/getting-started.html#operator-install-guide

- https://github.com/ggerganov/llama.cpp/blob/master/docs/docker.md
- https://github.com/zylon-ai/private-gpt/blob/77461b96cf2e18b88b592fff441206a49826db97/fern/docs/pages/installation/installation.mdx#L294
- https://github.com/zylon-ai/private-gpt/blob/77461b96cf2e18b88b592fff441206a49826db97/fern/docs/pages/quickstart/quickstart.mdx#L2
- https://github.com/zylon-ai/private-gpt/blob/77461b96cf2e18b88b592fff441206a49826db97/private_gpt/settings/settings.py#L163
- https://github.com/abetlen/llama-cpp-python
- https://docs.privategpt.dev/installation/getting-started/installation#local-llama-cpp-powered-setup

## Issues:

- The container built in this pipeline cannot be used because it will throw an "Illegal Instruction" error
  - This is because the runner that github uses likely does not run on the same machine type as you
  - You must build this locally
  - Follow the steps from [this repo](https://github.com/msimonelli331/DevOpsEnv) if you'd like to setup a pipeline capable of building this locally
