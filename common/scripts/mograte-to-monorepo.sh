#!/bin/bash

REPOSITORIES='[
  {
    "prefix":"guides",
    "repository": "TimurRK/guides",
    "branch": "v2"
  }
]'

ONLY_ADD_NEW=false

for repo in $(echo "${REPOSITORIES}" | jq -r '.[] | @base64'); do
  _jq() {
    echo ${repo} | base64 --decode | jq -r ${1}
  }

   PREFIX=$(_jq '.prefix')
   REPOSITORY=$(_jq '.repository')
   BRANCH=$(_jq '.branch')

  if [ -d "./${PREFIX}" ]; then
    if [ $ONLY_ADD_NEW = false ]; then
      $(git subtree pull --prefix=${PREFIX} git@github.com:${REPOSITORY} ${BRANCH} --squash)
    fi
  else
    $(git subtree add --prefix=${PREFIX} git@github.com:${REPOSITORY} ${BRANCH} --squash)
  fi
done
