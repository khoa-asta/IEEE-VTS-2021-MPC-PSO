%% IEEE VTS Motor Vehicles Challenge 2021
% Energy Management of A Dual-Motor All-Wheel Drive Electric Vehicle

% Bao-Huy Nguyen 
% Université de Sherbrooke, QC, Canada

% Results

% Do NOT change anything in this file

close all

%% Global results

Penalty_EDf = (EDf_lim_violation(end)>0);
Penalty_EDr = (EDr_lim_violation(end)>0);
Penalty_T_cell = (T_cell_lim_violation(end)>0);

disp(['Global point: ' num2str(SoC(end)-Penalty_EDf*10-Penalty_EDr*10-Penalty_T_cell*10,'%.2f')]);
disp(['Final battery SoC: ' num2str(SoC(end), '%.2f') '%']);
if Penalty_EDf == 0
    disp('The front axle drive torque constraint is respected')
else
    disp('The front axle drive torque constraint is NOT respected')
end
if Penalty_EDr == 0
    disp('The rear axle drive torque constraint is respected')
else
    disp('The rear axle drive torque constraint is NOT respected')
end
if Penalty_T_cell == 0
    disp('The cell temperature constraint is respected')
else
    disp('The cell temperature constraint is NOT respected')
end

%% Driving cycle

% Vehicle speed
figure;hold on;
plot(time, v_veh, 'b-', 'LineWidth',1);
plot(time, v_veh_ref, 'k--', 'LineWidth',1);
hold off;xlabel('Time [s]');xlim([0 time(end)]);
title('Vehicle speed [km/h]');set(gca,'FontName','Times New Roman');
grid on;ax = gca;ax.GridLineStyle = ':';ax.GridColor = 'k';
ax.GridAlpha = 1;ax.XColor = 'k';ax.YColor = 'k';box on;
legend({'\it{v}_{\rm{veh}}','\it{v}_{\rm{veh ref}}'},'Location','Best');

% Vehicle speed
figure;hold on;
plot(time, Distance, 'b-', 'LineWidth',1);
hold off;xlabel('Time [s]');xlim([0 time(end)]);
title('Distance [km]');set(gca,'FontName','Times New Roman');
grid on;ax = gca;ax.GridLineStyle = ':';ax.GridColor = 'k';
ax.GridAlpha = 1;ax.XColor = 'k';ax.YColor = 'k';box on;
legend({'\it{s}_{\rm{veh}}'},'Location','Best');

%% Battery

% Battery SoC
figure;hold on;
plot(time, SoC, 'b-', 'LineWidth',1);
hold off;xlabel('Time [s]');xlim([0 time(end)]);
title('Battery SoC [%]');set(gca,'FontName','Times New Roman');
grid on;ax = gca;ax.GridLineStyle = ':';ax.GridColor = 'k';
ax.GridAlpha = 1;ax.XColor = 'k';ax.YColor = 'k';box on;
legend({'\it{SoC}_{\rm{bat}}'},'Location','Best');

% Battery temperature
figure;hold on;
plot(time, T_cell, 'b-', 'LineWidth',1);
plot(time, ones(length(time))*(BAT.T_cell_max-273.15),'k--','LineWidth',1);
hold off;xlabel('Time [s]');xlim([0 time(end)]);
title('Battery cell temperature [^oC]');set(gca,'FontName','Times New Roman');
grid on;ax = gca;ax.GridLineStyle = ':';ax.GridColor = 'k';
ax.GridAlpha = 1;ax.XColor = 'k';ax.YColor = 'k';box on;
legend({'\it{T}_{\rm{cell}}', '\it{T}_{\rm{cell max}}'},'Location','Best');

% Battery current
figure;hold on;
plot(time, i_bat, 'b-', 'LineWidth',1);
hold off;xlabel('Time [s]');xlim([0 time(end)]);
title('Battery current [A]');set(gca,'FontName','Times New Roman');
grid on;ax = gca;ax.GridLineStyle = ':';ax.GridColor = 'k';
ax.GridAlpha = 1;ax.XColor = 'k';ax.YColor = 'k';box on;
legend({'\it{i}_{\rm{bat}}'},'Location','Best');

% Battery voltage
figure;hold on;
plot(time, u_bat, 'b-', 'LineWidth',1);
hold off;xlabel('Time [s]');xlim([0 time(end)]);
title('Battery voltage [V]');set(gca,'FontName','Times New Roman');
grid on;ax = gca;ax.GridLineStyle = ':';ax.GridColor = 'k';
ax.GridAlpha = 1;ax.XColor = 'k';ax.YColor = 'k';box on;
legend({'\it{u}_{\rm{bat}}'},'Location','Best');

%% Force distribution

% Front-rear force distribution
figure;hold on;
plot(time, F_trac, 'k--', 'LineWidth',1);
plot(time, F_f, 'b-', 'LineWidth',1);
plot(time, F_r, 'r-.', 'LineWidth',1);
hold off;xlabel('Time [s]');xlim([0 time(end)]);
title('Front-rear force distribution [N]');set(gca,'FontName','Times New Roman');
grid on;ax = gca;ax.GridLineStyle = ':';ax.GridColor = 'k';
ax.GridAlpha = 1;ax.XColor = 'k';ax.YColor = 'k';box on;
legend({'Traction force \it{F}_{\rm{trac}}',...
    'Front axle force \it{F}_{\rm{f}}',...
    'Rear axle force \it{F}_{\rm{r}}'},'Location','Best');

