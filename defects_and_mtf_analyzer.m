% AIT Optical Defect & Performance Analyzer
% Análisis de defectos superficiales y degradación de MTF en cargas útiles.
clear; clc; close all;

%% 1. Parámetros del Sistema Óptico 
D_aperture = 150; % Diámetro de la apertura libre en mm (Ej. telescopio LEO)
A_total = pi * (D_aperture/2)^2; % Área total en mm^2

%% 2. Ingreso de Datos de Defectos (Rayaduras, Puntadas/Digs, Suciedad)
% Formato: [Pos_X, Pos_Y, Area_mm2, Tipo(1=Ray, 2=Punt, 3=Suc), Modo(1=Transm, 2=Reflex)]
defectos = [
    12,  5,   0.05, 1, 2;
   -30, 20,   0.15, 2, 1;
    45, -10,  0.02, 3, 2;
    5,  -40,  0.08, 1, 1;
   -10, -15,  0.25, 2, 2
];

tipos = {'Rayadura', 'Puntada', 'Suciedad'};
modos = {'Transmisión', 'Reflexión'};

%% 3. Análisis y Clasificación de Defectos
area_oscurecida_total = 0;

figure('Name', 'AIT - Inspección de Filtros y Ópticas', 'Color', 'w', 'Position', [100 100 900 400]);

% --- Subplot 1: Mapa de Defectos ---
subplot(1,2,1); hold on; grid on; axis equal;
% Dibujar el límite de la apertura óptica
theta = linspace(0, 2*pi, 100);
plot((D_aperture/2)*cos(theta), (D_aperture/2)*sin(theta), 'k--', 'LineWidth', 1.5);

fprintf('--- REPORTE DE INSPECCIÓN ÓPTICA ---\n');
for i = 1:size(defectos, 1)
    x = defectos(i,1); y = defectos(i,2);
    area = defectos(i,3); tipo = defectos(i,4); modo = defectos(i,5);
    
    area_oscurecida_total = area_oscurecida_total + area;
    
    % Graficar según el modo de inspección
    if modo == 1
        % Transmisión: Marcadores rojos
        plot(x, y, 'ro', 'MarkerSize', area*40 + 2, 'LineWidth', 1.5); 
    else
        % Reflexión: Marcadores azules
        plot(x, y, 'bx', 'MarkerSize', area*40 + 2, 'LineWidth', 1.5); 
    end
    
    fprintf('Defecto %d: %s en %s | Área: %.2f mm^2 | Pos: (%.1f, %.1f)\n', ...
        i, tipos{tipo}, modos{modo}, area, x, y);
end

title('Mapa de Defectos en Apertura');
xlabel('X (mm)'); ylabel('Y (mm)');
xlim([-D_aperture/2-10, D_aperture/2+10]); ylim([-D_aperture/2-10, D_aperture/2+10]);
% Leyenda manual para claridad
plot(NaN, NaN, 'k--', 'DisplayName', 'Límite Óptico');
plot(NaN, NaN, 'ro', 'DisplayName', 'Transmisión (Incidencia)');
plot(NaN, NaN, 'bx', 'DisplayName', 'Reflexión');
legend('show', 'Location', 'bestout');

%% 4. Análisis de Rendimiento Óptico (Impacto en MTF)
obscuration_ratio = area_oscurecida_total / A_total;
fprintf('\nÁrea total oscurecida: %.4f mm^2 (%.4e %% del total)\n', area_oscurecida_total, obscuration_ratio*100);

% Frecuencias espaciales normalizadas
nu = linspace(0, 1, 100);

% MTF ideal (Difracción limitada)
MTF_ideal = (2/pi) * (acos(nu) - nu .* sqrt(1 - nu.^2));
MTF_ideal(nu >= 1) = 0;

% MTF degradada (Aproximación por pérdida de contraste debido a defectos)
% Multiplicador exagerado (x1000) para poder visualizar el impacto de micro-defectos
MTF_degradada = MTF_ideal .* (1 - obscuration_ratio*1000); 
MTF_degradada = max(MTF_degradada, 0);

% --- Subplot 2: Modulación Transfer Function ---
subplot(1,2,2);
plot(nu, MTF_ideal, 'k--', 'LineWidth', 2); hold on;
plot(nu, MTF_degradada, 'r', 'LineWidth', 2);
grid on;
title('Impacto en Contraste (MTF)');
xlabel('Frecuencia Espacial Normalizada');
ylabel('Contraste (MTF)');
legend('MTF Ideal', 'MTF con Defectos', 'Location', 'northeast');