#!/usr/bin/env bash

cd=$(pwd)
script=$(dirname $0)

# cert info define
country=US
state=CA
city=GS
organization=fake.me
unit=fake.me
name=fake
email=fake@fake.me
domain=fake.me

function gen_ca() {
    if [[ ! -d "${script}/../cert" ]];then
        mkdir ${script}/../cert
    fi
    cd ${script}/cert
    # gen root CA
    ../bin/ca-gen -v \
        -c ${country} -s ${state} -l ${city} -o ${organization} -u ${unit} -n ${name} -e ${email} \
        ${name}-rootCA.key ${name}-rootCA.crt
    # return working dir
    cd ${cd}
    echo
    echo
    echo
    echo "ok"

}

function gen_cert(){
    if [[ ! -d "${script}/../cert" ]];then
        mkdir ${script}/../cert
    fi
    cd ${script}/cert
    # gen ssl
    ../bin/cert-gen \
        -c ${country} -s ${state} -l ${city} -o ${organization} -u ${unit} -n ${name} -e ${email} \
        -a "*.${domain}, ${domain}" \
        ${name}-rootCA.key \
        ${name}-rootCA.crt \
        ${domain}.key \
        ${domain}.csr \
        ${domain}.crt
    # return working dir
    cd ${cd}
    echo
    echo
    echo
    echo "install root CA to Trusted Root Cert"
}

function gen() {
    gen_ca
    gen_cert
}

function clean() {
    cd ${script}/cert || return
    rm ${name}-rootCA.key ${name}-rootCA.crt ${name}-rootCA.srl ${domain}.key ${domain}.csr ${domain}.crt
    cd ${script}
}

function test() {
    nodejs server.js ${domain}
}

if [[ ! -n ${1} ]];then
    echo "gen [gen_ca | gen_cert]  |  clean  |  test"
else
    $1
fi