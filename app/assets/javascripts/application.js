// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//= require jquery
//= require jquery_ujs
//= require highcharts

$(function() {
  if (typeof(daily_submits_report) != "undefined")
  new Highcharts.Chart({
     chart: {
        renderTo: 'daily_submits_report',
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
        data: $.map(daily_submits_report, function(ele, index) { return [[Date.parse(ele[0]), ele[1]]];}),
     }]
  });

  if (typeof(total_submits_report) != "undefined")
  new Highcharts.Chart({
     chart: {
        renderTo: 'total_submits_report',
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
        data: $.map(total_submits_report, function(ele, index) { return [[Date.parse(ele[0]), ele[1]]];}),
        type: "area"
     }]
  });
  if (typeof(contest_submit_report) != "undefined")
  new Highcharts.Chart({
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
       categories: $.map(contest_submit_report, function(ele, index) {return ele[0];}),
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
       data: $.map(contest_submit_report, function(ele, index) {return ele[1];})
     }]
  });
  if (typeof(rating_report) != "undefined")
  new Highcharts.Chart({
     chart: {
        renderTo: 'rating_report',
        defaultSeriesType: 'line',
        marginRight: 0,
        marginBottom: 40
     },
     title: {
        text: 'Рейтинг',
        x: -20 //center
     },
     yAxis: {
       plotBands: [{
         color: "#CCCCCC",
         from: 0,
         to: 900
       },{
         color: "#00FF00",
         from: 900,
         to: 1200
       },{
         color: "#0000FF",
         from: 1200,
         to: 1500
       },{
         color: "#CBDD00",
         from: 1500,
         to: 2000
       },{
         color: "#FF0000",
         from: 2000,
         to: 2500
       }],
       title: ""
     },
     xAxis: {
       type: "datetime"
     },
     plotOptions: {
       series: {
         cursor: "pointer",
         point: {
           events: {
             click: function() {
               location.href = this.options.url;
             }
           }
         }
       }
     },
     subtitle: {
        text: 'Промяна на рейтингна след всяко състезание',
        x: -20
     },
     legend: {
       enabled: false
     },
     series: [{
       name: "Rating",
       data: $.map(rating_report, function(ele, index) { ele["x"] = Date.parse(ele["x"]);return ele;})
     }]
  });
});
