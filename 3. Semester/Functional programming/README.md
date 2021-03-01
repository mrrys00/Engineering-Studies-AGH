# Jupyter Haskell
### How to install docker with haskell on Linux?
1. Install docker engine using [this](https://docs.docker.com/engine/install/) manual.
2. Download docker image with iHaskell using `docker pull gibiansky/ihaskell` command.
3. Create container: `docker create --name jupyter-haskell -p 8888:8888 gibiansky/ihaskell`. You can change name and port if you want.

#### Start and stop
In terminal write:
`docker start -i jupyter-haskell &` and stop using command: `docker stop jupyter-haskell` or use Ctrl+C when process is on terminal foreground

### Remove docker haskell container and image:
1. `docker container rm jupyter-haskell --force`
2. `docker image rm gibiansky/ihaskell`