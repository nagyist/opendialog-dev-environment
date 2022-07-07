DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${DIR}/..

CHOSEN_DATABASE=$(grep CHOSEN_DATABASE .env | xargs)
CHOSEN_DATABASE=${CHOSEN_DATABASE#*=}

BUILT_IMAGES=$(grep USE_BUILT_IMAGES .env | xargs)
BUILT_IMAGES=${BUILT_IMAGES#*=}

COMPOSE_FILE='docker-compose.yml'
if [ "${BUILT_IMAGES}" == true ]; then
    COMPOSE_FILE='docker-compose-built.yml'
    echo "### Using pre-built images ###"
fi