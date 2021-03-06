import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtCharts 2.1

import QClipboard 1.0
import BandwidthChartData 1.0
import "."

Container {
    property var down: 0
    property var up: 0

    property var lastCategoryLabel: null

    BandwidthChartData {
        id: chartData
    }

    onUpChanged: function() {
        // console.log("new 'up' value: "+ up);
        chartData.addUploadSample(up);
        chartData.updateUploadSeries(txData.upperSeries);
    }

    onDownChanged: function() {
        // console.log("new 'down' value: "+ down);
        chartData.addDownloadSample(down);
        chartData.updateDownloadSeries(rxData.upperSeries);
        recalculateGraphScale(chartData.getHighestSample());
    }

    Layout.preferredHeight: 177
    Layout.preferredWidth: Style.appWidth

    contentItem: Rectangle {
        color: Style.panelBackgroundColor
    }

    function recalculateGraphScale(highestSample) {
        yAxis.max = highestSample;
        const label = makeRate(highestSample);

        // if we need a new label, remove and re-add. ughly hack.
        // essentially, we use a single CategoryAxis category because this lets us position
        // a tick interval at a specific location with a specific label.
        // ValueAxis has no way of doing this.
        if (! lastCategoryLabel) {
            yAxis.append(label, highestSample);
            lastCategoryLabel = label;
        } else if (lastCategoryLabel != label) {
            yAxis.remove(lastCategoryLabel);
            yAxis.append(label, highestSample);
            lastCategoryLabel = label;
        }
    }

    function makeRate(value)
    {
      var unit_idx = 0;
      var units = ["B", "KB", "MB"];
      while(value > 1024.0 && ( unit_idx + 1 ) < units.length)
      {
        value /= 1024.0;
        unit_idx += 1;
      }
      return "" + (
        value < 10 ? Math.round(value * 100) / 100 :
        value < 100 ? Math.round(value * 10) / 10 :
        Math.round(value)) + " " + units[unit_idx] + "/s";
    }

    Text {
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        y: 3
        text: "Upload"
        font.family: Style.weakTextFont
        color: Style.weakTextColor
        font.pointSize: Style.weakTextSize
        font.capitalization: Font.AllUppercase
    }
    Text {
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        y: 22
        text: ""+ makeRate(up)
        font.family: Style.weakTextFont
        color: Style.strongTextColor
        font.pointSize: Style.weakTextSize
        z: 1
    }

    Text {
        anchors.left: parent.left
        anchors.leftMargin: 170
        anchors.right: parent.right
        anchors.rightMargin: 20
        text: "Download"
        y: 3
        font.family: Style.weakTextFont
        color: Style.weakTextColor
        font.pointSize: Style.weakTextSize
        font.capitalization: Font.AllUppercase
    }
    Text {
        anchors.left: parent.left
        anchors.leftMargin: 170
        anchors.right: parent.right
        anchors.rightMargin: 20
        y: 22
        text: ""+ makeRate(down)
        font.family: Style.weakTextFont
        color: Style.strongTextColor
        font.pointSize: Style.weakTextSize
        z: 1
    }

  /*
    Text {
        x: 20
        y: 54
        text: makeRate(down)
        font.family: Style.weakTextFont
        color: Style.strongTextColor
        font.pointSize: Style.weakTextSize
    }

    // Upload
    Text {
        x: 150
        y: 32
        text: "Upload"
        font.family: Style.strongTextFont
        color: Style.strongTextColor
        font.pointSize: Style.strongTextSize
    }
    Text {
        x: 150
        y: 54
        text: makeRate(up)
        font.family: Style.weakTextFont
        color: Style.strongTextColor
        font.pointSize: Style.weakTextSize
    }
  */

    ChartView {
        id: chart
        title: ""
        // anchors.fill:  parent
        // anchors.margins: 0
        antialiasing: true
        backgroundColor: Style.panelBackgroundColor
        theme: ChartView.ChartThemeDark

        legend.visible: false

        // these weird numbers come from an attempt to work around ChartView's
        // nasty permanent margins
        x: -20
        y: 25
        width: Style.appWidth + 75
        height: 189

        ValueAxis {
            id: xAxis
            labelFormat: "%e"
            min: 0
            max: 128
            labelsVisible: false
            gridVisible: false
            titleVisible: false
        }

        CategoryAxis {
            id: yAxis
            min: 0
            max: 10000
            labelsPosition: CategoryAxis.AxisLabelsPositionOnValue
        }

        AreaSeries {
            id: "txData"
            axisX: xAxis
            axisY: yAxis
            opacity: 0.8
            upperSeries: LineSeries {}

        }

        AreaSeries {
            id: "rxData"
            axisX: xAxis
            axisY: yAxis
            opacity: 0.8
            upperSeries: LineSeries {}
        }
    }
}

