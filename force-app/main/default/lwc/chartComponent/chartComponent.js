import { LightningElement, api } from 'lwc';

export default class ChartComponent extends LightningElement {
    @api chartData;
    chart;

    renderedCallback() {
        if (!this.chart && this.chartData.length > 0) {
            this.loadChart();
        }
    }

    async loadChart() {
        if (!window.Chart) {
            let script = document.createElement('script');
            script.src = 'https://cdn.jsdelivr.net/npm/chart.js';
            script.onload = () => this.renderChart();
            document.head.appendChild(script);
        } else {
            this.renderChart();
        }
    }

    renderChart() {
        const ctx = this.template.querySelector('canvas').getContext('2d');

        this.chart = new window.Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: this.chartData.map(data => data.label),
                datasets: [{
                    data: this.chartData.map(data => data.value),
                    backgroundColor: ['#4CAF50', '#FF9800', '#F44336', '#2196F3'],
                    hoverOffset: 10
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: true,
                        position: 'bottom'
                    },
                    tooltip: {
                        enabled: true
                    }
                },
                animation: {
                    animateScale: true
                }
            }
        });
    }
}