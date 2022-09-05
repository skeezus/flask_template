# Application Setup
- `poetry init`
- `poetry add <dependency>`

# Docker
- `docker build . -t <image-name>:<image-type> --target=<deploy_target>`
	- ie: `docker build . -t flask-template:deploy --target=deploy`
- `docker tag <image-name>:<image-type> <host-name>/<project-id>/<repo-name>/<image-name>:<image-tag>`
	- ie: `docker tag flask-template:deploy us-central1-docker.pkg.dev/flask-template-15608/flask-template/flask-template`
- `docker push <host-name>/<project-id>/<repo-name>/<image-name>:<image-tag>`
	- ie: `docker push us-central1-docker.pkg.dev/flask-template-15608/flask-template/flask-template`
- `docker run -d -p 5000:5000 <image-name>`
	- ie: `docker run -d -p 5000:5000 flask-template -e FLASK_TEMPLATE_DB_URI=${FLASK_TEMPLATE_DB_URI}`

# Secrets Management
- Git Crypt
	- encrypt secrets using Git Crypt: https://github.com/AGWA/git-crypt
	- `git-crypt status` indicates which files are encrypted

## Resources
- https://www.fpgmaas.com/blog/deploying-a-flask-api-to-cloudrun
- https://www.markdownguide.org/basic-syntax/
