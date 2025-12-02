%%% process_adelaide.m
% This script uses monthly mean temperature data for Adelaide Airport (the location I had for my climate data assignment) and calculates annual mean temperatures and anomalies from 1951-1980>
% These calculations are used to create a graph of annual temperature
% anomalies with a trendline, and a barcode type image of annual temperature anomalies
% Finally, Detroit Metro Airport data is used to calclate annual anomalies
% and then make a scatterplot comparing the two locations (Adelaide Airport
% and Detriot)
%
%
% Created by: Rishabh Bhatia
%
% Date created: 2025-11-26
% 
%



%% Preparation
clearvars;
%%% Set a variable equal to the station name -- this way, we can reuse it to
% load and save things. 
station_name = 'ADELAIDE_AIRPORT'; 

%%% Colormap (used for barcode plots)
cmap = ([0,0,0.562500000000000;0,0,0.625000000000000;0,0,0.687500000000000;0,0,0.750000000000000;0,0,0.812500000000000;0,0,0.875000000000000;0,0,0.937500000000000;0,0,1;0,0.0625000000000000,1;0,0.125000000000000,1;0,0.187500000000000,1;0,0.250000000000000,1;0,0.312500000000000,1;0,0.375000000000000,1;0,0.437500000000000,1;0,0.500000000000000,1;0,0.562500000000000,1;0,0.625000000000000,1;0,0.687500000000000,1;0,0.750000000000000,1;0,0.812500000000000,1;0,0.875000000000000,1;0,0.937500000000000,1;0,1,1;0.117647059261799,0.992647051811218,0.992647051811218;0.235294118523598,0.985294103622437,0.985294103622437;0.352941185235977,0.977941155433655,0.977941155433655;0.470588237047195,0.970588207244873,0.970588207244873;0.588235318660736,0.963235318660736,0.963235318660736;0.705882370471954,0.955882370471954,0.955882370471954;0.823529422283173,0.948529422283173,0.948529422283173;0.941176474094391,0.941176474094391,0.941176474094391;0.948529422283173,0.948529422283173,0.823529422283173;0.955882370471954,0.955882370471954,0.705882370471954;0.963235318660736,0.963235318660736,0.588235318660736;0.970588207244873,0.970588207244873,0.470588237047195;0.977941155433655,0.977941155433655,0.352941185235977;0.985294103622437,0.985294103622437,0.235294118523598;0.992647051811218,0.992647051811218,0.117647059261799;1,1,0;1,0.937500000000000,0;1,0.875000000000000,0;1,0.812500000000000,0;1,0.750000000000000,0;1,0.687500000000000,0;1,0.625000000000000,0;1,0.562500000000000,0;1,0.500000000000000,0;1,0.437500000000000,0;1,0.375000000000000,0;1,0.312500000000000,0;1,0.250000000000000,0;1,0.187500000000000,0;1,0.125000000000000,0;1,0.0625000000000000,0;1,0,0;0.937500000000000,0,0;0.875000000000000,0,0;0.812500000000000,0,0;0.750000000000000,0,0;0.687500000000000,0,0;0.625000000000000,0,0;0.562500000000000,0,0;0.500000000000000,0,0]);
%%% Create a cell array with column names for the input file 
colheaders = {'Year','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'}; % Column headers

%%% Load the data for the site from the /Data directory:
stn_data = readmatrix(['Data/' station_name '.csv']); % Note how we've built the filename from the station name.
%%% <**TO DO**> Open up the data in the Variable Browser and inspect. 

%%% Pull out years and temperatures from stn_data
years = stn_data(:,1); % Pull out column of years from stn_data (first column)
temps = stn_data(:,2:end); % Pull out matrix of temperatures from stn_data (all rows x the last 12 columns)
temps(temps==-9999)= NaN; % Turn -9999s into NaNs
temps = temps./100; % Turn temperatures into degrees Celsius. 
clear stn_data; % Clear this variable because we'll use 'years' and 'temps' from now on

%%% Create some labels to use for plotting
first_ten_mult = find(mod(years,10)==0,1,'first'); % Find the first year in the time series that is evenly divisible by 10. 
year_labels = num2str(years([first_ten_mult:20:numel(years)])); % We'll create a set of labels that start at the first_ten_mult and advance by 20.

%%%%%%%%%%%%%%%%%%%%
%% Calculate annual means, anomalies
ref_start = 1951;
ref_end = 1980;

%%% Calculate annual means so that years with an NaN in any month will also have NaNs in annual average 
% Mean across 12 the 12 monthly columns 
annual_mean = mean(temps,2); %each row represents one year so this is the annual mean for the year

% Mean of reference period -- take average of all non-NaNs between the reference years
annual_mean_ref = mean(annual_mean(years>=ref_start & years<= ref_end & ~isnan(annual_mean)));

%Annual anomalies calculated by subtracting annual_mean_ref by annual_mean
anoms_annual = annual_mean - annual_mean_ref; 

