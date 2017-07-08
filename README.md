# ElectionPrediction
Model to predict election results 

Objective:

The goal of this project is to build a predictive model to predict the outcomes of 2014 Lok Sabha elections six months before the elections were held.

Hypothesis Statements:
Before stating the task of identifying what data to collect and from what sources, we have built some hypothesis. These hypotheses are based on the factors that we think would impact the outcome of loksabha election results.

Hypothesis 1: 
Null: Election results are not impacted by the percentage of Muslim population in a constituency.
Alternative: Election results are impacted by the percentage of Muslim population in a constituency.

Hypothesis 2: 
Null: Election results are not impacted by the percentage of Hindu population in a constituency.
Alternative: Election results are impacted by the percentage of Hindu population in a constituency.

Hypothesis 3: 
Null: Election results are not impacted by the literacy rate of voters in a given constituency.
Alternative: Election results impacted by the literacy rate of voters in a given constituency.

Hypothesis 4: 
Null: Election results are not impacted by the polling percentage in a constituency.
Alternative: Election results are impacted by the polling percentage in a constituency.

Hypothesis 5: 
Null: Election results are not impacted by male female ratio in a constituency.
Alternative: Election results are impacted by male female ratio in a constituency.

Hypothesis 6: 
Null: Election results are not impacted by incumbency effect of winning party in a constituency.
Alternative: Election results are impacted by incumbency effect of winning party in a constituency.

Hypothesis 7: 
Null: Election results are not impacted by the educational background of the candidate.
Alternative: Election results are impacted by the educational background of the candidate.

Hypothesis 8: 
Null: Election results are not impacted by the criminal background of the candidate.
Alternative: Election results are impacted by the criminal background of the candidate

Hypothesis 9: 
Null: Election results are not impacted by the wealth of the candidate.
Alternative: Election results are impacted by the wealth of the candidate.

Hypothesis 10: 
Null: Election results are not impacted by the sex of the candidate.
Alternative: Election results are impacted by the sex of the candidate.

Hypothesis 11: 
Null: Election results are not impacted by the type of the political party (National/Regional).
Alternative: Election results are impacted the type of the political party (National/Regional).
.

Hypothesis 12: 
Null: Election results are not impacted by results of assembly election recently held in a constituency.
Alternative: Election results are impacted by the results of the assembly elections held in a constituency.

Factors impacting election results:
Based on above hypotheses, we think following factors could impact the outcome of election results:
Muslim population percentage in a constituency
•	Hindu population percentage in a constituency
•	Literacy rate of voters in a constituency
•	Sex ratio of voters in a constituency
•	Polling percentage in a constituency
•	Incumbency effect of previous election winning party in a constituency
•	Educational background of the candidate contesting election
•	Criminal background of the candidate contesting election 
•	Number of serious criminal cases against the candidate contesting election
•	Wealth of the candidate contesting election
•	Sex of the candidate contesting election
•	Type of political party of the candidate contesting election ( Regional/ National/ Other)
•	Type of category of the candidate contesting election ( SC/ST/GEN)

Identification of Data Sources:

Publicly available data is collected from following sources for this modeling:

•	2009 Loksabha election data with candidates profile, total votes polled, poll percentage, vote share , etc is collected from Election Commission Website: http://eci.nic.in/eci_main1/ElectionStatistics.aspx
•	2009 Loksabha data about candidate’s education, assets, criminal background, serious criminal charges is taken from MyNeta website having following URL:
http://www.myneta.info/ls2009/
•	2004 lok sabha elections winners’ data is collected from election commission website.
http://eci.nic.in/eci_main1/ElectionStatistics.aspx
•	2011 Census data about total Hindu/Muslim population in each constituency (state wise) is collected from govt. census website with following URL:
http://www.censusindia.gov.in/2011census/C-01.html
•	2011 Census data about literacy rate and sex ratio in each constituency is collected from following URL
http://www.mapsofindia.com/maps/tamilnadu/tamilnadu-district.htm


Methodology:
As the Census data is available state wise, and we wanted to include the population demographic factors in our model, we have decided to collect the data state-wise. Given the timeframe of this assignment, it is not possible to collect data for all the states, so we have identified and collected data for 5 major states that represent the overall lok sabha election results.

