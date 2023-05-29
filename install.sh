#!/bin/sh

mkdir -p /john-bin/usr/share/bash-completion/completions
mkdir -p /john-bin/etc/john
mkdir -p /john-bin/usr/libexec
mkdir -p /john-bin/usr/local/bin/
mkdir -p /john-bin/usr/share/zsh/vendor-completions/

mv /john/run/john.zsh_completion /john-bin/usr/share/zsh/vendor-completions/_john
mv /john/run/john.bash_completion /john-bin/usr/share/bash-completion/completions/john
mv /john/run/*.conf /john-bin/etc/john
mv /john/run/*.dic /john-bin/usr/share/
mv /john/run/*.lst /john-bin/usr/share/
mv /john/run/*.pl /john-bin/usr/local/bin/
mv /john/run/*.py /john-bin/usr/local/bin/
mv /john/run/dictionary.rfc2865 /john-bin/usr/share
mv /john/run/oui.txt /john-bin/usr/share
mv /john/run/dns /john-bin/usr/share/
mv /john/run/*.chr /john-bin/usr/share/
mv /john/run/*.js /john-bin/usr/share/
mv /john/run/*.rb /john-bin/usr/local/bin/
mv /john/run/*.lua /john-bin/usr/local/bin/
mv /john/run/lib /john-bin/usr/share
mv /john/run/stats /john-bin/usr/share
mv /john/run/ztex /john-bin/usr/share
mv /john/run/protobuf /john-bin/usr/share
mv /john/run/bip-0039 /john-bin/usr/share
mv /john/run/rules /john-bin/usr/share/
mv /john/run/*.pm /john-bin/usr/share/
mv /john/run/*2john /john-bin/usr/local/bin/
mv /john/run/SIPdump /john-bin/usr/local/bin/
mv /john/run/calc_stat /john-bin/usr/local/bin/
mv /john/run/cprepair /john-bin/usr/local/bin/
mv /john/run/eapmd5tojohn /john-bin/usr/local/bin/
mv /john/run/genmkvpwd /john-bin/usr/local/bin/
mv /john/run/mkvcalcproba /john-bin/usr/local/bin/
mv /john/run/raw2dyna /john-bin/usr/local/bin/
mv /john/run/tgtsnarf /john-bin/usr/local/bin/
mv /john/run/john /john-bin/usr/local/bin/
mv /john/run/unafs /john-bin/usr/local/bin/
mv /john/run/undrop /john-bin/usr/local/bin/
mv /john/run/unique /john-bin/usr/local/bin/
mv /john/run/unshadow /john-bin/usr/local/bin/
mv /john/run/base64conv /john-bin/usr/local/bin/
mv /john/run/mailer /john-bin/usr/local/bin/
mv /john/run/opencl /john-bin/usr/local/bin
mv /john/run/benchmark-unify /john-bin/usr/local/bin
mv /john/run/makechr /john-bin/usr/local/bin
mv /john/run/relbench /john-bin/usr/local/bin

chmod +x /john-bin/usr/local/bin/*


if [ $(ls -1 /john/run/ | wc -l) -ne 0 ]; then
    echo 'Files left:'
    ls -al /john/run/
    exit 1
fi

exit 0