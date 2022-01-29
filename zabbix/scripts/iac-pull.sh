#!/bin/bash
cd "$(dirname "$0")"
if [[ -d "IaC" ]]
then
  echo "Pulling..."
  cd IaC
  git pull &
  [[ $? != 0 ]] && exit 1
else
  echo "Cloning..."
  git clone https://github.com/jpmenega/IaC.git &
  [[ $? != 0 ]] && exit 1
fi
exit 0
