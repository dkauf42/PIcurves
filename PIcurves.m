function [ handles ] = PIcurves( varargin )
%PICURVES Makes figures of 2 common photosynthesis-irradiance relationships
%   The two P-I curves plotted are from:
%           1) Evans & Parslow (1985)
%           2) Platt et al (1980)
%
%   PICURVES()
%   PICURVES(..., 'form'      , string ) 
%   PICURVES(..., 'PBs'       , numeric) 
%   PICURVES(..., 'alpha'     , numeric) 
%   PICURVES(..., 'beta'      , numeric)
%   PICURVES(..., 'trappings' , string)
%   
%   Parameter/Value Pairs:
%    'form'      - string, either 'Evans and Parslow' or 'Platt' 
%                                           (default is 'Evans')
%    'PBs'       - number (default is 1.07)
%    'alpha'     - number (default is 0.03)
%    'beta'      - number (default is 0.00) (Note: Beta is not used in the 
%                                              'Evans' form)
%    'trappings' - string, either 'on' or 'off' (default is 'on')
%
%  References: 
%   1) Evans, G.T., Parslow, J.S., 1985. A Model of Annual Plankton Cycles.
%       Biol. Oceanogr. 3, 327?347.
%   2) Platt, T., Gallegos, C.L., Harrison, W.G., 1980. Photoinhibition of
%       Photosynthesis in Natural Assemblages of Marine Phytoplankton. 
%       J. Mar. Res. 38.
%
% MFILE:   PIcurves.m
% MATLAB:  8.5.0.197613 (R2015a)
% AUTHOR:  Daniel E. Kaufman, @ The Virginia Institute of Marine Science
% CONTACT: dkauf42@gmail.com
%
%  REVISIONS:
%   - Initial Generation. (Apr, 2015)
%   - Added switch for PI curve forms and 'trappings' option. (Apr, 2015)

defaultValues.form  = 'Evans';
defaultValues.PBs   = 1.07;
defaultValues.alpha = 0.03;
defaultValues.beta  = 0.00;

validForms = {'Platt', 'Evans and Parslow'};
validTrappings = {'on', 'off'};
%% Initial Function Housekeeping, parse input arguments
p=inputParser;
    addParameter(p,'form' , defaultValues.form , ...
                            @(x) any(validatestring(x, validForms)))
    addParameter(p,'PBs'  , defaultValues.PBs  , @isnumeric);
    addParameter(p,'alpha', defaultValues.alpha, @isnumeric);
    addParameter(p,'beta' , defaultValues.beta , @isnumeric);
    addParameter(p,'trappings' , 'on' ,...
                            @(x) any(validatestring(x,validTrappings)));
parse(p,varargin{:})
form  = validatestring(p.Results.form, validForms);
PBs   = p.Results.PBs;
alpha = p.Results.alpha;
beta  = p.Results.beta;
trappings  = validatestring(p.Results.trappings,validTrappings);

%% Make the PI curve plots
handles = struct();
syms E;
handles.fig = gcf;

switch form
    case 'Platt'
        handles.ezplot = ezplot( PBs*(1-exp( (-alpha*E)/PBs ) )*exp( (-beta*E)/PBs ), [0 100]);
        titlestr = ['P^{B}_{s} * [1 - exp( (-\alpha*E)/P^{B}_{s} )  ] ',...
               '* exp( (-\beta*E)/P^{B}_{s} )'];
        parametersString = [form,'; P^{B}_{s} = ',num2str(PBs),...
                            ' ; \alpha = ', num2str(alpha),...
                            ' ; \beta = ',num2str(beta)];
    case 'Evans and Parslow'
        handles.ezplot = ezplot( (PBs*alpha*E)/sqrt(PBs^2 + (alpha*E)^2) , [0 150]);
        titlestr = '(P^{B}_{s}*\alpha*E) / sqrt(P^{B}_{s}^{2} + (\alpha*E)^2)';
        parametersString = [form,'; P^{B}_{s} = ',num2str(PBs),...
                            ' ; \alpha = ', num2str(alpha)];
end

if strcmp(trappings,'on')
    title(titlestr);
    ylim([0 1.2]);
    ylabel('P^{B}');
    figAnnotate_subfcn(handles.fig,parametersString);
end

end

function figAnnotate_subfcn(figHandle,upperRightSideText)
set(0,'CurrentFigure',figHandle);
mainAxis = gca;
axInvis = axes('parent',figHandle,'Position',[0 0 1 1],'Visible','off');

% Generate Upper Right Side Text
axes(axInvis) % sets axInvis to current axes
text(0.975,0.25,upperRightSideText,'Rotation',90,'FontSize',10);

axes(mainAxis); % reset the main Axis to the main one
end

