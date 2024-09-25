## 팀원 👨‍👨‍👧‍👧
| <img src="https://avatars.githubusercontent.com/u/83341978?v=4" width="150" height="150"/> | <img src="https://avatars.githubusercontent.com/u/129728196?v=4" width="150" height="150"/> | <img src="https://avatars.githubusercontent.com/u/104816148?v=4" width="150" height="150"/> | <img src="https://avatars.githubusercontent.com/u/86452494?v=4" width="150" height="150"/> |
|:-------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------:|:-------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------:|
|                     **박지원** <br/>[@jiione](https://github.com/jiione)                     |                      **최나영**<br/>[@na-rong](https://github.com/na-rong)                      |                     **박현서**<br/>[@hyleei](https://github.com/hyleei)                      |                 **백승지** <br/>[@seungji2001](https://github.com/seungji2001)                 |                         |
<br>

--- 

## 📝 개요
컨테이너 보안은 오늘날 매우 중요한 사이버 보안 요소입니다. 대부분의 컨테이너 이미지가 베이스 이미지에서 파생되며, 베이스 이미지 내부에는 개발자가 제어할 수 없는 잠재적 취약점이 존재할 수 있습니다. 이러한 이유로 우리는 컨테이너 이미지를 스캔하여 취약점을 찾아야 하며, 이는 개발자 구성 파일(Dockerfile, Kubernetes Manifest, IaC)에도 해당됩니다.

[Trivy](https://github.com/aquasecurity/trivy)는 이러한 취약점과 보안 잘못된 구성을 스캔할 수 있는 강력한 도구입니다. Trivy는 컨테이너 이미지뿐만 아니라 파일 시스템, Git 리포지토리, IaC, Dockerfile, Kubernetes Manifest의 취약점도 탐지할 수 있습니다.


## 💡 Trivy의 필요성
1. **취약점 탐지**: 컨테이너 이미지를 비롯한 여러 구성 파일의 취약점을 빠르게 파악.
2. **경량화**: 시장에 있는 다양한 보안 도구 중 하나로서 성능과 기능이 탁월.
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
| libssl1.1                | CVE-2023-0464    | HIGH     | 1.1.1n-0+deb11u4  | 1.1.1n-0+deb11u4+exp | openssl: Denial of service           |
|                          |                  |          |                   |                      | vulnerability in DTLS                 |
+--------------------------+------------------+----------+-------------------+----------------------+---------------------------------------+
```
- LIBRARY: 취약점이 발견된 라이브러리 이름
- VULNERABILITY ID: CVE(Common Vulnerabilities and Exposures) ID
- SEVERITY: 취약점의 심각도
- INSTALLED VERSION: 현재 설치된 버전
- FIXED VERSION: 취약점이 수정된 버전
- TITLE: 취약점에 대한 간단한 설명

