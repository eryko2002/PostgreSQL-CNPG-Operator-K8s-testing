#!/bin/bash

wget https://github.com/cloudnative-pg/cloudnative-pg/releases/download/v1.18.1/kubectl-cnpg_1.18.1_linux_x86_64.deb

sudo dpkg -i kubectl-cnpg_1.18.1_linux_x86_64.deb

dpkg -l | grep cnpg

dpkg -s cnpg

kubectl cnpg version
