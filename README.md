# 🖥 Trivy 기반 이미지 모니터링 시스템

## 참여 인원 👨‍👨‍👧‍👧
| <img src="https://avatars.githubusercontent.com/u/83341978?v=4" width="150" height="150"/> | <img src="https://avatars.githubusercontent.com/u/129728196?v=4" width="150" height="150"/> | <img src="https://avatars.githubusercontent.com/u/104816148?v=4" width="150" height="150"/> | <img src="https://avatars.githubusercontent.com/u/86452494?v=4" width="150" height="150"/> |
|:-------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------:|:-------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------:|
|                     **박지원** <br/>[@jiione](https://github.com/jiione)                     |                      **최나영**<br/>[@na-rong](https://github.com/na-rong)                      |                     **박현서**<br/>[@hyleei](https://github.com/hyleei)                      |                 **백승지** <br/>[@seungji2001](https://github.com/seungji2001)                 |                         |
<br>

--- 

## 📝 개요
**컨테이너 보안은 오늘날 매우 중요한 사이버 보안 요소**입니다. 대부분의 컨테이너 이미지가 베이스 이미지에서 파생되며, 베이스 이미지 내부에는 개발자가 제어할 수 없는 잠재적 취약점이 존재할 수 있습니다. 이러한 이유로 우리는 **컨테이너 이미지를 스캔하여 취약점**을 찾아야 하며, 이는 개발자 구성 파일(Dockerfile, Kubernetes Manifest, IaC)에도 해당됩니다.

[Trivy](https://github.com/aquasecurity/trivy)는 이러한 **취약점과 보안 잘못된 구성을 스캔**할 수 있는 강력한 도구입니다. **Trivy**는 컨테이너 이미지뿐만 아니라 파일 시스템, Git 리포지토리, IaC, Dockerfile, Kubernetes Manifest의 취약점도 탐지할 수 있습니다.


## 💡 Trivy의 필요성
1. **취약점 탐지**: 컨테이너 이미지를 비롯한 여러 구성 파일의 취약점을 빠르게 파악할 수 있습니다.
2. **경량화**: 시장에 있는 다양한 보안 도구 중 하나로서 성능과 기능이 탁월합니다.
3. **CI 파이프라인 통합**: Jenkins, GitLab CI, CircleCI 등의 CI 도구와 쉽게 통합 가능하여 개발 과정에서 자동으로 보안 검사를 진행할 수 있습니다.

--- 

## 🛠️ 설치 방법
Trivy는 여러 플랫폼에서 지원되며, Ubuntu에서 설치하는 방법은 다음과 같습니다:

```bash
$ sudo apt-get install wget apt-transport-https gnupg lsb-release
$ wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
$ echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
$ sudo apt-get update
$ sudo apt-get install trivy
```

## 🔍 취약점 스캔 예시
Docker 이미지의 취약점을 스캔하려면 다음 명령어를 사용하세요:

```bash
$ trivy image <image_name>
```

예를 들어, `nginx:latest` 이미지를 스캔하려면:

```bash
$ trivy image nginx:latest
```
### 스캔 결과
```bash
nginx:latest (debian 11.6)
=============================
Total: 145 (HIGH: 145, CRITICAL: 0)

+--------------------------+------------------+----------+-------------------+----------------------+---------------------------------------+
|         LIBRARY          | VULNERABILITY ID | SEVERITY | INSTALLED VERSION |    FIXED VERSION     |                 TITLE                 |
+--------------------------+------------------+----------+-------------------+----------------------+---------------------------------------+
| libssl1.1                | CVE-2023-0464    | HIGH     | 1.1.1n-0+deb11u4  | 1.1.1n-0+deb11u4+exp | openssl: Denial of ## 📋 **프로젝트 목적**

1. **자동화된 취약점 스캐닝**: 컨테이너 이미지의 **Critical** 취약점을 정기적으로 탐지하여 보안 위협을 최소화.
2. **실시간 보안 알림**: **Slack**과의 연동을 통해 Critical 취약점이 발견될 경우 즉시 알림을 수신, 빠른 대응 가능.service           |
|                          |                  |          |                   |                      | vulnerability in DTLS                 |
+--------------------------+------------------+----------+-------------------+----------------------+---------------------------------------+
```
- LIBRARY: 취약점이 발견된 라이브러리 이름
- VULNERABILITY ID: CVE(Common Vulnerabilities and Exposures) ID
- SEVERITY: 취약점의 심각도
- INSTALLED VERSION: 현재 설치된 버전
- FIXED VERSION: 취약점이 수정된 버전
- TITLE: 취약점에 대한 간단한 설명

--- 
<br>

# 🛡️ 응용: Trivy를 사용하여 이미지 스캔 및 Critical 취약점 Slack 알림 설정

## 📋 **프로젝트 목적**

1. **자동화된 취약점 스캐닝**: 컨테이너 이미지의 **Critical** 취약점을 정기적으로 탐지하여 보안 위협을 최소화.
2. **실시간 보안 알림**: **Slack**과의 연동을 통해 Critical 취약점이 발견될 경우 즉시 알림을 수신, 빠른 대응 가능.

## ⚙️ **프로젝트 구성**

### 1. 🛠️ Trivy 및 jq 설치

 **Trivy**와 **jq**를 설치합니다.
`jq`는 JSON 데이터를 처리하는 도구입니다. Trivy의 JSON 결과를 필터링하여 취약점 정보를 추출하기 위해 사용됩니다:

```bash
# Trivy 설치
sudo apt-get update
sudo apt-get install trivy

# jq 설치
sudo apt-get install jq
```

## 2. 🔍 Trivy 스캔 스크립트 작성

아래의 스크립트는 Trivy를 사용하여 Docker 이미지를 스캔하고, Critical 취약점이 발견될 경우 Slack 알림을 전송 합니다.

```bash
#!/bin/bash

# 스캔할 이미지 이름을 지정 (예: nginx:latest)
IMAGE_NAME="nginx:latest"

# 스캔 결과를 JSON 파일로 저장
trivy image --severity CRITICAL --format json --output /tmp/trivy-result.json $IMAGE_NAME

# 스캔 결과에서 Critical 취약점이 있는지 확인
CRITICAL_COUNT=$(jq '[.Results[]?.Vulnerabilities[]? | select(.Severity == "CRITICAL")] | length' /tmp/trivy-result.json 2>/dev/null || echo 0)

# Critical 취약점이 1개 이상 발견되면 Slack으로 알림 전송
if [ "$CRITICAL_COUNT" -gt 0 ]; then
  # Critical 취약점의 세부 정보를 슬랙 메시지에 포함
  CRITICAL_DETAILS=$(jq -r '.Results[]?.Vulnerabilities[]? | select(.Severity == "CRITICAL") | "\(.VulnerabilityID): \(.Title)\nPackage: \(.PkgName) \(.InstalledVersion)\nDescription: \(.Description)\nSeverity: \(.Severity)\n"' /tmp/trivy-result.json 2>/dev/null || echo "No critical vulnerabilities found")

  # Slack 알림 전송
  curl -X POST -H 'Content-type: application/json' \
  --data "{\"text\": \"Critical vulnerabilities found in $IMAGE_NAME!\", \"attachments\": [{ \"title\": \"Trivy Scan Results\", \"text\": \"$CRITICAL_DETAILS\" }]}" \
  https://hooks.slack.com/services/YOUR_SLACK_WEBHOOK_URL
else
  echo "No Critical vulnerabilities found in $IMAGE_NAME"
fi
```

## 3. 🕒 Crontab을 사용하여 정기적으로 스캔
다음으로, crontab을 사용하여 Trivy 스캔을 정기적으로 실행할 수 있습니다. 여기서는 매일 새벽 2시에 스캔이 실행되도록 설정합니다.
### 1) 스크립트 파일에 실행 권한 부여:
```bash
sudo chmod +x /usr/local/bin/trivy-scan.sh
```
### 2) crontab 설정:
```bash
sudo crontab -e
```
이 명령어로 crontab을 열고 다음과 같이 새벽 2시에 스크립트를 실행하도록 설정합니다:
```
0 2 * * * /usr/local/bin/trivy-scan.sh
```
이 설정을 저장하면 매일 새벽 2시에 nginx
이미지가 스캔되며, Critical 취약점이 발견될 경우 Slack으로 알림이 전송됩니다.

## 4. 🔔 Slack 알림 설정
Slack 알림을 받기 위해서는 Slack Webhook URL을 설정해야 합니다. Slack Incoming Webhooks을 사용하여 Webhook URL을 생성한 후, 스크립트에 해당 URL을 입력하세요.
```bash
https://hooks.slack.com/services/YOUR_SLACK_WEBHOOK_URL
```
## 5. 🎉 Slack 확인
이제 Trivy를 사용하여 이미지의 Critical 취약점을 정기적으로 스캔하고, Slack을 통해 실시간으로 알림을 받을 수 있습니다! 🚀
![image](https://github.com/user-attachments/assets/dbee7e51-11b4-4aa5-a813-f83ef0754248)

## 📜 결론
**Trivy**를 기반으로 한 컨테이너 **이미지 취약점 스캐닝 시스템**을 구현하여, 보안 위협을 최소화하는 자동화된 방식으로 관리할 수 있게 합니다. 특히, Critical 취약점에 대한 실시간 Slack 알림 기능을 통해 신속하게 대응할 수 있으며, 이는 운영 환경에서 매우 중요한 요소입니다.

이 시스템을 통해 조직의 컨테이너 보안을 강화할 수 있으며, 지속적인 모니터링을 통해 취약점 발생 시 빠르게 대응함으로써 보안 사고를 사전에 방지할 수 있습니다. 향후에는 더 많은 CI/CD 도구와의 연동을 통해 DevOps 환경에서도 손쉽게 통합할 수 있는 확장성을 목표로 발전시킬 계획입니다.

