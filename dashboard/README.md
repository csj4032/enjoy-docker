## Grafana Docker Compose 실행 가이드

이 문서는 Docker Compose를 사용하여 Grafana를 실행하는 방법을 설명합니다.
Docker Compose를 사용하면 여러 컨테이너로 구성된 애플리케이션을 하나의 YAML 파일로 정의하고, 단일 명령으로 손쉽게 실행·중지할 수 있습니다.

### 사전 준비 사항

#### Docker Compose 설치 확인

먼저 Docker Compose가 설치되어 있는지 확인합니다.

```bash
docker compose version
```

만약 명령어가 실행되지 않는다면, 아래 문서를 참고하여 설치하세요.

### Docker Compose 설치 가이드

💡 Linux (Ubuntu, Debian 등)
docker 명령 실행 시 sudo가 필요할 수 있습니다.
또는 사용자를 docker 그룹에 추가하세요.

### Grafana 최신 버전 실행하기

아래 예제는 Compose 버전 3 기준입니다.

#### docker-compose.yaml 파일 생성

```bash
cd /path/to/docker-compose-directory
touch docker-compose.yaml
```

#### 기본 Grafana 실행 설정

```yaml
services:
  grafana:
    image: grafana/grafana-enterprise
    container_name: grafana
    restart: unless-stopped
    ports:
      - "3000:3000"
```

#### Grafana 컨테이너 실행

```bash
docker compose up -d
```

#### 실행 확인

```bash
http://IP_ADDRESS:3000
```