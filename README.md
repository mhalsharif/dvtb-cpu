This is a docker container for https://github.com/yosinski/deep-visualization-toolbox to get the toolbox running on CPU without going through the hassle of manual installation.

Please check out https://github.com/fishcorn/dvtb-container for a docker container of the same toolbox but runs on CUDA GPUs. I created this container because fishcorn/dvtb-container did not work on my MacBook which lacks Nvidia GPU.

## Running this container

First, pull the image from the docker-hub using:
```
docker pull mhalsharif/dvtb-cpu
```

To enable X server connection between the host and the container, run:
```
xhost +
```

On Linux (video cam input is supported), run this container with:
```
docker run -ti --name dvtb-container --device=/dev/video0:/dev/video0 --env="DISPLAY" --net=host -v /tmp/.X11-unix:/tmp/.X11-unix mhalsharif/dvtb-cpu
```
On macOS (video cam input is not supported), run this container with:
```
docker run -ti --name dvtb-container -e DISPLAY=host.docker.internal:0 -v /tmp/.X11-unix:/tmp/.X11-unix mhalsharif/dvtb-cpu
```

Before running the toolbox, make sure that you have downloaded (fetched) one of the models in the 'models' folder. For instance:
```
cd models
cd caffenet-yos
./fetch.sh
```

Finally, run the toolbox in /opt/dvtb folder with:
```
./run_toolbox.py
```

## Building the image

First clone this repository:
```
git clone https://github.com/mhalsharif/dvtb-cpu.git
```

Then build the image with:
```
docker build -t dvtb-cpu .
```
