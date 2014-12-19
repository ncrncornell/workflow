*                                                                                   
*             STATA DATA DEFINITION STATEMENTS FOR ICPSR 13511 AND 13568            
*               CENSUS OF POPULATION AND HOUSING, 2000 [UNITED STATES]:             
*          PUBLIC USE MICRODATA SAMPLE: 1-PERCENT SAMPLE AND 5-PERCENT SAMPLE       
*                                1ST ICPSR RELEASE                                  
*                                  FEBRUARY, 2004                                   
*                                                                                   
*  local:  assigns the filename and locations for input files, dictionary,          
*  and output files.  Users must replace the "physical-filename" with host          
*  computer specific input file specifications.                                     
*                                                                                   
*  inlist: reads input file (raw data) and outputs the STATA file.                  
*  For the fixed format ascii file inlist uses the separate dictionary              
*  file.                                                                            
*                                                                                   
*  NOTE1:  Users should modify these data definition statements to suit             
*  their specific needs.                                                            
*                                                                                   
*  NOTE2:  At the time of the writing of this program there are three               
*  Stata packages available, Small Stata, Intercooled, and SE.  Small               
*  Stata has a limit of 99 variables and approximately 1,000 cases and              
*  is probably not useful for Census data.  Intercooled Stata has a limit           
*  of 2,047 variables and number of observations is limited by amount of            
*  computer memory.  SE 8 has a limit of 32,766 variables. The Housing Unit         
*  record has 106 variables and the Person record has 155 variables.                
*                                                                                   
*                                                                                   
*  These data definition statements have been tested for compatibility              
*  with Stata/SE 8.0 for Windows and Stata/SE 8.0 for UNIX.                         
*                                                                                   
* ----------------------------------------------------------------------            
version 8.0                                                                         
                                                                                    
/* Define local macros, filenames and locations */                                  
local datpums "PUMS5_50.TXT"   /* PUMS Data */                                      
local dtahu "hu.dta"          /* Stata Housing Unit data */                         
local dcthu "hu.dct"          /* Stata Housing Unit dictionary */                   
local dtap  "per.dta"         /* Stata Person data */                               
local dctp  "per.dct"         /* Stata Person dictionary */                         
local dtam  "pums.dta"        /* Stata PUMS merged data */                          
                                                                                    
capture log close                                                                   
log using pums, replace                                                             
                                                                                    
clear                                                                               
infile using `dcthu' if rectype=="H"                                                
sort serialno           /* sort data by Serial Number */                            
save dtahu, replace  /* save housing unit data */                                   
                                                                                    
clear                                                                               
infile using `dctp' if rectype=="P"                                                 
sort serialno           /* sort data by Serial Number */                            
save dtap, replace /* save person data */                                           
                                                                                    
merge serialno using dtahu /* merge person and housing unit data */                 
drop _merge                                                                         
                                                                                    
save dtam, replace  /* save merged data */                                          
log close                                                                           
