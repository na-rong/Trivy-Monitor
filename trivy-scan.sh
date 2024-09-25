#!/bin/bash

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
  https://hooks.slack.com/services/slack_url
else
  echo "No Critical vulnerabilities found in $IMAGE_NAME"
fi
