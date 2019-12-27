function [sys,x0,str,ts] = S_onehoist(t,x,u,flag,file,sampleTime,TS,period)
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
sizes.NumDiscStates  = 43;
sizes.NumOutputs     = 28;
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
H1trans = vrgetpar(file, 'Arm1', 'translation');
Wrist1 = vrgetpar(file, 'Wrist1', 'translation');
ArmStick1 = vrgetpar(file, 'ArmStick1', 'height');
Fingers1 = vrgetpar(file, 'Fingers1', 'translation');
Upper_text = vrgetpar(file, 'Upper_text', 'translation');
Pointer = vrgetpar(file, 'Pointer', 'translation');
x0 = [zeros(1,3) T1trans T2trans T3trans T4trans H1trans Wrist1 ArmStick1 Fingers1 Upper_text Pointer start stop proc];
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
H1trans = vrgetpar(file, 'Arm1', 'translation');
Wrist1 = vrgetpar(file, 'Wrist1', 'translation');
ArmStick1 = vrgetpar(file, 'ArmStick1', 'height');
Fingers1 = vrgetpar(file, 'Fingers1', 'translation');
Upper_text = vrgetpar(file, 'Upper_text', 'translation');
Pointer = vrgetpar(file, 'Pointer', 'translation');

%Do this every sample

if dt == 0
x(3) = Pointer(1);
end
pause(0.05)
Pointer(1) = Pointer(1) + 8.3/period;
if mod(dt, period) == 0 && dt>0
Pointer(1) = x(3);
end

%task 1
if isin(x(32),x(36),period,dt)
	
end
if isin(x(32)+-20,x(32)+0,period,dt) && ((mod(dt-rem(x(32),period),1) == 0) || period == inf)
	start = get_schedule(TS);
	treshold = start(1)-mod(dt,period)-period*rem(start(1),period);
	if H1trans(1) >= treshold && H1trans(1) > 0
	H1trans(1) = H1trans(1) - 1;
	w = vrworld('onehoist.wrl');
	open(w)
	node = vrnode(w,'Text1');
	str{1} = {'Empty hoist move'};
	setfield(node,'string', str{1}) 
	
	close(w)
	end
end
if isin(x(32)+0,x(32)+0,period,dt)
	w=vrworld('onehoist.wrl');
	open(w)
	node = vrnode(w,'Text1');
	str{1} = {'Transporting material to bath 1'};
	setfield(node,'string', str{1}) 
	
	close(w)
	x(1) = x(1)+1;
	w=vrworld('onehoist.wrl');
	open(w)
	node = vrnode(w,'Counter');
	str{1} = {num2str(max(0,5-x(1)))};
	setfield(node,'string', str{1}) 
	close(w)
end
if isin(x(32)+0,x(32)+4,period,dt) && ((mod(dt-rem(x(32),period),1) == 0) || period == inf)
	T1trans(1) = T1trans(1) + 1;
end
if isin(x(32)+0,x(32)+7,period,dt) && ((mod(dt-rem(x(32),period),1) == 0) || period == inf)
	Wrist1(2) = Wrist1(2) - 0.5;
	Fingers1(2) = Fingers1(2) - 0.5;
	ArmStick1 = ArmStick1 + 1;
end
if isin(x(32)+8,x(32)+15,period,dt) && ((mod(dt-rem(x(32),period),1) == 0) || period == inf)
	T1trans(2) = T1trans(2) + 1;
	Wrist1(2) = Wrist1(2) + 0.5;
	Fingers1(2) = Fingers1(2) + 0.5;
	ArmStick1 = ArmStick1 - 1;
end
if isin(x(32)+16,x(32)+20,period,dt) && ((mod(dt-rem(x(32),period),1) == 0) || period == inf)
	T1trans(1) = T1trans(1) + 1;
	H1trans(1) = H1trans(1) + 1;
end
if isin(x(32)+21,x(32)+28,period,dt) && ((mod(dt-rem(x(32),period),1) == 0) || period == inf)
	T1trans(2) = T1trans(2) - 1;
	Wrist1(2) = Wrist1(2) - 0.5;
	Fingers1(2) = Fingers1(2) - 0.5;
	ArmStick1 = ArmStick1 + 1;
end
if isin(x(32)+29,x(32)+36,period,dt) && ((mod(dt-rem(x(32),period),1) == 0) || period == inf)
	Wrist1(2) = Wrist1(2) + 0.5;
	Fingers1(2) = Fingers1(2) + 0.5;
	ArmStick1 = ArmStick1 - 1;
end
if isin(x(32)+29,x(32)+29,period,dt)
	T1trans(1) = -5;
