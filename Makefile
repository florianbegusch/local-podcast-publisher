SHELL := bash


.PHONY: run-file-server
run-file-server:
	# forward tailscale ip port 80 to localhost (lima vm)
	if [ $(shell uname) = Darwin ]; then \
		sudo ssh -p 60906 -f -NT -L podcast-svc-org:80:localhost:8080  lima@localhost -i ~/.ssh/id_rsa; \
		sudo -k; \
	fi

	docker run --rm --name blub -p 8080:8080 \
		-v "$(shell pwd)"/etc/nginx/conf.d/default.conf:/etc/nginx/conf.d/default.conf \
		-v "$(shell pwd)":/data \
		-it \
		docker.io/library/nginx:1.23-alpine


# calling convention -> README
#
.PHONY: run-feed-generator
run-feed-generator:
	source .venv/bin/activate; \
		./gistfile1.py "${host}":"${port}" "${dir_to_expose}" "${title}"

.PHONY: install
install:
	deactivate; rm -r .venv; \
		virtualenv -p python3 .venv; \
		source .venv/bin/activate; \
		pip install -r requirements.txt

