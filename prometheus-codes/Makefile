export DOCKER_GRAFANA_TAG=6.7.3
export DOCKER_PROMETHEUS_TAG=v2.17.2
export DOCKER_INFLUXDB_TAG=1.8
export DOCKER_NETWORK_NAME=prometheus-network
export DOCKER_INFLUXDB_NAME=influxdb

up:
	make network
	make influxdb

network:
	( docker network ls | grep ${DOCKER_NETWORK_NAME} ) \
		|| docker network create ${DOCKER_NETWORK_NAME}

influxdb: network
	docker run  \
		--rm \
		--interactive \
		--tty \
		--name ${DOCKER_INFLUXDB_NAME} \
		--net ${DOCKER_NETWORK_NAME} \
		--user `id -u`:`id -g` \
		--publish 8086:8086 \
		--mount type=bind,source=${PWD}/influxdb/,target=/var/lib/influxdb/ \
		influxdb:${DOCKER_INFLUXDB_TAG}

stats:
	docker container stats --all --format "table {{.Container}}\t{{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"

# $1：コンテナ名
define stop-container
	docker container ls --quiet --filter='name=$1' \
		| xargs -I {} docker container stop {}
endef
clean:
	$(call stop-container,${DOCKER_INFLUXDB_NAME})
	docker network rm ${DOCKER_NETWORK_NAME} || echo ${DOCKER_NETWORK_NAME} is nothing
