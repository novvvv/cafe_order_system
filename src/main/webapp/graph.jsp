<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cafe.dao.OrderDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.cafe.dto.Order" %>
<%@ page import="java.util.Set" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주문 통계</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reset.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .chart-container {
            margin-top: 2rem;
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            border: 1px solid #e0e0e0;
        }

        /* Tab Button Desgin */ 
        .chart-tabs {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
        }
        .chart-tab {
            padding: 0.75rem 1.5rem;
            background: #f5f5f5;
            border: 1px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s;
            color: #333;
        }
        .chart-tab:hover {
            background: #e9e9e9;
        }
        .chart-tab.active {
            background: #e0e0e0;
            color: #333;
            border-color: #bbb;
        }

        /* Char Animation */
        .chart-wrapper {
            display: none;
            opacity: 0;
            transform: translateY(30px);
            transition: opacity 0.4s ease-out, transform 0.4s ease-out;
        }
        .chart-wrapper.active {
            display: block;
        }
        .chart-wrapper.active.show {
            opacity: 1;
            transform: translateY(0);
        }
        .chart-wrapper canvas {
            max-height: 400px;
        }
        .stats-info {
            margin-top: 1rem;
            padding: 1rem;
            background: #f9f9f9;
            border-radius: 4px;
            border: 1px solid #e0e0e0;
        }
        .stats-info p {
            margin: 0.5rem 0;
            color: #666;
        }
        .stats-info strong {
            color: #333;
        }
        .order-container h2 {
            color: #333;
        }
    </style>

