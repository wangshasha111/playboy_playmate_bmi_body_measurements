
version 15.1
set scheme s1color
clear all
set more off
set maxvar 20000

timer on 1


local thisfile "11_playmate"
global with_weight = 1

global AVZ	"/Users/wss2023/Dropbox/stata/playmate"
global MY_IN_PATH "$AVZ/data/"
global MY_DO_FILES "$AVZ/do/"
global MY_OUT_LOG "$AVZ/log/"
global MY_OUT_DATA "$AVZ/output/"
global MY_OUT_TEMP "$AVZ/temp/"

cap log close
log using "${MY_OUT_LOG}`thisfile'", replace	

import delimited ${MY_IN_PATH}clean_shasha_1702_Infoporn_Playmate_Data.csv

rename ïmonth month
gen waist2bust = waist/bust


label var month "month"
label var year "year"
label var bust "bust (in)"
label var cupsize "cup size"
label var waist "waist (in)"
label var hips "hips (in)"
label var height "height (in)"
label var weight "weight (lbs)"
label var bmi "BMI"
label var waist2hip "waist-to-hip ratio"
label var waist2bust "waist-to-bust ratio"
label var model_of_the_year "1 = model of the year"

//drop if weight > 200

save ${MY_OUT_DATA}playmate.dta, replace

//mean(bmi), over(year)
//mat temp = r(table)

//twoway qfitci bmi year || scatter bmi year


/**********************************************************************/
/*  SECTION 1: mean plotting  			
    Notes: */
/**********************************************************************/

 
/*----------------------------------------------------*/
   /* [>   1.  bmi, height, weight   <] */ 
/*----------------------------------------------------*/

/* [> I wanted to overlay median on the same graph. But it's too messy. I dropped it <] */ 
/* collapse (median) bust_med = bust ///
					cupsize_med = cupsize ///
					waist_med = waist ///
					hips_med = hips ///
					height_med = height ///
					weight_med = weight ///
					bmi_med = bmi ///
					waist2hip_med = waist2hip ///
					waist2bust_med = waist2bust ///
					,by(year)
save ${MY_OUT_DATA}playmate_median.dta, replace */

/* use ${MY_OUT_DATA}playmate.dta, clear
statsby mean=r(mean) ub=r(ub) lb=r(lb) se=r(se) N=r(N) if year ~= 2021, by(year): ci means bmi
merge 1:1 year using ${MY_OUT_DATA}playmate_median.dta
keep if _merge == 3
twoway ///
(rcap lb ub year, vert) /// code for 95% CI
(scatter mean year, mcolor(red) msize(tiny)) /// dot for group 1
(scatter bmi_med year, mcolor(blue) msize(small) msymbol(diamond_hollow)) /// dot for group 1
, legend(row(1) order(2 "mean" 3 "median") pos(6)) /// legend at 6 o’clock position
xlabel(1953 1960(10)2020, angle(45) /* noticks */ /* grid */) ///
/// ylabel(,/* noticks */ grid) ///
title("BMI") ///
xtitle("") ///
ytitle("BMI") ///
aspect(.5) ///
name(g_ci_bmi,replace)  */


use ${MY_OUT_DATA}playmate.dta, clear
statsby mean=r(mean) ub=r(ub) lb=r(lb) se=r(se) N=r(N) if year ~= 2021, by(year): ci means bmi
twoway ///
(rcap lb ub year, vert) /// code for 95% CI
(scatter mean year, mcolor(red) msize(tiny)) /// dot for group 1
, legend(row(1) order(2 "BMI") pos(6)) /// legend at 6 o’clock position
xlabel(1953 1960(10)2020, angle(45) /* noticks */ /* grid */) ///
/// ylabel(,/* noticks */ grid) ///
title("BMI") ///
xtitle("") ///
ytitle("BMI") ///
aspect(.5) ///
name(g_ci_bmi,replace) 



/* use ${MY_OUT_DATA}playmate.dta, clear
statsby mean=r(mean) ub=r(ub) lb=r(lb) se=r(se) N=r(N) if year ~= 2021, by(year): ci means height
merge 1:1 year using ${MY_OUT_DATA}playmate_median.dta
keep if _merge == 3
twoway ///
(rcap lb ub year, vert) /// code for 95% CI
(scatter mean year, mcolor(red) msize(tiny)) /// dot for group 1
(scatter height_med year, mcolor(blue) msize(small) msymbol(diamond_hollow)) /// dot for group 1
, legend(row(1) order(2 "mean" 3 "median") pos(6)) /// legend at 6 o’clock position
xlabel(1953 1960(10)2020, angle(45) /* noticks */ /* grid */) ///
/// ylabel(,/* noticks */ grid) ///
title("Height") ///
xtitle("") ///
ytitle("height (in)") ///
aspect(.5) ///
name(g_ci_height,replace)  */




