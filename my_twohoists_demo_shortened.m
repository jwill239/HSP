% TWOHOISTS_DEMO Demo application of the hoist scheduling problem visualization.
%
%    See also TASKSET2SIMULINK


% Author: Roman Capek <capekr1@fel.cvut.cz>
% Originator: Michal Kutil <kutilm@fel.cvut.cz>
% Originator: Premysl Sucha <suchap@fel.cvut.cz>
% Project Responsible: Zdenek Hanzalek
% Department of Control Engineering
% FEE CTU in Prague, Czech Republic
% Copyright (c) 2004 - 2009 
% $Revision: 2958 $  $Date:: 2009-07-15 11:03:10 +0200 #$


% This file is part of TORSCHE Scheduling Toolbox for Matlab.
% TORSCHE Scheduling Toolbox for Matlab can be used, copied 
% and modified under the next licenses
%
% - GPL - GNU General Public License
%
% - and other licenses added by project originators or responsible
%
% Code can be modified and re-distributed under any combination
% of the above listed licenses. If a contributor does not agree
% with some of the licenses, he/she can delete appropriate line.
% If you delete all lines, you are not allowed to distribute 
% source code and/or binaries utilizing code.
%
% --------------------------------------------------------------
%                  GNU General Public License  
%
% TORSCHE Scheduling Toolbox for Matlab is free software;
% you can redistribute it and/or modify it under the terms of the
% GNU General Public License as published by the Free Software
% Foundation; either version 2 of the License, or (at your option)
% any later version.
% 
% TORSCHE Scheduling Toolbox for Matlab is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY;
% without even the implied warranty of MERCHANTABILITY or 
% FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with TORSCHE Scheduling Toolbox for Matlab; if not, write
% to the Free Software Foundation, Inc., 59 Temple Place,
% Suite 330, Boston, MA 02111-1307 USA


% try moving to directory on left - and then open this file
% paths should already be added
addpath( '/Applications/MATLAB_R2018b.app/toolbox/TORSCHE-master/scheduling')
% addpath( '/Applications/MATLAB_R2018b.app/toolbox/TORSCHE-master/scheduling/stdemos')
%addpath('/Users/jules/Documents')

clc;
clear all;

destDir = '/Users/jules/Documents/MATLAB/twohoist'
myfilename = 'my_twohoists_demo.m'

% destDir = prefdir;  % need to change this

%Define taskset
T = taskset([30 30 30 30]);
adduserparam(T,'my_twohoists.txt');

%Set schedule
add_schedule(T, 'my_twohoists', [15 60 130 175], T.ProcTime)

% these have been added by me from taskset2simulink.m
simulink = 1;
sampleTime = 1;
period = [];
connect = 0;


%Define Virtual Reality file
name = 'my_twohoists.wrl';

%Define parameters for simulation in simulink
stopTime = 5400;
period = 105;

%Define inputs and outputs for S-Function block
ports = visiscontrolports('Output','T1trans',3,'T2trans',3,'T3trans',3,'T4trans',3 ...
                ,'H1trans',3,'H2trans',3,'Arm1_trans',3,'ArmStick1_trans',1,'Wrist1_trans',3 ...
                ,'Arm2_trans',3,'ArmStick2_trans',1,'Wrist2_trans',3);



