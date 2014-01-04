#Docker-Supervisord

Dockerfile for multi deamon process using supervisor.
Using sshd and nginx.

CentOS6.4, Docker 0.7.2

#Usage

```
git clone git@github.com:yss44/docker_supervisord.git
cd docker_supervisord
docker build yoshiso/supervisord .
docker run -p 2222 -p 80 -d yoshiso/supervisord
```

Container port is forwarded to Host's port 80.
For check nginx works.

SSH listening port 2222

```
ssh -p 2222 -i path/to/identify_file yoshiso@XXX.XXX.XXX.XXX
```

Nginx listen port 80

```
curl http://XXX.XXX.XXX.XXX:80
> Hello, Nginx!
```

ok!
