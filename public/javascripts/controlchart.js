
(function() {

    var pageWidth = 950,
	panelMargin = 60,
	panelWidth = pageWidth - 2 * panelMargin,
	panelHeight = 300,
	yMaxData = pv.max(xbardata.subgroupavgs),
	yMax = pv.max([yMaxData, xbardata.xbarucl]) + 1,
	fnYScale = pv.Scale.linear(0, yMax).range(0, panelHeight),
	fnXScale = pv.Scale.linear(0, xbardata.subgroupavgs.length - 1).range(0, panelWidth);

    var pnl = new pv.Panel()
	.canvas("xbar")
	.width(panelWidth)
	.height(panelHeight)
	.left(panelMargin).right(panelMargin).bottom(panelMargin + 10).top(5)
	.strokeStyle("#CCC");

    // add dots
    pnl.add(pv.Dot)
	.data(xbardata.subgroupavgs)
	.left(function() {return fnXScale(this.index)})
	.bottom(fnYScale)
	.strokeStyle("#1142AA");

    // add vertical rules / x axis labels
    pnl.add(pv.Rule)
	.data(fnXScale.ticks())
	.strokeStyle("#eee")
	.left(fnXScale)
	.anchor("bottom").add(pv.Label)
	.text(function(d) {
		if (this.index % 2 == 0) {
		    return xbardata.labels[d];
		}
	    })
	.textAngle(Math.PI/2.3)
	.textAlign("left")
	.textBaseline("center")
	.textMargin(5);

    // add horizontal rules / y axis labels
    pnl.add(pv.Rule)
	.data(fnYScale.ticks())
	.strokeStyle("#eee")
	.bottom(fnYScale)
	.anchor("left").add(pv.Label)
	.text(fnYScale.tickFormat);

    // add y axis label		
    pnl.anchor("left").add(pv.Label)
	.text("Deliveries per Day")
	.textAlign("center")
	.textAngle(-Math.PI/2)
	.textMargin(30)
	.textBaseline("bottom")
	.font("12px sans-serif")

	// add right hand side y axis labels		
	var hrule = pnl.add(pv.Rule)
	.data(function() {
		if (xbardata.xbarlcl != 0) {
		    return [[xbardata.xbarlcl, "lcl"], [xbardata.xbarbar, "avg"], [xbardata.xbarucl, "ucl"]]
		} else {
		    return [[xbardata.xbarbar, "avg"], [xbardata.xbarucl, "ucl"]]
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