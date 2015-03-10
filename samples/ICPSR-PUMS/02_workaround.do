/*$Id: 02_workaround.do 1259 2014-12-10 14:37:31Z lv39 $ */
/* Workaround only for this example: subset the output data 
   to less than 5000 obs 
*/
  local dtam  "pumsak.dta"  /* Stata PUMS merged data */
  local limit 5000

  use `dtam'
  keep if _n < `limit'
  saveold `dtam', replace
