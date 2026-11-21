# Anthropogenic Climate Change and MDD-C
Anthropogenic climate change exacerbated the burden of extreme precipitation on children’s dietary diversity in low- and middle-income countries

## DHS data source and access

### Data source

The child and household survey records used in this study were
obtained from [IPUMS DHS](https://www.idhsdata.org/idhs/), which
provides harmonized microdata from the Demographic and Health
Surveys (DHS) Program.
The data used in our study are drawn from 32 low- and middle-income 
countries and cover the period from 2004 to 2020; further details 
are provided in Supplementary Table S1.

### How to obtain the data

1. Register with [The DHS Program](https://dhsprogram.com/data/new-user-registration.cfm),
   describe the proposed research, and request access to the
   relevant countries and surveys.
2. After approval, sign in to [IPUMS DHS](https://www.idhsdata.org/idhs/)
   using the DHS Program account.
3. Select the relevant child survey samples and variables, create
   a customized data extract.


## Software environment

Statistical analyses were performed in R 4.6.1. The main packages were:
- fixest 0.14.2: fixed-effects regression and statistical inference.
- data.table 1.18.6.1 and dplyr 1.2.1: data processing.
- ggplot2 4.0.3 and patchwork 1.3.2: plotting and figure assembly.

Python 3.12.13 was also used for figure generation, primarily with:
- Matplotlib 3.10.9
- NumPy 2.4.4
- pandas 3.0.2



### Restrictions on redistribution

DHS and IPUMS DHS microdata are third-party, access-controlled data.
Authorization to download and analyse these records does not grant
permission to redistribute them publicly. The original survey
microdata and geospatial files are therefore not included in this
repository.

Please
[IPUMS DHS Terms of Use](https://www.idhsdata.org/idhs/terms.shtml)
and the
[DHS Program Terms of Use](https://dhsprogram.com/data/terms-of-use.cfm).
