
clear all;
close all;

t_on = [];   % here is the distribution of activation times
tmax = 150;

x_on = [];   % the activation times 
x_off = [];   % y offset time 
y_on = [];   % y activation time

for i = 0:199
  
    %fprintf(['processing trace number ' num2str(i) '\n']);
    data = readtable(['data/data_' num2str(i) '.csv']);
    t = data{:,'Var1'};   % time
    V = data{:,'Var2'};   % normalized volume of the cell
    x = data{:,'Var4'};   % copy numer of x
    y = data{:,'Var6'};   % copy number of y
    
    threshold  = 500;   % threshold level of y for activation
    
    % y activation time
    x_ind = min(find(x./V > threshold));  % the index when activation occurs
    
    
    % x activation time 
    if isempty(x_ind)     % there was no activation in the first place, therefore 
        x_on = [x_on Inf];
        x_off = [x_off Inf];
    else
        x_on = [x_on t(x_ind)];
        
        x_ind_max = max(find(x./V > threshold));   % the largest index where threshold is reached 
        x_off_inds = find(x./V <= threshold);  % calculate the offset times
        x_off_inds(find(x_off_inds < x_ind_max)) = [];   % throw out all the indices prior to gene activation
        x_off_ind = min(x_off_inds);     % this is the first index for the off transition
        
        
        if isempty(x_off_ind);   % no off event
            x_off = [x_off Inf];
        else
            x_off = [x_off t(x_off_ind)];
        end
    end

    % y activation
    y_ind = min(find(y./V > threshold));  % the index when activation occurs       
    if isempty(y_ind)
        y_on = [y_on -Inf];
    else
        y_on = [y_on t(y_ind)];
    end;
    
        % plotting code
%         tc = 10; nc = 35;  % plot the cell cycle parameters  
%         % plot the copy number of x
%         subplot(3,2,1);
%         % plot the cell cycle shadings
%         plot(t,x./V,'r'); xlabel('time (hrs)'); ylabel('X copies/cell volume)'); hold on;
%         axis([0 tmax -100 1500]);
% 
%         subplot(3,2,3);
%         % plot the cell cycle shadings
%         plot(t,y./V,'g'); xlabel('time (hrs)'); ylabel('X copies/cell volume)'); hold on;
%         axis([0 tmax -100 1500]);
        
        
        % plot the copy number of y
        
%         
%         subplot(3,2,3); hold on;
%         
%         if ~isempty(t_on)
%             area([t_on 150],[12000 12000],'FaceColor',[0.9 0.9 0.9],'LineStyle','none');
%         end
%         
%         plot(t,y./V,'k'); xlabel('time(hrs)'); ylabel('Y copies/cell volume');
%         axis([0 tmax -100 1000]);
%         
        % plot the cell cycling time
%         subplot(3,2,5);
%         color1 = [0.4 0.4 0.4];
%         color2 = [0.7 0.7 0.7];
%         
%         hold on;
%         for j = 1:2:nc
%             area([(j-1)*tc j*tc], [1 1], 'FaceColor',color1,'LineStyle','none');
%         end
%         for j = 2:2:nc
%             area([(j-1)*tc j*tc], [1 1], 'FaceColor',color2,'LineStyle','none');
%         end
%         
%         axis([0 tmax 0 10]);
%         axis off
% 
%         
        
end

figure(10);
area([median(x_on) median(x_off)],[-1 -1],'FaceColor', 'r', 'LineStyle', 'none'); hold on;
area([median(y_on) tmax],[-1 -1],'FaceColor', 'g', 'LineStyle', 'none'); hold on;
set(gca,'XLim',[0 tmax]);
set(gca,'YLim',[-25 0]);
median(y_on)
