function out2 = extractdata2(filename,startyr,censusyr,SSP,GCM)
% takes all simulations of a given SSP/GCM model and provides key 
% outputs plus the simulation-specific normalised z-scores

%out2 = extractdata("sR0_GBR.6.8_SSP119_CNRM-ESM2-1.mat",43,88,1,1);
%out2 = extractdata("sR0_GBR.7.0_herit0.3_SSP119_CNRM-ESM2-1.mat",28,43,1,1);
% 1 reef row number (1-3806)
% 2 aims sector
% 3 start year of analysis 'startyr'
% 4 census year of coral cover 'censusyr'
% 5 SSP 1=1.9, 2=2.6, 3=4.5, 4 =7.0, 5=8.5
% 6 GCM 1=CNRMm, 2=EC-Earth, 3=IPSL, 4=MRI, 5=UKESM
% 7 simulation number (1-20)
% 8 coral cover in census year LOG+0.1
% 9 total number of cyclones since startyr NORMAL
% 10 mean cyclone strength since startyr LOG+0.1
% 11 time since last cyclone (prior to census year) SQRT
% 12 total number of bleaching event since startyr LOG+0.1
% 13 mean dhW of bleaching events LOG+0.1
% 14 time since last bleaching event where DHW>=6 SQRT
% 15 total density of largest 4 cots classes over time since startyr SQRT
% 16 mean cots density of largest 4 classes since startyr SQRT
% 17 number of cots control actions since startyr LOG+0.1
% 18 years since last cots control (max is census-startyr if never done) LOG+0.1
% 19 mean larval supply since startyr LOG+0.1
% 20 mean larval supply in last 5 years before census LOG+0.1
% 21 mean rubble cover in last 5 years before census NORMAL
% 22 impact of WQ on reproduction (0-1)SQRT
% 23 impact of WQ on recruitment (0-1)SQRT
% 24 impact of WQ on juvenile growth (0-1)SQRT
% 25 z-score of coral cover
% 26 z-score of total number of cyclones since startyr
% 27 z-score of mean cyclone strength since startyr
% 28 z-score of time since last cyclone (prior to census year)
% 29 z-score of total number of bleaching event since startyr
% 30 z-score of mean dhW of bleaching events
% 31 z-score of time since last bleaching event where DHW>=6
% 32 z-score of total density of largest 4 cots classes over time since startyr
% 33 z-score of mean cots density of largest 4 classes since startyr
% 34 z-score of number of cots control actions since startyr
% 35 z-score of years since last cots control (max is census-startyr if never done)
% 36 z-score of mean larval supply since startyr
% 37 z-score of mean larval supply in last 5 years before census
% 38 z-score of mean rubble cover in last 5 years before census
% 39 z-score of impact of WQ on reproduction (0-1)
% 40 z-score of cimpact of WQ on recruitment (0-1)
% 41 z-score of cimpact of WQ on juveniles (0-1)
% 42 coral cover in census year
% 43 total number of cyclones since startyr
% 44 mean cyclone strength since startyr
% 45 time since last cyclone (prior to census year)
% 46 total number of bleaching event since startyr
% 47 mean dhW of bleaching events
% 48 time since last bleaching event where DHW>=6
% 49 total density of largest 4 cots classes over time since startyr
% 50 mean cots density of largest 4 classes since startyr
% 51 number of cots control actions since startyr
% 52 years since last cots control (max is census-startyr if never done)
% 53 mean larval supply since startyr
% 54 mean larval supply in last 5 years before census
% 55 mean rubble cover in last 5 years before census
% 56 impact of WQ on reproduction (0-1)
% 57 impact of WQ on recruitment (0-1)
% 58 impact of WQ on juvenile growth (0-1)
% 59 mean HT of corals in last 5 years
% 60 normalized HT of corals

%load("sR0_GBR.6.8_SSP119_CNRM-ESM2-1.mat");
load(filename);
%load("ReefModWQdrivers.mat");
% load("ReefWQdrivers.mat");
out=zeros(1,60); % for simulation specific normalisation
out2=zeros(1,60);% to collate data from multiple simulations
count=1;
[sims,numreefs,years,species]=size(coral_cover_per_taxa);
totalcoral=sum(coral_cover_per_taxa,4);

% external_supply = coral_larval_supply - 0.28*nb_coral_offspring*2;
external_supply = extract_external_LS(coral_larval_supply,nb_coral_offspring); % YM: note first and last year cannot be assessed (NaN)
totallarvae=sum(external_supply,4);% modified code to ignore self recruitment
%totallarvae=sum(coral_larval_supply,4);
totallarvae(totallarvae<0)=NaN; % YM: I'll do totallarvae(totallarvae<0)=0 here, because small negatives indicate no external supply;

