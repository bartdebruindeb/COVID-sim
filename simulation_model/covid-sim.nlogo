extensions [profiler table]
__includes ["setup.nls" "people_management.nls" "global_metrics.nls" "environment_dynamics.nls" "animation.nls" "behaviourspace.nls" "utils/all_utils.nls"]
breed [people person]

globals [
  slice-of-the-day
  day-of-the-week
  is-lockdown-active?
  current-day
  #dead-people
  #dead-retired
  away-gathering-point
  #who-became-sick-while-travelling-locally
  import-scenario-name
]

to go

  reset-timer
  reset-metrics
  reset-economy-measurements
  spread-contagion
  update-within-agent-disease-status
  update-people-mind

  perform-people-activities
  run-economic-cycle
  update-display
  increment-time
  apply-active-measures
  update-metrics

  ; Tick goes at the end of the go procedure for better plot updating
  tick
end

to go-profile
  profiler:reset
  profiler:start

  repeat 10 [go]
  export-profiling
end

to startup
  setup
end

to-report epistemic-accuracy if #infected = 0 [report 1] report count people with [is-infected? and is-believing-to-be-infected?] / #infected end

to-report epistemic-false-positive-error-ratio report count people with [is-believing-to-be-infected? and not is-infected?] / count people end

to-report epistemic-error-of-ignored-immunity-ratio report count people with [not is-believing-to-be-immune? and not is-immune?] / count people end
@#$#@#$#@
GRAPHICS-WINDOW
115
59
522
467
-1
-1
7.824
1
10
1
1
1
0
0
0
1
0
50
0
50
1
1
1
ticks
30.0

BUTTON
12
88
101
123
setup
setup
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
13
129
105
165
go
go\nif not any? people with [is-contagious?]\n[stop]
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
1577
23
1771
56
propagation-risk
propagation-risk
0
1
0.4
0.01
1
NIL
HORIZONTAL

PLOT
10
515
518
671
population status
time
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"Uninfected" 1.0 0 -11085214 true "" "plot count people with [infection-status = \"healthy\"]"
"Dead" 1.0 0 -10873583 true "" "plot #dead-people"
"Immune" 1.0 0 -11033397 true "" "plot count people with [infection-status = \"immune\"]"
"Infected" 1.0 0 -2674135 true "" "plot count people with [is-infected?]"
"EInfected" 1.0 0 -1604481 true "" "plot count people with [epistemic-infection-status = \"infected\"]"
"EImmune" 1.0 0 -5516827 true "" "plot count people with [is-believing-to-be-immune?]"
"Inf. Retired" 1.0 0 -10141563 true "" "plot count people with [age = \"retired\" and infection-status = \"infected\"]"
"Healthy" 1.0 0 -12087248 true "" "plot count people with [infection-status = \"healthy\" or infection-status = \"immune\"]"

TEXTBOX
559
699
709
717
Proxemics model
14
125.0
1

INPUTBOX
833
795
922
855
#schools-gp
12.0
1
0
Number

INPUTBOX
919
795
1012
855
#universities-gp
40.0
1
0
Number

INPUTBOX
1012
795
1105
855
#workplaces-gp
40.0
1
0
Number

TEXTBOX
743
769
1496
789
Number of units per activity type (sharing a unit incurs a transmission risk: due to contact)
11
125.0
1

INPUTBOX
1103
795
1218
855
#public-leisure-gp
4.0
1
0
Number

INPUTBOX
1219
795
1337
855
#private-leisure-gp
40.0
1
0
Number

TEXTBOX
559
726
1508
769
Proxemics is represented as \"meeting spaces\" people can move into and be infected or spread infection.\nAs simplifications: each person relates to a fix set of spaces over time (same school, bus, bar) and gets in contact with everyone sharing this space; no contamination due to left germs.
10
125.0
1

TEXTBOX
682
476
832
494
Age model
11
53.0
1

SLIDER
832
859
924
892
density-factor-schools
density-factor-schools
0
1
1.0
0.01
1
NIL
HORIZONTAL

SLIDER
922
859
1014
892
density-factor-universities
density-factor-universities
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
1013
859
1105
892
density-factor-workplaces
density-factor-workplaces
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
1109
859
1221
892
density-factor-public-leisure
density-factor-public-leisure
0
1
0.05
0.01
1
NIL
HORIZONTAL

SLIDER
1223
860
1338
893
density-factor-private-leisure
density-factor-private-leisure
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
556
858
731
891
density-factor-homes
density-factor-homes
0
1
1.0
0.01
1
NIL
HORIZONTAL

TEXTBOX
1845
785
2153
831
Measures (Interventions) Model
16
105.0
1

CHOOSER
2473
985
2688
1030
global-confinement-measures
global-confinement-measures
"none" "total-lockdown" "lockdown-10-5"
0

PLOT
10
681
518
831
measures
NIL
NIL
0.0
1.0
0.0
1.0
true
true
"" ""
PENS
"lockdown" 1.0 0 -2674135 true "" "plot ifelse-value is-lockdown-active? [1] [0]"
"@home" 1.0 0 -7500403 true "" "plot count people with [is-at-home?] / count people"
"watched-kids" 1.0 0 -955883 true "" "plot count children with [is-currently-watched-by-an-adult?] / count children"
"workersWorking@work" 1.0 0 -6459832 true "" "plot count workers with [is-working-at-work?] / count workers"
"working@home" 1.0 0 -1184463 true "" "plot count workers with [is-working-at-home?] / count workers"
"kids@home" 1.0 0 -10899396 true "" "plot count children with [is-at-home?] / count children"

MONITOR
928
992
1046
1037
NIL
day-of-the-week
17
1
11

MONITOR
1046
992
1162
1037
NIL
slice-of-the-day
17
1
11

INPUTBOX
1335
795
1454
855
#essential-shops-gp
20.0
1
0
Number

SLIDER
1340
860
1459
893
density-factor-essential-shops
density-factor-essential-shops
0
1
0.3
0.01
1
NIL
HORIZONTAL

SLIDER
1460
860
1585
893
density-factor-non-essential-shops
density-factor-non-essential-shops
0
1
0.6
0.01
1
NIL
HORIZONTAL

INPUTBOX
1453
795
1582
855
#non-essential-shops-gp
40.0
1
0
Number

INPUTBOX
739
795
835
855
#hospital-gp
4.0
1
0
Number

SLIDER
739
859
834
892
density-factor-hospital
density-factor-hospital
0
1
0.8
0.01
1
NIL
HORIZONTAL

SLIDER
936
495
1186
528
probability-hospital-personel
probability-hospital-personel
0
1
0.03
0.01
1
NIL
HORIZONTAL

SLIDER
941
532
1190
565
probability-school-personel
probability-school-personel
0
1
0.03
0.01
1
NIL
HORIZONTAL

SLIDER
938
568
1186
601
probability-university-personel
probability-university-personel
0
1
0.04
0.01
1
NIL
HORIZONTAL

SLIDER
941
605
1186
638
probability-shopkeeper
probability-shopkeeper
0
1
0.04
0.01
1
NIL
HORIZONTAL

SWITCH
1957
1084
2227
1117
closed-workplaces?
closed-workplaces?
1
1
-1000

SWITCH
2235
983
2457
1016
closed-universities?
closed-universities?
1
1
-1000

SWITCH
547
47
658
80
animate?
animate?
1
1
-1000

MONITOR
559
988
651
1033
NIL
#dead-people
17
1
11

MONITOR
662
991
754
1036
NIL
#dead-retired
17
1
11

