# rblinks: R package to read MedPC Blinks task data.

This package contains 3 functions:
  - med_to_dt: reads a MedPC raw data file to an R data table
  - save_blinks_data: saves file to a specified path
  - load_blinks_data: loads data from a specified file
  
### Installation

First, make sure you have the devtools package installed. If not, run:<br/> ``install.packages("devtools")``

Next, install rblinks directly from github:<br/>
``devtools::install_github("gkane26/rblinks")``

### Instructions for use

First, get the path to MedPC data files. These can be typed in manually, or selected via a GUI in a number of ways. I think the tcltk package is a good option across platforms. If using a mac, this will require [XQuartz](https://www.xquartz.org/) is installed. Example:<br/>
``files = tcltk::tk_choose.files()``

Next, use the med_to_dt function to get a data frame of trial-by-trial data:
```
library(rblinks)
blinks_dat = med_to_dt(files[1])
```

Data can be saved to either a csv or Rdata file using the save_blinks_data function:
```
save_file_name = save_blinks_data(blinks_dat, path="~/Desktop")
```

Previously saved data can be loaded using the load_blinks_data function. Multiple files can be loaded into a single data table by passing a vector of file names:
```
blinks_dat = load_blinks_data(save_file_name)
blinks_dat = load_blinks_data(c(save_file_name, save_file_name))
```

To see additional options or for further details, see documentation. For example: ``?med_to_dt``

### Further Analysis

At the moment, this package does not implement any further statistical analysis. Since the package uses data.table, further analysis is easy and convenient to do. After loading a data table containing data from multiple groups of subjects and multiple experimental conditions, accuracy and reaction time can be found:
```
blinks_data = rblinks::load_blinks_data(file=vector_of_data_files)
accuracy_data = blinks_data[, accuracy := mean(correctChoice), .(subject, group, condition, pCorrectBlink)]
rt_data = blinks_data[, RT := mean(RT), .(subject, group, condition, pCorrectBlink)]
```

These variables can be easily plotted using ggplot2:
```
library(ggplot2)
library(Hmisc)

accuracy_plot = ggplot(accuracy_data, aes(x=pCorrectBlink, y=accuracy, color=condition)) +
    facet_wrap(~group)
    stat_summary(fun,y=mean, geom="point", size=2) +
    stat_summary(fun.y=mean, geom="line") +
    stat_summary(fun.data=mean_se, geom="errorbar", width=.03) +
    theme_classic()
accuracy_plot
```
