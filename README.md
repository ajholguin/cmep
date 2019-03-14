
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cmep

The `cmep` package can be used to read CMEP formatted files into R.

## Installation

You can install the development version of `cmep` from GitHub with:

``` r
remotes::install_github("ajholguin/cmep")
```

## Example

Read the sample file:

``` r
library(cmep)
f <- system.file("extdata", "cmep.dat", package = "cmep", mustWork = TRUE)
read_cmep(f)
#> # A tibble: 5 x 15
#>   record_type record_version sender_id sender_customer~ receiver_id
#>   <chr>       <chr>          <chr>     <chr>            <chr>      
#> 1 MEPMD01     20080501       SENSUS    SPS:130000       15173624   
#> 2 MEPMD01     20080501       SENSUS    SPS:130000       15175228   
#> 3 MEPMD01     20080501       SENSUS    SPS:130000       15179826   
#> 4 MEPMD01     20080501       SENSUS    SPS:130000       15179930   
#> 5 MEPMD01     20080501       SENSUS    SPS:130000       47622887   
#> # ... with 10 more variables: receiver_customer_id <chr>,
#> #   timestamp <dttm>, meter_id <chr>, purpose <chr>, commodity <chr>,
#> #   units <chr>, calculation_constant <dbl>, interval <chr>, count <int>,
#> #   data <list>
```

## Related Work

There is a CMEP parser (<https://github.com/craignicholson/cmepparser>)
developed in Go, which formats the data as JSON.
