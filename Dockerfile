FROM nvcr.io/nvidia/isaac-sim:4.5.0

ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=humble
ARG USERNAME=ubuntu

RUN apt update && \
    apt install -y vim tree wget curl git unzip zip && \
    apt install -y zsh && \
    apt install -y libeigen3-dev && \
    apt install -y software-properties-common gnupg2 lsb-release && \
    add-apt-repository -y universe && \
    DEBIAN_FRONTEND=noninteractive apt install -y keyboard-configuration && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
      | gpg --dearmor -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    sh -c 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] \
      http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" \
      > /etc/apt/sources.list.d/ros2-latest.list' && \
    apt update && \
    apt install -y ros-${ROS_DISTRO}-ros-base && \
    apt install -y python3-colcon-common-extensions python3-rosdep python3-vcstool python3-pip python3-colcon-mixin && \
    apt install -y ros-${ROS_DISTRO}-vision-msgs ros-${ROS_DISTRO}-ackermann-msgs && \
    rosdep init && \
    colcon mixin add default https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml && \
    colcon mixin update default && \
    rm -rf /var/lib/apt/lists/*

RUN echo "root:'" | chpasswd && \
    echo "ubuntu:'" | chpasswd && \
    usermod -aG sudo ubuntu

USER ubuntu
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' /home/$USERNAME/.zshrc
SHELL ["/bin/zsh", "-c"]

RUN echo "alias omni_python='/isaac-sim/python.sh'" >> /home/$USERNAME/.zshrc && \
    echo "alias sim='/isaac-sim/isaac-sim.sh'" >> /home/$USERNAME/.zshrc && \
    echo "source /opt/ros/${ROS_DISTRO}/setup.zsh" >> /home/$USERNAME/.zshrc && \
    echo "source /usr/share/colcon_cd/function/colcon_cd.sh" >> /home/$USERNAME/.zshrc && \
    echo "export _colcon_cd_root=/opt/ros/${ROS_DISTRO}/" >> /home/$USERNAME/.zshrc && \
    echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.zsh" >> /home/$USERNAME/.zshrc && \
    echo ": 1700000000:0;colcon build" >> /home/$USERNAME/.zsh_history && \
    echo ": 1700000001:0;/isaac-sim/isaac-sim.sh" >> /home/$USERNAME/.zsh_history && \
    echo ": 1700000002:0;/isaac-sim/post_install.sh" >> /home/$USERNAME/.zsh_history && \
    rosdep update

WORKDIR /home/$USERNAME
ENTRYPOINT [ "zsh", "-l" ]
