#!/bin/bash
BASE_DIR="$(cd $(dirname $0); pwd -P)"
if [[ ! "$#" -eq 1 ]]; then
    echo "please specify the virtual root, e.g. /git/"
    exit 1
fi
VIRT_ROOT=${1%/}
cat > theme.cgitrc << EOF
css=
logo=
virtual-root=$VIRT_ROOT
header=${BASE_DIR}/header.html
footer=${BASE_DIR}/footer.html
source-filter=${BASE_DIR}/syntax-highlighting.py
about-filter=${BASE_DIR}/about-formatting.sh
readme=:README.md
readme=:README.rst
enable-commit-graph=1
EOF
echo "Done."

cat > nginx.conf << EOF
location $VIRT_ROOT/assets {
    root ${BASE_DIR};
    rewrite ^$VIRT_ROOT/assets(.*)$ /assets\$1 break;
    disable_symlinks off;
}
EOF
