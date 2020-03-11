FROM python:3.7

WORKDIR /
RUN set -eux; \
  apt-get update; \
  apt-get install -y gosu libldap2-dev libsasl2-dev git; \
  rm -rf /var/lib/apt/lists/*

RUN git clone --depth=1 https://github.com/janeczku/calibre-web.git

WORKDIR /calibre-web
RUN   pip install -r requirements.txt & \
  pip install -r optional-requirements.txt

COPY . .

ENV PUSER  500
ENV PGROUP 1000
EXPOSE 8083
VOLUME /config
VOLUME /books

HEALTHCHECK --interval=10s --timeout=5s --retries=3 \
CMD curl -f http://localhost:8083/ || exit 1

ENTRYPOINT ["/calibre-web/docker-entrypoint.sh"]
