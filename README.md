# Optical Defect Analyzer

Herramienta de análisis y certificación de filtros y componentes ópticos.

Este script procesa datos de inspección visual (rayaduras, puntadas, suciedad) detectados mediante iluminación por transmisión (incidencia) o reflexión. 

## Funciones Principales
1. **Mapeo Espacial:** Grafica la distribución de los defectos sobre la apertura libre del componente óptico, clasificándolos visualmente según su método de inspección.
2. **Cálculo de Oscurecimiento:** Integra el área total afectada frente al área libre de la pupila.
3. **Análisis de Impacto (MTF):** Proyecta la degradación teórica de la Función de Transferencia de Modulación (MTF), estimando la pérdida de contraste generada por la dispersión de luz de los defectos.

## Uso
Modifique la matriz `defectos` en `defects_and_mtf_analyzer.m` con las coordenadas, área, tipo y modo de inspección de los hallazgos de laboratorio, y ejecute el script para generar el reporte en la consola de MATLAB y los gráficos de rendimiento.
