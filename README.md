# Isaac Sim ROS2 Docker

This is the docker support for isaac sim 

## Requirments

You should have nvidia-docker installed:
``` shell
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg && \
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list && \
sudo apt update
sudo apt install -y nvidia-container-toolkit
sudo systemctl restart docker
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

## Get images

### Proxy (Optional)

Edit `/etc/docker/daemon.json`, add following params:
``` json
{
    "proxies": {
            "http-proxy": "http://ip:port",
            "https-proxy": "http://ip:port"
    }
}
```

### Pull Base image
``` shell
docker pull nvcr.io/nvidia/isaac-sim:4.5.0
```

#### Headless
For headless running, pull ros-base image
``` shell
docker pull ghcr.io/endermands/isaac-sim:4.5.0
```

#### GUI
For GUI, pull ros-desktop image
``` shell
docker pull ghcr.io/endermands/isaac-sim:4.5.0-desktop
```

## Usage

### Headless
Create a docker container. Set the last volume mount to your own isaac sim asset directory.
``` shell
docker run --name isaac-sim -itd --runtime=nvidia --gpus all -e "ACCEPT_EULA=Y" --network=host \
    -e "PRIVACY_CONSENT=Y" \
    -v ~/docker/isaac-sim/cache/kit:/isaac-sim/kit/cache:rw \
    -v ~/docker/isaac-sim/cache/ov:/root/.cache/ov:rw \
    -v ~/docker/isaac-sim/cache/pip:/root/.cache/pip:rw \
    -v ~/docker/isaac-sim/cache/glcache:/root/.cache/nvidia/GLCache:rw \
    -v ~/docker/isaac-sim/cache/computecache:/root/.nv/ComputeCache:rw \
    -v ~/docker/isaac-sim/logs:/root/.nvidia-omniverse/logs:rw \
    -v ~/docker/isaac-sim/data:/root/.local/share/ov/data:rw \
    -v ~/docker/isaac-sim/documents:/root/Documents:rw \
    -v /opt/isaac_assets/Assets/Isaac/4.5:/isaac_assets:rw \
    ghcr.io/endermands/isaac-sim:4.5.0
```

### GUI

Setup xhost display
``` shell
xhost +
```

Create a docker container. Set the last volume mount to your own isaac sim asset directory.
``` shell
docker run --name isaac-sim --runtime=nvidia --gpus all -e "ACCEPT_EULA=Y" -itd --network=host \
    -v $HOME/.Xauthority:/root/.Xauthority \
    -e DISPLAY \
    -e "OMNI_USER=admin" -e "OMNI_PASS=admin" \
    -e "OMNI_SERVER=http://omniverse-content-production.s3-us-west-2.amazonaws.com/Assets/Isaac/4.5" \
    -e "PRIVACY_CONSENT=${privacy_consent}" -e "PRIVACY_USERID=admin" \
    -v ~/docker/isaac-sim/cache/kit:/isaac-sim/kit/cache:rw \
    -v ~/docker/isaac-sim/cache/ov:/root/.cache/ov:rw \
    -v ~/docker/isaac-sim/cache/pip:/root/.cache/pip:rw \
    -v ~/docker/isaac-sim/cache/glcache:/root/.cache/nvidia/GLCache:rw \
    -v ~/docker/isaac-sim/cache/computecache:/root/.nv/ComputeCache:rw \
    -v ~/docker/isaac-sim/cache/asset_browser:/isaac-sim/exts/isaacsim.asset.browser/cache:rw \
    -v ~/docker/isaac-sim/logs:/root/.nvidia-omniverse/logs:rw \
    -v ~/docker/isaac-sim/data:/root/.local/share/ov/data:rw \
    -v ~/docker/isaac-sim/pkg:/root/.local/share/ov/pkg:rw \
    -v ~/docker/isaac-sim/documents:/root/Documents:rw \
    -v /opt/isaac_assets/Assets/Isaac/4.5:/isaac_assets:rw \
    ghcr.io/endermands/isaac-sim:4.5.0-desktop
```

### Start isaac-sim
Attach a new shell
``` shell
docker exec -it isaac-sim zsh
```

Setup Isaac sim, only need to run post_install.sh once
``` shell
/isaac-sim/post_install.sh
```

Start up isaac sim
``` shell
/isaac-sim/isaac-sim.sh
```
