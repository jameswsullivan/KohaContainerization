### Containerization of the [Koha ILS Software](https://koha-community.org/)
<br>

---

#### BUILD IMAGE

```
# Linux build:

docker image build --tag koha:1.0 --progress plain --no-cache . 2>&1 | tee koha_build.log

# Windows build using PowerShell
docker image build --tag koha:1.0 --progress plain --no-cache . 2>&1 | Tee-Object koha_build.log
```

<br>

---

#### START CONTAINER

```
docker run -dit \
    --name YOUR_CONTAINER_NAME \
    --network YOURDOMAIN.COM_or_YOUR_NETWORK \
    --ip IP_ADDRESS --restart=unless-stopped \
    --hostname=koha-opac.YOURDOMAIN.COM \
    --add-host=koha-staff.YOURDOMAIN.COM:IP_ADDRESS \
    --cap-add=SYS_NICE --cap-add=DAC_READ_SEARCH \
    koha:1.0
```

<br>

---

#### INSTRUCTIONS

1. Change ***DOMAIN=".YOURDOMAIN.COM"*** in ***koha-sites.conf*** file to your domain.
2. Since I named my koha instance ***koha*** (*koha-create --create-db koha*), the Linux user created by Koha in this case will be ***koha-koha*** and the database username will be ***koha_koha*** (this username is also going to be used for first-time login). To name your user/instance differently you'll need to modify the *docker-entrypoint.sh* accordingly.
3. After the container fully starts and all the commands in *docker-entrypoint.sh* finish running, the auto-generated password will be displayed and can be viewed by running the ***docker logs your_container_name*** command.
4. The default locale is set to *UTF-8* and time zone is set to *US Central*.
5. This project is designed to quickly spin up a Koha instance for test or dev purposes and is not intended to be directly used for production without modification.