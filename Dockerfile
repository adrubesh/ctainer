FROM debian:bullseye

# Set to your workspace UID if required 
ARG USER_ID=1000
ARG USER_NAME="dev"

RUN apt-get update && apt-get upgrade --yes

# Install essential packages for C development 
RUN apt-get install --no-install-recommends --yes \
	ca-certificates \
	git \
        build-essential \
	curl \
        clang-format \
        neovim \
	zsh \
	sudo
	# Append personal packages here

RUN update-ca-certificates

RUN curl -o /usr/local/bin/init -L "https://raw.githubusercontent.com/adrubesh/nviminit/master/init.sh"
RUN chmod o+x /usr/local/bin/init

RUN useradd -c "workspace user" -m -s /usr/bin/zsh -u $USER_ID $USER_NAME
# Add user to sudoers

RUN echo "$USER_NAME	ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/user
RUN chmod 0644 /etc/sudoers.d/user

# Set container environmental variables
ENV NVIM_LISTEN_PORT=5321
ENV USER_ID=$USER_ID

USER $USER_NAME
RUN touch ~/.zshrc

WORKDIR /home/$USER_NAME

ENTRYPOINT ["init"]



