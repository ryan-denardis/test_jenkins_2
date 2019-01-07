# test_jenkins_2

This is a test implementation of Jenkins 2, for use by Rhiza. The image used is based on BlueOcean's docker image (https://jenkins.io/projects/blueocean/). This not only provides a useful alternative UI to that native to Jenkins, but also a stable image with a recent version of the software and its dependencies.

There is also a large list of plugins we want to install - this is performed automatically by the Dockerfile.

## Running Jenkins 2 Locally

The Dockerfile in this top-level directory governs the specifics of the docker image - however, a shell script was created to simplify the process of running the image locally via `./run.sh`. The image will be tagged `ryandenardis/test_jenkins`

## Running Jenkins 2 on Kubernetes

The docker image to run on Kubernetes is located at https://cloud.docker.com/repository/docker/ryandenardis/test_jenkins. This is basically the image described above, built and pushed to DockerHub.

Deploying the image to Kubernetes is similar to information located at https://github.com/Rhiza/rhiza/wiki/Deploying-to-Kubernetes, but I'll try to encapsulate the process here.

1. Install `aws-cli` and set up you AWS credentials locally for `gotham`. (See https://github.com/Rhiza/rhiza/wiki/How-to-set-up-AWS-credentials for more info)

2. Create & download a personal access token (In Developer Settings -> Personal Access Tokens). In the permissions section grant only admin:org --> read:org scope. Finally, export this token in your `bash_profile` for the variable `VAULT_GITHUB_TOKEN`, and `source` the update `~/.bash_profile`

3. Copy this entire project (including the encapsulating folder) into the top-level directory of a folder containing the `rhiza` project https://github.com/Rhiza/rhiza.

4. From the top-level directory of the rhiza project, launch the Kubernetes Docker container:

	VAULT_GITHUB_TOKEN=<paste your github token> \
    asgard/build/images/k8s/run.sh $PWD

5. Login to dockerhub in the new container using `docker login`

6. In the directory containing the rhiza project, run `./ops/EngOps/kubernetes/kubeconfig/list.py` to ensure that you have access to Kubernetes. Then, select the qa cluster using `ops/EngOps/kubernetes/kubeconfig/retrieve.py --cluster-name qa`

7. Create the new project using `k create -f test_jenkins_2/kube/test_jenkins.yml`. Check to see that the new pod is running using `k get pods | grep test-jenkins`

8. Enable port-forwarding via `k port-forward pods/test-jenkins 42100:8080`. After running this, the Jenkins 2 server should be accessible throughout Rhiza using at your ip address, port 8080.
