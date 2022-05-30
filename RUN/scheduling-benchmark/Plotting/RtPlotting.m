clc;
close all;
clear all;
%%
sched=[1 2 3]; % PF; FLS; MLWDF
users=[10 30 50];
delay=[0.02 0.05 0.1];
speed=[0 3 120];

test='DELVIDEO';
for v=1:length(speed)
for d=1:length(delay)
for ue=1:length(users)
    for s=1:length(sched)
        dat=load(strcat('../OUT/RtTraffic/',test,'_SCHED_',num2str(sched(s)),'_UE_',num2str(users(ue)), '_V_',num2str(speed(v)),'_D_',num2str(delay(d))));
        mat(s,ue)=mean(dat);
    end
    end
    t=strcat('RtTraffic/',test,'_SPEED_',num2str(speed(v)),'_UEs_',num2str(users(ue)),'_D_',num2str(delay(d)));
    x='Number of connected UEs';
    y='Average delay [s]';
    ymax=max(max(max(mat)),0.1);
    ymin=0;
    plotnormal(mat',t, x, y, ymin, ymax)
end
end

test='PLRVIDEO';
for v=1:length(speed)
for d=1:length(delay)
for ue=1:length(users)
    for s=1:length(sched)
        dat=load(strcat('../OUT/RtTraffic/',test,'_SCHED_',num2str(sched(s)),'_UE_',num2str(users(ue)), '_V_',num2str(speed(v)),'_D_',num2str(delay(d))));
        mat(s,ue)=mean(dat);
    end
    end
    t=strcat('RtTraffic/',test,'_SPEED_',num2str(speed(v)),'_UEs_',num2str(users(ue)),'_D_',num2str(delay(d)));
    x='Number of connected UEs';
    y='Packet loss ratio [%]';
    ymax=max(max(max(mat)),1);
    ymin=0;
    plotnormal(mat',t, x, y, ymin, ymax)
end
end

test='DELVOIP';
for v=1:length(speed)
for d=1:length(delay)
for ue=1:length(users)
    for s=1:length(sched)
        dat=load(strcat('../OUT/RtTraffic/',test,'_SCHED_',num2str(sched(s)),'_UE_',num2str(users(ue)), '_V_',num2str(speed(v)),'_D_',num2str(delay(d))));
        mat(s,ue)=mean(dat);
    end
    end
    t=strcat('RtTraffic/',test,'_SPEED_',num2str(speed(v)),'_UEs_',num2str(users(ue)),'_D_',num2str(delay(d)));
    x='Number of connected UEs';
    y='Average delay [s]';
    ymax=max(max(max(mat)),0.1);
    ymin=0;
    plotnormal(mat',t, x, y, ymin, ymax)
end
end

test='PLRVOIP';
for v=1:length(speed)
for d=1:length(delay)
for ue=1:length(users)
    for s=1:length(sched)
        dat=load(strcat('../OUT/RtTraffic/',test,'_SCHED_',num2str(sched(s)),'_UE_',num2str(users(ue)), '_V_',num2str(speed(v)),'_D_',num2str(delay(d))));
        mat(s,ue)=mean(dat);
    end
    end
    t=strcat('RtTraffic/',test,'_SPEED_',num2str(speed(v)),'_UEs_',num2str(users(ue)),'_D_',num2str(delay(d)));
    x='Number of connected UEs';
    y='Packet loss ratio [%]';
    ymax=max(max(max(mat)),1);
    ymin=0;
    plotnormal(mat',t, x, y, ymin, ymax)
end
end

test='TPUTVIDEO';
for v=1:length(speed)
for d=1:length(delay)
for ue=1:length(users)
    for s=1:length(sched)
        dat=load(strcat('../OUT/RtTraffic/',test,'_SCHED_',num2str(sched(s)),'_UE_',num2str(users(ue)), '_V_',num2str(speed(v)),'_D_',num2str(delay(d))));
        mat(s,ue)=mean(dat);
    end
    end
    t=strcat('RtTraffic/',test,'_SPEED_',num2str(speed(v)),'_UEs_',num2str(users(ue)),'_D_',num2str(delay(d)));
    x='Number of connected UEs';
    y='Video Throughput [Mbps]';
    mat=mat./1000000;
    ymax=max(max(mat));
    ymin=0;
    plotnormal(mat',t, x, y, ymin, ymax)
end
end

test='TPUTVOIP';
for v=1:length(speed)
for d=1:length(delay)
for ue=1:length(users)
    for s=1:length(sched)
        dat=load(strcat('../OUT/RtTraffic/',test,'_SCHED_',num2str(sched(s)),'_UE_',num2str(users(ue)), '_V_',num2str(speed(v)),'_D_',num2str(delay(d))));
        mat(s,ue)=mean(dat);
    end
    end
    t=strcat('RtTraffic/',test,'_SPEED_',num2str(speed(v)),'_UEs_',num2str(users(ue)),'_D_',num2str(delay(d)));
    x='Number of connected UEs';
    y='VoIP Throughput [Mbps]';
    mat=mat./1000000;
    ymax=max(max(mat));
    ymin=0;
    plotnormal(mat',t, x, y, ymin, ymax)
end
end
test='CQITOTAL';
for v=1:length(speed)
for d=1:length(delay)
for ue=1:length(users)
    for s=1:length(sched)
        dat=load(strcat('../OUT/RtTraffic/',test,'_SCHED_',num2str(sched(s)),'_UE_',num2str(users(ue)), '_V_',num2str(speed(v)),'_D_',num2str(delay(d))));
        mat(s,ue)=mean(dat);
    end
    end
    t=strcat('RtTraffic/',test,'_SPEED_',num2str(speed(v)),'_UEs_',num2str(users(ue)),'_D_',num2str(delay(d)));
    x='Number of connected UEs';
    y='CQI';
    ymax=15;
    ymin=0;
    plotnormal(mat',t, x, y, ymin, ymax)
end
end
test='BLERTOTAL';
for v=1:length(speed)
for d=1:length(delay)
for ue=1:length(users)
    for s=1:length(sched)
        dat=load(strcat('../OUT/RtTraffic/',test,'_SCHED_',num2str(sched(s)),'_UE_',num2str(users(ue)), '_V_',num2str(speed(v)),'_D_',num2str(delay(d))));
        mat(s,ue)=mean(dat);
    end
    end
    t=strcat('RtTraffic/',test,'_SPEED_',num2str(speed(v)),'_UEs_',num2str(users(ue)),'_D_',num2str(delay(d)));;
    x='Number of connected UEs';
    y='BLER';
    ymax=1;
    ymin=0;
    plotnormal(mat',t, x, y, ymin, ymax)
end
end