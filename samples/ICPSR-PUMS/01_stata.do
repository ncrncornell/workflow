/* $Id: 01_stata.do 1259 2014-12-10 14:37:31Z lv39 $ */
/* This file reads in Alaska PUMS data */
/* SRC: http://doi.org/10.3886/ICPSR13568.v1 */
/* Source program:  "ICPSR_13568/13568-Setup.do" was used
   as a template, but that program cannot
   be run as-is */
/* Author: Lars Vilhuber */

  /* Define local macros, filenames and locations */
  local datpums "13568-0002-Data.txt"   /* PUMS Data */
  local datpath "ICPSR_13568/DS0002"  /* local relative path */
  local dtahu "housing.dta"  /* Stata Housing Unit data */
  local dcthu "housing.dct"  /* Stata Housing Unit dictionary */
  local dtap  "person.dta"   /* Stata Person data */
  local dctp  "person.dct"   /* Stata Person dictionary */
  local dtam  "pumsak.dta"  /* Stata PUMS merged data */

  capture log close
  log using pums, replace
  set more 1

  clear
  infile using `dcthu' if rectype=="H", using ("`datpath'/`datpums'")
  sort serialno   /* sort data by Serial Number */
  save `dtahu', replace  /* save housing unit data */

  clear
  infile using `dctp' if rectype=="P", using ("`datpath'/`datpums'")
  sort serialno   /* sort data by Serial Number */
  save `dtap', replace /* save person data */

  merge serialno using `dtahu' /* merge person and housing unit data */
  drop _merge
  /* keep only relevant information */
  keep pweight race2 race1 numrace
  /* code a dummy to the four tribes */
  gen specific_ak=(race2 == "31" | race2 == "32" | race2 == "33" | race2 == "34")
  /* convert weights */
  destring pweight, gen(pweight_num)
  /* label variables */
  label variable specific_ak "Identifying with one of the four tribes"
  label variable pweight_num "Person weight"
  /* table with appropriate weights */
  tab specific_ak [fweight=pweight_num]
  /* output the table to latex */
  label define spec 0  "Not identified" 1 "Identified with one of the four tribes"
  label value specific_ak spec
  latab specific_ak [fweight=pweight_num], tf("freq_specific_ak") replace dec(2)
  saveold `dtam', replace  /* save merged data */
  log close