end
if isin(x(32)+8,x(32)+8,period,dt)
	w=vrworld('onehoist.wrl');
	open(w)
	node = vrnode(w,'Text1');
	str{1} = {'Transporting material to bath 1'};
	setfield(node,'string', str{1}) 
	
	close(w)
end
%end of task 1

%task 2
if isin(x(33),x(37),period,dt)
	
end
if isin(x(33)+-15,x(33)+0,period,dt) && ((mod(dt-rem(x(33),period),1) == 0) || period == inf)
	start = get_schedule(TS);
	treshold = start(2)-mod(dt,period)-period*rem(start(2),period)-5;
	if abs(H1trans(1)-5) >= treshold
	w=vrworld('onehoist.wrl');
	open(w)
	node = vrnode(w,'Text1');
	str{1} = {'Empty hoist move'};
	setfield(node,'string', str{1}) 
	
	close(w)
	if H1trans(1) > 5
	H1trans(1) = H1trans(1) - 1;
	end
	if H1trans(1) < 5
	H1trans(1) = H1trans(1) + 1;
	end
	end
end
if isin(x(33)+0,x(33)+7,period,dt) && ((mod(dt-rem(x(33),period),1) == 0) || period == inf)
	Wrist1(2) = Wrist1(2) - 0.5;
	Fingers1(2) = Fingers1(2) - 0.5;
	ArmStick1 = ArmStick1 + 1;
end
if isin(x(33)+8,x(33)+15,period,dt) && ((mod(dt-rem(x(33),period),1) == 0) || period == inf)
	T2trans(2) = T2trans(2) + 1;
	Wrist1(2) = Wrist1(2) + 0.5;
	Fingers1(2) = Fingers1(2) + 0.5;
	ArmStick1 = ArmStick1 - 1;
end
if isin(x(33)+16,x(33)+20,period,dt) && ((mod(dt-rem(x(33),period),1) == 0) || period == inf)
	T2trans(1) = T2trans(1) + 1;
	H1trans(1) = H1trans(1) + 1;
end
if isin(x(33)+21,x(33)+28,period,dt) && ((mod(dt-rem(x(33),period),1) == 0) || period == inf)
	T2trans(2) = T2trans(2) - 1;
	Wrist1(2) = Wrist1(2) - 0.5;
	Fingers1(2) = Fingers1(2) - 0.5;
	ArmStick1 = ArmStick1 + 1;
end
if isin(x(33)+29,x(33)+36,period,dt) && ((mod(dt-rem(x(33),period),1) == 0) || period == inf)
	Wrist1(2) = Wrist1(2) + 0.5;
	Fingers1(2) = Fingers1(2) + 0.5;
	ArmStick1 = ArmStick1 - 1;
end
if isin(x(33)+29,x(33)+29,period,dt)
	T2trans(1) = 5;
end
if isin(x(33)+8,x(33)+8,period,dt)
	w=vrworld('onehoist.wrl');
	open(w)
	node = vrnode(w,'Text1');
	str{1} = {'Transporting material to bath 2'};
	setfield(node,'string', str{1}) 
	
	close(w)
end
%end of task 2

%task 3
if isin(x(34),x(38),period,dt)
	
end
if isin(x(34)+-10,x(34)+0,period,dt) && ((mod(dt-rem(x(34),period),1) == 0) || period == inf)
	start = get_schedule(TS);
	treshold = start(3)-mod(dt,period)-period*rem(start(3),period);
	if abs(H1trans(1)-10) >= treshold
	w=vrworld('onehoist.wrl');
	open(w)
	node = vrnode(w,'Text1');
	str{1} = {'Empty hoist move'};
	setfield(node,'string', str{1}) 
	
	close(w)
	if H1trans(1) > 10
	H1trans(1) = H1trans(1) - 1;
	end
	if H1trans(1) < 10
	H1trans(1) = H1trans(1) + 1;
	end
	end
end
if isin(x(34)+0,x(34)+7,period,dt) && ((mod(dt-rem(x(34),period),1) == 0) || period == inf)
	Wrist1(2) = Wrist1(2) - 0.5;
	Fingers1(2) = Fingers1(2) - 0.5;
	ArmStick1 = ArmStick1 + 1;
end
if isin(x(34)+8,x(34)+15,period,dt) && ((mod(dt-rem(x(34),period),1) == 0) || period == inf)
	T3trans(2) = T3trans(2) + 1;
	Wrist1(2) = Wrist1(2) + 0.5;
	Fingers1(2) = Fingers1(2) + 0.5;
	ArmStick1 = ArmStick1 - 1;
end
if isin(x(34)+16,x(34)+20,period,dt) && ((mod(dt-rem(x(34),period),1) == 0) || period == inf)
	T3trans(1) = T3trans(1) + 1;
	H1trans(1) = H1trans(1) + 1;
