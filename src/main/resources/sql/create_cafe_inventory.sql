-- 카페 재고 관리 시스템 테이블 생성 스크립트

-- 데이터베이스 생성 (이미 존재하면 무시)
CREATE DATABASE IF NOT EXISTS cafe_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 데이터베이스 사용
USE cafe_db;

-- 기존 테이블이 있으면 삭제 
DROP TABLE IF EXISTS cafe_inventory;

-- 재고 관리 테이블 생성
CREATE TABLE cafe_inventory (
    menu_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '메뉴 고유 ID',
    menu_name VARCHAR(50) NOT NULL UNIQUE COMMENT '메뉴 이름',
    stock_quantity INT NOT NULL DEFAULT 0 COMMENT '잔여 재고 수량',
    INDEX idx_menu_name (menu_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='카페 재고 관리 테이블';


