# Java Map.Entry와 entrySet() 완벽 가이드

## 목차
1. [Map의 기본 개념](#1-map의-기본-개념)
2. [Map.Entry란?](#2-mapentry란)
3. [entrySet() 메서드 이해하기](#3-entryset-메서드-이해하기)
4. [실전 예제 코드](#4-실전-예제-코드)
5. [다른 순회 방법과 비교](#5-다른-순회-방법과-비교)
6. [성능 비교 및 사용 가이드](#6-성능-비교-및-사용-가이드)

---

## 1. Map의 기본 개념

### Map이란?
`Map`은 Java에서 **키(Key)와 값(Value)의 쌍**으로 데이터를 저장하는 자료구조입니다.

```java
Map<String, Integer> map = new HashMap<>();
map.put("사과", 5);      // 키: "사과", 값: 5
map.put("바나나", 3);    // 키: "바나나", 값: 3
map.put("오렌지", 7);   // 키: "오렌지", 값: 7
```

### Map의 구조
```
┌──────────┬───────┐
│   키     │  값   │
├──────────┼───────┤
│ "사과"   │   5   │
│ "바나나" │   3   │
│ "오렌지" │   7   │
└──────────┴───────┘
```

---

## 2. Map.Entry란?

### Map.Entry의 정의
`Map.Entry`는 **하나의 키-값 쌍을 나타내는 인터페이스**입니다. Map 내부의 각 항목을 표현합니다.

```java
// Map.Entry 인터페이스의 주요 메서드
interface Map.Entry<K, V> {
    K getKey();      // 키를 반환
    V getValue();    // 값을 반환
    V setValue(V value);  // 값을 설정
}
```

### Map.Entry의 역할
- **하나의 키-값 쌍을 하나의 객체로 표현**
- 키와 값을 함께 다룰 수 있게 해줌
- Map의 내부 구조를 추상화

---

## 3. entrySet() 메서드 이해하기

### entrySet()이란?
`entrySet()`은 Map의 **모든 키-값 쌍을 Set 형태로 반환**하는 메서드입니다.

```java
Set<Map.Entry<String, Integer>> entries = map.entrySet();
```

### entrySet()의 반환 타입
- **반환 타입**: `Set<Map.Entry<K, V>>`
- Map의 모든 항목을 `Map.Entry` 객체들의 Set으로 반환
- 각 `Map.Entry`는 하나의 키-값 쌍을 나타냄

### 시각적 이해
```java
Map<String, Integer> menuCounts = new HashMap<>();
menuCounts.put("아메리카노", 3);
menuCounts.put("카페라떼", 2);
menuCounts.put("카푸치노", 1);

// entrySet() 호출
Set<Map.Entry<String, Integer>> entries = menuCounts.entrySet();

// 결과:
// [
//   Entry("아메리카노", 3),  ← entry.getKey() = "아메리카노"
//                             entry.getValue() = 3
//   Entry("카페라떼", 2),    ← entry.getKey() = "카페라떼"
//                             entry.getValue() = 2
//   Entry("카푸치노", 1)     ← entry.getKey() = "카푸치노"
//                             entry.getValue() = 1
// ]
```

---

## 4. 실전 예제 코드

### 예제 1: 기본 사용법

```java
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class MapEntryExample {
    public static void main(String[] args) {
        // Map 생성 및 데이터 추가
        Map<String, Integer> scores = new HashMap<>();
        scores.put("김철수", 95);
        scores.put("이영희", 87);
        scores.put("박민수", 92);
        
        // entrySet()을 사용한 순회
        for (Map.Entry<String, Integer> entry : scores.entrySet()) {
            String name = entry.getKey();      // 키 추출
            Integer score = entry.getValue();   // 값 추출
            
            System.out.println(name + "의 점수: " + score);
        }
        
        // 출력 결과:
        // 김철수의 점수: 95
        // 이영희의 점수: 87
        // 박민수의 점수: 92
    }
}
```

### 예제 2: 카페 주문 시스템 (실제 프로젝트 예제)

```java
public class WaitTimeCalculator {
    
    // 메뉴별 제조시간 계산
    public static int calculateTotalTime(Map<String, Integer> menuCounts) {
        int totalTime = 0;
        
        // entrySet()을 사용하여 키와 값을 함께 처리
        for (Map.Entry<String, Integer> entry : menuCounts.entrySet()) {
            String menuName = entry.getKey();      // 메뉴명
            int quantity = entry.getValue();        // 수량
            
            // 메뉴별 제조시간 × 수량
            int prepTime = getPreparationTime(menuName);
            totalTime += prepTime * quantity;
        }
        
        return totalTime;
    }
    
    private static int getPreparationTime(String menuName) {
        // 메뉴별 제조시간 반환 로직
        if (menuName.contains("아메리카노")) return 60;
        if (menuName.contains("카페라떼")) return 90;
        return 60; // 기본값
    }
    
    public static void main(String[] args) {
        Map<String, Integer> orders = new HashMap<>();
        orders.put("아메리카노", 3);  // 아메리카노 3잔
        orders.put("카페라떼", 2);    // 카페라떼 2잔
        
        int totalTime = calculateTotalTime(orders);
        System.out.println("총 제조시간: " + totalTime + "초");
        // 출력: 총 제조시간: 360초 (60*3 + 90*2)
    }
}
```

### 예제 3: 조건부 처리

```java
public class MapFilterExample {
    public static void main(String[] args) {
        Map<String, Integer> products = new HashMap<>();
        products.put("노트북", 1500000);
        products.put("마우스", 50000);
        products.put("키보드", 120000);
        products.put("모니터", 300000);
        
        // 10만원 이상인 상품만 출력
        System.out.println("=== 10만원 이상 상품 ===");
        for (Map.Entry<String, Integer> entry : products.entrySet()) {
            String productName = entry.getKey();
            int price = entry.getValue();
            
            if (price >= 100000) {
                System.out.println(productName + ": " + price + "원");
            }
        }
        
        // 출력 결과:
        // === 10만원 이상 상품 ===
        // 노트북: 1500000원
        // 키보드: 120000원
        // 모니터: 300000원
    }
}
```

### 예제 4: 값 수정하기

```java
public class MapUpdateExample {
    public static void main(String[] args) {
        Map<String, Integer> inventory = new HashMap<>();
        inventory.put("사과", 10);
        inventory.put("바나나", 5);
        inventory.put("오렌지", 8);
        
        // 모든 재고를 2배로 증가
        for (Map.Entry<String, Integer> entry : inventory.entrySet()) {
            int currentStock = entry.getValue();
            entry.setValue(currentStock * 2);  // 값 수정
        }
        
        // 결과 확인
        System.out.println(inventory);
        // 출력: {사과=20, 바나나=10, 오렌지=16}
    }
}
```

---

## 5. 다른 순회 방법과 비교

### 방법 1: entrySet() 사용 (권장)

```java
// ✅ 키와 값을 함께 사용할 때 가장 효율적
for (Map.Entry<String, Integer> entry : map.entrySet()) {
    String key = entry.getKey();
    Integer value = entry.getValue();
    // 키와 값을 한 번에 처리
}
```

**장점:**
- 키와 값을 한 번에 가져옴
- 가장 효율적인 방법 (O(1) 조회)
- 코드가 깔끔하고 읽기 쉬움

**단점:**
- 없음 (가장 권장되는 방법)

### 방법 2: keySet() 사용

```java
// ⚠️ 키로 값을 다시 조회해야 함 (비효율적)
for (String key : map.keySet()) {
    Integer value = map.get(key);  // 키로 값을 다시 조회
    // 처리 로직
}
```

**장점:**
- 키만 순회할 때 유용
- 키를 먼저 확인하고 값이 필요할 때만 조회 가능

**단점:**
- 값을 얻기 위해 `get()` 메서드를 추가로 호출해야 함
- `entrySet()`보다 느림 (HashMap의 경우 O(1)이지만 추가 조회 발생)

### 방법 3: values() 사용

```java
// ⚠️ 값만 순회, 키는 알 수 없음
for (Integer value : map.values()) {
    // 값만 처리, 키는 사용 불가
}
```

**장점:**
- 값만 필요할 때 유용
- 간단한 코드

**단점:**
- 키에 접근할 수 없음
- 키-값 쌍을 함께 처리할 수 없음

### 방법 4: Iterator 사용 (전통적인 방법)

```java
// Iterator를 사용한 순회
Iterator<Map.Entry<String, Integer>> iterator = map.entrySet().iterator();
while (iterator.hasNext()) {
    Map.Entry<String, Integer> entry = iterator.next();
    String key = entry.getKey();
    Integer value = entry.getValue();
    
    // 필요시 iterator.remove()로 항목 제거 가능
}
```

**장점:**
- 순회 중 항목 제거 가능 (`iterator.remove()`)
- 더 세밀한 제어 가능

**단점:**
- 코드가 길고 복잡함
- 일반적인 경우에는 향상된 for문이 더 간단

---

## 6. 성능 비교 및 사용 가이드

### 성능 비교

| 방법 | 시간 복잡도 | 설명 |
|------|------------|------|
| `entrySet()` | O(n) | 가장 효율적, 키-값 쌍을 직접 접근 |
| `keySet() + get()` | O(n) | 추가 조회 발생, 약간 느림 |
| `values()` | O(n) | 값만 필요할 때 유용 |

### 언제 어떤 방법을 사용할까?

#### ✅ entrySet() 사용 권장 상황
- **키와 값을 모두 사용**할 때
- Map의 모든 항목을 처리할 때
- 값만 수정해야 할 때 (`entry.setValue()`)

```java
// 예: 총합 계산, 필터링, 변환 등
int total = 0;
for (Map.Entry<String, Integer> entry : map.entrySet()) {
    total += entry.getValue();
}
```

#### ✅ keySet() 사용 권장 상황
- **키만 순회**하고 값은 선택적으로 조회할 때
- 키를 먼저 확인하고 조건에 따라 값 조회가 필요할 때

```java
// 예: 특정 키가 존재하는지 확인 후 값 조회
for (String key : map.keySet()) {
    if (key.startsWith("VIP_")) {
        Integer value = map.get(key);
        // 처리
    }
}
```

#### ✅ values() 사용 권장 상황
- **값만 필요**하고 키는 필요 없을 때
- 모든 값의 합, 평균 등을 계산할 때

```java
// 예: 값들의 합계 계산
int sum = 0;
for (Integer value : map.values()) {
    sum += value;
}
```

---

## 7. 실무 활용 팁

### 팁 1: 람다 표현식과 함께 사용

```java
// Java 8 이상: forEach와 람다 표현식
map.entrySet().forEach(entry -> {
    System.out.println(entry.getKey() + ": " + entry.getValue());
});

// 또는 더 간단하게
map.forEach((key, value) -> {
    System.out.println(key + ": " + value);
});
```

### 팁 2: Stream API 활용

```java
// Stream을 사용한 필터링 및 변환
Map<String, Integer> filtered = map.entrySet().stream()
    .filter(entry -> entry.getValue() > 100)
    .collect(Collectors.toMap(
        Map.Entry::getKey,
        Map.Entry::getValue
    ));
```

### 팁 3: 중첩 Map 처리

```java
Map<String, Map<String, Integer>> nestedMap = new HashMap<>();

// 중첩된 Map 순회
for (Map.Entry<String, Map<String, Integer>> outerEntry : nestedMap.entrySet()) {
    String outerKey = outerEntry.getKey();
    Map<String, Integer> innerMap = outerEntry.getValue();
    
    for (Map.Entry<String, Integer> innerEntry : innerMap.entrySet()) {
        String innerKey = innerEntry.getKey();
        Integer value = innerEntry.getValue();
        // 처리 로직
    }
}
```

---

## 8. 정리

### 핵심 요약

1. **Map.Entry**: 하나의 키-값 쌍을 나타내는 인터페이스
   - `getKey()`: 키 반환
   - `getValue()`: 값 반환
   - `setValue()`: 값 설정

2. **entrySet()**: Map의 모든 키-값 쌍을 Set으로 반환
   - 반환 타입: `Set<Map.Entry<K, V>>`
   - 키와 값을 함께 처리할 때 가장 효율적

3. **사용 시나리오**:
   - 키와 값을 모두 사용 → `entrySet()` ✅
   - 키만 필요 → `keySet()`
   - 값만 필요 → `values()`

### 기억할 점

```java
// 가장 일반적이고 권장되는 패턴
for (Map.Entry<K, V> entry : map.entrySet()) {
    K key = entry.getKey();
    V value = entry.getValue();
    // 처리 로직
}
```

이 패턴을 익혀두면 Map을 다룰 때 매우 유용합니다! 🚀

---

## 참고 자료

- [Oracle Java Documentation - Map.Entry](https://docs.oracle.com/javase/8/docs/api/java/util/Map.Entry.html)
- [Oracle Java Documentation - Map.entrySet()](https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#entrySet--)