end
if isin(x(34)+21,x(34)+28,period,dt) && ((mod(dt-rem(x(34),period),1) == 0) || period == inf)
	T3trans(2) = T3trans(2) - 1;
	Wrist1(2) = Wrist1(2) - 0.5;
	Fingers1(2) = Fingers1(2) - 0.5;
	ArmStick1 = ArmStick1 + 1;
end
if isin(x(34)+29,x(34)+36,period,dt) && ((mod(dt-rem(x(34),period),1) == 0) || period == inf)
	Wrist1(2) = Wrist1(2) + 0.5;
	Fingers1(2) = Fingers1(2) + 0.5;
	ArmStick1 = ArmStick1 - 1;
end
if isin(x(34)+29,x(34)+29,period,dt)
	T3trans(1) = 10;
end
if isin(x(34)+8,x(34)+8,period,dt)
	w=vrworld('onehoist.wrl');
	open(w)
	node = vrnode(w,'Text1');
	str{1} = {'Transporting material to bath 3'};
	setfield(node,'string', str{1}) 
	
	close(w)
end
%end of task 3

%task 4
if isin(x(35),x(39),period,dt)
	
end
if isin(x(35)+-15,x(35)+0,period,dt) && ((mod(dt-rem(x(35),period),1) == 0) || period == inf)
	start = get_schedule(TS);
	treshold = start(4)-mod(dt,period)-period*rem(start(4),period);
	if H1trans(1) >= treshold && H1trans(1) < 15
	H1trans(1) = H1trans(1) + 1;
	w=vrworld('onehoist.wrl');
	open(w)
	node = vrnode(w,'Text1');
	str{1} = {'Empty hoist move'};
	setfield(node,'string', str{1}) 
	
	close(w)
	end
end
if isin(x(35)+0,x(35)+7,period,dt) && ((mod(dt-rem(x(35),period),1) == 0) || period == inf)
	Wrist1(2) = Wrist1(2) - 0.5;
	Fingers1(2) = Fingers1(2) - 0.5;
	ArmStick1 = ArmStick1 + 1;
end
if isin(x(35)+8,x(35)+15,period,dt) && ((mod(dt-rem(x(35),period),1) == 0) || period == inf)
	T4trans(2) = T4trans(2) + 1;
	Wrist1(2) = Wrist1(2) + 0.5;
	Fingers1(2) = Fingers1(2) + 0.5;
	ArmStick1 = ArmStick1 - 1;
end
if isin(x(35)+16,x(35)+30,period,dt) && ((mod(dt-rem(x(35),period),1) == 0) || period == inf)
	T4trans(1) = T4trans(1) - 1;
	H1trans(1) = H1trans(1) - 1;
end
if isin(x(35)+30,x(35)+37,period,dt) && ((mod(dt-rem(x(35),period),1) == 0) || period == inf)
	T4trans(2) = T4trans(2) - 1;
	Wrist1(2) = Wrist1(2) - 0.5;
	Fingers1(2) = Fingers1(2) - 0.5;
	ArmStick1 = ArmStick1 + 1;
end
if isin(x(35)+38,x(35)+45,period,dt) && ((mod(dt-rem(x(35),period),1) == 0) || period == inf)
	Wrist1(2) = Wrist1(2) + 0.5;
	Fingers1(2) = Fingers1(2) + 0.5;
	ArmStick1 = ArmStick1 - 1;
end
if isin(x(35)+45,x(35)+49,period,dt) && ((mod(dt-rem(x(35),period),1) == 0) || period == inf)
	T4trans(1) = T4trans(1) - 1;
end
if isin(x(35)+49,x(35)+49,period,dt)
	x(2) = x(2)+1;
end
if isin(x(35)+50,x(35)+50,period,dt)
	T4trans(1) = 15;
	w=vrworld('onehoist.wrl');
	open(w)
	node = vrnode(w,'Counter2');
	str{1} = {num2str(x(2))};
	setfield(node,'string', str{1}) 
	close(w)
end
if isin(x(35)+8,x(35)+8,period,dt)
	w=vrworld('onehoist.wrl');
	open(w)
	node = vrnode(w,'Text1');
	str{1} = {'Transporting material to buffer'};
	setfield(node,'string', str{1}) 
	
	close(w)
end
%end of task 4

sys = [x(1:3)' T1trans T2trans T3trans T4trans H1trans Wrist1 ArmStick1 Fingers1 Upper_text Pointer x(32:end)'];

%%
%Update discrete outputs
function sys=mdlOutputs(x)

sys = x(4:31);

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
