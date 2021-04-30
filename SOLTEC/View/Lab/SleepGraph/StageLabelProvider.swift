//
//  StageLabelProvider.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 3/25/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation
import SciChart.Protected.SCILabelProviderBase

class StageLabelProvider: SCILabelProviderBase<SCINumericAxis> {

    init() {
        super.init(axisType: ISCINumericAxis.self)
    }

    override func formatLabel(_ dataValue: ISCIComparable) -> ISCIString {
        guard let value = dataValue as? Int else { return NSString("?") }
        return NSString(string: SleepStageType.type(forLevel: value).shortName)
    }

    override func formatCursorLabel(_ dataValue: ISCIComparable) -> ISCIString {
        return formatLabel(dataValue)
    }
}

extension SCIAxisBase {
    @objc func setTicksAndLabels(visible: Bool) {
//        drawMajorGridLines = true
//        drawMinorGridLines = true
        drawMajorTicks = visible
        drawMinorTicks = visible
        drawLabels = visible
    }
}
