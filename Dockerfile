FROM jenkinsci/ssh-slave

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y --force-yes build-essential curl git
RUN apt-get install -y --force-yes zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev
RUN apt-get clean

ENV RBENV_ROOT=/opt/rbenv
RUN git clone https://github.com/rbenv/rbenv.git "${RBENV_ROOT}"
RUN git clone https://github.com/rbenv/ruby-build.git "${RBENV_ROOT}/plugins/ruby-build"
RUN git clone https://github.com/rbenv/rbenv-gem-rehash.git "${RBENV_ROOT}/plugins/rbenv-gem-rehash"
RUN git clone https://github.com/rbenv/rbenv-default-gems.git "${RBENV_ROOT}/plugins/rbenv-default-gems"
RUN "${RBENV_ROOT}/plugins/ruby-build/install.sh"
ADD ./default-gems "${RBENV_ROOT}/default-gems"

RUN echo 'export PATH=${RBENV_ROOT}/bin:${PATH}' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh

RUN chgrp -R jenkins "${RBENV_ROOT}"
RUN chmod -R g+rwxXs "${RBENV_ROOT}"

RUN mkdir "${RBENV_ROOT}/versions"
RUN chgrp -R jenkins "${RBENV_ROOT}/versions"
RUN chmod -R g+rwxXs "${RBENV_ROOT}/versions"
VOLUME "${RBENV_ROOT}/versions"
