# ISTART-ugdg: Analysis Code

## Overview and disclaimers
- run_* scripts loop through a list of subjects for a given script; e.g., run_L1stats.sh loops all subjects through the L1stats.sh script.
- paths to input/output data should work without error, but check package/software installation
- see also https://github.com/DVS-Lab/istart-data for scripts that generated data that this reposistory uses

## Scripts and files
- `L1stats.sh` -- Level 1 analysis on a specific subject and run (could be activation, PPI, or network PPI)
- `L2stats.sh` -- Level 2 analysis (combine data across runs)
- `L3stats.sh` -- Level 3 analysis (i.e., group-level analysis)
- `barweb_dvs2.m` -- helper function for making bargraphs (used by `plotROIdata.m`)
- `compileZimages.sh` -- compiles subject-level z-stat images (useful for plotting)
- `extractROI.sh` -- extract stat values (e.g., zstat, cope, etc.) from an ROI in a 4-d image
- `gen3colfiles.sh` -- generate 3-column files for FSL based on BIDS `*_events.tsv` files
- `plotROIdata.m` -- plot data from an ROI as a bar graph (uses output of `extractROI.sh`)
- `newsubs.txt` -- list of subjects for an analysis
- `behavioral_analysis.m` -- prepares subjects for UGDG_Analysis. Use debug version for several subjects due to psychopy version issue.
- 'final_converter.m' -- Makes BIDS compatible TSV files. Use debug version for several subjects due to psychopy issue.
- 'UGDG_analysis.m' -- Inputs data for behavioral analyses. Makes plots and figures.
- 'motion_data_input.xls' and ISTART_CombinedDataSpreadsheet_031722.csv-- Inputs into UGDG_analysis.m
- 'PlotROIData.m' -- Inputs extracted ROIs for analyses
- 'plot_ugdg.m' - Makes ROI bar plots for activation and connectivity. PlotROIdata calls this function.
- 'plot_ugdg_multiple.m' -- Ditto as plot_ugdg, though lets plot two bar plots next to each other.


