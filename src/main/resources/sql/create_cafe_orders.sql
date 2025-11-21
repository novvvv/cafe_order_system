-- 카페 주문 시스템 데이터베이스 및 테이블 생성 스크립트

-- 데이터베이스 생성 (이미 존재하면 무시)
CREATE DATABASE IF NOT EXISTS cafe_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 데이터베이스 사용
USE cafe_db;

-- 기존 테이블이 있으면 삭제 (주의: 기존 데이터가 모두 삭제됩니다)
DROP TABLE IF EXISTS cafe_orders;

-- 주문 테이블 생성
CREATE TABLE cafe_orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '주문 ID',
    customer_name VARCHAR(50) NOT NULL COMMENT '고객 이름',
    customer_phone VARCHAR(20) NOT NULL COMMENT '고객 연락처',
    menu_name VARCHAR(50) NOT NULL COMMENT '메뉴 이름',
    size_code VARCHAR(10) NOT NULL COMMENT '사이즈 코드 (S, M, L, G, X)',
    temperature VARCHAR(10) NOT NULL COMMENT '온도 (H: Hot, I: Ice)',
    quantity INT NOT NULL DEFAULT 1 COMMENT '수량',
    unit_price INT NOT NULL COMMENT '단가',
    total_price INT NOT NULL COMMENT '총 가격',
    request_message VARCHAR(500) COMMENT '요청사항',
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '주문 시간',
    INDEX idx_customer_phone (customer_phone),
    INDEX idx_order_time (order_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='카페 주문 테이블';

-- 테이블 생성 확인
SHOW TABLES;

-- 테이블 구조 확인
DESC cafe_orders;
