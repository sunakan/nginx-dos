export DOCKER_CADVISOR_TAG=v0.36.0
export DOCKER_CADVISOR_NAME=cadvisor
export DOCKER_TELEGRAf_TAG=1.14.2-alpine
export DOCKER_CADVISOR_NAME=cadvisor
export DOCKER_NGINX_NAME=nginx
export DOCKER_APP_NAME=app
export DOCKER_NETWORK_NAME=web-network

# LinuxのCPU情報とメモリ情報
spec:
	cat /proc/cpuinfo | grep 'physical id' | wc -l | xargs -I {} echo A：物理CPU：{} \
		&& cat /proc/cpuinfo | grep 'cpu cores' | uniq | awk '{ print $$4 }' | xargs -I {} echo B：CPU毎のコアの数：{} \
		&& cat /proc/cpuinfo | grep 'processor' | wc -l | xargs -I {} echo C：論理プロセッサ数：{} \
		&& free -m | grep 'Mem' | awk '{ print $$2}' | xargs -I {} echo D：メモリ：{}MB

up:
	make cadvisor
	make network
	make app
	sleep 1
	make nginx
	docker container ls

network:
	( docker network ls | grep ${DOCKER_NETWORK_NAME} ) \
		|| docker network create ${DOCKER_NETWORK_NAME}

nginx: network
	( docker container ls | grep ${DOCKER_NGINX_NAME} ) \
		|| docker run \
			--detach \
			--rm \
			--interactive \
			--tty \
			--net ${DOCKER_NETWORK_NAME} \
			--name ${DOCKER_NGINX_NAME} \
			--publish 80:80 \
			--memory 128mb \
			--cpu-shares 512 \
			--mount type=bind,source=${PWD}/default.conf,target=/etc/nginx/conf.d/default.conf,readonly \
			--workdir /usr/local/web/ \
			nginx:stable

app: network
	( docker container ls | grep ${DOCKER_APP_NAME} ) \
		|| docker run \
			--detach \
			--rm \
			--interactive \
			--tty \
			--net ${DOCKER_NETWORK_NAME} \
			--name ${DOCKER_APP_NAME} \
			--env PORT=8000 \
			--publish 8000:8000 \
			--cpu-shares 512 \
			--memory 512mb \
			--mount type=bind,source=${PWD}/,target=/usr/local/app/,readonly \
			--workdir /usr/local/app \
			ruby:2.7-slim ruby hello.rb

cadvisor:
	( docker container ls | grep ${DOCKER_CADVISOR_NAME} ) \
		|| sudo docker run \
			--detach \
			--rm \
			--volume=/:/rootfs:ro \
			--volume=/var/run:/var/run:ro \
			--volume=/sys:/sys:ro \
			--volume=/var/lib/docker/:/var/lib/docker:ro \
			--volume=/dev/disk/:/dev/disk:ro \
			--publish=8080:8080 \
			--name=${DOCKER_CADVISOR_NAME} \
			--cpu-shares 1024 \
			gcr.io/google-containers/cadvisor:${DOCKER_CADVISOR_TAG}

stats:
	docker container stats --all --format "table {{.Container}}\t{{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"

# $1：コンテナ名
define stop-container
	docker container ls --quiet --filter='name=$1' \
		| xargs -I {} docker container stop {}
endef
clean:
	$(call stop-container,${DOCKER_CADVISOR_NAME})
	$(call stop-container,nginx)
	$(call stop-container,${DOCKER_APP_NAME})
	docker network rm ${DOCKER_NETWORK_NAME} || echo ${DOCKER_NETWORK_NAME} is nothing

restart-nginx:
	$(call stop-container,nginx)
	make nginx