%%%%%%%%%%%%%%%%%%%%%%
%% Calculate trendline *** THIS IS DONE FOR YOU *** 
ind = find(~isnan(anoms_annual)); % find years without an NaN
%%% fit a first-order (linear) polynomial
p = polyfit(years(ind),anoms_annual(ind),1); % p(1) is the slope, p(2) is the intercept
anoms_annual_trend = polyval(p,years); % polyval uses the linear coefficients to create predicted values (i.e. our trendline)

%%%%%%%%%%%%%%%%%%%%%%
%% Figure 1: Create line plot and save it to the /Figs directory with a filename that matches the station name (i.e., "Adelaide Airport_timeseries.png")  
%%% Plot (this part is done)
fig1 = figure; clf;
plot(years,anoms_annual,'b.-'); hold on; % Plot the anomaly time series
plot(years,anoms_annual_trend,'r-'); % Plot the trend line 
ylabel('Annual temperature anomaly (^{\circ}C)');                   % y-axis label
xlabel('Year');                                                     % x-axis label
legend('Annual anomalies','Linear trend','Location','NorthWest');   % legend label
print('-dpng',['Figs\' station_name '_timeseries']); % saves as "Adelaide Airport_timeseries.png" with the name of the station in the filename. See how handy it is to reuse variables?

%%%%%%%%%%%%%%%%%%%%%
%% Figure 2: Create a 'Barcode' graph of Annual anomalies and save it to the /Figs directory with a filename that matches the station name (i.e., "Adelaide Airport_barcode.png")
%%% Rearrange and plot (This is done for you)
anoms_annual_plot = anoms_annual'; % transpose for plotting purposes
anoms_annual_plot(isnan(anoms_annual_plot))=0;
fig2 = figure; clf;
imagesc(anoms_annual_plot);
shading flat;
colormap(cmap); % Sets a colormap using the cmap array we created at the beginning of the script.
caxis([-2 2]);  % Scales the limits of the colours to +/- 2 degrees C
c2 = colorbar; 
set(gca,'XTick',[first_ten_mult:20:numel(years)]);
set(gca,'XTickLabels',year_labels);
set(gca,'YTick',[]); % Leave this blank-it removes ticks on the y-axis.
%%% <TO DO> Save this in the Figs\ directory (as above) with the name of the station and '_barcode' (i.e. '\Figs\Adelaide Airport_barcode') <TO DO>
ylabel(c2,'Annual temperature anomaly (^{\circ}C)'); % label for the colourbar
print('-dpng',['Figs\' station_name '_barcode']); 

%% Part 2: Plot a scatterplot of annual temperature anomalies between Adelaide Airport and Detroit Airport (Detroit Metro Ap.csv)

%% Part 2: Plot a scatterplot of annual temperature anomalies between Adelaide Airport and Detroit Airport (Detroit Metro Ap.csv)

%%% Load the Detroit Airport data file
station_name_detroit = 'DETROIT_METRO_AP';                      % station name for Detroit
stn_data_detroit = readmatrix(['Data/' station_name_detroit '.csv']); % load Detroit data from /Data

%%% Pull out years and temperatures for Detroit
years_detroit = stn_data_detroit(:,1);      % first column = years
temps_detroit = stn_data_detroit(:,2:end);  % remaining columns = monthly temps

%%% Clean and convert Detroit temperature data
temps_detroit(temps_detroit == -9999) = NaN; % replace -9999 with NaN
temps_detroit = temps_detroit./100;         % convert from 1/100 deg C to deg C
clear stn_data_detroit;                     % we now use years_detroit and temps_detroit

%%% Calculate annual mean temperatures for Detroit
annual_mean_detroit = mean(temps_detroit,2); % mean across the 12 months for each year

%%% Reference-period mean for Detroit (same 1951–1980 as Adelaide)
annual_mean_ref_detroit = mean(annual_mean_detroit(years_detroit>=ref_start & ...
                                                   years_detroit<=ref_end & ...
                                                   ~isnan(annual_mean_detroit)));

%%% Calculate annual anomalies for Detroit
anoms_annual_detroit = annual_mean_detroit - annual_mean_ref_detroit;

%%% Make a scatterplot using years where both stations have data
% Adelaide and Detroit series are different lengths, so use the first N
% years that both have (simple way to line them up)
N = min(length(anoms_annual), length(anoms_annual_detroit));

x_vals = anoms_annual(1:N);           % Adelaide anomalies (x-axis)
y_vals = anoms_annual_detroit(1:N);   % Detroit anomalies (y-axis)

% Remove any NaNs so we only plot valid year pairs
valid_both = ~isnan(x_vals) & ~isnan(y_vals);
x_vals = x_vals(valid_both);
y_vals = y_vals(valid_both);

%%% Create the scatterplot
fig3 = figure; clf;
plot(x_vals, y_vals, 'ko');  % black circles
grid on;
xlabel('Adelaide Airport annual anomaly (^{\circ}C)');
ylabel('Detroit Metro AP annual anomaly (^{\circ}C)');
title('Adelaide vs Detroit annual temperature anomalies');

%%% Save the figure in the Figs\ directory
print('-dpng','Figs\Adelaide_vs_Detroit');  % saves "Adelaide_vs_Detroit.png"
