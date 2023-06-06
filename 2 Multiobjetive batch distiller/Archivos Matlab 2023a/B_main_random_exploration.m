clear all;clc;close all

%% Importing Code
addpath("SRC\Prop_and_Transfer_Heat_Mass\")
addpath("SRC\Data\")
addpath("SRC\auxiliar_files\NSGAcode\")
addpath("SRC\auxiliar_files\")

%% initial condition vector - Simulink integrator
load_initial_conditions()

%% Random exploration (MANUAL)
n = 9;                               % Time element discretization of coolant flow
nn = 100;                            % Number of samples (100 = 25 seg ;  1000 = 219 seg)

Fr_min = 10*ones(nn,n); Fr_max = 500*ones(nn,n); % Fr bound for scaling
Fr_matrix = lhsdesign(nn,n).*(Fr_max-Fr_min)+Fr_min; rng('default') ;  % Latin Hyper Cube combination samples
        

graf = 0; alpha = 0.5;  % dont change

% Run the combinations
tic()
parfor i=1:nn
    [J, out2] = fun_sintetica(Fr_matrix(i,:),x0_ini,x_range,x_ss,a,b,graf,i,alpha);
    Water_random(i,1)  = out2(1);
    GL_ac_random(i,1)  = out2(2);
end
toc()

% Sort the non-dominat solutions (pareto)
[A,a]=prtp2([-GL_ac_random,Water_random]);
Pareto_actual = [-A(:,1),A(:,2)]';

%% Plotting
V_ideal = 2.3879;      % V acumulado mínimo
GL_ac_ideal = 89.0228; % GL acumulado máximo

% Previus saved result of non-dominat solution (extract form random exploration 7000 samples)
Pareto_saved =[88.3564458181918	88.1630362572039	87.7279240913345	87.5526042668899	87.3706508290284	87.2359042967675	87.0943056697062	87.0605561236194	86.8667817026954	86.0129239312559	85.9480660219609	85.8084023475220	85.7312950988916	85.6426198918785	85.6315688210996	85.4964295095049	85.4495675205521	85.1208741901518	85.1195514827966	85.0916954359988	85.0525265649408	84.9126555174213	84.4407516106938	84.3122991010993	84.2310299567143	83.9811066670708	83.8559215163247	83.8244543372540	83.8165703328513	82.4178463887986	82.2555589052004	82.1890041619674	82.0203261921151	81.9051732965908	81.7370219927511	79.5896649787553	79.4822432552954	79.3457785909967	79.1273648699115	78.4463992061034	78.2736308239156	78.2033915640076	78.1418303183984	77.8089535449538	77.7428276971408	77.5346622471709	77.3912856836243	77.0377741166042	77.0149999377043	77.0002393781685	75.8404698426203	75.4905984775299	75.1584453873566	75.0190694783537	73.8012469908731	73.3803423699251	72.8926645194269	70.6891757802552	70.6138095543907	70.0275313733951	67.4546459131172	67.3754536808093
                90.1249176377039	87.2671604648184	83.1399954443284	82.0294823028371	81.1849408885312	80.7250862362122	78.9485720496348	78.4555629233433	78.4344847447888	72.5085736584177	72.0768382596585	71.5888114706850	71.1993046483812	71.1145014512985	70.4547815904495	70.4269736786290	69.6706916962110	69.6631006972657	68.8378842595921	68.3442619361662	67.9779710518524	67.7799966093172	65.6545267175666	64.6924540957256	64.0293929606291	63.6698853811757	63.3814109275622	63.3199623151058	63.0905533937669	57.3874092638629	57.2560774987857	56.1802705922811	56.0018176608963	55.5765630979699	55.1092543658929	47.3633872574823	47.0962653692447	46.5216391632477	46.0043289303093	43.3541014336562	43.0762934022463	42.9689762883947	42.2763607251611	41.8304919202332	41.4102034764584	40.7107962558435	40.3036434106080	39.8307778183474	39.7297616464319	39.4400992717543	36.5744283255401	34.4436522157593	33.8803804180598	33.5127122004779	31.1935188917485	28.4884856325900	26.5784141035037	24.7397618768426	21.3190191774724	20.9696074158655	20.4953282744558	13.4748115912153];               ;

figure(1)
%1. Plot current random search results
plot(GL_ac_random,Water_random,'.r','MarkerSize',10); hold on

%2. Plot current random search results
plot(Pareto_actual(1,:),Pareto_actual(2,:),'ob','MarkerSize',12); hold on

% 3. Plot saved non-dominat solution (reference)
plot(Pareto_saved(1,:),Pareto_saved(2,:),'.b','MarkerSize',6)

legend("Random Exploration","Pareto Set","Pareto Set (reference)")
xlabel('% Water consumption');ylabel('% Ethanol distillate')
title('Pareto Front');grid on
set(gcf,'color','white')
    