use ${MY_OUT_DATA}playmate.dta, clear
statsby mean=r(mean) ub=r(ub) lb=r(lb) se=r(se) N=r(N) if year ~= 2021, by(year): ci means height
twoway ///
(rcap lb ub year, vert) /// code for 95% CI
(scatter mean year, mcolor(red) msize(tiny)) /// dot for group 1
, legend(row(1) order(2 "height (in)") pos(6)) /// legend at 6 o’clock position
xlabel(1953 1960(10)2020, angle(45) /* noticks */ /* grid */) ///
/// ylabel(,/* noticks */ grid) ///
title("Height") ///
xtitle("") ///
ytitle("height (in)") ///
aspect(.5) ///
name(g_ci_height,replace) 

use ${MY_OUT_DATA}playmate.dta, clear
statsby mean=r(mean) ub=r(ub) lb=r(lb) se=r(se) N=r(N) if year ~= 2021, by(year): ci means weight
twoway ///
(rcap lb ub year, vert) /// code for 95% CI
(scatter mean year, mcolor(red) msize(tiny)) /// dot for group 1
, legend(row(1) order(2 "weight (lbs)") pos(6)) /// legend at 6 o’clock position
xlabel(1953 1960(10)2020, angle(45) /* noticks */ /* grid */) ///
/// ylabel(,/* noticks */ grid) ///
title("Weight") ///
xtitle("") ///
ytitle("weight (lbs)") ///
aspect(.5) ///
name(g_ci_weight,replace) 
graph combine g_ci_bmi g_ci_height g_ci_weight, col(3) xsize(20) ysize(8) iscale(1) name(playmate_bmi_height_weight, replace)
graph export ${MY_OUT_DATA}playmate_bmi_height_weight.png,replace width(4000)


/*----------------------------------------------------*/
   /* [>   2. bust, waist, hips   <] */ 
/*----------------------------------------------------*/

use ${MY_OUT_DATA}playmate.dta, clear
statsby mean=r(mean) ub=r(ub) lb=r(lb) se=r(se) N=r(N) if year ~= 2021, by(year): ci means bust
twoway ///
(rcap lb ub year, vert) /// code for 95% CI
(scatter mean year, mcolor(red) msize(tiny)) /// dot for group 1
, legend(row(1) order(2 "bust (in)") pos(6)) /// legend at 6 o’clock position
xlabel(1953 1960(10)2020, angle(45) /* noticks */) ///
title("Bust") ///
xtitle("") ///
ytitle("bust (in)") ///
aspect(.5) ///
name(g_ci_bust,replace) 

use ${MY_OUT_DATA}playmate.dta, clear
statsby mean=r(mean) ub=r(ub) lb=r(lb) se=r(se) N=r(N) if year ~= 2021, by(year): ci means waist
twoway ///
(rcap lb ub year, vert) /// code for 95% CI
(scatter mean year, mcolor(red) msize(tiny)) /// dot for group 1
, legend(row(1) order(2 "waist (in)") pos(6)) /// legend at 6 o’clock position
xlabel(1953 1960(10)2020, angle(45) /* noticks */) ///
title("Waist") ///
xtitle("") ///
ytitle("waist (in)") ///
aspect(.5) ///
name(g_ci_waist,replace) 

use ${MY_OUT_DATA}playmate.dta, clear
statsby mean=r(mean) ub=r(ub) lb=r(lb) se=r(se) N=r(N) if year ~= 2021, by(year): ci means hips
twoway ///
(rcap lb ub year, vert) /// code for 95% CI
(scatter mean year, mcolor(red) msize(tiny)) /// dot for group 1
, legend(row(1) order(2 "hips (in)") pos(6)) /// legend at 6 o’clock position
xlabel(1953 1960(10)2020, angle(45) /* noticks */) ///
title("Hips") ///
xtitle("") ///
ytitle("hips (in)") ///
aspect(.5) ///
name(g_ci_hips,replace) 

graph combine g_ci_bust g_ci_waist g_ci_hips, col(3) xsize(20) ysize(8) iscale(1) name(playmate_measurement, replace)
graph export ${MY_OUT_DATA}playmate_measurement.png,replace width(4000)


 
/*----------------------------------------------------*/
   /* [>   3.  ratio   <] */ 
/*----------------------------------------------------*/

use ${MY_OUT_DATA}playmate.dta, clear
statsby mean=r(mean) ub=r(ub) lb=r(lb) se=r(se) N=r(N) if year ~= 2021, by(year): ci means cupsize
twoway ///
(rcap lb ub year, vert) /// code for 95% CI
(scatter mean year, mcolor(red) msize(tiny)) /// dot for group 1
, legend(row(1) order(2 "cupsize") pos(6)) /// legend at 6 o’clock position
xlabel(1953 1960(10)2020, angle(45) /* noticks */) ///
title("Cupsize") ///
xtitle("") ///
ytitle("cupsize (A=1 to F=6)") ///
aspect(.5) ///
name(g_ci_cupsize,replace) 


