function [sys,x0,str,ts] = S_my_twohoists(t,x,u,flag,file,sampleTime,TS,period)
%Automatically generated S-Function

switch flag
    case 0
        %initialize
        [sys,x0,str,ts]=mdlInitializeSizes(t,x,u,file,sampleTime,period,TS);        
    case 2
        %Update discrete states
        sys=mdlUpdate(t+sampleTime,x,u,file,sampleTime,period,TS);
    case 3
        %Update discrete outputs
        sys=mdlOutputs(x);
	case 9
        %Terminate
        sys=mdlTerminate();
    otherwise
        error(['Unhandled flag ',num2str(flag)]);
end

%%
%Initialize
function [sys,x0,str,ts]=mdlInitializeSizes(t,x,u,file,sampleTime,period,TS)

sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 46;
sizes.NumOutputs     = 32;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);
[start,len,proc] = get_schedule(TS);
stop = start+TS.ProcTime;
T1trans = vrgetpar(file, 'T1', 'translation');
T2trans = vrgetpar(file, 'T2', 'translation');
T3trans = vrgetpar(file, 'T3', 'translation');
T4trans = vrgetpar(file, 'T4', 'translation');
H1trans = vrgetpar(file, 'Hoist1', 'translation');
H2trans = vrgetpar(file, 'Hoist2', 'translation');
Arm1_trans = vrgetpar(file, 'Arm1', 'translation');
ArmStick1_trans = vrgetpar(file, 'ArmStick1', 'height');
Wrist1_trans = vrgetpar(file, 'Wrist1', 'translation');
Arm2_trans = vrgetpar(file, 'Arm2', 'translation');
ArmStick2_trans = vrgetpar(file, 'ArmStick2', 'height');
Wrist2_trans = vrgetpar(file, 'Wrist2', 'translation');
x0 = [zeros(1,2) T1trans T2trans T3trans T4trans H1trans H2trans Arm1_trans ArmStick1_trans Wrist1_trans Arm2_trans ArmStick2_trans Wrist2_trans start stop proc];
x0 = mdlUpdate(0,x0',0,file,sampleTime,period,TS);
str = [];
ts  = [-1 0];

%%
%Update discrete states
function sys=mdlUpdate(t,x,u,file,sampleTime,period,TS)

dt = round(t/sampleTime);
t = dt*sampleTime;

T1trans = vrgetpar(file, 'T1', 'translation');
T2trans = vrgetpar(file, 'T2', 'translation');
T3trans = vrgetpar(file, 'T3', 'translation');
T4trans = vrgetpar(file, 'T4', 'translation');
H1trans = vrgetpar(file, 'Hoist1', 'translation');
H2trans = vrgetpar(file, 'Hoist2', 'translation');
Arm1_trans = vrgetpar(file, 'Arm1', 'translation');
ArmStick1_trans = vrgetpar(file, 'ArmStick1', 'height');
Wrist1_trans = vrgetpar(file, 'Wrist1', 'translation');
Arm2_trans = vrgetpar(file, 'Arm2', 'translation');
ArmStick2_trans = vrgetpar(file, 'ArmStick2', 'height');
Wrist2_trans = vrgetpar(file, 'Wrist2', 'translation');

%Do this every sample

pause(0.05)

%task 1
if isin(x(35),x(39),period,dt)
	
end
if isin(x(35)+-20,x(35)+-10,period,dt) && ((mod(dt-rem(x(35),period),1) == 0) || period == inf)
	start = get_schedule(TS);
	treshold = start(1)-mod(dt,period)-10-period*rem(start(1),period);
	if H1trans(1) >= treshold && H1trans(1) > 0
	H1trans(1) = H1trans(1) - 1;
	end
end
if isin(x(35)+0,x(35)+0,period,dt)
	x(1) = x(1)+1;
	w=vrworld('twohoists.wrl');
	open(w)
	node = vrnode(w,'Counter');
	str{1} = {num2str(max(0,5-x(1)))};
	setfield(node,'string', str{1}) 
	close(w)
end
if isin(x(35)+0,x(35)+4,period,dt) && ((mod(dt-rem(x(35),period),1) == 0) || period == inf)
	T1trans(1) = T1trans(1) + 1;
end
if isin(x(35)+0,x(35)+7,period,dt) && ((mod(dt-rem(x(35),period),1) == 0) || period == inf)
	Arm1_trans(2) = Arm1_trans(2) - 0.5;
	Wrist1_trans(2) = Wrist1_trans(2) - 0.5;
	ArmStick1_trans = ArmStick1_trans + 1;
end
if isin(x(35)+8,x(35)+15,period,dt) && ((mod(dt-rem(x(35),period),1) == 0) || period == inf)
	T1trans(2) = T1trans(2) + 1;
	Arm1_trans(2) = Arm1_trans(2) + 0.5;
	Wrist1_trans(2) = Wrist1_trans(2) + 0.5;
	ArmStick1_trans = ArmStick1_trans - 1;
end
if isin(x(35)+16,x(35)+20,period,dt) && ((mod(dt-rem(x(35),period),1) == 0) || period == inf)
	T1trans(1) = T1trans(1) + 1;
	H1trans(1) = H1trans(1) + 1;
end
if isin(x(35)+21,x(35)+28,period,dt) && ((mod(dt-rem(x(35),period),1) == 0) || period == inf)
	T1trans(2) = T1trans(2) - 1;
	Arm1_trans(2) = Arm1_trans(2) - 0.5;
	Wrist1_trans(2) = Wrist1_trans(2) - 0.5;
	ArmStick1_trans = ArmStick1_trans + 1;
end
if isin(x(35)+29,x(35)+36,period,dt) && ((mod(dt-rem(x(35),period),1) == 0) || period == inf)
	Arm1_trans(2) = Arm1_trans(2) + 0.5;
	Wrist1_trans(2) = Wrist1_trans(2) + 0.5;
	ArmStick1_trans = ArmStick1_trans - 1;
end
if isin(x(35)+29,x(35)+29,period,dt)
	T1trans(1) = -5;
end
%end of task 1

%task 2
if isin(x(36),x(40),period,dt)
	
end
if isin(x(36)+-20,x(36)+-10,period,dt) && ((mod(dt-rem(x(36),period),1) == 0) || period == inf)
	start = get_schedule(TS);
	treshold = start(2)-mod(dt,period)-10-period*rem(start(2),period);
	if abs(H1trans(1)-5) >= treshold
	if H1trans(1) > 5
	H1trans(1) = H1trans(1) - 1;
	end
	if H1trans(1) < 5
	H1trans(1) = H1trans(1) + 1;
	end
	end
end
if isin(x(36)+0,x(36)+7,period,dt) && ((mod(dt-rem(x(36),period),1) == 0) || period == inf)
	Arm1_trans(2) = Arm1_trans(2) - 0.5;
	Wrist1_trans(2) = Wrist1_trans(2) - 0.5;
	ArmStick1_trans = ArmStick1_trans + 1;
end
if isin(x(36)+8,x(36)+15,period,dt) && ((mod(dt-rem(x(36),period),1) == 0) || period == inf)
	T2trans(2) = T2trans(2) + 1;
	Arm1_trans(2) = Arm1_trans(2) + 0.5;
	Wrist1_trans(2) = Wrist1_trans(2) + 0.5;
	ArmStick1_trans = ArmStick1_trans - 1;
end
if isin(x(36)+16,x(36)+20,period,dt) && ((mod(dt-rem(x(36),period),1) == 0) || period == inf)
	T2trans(1) = T2trans(1) + 1;
	H1trans(1) = H1trans(1) + 1;
end
if isin(x(36)+21,x(36)+28,period,dt) && ((mod(dt-rem(x(36),period),1) == 0) || period == inf)
	T2trans(2) = T2trans(2) - 1;
	Arm1_trans(2) = Arm1_trans(2) - 0.5;
	Wrist1_trans(2) = Wrist1_trans(2) - 0.5;
	ArmStick1_trans = ArmStick1_trans + 1;
end
if isin(x(36)+29,x(36)+36,period,dt) && ((mod(dt-rem(x(36),period),1) == 0) || period == inf)
	Arm1_trans(2) = Arm1_trans(2) + 0.5;
	Wrist1_trans(2) = Wrist1_trans(2) + 0.5;
	ArmStick1_trans = ArmStick1_trans - 1;
end
if isin(x(36)+29,x(36)+29,period,dt)
	T2trans(1) = 5;
end
%end of task 2

%task 3
if isin(x(37),x(41),period,dt)
	
end
if isin(x(37)+-20,x(37)+-10,period,dt) && ((mod(dt-rem(x(37),period),1) == 0) || period == inf)
	start = get_schedule(TS);
	treshold = start(3)-mod(dt,period)-10-period*rem(start(3),period);
	if abs(H2trans(1)-10) >= treshold && H2trans(1) > 10
	H2trans(1) = H2trans(1) - 1;
	end
end
if isin(x(37)+0,x(37)+7,period,dt) && ((mod(dt-rem(x(37),period),1) == 0) || period == inf)
	Arm2_trans(2) = Arm2_trans(2) - 0.5;
	Wrist2_trans(2) = Wrist2_trans(2) - 0.5;
	ArmStick2_trans = ArmStick2_trans + 1;
end
if isin(x(37)+8,x(37)+15,period,dt) && ((mod(dt-rem(x(37),period),1) == 0) || period == inf)
	T3trans(2) = T3trans(2) + 1;
	Arm2_trans(2) = Arm2_trans(2) + 0.5;
	Wrist2_trans(2) = Wrist2_trans(2) + 0.5;
	ArmStick2_trans = ArmStick2_trans - 1;
end
if isin(x(37)+16,x(37)+20,period,dt) && ((mod(dt-rem(x(37),period),1) == 0) || period == inf)
	T3trans(1) = T3trans(1) + 1;
	H2trans(1) = H2trans(1) + 1;
end
if isin(x(37)+21,x(37)+28,period,dt) && ((mod(dt-rem(x(37),period),1) == 0) || period == inf)
	T3trans(2) = T3trans(2) - 1;
	Arm2_trans(2) = Arm2_trans(2) - 0.5;
	Wrist2_trans(2) = Wrist2_trans(2) - 0.5;
	ArmStick2_trans = ArmStick2_trans + 1;
end
if isin(x(37)+29,x(37)+36,period,dt) && ((mod(dt-rem(x(37),period),1) == 0) || period == inf)
	Arm2_trans(2) = Arm2_trans(2) + 0.5;
	Wrist2_trans(2) = Wrist2_trans(2) + 0.5;
	ArmStick2_trans = ArmStick2_trans - 1;
end
if isin(x(37)+29,x(37)+29,period,dt)
	T3trans(1) = 10;
end
%end of task 3

%task 4
if isin(x(38),x(42),period,dt)
	
end
if isin(x(38)+-20,x(38)+-10,period,dt) && ((mod(dt-rem(x(38),period),1) == 0) || period == inf)
	start = get_schedule(TS);
	treshold = start(4)-mod(dt,period)-period*rem(start(4),period)-10;
	if abs(H2trans(1)-15) >= treshold
	if H2trans(1) > 15
	H2trans(1) = H2trans(1) - 1;
	end
	if H2trans(1) < 15
	H2trans(1) = H2trans(1) + 1;
	end
	end
end
if isin(x(38)+0,x(38)+7,period,dt) && ((mod(dt-rem(x(38),period),1) == 0) || period == inf)
	Arm2_trans(2) = Arm2_trans(2) - 0.5;
	Wrist2_trans(2) = Wrist2_trans(2) - 0.5;
	ArmStick2_trans = ArmStick2_trans + 1;
end
if isin(x(38)+8,x(38)+15,period,dt) && ((mod(dt-rem(x(38),period),1) == 0) || period == inf)
	T4trans(2) = T4trans(2) + 1;
	Arm2_trans(2) = Arm2_trans(2) + 0.5;
	Wrist2_trans(2) = Wrist2_trans(2) + 0.5;
	ArmStick2_trans = ArmStick2_trans - 1;
end
if isin(x(38)+16,x(38)+20,period,dt) && ((mod(dt-rem(x(38),period),1) == 0) || period == inf)
	T4trans(1) = T4trans(1) + 1;
	H2trans(1) = H2trans(1) + 1;
end
if isin(x(38)+21,x(38)+28,period,dt) && ((mod(dt-rem(x(38),period),1) == 0) || period == inf)
	T4trans(2) = T4trans(2) - 1;
	Arm2_trans(2) = Arm2_trans(2) - 0.5;
	Wrist2_trans(2) = Wrist2_trans(2) - 0.5;
	ArmStick2_trans = ArmStick2_trans + 1;
end
if isin(x(38)+29,x(38)+36,period,dt) && ((mod(dt-rem(x(38),period),1) == 0) || period == inf)
	Arm2_trans(2) = Arm2_trans(2) + 0.5;
	Wrist2_trans(2) = Wrist2_trans(2) + 0.5;
	ArmStick2_trans = ArmStick2_trans - 1;
end
if isin(x(38)+35,x(38)+35,period,dt)
	T4trans(1) = 15;
end
if isin(x(38)+30,x(38)+34,period,dt) && ((mod(dt-rem(x(38),period),1) == 0) || period == inf)
	T4trans(1) = T4trans(1) + 1;
end
if isin(x(38)+34,x(38)+34,period,dt)
	x(2) = x(2)+1;
	w=vrworld('twohoists.wrl');
	open(w)
	node = vrnode(w,'Counter2');
	str{1} = {num2str(x(2))};
	setfield(node,'string', str{1}) 
	close(w)
end
%end of task 4

sys = [x(1:2)' T1trans T2trans T3trans T4trans H1trans H2trans Arm1_trans ArmStick1_trans Wrist1_trans Arm2_trans ArmStick2_trans Wrist2_trans x(35:end)'];

%%
%Update discrete outputs
function sys=mdlOutputs(x)

sys = x(3:34);

%%
%Terminate
function sys=mdlTerminate()

sys = [];

%%
%Internal function for recognition of active tasks
function status = isin(start, stop, period, t)

if start<=t & isfinite(period)
    curPeriodOffset = period*floor((t-start)/period);
    start = start + curPeriodOffset;
    stop = stop + curPeriodOffset;
end
if t>=start && t<=stop
    status = 1;
else
    status = 0;
end
