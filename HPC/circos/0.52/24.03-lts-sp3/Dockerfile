ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG VERSION=0.52

RUN dnf install -y \
      perl perl-devel perl-Config-General perl-Font-TTF \
      perl-Params-Validate perl-Readonly perl-Clone \
      perl-Data-Dumper perl-Digest-MD5 perl-File-Temp \
      perl-Regexp-Common \
      gd-devel libpng-devel \
      curl gcc make && \
    dnf clean all

RUN curl -fSL -o /usr/local/bin/cpanm https://raw.githubusercontent.com/miyagawa/cpanminus/master/cpanm && \
    chmod +x /usr/local/bin/cpanm

RUN cpanm --mirror https://mirrors.tuna.tsinghua.edu.cn/CPAN/ --notest SVG Math::Bezier Math::Round Math::VecStat Set::IntSpan Text::Format Statistics::Basic Statistics::Descriptive GD

RUN mkdir -p /opt/circos && \
    curl -fSL https://github.com/vigsterkr/circos/archive/refs/tags/${VERSION}.tar.gz | tar xz --strip-components=1 -C /opt/circos && \
    find /opt/circos/bin -type f -exec sed -i '1s|^#!/home/martink/bin/.*|#!/usr/bin/perl|' {} \;

ENV PATH=/opt/circos/bin:$PATH

WORKDIR /data

CMD ["circos", "-help"]