</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <main>
        <div class="order-container">
            <h2>주문 통계 (완료된 주문 기준)</h2>
            
            <%
                // Logic1. Database 조회 (Completed Data 기준)

                OrderDAO orderDAO = new OrderDAO();
                Map<String, Map<String, Object>> dateStats = orderDAO.getCompletedOrdersByDate(); // 일별 통계
                Map<String, Map<String, Object>> weekStats = orderDAO.getCompletedOrdersByWeek(); // 주간 통계
                Map<String, Map<String, Object>> monthStats = orderDAO.getCompletedOrdersByMonth(); // 월별 통계
                request.setAttribute("dateStats", dateStats);
                request.setAttribute("weekStats", weekStats);
                request.setAttribute("monthStats", monthStats);
                
                // Logic2. JSON 문자열 생성
                // * Map을 JSON 문자열로 변환한다. 

                StringBuilder dateStatsJson = new StringBuilder("{");
                boolean first = true;
                for (Map.Entry<String, Map<String, Object>> entry : dateStats.entrySet()) {
                    if (!first) dateStatsJson.append(",");
                    dateStatsJson.append("\"").append(entry.getKey()).append("\":{");
                    dateStatsJson.append("\"orderCount\":").append(entry.getValue().get("orderCount"));
                    dateStatsJson.append(",\"totalRevenue\":").append(entry.getValue().get("totalRevenue"));
                    dateStatsJson.append("}");
                    first = false;
                }
                dateStatsJson.append("}");
                
                StringBuilder weekStatsJson = new StringBuilder("{");
                first = true;
                for (Map.Entry<String, Map<String, Object>> entry : weekStats.entrySet()) {
                    if (!first) weekStatsJson.append(",");
                    weekStatsJson.append("\"").append(entry.getKey()).append("\":{");
                    weekStatsJson.append("\"orderCount\":").append(entry.getValue().get("orderCount"));
                    weekStatsJson.append(",\"totalRevenue\":").append(entry.getValue().get("totalRevenue"));
                    weekStatsJson.append("}");
                    first = false;
                }
                weekStatsJson.append("}");
                
                StringBuilder monthStatsJson = new StringBuilder("{");
                first = true;
                for (Map.Entry<String, Map<String, Object>> entry : monthStats.entrySet()) {
                    if (!first) monthStatsJson.append(",");
                    monthStatsJson.append("\"").append(entry.getKey()).append("\":{");
                    monthStatsJson.append("\"orderCount\":").append(entry.getValue().get("orderCount"));
                    monthStatsJson.append(",\"totalRevenue\":").append(entry.getValue().get("totalRevenue"));
                    monthStatsJson.append("}");
                    first = false;
                }
                monthStatsJson.append("}");
            %>

            // Logic3. HTML Structure
            
            <div class="chart-container">
                <div class="chart-tabs">
                    <button class="chart-tab active" onclick="showChart('daily')">일별 통계</button>
                    <button class="chart-tab" onclick="showChart('weekly')">주간 통계</button>
                    <button class="chart-tab" onclick="showChart('monthly')">월별 통계</button>
                </div>
                
                <!-- 일별 차트 -->
                <div id="daily-chart" class="chart-wrapper active">
                    <canvas id="dailyChart"></canvas>
                    <div class="stats-info" id="daily-stats"></div>
                </div>
                
                <!-- 주간 차트 -->
                <div id="weekly-chart" class="chart-wrapper">
                    <canvas id="weeklyChart"></canvas>
                    <div class="stats-info" id="weekly-stats"></div>
                </div>
                
                <!-- 월별 차트 -->
                <div id="monthly-chart" class="chart-wrapper">
                    <canvas id="monthlyChart"></canvas>
                    <div class="stats-info" id="monthly-stats"></div>
                </div>
            </div>
            
            <!-- 버튼 그룹 -->
            <div class="button-group" style="margin-top: 2rem;">
                <a href="${pageContext.request.contextPath}/listOrder.jsp" class="btn">주문 목록</a>
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn">메인으로</a>
            </div>
        </div>
        
        // Logic4. Chart Data 준비 (JavaScript)
        <script>
            // 차트 데이터 준비
            const dateStats = JSON.parse('<%= dateStatsJson.toString() %>');
            const weekStats = JSON.parse('<%= weekStatsJson.toString() %>');
            const monthStats = JSON.parse('<%= monthStatsJson.toString() %>');
            
            // 일별 차트 데이터 준비
            const dailyLabels = Object.keys(dateStats).reverse();
            const dailyOrderCounts = dailyLabels.map(date => dateStats[date].orderCount);
            const dailyRevenues = dailyLabels.map(date => dateStats[date].totalRevenue);
            
            // 주간 차트 데이터 준비
            const weeklyLabels = Object.keys(weekStats).reverse();
            const weeklyOrderCounts = weeklyLabels.map(week => weekStats[week].orderCount);
            const weeklyRevenues = weeklyLabels.map(week => weekStats[week].totalRevenue);
            
            // 월별 차트 데이터 준비
            const monthlyLabels = Object.keys(monthStats).reverse();
            const monthlyOrderCounts = monthlyLabels.map(month => monthStats[month].orderCount);
            const monthlyRevenues = monthlyLabels.map(month => monthStats[month].totalRevenue);
            
            // 일별 차트 생성
            const dailyCtx = document.getElementById('dailyChart').getContext('2d');
            const dailyChart = new Chart(dailyCtx, {
                type: 'line',
                data: {
                    labels: dailyLabels,
                    datasets: [{
                        label: '주문 건수',
                        data: dailyOrderCounts,
                        borderColor: '#A8D5E2',
                        backgroundColor: 'rgba(168, 213, 226, 0.3)',
                        yAxisID: 'y',
                        tension: 0.4,
                        borderWidth: 2
                    }, {
                        label: '매출액 (원)',
                        data: dailyRevenues,
                        borderColor: '#B8E0D2',
                        backgroundColor: 'rgba(184, 224, 210, 0.3)',
                        yAxisID: 'y1',
                        tension: 0.4,
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    interaction: {
                        mode: 'index',
                        intersect: false,
                    },
                    plugins: {
                        legend: {
                            position: 'top',
                            labels: {
                                color: '#333'
                            }
                        },
                        title: {
                            display: true,
                            text: '완료된 주문 일별 통계',
                            color: '#333'
                        },
                        tooltip: {
                            backgroundColor: 'rgba(255, 255, 255, 0.95)',
                            titleColor: '#333',
                            bodyColor: '#333',
                            borderColor: '#ddd',
                            borderWidth: 1,
                            callbacks: {
                                label: function(context) {
                                    let label = context.dataset.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    if (context.datasetIndex === 1) {
                                        label += new Intl.NumberFormat('ko-KR').format(context.parsed.y) + '원';
                                    } else {
                                        label += context.parsed.y + '건';
                                    }
                                    return label;
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            ticks: {
                                color: '#666'
                            },
                            grid: {
                                color: '#e0e0e0'
                            }
                        },
                        y: {
                            type: 'linear',
                            display: true,
                            position: 'left',
                            title: {
                                display: true,
                                text: '주문 건수',
                                color: '#333'
                            },
                            ticks: {
                                color: '#666'
                            },
                            grid: {
                                color: '#e0e0e0'
                            }
                        },
                        y1: {
                            type: 'linear',
                            display: true,
                            position: 'right',
                            title: {
                                display: true,
                                text: '매출액 (원)',
                                color: '#333'
                            },
                            grid: {
                                drawOnChartArea: false,
                            },
                            ticks: {
                                color: '#666',
                                callback: function(value) {
                                    return new Intl.NumberFormat('ko-KR').format(value) + '원';
                                }
                            }
                        }
                    }
                }
            });
            
            // 주간 차트 생성
            const weeklyCtx = document.getElementById('weeklyChart').getContext('2d');
            const weeklyChart = new Chart(weeklyCtx, {
                type: 'bar',
                data: {
                    labels: weeklyLabels,
                    datasets: [{
                        label: '주문 건수',
                        data: weeklyOrderCounts,
                        backgroundColor: 'rgba(168, 213, 226, 0.6)',
                        borderColor: '#A8D5E2',
                        borderWidth: 2,
                        yAxisID: 'y'
                    }, {
                        label: '매출액 (원)',
                        data: weeklyRevenues,
                        backgroundColor: 'rgba(184, 224, 210, 0.6)',
                        borderColor: '#B8E0D2',
                        borderWidth: 2,
                        yAxisID: 'y1'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    interaction: {
                        mode: 'index',
                        intersect: false,
                    },
                    plugins: {
                        legend: {
                            position: 'top',
                            labels: {
                                color: '#333'
                            }
                        },
                        title: {
                            display: true,
                            text: '완료된 주문 주간 통계',
                            color: '#333'
                        },
                        tooltip: {
                            backgroundColor: 'rgba(255, 255, 255, 0.95)',
                            titleColor: '#333',
                            bodyColor: '#333',
                            borderColor: '#ddd',
                            borderWidth: 1,
                            callbacks: {
                                label: function(context) {
                                    let label = context.dataset.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    if (context.datasetIndex === 1) {
                                        label += new Intl.NumberFormat('ko-KR').format(context.parsed.y) + '원';
                                    } else {
                                        label += context.parsed.y + '건';
                                    }
                                    return label;
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            ticks: {
                                color: '#666'
                            },
                            grid: {
                                color: '#e0e0e0'
                            }
                        },
                        y: {
                            type: 'linear',
                            display: true,
                            position: 'left',
                            title: {
                                display: true,
                                text: '주문 건수',
                                color: '#333'
                            },
                            ticks: {
                                color: '#666'
                            },
                            grid: {
                                color: '#e0e0e0'
                            }
                        },
                        y1: {
                            type: 'linear',
                            display: true,
                            position: 'right',
                            title: {
                                display: true,
                                text: '매출액 (원)',
                                color: '#333'
                            },
                            grid: {
                                drawOnChartArea: false,
                            },
                            ticks: {
                                color: '#666',
                                callback: function(value) {
                                    return new Intl.NumberFormat('ko-KR').format(value) + '원';
                                }
                            }
                        }
                    }
                }
            });
            
            // 월별 차트 생성
            const monthlyCtx = document.getElementById('monthlyChart').getContext('2d');
            const monthlyChart = new Chart(monthlyCtx, {
                type: 'bar',
                data: {
                    labels: monthlyLabels,
                    datasets: [{
                        label: '주문 건수',
                        data: monthlyOrderCounts,
                        backgroundColor: 'rgba(168, 213, 226, 0.6)',
                        borderColor: '#A8D5E2',
                        borderWidth: 2,
                        yAxisID: 'y'
                    }, {
                        label: '매출액 (원)',
                        data: monthlyRevenues,
                        backgroundColor: 'rgba(184, 224, 210, 0.6)',
                        borderColor: '#B8E0D2',
                        borderWidth: 2,
                        yAxisID: 'y1'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    interaction: {
                        mode: 'index',
                        intersect: false,
                    },
                    plugins: {
                        legend: {
                            position: 'top',
                            labels: {
                                color: '#333'
                            }
                        },
                        title: {
                            display: true,
                            text: '완료된 주문 월별 통계',
                            color: '#333'
                        },
                        tooltip: {
                            backgroundColor: 'rgba(255, 255, 255, 0.95)',
                            titleColor: '#333',
                            bodyColor: '#333',
                            borderColor: '#ddd',
                            borderWidth: 1,
                            callbacks: {
                                label: function(context) {
                                    let label = context.dataset.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    if (context.datasetIndex === 1) {
                                        label += new Intl.NumberFormat('ko-KR').format(context.parsed.y) + '원';
                                    } else {
                                        label += context.parsed.y + '건';
                                    }
                                    return label;
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            ticks: {
                                color: '#666'
                            },
                            grid: {
                                color: '#e0e0e0'
                            }
                        },
                        y: {
                            type: 'linear',
                            display: true,
                            position: 'left',
                            title: {
                                display: true,
                                text: '주문 건수',
                                color: '#333'
                            },
                            ticks: {
                                color: '#666'
                            },
                            grid: {
                                color: '#e0e0e0'
                            }
                        },
                        y1: {
                            type: 'linear',
                            display: true,
                            position: 'right',
                            title: {
                                display: true,
                                text: '매출액 (원)',
                                color: '#333'
                            },
                            grid: {
                                drawOnChartArea: false,
                            },
                            ticks: {
                                color: '#666',
                                callback: function(value) {
                                    return new Intl.NumberFormat('ko-KR').format(value) + '원';
                                }
                            }
                        }
                    }
                }
            });
            
            // 통계 정보 표시
            function updateStatsInfo(type) {
                let stats, statsElement, periodUnit, periodLabel;
                if (type === 'daily') {
                    stats = dateStats;
                    statsElement = document.getElementById('daily-stats');
                    periodUnit = '일';
                    periodLabel = '일일';
                } else if (type === 'weekly') {
                    stats = weekStats;
                    statsElement = document.getElementById('weekly-stats');
                    periodUnit = '주';
                    periodLabel = '주간';
                } else {
                    stats = monthStats;
                    statsElement = document.getElementById('monthly-stats');
                    periodUnit = '개월';
                    periodLabel = '월별';
                }
                
                const keys = Object.keys(stats);
                if (keys.length === 0) {
                    statsElement.innerHTML = '<p>표시할 데이터가 없습니다.</p>';
                    return;
                }
                
                let totalOrders = 0;
                let totalRevenue = 0;
                keys.forEach(key => {
                    totalOrders += stats[key].orderCount;
                    totalRevenue += stats[key].totalRevenue;
                });
                
                statsElement.innerHTML = 
                    '<p><strong>총 기간:</strong> ' + keys.length + periodUnit + '</p>' +
                    '<p><strong>총 주문 건수:</strong> ' + totalOrders.toLocaleString('ko-KR') + '건</p>' +
                    '<p><strong>총 매출액:</strong> ' + totalRevenue.toLocaleString('ko-KR') + '원</p>' +
                    '<p><strong>평균 ' + periodLabel + ' 주문 건수:</strong> ' + Math.round(totalOrders / keys.length).toLocaleString('ko-KR') + '건</p>' +
                    '<p><strong>평균 ' + periodLabel + ' 매출액:</strong> ' + Math.round(totalRevenue / keys.length).toLocaleString('ko-KR') + '원</p>';
            }
            
            updateStatsInfo('daily');
            updateStatsInfo('weekly');
            updateStatsInfo('monthly');
            
            // 초기 로드 시 첫 번째 차트에 애니메이션 적용
            const initialChart = document.getElementById('daily-chart');
            if (initialChart) {
                requestAnimationFrame(() => {
                    requestAnimationFrame(() => {
                        initialChart.classList.add('show');
                    });
                });
            }
            
            // 탭 전환 함수
            function showChart(type) {

                // 모든 탭과 차트 숨기기
                document.querySelectorAll('.chart-tab').forEach(tab => {
                    tab.classList.remove('active');
                });
                document.querySelectorAll('.chart-wrapper').forEach(wrapper => {
                    wrapper.classList.remove('active', 'show');
                });
                
                // 선택된 탭과 차트 표시
                let targetChart;
                if (type === 'daily') {
                    document.querySelector('.chart-tab:nth-child(1)').classList.add('active');
                    targetChart = document.getElementById('daily-chart');
                } 
                
                else if (type === 'weekly') {
                    document.querySelector('.chart-tab:nth-child(2)').classList.add('active');
                    targetChart = document.getElementById('weekly-chart');
                } 
                
                else {
                    document.querySelector('.chart-tab:nth-child(3)').classList.add('active');
                    targetChart = document.getElementById('monthly-chart');
                }
                
                // display를 먼저 block으로 설정한 후 애니메이션 적용
                targetChart.classList.add('active');
                // 다음 프레임에서 애니메이션 시작
                requestAnimationFrame(() => {
                    requestAnimationFrame(() => {
                        targetChart.classList.add('show');
                    });
                });
            }
        </script>
    </main>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>

