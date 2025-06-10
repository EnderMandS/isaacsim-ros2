# Isaac Sim ROS2 Docker

This is the Docker support for isaac sim 

## Usage

``` shell
docker pull nvcr.io/nvidia/isaac-sim:4.5.0
xhost +
docker run --name isaac-sim --entrypoint zsh --runtime=nvidia --gpus all -e "ACCEPT_EULA=Y" -itd --network=host \
        -v $HOME/.Xauthority:/root/.Xauthority \
        -e DISPLAY \
        -e "OMNI_USER=admin" -e "OMNI_PASS=admin" \
        -e "OMNI_SERVER=http://omniverse-content-production.s3-us-west-2.amazonaws.com/Assets/Isaac/4.5" \
        -e "PRIVACY_CONSENT=${privacy_consent}" -e "PRIVACY_USERID=admin" \
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
        nvcr.io/nvidia/isaac-sim:4.5.0
docker exec -it isaac-sim zsh
/isaac-sim/post_install.sh
/isaac-sim/isaac-sim.sh
```
