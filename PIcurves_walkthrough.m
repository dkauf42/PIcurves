clear
%% Photosynthesis-irradiance Curve
%% Get the P-I data

containerdir = ['/Users/Danny/Desktop/CATEGORIES/CAREER_MANAGEMENT/VIMS/'...
            'Assistance/Helga_do_Rosario_Gomes/'];
datafile = [containerdir,'PE_Dan2016.csv'];

PIdata = readtable(datafile);
names = {'control', 'Peridinuim', 'Phaeodactylum'};

%% Examine the data

E  = PIdata.E;
y1 = PIdata.control_P_;
y2 = PIdata.Peridinuim_P_;
y3 = PIdata.Phaeodactylum_P_;

plotHandles = plot(E,[y1,y2,y3], 'marker','o', 'linestyle','-');
title('Data points')

%% Platt Equation:
 
% Let's define the parameters in terms of a single variable "x", so that
% 
% x(1) = PBs;
% x(2) = alpha;
% x(3) = beta;
% 
% Then we'll define the platt curve as a function of the parameter vector 
% "x" and the irradiance data, which will enter the function as "xdata"

F = @(x,xdata)x(1) * (1-exp( (-x(2)*xdata)/x(1) ) ) .* exp( (-x(3)*xdata)/x(1) );

% We need to set a starting point for the optimization routine... here we'll 
% use PBs=1000, alpha=600, beta = 0.00:

x0 = [1000 100 0.00];

%% Run the solver and plot the resulting fits
co=get(groot,'DefaultAxesColorOrder'); % Get default matlab colors

[x1,resnorm,~,exitflag,output] = lsqcurvefit(F,x0,E,y1);
hold on
plot(E,F(x1,E),  'linestyle','--', 'color',brighten(co(1,:),-0.5));

[x2,resnorm,~,exitflag,output] = lsqcurvefit(F,x0,E,y2);
plot(E,F(x2,E),  'linestyle','--', 'color',brighten(co(2,:),-0.5));

[x3,resnorm,~,exitflag,output] = lsqcurvefit(F,x0,E,y3);
plot(E,F(x3,E), 'linestyle','--', 'color',brighten(co(3,:),-0.5));

legend(plotHandles, names)

%% Print parameters to the command window
format shortG
disp('Parameter estimates of...')
disp({'PBs' , 'alpha', 'beta'})
disp([names{1},':'])
disp(x1)
disp([names{2},':'])
disp(x2)
disp([names{3},':'])
disp(x3)
format short