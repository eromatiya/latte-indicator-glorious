import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.plasmoid 2.0

import org.kde.latte.components 1.0 as LatteComponents

ColumnLayout {
	Layout.fillWidth: true

	LatteComponents.SubHeader {
		text: i18n("Colors Style")
	}

	ColumnLayout {

		spacing: 0

		RowLayout {

			Layout.fillWidth: true
			spacing: 2

			readonly property int colorStyle: indicator.configuration.colorStyle
			readonly property int buttonCount: 2
			readonly property int buttonSize: (dialog.optionsWidth - (spacing * buttonCount - 1)) / buttonCount

			ButtonGroup {
				id: colorStyleGroup
			}

			function updateColorStyleConfig(style) {
				indicator.configuration.colorStyle = style
			}

			PlasmaComponents3.Button {
				Layout.minimumWidth: parent.buttonSize
				Layout.maximumWidth: Layout.minimumWidth

				// Simple (theme.textColor)
				readonly property int colorStyle: 0

				text: i18nc("Simple Colorscheme", "Simple")
				checked: parent.colorStyle === colorStyle
				checkable: false
				ToolTip.text: i18n("Use simple color for background")
				ToolTip.visible: hovered
				ToolTip.delay: 1000
				ButtonGroup.group: colorStyleGroup

				onPressedChanged: {
					if (pressed) {
						parent.updateColorStyleConfig(colorStyle)
					}
				}
			}

			PlasmaComponents3.Button {
				Layout.minimumWidth: parent.buttonSize
				Layout.maximumWidth: Layout.minimumWidth

				// Vibrant (icon colors)
				readonly property int colorStyle: 1

				text: i18nc("Colorful Colorscheme", "Colorful")
				checked: parent.colorStyle === colorStyle
				checkable: false
				ToolTip.text: i18n("Use icon colors for background")
				ToolTip.visible: hovered
				ToolTip.delay: 1000
				ButtonGroup.group: colorStyleGroup

				onPressedChanged: {
					if (pressed) {
						parent.updateColorStyleConfig(colorStyle)
					}
				}
			}
		}
	}

	LatteComponents.SubHeader {
		text: i18n("Background Indicator")
	}

	ColumnLayout {
	
		spacing: 0

		// Background Opacity
		RowLayout {
			
			Layout.fillWidth: true
			spacing: units.smallSpacing

			PlasmaComponents3.Label {
				horizontalAlignment: Text.AlignLeft
				text: i18n("Opacity")
			}

			LatteComponents.Slider {
				id: opacitySlider
				Layout.fillWidth: true

				leftPadding: 0
				value: indicator.configuration.opacity * 100
				from: 30
				to: 100
				stepSize: 5
				wheelEnabled: false

				function updateOpacity() {
					if (!pressed) {
						indicator.configuration.opacity = value / 100;
					}
				}

				onPressedChanged: {
					updateOpacity();
				}

				Component.onCompleted: {
					valueChanged.connect(updateOpacity);
				}

				Component.onDestruction: {
					valueChanged.disconnect(updateOpacity);
				}
			}

			PlasmaComponents3.Label {
				text: i18nc("number in percentage, e.g. 25 %", "%0 %").arg(opacitySlider.value)
				horizontalAlignment: Text.AlignRight
				Layout.minimumWidth: theme.mSize(theme.defaultFont).width * 4
				Layout.maximumWidth: theme.mSize(theme.defaultFont).width * 4
			}
		}

		LatteComponents.CheckBoxesColumn {

			Layout.topMargin: 7
			Layout.fillWidth: true

			LatteComponents.CheckBox {
				Layout.maximumWidth: dialog.optionsWidth
				text: i18n("Show for minimized windows")
				checked: indicator.configuration.colorsForMinimized
				visible: indicator.latteTasksArePresent

				onClicked: {
					indicator.configuration.colorsForMinimized = !indicator.configuration.colorsForMinimized;
				}
			}

			LatteComponents.CheckBox {
				Layout.maximumWidth: dialog.optionsWidth
				text: i18n("Show for all square applets")
				checked: indicator.configuration.colorsForSquareApplets
				visible: indicator.configuration.enabledForApplets

				onClicked: {
					indicator.configuration.colorsForSquareApplets = !indicator.configuration.colorsForSquareApplets;
				}
			}
		}
	}

	LatteComponents.SubHeader {
		text: i18n("Shape Indicator")
	}

	LatteComponents.CheckBoxesColumn {

		LatteComponents.CheckBox {
			Layout.maximumWidth: dialog.optionsWidth
			text: i18n("Show indicator")
			checked: indicator.configuration.showShapeIndicator

			onClicked: {
				indicator.configuration.showShapeIndicator = !indicator.configuration.showShapeIndicator;
			}
		}

		LatteComponents.CheckBox {
			Layout.maximumWidth: dialog.optionsWidth
			text: i18n("Reverse indicator position")
			checked: indicator.configuration.reversed
			visible: indicator.configuration.showShapeIndicator

			onClicked: {
				indicator.configuration.reversed = !indicator.configuration.reversed;
			}
		}
		
		LatteComponents.CheckBox {
			Layout.maximumWidth: dialog.optionsWidth
			text: i18n("Place indicator at foreground above item icon")
			checked: indicator.configuration.shapesAtForeground
			visible: indicator.configuration.showShapeIndicator

			onClicked: {
				indicator.configuration.shapesAtForeground = !indicator.configuration.shapesAtForeground;
			}
		}
	}

	LatteComponents.SubHeader {
		text: i18n("Padding")
	}

	ColumnLayout {

		spacing: 0

		// Padding
		RowLayout {

			Layout.fillWidth: true
			spacing: units.smallSpacing

			PlasmaComponents3.Label {
				text: i18n("Length")
				horizontalAlignment: Text.AlignLeft
			}

			LatteComponents.Slider {
				id: lengthIntMarginSlider
				Layout.fillWidth: true

				value: Math.round(indicator.configuration.lengthPadding * 100)
				from: 5
				to: maxMargin
				stepSize: 1
				wheelEnabled: false

				readonly property int maxMargin: 80

				onPressedChanged: {
					if (!pressed) {
						indicator.configuration.lengthPadding = value / 100;
					}
				}
			}

			PlasmaComponents3.Label {
				text: i18nc("number in percentage, e.g. 85 %", "%0 %").arg(currentValue)
				horizontalAlignment: Text.AlignRight
				Layout.minimumWidth: theme.mSize(theme.defaultFont).width * 4
				Layout.maximumWidth: theme.mSize(theme.defaultFont).width * 4

				readonly property int currentValue: lengthIntMarginSlider.value
			}
		}
	}

	LatteComponents.SubHeader {
		text: i18n("Options")
	}

	LatteComponents.CheckBoxesColumn {

		LatteComponents.CheckBox {
			Layout.maximumWidth: dialog.optionsWidth
			text: i18n("Show indicators for applets")
			checked: indicator.configuration.enabledForApplets
			tooltip: i18n("Indicators are shown for applets")

			onClicked: {
				indicator.configuration.enabledForApplets = !indicator.configuration.enabledForApplets
			}
		}
	}
}
