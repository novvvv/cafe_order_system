document.addEventListener('DOMContentLoaded', function() {
    
    const orderForm = document.getElementById('orderForm');
    const nameInput = document.getElementById('name');
    const contactInput = document.getElementById('contact');
    const menuSelect = document.getElementById('menu');
    const sizeRadios = document.querySelectorAll('input[name="size"]');
    const temperatureRadios = document.querySelectorAll('input[name="temperature"]');
    const quantityInput = document.getElementById('quantity');
    const totalPriceElement = document.getElementById('totalPrice');

    // * ==========================  가격 계산 로직 ==========================  * 
    // * menuPrices : 메뉴별 기본 가격 변수 
    // * sizePrices : 사이즈별 추가 금액 변수 


    // * 메뉴별 기본 가격 변수 
    const menuPrices = {
        'americano': 4500,
        'espresso': 4300,
        'latte': 5000,
        'cappuccino': 5000
    };

    // * 사이즈별 추가 금액 변수 
    const sizePrices = {
        'S': 0,
        'M': 100,
        'L': 200,
        'G': 500,
        'X': 1000
    };

    // * cacluateTotal() - 총 가격 계산 함수
    function calculateTotal() {

        // [Exception] totalPriceElement를 찾을 수 없는 경우 예외 처리
        if (!totalPriceElement) {
            console.error('totalPriceElement를 찾을 수 없습니다.');
            return;
        }
        
        // [Variable] 메뉴, 사이즈, 수량 변수 선언
        // menu - <select> americano, espresso, latte, cappuccino 
        // sizeRadio - HTMLInputElement or null
        //     <input type="radio" name="size" value="M" checked>
        // size - S, M, L, G, X or null 
        // quantity - 수량 
        const menu = menuSelect.value;
        const sizeRadio = document.querySelector('input[name="size"]:checked');
        const size = sizeRadio ? sizeRadio.value : null;
        const quantity = parseInt(quantityInput.value) || 1;

        // * Case 1 : 메뉴, 사이즈가 모두 선택된 경우 
        if (menu && size) {

            const basePrice = menuPrices[menu] || 0;
            const sizePrice = sizePrices[size] || 0;
            const total = (basePrice + sizePrice) * quantity;
            totalPriceElement.textContent = total.toLocaleString() + '원';

        } 
        
        // * Case 2 : 메뉴만 선택된 경우 
        else if (menu) {

            const basePrice = menuPrices[menu] || 0; 
            const total = basePrice * quantity;
            totalPriceElement.textContent = total.toLocaleString() + '원';

        } 
        
        // * Case 3 : 아무것도 선택되지 않은 경우 
        else {
            totalPriceElement.textContent = '0원';
        }
    }

    // * ==========================  가격 계산 로직 ==========================  * 

    // 에러 메시지 표시 함수
    function showError(elementId, message) {
        const errorElement = document.getElementById(elementId);
        if (errorElement) {
            errorElement.textContent = message;
            errorElement.style.display = 'block';
        }
    }

    // 에러 메시지 숨기기 함수
    function hideError(elementId) {
        const errorElement = document.getElementById(elementId);
        if (errorElement) {
            errorElement.textContent = '';
            errorElement.style.display = 'none';
        }
    }

    // 이름 검증
    function validateName() {
        const name = nameInput.value.trim();
        if (name === '') {
            showError('nameError', '이름을 입력해주세요.');
            nameInput.style.borderBottomColor = '#666666';
            nameInput.style.borderBottomWidth = '2px';
            return false;
        }
        hideError('nameError');
        nameInput.style.borderBottomColor = '#000000';
        nameInput.style.borderBottomWidth = '1px';
        return true;
    }

    // 연락처 검증
    function validateContact() {
        const contact = contactInput.value.trim();
        if (contact === '') {
            showError('contactError', '연락처를 입력해주세요.');
            contactInput.style.borderBottomColor = '#666666';
            contactInput.style.borderBottomWidth = '2px';
            return false;
        }
        // 연락처 형식 검증 (선택사항)
        const phonePattern = /^[0-9-]+$/;
        if (!phonePattern.test(contact)) {
            showError('contactError', '올바른 연락처 형식을 입력해주세요.');
            contactInput.style.borderBottomColor = '#666666';
            contactInput.style.borderBottomWidth = '2px';
            return false;
        }
        hideError('contactError');
        contactInput.style.borderBottomColor = '#000000';
        contactInput.style.borderBottomWidth = '1px';
        return true;
    }

    // 메뉴 검증
    function validateMenu() {
        const menu = menuSelect.value;
        if (menu === '') {
            showError('menuError', '메뉴를 선택해주세요.');
            menuSelect.style.borderBottomColor = '#666666';
            menuSelect.style.borderBottomWidth = '2px';
            return false;
        }
        hideError('menuError');
        menuSelect.style.borderBottomColor = '#000000';
        menuSelect.style.borderBottomWidth = '1px';
        return true;
    }

    // 사이즈 검증
    function validateSize() {
        const sizeSelected = Array.from(sizeRadios).some(radio => radio.checked);
        if (!sizeSelected) {
            showError('sizeError', '사이즈를 선택해주세요.');
            return false;
        }
        hideError('sizeError');
        return true;
    }

    // 온도 검증
    function validateTemperature() {
        const temperatureSelected = Array.from(temperatureRadios).some(radio => radio.checked);
        if (!temperatureSelected) {
            showError('temperatureError', '온도를 선택해주세요.');
            return false;
        }
        hideError('temperatureError');
        return true;
    }

    // 수량 검증 (1 이상)
    function validateQuantity() {
        const quantity = parseInt(quantityInput.value);
        if (isNaN(quantity) || quantity < 1) {
            showError('quantityError', '수량은 1 이상이어야 합니다.');
            quantityInput.style.borderBottomColor = '#666666';
            quantityInput.style.borderBottomWidth = '2px';
            return false;
        }
        hideError('quantityError');
        quantityInput.style.borderBottomColor = '#000000';
        quantityInput.style.borderBottomWidth = '1px';
        return true;
    }

    // 전체 폼 검증
    function validateForm() {
        let isValid = true;
        
        isValid = validateName() && isValid;
        isValid = validateContact() && isValid;
        isValid = validateMenu() && isValid;
        isValid = validateSize() && isValid;
        isValid = validateTemperature() && isValid;
        isValid = validateQuantity() && isValid;

        return isValid;
    }

    // 실시간 검증 이벤트 리스너
    nameInput.addEventListener('blur', validateName);
    nameInput.addEventListener('input', function() {
        if (nameInput.value.trim() !== '') {
            hideError('nameError');
            nameInput.style.borderBottomColor = '#000000';
            nameInput.style.borderBottomWidth = '1px';
        }
    });

    contactInput.addEventListener('blur', validateContact);
    contactInput.addEventListener('input', function() {
        if (contactInput.value.trim() !== '') {
            hideError('contactError');
            contactInput.style.borderBottomColor = '#000000';
            contactInput.style.borderBottomWidth = '1px';
        }
    });


    // * menuSelect 이벤트 리스너 
    menuSelect.addEventListener('change', function() {
        validateMenu();
        calculateTotal(); 
        if (menuSelect.value !== '') {
            hideError('menuError');
            menuSelect.style.borderBottomColor = '#000000';
            menuSelect.style.borderBottomWidth = '1px';
        }
    });

    sizeRadios.forEach(radio => {
        radio.addEventListener('change', function() {
            if (Array.from(sizeRadios).some(r => r.checked)) {
                hideError('sizeError');
                calculateTotal(); // 가격 계산
            }
        });
    });

    temperatureRadios.forEach(radio => {
        radio.addEventListener('change', function() {
            if (Array.from(temperatureRadios).some(r => r.checked)) {
                hideError('temperatureError');
            }
        });
    });

    quantityInput.addEventListener('blur', validateQuantity);
    quantityInput.addEventListener('input', function() {
        const quantity = parseInt(quantityInput.value);
        if (!isNaN(quantity) && quantity >= 1) {
            hideError('quantityError');
            quantityInput.style.borderBottomColor = '#000000';
            quantityInput.style.borderBottomWidth = '1px';
            calculateTotal(); // 가격 계산
        }
    });

    // 폼 제출 이벤트
    orderForm.addEventListener('submit', function(e) {
        e.preventDefault(); // 기본 제출 동작 방지
        
        if (validateForm()) {
            // 모든 검증 통과 시
            if (confirm('주문을 제출하시겠습니까?')) {
                orderForm.submit(); // 실제 제출
            }
        } else {
            alert('입력 항목을 확인해주세요.');
            // 첫 번째 에러 필드로 스크롤
            const firstError = document.querySelector('.error-message:not(:empty)');
            if (firstError) {
                firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        }
    });

    // 초기화 버튼 클릭 시 에러 메시지도 초기화
    const resetButton = document.querySelector('.btn-reset');
    if (resetButton) {
        resetButton.addEventListener('click', function() {
            setTimeout(function() {
                hideError('nameError');
                hideError('contactError');
                hideError('menuError');
                hideError('sizeError');
                hideError('temperatureError');
                hideError('quantityError');
                
                // 입력 필드 스타일 초기화
                nameInput.style.borderBottomColor = '#000000';
                nameInput.style.borderBottomWidth = '1px';
                contactInput.style.borderBottomColor = '#000000';
                contactInput.style.borderBottomWidth = '1px';
                menuSelect.style.borderBottomColor = '#000000';
                menuSelect.style.borderBottomWidth = '1px';
                quantityInput.style.borderBottomColor = '#000000';
                quantityInput.style.borderBottomWidth = '1px';
                
                // 총액 초기화
                calculateTotal();
            }, 100);
        });
    }
    
    // 페이지 로드 시 초기 계산 실행
    calculateTotal();
});

