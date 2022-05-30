clc;
close all;
clear all;
%%
sched=[1 2 3]; % PF; FLS; MLWDF
users=[10 30 50];
delay=[0.1];
speed=[0 3 120];

test='TPUTTOTAL';
for v=1:length(speed)
for ue=1:length(users)
    for s=1:length(sched)
        dat=load(strcat('../OUT/NonRtTraffic/',test,'_SCHED_',num2str(sched(s)),'_UE_',num2str(users(ue)), '_V_',num2str(speed(v))));
        mat(s,ue)=mean(dat);
    end
    end
    t=strcat('NonRtTraffic/',test,'_SPEED_',num2str(speed(v)),'_UEs_',num2str(users(ue)));
    x='Number of connected UEs';
    y='Throughput [Mbps]';
    ymax=60;
    mat=mat./1000000;
    ymin=0;
    plotnormal(mat',t, x, y, ymin, ymax)
end

test='FAIRNESSTOTAL';
for v=1:length(speed)
for ue=1:length(users)
    for s=1:length(sched)
        dat=load(strcat('../OUT/NonRtTraffic/',test,'_SCHED_',num2str(sched(s)),'_UE_',num2str(users(ue)), '_V_',num2str(speed(v))));
        mat(s,ue)=mean(dat);
    end
    end
    t=strcat('NonRtTraffic/',test,'_SPEED_',num2str(speed(v)),'_UEs_',num2str(users(ue)));
    x='Number of connected UEs';
    y='Fairness';
    ymax=1;
    ymin=0;
    plotnormal(mat',t, x, y, ymin, ymax)
end

test='CQITOTAL';
for v=1:length(speed)
for ue=1:length(users)
    for s=1:length(sched)
        dat=load(strcat('../OUT/NonRtTraffic/',test,'_SCHED_',num2str(sched(s)),'_UE_',num2str(users(ue)), '_V',num2str(speed(v))));
        mat(s,ue)=mean(dat);
    end
    end
    t=strcat('NonRtTraffic/',test,'_SPEED_',num2str(speed(v)),'_UEs_',num2str(users(ue)));
    x='Number of connected UEs';
    y='CQI';
    ymax=15;
    ymin=0;
    plotnormal(mat',t, x, y, ymin, ymax)
end

test='BLERTOTAL';
for v=1:length(speed)
for ue=1:length(users)
    for s=1:length(sched)
        dat=load(strcat('../OUT/NonRtTraffic/',test,'_SCHED_',num2str(sched(s)),'_UE_',num2str(users(ue)), '_V',num2str(speed(v))));
        mat(s,ue)=mean(dat);
    end
    end
    t=strcat('NonRtTraffic/',test,'_SPEED_',num2str(speed(v)),'_UEs_',num2str(users(ue)));
    x='Number of connected UEs';
    y='BLER';
    ymax=1;
    ymin=0;
    plotnormal(mat',t, x, y, ymin, ymax)
end