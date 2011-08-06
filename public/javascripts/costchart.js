
(function() {

    var pageWidth = 950,
	panelMargin = 60,
	panelWidth = pageWidth - 2 * panelMargin,
	panelHeight = 300,
	yMaxData = pv.max(cost_chart_data.subgroupavgs),
	yMax = pv.max([yMaxData, cost_chart_data.xbarucl]) + 1,
	yMinData = pv.min(cost_chart_data.subgroupavgs),
	yMin = pv.min([yMinData, cost_chart_data.xbarlcl])
	fnYScale = pv.Scale.log(yMin, yMax).base(2.7183).nice().range(0, panelHeight),
	fnXScale = pv.Scale.linear(0, cost_chart_data.subgroupavgs.length - 1).range(0, panelWidth);

    var pnl = new pv.Panel()
	.canvas("cost_chart")
	.width(panelWidth)
	.height(panelHeight)
	.left(panelMargin).right(panelMargin).bottom(panelMargin + 10).top(5)
	.strokeStyle("#CCC");

    // add dots
    pnl.add(pv.Dot)
	.data(cost_chart_data.subgroupavgs)
	.left(function() {return fnXScale(this.index)})
	.bottom(fnYScale)
	.strokeStyle("#1142AA");

    // add vertical rules / x axis labels
    pnl.add(pv.Rule)
	.data(fnXScale.ticks())
	.strokeStyle("#eee")
	.left(fnXScale)

	// add horizontal rules / y axis labels
	pnl.add(pv.Rule)
	.data(fnYScale.ticks())
	.strokeStyle("#eee")
	.bottom(fnYScale)
	.anchor("left").add(pv.Label)
	.text(fnYScale.tickFormat);

    // add y axis label		
    pnl.anchor("left").add(pv.Label)
	.text("Cost (hours)")
	.textAlign("center")
	.textAngle(-Math.PI/2)
	.textMargin(30)
	.textBaseline("bottom")
	.font("12px sans-serif")

	// add right hand side y axis labels		
	var hrule = pnl.add(pv.Rule)
	.data(function() {
		if (cost_chart_data.xbarlcl != 0) {
		    return [[cost_chart_data.xbarlcl, "lcl"], [cost_chart_data.xbarbar, "avg"], [cost_chart_data.xbarucl, "ucl"]]
		} else {
		    return [[cost_chart_data.xbarbar, "avg"], [cost_chart_data.xbarucl, "ucl"]]
		}
	    }())
	.bottom(function(d) {return fnYScale(d[0])})
	.strokeStyle("#FFA900")
	.anchor("right").add(pv.Label)
        .text(function(d) {return d[1]})
        .textAlign("left")
        .textBaseline("middle")
	.textMargin(5);

    pnl.render();

}());