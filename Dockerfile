FROM xieguochao/code-server:1.0

USER root
# RUN cp /etc/apt/sources.list /etc/apt/sources.backup.list

# Please comment this line if you are not using Tencent Cloud network
COPY sources.list /etc/apt/sources.list

RUN apt-get update

USER codeserver
RUN aria2c https://sh.rustup.rs -d ~
RUN sh ~/rustup-init.sh -y 

# Rust
RUN code-server --install-extension rust-lang.rust

USER root
RUN cp /etc/apt/sources.list /etc/apt/sources-tencent.list
RUN mv /etc/apt/sources.backup.list /etc/apt/sources.list
RUN apt-get update

EXPOSE 7777
ENV PASSWORD=codeserver
USER codeserver
CMD [ "code-server", "--bind-addr", "0.0.0.0:7777", "--auth", "password" ]