% Front axle braking force distribution
figure;hold on;
plot(time, F_f, 'k--', 'LineWidth',1);
plot(time, F_Tf, 'b-', 'LineWidth',1);
plot(time, F_brf, 'r-.', 'LineWidth',1);
hold off;xlabel('Time [s]');xlim([0 time(end)]);
title('Front axle braking force distribution [N]');set(gca,'FontName','Times New Roman');
grid on;ax = gca;ax.GridLineStyle = ':';ax.GridColor = 'k';
ax.GridAlpha = 1;ax.XColor = 'k';ax.YColor = 'k';box on;
legend({'Front axle force \it{F}_{\rm{f}}',...
    'Front drive force \it{F}_{\rm{Tf}}',...
    'Front mechanical braking force \it{F}_{\rm{brf}}'},'Location','Best');

% Rear axle braking force distribution
figure;hold on;
plot(time, F_r, 'k--', 'LineWidth',1);
plot(time, F_Tr, 'b-', 'LineWidth',1);
plot(time, F_brr, 'r-.', 'LineWidth',1);
hold off;xlabel('Time [s]');xlim([0 time(end)]);
title('Rear axle braking force distribution [N]');set(gca,'FontName','Times New Roman');
grid on;ax = gca;ax.GridLineStyle = ':';ax.GridColor = 'k';
ax.GridAlpha = 1;ax.XColor = 'k';ax.YColor = 'k';box on;
legend({'Rear axle force \it{F}_{\rm{r}}',...
    'Rear drive force \it{F}_{\rm{Tr}}',...
    'Rear mechanical braking force \it{F}_{\rm{brr}}'},'Location','Best');

%% Electrical drives 

% Front electrical drive efficiency map
figure;hold on;
contour(EM1.Speed*30/pi,EM1.Torque,EM1.Eff*100,'linewidth',1,'ShowText','on');
h1 = plot(EM1.Speed*30/pi,EM1.T_trac_max,'k-.','linewidth',1.5);
plot(EM1.Speed*30/pi,EM1.T_gen_max,'k-.','linewidth',1.5);
plot(W_EDf, T_EDf_ref,'bo','linewidth',0.5);
hold off;xlabel('Speed [rpm]');ylabel('Torque [Nm]');ylim([-210 200]);
title('Front electrical drive efficiency map [%]');
set(gca,'FontName','Times New Roman');
grid on;ax = gca;ax.GridLineStyle = ':';ax.GridColor = 'k';
ax.GridAlpha = 1;ax.XColor = 'k';ax.YColor = 'k';box on;
legend(h1, {'\Gamma_{\rm{EDf lim}}'},'Location','Best');

% Front electrical drive torque
figure;hold on;
plot(time, T_EDf, 'b-', 'LineWidth',1);
plot(time, T_EDf_ref, 'k--', 'LineWidth',1);
plot(time, T_EDf_trac_max,'k-.','LineWidth',1);
plot(time, T_EDf_gen_max,'k-.','LineWidth',1);
hold off;xlabel('Time [s]');xlim([0 time(end)]);ylim([-210 200]);
title('Front electrical drive torque [Nm]');set(gca,'FontName','Times New Roman');
grid on;ax = gca;ax.GridLineStyle = ':';ax.GridColor = 'k';
ax.GridAlpha = 1;ax.XColor = 'k';ax.YColor = 'k';box on;
legend({'\it{\Gamma}_{\rm{EDf}}','\it{\Gamma}_{\rm{EDf ref}}',...
    '\it{\Gamma}_{\rm{EDf lim}}'},'Location','Best');

% Rear electrical drive efficiency map
figure;hold on;
contour(EM2.Speed*30/pi,EM2.Torque,EM2.Eff*100,'linewidth',1,'ShowText','on');
h1 = plot(EM2.Speed*30/pi,EM2.T_trac_max,'k-.','linewidth',1.5);
plot(EM2.Speed*30/pi,EM2.T_gen_max,'k-.','linewidth',1.5);
plot(W_EDr,T_EDr_ref,'bo','linewidth',0.5);
hold off;xlabel('Speed [rpm]');ylabel('Torque [Nm]');ylim([-150 210]);
title('Rear electrical drive efficiency map [%]');
set(gca,'FontName','Times New Roman');
grid on;ax = gca;ax.GridLineStyle = ':';ax.GridColor = 'k';
ax.GridAlpha = 1;ax.XColor = 'k';ax.YColor = 'k';box on;
legend(h1, {'\Gamma_{\rm{EDr lim}}'},'Location','Best');

% Rear electrical drive torque
figure;hold on;
plot(time, T_EDr, 'b-', 'LineWidth',1);
plot(time, T_EDr_ref, 'k--', 'LineWidth',1);
plot(time, T_EDr_trac_max,'k-.','LineWidth',1);
plot(time, T_EDr_gen_max,'k-.','LineWidth',1);
hold off;xlabel('Time [s]');xlim([0 time(end)]);ylim([-150 210]);
title('Rear electrical drive torque [Nm]');set(gca,'FontName','Times New Roman');
grid on;ax = gca;ax.GridLineStyle = ':';ax.GridColor = 'k';
ax.GridAlpha = 1;ax.XColor = 'k';ax.YColor = 'k';box on;
legend({'\it{\Gamma}_{\rm{EDr}}','\it{\Gamma}_{\rm{EDr ref}}',...
    '\it{\Gamma}_{\rm{EDr lim}}'},'Location','Best');