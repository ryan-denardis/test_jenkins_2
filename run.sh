# Build the container
docker build -t ryandenardis/test_jenkins .

# Run the container in the background
docker run -d -p 8080:8080 -p 50000:50000 -v /var/run/docker.sock:/var/run/docker.sock -v jenkins-data:/var/jenkins_home --rm --name test_jenkins ryandenardis/test_jenkins:latest