use ${MY_OUT_DATA}playmate.dta, clear
statsby mean=r(mean) ub=r(ub) lb=r(lb) se=r(se) N=r(N) if year ~= 2021, by(year): ci means waist2bust
twoway ///
(rcap lb ub year, vert) /// code for 95% CI
(scatter mean year, mcolor(red) msize(tiny)) /// dot for group 1
, legend(row(1) order(2 "waist/bust") pos(6)) /// legend at 6 o’clock position
xlabel(1953 1960(10)2020, angle(45) /* noticks */) ///
title("Waist-to-Bust Ratio") ///
xtitle("") ///
ytitle("waist/bust") ///
aspect(.5) ///
name(g_ci_waist2bust,replace) 


use ${MY_OUT_DATA}playmate.dta, clear
statsby mean=r(mean) ub=r(ub) lb=r(lb) se=r(se) N=r(N) if year ~= 2021, by(year): ci means waist2hip
twoway ///
(rcap lb ub year, vert) /// code for 95% CI
(scatter mean year, mcolor(red) msize(tiny)) /// dot for group 1
, legend(row(1) order(2 "waist/hip") pos(6)) /// legend at 6 o’clock position
xlabel(1953 1960(10)2020, angle(45) /* noticks */) ///
title("Waist-to-Hip Ratio") ///
xtitle("") ///
ytitle("waist/hip") ///
aspect(.5) ///
name(g_ci_waist2hips,replace) 

graph combine g_ci_cupsize g_ci_waist2bust g_ci_waist2hips, col(3) xsize(20) ysize(8) iscale(1) name(playmate_ratio, replace)
graph export ${MY_OUT_DATA}playmate_ratio.png,replace width(4000)


/**********************************************************************/
/*  SECTION 2: fit curve plotting  			
    Notes: */
/**********************************************************************/
	

//twoway qfitci bmi year, ysc(r(14 25)) || scatter bmi year, msize(tiny) mcolor(pink%20) jitter(1) ysc(r(14 25)) ytitle("BMI") name(g1, replace) //nodraw
twoway qfitci bmi year, stdf || scatter bmi year if inrange(bmi, 14, 30),  ///
	msize(tiny) mcolor(pink%20) jitter(2) ytitle("BMI") title("BMI") xtitle("") ///
	name(g1, replace) //nodraw
twoway qfitci height year, stdf || scatter height year, ///
	msize(tiny) mcolor(pink%20) jitter(2) ytitle("height (in)") title("Height") xtitle("") ///
	name(g2, replace) //nodraw  
twoway qfitci weight year, stdf || scatter weight year if inrange(weight,85, 160), ///
	msize(tiny) mcolor(pink%20) jitter(2) ytitle("weight (lbs)") title("Weight") xtitle("") ///
	name(g3, replace) //nodraw  
graph combine g1 g2 g3, col(3) xsize(20) ysize(8) iscale(1) name(g123, replace)
graph export ${MY_OUT_DATA}playmate_fit_bmi_height_weight.png,replace width(4000)


twoway qfitci bust year, stdf || scatter bust year,  ///
	msize(tiny) mcolor(pink%20) jitter(2) ytitle("bust (in)") title("Bust") xtitle("") ///
	name(g4, replace) //nodraw
twoway qfitci waist year, stdf || scatter waist year /* if inrange(waist, 15, 30) */, ///
	msize(tiny) mcolor(pink%20) jitter(2) ytitle("waist (in)") title("Waist") xtitle("") ///
	name(g5, replace) //nodraw  
twoway qfitci hips year, stdf || scatter hips year /* if inrange(hips, 25, 40) */, ///
	msize(tiny) mcolor(pink%20) jitter(2) ytitle("hips (in)") title("Hips") xtitle("") ///
	name(g6, replace) //nodraw  
graph combine g4 g5 g6, col(3) xsize(20) ysize(8) iscale(1) name(g456, replace)
graph export ${MY_OUT_DATA}playmate_fit_measurement.png,replace width(4000)




twoway qfitci cupsize year, stdf || scatter cupsize year,  ///
	msize(tiny) mcolor(pink%20) jitter(2) ytitle("cupsize (A=1 to F=6)") title("Cupsize") xtitle("") ///
	name(g7, replace) //nodraw
twoway qfitci waist2bust year, stdf || scatter waist2bust year /* if inrange(waist, 15, 30) */, ///
	msize(tiny) mcolor(pink%20) jitter(2) ytitle("waist/bust") title("Waist-to-Bust Ratio") xtitle("") ///
	name(g8, replace) //nodraw  
