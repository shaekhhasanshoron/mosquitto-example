#!/bin/bash

echo
echo "----------------------------"
echo "| SSL Cert Generator |"
echo "----------------------------"
echo

export EXPIRE_DAYS=${EXPIRE_DAYS:=1460}
export CERTS_DIR=${CERTS_DIR:-"/etc/app/certs"}
export FORCE_REGENERATE_CERTS=${FORCE_REGENERATE_CERTS:=0}

export CA_KEY=${CA_KEY-"ca.key"}
export CA_CERT=${CA_CERT-"ca.crt"}
export CA_SUBJECT=${CA_SUBJECT:-"*"}

export SERVER_KEY=${SERVER_KEY-"server.key"}
export SERVER_CERT=${SERVER_CERT-"server.crt"}
export SERVER_CSR=${SERVER_CSR-"server.csr"}

export SSL_SIZE=${SSL_SIZE:-"2048"}
export SSL_SUBJECT=${SSL_SUBJECT:-"example.com"}
export SSL_DNS=${SSL_DNS}
export SSL_IP=${SSL_IP}

export DEBUG=${DEBUG:=1}

PASS=$(openssl rand -hex 16)

fileCount=$(find ${CERTS_DIR} -type f | wc -l)
if [ $fileCount -gt 2 ] && [ $FORCE_REGENERATE_CERTS == 0 ]
        then
        echo "[INFO] Certificates exists"
else
    # remove certificates from previous execution.
    rm -f ${CERTS_DIR}/*.crt ${CERTS_DIR}/*.key ${CERTS_DIR}/*.srl ${CERTS_DIR}/*.csr ${CERTS_DIR}/*.cnf

    # generate CA private and public keys
    echo "--> Generating Certificate Authority"

    echo 01 > ${CERTS_DIR}/ca.srl
    openssl genrsa -des3 -out ${CERTS_DIR}/${CA_KEY} -passout pass:$PASS ${SSL_SIZE}
    openssl req -subj "/CN=${CA_SUBJECT}/" -new -x509 -days $EXPIRE_DAYS -passin pass:$PASS -key ${CERTS_DIR}/${CA_KEY} -out ${CERTS_DIR}/${CA_CERT}

    # create a server key and certificate signing request (CSR)
    echo "--> Generating Server Key"
    openssl genrsa -out ${CERTS_DIR}/${SERVER_KEY} ${SSL_SIZE}
    openssl req -new -key ${CERTS_DIR}/${SERVER_KEY} -out ${CERTS_DIR}/${SERVER_CSR} -passin pass:$PASS -subj "/CN=${SSL_SUBJECT}/"

    # sign the server key with our CA
    echo "--> Generating Server Certificate"
    echo "subjectAltName=DNS:${SSL_SUBJECT}" > ${CERTS_DIR}/server.extfile.cnf
    openssl x509 -req -extfile ${CERTS_DIR}/server.extfile.cnf -days $EXPIRE_DAYS -passin pass:$PASS -in ${CERTS_DIR}/${SERVER_CSR} -CA ${CERTS_DIR}/${CA_CERT} -CAkey ${CERTS_DIR}/${CA_KEY} -out ${CERTS_DIR}/${SERVER_CERT}

    # create a client key and certificate signing request (CSR)
    # openssl genrsa -des3 -out key.pem -passout pass:$PASS 2048
    # openssl req -subj '/CN=client' -new -key key.pem -out client.csr -passin pass:$PASS

    # create an extensions config file and sign
    # echo extendedKeyUsage = clientAuth > extfile.cnf
    # openssl x509 -req -days $EXPIRE_DAYS -passin pass:$PASS -in client.csr -CA ca.pem -CAkey ca-key.pem -out cert.pem -extfile extfile.cnf

    # remove the passphrase from the client and server key
    # openssl rsa -in server-key.pem -out server-key.pem -passin pass:$PASS
    # openssl rsa -in key.pem -out key.pem -passin pass:$PASS

    # remove generated files that are no longer required
    rm -f ${CERTS_DIR}/${CA_KEY} ${CERTS_DIR}/ca.srl ${CERTS_DIR}/client.csr ${CERTS_DIR}/extfile.cnf ${CERTS_DIR}/${SERVER_CSR}

fi

echo
echo "-------------------------------------"
echo "| Exiting SSL Certificate Generator |"
echo "-------------------------------------"
echo
echo
echo