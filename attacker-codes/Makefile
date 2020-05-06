DOCKER_K6_TAG=0.26.2
DOCKER_VEGETA_TAG=6.8-vegeta12.8.3

export WEB_IP=`cat /etc/hosts | grep web | awk '{ print $$1 }'`
ash:
	docker run \
		--rm \
		--interactive \
		--tty \
		--name attacker \
		--mount type=bind,source=${PWD}/,target=/usr/local/attacker/ \
		--add-host web:${WEB_IP} \
		--entrypoint '' \
		--workdir /usr/local/attacker/ \
		loadimpact/k6:${DOCKER_K6_TAG} \
		ash
#		peterevans/vegeta:${DOCKER_VEGETA_TAG} \

