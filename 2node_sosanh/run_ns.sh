#!/bin/sh
ns 2node_SMAC.tcl > trace1
perl Latency.pl MyTest.tr 0 1