BUTTON
10
206
105
241
1 Week Run
go\nwhile [day-of-the-week != \"monday\" or slice-of-the-day != \"morning\"] [go]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
552
189
655
222
log?
log?
0
1
-1000

TEXTBOX
1254
32
1421
59
Disease Model
14
15.0
1

TEXTBOX
1233
70
1527
103
Time between transitions
11
15.0
1

INPUTBOX
1199
92
1442
152
infection-to-asymptomatic-contagiousness
8.0
1
0
Number

INPUTBOX
1447
93
1784
153
asympomatic-contagiousness-to-symptomatic-contagiousness
16.0
1
0
Number

INPUTBOX
1787
92
1974
152
symptomatic-to-critical-or-heal
7.0
1
0
Number

INPUTBOX
1982
93
2094
153
critical-to-terminal
2.0
1
0
Number

INPUTBOX
2104
92
2223
152
terminal-to-death
7.0
1
0
Number

SLIDER
2008
199
2253
232
probability-unavoidable-death
probability-unavoidable-death
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
1378
159
1643
192
probability-self-recovery-symptoms
probability-self-recovery-symptoms
0
1
0.6
0.01
1
NIL
HORIZONTAL

SLIDER
1735
200
2004
233
probability-recorvery-if-treated
probability-recorvery-if-treated
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
1377
202
1730
235
probability-self-recovery-symptoms-old
probability-self-recovery-symptoms-old
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
1735
238
2008
271
probability-recorvery-if-treated-old
probability-recorvery-if-treated-old
0
1
0.6
0.01
1
NIL
HORIZONTAL

SLIDER
2012
238
2275
271
probability-unavoidable-death-old
probability-unavoidable-death-old
0
1
0.2
0.01
1
NIL
HORIZONTAL

TEXTBOX
1658
162
2130
219
Probabilities of each line should be <1\nExtra probability counts as \"recovery without symptoms\"
11
15.0
1

TEXTBOX
547
13
779
53
Simulation management
14
0.0
1

TEXTBOX
588
358
796
396
Demographics Model
14
53.0
1

MONITOR
760
420
929
465
Adults rooming together
count houses-hosting-adults2
17
1
11

MONITOR
1022
420
1130
465
Retired couples
count houses-hosting-retired-couple
17
1
11

MONITOR
936
420
1016
465
Family
count houses-hosting-family
17
1
11

MONITOR
1138
420
1313
465
Multi-generational living
count houses-hosting-multiple-generations
17
1
11

TEXTBOX
2960
306
3115
346
Migration model
14
35.0
1

SLIDER
2950
340
3224
373
probability-infection-when-abroad
probability-infection-when-abroad
0
1
0.0
0.01
1
NIL
HORIZONTAL

SLIDER
3236
382
3533
415
probability-getting-back-when-abroad
probability-getting-back-when-abroad
0
1
0.0
0.01
1
NIL
HORIZONTAL

SWITCH
3099
300
3211
333
migration?
migration?
1
1
-1000

SLIDER
3293
756
3537
789
density-travelling-propagation
density-travelling-propagation
0
1
0.05
0.01
1
NIL
HORIZONTAL

MONITOR
556
1048
620
1093
#@home
count people with [[gathering-type] of current-activity = \"home\"]
17
1
11

MONITOR
616
1048
685
1093
#@school
count people with [[gathering-type] of current-activity = \"school\"]
17
1
11

MONITOR
680
1048
769
1093
#@workplace
count people with [[gathering-type] of current-activity = \"workplace\"]
17
1
11

MONITOR
766
1048
854
1093
#@university
count people with [[gathering-type] of current-activity = \"university\"]
17
1
11

MONITOR
850
1048
927
1093
#@hospital
count people with [[gathering-type] of current-activity = \"hospital\"]
17
1
11

PLOT
10
834
518
1153
Average need satisfaction
time
need satisfaction
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"belonging" 1.0 0 -16777216 true "" "plot mean [belonging-satisfaction-level] of people"
"risk avoidance" 1.0 0 -13345367 true "" "plot mean [risk-avoidance-satisfaction-level] of people"
"autonomy" 1.0 0 -955883 true "" "plot mean [autonomy-satisfaction-level] of people"
"luxury" 1.0 0 -8330359 true "" "plot mean [luxury-satisfaction-level] of people with [not is-child?]"
"health" 1.0 0 -2674135 true "" "plot mean [health-satisfaction-level] of people"
"sleep" 1.0 0 -7500403 true "" "plot mean [sleep-satisfaction-level] of people"
"compliance" 1.0 0 -6459832 true "" "plot mean [compliance-satisfaction-level] of people"
"financial-safety" 1.0 0 -1184463 true "" "plot mean [financial-safety-satisfaction-level] of people with [not is-child?]"
"food-safety" 1.0 0 -14439633 true "" "plot mean [food-safety-satisfaction-level] of people"
"leisure" 1.0 0 -865067 true "" "plot mean [leisure-satisfaction-level] of people"
"financial-survival" 1.0 0 -7858858 true "" "plot mean [financial-survival-satisfaction-level] of people with [not is-child?]"
"conformity" 1.0 0 -12345184 true "" "plot mean [conformity-satisfaction-level] of people"

MONITOR
923
1048
993
1093
#@leisure
count people with [member? \"leisure\" [gathering-type] of current-activity]
17
1
11

MONITOR
992
1048
1094
1093
#@essential-shop
count people with [[gathering-type] of current-activity = \"essential-shop\"]
17
1
11

MONITOR
1093
1048
1168
1093
#@NEshop
count people with [[gathering-type] of current-activity = \"non-essential-shop\"]
17
1
11

SWITCH
1423
25
1562
58
with-infected?
with-infected?
0
1
-1000

MONITOR
1715
1130
1941
1175
NIL
closed-schools?
17
1
11

SWITCH
1717
1090
1939
1123
is-closing-school-when-any-reported-case-measure?
is-closing-school-when-any-reported-case-measure?
1
1
-1000

SLIDER
676
530
924
563
ratio-family-homes
ratio-family-homes
0
1
0.27
0.01
1
NIL
HORIZONTAL

SLIDER
1717
988
1945
1021
ratio-omniscious-infected-that-trigger-school-closing-measure
ratio-omniscious-infected-that-trigger-school-closing-measure
0
1
1.0
0.01
1
NIL
HORIZONTAL

INPUTBOX
1717
1025
1943
1086
#days-trigger-school-closing-measure
10000.0
1
0
Number

SLIDER
1957
983
2225
1016
ratio-omniscious-infected-that-trigger-non-essential-closing-measure
ratio-omniscious-infected-that-trigger-non-essential-closing-measure
0
1
1.0
0.01
1
NIL
HORIZONTAL

INPUTBOX
1959
1020
2228
1081
#days-trigger-non-essential-business-closing-measure
10000.0
1
0
Number

MONITOR
1957
1124
2230
1169
NIL
closed-non-essential?
17
1
11

SLIDER
676
495
928
528
ratio-adults-homes
ratio-adults-homes
0
1
0.38
0.01
1
NIL
HORIZONTAL

SLIDER
676
565
924
598
ratio-retired-couple-homes
ratio-retired-couple-homes
0
1
0.35
0.01
1
NIL
HORIZONTAL

SLIDER
675
602
927
635
ratio-multi-generational-homes
ratio-multi-generational-homes
0
1
0.01
0.01
1
NIL
HORIZONTAL

SLIDER
1377
240
1731
273
factor-reduction-probability-transmission-young
factor-reduction-probability-transmission-young
0
1
0.69
0.01
1
NIL
HORIZONTAL

PLOT
12
1215
524
1365
Average amount of capital per people age
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"worker" 1.0 0 -13345367 true "" "plot workers-average-amount-of-capital"
"retired" 1.0 0 -955883 true "" "plot retirees-average-amount-of-capital"
"student" 1.0 0 -13840069 true "" "plot students-average-amount-of-capital"

PLOT
12
1370
524
1520
Amount of capital per gathering point
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"essential-shop" 1.0 0 -16777216 true "" "plot essential-shop-amount-of-capital"
"non-essential-shop" 1.0 0 -13345367 true "" "plot non-essential-shop-amount-of-capital"
"university" 1.0 0 -955883 true "" "plot university-amount-of-capital"
"hospital" 1.0 0 -13840069 true "" "plot hospital-amount-of-capital"
"workplace" 1.0 0 -2674135 true "" "plot workplace-amount-of-capital"
"school" 1.0 0 -6917194 true "" "plot school-amount-of-capital"

PLOT
1097
1504
1559
1654
Total amount of capital available in the system
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"total" 1.0 0 -16777216 true "" "plot total-amount-of-capital-in-the-system"
"government-reserve" 1.0 0 -13345367 true "" "plot government-reserve-of-capital"

SLIDER
549
1373
760
1406
ratio-tax-on-essential-shops
ratio-tax-on-essential-shops
0
1
0.52
0.01
1
NIL
HORIZONTAL

SLIDER
549
1410
761
1443
ratio-tax-on-non-essential-shops
ratio-tax-on-non-essential-shops
0
1
0.52
0.01
1
NIL
HORIZONTAL

SLIDER
549
1449
761
1482
ratio-tax-on-workplaces
ratio-tax-on-workplaces
0
1
0.55
0.01
1
NIL
HORIZONTAL

SLIDER
549
1487
761
1520
ratio-tax-on-workers
ratio-tax-on-workers
0
1
0.41
0.01
1
NIL
HORIZONTAL

TEXTBOX
552
1354
750
1382
Taxes charged by the government
11
25.0
1

TEXTBOX
789
1308
1013
1337
Distribution of government subsidy
11
25.0
1

SLIDER
784
1368
957
1401
ratio-hospital-subsidy
ratio-hospital-subsidy
0
1
0.21
0.01
1
NIL
HORIZONTAL

SLIDER
784
1405
957
1438
ratio-university-subsidy
ratio-university-subsidy
0
1
0.03
0.01
1
NIL
HORIZONTAL

SLIDER
784
1444
957
1477
ratio-retirees-subsidy
ratio-retirees-subsidy
0
1
0.34
0.01
1
NIL
HORIZONTAL

SLIDER
785
1482
957
1515
ratio-students-subsidy
ratio-students-subsidy
0
1
0.34
0.01
1
NIL
HORIZONTAL

SLIDER
784
1329
956
1362
ratio-school-subsidy
ratio-school-subsidy
0
1
0.03
0.01
1
NIL
HORIZONTAL

CHOOSER
583
379
743
424
household-profiles
household-profiles
"custom" "Belgium" "Canada" "Germany" "Great Britain" "France" "Italy" "Korea South" "Netherlands" "Norway" "Spain" "Singapore" "Sweden" "U.S.A."
0

SLIDER
2149
642
2436
675
ratio-population-randomly-tested-daily
ratio-population-randomly-tested-daily
0
1
0.0
0.01
1
NIL
HORIZONTAL

SWITCH
2148
717
2438
750
test-workplace-of-confirmed-people?
test-workplace-of-confirmed-people?
1
1
-1000

SWITCH
2148
679
2437
712
test-home-of-confirmed-people?
test-home-of-confirmed-people?
1
1
-1000

TEXTBOX
2264
612
2414
630
Testing
11
105.0
1

SLIDER
549
1239
761
1272
price-of-rations-in-essential-shops
price-of-rations-in-essential-shops
0.5
10
2.2
0.1
1
NIL
HORIZONTAL

PLOT
13
1524
524
1674
Accumulated amount of goods in stock per type of business
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"essential-shop" 1.0 0 -16777216 true "" "plot essential-shop-amount-of-goods-in-stock"
"non-essential-shop" 1.0 0 -13345367 true "" "plot non-essential-shop-amount-of-goods-in-stock"
"workplace" 1.0 0 -2674135 true "" "plot workplace-amount-of-goods-in-stock"

SLIDER
548
1547
757
1580
goods-produced-by-work-performed
goods-produced-by-work-performed
1
50
12.0
1
1
NIL
HORIZONTAL

SLIDER
548
1584
757
1617
unit-price-of-goods
unit-price-of-goods
0.1
5
1.7
0.1
1
NIL
HORIZONTAL

SWITCH
668
47
781
80
static-seed?
static-seed?
1
1
-1000

CHOOSER
548
89
790
134
preset-scenario
preset-scenario
"default-scenario" "scenario-1-zero-action-scandinavia" "scenario-1-closing-schools-and-uni" "scenario-1-work-at-home-only" "scenario-1-closing-all" "scenario-3-random-test-20" "scenario-3-app-test-60" "scenario-3-app-test-80" "scenario-3-app-test-100" "economic-scenario-1-baseline" "economic-scenario-2-infections" "economic-scenario-3-lockdown" "economic-scenario-4-wages" "app-test-scenario-5-1K" "scenario-6-default" "no-action-scandinavia-2.5K" "one-family" "scenario-9-smart-testing" "scenario-7-cultural-model"
14

MONITOR
760
376
848
421
#children
count children
17
1
11

MONITOR
858
375
929
420
#students
count students
17
1
11

MONITOR
928
375
994
420
#workers
count workers
17
1
11

MONITOR
992
375
1051
420
#retired
count retireds
17
1
11

TEXTBOX
1797
963
1947
981
Closing schools\n
11
105.0
1

TEXTBOX
2037
958
2187
976
Closing workplaces
11
105.0
1

TEXTBOX
2305
959
2455
977
Closing universities
11
105.0
1

TEXTBOX
941
475
1261
524
Worker distribution (relevant for economic model)
11
53.0
1

TEXTBOX
1233
167
1368
210
Distribution of disease evolution
11
15.0
1

TEXTBOX
563
788
723
863
Density factors:\nRelative proximity between individuals within an activity type (impacts contamination risks).
10
125.0
1

TEXTBOX
3293
708
3548
763
Density settings influence risk of becoming sick when travelling locally (is related with contagion model)
11
65.0
1

TEXTBOX
2458
794
2633
825
All people at home are tested if one is confirmed sick.
9
105.0
1

TEXTBOX
2457
833
2639
862
All people at work are tested if one is confirmed sick.
9
105.0
1

TEXTBOX
2495
960
2690
988
General Lockdown Measures
11
105.0
1

TEXTBOX
560
1165
710
1183
Economic Model
14
25.0
1

BUTTON
803
98
1061
133
load scenario-specific parameter settings
load-scenario-specific-parameter-settings
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
549
1277
745
1310
days-of-rations-bought
days-of-rations-bought
1
28
3.0
1
1
NIL
HORIZONTAL

SLIDER
2950
380
3225
413
probability-going-abroad
probability-going-abroad
0
1
0.0
0.01
1
NIL
HORIZONTAL

MONITOR
1036
1095
1093
1140
#away
count people with [is-away?]
17
1
11

MONITOR
766
992
909
1037
NIL
#who-became-sick-while-travelling-locally
17
1
11

SWITCH
787
1529
987
1562
government-pays-wages?
government-pays-wages?
1
1
-1000

SLIDER
787
1569
1058
1602
ratio-of-wage-paid-by-the-government
ratio-of-wage-paid-by-the-government
0
1
0.8
0.01
1
NIL
HORIZONTAL

INPUTBOX
787
1609
986
1669
government-initial-reserve-of-capital
10000.0
1
0
Number

SLIDER
548
1624
766
1657
max-stock-of-goods-in-a-shop
max-stock-of-goods-in-a-shop
0
1000
500.0
10
1
NIL
HORIZONTAL

SLIDER
784
1192
1054
1225
starting-amount-of-capital-workers
starting-amount-of-capital-workers
0
100
75.0
1
1
NIL
HORIZONTAL

SLIDER
784
1229
1055
1262
starting-amount-of-capital-retired
starting-amount-of-capital-retired
0
100
40.0
1
1
NIL
HORIZONTAL

SLIDER
784
1268
1068
1301
starting-amount-of-capital-students
starting-amount-of-capital-students
0
100
30.0
1
1
NIL
HORIZONTAL

SLIDER
2264
1175
2703
1208
probably-contagion-mitigation-from-social-distancing
probably-contagion-mitigation-from-social-distancing
0
1
0.08
0.01
1
NIL
HORIZONTAL

TEXTBOX
2417
1112
2567
1130
Social distancing
11
105.0
1

SLIDER
2265
1139
2700
1172
ratio-omniscious-infected-that-trigger-social-distancing-measure
ratio-omniscious-infected-that-trigger-social-distancing-measure
0
1
1.0
0.01
1
NIL
HORIZONTAL

MONITOR
2267
1215
2519
1260
NIL
is-social-distancing-measure-active?
17
1
11

PLOT
1098
1662
1464
1812
Velocity of money in total system
NIL
NIL
0.0
10.0
0.0
0.5
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot velocity-of-money-in-total-system"

PLOT
1098
1825
1465
1975
Goods production of total system
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot goods-production-of-total-system"

PLOT
1480
1663
1890
1813
Number of adult people out of capital
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"total" 1.0 0 -16777216 true "" "plot #adult-people-out-of-capital"
"worker" 1.0 0 -13345367 true "" "plot #workers-out-of-capital"
"retired" 1.0 0 -955883 true "" "plot #retired-out-of-capital"
"student" 1.0 0 -10899396 true "" "plot #students-out-of-capital"

PLOT
1480
1824
1891
1974
Number of gathering points out of capital
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"essential-shop" 1.0 0 -16777216 true "" "plot #essential-shops-out-of-capital"
"non-essential-shop" 1.0 0 -13345367 true "" "plot #non-essential-shops-out-of-capital"
"university" 1.0 0 -955883 true "" "plot #universities-out-of-capital"
"hospital" 1.0 0 -13840069 true "" "plot #hospitals-out-of-capital"
"workplace" 1.0 0 -2674135 true "" "plot #workplaces-out-of-capital"
"school" 1.0 0 -8630108 true "" "plot #schools-out-of-capital"

PLOT
13
1687
522
1851
Activities
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"@Work" 1.0 0 -14070903 true "" "plot count people with [is-at-work?]"
"@Pu-Leisure" 1.0 0 -5298144 true "" "plot count people with [is-at-public-leisure-place?]"
"@Pr-Leisure" 1.0 0 -3844592 true "" "plot count people with [is-at-private-leisure-place?]"
"@Home" 1.0 0 -14439633 true "" "plot count people with [is-at-home?]"
"@Univ" 1.0 0 -4079321 true "" "plot count people with [is-at-university?]"
"Treated" 1.0 0 -7500403 true "" "plot count people with [current-motivation = treatment-motive]"
"@E-Shop" 1.0 0 -8630108 true "" "plot count people-at-essential-shops"
"@NE-Shop" 1.0 0 -5825686 true "" "plot count people-at-non-essential-shops"

SLIDER
549
1200
721
1233
workers-wages
workers-wages
0
30
10.0
0.5
1
NIL
HORIZONTAL

SLIDER
2364
484
2589
517
mean-social-distance-profile
mean-social-distance-profile
0
1
0.5
0.01
1
NIL
HORIZONTAL

INPUTBOX
582
495
662
558
#households
391.0
1
0
Number

MONITOR
582
438
657
483
#people
count people
17
1
11

INPUTBOX
1375
288
1570
348
#beds-in-hospital
2000.0
1
0
Number

MONITOR
559
943
652
988
NIL
#people-saved-by-hospitalization
17
1
11

MONITOR
1199
2055
1312
2100
NIL
#hospital-workers
17
1
11

MONITOR
1059
2002
1192
2047
NIL
#essential-shop-workers
17
1
11

MONITOR
1199
2002
1374
2047
NIL
#non-essential-shop-workers
17
1
11

MONITOR
662
943
752
988
NIL
#denied-requests-for-hospital-beds
17
1
11

MONITOR
1059
2055
1191
2100
NIL
#university-workers
17
1
11

MONITOR
1199
2108
1304
2153
NIL
#school-workers
17
1
11

MONITOR
765
941
913
986
NIL
#people-dying-due-to-lack-of-hospitalization
17
1
11

MONITOR
1063
2108
1194
2153
NIL
#workplace-workers
17
1
11

SLIDER
2597
484
2855
517
std-dev-social-distance-profile
std-dev-social-distance-profile
0
1
0.1
0.01
1
NIL
HORIZONTAL

MONITOR
2527
1215
2684
1260
#social-distancing
count people with [is-I-apply-social-distancing? = true]
17
1
11

PLOT
545
1704
1044
1854
Number of workers actually working at each gathering point
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"essential-shop" 1.0 0 -16777216 true "" "plot #workers-working-at-essential-shop"
"non-essential-shop" 1.0 0 -13345367 true "" "plot #workers-working-at-non-essential-shop"
"university" 1.0 0 -955883 true "" "plot #workers-working-at-university"
"hospital" 1.0 0 -13840069 true "" "plot #workers-working-at-hospital"
"workplace" 1.0 0 -2674135 true "" "plot #workers-working-at-workplace"
"school" 1.0 0 -8630108 true "" "plot #workers-working-at-school"

SLIDER
549
1315
775
1348
price-of-rations-in-non-essential-shops
price-of-rations-in-non-essential-shops
0.5
10
2.2
0.1
1
NIL
HORIZONTAL

BUTTON
548
141
614
174
import
ask-user-for-import-file\nload-scenario-from-file
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
619
141
688
174
export
ask-user-for-export-file\nsave-world-state
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
1656
539
1836
584
NIL
hospital-effectiveness
17
1
11

SLIDER
2148
900
2442
933
ratio-population-daily-immunity-testing
ratio-population-daily-immunity-testing
0
1
0.0
0.01
1
NIL
HORIZONTAL

SLIDER
1779
25
2129
58
daily-risk-believe-experiencing-fake-symptoms
daily-risk-believe-experiencing-fake-symptoms
0
1
0.0
0.01
1
NIL
HORIZONTAL

SLIDER
3052
616
3306
649
ratio-worker-public-transport
ratio-worker-public-transport
0
1
0.4
0.01
1
NIL
HORIZONTAL

SLIDER
3322
618
3540
651
ratio-worker-shared-car
ratio-worker-shared-car
0
1
0.15
0.01
1
NIL
HORIZONTAL

SLIDER
3050
539
3304
572
ratio-children-public-transport
ratio-children-public-transport
0
1
0.75
0.01
1
NIL
HORIZONTAL

SLIDER
3318
538
3536
571
ratio-children-shared-car
ratio-children-shared-car
0
1
0.0
0.01
1
NIL
HORIZONTAL

SLIDER
3318
576
3536
609
ratio-student-shared-car
ratio-student-shared-car
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
3322
656
3540
689
ratio-retired-shared-car
ratio-retired-shared-car
0
1
0.5
0.01
1
NIL
HORIZONTAL

SLIDER
3050
578
3304
611
ratio-student-public-transport
ratio-student-public-transport
0
1
0.6
0.01
1
NIL
HORIZONTAL

SLIDER
3052
658
3305
691
ratio-retired-public-transport
ratio-retired-public-transport
0
1
0.2
0.01
1
NIL
HORIZONTAL

INPUTBOX
2918
713
3074
773
#bus-per-timeslot
30.0
1
0
Number

INPUTBOX
2916
780
3072
840
#max-people-per-bus
20.0
1
0
Number

MONITOR
3078
789
3273
834
#people-staying-out-queuing
count people with [stayed-out-queuing-for-bus?]
17
1
11

SLIDER
3293
799
3540
832
density-when-queuing
density-when-queuing
0
1
0.6
0.01
1
NIL
HORIZONTAL

SLIDER
3296
842
3540
875
density-in-public-transport
density-in-public-transport
0
1
0.5
0.01
1
NIL
HORIZONTAL

SLIDER
3298
882
3545
915
density-in-shared-cars
density-in-shared-cars
0
1
0.8
0.01
1
NIL
HORIZONTAL

MONITOR
3080
723
3269
768
NIL
#people-denied-bus
17
1
11

MONITOR
1868
435
2093
480
NIL
#people-infected-in-general-travel
17
1
11

BUTTON
10
248
102
283
1 Month Run
let starting-day current-day\nlet end-day starting-day + 28\nwhile [current-day <= end-day] [ go ]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
2360
35
2510
80
set_national_culture
set_national_culture
"Custom" "Belgium" "Canada" "Germany" "Great Britain" "France" "Italy" "Korea South" "Netherlands" "Norway" "Spain" "Singapore" "Sweden" "U.S.A."
4

SLIDER
2364
112
2538
145
uncertainty-avoidance
uncertainty-avoidance
0
100
35.0
1
1
NIL
HORIZONTAL

SLIDER
2547
110
2736
143
individualism-vs-collectivism
individualism-vs-collectivism
0
100
89.0
1
1
NIL
HORIZONTAL

SLIDER
2365
153
2537
186
power-distance
power-distance
0
100
35.0
1
1
NIL
HORIZONTAL

SLIDER
2547
157
2736
190
indulgence-vs-restraint
indulgence-vs-restraint
0
100
69.0
1
1
NIL
HORIZONTAL

SLIDER
2365
202
2539
235
masculinity-vs-femininity
masculinity-vs-femininity
0
100
66.0
1
1
NIL
HORIZONTAL

SLIDER
2550
202
2736
235
long-vs-short-termism
long-vs-short-termism
0
100
51.0
1
1
NIL
HORIZONTAL

SLIDER
2599
267
2722
300
value-std-dev
value-std-dev
0
20
10.0
1
1
NIL
HORIZONTAL

SLIDER
2367
268
2590
301
value-system-calibration-factor
value-system-calibration-factor
0
40
25.0
1
1
NIL
HORIZONTAL

SLIDER
2365
336
2537
369
survival-multiplier
survival-multiplier
0
3
2.5
0.1
1
NIL
HORIZONTAL

SLIDER
2547
336
2719
369
maslow-multiplier
maslow-multiplier
0
1
0.0
0.01
1
NIL
HORIZONTAL

TEXTBOX
2362
13
2483
37
Cultural Model
14
83.0
1

SLIDER
3233
343
3541
376
owning-solo-transportation-probability
owning-solo-transportation-probability
0
1
1.0
0.01
1
NIL
HORIZONTAL

SLIDER
1729
1333
2044
1366
ratio-of-people-using-the-tracking-app
ratio-of-people-using-the-tracking-app
0
1
0.6
0.01
1
NIL
HORIZONTAL

SWITCH
1957
1178
2235
1211
is-working-from-home-recommended?
is-working-from-home-recommended?
1
1
-1000

SLIDER
1872
894
2098
927
percentage-news-watchers
percentage-news-watchers
0
1
0.75
0.01
1
NIL
HORIZONTAL

MONITOR
2063
1402
2196
1447
#recorded-contacts-in-tracing-app
average-number-of-people-recorded-by-recording-apps
17
1
11

INPUTBOX
1633
1470
1793
1531
#days-recording-tracing
7.0
1
0
Number

MONITOR
2458
876
2586
921
NIL
#tests-performed
17
1
11

BUTTON
10
288
103
323
go once
go
NIL
1
T
OBSERVER
NIL
G
NIL
NIL
1

BUTTON
10
328
105
363
inspect person
inspect one-of people
NIL
1
T
OBSERVER
NIL
I
NIL
NIL
1

BUTTON
1872
850
2095
885
NIL
inform-people-of-measures
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
2365
376
2538
409
weight-survival-needs
weight-survival-needs
0
1
0.5
0.01
1
NIL
HORIZONTAL

TEXTBOX
2364
88
2698
115
Hofstede dimension settings
11
83.0
1

TEXTBOX
2367
248
2564
278
Agent value system settings
11
83.0
1

TEXTBOX
2370
313
2560
331
Agent need system settings
11
83.0
1

INPUTBOX
801
27
914
87
#random-seed
3.0
1
0
Number

CHOOSER
2794
63
2996
108
network-generation-method
network-generation-method
"random" "value-similarity"
1

TEXTBOX
2798
27
2986
65
Social Network Model
14
115.0
1

SLIDER
2794
113
3038
146
peer-group-friend-links
peer-group-friend-links
1
150
7.0
1
1
NIL
HORIZONTAL

SLIDER
784
1150
956
1183
productivity-at-home
productivity-at-home
0
2
1.0
0.1
1
NIL
HORIZONTAL

SLIDER
2794
154
3082
187
percentage-of-agents-with-random-link
percentage-of-agents-with-random-link
0
1
0.14
0.01
1
NIL
HORIZONTAL

SLIDER
1726
1293
2046
1326
ratio-of-anxiety-avoidance-tracing-app-users
ratio-of-anxiety-avoidance-tracing-app-users
0
1
0.0
0.01
1
NIL
HORIZONTAL

BUTTON
2796
198
2953
231
Write network as dot
write-network-to-file user-new-file
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

MONITOR
2063
1269
2198
1314
#tracing-app-users
count people with [is-user-of-tracking-app?]
17
1
11

BUTTON
678
436
741
469
set
load-population-profile-based-on-current-preset-profile
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1673
1989
2249
2185
Macro Economic Model - Capital Flow
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"agriculture-essential" 1.0 0 -16777216 true "" "plot total-capital-agriculture-essential"
"agriculture-luxury" 1.0 0 -13345367 true "" "plot total-capital-agriculture-luxury"
"manufacturing-essential" 1.0 0 -955883 true "" "plot total-capital-manufacturing-essential"
"manufacturing-luxury" 1.0 0 -13840069 true "" "plot total-capital-manufacturing-luxury"
"services-essential" 1.0 0 -2674135 true "" "plot total-capital-services-essential"
"services-luxury" 1.0 0 -8630108 true "" "plot total-capital-services-luxury"
"education-research" 1.0 0 -13791810 true "" "plot total-capital-education-research"
"households-sector" 1.0 0 -6459832 true "" "plot total-capital-households-sector"
"government-sector" 1.0 0 -5825686 true "" "plot total-capital-government-sector"

TEXTBOX
2370
425
2642
455
Agent social distancing settings
11
83.0
1

PLOT
1480
2192
1938
2342
Macro Economic Model - International Sector
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"international-sector" 1.0 0 -14835848 true "" "plot total-capital-international-sector"

SWITCH
1469
2027
1663
2060
close-services-luxury?
close-services-luxury?
1
1
-1000

PLOT
1895
1663
2235
1813
Number of adult people in poverty
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"total" 1.0 0 -16777216 true "" "plot count people with [not is-young? and is-in-poverty?]"
"worker" 1.0 0 -13345367 true "" "plot count workers with [is-in-poverty?]"
"retired" 1.0 0 -955883 true "" "plot count retireds with [is-in-poverty?]"
"students" 1.0 0 -13840069 true "" "plot count students with [is-in-poverty?]"

PLOT
1895
1824
2223
1974
Histogram of available capital
my-amount-of-capital
counts
0.0
500.0
0.0
10.0
true
true
"foreach [\"worker\" \"retired\" \"student\"] [ pen ->\n  set-current-plot-pen pen\n  set-plot-pen-mode 1\n]\nset-histogram-num-bars 500" ""
PENS
"worker" 1.0 0 -13345367 true "" "histogram [my-amount-of-capital] of workers"
"retired" 1.0 0 -955883 true "" "histogram [my-amount-of-capital] of retireds"
"student" 1.0 0 -13840069 true "" "histogram [my-amount-of-capital] of students"

PLOT
1098
1330
1539
1480
Quality of Life Indicator
Time
Quality of Life
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"Mean" 1.0 0 -13840069 true "" "plot mean [quality-of-life-indicator] of people"
"Median" 1.0 0 -14454117 true "" "plot median [quality-of-life-indicator] of people"
"Min" 1.0 0 -2674135 true "" "plot min [quality-of-life-indicator] of people"
"Max" 1.0 0 -1184463 true "" "plot max [quality-of-life-indicator] of people"

TEXTBOX
22
13
210
55
ASSOCC
32
14.0
1

TEXTBOX
1788
1270
1956
1313
Tracing (smartphone app)
11
105.0
1

SWITCH
2365
444
2689
477
make-social-distance-profile-value-based?
make-social-distance-profile-value-based?
0
1
-1000

MONITOR
1652
439
1836
484
NIL
#healthy-hospital-personel
17
1
11

MONITOR
1656
489
1838
534
NIL
#sick-hospital-personel
17
1
11

SLIDER
1443
2137
1663
2170
government-sector-subsidy-ratio
government-sector-subsidy-ratio
0
1
0.0
0.01
1
NIL
HORIZONTAL

PLOT
1945
2192
2380
2342
Macro Economic Model - Central Bank
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"reserve-of-capital" 1.0 0 -16777216 true "" "plot sum [reserve-of-capital] of central-banks"
"total-credit" 1.0 0 -13345367 true "" "plot sum [total-credit] of central-banks"

PLOT
2262
1989
2801
2183
Macro Economic Model - Debt
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"agriculture-essential" 1.0 0 -16777216 true "" "plot total-debt-agriculture-essential"
"agriculture-luxury" 1.0 0 -13345367 true "" "plot total-debt-agriculture-luxury"
"manufacturing-essential" 1.0 0 -955883 true "" "plot total-debt-manufacturing-essential"
"manufacturing-luxury" 1.0 0 -13840069 true "" "plot total-debt-manufacturing-luxury"
"services-essential" 1.0 0 -2674135 true "" "plot total-debt-services-essential"
"services-luxury" 1.0 0 -8630108 true "" "plot total-debt-services-luxury"
"education-research" 1.0 0 -13791810 true "" "plot total-debt-education-research"
"households-sector" 1.0 0 -6459832 true "" "plot total-debt-households-sector"

PLOT
2389
2192
2801
2342
Macro Economic Model - Government Debt
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"debt" 1.0 0 -16777216 true "" "plot total-debt-government-sector"

SLIDER
1358
2063
1663
2096
services-luxury-ratio-of-expenditures-when-closed
services-luxury-ratio-of-expenditures-when-closed
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
1362
2099
1663
2132
services-luxury-ratio-of-income-when-closed
services-luxury-ratio-of-income-when-closed
0
1
0.0
0.01
1
NIL
HORIZONTAL

SLIDER
1802
1463
2033
1496
ratio-young-with-phones
ratio-young-with-phones
0
1
1.0
0.01
1
NIL
HORIZONTAL

SLIDER
1801
1502
2040
1535
ratio-retired-with-phones
ratio-retired-with-phones
0
1
1.0
0.01
1
NIL
HORIZONTAL

MONITOR
2066
1449
2196
1494
#phone-owners
count people with [has-mobile-phone?]
17
1
11

MONITOR
2066
1498
2198
1543
ratio-phone-owners
count people with [has-mobile-phone?] / count people
17
1
11

SLIDER
1469
1989
1663
2022
interest-rate-by-tick
interest-rate-by-tick
0
0.01
0.001
0.0001
1
NIL
HORIZONTAL

CHOOSER
2122
335
2260
380
disease-fsm-model
disease-fsm-model
"assocc" "oxford"
1

MONITOR
2122
398
2179
443
NIL
r0
17
1
11

INPUTBOX
2606
866
2724
927
#available-tests
10000.0
1
0
Number

SWITCH
2148
753
2439
786
prioritize-testing-health-care?
prioritize-testing-health-care?
1
1
-1000

BUTTON
12
168
104
201
1 Day run
if slice-of-the-day = \"morning\" [go]\nwhile [slice-of-the-day != \"morning\"] [go]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
2148
823
2440
856
do-not-test-youth?
do-not-test-youth?
0
1
-1000

SWITCH
2148
862
2442
895
only-test-retirees-with-extra-tests?
only-test-retirees-with-extra-tests?
1
1
-1000

MONITOR
2828
1496
2933
1541
#Non isolators
count should-be-isolators with [current-activity != my-home and current-activity != my-hospital and current-activity != away-gathering-point]
17
1
11

MONITOR
2943
1499
3083
1544
#Should be isolating
count should-be-isolators
17
1
11

SWITCH
2233
1423
2471
1456
food-delivered-to-isolators?
food-delivered-to-isolators?
0
1
-1000

PLOT
2828
1336
3206
1486
Quarantining & isolation
time
#people
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"breaking isolation" 1.0 0 -2674135 true "" "plot count people with [is-officially-asked-to-quarantine? and not is-in-quarantine?]"
"of. quarantiners" 1.0 0 -11085214 true "" "plot count people with [is-officially-asked-to-quarantine?]"
"online supplying" 1.0 0 -7171555 true "" "plot  #delivered-supply-proposed-this-tick"
"sick quarantiners" 1.0 0 -13791810 true "" "plot count people with [is-officially-asked-to-quarantine? and is-believing-to-be-infected?]"

TEXTBOX
2512
1308
2662
1329
Self-isolation
11
105.0
1

SLIDER
2485
1455
2803
1488
ratio-self-quarantining-when-a-family-member-is-symptomatic
ratio-self-quarantining-when-a-family-member-is-symptomatic
0
1
0.8
0.01
1
NIL
HORIZONTAL

SWITCH
2485
1329
2799
1362
is-infected-and-their-families-requested-to-stay-at-home?
is-infected-and-their-families-requested-to-stay-at-home?
0
1
-1000

SWITCH
2232
1329
2476
1362
all-self-isolate-for-35-days-when-first-hitting-2%-infected?
all-self-isolate-for-35-days-when-first-hitting-2%-infected?
0
1
-1000

MONITOR
2233
1369
2475
1414
NIL
start-tick-of-global-quarantine
17
1
11

PLOT
1579
289
1847
429
hospitals
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"#taken-beds" 1.0 0 -2674135 true "" "plot #taken-hospital-beds"
"#available-beds" 1.0 0 -10899396 true "" "plot #beds-available-for-admission"

SLIDER
2485
1415
2800
1448
ratio-self-quarantining-when-symptomatic
ratio-self-quarantining-when-symptomatic
0
1
0.8
0.01
1
NIL
HORIZONTAL

MONITOR
2474
1040
2687
1085
NIL
is-hard-lockdown-active?
17
1
11

CHOOSER
1729
1373
2039
1418
when-is-tracing-app-active?
when-is-tracing-app-active?
"always" "never" "7-days-before-end-of-global-quarantine" "at-end-of-global-quarantine"
2

SWITCH
1719
1425
2041
1458
is-tracking-app-testing-immediately-recursive?
is-tracking-app-testing-immediately-recursive?
0
1
-1000

MONITOR
2063
1359
2196
1404
NIL
is-tracing-app-active?
17
1
11

MONITOR
2063
1315
2202
1360
#people-ever-recorded-as-positive-in-the-app
count people-having-ever-been-recorded-as-positive-in-the-app
17
1
11

CHOOSER
2453
700
2724
745
when-is-daily-testing-applied?
when-is-daily-testing-applied?
"always" "never" "7-days-before-end-of-global-quarantine" "at-end-of-global-quarantine"
1

MONITOR
2453
644
2625
689
NIL
#tests-used-by-daily-testing
17
1
11

MONITOR
1866
485
2098
530
NIL
#infected-by-asymptomatic-people
17
1
11

SWITCH
2147
788
2439
821
prioritize-testing-education?
prioritize-testing-education?
1
1
-1000

SWITCH
2485
1372
2798
1405
is-psychorigidly-staying-at-home-when-quarantining?
is-psychorigidly-staying-at-home-when-quarantining?
1
1
-1000

TEXTBOX
2290
1304
2440
1322
Global quarantine
11
105.0
1

SWITCH
662
190
834
223
log-contamination?
log-contamination?
1
1
-1000

SWITCH
549
233
804
266
log-preferred-activity-decision?
log-preferred-activity-decision?
1
1
-1000

TEXTBOX
3179
506
3367
529
Transport Model
14
65.0
1

SWITCH
550
269
663
302
log-setup?
log-setup?
1
1
-1000

SLIDER
2547
377
2719
410
financial-safety-learning-rate
financial-safety-learning-rate
0
1
0.05
0.01
1
NIL
HORIZONTAL

SWITCH
836
240
999
273
clear-log-on-setup?
clear-log-on-setup?
0
1
-1000

PLOT
1374
350
1574
587
contacts
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"hospitals" 1.0 0 -16777216 true "" "plot  #contacts-in-hospitals"
"workplaces" 1.0 0 -7500403 true "" "plot  #contacts-in-workplaces"
"homes" 1.0 0 -2674135 true "" "plot  #contacts-in-homes"
"pub-lei" 1.0 0 -955883 true "" "plot  #contacts-in-public-leisure"
"pri-lei" 1.0 0 -6459832 true "" "plot  #contacts-in-private-leisure"
"schools" 1.0 0 -1184463 true "" "plot  #contacts-in-schools"
"univ" 1.0 0 -10899396 true "" " plot #contacts-in-universities"
"e-shops" 1.0 0 -13840069 true "" "plot  #contacts-in-essential-shops"
"ne-shops" 1.0 0 -14835848 true "" " plot #contacts-in-non-essential-shops"
"pub-trans" 1.0 0 -11221820 true "" "plot  #contacts-in-pubtrans"
"priv-trans" 1.0 0 -13791810 true "" " plot #contacts-in-shared-cars"
"queuing" 1.0 0 -13345367 true "" "plot  #contacts-in-queuing"

MONITOR
2136
477
2324
522
NIL
#people-infected-in-workplaces
17
1
11

MONITOR
1784
588
1848
633
ne-shops
#people-infected-in-non-essential-shops
17
1
11

PLOT
1867
531
2098
764
#people infected in
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"hospitals" 1.0 0 -16777216 true "" "plot #people-infected-in-hospitals"
"workplaces" 1.0 0 -7500403 true "" "plot #people-infected-in-workplaces"
"homes" 1.0 0 -2674135 true "" "plot #people-infected-in-homes"
"public-leisure" 1.0 0 -955883 true "" "plot #people-infected-in-public-leisure"
"private-leisure" 1.0 0 -6459832 true "" "plot #people-infected-in-private-leisure"
"schools" 1.0 0 -1184463 true "" "plot #people-infected-in-schools"
"universities" 1.0 0 -10899396 true "" "plot #people-infected-in-universities"
"e-shops" 1.0 0 -13840069 true "" "plot #people-infected-in-essential-shops"
"ne-shops" 1.0 0 -14835848 true "" "plot #people-infected-in-non-essential-shops"
"pub-trans" 1.0 0 -11221820 true "" "plot #people-infected-in-pubtrans"
"priv-trans" 1.0 0 -13791810 true "" "plot #people-infected-in-shared-cars"
"queuing" 1.0 0 -13345367 true "" "plot #people-infected-in-queuing"

PLOT
1377
585
1664
765
infection per age
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"R-Y" 1.0 0 -8053223 true "" "plot #cumulative-youngs-infected"
"R-S" 1.0 0 -7171555 true "" "plot #cumulative-students-infected"
"R-W" 1.0 0 -15040220 true "" "plot #cumulative-workers-infected"
"R-R" 1.0 0 -13403783 true "" "plot #cumulative-retireds-infected"
"S-Y" 1.0 0 -2139308 true "" "plot #cumulative-youngs-infector"
"S-S" 1.0 0 -987046 true "" "plot #cumulative-students-infector"
"S-W" 1.0 0 -8732573 true "" "plot #cumulative-workers-infector"
"S-R" 1.0 0 -11033397 true "" "plot #cumulative-retireds-infector"

MONITOR
2878
1561
3185
1606
NIL
ratio-quarantiners-currently-complying-to-quarantine
17
1
11

SWITCH
839
189
1010
222
log-violating-quarantine?
log-violating-quarantine?
0
1
-1000

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="true">
    <setup>load-population-profile-based-on-current-preset-profile
setup</setup>
    <go>go</go>
    <timeLimit steps="3"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="#hospital">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-of-rations-in-non-essential-shops">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probably-contagion-mitigation-from-social-distancing">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="factor-reduction-probability-transmission-young">
      <value value="0.68"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="goods-produced-by-work-performed">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-safety-belonging">
      <value value="0.41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-stock-of-goods-in-a-shop">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="preset-scenario">
      <value value="&quot;generic-baseline&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-private-leisure">
      <value value="0.21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-non-essential-closing-measure">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-getting-back-when-abroad">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="critical-to-terminal">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="asympomatic-contagiousness-to-symptomatic-contagiousness">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-school-closing-measure">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="test-workplace-of-confirmed-people?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="importance-survival">
      <value value="0.93"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="with-infected?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-students-subsidy">
      <value value="0.34"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-hospital">
      <value value="0.81"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#schools">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="static-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="importance-risk-avoidance">
      <value value="0.39"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-social-distancing-measure">
      <value value="0.12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-non-essential-shops">
      <value value="0.52"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="days-of-rations-bought">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-school-subsidy">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-schools">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-adults-homes">
      <value value="0.49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-self-recovery-symptoms">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-unavoidable-death">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-multi-generational-homes">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#households">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-hospital-subsidy">
      <value value="0.21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-shopkeeper">
      <value value="0.13"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="importance-luxury">
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-essential-shops">
      <value value="0.19"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="workers-wages">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-of-wage-paid-by-the-government">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-school-personel">
      <value value="0.12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-public-leisure">
      <value value="0.51"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-workplaces">
      <value value="0.21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="std-dev-social-distance-profile">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-universities">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-university-subsidy">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-infection-when-abroad">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="needs-std-dev">
      <value value="0.11"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-going-abroad">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#beds-in-hospital">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-retired">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#non-essential-shops">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#universities">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-self-recovery-symptoms-old">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="importance-autonomy">
      <value value="0.28"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infection-to-asymptomatic-contagiousness">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-family-homes">
      <value value="0.23"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-non-essential-shops">
      <value value="0.71"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-hospital-personel">
      <value value="0.17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="migration?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-essential-shops">
      <value value="0.52"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#public-leisure">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-of-rations-in-essential-shops">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="importance-financial-safety">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="terminal-to-death">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="unit-price-of-goods">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="symptomatic-to-critical-or-heal">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-homes">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="importance-self-esteem">
      <value value="0.41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-closing-school-when-any-reported-case-measure?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-workplaces">
      <value value="0.55"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-recorvery-if-treated-old">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="preset-profiles">
      <value value="&quot;scandinavia&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="global-confinment-measures">
      <value value="&quot;none&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="importance-compliance">
      <value value="0.55"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="propagation-risk">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="importance-leisure">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-unavoidable-death-old">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-population-randomly-tested-daily">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-social-distance-profile">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="closed-universities?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-initial-reserve-of-capital">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-students">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-pays-wages?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#essential-shops">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-workers">
      <value value="0.41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#private-leisure">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retirees-subsidy">
      <value value="0.34"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#workplaces">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="animate?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-recorvery-if-treated">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-couple-homes">
      <value value="0.27"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="closed-workplaces?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#days-trigger-non-essential-business-closing-measure">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="test-home-of-confirmed-people?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-workers">
      <value value="75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-travelling-propagation2">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-university-personel">
      <value value="0.11"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#days-trigger-school-closing-measure">
      <value value="10000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="social-cultural-model-experiment" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="500"/>
    <metric>count people with [is-infected?]</metric>
    <metric>#dead-people</metric>
    <metric>count people with [is-I-apply-social-distancing?]</metric>
    <metric>count people with [is-at-home?]</metric>
    <metric>count people with [is-working-at-home?]</metric>
    <metric>count workers</metric>
    <metric>count retireds</metric>
    <metric>count students</metric>
    <metric>count children</metric>
    <metric>count people with [[is-school?] of current-activity]</metric>
    <metric>count people with [[is-hospital?] of current-activity]</metric>
    <metric>count people with [[is-university?] of current-activity = "university"]</metric>
    <metric>count people with [is-at-work?]</metric>
    <metric>count people with [[is-public-leisure?] of current-activity]</metric>
    <metric>count people with [[is-private-leisure?] of current-activity = "private-leisure"]</metric>
    <metric>count people with [[is-essential-shop?] of current-activity]</metric>
    <metric>count people with [[is-private-leisure?] of current-activity]</metric>
    <metric>mean [sleep-satisfaction-level] of people</metric>
    <metric>mean [conformity-satisfaction-level] of people</metric>
    <metric>mean [risk-avoidance-satisfaction-level] of people</metric>
    <metric>mean [compliance-satisfaction-level] of people</metric>
    <metric>mean [belonging-satisfaction-level] of people</metric>
    <metric>mean [leisure-satisfaction-level] of people</metric>
    <metric>mean [luxury-satisfaction-level] of people</metric>
    <metric>mean [autonomy-satisfaction-level] of people</metric>
    <metric>mean [quality-of-life-indicator] of people</metric>
    <metric>median [quality-of-life-indicator] of people</metric>
    <metric>max [quality-of-life-indicator] of people</metric>
    <metric>min [quality-of-life-indicator] of people</metric>
    <enumeratedValueSet variable="set_national_culture">
      <value value="&quot;Netherlands&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-of-rations-in-non-essential-shops">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#max-people-per-bus">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="factor-reduction-probability-transmission-young">
      <value value="0.69"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="goods-produced-by-work-performed">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="preset-scenario">
      <value value="&quot;default-scenario&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-stock-of-goods-in-a-shop">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-private-leisure">
      <value value="0.19"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-getting-back-when-abroad">
      <value value="0.13"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="critical-to-terminal">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="with-infected?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="indulgence-vs-restraint">
      <value value="68"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="static-seed?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-of-users-of-the-tracking-app">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-non-essential-shops">
      <value value="0.52"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-school-subsidy">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="value-system-calibration-factor">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-self-recovery-symptoms">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-multi-generational-homes">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#households">
      <value value="400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="global-confinement-measures">
      <value value="&quot;none&quot;"/>
      <value value="&quot;total-lockdown&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-of-wage-paid-by-the-government">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-public-leisure">
      <value value="0.51"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#universities-gp">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="std-dev-social-distance-profile">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="value-std-dev">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="close-services-luxury?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#workplaces-gp">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="individualism-vs-collectivism">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-student-public-transport">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="uncertainty-avoidance">
      <value value="53"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-retired">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infection-to-asymptomatic-contagiousness">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-family-homes">
      <value value="0.23"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-hospital-personel">
      <value value="0.04"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="weight-survival-needs">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#bus-per-timeslot">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="migration?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masculinity-vs-femininity">
      <value value="14"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-of-rations-in-essential-shops">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="terminal-to-death">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percentage-news-watchers">
      <value value="0.76"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-closing-school-when-any-reported-case-measure?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-workplaces">
      <value value="0.55"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="owning-solo-transportation-probability">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-children-public-transport">
      <value value="0.75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="survival-multiplier">
      <value value="2.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-unavoidable-death-old">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-population-randomly-tested-daily">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="long-vs-short-termism">
      <value value="67"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-social-distance-profile">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-students">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retirees-subsidy">
      <value value="0.34"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-of-anxiety-avoidance-users">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-workers">
      <value value="75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="daily-risk-believe-experiencing-fake-symptoms">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="productivity-at-home">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-shared-car">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#essential-shops-gp">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#hospital-gp">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-worker-public-transport">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="make-social-distance-profile-value-based?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probably-contagion-mitigation-from-social-distancing">
      <value value="0.08"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-working-from-home-recommended?">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-non-essential-closing-measure">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-population-daily-immunity-testing">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-school-closing-measure">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="asympomatic-contagiousness-to-symptomatic-contagiousness">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-student-shared-car">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="test-workplace-of-confirmed-people?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-students-subsidy">
      <value value="0.34"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-hospital">
      <value value="0.81"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-social-distancing-measure">
      <value value="0"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maslow-multiplier">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#private-leisure-gp">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="days-of-rations-bought">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-schools">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-adults-homes">
      <value value="0.49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-unavoidable-death">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-hospital-subsidy">
      <value value="0.21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-shopkeeper">
      <value value="0.04"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="workers-wages">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-essential-shops">
      <value value="0.19"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-in-shared-cars">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-school-personel">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-workplaces">
      <value value="0.21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-worker-shared-car">
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-universities">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-going-abroad">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-university-subsidy">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-infection-when-abroad">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#beds-in-hospital">
      <value value="13"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-self-recovery-symptoms-old">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="power-distance">
      <value value="38"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-non-essential-shops">
      <value value="0.83"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peer-group-friend-links">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="import-scenario-name">
      <value value="&quot;output/done3.csv&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-essential-shops">
      <value value="0.52"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-children-shared-car">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="productivity-factor-when-not-at-work">
      <value value="0.79"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="unit-price-of-goods">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="network-generation-method">
      <value value="&quot;random&quot;"/>
      <value value="&quot;value-similarity&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="symptomatic-to-critical-or-heal">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-homes">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#public-leisure-gp">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#days-tracking">
      <value value="14"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-recorvery-if-treated-old">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#random-seed">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="propagation-risk">
      <value value="0.08"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="preset-profiles">
      <value value="&quot;scandinavia&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-travelling-propagation">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#schools-gp">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="closed-universities?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-initial-reserve-of-capital">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-pays-wages?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-workers">
      <value value="0.41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="animate?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-recorvery-if-treated">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-couple-homes">
      <value value="0.27"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percentage-of-agents-with-random-link">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="closed-workplaces?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#days-trigger-non-essential-business-closing-measure">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="test-home-of-confirmed-people?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#non-essential-shops-gp">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-when-queuing">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-public-transport">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-in-public-transport">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-university-personel">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#days-trigger-school-closing-measure">
      <value value="10000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="smart-testing" repetitions="30" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="600"/>
    <metric>count people with [is-infected?]</metric>
    <metric>#dead-people</metric>
    <metric>count people with [is-officially-asked-to-quarantine?]</metric>
    <metric>count people with [is-officially-asked-to-quarantine? and not is-in-quarantine?]</metric>
    <metric>#tests-performed</metric>
    <metric>r0</metric>
    <metric>#taken-hospital-beds</metric>
    <metric>#beds-available-for-admission</metric>
    <metric>hospital-effectiveness</metric>
    <enumeratedValueSet variable="prioritize-testing-education?">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritize-testing-health-care?">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-infected-and-their-families-requested-to-stay-at-home?">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="when-is-daily-testing-applied?">
      <value value="&quot;always&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="food-delivered-to-isolators?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="do-not-test-youth?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-test-retirees-with-extra-tests?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-population-randomly-tested-daily">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#available-tests">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#days-recording-tracking">
      <value value="14"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-of-rations-in-non-essential-shops">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#max-people-per-bus">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="factor-reduction-probability-transmission-young">
      <value value="0.69"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="goods-produced-by-work-performed">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="preset-scenario">
      <value value="&quot;scenario-9-smart-testing&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-stock-of-goods-in-a-shop">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-private-leisure">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="critical-to-terminal">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-getting-back-when-abroad">
      <value value="0.13"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="with-infected?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="indulgence-vs-restraint">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="static-seed?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="set_national_culture">
      <value value="&quot;Italy&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="all-self-isolate-for-35-days-when-first-hitting-2%-infected?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-non-essential-shops">
      <value value="0.52"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-school-subsidy">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="value-system-calibration-factor">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-self-recovery-symptoms">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-multi-generational-homes">
      <value value="0.049"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#households">
      <value value="345"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="global-confinement-measures">
      <value value="&quot;none&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-of-wage-paid-by-the-government">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-public-leisure">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#universities-gp">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="std-dev-social-distance-profile">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="value-std-dev">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="close-services-luxury?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#workplaces-gp">
      <value value="34"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="individualism-vs-collectivism">
      <value value="76"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-student-public-transport">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="uncertainty-avoidance">
      <value value="75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-retired">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infection-to-asymptomatic-contagiousness">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-family-homes">
      <value value="0.344"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-hospital-personel">
      <value value="0.026"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="debug?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-sector-subsidy-ratio">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="weight-survival-needs">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#bus-per-timeslot">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="migration?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masculinity-vs-femininity">
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="services-luxury-ratio-of-income-when-closed">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-of-rations-in-essential-shops">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="terminal-to-death">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-of-people-using-the-tracking-app">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percentage-news-watchers">
      <value value="0.76"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-closing-school-when-any-reported-case-measure?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-tracking-app-testing-immediately-recursive?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-workplaces">
      <value value="0.55"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="owning-solo-transportation-probability">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-children-public-transport">
      <value value="0.75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="survival-multiplier">
      <value value="2.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-unavoidable-death-old">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="long-vs-short-termism">
      <value value="61"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-fsm-model">
      <value value="&quot;oxford&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-social-distance-profile">
      <value value="0.29"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-students">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-with-phones">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retirees-subsidy">
      <value value="0.34"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-of-anxiety-avoidance-users">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-workers">
      <value value="75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="daily-risk-believe-experiencing-fake-symptoms">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="productivity-at-home">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-shared-car">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#essential-shops-gp">
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#hospital-gp">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-worker-public-transport">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="make-social-distance-profile-value-based?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probably-contagion-mitigation-from-social-distancing">
      <value value="0.08"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-working-from-home-recommended?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="when-is-tracing-app-active?">
      <value value="&quot;never&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="services-luxury-ratio-of-expenditures-when-closed">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="household-profiles">
      <value value="&quot;Italy&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-non-essential-closing-measure">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="interest-rate-by-tick">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-population-daily-immunity-testing">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="asympomatic-contagiousness-to-symptomatic-contagiousness">
      <value value="16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-school-closing-measure">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-student-shared-car">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="test-workplace-of-confirmed-people?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-students-subsidy">
      <value value="0.34"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-hospital">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-social-distancing-measure">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maslow-multiplier">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#private-leisure-gp">
      <value value="34"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="days-of-rations-bought">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-schools">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-adults-homes">
      <value value="0.309"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-unavoidable-death">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-hospital-subsidy">
      <value value="0.21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-self-quarantining-when-symptomatic">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-shopkeeper">
      <value value="0.04"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="workers-wages">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-essential-shops">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-in-shared-cars">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-school-personel">
      <value value="0.028"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-workplaces">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-worker-shared-car">
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-young-with-phones">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-universities">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-going-abroad">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-infection-when-abroad">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-university-subsidy">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#beds-in-hospital">
      <value value="2000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-self-recovery-symptoms-old">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="power-distance">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-non-essential-shops">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peer-group-friend-links">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-essential-shops">
      <value value="0.52"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-children-shared-car">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="productivity-factor-when-not-at-work">
      <value value="0.79"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="unit-price-of-goods">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="network-generation-method">
      <value value="&quot;value-similarity&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="symptomatic-to-critical-or-heal">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-homes">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#public-leisure-gp">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-recorvery-if-treated-old">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="propagation-risk">
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#random-seed">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-travelling-propagation">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#schools-gp">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="closed-universities?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-initial-reserve-of-capital">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-pays-wages?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-self-quarantining-when-a-family-member-is-symptomatic">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-workers">
      <value value="0.41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="animate?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-recorvery-if-treated">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-couple-homes">
      <value value="0.298"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percentage-of-agents-with-random-link">
      <value value="0.14"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="closed-workplaces?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#days-trigger-non-essential-business-closing-measure">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="test-home-of-confirmed-people?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#non-essential-shops-gp">
      <value value="34"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-public-transport">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-when-queuing">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-in-public-transport">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-university-personel">
      <value value="0.005"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#days-trigger-school-closing-measure">
      <value value="10000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="S7_1-social-distancing-tracking-tracing-testing-isolating" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>output-print (word "Execution of run " behaviorspace-run-number " finished in " timer " seconds")</final>
    <timeLimit steps="500"/>
    <metric>count people with [is-infected?]</metric>
    <metric>#dead-people</metric>
    <metric>#tests-performed</metric>
    <metric>r0</metric>
    <metric>count should-be-isolators with [current-activity != my-home and current-activity != my-hospital and current-activity != away-gathering-point]</metric>
    <metric>count should-be-isolators</metric>
    <metric>count people with [is-at-home?]</metric>
    <metric>count people with [is-working-at-home?]</metric>
    <metric>count people with [[is-school?] of current-activity]</metric>
    <metric>count people with [[is-hospital?] of current-activity]</metric>
    <metric>count people with [[is-university?] of current-activity = "university"]</metric>
    <metric>count people with [is-at-work?]</metric>
    <metric>count people with [[is-public-leisure?] of current-activity]</metric>
    <metric>count people with [[is-private-leisure?] of current-activity = "private-leisure"]</metric>
    <metric>count people with [[is-essential-shop?] of current-activity]</metric>
    <metric>count people with [[is-private-leisure?] of current-activity]</metric>
    <metric>mean [sleep-satisfaction-level] of people</metric>
    <metric>mean [conformity-satisfaction-level] of people</metric>
    <metric>mean [risk-avoidance-satisfaction-level] of people</metric>
    <metric>mean [compliance-satisfaction-level] of people</metric>
    <metric>mean [belonging-satisfaction-level] of people</metric>
    <metric>mean [leisure-satisfaction-level] of people</metric>
    <metric>mean [luxury-satisfaction-level] of people</metric>
    <metric>mean [autonomy-satisfaction-level] of people</metric>
    <metric>mean [quality-of-life-indicator] of people</metric>
    <enumeratedValueSet variable="set_national_culture">
      <value value="&quot;Korea South&quot;"/>
      <value value="&quot;Singapore&quot;"/>
      <value value="&quot;Germany&quot;"/>
      <value value="&quot;Italy&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritize-testing-education?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-of-rations-in-non-essential-shops">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#max-people-per-bus">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="factor-reduction-probability-transmission-young">
      <value value="0.69"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="goods-produced-by-work-performed">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="preset-scenario">
      <value value="&quot;scenario-7-cultural-model&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-stock-of-goods-in-a-shop">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-private-leisure">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="log-preferred-activity-decision?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="critical-to-terminal">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-getting-back-when-abroad">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-infected-and-their-families-requested-to-stay-at-home?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="log?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="with-infected?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="indulgence-vs-restraint">
      <value value="29"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="static-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-non-essential-shops">
      <value value="0.52"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="all-self-isolate-for-35-days-when-first-hitting-2%-infected?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-school-subsidy">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="value-system-calibration-factor">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-self-recovery-symptoms">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#households">
      <value value="400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-multi-generational-homes">
      <value value="0.054"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="global-confinement-measures">
      <value value="&quot;none&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-of-wage-paid-by-the-government">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-public-leisure">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#universities-gp">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="std-dev-social-distance-profile">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="value-std-dev">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="close-services-luxury?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#workplaces-gp">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="individualism-vs-collectivism">
      <value value="18"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-student-public-transport">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="uncertainty-avoidance">
      <value value="85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-retired">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infection-to-asymptomatic-contagiousness">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-family-homes">
      <value value="0.163"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-sector-subsidy-ratio">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-hospital-personel">
      <value value="0.04"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="weight-survival-needs">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#bus-per-timeslot">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="migration?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masculinity-vs-femininity">
      <value value="39"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="services-luxury-ratio-of-income-when-closed">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-of-rations-in-essential-shops">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="terminal-to-death">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-of-people-using-the-tracking-app">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percentage-news-watchers">
      <value value="0.75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-closing-school-when-any-reported-case-measure?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-tracking-app-testing-immediately-recursive?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-workplaces">
      <value value="0.55"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="food-delivered-to-isolators?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="owning-solo-transportation-probability">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-children-public-transport">
      <value value="0.75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="survival-multiplier">
      <value value="2.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-unavoidable-death-old">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-population-randomly-tested-daily">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="long-vs-short-termism">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-fsm-model">
      <value value="&quot;oxford&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-social-distance-profile">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-students">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-with-phones">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retirees-subsidy">
      <value value="0.34"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-workers">
      <value value="75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="daily-risk-believe-experiencing-fake-symptoms">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="productivity-at-home">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritize-testing-health-care?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-shared-car">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#essential-shops-gp">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="do-not-test-youth?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-worker-public-transport">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#hospital-gp">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="make-social-distance-profile-value-based?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probably-contagion-mitigation-from-social-distancing">
      <value value="0.08"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-psychorigidly-staying-at-home-when-quarantining?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-working-from-home-recommended?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="when-is-tracing-app-active?">
      <value value="&quot;always&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="interest-rate-by-tick">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="household-profiles">
      <value value="&quot;Korea South&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="services-luxury-ratio-of-expenditures-when-closed">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-non-essential-closing-measure">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-population-daily-immunity-testing">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="asympomatic-contagiousness-to-symptomatic-contagiousness">
      <value value="16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-school-closing-measure">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="test-workplace-of-confirmed-people?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-student-shared-car">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-students-subsidy">
      <value value="0.34"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-hospital">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-social-distancing-measure">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maslow-multiplier">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#private-leisure-gp">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="days-of-rations-bought">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-schools">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-adults-homes">
      <value value="0.352"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-unavoidable-death">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-hospital-subsidy">
      <value value="0.21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-self-quarantining-when-symptomatic">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-shopkeeper">
      <value value="0.04"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="workers-wages">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-essential-shops">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-in-shared-cars">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-school-personel">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-test-retirees-with-extra-tests?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-worker-shared-car">
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-workplaces">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-young-with-phones">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-universities">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-infection-when-abroad">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-going-abroad">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-university-subsidy">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="log-contamination?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#beds-in-hospital">
      <value value="13"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-self-recovery-symptoms-old">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="power-distance">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-non-essential-shops">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peer-group-friend-links">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-essential-shops">
      <value value="0.52"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-children-shared-car">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="unit-price-of-goods">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="network-generation-method">
      <value value="&quot;value-similarity&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="symptomatic-to-critical-or-heal">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-homes">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="when-is-daily-testing-applied?">
      <value value="&quot;always&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#public-leisure-gp">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-recorvery-if-treated-old">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#random-seed">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="propagation-risk">
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-travelling-propagation">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#available-tests">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#schools-gp">
      <value value="13"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="closed-universities?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-initial-reserve-of-capital">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-pays-wages?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-self-quarantining-when-a-family-member-is-symptomatic">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-workers">
      <value value="0.41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="animate?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-recorvery-if-treated">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-couple-homes">
      <value value="0.431"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percentage-of-agents-with-random-link">
      <value value="0.14"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="closed-workplaces?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#days-trigger-non-essential-business-closing-measure">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-of-anxiety-avoidance-tracing-app-users">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#days-recording-tracing">
      <value value="14"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="test-home-of-confirmed-people?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#non-essential-shops-gp">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-when-queuing">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-public-transport">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-in-public-transport">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-university-personel">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#days-trigger-school-closing-measure">
      <value value="10000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="S7_1-social-distancing-lockdown" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>output-print (word "Execution of run " behaviorspace-run-number " finished in " timer " seconds")</final>
    <timeLimit steps="500"/>
    <metric>count people with [is-infected?]</metric>
    <metric>#dead-people</metric>
    <metric>#tests-performed</metric>
    <metric>r0</metric>
    <metric>count should-be-isolators with [current-activity != my-home and current-activity != my-hospital and current-activity != away-gathering-point]</metric>
    <metric>count should-be-isolators</metric>
    <metric>count people with [is-at-home?]</metric>
    <metric>count people with [is-working-at-home?]</metric>
    <metric>count people with [[is-school?] of current-activity]</metric>
    <metric>count people with [[is-hospital?] of current-activity]</metric>
    <metric>count people with [[is-university?] of current-activity = "university"]</metric>
    <metric>count people with [is-at-work?]</metric>
    <metric>count people with [[is-public-leisure?] of current-activity]</metric>
    <metric>count people with [[is-private-leisure?] of current-activity = "private-leisure"]</metric>
    <metric>count people with [[is-essential-shop?] of current-activity]</metric>
    <metric>count people with [[is-private-leisure?] of current-activity]</metric>
    <metric>mean [sleep-satisfaction-level] of people</metric>
    <metric>mean [conformity-satisfaction-level] of people</metric>
    <metric>mean [risk-avoidance-satisfaction-level] of people</metric>
    <metric>mean [compliance-satisfaction-level] of people</metric>
    <metric>mean [belonging-satisfaction-level] of people</metric>
    <metric>mean [leisure-satisfaction-level] of people</metric>
    <metric>mean [luxury-satisfaction-level] of people</metric>
    <metric>mean [autonomy-satisfaction-level] of people</metric>
    <metric>mean [quality-of-life-indicator] of people</metric>
    <enumeratedValueSet variable="set_national_culture">
      <value value="&quot;Korea South&quot;"/>
      <value value="&quot;Singapore&quot;"/>
      <value value="&quot;Germany&quot;"/>
      <value value="&quot;Italy&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritize-testing-education?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-of-rations-in-non-essential-shops">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#max-people-per-bus">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="factor-reduction-probability-transmission-young">
      <value value="0.69"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="goods-produced-by-work-performed">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="preset-scenario">
      <value value="&quot;scenario-7-cultural-model&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-stock-of-goods-in-a-shop">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-private-leisure">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="log-preferred-activity-decision?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="critical-to-terminal">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-getting-back-when-abroad">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-infected-and-their-families-requested-to-stay-at-home?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="log?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="with-infected?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="indulgence-vs-restraint">
      <value value="29"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="static-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-non-essential-shops">
      <value value="0.52"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="all-self-isolate-for-35-days-when-first-hitting-2%-infected?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-school-subsidy">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="value-system-calibration-factor">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-self-recovery-symptoms">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#households">
      <value value="400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-multi-generational-homes">
      <value value="0.054"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="global-confinement-measures">
      <value value="&quot;total-lockdown&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-of-wage-paid-by-the-government">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-public-leisure">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#universities-gp">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="std-dev-social-distance-profile">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="value-std-dev">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="close-services-luxury?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#workplaces-gp">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="individualism-vs-collectivism">
      <value value="18"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-student-public-transport">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="uncertainty-avoidance">
      <value value="85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-retired">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infection-to-asymptomatic-contagiousness">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-family-homes">
      <value value="0.163"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-sector-subsidy-ratio">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-hospital-personel">
      <value value="0.04"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="weight-survival-needs">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#bus-per-timeslot">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="migration?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masculinity-vs-femininity">
      <value value="39"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="services-luxury-ratio-of-income-when-closed">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-of-rations-in-essential-shops">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="terminal-to-death">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-of-people-using-the-tracking-app">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percentage-news-watchers">
      <value value="0.75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-closing-school-when-any-reported-case-measure?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-tracking-app-testing-immediately-recursive?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-workplaces">
      <value value="0.55"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="food-delivered-to-isolators?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="owning-solo-transportation-probability">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-children-public-transport">
      <value value="0.75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="survival-multiplier">
      <value value="2.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-unavoidable-death-old">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-population-randomly-tested-daily">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="long-vs-short-termism">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-fsm-model">
      <value value="&quot;oxford&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-social-distance-profile">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-students">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-with-phones">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retirees-subsidy">
      <value value="0.34"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-workers">
      <value value="75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="daily-risk-believe-experiencing-fake-symptoms">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="productivity-at-home">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritize-testing-health-care?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-shared-car">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#essential-shops-gp">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="do-not-test-youth?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-worker-public-transport">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#hospital-gp">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="make-social-distance-profile-value-based?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probably-contagion-mitigation-from-social-distancing">
      <value value="0.08"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-psychorigidly-staying-at-home-when-quarantining?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-working-from-home-recommended?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="when-is-tracing-app-active?">
      <value value="&quot;never&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="interest-rate-by-tick">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="household-profiles">
      <value value="&quot;Korea South&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="services-luxury-ratio-of-expenditures-when-closed">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-non-essential-closing-measure">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-population-daily-immunity-testing">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="asympomatic-contagiousness-to-symptomatic-contagiousness">
      <value value="16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-school-closing-measure">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="test-workplace-of-confirmed-people?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-student-shared-car">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-students-subsidy">
      <value value="0.34"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-hospital">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-social-distancing-measure">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maslow-multiplier">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#private-leisure-gp">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="days-of-rations-bought">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-schools">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-adults-homes">
      <value value="0.352"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-unavoidable-death">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-hospital-subsidy">
      <value value="0.21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-self-quarantining-when-symptomatic">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-shopkeeper">
      <value value="0.04"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="workers-wages">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-essential-shops">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-in-shared-cars">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-school-personel">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-test-retirees-with-extra-tests?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-worker-shared-car">
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-workplaces">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-young-with-phones">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-universities">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-infection-when-abroad">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-going-abroad">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-university-subsidy">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="log-contamination?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#beds-in-hospital">
      <value value="13"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-self-recovery-symptoms-old">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="power-distance">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-non-essential-shops">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peer-group-friend-links">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-essential-shops">
      <value value="0.52"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-children-shared-car">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="unit-price-of-goods">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="network-generation-method">
      <value value="&quot;value-similarity&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="symptomatic-to-critical-or-heal">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-homes">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="when-is-daily-testing-applied?">
      <value value="&quot;never&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#public-leisure-gp">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-recorvery-if-treated-old">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#random-seed">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="propagation-risk">
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-travelling-propagation">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#available-tests">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#schools-gp">
      <value value="13"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="closed-universities?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-initial-reserve-of-capital">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-pays-wages?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-self-quarantining-when-a-family-member-is-symptomatic">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-workers">
      <value value="0.41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="animate?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-recorvery-if-treated">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-couple-homes">
      <value value="0.431"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percentage-of-agents-with-random-link">
      <value value="0.14"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="closed-workplaces?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#days-trigger-non-essential-business-closing-measure">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-of-anxiety-avoidance-tracing-app-users">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#days-recording-tracing">
      <value value="14"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="test-home-of-confirmed-people?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#non-essential-shops-gp">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-when-queuing">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-public-transport">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-in-public-transport">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-university-personel">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#days-trigger-school-closing-measure">
      <value value="10000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="S7_1-only-social-distancing" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>output-print (word "Execution of run " behaviorspace-run-number " finished in " timer " seconds")</final>
    <timeLimit steps="500"/>
    <metric>count people with [is-infected?]</metric>
    <metric>#dead-people</metric>
    <metric>#tests-performed</metric>
    <metric>r0</metric>
    <metric>count should-be-isolators with [current-activity != my-home and current-activity != my-hospital and current-activity != away-gathering-point]</metric>
    <metric>count should-be-isolators</metric>
    <metric>count people with [is-at-home?]</metric>
    <metric>count people with [is-working-at-home?]</metric>
    <metric>count people with [[is-school?] of current-activity]</metric>
    <metric>count people with [[is-hospital?] of current-activity]</metric>
    <metric>count people with [[is-university?] of current-activity = "university"]</metric>
    <metric>count people with [is-at-work?]</metric>
    <metric>count people with [[is-public-leisure?] of current-activity]</metric>
    <metric>count people with [[is-private-leisure?] of current-activity = "private-leisure"]</metric>
    <metric>count people with [[is-essential-shop?] of current-activity]</metric>
    <metric>count people with [[is-private-leisure?] of current-activity]</metric>
    <metric>mean [sleep-satisfaction-level] of people</metric>
    <metric>mean [conformity-satisfaction-level] of people</metric>
    <metric>mean [risk-avoidance-satisfaction-level] of people</metric>
    <metric>mean [compliance-satisfaction-level] of people</metric>
    <metric>mean [belonging-satisfaction-level] of people</metric>
    <metric>mean [leisure-satisfaction-level] of people</metric>
    <metric>mean [luxury-satisfaction-level] of people</metric>
    <metric>mean [autonomy-satisfaction-level] of people</metric>
    <metric>mean [quality-of-life-indicator] of people</metric>
    <enumeratedValueSet variable="set_national_culture">
      <value value="&quot;Korea South&quot;"/>
      <value value="&quot;Singapore&quot;"/>
      <value value="&quot;Germany&quot;"/>
      <value value="&quot;Italy&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritize-testing-education?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-of-rations-in-non-essential-shops">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#max-people-per-bus">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="factor-reduction-probability-transmission-young">
      <value value="0.69"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="goods-produced-by-work-performed">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="preset-scenario">
      <value value="&quot;scenario-7-cultural-model&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-stock-of-goods-in-a-shop">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-private-leisure">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="log-preferred-activity-decision?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="critical-to-terminal">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-getting-back-when-abroad">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-infected-and-their-families-requested-to-stay-at-home?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="log?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="with-infected?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="indulgence-vs-restraint">
      <value value="29"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="static-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-non-essential-shops">
      <value value="0.52"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="all-self-isolate-for-35-days-when-first-hitting-2%-infected?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-school-subsidy">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="value-system-calibration-factor">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-self-recovery-symptoms">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#households">
      <value value="400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-multi-generational-homes">
      <value value="0.054"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="global-confinement-measures">
      <value value="&quot;none&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-of-wage-paid-by-the-government">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-public-leisure">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#universities-gp">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="std-dev-social-distance-profile">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="value-std-dev">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="close-services-luxury?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#workplaces-gp">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="individualism-vs-collectivism">
      <value value="18"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-student-public-transport">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="uncertainty-avoidance">
      <value value="85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-retired">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infection-to-asymptomatic-contagiousness">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-family-homes">
      <value value="0.163"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-sector-subsidy-ratio">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-hospital-personel">
      <value value="0.04"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="weight-survival-needs">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#bus-per-timeslot">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="migration?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masculinity-vs-femininity">
      <value value="39"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="services-luxury-ratio-of-income-when-closed">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-of-rations-in-essential-shops">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="terminal-to-death">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-of-people-using-the-tracking-app">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percentage-news-watchers">
      <value value="0.75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-closing-school-when-any-reported-case-measure?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-tracking-app-testing-immediately-recursive?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-workplaces">
      <value value="0.55"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="food-delivered-to-isolators?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="owning-solo-transportation-probability">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-children-public-transport">
      <value value="0.75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="survival-multiplier">
      <value value="2.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-unavoidable-death-old">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-population-randomly-tested-daily">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="long-vs-short-termism">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-fsm-model">
      <value value="&quot;oxford&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-social-distance-profile">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-students">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-with-phones">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retirees-subsidy">
      <value value="0.34"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-workers">
      <value value="75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="daily-risk-believe-experiencing-fake-symptoms">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="productivity-at-home">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritize-testing-health-care?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-shared-car">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#essential-shops-gp">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="do-not-test-youth?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-worker-public-transport">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#hospital-gp">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="make-social-distance-profile-value-based?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probably-contagion-mitigation-from-social-distancing">
      <value value="0.08"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-psychorigidly-staying-at-home-when-quarantining?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-working-from-home-recommended?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="when-is-tracing-app-active?">
      <value value="&quot;never&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="interest-rate-by-tick">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="household-profiles">
      <value value="&quot;Korea South&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="services-luxury-ratio-of-expenditures-when-closed">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-non-essential-closing-measure">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-population-daily-immunity-testing">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="asympomatic-contagiousness-to-symptomatic-contagiousness">
      <value value="16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-school-closing-measure">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="test-workplace-of-confirmed-people?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-student-shared-car">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-students-subsidy">
      <value value="0.34"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-hospital">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-social-distancing-measure">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maslow-multiplier">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#private-leisure-gp">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="days-of-rations-bought">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-schools">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-adults-homes">
      <value value="0.352"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-unavoidable-death">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-hospital-subsidy">
      <value value="0.21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-self-quarantining-when-symptomatic">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-shopkeeper">
      <value value="0.04"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="workers-wages">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-essential-shops">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-in-shared-cars">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-school-personel">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-test-retirees-with-extra-tests?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-worker-shared-car">
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-workplaces">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-young-with-phones">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-universities">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-infection-when-abroad">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-going-abroad">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-university-subsidy">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="log-contamination?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#beds-in-hospital">
      <value value="13"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-self-recovery-symptoms-old">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="power-distance">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-non-essential-shops">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peer-group-friend-links">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-essential-shops">
      <value value="0.52"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-children-shared-car">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="unit-price-of-goods">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="network-generation-method">
      <value value="&quot;value-similarity&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="symptomatic-to-critical-or-heal">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-homes">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="when-is-daily-testing-applied?">
      <value value="&quot;never&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#public-leisure-gp">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-recorvery-if-treated-old">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#random-seed">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="propagation-risk">
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-travelling-propagation">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#available-tests">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#schools-gp">
      <value value="13"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="closed-universities?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-initial-reserve-of-capital">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-pays-wages?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-self-quarantining-when-a-family-member-is-symptomatic">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-workers">
      <value value="0.41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="animate?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-recorvery-if-treated">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-couple-homes">
      <value value="0.431"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percentage-of-agents-with-random-link">
      <value value="0.14"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="closed-workplaces?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#days-trigger-non-essential-business-closing-measure">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-of-anxiety-avoidance-tracing-app-users">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#days-recording-tracing">
      <value value="14"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="test-home-of-confirmed-people?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#non-essential-shops-gp">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-when-queuing">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-public-transport">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-in-public-transport">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-university-personel">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#days-trigger-school-closing-measure">
      <value value="10000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="S7_1-no-public-measures" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>output-print (word "Execution of run " behaviorspace-run-number " finished in " timer " seconds")</final>
    <timeLimit steps="500"/>
    <metric>count people with [is-infected?]</metric>
    <metric>#dead-people</metric>
    <metric>#tests-performed</metric>
    <metric>r0</metric>
    <metric>count should-be-isolators with [current-activity != my-home and current-activity != my-hospital and current-activity != away-gathering-point]</metric>
    <metric>count should-be-isolators</metric>
    <metric>count people with [is-at-home?]</metric>
    <metric>count people with [is-working-at-home?]</metric>
    <metric>count people with [[is-school?] of current-activity]</metric>
    <metric>count people with [[is-hospital?] of current-activity]</metric>
    <metric>count people with [[is-university?] of current-activity = "university"]</metric>
    <metric>count people with [is-at-work?]</metric>
    <metric>count people with [[is-public-leisure?] of current-activity]</metric>
    <metric>count people with [[is-private-leisure?] of current-activity = "private-leisure"]</metric>
    <metric>count people with [[is-essential-shop?] of current-activity]</metric>
    <metric>count people with [[is-private-leisure?] of current-activity]</metric>
    <metric>mean [sleep-satisfaction-level] of people</metric>
    <metric>mean [conformity-satisfaction-level] of people</metric>
    <metric>mean [risk-avoidance-satisfaction-level] of people</metric>
    <metric>mean [compliance-satisfaction-level] of people</metric>
    <metric>mean [belonging-satisfaction-level] of people</metric>
    <metric>mean [leisure-satisfaction-level] of people</metric>
    <metric>mean [luxury-satisfaction-level] of people</metric>
    <metric>mean [autonomy-satisfaction-level] of people</metric>
    <metric>mean [quality-of-life-indicator] of people</metric>
    <enumeratedValueSet variable="set_national_culture">
      <value value="&quot;Korea South&quot;"/>
      <value value="&quot;Singapore&quot;"/>
      <value value="&quot;Germany&quot;"/>
      <value value="&quot;Italy&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritize-testing-education?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-of-rations-in-non-essential-shops">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#max-people-per-bus">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="factor-reduction-probability-transmission-young">
      <value value="0.69"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="goods-produced-by-work-performed">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="preset-scenario">
      <value value="&quot;scenario-7-cultural-model&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-stock-of-goods-in-a-shop">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-private-leisure">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="log-preferred-activity-decision?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="critical-to-terminal">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-getting-back-when-abroad">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-infected-and-their-families-requested-to-stay-at-home?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="log?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="with-infected?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="indulgence-vs-restraint">
      <value value="29"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="static-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-non-essential-shops">
      <value value="0.52"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="all-self-isolate-for-35-days-when-first-hitting-2%-infected?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-school-subsidy">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="value-system-calibration-factor">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-self-recovery-symptoms">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#households">
      <value value="400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-multi-generational-homes">
      <value value="0.054"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="global-confinement-measures">
      <value value="&quot;none&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-of-wage-paid-by-the-government">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-public-leisure">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#universities-gp">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="std-dev-social-distance-profile">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="value-std-dev">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="close-services-luxury?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#workplaces-gp">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="individualism-vs-collectivism">
      <value value="18"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-student-public-transport">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="uncertainty-avoidance">
      <value value="85"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-retired">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infection-to-asymptomatic-contagiousness">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-family-homes">
      <value value="0.163"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-sector-subsidy-ratio">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-hospital-personel">
      <value value="0.04"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="weight-survival-needs">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#bus-per-timeslot">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="migration?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masculinity-vs-femininity">
      <value value="39"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="services-luxury-ratio-of-income-when-closed">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-of-rations-in-essential-shops">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="terminal-to-death">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-of-people-using-the-tracking-app">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percentage-news-watchers">
      <value value="0.75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-closing-school-when-any-reported-case-measure?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-tracking-app-testing-immediately-recursive?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-workplaces">
      <value value="0.55"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="food-delivered-to-isolators?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="owning-solo-transportation-probability">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-children-public-transport">
      <value value="0.75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="survival-multiplier">
      <value value="2.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-unavoidable-death-old">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-population-randomly-tested-daily">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="long-vs-short-termism">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-fsm-model">
      <value value="&quot;oxford&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-social-distance-profile">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-students">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-with-phones">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retirees-subsidy">
      <value value="0.34"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-workers">
      <value value="75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="daily-risk-believe-experiencing-fake-symptoms">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="productivity-at-home">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritize-testing-health-care?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-shared-car">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#essential-shops-gp">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="do-not-test-youth?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-worker-public-transport">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#hospital-gp">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="make-social-distance-profile-value-based?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probably-contagion-mitigation-from-social-distancing">
      <value value="0.08"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-psychorigidly-staying-at-home-when-quarantining?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-working-from-home-recommended?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="when-is-tracing-app-active?">
      <value value="&quot;never&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="interest-rate-by-tick">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="household-profiles">
      <value value="&quot;Korea South&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="services-luxury-ratio-of-expenditures-when-closed">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-non-essential-closing-measure">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-population-daily-immunity-testing">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="asympomatic-contagiousness-to-symptomatic-contagiousness">
      <value value="16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-school-closing-measure">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="test-workplace-of-confirmed-people?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-student-shared-car">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-students-subsidy">
      <value value="0.34"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-hospital">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-social-distancing-measure">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maslow-multiplier">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#private-leisure-gp">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="days-of-rations-bought">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-schools">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-adults-homes">
      <value value="0.352"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-unavoidable-death">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-hospital-subsidy">
      <value value="0.21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-self-quarantining-when-symptomatic">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-shopkeeper">
      <value value="0.04"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="workers-wages">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-essential-shops">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-in-shared-cars">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-school-personel">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-test-retirees-with-extra-tests?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-worker-shared-car">
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-workplaces">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-young-with-phones">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-universities">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-infection-when-abroad">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-going-abroad">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-university-subsidy">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="log-contamination?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#beds-in-hospital">
      <value value="13"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-self-recovery-symptoms-old">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="power-distance">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-non-essential-shops">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peer-group-friend-links">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-essential-shops">
      <value value="0.52"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-children-shared-car">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="unit-price-of-goods">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="network-generation-method">
      <value value="&quot;value-similarity&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="symptomatic-to-critical-or-heal">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-homes">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="when-is-daily-testing-applied?">
      <value value="&quot;never&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#public-leisure-gp">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-recorvery-if-treated-old">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#random-seed">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="propagation-risk">
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-travelling-propagation">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#available-tests">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#schools-gp">
      <value value="13"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="closed-universities?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-initial-reserve-of-capital">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-pays-wages?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-self-quarantining-when-a-family-member-is-symptomatic">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-workers">
      <value value="0.41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="animate?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-recorvery-if-treated">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-couple-homes">
      <value value="0.431"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percentage-of-agents-with-random-link">
      <value value="0.14"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="closed-workplaces?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#days-trigger-non-essential-business-closing-measure">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-of-anxiety-avoidance-tracing-app-users">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#days-recording-tracing">
      <value value="14"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="test-home-of-confirmed-people?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#non-essential-shops-gp">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-when-queuing">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-public-transport">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-in-public-transport">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-university-personel">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#days-trigger-school-closing-measure">
      <value value="10000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="S6" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="500"/>
    <metric>#infected</metric>
    <metric>count people with [epistemic-infection-status = "infected"]</metric>
    <metric>#admissions-last-tick</metric>
    <metric>#taken-hospital-beds</metric>
    <metric>#denied-requests-for-hospital-beds</metric>
    <metric>#dead-people</metric>
    <metric>#tests-performed</metric>
    <metric>r0</metric>
    <metric>count should-be-isolators</metric>
    <metric>count should-be-isolators with [current-activity != my-home and current-activity != my-hospital and current-activity != away-gathering-point]</metric>
    <metric>#contacts-last-tick</metric>
    <metric>#people-infected-in-hospitals</metric>
    <metric>#people-infected-in-workplaces</metric>
    <metric>#people-infected-in-homes</metric>
    <metric>#people-infected-in-public-leisure</metric>
    <metric>#people-infected-in-private-leisure</metric>
    <metric>#people-infected-in-schools</metric>
    <metric>#people-infected-in-universities</metric>
    <metric>#people-infected-in-essential-shops</metric>
    <metric>#people-infected-in-non-essential-shops</metric>
    <metric>#people-infected-in-pubtrans</metric>
    <metric>#people-infected-in-shared-cars</metric>
    <metric>#people-infected-in-queuing</metric>
    <metric>#contacts-in-pubtrans</metric>
    <metric>#contacts-in-shared-cars</metric>
    <metric>#contacts-in-queuing</metric>
    <metric>#contacts-in-pubtrans</metric>
    <metric>#contacts-in-hospitals</metric>
    <metric>#contacts-in-workplaces</metric>
    <metric>#contacts-in-homes</metric>
    <metric>#contacts-in-public-leisure</metric>
    <metric>#contacts-in-private-leisure</metric>
    <metric>#contacts-in-schools</metric>
    <metric>#contacts-in-universities</metric>
    <metric>#contacts-in-essential-shops</metric>
    <metric>#contacts-in-non-essential-shops</metric>
    <metric>#cumulative-youngs-infected</metric>
    <metric>#cumulative-students-infected</metric>
    <metric>#cumulative-workers-infected</metric>
    <metric>#cumulative-retireds-infected</metric>
    <metric>#cumulative-youngs-infector</metric>
    <metric>#cumulative-students-infector</metric>
    <metric>#cumulative-workers-infector</metric>
    <metric>#cumulative-retireds-infector</metric>
    <metric>ratio-quarantiners-currently-complying-to-quarantine</metric>
    <metric>ratio-infected-youngs</metric>
    <metric>ratio-infected-students</metric>
    <metric>ratio-infected-workers</metric>
    <metric>ratio-infected-retireds</metric>
    <metric>#hospitalizations-youngs-this-tick</metric>
    <metric>#hospitalizations-students-this-tick</metric>
    <metric>#hospitalizations-workers-this-tick</metric>
    <metric>#hospitalizations-retired-this-tick</metric>
    <metric>ratio-young-contaminated-by-young</metric>
    <metric>ratio-young-contaminated-by-workers</metric>
    <metric>ratio-young-contaminated-by-students</metric>
    <metric>ratio-young-contaminated-by-retireds</metric>
    <metric>ratio-workers-contaminated-by-young</metric>
    <metric>ratio-workers-contaminated-by-workers</metric>
    <metric>ratio-workers-contaminated-by-students</metric>
    <metric>ratio-workers-contaminated-by-retireds</metric>
    <metric>ratio-students-contaminated-by-young</metric>
    <metric>ratio-students-contaminated-by-workers</metric>
    <metric>ratio-students-contaminated-by-students</metric>
    <metric>ratio-students-contaminated-by-retireds</metric>
    <metric>ratio-retireds-contaminated-by-young</metric>
    <metric>ratio-retireds-contaminated-by-workers</metric>
    <metric>ratio-retireds-contaminated-by-students</metric>
    <metric>ratio-retireds-contaminated-by-retireds</metric>
    <enumeratedValueSet variable="ratio-of-anxiety-avoidance-tracing-app-users">
      <value value="0"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-of-people-using-the-tracking-app">
      <value value="0"/>
      <value value="0.6"/>
      <value value="0.9"/>
    </enumeratedValueSet>
    <steppedValueSet variable="#random-seed" first="1" step="1" last="5"/>
    <enumeratedValueSet variable="prioritize-testing-education?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-of-rations-in-non-essential-shops">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#max-people-per-bus">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="factor-reduction-probability-transmission-young">
      <value value="0.69"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="goods-produced-by-work-performed">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="preset-scenario">
      <value value="&quot;scenario-6-default&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-stock-of-goods-in-a-shop">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-private-leisure">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="log-preferred-activity-decision?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-getting-back-when-abroad">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="critical-to-terminal">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-infected-and-their-families-requested-to-stay-at-home?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="log?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="with-infected?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="indulgence-vs-restraint">
      <value value="69"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="static-seed?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="set_national_culture">
      <value value="&quot;Great Britain&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="all-self-isolate-for-35-days-when-first-hitting-2%-infected?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-non-essential-shops">
      <value value="0.52"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-school-subsidy">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="value-system-calibration-factor">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-self-recovery-symptoms">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-multi-generational-homes">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#households">
      <value value="391"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="global-confinement-measures">
      <value value="&quot;none&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-of-wage-paid-by-the-government">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-public-leisure">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#universities-gp">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="std-dev-social-distance-profile">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="value-std-dev">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="close-services-luxury?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#workplaces-gp">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="individualism-vs-collectivism">
      <value value="89"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-student-public-transport">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="uncertainty-avoidance">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-retired">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="clear-log-on-setup?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infection-to-asymptomatic-contagiousness">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-family-homes">
      <value value="0.27"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="financial-safety-learning-rate">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-hospital-personel">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-sector-subsidy-ratio">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="weight-survival-needs">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#bus-per-timeslot">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="migration?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masculinity-vs-femininity">
      <value value="66"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="services-luxury-ratio-of-income-when-closed">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-of-rations-in-essential-shops">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="terminal-to-death">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-closing-school-when-any-reported-case-measure?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percentage-news-watchers">
      <value value="0.75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-tracking-app-testing-immediately-recursive?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-workplaces">
      <value value="0.55"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="food-delivered-to-isolators?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="owning-solo-transportation-probability">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="log-setup?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-children-public-transport">
      <value value="0.75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="survival-multiplier">
      <value value="2.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-unavoidable-death-old">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-population-randomly-tested-daily">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="long-vs-short-termism">
      <value value="51"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-fsm-model">
      <value value="&quot;oxford&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-social-distance-profile">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-students">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-with-phones">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retirees-subsidy">
      <value value="0.34"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="starting-amount-of-capital-workers">
      <value value="75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="daily-risk-believe-experiencing-fake-symptoms">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="productivity-at-home">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prioritize-testing-health-care?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-shared-car">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#essential-shops-gp">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="do-not-test-youth?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#hospital-gp">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-worker-public-transport">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="make-social-distance-profile-value-based?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probably-contagion-mitigation-from-social-distancing">
      <value value="0.08"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-psychorigidly-staying-at-home-when-quarantining?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="is-working-from-home-recommended?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="when-is-tracing-app-active?">
      <value value="&quot;7-days-before-end-of-global-quarantine&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="services-luxury-ratio-of-expenditures-when-closed">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-non-essential-closing-measure">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="household-profiles">
      <value value="&quot;custom&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="interest-rate-by-tick">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-population-daily-immunity-testing">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="asympomatic-contagiousness-to-symptomatic-contagiousness">
      <value value="16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-school-closing-measure">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="test-workplace-of-confirmed-people?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-student-shared-car">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-students-subsidy">
      <value value="0.34"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-hospital">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-omniscious-infected-that-trigger-social-distancing-measure">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="maslow-multiplier">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#private-leisure-gp">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="days-of-rations-bought">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-schools">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-adults-homes">
      <value value="0.38"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-unavoidable-death">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-hospital-subsidy">
      <value value="0.21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-self-quarantining-when-symptomatic">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-shopkeeper">
      <value value="0.04"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="workers-wages">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-essential-shops">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-in-shared-cars">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-school-personel">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-workplaces">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-worker-shared-car">
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="only-test-retirees-with-extra-tests?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-young-with-phones">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-universities">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-university-subsidy">
      <value value="0.03"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-infection-when-abroad">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-going-abroad">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="log-contamination?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#beds-in-hospital">
      <value value="2000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-self-recovery-symptoms-old">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="power-distance">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-non-essential-shops">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="peer-group-friend-links">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-essential-shops">
      <value value="0.52"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-children-shared-car">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="unit-price-of-goods">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="network-generation-method">
      <value value="&quot;value-similarity&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="symptomatic-to-critical-or-heal">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-factor-homes">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="when-is-daily-testing-applied?">
      <value value="&quot;never&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#public-leisure-gp">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-recorvery-if-treated-old">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="propagation-risk">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-travelling-propagation">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#available-tests">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#schools-gp">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="closed-universities?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-initial-reserve-of-capital">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-pays-wages?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-self-quarantining-when-a-family-member-is-symptomatic">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-tax-on-workers">
      <value value="0.41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="animate?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-recorvery-if-treated">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-couple-homes">
      <value value="0.35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percentage-of-agents-with-random-link">
      <value value="0.14"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="closed-workplaces?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#days-trigger-non-essential-business-closing-measure">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#days-recording-tracing">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="test-home-of-confirmed-people?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#non-essential-shops-gp">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ratio-retired-public-transport">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-when-queuing">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density-in-public-transport">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-university-personel">
      <value value="0.04"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#days-trigger-school-closing-measure">
      <value value="10000"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
