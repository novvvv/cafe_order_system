package com.cafe.util;

import java.util.Map;
import java.util.Calendar;

/**
 * 예상 대기시간을 계산하는 유틸리티 클래스
 */
public class WaitTimeCalculator {

    // -- init : 수식 가중치 변수 선언. (메뉴, 바리스타수, 제조중 건수, 메뉴명에 따른 제조시간) --
    private static final int PREP_TIME_AMERICANO = 60; // 아메리카노: 60초
    private static final int PREP_TIME_ESPRESSO = 60; // 에스프레소: 60초
    private static final int PREP_TIME_CAPPUCCINO = 90; // 카푸치노: 90초
    private static final int PREP_TIME_LATTE = 90; // 카페라떼: 90초
    private static final int DEFAULT_BARISTA_COUNT = 2;
    private static final int WAIT_TIME_PER_ORDER = 30;

    // Method: getPreparationTime() - 메뉴명에 따른 제조시간 반환
    private static int getPreparationTime(String menuName) {

        if (menuName == null) {
            return 60; // 기본값
        }

        // 메뉴명을 소문자로 변환하여 비교
        String menuLower = menuName.toLowerCase().trim();

        if (menuLower.contains("아메리카노") || menuLower.contains("americano")) {
            return PREP_TIME_AMERICANO;
        } else if (menuLower.contains("에스프레소") || menuLower.contains("espresso")) {
            return PREP_TIME_ESPRESSO;
        } else if (menuLower.contains("카푸치노") || menuLower.contains("cappuccino")) {
            return PREP_TIME_CAPPUCCINO;
        } else if (menuLower.contains("카페라떼") || menuLower.contains("라떼") ||
                menuLower.contains("latte")) {
            return PREP_TIME_LATTE;
        }
        return 60;
    }

    // Method: getTimeWeight() - 시간대 가중치 반환
    private static double getTimeWeight() {
        Calendar cal = Calendar.getInstance();
        int hour = cal.get(Calendar.HOUR_OF_DAY);
        if ((hour >= 12 && hour < 14) || (hour >= 17 && hour < 19)) {
            return 1.2;
        }
        return 1.0;
    }

    // Method: calculateWaitTime() - 예상 대기시간 계산
    public static int calculateWaitTime(Map<String, Integer> menuCounts,
            int pendingOrderCount,
            int baristaCount) {

        int actualBaristaCount = (baristaCount > 0) ? baristaCount : DEFAULT_BARISTA_COUNT;

        // Logic1. 메뉴별 제조시간 합산 계산
        // -- menuCounts.entrySet() : Map의 Key-Value 쌍을 Set 형태로 반환 --
        // -- entry.getKey() : Map의 Key 값을 반환 --
        // -- entry.getValue() : Map의 Value 값을 반환 --
        int totalPreparationTime = 0;
        if (menuCounts != null) {
            for (Map.Entry<String, Integer> entry : menuCounts.entrySet()) {
                String menuName = entry.getKey();
                int quantity = entry.getValue();
                int prepTime = getPreparationTime(menuName);
                totalPreparationTime += prepTime * quantity;
            }
        }

        // Logic2. 바리스타 수로 나누기
        double baseWaitTime = (double) totalPreparationTime / actualBaristaCount;

        // Logic3. 시간대 가중치 적용
        double timeWeight = getTimeWeight();
        double weightedWaitTime = baseWaitTime * timeWeight;

        // Logic4. 제조중 건수에 따른 추가 대기시간 (건당 30초)
        int additionalWaitTime = pendingOrderCount * WAIT_TIME_PER_ORDER;

        // Logic5. 최종 대기시간 계산 (소수점 반올림)
        int finalWaitTime = (int) Math.round(weightedWaitTime + additionalWaitTime);

        return finalWaitTime;
    }

    // Method: formatWaitTime() - 초 단위 시간을 "X분 Y초" 형식의 문자열로 변환
    public static String formatWaitTime(int seconds) {

        // -- Init --
        if (seconds < 0) {
            return "0초";
        }

        int minutes = seconds / 60;
        int remainingSeconds = seconds % 60;

        if (minutes == 0) {
            return remainingSeconds + "초";
        } else if (remainingSeconds == 0) {
            return minutes + "분";
        } else {
            return minutes + "분 " + remainingSeconds + "초";
        }
    }
}
