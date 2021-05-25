#### Docker Run:
You need to mount your certificates to Mosquitto Container in this path (`/mosquitto/certs`)

```sh
docker run --rm -it --name mosquitto -e USERNAME=klovercloud -e PASSWORD=keepitsecret -e GENERATE_SELF_SIGNED_CERTS=1 -e CERTS_DIR=/mosquitto/certs  -e SSL_SUBJECT=mosquitto.example.com -p 1883:1883 --read-only -v /vol/mosquitto/run:/mosquitto/run -v /vol/mosquitto/data:/mosquitto/data -v /vol/mosquitto/certs:/mosquitto/certs  klovercloud/mosquitto:2.0
```
####

#### Environment Variables:
- `USERNAME: <YOUR_MQTT_USERNAME>` (Default: mosquitto)
- `PASSWORD: <YOUR_MQTT_PASSWORD>` (Default: mosquitto)
- `GENERATE_SELF_SIGNED_CERTS: 1` (Optional)
- `FORCE_REGENERATE_CERTS: 0` (Optional & depends on GENERATE_SELF_SIGNED_CERTS)
- `CERTS_DIR: <MOSQUITTO_CERTS_DIRECTORY>` (Required if GENERATE_SELF_SIGNED_CERTS == 1)
- `SSL_SUBJECT: <YOUR_MOSQUITTO_ENDPOINT_DOMAIN>` (Required if GENERATE_SELF_SIGNED_CERTS == 1)


####
#### Run in KloverCloud:
- Make a fork or clone of this repository to your attached git account with KloverCloud
- On-board the forked / cloned repository as an Application
- Set Application Port to `1883`
- Set Health Check as `None` (For now)
- Minimum 1 GB of persistent volume is required with the following volume mount paths    
`/mosquitto/data`    
`/mosquitto/run`    
`<MOSQUITTO_CERTS_DIRECTORY_PATH>` (If using GENERATE_SELF_SIGNED_CERTS=1)        
- Setup your Custom External Access URL (Optional)
- Check `SSL Pass Through` to True
- Check `Auto SSL by KloverCloud (Let's Encrypt)` to True & provide `/mosquitto/certs` as Auto SSL Certificate Mount Path  (Optional, applicable if using Custom External Access URL)   
Or you have to provide your own SSL Certificate & SSL Configurations in `config/mosquitto.conf`
- Create Application
- Create a Secret with the given Environment Variables
- Deploy


#### Test Connection:

***With Self Signed Certificate***
```sh
mqtt test -h <YOUR_MOSQUITTO_EXTERNAL_ENDPOINT> -p 443 --secure -u <YOUR_MQTT_USERNAME> -pw <YOUR_MQTT_PASSWORD> --cafile=<PATH_TO_CA_FILE> --cert=<PATH_TO_SERVER_CERT_FILE> --key=<PATH_TO_SERVER_KEY_FILE>
```

###

***With Trusted Certificate***
```sh
mqtt test -h <YOUR_MOSQUITTO_EXTERNAL_ENDPOINT> -p 443 --secure -u <YOUR_MQTT_USERNAME> -pw <YOUR_MQTT_PASSWORD>
```
