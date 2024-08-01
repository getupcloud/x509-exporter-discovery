FROM ubuntu:latest

RUN apt update && \
  apt install -y curl jq && \
  apt-get clean && \
  apt-get autoclean

RUN KUBECTL_VERSIONS=$( \
        curl -s https://api.github.com/repos/kubernetes/kubernetes/releases?per_page=100 \
        | jq -r '.[] | .tag_name' \
        | grep '^v[0-9]\.[0-9][0-9]\?\.[0-9][0-9]\?$' \
        | sort -Vr \
        | awk -F . '!a[$1 FS $2]++' \
        | sort -V ) && \
    for KUBECTL_VERSION in $KUBECTL_VERSIONS; do \
      v=${KUBECTL_VERSION%.*} && \
      curl -skL https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl > \
        /usr/local/bin/kubectl-${v}; \
    done && \
    chmod +x /usr/local/bin/kubectl-* && \
    ln -fs /usr/local/bin/kubectl-${v} /usr/local/bin/kubectl && \
    ls -l /usr/local/bin/kubectl*

COPY entrypoint certificate-discovery /

ENTRYPOINT ["/entrypoint"]
