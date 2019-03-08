#!/bin/bash

OPENVPN_DIR=/etc/openvpn
OPENVPN_NEED=/usr/local/bin/
AUTH_PASSWORD="auth-user-pass-verify /etc/openvpn/server/check_password.sh via-env"
AUTH_LDAP='plugin /usr/lib/openvpn/openvpn-auth-ldap.so "/etc/openvpn/ldap.conf cn=%u"'

if [ ! -f ${OPENVPN_DIR}/server/server.crt ]
then
    echo 'openvpn initializing ...'
    # make server ca and server crt
    cd ${OPENVPN_DIR}
    mkdir -p server client logs
    cd /root/
    mkdir -p openvpn-ca client-configs
    cp /usr/share/easy-rsa/* openvpn-ca
    cp ${OPENVPN_NEED}/make_cert.sh ${OPENVPN_NEED}/vars openvpn-ca
    cp openvpn-ca/openssl-1.0.0.cnf openvpn-ca/openssl.cnf
    cd openvpn-ca
    ./make_cert.sh
    cd ./keys
    cp ca.crt server.crt server.key dh* ${OPENVPN_DIR}/server/

    if [ ! -f ${OPENVPN_DIR}/server.conf ]
    then
        cp ${OPENVPN_NEED}/server.conf ${OPENVPN_DIR}/server.conf

        if [ $AUTH_TYPE == "openldap" ]
        then
            cp ${OPENVPN_NEED}/ldap.conf ${OPENVPN_DIR}
            sed -i "s|{{ AUTH_TYPE }}|${AUTH_LDAP}|g" ${OPENVPN_DIR}/server.conf
        else
            cp ${OPENVPN_NEED}/check_password.sh ${OPENVPN_DIR}/server/
            sed -i "s|{{ AUTH_TYPE }}|${AUTH_PASSWORD}|g" ${OPENVPN_DIR}/server.conf
            echo script-security 3 >> ${OPENVPN_DIR}/server.conf
            touch ${OPENVPN_DIR}/password
            chmod 600 ${OPENVPN_DIR}/password
            touch ${OPENVPN_DIR}/logs/password.log
            chmod 644 ${OPENVPN_DIR}/logs/password.log
        fi
    fi

    # fill environment variable in
    sed -i "s|^dh.*|dh ${OPENVPN_DIR}/server/dh${KEY_SIZE}.pem|" ${OPENVPN_DIR}/server.conf
    sed -i "s|{{ OPENVPN_SERVER }}|${OPENVPN_SERVER}|g" ${OPENVPN_DIR}/server.conf
    sed -i "s|^push \"route.*|push \"route ${PUSH}\"|" ${OPENVPN_DIR}/server.conf

    # make client crt
    cd /root/
    cp ${OPENVPN_NEED}/make_config.sh ${OPENVPN_NEED}/base.conf client-configs
    ./client-configs/make_config.sh client
    sed -i "s|^remote.*|remote ${CLIENTREMOTE} 1194|" ${OPENVPN_DIR}/client/client.ovpn
    
    rm -rf /usr/local/bin/*
    rm -rf /root/client-configs /root/openvpn-ca
else
    echo 'openvpn has been initialized, skip.'
fi

# add tun
if [ ! -c /dev/net/tun ]
then
    echo "creating /dev/net/tun"
    mkdir /dev/net
    mknod /dev/net/tun c 10 200
fi

# Set ldap environment variables
if [ $AUTH_TYPE == "openldap" ]
then
    sed -i "s|{{ LDAP_SERVICE_URL }}|${LDAP_SERVICE_URL}|g" ${OPENVPN_DIR}/ldap.conf
    sed -i "s|{{ LDAP_BIND_DN }}|${LDAP_BIND_DN}|g" ${OPENVPN_DIR}/ldap.conf
    sed -i "s|{{ LDAP_PASSWORD }}|${LDAP_PASSWORD}|g" ${OPENVPN_DIR}/ldap.conf
    sed -i "s|{{ LDAP_TLS }}|${LDAP_TLS}|g" ${OPENVPN_DIR}/ldap.conf
    sed -i "s|{{ LDAP_BASE_DN }}|${LDAP_BASE_DN}|g" ${OPENVPN_DIR}/ldap.conf
    sed -i "s|{{ LDAP_SEARCH_FILTER }}|${LDAP_SEARCH_FILTER}|g" ${OPENVPN_DIR}/ldap.conf

    # Determine if TLS_REQCERT is added
    grep "TLS_REQCERT ${TLS_REQCERT}" /etc/ldap/ldap.conf > /dev/null
    if [ ! $? -eq 0 ]
    then
        echo TLS_REQCERT $TLS_REQCERT >> /etc/ldap/ldap.conf
    fi
fi
