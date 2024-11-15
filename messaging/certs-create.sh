#!/bin/bash

#set -o nounset \
#    -o errexit \
#    -o verbose \
#    -o xtrace

# Cleanup files
rm -f /tmp/*.crt /tmp/*.csr /tmp/*_creds /tmp/*.jks /tmp/*.srl /tmp/*.key /tmp/*.pem /tmp/*.der /tmp/*.p12 /tmp/extfile

# Generate CA key
openssl req -new -x509 -keyout /tmp/snakeoil-ca-1.key -out /tmp/snakeoil-ca-1.crt -days 365 -subj '/CN=ca1.local.floatic.io/OU=TEST/O=FLOATIC/L=Seongdong/S=Seoul/C=KR' -passin pass:floatic -passout pass:floatic

for i in kafka-broker kafka-broker-1 kafka-broker-2 kafka-broker-3 kafka-client kafka-connect
do
    echo "------------------------------- $i -------------------------------"

    # Create host keystore
    keytool -genkey -noprompt \
                 -alias $i \
                 -dname "CN=$i,OU=TEST,O=FLOATIC,L=Seongdong,S=Seoul,C=KR" \
                                 -ext "SAN=dns:$i,dns:localhost" \
                 -keystore /tmp/$i.keystore.jks \
                 -keyalg RSA \
                 -storepass floatic \
                 -keypass floatic \
                 -storetype pkcs12

    # Create the certificate signing request (CSR)
    keytool -keystore /tmp/$i.keystore.jks -alias $i -certreq -file /tmp/$i.csr -storepass floatic -keypass floatic -ext "SAN=dns:$i,dns:localhost"
        #openssl req -in $i.csr -text -noout

cat << EOF > /tmp/extfile
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no
[req_distinguished_name]
CN = $i
[v3_req]
subjectAltName = @alt_names
[alt_names]
DNS.1 = $i
DNS.2 = localhost
EOF
        # Sign the host certificate with the certificate authority (CA)
        openssl x509 -req -CA /tmp/snakeoil-ca-1.crt -CAkey /tmp/snakeoil-ca-1.key -in /tmp/$i.csr -out /tmp/$i-ca1-signed.crt -days 9999 -CAcreateserial -passin pass:floatic -extensions v3_req -extfile /tmp/extfile

        #openssl x509 -noout -text -in $i-ca1-signed.crt

        # Sign and import the CA cert into the keystore
    keytool -noprompt -keystore /tmp/$i.keystore.jks -alias CARoot -import -file /tmp/snakeoil-ca-1.crt -storepass floatic -keypass floatic
        #keytool -list -v -keystore $i.keystore.jks -storepass floatic

        # Sign and import the host certificate into the keystore
     keytool -noprompt -keystore /tmp/$i.keystore.jks -alias $i -import -file /tmp/$i-ca1-signed.crt -storepass floatic -keypass floatic -ext "SAN=dns:$i,dns:localhost"
        #keytool -list -v -keystore $i.keystore.jks -storepass floatic

    # Create truststore and import the CA cert
     keytool -noprompt -keystore /tmp/$i.truststore.jks -alias CARoot -import -file /tmp/snakeoil-ca-1.crt -storepass floatic -keypass floatic

    # Save creds
      echo  "floatic" > /tmp/${i}-sslkey-creds
      echo  "floatic" > /tmp/${i}-keystore-creds
      echo  "floatic" > /tmp/${i}-truststore-creds

    # Create pem files and keys used for Schema Registry HTTPS testing
    #   openssl x509 -noout -modulus -in client.certificate.pem | openssl md5
    #   openssl rsa -noout -modulus -in client.key | openssl md5
    #   log "GET /" | openssl s_client -connect localhost:8081/subjects -cert client.certificate.pem -key client.key -tls1
    keytool -export -alias $i -file /tmp/$i.der -keystore /tmp/$i.keystore.jks -storepass floatic
    openssl x509 -inform der -in /tmp/$i.der -out /tmp/$i.certificate.pem
    keytool -importkeystore -srckeystore /tmp/$i.keystore.jks -destkeystore /tmp/$i.keystore.p12 -deststoretype PKCS12 -deststorepass floatic -srcstorepass floatic -noprompt
    openssl pkcs12 -in /tmp/$i.keystore.p12 -nodes -nocerts -out /tmp/$i.key -passin pass:floatic


    cacerts_path="$(readlink -f /usr/bin/java | sed "s:bin/java::")lib/security/cacerts"
    keytool -noprompt -destkeystore /tmp/$i.truststore.jks -importkeystore -srckeystore $cacerts_path -srcstorepass changeit -deststorepass floatic
done

# used for other/rest-proxy-security-plugin test
# https://stackoverflow.com/a/8224863
openssl pkcs12 -export -in /tmp/clientrestproxy-ca1-signed.crt -inkey /tmp/clientrestproxy.key \
               -out /tmp/clientrestproxy.p12 -name clientrestproxy \
               -CAfile /tmp/snakeoil-ca-1.crt -caname CARoot -passout pass:confluent

keytool -importkeystore \
        -deststorepass confluent -destkeypass confluent -destkeystore /tmp/restproxy.keystore.jks \
        -srckeystore /tmp/clientrestproxy.p12 -srcstoretype PKCS12 -srcstorepass confluent \
        -alias clientrestproxy