twoway qfitci waist2hip year, stdf || scatter waist2hip year /* if inrange(hips, 25, 40) */, ///
	msize(tiny) mcolor(pink%20) jitter(2) ytitle("waist/hips") title("Waist-to-Hip Ratio") xtitle("") ///
	name(g9, replace) //nodraw  
graph combine g7 g8 g9, col(3) xsize(20) ysize(8) iscale(1) name(g789, replace)
graph export ${MY_OUT_DATA}playmate_fit_ratio.png,replace width(4000)

/* twoway qfitci bmi year, yaxis(1) ytitle("Title y1" axis(1)) || qfitci cupsize year, yaxis(2) ytitle("Title y2" axis(2))
twoway qfitci bmi year, ytitle("Title y1") || qfitci cupsize year, yaxis(2) ytitle("Title y2")
twoway (qfitci bmi year, yaxis(2) suffix) || (qfitci cupsize year, yaxis(1) suffix), ytitle("Title y1" axis(1)) ytitle("Title y2" axis(2))
 */
/* 
twoway qfitci waist2hip year, stdf || scatter waist2hip year if inrange(waist2hip, 0.5, 0.8), msize(tiny) mcolor(pink%20) jitter(2) ytitle("waist-to-hip") name(g3, replace)  //nodraw 
twoway qfitci waist2bust year, stdf || scatter waist2bust year if inrange(waist2bust, 0.5, 0.9), msize(tiny) mcolor(pink%20) jitter(2) ytitle("waist-to-bust") name(g4, replace) //nodraw 
graph combine g3 g4, col(2) xsize(20) ysize(10) iscale(1)
graph export ${MY_OUT_DATA}fit_ratio_three_measure.png,replace
/* twoway qfitci waist2hip year, yaxis(1) ytitle("Title y1") || qfitci waist2bust year, yaxis(2) ytitle("Title y2" axis(2))
 */
twoway qfitci cupsize year, stdf || scatter cupsize year if inrange(cupsize, 1, 5), ///
	msize(tiny) mcolor(pink%20) jitter(2) ytitle("cup size") ///
	name(g2, replace) //nodraw

twoway qfitci bust year, stdf || scatter bust year, msize(tiny) mcolor(pink%20) jitter(2) ytitle("bust") name(g7, replace) //nodraw  
//twoway qfitci waist year, ytitle("waist") name(g8, replace) //nodraw  
//twoway qfitci hips year, ytitle("hips") name(g9, replace) //nodraw  
graph combine g5 g6 g7, col(3) xsize(20) ysize(8) iscale(1)
graph export ${MY_OUT_DATA}fit_maturity.png,replace */
/*------------------------------------ End of SECTION 1 ------------------------------------*/
 

/* 
//statsby mean=r(table)[1,1], by(year):  mean(bmi)
ciplot bmi if year <2021, by(year) xsc(r(1 68)) ///
name(g_ci_1,replace) 
ciplot height if year < 2021, by(year)  ///
name(g_ci_2,replace)
ciplot weight if year < 2021, by(year) ///
name(g_ci_3,replace)
graph combine g_ci_1 g_ci_2 g_ci_3, col(3) xsize(20) ysize(8) iscale(1)
graph export ${MY_OUT_DATA}trend_bmi_height_weight.png,replace



ciplot cupsize if year <2021, by(year) ///
name(g_ci_4,replace)
ciplot bust if year < 2021, by(year)  ///
name(g_ci_5,replace)
ciplot waist if year < 2021, by(year) ///
name(g_ci_6,replace)
ciplot hips if year < 2021, by(year) ///
name(g_ci_7,replace)
graph combine g_ci_4 g_ci_5 g_ci_6 g_ci_7, col(2) xsize(20) ysize(20) iscale(1)
graph export ${MY_OUT_DATA}trend_measurement.png,replace




ciplot waist2hip if year < 2021, by(year)  ///
name(g_ci_8,replace)
ciplot waist2bust if year < 2021, by(year) ///
name(g_ci_9,replace)
graph combine g_ci_8 g_ci_9, col(2) xsize(20) ysize(10) iscale(1)
graph export ${MY_OUT_DATA}trend_ratio_three_measure.png,replace
 */

/* ciplot bust if year < 2021, by(year) ///
name(g_ci_7,replace)
ciplot waist if year < 2021, by(year) ///
name(g_ci_8,replace)
ciplot hips if year < 2021, by(year) ///
name(g_ci_9,replace) */
/* graph combine g_ci_5 g_ci_6 g_ci_1, col(3) xsize(20) ysize(8) iscale(1)
graph export ${MY_OUT_DATA}trend_height_weight_bmi.png,replace
 */

/*------------------------------------ End of SECTION 2 ------------------------------------*/





log close

set more on
timer off 1

timer list

