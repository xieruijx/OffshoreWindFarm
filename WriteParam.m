% WriteParam.m
% 写参数文件ParamLoad.txt、ParamOther.txt、ParamWindGen.txt、ParamWindBus.txt、ParamLine.txt、ParamGen.txt
Num_T = 48;
Num_W = 6;
mpc = loadcase('case30pwl.m'); % MATPOWER中IEEE 30节点算例文件

%% ParamLoad 负荷功率矩阵P_D，行表示全部节点，列表示全部时刻
PD = mpc.bus(:, 3) / mpc.baseMVA;
%P_D = [1.5 * PD, 2 * PD * linspace(0.9, 1.1, Num_T - 1)]; 
P_D = PD * linspace(1.5, 2.2, Num_T);
writematrix(P_D, 'ParamLoad.txt');

%% ParamOther 行向量，依次为风电利用率下限lambda、足够大的正数M_P、正整数M_L、总额外下调峰上限P_GSdt、总额外下调峰上限P_GSut、断面总注入功率下限P_Flt、断面总注入功率上限P_Fut
O = [0.95, 10, 2, 1, 1, -0.15, 0.15];
writematrix(O, 'ParamOther.txt');

%% ParamWindGen 最大风电功率矩阵P_W，行表示全部风电场，列表示全部时刻
load('Wind_Test.mat', 'Wind_Test');
P_W = Wind_Test(1: Num_W, 1: Num_T) * 2;
writematrix(P_W, 'ParamWindGen.txt');

%% ParamWindBus 风电候选接入点成本矩阵C_W，行表示全部节点，列表示全部风电场，-1表示风电场不能接入该节点，非负数表示风电场接入该节点的成本
C_W = - ones(30, Num_W);
C_W(1, 1) = 1; C_W(2, 1) = 1;
C_W(4, 2) = 2;
C_W(5, 3) = 1; C_W(6, 3) = 1;
C_W(10, 4) = 2;
C_W(12, 5) = 1;
C_W(25, 6) = 1; C_W(26, 6) = 1; C_W(27, 6) = 1;
writematrix(C_W, 'ParamWindBus.txt');

%% ParamLine 线路参数矩阵，行表示全部线路，列依次为开始节点、结束节点、一回电抗X_L、一回容量S_L、已有回数N_L、新增一回成本C_L、新增回数下限N_Ll、新增回数上限N_Lu
L_B = [mpc.branch(:, 1: 2);
    1, 8;
    2, 10;
    5, 17];
X_L = [mpc.branch(:, 4);
    mpc.branch(1: 3, 4)];
S_L = [mpc.branch(:, 6);
    mpc.branch(1: 3, 6)] / mpc.baseMVA;
[Num_L, ~] = size(L_B);
N_L = [ones(Num_L - 3, 1); 0; 0; 0];
C_L = 1 * ones(Num_L, 1);
N_Ll = zeros(Num_L, 1);
N_Lu = 3 * ones(Num_L, 1);
Param_Line = [L_B, X_L, S_L, N_L, C_L, N_Ll, N_Lu];
writematrix(Param_Line, 'ParamLine.txt');

%% ParamGen 可调机组参数矩阵，行表示全部可调机组，列依次为接入节点、发电功率下限P_Gl、发电功率上限P_Gu、额外下调峰上限P_GSd、额外上调峰上限P_GSu、增加下调峰能力的单位成本C_GSd、增加上调峰能力的单位成本C_GSu
G_B = [mpc.gen(:, 1)];
Num_G = length(G_B);
P_Gu = [mpc.gen(:, 9)] / mpc.baseMVA;
P_Gl = 0.4 * P_Gu;
P_GSd = 0.4 * P_Gu;
P_GSu = 0.3 * P_Gu;
C_GSd = 0.1 * ones(Num_G, 1);
C_GSu = 0.1 * ones(Num_G, 1);
Param_Gen = [G_B, P_Gl, P_Gu, P_GSd, P_GSu, C_GSd, C_GSu];
writematrix(Param_Gen, 'ParamGen.txt');

%% ParamFracture 断面参数矩阵，行表示全部断面，列依次为接入节点、注入功率下限P_Fl、注入功率上限P_Fu
%writematrix([1, -0.1, 0.1; 6, 0, 0.2], 'ParamFracture.txt');
% writematrix([1, 0, 0; 6, 0.1, 0.1], 'ParamFracture.txt');
writematrix([], 'ParamFracture.txt');
