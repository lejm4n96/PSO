clear all
close all 
clc
delete saves\*.mat

%Details der Zielfunktion
problem.nVar = 2; %Anzahl der Variablen
problem.ub = [50,50]; %obere Grenze
problem.lb = [-50,-50]; %untere Grenze
problem.fobj = @ObjectiveFunction;

%Definition der PSO´s Parameter
noP = 4;
maxIter = 500;

%PSO wird beendet, wenn nach n Iterationen keine Verbesserung des GBEST gefunden wurde 
counterEndVal =  50;

%zeigen der Visualisierung
visFlag = 1;

RunNo = 1; %Anzahl der Durchläufe
BestSolutions = zeros(1, RunNo);

for k = [1:1:RunNo]
    disp(['Run#',num2str(k)]);
    [GBEST] = PSO(noP, maxIter, problem, visFlag, counterEndVal);
    BestSolutions(k) = GBEST.O;
end


%Berechnung des Durchschnitts der besten Lösung 
average_results = mean(BestSolutions);
%Berechnung der Standardabweichnung
std_results = std(BestSolutions);

%fprintf('Der Durchschnitt der besten Lösung beträgt: %d\n', average_results);
%fprintf('Die Standardabweichung beträgt: %d', std_results);

GBESTTable = struct2table(GBEST);
disp(GBESTTable)


