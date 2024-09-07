# PrivateGPT

Repo to build local PrivateGPT into a container

## Build steps

1. Setup a development environment, you can follow the steps [here](https://github.com/msimonelli331/DevOpsEnv)
2. Setup a local container build in you development environment
   - You could fork this repo into gitea and the container would build, assuming you setup the devopsenv following the steps linked above

## Install steps

1. Install the helm chart. **Note: If you did not setup a development environment using the link above, or if you changed the container registry name or domain you must edit the values file**

```bash
helm repo add ghcr https://msimonelli331.github.io/PrivateGPT
helm install privategpt ghcr/privategpt --create-namespace -n devops \
--set env[0].name=HF_TOKEN \
--set env[0].value=<your token> \
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

## Issues:

- The container built in this pipeline cannot be used because it will throw an "Illegal Instruction" error
  - This is because the runner that github uses likely does not run on the same machine type as you
  - You must build this locally
  - Follow the steps from [this repo](https://github.com/msimonelli331/DevOpsEnv) if you'd like to setup a pipeline capable of building this locally
