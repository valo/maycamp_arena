// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//= require jquery
//= require jquery_ujs
//= require highcharts
//= require codemirror
//= require bootstrap-sprockets
//= require js.cookie
//= require_tree ./main

$(function () {
  $('[data-toggle="tooltip"]').tooltip();

  if (gon.daily_submits_report) {
    $('#daily_submits_report').highcharts({
      chart: {
        defaultSeriesType: 'line',
        marginRight: 0,
        marginBottom: 40
      },
      title: {
        text: 'Брой събмити на ден - последните 3 седмици',
        x: -20 //center
      },
      yAxis: {
        title: "",
        min: 0
      },
      xAxis: {
        type: 'datetime'
      },
      legend: {
        enabled: false
      },
      series: [{
        name: 'Submits',
        data: $.map(gon.daily_submits_report, function (ele, index) { return [[Date.parse(ele[0]), ele[1]]]; }),
      }]
    });
  }

  if (gon.total_submits_report) {
    $('#total_submits_report').highcharts({
      chart: {
        marginRight: 0,
        marginBottom: 40
      },
      title: {
        text: 'Брой събмити на ден - от регистрацията насам',
        x: -20 //center
      },
      yAxis: {
        title: "",
        min: 0,
        startOnTick: false,
        showFirstLabel: false
      },
      xAxis: {
        type: 'datetime'
      },
      legend: {
        enabled: false
      },
      plotOptions: {
        area: {
          lineWidth: 1,
          marker: {
            enabled: false,
            states: {
              hover: {
                enabled: true,
                radius: 5
              }
            }
          }
        }
      },
      series: [{
        name: 'Submits',
        data: $.map(gon.total_submits_report, function (ele, index) { return [[Date.parse(ele[0]), ele[1]]]; }),
        type: "area"
      }]
    });
  }

  if (gon.contest_submit_report) {
    $('#contest_submit_report').highcharts({
      chart: {
        renderTo: 'contest_submit_report',
        defaultSeriesType: 'column',
        marginRight: 0,
        marginBottom: 150
      },
      title: {
        text: 'Пратени решения по състезания',
        x: -20 //center
      },
      yAxis: {
        title: "",
        min: 0
      },
      xAxis: {
        categories: $.map(gon.contest_submit_report, function (ele, index) { return ele[0]; }),
        labels: {
          rotation: 45,
          align: "left"
        }
      },
      subtitle: {
        text: 'Брой събмити по състезания',
        x: -20
      },
      legend: {
        enabled: false
      },
      series: [{
        name: "aaa",
        data: $.map(gon.contest_submit_report, function (ele, index) { return ele[1]; })
      }]
    });
  }

  // CodeMirror
  if (document.getElementById("run_source_code")) {
    CodeMirror.fromTextArea(document.getElementById("run_source_code"), {
      lineNumbers: true
    });
  }
});
