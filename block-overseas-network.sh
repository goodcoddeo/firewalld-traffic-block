#!/bin/bash

SET_NAME=kr_allow
ZONE=public
KR_CIDR_URL="https://raw.githubusercontent.com/herrbischoff/country-ip-blocks/master/ipv4/kr.cidr"
TMP_FILE="/tmp/kr.cidr"

function block_foreign() {
    echo "[*] 한국 IP만 허용하는 중..."

    curl -s -o $TMP_FILE "$KR_CIDR_URL" || {
        echo "❌ 한국 IP 목록 다운로드 실패"
        exit 1
    }

    if ! ipset list "$SET_NAME" &>/dev/null; then
        ipset create "$SET_NAME" hash:net
    else
        ipset flush "$SET_NAME"
    fi

    while read ip; do
        ipset add "$SET_NAME" "$ip"
    done < "$TMP_FILE"

    firewall-cmd --permanent --new-ipset="$SET_NAME" --type=hash:net || true
    firewall-cmd --permanent --ipset="$SET_NAME" --add-entries-from-file="$TMP_FILE"

    firewall-cmd --permanent --zone=$ZONE --add-rich-rule="rule source ipset=$SET_NAME accept"
    firewall-cmd --permanent --zone=$ZONE --add-rich-rule="rule family=ipv4 source not ipset=$SET_NAME drop"

    firewall-cmd --reload

    echo "[+] 해외 IP 차단 완료 (한국 IP만 허용됨)"
}

function unblock_foreign() {
    echo "[*] 해외망 차단 해제 중..."

    firewall-cmd --permanent --zone=$ZONE --remove-rich-rule="rule source ipset=$SET_NAME accept"
    firewall-cmd --permanent --zone=$ZONE --remove-rich-rule="rule family=ipv4 source not ipset=$SET_NAME drop"
    firewall-cmd --permanent --delete-ipset="$SET_NAME"

    firewall-cmd --reload

    echo "[+] 해외망 차단 해제 완료 (모든 IP 허용됨)"
}

case "$1" in
    block)
        block_foreign
        ;;
    unblock)
        unblock_foreign
        ;;
    *)
        echo "사용법: $0 {block|unblock}"
        ;;
esac
