%%
% Computer Methods in Human Motion Analysis 2017 -- HW6
% Matlab Version: MATLAB R2017a
% Student: ����Ӥ@ ���µ� R05522625

addpath(genpath(fileparts(cd))) % adding all hw directory to PATH.

%% Initialization
clc;
clearvars;
close all;

%% Practice 1
disp('[Practice 1]') 
%% (i)
load('DataQ1.mat')
[rRg2p, rVg2p, ~] = CoordPelvis(cat(3, LASI, RPSI, RASI), 'r', {'LASI', 'RPSI', 'RASI'});
[rRg2t, rVg2t, ~] = CoordThigh(cat(3, RTRO, RMFC, RLFC), 'r', {'RTRO', 'RMFC', 'RLFC'});
[rRg2s, rVg2s, ~] = CoordShank(cat(3, RTT, RSHA, RLMA, RMMA), 'r', {'RTT', 'RSHA', 'RLMA', 'RMMA'});
nf = size(LASI,1);
rRp2t = mtimesx(rRg2p, 'T', rRg2t); rRt2p = mtimesx(rRg2t, 'T', rRg2p);
rRt2s = mtimesx(rRg2t, 'T', rRg2s); rRs2t = mtimesx(rRg2s, 'T', rRg2t);
rVp2t = rVg2t - rVg2p; rVt2p = rVg2p - rVg2t;
rVt2s = rVg2s - rVg2t; rVs2t = rVg2t - rVg2s;
Rtarget = rRt2s; Vtarget = rVt2s;
disp('(i)   Done')

%% (ii)
[ phi, n, t, s ] = RV2Screw( Rtarget, Vtarget);
nDOTs = bsxfun(@dot, n, s);
if ~isempty(nDOTs(nDOTs<10^-10))
    disp('(ii)  n is perpendicular to s')
else
    disp('(ii)  n isn''t perpendicular to s')
end

%% (iii)
[ Uphi, Un, Ut, Us ] = RV2Screw( Rtarget, Vtarget, 0);
% a=Uphi-phi;
% a(a>10^-8)
[ Ruwp, Vuwp ] = Screw2RV( phi, n, t, s );
[ RuwpU, VuwpU ] = Screw2RV( Uphi, Un, Ut, Us );
vecR = Ruwp-RuwpU; vecV = Vuwp-VuwpU;
if ~isempty(vecR(vecR<10^-10)) && ~isempty(vecV(vecV<10^-10))
    disp('(iii) R & V with or without unwrap are the same!')
else
    disp('(iii) R & V with and without unwrap aren''t the same!')
end

%% (iv)
vec = mtimesx(rRt2s, permute(n, [2 3 1])) - mtimesx(rRs2t, permute(n, [2 3 1]));
if ~isempty(vec(vec<10^-10))
    disp('(iv)  R_{t2s}n = R_{s2t}n')
else
    disp('(iv)  R_{t2s}n != R_{s2t}n')
end

%% (v)
[ PEP, phiEP, nEP ] = Rot2EulerP( Rtarget );
PlotData = cat(3, [n, phi], [nEP, phiEP]);
artiname = {'n_x','n_y','n_z','\phi'};
figure('Name','Comparison of n and \phi generated by Euler Parameters and Screw Axis.', 'NumberTitle','off','position',[100 50 600 700]);
hold on
for i = 1:4
    eval(['ax',num2str(i)]) = subplot(4,1,i);
    hold on
    title(artiname(i))
    a = plot( 1:nf, PlotData(:,i,1), 'k--');
    b = plot( 1:nf, PlotData(:,i,2), 'm');
    if i == 4
        ylabel('Degree')
    end
    xlabel('frames')
    xlim([0 nf])
    if i == 1
        Leg = legend([a; b], {'Screw Axis', 'Euler Parameter'});
        Pos = get(Leg, 'Position');
        set(Leg, 'Position', [Pos(1)+0.05, Pos(2)+0.05, Pos(3), Pos(4)])
    end
end
disp('(v)   Fig. 1 is plotted.')
disp(' ')

%% Practice 2
disp('[Practice 2]') 
HAtest
disp('HAtest done')
disp(' ')
%% Practice 3
%% (1)
clearvars
disp('[Practice 3]') 
load('HipROM.mat')
[lRg2p, ~, ~] = CoordPelvis(cat(3, LASI, LPSI, RASI), 'l', {'LASI', 'LPSI', 'RASI'});
[lRg2t, ~, ~] = CoordThigh(cat(3, LLFC, LTRO, LMFC), 'l', {'LLFC', 'LTRO', 'LMFC'});
lRp2t = mtimesx(lRg2p, 'T', lRg2t); 
Anglp2t = RotAngConvert( lRp2t, 'zxy' );
disp('(1) hip F/E: '+string(range(Anglp2t(:,1)))+', Abd/Add: '+string(range(Anglp2t(:,2)))+', IR/ER: '+string(range(Anglp2t(:,3)))+' (deg)')

%% (2)
load('KneeFE.mat')
[lRg2t, ~, ~] = CoordThigh(cat(3, LLFC, LTRO, LMFC), 'l', {'LLFC', 'LTRO', 'LMFC'});
[lRg2s, ~, ~] = CoordShank(cat(3, LTT, LLMA, LMMA, LSHA), 'l', {'LTT', 'LLMA', 'LMMA', 'LSHA'});
lRt2s = mtimesx(lRg2t, 'T', lRg2s); 
Anglt2s = RotAngConvert( lRt2s, 'zxy' );
disp('(2) knee F/E: '+string(range(Anglt2s(:,1)))+' (deg)')

%% (3)
disp('(3)')
% Method of Circumcenter & Intersection Point Fitting
hw6prac3p3Circumcenter

% Method of Sphere Fitting
hw6prac3p3SphereFit

%% (4)
load('KneeFE.mat')
[lRg2t, lVg2t, ~] = CoordThigh(cat(3, LLFC, LTRO, LMFC), 'l', {'LLFC', 'LTRO', 'LMFC'});
[lRg2s, lVg2s, ~] = CoordShank(cat(3, LTT, LLMA, LMMA, LSHA), 'l', {'LTT', 'LLMA', 'LMMA', 'LSHA'});
lRt2s = mtimesx(lRg2t, 'T', lRg2s); 
lRs2t = mtimesx(lRg2s, 'T', lRg2t);
[ phi, n, t, s ] = RV2Screw(lRs2t, lVg2s, 1);
[ o, E, v ] = HelicalAxesCenter( n, CoordG2L( lRg2s, lVg2s, LLFC ) );
disp('(4) principal axis of left knee F/E is [ '+string(v(1))+', '+string(v(2))+', '+string(v(3))+' ].')