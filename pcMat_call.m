%% call script to make pie charts for a study
CCidx = []; CClabelArray = [];
%% *** USER INPUT
    studyID = 'flights'; % 'dvb' or 'flights'
    sampleArrayPIDCol = 8; % = 4 for flights;, = 2 for dvb; 7 or 8 for CVI, ISO inlet
    %     art2a_path          = 'G:\StudyData\processedData\2014_11_FIN1_dvb\analysis_art2a\vf070_rf075\';
    gui_outID_path          = 'G:\StudyData\processedData\2015_01_CW2_flights_sly_LK_gui\analysis_gui_fates\';  
    PID_source_path     = 'G:\StudyData\processedData\2015_01_CW2_flights_sly_LK_gui\PIDs\';
    piechart_path        = 'G:\StudyData\processedData\2015_01_CW2_flights_sly_LK_gui\analysis_piecharts\ISO\';
    %     art2a_outName       = 'FIN1_dvb_Results';   % name of art2a output file
    art2a_outName       = 'GUI_outID';   % name of art2a output file
    PIDsource           = 'PIDs_cwf.mat';       % name of PID source file
    minFrac             = 1;                    % set minimum fraction of pie slices to include
    colorDB             = 'normal';             % default is 'normal'
    partTypeID          = 'known';         % 'known', 'unknown', or 'combined'; default is 'unknown'
    %titleArray = {'EVSD','Kfeld','MDD','ArgSD','Bachli','Illite','Snomax','BacPS','BacCG'};
    %titleArray = {'all dvb'}; % **** tmp ****
    titleArray = cell(1,30);
            for i = 1:30;
            titleArray{i} = sprintf('rf% u ISO',i);
            end
% *** END of USER INPUT ***
            
disp('>> making pie chart matrix')
%% load variables
load(sprintf('%s%s.mat', gui_outID_path,art2a_outName)); % load(sprintf('%s%s.mat', art2a_path,art2a_outName));
    switch partTypeID
        case 'combined' 
              inputPID = GUI_outID(1,:); % inputPID = art2a_outID;
              [CCoutID,CCidx,CClabelArray] = pcMat_combineClusters(inputPID); %[combClstrsID] = pcMat_combineClusters(inputID,pcm);
              inputPID = CCoutID;
        otherwise
               inputPID = GUI_outID(1,:); %inputPID = art2a_outID;
    end
load(sprintf('%s%s',PID_source_path,PIDsource));
    switch studyID
        case 'flights'
        PIDdefs = PIDoutcell;   % CWflights
        case 'dvb'
            %% temp
%             tempPID{1,1} = 'alldvb'; tempPID{1,2} = mod_dvb_all;
%             PIDdefs = tempPID; %
            %% 
            PIDdefs = mod_dvbcell; 
    end
 
%% use PID out cell to create variables for input to make pc matrix
for i = 1:size(PIDdefs,1)
    sampleArray{i}  = PIDdefs{i,sampleArrayPIDCol}; 
    labelArray{i}   = PIDdefs{i,1};
end
%% call make_PCmat function
[pcMat,pcMat_frac] = pcMat_make(inputPID,sampleArray,labelArray,piechart_path);
%% make pie chart plots
disp('>> making pie charts')

%% load color database
switch colorDB
    case 'dvb'
        load('C:\FATES\scripts_HA\HA_customColors\customColorMaps.mat')
        startColor  = 1;
        otherColor  = 1;
    otherwise
        load('C:\FATES\scripts_HA\HA_customColors\customColorMaps.mat')
        startColor = 280; % = 280 for CW2 and in general; 
        otherColor = 784; % = 784 for CW2 and in general;  
end
% eliminate lables on piechart cell... and convert to matrix
        noLabel = pcMat_frac(2:end,3:end); % noLabel_frac = pcMat_frac(2:end,3:end); 
        pcm = cell2mat(noLabel);       
%% call function to apply labels to clusters
[clusterLabel] = pcMat_knownType(partTypeID,pcm,CCidx,CClabelArray);             
%% call plot function
[eachExpt_pcMat] = pcMat_plot(customColorMap,startColor,otherColor,minFrac,clusterLabel,pcm,pcMat,titleArray,piechart_path)


