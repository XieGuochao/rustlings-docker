FROM xieguochao/code-server:1.0

USER root
RUN cp /etc/apt/sources.list /etc/apt/sources.backup.list

# Please comment this line if you are not using Tencent Cloud network
# COPY sources.list /etc/apt/sources.list

RUN apt-get update

USER codeserver
RUN aria2c https://sh.rustup.rs -d ~
RUN sh ~/rustup-init.sh -y 

# Rust
RUN code-server --install-extension rust-lang.rust

# Rustlings
ENV PATH="/home/codeserver/.cargo/bin:${PATH}"
RUN cd ~ && git clone https://github.com/rust-lang/rustlings
RUN cd ~/rustlings && git switch -c tags/4.4.0 
ADD proxy-config ~/.cargo/config.toml
RUN cd ~/rustlings && cargo install --force --path .

RUN rustup component add rls rust-analysis rust-src

USER root
RUN cp /etc/apt/sources.list /etc/apt/sources-tencent.list
RUN mv /etc/apt/sources.backup.list /etc/apt/sources.list
RUN apt-get update

EXPOSE 7777
ENV PASSWORD=codeserver
USER codeserver
CMD [ "code-server", "--bind-addr", "0.0.0.0:7777", "--auth", "password" ]
