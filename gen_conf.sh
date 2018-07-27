#!/bin/bash
BASE_DIR="$(cd $(dirname $0); pwd -P)"
if [[ ! "$#" -eq 1 ]]; then
    echo "please specify the virtual root, e.g. /git/"
    exit 1
fi

function remove_slashes {
    x="$1"
    case "$x" in *[!/]*/) x="${x%"${x##*[!/]}"}";; esac
    echo "$x"
}

VIRT_ROOT=$(remove_slashes "${1%/}")
echo $VIRT_ROOT
cat > theme.cgitrc << EOF
css=
logo=
virtual-root=$VIRT_ROOT
head-include=${BASE_DIR}/head.html
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

sed "s=%VIRT_ROOT%=$VIRT_ROOT=g" head.html.template > head.html