We will base and build our model with data for these 5 states. Same model can be later on extended with data collected for all the states to give a complete picture of the election outcomes.

States selected for this assignment are:
1.	Uttar Pradesh
2.	Madhya Pradesh
3.	Maharashtra
4.	West Bengal
5.	Tamil Nadu

Data collection and preparation:
Following steps were taken to prepare the data files for each state:
1.	2009 lok sabha election data is downloaded from EC website. Both the sheets of EC data is merged using Vlookup in excel. File prepared after this merger is “GE_2009_Candidates.csv”.
2.	Religion data for each state is downloaded from census website as mentioned above. This data is cleaned manually to remove irrelevant rows and columns. Files for each state prepared at this stage are :
UP_Religion.csv
MP_Religion.csv
MH_Religion.csv
WB_Religion.csv
TN_Religion.csv
3.	Religion data is merged with EC data using R. First of all districts present in religion data are matched using stringdist algorithm in R. Four methods ( JW,Jaccard, lv and dl) were tried using stringdist function to match the district present in religion file with constituencies present in EC file. Unmatched values that could not be matched by algorithm were matched manually.  Following sub files were created for each state during this step:
UP-ReligionDistrict-Const-Matching.csv
MP-ReligionDistrict-Const-Matching.csv
MH-ReligionDistrict-Const-Matching.csv
WB-ReligionDistrict-Const-Matching.csv
TN-ReligionDistrict-Const-Matching.csv
4.	Relgion data for each state is then merged with EC data using above sub files.
5.	Literacy data for each state is extracted from the website using web scrapping in R.  Districts present in literacy data are matched with constituencies following the same steps as mentioned in point 3 above. Following sub files were created for each state.
UP-LiteracyDistrict-Const-Matching.csv
MP-LiteracyDistrict-Const-Matching.csv
MH-LiteracyDistrict-Const-Matching.csv
WB-LiteracyDistrict-Const-Matching.csv
TN-LiteracyDistrict-Const-Matching.csv
6.	Literacy data for each state is merged with dataset created in step 5  using sub files.
7.	To add incumbency data, election winners data for 2004 lok sabha election is downloaded manually for each state. Following data files were created:
GE_2004_Winners_UP.csv
GE_2004_Winners_MP.csv
GE_2004_Winners_MH.csv
GE_2004_Winners_WB.csv
GE_2004_Winners_TN.csv
8.	 Constituencies in 2004 EC data and 2009 EC data are matched in R using stringdist function.  It was found that some constituencies were renamed from 2004 to 2009 while some were newly created constituencies in 2009. All such constituencies were manually matched. Following sub files were created in this step.
GE_2004_Winners_UP.csv
GE_2004_Winners_MP.csv
GE_2004_Winners_MH.csv
GE_2004_Winners_WB.csv
GE_2004_Winners_TN.csv
9.	Incumbency data is merged to the EC dataset using these sub files. Following final merged file is generated at this stage:
EC.Final.UP.2009.csv
EC.Final.MP.2009.csv
EC.Final.WB.2009.csv
EC.Final.MH.2009.csv
EC.Final.TN.2009.csv
10.	All the files are merged into single file for all the states.
EC.Final.ALL.2009_Clean.csv
11.	Data from MyNeta website is extracted using web scrapping and processed using R script to generate following file:
LokSabha2009_Merged_file.csv
12.	A file generated in step 10 is merged with the Myneta file generated in step 10. This merge was done manually using vlookup function in excel.
EC_MyNeta_Merged_Final_ALL.csv
13.	Further cleaning is done to remove data for all independent candidates. Data for IND candidates are deleted because by keeping the IND candidates, dataset is highly biased towards the chances of candidate loosing election. This is because most of the independent candidates’ loose election as observed in all previous elections. So data for IND candidates can be considered as noise in the dataset. File generated at this stage is 
Final_Merged_Clean_ALL_2009.csv

 
Relevant R code files:

PM_Grp_Assignment-DataPrep-UP.R
PM_Grp_Assignment-DataPrep-MP.R
PM_Grp_Assignment-DataPrep-MH.R
PM_Grp_Assignment-DataPrep-WB.R
PM_Grp_Assignment-DataPrep-TN.R
PM_Grp_Assignment-EC-MyNeta-Merge.R
PM_Grp_Assignment-MyNeta-DataDownload.R




