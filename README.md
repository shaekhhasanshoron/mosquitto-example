#### Docker Run:
You need to mount your certificates to Mosquitto Container in this path (`/mosquitto/certs`)

```sh
docker run --rm -it -e USERNAME=whyxn -e PASSWORD=keepitsecret --name mosquitto -p 1883:1883 --read-only -v /vol/mosquitto/run:/mosquitto/run -v /vol/mosquitto/data:/mosquitto/data -v /vol/mosquitto/certs:/mosquitto/certs  klovercloud/mosquitto:2.0
```
####

#### Environment Variables:
- `USERNAME: <YOUR_MQTT_USERNAME>`
- `PASSWORD: <YOUR_MQTT_PASSWORD>`


####
#### Run in KloverCloud:
- Make a fork or clone of this repository to your attached git account with KloverCloud
- On-board the forked / cloned repository as an Application
- Set Health Check as `None` (For now)
- Minimum 1 GB of persistent volume is required with the following volume mount paths    
`/mosquitto/data`    
`/mosquitto/run`    
- Check `SSL Pass Through` to True
- Check `Auto SSL by KloverCloud (Let's Encrypt)` to True
- Provide `/mosquitto/certs` as Auto SSL Certificate Mount Path
- Create Application
- Create a secret with the given Environment Variables
- Deploy


#### Test Connection:
```sh
mqtt test -h <YOUR_MOSQUITTO_EXTERNAL_ENDPOINT> -p 443 --secure -u <YOUR_MQTT_USERNAME> -pw <YOUR_MQTT_PASSWORD>
```
