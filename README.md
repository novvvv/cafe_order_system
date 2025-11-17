# 웹 카페 프로젝트

JSP 기반 웹 애플리케이션 프로젝트입니다.

## 프로젝트 구조

```
web_cafe_prj/
├── pom.xml                          # Maven 설정 파일
├── src/
│   └── main/
│       ├── java/                    # Java 소스 코드
│       │   └── com/cafe/
│       │       └── filter/          # 필터 클래스
│       └── webapp/                  # 웹 리소스
│           ├── WEB-INF/
│           │   ├── web.xml         # 웹 애플리케이션 설정
│           │   └── views/          # JSP 뷰 파일
│           ├── css/                # 스타일시트
│           ├── js/                 # JavaScript 파일
│           ├── error/              # 에러 페이지
│           └── index.jsp          # 메인 페이지
└── README.md
```

## 필수 세팅 사항

### 1. Java 개발 환경

- JDK 11 이상 설치 필요
- JAVA_HOME 환경 변수 설정

### 2. Maven 설치

- Maven 3.6 이상 설치 필요
- MAVEN_HOME 환경 변수 설정

### 3. 웹 서버 (Tomcat)

- Apache Tomcat 9.0 이상 설치
- 또는 Maven Tomcat 플러그인 사용 (로컬 개발용)

## 실행 방법

### Maven을 사용한 빌드

```bash
# 프로젝트 빌드
mvn clean package

# 생성된 WAR 파일: target/web-cafe.war
```

### Tomcat Maven 플러그인으로 실행 (로컬 개발)

```bash
# Tomcat 서버 실행 (포트 8080)
mvn tomcat7:run

# 브라우저에서 http://localhost:8080 접속
```

### 외부 Tomcat 서버에 배포

1. `target/web-cafe.war` 파일을 Tomcat의 `webapps` 디렉토리에 복사
2. Tomcat 서버 시작
3. 브라우저에서 `http://localhost:8080/web-cafe` 접속

## 주요 설정 파일

### pom.xml

- 프로젝트 의존성 관리
- 빌드 설정
- Servlet API, JSP API, JSTL 등 포함

### web.xml

- 웹 애플리케이션 설정
- 필터 설정 (인코딩)
- 세션 타임아웃 설정
- 에러 페이지 매핑

## 다음 단계

1. 데이터베이스 연결 설정 추가
2. 서블릿 클래스 작성
3. JSP 페이지 확장
4. 로그인/회원가입 기능 구현
5. 게시판 기능 구현

## 개발 환경

- Java: 11+
- Maven: 3.6+
- Servlet: 4.0
- JSP: 2.3
- JSTL: 1.2
