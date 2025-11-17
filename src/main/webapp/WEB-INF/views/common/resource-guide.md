# 정적 리소스 파일 위치 가이드

## 파일 위치 구조

```
src/main/webapp/
├── css/                    # CSS 파일
│   ├── style.css          # 메인 스타일시트
│   ├── board.css          # 게시판 전용 스타일
│   └── member.css         # 회원 관련 스타일
│
├── js/                     # JavaScript 파일
│   ├── common.js          # 공통 JavaScript
│   ├── board.js           # 게시판 관련 스크립트
│   └── member.js          # 회원 관련 스크립트
│
├── images/                 # 이미지 파일
│   ├── logo.png
│   └── icons/
│
├── html/                   # 정적 HTML 파일 (선택사항)
│   └── static-pages.html
│
└── resources/              # 기타 리소스 (선택사항)
    ├── fonts/
    └── uploads/
```

## JSP에서 사용하는 방법

### CSS 파일 연결
```jsp
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
```

### JavaScript 파일 연결
```jsp
<script src="${pageContext.request.contextPath}/js/common.js"></script>
```

### 이미지 사용
```jsp
<img src="${pageContext.request.contextPath}/images/logo.png" alt="로고">
```

## 주의사항

1. **WEB-INF 폴더 안의 파일은 직접 접근 불가**
   - WEB-INF는 보안상 외부에서 직접 접근할 수 없습니다
   - 정적 리소스는 webapp 루트나 하위 폴더에 위치해야 합니다

2. **경로 사용 시 주의**
   - `${pageContext.request.contextPath}`를 사용하여 컨텍스트 경로를 동적으로 처리하세요
   - 절대 경로보다 상대 경로가 더 유연합니다

