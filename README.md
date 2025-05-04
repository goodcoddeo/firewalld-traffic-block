# 🇰🇷 한국 IP만 허용하는 firewalld 기반 해외망 차단 스크립트

마인크래프트 서버나 리눅스 서버를 운영할 때, 해외에서 들어오는 디도스 공격이나 불필요한 접근을 차단하고 싶은 경우가 많습니다.  
이 스크립트는 **한국 IP만 허용**하고, 나머지 해외 IP는 모두 차단하는 간단한 방화벽 도구입니다.

## 🧰 기능

- `firewalld` + `ipset` 기반으로 **빠르고 효율적인 차단**
- 한국 IP 대역(CIDR)을 실시간으로 다운로드하여 최신 상태 유지
- 해외망 **차단 / 해제**를 명령어 한 줄로 제어

## ❗ 방화벽
- 위 해외망 차단 스크립트는 `firewalld` 방화벽만 사용할 수 있습니다!
- `iptables` 방화벽을 사용하고 계신다면? [여기를 클릭해주세요](https://github.com/goodcoddeo/iptables-traffic-block)

## 🔧 설치 방법

### 1. 필요 패키지 설치

```bash
sudo apt update -y && sudo apt install firewalld ipset curl -y
```

### 2. 스크립트 다운로드
```
wget https://raw.githubusercontent.com/goodcoddeo/firewalld-traffic-block/refs/heads/main/block-overseas-network.sh
sudo chmod +x firewalld_country_block.sh
```

### 3. 해외망 차단 / 해제
- 해외망 차단 (한국만 허용):
```
sudo ./block-overseas-network.sh block
```

## 📁 한국 IP 대역
https://github.com/herrbischoff/country-ip-blocks/blob/master/ipv4/kr.cidr

## ⚠️ 주의사항
기본 zone은 public으로 설정되어 있습니다. 서버의 zone이 다르면 스크립트 내 ZONE 값을 수정하세요:
```firewall-cmd --get-default-zone```

이 스크립트는 서버의 public zone에 firewalld 규칙을 추가하므로, 사용 중인 방화벽 정책에 따라 테스트 후 사용하세요.

ipset을 지원하지 않는 환경에서는 동작하지 않습니다.

클라우드 호스팅에서는 해당 정책이 정상 동작하지 않을 수 있습니다 (예: AWS 보안 그룹 등).

