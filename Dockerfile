FROM jenkinsci/ssh-slave

RUN apt-get update && apt-get install -y --force-yes \
        build-essential \
        curl \
        git \
        zlib1g-dev \
        libssl-dev \
        libreadline-dev \
        libyaml-dev \
        libxml2-dev \
        libxslt-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV RBENV_ROOT=/opt/rbenv
RUN git clone https://github.com/rbenv/rbenv.git "${RBENV_ROOT}"
RUN git clone https://github.com/rbenv/ruby-build.git "${RBENV_ROOT}/plugins/ruby-build"
RUN git clone https://github.com/rbenv/rbenv-gem-rehash.git "${RBENV_ROOT}/plugins/rbenv-gem-rehash"
RUN git clone https://github.com/rbenv/rbenv-default-gems.git "${RBENV_ROOT}/plugins/rbenv-default-gems"
RUN git clone https://github.com/rkh/rbenv-update.git "${RBENV_ROOT}/plugins/rbenv-update"
ADD ./default-gems "${RBENV_ROOT}/default-gems"

ADD ./auto-install-ruby-with-rbenv.sh /tmp/auto-install-ruby-with-rbenv.sh
RUN echo 'export PATH=${RBENV_ROOT}/bin:${PATH}\n\
eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh \
    && cat /tmp/auto-install-ruby-with-rbenv.sh >> /etc/profile.d/rbenv.sh \
    && chgrp -R jenkins "${RBENV_ROOT}" \
    && chmod -R g+rwxXs "${RBENV_ROOT}"

VOLUME "${RBENV_ROOT}"