totaladultcots=sum(COTS_adult_densities(:,:,:),4);
meanHT=mean(coral_HT_mean,4); % mean heat tolerance in DHW (above group mean of zero) across all corals
% Note that the original values are now placed in rows 42 onwards and the
% transformed (including if no trans needed) in the original places from
% 8-24. THat way the z scores work correctly.
for s=1:sims
    count=1;
    for r=1:numreefs
        out(count,1)=r;
        out(count,2)=reefs.AIMS_sector(r);
        out(count,3)=YEARS(1,startyr);
        out(count,4)=YEARS(1,censusyr);
        out(count,5)=SSP;
        out(count,6)=GCM;
        out(count,7)=s;
        out(count,42)=totalcoral(s,r,censusyr);
        out(count,8)=log(out(count,42)+0.1);
        cyclones=record_applied_cyclones(s,r,startyr:censusyr);
        out(count,43)=nnz(cyclones);
        out(count,9)=nnz(cyclones);
        cyclonesizes=cyclones(1,cyclones(1,:)>0);
        out(count,44)=mean(cyclonesizes);
        out(count,10)=log(out(count,44)+0.1);
        [crap,cycloneyrs]=find(record_applied_cyclones(s,r,:)>0);
        if isempty(cycloneyrs)==1
            out(count,45)=censusyr-startyr; % there hasn't been a cyclone
        else
            for i=1:length(cycloneyrs)
                if cycloneyrs(i,1)>=startyr && cycloneyrs(i,1)<=censusyr
                    out(count,45)=censusyr-cycloneyrs(i,1);
                end
            end
        end
        out(count,11)=sqrt(out(count,45));
        dhws=record_applied_DHWs(s,r,startyr:censusyr);
        [crap,allbleachingevents]=find(record_applied_DHWs(s,r,:)>=6);
        dhws_period=dhws(dhws(1,:)>=6);
        out(count,46)=length(dhws_period);
        out(count,12)=log(out(count,46)+0.1);
        out(count,47)=mean(dhws_period);
        out(count,13)=log(out(count,47)+0.1);
        if isempty(allbleachingevents)==1
            out(count,48)=censusyr-startyr; % there hasn't been a cyclone
        else
            for i=1:length(allbleachingevents)
                if allbleachingevents(i,1)>=startyr && allbleachingevents(i,1)<=censusyr
                    out(count,48)=censusyr-allbleachingevents(i,1);
                end
            end
        end
        out(count,14)=sqrt(out(count,48));
        out(count,49)=sum(totaladultcots(s,r,startyr:censusyr),3);
        out(count,15)=sqrt(out(count,49));
        out(count,50)=mean(totaladultcots(s,r,startyr:censusyr),3);
        out(count,16)=sqrt(out(count,50));
        out(count,51)=sum(COTS_CONTROL_culled_reefs(s,r,startyr:censusyr),3);
       % out(count,51)=sum(record_culled_reefs(s,r,startyr:censusyr),3);
        out(count,17)=log(out(count,51)+0.1);
        %[crap,cotsctrlyrs]=find(record_culled_reefs(s,r,:)>0);
        [crap,cotsctrlyrs]=find(COTS_CONTROL_culled_reefs(s,r,:)>0);
        if isempty(cotsctrlyrs)==1
            out(count,52)=censusyr-startyr; % there hasn't been a cyclone
        else
            for i=1:length(cotsctrlyrs)
                if cotsctrlyrs(i,1)>=startyr && cotsctrlyrs(i,1)<=censusyr
                    out(count,52)=censusyr-cotsctrlyrs(i,1);
                end
            end
        end
        out(count,18)=log(out(count,52)+0.1);
        out(count,53)=mean(totallarvae(s,r,startyr:censusyr),3);
        out(count,19)=log(out(count,53)+0.1);
        out(count,54)=mean(totallarvae(s,r,censusyr-5:censusyr),3);
        out(count,20)=log(out(count,54)+0.1);
        out(count,21)=mean(rubble(s,r,censusyr-5:censusyr),3);
        out(count,55)=mean(rubble(s,r,censusyr-5:censusyr),3);
        out(count,56)=ReefModWQdrivers.WQ_repro(r);
        out(count,22)=sqrt(out(count,56));
        out(count,57)=ReefModWQdrivers.WQ_recruit(r);
        out(count,23)=sqrt(out(count,57));
        out(count,58)=ReefModWQdrivers.WQ_juv(r);
        out(count,24)=sqrt(out(count,58));
        out(count,59)=mean(meanHT(s,r,censusyr-5:censusyr));
        count=count+1;
    end
        out(:,25)=normalize(out(:,8));
        out(:,26)=normalize(out(:,9));
        out(:,27)=normalize(out(:,10));
        out(:,28)=normalize(out(:,11));
        out(:,29)=normalize(out(:,12));
        out(:,30)=normalize(out(:,13));
        out(:,31)=normalize(out(:,14));
        out(:,32)=normalize(out(:,15));
        out(:,33)=normalize(out(:,16));
        out(:,34)=normalize(out(:,17));
        out(:,35)=normalize(out(:,18));
        out(:,36)=normalize(out(:,19));
        out(:,37)=normalize(out(:,20));
        out(:,38)=normalize(out(:,21));
        out(:,39)=normalize(out(:,22));
        out(:,40)=normalize(out(:,23));
        out(:,41)=normalize(out(:,24));
        out(:,60)=normalize(out(:,59));
        if s==1
            out2=out;
        else
            out2=[out2;out];
        end
end

