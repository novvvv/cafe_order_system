# 데이터베이스 설정 가이드

## 1. MySQL 설치 확인

MySQL이 설치되어 있고 실행 중인지 확인하세요.

## 2. SQL 파일 실행 방법

### 방법 1: MySQL Workbench 사용

1. MySQL Workbench 실행
2. File → Open SQL Script
3. `create_table.sql` 파일 선택
4. Execute 버튼 클릭

### 방법 2: 터미널/명령 프롬프트 사용

```bash
# MySQL 접속
mysql -u root -p

# SQL 파일 실행
source /Users/choedoil/Desktop/web_cafe_prj/src/main/resources/sql/create_table.sql
```

### 방법 3: 직접 SQL 복사해서 실행

1. `create_table.sql` 파일 내용 복사
2. MySQL 클라이언트에 붙여넣기
3. 실행

## 3. 데이터베이스 연결 정보

애플리케이션에서 사용할 DB 연결 정보:

- **데이터베이스명**: `cafe_db`
- **테이블명**: `cafe_orders`
- **포트**: 3306 (기본값)
- **사용자명**: root (또는 본인의 MySQL 사용자명)
- **비밀번호**: 본인의 MySQL 비밀번호

## 4. 테이블 구조

### cafe_orders 테이블

| 컬럼명          | 타입         | 설명                        |
| --------------- | ------------ | --------------------------- |
| order_id        | INT          | 주문 ID (PK, 자동증가)      |
| customer_name   | VARCHAR(50)  | 고객 이름                   |
| customer_phone  | VARCHAR(20)  | 고객 연락처                 |
| menu_name       | VARCHAR(50)  | 메뉴 이름                   |
| size_code       | VARCHAR(10)  | 사이즈 코드 (S, M, L, G, X) |
| temperature     | VARCHAR(10)  | 온도 (H: Hot, I: Ice)       |
| quantity        | INT          | 수량                        |
| unit_price      | INT          | 단가                        |
| total_price     | INT          | 총 가격                     |
| request_message | VARCHAR(500) | 요청사항 (선택사항)         |
| order_time      | TIMESTAMP    | 주문 시간 (자동 설정)       |

## 5. 테스트 데이터 삽입 (선택사항)

테스트를 위해 샘플 데이터를 넣고 싶다면:

```sql
INSERT INTO cafe_orders
(customer_name, customer_phone, menu_name, size_code, temperature, quantity, unit_price, total_price, request_message)
VALUES
('홍길동', '010-1234-5678', 'americano', 'M', 'H', 2, 4500, 9000, '따뜻하게 주세요'),
('김영희', '010-9876-5432', 'latte', 'L', 'I', 1, 5500, 5500, NULL);
```
