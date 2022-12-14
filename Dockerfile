FROM fedora:latest
RUN dnf -y install openssh-server git

# setup openssh
RUN sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config
RUN mkdir /var/run/sshd
RUN rm -f /var/run/nologin

# setup git user
RUN adduser --system -s /bin/bash git
RUN mkdir -p /home/git/.ssh
RUN touch /home/git/.ssh/authorized_keys
RUN chmod 700 /home/git/.ssh
RUN chmod 600 /home/git/.ssh/authorized_keys
RUN ln -s /home/git /repos

# setup sample git repo
RUN mkdir /home/git/sample.git && git -C /home/git/sample.git init --bare

# set some keys if you wish
RUN echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDUMUpf4VlKl8MeroxrW3hwlrfR4j8TjmBXfl93jzbpEd4zBABWhq8KsJtCDnUaQsYviQssjj+vIx2PzDGE5PbAFW6Sx9gumOQu9MvFrKEvLhxFM2Ufgq/wice8UdAjhQ0++eJzCHMNp906zcq5AsgMsksnED0OZfA6+5U1WomItIdACzN77YJxTacRs8yxhatlvEtH0PseR9w7z50nimZWaRQiySfG7w4YzrDpPddAWbSw/vmmIk96QO6GPBVwRqWqDLASU0NZbsP9FrJ3XZKuwbkx8IIAh6ZTi+TFck7EwMakuqGLSnAEtSILNeFfbnm8bNS8b5kdNdnjwmS0yt837j7t5alQP0g9jp4WRsE5+CtIXjBU9P727mGyEIzIWG64QJHvWJ5ktOe9oPD9yuzLuFvMJkLT2rvt0GsZx8OCB6wcxKTQ8pS8YC9oFg/A/kmWeRhWbv/85UhRlHgnSKFVzWJ7JyIUVG47Iks4ZiGEHuioEXOUbJUm+5PcKVbAv/E= hongliang001@x18240pzz.omaccess.net' > /home/git/.ssh/authorized_keys

# make stuff git owned
RUN chown git -R /home/git

EXPOSE 22
LABEL Description="sample git server; you need to add your ssh keys after startup; on restart you lose repos by default" Vendor="Red Hat" Version="1.0"
# CMD ["/usr/sbin/sshd", "-D"]
CMD ssh-keygen -A && exec /usr/sbin/sshd -D
