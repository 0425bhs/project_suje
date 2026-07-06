document.addEventListener("DOMContentLoaded", function () {
    const rankBars = document.querySelectorAll(".rank-bar");

    rankBars.forEach(function (bar) {
        const width = bar.dataset.width || 0;
        bar.style.width = width + "%";
    });

    if (typeof Chart === "undefined") {
        return;
    }

    const dailyChartCanvas = document.getElementById("dailySalesChart");

    if (dailyChartCanvas) {
        const labels = window.dailySalesLabels || [];
        const data = window.dailySalesData || [];

        const ctx = dailyChartCanvas.getContext("2d");

        new Chart(ctx, {
            type: "line",
            data: {
                labels: labels,
                datasets: [
                    {
                        label: "매출",
                        data: data,
                        borderColor: "#ff6f4f",
                        backgroundColor: "rgba(255, 111, 79, 0.12)",
                        pointBackgroundColor: "#ff6f4f",
                        pointBorderColor: "#ffffff",
                        pointBorderWidth: 3,
                        pointRadius: 5,
                        pointHoverRadius: 7,
                        borderWidth: 3,
                        tension: 0.35,
                        fill: true
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,

                plugins: {
                    legend: {
                        display: true,
                        labels: {
                            color: "#555",
                            font: {
                                size: 13,
                                weight: "bold"
                            }
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                return "매출: " + context.raw.toLocaleString() + "원";
                            }
                        }
                    }
                },

                scales: {
                    x: {
                        grid: {
                            color: "#f1f1f1"
                        },
                        ticks: {
                            color: "#777",
                            font: {
                                size: 12,
                                weight: "bold"
                            }
                        }
                    },
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: "#eeeeee"
                        },
                        ticks: {
                            color: "#777",
                            font: {
                                size: 12,
                                weight: "bold"
                            },
                            callback: function (value) {
                                return value.toLocaleString();
                            }
                        }
                    }
                }
            }
        });
    }

    const categoryChartCanvas = document.getElementById("categorySalesChart");

    if (categoryChartCanvas) {
        const categoryLabels = window.categorySalesLabels || [];
        const categoryData = window.categorySalesData || [];

        const categoryCtx = categoryChartCanvas.getContext("2d");

        new Chart(categoryCtx, {
            type: "doughnut",
            data: {
                labels: categoryLabels,
                datasets: [
                    {
                        data: categoryData,
                        backgroundColor: [
                            "#ff6f4f",
                            "#ff9a76",
                            "#ffc2ad",
                            "#ffd8cc",
                            "#ffece6",
                            "#ffb085",
                            "#f28b68"
                        ],
                        borderColor: "#ffffff",
                        borderWidth: 3
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: "62%",

                plugins: {
                    legend: {
                        position: "bottom",
                        labels: {
                            color: "#555",
                            font: {
                                size: 13,
                                weight: "bold"
                            }
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                return context.label + ": " + context.raw.toLocaleString() + "원";
                            }
                        }
                    }
                }
            }
        });
    }
});