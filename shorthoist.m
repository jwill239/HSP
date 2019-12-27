% ONEHOIST_DEMO Demo application of the hoist scheduling problem visualization.
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


% this is what I did to get a running animation
% 1. run the file as presented - generate a mdl file - that probably won't
% load.
% 2. Find the error in the file - it was creating a second output block
% 3. Use the information in the mdl file to manually complete the simulink
% model.  Export as a slx file.
% 4. Edited taskset2simulink.m to open the slx file not the file passed to
% it
% 5. I think that generates the wrl file?????
% 6. Run a shortened version of the original file, removing the steps that
% try to run the simulink automatically and added some variables that are
% needed - see this file further down
% 7. Run the simulink - making sure the S-function parameters point to the
% wrl file.

% try moving to directory on left - and then open this file
% paths should already be added
addpath( '/Applications/MATLAB_R2018b.app/toolbox/TORSCHE-master/scheduling')
% addpath( '/Applications/MATLAB_R2018b.app/toolbox/TORSCHE-master/scheduling/stdemos')
%addpath('/Users/jules/Documents')

clc;
clear all;

 %destDir = prefdir;
destDir = '/Users/jules/Documents/MATLAB/Saturday'

%Minimum and maximum processing time in stages
a = [0 70 70 30];
b = [0 100 200 75];

%Empty hoist move times
C = toeplitz([0 15 20 25]);

%Loaded hoist move times
d = [36 36 36 51];

%Define taskset
T = taskset(d);
adduserparam(T,'onehoist.txt');

T.TSUserParam.SetupTime = C;
T.TSUserParam.minDistance = a;
T.TSUserParam.maxDistance = b;

schoptions = schoptionsset(); 

%Schedule tasks
TS = singlehoist(T,schoptions,0);

% these have been added by me from taskset2simulink.m
simulink = 1;
sampleTime = 1;
period = [];
connect = 0;

%Virutal Reality file name /Users/jules/Documents
name = 'onehoist.wrl';

%Define parameters for simulation in simulink
stopTime = 1039;
period = 208;

%Define inputs and outputs for S-Function block
ports = visiscontrolports('Output','T1trans',3,'T2trans',3,'T3trans',3,'T4trans',3 ...
                ,'H1trans',3,'Wrist1',3,'ArmStick1',1,'Fingers1',3,'Upper_text',3,'Pointer',3);
